# Caffeine — Implementation Notes

Technical details for anyone hacking on Caffeine or curious about what
it's actually doing on the wire.

## The keepalive

On each timer tick Caffeine writes two bytes directly to the game
socket via Mudlet's `sendSocket`:

| Byte | Decimal | Name  | Meaning              |
| ---- | ------- | ----- | -------------------- |
| 0xFF | 255     | `IAC` | Interpret As Command |
| 0xF1 | 241     | `NOP` | No Operation         |

This is the standard telnet `IAC NOP` sequence from
[RFC 854](https://www.rfc-editor.org/rfc/rfc854). Compliant telnet
servers should silently discard it, so in most cases nothing is
echoed and no command is executed — and the bytes traverse the
network path, which tends to reset idle timers along the way
(NATs, stateful firewalls, load balancers, and the MUD's own idle
disconnect). Results will vary depending on how each hop is
configured.

## Default interval

The default of **150 seconds** sits comfortably under the 5-minute
idle window that most consumer-grade NATs and stateful firewalls
enforce. The command handler clamps any user-supplied interval to a
minimum of **60 seconds** to avoid flooding.

## Persistence

Preferences are loaded and saved via
[Glu](https://github.com/gesslar/Glu)'s `preferences` module, backed
by a `Caffeine.settings.lua` file in the package profile. Changes to
the interval persist across Mudlet restarts.

## Lifecycle

- **Install / load** — `Caffeine.main()` runs, loads preferences,
  registers event handlers, and starts the timer.
- **Uninstall** — a `sysUninstall` handler scoped to this package
  tears down all named event handlers and named timers, prints a
  confirmation, and nils out the global.

All handlers and timers are registered under a namespaced `userName`
so teardown is a clean `deleteAllNamedEventHandlers` /
`deleteAllNamedTimers` call — no leaks into other packages.

## Command flow

The aliases raise a `caffeine:command` event, which is handled by
`Caffeine.command`. Setting a new interval writes preferences to disk
and calls `Caffeine.startTimer()`, which stops the existing named
timer before registering a new one — safe to call repeatedly.

## Building

Caffeine is packaged for Mudlet using
[Muddy](https://www.npmjs.com/package/@gesslar/muddy). From the repo
root:

```bash
# Build a distributable .mpackage
npm run build

# Rebuild on source changes
npm run watch
```

The build pulls sources from `src/` — `scripts/`, `aliases/`, and
`resources/` (icon, bundled `Glu-single.lua`) — and produces a Mudlet
package archive.

## Project layout

```text
src/
├── aliases/          # User-facing command aliases
│   ├── aliases.json
│   ├── Caffeine.lua
│   └── Caffeine_Interval.lua
├── resources/        # Bundled assets
│   ├── coffee-bean.png
│   ├── coffee-bean.svg
│   └── Glu-single.lua
└── scripts/          # Package logic
    ├── Caffeine.lua
    └── scripts.json
```
