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
) = {
  let (target, supplement, main) = items
  func(
    ..args,
    target + supplement + main,
  )
}

#let config = (
  group: (
    name: [Group Name],
    authors: (
      jane-doe: author("Jane", "Doe", 31415926),
      alex-conquitlam: author(
        "Alex",
        "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}",
        27182818,
        strname: "Alex Coquitlam",
      ),
    ),
  ),
  question: (
    numbering: ("1.", "a.", "i."),
    labelling: ("1", "a", "i"),
    container: question-container,
  ),
  solution: (
    container: solution-container,
  ),
)
