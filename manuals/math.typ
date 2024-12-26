#import "@preview/physica:0.9.4": *
#show: super-T-as-transpose // Render "..^T" as transposed matrix
#import "@preview/equate:0.2.1": *
#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

= Math
Formatting math equations is probably the reason you are here.
Unlike LaTex, math in Typst is simple.
#let eqs = (
  "E = m c^2",
  "e^(i pi) = -1",
  "x = (-b plus.minus sqrt(b^2 - 4a c)) / (2a)",
)
#table(
  columns: 2,
  align: (x, y) => (right, left).at(calc.rem(x, 2)),
  stroke: (x, y) => if x == 0 { (right: 0.5pt) },
  ..eqs
    .map(eq => {
      (
        table.cell(raw("$" + eq + "$", lang: "typst", block: true)),
        table.cell(std.eval(eq, mode: "math")),
      )
    })
    .flatten(),
)

For "block" or "display" math, leave a space or newline between the dollar sign and the equations.
```typst
$ E = m c^2 $
```
$ E = m c^2 $

Documented are built-in #link("https://staging.typst.app/docs/reference/math/")[math functions] and #link("https://staging.typst.app/docs/reference/symbols/sym/")[symbols]

== Numbering and Referencing Equations
Note that you must enable equation numbering to reference equations, which is set by this template.
#block(
  breakable: false,
  grid(
    columns: (2fr, 3fr),
    align: horizon,
    ```typst
    $
      e^(i pi) = -1 #<euler>
    $
    @euler is Euler's identity. \
    #link(<euler>)[This] is the same thing.
    ```,
    [
      $
        e^(i pi) = -1 #<euler>
      $
      @euler is Euler's identity. \
      #link(<euler>)[This] is the same thing.
    ],
  ),
)

== Extra Math Symbols and Functions
The `physica` package provides additional math symbols and functions.
#table(
  columns: 2,
  align: (x, y) => (right, left).at(calc.rem(x, 2)),
  stroke: (x, y) => if x == 0 { (right: 0.5pt) },
  ```typst
  $A^T, curl vb(E) = - pdv(vb(B), t)$
  ```,
  $A^T, curl vb(E) = - pdv(vb(B), t)$,

  ```typst
  $tensor(Lambda,+mu,-nu) = dmat(1,RR)$
  ```,
  $tensor(Lambda,+mu,-nu) = dmat(1,RR)$,

  ```typst
  $f(x,y) dd(x,y)$
  ```,
  $f(x,y) dd(x,y)$,
)
It is imported in this template.

== Units and Quantities
Although no as common as in physics, we do sometimes need to use units and quantities.
This template uses the `metro` package for this purpose.
If you prefer, you can also use the `unify` package.
