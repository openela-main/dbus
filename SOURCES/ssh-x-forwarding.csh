# DBus session bus over SSH with X11 forwarding
if ( $?SSH_CONNECTION == 0 ) exit
if ( $?XDG_SESSION_ID == 0) exit
if ( $?DISPLAY == 0 ) exit
if ( $SHLVL > 1 ) exit

set DBUS_SESSIONS = "${XDG_RUNTIME_DIR}/dbus-1/sessions"
set DBUS_SESSION_ADDRESS_FILE = "${DBUS_SESSIONS}/${XDG_SESSION_ID}"

if ( -e "${DBUS_SESSION_ADDRESS_FILE}" ) then
    setenv DBUS_SESSION_BUS_ADDRESS "`cat ${DBUS_SESSION_ADDRESS_FILE}`"
    exit
endif

setenv GDK_BACKEND x11

eval `dbus-launch --csh-syntax`

if ( $?DBUS_SESSION_BUS_PID == 0 ) exit

mkdir -p "${DBUS_SESSIONS}"
echo "${DBUS_SESSION_BUS_ADDRESS}" > "${DBUS_SESSION_ADDRESS_FILE}"

setsid -f /usr/libexec/dbus-1/dbus-kill-process-with-session $DBUS_SESSION_BUS_PID
