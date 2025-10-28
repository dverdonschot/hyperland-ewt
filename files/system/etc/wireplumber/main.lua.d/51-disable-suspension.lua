-- Disable audio device suspension to prevent audio dropout
-- This fixes issues where audio stops after periods of silence
-- Applies to both USB audio devices (like DECT headsets) and Bluetooth

-- Prevent all ALSA devices (including USB audio) from suspending
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "alsa_output.*" },
    },
  },
  apply_properties = {
    ["session.suspend-timeout-seconds"] = 0,  -- never suspend
    ["api.alsa.period-size"] = 1024,          -- optimize for USB audio
    ["api.alsa.headroom"] = 2048,             -- extra buffer for USB devices
  },
})

-- Also handle USB audio input devices (microphones, headsets)
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "alsa_input.*" },
    },
  },
  apply_properties = {
    ["session.suspend-timeout-seconds"] = 0,
    ["api.alsa.period-size"] = 1024,
    ["api.alsa.headroom"] = 2048,
  },
})

-- Prevent Bluetooth devices from suspending
table.insert(bluez_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "bluez_card.*" },
    },
  },
  apply_properties = {
    ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink ]",
    ["session.suspend-timeout-seconds"] = 0,
  },
})
