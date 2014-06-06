public-meta
status: workUnitId
	<GET>
	<Path: '/status/{workUnitId}'>

	| workUnit |
	workUnit := WAGemStoneServiceTask instanceWithId: workUnitId asInteger.
	workUnit == nil
		ifTrue: [ self errorNotFound: workUnitId ].
	self respondFor: workUnit