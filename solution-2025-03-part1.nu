do {
aoc load 2025 3 | lines | each { split row '' | skip | drop | each { into int } }
| each { |batteries|
  # the max digit is always part of the result
  let max_digit = $batteries | math max
  let bank = $batteries | str join '' | wrap bank
  let maxes = $batteries | enumerate | where item == $max_digit
  let joltage = if ($maxes | length) >= 2 {
    # if max appears at least twice, double the digit
    $max_digit * 10 + $max_digit
  } else if ($maxes.0.index != ($batteries | length) - 1) { # 
    # there is only one occurrence and it is not at the end, so search to the right
    let right_digit = $batteries | slice ($maxes.0.index + 1).. | math max
    $max_digit * 10 + $right_digit
  } else {
    # there is only one occurrence and it is at the end, so search to the left
    let left_digit = $batteries | slice 0..($maxes.0.index - 1) | math max
    $left_digit * 10 + $max_digit
  } | wrap joltage
  $bank | merge $joltage
}
| get joltage
| math sum
}