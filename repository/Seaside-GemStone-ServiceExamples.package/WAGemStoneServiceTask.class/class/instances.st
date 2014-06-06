accessing
instances

	Instances == nil ifTrue: [ Instances := RcQueue new: 100 ].
	^Instances