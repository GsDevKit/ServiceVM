actions
value
  timeInLondon := (HTTPSocket httpGet: self url)
    throughAll: 'Europe/London - ';
    upTo: Character space.
  ^ timeInLondon