#import "@local/ubc-math-group-project:0.1.0": author
#let authors = (
  jane-doe: author("Jane", "Doe", "12345678"),
  john-smith: author([#strike[Jane]John], "Smith", 10010010, strname: "John Smith"),
  alex-conquitlam: author("Alex", "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}", $9999^9999$),
)
#let group-name = [Some Group]
