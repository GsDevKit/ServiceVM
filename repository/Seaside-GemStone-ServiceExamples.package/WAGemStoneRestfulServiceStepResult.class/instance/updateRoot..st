rendering
updateRoot: anHtmlRoot

	| url |
	super updateRoot: anHtmlRoot.
	workUnit finishedStep ifTrue: [ ^self ].
	url := anHtmlRoot context actionUrl.
	url addToPath: '/examples/service/status/', workUnit id asString.
	anHtmlRoot meta 
		redirectAfter: self delay
		to: url greaseString