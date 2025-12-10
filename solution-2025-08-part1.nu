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
| first 1000
| reduce -f [] { |connection, circuits|
  print ($connection | select X Y Z)
  let found = $circuits | enumerate | where { |circuit| ($connection | select X Y Z) in $circuit.item or ($connection | select x y z | rename X Y Z) in $circuit.item }
  if ($found | is-empty) {
    $circuits
    | append [[($connection | select X Y Z) ($connection | select x y z | rename X Y Z)]]
    | each { uniq }
  } else if ($found | length) == 1 {
    let found0 = $found | first
    $circuits
    | update $found0.index (
        $found0.item
        | append [($connection | select X Y Z) ($connection | select x y z | rename X Y Z)]
    )
    | each { uniq }
  } else {
    $circuits
    | reject ...($found.index)
    | append [(($found.item | reduce { |item, merged| $merged | append $item }) | append [($connection | select X Y Z) ($connection | select x y z | rename X Y Z)])]
    | each { uniq }
   }
}
| sort-by { length }
| last 3
| each { length }
| math product
}