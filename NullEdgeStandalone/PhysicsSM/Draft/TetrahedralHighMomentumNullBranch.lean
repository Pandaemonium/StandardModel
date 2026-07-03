import Mathlib

/-!
# High-momentum tetrahedral null branch theorem (finite branch-data)

Aristotle deliverable for the null-edge Gate C branch-count program.  See
`PROMPT.md`, `AgentTasks/null-edge-flat-branch-count-protocol.md`,
`AgentTasks/null-edge-branch-count-acceptance-criteria.md` and
`docs/CONVENTIONS.md`.

This file formalizes the **finite algebra** of the warning example and the full
`{0, π}^4` corner classification for the flat tetrahedral retarded dual-soldered
null-edge Dirac symbol.  It is *finite branch data*, not a physical doubler
theorem.

## Conventions (locked, `docs/CONVENTIONS.md`)

* Mostly-minus Lorentzian signature `g = diag(+,-,-,-)`: null modes have
  `p² = 0`, spacelike `p² < 0`, timelike `p² > 0`.
* The tetrahedral inverse Gram matrix (the symbol metric in edge-phase
  coordinates) for `d = 4` is
  `G⁻¹ = -(d-1)/d · I + (1/d) · J = -3/4 · I + 1/4 · J`,
  i.e. diagonal `-1/2`, off-diagonal `1/4`.  This equals `αᵃ · αᵇ` under the
  mostly-minus metric (`Open Questions 6.9`).
* The retarded phase vector is `uₐ = exp(i qₐ) - 1`.  The Lorentzian symbol
  square in edge coordinates is `p(q)² = uᵀ G⁻¹ u` (with lattice spacing
  `h = 1`).

## What is proved here

* `Ginv_eq`: `G⁻¹ = -3/4 · I + 1/4 · J`.
* `qform_eq`: `uᵀ G⁻¹ u = -3/4 · Σ uₐ² + 1/4 · (Σ uₐ)²`.
* `warning_uT_Ginv_u`: the warning example `q = (π,π,π,0)`,
  `u = (-2,-2,-2,0)` has `uᵀ G⁻¹ u = 0` while `u ≠ 0`
  (high-momentum null Clifford singularity: coefficient nonzero, quadratic
  form null).
* `threePi_null`: all four three-`π` corners have the same property.
* `corner_qform`: the closed form `uᵀ G⁻¹ u = k² - 3k` for the corner with
  `k` edges set to `π`, and the classification of all 16 corners:
  `1` origin (coefficient-zero null) `+` `4` high-momentum nonzero null
  corners `+` `10` spacelike corners `p² = -2` `+` `1` timelike all-`π` corner
  `p² = +4`.
* `pSq_mink_eq_qform` (Lorentzian build): the explicit Minkowski square of the
  spacetime symbol covector `p(q)_μ = Σₐ uₐ αᵃ_μ` built from the unit-normalized
  tetrahedral dual frame `αᴬ = (1/4) dt + (3/4) n_A · dx` equals `uᵀ G⁻¹ u`.

## Guardrails (carried verbatim, `docs/CONVENTIONS.md`, do not weaken)

* This is finite branch data, NOT a physical doubler theorem.  Being a
  determinant-level / quadratic-form null is necessary but not sufficient to be
  a physical doubler.
* Physical classification still needs the Krein `J`-sign, gauge content,
  energy-slice (real vs complex) data, and `h`-scaling of each branch.
* Retardedness avoids coefficient-zero doublers only; these determinant-level
  null branches remain to be physically classified.
-/

namespace PhysicsSM
namespace Draft
namespace TetrahedralNullBranch

open Finset Complex

noncomputable section

/-! ## The tetrahedral inverse Gram matrix and the Lorentzian quadratic form -/

/-- The tetrahedral inverse Gram matrix `G⁻¹ = -3/4 · I + 1/4 · J` on `Fin 4`,
with diagonal entries `-1/2` and off-diagonal entries `1/4`.  This is the symbol
metric in edge-phase coordinates (mostly-minus signature). -/
def Ginv : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of fun i j => if i = j then (-1/2 : ℂ) else (1/4 : ℂ)

/-
`G⁻¹ = -3/4 · I + 1/4 · J`, with `I` the identity matrix and `J` the
all-ones matrix.
-/
theorem Ginv_eq :
    Ginv = (-3/4 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ)
      + (1/4 : ℂ) • (Matrix.of fun _ _ => (1 : ℂ)) := by
  ext i j; unfold Ginv; fin_cases i <;> fin_cases j <;> norm_num;

/-- The Lorentzian quadratic form `uᵀ G⁻¹ u` in edge-phase coordinates.  In the
mostly-minus convention this is the symbol square `p(q)²` (at `h = 1`). -/
def qform (u : Fin 4 → ℂ) : ℂ := ∑ i, ∑ j, u i * Ginv i j * u j

/-
Closed form of the quadratic form:
`uᵀ G⁻¹ u = -3/4 · Σ uₐ² + 1/4 · (Σ uₐ)²`.
-/
theorem qform_eq (u : Fin 4 → ℂ) :
    qform u = (-3/4 : ℂ) * (∑ a, (u a) ^ 2) + (1/4 : ℂ) * (∑ a, u a) ^ 2 := by
  unfold qform; norm_num [ Fin.sum_univ_four ] ; ring_nf
  unfold Ginv; norm_num [ Fin.ext_iff ] ; ring

/-! ## Corner phase vectors `qₐ ∈ {0, π}` -/

/-- Edge phase of a `{0, π}^4` corner: `qₐ = π` if the bit is set, else `0`. -/
def cornerPhase (s : Fin 4 → Bool) (a : Fin 4) : ℝ := if s a then Real.pi else 0

/-- Retarded phase vector of a corner, `uₐ = exp(i qₐ) - 1`. -/
def cornerU (s : Fin 4 → Bool) (a : Fin 4) : ℂ :=
  Complex.exp (Complex.I * (cornerPhase s a : ℂ)) - 1

/-- Number of edges set to `π` in a corner. -/
def cornerCount (s : Fin 4 → Bool) : ℕ := ∑ a : Fin 4, if s a then 1 else 0

/-
The corner retarded values: `uₐ = exp(i π) - 1 = -2` at a `π` edge and
`uₐ = exp(i·0) - 1 = 0` at a `0` edge.
-/
theorem cornerU_apply (s : Fin 4 → Bool) (a : Fin 4) :
    cornerU s a = if s a then (-2 : ℂ) else 0 := by
  unfold cornerU cornerPhase;
  split_ifs <;> norm_num [ mul_comm Complex.I ]

/-
`Σₐ uₐ = -2 k`, where `k = cornerCount s`.
-/
theorem sum_cornerU (s : Fin 4 → Bool) :
    (∑ a, cornerU s a) = (-2 : ℂ) * (cornerCount s : ℂ) := by
  simp +decide [cornerU_apply, cornerCount]
  rw [Finset.sum_ite]
  norm_num
  ring

/-
`Σₐ uₐ² = 4 k`, where `k = cornerCount s`.
-/
theorem sum_cornerU_sq (s : Fin 4 → Bool) :
    (∑ a, (cornerU s a) ^ 2) = (4 : ℂ) * (cornerCount s : ℂ) := by
  convert Finset.sum_congr rfl fun i _ => ?_ using 1;
  rotate_left;
  exact fun i => if s i then 4 else 0;
  · split_ifs <;> norm_num [ cornerU_apply, ‹_› ];
  · rw [ Finset.sum_ite ] ; norm_num [ cornerCount ] ; ring

/-
`uₐ = 0` for all `a` iff the corner is the origin (`k = 0`).
-/
theorem cornerU_eq_zero_iff (s : Fin 4 → Bool) :
    cornerU s = 0 ↔ cornerCount s = 0 := by
  rw [ funext_iff ] ; simp +decide [ Fin.forall_fin_succ, cornerCount, cornerU_apply ]

/-
Closed form of the corner quadratic form: `uᵀ G⁻¹ u = k² - 3k`, where
`k = cornerCount s` is the number of edges set to `π`.
-/
theorem corner_qform (s : Fin 4 → Bool) :
    qform (cornerU s) = (cornerCount s : ℂ) ^ 2 - 3 * (cornerCount s : ℂ) := by
  convert qform_eq ( cornerU s ) using 1 ; norm_num [ sum_cornerU, sum_cornerU_sq ] ; ring

/-! ## The warning example `q = (π, π, π, 0)` -/

/-- The warning corner `q = (π, π, π, 0)`. -/
def threePiZero : Fin 4 → Bool := ![true, true, true, false]

/-
The warning retarded phase vector `u = (-2, -2, -2, 0)`.
-/
theorem warning_u : cornerU threePiZero = ![(-2 : ℂ), -2, -2, 0] := by
  ext i; fin_cases i <;> simp +decide [ cornerU_apply, threePiZero ] ;

/-
The warning vector is nonzero (the symbol coefficient does not vanish).
-/
theorem warning_u_ne_zero : cornerU threePiZero ≠ 0 := by
  rw [Ne, cornerU_eq_zero_iff]; decide

/-
**Warning example (finite algebra).**  For `q = (π, π, π, 0)`,
`u = exp(i q) - 1 = (-2, -2, -2, 0)`, the Lorentzian quadratic form is null,
`uᵀ G⁻¹ u = 0`, while `u ≠ 0`: a high-momentum null Clifford singularity whose
symbol coefficient is nonzero but whose Lorentzian quadratic form vanishes.
-/
theorem warning_uT_Ginv_u :
    qform (cornerU threePiZero) = 0 ∧ cornerU threePiZero ≠ 0 := by
  refine' ⟨ _, _ ⟩;
  · rw [ corner_qform ] ; norm_cast;
  · exact warning_u_ne_zero

/-! ## All four three-`π` corners are high-momentum null branches -/

/-
**Three-`π` corners.**  Every corner with exactly three `π` edges (the four
permutations of `(π,π,π,0)`) has a null Lorentzian quadratic form
`uᵀ G⁻¹ u = 0` while its retarded vector is nonzero.
-/
theorem threePi_null (s : Fin 4 → Bool) (hs : cornerCount s = 3) :
    qform (cornerU s) = 0 ∧ cornerU s ≠ 0 := by
  rw [ corner_qform, hs ] ; norm_num;
  exact fun h => by have := cornerU_eq_zero_iff s; aesop;

/-! ## Classification of all 16 `{0, π}^4` corners -/

/-
The origin `k = 0`: coefficient-zero null corner (`u = 0`, `p² = 0`).
-/
theorem corner_origin (s : Fin 4 → Bool) (hs : cornerCount s = 0) :
    cornerU s = 0 ∧ qform (cornerU s) = 0 := by
  exact ⟨ cornerU_eq_zero_iff s |>.2 hs, by rw [ corner_qform, hs ] ; norm_num ⟩

/-
Spacelike corners `k ∈ {1, 2}`: `p² = -2`.
-/
theorem corner_spacelike (s : Fin 4 → Bool)
    (hs : cornerCount s = 1 ∨ cornerCount s = 2) :
    qform (cornerU s) = -2 := by
  rcases hs with ( hs | hs ) <;> rw [ corner_qform, hs ] <;> norm_num

/-
Timelike all-`π` corner `k = 4`: `p² = +4`.
-/
theorem corner_timelike (s : Fin 4 → Bool) (hs : cornerCount s = 4) :
    qform (cornerU s) = 4 := by
  rw [ corner_qform, hs ] ; norm_num

/-! ### Corner counts (`{0, π}^4` has 16 corners) -/

/-
There is exactly one origin corner (`k = 0`).
-/
theorem count_origin :
    (univ.filter fun s : Fin 4 → Bool => cornerCount s = 0).card = 1 := by
  decide +revert

/-
There are exactly four high-momentum null corners (`k = 3`).
-/
theorem count_highMomentumNull :
    (univ.filter fun s : Fin 4 → Bool => cornerCount s = 3).card = 4 := by
  decide +revert

/-
There are exactly ten spacelike corners (`k ∈ {1, 2}`).
-/
theorem count_spacelike :
    (univ.filter fun s : Fin 4 → Bool =>
      cornerCount s = 1 ∨ cornerCount s = 2).card = 10 := by
  decide +revert

/-
There is exactly one timelike corner (`k = 4`).
-/
theorem count_timelike :
    (univ.filter fun s : Fin 4 → Bool => cornerCount s = 4).card = 1 := by
  decide +kernel

/-
There are exactly five null corners (`k = 0` or `k = 3`):
one origin plus the four high-momentum corners.
-/
theorem count_null :
    (univ.filter fun s : Fin 4 → Bool =>
      cornerCount s = 0 ∨ cornerCount s = 3).card = 5 := by
  decide +revert

/-
The full corner set `{0, π}^4` has 16 elements.
-/
theorem count_total : (univ : Finset (Fin 4 → Bool)).card = 16 := by
  rfl

/-! ## Explicit Lorentzian Minkowski build

The quadratic form `uᵀ G⁻¹ u` is the Minkowski square of the spacetime symbol
covector `p(q)_μ = Σₐ uₐ αᵃ_μ`, where the unit-normalized tetrahedral dual frame
is `αᴬ = (1/4) dt + (3/4) n_A · dx`, `n_A = s_A / √3`, with directions
`s_1 = (1,1,1)`, `s_2 = (1,-1,-1)`, `s_3 = (-1,1,-1)`, `s_4 = (-1,-1,1)`.
This makes the mostly-minus Lorentzian signature explicit. -/

/-- The four tetrahedral spatial directions `s_A ∈ {±1}^3`. -/
def sVec : Fin 4 → Fin 3 → ℂ :=
  ![![1, 1, 1], ![1, -1, -1], ![-1, 1, -1], ![-1, -1, 1]]

/-- The tetrahedral dual-frame covectors `αᵃ_μ`: time component `1/4`, spatial
components `(√3/4) s_A` (so `αᴬ = (1/4) dt + (3/4) n_A · dx`, `n_A = s_A/√3`). -/
def alpha (a : Fin 4) : Fin 4 → ℂ :=
  ![(1/4 : ℂ),
    (Real.sqrt 3 / 4 : ℂ) * sVec a 0,
    (Real.sqrt 3 / 4 : ℂ) * sVec a 1,
    (Real.sqrt 3 / 4 : ℂ) * sVec a 2]

/-- The spacetime symbol covector `p(q)_μ = Σₐ uₐ αᵃ_μ`. -/
def pCov (u : Fin 4 → ℂ) : Fin 4 → ℂ := fun mu => ∑ a, u a * alpha a mu

/-- The Minkowski square (mostly-minus) of a covector
`p² = (p₀)² - (p₁)² - (p₂)² - (p₃)²`. -/
def mink (p : Fin 4 → ℂ) : ℂ := (p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2

/-
The time component of the symbol covector: `p₀ = (1/4) Σₐ uₐ`.
-/
theorem pCov_time (u : Fin 4 → ℂ) : pCov u 0 = (1/4 : ℂ) * ∑ a, u a := by
  unfold pCov; norm_num [ Fin.sum_univ_four ] ; ring_nf
  unfold alpha; norm_num

/-
**Lorentzian identity.**  The Minkowski square of the spacetime symbol
covector equals the edge-coordinate quadratic form:
`p(q)² = uᵀ G⁻¹ u`.  This identifies `qform` with the genuine mostly-minus
Lorentzian quadratic form.
-/
theorem pSq_mink_eq_qform (u : Fin 4 → ℂ) : mink (pCov u) = qform u := by
  unfold mink pCov qform;
  unfold alpha Ginv;
  simp +decide [ Fin.sum_univ_succ, sVec ];
  ring_nf ; norm_num [ ← Complex.ofReal_pow ] ; ring

/-
For a high-momentum (`k = 3`) corner the spacetime symbol covector is
nonzero, witnessed by its time component `p₀ = -3/2 ≠ 0`.
-/
theorem threePi_pCov_ne_zero (s : Fin 4 → Bool) (hs : cornerCount s = 3) :
    pCov (cornerU s) ≠ 0 := by
  intro h; have := congr_fun h 0; norm_num [ pCov, hs ] at this;
  unfold alpha at this; norm_num [ pCov_time, sum_cornerU, hs ] at this;
  rw [ ← Finset.sum_mul _ _ _ ] at this ; norm_num [ sum_cornerU, hs ] at this

end

end TetrahedralNullBranch
end Draft
end PhysicsSM
