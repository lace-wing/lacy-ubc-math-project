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
  marking-width: 7.2em,
  // marking-extension: linebreak()//context v(measure(linebreak()).height * 0.9)
) = {
  let (target, supplement, main, marking, marking-extension) = items
  let bodies = target + supplement + main
  if markscheme {
    args += (columns: (100% - marking-width, marking-width))
    bodies = (bodies + marking-extension, marking(marking-width))
  }
  func(
    ..args,
    ..(bodies,).flatten(),
  )
}

#let config = (
  colors: (
    foreground: black,
    background: white,
    solution: (
      major: rgb(10%, 40%, 10%),
    ),
    link: blue.darken(30%),
    ref: blue.darken(30%),
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
