-- Bluetooth audio codec configuration
-- Prioritize high-quality codecs for better audio experience

bluez_monitor.properties = {
  -- Enable all available Bluetooth profiles
  ["bluez5.enable-sbc-xq"] = true,
  ["bluez5.enable-msbc"] = true,
  ["bluez5.enable-hw-volume"] = true,

  -- Codec preferences (higher number = higher priority)
  -- LDAC (990kbps) > aptX HD (576kbps) > aptX (352kbps) > AAC > SBC
  ["bluez5.codecs"] = "[ ldac aptx_hd aptx_ll aptx aac sbc sbc_xq ]",

  -- Roles for auto-connect
  ["bluez5.roles"] = "[ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]",

  -- Headset head unit (HSP/HFP) properties
  ["bluez5.hfphsp-backend"] = "native",
}
