title="Remove packages"
#remove_packages=""

run_hook() {
	if [ -z "${remove_packages}" ]; then
		return
	fi

	if command -v pacman &>/dev/null; then
		pacman -Qlq -r ${CLNR_ROOT} ${remove_packages} | sed -e "s#^${CLNR_ROOT}/##;/\/$/d;/^$/d" | tr '\n' '\0'
	fi

}
