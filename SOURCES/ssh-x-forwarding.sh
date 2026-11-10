# DBus session bus over SSH with X11 forwarding
[ -z "$SSH_CONNECTION" ] && return
[ -z "$XDG_SESSION_ID" ] && return
[ -z "$DISPLAY" ] && return
[ "${DISPLAY:0:1}" = ":" ] && return
[ "$SHLVL" -ne 1 ] && return

DBUS_SESSIONS="${XDG_RUNTIME_DIR}/dbus-1/sessions"
DBUS_SESSION_ADDRESS_FILE="${DBUS_SESSIONS}/${XDG_SESSION_ID}"

if [ -e "${DBUS_SESSION_ADDRESS_FILE}" ]; then
    export DBUS_SESSION_BUS_ADDRESS="$(cat ${DBUS_SESSION_ADDRESS_FILE})"
    return
fi

export GDK_BACKEND=x11

eval `dbus-launch --sh-syntax`

[ -z "$DBUS_SESSION_BUS_PID" ] && return

mkdir -p "${DBUS_SESSIONS}"
echo "${DBUS_SESSION_BUS_ADDRESS}" > "${DBUS_SESSION_ADDRESS_FILE}"

setsid -f /usr/libexec/dbus-1/dbus-kill-process-with-session "$DBUS_SESSION_BUS_PID"
