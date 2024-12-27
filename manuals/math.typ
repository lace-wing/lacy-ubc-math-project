#import "@preview/physica:0.9.4": *
#show: super-T-as-transpose // Render "..^T" as transposed matrix
#import "@preview/equate:0.2.1": *
#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")
#import "../format.typ": *

= Math
Formatting math equations is probably the reason you are here.
Unlike LaTex, math in Typst is simple.
#(
  (
    "E = m c^2",
    "e^(i pi) = -1",
    "x = (-b plus.minus sqrt(b^2 - 4a c))\n\t / (2a)",
  )
    .map(eq => [
      #raw("$" + eq + "$", lang: "typst", block: true) <show>
    ])
    .join()
)

For "block" or "display" math, leave a space or newline between the dollar sign and the equations.
```typst
$ E = m c^2 $
``` <show>

Documented are the built-in #link("https://staging.typst.app/docs/reference/math/")[math functions] and #link("https://staging.typst.app/docs/reference/symbols/sym/")[symbols]

== Numbering and Referencing Equations
Note that you must enable equation numbering to reference equations, which is set by this template. Add a ```typst #<label-name>``` right after the equation you wish to reference.
```typst
$
  e^(i pi) = -1 #<ex:eq:euler>
$
@ex:eq:euler is Euler's identity. \
#link(<ex:eq:euler>)[This] is the same.
``` <show>

== Extra Math Symbols and Functions
The `physica` package provides additional math symbols and functions.
```typst
$A^T, curl vb(E) = - pdv(vb(B), t)$
``` <show>

```typst
$tensor(Lambda,+mu,-nu) = dmat(1,RR)$
``` <show>

```typst
$f(x,y) dd(x,y)$
``` <show>

It is imported in this template.

== Units and Quantities
Although no as common as in physics, we do sometimes need to use units and quantities.
Directly typing the 'units' will not result in correct output.
```typst
$1 m = 100 cm$
``` <show>
```typst
$N = kg m s^(-2)$
``` <show>

This template uses the `metro` package for this purpose.
If you prefer, you can also use the `unify` package.
```typst
$qty(1, m) = qty(100, cm)$
``` <show>
```typst
$unit(N) = unit(kg m s^(-2))$
``` <show>

As you see, the ```typc qty()``` and ```typc unit()``` functions correct the numbers, units and spacing.
