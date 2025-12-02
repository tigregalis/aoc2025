do {
aoc load 2025 2 | split row ,
| parse "{start}-{end}"
| each {
  ($in.start | into int)..($in.end | into int)
  | where {
    let s = $in | into string
    let len = $s| str length
    if $len mod 2 == 0 {
      let first = $s | str substring 0..<($len / 2 | into int)
      let second = $s | str substring ($len / 2 | into int)..<$len
      $first == $second
    } else {
      false
    }
  }
}
| flatten
| math sum
}