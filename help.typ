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
        #include "manuals/" + section + ".typ"

        #{
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
