#import "spec.typ": spec, spell

//REGION: author

#let author(firstname, lastname, id, strname: none) = (..args) => {
  let argp = args.pos()
  let argn = args.named()

  (
    (
      name: (
        first: firstname,
        last: lastname,
      ),
      id: id,
      strname: strname,
    )
      + if "suffix" in argn {
        (suffix: argn.suffix)
      } else if argp != () {
        (suffix: argp.first())
      } else {
        (suffix: none)
      }
  )
}

//REGION: util

#let component-type(comp) = {
  if type(comp) == dictionary {
    if comp.at("magic", default: none) == spec.magic and comp.at("class", default: none) == spec.class {
      return comp.type
    }
  }
  return spec.flat.name
}

#let qsn-info(..args) = {
  args = args.pos()
  let fst = args.first()
  if fst == none {
    return (
      id: (),
      label: none,
    )
  }
  if component-type(fst) == spec.question.name {
    return (
      id: fst.id,
      label: fst.label,
    )
  }
  (
    id: fst,
    label: args.at(1),
  )
}

#let question-labeller(id, head: spec.question.label-head, config: (:)) = {
  if config == (:) { panic(config) }
  label(head + id.enumerate().map(((x, i)) => numbering(config.question.labelling.at(x), i)).join("-"))
}

/// Generate content for displaying point of a question based on a numeric point value and a display guide.
/// When `point-display == auto`, generate appropriate English point text.
/// [WARN] Does not leave trailing space when `point-display` is a `function`.
///
/// - point (int, decimal): The numeric point.
/// - point-display (auto, str, content, function): The content to display, give `auto` for automatic point display, can be a function that accepts a numeric point argument.
/// -> content
#let point-visualizer(point, point-display) = {
  // if display is func: call it
  if type(point-display) == function {
    return point-display(point)
  }
  // if display is definite, show it
  if point-display != auto {
    return [(#point-display) ]
  }

  // else, automatic point
  if point == 1 {
    return [(#point point) ]
  }
  if point == 0 {
    return []
  }
  return [(#point points) ]
}

#let target-visualizer(target, target-display) = {
  // if not to display, return none
  if none in (target, target-display) {
    return none
  }
  // if display is auto, display it
  if target-display == auto {
    return [
      #set align(right)
      #ref(target)
    ]
  }
  // if display is function, call it
  if type(target-display) == function {
    return (target-display)(target)
  }
  // if display is definite, show it with link to target
  return [
    #set align(right)
    #link(target, target-display)
  ]
}

/// Find the first (DFS) instance of component that matches all the predicates.
/// Returns an array of 2 elements, firstly, if there is a match, secondly, the first match, if any.
///
/// - tree (array): The tree containing branches of component.
/// - pred (argument): The predicates to match with the components. For positional predicates, each will be compared with components directly, or being called with a component to return a `bool` if it is a function. For named predicates, they will be searched in components as `dictionary` key-value pairs.
/// - no-components (bool): Whether to set `components: none` for the component found. Use `true` if the child components of a component does not matter.
/// -> array
#let find-component(tree, ..pred, no-components: true) = {
  let pcomp = pred.pos()
  let pfield = pred.named()

  for branch in tree {
    if type(branch) != dictionary and pfield != (:) {
      continue
    }

    if (
      pcomp.fold(
        true,
        (can, pred) => {
          if not can { return false }
          if type(pred) == function {
            return pred(branch)
          } else {
            return branch == pred
          }
        },
      )
        and pfield
          .pairs()
          .fold(
            true,
            (can, pred) => {
              if not can { return false }
              return branch.keys().contains(pred.first()) and branch.at(pred.first()) == pred.last()
            },
          )
    ) {
      return (
        true,
        (
          if no-components {
            branch + (components: none)
          } else { branch }
        ),
      )
    } else if component-type(branch) != spec.flat.name {
      let (found, comp) = find-component(branch.components, ..pred)
      if found { return (true, comp) }
    }
  }

  return (false, none)
}

//REGION: markscheme

// unique solution count, used for markscheme
#let solution-counter = counter(spec.solution.name)

#let embed-pin(num) = {
  place(circle(stroke: .1pt + blue, radius: 1pt))
  metadata(
    spell(
      spec.pin.name,
      pin: num,
    ),
  )
}

#let marks = (
  "method",
  "accuracy",
  "correct",
  "reasoning",
  "follow-through",
  "no-attempt",
)

#let mark-label = label(spec.mark.label-head + "embed")

#let embed-mark(mark, pin) = [
  // #place(circle(stroke: .1pt + red, radius: 1pt))
  #[]#mark-label //TODO: fix it
  #metadata(
    spell(
      spec.mark.name,
      mark: mark,
      pin: pin,
    ),
  )
]

#(
  marks = marks
    .map(k => {
      let ak = k.split("-").map(s => s.clusters().first()).reduce((a, i) => if i == none { a } else { a + i })
      let v = context embed-mark(k, solution-counter.get().first())
      ((k): v, (ak): v)
    })
    .join()
)

#let extract-mark() = none

//REGION: flat

#let flat-visualizer(flat, config: (:)) = {
  flat
}

//REGION: feeder

/// A function and its arguments that will be run, but if an argument is a component, it will be first visualized, then fed to the function.
///
/// - proc (function): A function to be run with visualized components.
/// - args (arguments): Arguments for `proc`, components within will be first visualized when visualizing the feeder.
/// -> dictionary
#let feeder(proc, ..args) = {
  assert(type(proc) == function, message: "`proc` must be a function.")

  spell(
    spec.feeder.name,
    proc: proc.with(..args.named()),
    components: args.pos(),
  )
}

/// Calls a `feeder.proc` with its components, wrapped in a content block.
///
/// - feeder (dictionary): The `feeder` to visualize.
/// -> content
#let feeder-visualizer(tak, config: (:)) = {
  [#(tak.proc)(..tak.components)]
}

//REGION: question

#let question(point: auto, point-display: auto, label: auto, ..args) = {
  assert(type(point) in (int, decimal) or point == auto)

  spell(
    spec.question.name,
    point: point,
    point-display: point-display,
    id: auto,
    label: label,
    components: args.pos(),
    ..args.named(),
  )
}

#let question-visualizer(qsn, config: (:)) = {
  [
    #figure(
      kind: spec.question.kind,
      // makes numbering into supplement, so refs can completely replace the text
      supplement: _ => (
        spec.question.supplement
          + " "
          + qsn.id.enumerate().map(((x, i)) => numbering(config.question.numbering.at(x), i)).join()
      ),
      numbering: _ => none,

      (config.question.container)(
        grid,
        (
          inset: (
            (x: .3em, y: .65em),
            .65em,
          ),
          columns: (1.65em, 1fr),
          align: (right, left),
        ),
        (
          number: numbering(
            config.question.numbering.at(qsn.id.len() - 1),
            qsn.id.last(),
          ),
          point: point-visualizer(qsn.point, qsn.point-display),
          main: qsn.components.join(),
        ),
      ),
    )
    #qsn.label
  ]
}

//REGION: solution

#let solution(
  supplement: none,
  target: auto,
  target-display: auto,
  label: none,
  ..args,
) = {
  spell(
    spec.solution.name,
    supplement: supplement,
    target: target,
    target-display: target-display,
    label: label,
    components: args.pos(),
    ..args.named(),
  )
}

#let solution-visualizer(sol, config: (:)) = {
  solution-counter.step()
  context [
    // make sure all the grids in this figure use the same uid
    #let uid = solution-counter.get().first()

    #figure(
      kind: spec.solution.kind,
      // makes numbering into supplement, so refs can completely replace the text
      supplement: _ => (
        spec.solution.supplement
          + if sol.target != none {
            [ to #ref(sol.target)]
          }
      ),
      numbering: _ => none,
      (config.solution.container)(
        grid,
        (
          stroke: green + .1pt,
          inset: .65em,
          columns: 1fr,
          align: left,
        ),
        (
          target: target-visualizer(sol.target, sol.target-display),
          supplement: sol.supplement,
          main: sol.components.join(),
          marking: {
            embed-pin(uid)
            context {
              let metas = query(metadata)
              let ms = metas.filter(m => component-type(m.value) == spec.mark.name and m.value.pin == uid)
              if ms == () { return none }

              let mspos = ms.map(m => query(selector(mark-label).before(m.location())).last().location().position())
              let ppos = metas
                .find(m => component-type(m.value) == spec.pin.name and m.value.pin == uid)
                .location()
                .position()

              grid(
                stroke: .1pt,
                columns: (1fr,),
                rows: for (i, mpos) in mspos.enumerate() {
                  // first row: all the way till mpos.y
                  if i == 0 {
                    (mpos.y - ppos.y,)
                  } else {
                    // cur pos - prev pos
                    (mpos.y - mspos.at(i - 1).y,)
                  }
                }
                  + (auto,),
                [],
                ..ms.map(m => m.value.mark)
              )
            }
          },
        ),
      ),
    )
    #sol.label
  ]
}

//REGION: grower

#let branch-grower(branch, parent, qs-count, components-grower, config: (:)) = {
  let btype = component-type(branch)
  let pt = 0

  if btype == spec.flat.name {
    // flat: no action
  } else if btype == spec.question.name {
    // question:
    // - assign ID
    branch.id = parent.id + (qs-count,)
    // - assign label
    if branch.label == auto {
      branch.label = question-labeller(branch.id, config: config)
    } else if type(branch.label) == str {
      branch.label = label(spec.question.label-head + branch.label)
    }
    // - grow components
    (branch.components, pt, _) = components-grower(branch.components, qsn-info(branch))
    // - collect points
    if branch.point == auto {
      branch.point = pt
    }
  } else if btype == spec.solution.name {
    // solution:
    // - assign label
    if type(branch.label) == str {
      branch.label = label(spec.solution.label-head + branch.label)
    }
    // - set target to parent question
    if branch.target == auto {
      branch.target = parent.label
    }
    // update target-display
    if branch.target-display == auto {
      if branch.target == parent.label {
        branch.target-display = none
      }
    }
    // - grow components
    (branch.components, _, _) = components-grower(branch.components, parent)
  } else if btype == spec.feeder.name {
    // feeder:
    // - ignore the feed and continue to its components
    (branch.components, _, qs-count) = components-grower(branch.components, parent, qs-count: qs-count)
  } else {
    panic("Unknown component type `" + btype + "`!")
  }

  // finally return the branch
  return (branch, qs-count)
}

#let grow-branches(branches, parent, qs-count: 0, config: (:)) = {
  // initialize from branches
  branches.fold(
    ((), 0, qs-count),
    ((bs, pt, qc), branch) => {
      // update root question ID
      if component-type(branch) == spec.question.name {
        qc += 1
      }
      // start growing the branch
      let (grown, qc) = branch-grower(
        branch,
        parent,
        qc,
        grow-branches.with(config: config),
        config: config,
      )

      (
        bs + (grown,),
        pt + grown.at("point", default: 0),
        qc,
      )
    },
  )
}

//REGION: visualizer

#let visualize-branches(branches, config: (:)) = {
  branches.map(branch => {
    let btype = component-type(branch)

    if btype == spec.flat.name {
      flat-visualizer(branch, config: config)
    } else {
      // first, visualize its components
      branch.components = visualize-branches(branch.components, config: config)

      // then, call respective visualizer
      if btype == spec.question.name {
        question-visualizer(branch, config: config)
      } else if btype == spec.solution.name {
        solution-visualizer(branch, config: config)
      } else if btype == spec.feeder.name {
        feeder-visualizer(branch, config: config)
      } else {
        panic("Unknown componemnt type `" + btype + "`!")
      }
    }
  })
}

//REGION: wrapper

#let qna-wrapper(..branches, config: (:)) = {
  import "loader.typ": merge-configs
  import "defaults.typ"
  config = merge-configs(defaults, config)

  visualize-branches(
    grow-branches(
      branches.pos(),
      qsn-info(none),
      config: config,
    ).first(),
    config: config,
  ).join()
}
