"webServer --register"
| serviceName ports serverClass |
serviceName := 'ServiceVM-WebServer'.
ports := #(8383).
serverClass:= WAGsZincAdaptor. "WAFastCGIAdaptor or WAGsSwazooAdaptor"
WAGemStoneRunSmalltalkServer
  addServerOfClass: serverClass
  withName: serviceName
  on: #(8383).

"webServer--start"
| server serviceName |
serviceName := 'ServiceVM-WebServer'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer startGems: server.

"webServer --stop"
| server serviceName |
serviceName := 'ServiceVM-WebServer'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName
WAGemStoneRunSmalltalkServer stopGems: server

