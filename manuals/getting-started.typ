= Getting Started
To start a math group project, simply import this package (you should have done it already) and use the `setup` function to define the project details. Here is an example:
```typst
#import "@preview/ubc-mathgp:0.1.0": *
#show: setup.with( // Use `.with()` instead of the full function.
  authors: (
    // The trailing comma is mandatory when there is only 1 author!
    author("Jane", "Doe", 12345678), // ← this comma
  ),
  number: 1,
  flavor: "A",
  group: "A Cool Math Group",
)
```

Fortunately, you don't have to remember all the details. #link("https://typst.app")[Typst web app] can handle the initialization for you. Follow the link, register an account, we are good to go.

In the project dashboard, next to "Empty document", click on "Start from a template", search and select "ubc-mathgp", enter your own project name, create, that easy!

Below the `#show: setup.with(...)`, you can start writing your project content.

For general techniques, consult the #link("https://staging.typst.app/docs")[Typst documentation].
