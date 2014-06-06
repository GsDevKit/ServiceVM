public-meta
step2
	<GET>
	<Path: '/step2'>

	| workUnit |
	workUnit := (WAGemStoneServiceTask new)
		step1: #skipped;
		currentStep: #step1;
		yourself.
	workUnit addToQueue.
	self respondFor: workUnit