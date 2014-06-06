rendering
render
	
	^WARenderCanvas builder
		fullDocument: true;
		rootBlock: [ :root | 
			self updateRoot: root ];
		render: [ :canvas |
			self renderContentOn: canvas ]