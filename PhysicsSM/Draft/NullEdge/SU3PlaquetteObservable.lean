import Mathlib

/-!
# SU(3) plaquette observable (Opus, verified Aristotle 66995720)

The GAUGE-INVARIANT OBSERVABLE half of the A3 composite-mass bridge - the weakest
mass gate. Contents: an explicit endpoint convention (U1: 0->1, U2: 1->2, U3: 3->2,
U4: 0->3, the last two traversed via star); gauge covariance P -> g0 P (star g0);
gauge INVARIANCE of W = Re(trace P); nonconstancy by explicit configurations
(identity links give W = 3, one link diag(-1,-1,1) gives W = -1); the bound |W| <= 3
with the sharp characterization |W| = 3 iff P = 1 (excluding -I via det = 1); and
CENTER BLINDNESS - multiplying every link by a central element leaves P and W
unchanged, since the two forward center factors cancel the two starred ones
(explicit scalar version for z = omega I with omega^3 = 1).

SCOPE - DO NOT PAIR WITHOUT PROOF: this is the observable half ONLY. Transfer-
operator positivity and the existence of a spectral gap are NOT proved here and are
NOT to be asserted alongside it. `A3TransferPositivity` (job e8f3f87b) treats
positivity separately and shows positivity does not bound the gap, nor the gap fix
the projector. An A3 composite-mass claim needs the observable, the positivity, the
gap, AND their linkage - four items, of which this module supplies one.

Namespace kept as the prover's SU3Plaquette. Provenance: verified at pin from task
b2f14653. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace SU3Plaquette

abbrev SU3 := Matrix.specialUnitaryGroup (Fin 3) ℂ

/-- The oriented boundary is `0 → 1 → 2 → 3 → 0`.
`U₁ : 0 → 1`, `U₂ : 1 → 2`, while `U₃ : 3 → 2` and `U₄ : 0 → 3`;
thus the last two boundary edges are traversed using their stars. -/
def plaquette (U₁ U₂ U₃ U₄ : SU3) : SU3 := U₁ * U₂ * star U₃ * star U₄

/-- The (unnormalized) real Wilson plaquette observable. -/
noncomputable def wilson (U₁ U₂ U₃ U₄ : SU3) : ℝ :=
  ((plaquette U₁ U₂ U₃ U₄ : Matrix (Fin 3) (Fin 3) ℂ).trace).re

/-- Endpoint gauge action on a link `x → y`. -/
def gaugeLink (gₓ gᵧ U : SU3) : SU3 := gₓ * U * star gᵧ

/-
With the endpoint convention documented on `plaquette`, all internal gauge
factors cancel and only conjugation at vertex `0` remains.
-/
theorem plaquette_gauge_conjugation
    (g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄ : SU3) :
    plaquette (gaugeLink g₀ g₁ U₁) (gaugeLink g₁ g₂ U₂)
      (gaugeLink g₃ g₂ U₃) (gaugeLink g₀ g₃ U₄) =
      g₀ * plaquette U₁ U₂ U₃ U₄ * star g₀ := by
  unfold plaquette gaugeLink;
  simp +decide [ mul_assoc, Subtype.ext_iff ];
  have := g₁.2.1; have := g₂.2.1; have := g₃.2.1; simp_all +decide [← mul_assoc] ;

/-
The real trace is invariant under the endpoint gauge action.
-/
theorem wilson_gauge_invariant
    (g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄ : SU3) :
    wilson (gaugeLink g₀ g₁ U₁) (gaugeLink g₁ g₂ U₂)
      (gaugeLink g₃ g₂ U₃) (gaugeLink g₀ g₃ U₄) =
      wilson U₁ U₂ U₃ U₄ := by
  -- By expanding the expression using the definition of `plaquette`, we can simplify it.
  have h_expand : ∀ (g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄ : SU3), (plaquette (gaugeLink g₀ g₁ U₁) (gaugeLink g₁ g₂ U₂) (gaugeLink g₃ g₂ U₃) (gaugeLink g₀ g₃ U₄) : Matrix (Fin 3) (Fin 3) ℂ) = g₀ * (plaquette U₁ U₂ U₃ U₄ : Matrix (Fin 3) (Fin 3) ℂ) * star g₀ := by
    intros g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄
    apply congr_arg Subtype.val (plaquette_gauge_conjugation g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄);
  -- By the properties of the trace and the unitary group, we know that $\text{trace}(g₀ * P * star g₀) = \text{trace}(P)$ for any unitary matrix $g₀$ and any matrix $P$.
  have h_trace_unitary : ∀ (g₀ : Matrix (Fin 3) (Fin 3) ℂ) (P : Matrix (Fin 3) (Fin 3) ℂ), g₀ * star g₀ = 1 → Matrix.trace (g₀ * P * star g₀) = Matrix.trace P := by
    intros g₀ P hg₀; rw [ ← Matrix.trace_mul_comm ] ; simp +decide [← mul_assoc] ;
    rw [ mul_eq_one_comm.mp hg₀, one_mul ];
  convert congr_arg Complex.re ( h_trace_unitary g₀ ( plaquette U₁ U₂ U₃ U₄ ) _ ) using 1;
  · convert congr_arg Complex.re ( congr_arg Matrix.trace ( h_expand g₀ g₁ g₂ g₃ U₁ U₂ U₃ U₄ ) ) using 1;
  · exact g₀.2.1.2

/-- A concrete nonidentity element `diag(-1,-1,1)` of `SU(3)`. -/
def signDiagonal : SU3 := by
  refine ⟨Matrix.diagonal ![-1, -1, 1], ?_⟩
  rw [Matrix.mem_specialUnitaryGroup_iff, Matrix.mem_unitaryGroup_iff]
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, Matrix.diagonal]
  · rw [Matrix.det_diagonal]
    norm_num [Fin.prod_univ_succ]

/-
The trivial configuration has Wilson observable `3`.
-/
theorem wilson_trivial : wilson 1 1 1 1 = 3 := by
  -- By definition of $wilson$, we have $wilson(1, 1, 1, 1) = \text{trace}(1 * 1 * 1 * 1) = \text{trace}(1) = 3$. Hence, the base case holds. We can use the fact that the trace of the identity matrix is 3.
  simp [wilson, plaquette]

/-
Putting `diag(-1,-1,1)` on one link gives Wilson observable `-1`.
-/
theorem wilson_signDiagonal : wilson signDiagonal 1 1 1 = -1 := by
  convert congr_arg Complex.re ( congr_arg Matrix.trace ( show ( signDiagonal : Matrix ( Fin 3 ) ( Fin 3 ) ℂ ) = Matrix.diagonal ![ -1, -1, 1 ] from ?_ ) ) using 1;
  · unfold wilson plaquette; norm_num;
  · norm_num [ Fin.sum_univ_succ ];
  · rfl

/-
In particular, the Wilson observable is not constant.
-/
theorem wilson_nonconstant :
    wilson (1 : SU3) 1 1 1 ≠ wilson signDiagonal 1 1 1 := by
  rw [ wilson_trivial, wilson_signDiagonal ] ; norm_num

/-
The real trace of an `SU(3)` matrix has absolute value at most three.
-/
theorem abs_re_trace_le_three (P : SU3) :
    |((P : Matrix (Fin 3) (Fin 3) ℂ).trace).re| ≤ 3 := by
  have h_unitary : P.val * star P.val = 1 := by
    convert P.2.1.2 using 1;
  -- Each diagonal entry of the unitary matrix P has complex norm <= 1 by `entry_norm_bound_of_unitary`.
  have h_norm : ∀ i : Fin 3, Complex.normSq (P.val i i) ≤ 1 := by
    intro i;
    have := congr_fun ( congr_fun h_unitary i ) i; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ;
    exact this.1 ▸ Finset.single_le_sum ( fun x _ => add_nonneg ( mul_self_nonneg ( P.val i x |> Complex.re ) ) ( mul_self_nonneg ( P.val i x |> Complex.im ) ) ) ( Finset.mem_univ i ) |> le_trans ( by simp +decide [Complex.normSq_apply] );
  exact le_trans ( Complex.abs_re_le_norm _ ) ( by simpa [ Matrix.trace ] using le_trans ( norm_sum_le _ _ ) ( le_trans ( Finset.sum_le_sum fun i _ => Real.sqrt_le_sqrt ( h_norm i ) ) ( by norm_num ) ) )

/-
Saturation of the absolute real-trace bound occurs only at the identity.
-/
theorem abs_re_trace_eq_three_iff (P : SU3) :
    |((P : Matrix (Fin 3) (Fin 3) ℂ).trace).re| = 3 ↔ P = 1 := by
  constructor;
  · intro hP
    have h_diag : ∀ i : Fin 3, P.val i i = 1 ∨ P.val i i = -1 := by
      have h_diag : ∀ i : Fin 3, Complex.re (P.val i i) = 1 ∨ Complex.re (P.val i i) = -1 := by
        have h_diag : ∀ i : Fin 3, -1 ≤ Complex.re (P.val i i) ∧ Complex.re (P.val i i) ≤ 1 := by
          have h_unitary : P.val * star P.val = 1 := by
            have := P.2.1.2; aesop;
          intro i
          have := congr_fun ( congr_fun h_unitary i ) i
          simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ];
          constructor <;> nlinarith only [ this.1 ▸ Finset.single_le_sum ( fun x _ => add_nonneg ( mul_self_nonneg ( P.val i x |> Complex.re ) ) ( mul_self_nonneg ( P.val i x |> Complex.im ) ) ) ( Finset.mem_univ i ) ];
        simp_all +decide [ Fin.sum_univ_three, Matrix.trace ];
        intro i; fin_cases i <;> cases abs_cases ( ( P.val 0 0 |> Complex.re ) + ( P.val 1 1 |> Complex.re ) + ( P.val 2 2 |> Complex.re ) ) <;> first | left; linarith! [ h_diag 0, h_diag 1, h_diag 2 ] | right; linarith! [ h_diag 0, h_diag 1, h_diag 2 ] ;
      have h_unitary : P.val * star P.val = 1 := by
        exact P.2.1.2;
      intro i; specialize h_diag i; specialize h_unitary; replace h_unitary := congr_fun ( congr_fun h_unitary i ) i; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ;
      rw [ Finset.sum_eq_add_sum_diff_singleton ( Finset.mem_univ i ) ] at h_unitary;
      cases h_diag <;> [ left; right ] <;> constructor <;> nlinarith [ show 0 ≤ ∑ x ∈ Finset.univ \ { i }, ( ( P.val i x |> Complex.re ) * ( P.val i x |> Complex.re ) + ( P.val i x |> Complex.im ) * ( P.val i x |> Complex.im ) ) from Finset.sum_nonneg fun _ _ => add_nonneg ( mul_self_nonneg _ ) ( mul_self_nonneg _ ) ];
    -- Since $P$ is unitary, we have $P * P^* = I$. This implies that the off-diagonal entries of $P$ must be zero.
    have h_off_diag : ∀ i j : Fin 3, i ≠ j → P.val i j = 0 := by
      intro i j hij
      have h_unitary : P.val * star P.val = 1 := by
        convert P.2.1.2 using 1;
      replace h_unitary := congr_fun ( congr_fun h_unitary i ) i; simp_all +decide [Matrix.mul_apply] ;
      simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
      rw [ Finset.sum_eq_add_sum_diff_singleton ( Finset.mem_univ i ) ] at h_unitary;
      exact norm_eq_zero.mp ( by norm_cast at h_unitary; nlinarith [ show 0 ≤ ∑ x ∈ Finset.univ \ { i }, ‖P.val i x‖ ^ 2 from Finset.sum_nonneg fun _ _ => sq_nonneg _, show ‖P.val i j‖ ^ 2 ≤ ∑ x ∈ Finset.univ \ { i }, ‖P.val i x‖ ^ 2 from Finset.single_le_sum ( fun x _ => sq_nonneg ( ‖P.val i x‖ ) ) ( by aesop ), show ‖P.val i i‖ ^ 2 = 1 from by cases h_diag i <;> aesop ] );
    -- Since $P$ is unitary and all its off-diagonal entries are zero, $P$ must be a diagonal matrix.
    have h_diag_matrix : P.val = Matrix.diagonal (fun i => P.val i i) := by
      ext i j; by_cases hij : i = j <;> aesop;
    -- Since $P$ is unitary and all its off-diagonal entries are zero, $P$ must be a diagonal matrix with entries $\pm 1$.
    have h_diag_entries : P.val 0 0 = 1 ∧ P.val 1 1 = 1 ∧ P.val 2 2 = 1 ∨ P.val 0 0 = -1 ∧ P.val 1 1 = -1 ∧ P.val 2 2 = -1 := by
      rcases h_diag 0 with ha | ha <;> rcases h_diag 1 with hb | hb <;> rcases h_diag 2 with hc | hc <;> norm_num [ ha, hb, hc ] at hP ⊢;
      all_goals rw [ h_diag_matrix ] at hP; norm_num [ Fin.sum_univ_three, Matrix.trace, ha, hb, hc ] at hP;
    rcases h_diag_entries with h | h <;> norm_num [ h ] at h_diag_matrix ⊢;
    · exact Subtype.ext <| h_diag_matrix.trans <| by ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ h ] ;
    · have := P.2.2; norm_num [ h, Matrix.det_fin_three ] at this;
      grind +suggestions;
  · rintro rfl; norm_num [ Matrix.trace ] ;

/-
The requested Wilson bound.
-/
theorem wilson_abs_le_three (U₁ U₂ U₃ U₄ : SU3) :
    |wilson U₁ U₂ U₃ U₄| ≤ 3 := by
  convert abs_re_trace_le_three ( plaquette U₁ U₂ U₃ U₄ ) using 1

/-
Equality in the Wilson bound characterizes trivial plaquette holonomy.
-/
theorem wilson_abs_eq_three_iff (U₁ U₂ U₃ U₄ : SU3) :
    |wilson U₁ U₂ U₃ U₄| = 3 ↔ plaquette U₁ U₂ U₃ U₄ = 1 := by
  convert abs_re_trace_eq_three_iff ( plaquette U₁ U₂ U₃ U₄ ) using 1

/-- Multiplication of every link by the same central element. -/
def centerLink (z U : SU3) : SU3 := z * U

/-
A central transformation is invisible to the plaquette.  In particular this
applies to every scalar matrix `z = ω I` with `ω³ = 1`, i.e. every SU(3) center
element.
-/
theorem plaquette_center_blind (z : Subgroup.center SU3) (U₁ U₂ U₃ U₄ : SU3) :
    plaquette (centerLink z U₁) (centerLink z U₂)
      (centerLink z U₃) (centerLink z U₄) = plaquette U₁ U₂ U₃ U₄ := by
  unfold plaquette centerLink; simp_all +decide [mul_assoc] ;
  -- Since $z$ is in the center, we have $z * U = U * z$ for any $U \in SU(3)$.
  have h_comm : ∀ U : SU3, z * U = U * z := by
    exact fun U => z.2.comm U;
  have h_comm_star : star (z : SU3) * z = 1 := by
    have := z.1.2.1;
    exact Subtype.ext <| this.1;
  simp +decide only [h_comm];
  simp +decide [ mul_assoc, h_comm_star ];
  grind +suggestions

/-
Consequently the Wilson plaquette is center-blind.
-/
theorem wilson_center_blind (z : Subgroup.center SU3) (U₁ U₂ U₃ U₄ : SU3) :
    wilson (centerLink z U₁) (centerLink z U₂)
      (centerLink z U₃) (centerLink z U₄) = wilson U₁ U₂ U₃ U₄ := by
  unfold wilson; simp +decide [plaquette_center_blind] ;

/-
Explicit cube-root/scalar formulation of the SU(3) center action.  The
hypothesis `hz` says that the chosen `SU3` element is the scalar matrix `ω I`;
`hω` records `ω³ = 1`.  Multiplying all four links by it leaves the oriented
plaquette unchanged.  The cube-root equation states the requested center convention
explicitly; it is redundant once `z : SU3` and `hz` are given.
-/
theorem plaquette_cubeRoot_scalar_blind
    (ω : ℂ) (hω : ω ^ 3 = 1) (z : SU3)
    (hz : (z : Matrix (Fin 3) (Fin 3) ℂ) = Matrix.scalar (Fin 3) ω)
    (U₁ U₂ U₃ U₄ : SU3) :
    plaquette (centerLink z U₁) (centerLink z U₂)
      (centerLink z U₃) (centerLink z U₄) = plaquette U₁ U₂ U₃ U₄ := by
  have _cubeRootConvention := hω
  convert plaquette_center_blind ( ⟨ z, ?_ ⟩ : Subgroup.center SU3 ) U₁ U₂ U₃ U₄;
  simp +decide [Subgroup.mem_center_iff];
  intro a ha; ext i j; simp +decide [ hz, Matrix.mul_apply, Matrix.diagonal ] ;
  ring

/-
Hence the Wilson observable itself is unchanged by the explicit
`ω I`, `ω³ = 1` center action.
-/
theorem wilson_cubeRoot_scalar_blind
    (ω : ℂ) (hω : ω ^ 3 = 1) (z : SU3)
    (hz : (z : Matrix (Fin 3) (Fin 3) ℂ) = Matrix.scalar (Fin 3) ω)
    (U₁ U₂ U₃ U₄ : SU3) :
    wilson (centerLink z U₁) (centerLink z U₂)
      (centerLink z U₃) (centerLink z U₄) = wilson U₁ U₂ U₃ U₄ := by
  unfold wilson; simp +decide [plaquette_cubeRoot_scalar_blind ω hω z hz] ;

end SU3Plaquette
