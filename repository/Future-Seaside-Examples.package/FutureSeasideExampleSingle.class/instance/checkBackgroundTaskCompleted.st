rendering
checkBackgroundTaskCompleted
	remoteTime isNil 
		ifFalse: [
			(remoteTime hasValue or: [remoteTime hasError]) 
				ifTrue: [ self step: 4 ] ]