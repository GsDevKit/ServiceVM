serviceVM tasks
serviceVMTasks: vmTask
  | tasks persistentCounterValue |
  tasks := #().
  persistentCounterValue := WAGemStoneServiceExampleTask sharedCounterValue.
  WAGemStoneServiceTask queue size > 0
    ifTrue: [ 
      vmTask state: persistentCounterValue.
      tasks := WAGemStoneServiceTask queue removeCount: 10.
      WAGemStoneServiceTask inProcess addAll: tasks ].
  ^ tasks