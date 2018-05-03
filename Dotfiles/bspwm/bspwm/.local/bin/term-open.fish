#!/bin/fish

function create_st
	st -t $argv[1] -e sh -c $argv[2]
end

function raise_or_create
	set $cmd $argv[2]
	set $window_title $argv[1]
	if test (wmctrl -l | grep $window_title)
		wmctrl -a $window_title -F
	else
		create_st $window_title $cmd
	end
end

switch $argv[1]
case "main"
	raise_or_create "st-main-local-tmux" "tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$USER"
case "single"
	create_st "st" "tmux new-session"
case "home"
	raise_or_create "st-main-home-tmux" "mosh home -- tmux -q has-session && tmux attach-session -d || tmux new-session -n$USER -s$USER"
end

