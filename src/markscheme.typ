#import "spec.typ": spec, spell, component-type

// unique solution count, used for markscheme
#let solution-counter = counter(spec.solution.kind)

#let marker(mark, point, ..remark) = spell(
  spec.marker.name,
  mark: mark,
  point: point,
  remark: remark.pos().at(0, default: none),
)

#let markers-visualizer(marks, width: auto, sum: false) = {
  set text(size: 0.8em, style: "italic", weight: "bold")
  set par(
    first-line-indent: 0pt,
    hanging-indent: 0pt,
    leading: .2em,
  )

  let cont = box.with(width: width, height: auto, inset: 0pt, outset: 0pt)

  if sum {
    let total = marks.map(m => m.point).sum(default: 0)
    if total in (0, 1) {
      cont[[#total point]]
    } else {
      cont[[#total points]]
    }
  } else {
    cont(
      marks.map(m => [(#m.mark#m.point)]).join(sym.zws)
        + linebreak()
        + marks.map(m => m.remark).filter(rm => rm != none).map(rm => [(#rm)]).join(sym.zws),
    )
  }
}

#let embed-pin(..args) = metadata(
  spell(
    spec.pin.name,
    ..args.named(),
  ),
)

#let is-pin(data, ..preds) = {
  if data.func() == metadata {
    data = data.value
  }
  return (
    component-type(data) == spec.pin.name
      and preds.named().pairs().map(((pk, pv)) => data.keys().contains(pk) and data.at(pk) == pv).all(p => p == true)
  )
}

#let embed-mark(id, markers) = metadata(
  spell(
    spec.mark.name,
    id: id,
    markers: markers,
  ),
)



#let is-mark(data) = {
  if data.func() == metadata {
    data = data.value
  }
  return component-type(data) == spec.mark.name
}

#let markit(..args) = layout(size => {
  let args = args.pos()
  let markers = args.filter(a => component-type(a) == spec.marker.name)
  let body = args.filter(a => component-type(a) != spec.marker.name).join()

  embed-mark(
    solution-counter.get().first(),
    markers,
  )
  body
})

#let marking-grid(uid, width) = context {
  // above, a context, so the pin is placed in *this* context--the marking cell, not the entire context of the solution block

  embed-pin(id: uid, usage: spec.marker.name, pos: top + left, width: width)
  // below is moved to `marking-extension` by solution-visualizer
  // place(
  //   bottom + left,
  //   circle(radius: 1pt, stroke: red) + embed-pin(id: uid, usage: spec.marker.name, pos: bottom + left),
  // )
}

#let foreground-marking = context {
  let this-page = here().page()
  let meta = query(metadata)

  let marks = meta.filter(m => m.location().page() == this-page and is-mark(m))
  // leave if no mark
  if marks == () { return none }
  let pins = meta.filter(m => is-pin(m, usage: spec.marker.name))
  // leave if no pin
  if pins == () { return none }

  // group into (dx, marks with the same pin id)
  let mark-groups = pins
    .filter(p => p.value.pos == top + left)
    .map(pin => (
      pin,
      marks.filter(m => m.value.id == pin.value.id),
    ))
    .filter(gp => gp.at(1) != ())

  for (pin, marks) in mark-groups {
    for (i, mark) in marks.enumerate() {
      place(
        dx: pin.location().position().x,
        dy: mark.location().position().y,
        markers-visualizer(mark.value.markers, width: pin.value.width),
      )
    }
  }

  //TODO figure out why it cannot handle pagebreak
  // for bpin in pins.filter(p => p.location().page() == this-page and p.value.pos == bottom + left) {
  //   let group = mark-groups.find(gp => gp.first().value.id == bpin.value.id)
  //   if group == none { continue }
  //
  //   let sum = markers-visualizer(
  //     group.at(1).map(m => m.value.markers).flatten(),
  //     width: group.at(0).value.width,
  //     sum: true,
  //   )
  //
  //   place(
  //     dx: group.at(0).location().position().x,
  //     dy: bpin.location().position().y - measure(sum).height,
  //     sum,
  //   )
  // }
}

#let method = marker.with("M")
#let m = method

#let accuracy = marker.with("A")
#let a = accuracy

#let correct = marker.with("C")
#let c = correct

#let reasoning = marker.with("R")
#let r = reasoning

#let follow-through = marker.with("ft", none)
#let ft = follow-through

#let no-attempt = marker.with("na", 0)
#let na = no-attempt

