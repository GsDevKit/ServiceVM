rendering
renderContentOn: html
	started isNil 
		ifTrue: [
			html anchor 
				callback: [
					self startBackgroundTasks.
					started := true ];
				with: 'start multiple background requests']
		ifFalse: [
			html orderedList: [
				self tasks do: [ :aTask | html listItem: aTask].		
			].
			html anchor callback: [self startBackgroundTasks]; with: 'start all again' ]