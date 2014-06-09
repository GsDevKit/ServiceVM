operations
vmStartup
  "take all inProcess tasks and put them back in the queue"

  GRPlatform current
    doTransaction: [ 
      (ObjectLogEntry
        debug: 'SVCE STATS: Startup [1]'
        object:
          'queue: ' , WAGemStoneServiceExampleTask queue size asString , ' scv: '
            , WAGemStoneServiceExampleTask sharedCounterValue asString , ' hw: '
            , WAGemStoneServiceExampleTask idHighWater asString , ' inprocess: '
            , WAGemStoneServiceExampleTask inProcess size asString)
        addToLog.
      WAGemStoneServiceExampleTask queue
        addAll: WAGemStoneServiceExampleTask inProcess.
      WAGemStoneServiceExampleTask inProcess
        removeAll: WAGemStoneServiceExampleTask inProcess.
      (ObjectLogEntry
        debug: 'SVCE STATS: Startup [2]'
        object:
          'queue: ' , WAGemStoneServiceExampleTask queue size asString , ' scv: '
            , WAGemStoneServiceExampleTask sharedCounterValue asString , ' hw: '
            , WAGemStoneServiceExampleTask idHighWater asString , ' inprocess: '
            , WAGemStoneServiceExampleTask inProcess size asString)
        addToLog ].
  WAGemStoneServiceExampleTask setSharedCounterValue: self tasks first state + 1	"prime the pump"