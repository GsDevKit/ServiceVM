accessing
inProcess
  inProcess == nil
    ifTrue: [ inProcess := RcIdentityBag new: 100 ].
  ^ inProcess