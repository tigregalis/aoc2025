do {
aoc load 2025 2 | split row ,
| parse "{start}-{end}"
| par-each {
  ($in.start | into int)..($in.end | into int)
  | where {
    let s = $in | into string
    let len = $s | str length
    # number of pieces (at least two, up to `len`)
    2..([$len 2] | math max)
    # divisible, e.g. 9 divisible by 3 or 9
    | where { $len mod $in == 0 }
    | where {
      |pieces|
      let piece_length = $len / $pieces | into int
      let sub = $s | str substring 0..<($piece_length)
      let compare = (0..<($pieces) | each { $sub } | str join "")
      $compare == $s
    }
    | is-not-empty
  }
}
| flatten
| math sum
}