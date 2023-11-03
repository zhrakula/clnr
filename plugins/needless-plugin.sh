title="Remove files for apps that not installed"

is_callable() {
	command -v ${1}
}

run_hook() {
	local command= dir= list="
zsh:usr/share/zsh
fish:usr/share/fish
"

	for l in $list; do
		command=${l%%:*}
		dir=${l#*:}
		if ! command -v ${command} &>/dev/null; then
			find_files ${dir}
		fi
	done

}
