#import "@preview/lacy-ubc-math-project:0.2.0": *
#show: setup.with(
  project: "test proj",
  author("Jane", "Doe", 12345678),
)

#import unsafe: *

= Read the Friendly Manual

#{
  let grown = grow-branches(
    (
      [some preface],
      question(
        [some question $ a x + b y + c z = d. $],
        solution[some solution],

        question(
          point: 1,
          [some sub-question],

          solution(
            target: (1, 2),
            target-display: [guess who's not solved? you!],
            label: "you",
          )[some solution to a sub-question, ref it by `@sn:you`: @sn:you],
        ),
        [some content],
        question(
          point: 6,
          [yet another sub-question],
        ),
      ),
      [some mayonnaise],
      question(
        [some question $section 42$ do not answer.],
        solution(target: (1,))[some solution. also @qs:1-a],
      ),
    ),
    (),
  ).first()

  visualize-branches(grown).join()
}

#outline(title: [Q&A], target: figure.where(kind: spec.question.kind).or(figure.where(kind: spec.solution.kind)))

#pagebreak()

/*
#question[
  `@qs:2-a-i`
  @qs:2-a-i

  #question[
    `@qs:2-a`
    @qs:2-a

    #question(2)[
      `@qs:2`
      @qs:2
    ]
  ]
]

#question[
  `@qs:2-a`
  @qs:2-a

  #question[
    `@qs:2-a`
    @qs:2-a

    #question(3)[
      `@qs:2-a`
      @qs:2-a
    ]

    #question(2)[
      `@qs:2-a-i`
      @qs:2-a-i
    ]
  ]

  #question(1)[
    `@qs:2-a`
    @qs:2-a

    #question(1)[
      `@qs:2-a`
      @qs:2-a
    ]

    #question()[
      `@qs:2-a-i[Some]`
      @qs:2-a-i[Some]
    ]
  ]
]

#question(1, p => [see, it's worth #p, `p => [see, it's worth #p]`])[
  `@qs:3[Qs 3]`
  @qs:3[Qs 3]
]

`@qs:2-a-ii`
@qs:2-a-ii
