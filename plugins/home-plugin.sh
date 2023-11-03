title="Remove needless in ~/"

run_hook() {
  #getent passwd {1000..60000}
  local home_dirs="$(cat ${CLNR_ROOT}/etc/passwd | grep -E ":[0-9]{4,}:[0-9]{4,}:" | grep -v "/usr/bin/nologin" | cut -d: -f6 | sed -e 's/^\///')"

  for home in ${home_dirs}; do
    find_files "${home}/.thumbnails"
    find_files "${home}/.cache"
    find_files "${home}/.chatty/cache"
    find_files "${home}/.chatty/logs"
    find_files "${home}/.xsession-errors*"
    find_files "${home}/.config/Code - OSS/Cache"
    find_files "${home}/.config/Code - OSS/CachedData"
    find_files "${home}/.config/Code - OSS/CachedExtensions"
    find_files "${home}/.config/Code - OSS/CachedExtensionVSIXs"
    find_files "${home}/.config/Code - OSS/Code Cache"
    find_files "${home}/.config/Code - OSS/Crash Reports"
    find_files "${home}/.mozilla/firefox/Crash Reports"
  done

}
