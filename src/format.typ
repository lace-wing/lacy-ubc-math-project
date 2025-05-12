#import "colors.typ": colors

// Question levels, corresponding numbering and labeling.

// The maximum number of question levels.
#let __question-level-max = 3
// The current question level.
#let __question-level = state("question-level", 0)
// Point of each question
#let __question-list = state("question-list", ())
// The question counters.
#let __question-counters = (
  (none,) + range(1, __question-level-max + 1).map(i => counter(figure.where(kind: "question-" + str(i))))
)
// Numbering for each question level.
#let __question-numbering = (
  (none,)
    + (
      "1.",
      "(a)",
      "i.",
    )
)
// Label numbering for each question level.
#let __question-labels = (
  (none,)
    + (
      "1",
      "a",
      "i",
    )
)
// Make sure the numbering and labeling are consistent.
#assert(__question-numbering.len() == __question-level-max + 1 and __question-labels.len() == __question-level-max + 1)

// solution visibility
#let __solution-visible = state("solution-visible", true)
#let toggle-solution(visible) = {
  assert(type(visible) == bool, message: "The visibility of the solution must be a boolean.")
  __solution-visible.update(v => visible)
}
#let __solution-disabled = sys.inputs.at("hide-solution", default: "") in ("1", "true", "yes", "y")

// Show rule for evaluating questions with point = auto
#let __question-point-rule(body) = (
  context {
    let question-list = __question-list.final()
    let max-count = calc.max(0, ..question-list.map(q => q.first().len()))

    // if there is no auto in question point, stop
    if question-list.find(q => q.at(1) == auto) == none { return }

    // re-eval to remove auto
    for level in range(max-count, 0, step: -1) {
      let auto-list = question-list.filter(q => q.first().len() == level and q.at(1) == auto)
      if auto-list == () { continue }

      // if it's the deepest level
      if level == max-count {
        // set point to 0
        __question-list.update(ql => (auto-list.map(q => (q.first(), 0)) + ql).dedup(key: q => q.first()))
        continue
      }

      // else, collect points from children
      let child-list = question-list.filter(q => q.first().len() == level + 1)
      __question-list.update(ql => (
        auto-list.map(q => (
          q.first(),
          child-list.filter(c => c.first().slice(0, level) == q.first()).map(c => c.at(1)).sum(default: 0),
        ))
          + ql
      ).dedup(key: q => q.first()))
    }
  }
    + body
)

// Show rule for automatic @qs:n display
#let __question-ref-rule(body) = {
  show ref: it => context {
    let qs = it.element
    if not (
      qs != none and qs.func() == figure and type(qs.kind) == str and qs.kind.starts-with("question-")
    ) {
      return it
    }

    let qs-level = int(qs.kind.split("-").last())
    let ref-level = __question-level.get()

    let common-level = if ref-level == 0 { 0 } else {
      __question-counters
        .fold(
          (0, false),
          ((level, stop), counter) => {
            if stop { return (level, stop) }
            if counter == none { return (level, false) }
            if counter.get().first() == counter.at(it.target).first() { return (level + 1, false) }
            return (level, true)
          },
        )
        .first()
    }

    let supplement = if it.supplement == auto {
      if common-level == 0 or qs-level == 1 { "Question" } else { "Part" }
    } else { it.supplement }

    let link-str = if common-level == __question-level-max {
      if it.supplement == auto { "This " + supplement } else { it.supplement }
    } else {
      (
        supplement
          + " "
          + range(calc.min(common-level + 1, qs-level), qs-level + 1)
            .map(i => numbering(__question-labels.at(i), __question-counters.at(i).at(it.target).first()))
            .join(".")
      )
    }

    link(it.target, link-str)
  }

  body
}

/// Creates an author (a `dictionary`).
/// - firstname (str, content): The author's first name, bold when displayed.
/// - lastname (str, content): The author's last name.
/// - id (int, content): The author's student ID.
/// - strname (str, none): `str` alternative as the full name. In case of special characters or formatting in the name, a plain text version can be used for PDF metadata.
/// - suffix (str, content, none): The author's suffix, e.g. "(NP)" for non-participant.
#let author(firstname, lastname, id, strname: none, suffix: none) = {
  (
    name: (
      first: firstname,
      last: lastname,
    ),
    id: id,
    strname: strname,
    suffix: suffix,
  )
}

/// Creates a question block.
/// Automatically increments the question level for further questions in `body`.
/// Supports up to 3 levels of questions.
/// [WARN] Do not provide `counters`, `numbering` or `labels` if unsure of what they do.
///
/// - point (int, content, str, none): The number of points for the question. Does not display if it is `0` or `none`; does not attach "points" if it is `content` or `str`.
///
/// - body (block): The question, sub-questions and solutions.
///
/// - numbering (array): The numbering for each question level.
///  For example, `("1.", "(a)", "i.")`.
///
/// - labels (array): The label numbering for each question level. Must not contain anything not allowed in `label`, e.g. spaces, plus signs.
///  For example, `("1", "a", "i")` will result in question 1.1.1 being labeled with `<qs:1-a-i>`.
#let question(
  ..points,
  body,
  label: none,
  numbering: __question-numbering,
  labels: __question-labels,
) = context {
  // Width of the question number, which is the width of an enum number.
  let w = 2.65em

  // Get the current question level.
  let level = __question-level.get() + 1
  // Increment the question level.
  __question-level.update(n => n + 1)

  let kind = "question-" + str(level)
  // since we cannot `context` for the label, lets just store the supposed count now
  let count = __question-counters.at(level).get().first() + 1
  let counts = range(1, level + 1).map(i => if i == level { count } else { __question-counters.at(i).get().first() })
  let counts-strs = counts.map(c => str(c))

  let label-str = if label == none {
    (
      "qs:"
        + counts
          .enumerate()
          .map(((i, c)) => std.numbering(
            __question-labels.at(i + 1),
            c,
          ))
          .join("-")
    )
  } else if type(label) == str {
    "qs:" + label
  } else {
    "qs:" + str(label)
  }

  // get point
  let points = points.pos()
  let (point, point-display) = (auto, auto)
  let is-point(p) = type(p) in (int, decimal) or p in (auto, none)
  if points.len() == 1 {
    let p = points.first()
    if is-point(p) { point = p } else { point-display = p }
  } else if points != () {
    (point, point-display) = points.slice(0, 2)
    assert(is-point(point), message: "Point, the first of multiple sink parameters, must be a number, auto or none.")
  }

  if point == none { point = 0 }

  let question-list = __question-list.get()
  if question-list.find(q => q.first() == counts) == none {
    // before solidify auto point
    // report question to tree
    __question-list.update(ql => {
      ql + ((counts, point),)
    })
  } else {
    point = __question-list.final().find(q => q.first() == counts).at(1)
  }

  /*
    // get point from list
    if point == auto {
      // if level == __question-level-max {
      //   point = 0
      // } else {
      point = __question-list.final().find(q => q.first() == counts)
      // }
    } else if point == none {
      point = 0
    }
  */

  [
    #figure(
      kind: kind,
      supplement: [Question],
      numbering: __question-numbering.at(level),
      grid(
        columns: (w, 100% - w),
        align: (top + right, top + left),

        // Question number
        [
          #std.numbering(__question-numbering.at(level), count)
          #h(.65em)
        ],
        // Question body.
        [
          // display point
          #if point-display == auto {
            if point != 0 {
              if point == 1 [(#point point)] else [(#point points)]
              sym.space.thin
            }
          } else if type(point-display) == function [(#point-display(point))] else [(#point-display)]
          #body
        ]
      ),
    )

    // label
    #std.label(label-str)

  ]

  // Set all lower level question counters to 0.
  for i in range(level + 1, __question-counters.len()) {
    __question-counters.at(i).update(0)
  }
  // Reduce the question level, leave.
  __question-level.update(n => n - 1)
}

/// Creates a solution block.
/// - body (content): The solution.
/// - color (color): The color of the solution frame and text.
/// - supplement (content): The supplemental text to be displayed before the solution.
/// - force (bool): If it is forced to be visible when solutions are hidden.
#let solution(body, color: colors.green.solution, supplement: [*Solution*: ], force: false) = {
  context block(
    width: 100%,
    inset: 1em,
    stroke: color + 0.5pt,
  )[
    #if __solution-disabled { return none }
    #if not force and not __solution-visible.get() { return none }
    #set align(left)
    #set text(fill: color)
    #supplement#body
  ]
}

