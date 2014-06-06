rendering
renderJavascriptDelayedCallbackOn: html with: aCallbackBlock
	| callbackUrl |
	callbackUrl := html urlForAction: aCallbackBlock.
	
	"ensure we only have one javascript callback block per page"
	self requestContext properties at: #javascriptDelayedCallback ifAbsent: [
		html script: 'window.setInterval(function(){window.location="', callbackUrl greaseString, '"},2000)']