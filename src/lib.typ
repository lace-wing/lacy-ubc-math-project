#import "@preview/physica:0.9.3": *
#import "@preview/unify:0.7.1": *
#import "@preview/equate:0.2.1": *

#import "defaults.typ"
#import "loader.typ"

#import "components.typ"
#import components: author, question, solution, feeder
#import "markscheme.typ"
#import "shorthand.typ": *
#import "drawing.typ"

#import "unsafe.typ"

/*******
 * Setup
 *******/

/// Setup for the document.
/// [WARN] `authors` requires specific structure.
/// Use function `author()` to help construct them.
///
/// - project (str, content): The name of the project.
/// - number (int, float, version, none): The number of the project.
/// - flavor (str, content, none): The flavor of the project.
/// - group (str, content, none): The group name.
/// - authors (array): The authors of the project, use `author()` to fill it.
/// - body (block): The content of the document.
#let setup(
  project: "Group Project",
  number: none,
  flavor: none,
  group: none,
  config: (),
  ..authors,
  body,
) = [
  #if type(config) != array {
    config = (config,)
  }
  #(config = loader.merge-configs(defaults, ..config))

  #let authors = authors.pos().map(a => if type(a) == function { a() } else { a })

  #let title = {
    [#project]
    if number != none {
      " " + str(number)
    }
    if flavor != none {
      ", Flavor " + flavor
    }
  }

  #set document(
    title: title,
    author: authors.map(a => {
      if type(a.strname) == str {
        return a.strname
      }
      if type(a.name.first) == content {
        if "text" in a.name.first.fields() {
          a.name.first = a.name.first.text
        } else {
          // If the name is not normal, set "<unsupported>".
          a.name.first = "<unsupported>"
        }
      }
      if type(a.name.last) == content {
        if "text" in a.name.last.fields() {
          a.name.last = a.name.last.text
        } else {
          // If the name is not normal, set "<unsupported>".
          a.name.last = "<unsupported>"
        }
      }
      a.name.first + " " + a.name.last
    }),
  )
  #set page(numbering: none)
  #set par(first-line-indent: 0em)
  #set text(font: ("DejaVu Serif", "New Computer Modern"), size: 10pt)
  #let link_s = text.with(fill: blue.darken(30%))
  #show ref: link_s
  #show link: link_s

  #show: super-T-as-transpose // Render "..^T" as transposed matrix
  #show: equate.with(breakable: true, sub-numbering: true)
  #set math.equation(numbering: "(1.1)")

  #show: components.qna-breakable-rule

  #[
    #set align(center)
    #text(size: 1.2em, weight: "bold", upper(title))
    #v(0.2em)
    #text(size: 1.2em, group)

    #for a in (
      authors
        .map(a => {
          stack(
            dir: ttb,
            spacing: 0.65em,
            [#a.name.first *#a.name.last* #if a.suffix != none { a.suffix }],
            {
              if type(a.id) == int {
                raw(str(a.id))
              } else if type(a.id) == str {
                raw(a.id)
              } else if type(a.id) == content and "text" in a.id.fields() {
                raw(a.id.text)
              } else {
                a.id
              }
            },
          )
        })
        .chunks(4)
    ) {
      grid(
        align: center,
        columns: a.len(),
        column-gutter: 40% / a.len(),
        ..a
      )
    }

    #v(1.3em)
  ]

  #body
]
