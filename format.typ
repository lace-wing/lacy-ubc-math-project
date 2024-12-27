// Question levels, corresponding numbering and labeling.

// The maximum number of question levels.
#let __max-qs-level = 3
// The current question level.
#let __question-level = state("question-level", 0)
// The question counters.
#let __question-counters = range(1, __max-qs-level + 1).map(i => counter("question-" + str(i)))
// Duplicate question numbers
#let __question-duplicates = state("question-duplicates", (:))
// Numbering for each question level.
#let __question-numbering = (
  "1.",
  "(a)",
  "i.",
)
// Label numbering for each question level.
#let __question-labels = (
  "1",
  "a",
  "i",
)
// Make sure the numbering and labeling are consistent.
#assert(__question-numbering.len() == __max-qs-level and __question-labels.len() == __max-qs-level)

/// Creates an author (a `dictionary`).
/// - firstname (str, content): The author's first name, bold when displayed.
/// - lastname (str, content): The author's last name.
/// - id (int, content): The author's student ID.
/// - strname (str, none): `str` alternative as the full name. In case of special characters or formatting in the name, a plain text version can be used for PDF metadata.
#let author(firstname, lastname, id, strname: none) = {
  (
    name: (
      first: firstname,
      last: lastname,
    ),
    id: id,
    strname: strname,
  )
}

// The green used for solution frame and text.
#let green-solution = rgb(10%, 40%, 10%)

/// Creates a question block.
/// Automatically increments the question level for further questions in `body`.
/// Supports up to 3 levels of questions. Properly configure `numbering` and `labels` if needed, each must contain exactly 3 elements.
///
/// - point (int, content, str, none): The number of points for the question. Does not display if it is `0` or `none`; does not attach "points" if it is `content` or `str`.
///
/// - body (block): The question, sub-questions and solutions.
///
/// - numbering (array): The numbering for each question level.
///  For example, `("1.", "(a)", "i.")`.
///
/// - labels (array): The label numbering for each question level. Must not contain anything not allowed in `label`, e.g. spaces, dashes.
///  For example, `("1", "a", "i")` will result in question 1.1.1 being labeled with `<qs:1:a:i>`.
#let question(point, body, numbering: __question-numbering, labels: __question-labels) = context {
  // Increment the question level.
  __question-level.update(n => n + 1)
  // Get the current question level.
  let level = __question-level.get()
  // Make sure the question level is within the supported range.
  assert(
    level <= __max-qs-level,
    message: "Maximum question level exceeded. Only " + str(__max-qs-level) + " levels are supported.",
  )

  // Gutter between the question number and the question body.
  let gut = 0.45em
  // Width of the question number, which is the width of an enum number.
  let w = measure(enum.item([])).width
  // The question number#.
  let numbers = range(0, level + 1).map(i => str(__question-counters.at(i).display(labels.at(i)))).join("-")
  // Update the duplicate question numbers.
  __question-duplicates.update(d => {
    if numbers in d.keys() {
      (..d, (numbers): d.at(numbers) + 1)
    } else {
      d + ((numbers): 1)
    }
  })
  context grid(
    columns: (w, 100% - w - gut),
    column-gutter: gut,
    align: (top + right, top + left),

    // Question number with label.
    [
      #__question-counters.at(level).display(numbering.at(level))

      #let occ = __question-duplicates.get().at(numbers, default: 1)
      #label(
        "qs:"
          + numbers
          + if occ > 1 { "_" + str(occ) } else { none },
      )
    ],
    // Question body.
    [
      #if not point in (none, 0) {
        if type(point) == str or type(point) == content [(#point)] else if (
          type(point) == int and point == 1
        ) [(#point point)] else [(#point points)]
        sym.space.thin
      }
      #body
    ]
  )

  // Increment the question counter at the current level.
  __question-counters.at(level).step()
  // Set all lower level question counters to 1.
  for i in range(level + 1, __question-counters.len()) {
    __question-counters.at(i).update(1)
  }
  // Reduce the question level, leave.
  __question-level.update(n => n - 1)
}

/// Creates a solution block.
/// - body (content): The solution.
/// - color (color): The color of the solution frame and text.
/// - suppliment (content): The supplimental text to be displayed before the solution.
#let solution(body, color: green-solution, supplement: [*Solution*: ]) = {
  block(
    width: 100%,
    inset: 1em,
    stroke: color + 0.5pt,
  )[
    #set align(left)
    #set text(fill: color)
    #supplement#body
  ]
}

/*******
 * Setup
 *******/

/// Setup for the document.
/// - project (str, content): The name of the project.
/// - number (int, float, version, none): The number of the project.
/// - flavor (str, content, none): The flavor of the project.
/// - group (str, content, none): The group name.
/// - authors (array): The authors of the project, use `author()` to fill it.
/// - body (block): The content of the document.
#let setup(
  project: "Group Project",
  number: none,
  flavor: none,
  group: none,
  ..authors,
  body,
) = [
  #let authors = authors.pos()
  // Make sure the project name is a string or content.
  #assert(type(project) in (str, content), message: "The project name must be a string or content.")
  // Make sure the project number is a number.
  #assert(
    number == none or type(number) in (int, float, version),
    message: "The project number, if set, must be an integer, float or version.",
  )
  // Make sure the project flavor is a string or content.
  #assert(
    flavor == none or type(flavor) in (str, content),
    message: "The project flavor, if set, must be a string or content.",
  )
  // Make sure the group is a string or content.
  #assert(group == none or type(group) in (str, content), message: "The group, if set, must be a string or content.")
  // Make sure the authors are properly structured.
  #assert(type(authors) == array and authors.len() > 0, message: "At least one author is required.")
  #let msg-author = "Malformed author information. Consider using the `author` function for author information."
  #for a in authors {
    assert(type(a) == dictionary, message: msg-author)
    assert("name" in a and type(a.name) == dictionary, message: msg-author)
    assert("first" in a.name and type(a.name.first) in (str, content), message: msg-author)
    assert("last" in a.name and type(a.name.last) in (str, content), message: msg-author)
    assert("id" in a and type(a.id) in (int, content, str), message: msg-author)
  }

  #let title = {
    [#project]
    if number != none {
      " " + str(number)
    }
    if flavor != none {
      ", Flavor " + flavor
    }
  }

  #set document(
    title: title,
    author: authors.map(a => {
      if type(a.strname) == str {
        return a.strname
      }
      if type(a.name.first) == content {
        if "text" in a.name.first.fields() {
          a.name.first = a.name.first.text
        } else {
          // If the name is not normal, set "<unsupported>".
          a.name.first = "<unsupported>"
        }
      }
      if type(a.name.last) == content {
        if "text" in a.name.last.fields() {
          a.name.last = a.name.last.text
        } else {
          // If the name is not normal, set "<unsupported>".
          a.name.last = "<unsupported>"
        }
      }
      a.name.first + " " + a.name.last
    }),
  )
  #set page(numbering: none)
  #set par(first-line-indent: 0em)
  #set text(font: ("DejaVu Serif", "New Computer Modern"), size: 10pt)
  #show ref: set text(fill: blue.darken(30%), stroke: 0.2pt + blue.darken(30%))
  #show link: set text(fill: blue.darken(30%), stroke: 0.2pt + blue.darken(30%))

  #set math.equation(numbering: "(1.1)")

  // Initialize the question counters.
  #for c in __question-counters {
    c.update(1)
  }

  #[
    #set align(center)
    #text(size: 1.2em, weight: "bold", upper(title))
    #v(0.2em)
    #text(size: 1.2em, group)

    #for a in (
      authors
        .map(a => {
          stack(
            dir: ttb,
            spacing: 0.65em,
            [#a.name.first *#a.name.last*],
            {
              if type(a.id) == int {
                raw(str(a.id))
              } else if type(a.id) == str {
                raw(a.id)
              } else if type(a.id) == content and "text" in a.id.fields() {
                raw(a.id.text)
              } else {
                a.id
              }
            },
          )
        })
        .chunks(4)
    ) {
      grid(
        align: center,
        columns: a.len(),
        column-gutter: 40% / a.len(),
        ..a
      )
    }

    #v(1.3em)
  ]

  #body
]
