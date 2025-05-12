#import "defaults.typ"

/// Cast a magic of lacy dict.
///
/// - impl (dictionary): Implementation of component identifiers.
/// - type (str): Type of the component.
///
/// -> dictionary
#let spell(impl: defaults.impl, type) = {
  assert(type in impl.components.keys(), message: "Component type \"" + type + "\" is not supported")
  return (magic: impl.magic, class: impl.class, type: type)
}

#let is-my-spell(impl: defaults.impl, element) = {
  if type(element) == dictionary {
    return element.at("magic", default: none) == impl.magic and element.at("class", default: none) == impl.class
  }
  return false
}

#let seperate-components(body) = {
  let components = ()
  let bodies = ()
  let bcount = 0
  if body.func() == [].func() {
    for c in body.children {
      if c.func() == raw and c.lang == "typc" and is-my-spell(eval(c.text)) {
        components += (bcount, eval(c.text))
      } else if is-my-spell(c) {
        components += (bcount, c)
      } else {
        bodies += (c,)
        bcount += 1
      }
    }
  } else if is-my-spell(body) {
    components = (0, body)
  } else {
    bodies = (body,)
  }

  (components, bodies)
}

#let tree-walker(tree) = { }

#let question(impl: defaults.impl, ..points, body) = {
  // get point
  let points = points.pos()
  let (point, point-display) = (auto, auto)
  let is-point(p) = type(p) in (int, decimal) or p in (auto, none)
  if points.len() == 1 {
    let p = points.first()
    if is-point(p) { point = p } else { point-display = p }
  } else if points != () {
    (point, point-display) = points.slice(0, 2)
    assert(is-point(point), message: "Point, the first of multiple sink parameters, must be a numbr, auto or none.")
  }
  if point == none { point = 0 }

  let (components, bodies) = seperate-components(body)
  (
    spell("question")
      + (
        point: point,
        point-display: point-display,
        id: auto,
        components: components,
        bodies: bodies,
      )
  )
}
#let question-walker(impl: defaults.impl, layers) = { }
#let question-visualizer(qsn) = none

#let solution(impl: defaults.impl, body) = {
  let (components, bodies) = seperate-components(body)
  (
    spell("solution")
      + (
        id: auto,
        components: components,
        bodies: bodies,
      )
  )
}
#let solution-visualizer(sol) = none

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

