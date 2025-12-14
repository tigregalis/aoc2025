do {
|input?|
let corners = if $input == null { aoc load 2025 9 } else { $input }
| lines
| parse "{x},{y}"
| update cells { into int }
$corners
| drop
| enumerate
| flatten
| insert other {
  |it|
  $corners
  | skip ($it.index + 1)
  | insert area {
    ([$in.x $it.x] | sort | $in.1 - $in.0 + 1) * ([$in.y $it.y] | sort | $in.1 - $in.0 + 1)
  }
}
| flatten
| flatten
| get area
| math max
}