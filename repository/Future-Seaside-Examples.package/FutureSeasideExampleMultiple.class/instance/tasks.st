accessing
tasks
	^ tasks ifNil: [tasks := (1 to: 40) collect: [ :each | FutureSeasideExampleSingle new ] ]