public-meta
step3
	<GET>
	<Path: '/step3'>

	| workUnit |
	workUnit := (WAGemStoneServiceTask new)
		step1: #skipped;
		step2: #skipped;
		currentStep: #step2;
		yourself.
	workUnit addToQueue.
	self respondFor: workUnit