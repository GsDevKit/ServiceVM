private
performSafely: aBlock
  "catch errors, halts and breakpoints ... service vm is non-interactive ... 
	 record the error (in transaction) and let the process servicing this task terminate ... 
	 it's up to someone else to clean up:)"

  aBlock
    on: Error , Halt , Breakpoint
    do: [ :ex | 
      GRPlatform current
        doTransaction: [ 
          DebuggerLogEntry createContinuationLabeled: 'SVCE continuation'.
          self performLogging: 'ERROR: ' , ex description.
          errorFlag := ex description ] ]