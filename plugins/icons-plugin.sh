title="Remove icon themes"

run_hook() {
  local prevents="${ignore_icons// /|}|hicolor|default"
  find_files "usr/share/icons" "usr/share/icons/(${prevents})/.*"
}
