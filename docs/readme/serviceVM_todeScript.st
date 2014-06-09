[ :topez :objIn :tokens :command :commandNode | 
| opts args cmd |
"for help: ./serviceVM -h"
cmd := command command.
command
  getOptsMixedLongShort:
    {#('help' $h #'none').
    #('register' nil #'none').
    #('force' nil #'none').
    #('start' nil #'none').
    #('status' nil #'none').
    #('stop' nil #'none').
    #('restart' nil #'none')}
  optionsAndArguments: [ :options :operands | 
    opts := options.
    args := operands ].
opts
  at: 'help'
  ifAbsent: [ 
    | server serviceName response |
    serviceName := 'ServiceVM-ServiceVM'.
    server := WAGemStoneRunSmalltalkServer serverNamed: serviceName.
    response := server.
    opts
      at: 'status'
      ifPresent: [ :ignored | 
        server isNil
          ifTrue: [ response := 'Web server not registered' ]
          ifFalse: [ WAGemStoneRunSmalltalkServer statusGems: server ].
        response ]
      ifAbsent: [ 
        opts
          at: 'register'
          ifPresent: [ :ignored | 
            opts
              at: 'force'
              ifPresent: [ :ignored2 | server ifNotNil: [ WAGemStoneRunSmalltalkServer removeServerNamed: serviceName ] ].
            WAGemStoneRunSmalltalkServer
              addServerOfClass: WAGemStoneServiceExampleVM
              withName: serviceName
              on: #(0).	"port required"
            server := WAGemStoneRunSmalltalkServer serverNamed: serviceName.
            response := server ].
        opts at: 'port' ifPresent: [ :port | server ports: {(port asNumber)} ].
        opts
          at: 'start'
          ifPresent: [ :ignored | WAGemStoneRunSmalltalkServer startGems: server ]
          ifAbsent: [ 
            opts
              at: 'restart'
              ifPresent: [ :ignored | WAGemStoneRunSmalltalkServer restartGems: server ]
              ifAbsent: [ 
                opts
                  at: 'stop'
                  ifPresent: [ :ignored | WAGemStoneRunSmalltalkServer stopGems: server ]
                  ifAbsent: [  ] ] ] ].
    response ]
  ifPresent: [ :ignored | 
    TDManPage
      viewManPage:
        'NAME
  serviceVM - control server gem for WAGemStoneServiceExampleVM example
SYNOPSIS
  serviceVM [-h|--help] [--register [--force]] [--start] [--stop] [--restart]


DESCRIPTION
EXAMPLES
  ./serviceVM --help
  ./serviceVM --register         # register a new instance (first time)
  ./serviceVM --register --force # force a new registration (override existing)

  ./serviceVM --restart          # restart service gem
  ./serviceVM --start            # start service gem
  ./serviceVM --status           # status of service gem
  ./serviceVM --stop             # stop service gem
'
      topez: topez ] ]
