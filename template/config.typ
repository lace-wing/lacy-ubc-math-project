#import "@preview/lacy-ubc-math-project:0.2.0": author, defaults

#let group-name = [Please name your group.]

#let jane-doe = author("Jane", "Doe", 12345678)
#let alex-conquitlam = author(
  "Alex",
  "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}",
  99999999,
  ascii: "Alex Coquitlam",
)

// Feel free to add more common content here.
// #let the-thing = "The thing."


#let config = (
  solution: (
    container: defaults.solution.container.with(markscheme: true),
  ),
)
