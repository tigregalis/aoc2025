do {
|input?|
let data = if $input == null { aoc load 2025 4 } else { $input }
let floor = $data | lines | each { split row '' | skip | drop | enumerate } | enumerate
$floor
| each {
  |row|
  $row.item 
  | where item == @ 
  | each {
    |roll|
    let x = $roll.index
    let y = $row.index
    let above = try { $floor | get ($y - 1) | get item | where { $in.index in ($x - 1)..($x + 1) } | where item == @ | length } catch { 0 }
    let below = try { $floor | get ($y + 1) | get item | where { $in.index in ($x - 1)..($x + 1) } | where item == @ | length } catch { 0 }
    let left = $row.item | where index == $x - 1 | where item == @ | length
    let right = $row.item | where index == $x + 1 | where item == @ | length
    [$above $below $left $right] | math sum
  }
  | where { $in < 4 }
  | length
}
| math sum
}