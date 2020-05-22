function begitu_selesai(){
	while true;do
		net_result=`netstat -ntp|grep 'ESTABLISHED'|awk '{print $2"\t"$4"\t"$5}'`
		printf "%s\n%s\t" "$net_result" "_ports :";read _ports;
		if `echo $_ports|grep -qE '^[0-9]'`;then
			if `printf "%s\n" "$net_result"|grep -q ":$_ports$"`;then
				break;
			else
				printf "%s\n" "PORT CLOSED" >&2;
			fi
		fi
	done
	while true;do
		if ! `netstat -nt 2>/dev/null|grep -q ":"$_ports" "`;then
			$@;
			break;
		fi
		sleep 10;
	done &!;
}
