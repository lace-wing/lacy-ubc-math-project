#import "@preview/physica:0.9.3": *
#import "@preview/unify:0.7.1": *
#import "@preview/equate:0.2.1": *

#import "loader.typ": load-config, defaults
// #import "format.typ": author, question, solution, toggle-solution
#import "components.typ": author, question, solution
#import "shorthand.typ": *
#import "drawing.typ" as drawing

#import "unsafe.typ" as unsafe

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
  config: defaults,
  ..authors,
  body,
) = [
  #let authors = authors.pos()
  // Make sure the project name is a string or content.
  #assert(type(project) in (str, content), message: "The project name must be a string or content.")
  // Make sure the project number is a number.
  #assert(
    number == none or type(number) in (int, float, version),
    message: "The project number, if set, must be an integer, float or version.",
  )
  // Make sure the project flavor is a string or content.
  #assert(
    flavor == none or type(flavor) in (str, content),
    message: "The project flavor, if set, must be a string or content.",
  )
  // Make sure the group is a string or content.
  #assert(group == none or type(group) in (str, content), message: "The group, if set, must be a string or content.")
  // Make sure the authors are properly structured.
  #assert(type(authors) == array and authors.len() > 0, message: "At least one author is required.")
  #let msg-author = "Malformed author information. Consider using the `author` function for author information."
  #for a in authors {
    assert(type(a) == dictionary, message: msg-author)
    assert("name" in a and type(a.name) == dictionary, message: msg-author)
    assert("first" in a.name and type(a.name.first) in (str, content), message: msg-author)
    assert("last" in a.name and type(a.name.last) in (str, content), message: msg-author)
    assert("id" in a and type(a.id) in (int, content, str), message: msg-author)
  }

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
  #let link_s = it => {
    set text(fill: blue.darken(30%))
    it
  }
  #show ref: link_s
  #show link: link_s

  #show: super-T-as-transpose // Render "..^T" as transposed matrix
  #show: equate.with(breakable: true, sub-numbering: true)
  #set math.equation(numbering: "(1.1)")

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
