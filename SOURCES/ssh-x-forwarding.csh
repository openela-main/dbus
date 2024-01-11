# DBus session bus over SSH with X11 forwarding
if ( $?SSH_CONNECTION == 0 ) exit
if ( $?DISPLAY == 0 ) exit
if ( $SHLVL > 1 ) exit
setenv GDK_BACKEND x11

eval `dbus-launch --csh-syntax`

if ( $?DBUS_SESSION_BUS_PID == 0 ) exit
setsid -f /usr/libexec/dbus-1/dbus-kill-process-with-session $DBUS_SESSION_BUS_PID
