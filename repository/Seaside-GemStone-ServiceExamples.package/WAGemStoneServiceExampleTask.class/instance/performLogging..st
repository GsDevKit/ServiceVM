private
performLogging: label

	false ifTrue: [ (ObjectLogEntry debug: 'Work Unit ', self label object: self) addToLog ].
	self log add: label -> DateAndTime now.