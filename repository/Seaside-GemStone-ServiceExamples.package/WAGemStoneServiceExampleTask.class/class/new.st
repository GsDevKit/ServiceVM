instance creation
new

	| new |
	new := (super new)
		id: self newId;
		yourself.
	self instances add: new.
	^new