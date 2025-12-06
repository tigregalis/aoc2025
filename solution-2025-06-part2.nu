
do {
aoc load 2025 6
| lines 
| enumerate 
| each { |row| $row.item | split chars | wrap $"c($row.index)" } 
| reduce { |item, acc| $acc | merge $item }
| split list { $in | values | all { $in == " "} }
| each {
  |problem|
  $problem
  | select ...($problem | columns | drop)
  | each { values | str join '' | into int }
  | match ($problem.0 | get ($problem | columns | last)) {
      "+" => { $in | math sum }
      "*" => { $in | math product }
  }
}
| math sum
}