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
    | server serviceName |
    serviceName := 'ServiceVM-ServiceVM'.
    server := WAGemStoneRunSmalltalkServer serverNamed: serviceName.
    opts
      at: 'status'
      ifPresent: [ :ignored | 
        | response |
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
              ifPresent: [ :xx | server ifNotNil: [ WAGemStoneRunSmalltalkServer removeServerNamed: serviceName ] ].
            WAGemStoneRunSmalltalkServer
              addServerOfClass: WAGemStoneServiceVM
              withName: serviceName
              on: #(8383).
            server := WAGemStoneRunSmalltalkServer serverNamed: serviceName ].
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
                  ifAbsent: [  ] ] ] ] ]
  ifPresent: [ :ignored | 
    TDManPage
      viewManPage:
        'NAME
  serviceVM - control server gem for ServiceVM example
SYNOPSIS
  serviceVM [-h|--help] [--register [--force]] [--start] [--stop] [--restart]


DESCRIPTION
EXAMPLES
  ./serviceVM --help
  ./serviceVM --register
  ./serviceVM --register --force # force a new registration

  ./serviceVM --restart
  ./serviceVM --start
  ./serviceVM --status
  ./serviceVM --stop
'
      topez: topez ] ]
