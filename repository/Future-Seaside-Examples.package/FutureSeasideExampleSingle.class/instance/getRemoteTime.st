private
getRemoteTime
	| resultStream |
	resultStream := HTTPSocket httpGet: 'http://www.worldtimeserver.com/current_time_in_UTC.aspx'.
	"Error signal: 'pretend error'."
	"fragile string extraction - try to find a better example"
	^ resultStream upToAll: '<div id="analog-digital">'; upToAll: '<span' ; throughAll: '</span>'