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

/// Gather immediate children components of a type, they can be _more than 1 layer apart_.
///
/// - comp (dictionary): The component to find children from.
/// - type (auto, str): The type of children to find. Set to type of the `comp` if left `auto`.
/// -> array
#let gather-child(comp, type: auto) = {
  if type == auto {
    type = comp.type
  }
  comp
    .components
    .map(leaf => {
      let ltype = component-type(leaf)
      if ltype == type {
        leaf
      } else if ltype != spec.components.flat {
        gather-child(leaf, type: type)
      }
    })
    .filter(el => el != none)
    .flatten()
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

#let question(point: auto, point-display: auto, ..args) = {
  assert(type(point) in (int, decimal) or point == auto)

  spell(
    spec.components.question,
    point: point,
    point-display: point-display,
    id: auto,
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

    #label(
      spec.question.label-head
        + qsn.id.enumerate().map(((x, i)) => numbering(spec.question.labelling.at(x), i)).join("-"),
    )
  ]
}

#let solution(supplement: [*Solution: *], ..args) = {
  spell(
    spec.components.solution,
    supplement: supplement,
    components: args.pos(),
    ..args.named(),
  )
}

#let solution-visualizer(sol) = {
  block(
    stroke: green + .1pt,
    inset: .65em,
    sol.supplement + sol.components.join(),
  )
}


#let branch-grower(branch, parent, qs-num, components-grower) = {
  let btype = component-type(branch)
  let pt = 0

  if btype == spec.components.flat {
    // flat: no action
    branch
  } else if btype == spec.components.solution {
    // solution:
    // - set target to parent question
    branch.target = parent
    // - grow components
    (branch.components, _) = components-grower(branch.components, parent)

    branch
  } else if btype == spec.components.question {
    // question:
    // - assign ID
    branch.id = parent + (qs-num,)
    // - grow components
    (branch.components, pt) = components-grower(branch.components, branch.id)
    // - collect points
    if branch.point == auto {
      branch.point = pt
    }

    branch
  } else if btype == spec.components.feeder {
    none
  } else {
    branch
  }
}

#let grow-branches(branches, parent) = {
  // initialize from branches
  branches
    .fold(
      ((), 0, 0),
      ((bs, pt, num), branch) => {
        // update root question ID
        if component-type(branch) == spec.components.question {
          num += 1
        }
        // start growing the branch
        let grown = branch-grower(branch, parent, num, grow-branches)

        (
          bs + (grown,),
          pt + grown.at("point", default: 0),
          num,
        )
      },
    )
    .slice(0, 2)
}

#let visualize-branches(branches) = {
  branches.map(branch => {
    let btype = component-type(branch)

    if btype == spec.components.flat {
      flat-visualizer(branch)
    } else {
      // first, visualize its components
      branch.components = visualize-branches(branch.components)

      if btype == spec.components.question {
        question-visualizer(branch)
      } else if btype == spec.components.solution {
        solution-visualizer(branch)
      } else if btype == spec.components.feeder {
        feeder-visualizer(branch)
      }
    }
  })
}
