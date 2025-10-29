#!/bin/sh
# Enable hardware video acceleration for Firefox and other browsers
# This enables VA-API support for video playback on Wayland

# Enable VA-API hardware acceleration in Firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_DBUS_REMOTE=1

# Force enable hardware acceleration
export MOZ_X11_EGL=1
export MOZ_WEBRENDER=1
