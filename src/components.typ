#import "spec.typ": spec, spell, component-type
#import "loader.typ": merge-configs
#import "markscheme.typ"

//REGION: author

/// Construct a callable author entry.
/// Returns a `function`, which:
/// - is intended to be supplied to this template's functions, where asked. Other packages/templates likely do not respect its usage;
/// - can be left uncalled, i.e. not appending "()" or "[]" to it;
/// - can be called with a suffix, e.g. `returned-func[suffix content]`.
/// See more of its usage in documentation of the `setup()` function.
///
/// - firstname (str, content): The first name.
///   [WARN] If `content` is given, make sure Typst can convert it to `str`, or also provide an `ascii`; else in the author metadata it will show as "`<unsupported>`"
/// - lastname (str, content): The last name, i.e. surname.
///   [WARN] If `content` is given, make sure Typst can convert it to `str`, or also provide an `ascii`; else in the author metadata it will show as "`<unsupported>`"
/// - id (int, str, content): An ID, perhaps a student number.
///  Will be wrapped in `raw()`, displaying with "code" style.
///  If Typst cannot convert it to `str`, the above will not apply.
/// - ascii (str, none): A string, which is the Ascii representation of the *full* name.
/// -> function
#let author(firstname, lastname, id, ascii: none) = (..args) => {
  let argp = args.pos()
  let argn = args.named()

  (
    (
      name: (
        first: firstname,
        last: lastname,
      ),
      id: id,
      ascii: ascii,
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

/// Produce `line` number of empty line(s) using `linebreak`, or an empty block till the end of the current container when `line < 0`.
///
/// - lines (int): The number of empty lines to produce. A number less than 0 means all the way to the end of container instead.
/// -> content
#let spacer(lines) = if lines > -1 { linebreak() * lines } else { v(1fr) }

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

/// Produce a label based on a question ID.
///
/// - id (array): The question's ID, an array of integers.
/// - head (str): The head of the label generated.
/// - config (dictionary): The config containing question labelling information.
/// -> label
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

/// Visualize a question target, a `ref` or a `label` in general.
///
/// - target (label): The target question's label.
/// - target-display (content, str, function, auto): The display guide/override for the target.
///   - `auto` → a `ref()` to the target label, aligned right.
///   - `function` → called with `target`, and whatever returned.
///   - otherwise, whatever `target-display`, wrapped in a `link()` to `target`, aligned right.
/// -> content
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

//REGION: flat

/// Visualize "flat" content: stuff not managed or processed by this template.
///
/// - flat (any): The content, anything.
/// - config (dictionary): The config, does nothing for now.
/// -> any
#let flat-visualizer(flat, config: (:)) = {
  flat
}

//REGION: feeder

/// A function and its arguments that will be run, but if an argument is a component, it will be first visualized, then fed to the function.
/// - Visualize: This template's helper functions, e.g. `question` and `solution`, produce data that is intended to be visualized by wrapper functions, instead of being put to the document directly. Visualization is the process that such data is turned into display-ready content.
///
/// - proc (function): A function to be run with visualized components.
/// - args (arguments): Arguments for `proc`, components within will be first visualized when visualizing the feeder.
/// -> dictionary
#let feeder(
  proc,
  config: (:),
  ..args,
) = {
  assert(type(proc) == function, message: "`proc` must be a function.")

  spell(
    spec.feeder.name,
    proc: proc.with(..args.named()),
    components: args.pos(),
    config: config,
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

/// Produce a question object.
///
/// - point (int, decimal, float, auto): The point the question is worth.
///   Can be left `auto`:
///   - if there are sub-questions in `args`, the sum of their `point`s becomes this `point`;
///   - if there is no sub-question, it becomes 0.
///   [WARN] For precision, `float` value is converted to `decimal` through `str`.
/// - point-display (any, function, auto): The display guide/override for the point value.
/// - label (str, label, auto): The label for the question.
///   - `auto` → question is automatically labelled with its question number.
///   - `str` → question is labelled with a label comprised of a identifying head, then this `label`.
///   - otherwise, whatever `label`, but it should be a `label`.
/// - config (dictionary): The config used in question processing.
/// - args (arguments): The sub-elements of the question, and API reserve.
///   - positional (like `value, value,`) → the question's sub-elements, can be anything, including `question` and `solution`.
///   - named (like `name: value,`) → reserved for potential modding. Named `args` is added to the question object produced, and can be used by custom processors.
/// -> dictionary
#let question(
  point: auto,
  point-display: auto,
  label: auto,
  config: (:),
  ..args,
) = {
  if type(point) == float {
    point = decimal(str(point))
  }

  spell(
    spec.question.name,
    point: point,
    point-display: point-display,
    id: auto,
    label: label,
    components: args.pos(),
    config: config,
    ..args.named(),
  )
}

#let question-visualizer(qsn, config: (:)) = {
  config = merge-configs(config, qsn.config)
  [
    #show: config.question.rule

    #block[
      #figure(
        kind: spec.question.kind,
        // makes numbering into supplement, so refs can completely replace the text
        supplement: _ => (
          spec.question.supplement
            + " "
            + qsn.id.enumerate().map(((x, i)) => numbering(config.question.numbering.at(x), i)).join()
        ),
        numbering: _ => h(-.65em),
      )[]
      #qsn.label
      #(config.question.container)(
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
      )
    ]
  ]
}

//REGION: solution

// unique solution count, used for markscheme
#let solution-counter = counter(spec.solution.name)

#let solution(
  supplement: none,
  target: auto,
  target-display: auto,
  label: none,
  config: (:),
  ..args,
) = {
  spell(
    spec.solution.name,
    supplement: supplement,
    target: target,
    target-display: target-display,
    label: label,
    components: args.pos(),
    config: config,
    ..args.named(),
  )
}

#let solution-visualizer(sol, config: (:)) = {
  config = merge-configs(config, sol.config)
  solution-counter.step()
  context [
    // make sure all the grids in this figure use the same uid
    #let uid = solution-counter.get().first()

    #show: config.solution.rule

    #block[
      #figure(
        kind: spec.solution.kind,
        // makes numbering into supplement, so refs can completely replace the text
        supplement: _ => (
          spec.solution.supplement
            + if sol.target != none {
              [ to #ref(sol.target)]
            }
        ),
        numbering: _ => h(-.65em),
      )[]
      #sol.label
      #(config.solution.container)(
        grid,
        (
          stroke: config.colors.solution.major + .5pt,
          inset: .65em,
          columns: 1fr,
          align: left,
        ),
        (
          target: target-visualizer(sol.target, sol.target-display),
          supplement: sol.supplement,
          main: sol.components.join(),
          marking: markscheme.marking-grid.with(uid),
        ),
      )
    ]
  ]
}

//REGION: grower

#let branch-grower(branch, parent, qs-count, components-grower, config: (:)) = {
  let btype = component-type(branch)
  let pt = 0

  if btype == spec.flat.name {
    // flat: no action
  } else {
    config = merge-configs(config, branch.config)

    if btype == spec.question.name {
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
      let config = merge-configs(config, branch.config)

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

#let qns-nullifier(body) = {
  show figure: it => if it.kind in ("question", "solution").map(e => spec.at(e).kind) {
    none
  } else {
    it
  }

  body
}
