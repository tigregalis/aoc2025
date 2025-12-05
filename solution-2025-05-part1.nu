do {
|input?|
let data = if $input == null { aoc load 2025 5 } else { $input }
let prepared_data = $data 
| lines
| split list ""
| wrap temp 
| transpose temp ranges ids 
| reject temp 
| update ranges { parse "{start}-{end}" | update start { into int } | update end { into int } | each { ($in.start)..($in.end) } }
| update ids { into int }
| first
let ranges = $prepared_data.ranges
let ids = $prepared_data.ids
$ids
| where {
  |id|
  $ranges | any { $id in $in }
}
| length
}