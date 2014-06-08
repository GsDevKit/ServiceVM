serviceVM tasks
serviceVMTasksAvailable: vmTask
  "Using a shared counter means that we don't have to abort to see if
   there are entries in the queue, which means we don't have to acquire
   the transaction mutex"

  ^ WAGemStoneServiceTask sharedCounterValue > vmTask state