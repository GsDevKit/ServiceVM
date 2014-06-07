accessing
inProcessCollection
  "self inProcessCollection"

  ^ (self inProcess collect: [ :each | each ]) sortBy: [ :a :b | a id < b id ]