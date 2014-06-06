testing
startedStep

	errorFlag ~~ nil ifTrue: [ ^true ].
	(currentStep == #step3 and: [ step3 == nil ]) ifTrue: [ ^true ].
	(currentStep == #step2 and: [ step2 == nil ]) ifTrue: [ ^true ].
	(currentStep == #step1 and: [ step1 == nil ]) ifTrue: [ ^true ].
	^false