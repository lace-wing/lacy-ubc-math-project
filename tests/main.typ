#import "@local/ubc-math-group-project:0.1.0": *
#let __orig-counters = state("orig-couters", (1, 2, 3))

#context for i in range(0, unsafe.__max-qs-level) {
  unsafe.__question-counters.at(i).update(__orig-counters.get().at(i))
}
