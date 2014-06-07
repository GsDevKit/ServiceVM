accessing
instanceErrors
	"self instanceErrors"

	^(self instances select: [:each | each hasError ]) sortBy: [:a :b | a id < b id ]