#let config-state = state("lacy-ubc-math-project-config", (:))

#let compose(body, ..funcs) = (body, ..funcs.pos()).reduce((it, func) => if type(func) == function {
  func(it)
} else {
  it
})

#let try-dict(data) = {
  let t = type(data)
  if t == dictionary {
    return data
  }
  if t == module {
    return dictionary(data)
  }
  if t == function {
    return try-dict(t())
  }
  if t == arguments {
    return data.named()
  }
  panic("Cannot convert a " + t + " to a dictionary!")
}

#let merge-dicts(..dicts) = (
  dicts
    .pos()
    .reduce((orig, cand) => cand
      .keys()
      .fold(
        orig,
        (acc, k) => if k in orig.keys() and type(orig.at(k)) == dictionary and type(cand.at(k)) == dictionary {
          acc + ((k): merge-dicts(orig.at(k), cand.at(k)))
        } else {
          acc + ((k): cand.at(k))
        },
      ))
)

#let merge-configs(..conf) = merge-dicts(
  ..conf.pos().map(c => if type(c) == module { try-dict(c).at("config", default: (:)) } else { try-dict(c) }),
)


