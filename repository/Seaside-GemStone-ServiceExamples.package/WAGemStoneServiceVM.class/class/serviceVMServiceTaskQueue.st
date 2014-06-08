serviceVM tasks
serviceVMServiceTaskQueue
  ^ self
    name: 'Service VM Loop'
    frequency: 1
    valuable: [ :vmTask | 
      "====== CHECK FOR TASKS IN QUEUE (non-transactional)"
      (self serviceVMTasksAvailable: vmTask)
        ifTrue: [ 
          | tasks repeat |
          repeat := true.	"====== PULL TASKS FROM QUEUE UNTIL QUEUE IS EMPTY OR 100 TASKS IN PROGRESS"
          [ repeat and: [ self serviceVMTasksInProcess < 100 ] ]
            whileTrue: [ 
              repeat := false.
              GRPlatform current
                doTransaction: [ 
                  "====== REMOVE TASKS FROM QUEUE..."
                  tasks := self serviceVMTasks: vmTask ].
              tasks
                do: [ :task | 
                  "====== ...FORK BLOCK AND PROCESS TASK"
                  [ task processTask ] fork ].
              repeat := tasks notEmpty ] ] ]
    reset: [ :vmTask | vmTask state: 0 ]