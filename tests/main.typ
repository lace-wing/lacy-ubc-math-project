#import "@local/ubc-mathgp:0.1.0": *
#show: setup.with(
  number: 2.1,
  flavor: [A],
  group: [Some Group],
  author("Jane", "Doe", "12345678"),
  author([#strike[Jane]John], "Smith", 10010010, strname: "John Smith"),
  author("Alex", "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}", $9999^9999$),
)

#import drawing: *
#cetz.canvas({
  cylinder((1, 2), (2, 1), 3cm, fill-side: red.lighten(50%))
})

$qty(12, km) limm_(x->0)^"wut"$

#hrule

#question(3)[one #question("Extra, no")[two #question(1)[three]]]

#help.drawing
#help.author
