title="Remove files for compilation"

run_hook() {
  local docfiles="
usr/include
usr/share/aclocal
usr/share/pkgconfig
usr/src
"
  for dir in $docfiles; do
    find_files ${dir}
  done
}
