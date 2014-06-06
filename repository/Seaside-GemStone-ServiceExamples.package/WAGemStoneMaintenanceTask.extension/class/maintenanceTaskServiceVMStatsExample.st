*seaside-gemstone-serviceexamples
maintenanceTaskServiceVMStatsExample
	"self initialize"

	^self 
		name: 'Service VM Stats'
		frequency: 1 " run once per minute"
		valuable: [:task |
			GRPlatform current doTransaction: [ | queueSize inProcessSize showStats |
				queueSize := WAGemStoneServiceTask queue size.
				inProcessSize := WAGemStoneServiceTask inProcess size.
				showStats := (queueSize  > 0) or: [ inProcessSize > 0 ].
				(task state | showStats)
					ifTrue: [ 
						(ObjectLogEntry 
							debug: 'SVCE STATS' 
							object: 
								'queue: ',  queueSize asString, 
								' insts: ', WAGemStoneServiceTask instances size asString,
								' scv: ', WAGemStoneServiceTask sharedCounterValue asString, 
								' hw: ', WAGemStoneServiceTask idHighWater asString,
								' inprocess: ', inProcessSize asString
						) addToLog.
						"record objectLog entry when showStats is false"
						task state: showStats ]]]
		reset: [:task | task state: true ]