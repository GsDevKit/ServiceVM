control (WAGemStoneRunSmalltalkServer)
startOn: ignored
  "start running the service"

  self vmStartup.
  self serviceLoop