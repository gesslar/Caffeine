local packageName = "__PKGNAME__"
local settingsFile = packageName .. ".settings.lua"
local userName = packageName

Caffeine = Caffeine or {
  glu = require(packageName .. "/Glu-single")(packageName),
  ping = function()
    local TN_IAC = 255
    local TN_NOP = 241
    local telnetSequence = string.char(TN_IAC, TN_NOP)

    sendSocket(telnetSequence)
  end
}

function Caffeine.main()
  Caffeine.prefs = Caffeine.glu.preferences.load(packageName, settingsFile, {
    interval = 150, -- seconds, or 2.5 minutes
  })

  registerNamedEventHandler(
    userName,
    "caffeine:command",
    "caffeine:command",
    Caffeine.command
  )

  registerNamedEventHandler(
    userName,
    "caffeine:uninstall",
    "sysUninstall",
    function(_, pkg)
      if pkg ~= packageName then return end

      deleteAllNamedEventHandlers(userName)
      deleteAllNamedTimers(userName)

      cecho("<brown>[" .. packageName .. "]<r> Caffeine has been uninstalled.\n")

      Caffeine = nil
    end
  )

  Caffeine.startTimer()
end

function Caffeine.command(_, arg, arg2)
  if arg == "interval" then
    if arg2 <= 60 then arg2 = 60 end

    Caffeine.prefs.interval = arg2
    Caffeine.glu.preferences.save(packageName, settingsFile, Caffeine.prefs)
    Caffeine.startTimer()
  end

  cecho("<brown>[" .. packageName .. "]<r> Wake up call is set for every " .. Caffeine.prefs.interval .. " seconds.\n")
end

function Caffeine.startTimer()
  Caffeine.stopTimer()

  registerNamedTimer(
    userName,
    "caffeine:timer",
    Caffeine.prefs.interval,
    Caffeine.ping,
    true
  )
end

function Caffeine.stopTimer()
  deleteNamedTimer(userName, "caffeine:timer")
end

Caffeine.main()
