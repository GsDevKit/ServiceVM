actions
step1Action

	| result |
	false 
		ifTrue: [ self performSafely: [ result := self randomDelay ]]
		ifFalse: [ 
			self performSafely: [ 
			result := Gofer new
				disablePackageCache;
				url: 'http://a-bibliocello.gemstone.com/bibliocello/projects/Seaside3.0/repository/Versions/3.0.0-rc.1/pharo';
				allResolved ]].
	GRPlatform current doTransaction: [ 
		self step1: result.
		self class inProcess remove: self ].