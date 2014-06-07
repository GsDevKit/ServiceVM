operations
serviceLoop
  | count |
  count := 0.
  self vmStartup.
  [ true ]
    whileTrue: [ 
      [ 
      self performTasks: count.	"run service tasks"
      (Delay forMilliseconds: 200) wait.	"Sleep for a 200ms"
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