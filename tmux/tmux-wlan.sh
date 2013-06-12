sym="☎"
status="-"

if ! wpa_cli status &>/dev/null; then
	state="DISABLED"
else
	state=$(wpa_cli status|grep wpa_state|cut -d"=" -f2)

	if [ "$state" = "COMPLETED" ];then
		state="$(wpa_cli status|grep -i "^ssid"|cut -d"=" -f2)"
	fi
fi

echo "$sym $state"
