accessing
tasks
	^ tasks ifNil: [tasks := (1 to: 100) collect: [ :each | FutureSeasideExampleSingle new ] ]