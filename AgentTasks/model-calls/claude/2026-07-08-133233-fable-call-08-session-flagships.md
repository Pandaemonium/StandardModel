# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `claude-fable-5`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-08T13:29:46`
- Finished: `2026-07-08T13:32:33`
- Timeout seconds: `600`
- Max budget USD: `2.50`
- Return code: `0`

## Command

```text
claude -p --bare --model claude-fable-5 --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
# Fable-5 call 08 (solo run): audit the session's new flagships + manuscript state

You are the program's toughest semantic-alignment auditor + referee (finite,
machine-verified mathematical-physics program: *mass is the obstruction to
coherent null transport*). Since your last review (call-07) a large body of new
kernel-checked, guard-pinned results landed. I need (1) a **semantic-alignment
audit of the two most consequential new flagships** (embedded verbatim), and (2) a
**manuscript-state judgment** on whether the grade discipline held across ~40 edits.

## What landed since call-07 (all M, guard-pinned unless noted)

- **Mass gap, full sector**: `B_spectrum` (spectrum `{λ-κ,λ,λ+κ}`); `Msec` = the
  `6×6` sector form `B(λ,κ)⊕B(λ,-κ)` with least eigenvalue `λ-κ` = aperture-|closure|.
- **D2 unitary flow**: `exp(-itH)` unitary + `LinearIsometryEquiv`; carrier ORBIT
  conserves norm/energy. (Graded honestly: generator-as-Hamiltonian is a **C**
  posit; Euclidean ≠ Krein evolution — the sector's Krein form = Euclidean identity
  is `sector_krein_form_eq_one`.)
- **Binding defect** (`BindingDefect`): `Δ_block(λ,κ) = −κ` (negative,
  closure-controlled, off-diagonal) — the interacting-bridge crux, block level.
- **T2 Clifford provenance** (`CliffordAssembly`): the hand-typed carrier `HAC`/`Jmet`
  = the Cl(4) Kronecker assembly (verbatim); I graded this as "realizes the
  documented recipe" (NOT canonicity — K/order are inputs) after a prior audit.
- **S1-CC central-crux witness** (`S1CCPhysicalSectorWitness`, embedded): the §6
  closure form `J Q_C|V'/N` has inertia `(2,2,0)` on the explicit `6×6` physical
  sector — upgrading the program's former #1 crux from MEMO to kernel on the witness.
- **Organizing theorem, provable half** (`EquivariantGradedIndex`, embedded):
  `graded_budget_decomposition` writes the `4 D^#D = Q_A+Q_C+4Q_T+4E_#` budget as
  one equivariant graded-supertrace identity ("unification is decomposition");
  disclaimed as NOT a topological index.
- **Free second-quantized gap** (`FockMassGap`): `dΓ(B)` gap = one-particle gap;
  `Δ=−κ` seeds a below-threshold bound state (interacting hadron mass still open).

## Task 1 — semantic-alignment audit of the two embedded flagships (be adversarial)

**`S1CCPhysicalSectorWitness.lean`** (the central-crux upgrade). Probe HARD:
- Is `V'/N` the genuine Gauss-constraint physical sector, or a convenient
  coordinate choice? Is `N_in_radical` enough to justify "`B = (J Q_C)|V'/N` is the
  genuine induced form", or is the `submatrix` compression subtly not the true
  quotient form?
- Is `balanced_on_physical_sector` (inertia `(2,2,0)`) the real inertia of the
  induced form, or a weaker fact dressed up? Does the `6×6` toy carrier's link to
  the *actual* §6 closure form live outside the kernel (I claim only the witness is
  kernel; the general reduction stays MEMO — is that the honest line)?

**`EquivariantGradedIndex.lean`** (the organizing theorem). Probe:
- Is `graded_budget_decomposition` a genuine equivariant identity, or trace
  linearity applied to an *assumed* budget hypothesis (renamed to sound deep)?
  Where is the real content?
- Does anything call this an "index" in a way the kernel does not earn? Is the
  "NOT a topological index" disclaimer sufficient, or does the prose still oversell?

## Task 2 — manuscript state

The complete manuscript is embedded. Since call-07 it gained ~10 new §11 anchor
rows, §10 crux upgrades (S1-CC MEMO→kernel; binding defect C→block-M), a §9
second-quantization update, and grade caveats throughout. **Did the grade
discipline hold?** Flag any grade slip, internal inconsistency, stale "open/MEMO"
claim now closed, or over-claim introduced by the rapid additions — most severe
first. If the manuscript is clean, say so and say what you checked. Is it still
publication-ready as a self-contained draft?

## Required output

- **Semantic-alignment verdict** on each of the two embedded flagships (per-file,
  3-5 sentences): do the kernel statements say the intended physics? Any mismatch,
  most severe first.
- **Manuscript verdict**: did grade discipline hold; any slips; still done?
- **Bottom line**: the 1-3 most important things (if any) to fix.

One sharp correct load-bearing finding beats ten generic cautions. Report even if
the news is that it is all honest.


## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/GateYM/S1CCPhysicalSectorWitness.lean (262 lines)

```lean
/-
# S1-CC: an explicit physical-sector witness (MEMO → M for kill-condition K-B)

DRAFT (kernel-clean; no `s o r r y`). This file converts
the numeric-oracle kill condition **K-B** of `S1CC_RESOLUTION.md` (the `6×6`
witness with `sig(J Q_C|_{V'/N}) = (2,2,0)`, previously PASSED by
`probe_s1cc_balanced_inertia.py`) into a kernel-checked statement.

The carrier is `H = ℂ⁶ = (Fin 2) × (Fin 3)` (Clifford ⊗ color). Everything is
coordinate-aligned so that `V' = ker Q_G`, `N = range Q_G` and the coset
representatives `V'/N` are axis subspaces, and the induced Krein form on `V'/N`
is literally a `submatrix` of `J Q_C`.

Design and no-go analysis: `S1CC_MEMO_TO_M_STRATEGY.md`.
Abstract balance engine reused here: `S1CCBalancedInertia.lean`.

## Claim boundary

Finite explicit matrices. The abstract balance mechanism
(`hermitian_balanced_count_of_neg_charpoly`) is already M and is only *applied*
here. This file adds the concrete instantiation that was MEMO: an explicit
carrier realizing all hypotheses on the physical sector, with the compressed
form provably Hermitian, `b̄`-anticonjugated, nondegenerate and indefinite,
hence balanced with inertia `(2,2,0)` — never positive.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness

open Matrix
open scoped Kronecker

noncomputable section

/-! ## The carrier and its operators -/

/-- Clifford `σx`. -/
def sx : Matrix (Fin 2) (Fin 2) ℂ := !![0,1;1,0]
/-- Clifford `σz` — the closure grading generator on the Clifford leg. -/
def sz : Matrix (Fin 2) (Fin 2) ℂ := !![1,0;0,-1]
/-- Single null covector `E₀₁` (the Gupta–Bleuler "half constraint"). -/
def c1 : Matrix (Fin 2) (Fin 2) ℂ := !![0,1;0,0]
/-- Closure commutator `K` on the color leg (skew-Hermitian). -/
def Kc : Matrix (Fin 3) (Fin 3) ℂ := !![0,1,0;-1,0,0;0,0,0]
/-- Gauss operator `G = diag(0,0,1)` (Hermitian). -/
def Gc : Matrix (Fin 3) (Fin 3) ℂ := !![0,0,0;0,0,0;0,0,1]

/-- Nilpotent Gauss charge `Q_G = c₁ ⊗ G`. -/
def QG : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := c1 ⊗ₖ Gc
/-- Closure Krein form `J Q_C = (σx·σz) ⊗ K` on the full carrier (Hermitian). -/
def JQc : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := (sx * sz) ⊗ₖ Kc
/-- Closure bivector grading `b = σz ⊗ 1`. -/
def bg : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := sz ⊗ₖ (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-! ## Structural facts on the full carrier -/

/-- `[G,K] = 0`: descent (Theorem 1 of the resolution) holds for this carrier. -/
theorem GK_comm : Gc * Kc = Kc * Gc := by
  unfold Gc Kc; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_three]

/-- `Q_G² = 0`: the Gauss charge is nilpotent. -/
theorem QG_nilpotent : QG * QG = 0 := by
  unfold QG
  rw [← Matrix.mul_kronecker_mul]
  have : c1 * c1 = 0 := by
    unfold c1; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [this, Matrix.zero_kronecker]

/-- `J Q_C` is Hermitian (skew ⊗ skew). -/
theorem JQc_hermitian : JQc.IsHermitian := by
  unfold Matrix.IsHermitian JQc
  rw [Matrix.conjTranspose_kronecker]
  have h1 : (sx * sz)ᴴ = -(sx*sz) := by
    unfold sx sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.conjTranspose]
  have h2 : Kcᴴ = -Kc := by
    unfold Kc; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.conjTranspose]
  rw [h1, h2]; ext ⟨a,i⟩ ⟨b,j⟩; simp [kroneckerMap]

/-- `b² = 1`, so `b` is an involution (hence invertible with `b⁻¹ = b`). -/
theorem bg_sq : bg * bg = 1 := by
  unfold bg
  rw [← Matrix.mul_kronecker_mul, Matrix.mul_one]
  have : sz * sz = 1 := by
    unfold sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [this, Matrix.one_kronecker_one]

/-- **Full-carrier anticonjugation** `b⁻¹ (J Q_C) b = -(J Q_C)` (using `b⁻¹=b`). -/
theorem bg_anticonj : bg * JQc * bg = -JQc := by
  unfold bg JQc
  rw [← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, Matrix.one_mul,
    Matrix.mul_one]
  have h1 : sz * (sx*sz) * sz = -(sx*sz) := by
    unfold sx sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [h1]; ext ⟨a,i⟩ ⟨b,j⟩; simp [kroneckerMap]

/-- **Descent / radical fact.** The `N`-generator index `(0,2)` pairs trivially
with the whole carrier under `J Q_C` (row 2 and column 2 of `K` vanish). Hence
`N = range Q_G` lies in the radical of `J Q_C|_{V'}`, so the induced form on the
quotient `V'/N` is well-defined and equals the `submatrix` compression below. -/
theorem N_in_radical (p : Fin 2 × Fin 3) :
    JQc (0,2) p = 0 ∧ JQc p (0,2) = 0 := by
  constructor <;>
  · obtain ⟨b, j⟩ := p
    unfold JQc Kc; fin_cases b <;> fin_cases j <;>
      simp [kroneckerMap, Matrix.mul_apply, Fin.sum_univ_two]

/-! ## The compressed form on the physical sector `V'/N`

`V' = ker Q_G` and `N = range Q_G` are coordinate-aligned:
`Q_G = E_{(0,2),(1,2)}` (single matrix unit), so `V'` is all axes except
`(1,2)` (dim 5), `N = span e_{(0,2)}` (dim 1), and the coset representatives are
the four axes `(0,0),(0,1),(1,0),(1,1)` (= `ker G ⊕ ker G`).  -/

/-- Coset representatives of `V'/N`. -/
def r : Fin 4 → Fin 2 × Fin 3 := ![(0,0),(0,1),(1,0),(1,1)]

/-- The induced Krein form on `V'/N`, as the compression (submatrix) of
`J Q_C` to the representatives. -/
def B : Matrix (Fin 4) (Fin 4) ℂ := JQc.submatrix r r

/-- Explicit value of the compressed form: `B = (σx·σz) ⊗ k` with
`k = !![0,1;-1,0]` the `ker G` block of `K`. -/
def Bexpl : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,0,-1; 0,0,1,0; 0,1,0,0; -1,0,0,0]

/-- The descended grading `b̄ = σz ⊗ 1₂ = diag(1,1,-1,-1)` on `V'/N`. -/
def bg4 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The compression computes to the explicit matrix. -/
theorem B_eq_Bexpl : B = Bexpl := by
  unfold B Bexpl JQc r
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.submatrix, kroneckerMap, sx, sz, Kc, Matrix.mul_apply,
      Fin.sum_univ_two]

/-! ### Kernel facts on the compressed form -/

/-- `B` is Hermitian. -/
theorem B_isHermitian : B.IsHermitian := by
  rw [B_eq_Bexpl]
  unfold Matrix.IsHermitian Bexpl
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

/-- `B² = 1`: `B` is an involution, hence invertible with eigenvalues `±1`. -/
theorem B_sq : B * B = 1 := by
  rw [B_eq_Bexpl]; unfold Bexpl
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- `tr B = 0`. -/
theorem B_trace : B.trace = 0 := by
  rw [B_eq_Bexpl]; unfold Bexpl
  simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four]

/-- `b̄² = 1`. -/
theorem bg4_sq : bg4 * bg4 = 1 := by
  unfold bg4; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- **Compressed anticonjugation** `b̄ B b̄ = -B` (with `b̄⁻¹ = b̄`). -/
theorem bg4_anticonj : bg4 * B * bg4 = -B := by
  rw [B_eq_Bexpl]; unfold bg4 Bexpl
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- **Indefiniteness (the positivity refutation).** The Krein form on the
physical sector realizes both signs, so it is not positive (nor negative)
semidefinite. -/
theorem JQc_not_positive_on_sector :
    (∃ v : Fin 4 → ℂ, (star v ⬝ᵥ B.mulVec v).re < 0) ∧
    (∃ w : Fin 4 → ℂ, 0 < (star w ⬝ᵥ B.mulVec w).re) := by
  rw [B_eq_Bexpl]
  refine ⟨⟨![1,0,0,1], ?_⟩, ⟨![1,0,0,-1], ?_⟩⟩ <;>
    simp [Bexpl, Matrix.mulVec, dotProduct, Fin.sum_univ_four, star]

/-! ### Inertia `(2,2,0)` via the balance engine

`bg4_anticonj` + `S1CCBalancedInertia.anticonj_charpoly_eq` give
`(-B).charpoly = B.charpoly`; then
`S1CCBalancedInertia.hermitian_balanced_count_of_neg_charpoly` gives
`#pos = #neg`. `B_sq` gives `det B = ±1 ≠ 0`, hence no zero eigenvalue. Combined
with `Fintype.card (Fin 4) = 4` this yields the sharp inertia. -/

/-- `B` is invertible (from `B² = 1`). -/
theorem B_isUnit_det : IsUnit B.det := by
  have h : B.det * B.det = 1 := by
    have := congrArg Matrix.det B_sq
    rwa [Matrix.det_mul, Matrix.det_one] at this
  exact IsUnit.of_mul_eq_one _ h

/-- Charpoly symmetry on the sector, from the compressed anticonjugation. -/
theorem B_charpoly_symm : (-B).charpoly = B.charpoly := by
  haveI : Invertible bg4 := ⟨bg4, bg4_sq, bg4_sq⟩
  have hinv : (⅟ bg4 : Matrix (Fin 4) (Fin 4) ℂ) = bg4 := invOf_eq_right_inv bg4_sq
  have hAnti : ⅟ bg4 * B * bg4 = -B := by rw [hinv]; exact bg4_anticonj
  exact S1CCBalancedInertia.anticonj_charpoly_eq B bg4 hAnti

/-- **Balanced count on the physical sector**: as many positive as negative
Hermitian eigenvalues of `B`. -/
theorem B_balanced :
    (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card =
      (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card :=
  S1CCBalancedInertia.hermitian_balanced_count_of_neg_charpoly B B_isHermitian
    B_charpoly_symm

/-
No zero eigenvalue (nondegeneracy from invertibility).
-/
theorem B_no_zero_eig :
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 0 := by
  have h_det : B.det = ∏ i, (B_isHermitian.eigenvalues i : ℂ) := by
    convert Matrix.IsHermitian.det_eq_prod_eigenvalues B_isHermitian;
  have h_det_ne_zero : B.det ≠ 0 := by
    exact IsUnit.ne_zero ( B_isUnit_det );
  simp_all +decide [ Finset.prod_eq_zero_iff ]

/-
**`balanced_on_physical_sector`.** The closure Krein form on `V'/N` has
inertia `(2,2,0)`: two positive, two negative, no zero eigenvalues — balanced
(Krein signature zero), hence never positive. This is the kernel form of the
oracle result `sig(J Q_C|_{V'/N}) = (2,2,0)` (kill-condition K-B).
-/
theorem balanced_on_physical_sector :
    (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card = 2 ∧
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card = 2 ∧
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 0 := by
  refine' ⟨ _, _, _ ⟩;
  · have h_card : (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 4 := by
      rw [ Finset.card_filter, Finset.card_filter, Finset.card_filter ];
      rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ];
      exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rcases lt_trichotomy ( B_isHermitian.eigenvalues _ ) 0 with h | h | h <;> split_ifs <;> first | linarith | aesop ) ( by norm_num );
    linarith [ B_balanced, B_no_zero_eig ];
  · have h_card : (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 4 := by
      rw [ Finset.card_filter, Finset.card_filter, Finset.card_filter ];
      rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ];
      exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rcases lt_trichotomy ( B_isHermitian.eigenvalues _ ) 0 with h | h | h <;> split_ifs <;> first | linarith | aesop ) ( by norm_num );
    linarith [ B_balanced, B_no_zero_eig ];
  · convert B_no_zero_eig using 1

end

end PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness

/-! ## Build-enforced axiom pins (this file self-guards its flagships) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.balanced_on_physical_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.balanced_on_physical_sector

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.JQc_not_positive_on_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.JQc_not_positive_on_sector

```

### PhysicsSM/Draft/NullEdge/Carrier/EquivariantGradedIndex.lean (261 lines)

```lean
/-
# The equivariant graded index: the program's candidate organizing theorem

DRAFT (kernel-clean; no `s o r r y`). The structural core of the finite
equivariant-index framework proposed in Fable call-03 (Part A), overnight
all-mass run 2026-07-08. Full design + corollary map:
`AgentTasks/overnight-allmass-run-2026-07-08/CALL03_UNIFIER_S6WITNESS_MASSGAP.md`.
Strategy / over-claim analysis for this file: `src/ORGANIZING_THEOREM_STRATEGY.md`.

## The framework (why one theorem organizes §§4, 6, 8)

Three gradings the program discovered separately - the chirality `Gamma`,
the closure bivector `b = sigma_z (x) 1` (S1-CC), and the
edge-orientation-reversal grading of the GW structure - are all ODD
elements of ONE symmetry group acting on the decorated complex; gauge
transformations and the reflection `R` (C4) are EVEN elements. The master
invariant is the equivariant supertrace `tr(Gamma g | sector)`, and its
three uses are `g = 1` (McKean-Singer index protection, via the odd-power
cancellation `graded_trace_odd_power_vanishes`), `g = R` (the C4 sectored
pinning, `graded_trace_sector_split`), and
"an odd element exists" (S1-CC: the closure form has an exact supersymmetry,
so its Witten index vanishes sector-by-sector, forcing balanced inertia).
In the code `b` and the C4 witness grading are LITERALLY the same matrix
`sigma_z` - that identity is the framework, not a coincidence.

## What this file lands (the structural core + the provable-half identities)

The master object is the **equivariant graded (super)trace**
`sdim_g(A) := tr(Gamma * g * A)`, a `ℂ`-linear functional on operators.
The organizing theorem's *provable half* is the collection of exact finite
identities this functional satisfies; the *aspirational half* (a topological
index theorem a la Atiyah-Singer) is NOT claimed - see the strategy note.

Structural core (unchanged):
* `IsOddInvolutionFor`, `IsEvenSymmetryFor`: the shared data (an odd
  involution grading, an even commuting symmetry).
* `chiralProduct_involution`: `C := Gamma * W` is an involution.
* `sector_pins_W_fixed`: common eigenvectors of `Gamma` and `C` are `W`-fixed.

Provable-half graded-trace identities (the sharpest true finite statements):
* `graded_trace_odd_vanishes`: `sdim_g` of an *odd* operator is `0`
  (the finite McKean-Singer supersymmetric cancellation).
* `gamma_pow_comm`, `graded_trace_odd_power_vanishes`: `tr(Gamma * D^(2k+1)) = 0`
  - only *even* powers of the Dirac operator (i.e. functions of `D^#D`) can
  contribute to the supertrace: the finite "localizes to `D^#D`" statement.
* `graded_trace_sum`: `sdim_g(Sum_i Q_i) = Sum_i sdim_g(Q_i)` - additivity;
  "unification is decomposition" over an arbitrary channel index.
* `graded_budget_decomposition`: the exact Dirac-square budget
  `4 D^#D = Q_A + Q_C + 4 Q_T + 4 E_#` becomes ONE equivariant graded
  identity relating the four channels' graded indices to the total.
* `graded_trace_sector_split`: `sdim(A) = sdim_{P_+}(A) + sdim_{P_-}(A)` for
  the reflection sectors `P_+- = (1 +- R)/2` - the C4 isotypic refinement.

## Claim boundary

Provable half only (finite linear algebra: trace cyclicity + eigenvalue
pairing). This file makes NO topological-index claim: there is no base space,
no family of Dirac operators, no K-theory class, and no characteristic-class
formula. The finite "index" here is literally `str(ker D)` and is computed
directly, not by topology (manuscript S2a is explicit about this). The
remaining substance - L3 `graded_supertrace_localizes_to_kernel` (finrank
form of McKean-Singer), L4 `sector_involution_pinning` (the `dim >= |nu|`
counting, C4), the balanced-inertia capstone (L2, `anticonj_charpoly_eq` ->
`n_+ = n_-`), and the RG-Schur bridge (L5) - are documented M-targets that
need the spectral/eigenspace `finrank` API and are handed off.

## Provenance

Fable call-03 (2026-07-08), Part A - the organizing theorem and its Lean
design - [orig]/[interp]; the involution and trace algebra is elementary -
[import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Shared data (odd face).** `Gamma` is an odd involution for the
operator `X`: a Hermitian self-inverse grading anticommuting with `X`. The
additive-face hypothesis of the master theorem (S1-CC / index protection). -/
structure IsOddInvolutionFor (Gamma X : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  herm : Gammaᴴ = Gamma
  anti : Gamma * X = -(X * Gamma)

/-- **Shared data (even face).** `g` is an even symmetry: it commutes with
both the operator `X` and the grading `Gamma`. The gauge group and the C4
reflection `R` are even elements. -/
structure IsEvenSymmetryFor (g X Gamma : Matrix n n ℂ) : Prop where
  commX : g * X = X * g
  commGamma : g * Gamma = Gamma * g

/-- **The chiral product is an involution (the sector-index heart).** For an
odd involution `Gamma` (`Gamma^2 = 1`) and a unitary `W` (`Wᴴ W = 1`) with
`Gamma W Gamma = Wᴴ` (the multiplicative face), `C := Gamma * W` satisfies
`C^2 = 1`. So `V` splits into `C`'s `+-1` eigenspaces, and together with
`Gamma`'s split this pins the `+-1` eigenvalues of `W` - the multiplicative
face of the same anticonjugation that gives the additive balanced inertia. -/
theorem chiralProduct_involution (Gamma W : Matrix n n ℂ)
    (hchiral : Gamma * W * Gamma = Wᴴ) (hU : Wᴴ * W = 1) :
    (Gamma * W) * (Gamma * W) = 1 := by
  rw [← mul_assoc (Gamma * W) Gamma W, hchiral, hU]

/-- **The sector mode-production heart (clause (iii), spectral-theorem-free).**
If a vector `v` is a common `s`-eigenvector of the grading `Gamma` and the
chiral product `C = Gamma W` for a sign `s` (`s^2 = 1`, so `s = +-1`), then
`v` is a fixed vector of `W`: `W v = v`. This is why BOTH the `(+1,+1)` and
`(-1,-1)` sectors of `(Gamma, C)` land in `ker(W - 1)` - the finite
mode-production fact behind the sectored pinning inequality (the finrank
counting `dim >= |nu|` is the remaining L4 step). No eigenvalues, no
spectral theorem - pure `mulVec` algebra. -/
theorem sector_pins_W_fixed (Gamma W : Matrix n n ℂ) (v : n → ℂ) (s : ℂ)
    (hGamma : Gamma * Gamma = 1) (hs : s * s = 1)
    (hGv : Gamma.mulVec v = s • v)
    (hCv : (Gamma * W).mulVec v = s • v) :
    W.mulVec v = v := by
  have h2 : Gamma.mulVec ((Gamma * W).mulVec v) = Gamma.mulVec (s • v) := by
    rw [hCv]
  rw [Matrix.mulVec_mulVec, ← mul_assoc, hGamma, one_mul, Matrix.mulVec_smul,
    hGv, smul_smul, hs, one_smul] at h2
  exact h2

/-! ## The provable half: exact finite graded-trace identities

The equivariant graded supertrace is `sdim_g(A) := (Gamma * g * A).trace`.
The following are the sharpest TRUE finite statements the framework supports.
They are pure linear algebra (trace cyclicity + a sign), NOT a topological
index theorem. -/

omit [DecidableEq n] in
/-- **Supersymmetric cancellation (finite McKean-Singer, `g`-equivariant).**
If `Gamma` anticommutes with an operator `X` (`X` is *odd*) and the even
symmetry `g` commutes with `X`, then the equivariant supertrace of `X`
vanishes: `tr(Gamma * g * X) = 0`. This is the finite algebraic heart of
"the supertrace sees only the kernel": odd contributions cancel between the
two chirality sectors. Only `[g, X] = 0` is needed here (not `[g, Gamma]`),
so the even-face commutation with `Gamma` is deliberately omitted. -/
theorem graded_trace_odd_vanishes (Gamma g X : Matrix n n ℂ)
    (hanti : Gamma * X = -(X * Gamma)) (hgX : g * X = X * g) :
    (Gamma * g * X).trace = 0 := by
  have h1 : Gamma * g * X = -(X * Gamma * g) := by
    have h0 : Gamma * g * X = Gamma * (g * X) := by rw [mul_assoc]
    rw [h0, hgX, ← mul_assoc, hanti, neg_mul, mul_assoc]
  have h2 : (Gamma * g * X).trace = (X * Gamma * g).trace := by
    rw [Matrix.trace_mul_comm (Gamma * g) X, mul_assoc]
  rw [h1, Matrix.trace_neg] at h2
  have ht : (X * Gamma * g).trace = 0 := self_eq_neg.mp (id (Eq.symm h2))
  rw [h1, Matrix.trace_neg, ht, neg_zero]

/-- If `Gamma` anticommutes with `D`, then `Gamma * D^m = (-1)^m • (D^m * Gamma)`:
the grading picks up the parity of the power. The engine behind
`graded_trace_odd_power_vanishes`. -/
theorem gamma_pow_comm (Gamma D : Matrix n n ℂ) (hanti : Gamma * D = -(D * Gamma)) :
    ∀ m : ℕ, Gamma * D ^ m = (-1 : ℂ) ^ m • (D ^ m * Gamma) := by
  intro m
  induction m with
  | zero => simp
  | succ k ih =>
    have step : Gamma * D ^ (k + 1) = (Gamma * D ^ k) * D := by rw [pow_succ, ← mul_assoc]
    rw [step, ih, Matrix.smul_mul, mul_assoc, hanti, mul_neg, ← mul_assoc, ← pow_succ,
        pow_succ (-1 : ℂ)]
    module

/-- **Localization to `D^#D` (finite McKean-Singer, odd powers).**
For a Dirac operator `D` anticommuting with the grading `Gamma`, the
supertrace of every *odd* power of `D` vanishes: `tr(Gamma * D^(2k+1)) = 0`.
Hence any supertrace that is a power series in `D` reduces to a series in the
*even* powers `D^(2k) = (D^#D)^k` - the finite face of "the supertrace of the
heat kernel localizes to `D^#D` / to the kernel of `D`." -/
theorem graded_trace_odd_power_vanishes (Gamma D : Matrix n n ℂ)
    (hanti : Gamma * D = -(D * Gamma)) (k : ℕ) :
    (Gamma * D ^ (2 * k + 1)).trace = 0 := by
  have h := gamma_pow_comm Gamma D hanti (2 * k + 1)
  have hsign : (-1 : ℂ) ^ (2 * k + 1) = -1 := by rw [pow_succ, pow_mul]; norm_num
  rw [hsign, neg_one_smul] at h
  have hcyc : (Gamma * D ^ (2 * k + 1)).trace = (D ^ (2 * k + 1) * Gamma).trace :=
    Matrix.trace_mul_comm _ _
  rw [h, Matrix.trace_neg] at hcyc
  have ht : (D ^ (2 * k + 1) * Gamma).trace = 0 := self_eq_neg.mp (id (Eq.symm hcyc))
  rw [h, Matrix.trace_neg, ht, neg_zero]

omit [DecidableEq n] in
/-- **Unification is decomposition (additivity of the graded index).**
The equivariant graded supertrace of a channel sum is the sum of the
per-channel graded supertraces: `sdim_g(Sum_i Q_i) = Sum_i sdim_g(Q_i)`.
This is the exact, general form of the organizing slogan. -/
theorem graded_trace_sum {ι : Type*} (s : Finset ι) (Gamma g : Matrix n n ℂ)
    (Q : ι → Matrix n n ℂ) :
    (Gamma * g * (∑ i ∈ s, Q i)).trace = ∑ i ∈ s, (Gamma * g * Q i).trace := by
  rw [Finset.mul_sum, Matrix.trace_sum]

omit [DecidableEq n] in
/-- **The Dirac-square budget as one equivariant graded identity.**
Given the four-channel budget `4 (D^# D) = Q_A + Q_C + 4 Q_T + 4 E_#`
(aperture/kinetic, closure/QCD, turn/Higgs, soldering/gravity), the four
channels' graded indices assemble into the total graded index:
`4 sdim_g(D^#D) = sdim_g(Q_A) + sdim_g(Q_C) + 4 sdim_g(Q_T) + 4 sdim_g(E_#)`.
This is the honest content of "the four channels ARE the graded pieces of one
equivariant index": an exact additive decomposition of the master functional.
It is NOT the claim that this common value is a topological invariant. -/
theorem graded_budget_decomposition
    (Gamma g Dsharp D QA QC QT E : Matrix n n ℂ)
    (hbudget : (4 : ℂ) • (Dsharp * D) = QA + QC + (4 : ℂ) • QT + (4 : ℂ) • E) :
    (4 : ℂ) • (Gamma * g * (Dsharp * D)).trace
      = (Gamma * g * QA).trace + (Gamma * g * QC).trace
        + (4 : ℂ) • (Gamma * g * QT).trace + (4 : ℂ) • (Gamma * g * E).trace := by
  have key : (Gamma * g * ((4 : ℂ) • (Dsharp * D))).trace
      = (Gamma * g * (QA + QC + (4 : ℂ) • QT + (4 : ℂ) • E)).trace := by rw [hbudget]
  simp only [Matrix.mul_smul, mul_add, Matrix.trace_add, Matrix.trace_smul,
    smul_eq_mul] at key ⊢
  linear_combination key

/-- **The C4 isotypic refinement (reflection-sectored split).**
For a reflection `R`, the graded index splits over the two sectors
`P_+- = (1 +- R)/2`: `sdim(A) = sdim_{P_+}(A) + sdim_{P_-}(A)`. This needs
only `P_+ + P_- = 1` (an algebraic identity in `ℂ`); that `P_+-` are the
`R`-eigenprojections is the extra input `R^2 = 1` used downstream to make the
per-sector values integers `nu_0(chi), nu_pi(chi)`. -/
theorem graded_trace_sector_split (Gamma R A : Matrix n n ℂ) :
    (Gamma * A).trace
      = (Gamma * ((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R)) * A).trace
        + (Gamma * ((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)) * A).trace := by
  have hsum : (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R) + (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)
      = 1 := by rw [← smul_add]; module
  calc (Gamma * A).trace
      = (Gamma * (((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R)
            + (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)) * A)).trace := by rw [hsum, one_mul]
    _ = _ := by rw [add_mul, mul_add, Matrix.trace_add, mul_assoc, mul_assoc]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.chiralProduct_involution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiralProduct_involution

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.sector_pins_W_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sector_pins_W_fixed

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_odd_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_odd_vanishes

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_odd_power_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_odd_power_vanishes

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_budget_decomposition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_budget_decomposition

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_sector_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_sector_split

end PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

```

### Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md (1483 lines)

```markdown
# Mass as null disagreement: a machine-verified finite framework

**A finite, kernel-checked framework in which the invariant mass of a
bundle of light-speed degrees of freedom is the geometric disagreement of
their directions, and a single Dirac-type square decomposes into four
force-shaped channels. The one trusted theorem is classical kinematics,
formalized; the dynamics is finite operator algebra, graded honestly.**

Draft v1, 2026-07-08. Status: **[DRAFT-MS]**. It subsumes and cites the P1
origin-of-mass draft (`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`)
rather than replacing it.

*On the title (the paper's discipline applied to itself).* An earlier
working title, "All mass from null edges," claimed more than the grades
license: the kernel-checked content is (a) a classical kinematic identity,
formalized, and (b) finite operator algebra whose central functional is now
proved a genuine *positive squared mass* on a concrete carrier
(`T2_positive_mass`, **M**; §4 rail 3), while its identification with *the*
physical mass of a Standard-Model particle remains conjectural (**C**). Per
this paper's own rule, a title graded **C** is an error; the present title is
what the grades support.
"All mass" survives only as the *program's* aim, not this paper's result.

Every technical claim below carries a grade, and the grades are as much the
point of the paper as the claims are:

| Grade | Meaning |
|---|---|
| **T** | source-verified theorem (external mathematics) |
| **M** | machine-verified: kernel-checked in Lean 4 under the pinned toolchain, axiom-audited, guard-pinned |
| **MEMO** | expert- and LLM-oracle-verified prose (hand-derivation plus frontier-model cross-check), pending kernel transcription — an explicit methodological choice, not a proof; failure mode is a convention or algebra slip that the kernel would catch |
| **C** | pre-registered conjecture with an explicit kill condition |
| **[import]** | an external result used as input, not reproved here |

The discipline this paper holds itself to: **a sentence that claims more
than its grade licenses is an error, however true it may turn out to be** —
and (per the reviews this draft has had) that discipline binds the
*interpretive* vocabulary too: the channel names of §4 are **structural
analogies at grade C** (no continuum reduction is claimed; §4a), and any
"oracle" / "Fable-analysis" evidence is a numerical experiment, not part of
the verified core (§11). Two long-standing conjectures of this program died
this month by their own pre-registered tests (§10); we report those with the
same prominence as the theorems, because a program that cannot say what it
has *disproved* cannot be trusted about what it has proved.

---

## 1. Thesis and reading guide

One sentence: **mass is the obstruction to coherent null transport.**

Unpacked: the only primitive is a *null edge* — an elementary step that
moves at the speed of light, the way a photon does. Nothing in the theory
is slow, and nothing is heavy, at the bottom. Bind several such steps into
one object and ask whether the bundle can still move at light speed. If
its constituent light-directions all agree, it can, and it is massless.
If they disagree, the bundle as a whole cannot keep up with light, and the
total amount of that disagreement *is* its mass squared (the exact form, §3;
"squared" is not a hedge — the invariant is literally a sum of squares).
Mass is trapped, mutually disagreeing light.

The organizing slogan of the formal work is **"unification is
decomposition."** A single finite operator — the carrier Dirac operator —
squares to a sum of four terms, and each term is one physical channel
through which mass enters: aperture (kinetic), closure (gauge / QCD), turn
(Higgs / Yukawa), and soldering-gradient (gravity). We do not unify the
forces by identifying them; we unify them by exhibiting them as four
summands of one square (§4).

**How to read this paper.** Part I (§2) is written for a reader who has
seen special relativity and a little quantum mechanics — no gauge theory
assumed. From §3 onward the grades take over and the register is
technical. A reader who wants only the verified core can read §3 (the one
trusted theorem), §4 (the decomposition that organizes everything), and
the anchor table (§11), and skip the rest.

**Glossary (recurring terms and internal labels).** So the technical
sections do not rely on codenames a reader cannot decode:

*Objects.* **Null edge** — an elementary light-speed step (the only
primitive). **Carrier (Dirac) operator `D`** — the finite first-quantized
operator whose square organizes the mass channels. **`det P`** — the
Gram/Plücker invariant of §3 that equals total pairwise null disagreement;
the paper's definition of "mass" at the kinematic layer. **Krein space** —
a vector space with an *indefinite* inner product (a `+`/`−` metric); the
right setting for a Lorentzian, not Euclidean, operator, and the reason
"positive" is a theorem to be earned, not assumed. **Channel operators
`Q_A, Q_C, Q_T`** — three Krein blocks of `4 D^#D`: aperture/**kinetic**,
closure/**gauge–QCD**, and turn/**Higgs** respectively. **`E_#`** — the Krein
self-adjointness *defect* (the cross term; vanishes in the self-adjoint gauge
class); it is *not* the gravity block — identifying it with the gravity-shaped
soldering-gradient channel `E` of §7 is a *conjecture* (§4). (All channel
names are grade-C analogies, §4a.)

*Named external tools (all `[import]`/`T`).* **Weitzenböck / Lichnerowicz
identity** — the algebraic fact that a Dirac operator's square is a
Laplacian plus curvature; our four-block split is the finite instance.
**Ginsparg–Wilson** — the lattice way to keep exact chirality at finite
size; here the edge-orientation-reversal grading. **McKean–Singer /
Lefschetz index** — supertrace formulas that count protected modes; §8's
masslessness protection. **Banks–Casher** — relates near-zero eigenvalue
density to condensation; we use only its finite *count* form. **Schur
complement** — the linear-algebra "integrate out a site" step; §9's
decimation. **Rayleigh–Ritz** — variational characterization of the lowest
eigenvalue; the keystone (`sector_ground_mass`) that would turn the budget
functional into a mass.

*Internal labels (this program's own bookkeeping).* **S1-CC** — the
"closure-channel positivity" question (S1) and its resolution as
*balanced* (§6); the program's former #1 crux. **Amendment A2/A4** —
numbered proposals in the program's working memos (A2: closure-defect
energy; A4: the disorder→condensate bridge, since killed, §9/§10). **Probe
P#** — a pre-registered numerical oracle experiment with a kill condition
(e.g. probe P1 killed the tetrahedral-Koide route, §5). **`sector_ground_
mass`, `aperture_dominance_pos`, `carrier_square_assembly`, …** — Lean
theorem names; every one appears with its file and guard status in §11.

---

## 2. Part I: what is a particle, and what is mass?

*(This section makes no new claims; it is the physical picture behind the
mathematics, in plain language.)*

**A particle is a knot of trapped light.** Picture an electron not as a
tiny ball but as light caught zig-zagging: a left-moving light-step, then
a right-moving light-step, alternating forever. Each leg races at the
speed of light. But a zig-zag that reverses on itself does not *get*
anywhere fast — its average progress is slow, and a particle "at rest" is
the extreme case where the legs cancel and the light runs in place. This
is the old idea that a massive particle is light that has been trapped, and
this program's central theorem (§3) makes it exact: **the mass *squared* of
a bundle of light-steps is precisely the total disagreement among their
directions** (the disagreement is a sum of squared wedges, so it carries the
dimensions of mass squared — see §3). All directions parallel: no disagreement, no mass, and the
thing flies off at light speed like a photon. Any disagreement: mass.

**Where mass is made: the corners.** The mass lives not in the legs of the
zig-zag but in the *corners* — the events where the light changes
direction. Take away the ability to turn, and the particle runs straight
at light speed forever, massless. So "how much mass" and "how often it
turns" are the same question. And a turn is not free: turning a
left-handed mover into a right-handed one changes a bookkeeping quantity
(weak charge) that must balance, and the thing that balances it is a field
filling all of space — the Higgs. In this picture the Higgs is not an
optional extra; it is the entry the corner *requires* in order to exist
(§5).

**What a particle is made of: strands.** Internally, a particle's identity
is a short list — which of a few elementary "strands" it carries. Charge
is the bookkeeping of that list: quarks and leptons differ by how many
color strands they hold, which is why quark charges come in thirds; lepton
number and baryon number are just *counts* of strands. An antiparticle is
the same list read backwards. The whole
particle zoo of one generation is the catalogue of ways to occupy a
handful of strands.

**Why particles are stable: topology.** Some patterns cannot come apart,
not because a force holds them but because a *count* forbids it. When the
left-handed and right-handed slots fail to balance, the surplus cannot
find a partner to turn with, and so it cannot acquire mass no matter what
fields you switch on. It stays massless the way a knot stays knotted (§8).
This is the program's reading of why masslessness in the Standard Model
tracks chirality.

**Nothing moves slower than light — fundamentally.** Every edge is null.
The electron on your desk is, in this ontology, moving at light speed the
entire time — it simply is not *going* anywhere, because its light-steps
disagree and cancel. "Slower than light" is what the statistics of
disagreeing light-steps looks like from far away. There is no slow
substance underneath.

That is the entire picture. The rest of the paper is the mathematics that
makes each italicized claim precise, and honest about which are theorems
and which are still hopes.

---

## 2a. Related work: where this sits, and what is new

None of the physical *pictures* above is original, and the paper is stronger
for saying so; the novelty is a finite Krein-space setting, machine
verification, and the four-channel budget as one object. Situating the work:

- **The kinematic identity (§3) is classical spinor-helicity.** For a sum of
  real null momenta `P = Σ pᵢ`, `P² = Σ_{i<j} 2 pᵢ·pⱼ = Σ_{i<j} |⟨ij⟩|²`, and
  the invariant mass of a multi-massless system vanishes iff the momenta are
  collinear — textbook in the amplitudes literature (Elvang–Huang; Dixon,
  TASI lectures) `[import]`. Our contribution in §3 is *not* the fact but its
  Plücker/Cauchy–Binet packaging, its kernel-checked formalization, and its
  use as the organizing invariant that reappears in every channel. As an
  independent convention check, our spinor wedge `ψ⁰φ¹ − ψ¹φ⁰` coincides
  exactly with the left-handed Weyl metric `𝓔 = !![0,1;-1,0]` of the PhysLean
  physics library (`Physlib/Relativity/Tensors/ComplexTensor/Weyl`,
  Tooby-Smith) `[import]` — same 2-component `SL(2,ℂ)` spinors, same sign — so
  §3 is not idiosyncratic notation but the standard, independently-formalized
  object; PhysLean's `comm_metricRaw` is the `SL(2,ℂ)`-invariance that makes
  `det P` Lorentz-invariant.
- **Part I is Penrose and Feynman.** The zig-zag electron is Penrose (*Road
  to Reality* §25.2); the "velocity eigenvalues are ±c, rest is light running
  in place" picture is *Zitterbewegung* (Dirac; Hestenes); the discrete
  null-step-with-corners model is the **Feynman checkerboard**. The last is a
  standing **asset**, not just a citation: the checkerboard's continuum limit
  to the 1+1D Dirac propagator is a *proven theorem* (Gersch; Jacobson–
  Schulman) `[import]` — a `T`-grade external result that closes the §9/§10
  continuum gap *for the simplest chain*, which we import rather than reprove.
  **This is also the closest living prior art, and we flag it plainly:**
  Foster–Jacobson (2016), "Spin on a 4D Feynman Checkerboard" `[import]`,
  discretize the Weyl equation on a hypercubic lattice with **null faces**,
  with step amplitudes that are **spin projection operators** and a retarded
  propagator that is a product of projectors, and **no fermion doubling** — a
  construction startlingly close to our null-soldered Clifford carrier with
  reflection sectors. Our added structure is the Krein grading and the
  four-channel budget on top of such a carrier; the honest reading of F8/§9 is
  "cast the Foster–Jacobson null-face checkerboard as a Krein carrier and read
  its mass budget," not a new 3+1D checkerboard. Kull (2002) similarly builds a
  checkerboard on a *dense rational* (non-continuous) 2D Minkowski.
- **Structurally closest living programs.** The nearest relatives are the
  *indefinite-metric spectral-triple* programs, and we cite them because they
  already occupy ground §2a earlier drafts implied was ours: **Bizi–Brouder–
  Besnard (2016)** build a pseudo-Riemannian spectral triple over **Krein**
  spaces and *exhibit a physical-state space solving the fermion-doubling
  problem* `[import]` — the same Krein-positive-sector move we make (§6, §8);
  **Barrett (2007)** gives a *Lorentzian* version of the NCG Standard Model
  `[import]`; **Connes (2006)** cures fermion doubling by a KO-dimension-6
  twist `[import]`. Finster's *causal fermion systems* (finite/measure-
  theoretic, mass from a variational principle, no background) `[import]` and
  Connes' *spectral triples* generally (our carrier `D` with the `Γφ`
  fluctuation is NCG-adjacent) are the broader family. On the discrete-Dirac
  side, the *quantum-walk / quantum-cellular-automaton* literature (Bakircioglu–
  Arnault–Arrighi 2025 give a chiral, doubler-free, neutrino-like QCA and its
  Nielsen–Ninomiya evasion) `[import]` is the nearest kin to §8/the doubler
  discussion. **Mlodinow–Brun (2018) is the closest *mass*-side kin:** a 3D
  quantum walk whose **four-dimensional** coin space is *forced* to carry the
  Dirac gamma matrices by parity and a discrete-rotation ("noncorrelation")
  symmetry, with the **coin-flip operator as the mass term** and a *massless*
  particle recovered exactly when that operator is switched off `[import]`. That
  is an independent "mass is an internal operator you can turn off" statement,
  and it rhymes precisely with our two-null-edge `Cl(4)` carrier and its
  massless critical line `κ = λ` (§4) — but without our Krein grading, the
  four-channel budget, or the `det P` kinematic-mass tie; their single coin
  operator is our aperture/closure pair. Kauffman–Noyes combinatorial work and Wilczek's "mass without
  mass" (the QCD share) `[import]` are the nearest slogans; Zwanziger's (1991)
  lattice confinement / positivity-violation setting is a nearby comparison
  and a warning that this terrain is occupied, not source support for §6's
  finite balanced-closure theorem `[import]`.
- **What is new, stated by contrast — and narrowed after a literature
  review.** Neither the finite Krein setting (Bizi et al; Barrett) nor
  machine-verified physics (HepLean/PhysLean `2405.08863`) `[import]` is new
  *on its own*, and we do not claim either.
  The defensible novelty is the **combination**: (i) a
  finite Krein *null-edge* carrier whose square is graded into a four-channel
  budget `4 D^#D = Q_A+Q_C+4Q_T+E_#` that **answers to the kernel-checked
  Plücker mass invariant `det P`** — we did not find this specific tie between
  an indefinite-metric operator budget and the §3 kinematic mass in our search,
  and we make no primacy claim;
  (ii) a **pre-registered kill-discipline** (grades, oracle quarantine, kill
  conditions) applied to a speculative unification — a working methodology, not
  "first verified physics"; and (iii) **kernel verification of a specific
  constructive-QFT chain** (reflection positivity → OS reconstruction →
  spectral gap → clustering), a machine-checked instance of that chain on finite
  lattices; we make no priority claim relative to existing verified-physics work
  such as HepLean. The pictures are borrowed and the individual ingredients are
  occupied; the combination, the `det P`-answering budget, and the verified
  kill-discipline are the current contribution. A full prior-art map with
  novelty-gap analysis is in
  `Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`. Full source-key:
  `Sources/Null_Edge_References.md`.

**Where this sits, at a glance.** The table crystallizes the positioning: no
column is uniquely ours, but the *conjunction* of the last three rows is.

| Program | finite | indefinite / Krein | fermion doubling handled | mass = `det P` (null-disagreement) invariant | one four-channel budget | kernel-verified + kill-discipline |
|---|---|---|---|---|---|---|
| **This paper** | ✓ | ✓ | ✓ (Krein-null) | ✓ | ✓ | ✓ |
| Bizi–Brouder–Besnard (Krein triple) | — | ✓ | ✓ | — | — | — |
| Barrett (Lorentzian NCG-SM) | fin. internal | ✓ | ✓ (KO-6) | — | — | — |
| Connes–Chamseddine (NCG-SM) | fin. internal | Euclidean | ✓ (KO-6) | — | — | — |
| Foster–Jacobson (4D checkerboard) | ✓ | — | ✓ | — | — | — |
| QCA / quantum-walk Dirac | ✓ | — | ✓ | — | — | — |
| Finster (causal fermion systems) | ✓ | Lorentzian | — | variational | — | — |
| HepLean / PhysLean | ✓ | — | — | — | — | ✓ (formalized) |

The novelty is the bottom-right block read together — a finite *Krein* carrier
whose square is a four-channel budget *answering to the kernel-checked Plücker
mass*, under a pre-registered kill-discipline — not any single ✓.

---

## 3. The kinematic layer: one trusted theorem (**T**/**M**)

Everything orbits a single kernel-checked identity. Represent a massless
degree of freedom by a two-component Weyl spinor `psi`; its contribution
to energy-momentum is the rank-one Hermitian matrix `psi psi^dagger`. A
particle-like system is a finite bundle of these, with total momentum
`P = sum_i psi_i psi_i^dagger`. Then

```text
det P = sum_{i<j} | psi_i wedge psi_j |^2 .
```

The left side is invariant mass squared. The right side is the total
pairwise *disagreement* of the null directions — the sum of squared
wedges, which vanishes exactly when two directions are parallel.

The sharpest reading is geometric: `P = sum_i psi_i psi_i^dagger` is a
positive matrix, and `det P` is the *area* (squared volume) its null
directions span in spinor space. A massless bundle has **rank-one**
momentum — all its light points one way, a single coherent beam. A massive
bundle spans a **two-** (or higher-) dimensional slice, and its mass squared
is exactly the area opened by the nonparallel directions. So "mass is trapped
disagreeing light" is, precisely, *mass is the area null directions open in
spinor space* — massless is rank-collapse, massive is spread. So:

- A single null edge is massless: `det (psi psi^dagger) = 0`
  (`det_rankOneHermitian_eq_zero`, **M**, trusted namespace
  `PhysicsSM.Spinor.PluckerMass`); and the two-edge mass identity and its
  collinearity criterion are trusted there too (`two_edge_plucker_mass_identity`,
  `two_edge_mass_zero_iff_wedge_zero`).
- Mass equals total pairwise disagreement for any finite bundle
  (`fin_bundle_plucker_mass_identity`, **M**; the general `n`-bundle
  version is kernel-checked in the Draft namespace).
- Mass is exactly zero iff all directions are projectively collinear —
  one common beam (`fin_bundle_mass_zero_iff_common_direction`, **M**, Draft).

This is the precise form of "mass is trapped disagreeing light," and it is
the most solid thing the paper rests on: kernel-checked, axiom-audited, in
the trusted layer. **What is ours here is the formalization and the framing,
not the fact.** The identity is classical spinor-helicity kinematics (§2a;
Elvang–Huang, Dixon) — the invariant mass of a multi-massless system as its
total pairwise non-collinearity. Our contribution is (a) the kernel-checked
Plücker/Cauchy–Binet formalization and (b) the decision to make *this*
invariant the organizing quantity that every later channel is measured
against. It is also *only* kinematics — it says what mass *is* for a given
bundle, not what dynamics builds the bundle, and crucially not what its mass
*spectrum* is (a spectral quantity; §4 rail 3). The rest of the paper is
about the dynamics, held to a lower grade for exactly that reason.

---

## 4. The organizing spine: the mass-budget decomposition (**M** + **C**)

The dynamical object is the finite carrier Dirac operator on a finite
2-complex,

```text
D = sum_e c(alpha_e) nabla_e + Gamma phi ,
```

with a null covector soldering `c(alpha_e)` on each edge (a Clifford
coefficient, `c(alpha)^2 = 0`), a covariant transport `nabla_e`, and a
vertex "turn" term `Gamma phi`. The master identity of the whole program is that its Krein-adjoint square
decomposes into channels. The exact kernel-checked statement
(`carrier_krein_square`, **M**) is

```text
4 . D^#D  =  Q_A^#  +  Q_C^#  +  4 Q_T  +  4 E_#      (carrier_krein_square, M)

  Q_A^# = sum_{e,f} g(e,f) ( nabla_e^# nabla_f + nabla_f^# nabla_e )
  Q_C^# = sum_{e,f} ( gamma_e gamma_f - gamma_f gamma_e )
                    ( nabla_e^# nabla_f - nabla_f^# nabla_e )
  Q_T   = phi^2
  E_#   = sum_e gamma_e Gamma ( phi ( nabla_e^# - nabla_e ) )
```

Two honesty notes the paper's own discipline requires (both were drifts in
an earlier draft of this display): the aperture/closure blocks contract the
**Krein-adjoint** transports `nabla_e^#` against the bare ones — they are the
*starred* blocks `nabla_e^# nabla_f`, not `nabla_e nabla_f` — and the defect
enters with a **factor 4**, as `4 E_#`. Each summand is one physical channel;
the reader can carry this table through §§5–9 (operator shapes shown in the
self-adjoint gauge, where the blocks are bare — see the specialization below):

| channel | operator shape | force | how the invariant enters | positivity |
|---|---|---|---|---|
| `Q_A` | aperture / `{nabla, nabla}` | kinetic | Plücker mass of §3 (`det P`) | positive (§3) |
| `Q_C` | closure / `[gamma,gamma][nabla,nabla]` | gauge / QCD | chromomagnetic `sigma·F`, §6 | signed (§6/§8) |
| `4 Q_T` | turn / `phi^2` | Higgs / Yukawa | corner amplitude, §5 | turn-sign |
| `4 E_#` | Krein self-adjointness defect | — | cross term, §7 | vanishes in the self-adjoint gauge class |

**The hypotheses are the physics (and one of them freezes the Higgs).** The
master identity holds under an explicit hypothesis set, and three hypotheses
are load-bearing for how §§5–7 read: `hcl` (the Clifford/closure relation
`{gamma_e, gamma_f} = g(e,f)`), `hcomm` (soldering commutes with transport,
`gamma_e nabla_f = nabla_f gamma_e`), and `hCov` (the turn field is
covariantly constant, `nabla_e phi = phi nabla_e`). Two consequences must be
stated plainly, because the kernel sees them and the prose must not hide them:

- Under `hcomm` the soldering-gradient (gravity) channel of §7 is
  *identically absent* from this identity. So **no single kernel theorem
  contains all four forces**: the four-channel table is assembled from two
  theorems with different hypothesis sets — `carrier_krein_square` for
  aperture/closure/turn, and `weitzenbock_master_varying` (§7) for the
  soldering-gradient — and their union is a *program claim*, not one equation.
- Under `hCov` the turn block is `Q_T = phi^2` with `phi` frozen, so at **M**
  grade the "Higgs channel" is indistinguishable from an explicit Dirac mass
  term. The Higgs *reading* (§5) is a grade-C interpretation; the kernel sees
  a constant. This is the specific gap in the turn-channel name (§4a).

**Two specializations, both kernel-checked.** In the self-adjoint gauge class
(`nabla_e^# = nabla_e`) the cross term `E_#` vanishes and the starred blocks
become bare, so the master identity reduces to the three-slot square
`4 D^#D = Q_A + Q_C + 4 Q_T` (`carrier_krein_square_selfAdjoint`;
`carrier_square_assembly`, **M**) — this is the form §§5–6 use. Separately,
for *varying* soldering the gravity channel is a genuinely distinct object,
the soldering-gradient defect `E` of `weitzenbock_master_varying` (**M**,
§7) — this `E` (a `D^2`-defect measuring non-constancy of the soldering) and
the Krein cross-term `E_#` above are two different blocks; identifying them
is a conjecture (**C**), not a theorem.

**Unification is decomposition.** These are not four theories glued
together; they are four summands of one square. The claim the program
stakes is that *the* invariant — pairwise null disagreement — reappears in
each channel through a different canonical map.

*It is not a telescoping tautology.* A referee will ask whether `E_#` is
merely *defined* as the residual `4 D^#D − Q_A − Q_C − 4 Q_T`, which would
make the identity vacuous (an audit this run raised exactly this). It is
not: each of the four blocks has an **independent, canonical definition**,
visible in the display above — `Q_A^#` from the *anticommutator* (the metric
`g`), `Q_C^#` from the *commutator* (the Clifford bivector), `Q_T` from
`phi^2`, and `E_#` from the *specific* cross-term sum
`Σ_e γ_e Γ (φ(∇_e^# − ∇_e))`. The content of `carrier_krein_square` is that
these four independently-built operators *sum to* `4 D^#D` — a genuine
decomposition, not a renaming of a leftover. What remains open is not
non-vacuity but *forcing*:

*The honest weakness in this thesis, named as a conjecture.* Every
Dirac-type operator squares into a Lichnerowicz/Weitzenböck identity;
decomposition-of-the-square is a property of the *category*, not of our
carrier. So "unification is decomposition" is only a thesis if the
decomposition is *forced*. We therefore pre-register the missing rigidity
statement:

> **Conjecture (carrier rigidity, C).** The axioms — null soldering on a
> finite 2-complex, Krein structure, chiral grading, and covariantly
> constant turn field — determine the carrier operator and its four-block
> split *essentially uniquely* (up to the representation gauge already
> identified in §6). **Kill condition:** exhibit two axiom-satisfying
> carriers whose square-decompositions are not related by that gauge, or a
> fifth canonically-forced block. Until this is settled, §4's split is a
> *natural* decomposition, not a *forced* one, and the reader should hold
> "unification" to that lower standard.

**The budget corollary (M).** A one-line consequence of the assembly
(apply any linear expectation `ev` — the state functional `<psi, . psi>` —
and divide by `M^2 = 4 ev(D^2) != 0`): the channel shares

```text
b_A + b_C + b_T = 1 ,
```

is kernel-checked (`signed_budget_sum_one`, **M**), with a concrete
non-vacuous witness: a single-edge `2x2` carrier has closure share exactly
zero (`witness_QC_zero`, **M** — one edge, no closure) and, as an arithmetic
consequence of the kernel-pinned `sum = 1` and `D^2` value, shares
`(1/2, 0, 1/2)` (`witness_budget_sum_one`, **M**). *(The closure share of a
non-trivial state is generally nonzero: a color-singlet stretched over a
non-flat holonomy loop has `b_C` equal to a difference of Wilson loops — a
concrete rational `18`-dim quark–antiquark witness with `b_C = −32/223 ≠ 0`
and a hyperfine spin-flip splitting is designed and awaiting transcription;
Fable analysis this run.)* Three honesty rails, all load-bearing:

1. **The shares are signed.** We do *not* call them positive fractions.
   Whether a channel share is positive is the closure-positivity question
   of §6 — now **kernel-resolved on the explicit witness**: `b_C` is genuinely
   signed, and the `6×6` Clifford⊗color witness is *proved* to have balanced
   closure inertia `(2,2,0)` on its `V'/N` realization
   (`S1CCPhysicalSectorWitness.balanced_on_physical_sector`, **M**). So `b_C` can
   be negative on some states. This is not a defect: §8 explains why the physics
   of chiral symmetry breaking *requires* the closure channel to have negative
   directions.
2. **`b_C` is the chromomagnetic share, not "gluon energy."** The closure
   *channel* `Q_C` is linear in field strength (a `sigma·F` /
   chromomagnetic object); the `|F|^2` gluon *energy* density is a
   different object (the Wilson action, §6). Conflating them is a
   pre-registered error (§10).
3. **What the budget decomposes is a quadratic functional — and this run it
   was made a genuine mass on a concrete carrier.** This was the paper's most
   important caveat; the honest status is now much sharper (see below). In §3
   "mass" is `det P`, an invariant of a state's momentum
   (trusted, spectral). From §4 on, `M^2 := 4 ev(D^2)` is the expectation
   of an operator square in a *chosen* state against a *chosen* functional.
   The expectation of `D^2` is a genuine mass only at an eigenstate — on a
   Krein space, only at the ground state of a *positive* physical sector.
   So the four-channel budget honestly decomposes a quadratic functional,
   and it becomes a decomposition of a *mass* exactly when that functional
   is minimized on a *positive* sector. The keystone that performs this
   upgrade — a finite Rayleigh–Ritz theorem, `sector_ground_mass` — is now
   **kernel-checked (M, guard-pinned; proved this run by an Aristotle
   strengthening job)**: on a finite-dimensional sector with a *definite*
   inner product, an ordinary-self-adjoint `T = D^#D|_P` whose real form is
   bounded below by `c > 0` has its Rayleigh-quotient infimum attained *as a
   genuine eigenvalue that is `> 0`*. That is the exact statement that turns
   "a quadratic functional" into "a positive squared mass." The theorem is
   **conditional**, and this run *both* of its conditions were met on a
   concrete carrier — what were the program's two deepest open links are now
   substantially closed:

   - *The positive sector must exist — now instantiated (M).* The hypothesis
     is a *definite* (`J`-positive) sector. On the single-doublet witness none
     exists (the closure grading balances the aperture's Krein form too), but
     that was a small-model artifact: `T2_positive_mass` (**M**, guard-pinned)
     builds an explicit **two-edge Cl(4) carrier**, proves its sector form
     `M6 = 1 + B^H B` positive-definite, and *fires* the keystone to yield a
     genuine positive squared-mass eigenvalue. The positive sector is now a
     theorem, not a hope.
   - *The eigenvalue and `det P` — free case now PROVED (M).* The keystone
     yields the least eigenvalue of `D^#D`; the §3 mass is `det P`. In the
     **free case** these coincide, kernel-checked: `free_mass_operator_eq_plucker`
     (**M**) shows the free carrier mass operator `P · adjugate P = det P • 1
     = (Plücker mass) • 1`, so its least eigenvalue *is* the §3 mass (the finite
     Clifford mass-shell). For **interacting** carriers the identification fails
     by the `Delta` binding-defect candidate — the eigenvalue drops *below*
     `det P` by a closure-controlled, off-diagonal amount, which is the
     physically correct behaviour (binding is not additive), not a gap. Naming
     `Delta` a finite binding invariant is the remaining grade-**C** target
     (§10).

**A worked example — the whole paper on one object.** Everything above is
concrete on a single carrier, the one `T2_positive_mass` (**M**) is built from.
Take two null edges: the Clifford factor is `Cl(4)` (Hermitian gammas
`γ_1=σ_x⊗I, γ_2=σ_y⊗I, γ_3=σ_z⊗σ_x, γ_4=σ_z⊗σ_y`), the color factor `C^3`, so
the carrier space is `C^12`. The closure bivector is `ω = γ_1γ_2`, the Krein
metric `J = iγ_3γ_4 ⊗ I_3 = diag(-1,-1,-1,1,1,1,-1,-1,-1,1,1,1)` (inertia
`(6,6)`), the aperture `Q_A = I_4 ⊗ 2·I_3`, the closure `Q_C = ω ⊗ K` with `K`
the skew curvature. The assembled Krein form `J(Q_A+Q_C)` is block-diagonal;
its `J`-positive sector is the 6 coordinates `{3,4,5,9,10,11}`, and the
compressed sector form is `M6 = 1 + B^H B` with eigenvalues `{1,3,2}` on each
block — **positive-definite, least eigenvalue 1** (aperture dominance
`2 > 1`). So on this one object: §3's kinematic mass is the Plücker `det` of a
momentum bundle; §4's budget splits `4 D^#D` into `Q_A + Q_C + 4Q_T + 4E_#`;
§6's closure `Q_C` is the balanced (chromomagnetic) block; the positive
physical sector exists (the 6-dim one above); and §4's keystone fires there to
give a genuine positive squared mass of `1`. The reader who wants a single
picture to hold should hold this carrier.

**The mass phase diagram (aperture − closure).** The worked point `(λ,κ)=(2,1)`
is one point of a plane. Consider the `3×3` Hermitian block
`B(λ,κ) = !![λ, κi, 0; -κi, λ, 0; 0, 0, λ]` (aperture strength `λ`, closure
strength `κ`, both real), whose spectrum is `{λ − κ, λ, λ + κ}`. Its **complete
spectral theory is a kernel theorem** (grade **M**, guard-pinned;
`MassGapWitness`, `CarrierAxiomGuard`), and it organizes the whole coupling
plane: `det B = λ(λ² − κ²)` (`B_det`); the block is **positive-definite (massive)
iff `|κ| < λ`** (`B_posDef_iff`); it is **singular (massless) exactly on the
critical line `κ = ±λ`, for `λ > 0`** (`B_massless_iff_of_pos`; the `λ = 0`
edge case is handled separately — at `λ = 0` the block is singular for every `κ`);
and — the sharpest form — its **least eigenvalue is `λ − κ`**,
`IsLeast (range eigenvalues) (λ − κ)` for `0 ≤ κ ≤ λ` (`B_least_eigenvalue`). So
*the squared mass gap of `B` = aperture − closure* is a **theorem** (axiom-audited
`[propext, Classical.choice, Quot.sound]`): closure *subtracts* from mass and,
tuned to equal aperture, cancels it — a finite, exactly-solvable massless
critical line.

*What ties `B` to the carrier, and what does not (the honest grade split).* At
the fixed point `(2,1)` the tie is **kernel-checked**: the actual carrier
compression `M6 = PᴴHAC P` is *exactly* the block diagonal `B(2,1) ⊕ B(2,-1)`
(`M6_topBlock_eq_B`, `M6_botBlock_eq_B`, `M6_offBlock_eq_zero`, all **M**,
guard-pinned) — so the full sector form is a pair of closure-mirror blocks
`Msec(λ,κ) = B(λ,κ) ⊕ B(λ,-κ)` (isospectral, both covered by the two-sided
`B_posDef_iff`), and `T2_positive_mass` is its `(2,1)` corner *in the kernel*. The
gap of this *full* `6`-dimensional sector form is itself a theorem:
`SectorMassGap.Msec_least_eigenvalue` (**M**, guard-pinned) proves its least
eigenvalue is `λ − κ = aperture − |closure|` (and `Msec_posDef_iff`: massive iff
`|κ| < λ`) — so the mass gap holds of the actual sector, not just the `3×3`
half-block. What is **not** a
theorem is that the carrier reduces to this shape at *general* `(λ,κ)`: that
identification is **oracle-grade** (`carrier_spectrum_sim.py`, §9a), kernel-checked
only at `(2,1)`. So the phase diagram is: *`B`'s spectral theory is M for all
`(λ,κ)`; that `B` is the carrier's sector form is M at `(2,1)` and oracle-grade
off it.*

The physical target this shape is aimed at — a finite analogue of the Ji
decomposition of the proton mass — is grade **C**, and the two claims it
supports are *not* on the same footing, for a reason internal to QCD:

- **Weak claim (scheme-robust, the honest first goal):** the turn/Higgs
  share `|b_T|` is small — most of the mass is not Higgs-generated. The
  physical counterpart (~99% of the nucleon mass is not from the Higgs
  Yukawa) is renormalization-*scheme-independent* — it is the statement
  that the light-quark masses are small — so a finite model reproducing
  `|b_T| ≪ 1` is matching a robust fact `[import]` (Yang et al.).
- **Strong claim (scheme-dependent, demoted):** "closure (chromomagnetic)
  is the single largest share." The individual terms of the Ji
  decomposition — quark energy, gluon energy, quark mass, trace anomaly —
  are separately **renormalization-scheme and scale dependent**; their
  relative sizes shift with the scheme, and only the *total* is invariant.
  So a bare inequality `b_C > b_A` in this finite model, even if proved,
  cannot be matched to "the chromomagnetic term dominates the proton mass"
  without fixing a scheme correspondence the model does not yet have. We
  therefore demote the strong claim to a **scheme-relative** statement and
  do not present term dominance as a prediction. This is a genuine
  limitation, not a temporary gap: term-by-term matching requires a
  continuum renormalization dictionary (§9, §10) the model lacks.

### 4a. What the channel names claim, and what they do not (grade **C**)

The four channel names — *aperture*, *closure*, *turn*, *soldering*, mapped
to *kinetic/QCD/Higgs/geometric* mass — do real organizing work, and they
are also the paper's largest reservoir of unearned suggestion. State the
boundary once, plainly, so no later sentence smuggles it back:

1. **What is a theorem (M).** The operator square `4 D^#D` splits into four
   named Krein blocks `Q_A + Q_C + 4Q_T + E_#` (§4, `carrier_square_assembly`).
   That the split *exists*, that the blocks have the stated Krein
   symmetries, and that their expectations sum to one budget — these are
   kernel-checked. The *algebra* of the decomposition is not in question.

2. **What is a named analogy (C).** That block `Q_A` *is* the QCD kinetic
   term, `Q_C` *is* the chromomagnetic/gluonic term, `Q_T` *is* the Higgs
   Yukawa, and `E_#` *is* the geometric/gravitational mass — these are
   **structural analogies**, justified by shape (each block is the finite
   image of the operator that carries that physics: a covariant Laplacian,
   a curvature/commutator `σ·F`, a scalar-coupling term, a soldering
   defect), **not** by any theorem that reduces the finite block to the
   continuum object in a limit. There is **no continuum reduction** in this
   paper. The names are load-bearing *hypotheses about a correspondence*,
   pre-registered so they can be falsified, not established identifications.

3. **The kill condition for the whole naming scheme.** If the finite
   blocks' expectations, evaluated on a family of complexes approaching a
   known continuum gauge theory, do *not* converge to the corresponding Ji
   terms (up to the scheme caveat above), the correspondence is wrong and
   the channel names should be retired to "block 1..4." That test is not
   run here; it is the §9/§10 continuum program. The checkerboard continuum
   limit (§2a) is the one sub-case where a genuine reduction exists in the
   literature, which is why we flag it as the most promising bridge.

Read §§5–8 with this in force: every time the text says "the QCD channel"
or "the Higgs channel," it means "the block whose *shape* is that of the
QCD/Higgs term, conjecturally its finite image" — grade **C** — never a
proved identity.

---

## 5. Turn mass: the Higgs-shaped channel (**M** + a reported kill)

The turn block `Q_T = phi^2` is where mass enters at a corner. The
mechanism, in the program's language: a corner converts a left-handed
light-mover into a right-handed one; the two carry different weak charge;
the corner must therefore exchange weak charge with a background
condensate; that condensate is the Higgs. The corner amplitude *is* the
mass. This is a **MEMO**-grade reading, resting on the kinematic corner
identity (`onshell_wedge_normSq_eq_coin_sq`, **M**, kernel-checked in
`GateI1/MassCoinBridge.lean` — a supporting identity, not guard-pinned;
§11) and the Standard-Model strand bookkeeping (Q04, **MEMO**).

**A reported kill (this is the honest heart of the section).** The program
attempted to derive the *value* of the charged-lepton mass ratios — the
Koide relation `Q = 2/3` — from corner geometry, via a soldering
coefficient `kappa` that would have to equal 1. A pre-registered numerical
probe measured it: `kappa = 3/2`, not 1, predicting `Q = 5/9` against the
observed `2/3`, and the carrier reduction does not even produce the
required uniform-diagonal form. **The tetrahedral-corner Koide route is
dead** (pre-registered probe P1; full analysis in the program's
soldering-constant memo). What survives is the
equipartition trace identity behind the Koide *combination* (pure algebra,
unaffected) and a sharper open question — see §8. Any future mass-value
route must additionally clear the Sumino bar `[import]`: a real Koide
mechanism must survive QED running, which this route never reached. The
honest status of mass *values* in this program is therefore: **no live
prediction**; ratios, not absolute scales, are the only admissible targets
(§10).

---

## 6. Closure mass: the QCD-shaped channel (**M** + the central crux, resolved)

Most visible mass is QCD binding energy. In this program it lives in the
closure channel, and the closure channel is where the program is,
surprisingly, furthest along outside pure kinematics.

**The Wilson action is a squared closure defect (M).** Before any carrier
identification, the standard lattice gauge action is *exactly* the squared
norm of the failure of transport to close around a face: for a face
holonomy `U`,

```text
Tr((1 - U)^dag (1 - U)) = 2N - 2 Re Tr U ,
```

so the Wilson plaquette weight `N - Re Tr U` is half the Hilbert-Schmidt
square of the closure defect `1 - U`
(`wilson_plaquette_eq_half_closure_defect`, **M**;
`closure_defect_trace_eq`, **M**). QCD's action and the program's closure
channel are the same object at the source. And this squared defect *is
positive energy*: for the linearized connection its leading value is the
non-negative Hilbert-Schmidt norm `-Tr(A²) = ‖A‖² = |F|²` at leading order
(`leading_closure_energy_nonneg`, **M**), zero exactly at flatness. The
static-pair potential then reads as the transfer-time cost of excess areal
closure defect (**C**, Amendment A2). (This `|F|²` *defect-gram* energy is
distinct from the chromomagnetic `Q_C` channel — §4 rail 2.)

**The strong-coupling pillars are kernel-checked (M).** On concrete finite
lattices: the Wilson-loop area law (`tyAreaLaw_slab_exp`), slab reflection
positivity (`wilsonSlabConnected_reflectionPositive`), an OS-reconstructed
spectral gap (`osSpectralGap_pos`), and exponential clustering
(`slab_exponential_clustering`) — finite strong-coupling analogues of two
hard pillars often associated with confinement and mass-gap arguments. The one
remaining hole in the
gap chain is a finite forest-counting injection, now diagnosed (this
month, audit memo, **MEMO**) as a *malposed statement* rather than a hard
proof: the total-block
permutation count collapses under the root-pinning constraint, so the
structured-partition route is the only viable one
(`PolymerKPConclusion.lean`; strong-coupling cluster-expansion audit).

**The closure channel is an exact Krein square — and this relocates the
crux (M + MEMO).** The nonabelian closure block factors exactly:

```text
Q_C = L^# L ,   L = c(alpha_1) (x) 1 + c(alpha_2) (x) (-K/2),
      K = [nabla_1, nabla_2] ,
```

with the abstract square identity kernel-checked (`null_soldered_square`,
`closure_current_square`, **M** — a group-free ring identity with explicit
hypotheses, which is *stronger* in that direction); the group-independence
(any compact group) and the GL-torsor classification of representatives are
**MEMO**, oracle-verified across SU(2) and SU(3)). But a Krein square carries no
positivity by itself — null Clifford coefficients are isotropic, so the
square has no positive-definite diagonal. Therefore:

> **The central crux, conditionally resolved as a structured no-go
> (M engine + MEMO physical instantiation).**
> Positivity of the closure channel is not a full-space fact and never
> could be; it can hold only on the physical (Gauss-law) sector `V'/N`.
> If the MEMO physical-sector identification and descent hypotheses are
> instantiated as stated, closure is **not** positive there: it is balanced
> on the checked `6x6` witness realization of `V'/N`
> (`sig = (2,2,0)`, oracle).
> The mechanism is a grading anticonjugation: the closure bivector
> `b = sigma_z (x) 1` satisfies `b^{-1}(J Q_C) b = -(J Q_C)` and preserves
> every gauge-defined constraint sector (gauge acts on the color factor
> alone, commuting with `b`), and a Hermitian form whose characteristic
> polynomial is invariant under negation has equal positive and negative
> eigenvalue counts. The kernel engine now has both rungs: anticonjugation
> forces every odd power traceless (`anticonj_odd_pow_trace_zero`, **M**),
> while `anticonj_charpoly_eq` plus
> `hermitian_balanced_count_of_neg_charpoly` prove the finite Hermitian
> count theorem (**M**). The half-constraint rigidity that forces the
> single-covector Gauss charge is also kernel-checked
> (`half_constraint_rigidity`, **M**); and the actual `(2,2,0)` inertia is now
> **kernel-checked** on the explicit `6x6` Clifford⊗color witness
> (`S1CCPhysicalSectorWitness.balanced_on_physical_sector`, **M**, self-guarded) —
> no longer only a numeric probe. So `Q_C` is honestly a *signed* chromomagnetic
> channel; any surviving physical positivity would require a `J`-positive
> sector not balanced by the same grading. What used to stay MEMO — the concrete
> `V'` construction from the carrier Gauss covectors (`Q_G = c₁⊗G`), the descent
> data (`[G,K]=0`, `Q_G²=0`, `N ⊆ radical`, `b(J Q_C)b = −J Q_C`), and the
> identification of the restricted representative `B = (J Q_C)|V'/N` (a literal
> `submatrix` on the coordinate-axis coset reps) to which the finite count theorem
> applies — is **now all kernel-checked** in that witness. What remains MEMO is
> only the claim that *every* scalar-metric physical Gauss sector reduces to this
> witness shape (the general representative), not the witness itself.

**The adversarial check the resolution turns on — run, and it fails on the
witness (a pre-registered probe finding, MEMO).** The escape route —
"physical positivity comes from the `J`-definite complement" — silently
requires that the closure bivector `b = sigma_z (x) 1` anticonjugates *only*
the closure block, and does **not** also anticonjugate `J(Q_A + 4 Q_T)`.
Prompted by an external review (Fable call-04), we checked this on the `6x6`
witness and found the escape route **does not survive** there
(`probe_s1cc_aperture_grading.py`): `b` negates `J Q_A` and `J Q_T` **as well
as** `J Q_C`, so the *whole* form `J(Q_A + Q_C + 4 Q_T)` is congruent to its
negative and is balanced — inertia `(2,2,0)` — on the `6x6` witness
realization of the physical sector `V'/N` (probe finding, MEMO).
The aperture does **not** rescue positivity, because the object that must be
positive is the *Krein* form `J Q_A`, and it is balanced even though `Q_A`
itself is positive-definite as a matrix.

The reason is structural, not an artifact of the toy: to balance closure by
`b` one needs `J` to anticommute with `b` (so that `J Q_C` is `b`-odd); but
the aperture `Q_A = {gamma, gamma}(...) = g . (transports)` is Clifford-*scalar*
(the anticommutator is central by the closure relation `hcl`), hence
`b`-even, hence `J Q_A` is `b`-odd — negated by the *same* grading. The turn
`Q_T = phi^2` is `b`-even for the same reason. So **for any scalar-metric
carrier with a `b`-invariant physical sector, the grading that balances
closure balances the aperture and turn too.** What this does and does not
touch: the no-go half — "`Q_C` is a balanced Krein square" — is unaffected;
what is obstructed is the *surviving positivity* half (crux #1 below, §4 rail
3, §10 crux 0). A rescue must break one of three premises — give `Q_A`
genuine `sigma_z`-*odd* Clifford content (a **larger** Clifford algebra where
the closure bivector and the chirality are *distinct* gradings), or use a `J`
not anticommuting with `b` (reopening S1-CC), or a non-`b`-invariant sector
(likewise). The live route is the first, and it is now **kernel-checked**, not
merely numeric: `T2_positive_mass` (**M**, guard-pinned) builds an explicit
*two-edge* Cl(4) carrier whose grading `b` anticommutes the closure bivector
(balancing `Q_C`) while *commuting* with the Krein metric `J_s` (fixing `Q_A`)
— the pair the 2-dimensional single-doublet could not provide — proves its
6-dimensional `J`-positive sector form is **positive-definite** (via the exact
Gram decomposition `M6 = 1 + B^H B`), and *fires* `sector_ground_mass` to produce
a genuine positive squared mass. So the aperture-balancing obstruction was a
small-model artifact, and the positive-sector escape the whole §6 program needed
is now a theorem on a concrete multi-edge carrier — the numeric escape
(`probe_multiedge_positive_sector.py`) transcribed and closed. Full analysis:
`S1CC_APERTURE_GRADING_FINDING.md` (the obstruction) and
`T2_MULTIEDGE_ESCAPE_FINDING.md` (the escape). (Technical note preserved: the kernel rung
proves trace identities via a *similarity*; the inertia conclusion needs `b`
to act by *congruence*, which holds because `b = sigma_z (x) 1` is
Hermitian-unitary — this belongs in the mechanism's hypotheses, since a
generic invertible `b` gives symmetric traces without equal inertia.)

A second correction the resolution forces: the gate as originally posed
asked whether a torsor *representative* `L_A` descends to `V'`; it does
not (**MEMO**), but that was the wrong question — only the *square* `Q_C`
needs to descend, and it does iff the finite Ward condition
`K(ker G) subseteq ker G` holds. The existing finite Kugo–Ojima witnesses
frame the surviving question: the nonvacuous positive sector on `(2,1)`
(`nonvacuous_positive_sector`, **M**) and the indefinite no-go on `(1,2)`
(`nondegenerate_but_indefinite_no_go`, **M**) show the decision quantity is
the inertia surplus `p - q` on the doublet-free complement — now with a
mechanism. Scope, stated plainly: everything here is finite and
strong-coupling; the continuum Yang–Mills mass gap is the Clay problem and
is **not claimed** (§10).

---

## 7. Soldering mass: the gravity-shaped channel (**M** + **C**)

The soldering-gradient block `E` is the gravity-shaped channel: it
measures how the null soldering fails to be covariantly constant, via the
frame commutator `D(e,f) = nabla_e gamma_f - gamma_f nabla_e`. The finite
"geometric trinity" split is now kernel-checked:

```text
2 E = Contract(T) + Contract(S)
```

(`eslot_torsion_solder_split`, **M**, choice-free), with `T` the
antisymmetrized soldering difference (torsion-shaped) and `S` a symmetric
remainder (non-metricity-shaped). And the split is *non-trivial*: the
program's earlier conjecture that `E` is *pure* torsion is refuted by an
explicit `2x2` witness where the symmetric contraction does not vanish
(`eslot_not_pure_torsion_witness`, **M**; §10). So at finite algebraic
level the gravity channel is a torsion-plus-non-metricity mix, not pure
teleparallel — the corrected statement after the pure-torsion kill.

What remains conjectural (**C**) is the *geometric* reading: identifying
`T` and `S` with a discrete contorsion and non-metricity carrying the
right transformation law, with the discrete teleparallel /
symmetric-teleparallel literature `[import]` (Aldrovandi–Pereira,
*Teleparallel Gravity*, and Regge-adjacent work) as the anchor. This is still the least-developed
channel physically, and the honest content is mostly the boundary, per the
Malament split: causal order supplies the light-cone structure for free,
and the decorations owe exactly the scale. But the finite *algebra* of the
split is a theorem, not a hope.

---

## 8. Protected masslessness: topology forbids mass (**M**)

Some modes cannot acquire mass, and this is a theorem, not a tuning. The
finite McKean–Singer index family shows that for a rank-symmetric carrier
the chiral index equals the graded dimension
(`chiralIndex_eq_graded_dimension`, **M**), and an unbalanced count forces
an exact massless mode immune to every potential and transport
(`exists_protected_massless_mode`, **M**). Masslessness of the chiral
surplus is topological — the knot of Part I, made precise.

**A new protection mechanism, found this month (M + C).** A determinant-
parity probe redirected a stalled line of work: the protected zero modes of
the decorated transport cycle are *not* forced by cyclic symmetry (that
reading was falsified — abstract symmetric data is generically unpinned),
but by a **chiral** symmetry — an involution `Gamma` with
`Gamma W Gamma = W^dagger`, which is exactly the edge-orientation-reversal
grading that also gives the program's Ginsparg–Wilson structure. Its
kernel-checked core: a unitary carrying such an involution has determinant
`+-1` (`chiral_det_eq_pm_one`, **M**); by the standard conjugate-pairing of
unitary spectra (**T**, transcription pending) that sign pins the parity of
the `-1`-eigenvalue multiplicity (the Lean file states the determinant fact;
the multiplicity reading is prose, per its own docstring). The full
amplitude-independent *double* pinning (both `±1` at every hop strength) is
**not** a global winding invariant — that index was measured to vanish
here. It is an equivariant *reflection-sectored* index: `W` commutes with a
reflection `R` (leg-reversal ∘ orientation-swap), and the two `R`-sectors
carry opposite chiral indices that cancel globally but each pin one `±1`
mode. The sector index is a Lefschetz fixed-point count `±¼ Tr(ΓR)` that
does not involve `W` — hence the `|t|`-independence (grade **C** /
**M**-target, with a rational fixture and a spectral-theorem-free pinning
theorem in hand; Fable analysis this run). The resulting spectrum on the
small cycle is neutrino-shaped (one exactly massless mode; oracle, **C**) —
which is where the mass-value question, having failed for charged leptons
(§5), honestly relocates.

**Why indefiniteness is a feature, not a bug.** The closure channel's
global indefiniteness (§6) is *required* here: chiral symmetry breaking
needs the curvature term to pull eigenvalues toward zero against the
positive kinetic part, so a positive-definite closure channel would have
killed this mechanism outright. §6 and §8 are coupled in the right
direction: the same sign structure that blocks naive closure positivity is
what makes protected and near-protected light modes possible.

---

## 9. Dynamics: mass generation under coarse-graining (**M**)

The kinematic theorem (§3) says what mass *is*; this section's theorem says
coarse-graining *makes* it, from the same invariant. One decimation
(Schur-complement) step on a null chain — integrating out a hidden site —
converts square-zero (null) edge terms into a non-null effective term. The
abstract law is

```text
(a b)^2 = k . (a b)   for   a^2 = b^2 = 0,  a b + b a = k . 1
```

(`null_pair_prod_sq_eq_pairing_smul`, **M**): the effective term fails to
be nilpotent exactly when the pairing `k` is nonzero — and for null
directions, nonzero pairing means non-collinear, i.e. *disagreeing*. On the
concrete three-site chain the induced edge is a nonzero idempotent
(`effective_edge_not_nilpotent`, **M**), where none existed before
blocking. The negative control is what makes this a statement about mass:
collinear couplings produce exactly zero effective coupling
(`collinear_schurComplement_eq_zero`, **M**) — nullity survives blocking
precisely on the massless configurations.

So the program's thesis is two-sided, and both sides are kernel-checked:
*kinematically* mass is pairwise null disagreement (§3); *dynamically*,
coarse-graining converts that same disagreement into an effective mass
term, and converts nothing when there is no disagreement.

**The coupling is a propagator element (M).** For a general (non-scalar)
invertible hidden block, the effective edge term is
`c(l) Minv c(n) = (Minv)_{11} . (c(l) c(n))`
(`nullL_mul_mid_mul_nullN`, **M**): the generated coupling is exactly the
matrix element of the hidden-block resolvent between the two null
light-cone directions, and it is non-nilpotent iff that element is nonzero
(`mid_effective_not_nilpotent`, **M**). This is the expected physics — the
effective coupling between two null directions is their propagator
overlap — and it recovers the scalar case as `Minv = mu⁻¹ . 1`.

Claim boundary: one finite decimation step — no renormalization-group
flow, no fixed point, no continuum. The bridge from this step to
constituent-mass generation was conjectured (Amendment A4) as "blocking a
closure-disordered background increases the finite near-zero count `N_m`
of §6". A pre-registered probe this run **refutes that at the finite
random-disorder level**: both generic and chiral-preserving random
closure disorder *decrease* `N_m` (they spread the spectrum away from
zero). So the Banks–Casher accumulation that would signal a condensate is
*not* produced by finite random curvature; it needs a specific coherent /
topological low-mode structure or a thermodynamic limit. The §9→§6 bridge
is therefore a documented kill at this level, and the honest open question
is sharper: *which* structured (not random) closure backgrounds accumulate
low modes. Grade **C**, with the naive version now closed.

**On the level of quantization (a boundary a reviewer will ask about).**
Everything in this paper is **first-quantized**: `D` is a one-particle
operator on a finite-dimensional space, "mass" is a spectral/kinematic
invariant of *states*, and the budget decomposes an expectation in a chosen
one-particle state. There is no Fock space, no creation/annihilation
algebra, no path integral, and therefore no particle number, no vacuum
condensate as an operator statement, and no second-quantized mass gap *of the
interacting many-body system*. (This run did land the finite **free**
second-quantized gap — `FockMassGap.secondQuantized_massGap` (**M**,
self-guarded): on the fermionic occupation Fock space, the free many-body
Hamiltonian `dΓ(B)` has ground energy `0` and first excited energy exactly the
one-particle gap `λ − κ`, with the free two-body energy exactly the *sum of
constituents* (`fockEnergy_twoParticle`) and the binding defect `Δ = −κ` as the
seed (`twoBody_bound_below_threshold`). What stays open is the *interacting*
hadron mass — a genuine bound state below the constituent threshold — which
needs an interaction term on `Λ²` not derived here.) This is deliberate and it
is also a real limitation:

- Several physical notions the words invite — a *chiral condensate*
  `⟨ψ̄ψ⟩`, the *number* of light hadrons, spontaneous symmetry breaking as a
  vacuum property — are genuinely second-quantized and are **out of scope**
  of every theorem here. When §6/§9 speak of Banks–Casher accumulation, the
  kernel content is a statement about the *one-particle* near-zero
  eigenvalue count, which is the finite shadow of the condensate, not the
  condensate itself.
- Promoting `D` to a field operator (a fermion field on the finite complex
  with a functional integral over the closure/turn decorations) is the
  natural next layer, and it is where a genuine hadron mass — an eigenvalue
  of a *many-body* Hamiltonian — would have to live. Nothing here forbids
  that construction; it is simply not attempted, and no claim in this paper
  should be read as a many-body or field-theoretic result. Grade **C**,
  and explicitly a future program, not a gap in a proof. We note that the
  second-quantized layer we defer — creation/annihilation operators, normal
  and time ordering, Wick's theorem — is *itself* already machine-verified in
  the PhysLean library (`Physlib/QFT/PerturbationTheory`, with `wicks_theorem`
  kernel-checked) `[import]`; that is the concrete peer framework a future
  many-body extension of this carrier would build on, not reinvent.

### 9a. A finite dynamics layer: action, evolution, RG, ensemble (**M** scaffolds)

The §3 identity and the §4 budget are *static*. This run added a finite
**dynamics** layer — kernel-checked as abstract scaffolds, plus validated
numerical simulations built on them. The honest reading is uniform: **each
theorem is a general finite fact (M); the physics is its instantiation on the
carrier, which is the pending link** — the same "the machine is built, the model
that satisfies its hypothesis is next" pattern as the keystone (§4 rail 3).

- **D1 — action and equation of motion.** `multiplierStationary_iff_eom`
  (`FiniteCarrierAction`, **M**): a finite action's variational stationarity is
  equivalent to the equation of motion `D psi = 0`. The carrier's dynamics is
  *derived* from an action, not posited. (Scaffold: the abstract Dirichlet /
  multiplier variation; a specific carrier Lagrangian is the physics.)
- **D2/D3 — evolution and conservation.** `norm_conserved_orbit`,
  `energy_conserved_orbit` (`FiniteUnitaryEvolution`, **M**) prove that *any
  sector isometry* conserves norm and energy along its orbit — generic finite
  functional analysis (`LinearIsometryEquiv`). This was previously flagged with
  the honest caveat that the *instantiation* (the T2 carrier's step actually
  being such an isometry) was open. **That instantiation is now closed** and
  kernel-checked (`CarrierUnitaryFlow`, **M**, guard-pinned): the sector form is
  Hermitian (the mass-gap block `B`), so the flow it generates `exp(−i t H)` is
  **unitary** (`hermitian_flow_mem_unitaryGroup` / `B_flow_unitary`) and induces a
  genuine `LinearIsometryEquiv` on the sector (`hermitian_flow_isometry`). Wired
  through the generic scaffold, this gives single concrete theorems —
  `carrier_orbit_norm_conserved` and `carrier_orbit_energy_conserved` (both **M**,
  guard-pinned): the discrete time-evolution *orbit* of the carrier block flow
  conserves the sector norm and (for commuting observables) energy. So
  `FiniteUnitaryEvolution` fires on the block flow. Stated exactly (per the
  flagship audit): this is Euclidean-unitarity of `exp(−i t H)` for Hermitian `H`,
  instantiated at the mass block — a generic fact with `H := B`, *not* yet the
  carrier's Krein evolution.
  **Two grade caveats, stated plainly.** *(i) The generator is a posit (**C**).*
  `B = Q_A + Q_C` is the compressed squared-mass / energy *form*, not a Hamiltonian
  *derived* from the D1 action (D1 gives the constraint `Dψ = 0`, not a Schrödinger
  equation). Taking the sector mass form as the generator of a one-parameter flow
  is a canonical modeling choice (Stueckelberg-style proper-time evolution),
  defensible but chosen; what is **M** is the unitarity/isometry and orbit
  conservation of `exp(−i t H)` for Hermitian `H`; that this flow *is* the
  carrier's physical time evolution is grade **C**. *(ii) Carrier tie at `(2,1)`.*
  the flow is of the *block* `B(λ,κ)` for all `(λ,κ)`, but `B` is the carrier's
  sector form kernel-checked only at `(2,1)` (§4), oracle-grade off it. (First
  -quantized throughout; Krein-unitary ≠ norm-unitary was the earlier worry, and
  the resolution is now **kernel-certified**: `sector_krein_form_eq_one` (**M**,
  guard-pinned) proves `Pisoᴴ J Piso = 1`, i.e. the indefinite Krein metric `J`
  compressed to the physical sector *is* the identity — the sector carries the
  ordinary positive inner product, so norm-unitary evolution there is honest, not
  a Krein-indefinite artifact.)
- **D4 — renormalization flow.** `invariant_orbit`,
  `observable_antitone_orbit` (`FiniteRGFlow`, **M**, axiom-free): orbit
  invariants and monotones under an iterated step. The intended step is the §9
  Schur decimation (`RGSchurMassWitness`); its instantiation is the physics.
- **D5 — canonical ensemble.** `partitionFunction_pos`,
  `sum_probability_eq_one`, `probability_pos` (`FiniteCanonicalEnsemble`, **M**):
  a finite canonical ensemble over any spectrum; applied to the carrier sector
  spectrum it gives the thermodynamics (and the §9 condensate's finite handle).

**Lean-informed simulations (oracle grade, quarantined from the M core).** Four
Python simulators, each output *validated against a landed M-identity* (the Lean
is the simulation's spec and validation oracle):

- `carrier_spectrum_sim.py` — the physical-sector **mass phase diagram**: the
  squared mass gap is **aperture − closure**, with a **massless critical line at
  closure = aperture**. The *block* spectral theory the diagram rests on is now a
  kernel theorem (`MassGapWitness`, §4, `B_least_eigenvalue` / `B_posDef_iff`,
  **M**, guard-pinned), and the tie to the carrier is kernel-checked at `(2,1)`
  (`M6_topBlock_eq_B`); so at that point the simulator *cross-checks a proved
  result*. The general-coupling reduction the diagram sweeps is oracle-grade
  (also validated against `T2_positive_mass`, `signed_budget_sum_one`,
  `posDef_iff_det_pos`).
- `carrier_evolution_sim.py` — unitary Hamiltonian flow with a positive mass
  gap, survival-amplitude **mass-spectrum resolution**, a unitary
  **quantum-walk transfer operator** (whose continuum limit yields a Dirac-type
  flow under the standard QW→Dirac conditions — a 4-dimensional coin carrying
  the gamma matrices, with parity and discrete-rotation symmetry; Mlodinow–Brun,
  §2a), and antisymmetrized **2-fermion Slater scattering amplitudes** (validated
  against `FiniteUnitaryEvolution`, `T2`).
- `carrier_rgflow_sim.py` — Schur **RG flow** (`k_eff = t^2/mu`, invariant
  `mu·k_eff`), the **canonical ensemble** (`Z`, `F = <E> − T S`, ground
  dominance), and a **condensate** near-zero-mode fraction rising to the
  critical line — the finite Banks–Casher shadow (validated against
  `FiniteRGFlow`, `FiniteCanonicalEnsemble`, `RGSchurMassWitness`).
- `carrier_scattering_sim.py` — a finite **S-matrix**: a 1+1D Dirac quantum walk
  (the checkerboard asset) with a localized **mass barrier**, giving transmission
  and reflection `T(m₀), R(m₀)`. Outputs: the S-matrix is **unitary**
  (`|T| + |R| = 1` after the packet clears, from the exact norm conservation),
  transmission **falls monotonically with the barrier mass** and `→ 1` as
  `m₀ → 0` (a *massless* region is transparent — the critical line κ=λ as a
  scattering statement), and it is **reciprocal** (`T_left = T_right` to `<10⁻³`).
  The faithful regime is small coin angle `θ = m₀·dt < π/2` (the Mlodinow–Brun
  continuum conditions, §2a); the mass a packet scatters off *is* the
  aperture−closure gap. Validated against `FiniteUnitaryEvolution` and the T2
  spectrum.

---

## 10. Boundaries, and the things we have disproved

**The permanent boundary.** No continuum limit is claimed. No physical mass
scale (dimensional transmutation) is claimed. Nothing Clay-adjacent is
claimed. The only sanctioned limit language is the refinement-ladder
(quotient-then-limit) discipline, and the only admissible mass targets are
dimensionless ratios protected by finite structure — never absolute MeV
values (finding 9; NuFIT-6.0 `[import]` for the one neutrino ratio that is
a legitimate finite target).

**The kills — reported with the prominence of the theorems.** A reader
familiar with the field will expect several natural ideas; here is why each
is dead, so no one re-derives them:

- **Koide from tetrahedral corner geometry** — killed by measurement
  (`kappa = 3/2`, probe P1). The equipartition identity survives as algebra
  (§5).
- **"`Tr E` = discrete torsion"** — killed by probe; replaced by the
  trinity-split target (§7).
- **"`Q_C` = site-diagonal defect Gram"** — killed structurally (grading:
  `Q_C` is purely off-diagonal, orthogonal to every site-local Gram). The
  defect Gram is a real object — it is the Wilson action — just not this
  operator (§6).
- **"`Q_C` is the positive gluon-energy share"** — killed by the
  chromomagnetic distinction: `Q_C` is linear in `F` (hyperfine-shaped);
  the `|F|^2` energy is the defect Gram (§4, §6).
- **Cyclic symmetry forces the protected zero mode** — falsified; the
  correct mechanism is chiral, not cyclic (§8).
- **Retardedness alone deletes fermion doublers** — killed by a
  determinant-level obstruction; one-sided Ginsparg–Wilson inversion is
  false nonabelian (explicit counterexample); the palindromic transfer
  ordering is the correct convention.
- **Spectral-measure language before positivity** — embargoed
  program-wide; finite eigenvalue-*count* identities are the sanctioned
  form (§6's Banks–Casher-type finite count, `banks_casher_count`, **M**).
- **"Random closure disorder increases the near-zero count `N_m`"** (the
  naive §9→§6 constituent-mass bridge, Amendment A4) — killed by a
  pre-registered probe: finite random curvature, chiral or generic,
  *decreases* `N_m` by spreading the spectrum. Condensate accumulation
  needs structured, not random, low-mode content (§9).
- **"The aperture rescues positivity on the S1-CC witness's physical
  sector"** — killed by a pre-registered probe this run
  (`probe_s1cc_aperture_grading.py`), prompted by an external review. The
  closure grading `b` that balances `Q_C` also balances `Q_A` and `Q_T` (the
  aperture is Clifford-scalar, hence `b`-even, hence its Krein form `J Q_A` is
  `b`-negated), so the *whole* operator `J(Q_A+Q_C+4Q_T)` is balanced
  `(2,2,0)` on the checked `6x6` witness realization of `V'/N`. The escape
  route of §6 has no witness; a rescuing model must give the aperture genuine
  `sigma_z`-odd Clifford content — a larger
  Clifford algebra with the closure bivector and chirality as distinct
  gradings (a multi-edge carrier). This is the sharpest open problem, not a
  refutation of the balanced-closure no-go itself (§6).

**The open cruxes, ranked** (after this run's progress). The former #1 —
physical-sector closure positivity (S1-CC) — is now **kernel-resolved on the
explicit witness** (§6). Not only is the finite anticonjugation + Hermitian-count
*engine* kernel-checked (**M**); the physical `J Q_C|V'/N` **instantiation is now
also kernel-checked** on the explicit `6×6` Clifford⊗color carrier
(`S1CCPhysicalSectorWitness`, **M**, self-guarded): with the Gauss projector
`Q_G = c₁⊗G`, the coset representatives of `V'/N` are coordinate axes (so the
compression is a literal `submatrix`), and the induced closure form `B = J Q_C|V'/N`
is proved to have inertia exactly **`(2,2,0)`** (`balanced_on_physical_sector`) and
to be genuinely indefinite (`JQc_not_positive_on_sector`) — the balanced closure
no-go, with the descent data (`[G,K]=0`, `Q_G²=0`, `N ⊆ radical`,
`b(JQc)b = −JQc`) all kernel-checked. So on the explicit witness the no-go is a
**theorem**, not MEMO. What remains oracle/MEMO is only the claim that *every*
physical Gauss sector of the scalar-metric class reduces to this witness shape
(the general representative), not the witness itself. What remains, ranked: **(0) The Rayleigh–Ritz
keystone `sector_ground_mass` is *proved* (M, guard-pinned; §4 rail 3), and its
positive-sector hypothesis is now *instantiated in the kernel*.** The two links
this was conditional on have both moved this run:

- **(0a) — RESOLVED.** A positive sector must *exist*; it now does, kernel
  -checked. `T2_positive_mass` (**M**, guard-pinned) builds the explicit
  two-edge Cl(4) carrier, proves its sector form `M6 = 1 + B^H B` is
  positive-definite (aperture dominance), and *fires* `sector_ground_mass` to
  produce a genuine positive squared-mass eigenvalue. What was a numeric escape
  (`probe_multiedge_positive_sector.py`, §6) is now a theorem: the aperture
  -balancing obstruction was a single-doublet artifact, and a concrete
  multi-edge model carries a real positive mass. The former #1 construction is
  done.
- **(0b) — the §3↔§4 bridge, now split, free half PROVED.** *(0b-a, free
  case, done):* `free_mass_operator_eq_plucker` (**M**) — the free carrier mass
  operator `P · adjugate P` equals `det P • 1 = (Plücker mass) • 1`, so its least
  eigenvalue *is* the §3 kinematic mass. In the free case "the operator mass is
  the kinematic mass" is now a theorem (the finite Clifford mass-shell). *(0b-b,
  interacting, now a block-level theorem):* for interacting carriers the bridge
  fails by a `Delta` binding defect — the least eigenvalue is *below* `det P` by a
  closure-controlled, off-diagonal amount. This is no longer only a candidate: on
  the sector mass block `B(λ,κ)` it is **kernel-proved** that
  `Δ_block(λ,κ) = −κ` (`BindingDefect.blockBindingDefect_eq_neg_kappa`, **M**,
  guard-pinned) — closure lowers the ground mass by *exactly its strength*. It is
  **negative** (binding sign, not additive constituent mass;
  `blockBindingDefect_nonpos`), **closure-controlled** with unit slope
  (`blockBindingDefect_closure_controlled`), and **off-diagonal**: the closure
  perturbation `B(λ,κ) − B(λ,0)` has zero diagonal
  (`closurePerturbation_offDiagonal`), so the naive additive estimate is `0` while
  the true `Δ = −κ` — the finite shadow of "bound-state mass is not assembled from
  constituents", and exactly why the naive bridge `0b` fails. **Kill condition**
  (`Δ > 0` or uncorrelated with closure) is now provably *unreachable* on the
  physical branch: `Δ > 0` forces `κ < 0` (`blockBindingDefect_pos_imp_neg_kappa`).
  What stays grade **C** is only the *physical identification* — that this block
  `Δ` is *the* carrier binding energy — which inherits the `(λ,κ)` carrier
  reduction (kernel at `(2,1)`, oracle-grade off it). (1) The strong-coupling gap's forest injection (§6) — now a
well-posed combinatorics problem (demoted to a standing bounty). (2) The
color-singlet mass-budget witness (§4) — designed, `b_C ≠ 0`, awaiting
transcription. (3) The reflection-sectored double-pinning theorem and its
rational fixture (§8). (4) The equivariant-index unification of §§4/6/8 (the
program's candidate organizing theorem) — whose **provable half is now landed**:
`EquivariantGradedIndex.graded_budget_decomposition` (**M**, self-guarded) writes
the exact Dirac-square budget `4 D^#D = Q_A+Q_C+4Q_T+4E_#` as *one equivariant
graded-supertrace identity* on the four channels (McKean–Singer odd-power
cancellation `graded_trace_odd_vanishes`; "unification is decomposition"
`graded_trace_sum`; the C4 isotypic split `graded_trace_sector_split`). The honest
boundary: this is finite graded linear algebra, **not** a topological index theorem
à la Atiyah–Singer — that is a category error at this generality (no base space, no
K-theory receptacle, no family of operators; the count is direct), not a research
gap. What stays open is the `finrank`/projection-trace dimension-counting layer
that would turn the algebraic supertrace facts into inertia/dimension theorems.
Each of (1)–(4) is finite, each has a kill condition, none requires new axioms.

**Pre-registered predictions (falsifiable, dimensionless, dated).** The
program is permitted exactly one kind of numeric prediction: a
*dimensionless ratio protected by finite structure*. Two are on the table.
Both are recorded here so a later "success" cannot be back-fitted; both are
grade **C** (they rest on the channel-name correspondence of §4a, not yet a
theorem).

| # | Prediction | Model source | Comparison / kill condition |
|---|---|---|---|
| P-ν | Exactly one massless mode on the small chiral cycle; the *next* mode's ratio is a protected finite target (not an absolute mass) | §8 protection (chiral, not cyclic); oracle | Compare the finite mode-ratio pattern to a neutrino mass-squared ratio `Δm²₂₁/Δm²₃₁` (NuFIT-6.0 `[import]`). **Kill:** if the protected structure forces a ratio pattern incompatible with the measured hierarchy/ordering. Honest status: the *count* (one massless mode) is what the model owns; the *ratio value* is not yet computed, so this is a registered target, not a delivered number. |
| P-hf | Finite hyperfine (π/ρ-analog) mass-squared splitting `M²(↓) − M²(↑) = 512/125` on the 18-dim color-singlet witness | §4 S6 witness; exact-fraction oracle (`probe_s6_singlet_budget.py`) | This is a property of *one specific finite witness* with fixed 3-4-5 rational holonomies — it is a self-consistency prediction of the construction (the closure/chromomagnetic sign flips between spin states), **not** a claim about the physical π/ρ ratio. **Kill:** if the Lean 18×18 transcription does not reproduce `512/125`, or if the sign structure is an artifact of the chosen holonomies (test: vary them). |

Neither is a physical mass. P-ν is the only place the program touches a
measured number, and it does so at the one point (§8) where masslessness is
a theorem and the residual ratio is a protected finite quantity — which is
the honest home for the mass-value question after it failed for charged
leptons (§5). P-hf is a prediction *about the model's own consistency*,
valuable because it is exact and checkable, not because `512/125` is a
hadron ratio.

---

## 11. The Lean anchor table

Every declaration cited in §§3–9, with file, grade, and guard-pin status.
All are kernel-checked under `leanprover/lean4:v4.28.0`. Axiom footprint is
the standard `[propext, Classical.choice, Quot.sound]` (several abstract
algebra lemmas are choice-free, `[propext, Quot.sound]`); the exact
footprints are the `#print axioms` messages inside the guard blocks. Guard
status: **trusted namespace** = outside `Draft/`, needs no pin;
**guard-pinned** = a `#guard_msgs … #print axioms` block enforces the
footprint in the named guard file; **local guard pin** = the block is in the
declaration's own file and is enforced when that module builds; **not pinned** = kernel-checked but without an
enforced pin (supporting identities only, never flagship claims). *(Table
anchor-swept — every one of the 38 declaration names produced a string
`grep` match in its claimed file on 2026-07-08. This is a text-match check,
not an elaboration check; existence and axiom footprints are supported
separately by the targeted Lean and guard builds.)*

| § | Declaration | File | Grade / guard | Role |
|---|---|---|---|---|
| 3 | `det_rankOneHermitian_eq_zero` | `Spinor/PluckerMass.lean` | M, trusted namespace | single edge massless |
| 3 | `two_edge_plucker_mass_identity` | `Spinor/PluckerMass.lean` | M, trusted namespace | two-edge mass = disagreement |
| 3 | `two_edge_mass_zero_iff_wedge_zero` | `Spinor/PluckerMass.lean` | M, trusted namespace | two-edge massless ⇔ wedge vanishes (collinear) |
| 3 | `fin_bundle_plucker_mass_identity` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | mass = pairwise disagreement, general `n` |
| 3 | `fin_bundle_mass_zero_iff_common_direction` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | massless iff collinear |
| 4 | `carrier_krein_square` | `Carrier/CarrierKreinSquare.lean` | M, guard-pinned (`CarrierAxiomGuard`) | master Krein identity: starred blocks `Q_{A,C}^#` + `4 Q_T` + `4 E_#` (§4) |
| 4 | `carrier_square_assembly` | `Carrier/CarrierSquareAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | self-adjoint 3-slot specialization `4 D^#D = Q_A+Q_C+4Q_T` (`E_#=0`, bare blocks) |
| 4 | `signed_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | shares sum to one (abstract) |
| 4/10 | `graded_budget_decomposition`, `graded_trace_odd_vanishes` | `Carrier/EquivariantGradedIndex.lean` | M, self-guarded (in-file pin) | **organizing theorem, provable half**: the 4-channel budget as one equivariant graded-supertrace identity ("unification is decomposition"); McKean–Singer odd-power cancellation. Not a topological index (finite graded linear algebra) |
| 4 | `witness_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-vacuous `(1/2,0,1/2)` witness |
| 4 | `sector_ground_mass` | `Carrier/SectorGroundMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | Rayleigh–Ritz keystone: definite-sector ground value is a positive squared mass (§4 rail 3, §10 crux 0) |
| 4 | `T2_positive_mass` | `Carrier/SectorGroundMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the positivity linchpin**: explicit two-edge Cl(4) carrier, sector form `1+B^HB` PosDef, keystone fires ⇒ genuine positive mass (§6, §10 crux 0a) |
| 4 | `HAC_eq_clifford`, `Jmet_eq_clifford` | `Carrier/CliffordAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **T2 carrier realizes the documented Cl(4) recipe**: hand-typed Krein form/metric `= J(Q_A+Q_C)` / `Js⊗I3` (verbatim) — closes the docstring-only-provenance gap. Certifies *a* Clifford presentation, not canonicity (`K`/order are inputs) |
| 4 | `B_posDef_iff`, `B_massless_iff_of_pos` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | spectral theory of the block `B(λ,κ)`: massive `↔ \|κ\|<λ`, massless line `κ=±λ` for `λ>0` (§4) |
| 4 | `B_least_eigenvalue`, `B_spectrum` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the mass gap as a theorem**: least eigenvalue of `B` `= λ−κ` = aperture − closure (`IsLeast`); full spectrum `= {λ−κ, λ, λ+κ}` (`B_spectrum`) — the three sector mass levels |
| 4 | `M6_topBlock_eq_B`, `M6_botBlock_eq_B` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the carrier tie at `(2,1)`**: `M6 = B(2,1) ⊕ B(2,-1)` — so the phase diagram is the carrier's actual sector form there (general `(λ,κ)` reduction is oracle-grade) |
| 4/10 | `blockBindingDefect_eq_neg_kappa`, `closurePerturbation_offDiagonal` | `Carrier/BindingDefect.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **T3b binding defect**: `Δ_block(λ,κ) = −κ` — closure lowers the ground mass by exactly its strength (negative, closure-controlled, off-diagonal); physical identification stays **C** (§10 crux 0b-b) |
| 3 | `free_mass_operator_eq_plucker` | `Carrier/FreeMassBridge.lean` | M, local guard pin | **free §3↔§4 bridge**: free mass operator `P·adj P = det P • 1` = Plücker mass (§10 crux 0b-a) |
| 3 | `pairwiseMass_append` (+`_le`, `_append_eq_iff`) | `Carrier/MassMonogamy.lean` | M, guard-pinned (`CarrierAxiomGuard`) | mass monogamy: Plücker mass superadditive, excess = cross-disagreement (F3) |
| 3 | `massOn_add_massOn_compl_le` | `Carrier/MassMonogamyPartition.lean` | M, guard-pinned (`CarrierAxiomGuard`) | general-partition monogamy: internal masses ≤ whole |
| 3 | `posDef_iff_det_pos`, `det_eq_zero_iff_not_posDef` | `Carrier/RankAreaMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | massive ⇔ momentum PosDef ⇔ `det P > 0` (rank/area) |
| 7 | `weitzenbock_eq_zero_iff` (+`_re_inner_nonneg`) | `Carrier/WittenPositiveMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite Witten/Lichnerowicz: `A^#A+C` PSD, vanishes iff covariantly constant & curvature-null (F4) |
| 9 | `multiplierStationary_iff_eom` | `Carrier/FiniteCarrierAction.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite carrier action: variational stationarity ⇔ the equation of motion (dynamics D1) |
| 9 | `norm_conserved_orbit`, `energy_conserved_orbit` | `Carrier/FiniteUnitaryEvolution.lean` | M, guard-pinned (`CarrierAxiomGuard`) | a sector isometry conserves norm & energy along its orbit (dynamics D2/D3) |
| 9 | `hermitian_flow_mem_unitaryGroup`, `B_flow_unitary`, `hermitian_flow_isometry` | `Carrier/CarrierUnitaryFlow.lean` | M (first two guard-pinned) | **the D2 instantiation, closed**: the carrier-block Hermitian flow `exp(−i t H)` is unitary and a `LinearIsometryEquiv` (generator-as-Hamiltonian is a **C** posit; carrier tie kernel at `(2,1)`) |
| 9 | `carrier_orbit_norm_conserved`, `carrier_orbit_energy_conserved`, `carrier6_orbit_norm_conserved` | `Carrier/CarrierUnitaryFlow.lean` | M, guard-pinned (`CarrierAxiomGuard`) | the flow **orbit** of the carrier block `B(λ,κ)` — and of the full `6×6` physical sector form `M6` (`carrier6_…`) — conserves sector norm & (commuting-observable) energy: `FiniteUnitaryEvolution` fired on the concrete carrier |
| 9 | `secondQuantized_massGap` | `Carrier/FockMassGap.lean` | M, self-guarded (in-file pin) | **free second-quantized mass gap**: on the fermionic occupation Fock space, `dΓ(B)`'s gap = one-particle gap `λ−κ`; free 2-body = sum of constituents; `Δ=−κ` seeds a below-threshold bound state (interacting hadron mass open) |
| 9 | `invariant_orbit`, `observable_antitone_orbit` | `Carrier/FiniteRGFlow.lean` | M, guard-pinned (`CarrierAxiomGuard`) | RG orbit invariants/monotones under an iterated step (dynamics D4; axiom-free) |
| 9 | `partitionFunction_pos`, `sum_probability_eq_one` | `Carrier/FiniteCanonicalEnsemble.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite canonical ensemble over the carrier spectrum (dynamics D5) |
| 5 | `onshell_wedge_normSq_eq_coin_sq` | `GateI1/MassCoinBridge.lean` | M, kernel-checked (not pinned; supporting) | corner flip amplitude = wedge |
| 6 | `closure_defect_trace_eq` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure-defect trace identity |
| 6 | `wilson_plaquette_eq_half_closure_defect` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | Wilson action = squared defect |
| 6 | `leading_closure_energy_nonneg` | `GateYM/LinearizedClosureEnergy.lean` | M, local guard pin in `LinearizedClosureEnergy.lean`; enforced transitively because `SlabAxiomGuard` imports that module | leading closure defect = nonnegative `|F|²` energy |
| 6 | `null_soldered_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure square structure (abstract) |
| 6 | `closure_current_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | abstract skew-pairing square (concrete `Q_C=L^#L` is MEMO) |
| 6/10 | `balanced_on_physical_sector`, `JQc_not_positive_on_sector` | `GateYM/S1CCPhysicalSectorWitness.lean` | M, self-guarded (in-file pin) | **S1-CC physical-sector instantiation, now kernel**: on the explicit `6×6` Clifford⊗color witness the induced closure form `J Q_C\|V'/N` has inertia `(2,2,0)` (balanced, indefinite) — the central-crux no-go on the witness is a theorem, not MEMO (§6, §10 #1) |
| 6 | `tyAreaLaw_slab_exp` | `GateYM/TYAreaLaw.lean` | M, guard-pinned (`SlabAxiomGuard`) | strong-coupling area law |
| 6 | `wilsonSlabConnected_reflectionPositive` | `GateYM/WilsonSlabConnected.lean` | M, guard-pinned (`SlabAxiomGuard`) | slab reflection positivity |
| 6 | `OSReconstruction.osSpectralGap_pos` | `GateYM/OSReconstruction.lean` | M, guard-pinned (`SlabAxiomGuard`) | OS spectral gap |
| 6 | `slab_exponential_clustering` | `GateYM/SlabClustering.lean` | M, guard-pinned (`SlabAxiomGuard`) | exponential clustering |
| 6 | `banks_casher_count` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite Banks-Casher-type eigenvalue count |
| 6 | `skew_prod` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | count denominator `= m²+AᴴA` |
| 6 | `anticonj_odd_pow_trace_zero` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | odd-trace identity from finite anticonjugation |
| 6 | `anticonj_charpoly_eq` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite anticonjugation gives charpoly negation symmetry |
| 6 | `hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | Hermitian eigenvalue multiset is negation-invariant |
| 6 | `hermitian_balanced_count_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | equal positive/negative Hermitian eigenvalue counts; physical `J Q_C|V'/N` bridge still MEMO |
| 6 | `nonvacuous_positive_sector` | `Carrier/KreinPositiveSectorWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | positive physical sector `(2,1)` |
| 6 | `nondegenerate_but_indefinite_no_go` | `Carrier/KreinPositiveSectorWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | indefinite no-go `(1,2)` |
| 7 | `weitzenbock_master_varying` | `Carrier/CarrierESlot.lean` | M, guard-pinned (`CarrierAxiomGuard`) | soldering-gradient `E` (varying soldering) |
| 7 | `eslot_torsion_solder_split` | `Carrier/CarrierESlotTorsionSplit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | `2E = Contract(T)+Contract(S)` |
| 7 | `eslot_not_pure_torsion_witness` | `Carrier/CarrierESlotTorsionSplit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | not pure torsion (witness) |
| 8 | `chiralIndex_eq_graded_dimension` | `Carrier/CarrierIndexProtection.lean` | M, guard-pinned (`CarrierAxiomGuard`) | index = graded dimension |
| 8 | `exists_protected_massless_mode` | `Carrier/CarrierIndexProtection.lean` | M, guard-pinned (`CarrierAxiomGuard`) | forced massless mode |
| 8 | `chiral_det_eq_pm_one` | `Carrier/ChiralZeroModeParity.lean` | M, guard-pinned (`CarrierAxiomGuard`) | chiral determinant dichotomy |
| 9 | `null_pair_prod_sq_eq_pairing_smul` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | decimation coefficient law |
| 9 | `effective_edge_not_nilpotent` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | blocking generates non-null term |
| 9 | `collinear_schurComplement_eq_zero` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | collinear negative control |
| 9 | `nullL_mul_mid_mul_nullN` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | coupling = propagator element |
| 9 | `mid_effective_not_nilpotent` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-null iff propagator-coupled |

---

## Provenance and status

This manuscript is a draft of the overnight all-mass run (2026-07-08). Its
verified core (§3, §4, §6 pillars, §8, §9) is machine-checked; its physical
readings (§5, §7, the budget's hadron interpretation) are MEMO or
conjectural and labeled as such. The external anchors — Wilson,
Osterwalder–Seiler, Banks–Casher, Ji, Yang et al., Dürr et al.,
Asbóth–Obuse, Aldrovandi–Pereira, NuFIT-6.0, Sumino — are `[import]` and are
recorded in `Sources/Null_Edge_References.md`. It supersedes nothing; it
sits beside the P1 origin-of-mass draft as the wider-scope companion.

---

## References

External works cited (`[import]`), grouped by role. Identifiers verified against
INSPIRE-HEP / arXiv (2026-07-08): the modern arXiv ids and the load-bearing
classics (Barrett hep-th/0608221 = J. Math. Phys. 48 012303; Banks–Casher DOI
10.1016/0550-3213(80)90255-2 = Nucl. Phys. B169 103; Zwanziger DOI
10.1016/0550-3213(91)90581-H; Nielsen–Ninomiya Nucl. Phys. B185 20; Osterwalder–
Seiler Ann. Phys. 110 440) are confirmed. The full source map with keys and
status is `Sources/Null_Edge_References.md`. The project's own kernel-checked
anchors are in the §11 table, not here. A fuller prior-art map with
novelty-gap analysis is in
`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`.

**Kinematics / spinor-helicity (§2a, §3).**

- H. Elvang, Y. Huang, *Scattering Amplitudes*, arXiv:1308.1697.
- L. Dixon, *A brief introduction to modern amplitude methods* (TASI lectures),
  arXiv:1310.5353.

**Physical pictures — zig-zag, Zitterbewegung, causal order (§2a).**

- R. Penrose, *The Road to Reality*, Jonathan Cape (2004), §25.2.
- P. A. M. Dirac (1930); D. Hestenes, *The Zitterbewegung interpretation of
  quantum mechanics*, Found. Phys. 20 (1990) 1213.
- D. Malament, *The class of continuous timelike curves determines the topology
  of spacetime*, J. Math. Phys. 18 (1977) 1399.

**Feynman checkerboard and its continuum limit (§2a, §9).**

- R. P. Feynman, A. R. Hibbs, *Quantum Mechanics and Path Integrals* (1965).
- H. A. Gersch, *Feynman's relativistic chessboard as an Ising model*, Int. J.
  Theor. Phys. 20 (1981) 491; T. Jacobson, L. S. Schulman, *Quantum stochastics:
  the passage from a relativistic to a non-relativistic path integral*, J. Phys.
  A 17 (1984) 375.
- B. Z. Foster, T. Jacobson, *Spin on a 4D Feynman Checkerboard*,
  arXiv:1610.01142.
- A. Kull, *Quantum mechanical motion of relativistic particle in
  non-continuous spacetime*, arXiv:quant-ph/0212053.

**Finite / Lorentzian / Krein spectral triples, NCG Standard Model (§2a, §6, §8).**

- N. Bizi, C. Brouder, F. Besnard, *Space and time dimensions of algebras with
  applications to Lorentzian noncommutative geometry*, arXiv:1611.07062.
- J. W. Barrett, *A Lorentzian version of the non-commutative geometry of the
  Standard Model*, J. Math. Phys. 48 (2007) 012303, arXiv:hep-th/0608221.
- A. Connes, *Noncommutative geometry and the standard model with neutrino
  mixing*, JHEP 0611 (2006) 081, arXiv:hep-th/0608226.
- F. Finster, *The Continuum Limit of Causal Fermion Systems*, Springer (2016),
  arXiv:1605.04742.

**Discrete Dirac, quantum walks/automata, fermion doubling (§2a, §8).**

- D. Bakircioglu, P. Arnault, P. Arrighi, *Fermion Doubling in Quantum Cellular
  Automata*, arXiv:2505.07900.
- L. Mlodinow, T. A. Brun, *Discrete spacetime, quantum walks, and relativistic
  wave equations*, Phys. Rev. A 97 (2018) 042131, arXiv:1802.03910 (4D coin →
  Dirac gammas; coin-flip operator = mass term; §2a mass-side comparator).
- A. Bisio, G. M. D'Ariano, P. Perinotti, A. Tosini, *Weyl, Dirac and Maxwell
  Quantum Cellular Automata*, arXiv:1601.04842 (1D Dirac QCA barrier scattering;
  the prior-art setup for the §9a `carrier_scattering_sim.py` S-matrix).
- H. B. Nielsen, M. Ninomiya, *Absence of neutrinos on a lattice*, Nucl. Phys.
  B185 (1981) 20.

**Confinement, positivity, constructive/lattice gauge theory (§6, §9).**

- D. Zwanziger, *Vanishing of zero-momentum lattice gluon propagator and color
  confinement*, Nucl. Phys. B364 (1991) 127.
- K. Osterwalder, E. Seiler, *Gauge field theories on a lattice*, Ann. Phys. 110
  (1978) 440.
- K. G. Wilson, *Confinement of quarks*, Phys. Rev. D 10 (1974) 2445 (the Wilson
  action, §6).
- T. Banks, A. Casher, *Chiral symmetry breaking in confining theories*, Nucl.
  Phys. B169 (1980) 103.
- P. H. Ginsparg, K. G. Wilson, *A remnant of chiral symmetry on the lattice*,
  Phys. Rev. D 25 (1982) 2649 (the GW relation, §8).
- J. K. Asbóth, H. Obuse, *Bulk-boundary correspondence for chiral symmetric
  quantum walks*, Phys. Rev. B 88 (2013) 121406.

**Hadron mass, proton mass decomposition (§4, §4a, §5).**

- X. Ji, *QCD analysis of the mass structure of the nucleon*, Phys. Rev. Lett.
  74 (1995) 1071, arXiv:hep-ph/9410274 (the Ji decomposition, §4/§4a).
- Y.-B. Yang et al., *Proton Mass Decomposition from the QCD Energy Momentum
  Tensor*, Phys. Rev. Lett. 121 (2018) 212001, arXiv:1808.08677.
- S. Dürr et al., *Ab initio determination of light hadron masses*, Science 322
  (2008) 1224, arXiv:0906.3599.

**Charged-lepton and neutrino masses (§5, §8, §10).**

- Y. Koide, *Charged lepton mass formula: development and prospect*,
  arXiv:0706.2534.
- Y. Sumino, *Family gauge symmetry and Koide's mass formula*, Phys. Lett. B671
  (2009) 477, arXiv:0812.2103.
- I. Esteban et al. (NuFIT-6.0), *Updated global analysis of three-flavor
  neutrino oscillations*, arXiv:2410.05380.

**Discrete geometry / gravity (§7).**

- T. Regge, *General relativity without coordinates*, Nuovo Cim. 19 (1961) 558.
- R. Aldrovandi, J. G. Pereira, *Teleparallel Gravity*, Springer (2013)
  (teleparallel / contorsion background for the E-slot trinity).

**Machine-verified physics; slogans (§2a).**

- J. Tooby-Smith, *HepLean: Digitalising high energy physics*, arXiv:2405.08863
  (now the *PhysLean* library, `Physlib`; its `Relativity/.../Weyl` metric
  `!![0,1;-1,0]` is the independent convention check for §3's spinor wedge).
- F. Wilczek, *QCD Made Simple* / "Mass Without Mass", Phys. Today 53 (2000) 22;
  L. H. Kauffman, H. P. Noyes, discrete-physics program (bit-string / iterant
  combinatorics).

---

## Appendix A. Reproducibility

Every **M** claim in this paper is machine-checked and independently
reproducible. The verification is not a claim to be trusted — it is a build to
be re-run.

**Toolchain (pinned).** `leanprover/lean4:v4.28.0` with Mathlib at the matching
`v4.28.0` (see `lakefile.toml`). Do not upgrade the pin; it is fixed for the
Aristotle and Sphere-Packing workflows.

**Rebuild everything.** From the repository root:

```bash
lake build                                  # builds the whole project (~8300 jobs)
lake env lean PhysicsSM/Path/To/File.lean   # check a single module
```

A green `lake build` is the top-level integrity check: it fails if any **M**
theorem acquires a `s o r r y`, a fake `a x i o m`, or a `n a t i v e _ d e c i d e`.

**Axiom audit (the M grade).** Each flagship carries a build-enforced axiom pin
— a `#guard_msgs (whitespace := lax) in #print axioms <name>` block — in its
module and in the lane guard file (`PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean`
for the Weitzenböck-carrier lane, `.../GateYM/SlabAxiomGuard.lean` for the
closure lane). The build **fails** if a theorem's transitive axiom footprint
drifts from the standard base `[propext, Classical.choice, Quot.sound]` (choice
-free results use only `[propext, Quot.sound]`). To audit any result yourself:
`#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.T2_positive_mass`.

**The anchor table (§11)** lists every M theorem with its file and guard status;
each name is grep-checkable against the source.

**Numeric oracles (NOT M).** The pre-registered numerical probes live in
`Scripts/oracle/` and are quarantined from the verified core. Each states, in its
docstring, exactly which kernel-checked identity it mirrors or which kill it
tests; run `python Scripts/oracle/<probe>.py`. Key ones: the S1-CC balanced
-inertia probe, the aperture-grading kill, the multi-edge positive-sector escape,
the Δ binding-energy probe, the T3a free-bridge probe, and the four dynamics
simulators — `carrier_spectrum_sim.py` (mass phase diagram; validates
`T2_positive_mass` + `signed_budget_sum_one`), `carrier_evolution_sim.py`
(unitary flow, quantum-walk transfer, Slater amplitudes; validates
`FiniteUnitaryEvolution` + `T2`), `carrier_rgflow_sim.py` (RG flow, canonical
ensemble, condensate shadow; validates `FiniteRGFlow` +
`FiniteCanonicalEnsemble` + `RGSchurMassWitness`), and `carrier_scattering_sim.py`
(a finite S-matrix: mass-barrier transmission/reflection, unitary and reciprocal;
validates `FiniteUnitaryEvolution` + `T2`). A probe is evidence for adding a fixture or
pre-registering a prediction — never a substitute for a kernel proof.

**Provenance.** Source keys and convention checks are in
`Sources/Null_Edge_References.md`; the PhysLean convention cross-checks and the
prior-art / novelty-gap analysis are in `docs/PHYSLEAN.md` and
`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`.

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
# Fable-5 call-08 review

## Semantic-alignment verdict: `S1CCPhysicalSectorWitness.lean`

**Verdict: the kernel statements are genuine and correctly computed, but the "physical sector" identification is prose, not kernel — one notch more MEMO than the manuscript's strongest sentence claims.** What the kernel actually proves is real: `B = JQc.submatrix r r` is genuinely the matrix claimed (`B_eq_Bexpl` checks out by hand: `sx·sz = !![0,-1;1,0]`, `k = !![0,1;-1,0]`, and the four blocks assemble to `Bexpl`), `balanced_on_physical_sector` counts actual `IsHermitian.eigenvalues` sign counts summing to 4 — this is the true inertia `(2,2,0)`, not a dressed-up weaker fact — and `N_in_radical` is stronger than needed (row/column `(0,2)` of `JQc` vanish against the *whole* carrier, so the compression is the genuine induced form given the coset-rep claim). The sharp finding is that **`Q_G` is decorative in the kernel**: no theorem states `ker Q_G = span{(0,0),(0,1),(0,2),(1,0),(1,1)}`, `range Q_G = span e_{(0,2)}`, or that `r` enumerates coset representatives — `N_in_radical` hard-codes the axis `(0,2)` and never mentions `Q_G`. Since `Q_G` is a single matrix unit these facts are trivially true by inspection, but the manuscript's §6 sentence "the concrete `V'` construction from the carrier Gauss covectors … is **now all kernel-checked**" outruns the kernel by exactly this by-inspection step (docstring-outruns-kernel, mild). Secondarily, `JQc` is one matrix *named* "J Q_C" — no kernel fact factors it into a Krein metric times a closure operator with each factor's properties. The claimed honest line ("witness kernel, general reduction MEMO") is the right line; the file itself holds it, and the fix is two five-line lemmas (`ker`/`range` of `Q_G`) plus one softened manuscript clause.

## Semantic-alignment verdict: `EquivariantGradedIndex.lean`

**Verdict: every statement is true and the topological-index disclaimer is adequate, but `graded_budget_decomposition` is thinner than even the disclaimed prose suggests — and the flag goes to the manuscript, not the file.** Concretely: (i) the theorem's hypotheses use **none** of the framework — `Gamma` and `g` are arbitrary matrices (no involution, no oddness, no commutation), `Dsharp` has no adjoint relation to `D`, and the budget is an *assumed hypothesis* `hbudget`; the conclusion is trace-linearity applied to it. The words "equivariant" and "graded" in the name are kernel-decorative. (ii) The structures `IsOddInvolutionFor` / `IsEvenSymmetryFor` are **defined and never used by any theorem in the file** — the "shared data" framing is dead code, which is the tell that the framework is not yet load-bearing. (iii) The genuine (small) content is `graded_trace_odd_vanishes` / `graded_trace_odd_power_vanishes` (real supersymmetric cancellation, correct proofs) and the two involution lemmas. (iv) Crucially, there is **no kernel composition** with `carrier_krein_square`: the manuscript §10/§11 line "`graded_budget_decomposition` (**M**) writes the **exact** Dirac-square budget as one equivariant graded-supertrace identity" invites the reading that the landed theorem *contains* the budget; in the kernel the budget is an undischarged hypothesis in a different formalism (concrete matrices vs. the abstract carrier setting), and the instantiation is not done. The file's own claim boundary is honest about "pure linear algebra" and lists L2–L5 as handoffs; the fix is to the manuscript's wording, plus (ideally) actually firing the lemma on the carrier blocks.

## Manuscript verdict

**Grade discipline substantially held across the ~40 edits — the caveat architecture (D2 generator-as-C-posit, `(2,1)`-only carrier tie, witness-vs-general-reduction split, channel names at C) is intact and consistently enforced — but the rapid S1-CC upgrade left three verified staleness/consistency defects, most severe first:**

1. **§6 crux box is internally contradictory (stale header + stale label).** Line 723–730: the box header still reads "(M engine + **MEMO physical instantiation**)" and the body still says "balanced … (`sig = (2,2,0)`, **oracle**)" — then the *same paragraph* correctly announces the instantiation is "now kernel-checked … no longer only a numeric probe." A referee reading the box top-down sees the paper grading one fact MEMO/oracle and M simultaneously. This is the worst kind of slip for this paper because the box is the advertised former-#1 crux.
2. **§11 anchor row stale:** the `hermitian_balanced_count_of_neg_charpoly` row still says "physical `J Q_C|V'/N` bridge still MEMO" — now false as written; it should say "witness instantiation now M (`S1CCPhysicalSectorWitness`); general representative MEMO."
3. **Factor-4 drift on `E_#` recurs in §2a (line 253) and §4a item 1**, both writing `4 D^#D = Q_A+Q_C+4Q_T+E_#` — precisely the drift §4's honesty note declares an error class and claims to have fixed. Cosmetic, but the paper indicted this exact slip.
4. **Over-generous §10/§11 wording on the organizing theorem** (see File-2 verdict): "writes the exact budget as one identity" should read "shows that *any* four-channel budget identity, including the kernel-checked `carrier_krein_square`, pushes through the supertrace by linearity; the budget hypothesis is not yet discharged in-file."

Everything else I checked is clean: the aperture-grading kill correctly stays probe-grade (the witness file proves inertia of the *closure* compression only, not of `J(Q_A+Q_C+4Q_T)`, and the manuscript keeps the distinction); the FockMassGap, BindingDefect, and CarrierUnitaryFlow claims match their stated boundaries; the title-discipline note, the kill list, and the P-ν/P-hf pre-registrations are honest. With items 1–3 fixed, still publication-ready as a self-contained draft.

## Bottom line

1. **Fix the §6 crux box** (header "MEMO physical instantiation" and the "(2,2,0), oracle" label) and the §11 `hermitian_balanced_count` row — the manuscript currently grades its own headline result two ways at once.
2. **Add the two missing witness lemmas** (`range Q_G = span e_{(0,2)}`, `ker Q_G` = the five axes, or a single "r ∪ {(0,2)} spans ker Q_G" statement) so "the `V'` construction is kernel-checked" becomes literally true; until then soften that one §6 clause.
3. **Reword the organizing-theorem claims and instantiate `graded_budget_decomposition` on the actual carrier blocks** (and either use or delete the dead `IsOddInvolutionFor`/`IsEvenSymmetryFor` structures) — the theorem is honest linearity, but "M" prose should not let the budget hypothesis and the unused equivariance pass as landed structure.

```

## Response stderr

```text

```
