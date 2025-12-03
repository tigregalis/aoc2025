do {
|input|
let quota = 12
$input | lines | each { split row '' | skip | drop | each { into int } }
| each { |batteries|
  mut search = $batteries | enumerate
  mut found = []
  while ($found | length) < $quota {
    let remainder = $quota - ($found | length)
    # collapse to the smallest right-most search space of at least remainder size
    let to_search = $search
    let comparison = $found | insert after { |f| $to_search | where index > $f.index | length }
    let left_edge = try { $comparison | where after >= $remainder | get index | math max } catch { 0 }
    $search = $search | where index >= $left_edge
    let max_digit = $search | get item | math max
    let maxes = $search | where item == $max_digit
    let to_append = $maxes | first
    $found = $found | append $to_append
    $search = $search | where index != $to_append.index
  }
  let joltage = $found | sort-by index | get item | str join '' | into int | wrap joltage
  let bank = $batteries | str join '' | wrap bank
  $bank | merge $joltage
}
| get joltage
| math sum
} (aoc load 2025 3)