import Mathlib

/-!
# Finite reflection positivity, separated from positive-definiteness (Opus, c2b7bd0d)

Fixes a conflation an earlier audit caught: a module of mine described
POSITIVE-DEFINITENESS as 'reflection positivity'. They are genuinely different, and
this proves it in both directions.

Contents: definitions of the reflected block, the reflected pairing, and genuine
Osterwalder-Schrader reflection positivity; identification of the pairing with the
quadratic form of the transported negative-positive block; the theorem that, under
reflection compatibility (Hermiticity of the reflected block), RP makes that block
positive semidefinite; and the bundled quotient by null directions with its induced
real inner product - the step that actually yields a PHYSICAL SPACE.

THE TWO SEPARATING WITNESSES:
* PD does NOT imply RP - symmetric positive definite [[2,-1],[-1,2]] has reflected
  pairing -1 (positivity of all eigenvalues included formally).
* RP does NOT imply PD - symmetric diag(-1,1) is reflection positive in this sense
  yet has an explicit eigenvector of eigenvalue -1.

CONSEQUENCE: a lattice bridge may NOT substitute positive-definiteness for
reflection positivity, in either direction. `FiniteTransferPositivity` proves the PD
side only; this module is what an OS-style construction actually needs.

Namespace kept as the prover's. Provenance: verified at pin from task 82d54463.
Standard three. Claim grade M, [comp]. -/

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace FiniteReflectionPositivity

variable {Neg Pos : Type} [Fintype Pos]

/-- The configuration index set, split into negative- and positive-time parts. -/
abbrev Config (Neg Pos : Type*) := Neg ⊕ Pos

/-- The negative-positive block, with its negative index transported back by reflection. -/
def reflectedBlock (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ)
    (theta : Pos ≃ Neg) : Matrix Pos Pos ℝ :=
  fun p q => M (Sum.inl (theta p)) (Sum.inr q)

/-- The finite Osterwalder--Schrader reflected pairing on positive-time functions. -/
def reflectedPairing (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ)
    (theta : Pos ≃ Neg) (f g : Pos → ℝ) : ℝ :=
  ∑ p, ∑ q, f p * M (Sum.inl (theta p)) (Sum.inr q) * g q

/-- Reflection positivity is nonnegativity of the reflected quadratic pairing. -/
def ReflectionPositive (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ)
    (theta : Pos ≃ Neg) : Prop :=
  ∀ f : Pos → ℝ, 0 ≤ reflectedPairing M theta f f

/-
The reflected pairing is exactly the quadratic/bilinear form of the transported
negative-positive block.
-/
theorem reflectedPairing_eq_block_quadratic
    (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ) (theta : Pos ≃ Neg)
    (f g : Pos → ℝ) :
    reflectedPairing M theta f g = dotProduct f (Matrix.mulVec (reflectedBlock M theta) g) := by
  simp [reflectedPairing, reflectedBlock, Matrix.mulVec, dotProduct,
    Finset.mul_sum, mul_assoc]

/-
Reflection positivity is precisely nonnegativity of the quadratic form of the
transported negative-positive block.
-/
theorem reflectionPositive_iff_block_quadratic_nonneg
    (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ) (theta : Pos ≃ Neg) :
    ReflectionPositive M theta ↔
      ∀ f : Pos → ℝ, 0 ≤ dotProduct f (Matrix.mulVec (reflectedBlock M theta) f) := by
  -- By definition of reflection positivity, we have:
  simp [ReflectionPositive, reflectedPairing_eq_block_quadratic]

/-- Symmetry of `M` alone does not force this condition.  It is the finite form of
reflection invariance needed to make the reflected pairing a Gram form. -/
def ReflectionCompatible (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ)
    (theta : Pos ≃ Neg) : Prop :=
  (reflectedBlock M theta).IsHermitian

/-
With reflection compatibility, OS positivity says exactly that the reflected
Gram matrix is positive semidefinite.
-/
theorem reflectionPositive_posSemidef
    (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ) (theta : Pos ≃ Neg)
    (hcompat : ReflectionCompatible M theta) (hRP : ReflectionPositive M theta) :
    (reflectedBlock M theta).PosSemidef := by
  refine' ⟨ hcompat, fun x => _ ⟩;
  convert hRP ( fun i => x i ) using 1;
  simp +decide [ Finsupp.sum_fintype, reflectedPairing ];
  rfl

/-- A bundled real inner-product space. -/
structure RealInnerProductSpace where
  carrier : Type
  seminormed : SeminormedAddCommGroup carrier
  innerProduct : @InnerProductSpace ℝ carrier _ seminormed

/-- The quotient by the null space of the reflected positive semidefinite form,
bundled with its induced real inner product. -/
noncomputable def physicalHilbertSpace
    (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ) (theta : Pos ≃ Neg)
    (hcompat : ReflectionCompatible M theta) (hRP : ReflectionPositive M theta) :
    RealInnerProductSpace := by
  let A := reflectedBlock M theta
  let hA : A.PosSemidef := reflectionPositive_posSemidef M theta hcompat hRP
  letI : SeminormedAddCommGroup (Pos → ℝ) := A.toSeminormedAddCommGroup hA
  letI : PseudoMetricSpace (Pos → ℝ) := SeminormedAddCommGroup.toPseudoMetricSpace
  letI : UniformSpace (Pos → ℝ) := PseudoMetricSpace.toUniformSpace
  letI : TopologicalSpace (Pos → ℝ) := UniformSpace.toTopologicalSpace
  letI : InnerProductSpace ℝ (Pos → ℝ) := A.toInnerProductSpace hA
  let Q := SeparationQuotient (Pos → ℝ)
  let qSeminormed : SeminormedAddCommGroup Q := inferInstance
  let qInner : @InnerProductSpace ℝ Q _ qSeminormed :=
    @SeparationQuotient.instInnerProductSpace ℝ (Pos → ℝ) _ _ _
  exact { carrier := Q, seminormed := qSeminormed, innerProduct := qInner }

/-
Consequently the null directions may be quotiented out to produce a genuine
real inner-product space (the finite physical Hilbert-space construction).
-/
theorem reflectionPositive_induces_quotient_innerProduct
    (M : Matrix (Config Neg Pos) (Config Neg Pos) ℝ) (theta : Pos ≃ Neg)
    (hcompat : ReflectionCompatible M theta) (hRP : ReflectionPositive M theta) :
    Nonempty (physicalHilbertSpace M theta hcompat hRP).carrier := by
  constructor;
  convert SeparationQuotient.mk _;
  exact fun _ => 0

section Witnesses

abbrev TwoConfig := Config Unit Unit

/-- A positive-definite symmetric matrix whose reflected block is `[-1]`. -/
def pdNotRPMatrix : Matrix TwoConfig TwoConfig ℝ
  | Sum.inl _, Sum.inl _ => 2
  | Sum.inl _, Sum.inr _ => -1
  | Sum.inr _, Sum.inl _ => -1
  | Sum.inr _, Sum.inr _ => 2

/-- A reflection-positive symmetric diagonal matrix with eigenvalue `-1`. -/
def rpNotPDMatrix : Matrix TwoConfig TwoConfig ℝ
  | Sum.inl _, Sum.inl _ => -1
  | Sum.inl _, Sum.inr _ => 0
  | Sum.inr _, Sum.inl _ => 0
  | Sum.inr _, Sum.inr _ => 1

/-
The positive-definite witness is symmetric.
-/
theorem pdNotRP_isHermitian : pdNotRPMatrix.IsHermitian := by
  ext x y; rcases x with ( _ | _ ) <;> rcases y with ( _ | _ ) <;> rfl;

/-
Positive-definiteness (and hence positivity of every eigenvalue) does not imply
reflection positivity: the displayed test function has reflected value `-1`.
-/
theorem positiveDefinite_not_reflectionPositive_witness :
    pdNotRPMatrix.PosDef ∧
    (∀ i, 0 < pdNotRP_isHermitian.eigenvalues i) ∧
    ¬ ReflectionPositive pdNotRPMatrix (Equiv.refl Unit) := by
  constructor;
  · constructor;
    · -- The matrix pdNotRPMatrix is symmetric, hence Hermitian.
      apply pdNotRP_isHermitian;
    · intro x hx; simp_all +decide [ Finsupp.sum_fintype, TwoConfig ] ;
      unfold pdNotRPMatrix; ring_nf ;
      exact not_le.mp fun h => hx <| Finsupp.ext fun i => by rcases i with ( _ | _ ) <;> norm_num <;> nlinarith [ sq_nonneg ( x ( Sum.inl PUnit.unit ) - x ( Sum.inr PUnit.unit ) ) ] ;
  · constructor;
    · -- By definition of $pdNotRPMatrix$, we know that it is positive definite.
      have h_pos_def : Matrix.PosDef pdNotRPMatrix := by
        constructor;
        · -- The matrix pdNotRPMatrix is symmetric, hence Hermitian.
          apply pdNotRP_isHermitian;
        · intro x hx; simp_all +decide [ Finsupp.sum_fintype, TwoConfig ] ;
          unfold pdNotRPMatrix; ring_nf ;
          exact not_le.mp fun h => hx <| Finsupp.ext fun i => by rcases i with ( _ | _ ) <;> norm_num <;> nlinarith [ sq_nonneg ( x ( Sum.inl PUnit.unit ) - x ( Sum.inr PUnit.unit ) ) ] ;
      exact fun i => Matrix.PosDef.eigenvalues_pos h_pos_def i;
    · intro h;
      convert h ( fun _ => 1 ) using 1 ; norm_num [ reflectedPairing, pdNotRPMatrix ]

/-
The explicit negative reflected value in the preceding witness.
-/
theorem pdNotRP_negative_value :
    reflectedPairing pdNotRPMatrix (Equiv.refl Unit) (fun _ => 1) (fun _ => 1) = -1 := by
  unfold reflectedPairing; norm_num [ pdNotRPMatrix ] ;

/-
The reflection-positive counterexample is also symmetric.
-/
theorem rpNotPD_isHermitian : rpNotPDMatrix.IsHermitian := by
  ext i j; rcases i with ( _ | _ ) <;> rcases j with ( _ | _ ) <;> norm_num [ rpNotPDMatrix ] ;

/-- Reflection positivity does not imply positive-definiteness. This symmetric witness
is reflection positive, but the negative-time basis vector has quadratic value `-1`. -/
theorem reflectionPositive_not_positiveDefinite_witness :
    rpNotPDMatrix.IsHermitian ∧
    ReflectionPositive rpNotPDMatrix (Equiv.refl Unit) ∧
    ¬ rpNotPDMatrix.PosDef := by
  refine ⟨rpNotPD_isHermitian, ?_⟩
  constructor;
  · intro f
    unfold reflectedPairing
    simp;
    unfold rpNotPDMatrix; norm_num;
  · intro h; have := h.2; simp_all +decide [ Matrix.PosDef ] ;
    convert h.2 ( show ( Finsupp.single ( Sum.inl () ) 1 ) ≠ 0 from ne_of_apply_ne ( fun x => x ( Sum.inl () ) ) ( by norm_num ) ) using 1 ; norm_num [ rpNotPDMatrix ]

/-
The same witness has the explicit eigenpair `(-1, e_neg)`.
-/
theorem rpNotPD_has_negative_eigenvalue :
    let eNeg : TwoConfig → ℝ := fun i => match i with
      | Sum.inl _ => 1
      | Sum.inr _ => 0
    eNeg ≠ 0 ∧ Matrix.mulVec rpNotPDMatrix eNeg = (-1 : ℝ) • eNeg := by
  refine' ⟨ _, _ ⟩;
  · exact fun h => by simpa using congr_fun h ( Sum.inl () ) ;
  · ext i;
    rcases i with ( _ | _ ) <;> norm_num [ Matrix.mulVec, dotProduct ]; all_goals rfl

end Witnesses

end FiniteReflectionPositivity
