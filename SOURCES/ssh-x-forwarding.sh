# DBus session bus over SSH with X11 forwarding
[ -z "$SSH_CONNECTION" ] && return
[ -z "$DISPLAY" ] && return
[ "${DISPLAY:0:1}" = ":" ] && return
[ "$SHLVL" -ne 1 ] && return

export GDK_BACKEND=x11

eval `dbus-launch --sh-syntax`

[ -z "$DBUS_SESSION_BUS_PID" ] && return
setsid -f /usr/libexec/dbus-1/dbus-kill-process-with-session "$DBUS_SESSION_BUS_PID"
