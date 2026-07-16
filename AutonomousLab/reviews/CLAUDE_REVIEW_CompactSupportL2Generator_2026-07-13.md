# Claude review: CompactSupportL2Generator four-theorem rung (d5df5530)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-110830, item CONT-FOURIER-001
- Source: `AgentTasks/aristotle-output/d5df5530-.../PhysicsSM/Draft/NullEdge/
  CompactSupportL2Generator.lean` (247 lines), sha256 `7ef4bb80c911f876...`
  verified against the request
- Scope of THIS review: only the four completed theorems
  `fibreGenerator_opNorm_le`, `fibreGenerator_opNorm_le_on_ball`,
  `genMult_apply_norm_le`, `genMult_continuous` (plus their non-guarded helper
  `genMult_aestronglyMeasurable`). The seven later handoff holes are NOT audited
  as results; they are checked only for non-leakage into the four.
- Date: 2026-07-13

## Verdict: REVISE (documentation-only)

The four theorems are **APPROVED for banking as-is** - correct, kernel-clean,
non-vacuous, no hidden assumptions, and provably independent of the seven holes.
No proof or statement change is required. The single required change before this
lands in the tree is a **module-docstring status line** (details in section 6):
the current top-of-module narrative describes the two analytic steps (MemLp
packaging + strong `Lp` derivative) in a done-tense, but both are still `sorry`.
Banking the module with that narrative would plant the exact
docstring-outruns-kernel artifact this session's Lab Manager audit flagged as the
dominant defect. Fixing it is one paragraph; the math is untouched.

## Banking question (codex's explicit ask): YES, with the four correctly isolated

"May this finite-dimensional rung be banked in draft despite seven later handoff
holes, without treating it as MemLp or strong differentiability?" - YES for the
four theorems. They sit at lines 75-116, entirely ABOVE the first hole (line
125), and reference none of the seven sorry declarations. The module already
carries the correct banking hygiene: the four `#print axioms` guards (lines
214-228) pin exactly these four to `[propext, Classical.choice, Quot.sound]`, and
the three sorry-dependent guards (`genMult_apply_memLp`,
`momMultL2Isometry_hasDerivAt_zero`, `ballWitness_ne_zero`) are correctly
commented out (lines 230-245) with an honest explanation. That is the right
isolation pattern. The bank must be scoped to the four bound/continuity theorems
and must NOT advertise MemLp (`genMult_apply_memLp`, sorry), the strong `Lp`
derivative (`momMultL2Isometry_hasDerivAt_zero`, sorry), or the non-vacuity
witness (`ballWitness_ne_zero`, sorry).

## The four overreach checks (applied to the four theorems)

### 1. Statement identity - PASS

- `fibreGenerator_opNorm_le : ‖fibreGenerator kx ky kz m‖ <= |kx|+|ky|+|kz|+|m|`.
  Traced to source: `fibreGenerator = (-I) . H` (ExactFlowGenerator.lean:37), so
  the rewrite chain `norm_smul -> norm_neg -> Complex.norm_I -> one_mul` reduces
  `‖(-I).H‖` to `‖H‖` correctly (`‖-I‖ = ‖I‖ = 1`); then `norm_H_le_B4`
  (Compact3Plus1DiracRate.lean:132) closes it because `B4 kx ky kz m` is
  DEFINITIONALLY `|kx|+|ky|+|kz|+|m|` (verified at :66-67). The bound is the
  box/sum-of-abs operator-norm UPPER bound, not the sharp spectral norm
  `sqrt(kx^2+ky^2+kz^2+m^2)`; the name and docstring say "bounded by", not
  "equals", so no sharpness over-claim.
- `fibreGenerator_opNorm_le_on_ball`: chains theorem 1, then bounds each
  `|k i| <= ‖k‖ <= R` via `PiLp.norm_apply_le` (valid since
  `FourierMomentum3 = EuclideanSpace Real (Fin 3)`), `linarith` to `3R+|m|`.
  Correct.
- `genMult_apply_norm_le`: the standard CLM bound `‖T v‖ <= ‖T‖‖v‖` with `‖T‖`
  rewritten from the matrix L2 op-norm via `Matrix.l2_opNorm_toEuclideanCLM`.
  Correct; `genMult m k = toEuclideanCLM (fibreGenerator ...)` (line 68).
- `genMult_continuous`: continuity of `k |-> genMult m k` (momentum |-> operator).
  Coordinatewise continuity (`PiLp.continuous_apply`, `Complex.continuous_ofReal`)
  -> matrix-entry continuity of `H`/`fibreGenerator` (smul/add/const_smul) ->
  compose with the isometry `toEuclideanCLM`. Correct.

### 2. Norm conventions - PASS (consistent throughout)

Matrix L2 operator norm (`scoped Matrix.Norms.L2Operator`), PiLp-2 Euclidean
momentum norm (`EuclideanSpace Real (Fin 3)`), 4-component Dirac spinor
(`Spinor = EuclideanSpace Complex (Fin 4)`, matching `Mat4` and
`toEuclideanCLM (n := Fin 4)`), and the CLM operator norm bridged to the matrix
norm by `Matrix.l2_opNorm_toEuclideanCLM`. No convention mismatch, no silent
norm switch. `H = kx.alpha1 + ky.alpha2 + kz.alpha3 + m.beta` is the genuine
nonzero Dirac fibre Hamiltonian (Compact3Plus1DiracRate.lean:50), so the bound
is a real bound on a real operator.

### 3. Vacuity - PASS for the four

None of the four has a restrictive hypothesis. Theorem 1, 3, 4 are universally
quantified over all reals/momenta/vectors; theorem 2's hypothesis `‖k‖ <= R` is
satisfiable (e.g. `k = 0, R = 0`). NOTE (scoped correctly): the module-level
non-vacuity witness for the FULL generator theorem - `ballWitness_ne_zero` - is
still `sorry`. That is fine, because it guards the un-banked strong-derivative
result, not the four bound/continuity theorems, which are self-evidently
non-vacuous. Do not let the bank imply the full generator theorem has a nonzero
witness yet; it does not (that witness is hole #7).

### 4. Hidden assumptions - PASS

The four proofs use only imported project definitions (`fibreGenerator`, `H`,
`B4`, `norm_H_le_B4`, `genMult`) and standard Mathlib lemmas (`norm_smul`,
`norm_neg`, `Complex.norm_I`, `PiLp.norm_apply_le`, `Matrix.l2_opNorm_toEuclideanCLM`,
`ContinuousLinearMap.le_opNorm`, `PiLp.continuous_apply`, `Complex.continuous_ofReal`,
`AddMonoidHomClass.isometry_of_norm`). No new `axiom`, no `native_decide`, no
`admit`. Confirmed by the independent `#print axioms` replay (section 5).

## 5. Independent build/replay footprint

`lake env lean` on the source file (elaborates all declarations AND executes the
four `#print axioms` guards), from the project root against the built imports:
**EXITCODE=0**. Output = exactly SEVEN `sorry` warnings (lines
123/130/137/164/176/197/203 - the seven documented holes) and ZERO `error:`
lines. Because the four `#guard_msgs (whitespace := lax) in #print axioms` blocks
(lines 214-228) produced no error, each theorem's actual axiom footprint MATCHED
the pinned `[propext, Classical.choice, Quot.sound]`; had any of the four
transitively touched a hole, `#print axioms` would have reported `sorryAx` and
`#guard_msgs` would have errored. Independent confirmation: the four theorems are
kernel-clean (standard three), no `sorryAx` / `native_decide` / extra axiom, and
provably do not depend on the seven sorries.

## 6. Required documentation edit (the only blocker)

The module top docstring (lines 15-31) narrates the two analytic steps in a tense
that reads as accomplished - "Bounded support implies the generator representative
is L2 ... we package it as an Lp element genRepr through MemLp.toLp" and "The
exact orbit has that strong derivative at zero. The proof is a real
dominated-convergence argument ..." - but BOTH steps are still `sorry`
(`genMult_apply_memLp` line 141; `momMultL2Isometry_hasDerivAt_zero` line 182,
resting on `momMult_sub_id_norm_le`, `slope_norm_le`, `orbit_slope_tendsto`).
The four ACTUALLY-completed theorems (op-norm bounds + parameter continuity +
measurability) are the SETUP feeding step 1, not step 1 itself, and are not
foregrounded as "what is done."

Required change (documentation only, no proof change):

(a) Add a module STATUS line separating COMPLETED (the four norm/continuity
    theorems + `genMult_aestronglyMeasurable`) from OPEN (the seven holes:
    Duhamel bound, uniform slope bound, `MemLp`, `genRepr` well-definedness,
    orbit `Lp`-convergence, strong `Lp` derivative, `ballWitness` support +
    non-vacuity). Present the two-step narrative explicitly as the PLAN for the
    open holes, not as accomplished analysis.

(b) Qualify the Scope line: "no operator-norm continuity" reads as disclaiming
    `genMult_continuous`, which IS an operator-norm continuity statement (of the
    generator family in MOMENTUM). Change to "no norm-continuity of the time flow
    `t |-> U(t)` (only strong continuity), no Stone theorem" so the disclaimer
    targets the flow/time direction it means, not the momentum continuity the
    module actually proves.

This is the "mandatory scope line" correction from the 2026-07-13 Lab Manager ops
audit, applied at bank time to pre-empt the docstring-outruns-kernel defect.

## 7. Handoff note for the open holes (borrow, do not reinvent)

The two load-bearing analytic holes are already discharged by an
ALREADY-IMPORTED lemma; codex should not re-derive them:

- Hole #1 `momMult_sub_id_norm_le` (`‖momMult m t k v - v‖ <= |t|‖H‖‖v‖`) is a
  `K := 0` corollary of `HermitianExpLipschitz.hermitian_exp_lipschitz`
  (imported at line 4):
  `‖exp(-t.I.H) - exp(-t.I.K)‖ <= |t|‖H-K‖`. Take `K = 0` (`isHermitian_zero`,
  `exp(-t.I.0) = 1`, `‖H-0‖ = ‖H‖`), giving `‖exp(-t.I.H) - 1‖ <= |t|‖H‖`; then
  wrap with the SAME `Matrix.l2_opNorm_toEuclideanCLM` + `le_opNorm` plumbing
  already used in `genMult_apply_norm_le`, since
  `momMult = toEuclideanCLM (exactFlow ...)` and
  `exactFlow = exp(-t.I.H)` (Compact3Plus1DiracRate.lean:63). `H_isHermitian`
  is available (Compact3Plus1DiracRate.lean:82). Net: ~a few lines, no new
  analysis.
- Hole #2 `slope_norm_le` then follows by dividing by `|t|` (`t = 0` case:
  LHS `= 0`).

The remaining holes (`genMult_apply_memLp`, `orbit_slope_tendsto`,
`momMultL2Isometry_hasDerivAt_zero`, `ballWitness_*`) are the genuine
`MemLp` / dominated-convergence / `indicatorConstLp` work; check Mathlib's
`MeasureTheory.Lp` / `MemLp.of_bound` / `tendsto_of_dominated` API and the
already-imported `MomMultL2StrongContinuity` / `VariablePointwiseL2Isometry`
before hand-rolling. None of this affects the four-theorem bank.

## Narrowest defensible claim (what the bank actually establishes)

For the 3+1 Dirac fibre generator `G_m(k) = -i H(k,m)` on the 4-spinor fibre
(matrix L2 operator norm): (i) `‖G_m(k)‖ <= |kx|+|ky|+|kz|+|m|` and (ii)
`‖G_m(k)‖ <= 3R+|m|` on the momentum ball `‖k‖ <= R`; (iii) the pointwise action
obeys `‖G_m(k) v‖ <= ‖G_m(k)‖‖v‖`; and (iv) the operator-valued family
`k |-> G_m(k)` is norm-continuous in the momentum coordinate (hence a.e. strongly
measurable). These are finite-dimensional / pointwise-in-momentum facts. They do
NOT establish `MemLp` of the generator action, the strong `Lp` derivative of the
orbit, existence of a nonzero compact-support witness, a bounded full-`L2`
generator, Stone/time-flow norm-continuity, Fourier transport, a position-space
PDE, a lattice limit, or Lorentz restoration - all seven of those remain open
`sorry` handoffs in this module.
