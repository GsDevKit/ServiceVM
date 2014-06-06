actions
processStep

	self finished ifTrue: [ ^self ].
	self step1 == nil
		ifTrue: [ ^self step1Action ].
	self step2 == nil
		ifTrue: [ ^self step2Action ].
	self step3 == nil
		ifTrue: [ ^self step3Action ].