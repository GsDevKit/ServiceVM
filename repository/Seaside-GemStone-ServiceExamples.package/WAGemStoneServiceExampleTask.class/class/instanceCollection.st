accessing
instanceCollection
	"self instanceCollection"

	^(self instances collect: [:each | each ]) sortBy: [:a :b | a id < b id ]