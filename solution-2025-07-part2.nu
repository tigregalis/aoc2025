
do {
let data = aoc load 2025 7 | lines
let first_beam = $data | first | str index-of S | { $in: 1 }
$data
| skip
| reduce -f $first_beam {
  |space, beams|
  $beams
  | columns
  | each { into int }
  | each {
    |index|
    let timelines = $beams | get $"($index)"
    if ($space | str substring $index..$index) == "^" {
      { ($index - 1): $timelines, ($index + 1): $timelines }
    } else {
      { ($index): $timelines }
    }
  }
  | reduce { |it, acc| [$acc $it] | math sum }
}
| values
| math sum
}