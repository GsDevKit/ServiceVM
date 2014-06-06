rendering
respondRendered
	
	self requestContext respond: [:response |
		response
			contentType: WAMimeType textHtml;
			nextPutAll: (	WARenderCanvas builder
				fullDocument: true;
				rootBlock: [ :root | 
					self updateRoot: root ];
				render: [ :canvas |
					self renderContentOn: canvas ])].