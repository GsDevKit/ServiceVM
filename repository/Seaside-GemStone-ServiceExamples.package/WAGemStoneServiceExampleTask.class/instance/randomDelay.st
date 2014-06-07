private
randomDelay

	| delay |
	delay := self class generator nextInt: 10.
	(Delay forSeconds: delay) wait.
	^delay