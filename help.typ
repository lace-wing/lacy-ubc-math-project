#let font-size = 10pt
#let sections = (
  "introduction",
  "getting-started",
  "setup",
  "author",
  "caveats",
  "drawing",
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

        #let body = include "manuals/" + section + ".typ"
        #let title = body.children.find(c => c.func() == heading).body

        #align(right)[#text(size: 8pt, fill: gray)[User Manual: #title]]
        #v(font-size * -2)
        #set text(size: font-size)
        #show raw.where(block: false): r => box(
          fill: gray.lighten(70%),
          radius: 0.5em,
          inset: 0.45em,
          baseline: 0.45em,
          r,
        )

        #body

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
