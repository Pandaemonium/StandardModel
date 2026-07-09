import Mathlib

open scoped BigOperators
open scoped Classical
open scoped ComplexConjugate ComplexOrder

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace SuiteB_PathSum

open Matrix Complex

/-!
# Suite B rung B1 — path-sum semantics: mass is retained which-direction information

A finite family of unit "direction states" `psi h : ℂ²` (points on the Bloch/
celestial sphere) with complex amplitudes `a h`, glued by a Hermitian PSD
"hidden-history coherence" kernel `Om : H → H → ℂ` with unit diagonal, produces the
path-conditioned visible direction density operator

  `rhoDir a psi Om = ∑_{h,h'} a h * conj (a h') * Om h h' • |psi h⟩⟨psi h'|`.

See `ARISTOTLE_SUMMARY.md` for the honest normalization note on
`mass² = det rhoDir`.
-/

/-- Outer product `|u⟩⟨v|`: the rank-≤1 matrix with entries `u i * conj (v j)`. -/
noncomputable def outer (u v : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of (fun i j => u i * conj (v j))

@[simp] lemma outer_apply (u v : Fin 2 → ℂ) (i j : Fin 2) :
    outer u v i j = u i * conj (v j) := rfl

/-- The path-conditioned visible direction density operator. -/
noncomputable def rhoDir {H : Type*} [Fintype H]
    (a : H → ℂ) (psi : H → Fin 2 → ℂ) (Om : H → H → ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ h, ∑ h', (a h * conj (a h') * Om h h') • outer (psi h) (psi h')

/-- The fully-decohered (identity / Kronecker) coherence kernel. -/
def deltaKer {H : Type*} [DecidableEq H] : H → H → ℂ := fun h h' => if h = h' then 1 else 0

/-- The fully-coherent (all-ones) coherence kernel. -/
def onesKer {H : Type*} : H → H → ℂ := fun _ _ => 1

/-- 2×2 Plücker / wedge determinant `det[u v] = u₀ v₁ - u₁ v₀`.
`|u ∧ v|² = normSq (wedge u v)` is the squared area of the parallelogram. -/
noncomputable def wedge (u v : Fin 2 → ℂ) : ℂ := u 0 * v 1 - u 1 * v 0

/-- The coherent superposition vector `Ψ = ∑_h a h • psi h`. -/
noncomputable def Psi {H : Type*} [Fintype H] (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    Fin 2 → ℂ := fun i => ∑ h, a h * psi h i

/-- The one-parameter coherence family `Om_t = (1-t)·ones + t·delta` on two histories. -/
noncomputable def OmegaT (t : ℝ) : Fin 2 → Fin 2 → ℂ :=
  fun h h' => if h = h' then 1 else (1 - (t : ℂ))

variable {H : Type*} [Fintype H]

/--
The conjugate-transpose swaps the arguments of an outer product.
-/
theorem outer_conjTranspose (u v : Fin 2 → ℂ) : (outer u v)ᴴ = outer v u := by
  ext i j; simp +decide [ outer_apply, mul_comm ] ;

/-! ## Target 1 : `rhoDir` is a Hermitian PSD operator. -/

/--
`rhoDir` is Hermitian whenever the coherence kernel is Hermitian.
-/
theorem rho_dir_hermitian (a : H → ℂ) (psi : H → Fin 2 → ℂ) (Om : H → H → ℂ)
    (hOm : ∀ h h', conj (Om h h') = Om h' h) :
    (rhoDir a psi Om).IsHermitian := by
  ext i j; simp +decide [ *, rhoDir ] ; ring;
  simp +decide [ Matrix.sum_apply, outer_apply ];
  rw [ ← Finset.sum_comm ] ; congr ; ext ; congr ; ext ; simp +decide [ *, mul_assoc, mul_comm, mul_left_comm ] ;

/--
`rhoDir` is positive-semidefinite whenever the coherence kernel is Hermitian and PSD.
-/
theorem rho_dir_psd (a : H → ℂ) (psi : H → Fin 2 → ℂ) (Om : H → H → ℂ)
    (hOm : ∀ h h', conj (Om h h') = Om h' h)
    (hpsd : ∀ z : H → ℂ, (0 : ℂ) ≤ ∑ h, ∑ h', conj (z h) * Om h h' * z h') :
    (rhoDir a psi Om).PosSemidef := by
  refine' ⟨ rho_dir_hermitian a psi Om hOm, fun x => _ ⟩;
  -- Let $A(h) = \sum_{i} \overline{x_i} \psi_h(i)$.
  set A : H → ℂ := fun h => ∑ i, star (x i) * psi h i;
  convert hpsd ( fun h => conj ( a h * A h ) ) using 1;
  simp +decide [ rhoDir, Matrix.sum_apply, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_comm, mul_left_comm, A ];
  simp +decide [ Finsupp.sum_fintype, Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ]

/--
General trace formula: `tr rhoDir = ∑_{h,h'} a h conj(a h') Om h h' ⟨psi h'|psi h⟩`.
-/
theorem rho_dir_trace (a : H → ℂ) (psi : H → Fin 2 → ℂ) (Om : H → H → ℂ) :
    (rhoDir a psi Om).trace
      = ∑ h, ∑ h', a h * conj (a h') * Om h h' * (∑ i, conj (psi h' i) * psi h i) := by
  unfold rhoDir; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] ;
  simp +decide [ mul_comm, Matrix.trace ]

/--
In the decohered case `tr rhoDir = ∑_h |a h|² = 1`: a genuine density operator.
-/
theorem rho_dir_decohered_trace_one [DecidableEq H] (a : H → ℂ) (psi : H → Fin 2 → ℂ)
    (hpsi : ∀ h, ∑ i, conj (psi h i) * psi h i = 1)
    (ha : ∑ h, conj (a h) * a h = 1) :
    (rhoDir a psi (deltaKer)).trace = 1 := by
  convert ha using 1;
  rw [ rho_dir_trace ];
  simp +decide [ deltaKer, mul_assoc, mul_comm ];
  exact Finset.sum_congr rfl fun x _ => by rw [ show psi x 0 * ( starRingEnd ℂ ) ( psi x 0 ) + psi x 1 * ( starRingEnd ℂ ) ( psi x 1 ) = 1 by simpa [ mul_comm ] using hpsi x ] ; ring;

/-! ## Target 2 : coherent kernel gives a pure (massless) direction state. -/

/--
With the all-ones kernel, `rhoDir = |Ψ⟩⟨Ψ|`.
-/
theorem rhoDir_ones_eq_outer (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    rhoDir a psi (onesKer) = outer (Psi a psi) (Psi a psi) := by
  ext i j;
  simp +decide [ rhoDir, onesKer, outer ];
  simp +decide [ Psi, Matrix.sum_apply, Finset.sum_mul _ _ _ ];
  simp +decide only [mul_left_comm, mul_assoc, Finset.mul_sum _ _ _]

/--
**Coherent path sum is pure.** With the all-ones kernel `rhoDir = |Ψ⟩⟨Ψ|` is rank ≤ 1,
hence `det rhoDir = 0`: the fully coherent path sum carries no mass.
-/
theorem coherent_is_pure (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    rhoDir a psi (onesKer) = outer (Psi a psi) (Psi a psi)
      ∧ (rhoDir a psi (onesKer)).det = 0 := by
  refine ⟨rhoDir_ones_eq_outer a psi, ?_⟩
  rw [rhoDir_ones_eq_outer, Matrix.det_fin_two]
  simp only [outer_apply]
  ring

/--
Normalization-free purity: `tr(ρ²) = (tr ρ)²` for the coherent state.
-/
theorem coherent_purity (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    (rhoDir a psi (onesKer) * rhoDir a psi (onesKer)).trace
      = (rhoDir a psi (onesKer)).trace ^ 2 := by
  rw [ rhoDir_ones_eq_outer ];
  simp +decide [ Matrix.trace, Matrix.mul_apply, outer ] ; ring

/--
Linear entropy `S_lin = 1 - tr(ρ²) = 0` for the coherent state *once normalized*
(`tr ρ = 1`, i.e. `‖Ψ‖ = 1`).
-/
theorem coherent_linear_entropy_zero (a : H → ℂ) (psi : H → Fin 2 → ℂ)
    (hnorm : (rhoDir a psi (onesKer)).trace = 1) :
    1 - (rhoDir a psi (onesKer) * rhoDir a psi (onesKer)).trace = 0 := by
  rw [ coherent_purity, hnorm ] ; norm_num

/-! ## Target 3 : decohered mass equals which-direction disagreement. -/

/--
With the delta kernel, `rhoDir = ∑_h |a h|² |psi h⟩⟨psi h|`.
-/
theorem rhoDir_delta_eq [DecidableEq H] (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    rhoDir a psi (deltaKer)
      = ∑ h, ((normSq (a h) : ℝ) : ℂ) • outer (psi h) (psi h) := by
  unfold rhoDir; simp +decide [ deltaKer ] ;
  simp +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
  norm_cast

/--
Combinatorial pair-splitting: a double sum splits into diagonal and strict-upper pairs.
-/
theorem sum_pair_split {M : Type*} [AddCommMonoid M] [LinearOrder H] (G : H → H → M) :
    ∑ h, ∑ g, G h g
      = (∑ h, G h h)
        + ∑ p ∈ Finset.univ.filter (fun p : H × H => p.1 < p.2), (G p.1 p.2 + G p.2 p.1) := by
  -- Let's rewrite the double sum as a single sum over the product type.
  have h_sum_prod : ∑ h, ∑ g, G h g = ∑ p : H × H, G p.1 p.2 :=
    (Fintype.sum_prod_type' G).symm
  rw [ h_sum_prod, ← Finset.sum_add_sum_compl ];
  congr! 1;
  any_goals exact Finset.diag ( Finset.univ : Finset H );
  · refine' Finset.sum_bij ( fun x hx => x.1 ) _ _ _ _ <;> simp +decide;
  · rw [ show ( Finset.univ.diagᶜ : Finset ( H × H ) ) = Finset.filter ( fun p => p.1 < p.2 ) ( Finset.univ : Finset ( H × H ) ) ∪ Finset.filter ( fun p => p.2 < p.1 ) ( Finset.univ : Finset ( H × H ) ) from ?_, Finset.sum_union ];
    · rw [ Finset.sum_add_distrib ];
      refine' congr rfl ( Finset.sum_bij ( fun x hx => ( x.2, x.1 ) ) _ _ _ _ ) <;> simp +contextual;
    · exact Finset.disjoint_filter.mpr fun _ _ _ _ => lt_asymm ‹_› ‹_›;
    · ext ⟨x, y⟩; simp [Finset.mem_diag, Finset.mem_union, Finset.mem_filter]

/--
**Two-history anchor (closed form).** For `|H| = 2` the decohered determinant is exactly
the weighted pairwise null disagreement.
-/
theorem decohered_mass_two (a : Fin 2 → ℂ) (psi : Fin 2 → Fin 2 → ℂ) :
    (rhoDir a psi (deltaKer)).det
      = ((normSq (a 0) * normSq (a 1) * normSq (wedge (psi 0) (psi 1)) : ℝ) : ℂ) := by
  have key : ∀ z : ℂ, ((normSq z : ℝ) : ℂ) = z * conj z := fun z => (Complex.mul_conj z).symm
  rw [rhoDir_delta_eq, Fin.sum_univ_two, Matrix.det_fin_two]
  simp only [Matrix.add_apply, Matrix.smul_apply, outer_apply, smul_eq_mul]
  push_cast
  simp only [key]
  unfold wedge
  simp only [map_sub, map_mul]
  ring

/--
**General decohered disagreement identity.** For any finite family,
`det rhoDir = ∑_{h < h'} |a h|² |a h'|² |psi h ∧ psi h'|²`.
-/
theorem decohered_mass_eq_disagreement [DecidableEq H] [LinearOrder H]
    (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    (rhoDir a psi (deltaKer)).det
      = ∑ p ∈ Finset.univ.filter (fun p : H × H => p.1 < p.2),
          ((normSq (a p.1) * normSq (a p.2) * normSq (wedge (psi p.1) (psi p.2)) : ℝ) : ℂ) := by
  have h_det : (rhoDir a psi deltaKer).det = ∑ h, ∑ g, ((normSq (a h) * normSq (a g) : ℝ) : ℂ) * ((psi h 0 * conj (psi h 0) * (psi g 1 * conj (psi g 1)) - psi h 0 * conj (psi h 1) * (psi g 1 * conj (psi g 0))) : ℂ) := by
    rw [ rhoDir_delta_eq ];
    simp +decide [ outer, Matrix.det_fin_two ];
    simp +decide [ Matrix.sum_apply, Finset.sum_mul _ _ _, mul_assoc, mul_sub ];
    simp +decide only [mul_left_comm, Finset.mul_sum _ _ _];
  rw [h_det, sum_pair_split]
  have hz : (∑ h : H, ((normSq (a h) * normSq (a h) : ℝ) : ℂ) *
      (psi h 0 * conj (psi h 0) * (psi h 1 * conj (psi h 1)) -
        psi h 0 * conj (psi h 1) * (psi h 1 * conj (psi h 0)))) = 0 :=
    Finset.sum_eq_zero fun h _ => by ring
  rw [hz, zero_add]
  refine Finset.sum_congr rfl fun p _ => ?_
  have key : ((normSq (wedge (psi p.1) (psi p.2)) : ℝ) : ℂ)
      = wedge (psi p.1) (psi p.2) * conj (wedge (psi p.1) (psi p.2)) := (Complex.mul_conj _).symm
  push_cast
  rw [key]
  unfold wedge
  simp only [map_sub, map_mul]
  ring

/-! ## Target 4 : mass is monotone in decoherence (two histories). -/

/--
Closed form of the determinant along the coherence family: `det ρ(t) = t(2-t)·D`,
with `D = |a₀|²|a₁|²|psi₀ ∧ psi₁|² ≥ 0`.
-/
theorem decohered_family_det (a : Fin 2 → ℂ) (psi : Fin 2 → Fin 2 → ℂ) (t : ℝ) :
    (rhoDir a psi (OmegaT t)).det
      = (((t * (2 - t)) *
          (normSq (a 0) * normSq (a 1) * normSq (wedge (psi 0) (psi 1)))) : ℝ) := by
  have key : ∀ z : ℂ, ((normSq z : ℝ) : ℂ) = z * conj z := fun z => (Complex.mul_conj z).symm
  simp only [rhoDir, Fin.sum_univ_two, OmegaT, Matrix.det_fin_two,
    Matrix.add_apply, Matrix.smul_apply, outer_apply, smul_eq_mul, reduceIte]
  push_cast
  rw [key, key, key]
  unfold wedge
  simp only [map_sub, map_mul]
  ring

/--
**Decohering can only create mass.** Along `Om_t = (1-t)·ones + t·delta` the determinant
`det ρ(t)` vanishes at `t = 0` (coherence hides mass) and is monotone nondecreasing on `[0,1]`.
-/
theorem mass_monotone_in_decoherence (a : Fin 2 → ℂ) (psi : Fin 2 → Fin 2 → ℂ) :
    (rhoDir a psi (OmegaT 0)).det = 0
      ∧ MonotoneOn (fun t => (rhoDir a psi (OmegaT t)).det.re) (Set.Icc (0 : ℝ) 1) := by
  constructor;
  · convert decohered_family_det a psi 0 using 1;
    norm_num;
  · intro t ht u hu htu; simp_all +decide [ decohered_family_det ] ;
    exact mul_le_mul_of_nonneg_right ( by nlinarith ) ( mul_nonneg ( mul_nonneg ( normSq_nonneg _ ) ( normSq_nonneg _ ) ) ( normSq_nonneg _ ) )

/-! ## Mandatory non-degeneracy witness. -/

/-- Witness amplitudes: `a₀ = a₁ = ½ + ½i`, so `|a₀|² = |a₁|² = ½` and `∑|a h|² = 1`. -/
noncomputable def witnessA : Fin 2 → ℂ := fun _ => ⟨1/2, 1/2⟩

/-- Witness directions: `psi₀ = (1,0)`, `psi₁ = (3/5, 4/5)` — unit vectors, non-collinear. -/
noncomputable def witnessPsi : Fin 2 → Fin 2 → ℂ := ![![1, 0], ![3/5, 4/5]]

/--
The witness directions are non-collinear: their wedge is nonzero (`= 4/5`).
-/
theorem witness_wedge_ne_zero : wedge (witnessPsi 0) (witnessPsi 1) ≠ 0 := by
  unfold wedge; norm_num [ witnessPsi ] ;

/--
**Non-degeneracy fixture.** On the explicit non-collinear rational witness the decohered
determinant is the specific nonzero rational value `det rhoDir = 4/25`.
-/
theorem witness_decohered_det :
    (rhoDir witnessA witnessPsi (deltaKer)).det = ((4 / 25 : ℝ) : ℂ) := by
  convert decohered_mass_two witnessA witnessPsi using 1;
  norm_num [ Complex.normSq, Complex.ext_iff, witnessA, witnessPsi, wedge ]

/-! ## Kernel-checked axiom footprints of the headline theorems.
Each depends only on `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'SuiteB_PathSum.rho_dir_hermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rho_dir_hermitian

/-- info: 'SuiteB_PathSum.rho_dir_psd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rho_dir_psd

/-- info: 'SuiteB_PathSum.rho_dir_decohered_trace_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rho_dir_decohered_trace_one

/-- info: 'SuiteB_PathSum.coherent_is_pure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coherent_is_pure

/-- info: 'SuiteB_PathSum.coherent_linear_entropy_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coherent_linear_entropy_zero

/-- info: 'SuiteB_PathSum.decohered_mass_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms decohered_mass_two

/-- info: 'SuiteB_PathSum.decohered_mass_eq_disagreement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms decohered_mass_eq_disagreement

/-- info: 'SuiteB_PathSum.mass_monotone_in_decoherence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_monotone_in_decoherence

/-- info: 'SuiteB_PathSum.witness_decohered_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_decohered_det

end SuiteB_PathSum
