accessing
queueCollection
  "sorted queue"

  ^ (self queue collect: [ :each | each ]) sortBy: [ :a :b | a id < b id ]