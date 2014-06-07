testing
finished

	errorFlag ~~ nil ifTrue: [ ^true ].
	currentStep ~~ #step3 ifTrue: [ ^false ].
	^(self step1 ~~ nil
		and: [ self step2 ~~ nil ])
		and: [ self step3 ~~ nil ]