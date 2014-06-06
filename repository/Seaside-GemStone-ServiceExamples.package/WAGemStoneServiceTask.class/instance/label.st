accessing
label

	errorFlag ~~ nil
		ifTrue: [ ^errorFlag ].
	step1 == nil
		ifTrue: [ ^'perform step 1' ].
	step2 == nil
		ifTrue: [ ^'perform step 2' ].
	step3 == nil
		ifTrue: [ ^'perform step 3' ].
	^'perform step 1'