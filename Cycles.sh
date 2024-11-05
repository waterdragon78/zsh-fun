#!/bin/zsh

read "?What string?: " hw
hw="${hw// /☗}"
hw=($(echo "$hw" | sed 's/./& /g'))
chars=({a..z} {0..9})
chars2=({A..Z} {0..9})
nums=({0..9})
e=1
count=1
cache=""
while :; do
	if [ -z "${hw[$count]}" ]; then
		echo
		exit
	fi
	if [[ "${chars[@]}" =~ "${hw[$count]}" ]] || [[ "${chars2[@]}" =~ "${hw[$count]}" ]]; then
		:
	else
		if [[ "${hw[$count]}" == '☗' ]]; then
			((count++))
			cache="$cache "
			continue
		fi
		cache="$cache""${hw[$count]}"
		echo -ne "$cache\r"
		((count++))
		continue
	fi
	a=1
	until [[ "${chars[$e]}" == "${hw[$count]}" ]] || [[ "${chars2[$e]}" == "${hw[$count]}" ]]; do
		if [[ "${chars2[@]}" =~ "${hw[$count]}" ]] && [[ ! "${nums[@]}" =~ "${hw[$count]}" ]]; then
			cap=1
			a=0
			echo -ne "$cache${chars2[$e]}\r"
		else
			cap=0
			a=0
	    	echo -ne "$cache${chars[$e]}\r"
		fi
		sleep .03
	    ((e++))
	done
	if [[ $a -eq 1 ]]; then
		if [[ "${chars2[@]}" =~ "${hw[$count]}" ]]; then
			cap=1
			a=0
			echo -ne "$cache${chars2[$e]}\r"
		else
			cap=0
			a=0
	    	echo -ne "$cache${chars[$e]}\r"
		fi
	fi
	if [[ $cap -eq 1 ]]; then
		echo -ne "$cache${chars2[$e]}\r"
		cache=$cache$(echo "$chars2[$e]")
		cap=false
	else
		echo -ne "$cache${chars[$e]}\r"
		cache=$cache$(echo "$chars[$e]")
		cap=false
	fi
	e=1
	((count++))
done
echo