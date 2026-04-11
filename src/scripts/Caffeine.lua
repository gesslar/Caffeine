Caffeine = Caffeine or {
  glu = require("__PKGNAME__/Glu-single")("__PKGNAME__"),
  userName = getProfileName(),
  ping = function()
    local TN_IAC = 255
    local TN_NOP = 241
    local telnetSequence = string.char(TN_IAC, TN_NOP)

    sendSocket(telnetSequence)
  end
}

function Caffeine.main()
  Caffeine.prefs = Caffeine.glu.preferences.load("__PKGNAME__", "__PKGNAME__.settings.lua", {
    interval = 150, -- seconds, or 2.5 minutes
  })

  registerNamedEventHandler(
    Caffeine.userName,
    "caffeine:command",
    "caffeine:command",
    Caffeine.command
  )

  registerNamedEventHandler(
    Caffeine.userName,
    "caffeine:uninstall",
    "sysUninstall",
    function()
      deleteAllNamedEventHandlers(Caffeine.userName)
      deleteAllNamedTimers(Caffeine.userName)
      cecho("<brown>[__PKGNAME__]<r> Caffeine has been uninstalled.\n")
      Caffeine = nil
    end
  )

  Caffeine.startTimer()
end

function Caffeine.command(_, arg, arg2)
  if arg == "interval" then
    if arg2 <= 60 then arg2 = 60 end

    Caffeine.prefs.interval = arg2
    Caffeine.glu.preferences.save("__PKGNAME__", "__PKGNAME__.settings.lua", Caffeine.prefs)
    Caffeine.startTimer()
  end

  cecho("<brown>[__PKGNAME__]<r> Wake up call set for every " .. Caffeine.prefs.interval .. " seconds.\n")
end

function Caffeine.startTimer()
  Caffeine.stopTimer()

  registerNamedTimer(
    Caffeine.userName,
    "caffeine:timer",
    Caffeine.prefs.interval,
    Caffeine.ping,
    true
  )
end

function Caffeine.stopTimer()
  deleteNamedTimer(Caffeine.userName, "caffeine:timer")
end

Caffeine.main()
