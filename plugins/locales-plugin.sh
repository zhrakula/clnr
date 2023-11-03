title="Remove locales"

# TODO
# ? usr/share/gnome/help
# ? usr/share/omf
# ? usr/share/doc/kde/HTML
# ? usr/share/tcltk
# ? usr/share/aptitude
# ? usr/share/calendar
# ? usr/share/cups/templates usr/share/cups/locale usr/share/cups/doc-root
# ? usr/share/djvu/osi
#   usr/share/git-gui/lib/msgs/ru.msg
# /usr/share/kvantumpreview/translations/kvantumpreview_eo.qm

run_hook() {
  local prevents=${ignore_locales// /|}
  for dir in usr/share/locale usr/share/help; do
    find_files "${dir}" ".*/(${prevents})/.*"
  done

  find_files "usr/share/avidemux6/qt5/i18n" ".*_(${prevents})\.qm"
  find_files "usr/share/man" "usr/share/man/(${prevents}|man[n0-9])/.*"
  find_files "usr/share/gnupg" "usr/share/gnupg/help\..*\.txt" "\.(${prevents}).txt$"
  find_files "usr/share/ufw/messages" ".*(${prevents})\.mo"
  find_files "boot/grub/locale" ".*(${prevents})\.mo"
  find_files "usr/share/gitk/lib/msgs" ".*(${prevents})\.msg"
  find_files "usr/share/mc/hints" "usr/share/mc/hints/mc\.hint\..*" ".*\.(${prevents})"
  find_files "usr/share/mc/help" ".*/mc\.hlp\..*" ".*\.(${prevents})"
  find_files "usr/share/obs/" ".*/locale/[^/]+.ini" ".*/(${prevents//_/-})\.ini$"

  find_files "usr/lib/electron/locales" ".*(${prevents//_/-})\.pak"

}
