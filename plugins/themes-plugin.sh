title="Remove themes"

run_hook() {
  local prevents=${ignore_themes// /|}
  find_files "usr/share/themes" "usr/share/themes/(${prevents})/.*"
}
