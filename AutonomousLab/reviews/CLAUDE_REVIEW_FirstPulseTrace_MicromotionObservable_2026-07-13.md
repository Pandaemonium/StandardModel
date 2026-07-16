# Claude review: FirstPulseTrace (micromotion anti-collapse observable)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-122724, item QCA-3PLUS1-001
- Source: `AgentTasks/aristotle-standalone/afpl-micromotion-observable-20260713/
  MicromotionObservable/FirstPulseTrace.lean` (89 lines, 0 sorry, Mathlib-only
  standalone), sha256 `385678f2...` verified
- Date: 2026-07-13

## Verdict: ACCEPT

A clean, correctly-scoped successor to AF0: a basis-invariant observable
(`firstPulseTrace = Tr` of the first substep) that actually DISTINGUISHES the
equal-endpoint pair `[flip,flip]` vs `[1,1]` (traces 0 vs 2). It realizes exactly
the Class-1-vs-Class-2 distinction (endpoint spectrum forgets what a micromotion
observable remembers) and is honestly labeled NOT a winding invariant. Two
non-blocking notes. No proof/statement change required.

## The four requested checks

### 1. Basis-invariance semantics - CORRECT

`firstPulseTrace_conjugate (S) (hS : IsUnitary S) (steps) :
firstPulseTrace (conjugateSchedule S steps) = firstPulseTrace steps`, where
`conjugateSchedule S = steps.map (U |-> S U S^H)` (simultaneous conjugation of
every substep by one unitary `S`). Proof: `Tr(S U S^H) = Tr(S^H S U)`
(`trace_mul_cycle`) `= Tr(U)` (`hSleft : S^H S = 1`). This is the correct notion
of basis-invariance for a physical observable - a change of internal basis
conjugates all operators identically, and the trace is conjugation-invariant.
(Only the left identity `S^H S = 1` is used; for a finite square matrix that
already gives `IsUnitary`, so the hypothesis is natural, if marginally stronger
than strictly needed.) Sound.

### 2. Equal-endpoint witness - CORRECT and non-vacuous

`equal_endpoints`: `endpoint [flip,flip] = endpoint [1,1]` (`flip*flip = I =
1*1`). `firstPulseTrace_pulse = 0` (`Tr flip = 0`), `firstPulseTrace_idle = 2`
(`Tr I_2 = 2`). `equal_endpoint_distinct_micromotion`: same endpoint AND
`firstPulseTrace` differs (0 != 2). `flip` is a genuine nontrivial unitary
involution, both loops length 2, so this is non-vacuous and GENUINE - a
basis-invariant scalar that provably resolves two histories the endpoint
collapses. This is the natural strengthening of AF0's non-injectivity: AF0 showed
the endpoint forgets; this shows a basis-invariant observable remembers.

### 3. Scope (observable, explicitly not winding) - CORRECT

Docstring (lines 11-12): "This observable is not claimed to be a topological
winding number. It is the smallest exact anti-collapse fixture that a future
winding must refine." Exactly right and modest. "Trace of the first partial
endpoint" is accurate (`endpoint [U0] = U0`, so `Tr(first pulse) = Tr(first
partial endpoint)`). It claims a basis-invariant micromotion OBSERVABLE, not the
`W3` invariant. Matches the Phenomenologist Class-2 framing: a (weak) micromotion
observable sensitive to ordered history, not the topological invariant.

### 4. Standard-three guards - PASS (replayed)

Independent replay `lake env lean ... FirstPulseTrace.lean`: **EXITCODE=0** with
fully clean output (no `sorry` warning, no `#guard_msgs` mismatch), confirming the
file typechecks (incl. the `!=` coercion) and both guards matched
`[propext, Classical.choice, Quot.sound]` with no `sorryAx`/native/compiler-trust.
Two `#print axioms` guards
(`firstPulseTrace_conjugate`, `equal_endpoint_distinct_micromotion`), both pinned
to `[propext, Classical.choice, Quot.sound]`. No `sorry`/`native_decide`/`axiom`/
`admit`; proofs use only kernel tactics (`cases`/`simp`/`calc`/`trace_mul_cycle`/
`fin_cases`/`norm_num`). The guarded `equal_endpoint_distinct_micromotion`
transitively covers `equal_endpoints` and both trace lemmas.

## Non-blocking notes

- **Basis-invariant but NOT timeframe-invariant.** `firstPulseTrace` inspects the
  FIRST pulse, which is timeframe-dependent (a cyclic shift of the period start
  changes which substep is "first"). A true winding invariant `W3` must be BOTH
  basis- AND timeframe-invariant (my Phenomenologist NS-3 kill test). This is
  precisely why it is "not a winding number" and what "a future winding must
  refine" means - the docstring anticipates it correctly, but it is worth stating
  explicitly as the refinement direction: the next observable must add
  timeframe-invariance (and momentum/`(q,s)` dependence) to become `W3`.
- **`!=` vs `≠` (style).** The statement uses `firstPulseTrace pulseLoop !=
  firstPulseTrace idleLoop` (Bool `bne`, coerced to `Prop`) rather than the
  Mathlib-idiomatic `≠` (`Ne`). It compiles and means "distinct" (`norm_num`
  closes it), and routes any `DecidableEq ℂ` through `Classical.choice` already in
  the standard three - so no correctness or axiom concern, only a minor style
  point; `≠` would be the conventional Prop form.

## Connection to the observable dictionary + narrowest claim

This is the first concrete instance of a Phenomenologist Class-2 (micromotion)
observable beating Class-1 (endpoint): a basis-invariant scalar
`firstPulseTrace` that distinguishes two schedules with identical endpoint. It is
NOT yet the decisive discriminator - that requires the timeframe-invariant,
`(q,s)`-dependent winding `W3` (AF3/AF4). Narrowest claim: on finite unitary
schedules, `firstPulseTrace` (trace of the first substep) is invariant under
simultaneous unitary basis change and takes distinct values (0 vs 2) on the
equal-endpoint pair `[flip,flip]`/`[1,1]`; hence some basis-invariant observable
resolves endpoint-collapsed micromotion. It is explicitly NOT a topological
winding number, timeframe invariant, momentum-resolved, or a single-Weyl/no-go
statement.
