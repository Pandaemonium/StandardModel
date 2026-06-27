# Null-edge trusted theorem promotion policy (job G1)

**No-build audit/policy deliverable. Generated 2026-06-26.**

Scope and method. This is a written policy only. No Lean, Lake, pre-commit, or
build/check command was run while producing it. It implements backlog job G1
("trusted theorem promotion policy for `PhysicsSM/Draft/*`", Section 21.6 of
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`) and operationalizes the
integration invariant of Section 21.8, the Gate-A promotion gate of Section 21.2,
the prime directive and trusted-vs-draft rules of `AGENTS.md`, and the locked
conventions of `docs/CONVENTIONS.md`.

Purpose. Define the criteria, checklist, rejection rules, task-note template, and
review protocol for moving an Aristotle-produced theorem package out of
`PhysicsSM/Draft/*` and into a trusted `PhysicsSM` namespace
(`PhysicsSM.Algebra.*`, `PhysicsSM.Clifford.*`, `PhysicsSM.Spinor.*`,
`PhysicsSM.Lie.*`, `PhysicsSM.Gauge.*`, `PhysicsSM.StandardModel.*`,
`PhysicsSM.Supersymmetry.*`).

Governing principle (restating the prime directive). The Lean kernel checks that
*a* proof of *a* statement is correct. It does not check that the statement is
the intended manuscript claim, that the conventions match the locked repo
conventions, or that the dependencies are themselves trusted. Promotion is
exactly the human/agent review step that closes those gaps. A draft file that
compiles is a candidate, not a promotion.

---

## 0. Definitions

- Draft package: one or more declarations living under `PhysicsSM/Draft/*`,
  typically returned by an Aristotle proof job, plus its task note in
  `AgentTasks/`.
- Trusted namespace: any `PhysicsSM` module outside `Draft/` and outside
  `Oracle/`. Other trusted code and manuscripts are permitted to depend on it.
- Promotion: the act of moving a declaration (statement and proof) from a draft
  module into a trusted module, updating imports, indexes, and provenance.
- Placeholder proof token (forbidden in trusted code): `s o r r y`, `a d m i t`,
  `a x i o m` declarations introduced to discharge a goal, `o p a q u e`
  placeholder definitions, `u n s a f e def`, and any
  `@[implemented_by]`-style escape hatch. (Spelled with spaces here per repo
  text-hygiene rules; the literal tokens are what the scan in `docs/BUILD.md`
  searches for.)
- Claim label: one of the locked labels from `docs/CONVENTIONS.md`
  ("Claim labels"): representation, reconstruction, structural theorem, or
  prediction. Finite identity / finite invariant mass / audit are also used as
  labels for finite algebraic facts.

---

## 1. Promotion checklist

A draft declaration may be promoted only when every item below is satisfied.
Each item maps to one of the required criteria from the job prompt and to the
integration invariant of Section 21.8.

### 1.1 Proof integrity

- [ ] **C1. No placeholder proof tokens in trusted code.** The promoted
  declaration and every new declaration it pulls along contain no `s o r r y`,
  no `a d m i t`, no goal-discharging `a x i o m`, no `o p a q u e` placeholder,
  no `u n s a f e def`, and no `@[implemented_by]`. This must hold transitively:
  the placeholder scan in `docs/BUILD.md` is run over the promoted file, and
  `#print axioms <decl>` shows only the standard kernel axioms
  (`propext`, `Classical.choice`, `Quot.sound`); any other axiom in the closure
  is a blocker.
- [ ] **C2. The proof is accepted by the kernel under the pinned toolchain.**
  The file elaborates under `leanprover/lean4:v4.28.0` (the frozen pin; do not
  upgrade) with no errors and no `s o r r y` warnings.

### 1.2 Semantic alignment

- [ ] **C3. Theorem statement semantically matches the intended manuscript
  claim.** The Lean statement says what the manuscript / working-plan target
  says: same hypotheses, same scalar field, same quotient/structure
  representation, same signs, same normalizations, correct distinction between
  groups, Lie algebras, representations, and concrete matrices, and all implicit
  physics assumptions made explicit. The statement has not been silently
  weakened, specialized, or made vacuously true to ease the proof. (See the
  Section 4 review protocol for how this is verified.)
- [ ] **C4. Claim label stated.** The docstring records exactly one claim label
  (representation / reconstruction / structural theorem / prediction, or finite
  identity / audit for finite algebraic facts) and the label is justified.
  Prediction labels are forbidden until a real codimension relation or rank
  deficit survives redundancy and field-redefinition checks (Section 21.5,
  Gate F). A "structural theorem" label requires that the forcing algebraic
  inputs are named as hypotheses.

### 1.3 Declared conventions (the Section 21.8 integration invariant)

Every trusted theorem must declare these in its module or declaration docstring.
A promotion that leaves any of them implicit is rejected.

- [ ] **C5. Metric signature declared.** States the mostly-minus Lorentzian
  signature `+(time)^2 - (space)^2` (null `p^2 = 0`, massive on-shell
  `p^2 = m^2`), or, if it genuinely uses the opposite signature, lives behind an
  explicit namespace or names the conversion lemma. (`docs/CONVENTIONS.md`,
  "Metric signature", Locked.)
- [ ] **C6. Grading conventions declared.** Names which gradings appear and keeps
  them distinct: spacetime chirality `Gamma_s`, internal grading `chi_E`, and
  cochain/form-degree grading `epsilon_form`. No grading is used to silently
  repair a sign in another grading. (`docs/CONVENTIONS.md`, "Gradings", Locked.)
- [ ] **C7. Kinetic sign and mass-shell convention declared.** States the
  super-Dirac square sign convention in use and which of `+Phi_H^2` /
  `-Phi_H^2` it commits to, with the corresponding grading hypothesis
  (`[Gamma_s, Phi_H] = 0` for `+Phi_H^2`; `{Gamma_s, Phi_H} = 0` for
  `-Phi_H^2`). For branch-count / no-doubling content, states that the physical
  test is determinant-level (`det D_+(q) = 0`) or the mass-shell equation, not
  coefficient-vector zeros alone. Names the kinetic operator with the locked
  identity `K_null = Phi_H^2` (no double counting; the Plucker/null-spread term
  is kinetic-side, the Higgs/Yukawa term is internal zero-order side).
  (`docs/CONVENTIONS.md`, "Super-Dirac square signs", "Branch-count / no-doubling
  test", "No double counting".)
- [ ] **C8. Frame/soldering normalization declared.** States the dual-soldered
  architecture `D_N = sum_a c(alpha^a) nabla_{ell_a}` (null directions `ell_a`
  for support, dual covectors `alpha^a` for Clifford soldering), and imports /
  references the shared `NullSolderFrame` (B0) data rather than re-defining local
  frame, Gram, or inverse-Gram structures. The diagonal architecture
  `sum_a c(ell_a^flat) nabla_{ell_a}` appears only as a documented negative
  comparison. If `T_frame` is nonzero it is classified (frame/tetrad defect,
  torsion/nonmetricity-like term, or continuum contamination), never hidden.
  (`docs/CONVENTIONS.md`, "Dual-soldered Dirac architecture", "Local frame and
  covariance", "Frame/tetrad defect"; Section 21.3.)

### 1.4 Dependencies and provenance

- [ ] **C9. Dependencies are trusted or deliberately local.** Every non-Mathlib
  declaration the statement and proof depend on is either (a) already in a
  trusted `PhysicsSM` namespace, or (b) a definition deliberately promoted in the
  same change and itself passing this checklist. The promoted file does not
  `import` any `PhysicsSM/Draft/*` module and does not reference any `Oracle/`
  declaration as a proof step (oracle/CAS outputs justify fixtures, never trusted
  theorems). If a needed definition must stay local for now, that is recorded as
  a deliberate-local decision in the task note with a reason and a follow-up.
- [ ] **C10. Source/provenance recorded.** The docstring (or a linked metadata
  entry) records source + convention for every nontrivial declaration inspired by
  a paper, book, repository, or CAS output, including the originating Aristotle
  project id and the returning task note. For octonion content, provenance notes
  the project XOR binary-label convention and any Baez/Furey relabeling done
  through `PhysicsSM.Algebra.Octonion.ConventionBridge` (raw Baez/Furey formulas
  must not be copied). Licensing of any consulted external code is recorded;
  GPL/LGPL/AGPL or unclear-license code is never copied into trusted source.

### 1.5 No convention drift, and the gate prerequisite

- [ ] **C11. No convention drift from `docs/CONVENTIONS.md`.** The declaration's
  metric, octonion basis/sign, grading separation, kinetic sign, double-counting
  split, claim-label usage, gauge/Higgs wording, and electroweak normalization
  all match the Locked entries of `docs/CONVENTIONS.md`. Where a convention is
  marked Working or Unlocked, the declaration states its assumption locally and
  does not present it as settled. Any place where the Lean choice differs from a
  Locked convention is a hard stop (Section 3), not a silent edit.
- [ ] **C12. Gate A passed for finite-square-dependent results.** If the
  declaration is, or depends on, finite super-Dirac square content, Gate A must
  have passed first: super-Dirac square sign audit, wrong-grading
  counterexamples, and convention integration audit all settled. No trusted
  theorem may depend on finite-square work before Gate A passes (Section 21.2).
  Likewise, S8 scalar/gauge null-kinetic reconstruction must be re-audited
  against B1/B3 before promotion (Section 21.3).

### 1.6 Lean checks to run before promotion

These are the appropriate checks; record in the task note exactly which were run
and their outcome (do not claim a command passed unless it was actually run).
This policy document itself is a no-build job and ran none of them.

- [ ] **C13a.** `lake env lean PhysicsSM/Draft/<File>.lean` on the draft file (no
  ProofWidgets dependency) - elaborates clean.
- [ ] **C13b.** Placeholder scan from `docs/BUILD.md` over the file - zero hits
  for `s o r r y` / `a d m i t` / placeholder `a x i o m` / `o p a q u e` /
  `u n s a f e`.
- [ ] **C13c.** `#print axioms <decl>` for each promoted declaration - only the
  standard kernel axioms appear.
- [ ] **C13d.** After moving into the trusted module:
  `lake build PhysicsSM.<Trusted.Module>` (targeted), then `lake build` (full),
  so the trusted corpus still builds as a whole.
- [ ] **C13e.** `pre-commit run --all-files` on the touched files (text hygiene:
  UTF-8 no BOM, LF, single final newline, no trailing whitespace, ASCII-only in
  code unless Unicode is semantically required).
- [ ] **C13f.** Index/provenance update commands from `docs/BUILD.md` if the
  promotion adds a public trusted declaration to an index document.

Promotion is authorized only when C1 through C13 are all satisfied.

---

## 2. Rejection / draft-only criteria

A package must stay in `PhysicsSM/Draft/*` (or be sent back to handoff) if any of
the following hold. These are the negations and danger-signs of Section 1, plus
the `AGENTS.md` red flags.

Hard rejections (do not promote; fix first):

- R1. Any placeholder proof token in the closure: `s o r r y`, `a d m i t`,
  goal-discharging `a x i o m`, `o p a q u e` placeholder, `u n s a f e def`, or
  `@[implemented_by]`. A `s o r r y` is a handoff marker, never a success.
- R2. `#print axioms` shows a nonstandard axiom, or the proof depends on a draft
  module or an `Oracle/` declaration.
- R3. The statement was weakened, specialized, or made vacuously / trivially true
  to make the proof pass, or it is true only because a hypothesis is
  unsatisfiable.
- R4. Statement/manuscript mismatch: wrong hypotheses, wrong scalar field, wrong
  signs or normalization, group vs Lie algebra vs representation vs concrete
  matrix confusion, or an implicit physics assumption left unstated.
- R5. A required convention declaration is missing (metric C5, grading C6,
  kinetic/mass-shell C7, frame/soldering C8) - the Section 21.8 invariant fails.
- R6. Convention drift from a Locked entry of `docs/CONVENTIONS.md` (e.g. opposite
  metric signature without a namespace/conversion lemma; Baez/Furey octonion
  formula copied without the convention bridge; `+Phi_H^2` claimed without
  `[Gamma_s, Phi_H] = 0`; no-doubling claimed from coefficient zeros alone;
  double-counting masses as `m_Plucker^2 + m_Higgs^2`; "spectral gap" used as the
  universal slogan; a gauge redundancy described as literally breaking).
- R7. Missing or unverifiable provenance / claim label, or a claim label stronger
  than the evidence (e.g. a prediction label without a surviving codimension /
  rank-deficit relation; a structural-theorem label without the forcing
  hypotheses named).
- R8. Finite-square-dependent content where Gate A has not passed (C12), or S8
  reconstruction not re-audited against B1/B3.
- R9. An `AGENTS.md` red flag is present: need for a new `a x i o m`; dependence
  on unstated analytic assumptions; ambiguity between group and Lie-algebra
  representations; convention mismatch between sources; copyleft code that seems
  necessary to copy; a proof that works only after weakening the statement;
  hidden associativity assumptions for octonions; a result based only on
  floating-point / `n a t i v e _ d e c i d e`-without-justification evidence;
  Standard Model normalization ambiguity; an E8 branching rule without source or
  oracle confirmation.

Keep-as-draft (legitimately incomplete, not a defect to "fix" by promotion):

- D1. The package is a deliberate negative comparison, counterexample, or audit
  scaffold (e.g. wrong-grading counterexamples, diagonal-architecture trace
  obstruction) whose home is `Draft/` by design.
- D2. The result is correct but its supporting convention in
  `docs/CONVENTIONS.md` is still Working or Unlocked; keep it local with stated
  assumptions until the convention is locked.
- D3. The proof is complete but depends on a still-local definition that has not
  yet been reviewed for promotion; promote the definition first (or together).

Failure protocol on rejection. Record, per `AGENTS.md`: the exact declaration,
the failing criterion id (R/D above), what was tried, the suspected missing
lemma or convention, the problem class (syntax / imports / statement /
missing-API / convention-mismatch / mathematical-falsehood), and the recommended
next step. A useful documented rejection beats a misleading promotion.

---

## 3. Recommended task-note template for future integrations

Place at the top of the integration task note in `AgentTasks/` (one note per
promotion). Spell placeholder tokens with spaces in prose. ASCII only.

```text
# Promotion: <PhysicsSM.Trusted.Module>.<declName>

## Provenance
- Aristotle project id: <id>
- Returned draft file: PhysicsSM/Draft/<File>.lean
- Returning task note: AgentTasks/<note>.md
- Source(s): <paper/book/repo/CAS> + convention; license status: <...>
- Context pack: docs/context-packs/<pack> (if used)

## Target declaration
- Draft name -> trusted name: <Draft.x> -> <PhysicsSM....x>
- One-line intended manuscript claim: <...>
- Claim label: <representation | reconstruction | structural theorem |
  prediction | finite identity | audit>  (justification: <...>)

## Declared conventions (Section 21.8 invariant)
- Metric signature: mostly-minus +(time)^2 - (space)^2  [or: <namespace/conv lemma>]
- Gradings used: Gamma_s / chi_E / epsilon_form  (kept distinct: yes)
- Kinetic sign + mass-shell: <+Phi_H^2 with [Gamma_s,Phi_H]=0 | -Phi_H^2 with
  {Gamma_s,Phi_H}=0 | n/a>; no-doubling test = determinant/mass-shell level;
  K_null = Phi_H^2 (no double counting)
- Frame/soldering: dual-soldered D_N = sum_a c(alpha^a) nabla_{ell_a};
  NullSolderFrame (B0) imported: <yes/no>; T_frame classification: <...>

## Dependencies
- Trusted deps: <list>
- Deliberately-local deps (with reason + follow-up): <list>
- Confirmed: no import of PhysicsSM/Draft/*; no Oracle/ proof step: <yes>

## Gate status
- Gate A passed (if finite-square-dependent): <yes/no/n.a.>
- S8 re-audited vs B1/B3 (if applicable): <yes/no/n.a.>
- Convention drift vs docs/CONVENTIONS.md: <none | list>

## Lean checks actually run (command : outcome)
- lake env lean PhysicsSM/Draft/<File>.lean : <...>
- placeholder scan (docs/BUILD.md) : <...>
- #print axioms <decl> : <axioms listed>
- lake build PhysicsSM.<Trusted.Module> : <...>
- lake build : <...>
- pre-commit run --all-files : <...>

## Review sign-off (Section 4 protocol)
- Semantic alignment reviewed by: <agent/human>  result: <pass/fail + notes>

## Decision
- [ ] PROMOTE   [ ] KEEP DRAFT (reason id: R#/D#)   [ ] SEND BACK TO HANDOFF
```

---

## 4. Miniature review protocol for semantic alignment

A focused, repeatable procedure to verify C3 (statement matches the intended
claim) and C4/C11 (label and convention fidelity). It is deliberately short so
it is actually run for every promotion. The kernel does not do this step; the
reviewing agent does (`AGENTS.md`, "Aristotle policy summary").

Step 1. Restate from the source, blind. Without reading the Lean statement,
write one English sentence of the intended manuscript claim straight from the
working plan / manuscript target, including hypotheses, scalar field, signs, and
normalization.

Step 2. Read the Lean statement and translate it back. Translate the actual Lean
`theorem` head into one English sentence. Compare the two sentences clause by
clause:

- same hypotheses (none added to make it true, none dropped that it needs)?
- same scalar field and same structure (group vs Lie algebra vs representation vs
  concrete matrix; quotient represented correctly)?
- same signs, normalization, and parenthesization (especially octonion
  non-associative products and gamma/kinetic signs)?
- implicit physics assumptions made explicit?

Step 3. Vacuity and triviality probe. Confirm the statement is not vacuously true
(no unsatisfiable hypothesis), not definitionally `True`, and not silently
weakened. Check whether the proof leans on `exfalso` / `by_contra` /
`contrapose` in a way that signals a contradictory-hypothesis shortcut rather
than a genuine argument; if so, confirm it is an honest contrapositive.

Step 4. Convention cross-check. Verify each declared convention (C5-C8) against
the Locked entries of `docs/CONVENTIONS.md`. For any value that could drift
(metric sign, octonion anchor products `e011*e111=e100`, `e101*e111=e010`,
`e110*e111=e001`, the `+Phi_H^2` grading hypothesis, the `K_null = Phi_H^2`
no-double-counting split, electroweak `Q = T_3 + Y/2`, `Y(H)=1`,
`H_0=(0, v/sqrt 2)`), point at the exact convention line that licenses it.

Step 5. Label and dependency check. Confirm the claim label is the weakest one
the evidence supports (prefer reconstruction/structural theorem over prediction
unless the prediction gate is met), and that every dependency is trusted or
deliberately local with a recorded reason.

Step 6. Verdict. Record pass/fail with notes in the task note. Any clause-level
mismatch in Step 2, any vacuity flag in Step 3, any unlicensed value in Step 4,
or any over-strong label in Step 5 is a fail -> route to Section 2 (keep draft or
send back). Only a clean pass authorizes the C13 build checks and promotion.

---

## 5. Operating notes

- Integrate before expanding (Section 21.1): this policy is a risk-reduction
  control, run before new broad proof waves, not after.
- Promote small and reviewable: prefer promoting one well-scoped declaration with
  exact provenance over a large bundle; a large speculative bundle is technical
  debt.
- Do not churn: if a draft cannot pass the checklist, leave it in `Draft/` with a
  documented handoff note (the failing criterion id, the blocker class, and the
  next step) rather than forcing it through.
- This document is a policy artifact only; promoting any specific package still
  requires running the C13 Lean checks under the pinned toolchain and recording
  their actual outcomes in the task note.
