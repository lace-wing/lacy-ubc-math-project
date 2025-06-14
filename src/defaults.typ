#import "components.typ": author

#let default-container(
  func,
  args,
  ..bodies,
) = {
  func(
    ..args,
    ..bodies,
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
    container: default-container,
  ),
  solution: (
    container: default-container,
  ),
)
