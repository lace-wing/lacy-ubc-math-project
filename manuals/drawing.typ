#import "../drawing.typ": *

= Drawing
As we are doing math, inevitably we will need to draw some graphs.
Typst has some native drawing abilities, but they are very limited.
There is an ad hoc Typst drawing library, a package actually, called "cetz", with its graphing companion "cetz-plot".
Simply
```typst
#import drawing: *
```
to let the template import them for you.

For general drawing techniques, refer to the #link("https://cetz-package.github.io/docs/")[cetz documentation].
For graphing, download and refer to the #link("https://github.com/cetz-package/cetz-plot/blob/stable/manual.pdf?raw=true")[cetz-plot manual].

There are other drawing packages available, but not imported by this template, here is a brief list:
- #link("https://staging.typst.app/universe/package/fletcher")[fletcher]: nodes & arrows;
- #link("https://staging.typst.app/universe/package/jlyfish")[jlyfish]: Julia integration;
- #link("https://staging.typst.app/universe/package/neoplot")[neoplot]: Gnuplot integration.

Find more visualization packages #link("https://staging.typst.app/universe/search/?category=visualization&kind=packages")[here].

== Template Helpers
Besides importing the drawing packages, the `drawing` module also provides some helper functions.

For example, the `cylinder()` function draws an upright no-perspective cylinder.
#block(
  breakable: false,
  grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    align: horizon,
    [
      ```typst
      #cetz.canvas({
        import cetz.draw: *
        group({
          rotate(30deg)
          cylinder(
            (0, 0), // Center
            (1.618, .6), // Radius: (x, y)
            2cm / 1.618, // Height
            fill-top: maroon.lighten(5%), // Top color
            fill-side: blue.transparentize(80%), // Side color
          )
        })
      })
      ```
    ],
    cetz.canvas({
      import cetz.draw: *
      group({
        rotate(30deg)
        cylinder(
          (0, 0), // Center
          (1.618, .6), // Radius: (x, y)
          2cm / 1.618, // Height
          fill-top: maroon.lighten(5%), // Top color
          fill-side: blue.transparentize(80%), // Side color
        )
      })
    }),
  ),
)
