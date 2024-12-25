#import "@local/ubc-math-group-project:0.1.0": *
#import "common.typ": *
#show: setup.with(
  number: 2.1,
  flavor: [A],
  group: group-name,
  authors.jane-doe,
  authors.john-smith,
  authors.alex-conquitlam,
)

#import drawing: *
#cetz.canvas({
  cylinder((1, 2), (2, 1), 3cm, fill-side: red.lighten(50%))
})

$qty(12, km) limm_(x->0)^"wut"$

#hrule

#question(3)[one #question("Extra, no")[two #question(1)[three]]]

#help.getting-started
#help.drawing
#help.author
