rendering
renderStep3On: html
	html text: 'waiting on background task '.
	html text: self count greaseString.
	html break.
	
	self renderJavascriptDelayedCallbackOn: html with: [self incrementCount].