actions
setCurrentStep

	currentStep == nil 
		ifTrue: [ 
			currentStep := #step1.
			^self].
	currentStep == #step1 
		ifTrue: [ 
			currentStep := #step2.
			^self].
	currentStep == #step2 
		ifTrue: [ 
			currentStep := #step3.
			^self].