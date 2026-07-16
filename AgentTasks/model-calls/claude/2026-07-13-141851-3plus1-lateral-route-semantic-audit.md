# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-13T14:18:43`
- Finished: `2026-07-13T14:18:51`
- Timeout seconds: `900`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
Independent semantic audit of a proposed lateral 3+1 route. Review the verbatim Lean sources against this intended reading: projector-conditioned shifts are algebraically irreducible to spin-blind shift plus fixed coin; strictly spin-blind schedules have a cubic winding obstruction; finite global unitary trace and finite permutation net-flow candidates cancel; reflecting boundaries are one nonchiral cycle; the Weyl Pauli/determinant-sign algebra is proved but degree and Chern remain conditional. Identify vacuity, hollow telescoping, false shape, hidden assumptions, and prose that outruns the statements. Give a verdict per module, exact edits required, and the strongest scientifically honest combined conclusion. Do not infer W=1 or bulk-edge correspondence.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/ProjectorConditionedStep.lean (94 lines)

```lean
import Mathlib

/-!
# Generic projector-conditioned unitary step

This standalone draft isolates the algebra behind one HNU substep. A selected
internal sector receives a unit-modulus translation phase while the
complementary sector is held on site. The theorem says exactly what is moved
and what is held; it does not call the held sector a null translation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProjectorConditionedStep

open Matrix Complex

def IsProjection {n : Type*} [Fintype n] [DecidableEq n]
    (P : Matrix n n Complex) : Prop := P * P = P ∧ Pᴴ = P

def IsPhase (z : Complex) : Prop := star z * z = 1 ∧ z * star z = 1

def conditionedStep {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) : Matrix n n Complex :=
  z • P + (1 - P)

def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- The selected sector receives exactly the phase `z`. -/
theorem conditionedStep_mul_projection {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) (hP : IsProjection P) :
    conditionedStep z P * P = z • P := by
  unfold conditionedStep;
  simp +decide [ add_mul, sub_mul, hP.1 ]

/-- The complementary sector is held exactly fixed. -/
theorem conditionedStep_mul_complement {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) (hP : IsProjection P) :
    conditionedStep z P * (1 - P) = 1 - P := by
  unfold conditionedStep; simp +decide [ mul_sub ] ;
  simp +decide [ add_mul, sub_mul, hP.1 ]

/-- A unit phase on an orthogonal projector gives an exact unitary step. -/
theorem conditionedStep_unitary {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex)
    (hP : IsProjection P) (hz : IsPhase z) :
    IsUnitary (conditionedStep z P) := by
  unfold IsUnitary conditionedStep;
  simp_all +decide [ mul_add, add_mul, IsProjection, sub_mul, mul_sub ];
  simp_all +decide [ ← smul_assoc, IsPhase ]

def selected : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

/-- Nontrivial control: the phase `-1` changes the selected sector. -/
theorem selected_neg_one_nontrivial :
    conditionedStep (-1) selected ≠ (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  intro h
  have := congr_fun ( congr_fun h 0 ) 0
  simp [conditionedStep, selected] at this
  norm_num at this

/-- The explicit selected-sector witness is an orthogonal projector. -/
theorem selected_isProjection : IsProjection selected := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ selected ]

/-!
## Standard-axiom guards

Each of the four headline results is checked, at build time, to depend only on
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`). No
trusted compiler evaluation (`Lean.ofReduceBool` / `Lean.trustCompiler`) and no
extra assumptions are permitted; `#guard_msgs` turns any deviation into a build
error.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_mul_projection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_mul_projection

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_mul_complement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_mul_complement

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.selected_neg_one_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selected_neg_one_nontrivial

end PhysicsSM.Draft.NullEdge.ProjectorConditionedStep

```

### PhysicsSM/Draft/NullEdge/SpinBlindWindingObstruction.lean (192 lines)

```lean
import Mathlib

/-!
# Spin-blind Floquet winding obstruction (pointwise algebraic core)

This file is a self-contained, Mathlib-only formalization of the **exact
algebraic core** of the spin-blind winding obstruction for the Null-Edge `3+1`
fork, following `HNU_SINGLE_WEYL_RECONSTRUCTION.md` (§5, §7, ladder item L9).

## What is proved here

The standard three-dimensional winding density of a momentum-space unitary
`U : T^3 -> U(N)`
is built from the logarithmic derivatives `R_j(k) := U(k)ᴴ ∂_{k_j} U(k)` via the
integrand
`Σ_{i,j,k} ε^{ijk} Tr[ R_i R_j R_k ] = Tr[ antisymCubic R ]`,
the fully antisymmetrized cubic trace density.

For scalar logarithmic derivatives `R_j = (-i m_j) • 1`, as produced by a
spin-blind schedule `U(k) = exp(-i k*m) W_0`, we prove that the
antisymmetrized cubic matrix expression vanishes identically, and therefore so
does its trace, for every finite matrix dimension. This is the pointwise
winding-integrand obstruction.

To show the obstruction is genuinely about *spin-blind commutativity* and not a
vacuous definition, we exhibit a **noncommuting** `2 × 2` control (the Pauli
matrices) whose antisymmetrized cubic trace is `12 i ≠ 0`.

## Scope (honest)

This is a **pointwise, purely algebraic** statement. The Lean theorem assumes
the scalar logarithmic-derivative form; it does not derive that form from a
unitary family. We do **not** formalize a
global winding *integral*, a degree map, or the geometry of `𝕋³`; and we do not
claim `W = 1` for the full HNU model. The result is a *scoped* no-go for the
spin-blind alphabet `{ unconditional (spin-blind) null shift, on-site turn }`,
i.e. exactly the `U(k) = exp(-i k·m) W₀` family. It says nothing against
*projector-conditioned* shifts, which are what carry the nonzero winding in the
HNU construction (see §7 of the reconstruction). No new assumptions are used and
no trusted-compiler evaluation (`n a t i v e _ d e c i d e` /
`Lean.ofReduceBool`) appears;
`#print axioms` guards below enforce a clean kernel dependency set.
-/

namespace PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction

open scoped Matrix
open Matrix Complex

/-- Complex `n × n` matrices. -/
abbrev Mat (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

/-- The fully antisymmetrized cubic expression over the six permutations of the
three indices, with Levi-Civita signs `+, -, -, +, +, -`:

`antisymCubic R = R₀R₁R₂ - R₀R₂R₁ - R₁R₀R₂ + R₁R₂R₀ + R₂R₀R₁ - R₂R₁R₀`.

Its trace is the winding integrand `Σ_{i,j,k} ε^{ijk} Tr[R_i R_j R_k]`. -/
noncomputable def antisymCubic {n : ℕ} (R : Fin 3 → Mat n) : Mat n :=
  R 0 * R 1 * R 2 - R 0 * R 2 * R 1 - R 1 * R 0 * R 2
    + R 1 * R 2 * R 0 + R 2 * R 0 * R 1 - R 2 * R 1 * R 0

/-! ## 1. Scalar matrices commute -/

/-- Scalar matrices `c • 1` commute (the algebraic heart of the spin-blind
obstruction: an unconditional schedule produces only commuting scalar
generators). -/
theorem scalar_matrix_comm {n : ℕ} (c d : ℂ) :
    (c • (1 : Mat n)) * (d • (1 : Mat n)) = (d • (1 : Mat n)) * (c • (1 : Mat n)) := by
  rw [smul_mul_smul_comm, smul_mul_smul_comm, one_mul, mul_comm]

/-- A product of scalar matrices is the scalar matrix of the product. -/
theorem scalar_matrix_mul {n : ℕ} (c d : ℂ) :
    (c • (1 : Mat n)) * (d • (1 : Mat n)) = (c * d) • (1 : Mat n) := by
  rw [smul_mul_smul_comm, one_mul]

/-! ## 2. The antisymmetrized cubic vanishes for scalar coefficients -/

/-- **Pointwise obstruction (matrix form).** For arbitrary scalar coefficients
`c : Fin 3 → ℂ`, the antisymmetrized cubic of the scalar matrices `c j • 1`
vanishes identically, in every finite dimension `n`. -/
theorem antisymCubic_scalar {n : ℕ} (c : Fin 3 → ℂ) :
    antisymCubic (fun j => c j • (1 : Mat n)) = 0 := by
  simp only [antisymCubic, smul_mul_smul_comm, mul_one]
  module

/-! ## 3. Trace vanishes in every finite dimension -/

/-- **Pointwise obstruction (trace form).** The winding integrand
`Σ_{i,j,k} ε^{ijk} Tr[R_i R_j R_k]` vanishes for scalar `R_j = c_j • 1`, in
every finite matrix dimension. -/
theorem trace_antisymCubic_scalar {n : ℕ} (c : Fin 3 → ℂ) :
    (antisymCubic (fun j => c j • (1 : Mat n))).trace = 0 := by
  rw [antisymCubic_scalar]; simp

/-! ## 4. Specialization to the spin-blind displacement data `c_j = -i m_j`

For `U(k) = exp(-i k·m) W₀` the logarithmic derivative is
`R_j = U(k)ᴴ ∂_{k_j} U(k) = (-i m_j) • 1`. We record the vanishing of the
winding integrand for both real and integer displacement data `m`. -/

/-- Spin-blind obstruction for **real** displacement data `m : Fin 3 → ℝ`. -/
theorem trace_antisymCubic_spinBlind_real {n : ℕ} (m : Fin 3 → ℝ) :
    (antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n))).trace = 0 :=
  trace_antisymCubic_scalar _

/-- Spin-blind obstruction for **integer** displacement data `m : Fin 3 → ℤ`
(the physical `m ∈ ℤ³` null shift). -/
theorem trace_antisymCubic_spinBlind_int {n : ℕ} (m : Fin 3 → ℤ) :
    (antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n))).trace = 0 :=
  trace_antisymCubic_scalar _

/-- The matrix expression itself vanishes for integer displacement data. -/
theorem antisymCubic_spinBlind_int {n : ℕ} (m : Fin 3 → ℤ) :
    antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n)) = 0 :=
  antisymCubic_scalar _

/-! ## 5. Noncommuting nonzero Pauli witness

To show the obstruction is about spin-blind *commutativity* and not a vacuous
definition, we take the three Pauli matrices as a noncommuting control and
compute a **nonzero** antisymmetrized cubic trace `12 i`. -/

/-- The three Pauli matrices `σ₁, σ₂, σ₃` as a `Fin 3`-indexed control. -/
def pauli : Fin 3 → Mat 2
  | 0 => !![0, 1; 1, 0]
  | 1 => !![0, -Complex.I; Complex.I, 0]
  | 2 => !![1, 0; 0, -1]

/-- The Pauli control is genuinely **noncommuting**: `σ₁ σ₂ ≠ σ₂ σ₁`. -/
theorem pauli_not_comm : pauli 0 * pauli 1 ≠ pauli 1 * pauli 0 := by
  intro h
  have := congrFun (congrFun h 0) 0
  simp only [pauli, Matrix.mul_fin_two] at this
  norm_num [Complex.ext_iff] at this

/-- Each Pauli generator is **nonzero**. -/
theorem pauli_ne_zero (j : Fin 3) : pauli j ≠ 0 := by
  fin_cases j
  · intro h; have := congrFun (congrFun h 0) 1; simp [pauli] at this
  · intro h; have := congrFun (congrFun h 0) 1; simp [pauli] at this
  · intro h; have := congrFun (congrFun h 0) 0; simp [pauli] at this

/-- **Nonzero control.** For the noncommuting Pauli control the antisymmetrized
cubic trace equals `12 i`. -/
theorem trace_antisymCubic_pauli : (antisymCubic pauli).trace = 12 * Complex.I := by
  simp only [antisymCubic, pauli]
  rw [Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two,
      Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two,
      Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two]
  simp only [Matrix.trace_fin_two]
  simp [Matrix.sub_apply]
  ring

/-- **Nonvacuity.** The winding integrand does not vanish for the noncommuting
Pauli control: the obstruction genuinely requires spin-blind commutativity. -/
theorem trace_antisymCubic_pauli_ne_zero : (antisymCubic pauli).trace ≠ 0 := by
  rw [trace_antisymCubic_pauli]
  simp [Complex.ext_iff]

/-! ## Kernel-cleanliness guards (build-enforced)

Each `#guard_msgs` block fails the build if the axiom dependency set changes,
enforcing that only the standard `propext, Classical.choice, Quot.sound` axioms
are used (no `s o r r y`, no `Lean.ofReduceBool` / trusted-compiler evaluation). -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.antisymCubic_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms antisymCubic_scalar

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_scalar

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_spinBlind_int' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_spinBlind_int

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_pauli' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_pauli

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_pauli_ne_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_pauli_ne_zero

end PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction

```

### PhysicsSM/Draft/NullEdge/ConditionedShiftIrreducible.lean (60 lines)

```lean
import Mathlib

/-!
# A fixed coin cannot reproduce a projector-conditioned shift family

This is the exact algebraic fork in the anomalous-Floquet 3+1 route. A scalar
spin-blind shift gives the same phase to every internal sector. Multiplying it
by one momentum-independent coin cannot reproduce a family that phases one
proper projector sector while holding its complement fixed, already when the
two phases `+1` and `-1` are compared.

The theorem is deliberately scoped: it does not exclude multi-step circuits,
momentum-dependent coins, extra registers, or other primitive alphabets.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible

open Matrix Complex

def conditionedStep {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) : Matrix n n Complex :=
  z • P + (1 - P)

def spinBlindThenCoin {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (C : Matrix n n Complex) : Matrix n n Complex := z • C

/-
A proper selected sector cannot be reproduced at both signs by one fixed
coin following a spin-blind scalar shift.
-/
theorem no_fixed_coin_factorization {n : Type*} [Fintype n] [DecidableEq n]
    (P : Matrix n n Complex) (hP : P ≠ 1) :
    ¬ ∃ C : Matrix n n Complex,
      spinBlindThenCoin 1 C = conditionedStep 1 P ∧
      spinBlindThenCoin (-1) C = conditionedStep (-1) P := by
  contrapose! hP; simp_all +decide [ spinBlindThenCoin, conditionedStep ] ;
  exact Matrix.ext fun i j => by have := congr_fun ( congr_fun hP i ) j; norm_num at *; linear_combination' this / 2;

def selected : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

theorem selected_ne_one : selected ≠ 1 := by
  unfold selected;
  exact ne_of_apply_ne ( fun m => m 1 1 ) ( by norm_num )

/-- Explicit two-channel nonvacuity witness. -/
theorem selected_no_fixed_coin :
    ¬ ∃ C : Matrix (Fin 2) (Fin 2) Complex,
      spinBlindThenCoin 1 C = conditionedStep 1 selected ∧
      spinBlindThenCoin (-1) C = conditionedStep (-1) selected := by
  convert no_fixed_coin_factorization selected selected_ne_one

-- Standard axiom guards.
#print axioms no_fixed_coin_factorization
#print axioms selected_ne_one
#print axioms selected_no_fixed_coin

end PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible

```

### PhysicsSM/Draft/NullEdge/FiniteTransportTraceNoGo.lean (69 lines)

```lean
import Mathlib

/-!
# The naive global finite transport trace always cancels

This target prevents a hollow definition in the open-boundary 3+1 route. On a
finite Hilbert space, exact unitarity and cyclicity force the global trace of a
transported projector minus itself to vanish. Local flow can still be nonzero;
the explicit swap witness shows its compensating contribution elsewhere.

## Correct consequence

`globalCutFlow_zero` shows that the *naive global* finite cut flow
`Tr(U^* P U - P)` is identically zero for every exactly unitary finite matrix,
so it can never serve as a chiral certificate on its own. This is **not** a
universal no-go against boundary transport: the swap witness below exhibits
genuine, nonzero, and mutually opposite *local* diagonal flow at the two sites
while the global trace cancels. The takeaway is that any nonzero chiral
certificate must be **localized/relative** (a difference of local flows or a
relative index), **causal-region restricted** (traced over a subregion rather
than globally), or **infinite-volume** (where cyclicity of the global trace no
longer applies). No claim is made that boundary transport itself vanishes.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo

open Matrix Complex

def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

def globalCutFlow {n : Type*} [Fintype n] [DecidableEq n]
    (U P : Matrix n n Complex) : Complex := (Uᴴ * P * U - P).trace

/-- Any naive global finite transport trace vanishes exactly. -/
theorem globalCutFlow_zero {n : Type*} [Fintype n] [DecidableEq n]
    (U P : Matrix n n Complex) (hU : IsUnitary U) :
    globalCutFlow U P = 0 := by
  convert Matrix.trace_sub (Uᴴ * P * U) P using 1
  rw [Matrix.trace_mul_comm]
  simp_all +decide [← Matrix.mul_assoc, IsUnitary]

def swap : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]
def leftProjector : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

theorem swap_unitary : IsUnitary swap := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, swap]

/-- The two local diagonal contributions are nonzero and opposite. -/
theorem swap_local_flow_witness :
    (swapᴴ * leftProjector * swap - leftProjector) 0 0 = -1 ∧
    (swapᴴ * leftProjector * swap - leftProjector) 1 1 = 1 := by
  norm_num [swap, leftProjector, Matrix.mul_apply]

/-- The same witness has zero global flow despite nonzero local motion. -/
theorem swap_global_flow_zero : globalCutFlow swap leftProjector = 0 := by
  convert globalCutFlow_zero swap leftProjector swap_unitary using 1

end PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo

-- Standard axiom guards: each target must rely only on the standard axioms
-- `propext`, `Classical.choice`, and `Quot.sound`.
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.globalCutFlow_zero
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.swap_unitary
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.swap_local_flow_witness
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.swap_global_flow_zero

```

### PhysicsSM/Draft/NullEdge/BoundaryTransportIndex.lean (243 lines)

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-!
# A non-hollow localized boundary-transport index: definition, ladder, and verdict

This module answers the strategy/construction request in `TASK.md`: design the
smallest mathematically correct boundary-transport invariant for the
open-boundary anomalous-Floquet 3+1 route, connect the bare reflecting shift to a
*zero* index, and honestly locate where a *nonzero* index must come from.

## The object we deliberately reject

The naive global finite trace `Tr(U⋆ P U − P)` (`P` a cut projector, `U` a finite
Floquet unitary) vanishes identically by cyclicity of the trace:
`Tr(U⋆ P U) = Tr(P U U⋆) = Tr(P)`.  The permutation-level shadow of this identity
is that a bijection of a finite set preserves the size of the complement of any
subset, so the number of orbits *entering* a region equals the number *leaving*
it.  We prove this shadow directly (`crossingsIn_eq_crossingsOut`,
`netFlow_eq_zero`); it is the exact reason a finite trace/flow index cannot be the
nonzero invariant.

## What we deliver

* `netFlow σ S` — the honest finite boundary-transport index: (orbits crossing
  into `S` in one period) − (orbits crossing out).  This is the correct *finite*
  object; it is proof-ready and Mathlib-only.
* `netFlow_eq_zero` — **the finite permutation no-go**: for *every* permutation
  of a finite state space and *every* cut, `netFlow = 0`. This subsumes the requested
  "bare reflecting shift ⟶ zero index" control as the special case
  `bareReflectingShift_netFlow_eq_zero`.
* Anti-vacuity + local-flow witnesses (`bareReflectingShift_ne_one`,
  `crossingsIn_pos`, `crossingsOut_pos`): the reflecting shift is a genuinely
  nontrivial permutation, and across a real cut it *does* have orbits crossing
  both ways — so the zero index is an exact cancellation of nonzero opposite
  currents, not an artifact of trivial dynamics.

## The verdict (see `BOUNDARY_TRANSPORT_INDEX_VERDICT.md` for the full write-up)

A **scoped no-go** for the finite index, plus a **sharply named missing-API**
requirement for the nonzero side:

1. Object choice: neither the global finite trace nor this finite permutation
   flow can be the
   nonzero invariant — both are `0` by `netFlow_eq_zero`.  The nonzero chiral
   boundary index must be the **half-space Fredholm / GNVW flow index** of the
   period map on an infinite (half-line) lattice.
2. That index requires infinite-volume operator API that Mathlib does not have.
   The exact missing declarations are listed in the verdict file and in the
   commented `BridgeLadder` section below.
3. Dimensional audit: a 1D finite reflecting orbit (`State N = Bool × Fin (N+1)`)
   is one transverse-momentum fiber of the 2D boundary of a 3D bulk, not the whole
   boundary; the full 2D boundary index is the sum of fiberwise 1D flows over the
   transverse torus `T²`.  Stated precisely below.

No new assumptions or trust-expanding finite evaluation.
-/

namespace PhysicsSM.Draft.NullEdge.BoundaryTransportIndex

open Finset
open PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-! ## The finite boundary-transport index -/

section FiniteIndex

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Orbits crossing **into** the region `S` in one application of `σ`: states
outside `S` whose image lands in `S`. -/
def crossingsIn (σ : Equiv.Perm V) (S : Finset V) : ℕ :=
  (univ.filter (fun x => x ∉ S ∧ σ x ∈ S)).card

/-- Orbits crossing **out of** the region `S`: states in `S` whose image leaves. -/
def crossingsOut (σ : Equiv.Perm V) (S : Finset V) : ℕ :=
  (univ.filter (fun x => x ∈ S ∧ σ x ∉ S)).card

/-- The finite net boundary-transport index across the cut `S` over one period. -/
def netFlow (σ : Equiv.Perm V) (S : Finset V) : ℤ :=
  (crossingsIn σ S : ℤ) - (crossingsOut σ S : ℤ)

/-- **Conservation / cyclicity shadow.** A bijection of a finite set moves as many
orbits into any region as out of it. This is the finite reason the naive
`Tr(U⋆ P U − P)` invariant is hollow. -/
theorem crossingsIn_eq_crossingsOut (σ : Equiv.Perm V) (S : Finset V) :
    crossingsIn σ S = crossingsOut σ S := by
  unfold crossingsIn crossingsOut
  have hpre : (univ.filter (fun x => σ x ∈ S)).card = S.card := by
    rw [← Finset.card_image_of_injective (univ.filter (fun x => σ x ∈ S)) σ.injective]
    congr 1
    ext y
    simp only [mem_image, mem_filter, mem_univ, true_and]
    constructor
    · rintro ⟨x, hx, rfl⟩; exact hx
    · intro hy; exact ⟨σ.symm y, by simp [hy], by simp⟩
  have hS : (univ.filter (fun x => x ∈ S)).card = S.card := by
    rw [Finset.filter_mem_eq_inter]; simp
  have h1 : (univ.filter (fun x => σ x ∈ S)).card
      = (univ.filter (fun x => σ x ∈ S ∧ x ∈ S)).card
        + (univ.filter (fun x => σ x ∈ S ∧ x ∉ S)).card := by
    rw [← Finset.filter_filter, ← Finset.filter_filter]
    rw [Finset.card_filter_add_card_filter_not]
  have h2 : (univ.filter (fun x => x ∈ S)).card
      = (univ.filter (fun x => x ∈ S ∧ σ x ∈ S)).card
        + (univ.filter (fun x => x ∈ S ∧ σ x ∉ S)).card := by
    rw [← Finset.filter_filter, ← Finset.filter_filter]
    rw [Finset.card_filter_add_card_filter_not]
  have e1 : (univ.filter (fun x => σ x ∈ S ∧ x ∈ S)).card
      = (univ.filter (fun x => x ∈ S ∧ σ x ∈ S)).card := by
    congr 1; ext x; simp [and_comm]
  have e2 : (univ.filter (fun x => σ x ∈ S ∧ x ∉ S)).card
      = (univ.filter (fun x => x ∉ S ∧ σ x ∈ S)).card := by
    congr 1; ext x; simp [and_comm]
  omega

/-- **The finite permutation no-go.** Every permutation of a finite state space
has zero net boundary transport across every cut. This theorem does not identify
an arbitrary finite-dimensional quantum unitary with a permutation. -/
theorem netFlow_eq_zero (σ : Equiv.Perm V) (S : Finset V) : netFlow σ S = 0 := by
  unfold netFlow
  rw [crossingsIn_eq_crossingsOut]
  ring

end FiniteIndex

/-! ## Bare reflecting shift: the transport-zero control -/

/-- **Control (bare ⟶ 0).** The bare open-boundary reflecting shift has zero net
chiral transport across every cut. This is the required transport-zero anchor. -/
theorem bareReflectingShift_netFlow_eq_zero (N : Nat) (S : Finset (State N)) :
    netFlow (stepEquiv N) S = 0 :=
  netFlow_eq_zero (stepEquiv N) S

/-! ## Anti-vacuity and local-flow witnesses

The zero index above must not be vacuous: it is a genuine cancellation of nonzero
opposite currents, and the reflecting shift is a genuinely nontrivial permutation.
-/

/-- The reflecting shift is a nontrivial permutation whenever there is interior
room (`N ≥ 1`): the left endpoint right-mover actually advances. -/
theorem bareReflectingShift_ne_one {N : Nat} (hN : 1 ≤ N) : stepEquiv N ≠ 1 := by
  intro h
  have hx : (stepEquiv N) (true, ⟨0, by omega⟩) = (true, ⟨0, by omega⟩) := by
    rw [h]; rfl
  have hstep : (stepEquiv N) (true, (⟨0, by omega⟩ : Fin (N + 1)))
      = (true, ⟨0 + 1, by omega⟩) :=
    step_right_interior (N := N) ⟨0, by omega⟩ (by simpa using hN)
  rw [hstep] at hx
  simp only [Prod.mk.injEq, Fin.mk.injEq] at hx
  omega

/-- The "right region": all states strictly to the right of the left endpoint. -/
def cutRight (N : Nat) : Finset (State N) :=
  univ.filter (fun s => 1 ≤ s.2.val)

/-- **Local-flow witness (into the region).** For `N ≥ 1` the left-endpoint
right-mover `(true, 0)` genuinely crosses *into* the right region, so the inbound
current is nonzero. -/
theorem crossingsIn_pos {N : Nat} (hN : 1 ≤ N) :
    0 < crossingsIn (stepEquiv N) (cutRight N) := by
  apply Finset.card_pos.mpr
  refine ⟨(true, ⟨0, by omega⟩), ?_⟩
  simp only [mem_filter, mem_univ, true_and, cutRight]
  have hstep : (stepEquiv N) (true, (⟨0, by omega⟩ : Fin (N + 1)))
      = (true, ⟨0 + 1, by omega⟩) :=
    step_right_interior (N := N) ⟨0, by omega⟩ (by simpa using hN)
  exact ⟨by simp, by rw [hstep]⟩

/-- **Local-flow witness (out of the region).** For `N ≥ 1` the left-mover at
site `1`, `(false, 1)`, genuinely crosses *out of* the right region, so the
outbound current is nonzero. Together with `crossingsIn_pos` this shows the zero
index of `bareReflectingShift_netFlow_eq_zero` is an exact cancellation of two
nonzero opposite currents. -/
theorem crossingsOut_pos {N : Nat} (hN : 1 ≤ N) :
    0 < crossingsOut (stepEquiv N) (cutRight N) := by
  apply Finset.card_pos.mpr
  refine ⟨(false, ⟨1, by omega⟩), ?_⟩
  simp only [mem_filter, mem_univ, true_and, cutRight]
  have hstep : (stepEquiv N) (false, (⟨1, by omega⟩ : Fin (N + 1)))
      = (false, ⟨1 - 1, by omega⟩) :=
    step_left_interior (N := N) ⟨1, by omega⟩ (by simp)
  exact ⟨by simp, by simp [hstep]⟩

/-! ## Dimensional correction: 1D fiber vs. 2D boundary of a 3D bulk

`State N = Bool × Fin (N+1)` is a `1+1`-dimensional edge with a `0`-dimensional
cut. Its transport invariant `netFlow` is a single integer: a `1D` GNVW flow.

The physical target is the `2`-dimensional spatial boundary of a `3`-dimensional
Floquet bulk. A chiral surface state there is a `2D` object whose transport
invariant is a *momentum-resolved family* of `1D` flows, one per transverse
quasimomentum `k ∈ T²`. Hence a single 1D finite reflecting orbit **cannot** model
the full 2D boundary; it models one transverse-momentum fiber. The correct
boundary index is

    boundaryIndex(U) = ∑_{k ∈ T²} netFlow_∞(U(k))            (⋆)

a sum/integral of fiberwise *infinite-volume* flows over the transverse torus.
`netFlow` here is the honest finite proxy for a single fiber's flow, and `(⋆)` is
the dimensional correction.  See `BOUNDARY_TRANSPORT_INDEX_VERDICT.md`.
-/

/-! ## `BridgeLadder`: the smallest missing-API theorem for the nonzero rung

`netFlow_eq_zero` proves the nonzero rung is **unreachable by this finite
permutation index**. A nonzero anomalous witness therefore requires a
infinite/half-space construction, whose defining API is absent from Mathlib
(confirmed: only TODO comments mention Fredholm operators; no GNVW/QCA theory).

The smallest bridge theorem, stated in prose because its API is absent:

  Let `H = lp (fun _ : ℕ => ℂ) 2` be the half-line Hilbert space, `U : H →L[ℂ] H`
  a unitary that is *finite-range* (there is `R` with `⟪δ_i, U δ_j⟫ = 0` for
  `|i−j| > R`), and `P : H →L[ℂ] H` the orthogonal projection onto `span {δ_i}`.
  Then `P.comp (U.comp P)` restricted to `range P` is Fredholm, and

      boundaryFlowIndex U := Fredholm.index (P U P |_ range P)  ∈ ℤ

  is a well-defined chiral transport index with:
    * `boundaryFlowIndex U = 0` when `U` preserves `range P` (reflecting bulk), and
    * `boundaryFlowIndex (rightShift) = -1` (or `+1` for the left shift),
  and it agrees with the GNVW flow of the two-sided extension.

The exact missing Mathlib declarations required to state and prove this bridge:

  * `Fredholm` predicate on `E →L[𝕜] F` (finite-dim kernel and cokernel,
    closed range) — Mathlib has none (only a TODO in
    `Mathlib/Analysis/Normed/Operator/Banach.lean`).
  * `Fredholm.index : (E →L[𝕜] F) → ℤ` and its stability/composition lemmas
    (`Fredholm.index_add_compact`, `Fredholm.index_comp`).
  * The essential-codimension / GNVW flow index for locality-preserving unitaries
    on `lp (fun _ : ℤ => V) 2`, i.e. a Kitaev/GNVW `flowIndex` with
    `flowIndex_shift`, `flowIndex_mul`, `flowIndex_locality_invariance`.
  * `analyticIndex = -essentialCodim` compatibility linking `P U P` to `flowIndex`.

Until those land, the nonzero rung is a *scoped no-go at the finite level* with a
*named missing hypothesis*: the infinite-volume Fredholm/GNVW flow index.
-/

end PhysicsSM.Draft.NullEdge.BoundaryTransportIndex

```

### PhysicsSM/Draft/NullEdge/ReflectingCycleControl.lean (98 lines)

```lean
import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-!
# Exact cycle structure of the reflecting open-boundary shift

The finite reflecting update is conjugate to addition by one on a cycle of
length `2 * (N + 1)`. This is a nonchiral control for the anomalous-Floquet
3+1 route: boundary memory restores a local reversible update, but reflection
alone supplies no net boundary anomaly.

Provenance: Aristotle job `847494db-4bfe-4d09-adcb-e6a78a721c8a`, adapted to
reuse `OpenBoundaryReflectingShift` rather than duplicate its definitions.
No Weyl, winding, or bulk-boundary correspondence is asserted here.
-/

namespace PhysicsSM.Draft.NullEdge.ReflectingCycleControl

open OpenBoundaryReflectingShift

/-- Coordinate around the reflected orbit: first rightward, then leftward. -/
def orbitIndex {N : Nat} (s : State N) : Fin (2 * (N + 1)) :=
  match s with
  | (true, x) => ⟨x.val, by omega⟩
  | (false, x) => ⟨2 * N + 1 - x.val, by omega⟩

/-- One reflecting step advances exactly once around the orbit coordinate. -/
theorem orbitIndex_step {N : Nat} (s : State N) :
    orbitIndex (step s) = orbitIndex s + 1 := by
  rcases s with ⟨b, x⟩
  rcases b with (_ | _) <;> simp_all +decide [orbitIndex]
  · rcases x with ⟨_ | x, hx⟩ <;> simp_all +decide [Fin.ext_iff, step]
    · norm_num [Fin.val_add]
    · norm_num [Fin.val_add, Fin.val_one, decClamp]
      rw [Nat.mod_eq_of_lt] <;> omega
  · unfold step
    rcases eq_or_ne x.val N <;> simp_all +decide [Fin.ext_iff, Fin.val_add]
    · rw [Nat.mod_eq_of_lt] <;> omega
    · rw [Nat.mod_eq_of_lt] <;> simp +arith +decide [*, incClamp]
      · grind
      · grind +splitIndPred

/-- The orbit coordinate loses no state information. -/
theorem orbitIndex_bijective (N : Nat) :
    Function.Bijective (orbitIndex (N := N)) := by
  have h_card : Fintype.card (State N) = Fintype.card (Fin (2 * (N + 1))) := by
    simp +arith +decide [State]
  have h_inj : Function.Injective (orbitIndex : State N → Fin (2 * (N + 1))) := by
    intro s t
    rcases s with ⟨b1, x1⟩
    rcases t with ⟨b2, x2⟩
    simp_all +decide [State]
    cases b1 <;> cases b2 <;> simp_all +decide [orbitIndex]
    · exact fun h => Fin.ext <| by
        rw [tsub_right_inj] at h <;> linarith [Fin.is_lt x1, Fin.is_lt x2]
    · omega
    · omega
    · exact fun h => Fin.ext h
  refine ⟨h_inj, ?_⟩
  exact ((Fintype.bijective_iff_injective_and_card orbitIndex).mpr ⟨h_inj, h_card⟩).2

/-- Iterating `step` advances the orbit coordinate by the same number of ticks. -/
theorem orbitIndex_iterate {N : Nat} (s : State N) (k : Nat) :
    (orbitIndex (step^[k] s)).val = ((orbitIndex s).val + k) % (2 * (N + 1)) := by
  induction' k with k ih
  · norm_num [Nat.mod_eq_of_lt]
  · rw [Function.iterate_succ_apply', orbitIndex_step]
    simp +decide [← add_assoc, ih, Fin.val_add]

/-- Every reflecting state reaches every other state under iteration. -/
theorem step_transitive {N : Nat} (s t : State N) :
    ∃ k : Nat, step^[k] s = t := by
  obtain ⟨k, hk⟩ :
      ∃ k : Nat, ((orbitIndex s) + k) % (2 * (N + 1)) = (orbitIndex t).val := by
    use (orbitIndex t).val + 2 * (N + 1) - (orbitIndex s).val
    rw [add_tsub_cancel_of_le]
    · norm_num [Fin.val_add, Nat.mod_eq_of_lt]
    · exact le_add_of_nonneg_of_le (Nat.zero_le _) (Nat.le_of_lt (Fin.is_lt _))
  use k
  exact Function.Injective.eq_iff (orbitIndex_bijective N).1 |>.1
    (by simp +decide [Fin.ext_iff, hk, orbitIndex_iterate])

/-- The explicit full orbit length returns every state to itself. -/
theorem step_full_period {N : Nat} (s : State N) :
    step^[2 * (N + 1)] s = s := by
  convert (Function.Injective.eq_iff
    (show Function.Injective (orbitIndex : State N → Fin (2 * (N + 1))) from
      (orbitIndex_bijective N).injective)).1 _ using 1
  convert orbitIndex_iterate s (2 * (N + 1)) using 1
  simp +decide [Fin.ext_iff, Nat.mod_eq_of_lt]

/-- The control is nonvacuous already on a two-site interval. -/
theorem two_site_orbit_witness :
    step^[4] (true, (0 : Fin 2)) = (true, (0 : Fin 2)) ∧
    step^[2] (true, (0 : Fin 2)) ≠ (true, (0 : Fin 2)) := by
  decide

end PhysicsSM.Draft.NullEdge.ReflectingCycleControl

```

### PhysicsSM/Draft/NullEdge/WeylSphereChargeBridge.lean (315 lines)

```lean
import Mathlib

/-!
# Weyl determinant-sign → enclosing-sphere degree / Chern bridge

This file builds the smallest honest theorem ladder connecting the *local*
Jacobian determinant sign of a two-band Pauli crossing `h(q) = (A q)·σ` to the
*topological* charge (degree / first Chern number) on an enclosing 2-sphere.

See `AUDIT.md` for the full Mathlib/PhysLean API audit. The one-line summary:
this Mathlib (`v4.28.0`) has **no** topological/Brouwer degree of sphere maps,
**no** `πₙ(Sⁿ) ≅ ℤ` / `Hₙ(Sⁿ)` computation, **no** `GL⁺` path-connectivity, and
**no** Chern/Berry/characteristic-class API; PhysLean is not a dependency.
Therefore the topological *endpoints* cannot even be defined here.

What is delivered:

* §1–§3  A proof-complete finite/linear layer: the Pauli↔sphere link
  (`pauliDot_sq`, `weylHam_eq_norm_smul`), the Bloch map as a self-map of the
  unit sphere with **functoriality** (`blochVec_comp`, `blochVec_bloch`), and the
  determinant-sign chirality with **canonical identity and reflection witnesses**
  (`chirality_one`, `chirality_reflect`, `blochVec_one`) and multiplicativity
  (`chirality_mul`).

* §4  The **degree bridge** as an abstract, proof-complete *reduction*
  (`deg_eq_chirality`): from the standard degree axioms — presented as named
  hypotheses that stand in for the missing API — the degree of the Bloch map
  equals `sign(det A)`. The hypotheses `deg_pos_det`/`deg_neg_det` are exactly
  the missing `GL⁺(3,ℝ)`-connectivity + homotopy-invariance input; the existence
  of `deg` is the missing Brouwer-degree API.

* §5  The **Chern bridge** kept *separate* (`chern_eq_chirality`), linked to the
  degree only by the explicit named hypothesis `chern_eq_deg` (the missing
  first-Chern-number = Bloch-degree physics), never by prose.

* Non-vacuity guard (`chirality_isDegreeModel`): `chirality = sign ∘ det`
  itself satisfies the abstract degree axioms, so §4 is not vacuous.

No new assumptions or compiled-evaluator shortcuts. Missing-API handoffs appear only as the named
hypotheses above and are documented at their use sites.

Provenance: clean-room finite algebra informed by the HNU single-Weyl
reconstruction (arXiv:1806.06868). The degree and Chern endpoints are not
available in the pinned Mathlib and are not claimed as proved here.
-/

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge

/-- Real momentum 3-vectors. -/
abbrev V3 := Fin 3 → ℝ
/-- Real `3×3` "vielbein"/Jacobian matrices `A`. -/
abbrev M3 := Matrix (Fin 3) (Fin 3) ℝ
/-- Complex `2×2` matrices (the two-band Pauli algebra). -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-! ## §0  Euclidean norm and normalization on `V3` -/

/-- Squared Euclidean norm `∑ vᵢ²`. -/
noncomputable def nrmSq (v : V3) : ℝ := ∑ i, (v i) ^ 2

/-- Euclidean norm `√(∑ vᵢ²)`. -/
noncomputable def nrm (v : V3) : ℝ := Real.sqrt (nrmSq v)

/-- Radial normalization `v ↦ v/‖v‖` (the map onto the unit sphere for `v ≠ 0`). -/
noncomputable def normalize (v : V3) : V3 := (nrm v)⁻¹ • v

/-- The unit-sphere predicate. -/
def OnSphere (v : V3) : Prop := nrm v = 1

lemma nrmSq_nonneg (v : V3) : 0 ≤ nrmSq v := Finset.sum_nonneg (fun _ _ => sq_nonneg _)

lemma nrmSq_eq_zero {v : V3} : nrmSq v = 0 ↔ v = 0 := by
  unfold nrmSq
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => sq_nonneg _)]
  simp [funext_iff]

lemma nrm_nonneg (v : V3) : 0 ≤ nrm v := Real.sqrt_nonneg _

lemma nrm_eq_zero {v : V3} : nrm v = 0 ↔ v = 0 := by
  unfold nrm; rw [Real.sqrt_eq_zero (nrmSq_nonneg v)]; exact nrmSq_eq_zero

lemma nrm_pos {v : V3} (hv : v ≠ 0) : 0 < nrm v :=
  lt_of_le_of_ne (nrm_nonneg v) (fun h => hv (nrm_eq_zero.mp h.symm))

lemma nrm_smul (t : ℝ) (v : V3) : nrm (t • v) = |t| * nrm v := by
  unfold nrm nrmSq
  have h : ∑ i, ((t • v) i) ^ 2 = t ^ 2 * ∑ i, (v i) ^ 2 := by
    simp [Pi.smul_apply, smul_eq_mul, mul_pow, Finset.mul_sum]
  rw [h, Real.sqrt_mul (sq_nonneg t), Real.sqrt_sq_eq_abs]

/-- Normalization lands on the unit sphere, for nonzero vectors. -/
lemma normalize_onSphere {v : V3} (hv : v ≠ 0) : OnSphere (normalize v) := by
  unfold OnSphere normalize
  rw [nrm_smul, abs_of_nonneg (inv_nonneg.2 (nrm_nonneg v)),
    inv_mul_cancel₀ (nrm_eq_zero.not.mpr hv)]

/-- Normalization is invariant under positive rescaling. -/
lemma normalize_smul_pos {t : ℝ} (ht : 0 < t) (v : V3) :
    normalize (t • v) = normalize v := by
  unfold normalize
  rw [nrm_smul, abs_of_pos ht, smul_smul, mul_inv, mul_right_comm,
    inv_mul_cancel₀ ht.ne', one_mul]

/-- Normalization fixes vectors already on the sphere. -/
lemma normalize_of_onSphere {v : V3} (hv : OnSphere v) : normalize v = v := by
  unfold normalize; rw [hv]; simp

/-! ## §1  Pauli algebra and the Weyl Hamiltonian `h(q) = (A q)·σ` -/

/-- Pauli `σ₁`. -/
def sigma1 : M2 := !![0, 1; 1, 0]
/-- Pauli `σ₂`. -/
def sigma2 : M2 := !![0, -Complex.I; Complex.I, 0]
/-- Pauli `σ₃`. -/
def sigma3 : M2 := !![1, 0; 0, -1]

/-- The Pauli contraction `v·σ = v₀σ₁ + v₁σ₂ + v₂σ₃` for a real 3-vector `v`. -/
noncomputable def pauliDot (v : V3) : M2 :=
  (v 0 : ℂ) • sigma1 + (v 1 : ℂ) • sigma2 + (v 2 : ℂ) • sigma3

/-- The two-band Weyl/Pauli Hamiltonian `h(q) = (A q)·σ`. -/
noncomputable def weylHam (A : M3) (q : V3) : M2 := pauliDot (A.mulVec q)

/-- **Pauli identity** `(v·σ)² = ‖v‖² • I`. This is the algebraic fact that makes
`v·σ` a Clifford/Weyl symbol: its square is the scalar `‖v‖²`. -/
lemma pauliDot_sq (v : V3) :
    pauliDot v * pauliDot v = ((nrmSq v : ℝ) : ℂ) • (1 : M2) := by
  unfold pauliDot sigma1 sigma2 sigma3 nrmSq
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.smul_apply, Fin.sum_univ_three,
      Complex.ext_iff, Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, pow_two] <;>
    first
      | (constructor <;> ring)
      | ring

/-- `v ↦ v·σ` is real-linear: `(t v)·σ = t (v·σ)`. -/
lemma pauliDot_smul (t : ℝ) (v : V3) : pauliDot (t • v) = (t : ℂ) • pauliDot v := by
  unfold pauliDot
  simp only [Pi.smul_apply, smul_eq_mul, Complex.ofReal_mul, smul_add, smul_smul]

/-- Squared Weyl Hamiltonian: `h(q)² = ‖A q‖² • I`. Eigenvalues are `±‖A q‖`. -/
lemma weylHam_sq (A : M3) (q : V3) :
    weylHam A q * weylHam A q = ((nrmSq (A.mulVec q) : ℝ) : ℂ) • (1 : M2) := by
  unfold weylHam; exact pauliDot_sq _

/-! ## §2  The normalized Bloch map `n : q ↦ (A q)/‖A q‖` as a sphere self-map -/

/-- The normalized Bloch map of the crossing `h(q) = (A q)·σ`: the sphere object
attached to the Pauli Hamiltonian. -/
noncomputable def blochVec (A : M3) (q : V3) : V3 := normalize (A.mulVec q)

/-- **Pauli Hamiltonian → sphere object**, made explicit: away from the crossing,
`h(q) = ‖A q‖ • ( n(q)·σ )` with `n(q) = blochVec A q ∈ S²`. This is the map from
the Hamiltonian to the sphere object referenced by the bridge theorems. -/
lemma weylHam_eq_norm_smul (A : M3) (q : V3) :
    weylHam A q = ((nrm (A.mulVec q) : ℝ) : ℂ) • pauliDot (blochVec A q) := by
  unfold weylHam blochVec normalize
  rw [pauliDot_smul, smul_smul, ← Complex.ofReal_mul]
  by_cases h : A.mulVec q = 0
  · simp [h, pauliDot]
  · rw [mul_inv_cancel₀ (nrm_pos h).ne', Complex.ofReal_one, one_smul]

/-- The Bloch map lands on the unit sphere away from the crossing. -/
lemma blochVec_onSphere {A : M3} {q : V3} (h : A.mulVec q ≠ 0) :
    OnSphere (blochVec A q) :=
  normalize_onSphere h

/-- The Bloch map is invariant under positive radial rescaling of `q` (it is a
genuine function of the ray, i.e. of a point of the sphere). -/
lemma blochVec_smul_pos {t : ℝ} (ht : 0 < t) (A : M3) (q : V3) :
    blochVec A (t • q) = blochVec A q := by
  unfold blochVec; rw [Matrix.mulVec_smul, normalize_smul_pos ht]

/-- **Functoriality of the Bloch construction** at the linear-algebra level:
`n_{AB} = n_A ∘ (B ·)`. Normalization kills the positive scalar introduced by
`B`, so `blochVec (A*B) q = blochVec A (B q)`. -/
lemma blochVec_comp (A B : M3) (q : V3) :
    blochVec (A * B) q = blochVec A (B.mulVec q) := by
  unfold blochVec; rw [Matrix.mulVec_mulVec]

/-- **Functoriality as composition of sphere self-maps**: applying `n_A` to the
sphere point `n_B q` gives `n_{AB} q` (for `B q ≠ 0`). This is the honest
`deg(f∘g)=deg f·deg g` substrate. -/
lemma blochVec_bloch {A B : M3} {q : V3} (h : B.mulVec q ≠ 0) :
    blochVec A (blochVec B q) = blochVec (A * B) q := by
  have hc : 0 < (nrm (B.mulVec q))⁻¹ := inv_pos.2 (nrm_pos h)
  have hbq : blochVec B q = (nrm (B.mulVec q))⁻¹ • B.mulVec q := rfl
  rw [hbq, blochVec_smul_pos hc, ← blochVec_comp]

/-! ## §3  Determinant-sign chirality, with identity/reflection witnesses -/

/-- The local Jacobian-sign chirality `χ(A) = sign(det A) ∈ {-1,0,1}`. This is a
total function of the supplied matrix; it is **not** a degree or a Chern number
(that identification is the content of §4–§5). -/
noncomputable def chirality (A : M3) : ℤ :=
  if 0 < A.det then 1 else if A.det < 0 then -1 else 0

/-- Canonical **identity witness**: `χ(I) = +1`. -/
lemma chirality_one : chirality (1 : M3) = 1 := by
  unfold chirality; rw [Matrix.det_one]; norm_num

/-- The canonical single-axis **reflection**. -/
noncomputable def reflect : M3 := Matrix.diagonal ![(-1 : ℝ), 1, 1]

lemma reflect_det : (reflect).det = -1 := by
  unfold reflect; rw [Matrix.det_diagonal]; simp [Fin.prod_univ_three]

/-- Canonical **reflection witness**: `χ(reflection) = -1`. -/
lemma chirality_reflect : chirality reflect = -1 := by
  unfold chirality; rw [reflect_det]; norm_num

/-- **Identity Bloch map**: `n_I` is the identity on the unit sphere. -/
lemma blochVec_one {q : V3} (hq : OnSphere q) : blochVec (1 : M3) q = q := by
  unfold blochVec; rw [Matrix.one_mulVec]; exact normalize_of_onSphere hq

/-- Chirality is `≠ 0` exactly on invertible (non-degenerate) crossings. -/
lemma chirality_ne_zero_iff (A : M3) : chirality A ≠ 0 ↔ A.det ≠ 0 := by
  unfold chirality
  rcases lt_trichotomy A.det 0 with h | h | h
  · rw [if_neg (not_lt.2 h.le), if_pos h]; simp [h.ne]
  · rw [if_neg (by simp [h]), if_neg (by simp [h])]; simp [h]
  · rw [if_pos h]; simp [h.ne']

/-- **Multiplicativity** `χ(A·B) = χ(A)·χ(B)` (from `det_mul` and sign of a
product). This is the algebraic shadow of degree multiplicativity under
`blochVec_comp`. -/
lemma chirality_mul (A B : M3) : chirality (A * B) = chirality A * chirality B := by
  unfold chirality
  rw [Matrix.det_mul]
  rcases lt_trichotomy A.det 0 with hA | hA | hA <;>
  rcases lt_trichotomy B.det 0 with hB | hB | hB <;>
  simp_all [mul_pos_iff, mul_neg_iff, not_lt.2, le_of_lt]

/-! ## §4  The degree bridge (abstract reduction; honest missing-API handoff)

We do **not** have a Brouwer degree in this Mathlib (see `AUDIT.md`). So the
bridge is stated as a reduction from the standard degree axioms, presented as
named hypotheses on an abstract `deg : M3 → ℤ` (read: the degree of the Bloch
self-map `blochVec A` on the enclosing sphere).

The two homotopy-invariance hypotheses are the exact missing input:

* `deg_pos_det` ⇐ `GL⁺(3,ℝ)` is path-connected, so `blochVec A ≃ₕ id` when
  `det A > 0`, plus homotopy invariance of degree;
* `deg_neg_det` ⇐ the `det < 0` component is path-connected to the reflection.

The existence of any such `deg` is the missing Brouwer-degree-of-`S²` API.
-/

/-- **Degree bridge.** Under the standard degree axioms (named hypotheses
standing in for the missing API), the degree of the enclosing-sphere Bloch map
equals the determinant-sign chirality. -/
theorem deg_eq_chirality
    (deg : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    -- MISSING API (GL⁺ connectivity + homotopy invariance of degree):
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    -- MISSING API (det<0 component connected to the reflection):
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect)
    (A : M3) (hA : A.det ≠ 0) :
    deg A = chirality A := by
  unfold chirality
  rcases lt_trichotomy A.det 0 with h | h | h
  · rw [if_neg (not_lt.2 h.le), if_pos h, deg_neg_det A h, deg_reflect]
  · exact absurd h hA
  · rw [if_pos h, deg_pos_det A h, deg_id]

/-- **Non-vacuity guard.** `chirality = sign ∘ det` itself satisfies every
abstract degree axiom used in `deg_eq_chirality`, so the reduction is
satisfiable and pins the unique invariant (it is not vacuously true). -/
theorem chirality_isDegreeModel :
    chirality 1 = 1 ∧ chirality reflect = -1 ∧
    (∀ A : M3, 0 < A.det → chirality A = chirality 1) ∧
    (∀ A : M3, A.det < 0 → chirality A = chirality reflect) := by
  refine ⟨chirality_one, chirality_reflect, ?_, ?_⟩
  · intro A h; rw [chirality_one]; unfold chirality; rw [if_pos h]
  · intro A h; rw [chirality_reflect]; unfold chirality;
    rw [if_neg (not_lt.2 h.le), if_pos h]

/-! ## §5  The Chern bridge (kept SEPARATE from the degree bridge)

The first Chern number of the negative-energy Berry eigenline bundle over the
enclosing sphere is a *distinct* object from the Bloch degree. Neither Chern
classes nor Berry curvature exist in this Mathlib. We keep the two invariants
separate and connect them **only** by the explicit named hypothesis
`chern_eq_deg` — never by prose — which is the missing physics theorem
(first Chern number = Bloch degree, i.e. Berry-curvature integration).
-/

/-- **Chern bridge.** Given the degree axioms *and* the separate first-Chern =
degree identity (`chern_eq_deg`, the missing Berry-curvature-integration
theorem), the first Chern number of the Berry eigenline bundle equals the
determinant-sign chirality. The degree and Chern invariants are linked only
through the explicit hypothesis, not by identification. -/
theorem chern_eq_chirality
    (deg chern : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect)
    -- MISSING PHYSICS API (first Chern number of Berry eigenline bundle = Bloch degree):
    (chern_eq_deg : ∀ A : M3, A.det ≠ 0 → chern A = deg A)
    (A : M3) (hA : A.det ≠ 0) :
    chern A = chirality A := by
  rw [chern_eq_deg A hA]
  exact deg_eq_chirality deg deg_id deg_reflect deg_pos_det deg_neg_det A hA

end PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
