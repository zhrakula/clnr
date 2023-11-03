title="Remove files in /tmp and /var/tmp"

run_hook() {
  find_files "tmp"
  find_files "var/tmp"
}
