#import "@preview/lacy-ubc-math-project:0.2.0": *
#import unsafe: * //DEBUG
#import "config.typ"
// #show: setup.with(
//   project: "test proj",
//   author("Jane", "Doe", 12345678),
// )

#show "42": [*42*]

#let solution = solution.with(supplement: [*Solution: *])

#qna-wrapper(
  config: (:),

  [some preface],
  question(
    [some question $ a x + b y + c z = d. $],
    solution(
      [some solution],
      solution(solution[...inside a solution])[and a solution inside a solution],
      solution(target: none)[yet another solution inside a solution, but forced to have no target by
        ```typc
        target: none
        ```
      ],
    ),

    question(
      point: 1,
      [some sub-question],

      solution(
        target: <qs:1-a>,
        target-display: [guess who's not solved? you!],
        label: "you",
      )[some solution to a sub-question, ref it by `@sn:you`: @sn:you],

      question[yet another @qs:1-a-i],
    ),
    [some content],
    question(
      point: 6,
      [yet another sub-question],
    ),
  ),
  [some mayonnaise],
  feeder(
    table,
    columns: (1fr,) * 2,
    table.header([This], [That]),

    solution(label: <fed>)[some solution fed into a table that refs itself: @fed by `@fed`],
    question(
      label: <unusual-label>,
      [the answer?],
      solution[42],
    ),
    solution(supplement: [*Hey, it's me!*\ ])[some solution fed to a table],
  ),
  question(
    label: <wut>,
    [some question],
    solution(target: <qs:1>)[some solution. I also ref @qs:1-a and @wut],
  ),
)

#outline(title: [Q&A], target: figure.where(kind: spec.question.kind).or(figure.where(kind: spec.solution.kind)))

