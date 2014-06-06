actions
nonBlockingStep
	workUnit startedStep
		ifTrue: [ 
			 (ObjectLogEntry debug: 'Processing already in progress' object: workUnit) addToLog.
			^self ].
	workUnit finished ifTrue: [ workUnit := WAGemStoneServiceTask  new ].
	workUnit addToQueue