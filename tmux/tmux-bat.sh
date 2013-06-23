bat_full="♥♥♥"
bat_67="♥♥♡"
bat_33="♥♡♡"
bat_empty="♡♡♡"

acpi_out=$(acpi -b)
bat_pct=$(echo $acpi_out|grep -o '[0-9]*%'|tr -d '%')
bat=$(echo $acpi_out|egrep -o '([0-9]{2}+:)+[0-9]{2}')

if echo $acpi_out | grep -qi "Discharging"; then
	charging=0
else
	charging=1;
fi

if [ $bat_pct -gt 67 ]; then
	sym=$bat_full
elif [ $bat_pct -gt 33 ]; then
	sym=$bat_67
elif [ $bat_pct -lt 6 ]; then
	sym=$bat_empty
elif [ $bat_pct -lt 34 ]; then
	sym=$bat_33
fi

if [ $charging -eq 1 ]; then
	echo "$sym ---"
else
	echo "$sym $bat"
fi
