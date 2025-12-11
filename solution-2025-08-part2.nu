do {
let boxes = aoc load 2025 8
| lines
| each { parse "{X},{Y},{Z}" }
| flatten
| update X { into int }
| update Y { into int }
| update Z { into int }

$boxes
| drop
| enumerate
| flatten
| insert temp { 
  |it| 
  $boxes 
  | skip ($it.index + 1) 
  | insert dist_sq {
    [($it.X - $in.X) ($it.Y - $in.Y) ($it.Z - $in.Z)] 
    | each { $in * $in } 
    | math sum
  }
  | rename x y z
}
| reject index
| flatten
| flatten
| sort-by dist_sq
| reduce -f {continue: true, data: []} { |connection, circuits|
  if not $circuits.continue { return $circuits }
  let found = $circuits.data | enumerate | where { |circuit| ($connection | select X Y Z) in $circuit.item or ($connection | select x y z | rename X Y Z) in $circuit.item }
  let new_circuits = if ($found | is-empty) {
    $circuits.data
    | append [[($connection | select X Y Z) ($connection | select x y z | rename X Y Z)]]
    | each { uniq }
  } else if ($found | length) == 1 {
    let found0 = $found | first
    $circuits.data
    | update $found0.index (
        $found0.item
        | append [($connection | select X Y Z) ($connection | select x y z | rename X Y Z)]
    )
    | each { uniq }
  } else {
    $circuits.data
    | reject ...($found.index)
    | append [(($found.item | reduce { |item, merged| $merged | append $item }) | append [($connection | select X Y Z) ($connection | select x y z | rename X Y Z)])]
    | each { uniq }
  }
  if ($new_circuits | length) == 1 and ($new_circuits | get 0 | length) == ($boxes | length) { { continue: false, data: $connection } } else { { continue: true, data: $new_circuits } }
}
| get data
| select X x
| values
| math product
}