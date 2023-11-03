#!/bin/bash

readonly CLNR_VERSION="0.1"
readonly CLNR_PROGNAME="${0##*/}"
readonly CLNR_PLUGINSDIR="$(dirname "$(realpath $0)")/plugins"
readonly CLNR_DEFAULT_CFG="$(dirname "$(realpath $0)")/clnr.conf"

usage() {
  cat <<_EOF
${CLNR_PROGNAME}: [options] <rootdir>
  -b <file.tar>        make backup file
  -c <config.conf>     use config file
  -l                   list files
  -p <plugins>         comma separated plugins list
  -r                   remove files
  -u <file.tar>        restore from backup file
  -s                   print size of files
_EOF
  exit
}

prepare_list() {
  local dt="${2}"
  echo "$1" | sed -e "s/^[[:blank:]]*//;s/[[:blank:]]*$//;/^[[:blank:]]*#/d;s/#.*//;/^$/d;" | sed -z "s/\n/${dt}/;$ s/${dt}$//"
}

find_files() {
  local src="${1}" regexp="${2}" invregexp="${3}" opts="-type f,l"

  if [ -n "${regexp}" ]; then
    opts="${opts} -regextype egrep"
    if [ -z "${invregexp}" ]; then
      opts="${opts} -not"
    fi
    opts="${opts} -regex ${regexp}"
  fi

  opts="${opts} -print0"

  if [ -z "${invregexp}" ]; then
    find "${src}" ${opts} 2>/dev/null
  else
    find "${src}" ${opts} 2>/dev/null | grep -zEv "${invregexp}"
  fi

}

process_all() {
  local src="$(realpath ${1})" plugfile=
  cd ${src}

  for plugin in ${plugins}; do

    plugfile="${CLNR_PLUGINSDIR}/${plugin}-plugin.sh"

    if [ -e "${plugfile}" ]; then
      . ${plugfile}
      run_hook
    else
      echo "ERROR: plugin '${plugin}' not found" 1>&2
    fi

  done | sort -uz | (test -n "${ignore_files}" && grep -zvE "${ignore_files}" || cat -)
}

if [ $# -le 1 ]; then
  usage
fi

while getopts "b:c:p:lrs" opt; do
  case $opt in
  b) CLNR_BACKUP_FILE=$(realpath $OPTARG) ;;
  c) CLNR_CONFIG_FILE=$(realpath $OPTARG) ;;
  p) CLNR_PLUGINS="${OPTARG}" ;;
  l) CLNR_LIST=1 ;;
  r) CLNR_REMOVE=1 ;;
  u) CLNR_RESTORE_FILE=$(realpath $OPTARG) ;;
  s) CLNR_SIZE=1 ;;
  * | h) usage ;;
  esac
done
shift $(($OPTIND - 1))

readonly CLNR_ROOT="$(realpath $1)"
readonly CLNR_TMPFILE=$(mktemp)

if [ -z ${CLNR_ROOT} ]; then
  usage
fi

if [ ! -d ${CLNR_ROOT} ]; then
  echo "ERROR: '${CLNR_ROOT}' is not directory" 1>&2
  exit
fi

if [ -f "$CLNR_DEFAULT_CFG" ]; then
  . $CLNR_DEFAULT_CFG
fi

if [ -n "${CLNR_CONFIG_FILE}" ]; then
  if [ -f "${CLNR_CONFIG_FILE}" ]; then
    . ${CLNR_CONFIG_FILE}
  else
    echo "ERROR: config file '${CLNR_CONFIG_FILE}' not found"
  fi
fi

if [ "${CLNR_PLUGINS}" ]; then
  plugins=${CLNR_PLUGINS//,/ }
fi

if [ "$plugins" = "all" -o "$plugins" = "*" ]; then
  plugins=$(ls ${CLNR_PLUGINSDIR}/ | xargs -l basename -s '-plugin.sh')
fi

plugins=$(prepare_list "${plugins}" " ")
ignore_files=$(prepare_list "${ignore_files}" "|")

# TODO: TEST THIS
if [ "${CLNR_RESTORE_FILE}" ]; then
  cd ${CLNR_ROOT}
  tar xf ${CLNR_RESTORE_FILE}
fi

process_all "${CLNR_ROOT}" >${CLNR_TMPFILE}

if [ "${CLNR_LIST}" ]; then
  cat ${CLNR_TMPFILE} | tr '\0' '\n'
fi

if [ "${CLNR_SIZE}" ]; then
  cat ${CLNR_TMPFILE} | du -h --files0-from=- --total -s 2>/dev/null | tail -1 | cut -f1
fi

if [ "${CLNR_BACKUP_FILE}" ]; then
  tar -caf ${CLNR_BACKUP_FILE} --null -T ${CLNR_TMPFILE}
fi

if [ "${CLNR_REMOVE}" ]; then
  cat ${CLNR_TMPFILE} | xargs -0 rm -fv
fi

rm ${CLNR_TMPFILE}
