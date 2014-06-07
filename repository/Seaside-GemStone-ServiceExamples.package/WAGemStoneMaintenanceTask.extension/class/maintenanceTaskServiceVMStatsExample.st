*seaside-gemstone-serviceexamples
maintenanceTaskServiceVMStatsExample
  "self initialize"

  ^ self
    name: 'Service VM Stats'
    frequency: 1
    valuable: [ :task | 
      GRPlatform current
        doTransaction: [ 
          | queueSize inProcessSize showStats |
          queueSize := WAGemStoneServiceExampleTask queue size.
          inProcessSize := WAGemStoneServiceExampleTask inProcess size.
          showStats := queueSize > 0 or: [ inProcessSize > 0 ].
          task state | showStats
            ifTrue: [ 
              (ObjectLogEntry
                debug: 'SVCE STATS'
                object:
                  'queue: ' , queueSize asString , ' insts: '
                    , WAGemStoneServiceExampleTask instances size asString
                    , ' scv: '
                    , WAGemStoneServiceExampleTask sharedCounterValue asString
                    , ' hw: '
                    , WAGemStoneServiceExampleTask idHighWater asString
                    , ' inprocess: ' , inProcessSize asString)
                addToLog.	"record objectLog entry when showStats is false"
              task state: showStats ] ] ]
    reset: [ :task | task state: true ]	" run once per minute"