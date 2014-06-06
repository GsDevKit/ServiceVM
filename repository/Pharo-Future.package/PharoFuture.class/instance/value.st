accessing
value
    lock isSignaled ifFalse: [ lock wait ].
    exception  ifNotNil: 
        [ exception
            privHandlerContext: thisContext;
            signal ].
    ^ futureValue