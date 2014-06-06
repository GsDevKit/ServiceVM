#! /bin/bash
#
#  Copy the runSmalltalkServer and startSmalltalkServer to the
#    $GEMSTONE/seaside/bin directory

if [ "${GEMSTONE}x" = "x" ] ; then
  echo "The \$GEMSTONE environment variable must be defined"
    exit 1
fi

chmod u+w $GEMSTONE/seaside/bin
cp runSmalltalkServer startSmalltalkServer $GEMSTONE/seaside/bin
chmod u-w $GEMSTONE/seaside/bin


