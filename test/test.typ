#import "@preview/lacy-ubc-math-project:0.2.0": *
#import unsafe: * //DEBUG
#import "config.typ"
#show: setup.with(
  project: "test proj",
  author("Jane", "Doe", 12345678),
)

// #let solution = solution.with(supplement: [*Solution: *])

#import markscheme as m: markbox

#qna-wrapper(
  config: (
    solution: (
      container: defaults.solution-container.with(markscheme: true),
    ),
  ),
  [some preface],
  question(
    [factorize $x^2 - 5x - 6$.],
    solution(
      [
        #markbox(lorem(5), m.m(1))

        $
          markbox(
            (x + 6)(x + 1),
            #m.a(1), #m.a(0)
          )
        $
        #markbox($ m^2 a_3 log(t) va(h) $, m.c(0))
        #markbox(lorem(24), m.a(1), m.ft(lorem(6)))
        #markbox(lorem(20), m.na[bunch-o-nonsense])
      ],

      solution(
        [
          $
            markbox(
              (x + 6)(x + 1),
              #m.a(1), #m.a(0)
            )
          $
          and a solution inside a solution],
        solution[
          #markbox($ m^2 a_3 log(t) va(h) $, m.c(0))
        ],
      ),
    ),

    question(
      point: 1,
      [some sub-question],

      solution(
        target: <qs:1-a>,
        target-display: [guess who's not solved? you!],
        label: "you",

        solution(target: none)[yet another solution inside a solution, but forced to have no target by
          ```typc
          target: none
          ```
        ],
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
    solution(target: <qs:1>)[some solution. I also ref @qs:1-a and @wut[wut]],
  ),
)

#outline(title: [Q&A], target: figure.where(kind: spec.question.kind).or(figure.where(kind: spec.solution.kind)))

