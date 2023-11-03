title="Remove docs files"

run_hook() {
  local docfiles="
usr/doc
usr/share/cups/doc-root
usr/share/devhelp
usr/share/doc
usr/share/doc-base
usr/share/examples
usr/share/ffconvert/doc
usr/share/gnome/help
usr/share/gnome/help-langpack
usr/share/gtk-doc
usr/share/help
usr/share/help-langpack
usr/share/info
usr/share/inkscape/doc
usr/share/inkscape/tutorials
usr/share/libreoffice/help
usr/share/mc/help
usr/share/mc/hints
usr/share/omf
usr/share/orage/doc
usr/share/sylpheed/faq
usr/share/sylpheed/manual
usr/share/synaptic/html
usr/share/xfce4/doc
"
  for dir in $docfiles; do
    find_files ${dir}
  done
}
