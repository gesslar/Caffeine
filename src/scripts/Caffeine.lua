local glu = require("__PKGNAME__/vendor/Glu-single")("__PKGNAME__")
local settingsFile = "__PKGNAME__.settings.lua"

__PKGNAME__ = __PKGNAME__ or {
  ping = function()
    local TN_IAC = 255
    local TN_NOP = 241
    local telnetSequence = string.char(TN_IAC, TN_NOP)

    sendSocket(telnetSequence)
  end
}

function __PKGNAME__.main()
  __PKGNAME__.prefs = glu.preferences.load("__PKGNAME__", settingsFile, {
    interval = 150, -- seconds, or 2.5 minutes
  })

  registerNamedEventHandler(
    "__PKGNAME__",
    "__PKGNAME__:command",
    "__PKGNAME__:command",
    __PKGNAME__.command
  )

  registerNamedEventHandler(
    "__PKGNAME__",
    "__PKGNAME__:install",
    "sysInstall",
    function(_, pkg)
      if pkg ~= "__PKGNAME__" then return end

      cecho("<brown>[__PKGNAME__]<r> Thank you for installing __PKGNAME__.\n")
    end
  )

  registerNamedEventHandler(
    "__PKGNAME__",
    "__PKGNAME__:uninstall",
    "sysUninstall",
    function(_, pkg)
      if pkg ~= "__PKGNAME__" then return end

      deleteAllNamedEventHandlers("__PKGNAME__")
      deleteAllNamedTimers("__PKGNAME__")

      cecho("<brown>[__PKGNAME__]<r> __PKGNAME__ has been uninstalled.\n")

      __PKGNAME__ = nil
    end
  )

  __PKGNAME__.startTimer()
end

function __PKGNAME__.command(_, arg, arg2)
  if arg == "interval" then
    if arg2 <= 60 then arg2 = 60 end

    __PKGNAME__.prefs.interval = arg2
    glu.preferences.save("__PKGNAME__", settingsFile, __PKGNAME__.prefs)
    __PKGNAME__.startTimer()
  end

  cecho("<brown>[__PKGNAME__]<r> Wake up call is set for every " .. __PKGNAME__.prefs.interval .. " seconds.\n")
end

function __PKGNAME__.startTimer()
  __PKGNAME__.stopTimer()

  registerNamedTimer(
    "__PKGNAME__",
    "__PKGNAME__:timer",
    __PKGNAME__.prefs.interval,
    __PKGNAME__.ping,
    true
  )
end

function __PKGNAME__.stopTimer()
  deleteNamedTimer("__PKGNAME__", "__PKGNAME__:timer")
end

__PKGNAME__.main()
