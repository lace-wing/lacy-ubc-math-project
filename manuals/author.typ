== Author
The `author()` function is to be used as an argument of the `setup()` function, providing an author dictionary. It takes the first name, last name, and student number as arguments. For example,
```typst
#show: setup.with(
  author("Jane", "Doe", 12345678),
  // ...
)
```
supplies
```typst
{
  name: {
    first: "Jane",
    last: "Doe",
  },
  id: 12345678,
}
```
And in the PDF metadata there will be a "Jane Doe" in the authors field, student number not included.

What if your last name is k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}, that happens to type...
```
k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}
```
Well, you still call `author()`:
```typst
author("Alex", "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}", 12345678)
```
If the PDF viewer gets lucky, the name will show up in file information as normal, but more often then not, it becomes something like `Alex kʷikʷəƛ\u{313}` due to incompatibility. You are recommended to provide a plain text version of the full name with argument `strname` that must be a `str`:

```typst
author(
  "Alex",
  "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}",
  12345678,
  strname: "Alex Coquitlam" // This sure will have no display issue.
)
```
If `strname` is set, it will be used in the PDF metadata instead of the displayed name.

In some more extreme cases, `strname` would be a necessity, rather than a backup. Take name #underline(text(fill: purple)[Ga])#strike[*_lli_*]#overline($cal("leo")$) as an example. The name is so special that it cannot be converted to plain text. In this case, you must provide a `strname` to avoid incomprehensible PDF metadata.
```typst
author(
  [#underline(text(fill: purple)[Ga])#strike[*_lli_*]#overline($cal("leo")$)],
  "Smith",
  12345678,
  strname: "Gallileo Smith"
)
```
