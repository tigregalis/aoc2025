do {
|input?|
let data = if $input == null { aoc load 2025 5 } else { $input }
$data 
| lines
| split list ""
| first
| each { parse "{start}-{end}" | update start { into int } | update end { into int } | first }
| sort-by end
| sort-by start
| reduce -f [] {
  |range, ranges| 
  let last_range = try { $ranges | last } catch { null }
  if $last_range == null {
    # first
    $ranges | append $range
  } else if $last_range.end? >= $range.start {
    # merge
    $ranges | drop | append { start: ([$last_range.start $range.start] | math min), end: ([$last_range.end $range.end] | math max) }
  } else {
    # append
    $ranges | append $range
  }
}
| each { $in.end - $in.start + 1 }
| math sum
}