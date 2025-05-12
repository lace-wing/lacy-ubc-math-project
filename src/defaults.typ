#let impl = {
  let values = (
    // Magic identifier of lacy packages.
    magic: "lacy",
    // Class of the lacy magic, the package name after `lacy-`.
    class: toml("../typst.toml").package.name.split("-").slice(1).join("-"),
    // Types of components implemented.
    components: (
      question: auto,
      solution: auto,
    ),
    visualizers: (
      question: auto,
      solution: auto,
    ),
    walkers: (
      question: auto,
      solution: auto,
    ),
  )

  let hook-groups = (
    "components",
    "visualizers",
    "walkers"
  )

  for group in hook-groups {
    let keys = values.at(group).keys()
    values.at(group) += keys.map(k => ("pre-" + k, auto)).to-dict() + keys.map(k => ("post-" + k, auto)).to-dict()
  }

  values
}

#let info = ()

#let features = ()

#let colors = (
  green: (
    // The green used for solution frame and text.
    solution: rgb(10%, 40%, 10%),
  ),
)

