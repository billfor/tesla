#!/bin/bash
# put oauth token here
token=`cat .token`
id=$(curl -sS --header "Authorization: Bearer $token" "https://owner-api.teslamotors.com/api/1/vehicles" | jq '.response[0].id_s' | tr -d \")
state=$(curl -sS --header "Authorization: Bearer $token" "https://owner-api.teslamotors.com/api/1/vehicles" | jq .response[0].state | tr -d \") 
[ $state == online  -a -f /tmp/asleep ] &&  rm -f /tmp/asleep && rm -f /tmp/shiftnull
[ $state == online  -a -f /tmp/shiftnull ] && echo `date '+%m/%d %T'` $state >> /tmp/tesla.log  && exit 0
[ $state == asleep ] && touch /tmp/asleep
shift_state=$(curl -sS --header "Authorization: Bearer $token" https://owner-api.teslamotors.com/api/1/vehicles/$id/data_request/drive_state | jq .response.shift_state)
latlon=$(curl -sS --header "Authorization: Bearer $token" https://owner-api.teslamotors.com/api/1/vehicles/$id/data_request/drive_state | jq -c '.response | [.latitude,.longitude]')
[ $shift_state == null ] && touch /tmp/shiftnull
echo `date '+%m/%d %T'` $state $shift_state $latlon>> /tmp/tesla.log
