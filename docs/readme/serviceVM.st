"serviceVM --register"
| serviceName ports |
serviceName := 'ServiceVM-ServiceVM'.
ports := #(8383).
WAGemStoneRunSmalltalkServer
  addServerOfClass: WAGemStoneServiceVM
  withName: serviceName
  on: ports.

"serviceVM --start"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer startGems: server

"serviceVM --stop"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer stopGems: server

"serviceVM --status"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer statusGems: server

"serviceVM --restart"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer restartGems: server

