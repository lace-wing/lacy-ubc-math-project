#import "defaults.typ"

#let replace-dict(orig, cand) = {
  cand
    .keys()
    .fold(
      orig,
      (acc, k) => if k in orig.keys() and type(orig.at(k)) == dictionary and type(cand.at(k)) == dictionary {
        acc + ((k): replace-dict(orig.at(k), cand.at(k)))
      } else {
        acc + ((k): cand.at(k))
      },
    )
}

#let configs = (
  "impl",
  "info",
  "features",
  "colors",
)

#let load-config(config, default: true) = {
  let defaults = dictionary(defaults)
  let cadidate = (:)

  if type(config) == str {
    assert(
      config.split("/").last() in configs,
      message: "\"" + config + "\" is not a valid config. Choose one among " + configs.join(", ", last: " and ") + ".",
    )
    import config + ".typ" as cmod
    cadidate = dictionary(cmod)
  } else if type(config) == dictionary {
    cadidate = config
  } else {
    panic("Config must be path to a config or a dictionary.")
  }

  if default { replace-dict(defaults, cadidate) } else { cadidate }
}
