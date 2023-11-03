title="Remove packages cache"

run_hook() {
  find_files "var/cache/apk"
  find_files "var/cache/xbps"
  find_files "var/cache/pacman"
  find_files "var/cache/apt"
  find_files "usr/portage/distfiles"
}
