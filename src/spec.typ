#let impl = (
  components: (
    "flat",
    "question",
    "solution",
    "feeder",
  ),
  configs: (
    "group",
    "colors",
  ),
)
#{
  impl.configs += impl.components
}

#let spec = (
  magic: "lacy",
  class: "ubc-math-project",
  flat: (:),
  feeder: (:),
  question: (
    kind: "lacy-question",
    supplement: "Question",
    label-head: "qs:",
  ),
  solution: (
    kind: "lacy-solution",
    supplement: "Solution",
    label-head: "sn:",
  ),
)

#for comp in impl.components {
  spec.at(comp).insert("name", comp)
}
