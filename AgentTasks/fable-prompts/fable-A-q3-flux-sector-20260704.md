# Fable call: fable-A-q3-flux-sector-20260704 (taxonomy A)

## Context

This is the four-day Yang-Mills/mass-gap run, queue item Q3: D12
sector-correct transfer decomposition. The run needs a flux-sector
statement stack that prevents the finite-volume transfer gap from being
silently measured between the trivial sector and a global winding-flux
sector. Current Lean status:

- `PhysicsSM.Draft.NullEdge.GateYM.FluxSectorZ2` defines the Z2 torus
  winding label, separates `fluxGap` from `localGlueballGap`, proves
  concrete Z2 vertex-gauge updates preserve the winding label, and has a
  draft support-level local-algebra slice saying diagonal observable
  multiplication preserves each winding sector.
- `PhysicsSM.Draft.NullEdge.GateYM.FluxSectorGeneral` adds the abstract
  finite-sector support API: sector label maps, sector projections,
  label-preserving finite transfer kernels, and the theorem that such
  kernels preserve sector-supported wavefunctions and commute with the
  diagonal sector projection.
- `FluxSectorZ2.lean` now exposes the concrete Z2 winding-sector data,
  winding-sector projection, winding-label-preserving-kernel predicate,
  abstract finite kernel action, and the support/projection commutation
  wrappers for those kernels.
- The current support-level slice is verified by direct file check and
  targeted module build; it is committed as `ac38785`.
- Q3's required baseline is: define the flux-sector decomposition,
  prove transfer preserves it at least on the Z2 torus, and prove the
  local plaquette algebra preserves the trivial-flux sector. The strong
  target is a general finite-group statement compatible with the Z2
  torus instance.

When executing this call, attach the source file verbatim:

```text
--source-file PhysicsSM/Draft/NullEdge/GateYM/FluxSectorGeneral.lean
--source-file PhysicsSM/Draft/NullEdge/GateYM/FluxSectorZ2.lean
```

Suggested wrapper command:

```text
python Scripts/autonomous_loop/send_claude_review.py \
  --model claude-fable-5 \
  --slug fable-A-q3-flux-sector-20260704 \
  --prompt-file AgentTasks/fable-prompts/fable-A-q3-flux-sector-20260704.md \
  --source-file PhysicsSM/Draft/NullEdge/GateYM/FluxSectorGeneral.lean \
  --source-file PhysicsSM/Draft/NullEdge/GateYM/FluxSectorZ2.lean \
  --max-budget-usd 15
```

## Verbatim Material

Use the attached `FluxSectorGeneral.lean` and `FluxSectorZ2.lean` as the
verbatim material under review. Also read these local run files for context:

- `AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`
- `AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md`, T3/Q3
- `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md`,
  `design:q3-flux-sector`
- `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`, section 14 Q3

## Intended Reading

The current Z2 draft is intended as a finite definition / sector
bookkeeping layer, not a transfer-matrix construction and not a proof of
positive mass gap. The two Bool winding bits are the two Z2 torus
fundamental-cycle fluxes. The D12 local/glueball gap is the gap inside
the Gauss-invariant, zero-momentum, trivial-winding sector. A separate
`fluxGap` name is reserved for the energy separation between trivial and
nontrivial winding sectors.

The current local-algebra theorem is intentionally support-level:
diagonal multiplication by an observable depending on the link field
cannot move a wavefunction from one winding label to another. Local
plaquette multiplication operators should become instances of this, but
the draft does not yet define a full plaquette operator algebra or a
transfer kernel on the Z2 torus.

## Questions

1. Super-stretch primary deliverable: review the current Z2 statement
   stack, then return the strongest defensible Q3 redesign as Lean-ready
   declarations. Aim for the complete general finite-group flux-sector
   decomposition: the sector label, sector projections or support
   predicates, transfer-preservation hypotheses/theorems, local
   plaquette-algebra preservation theorems, and a Z2 torus instance that
   subsumes the attached `FluxSectorZ2.lean`.
2. Fallback if the full redesign is too large: return the three
   highest-leverage partial results in priority order, each with a Lean
   signature and a one-paragraph proof/implementation route.
3. Semantic audit: identify any mismatch between the current Lean
   statements and the intended D12 reading. In particular, check whether
   the support-level diagonal multiplication theorem is the right local
   plaquette-algebra baseline or whether it hides a false stronger
   statement.
4. Falsity/sanity check: test the proposed general finite-group
   statements against Z2, Z3, and a nonabelian finite group such as S3.
   If a proposed statement fails, give the explicit counterexample and
   the corrected strongest statement.

## Output Format

Use these sections:

1. Decision: ACCEPT / REVISE / REJECT the current Z2 stack as a Q3
   baseline.
2. Semantic risks and counterexamples.
3. Redesigned Lean module skeleton, with names, namespaces, imports, and
   theorem statements.
4. Proof DAG: each lemma labeled `provable-now`, `needs-design`, or
   `external/oracle`.
5. Z2 torus integration plan: exact edits to `FluxSectorZ2.lean`.
6. General finite-G path: the next statement file and the smallest
   Aristotle package worth submitting.

## Guardrails

ASCII output. Use spaced forms for escape-hatch tokens in prose. Claim
labels must stay explicit: finite definition, finite identity,
consistency check, asymptotic theorem, reconstruction, or prediction.
Do not conflate flux gap, local/glueball mass gap, Wilson area law,
entanglement area law, or the Jaffe-Witten continuum prize. Lattice
finite-volume statements are not the prize.
