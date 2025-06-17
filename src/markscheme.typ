#import "spec.typ": spec, spell, component-type

// unique solution count, used for markscheme
#let solution-counter = counter(spec.solution.name)

#let marker(mark, point, ..remark) = spell(
  spec.marker.name,
  mark: mark,
  point: point,
  remark: remark.pos().at(0, default: none),
)

#let marks-visualizer(marks, sum: false) = {
  set text(size: 0.9em, style: "italic", weight: "bold")

  if sum {
    let total = marks.map(m => m.point).sum()
    if total in (0, 1) [
      [#total point]
    ] else [
      [#total points]
    ]
  } else {
    marks.map(m => [(#m.mark#m.point)]).join(sym.wj)
    marks.map(m => m.remark).filter(rm => rm != none).map(rm => [(#rm)]).join(sym.wj)
  }
}

#let embed-marks(pin, marks, span) = [
  #metadata(
    spell(
      spec.mark.name,
      pin: pin,
      marks: marks,
      span: span,
    ),
  )
]

#let markbox(..args) = layout(size => {
  let args = args.pos()
  let marks = args.filter(a => component-type(a) == spec.marker.name)
  let body = args.filter(a => component-type(a) != spec.marker.name).join()
  box(
    // stroke: .1pt + blue.transparentize(67%), //DEBUG
    inset: 0pt,
    outset: 0pt,
    embed-marks(
      solution-counter.get().first(),
      marks,
      measure(body, width: size.width).height,
    )
      + body,
  )
})

#let is-mark(data) = {
  if data.func() == metadata {
    data = data.value
  }
  return component-type(data) == spec.mark.name
}

#let marking-grid(uid) = context {
  let metas = query(metadata)
  let ms = metas.filter(m => is-mark(m) and m.value.pin == uid)
  // quit if no marks
  if ms == () { return none }

  let msposy = ms.map(m => m.location().position().y)
  // only find the first pin with the uid,
  // there's supposed to be one and no more
  let pposy = here().position().y

  grid(
    // stroke: .1pt + blue.transparentize(67%), //DEBUG
    columns: (1fr,),
    rows: (
      msposy.first() - pposy,
      ..msposy.windows(2).map(((f, s)) => s - f),
      ms.last().value.span,
      auto,
    ),
    [],
    ..ms.map(m => marks-visualizer(m.value.marks)),
    marks-visualizer(ms.map(m => m.value.marks).flatten(), sum: true)
  )
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
