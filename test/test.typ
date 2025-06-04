#import "@preview/lacy-ubc-math-project:0.2.0": *
#show: setup.with(
  project: "test proj",
  author("Jane", "Doe", 12345678),
)

#show ref: set text(red)

#import unsafe: *

= Read the Friendly Manual

#{
  let grown = grow-branches(
    (
      [some preface],
      question(
        [some question],
        [some math eqs],
        solution[some solution],

        question(
          point: 1,
          [some sub-question],

          solution[some solution to a sub-question],
        ),
        [some content],
        question(
          point: 6,
          [yet another sub-question],
        ),
      ),
      [some mayonnaise],
      question(
        [some question],
        [some math eqs],
        solution[some solution @qs:1-a],
      ),
    ),
    (),
  ).first()

  visualize-branches(grown).join()
}

#outline(title: [Questions], target: figure.where(kind: spec.question.kind))

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
