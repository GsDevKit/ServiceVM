accessing
instanceWithId: anInteger

	^self instances detect: [:each | each id == anInteger ] ifNone: []