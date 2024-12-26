#import "@preview/showman:0.1.2": runner

#let setup(body) = {
  let prefix-orig = (
    "#import \"@local/ubc-math-group-project:0.1.0\": *",
    "#unsafe.__question-counters.at(0).update(1)",
  ).join("\n")
  let suffix-orig = ""
  show raw.where(block: true): it => context {
    let prefix = prefix-orig
    let suffix = suffix-orig
    if "label" in it.fields() and it.label == <show> and it.lang in ("typst", "typc") {
      if it.lang == "typc" {
        prefix = prefix + "\n#{"
        suffix = "}"
      }
      runner.standalone-example(
        it,
        eval-prefix: prefix,
        eval-suffix: suffix,
      )
    } else { it }
  }
  body
}
