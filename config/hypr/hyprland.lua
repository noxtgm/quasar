local home = os.getenv("HOME") or ""
package.path = home .. "/.config/?.lua;" .. package.path

require("hypr.environment")
require("hypr.monitors")
require("hypr.input")
require("hypr.looknfeel")
require("hypr.bindings")
require("hypr.rules")
require("hypr.autostart")
