private
getRemoteTime
	| resultStream temp random |
	
	"randomised to avoid caching servers down the line"
	random := Random new.
	resultStream := HTTPSocket httpGet: 'http://www.worldtimeserver.com/current_time_in_UTC.aspx?random=', (random nextInt: 1000) greaseString .
	
	"fragile string extraction - try to find a better example. Currently it's designed to extract the time from html formatted as:
	      <div id=""analog-digital"">
                <span class=''''font7''''>
                      18:12
                </span>
            </div>

	The parsing below isn't as neat as it could be. At the time of writing multiline regex are broken on GemStone and Pharo doesn't
	support the handy #throughAll:'"
	temp := resultStream upToAll: '<div id="analog-digital">'; upToAll: '<span' ; upToAll: '</span>'.
	^ temp readStream upTo: $>; upToEnd