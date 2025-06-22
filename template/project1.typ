#import "@preview/lacy-ubc-math-project:0.2.0": *
// Import markscheme, including the box needed for marking
#import markscheme as m: markit
// Import the user config, including author information.
#import "config.typ": *

#set page(foreground: m.foreground-marking)

#show: setup.with(
  number: 1,
  flavor: [A], // Don't want a flavor? Just remove this line.
  group: group-name,
  // In config.typ, we set up these author information.
  jane-doe,
  // Say, Alex was not participating, so we add an "(NP)" suffix.
  alex-conquitlam[(NP)],
)

// Below is your project content.

= The Problem

#qns(
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

    solution(label: "fair", config: config)[
      #markit(m.r(2))[
        You can do it. By this reasoning I get 2 points, and I am labeled ```typ <sn:fair>```!
      ]
    ],
  ),
  question(
    [
      I do not have a point myself, but my sub-question have point, and I get the sum of theirs!
    ],
    question(
      point: 1,
      [The point is...],
      solution(
        [
          ...that you try solving @qs:1 (```typ @qs:1```), learn something along the way.
        ],
        question(
          point: 99,
          [
            I am worth 99 points, but my parent question had explicitly stated that it is worth 1 point.
          ],
          solution[
            The marking of @sn:fair[that] (```typ @sn:fair[that]```) sure sounds fair.
          ],
        ),
      ),
    ),
    question(
      [
        Take a look at the #link("https://github.com/lace-wing/lacy-ubc-math-project/blob/master/manual.pdf")[manual] there if you are lost or want advanced stuff!
      ],
      solution[
        $
          #markit(m.a(0), m.c(0), $42$) #<eq:me>
        $
      ],
    ),
  ),
)

