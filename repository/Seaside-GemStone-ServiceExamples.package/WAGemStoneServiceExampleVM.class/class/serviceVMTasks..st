serviceVM tasks
serviceVMTasks: vmTask
  | tasks persistentCounterValue |
  tasks := #().
  persistentCounterValue := WAGemStoneServiceExampleTask sharedCounterValue.
  WAGemStoneServiceExampleTask queue size > 0
    ifTrue: [ 
      vmTask state: persistentCounterValue.
      tasks := WAGemStoneServiceExampleTask queue removeCount: 10.
      WAGemStoneServiceExampleTask inProcess addAll: tasks ].
  ^ tasks