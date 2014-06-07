services
startOn: ignored
  "start running the service"

  | count |
  count := 0.
  WAGemStoneServiceVMTask vmStartup.
  [ true ]
    whileTrue: [ 
      [ 
      "run service tasks"
      WAGemStoneServiceVMTask performTasks: count.	"Sleep for a 200ms"
      (Delay forMilliseconds: 200) wait.
      count := count + 1 ]
        on: Error , Halt , Breakpoint
        do: [ :ex | 
          System inTransaction
            ifTrue: [ 
              DebuggerLogEntry createContinuationLabeled: 'SVCE continuation'.
              System commitTransaction.
              System beginTransaction ]
            ifFalse: [ 
              System beginTransaction.
              DebuggerLogEntry createContinuationLabeled: 'SVCE continuation'.
              System commitTransaction ].
          ex isResumable
            ifTrue: [ ex resume ] ] ]