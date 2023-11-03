title="Remove background images"

run_hook() {
  local docfiles="
usr/share/backgrounds
usr/share/xfce4/backdrops
usr/share/lubuntu/wallpapers
"
  for dir in $docfiles; do
    find_files ${dir}
  done
}
