import PhysicsSM.Draft.NullEdge.Carrier.ColorCommutantScalar

/-!
# NullEdge.Carrier.ColorCommutantMultiplicity

This module proves the finite reducible-color extension left open by
`ColorCommutantScalar`.

The single-triplet theorem says the commutant of the fundamental color action on
`Complex^3` is only the scalar matrices.  The physically useful follow-up is the
reducible internal-space case: if the color triplet is tensored with a finite
multiplicity space `K`, then commuting with the color generators forces an
operator to be color-blind, but it may be an arbitrary operator on `K`.

Concretely, for matrices on `Fin 3 x K`, the commutant of every lifted color
generator `g x I_K` is exactly the family `I_3 x B`, with
`B : Matrix K K Complex`.  This is the finite Schur-multiplicity statement behind the
lane note that Yukawa/flavor texture can live in multiplicity spaces, not in the
single irreducible color factor.

Claim boundary: this is finite matrix algebra.  It does not derive a Yukawa
matrix, a generation count, or a Standard Model flavor texture.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier

open Matrix

variable {K : Type*} [Fintype K] [DecidableEq K]

/-! ## Lifted color and multiplicity matrices -/

/-- Lift a color matrix to the reducible color-plus-multiplicity space. -/
def colorLift (g : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 3 × K) (Fin 3 × K) ℂ :=
  fun p q => if p.2 = q.2 then g p.1 q.1 else 0

/-- Lift a multiplicity-space matrix as a color-blind operator. -/
def multiplicityLift (B : Matrix K K ℂ) :
    Matrix (Fin 3 × K) (Fin 3 × K) ℂ :=
  fun p q => if p.1 = q.1 then B p.2 q.2 else 0

/-- The color block of a matrix between multiplicity labels `r` and `s`. -/
def colorBlock (M : Matrix (Fin 3 × K) (Fin 3 × K) ℂ) (r s : K) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  fun a b => M (a, r) (b, s)

theorem colorBlock_commutes_of_lift_commutes
    {M : Matrix (Fin 3 × K) (Fin 3 × K) ℂ}
    (h : ∀ g ∈ colorGens, M * colorLift (K := K) g = colorLift (K := K) g * M)
    (r s : K) :
    ∀ g ∈ colorGens, colorBlock M r s * g = g * colorBlock M r s := by
  intro g hg
  ext a b
  have hentry := congr_fun (congr_fun (h g hg) (a, r)) (b, s)
  simpa [colorBlock, colorLift, Matrix.mul_apply, Fintype.sum_prod_type] using hentry

theorem multiplicityLift_commutes_colorLift (B : Matrix K K ℂ)
    (g : Matrix (Fin 3) (Fin 3) ℂ) :
    multiplicityLift (K := K) B * colorLift (K := K) g =
      colorLift (K := K) g * multiplicityLift (K := K) B := by
  ext p q
  rcases p with ⟨a, r⟩
  rcases q with ⟨b, s⟩
  simp [multiplicityLift, colorLift, Matrix.mul_apply, Fintype.sum_prod_type, mul_comm]

/-! ## Reducible color commutant -/

/-- Reducible Schur-multiplicity form of the color commutant.

A matrix on `Fin 3 x K` commutes with all lifted color generators iff it is
color-blind and therefore comes from an arbitrary multiplicity-space matrix
`B : Matrix K K C`. -/
theorem color_commutant_multiplicity_eq
    (M : Matrix (Fin 3 × K) (Fin 3 × K) ℂ) :
    (∀ g ∈ colorGens, M * colorLift (K := K) g = colorLift (K := K) g * M) ↔
      ∃ B : Matrix K K ℂ, M = multiplicityLift (K := K) B := by
  constructor
  · intro h
    refine ⟨fun r s => M (0, r) (0, s), ?_⟩
    ext p q
    rcases p with ⟨a, r⟩
    rcases q with ⟨b, s⟩
    have hblock :
        ∃ c : ℂ, colorBlock M r s = c • (1 : Matrix (Fin 3) (Fin 3) ℂ) :=
      (color_commutant_eq_scalars (colorBlock M r s)).mp
        (colorBlock_commutes_of_lift_commutes h r s)
    rcases hblock with ⟨c, hc⟩
    have hab := congr_fun (congr_fun hc a) b
    have h00 := congr_fun (congr_fun hc 0) 0
    by_cases heq : a = b
    · subst heq
      have hab' : M (a, r) (a, s) = c := by
        simpa [colorBlock] using hab
      have h00' : M (0, r) (0, s) = c := by
        simpa [colorBlock] using h00
      simpa [multiplicityLift] using hab'.trans h00'.symm
    · simpa [colorBlock, multiplicityLift, heq] using hab
  · rintro ⟨B, rfl⟩
    intro g _
    exact multiplicityLift_commutes_colorLift B g

/-- Every multiplicity-space operator is color-exact after color-blind lifting. -/
theorem multiplicity_operator_is_color_exact (B : Matrix K K ℂ) :
    ∀ g ∈ colorGens, multiplicityLift (K := K) B * colorLift (K := K) g =
      colorLift (K := K) g * multiplicityLift (K := K) B := by
  intro g _
  exact multiplicityLift_commutes_colorLift B g

/-! ## Guarded footprint -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_multiplicity_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms color_commutant_multiplicity_eq

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.multiplicity_operator_is_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multiplicity_operator_is_color_exact

end PhysicsSM.Draft.NullEdge.Carrier
