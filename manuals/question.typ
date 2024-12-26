#import "../format.typ": question, __question-counters

= Question
The `question()` function is to create a question block.
#block(
  breakable: false,
  grid(
    columns: 2,
    align: horizon,
    ```typst
    #question(4)[
      The question.
      #question(2)[
        Sub-question.
      ]
      #question(0)[
        Another sub-question.
        #question(1)[
          Sub-sub-question.
        ]
        #question(1)[
          Another sub-sub-question.
        ]
      ]
    ]
    #question[2 points, -2 if wrong][
      The risky bonus question.
    ]
    ```,
    [
      // #__question-counters.at(0).update(1)
      // #question(4)[
      //   The question.
      //   #question(2)[
      //     Sub-question.
      //   ]
      //   #question(0)[
      //     Another sub-question.
      //     #question(1)[
      //       Sub-sub-question.
      //     ]
      //     #question(1)[
      //       Another sub-sub-question.
      //     ]
      //   ]
      // ]
      // #question[2 points, -2 if wrong][
      //   The risky bonus question.
      // ]
    ],
  ),
)

Questions can be referenced by their automatically assigned labels. For example, question 1.b.ii has label `<qs:1-b-ii>` and can be referenced by `#link(<qs:1-b-ii>)[That question]`. Note that it cannot be referenced by `@qs:1-b-ii`.
If, for some reason, questions with the same numbering occurs multiple times, a number indicating order of occurrence will be appended to the label. For example, the first 1.b.ii will be labeled `<qs:1-b-ii>`, and the second occurrence of numbering will have label `<qs:1-b-ii_2>`.
