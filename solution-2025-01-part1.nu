do {
aoc load 2025 1 | lines | parse -r "(?<dir>L|R)(?<dist>\\d+)"
| insert shift { if $in.dir == R { $in.dist | into int } else { -1 * ($in.dist | into int) } }
| reduce -f [{ dial: 50 }] {
  |it, acc|
  let dial = (($acc | last | get dial) + $it.shift) mod 100
  $acc | append { dial: $dial } }
| where dial == 0
| length
}