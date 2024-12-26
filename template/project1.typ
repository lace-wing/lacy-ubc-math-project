#import "@local/ubc-math-group-project:0.1.0": *
// Import the common content.
#import "common.typ": *
#show: setup.with(
  number: 1,
  flavor: [A],
  group: group-name,
  authors.jane-doe,
  // If you just want all authors, instead write:
  // ..authors.values(),
)

// Here is your project content.
= The Problem
Hey there's a cool math problem, let's solve it!

#question(5)[
  A cool math problem.

  // Import the drawing module for drawing abilities.
  #import drawing: *
  // Example
  #figure(
    caption: [A cool figure.],
    cetz.canvas({
      import cetz.draw: *
      import cetz-plot: *
      plot.plot(
        size: (4, 4),
        axis-style: none,
        name: "path",
        {
          plot.add-anchor("left", (-1, 0))
          plot.add(
            domain: (-1, 1),
            x => -calc.root(x, 3),
            style: (stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
          )
        },
      )
      set-origin("path.left")
      group({
        rotate(90deg)
        cylinder((0, 0), (2, 1), 4cm, fill-side: blue.transparentize(90%), fill-top: blue.transparentize(80%))
      })
    }),
  )

  #solution[
    You can do it.
  ]
]

// Use help.<section> to get help.
#help.getting-started
#help.setup
#help.math
#help.author
#help.question
#help.solution
#help.caveats

