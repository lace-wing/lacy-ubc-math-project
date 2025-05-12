#import "@preview/lacy-ubc-math-project:0.2.0": *
#show: setup.with(
  project: "test proj",
  author("Jane", "Doe", 12345678),
)

#show ref: set text(red)

#let qs = question[
  #solution[
    some solution
  ]

  layer 1

  #question[
    layer 2

    #question()[
      layer 3
    ]
  ]
]

#qs

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
