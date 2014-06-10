[ :topez :objIn :tokens :command :commandNode | 
| opts args |
"for help: ./serviceExample -h"
command
  getOptsMixedLongShort:
    {#('help' $h #'none').
    #('task' nil #'optional').
    #('poll' nil #'optional').
    #('addToQueue' nil #'none').
    #('reset' nil #'none').
    #('status' nil #'none')}
  optionsAndArguments: [ :options :operands | 
    opts := options.
    args := operands ].
opts
  at: 'help'
  ifAbsent: [ 
    | response taskClass taskInstances |
    taskClass := WAGemStoneServiceExampleTask.
    taskInstances := SessionTemps current
      at: #'SERVICE_EXAMPLE_INSTANCES'
      ifAbsent: [ SessionTemps current at: #'SERVICE_EXAMPLE_INSTANCES' put: Dictionary new ].
    opts
      at: 'task'
      ifPresent: [ :taskId | 
        | task |
        taskId
          ifNil: [ 
            response := task := taskClass
              valuable:
                (WAGemStoneServiceExampleTimeInLondon
                  url: 'http://www.time.org/zones/Europe/London.php').
            taskInstances at: task id put task ]
          ifNotNil: [ 
            System commit.	"ensure that we are accessing latest state of task"
            response := task := taskInstances at: taskId asNumber.
            opts
              at: 'addToQueue'
              ifPresent: [ :ignored | 
                task addToQueue.
                System commit	"so that service vm can see new queue entry" ].
            opts
              at: 'poll'
              ifPresent: [ :limitArg | 
                | limit count |
                limit := 10.
                limitArg ifNotNil: [ limit := limitArg asNumber ].
                count := 0.
                [ 
                System abort.	"so that service vm can see new queue entry"
                task hasValue not and: [ count <= limit ] ]
                  whileTrue: [ 
                    (Delay forSeconds: 1) wait.
                    count := count + 1 ].
                System abort.
                task hasValue
                  ifTrue: [ response := task ]
                  ifFalse: [ response := task -> ('not finished after ' , count printString , ' seconds') ] ] ] ]
      ifAbsent: [ 
        opts
          at: 'reset'
          ifPresent: [ :ignored | 
            response := taskClass reset.
            SessionTemps current
              at: #'SERVICE_EXAMPLE_INSTANCES'
              put: Dictionary new ].
        opts
          at: 'status'
          ifPresent: [ :ignored | 
            | dict |
            dict := Dictionary new
              at: 'queue' put: taskClass queue;
              at: 'inProcess' put: taskClass inProcessCollection;
              at: 'high water' put: taskClass idHighWater;
              yourself.
            dict edit: topez.	"bring up inspector"
            response := dict ] ].
    response ]
  ifPresent: [ :ignored | 
    TDManPage
      viewManPage:
        'NAME
  serviceExample - serviceExample sript utility template
SYNOPSIS
  serviceExample [-h|--help] [--reset] [--status]
  serviceExample --task[=<task-id>] [--addToQueue] [--poll[=<poll-limit>]
DESCRIPTION
EXAMPLES
  ./serviceExample --help
  ./serviceExample --reset                # clear service task queues and counters
                                          #   only use reset when service is not
                                          #   running
  ./serviceExample --status               # state of service task engine

  ./serviceExample --task                 # create a new task
  ./serviceExample --task=3               # access task #3
  ./serviceExample --task=3 --addToQueue  # schedule task #3 to process next step
  ./serviceExample --task=3 --poll=10     # poll until task #3 finished step (10 tries)
'
      topez: topez ] ]
