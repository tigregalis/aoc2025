do {
|input?|
let data = if $input == null { aoc load 2025 4 } else { $input }
mut floor = $data | lines | each { split row '' | skip | drop }
let height = $floor | length
mut continue = true
mut removed = 0
$floor | each { print ($in | str join '') }
print "--*--"
while $continue {
let removed_before = $removed
let prev_floor = $floor
let updated_floor = $prev_floor
| enumerate
| par-each -k {
  |r|
  let y = $r.index
  let row = $r.item
  let width = $row | length
  let updated_row = $row | enumerate | par-each -k {
    |t|
    let x = $t.index
    let $tile = $t.item
    if $tile == @ {
      # print { x: $x, y: $y }
      let neighbours = ($y - 1)..($y + 1)
      | each { |y| ($x - 1)..($x + 1) | wrap x | insert y $y }
      | flatten
      | where { not ($in.y == $y and $in.x == $x) }
      let neighbours2 = $neighbours
      | where x >= 0
      | where x <= $width - 1
      | where y >= 0
      | where y <= $height - 1
      | each { |it| $prev_floor | get $it.y | get $it.x }
      let rolls = $neighbours2 | where { $in == @ } | length
      if $rolls < 4 { "x" } else { "@" }
    } else {
      $tile
    }
  }
  $updated_row
}
$updated_floor | each { print ($in | str join '') }
$removed = $updated_floor | flatten | flatten | where { $in == x } | length
print ($"--($removed)--")
if $removed_before == $removed { $continue = false }
$floor = $updated_floor
}
}