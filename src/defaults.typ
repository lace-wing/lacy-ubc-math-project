/// The default question container. Produce a grid of 2 columns: the question number, and the question content.
///
/// - func (function): The original container function.
/// - args (dictionary): The original non-content arguments for the function.
/// - items (dictionary): Items that can show up as content.
/// -> content
#let question-container(
  func,
  args,
  items,
  config: (:),
) = {
  let (number, point, main) = items
  func(
    ..args,
    number,
    point + main,
  )
}

/// The default solution container. Produce a grid of 1 or 2 columns: the solution content, and optionally, the markings.
///
/// - func (function): The original container function.
/// - args (dictionary): The original non-content arguments for the function.
/// - items (dictionary): Items that can be used for output.
/// - markscheme (bool): Whether to enable the marking column.
/// - marking-width (length, relative, fraction, auto): A column width, for the markings.
/// -> content
#let solution-container(
  func,
  args,
  items,
  markscheme: false,
  marking-width: 7.2em,
  config: (:),
) = {
  let (target, supplement, main, marking, marking-extension) = items
  let bodies = target + supplement + main
  if markscheme {
    args += (columns: (100% - marking-width, marking-width))
    bodies = (
      bodies + marking-extension,
      grid.vline(stroke: config.solution.stroke-minor),
      marking(marking-width),
    )
  }
  func(
    ..args,
    ..(bodies,).flatten(),
  )
}

/// The default config.
#let config = (
  foreground: (
    color-major: black,
  ),
  background: (
    color-major: white,
  ),
  link: (
    color-major: blue.darken(30%),
  ),
  ref: (
    color-major: blue.darken(30%),
  ),
  question: (
    numbering: ("1.", "a.", "i."),
    labelling: ("1", "a", "i"),
    container: question-container,
    rule: body => body,
    color-major: black,
    color-minor: white,
    stroke-major: 0pt,
    stroke-minor: 0pt,
  ),
  solution: (
    container: solution-container,
    rule: body => body,
    color-major: black,
    color-minor: rgb(10%, 50%, 10%),
    stroke-major: 1pt + rgb(10%, 50%, 10%),
    stroke-minor: 1pt + rgb(10%, 50%, 10%).transparentize(50%),
  ),
)
