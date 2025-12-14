Ensure you have [nushell](https://www.nushell.sh/).

Log into [Advent of Code](adventofcode.com), open developer tools (F12) and get and save the value of the session cookie as a `session` file. For example:

```nu
open "session" | str substring 0..<8
# 53616c74
```

In each new nushell terminal session, include the helper code:

```nu
source "aoc.nu"
```

View the available helper commands:

```nu
aoc --help # or `help aoc`
```

Launch the default browser (or rather, URL handler) to the website for that day.

```nu
# aoc launch {year} {day}
aoc launch 2025 1
```

Load the input data for that day (it will load from an `input-{year}-{day}` file, or if it doesn't exist yet, it will fetch it using the `session`).

```nu
# aoc load {year} {day}
aoc load 2025 1
```

Or if you just want to download the input file (e.g. if you're solving in another language).

```nu
# aoc fetch {year} {day}
aoc fetch 2025 1
# will be saved as `input-{year}-{day}`
```

Display my nushell solution.

```nu
# aoc open {year} {day} {part}
aoc open 2025 1 1
```

Save your nushell solution (takes the last-run command with `aoc load` in it, and will overwrite mine).

```nu
# aoc save {year} {day} {part}
aoc save 2025 1 1
```
