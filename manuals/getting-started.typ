#import "../format.typ": question, solution, __question-counters

= Getting Started
#quote[So, how do I even start using Typst?]

First thing first, it is all free.

You have 2 options: working online or offline. Since this is a "group project" template, you probably want to work online for collaboration. Here is a step-by-step guide to get you started.

+ #link("https://typst.app")[Sign up] for an account on the Typst web app.
+ Follow some guides and explore a bit.
+ (Optional) Assemble a team.
  + Dashboard → (top left) Team → New Team.
  + Team dashboard → (next to big team name) manage team → Add member.

Voilà! You are ready to start your math group project.

== Initialize Projects
To start a math group project, simply import this package (you should have done it already) and use the `setup()` function to define the project details.

Fortunately, you don't have to remember all the details. #link("https://typst.app")[Typst web app] can handle the initialization for you.

In the project dashboard, next to "Empty document", click on "Start from a template", search and select "ubc-math-group-project", enter your own project name, create, that easy!

In the project just initialized, you will see 2 files: `common.typ` and `project1.typ`.

If you are to reuse the template, create no new project, but add files to the existing one, like `project2.typ`, `project3.typ`, etc.

=== `common.typ`
This file is for common content that can be shared across all projects.
For instance, your group name and members.
```typst
#import "@preview/ubc-math-group-project:0.1.0": author
// Modify as you please.
#let authors = (
  jane-doe: author("Jane", "Doe", "12345678"),
  alex-conquitlam: author(
    "Alex",
    "k\u{02b7}ik\u{02b7}\u{0259}\u{019b}\u{0313}",
    99999999,
    strname: "Alex Coquitlam"
  ),
)
#let group-name = [A Cool Group]
// Additional common content that you may add.
#let some-other-field = [Some other value]
#let some-function(some-arg) = { some-manipulation; some-output }

```

=== `project1.typ`
Here is where you write your project content.
```typst
#import "@preview/ubc-math-group-project:0.1.0": *
#import "common.typ": * // Import the common content.
#show: setup.with(
  number: 1,
  flavor: [A],
  group: group-name,
  authors.jane-doe,
  // Say, Alex is absent for this project, so their entry is not included.
  // If you just want all authors, instead write:
  // ..authors.values(),
)
```

Below this `#show: setup.with(...)` is your project content.

== Questions & Solutions
A math group project mostly consists of questions and solutions. You can use the `question()` and `solution()` functions to structure your content.
```typst
#question(1)[
  What is the answer to the universe, life, and everything?
  // The solution should be in the question.
  #solution[
    The answer is 42.
  ]
  // You can nest questions and solutions.
  #question[2 points, -1 if wrong][
    What do you get when you multiply six by nine?
    #solution[
      42\.
    ]
  ]
]
``` <show>


#question(1)[
  #solution[]
  #question(1)[
    #solution[]
    #question(1)[
      #solution[]
    ]
  ]
]

== Learn Typst
Yes, you do have to learn it, but it is simple (for our purpose).

For general techniques, consult the #link("https://staging.typst.app/docs")[Typst documentation].

For this template, you can find more help from the "Other helps" line at the bottom of each help section.
