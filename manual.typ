#import "help.typ": sections, help-setup

#align(
  horizon,
  [
    #align(
      center,
      [
        #text(
          size: 1.5em,
          weight: "bold",
          [
            UBC Math Group Project Template \
            User Manual
          ],
        )
      ],
    )

    #outline(depth: 1)
  ],
)

#set page(numbering: "1")
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

#show: help-setup
#for section in sections {
  include "manuals/" + section + ".typ"
}
