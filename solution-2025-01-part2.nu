do {
aoc load 2025 1 | lines | parse -r "(?<dir>L|R)(?<dist>\\d+)"
| insert shift { if $in.dir == R { $in.dist | into int } else { -1 * ($in.dist | into int) } }
| reduce -f [{ dial: 50 }] {
  |it, acc|
  let dial = $acc | last | get dial
  let old_dial_in_dir = if $it.shift < 0 and $dial > 0 { $dial - 100 } else { $dial }
  let new_dial = $old_dial_in_dir + $it.shift
  let clicks = $new_dial / 100 | math abs | math floor
  $acc | append {
    old_dial: $dial,
    old_dial_in_dir: $old_dial_in_dir,
    shift: $it.shift,
    new_dial: $new_dial,
    dial: ($new_dial mod 100),
    clicks: $clicks,
  }
}
| skip 1
| select old_dial old_dial_in_dir shift new_dial clicks dial
| get clicks | math sum
}