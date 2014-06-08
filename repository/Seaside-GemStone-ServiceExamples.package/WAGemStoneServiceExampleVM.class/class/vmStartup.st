operations
vmStartup
  "take all inProcess tasks and put them back in the queue"

  GRPlatform current
    doTransaction: [ 
      WAGemStoneServiceExampleTask queue
        addAll: WAGemStoneServiceExampleTask inProcess.
      WAGemStoneServiceExampleTask inProcess
        removeAll: WAGemStoneServiceExampleTask inProcess ].
  WAGemStoneServiceExampleTask setSharedCounterValue: self tasks first state + 1	"prime the pump"