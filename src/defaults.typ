#import "components.typ": author

#let question-container(
  func,
  args,
  items,
) = {
  let (number, point, main) = items
  func(
    ..args,
    number,
    point + main,
  )
}

#let solution-container(
  func,
  args,
  items,
  markscheme: false,
) = {
  let (target, supplement, main, marking) = items
  let bodies = (target + supplement + main,)
  if markscheme {
    args += (columns: (100% - 7.2em, 7.2em))
    bodies += (marking(),)
  }
  func(
    ..args,
    ..bodies,
  )
}

#let config = (
  colors: (
    foreground: black,
    background: white,
    solution: (
      major: rgb(10%, 40%, 10%),
    ),
  ),
  question: (
    numbering: ("1.", "a.", "i."),
    labelling: ("1", "a", "i"),
    container: question-container,
    rule: body => body,
  ),
  solution: (
    container: solution-container,
    rule: body => body,
  ),
)
