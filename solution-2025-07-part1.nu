do {
let data = aoc load 2025 7 | lines
let first_beam = $data | first | str index-of S
$data
| skip
| reduce -f { beams: [$first_beam], splits: 0 } {
  |space, acc|
  let new_beams = $acc.beams
  | each {
    |index|
    if ($space | str substring $index..$index) == "^" {
      { beams: [($index - 1) ($index + 1)], splits: 1 }
    } else {
      { beams: [$index], splits: 0 }
    }
  }
  let beams = $new_beams | get beams | flatten | uniq
  let new_splits = $new_beams | get splits | flatten | math sum
  let splits = $acc.splits + $new_splits
  { beams: $beams, splits: $splits }
}
| get splits
}