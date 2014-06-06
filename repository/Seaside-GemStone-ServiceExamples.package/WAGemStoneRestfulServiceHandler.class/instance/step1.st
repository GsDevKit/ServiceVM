public-meta
step1
	<GET>
	<Path: '/step1'>

	| workUnit |
	workUnit := WAGemStoneServiceTask new.
	workUnit addToQueue.
	self respondFor: workUnit