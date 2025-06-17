#import "@preview/lacy-ubc-math-project:0.2.0": *
// Import markscheme, including the box needed for marking
#import markscheme as m: markbox
// Import the common content.
#import "config.typ": *
#show: setup.with(
  number: 1,
  flavor: [A], // Don't want a flavor? Just remove this line.
  group: group-name,
  jane-doe,
  // Alex was not there, so we add an "(NP)" suffix.
  alex-conquitlam[(NP)],
  // If you just want all authors, instead write:
  // ..authors.values(),
)

// Here is your project content.
= The Problem

#qna(
  config: config,
  question(
    point: 5,
    [
      Hey, there's a cool math problem, let's solve it!
      // Encapsulate important visuals in figures,
      // so that they can be referenced later.
      #figure(
        // Include images from the assets folder.
        image(
          "assets/madeline-math.jpg",
          width: 80%,
          height: 25%,
          fit: "stretch",
        ),
        // Description.
        // Don't forget to give credit while using others' work.
        caption: [
          Madeline's math problem (image credit: #link("https://example.com")[Badeline]).
        ],
      )
    ],

    solution[
      #markbox(m.r(2))[You can do it.]
    ],
  ),
)

There is a #link("https://github.com/lace-wing/lacy-ubc-math-project")[GitHub repo] for this project, take a look at the #link("https://github.com/lace-wing/lacy-ubc-math-project/blob/master/manual.pdf")[manual] there!

