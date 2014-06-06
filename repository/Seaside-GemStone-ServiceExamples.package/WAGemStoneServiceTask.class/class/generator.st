accessing
generator

	Generator == nil ifTrue: [ Generator := GRPlatform current newRandom ].
	^Generator