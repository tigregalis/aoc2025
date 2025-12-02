def "aoc" [] { help aoc }

def "aoc name" [] { help aoc name }

# 
def "aoc name input" [year: int, day: int] {
  $"input-($year)-($day | fill -a r -w 2 -c 0)"
}
# 
def "aoc name solution" [year: int, day: int, part: int] {
  $"solution-($year)-($day | fill -a r -w 2 -c 0)-part($part).nu"
}

def "aoc save" [year: int, day: int, part: int] {
  let filename = aoc name solution $year $day $part
  if ($filename | path exists) {
    if (input --default y --numchar 1 "file already exists. continue? (y/n)") != y {
      return;
    }
  }
  history | last | get command | save --force $filename
  open $filename | nu-highlight
}

# Fetch input from adventofcode server using session key provided in the `session` file and save it as `input-{year}-{day}`
def "aoc fetch" [year: int, day: int] {
  # name of the file containing the session key is "session"
  let session = open session
  http get -H { Cookie: $"session=($session)" } $"https://adventofcode.com/($year)/day/($day)/input"
  | save --force (aoc name input $year $day)
}

# Fetch today's input if available
def "aoc fetch today" [] {
  let parts = date parts now
  aoc fetch $parts.year $parts.day
}

# Load already-fetched input
def "aoc load" [year: int, day: int] {
  if not (aoc name input $year $day | path exists) {
    aoc fetch $year $day
  }
  open (aoc name input $year $day)
}

# Load today's input if available
def "aoc load today" [] {
  let parts = date parts now
  aoc load $parts.year $parts.day
}

# Convert a datetime to its parts
def "date parts" []: datetime -> record<year: int, month: int, day: int, hour: int, minute: int, second: int> {
  format date "%Y-%m-%d %H:%M:%S" 
  | parse "{year}-{month}-{day} {hour}:{minute}:{second}" 
  | get 0  
  | items { 
    |key, value|
    { $key: ($value | into int) } 
  } 
  | reduce -f {} { 
    |item, acc|
    $acc | merge $item 
  }
}

# `date now | date parts`
def "date parts now" []: nothing -> record<year: int, month: int, day: int, hour: int, minute: int, second: int> {
  date now | date parts
}

def "aoc launch" [year: int, day: int] {
  start $"https://adventofcode.com/($year)/day/($day)"
}

def "aoc launch today" [] {
  let parts = date parts now
  aoc launch $parts.year $parts.day
}

def "aoc open" [year: int, day: int, part: int] {
  open (aoc name solution $year $day $part) | nu-highlight
}
