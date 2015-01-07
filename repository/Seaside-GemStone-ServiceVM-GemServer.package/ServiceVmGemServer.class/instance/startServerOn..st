service instance-server
startServerOn: portOrResourceName
  "start server in current vm. for gemstone, not expected to return."

  self taskClass vmStartup.
  super startServerOn: portOrResourceName