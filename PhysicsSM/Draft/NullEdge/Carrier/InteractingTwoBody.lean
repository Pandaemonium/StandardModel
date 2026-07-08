import Mathlib

/-!
# A finite interacting two-body bound state strictly below threshold

This module *earns* the interacting two-body bound state that the companion file
`FockMassGap.lean` only *seeded*.  There, the free second-quantized Hamiltonian
`dΓ(B)` has two-body energy *exactly* `d i + d j` (the sum of constituents, no
binding), and the binding defect `Δ = -κ` was inserted by hand.  Here we build a
genuine interacting two-body operator `H₂ = dΓ(B)|_{Λ²} + V` on the two-particle
sector and *prove* that its least eigenvalue lies strictly below the free
threshold exactly because of the attractive interaction `V`.

## The finite model (`N = 3`)

For `N = 3` one-particle modes with energies `d : Fin 3 → ℝ`, the two-particle
sector `Λ²(sector)` is `Fin 3 choose 2 = 3` dimensional, with occupation basis
the three pairs

* index `0 ↔ {mode 0, mode 1}`, free energy `d 0 + d 1`,
* index `1 ↔ {mode 0, mode 2}`, free energy `d 0 + d 2`,
* index `2 ↔ {mode 1, mode 2}`, free energy `d 1 + d 2`.

The **free** two-body Hamiltonian `dΓ(B)|_{Λ²}` is the diagonal matrix of these
pair energies (`freeH2`).  The **interaction** `V` (`interaction`) is an
attractive single off-diagonal coupling of strength `κ` between the two lowest
pairs (the two pairs sharing the lowest mode `0`); it is real symmetric, hence
Hermitian, and its scale is exactly the closure strength `κ`.  The interacting
Hamiltonian is `H₂ = freeH2 + V` (`H2`).

## The theorem (`interacting_boundState_below_threshold`)

For a sorted spectrum `d 0 ≤ d 1 ≤ d 2` and `κ > 0`, the least eigenvalue of
`H₂` — packaged as `IsLeast (spectrum2 d κ) (boundEnergy d κ)` — lies strictly
below the free two-body threshold `min_{i≠j}(d i + d j)` (`pairThreshold`).
The explicit least eigenvalue is

  `boundEnergy = (a+c)/2 - sqrt((a-c)²/4 + κ²)`,  `a = d0+d1`, `c = d0+d2`,

the smaller root of the `2×2` attractive block; it dips below `min(a,c)` exactly
when `κ ≠ 0`.  This is a genuine finite bound state below the sum of the
constituents: `mass < d i + d j`.

## Semantic honesty: hadron vs. toy

Grade **M** (a correct matrix/spectral fact): the below-threshold bound state is
a kernel-checked eigenvalue computation, no hand-inserted defect.

Grade **C** (the physical *hadron* identification is a claim, not earned here):
the interaction `V` is *modelled* on the carrier's closure strength `κ` (its
scale is `κ`, matching the block-level binding defect `Δ = -κ`), but its
attractive *form* (a single off-diagonal coupling) is inserted, not derived from
the carrier's closure geometry.
So this is an honest finite witness that "an attractive interaction of the
closure scale produces a bound state below threshold", and NOT yet a first-
principles derivation of a hadron mass from the null-transport geometry.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody

/-! ## The two-particle sector types -/

/-- The free two-body energies of the three pairs (the diagonal of the free
`dΓ(B)|_{Λ²}`): index `0 ↔ {0,1}`, `1 ↔ {0,2}`, `2 ↔ {1,2}`. -/
def pairEnergy (d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![d 0 + d 1, d 0 + d 2, d 1 + d 2]

/-- The free two-body Hamiltonian `dΓ(B)|_{Λ²}`: diagonal in the pair basis. -/
def freeH2 (d : Fin 3 → ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  Matrix.diagonal (pairEnergy d)

/-- The attractive interaction `V`: a real-symmetric single off-diagonal coupling
of strength `κ` between the two lowest pairs `{0,1}` (index `0`) and `{0,2}`
(index `1`), which share the lowest mode `0`. -/
def interaction (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![0, -kappa, 0; -kappa, 0, 0; 0, 0, 0]

/-- The interacting two-body Hamiltonian `H₂ = dΓ(B)|_{Λ²} + V`. -/
def H2 (d : Fin 3 → ℝ) (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  freeH2 d + interaction kappa

/-- The free two-body threshold `min_{i≠j}(d i + d j)`: the minimum over the
three pair energies. -/
def pairThreshold (d : Fin 3 → ℝ) : ℝ :=
  min (d 0 + d 1) (min (d 0 + d 2) (d 1 + d 2))

/-- The (real) spectrum of `H₂`: the set of eigenvalues, i.e. scalars `μ` with a
nonzero eigenvector `v` satisfying `H₂ v = μ v`. -/
def spectrum2 (d : Fin 3 → ℝ) (kappa : ℝ) : Set ℝ :=
  {μ | ∃ v : Fin 3 → ℝ, v ≠ 0 ∧ (H2 d kappa).mulVec v = μ • v}

/-- The discriminant `(a-c)²/4 + κ²` of the attractive `2×2` block, with
`a = d0+d1`, `c = d0+d2`. -/
noncomputable def discr (d : Fin 3 → ℝ) (kappa : ℝ) : ℝ :=
  ((d 0 + d 1) - (d 0 + d 2)) ^ 2 / 4 + kappa ^ 2

/-- The least eigenvalue of `H₂`: the smaller root
`(a+c)/2 - sqrt((a-c)²/4 + κ²)` of the attractive `2×2` block. -/
noncomputable def boundEnergy (d : Fin 3 → ℝ) (kappa : ℝ) : ℝ :=
  ((d 0 + d 1) + (d 0 + d 2)) / 2 - Real.sqrt (discr d kappa)

/-! ## The interaction is Hermitian -/

/-
`V` is real-symmetric, hence Hermitian.
-/
theorem interaction_isHermitian (kappa : ℝ) : (interaction kappa).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ interaction ] ;

/-- `H₂` is Hermitian. -/
theorem H2_isHermitian (d : Fin 3 → ℝ) (kappa : ℝ) : (H2 d kappa).IsHermitian := by
  convert Matrix.IsHermitian.add (Matrix.isHermitian_diagonal _) (interaction_isHermitian kappa) using 1

/-! ## Key algebraic identity for the least eigenvalue -/

/-
The discriminant is nonnegative.
-/
theorem discr_nonneg (d : Fin 3 → ℝ) (kappa : ℝ) : 0 ≤ discr d kappa := by
  exact add_nonneg ( div_nonneg ( sq_nonneg _ ) zero_le_four ) ( sq_nonneg _ )

/-
The defining quadratic relation of the least eigenvalue: with `a = d0+d1`,
`c = d0+d2`, `boundEnergy` satisfies `(a - μ)(c - μ) = κ²`.
-/
theorem boundEnergy_key (d : Fin 3 → ℝ) (kappa : ℝ) :
    ((d 0 + d 1) - boundEnergy d kappa) * ((d 0 + d 2) - boundEnergy d kappa)
      = kappa ^ 2 := by
  unfold boundEnergy;
  unfold discr; nlinarith [ Real.mul_self_sqrt ( show 0 ≤ ( d 0 + d 1 - ( d 0 + d 2 ) ) ^ 2 / 4 + kappa ^ 2 by positivity ) ] ;

/-! ## The bound state: `boundEnergy` is an eigenvalue of `H₂` -/

/-- The explicit eigenvector of `H₂` for the eigenvalue `boundEnergy`, living in
the `2×2` attractive block (third component `0`). -/
noncomputable def boundVector (d : Fin 3 → ℝ) (kappa : ℝ) : Fin 3 → ℝ :=
  ![-kappa, boundEnergy d kappa - (d 0 + d 1), 0]

/-- `boundEnergy` is an eigenvalue of `H₂` (a genuine bound state): the explicit
eigenvector `boundVector` is nonzero and satisfies `H₂ v = boundEnergy • v`. -/
theorem boundEnergy_mem_spectrum (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa) :
    boundEnergy d kappa ∈ spectrum2 d kappa := by
  use ![-kappa, boundEnergy d kappa - (d 0 + d 1), 0]
  refine ⟨ne_of_apply_ne (fun v => v 0) (by norm_num; linarith), ?_⟩
  ext i; fin_cases i <;> norm_num [H2, freeH2, interaction, Matrix.mulVec]
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]; ring
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]
    have := boundEnergy_key d kappa; norm_num [discr] at this; nlinarith
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]

/-! ## `boundEnergy` is the least eigenvalue -/

/-- Any eigenvalue of `H₂` is at least `boundEnergy`: from `H₂ v = μ v` with
`v ≠ 0` we get `det (H₂ - μ) = 0`, whose factorisation forces `μ = d1+d2` or
`(a-μ)(c-μ) = κ²`; in both cases `μ ≥ boundEnergy`. -/
theorem boundEnergy_lower_bound (d : Fin 3 → ℝ) (kappa : ℝ)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2)
    (μ : ℝ) (hμ : μ ∈ spectrum2 d kappa) : boundEnergy d kappa ≤ μ := by
  set a := d 0 + d 1
  set c := d 0 + d 2
  have h_quad : (a - μ) * (c - μ) = kappa ^ 2 ∨ μ = d 1 + d 2 := by
    obtain ⟨v, hv_ne_zero, hv_eq⟩ := hμ
    have h_det : Matrix.det (Matrix.diagonal (pairEnergy d) + interaction kappa
        - Matrix.diagonal (fun _ => μ)) = 0 := by
      rw [← Matrix.exists_mulVec_eq_zero_iff]
      simp_all +decide [H2, Matrix.sub_mulVec]
      exact ⟨v, hv_ne_zero, sub_eq_zero.mpr hv_eq⟩
    simp_all +decide [Matrix.det_fin_three, pairEnergy, interaction]
    exact Classical.or_iff_not_imp_right.2 fun h =>
      mul_left_cancel₀ (sub_ne_zero_of_ne h) <| by linarith
  cases' h_quad with h_quad h_quad <;> simp_all +decide [boundEnergy, discr]
  · nlinarith [Real.sqrt_nonneg ((d 1 - d 2) ^ 2 / 4 + kappa ^ 2),
      Real.mul_self_sqrt (by positivity : 0 ≤ (d 1 - d 2) ^ 2 / 4 + kappa ^ 2)]
  · nlinarith [Real.sqrt_nonneg ((d 1 - d 2) ^ 2 / 4 + kappa ^ 2)]

/-- `boundEnergy` is the least eigenvalue of `H₂`. -/
theorem boundEnergy_isLeast (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrum2 d kappa) (boundEnergy d kappa) :=
  ⟨boundEnergy_mem_spectrum d kappa hk,
    fun _ hμ => boundEnergy_lower_bound d kappa h01 h12 _ hμ⟩

/-! ## The least eigenvalue is strictly below the free threshold -/

/-
The free threshold of the sorted spectrum is the lowest pair energy.
-/
theorem pairThreshold_eq (d : Fin 3 → ℝ) (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    pairThreshold d = d 0 + d 1 := by
  exact min_eq_left ( by cases min_cases ( d 0 + d 2 ) ( d 1 + d 2 ) <;> linarith )

/-- The strict below-threshold bound: the least eigenvalue dips strictly below
the free threshold exactly because `κ > 0`. -/
theorem boundEnergy_lt_pairThreshold (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    boundEnergy d kappa < pairThreshold d := by
  unfold boundEnergy pairThreshold
  rw [min_def, min_def]
  split_ifs <;>
    nlinarith [Real.sqrt_nonneg (discr d kappa),
      Real.mul_self_sqrt (show 0 ≤ discr d kappa by
        exact add_nonneg (div_nonneg (sq_nonneg _) zero_le_four) (sq_nonneg _)),
      show 0 < kappa ^ 2 by positivity,
      show discr d kappa > (d 1 - d 2) ^ 2 / 4 by unfold discr; nlinarith]

/-! ## The flagship theorem -/

/-- **A finite interacting two-body bound state strictly below threshold.**

For a sorted one-particle spectrum `d 0 ≤ d 1 ≤ d 2` and attractive closure
strength `κ > 0`, the interacting two-body Hamiltonian `H₂ = dΓ(B)|_{Λ²} + V`
has least eigenvalue `boundEnergy d κ` (an `IsLeast` of its spectrum) lying
*strictly below* the free two-body threshold `min_{i≠j}(d i + d j)`.

This is a genuine finite bound state below the sum of the constituents: the mass
of the two-body state is strictly less than `d i + d j`, and the strictness is
driven exactly by the attractive interaction `κ > 0`. -/
theorem interacting_boundState_below_threshold
    (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrum2 d kappa) (boundEnergy d kappa) ∧
      boundEnergy d kappa < pairThreshold d :=
  ⟨boundEnergy_isLeast d kappa hk h01 h12,
    boundEnergy_lt_pairThreshold d kappa hk h01 h12⟩

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody.interacting_boundState_below_threshold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms interacting_boundState_below_threshold

end PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody
