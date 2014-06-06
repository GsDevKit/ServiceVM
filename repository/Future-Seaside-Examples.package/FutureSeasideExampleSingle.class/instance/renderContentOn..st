rendering
renderContentOn: html
	self checkBackgroundTaskCompleted.
	
	self step = 4 ifTrue: [self renderStep4On: html].
	self step = 3 ifTrue: [self renderStep3On: html].
	self step = 2 ifTrue: [self renderStep2On: html].
	self step = 1 ifTrue: [self renderStep1On: html]