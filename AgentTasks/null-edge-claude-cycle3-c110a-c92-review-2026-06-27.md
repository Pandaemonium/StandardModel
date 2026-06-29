# Claude review packet: cycle 3 C110a and C92 triage

Date: 2026-06-27

## Project context

We are running the null-edge autonomous loop. The active Gate C1 strategy is now:

```text
C1_local:
  retained as a local/no-go and escape-hatch audit.

C1_NU:
  controlled non-ultralocal release. Drop finite-range/exponential locality as
  a primitive requirement, but keep path-sum/resolvent/spectral/finite-volume
  control, true bad-sector inverse gap, ghost-zero exclusion, gauge covariance
  or dressing, Krein audit, anomaly audit, and regulator stability.

C1_NL:
  declared nonlocal fallback only when no controlled non-ultralocal certificate
  is claimed.
```

The decisive constructive route is:

```text
canonical branch observable B(U)
  -> finite polynomial / Riesz / sign / path-sum projector
  -> nonzero origin chiral-index test
  -> true bad-sector inverse gap
  -> path-sum / resolvent / finite-volume control
```

## Subject 1: C110a path-shell kernel bridge

Cycle 3 submitted a focused Aristotle job:

```text
Project: c804899f-1d36-4ba3-bc16-f656c105f164
Target: AgentTasks/aristotle-standalone/c110a-path-shell-kernel-bridge-20260627/C110aPathShellKernel/PathShellEnvelope.lean
```

The theorem is intentionally modest. It should bridge:

```text
finite shell cardinality bound + per-path amplitude bound
  => actual finite shell contribution bound.
```

This responds to your prior critique that scalar envelope summability is not yet
operator-kernel control.

Review questions:

- Is this theorem statement a useful finite bridge, or is it still too weak to
  matter?
- Is the lack of a nonnegativity hypothesis on each `weight p` a semantic issue,
  given that the theorem bounds the signed sum above rather than a norm?
- What should the immediate successor theorem be: nonnegative weights,
  norm-valued weights, matrix/operator norm shell bounds, or summability of
  shell bounds?
- Are there Lean statement repairs Aristotle is likely to need?

## Subject 2: C92 ghost-safety candidate integration triage

A stale C92 job was canceled earlier and continued as a partial-return task.
That continuation now returned a candidate file:

```text
AgentTasks/aristotle-output/03c6e63f-3a39-420e-81d3-173f2611b362/extracted/project-files.tar/output-3_aristotle/PhysicsSM/Draft/NullEdgeGateCGhostSafetyHardened.lean
```

The integration helper reports no placeholders for this new file. However, the
current autonomous-loop `AGENTS.md` contains a strong rule:

```text
No checklist-as-Lean:
  a Draft Lean module must make a statement about real mathematical objects
  tied to the program, such as matrices, operators, spinors, modules, kernels.
  A self-defined record of `Prop` or `Bool` flags that restates a planning
  checklist is not formal progress and belongs in markdown.
```

The C92 candidate defines `GhostZeroSafetyData` as five independent `Prop`
fields and proves logical separation facts about those fields. My current triage
is:

```text
Do not auto-apply C92 as Lean.
Preserve the idea as a ghost-safety audit/checklist note unless or until it is
connected to real program objects.
```

Review questions:

- Is this triage correct under the no-checklist-as-Lean rule?
- Is there any part of the C92 candidate that is strong enough to integrate as
  Lean without laundering a checklist into formal progress?
- What would be the minimal real-object version of C92? For example, should it
  quantify over a concrete propagator-zero datum, residue matrix, Krein form, or
  gauge-coupled branch sector?

## Requested output

Please give:

```text
Findings:
- ordered by severity.

C110a verdict:
- useful / too weak / statement repair needed.

C92 triage verdict:
- apply / reject as checklist-as-Lean / convert to markdown / rewrite around
  real objects.

Next theorem:
- one precise theorem statement or Aristotle job target.
```
