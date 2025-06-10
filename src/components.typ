#let spec = (
  magic: "lacy",
  class: "ubc-math-project",
  components: (
    flat: "flat",
    question: "question",
    solution: "solution",
    feeder: "feeder",
  ),
  question: (
    kind: "lacy-question",
    supplement: "Question",
    numbering: (
      "1.",
      "a.",
      "i.",
    ),
    label-head: "qs:",
    labelling: (
      "1",
      "a",
      "i",
    ),
  ),
  solution: (
    kind: "lacy-solution",
    supplement: "Solution",
    label-head: "sn:",
    labelling: (
      "1",
      "a",
      "i",
    ),
  ),
)

/// Generate text for point based on a numeric point value and a display guide.
/// When `point-display == auto`, generate appropriate English point text.
/// [WARN] Does not leave trailing space when `point-display` is a `function`.
///
/// - point (int, decimal): The numeric point.
/// - point-display (auto, str, content, function): The content to display, give `auto` for automatic point display, can be a function that accepts a numeric point argument.
/// -> content
#let point-text(point, point-display) = {
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

#let id-label(id, head: spec.question.label-head) = {
  label(head + id.enumerate().map(((x, i)) => numbering(spec.question.labelling.at(x), i)).join("-"))
}

/// Cast a magic of lacy dict.
///
/// - impl (dictionary): Implementation of component identifiers.
/// - type (str): Type of the component.
///
/// -> dictionary
#let spell(type, ..args) = {
  assert(type in spec.components.keys(), message: "Component type \"" + type + "\" is not supported")
  return (magic: spec.magic, class: spec.class, type: type, ..args.named())
}

#let component-type(comp) = {
  if type(comp) == dictionary {
    if comp.at("magic", default: none) == spec.magic and comp.at("class", default: none) == spec.class {
      return comp.type
    }
  }
  return spec.components.flat
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
    } else if component-type(branch) != spec.components.flat {
      let (found, comp) = find-component(branch.components, ..pred)
      if found { return (true, comp) }
    }
  }

  return (false, none)
}

#let flat-visualizer(flat) = {
  flat
}

/// A function and its arguments that will be run, but if an argument is a component, it will be first visualized, then fed to the function.
///
/// - proc (function): A function to be run with visualized components.
/// - args (arguments): Arguments for `proc`, components within will be first visualized when visualizing the feeder.
/// -> dictionary
#let feeder(proc, ..args) = {
  assert(type(proc) == function, message: "`proc` must be a function.")

  spell(
    spec.components.feeder,
    proc: proc.with(..args.named()),
    components: args.pos(),
  )
}


/// Calls a `feeder.proc` with its components, wrapped in a content block.
///
/// - feeder (dictionary): The `feeder` to visualize.
/// -> content
#let feeder-visualizer(tak) = {
  [#(tak.proc)(..tak.components)]
}

#let question(point: auto, point-display: auto, label: auto, ..args) = {
  assert(type(point) in (int, decimal) or point == auto)

  spell(
    spec.components.question,
    point: point,
    point-display: point-display,
    id: auto,
    label: label,
    components: args.pos(),
    ..args.named(),
  )
}

#let question-visualizer(qsn) = {
  [
    #figure(
      kind: spec.question.kind,
      supplement: spec.question.supplement,
      numbering: _ => qsn.id.enumerate().map(((x, i)) => numbering(spec.question.numbering.at(x), i)).join(),
      grid(
        stroke: orange + .1pt,
        inset: .65em,
        columns: (2.4em, 1fr),
        align: (right, left),
        numbering(
          spec.question.numbering.at(qsn.id.len() - 1),
          qsn.id.last(),
        ),
        point-text(qsn.point, qsn.point-display) + qsn.components.join(),
      ),
    )
    #if qsn.label == auto {
      id-label(qsn.id)
    } else if type(qsn.label) == str {
      label(spec.question.label-head + qsn.label)
    } else {
      qsn.label
    }
  ]
}

#let solution(
  supplement: [*Solution: *],
  target: auto,
  target-display: auto,
  label: none,
  ..args,
) = {
  spell(
    spec.components.solution,
    supplement: supplement,
    target: target,
    target-display: target-display,
    label: label,
    components: args.pos(),
    ..args.named(),
  )
}

#let solution-visualizer(sol) = {
  let target-display = (
    {
      if sol.target-display == auto [
        #set align(right)
        #ref(id-label(sol.target))
      ] else {
        if type(sol.target-display) == function {
          (sol.target-display)(sol.target)
        } else if sol.target-display != none [
          #set align(right)
          #link(id-label(sol.target), sol.target-display)
        ] else {
          none
        }
      }
    }
  )
  [
    #figure(
      kind: spec.solution.kind,
      supplement: spec.solution.supplement,
      numbering: _ => sol.target.enumerate().map(((x, i)) => numbering(spec.question.numbering.at(x), i)).join(),
      grid(
        stroke: green + .1pt,
        inset: .65em,
        columns: 1fr,
        align: left,
        [
          #target-display#sol.supplement#sol.components.join()
        ],
      ),
    )
    #if type(sol.label) == str {
      label(spec.solution.label-head + sol.label)
    } else {
      sol.label
    }
  ]
}


#let branch-grower(branch, parent, qs-count, components-grower) = {
  let btype = component-type(branch)
  let pt = 0

  if btype == spec.components.flat {
    // flat: no action
  } else if btype == spec.components.solution {
    // solution:
    // - set target to parent question
    if branch.target == auto {
      branch.target = parent
    }
    // update target-display
    if branch.target-display == auto {
      if branch.target == parent {
        branch.target-display = none
      }
    }
    // - grow components
    (branch.components, _, _) = components-grower(branch.components, parent)
  } else if btype == spec.components.question {
    // question:
    // - assign ID
    branch.id = parent + (qs-count,)
    // - grow components
    (branch.components, pt, _) = components-grower(branch.components, branch.id)
    // - collect points
    if branch.point == auto {
      branch.point = pt
    }
  } else if btype == spec.components.feeder {
    // feeder:
    // - ignore the feed and continue to its components
    (branch.components, _, qs-count) = components-grower(branch.components, parent, qs-count: qs-count)
  } else {
    panic("Unknown component type `" + btype + "`!")
  }

  // finally return the branch
  return (branch, qs-count)
}

#let grow-branches(branches, parent, qs-count: 0) = {
  // initialize from branches
  branches.fold(
    ((), 0, qs-count),
    ((bs, pt, qc), branch) => {
      // update root question ID
      if component-type(branch) == spec.components.question {
        qc += 1
      }
      // start growing the branch
      let (grown, qc) = branch-grower(branch, parent, qc, grow-branches)

      (
        bs + (grown,),
        pt + grown.at("point", default: 0),
        qc,
      )
    },
  )
}

#let visualize-branches(branches) = {
  branches.map(branch => {
    let btype = component-type(branch)

    if btype == spec.components.flat {
      flat-visualizer(branch)
    } else {
      // first, visualize its components
      branch.components = visualize-branches(branch.components)

      // then, call respective visualizer
      if btype == spec.components.question {
        question-visualizer(branch)
      } else if btype == spec.components.solution {
        solution-visualizer(branch)
      } else if btype == spec.components.feeder {
        feeder-visualizer(branch)
      } else {
        panic("Unknown componemnt type `" + btype + "`!")
      }
    }
  })
}
