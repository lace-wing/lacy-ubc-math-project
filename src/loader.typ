#let try-dictionary(data) = {
  let t = type(data)
  if t == dictionary {
    return data
  }
  if t == module {
    return dictionary(data)
  }
  if t == function {
    return try-dictionary(t())
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

#let merge-configs(..conf) = merge-dicts(..conf.pos().map(c => try-dictionary(c).at("config", default: (:))))


