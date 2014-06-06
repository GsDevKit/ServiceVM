rendering
renderStep2On: html
	html text: 'background task has been kicked-off - this page will automatically refresh in 2s'.
	self renderJavascriptDelayedCallbackOn: html with: [self step: 3].