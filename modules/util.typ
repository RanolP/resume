#let belonging(role, organization) = [#role #text(weight: 400)[\@] #organization]

#let enumerate(entries) = grid(
  columns: entries.len(),
  rows: (auto, auto),
  column-gutter: 10pt,
  row-gutter: 3pt,
  ..(
    for (first, _) in entries {
      (align(center)[#first],)
    }
  ),
  ..(
    for (_, second) in entries {
      (align(center)[#second],)
    }
  ),
)

#let format-thousand(n) = {
  let len = str(n).len()
  for (i, c) in str(n).codepoints().enumerate() {
    if i != 0 and calc.rem((len - i), 3) == 0 {
      ","
    }
    c
  }
}
