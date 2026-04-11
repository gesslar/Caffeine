# Caffeine

Send a keepalive message every ~150,000,000,000,000 picoseconds.

For the nerds out there, the keepalive is just sending `IAC NOP`.

## What it does

Caffeine helps keep your MUD session from being dropped while you're idle.
Every couple of minutes it quietly pokes the connection so your router,
firewall, or the MUD itself doesn't decide you've wandered off and cut
you loose. Nothing is printed, nothing is sent in-game — you won't see
a thing.

## Usage

| Alias           | What it does                                       |
| --------------- | -------------------------------------------------- |
| `/caffeine`     | Show how often the keepalive is being sent.        |
| `/caffeine <N>` | Send the keepalive every `N` seconds (minimum 60). |

The default is every **150 seconds** (2.5 minutes), which is frequent
enough to beat most idle timeouts. Your setting is remembered between
Mudlet sessions.

## License

`caffeine` is released under the [0BSD](LICENSE.txt).

---

Curious how it works under the hood? See [IMPLEMENTATION.md](IMPLEMENTATION.md).
