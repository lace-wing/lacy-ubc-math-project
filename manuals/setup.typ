== Setup
In `setup()`, we define the project details, including the project name, number, flavor, group name, and authors. The displayed title will look like
#align(center)[
  `project` `number`, `flavor` \
]
for example,
#align(center)[
  `GROUP PROJECT 1, FLAVOUR A`
]

Then it is the authors. Since this is a "group project" template, `group` indicates the group name, which will be displayed between the title and the authors.

Finally, `authors`. Each author should be a dictionary with `name` and `id`. The `name` should be a dictionary with `first` and `last`. The `id` should be the student number. Such a dictionary can be created with function `author`. So, it will look like
```typst
authors: (
  author("Jane", "Doe", 12345678), // You are Jane Doe with student number 12345678
)
```
Be reminded that when there is only one author, you must put a trailing comma to tell Typst that it is an array. More authors, you ask? Just add more `author()`, separated by commas.

Title and authors made in `setup()` are converted to PDF metadata, which can be seen in the PDF document properties.

