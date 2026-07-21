import Mathlib

/-!
# MC5 composite assembly with explicit side conditions (Opus, verified da659200)

The honest MC5 assembly, stated so its hypotheses are visible rather than buried,
following the two structural audits (`MCBrickCompositionAudit`,
`ChangingCellReuseAudit`). Contents: Parseval for the finite counting-measure L2
norm; componentwiseLift_bound (a lattice-side S (x) id_E inherits the scalar bound
K unchanged); pointwise_unitary_isometry (one FIXED spinor-index isometry applied at
every lattice point preserves the L2 norm); and
componentwiseLift_then_unitary_bound - the composite retains EXACTLY K, no extra
factor.

NECESSITY: the unitarity hypothesis is load-bearing, not decorative -
`nonunitary_composite_fails` shows that on a one-point lattice the identity lattice
operator has bound K = 1 while composing its lift with spinor DOUBLING violates that
bound (doubling is not an isometry).

Reading for MC5: free componentwise lattice-side reuse + an ISOMETRIC fixed
spinor-side change inherits the scalar constant; drop the isometry and it fails.
Namespace kept as the prover's MC5. Provenance: verified at pin from task c6076210.
Standard three. Claim grade M, [comp]. -/

open scoped BigOperators

set_option autoImplicit false

namespace MC5

variable {𝕜 X ι E : Type*}
variable [RCLike 𝕜] [Fintype X] [Fintype ι]
variable [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]

/-- The counting-measure `L²` norm on a finite lattice. -/
noncomputable def l2Norm (f : X → E) : ℝ :=
  Real.sqrt (∑ x, ‖f x‖ ^ 2)

/-- Apply a scalar lattice operator independently to every coordinate of an
orthonormal basis.  Thus this is precisely the lattice-side operator `S ⊗ id_E`. -/
noncomputable def componentwiseLift (b : OrthonormalBasis ι 𝕜 E)
    (S : (X → 𝕜) → (X → 𝕜)) (f : X → E) : X → E :=
  fun x => ∑ i, S (fun y => (b.repr (f y)).ofLp i) x • b i

/-- A scalar `L²` operator bound, with its nonnegative constant explicit. -/
def HasL2Bound (S : (X → 𝕜) → (X → 𝕜)) (K : ℝ) : Prop :=
  0 ≤ K ∧ ∀ g, l2Norm (E := 𝕜) (S g) ≤ K * l2Norm (E := 𝕜) g

/-
Parseval for the finite counting-measure `L²` norm.
-/
lemma l2Norm_coordinates (b : OrthonormalBasis ι 𝕜 E) (f : X → E) :
    l2Norm f ^ 2 = ∑ i, l2Norm (E := 𝕜) (fun x => (b.repr (f x)).ofLp i) ^ 2 := by
  unfold l2Norm;
  rw [ Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ];
  have h_parseval : ∀ x, ∑ i, ‖(b.repr (f x)).ofLp i‖^2 = ‖f x‖^2 := by
    intro x
    have := OrthonormalBasis.sum_sq_norm_inner_left b (f x)
    simp_all +decide;
    convert this using 3 ; simp +decide [ b.repr_apply_apply ];
    rw [ ← inner_conj_symm, RCLike.norm_conj ];
  rw [ ← Finset.sum_congr rfl fun i _ => h_parseval i ];
  rw [ Finset.sum_comm, Finset.sum_congr rfl fun _ _ => Real.sq_sqrt <| Finset.sum_nonneg fun _ _ => sq_nonneg _ ]

/-
**Free componentwise lift.** A scalar lattice bound lifts with exactly the
same constant when the operator is `S ⊗ id_E`.
-/
theorem componentwiseLift_bound (b : OrthonormalBasis ι 𝕜 E)
    (S : (X → 𝕜) → (X → 𝕜)) {K : ℝ} (hS : HasL2Bound S K) (f : X → E) :
    l2Norm (componentwiseLift b S f) ≤ K * l2Norm f := by
  obtain ⟨hS_nonneg, hS_bound⟩ := hS;
  have h_l2norm : l2Norm (componentwiseLift b S f) ^ 2 = ∑ i, l2Norm (fun x => (b.repr (componentwiseLift b S f x)).ofLp i) ^ 2 := by
    exact l2Norm_coordinates b _;
  have h_component : ∀ x i, (b.repr (componentwiseLift b S f x)).ofLp i = S (fun x => (b.repr (f x)).ofLp i) x := by
    intro x i; simp +decide [ componentwiseLift ] ;
    simp +decide [ OrthonormalBasis.repr_apply_apply ];
    rw [ Finset.sum_eq_single i ] <;> simp +contextual;
    exact fun j hj => Or.inr ( b.orthonormal.2 ( Ne.symm hj ) );
  have h_final : l2Norm (componentwiseLift b S f) ^ 2 ≤ K ^ 2 * ∑ i, l2Norm (fun x => (b.repr (f x)).ofLp i) ^ 2 := by
    rw [ h_l2norm, Finset.mul_sum _ _ _ ];
    exact Finset.sum_le_sum fun i _ => by simpa only [ h_component, mul_pow ] using pow_le_pow_left₀ ( Real.sqrt_nonneg _ ) ( hS_bound _ ) 2;
  convert Real.le_sqrt_of_sq_le h_final using 1 ; rw [ Real.sqrt_mul ( sq_nonneg _ ), Real.sqrt_sq hS_nonneg ] ; rw [ ← l2Norm_coordinates b f ] ; rw [ Real.sqrt_sq ( by exact Real.sqrt_nonneg _ ) ] ;

/-
Pointwise action on the spinor index by a fixed unitary is an `L²`
isometry.  The fact that the same `U` is used at every lattice point is explicit.
-/
theorem pointwise_unitary_isometry (U : E ≃ₗᵢ[𝕜] E) (f : X → E) :
    l2Norm (fun x => U (f x)) = l2Norm f := by
  unfold l2Norm; aesop;

/-
**MC5 composite assembly.** The lattice operator must be componentwise,
and the separate fixed spinor-index operation must be unitary.  Under exactly
these visible conditions, their composite retains the scalar constant `K`.
-/
theorem componentwiseLift_then_unitary_bound (b : OrthonormalBasis ι 𝕜 E)
    (S : (X → 𝕜) → (X → 𝕜)) {K : ℝ} (hS : HasL2Bound S K)
    (U : E ≃ₗᵢ[𝕜] E) (f : X → E) :
    l2Norm (fun x => U (componentwiseLift b S f x)) ≤ K * l2Norm f := by
  convert componentwiseLift_bound b S hS f using 1;
  convert pointwise_unitary_isometry U ( componentwiseLift b S f ) using 1

section NecessityWitness

/-- A non-unitary spinor operation: multiplication by two. -/
noncomputable def doubleSpinor : ℝ →ₗ[ℝ] ℝ := LinearMap.lsmul ℝ ℝ 2

lemma doubleSpinor_not_isometry : ¬ Isometry doubleSpinor := by
  rw [ isometry_iff_dist_eq ];
  norm_num [ dist_eq_norm, doubleSpinor ];
  exact ⟨ 0, 1, by norm_num ⟩

/-
The one-point identity lattice operator has scalar bound one.
-/
lemma onePoint_id_bound :
    HasL2Bound (X := PUnit) (𝕜 := ℝ) (fun g => g) 1 := by
  constructor <;> norm_num [ l2Norm ]

/-
**Necessity witness.** On a one-point lattice and one-dimensional spinor
space, the scalar identity has constant `K = 1`, but composing its componentwise
lift with the non-unitary doubling map violates that same bound.
-/
theorem nonunitary_composite_fails :
    ∃ (b : OrthonormalBasis (Fin 1) ℝ ℝ) (f : PUnit → ℝ),
      l2Norm (fun x => doubleSpinor (componentwiseLift b (fun g => g) f x)) >
        (1 : ℝ) * l2Norm f := by
  refine' ⟨ OrthonormalBasis.singleton (Fin 1) ℝ, _ ⟩
  refine' ⟨ fun _ => 1, _ ⟩
  norm_num [ l2Norm, componentwiseLift ];
  norm_num [ Real.lt_sqrt, doubleSpinor ]

end NecessityWitness

end MC5

#print axioms MC5.componentwiseLift_bound
#print axioms MC5.pointwise_unitary_isometry
#print axioms MC5.componentwiseLift_then_unitary_bound
#print axioms MC5.nonunitary_composite_fails
