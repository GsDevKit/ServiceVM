accessing
value: theTaskBlock 
    lock := Semaphore new.

    [ [ [ futureValue := theTaskBlock value ] 
        on: Error
        do: [ :ex | exception := ex ] ]
        ensure: [ lock signal ] ] forkAt: Processor userBackgroundPriority