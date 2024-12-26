#let font-size = 10pt
#let sections = (
  "introduction",
  "getting-started",
  "setup",
  "author",
  "math",
  "drawing",
  "question",
  "solution",
  "caveats",
)

#let help = (:)
#for section in sections {
  help.insert(
    section,
    block(
      width: 100%,
      inset: font-size,
      stroke: blue + 0.5pt,
      [
        #set text(size: font-size)
        #set heading(outlined: false)
        #show raw.where(block: false): r => box(
          fill: gray.lighten(70%),
          radius: 0.4em,
          inset: 0.35em,
          baseline: 0.35em,
          r,
        )

        #text(fill: gray)[User Manual]
        #v(font-size * 0.5, weak: true)

        #{
          import "@preview/showman:0.1.2": runner
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

          include "manuals/" + section + ".typ"

          import "shorthand.typ": hrule
          hrule
        }

        #context v(par.spacing * -0.5)

        #text(
          size: font-size * 0.8,
          [
            Other helps: #sections.filter(s => s != section).map(s => raw(s)).join(", ").
          ],
        )
      ],
    ),
  )
}
