import PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector

/-!
# Equivariant polynomial filters for carrier probe sectors

An order-native endomorphism can select a basis-free probe sector through a
polynomial filter. If two endomorphisms intertwine under a linear equivalence,
then evaluation of every real polynomial at those endomorphisms also
intertwines. Their filtered ranges therefore transport exactly, without
choosing or ordering eigenvectors.

For a carrier operator, an idempotent polynomial filter with four-dimensional
range packages directly as the existing `RankFourProbeProjector`. The final
carrier theorem shows that one common polynomial applied to intertwining
operators gives exactly the same selected sector after order relabeling.

This is a finite functional-calculus interface, not a graph-native spectral
construction. It does not derive the operator or polynomial, certify that a
spectral threshold is separated by a gap, prove rank four or Lorentzian
inertia, or establish overlap/refinement convergence.

Claim grade: `M [orig/comp]`. Provenance: program-internal composition of
Mathlib polynomial evaluation, conjugation of endomorphism algebras, and the
existing equivariant range-selector interface.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector

open Polynomial
open AlexandrovAlgebraGerm
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open EquivariantProbeSectorSelector

variable {M N : Type*}
  [AddCommGroup M] [Module Real M]
  [AddCommGroup N] [Module Real N]

/-! ## General polynomial naturality -/

/-- Evaluate a real polynomial at a real-linear endomorphism. -/
def polynomialFilter (A : Module.End Real M) (p : Real[X]) :
    Module.End Real M :=
  aeval A p

/-- Conjugate endomorphisms have intertwining polynomial evaluations. This is
the basis-free naturality statement needed by polynomial spectral filters. -/
theorem polynomialFilter_intertwines
    (E : M ≃ₗ[Real] N)
    (A : Module.End Real M) (B : Module.End Real N)
    (hintertwines : forall x, E (A x) = B (E x))
    (p : Real[X]) (x : M) :
    E (polynomialFilter A p x) = polynomialFilter B p (E x) := by
  have hconj : (E.conjAlgEquiv Real) A = B := by
    ext y
    change E (A (E.symm y)) = B y
    simpa using hintertwines (E.symm y)
  have hpoly := Polynomial.aeval_algHom_apply (E.conjAlgEquiv Real) A p
  rw [hconj] at hpoly
  rw [polynomialFilter, polynomialFilter, hpoly]
  simp

/-- The range of a polynomial filter transports exactly under an intertwining
linear equivalence. -/
theorem map_range_polynomialFilter_eq
    (E : M ≃ₗ[Real] N)
    (A : Module.End Real M) (B : Module.End Real N)
    (hintertwines : forall x, E (A x) = B (E x))
    (p : Real[X]) :
    (LinearMap.range (polynomialFilter A p)).map E.toLinearMap =
      LinearMap.range (polynomialFilter B p) := by
  exact map_range_eq_range_of_intertwines E
    (polynomialFilter A p) (polynomialFilter B p)
    (polynomialFilter_intertwines E A B hintertwines p)

/-- Idempotence of a polynomial filter transports across an exact
intertwining equivalence. -/
theorem polynomialFilter_idempotent_of_intertwines
    (E : M ≃ₗ[Real] N)
    (A : Module.End Real M) (B : Module.End Real N)
    (hintertwines : forall x, E (A x) = B (E x))
    (p : Real[X])
    (hidempotent :
      (polynomialFilter A p).comp (polynomialFilter A p) =
        polynomialFilter A p) :
    (polynomialFilter B p).comp (polynomialFilter B p) =
      polynomialFilter B p := by
  let PA := polynomialFilter A p
  let PB := polynomialFilter B p
  have hfilter : forall x, E (PA x) = PB (E x) :=
    polynomialFilter_intertwines E A B hintertwines p
  have hPA : forall x, PA (PA x) = PA x := by
    intro x
    change ((polynomialFilter A p).comp (polynomialFilter A p)) x =
      polynomialFilter A p x
    rw [hidempotent]
  ext y
  obtain ⟨x, rfl⟩ := E.surjective y
  change PB (PB (E x)) = PB (E x)
  calc
    PB (PB (E x)) = PB (E (PA x)) := by rw [hfilter x]
    _ = E (PA (PA x)) := (hfilter (PA x)).symm
    _ = E (PA x) := congrArg E (hPA x)
    _ = PB (E x) := hfilter x

/-- Intertwining polynomial filters have equal range finrank. -/
theorem finrank_range_polynomialFilter_eq
    (E : M ≃ₗ[Real] N)
    (A : Module.End Real M) (B : Module.End Real N)
    (hintertwines : forall x, E (A x) = B (E x))
    (p : Real[X]) :
    Module.finrank Real (LinearMap.range (polynomialFilter B p)) =
      Module.finrank Real (LinearMap.range (polynomialFilter A p)) := by
  have hrange := map_range_polynomialFilter_eq E A B hintertwines p
  calc
    Module.finrank Real (LinearMap.range (polynomialFilter B p)) =
        Module.finrank Real
          ((LinearMap.range (polynomialFilter A p)).map E.toLinearMap) := by
      rw [hrange]
    _ = Module.finrank Real
          (LinearMap.range (polynomialFilter A p)) :=
      (E.submoduleMap (LinearMap.range (polynomialFilter A p))).finrank_eq.symm

/-- The coordinate polynomial recovers the original endomorphism. -/
@[simp] theorem polynomialFilter_X (A : Module.End Real M) :
    polynomialFilter A Polynomial.X = A := by
  simp [polynomialFilter]

/-! ## Carrier polynomial projectors -/

/-- Package an idempotent four-dimensional polynomial filter of a carrier
operator as the existing rank-four projector interface. -/
def rankFourProbeProjectorOfPolynomial
    {V : Type} [Fintype V]
    {C : FiniteCausalOrder V} (carrier : MarkedDiamond C)
    (A : Module.End Real (carrierProbeSubspace carrier))
    (p : Real[X])
    (hidempotent :
      (polynomialFilter A p).comp (polynomialFilter A p) =
        polynomialFilter A p)
    (hrank :
      Module.finrank Real (LinearMap.range (polynomialFilter A p)) = 4) :
    RankFourProbeProjector carrier where
  project := polynomialFilter A p
  idempotent := hidempotent
  range_finrank_eq_four := hrank

/-- A common polynomial applied to intertwining carrier operators selects the
same rank-four sector after exact order relabeling. Source idempotence and rank
four transport to the target and remain the displayed certificate hypotheses. -/
theorem polynomialProjectorSector_mapOrderIso_space_eq
    {V W : Type} [Fintype V] [Fintype W]
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (carrier : MarkedDiamond C)
    (A : Module.End Real (carrierProbeSubspace carrier))
    (B : Module.End Real (carrierProbeSubspace (carrier.map e)))
    (p : Real[X])
    (hidempotentA :
      (polynomialFilter A p).comp (polynomialFilter A p) =
        polynomialFilter A p)
    (hrankA :
      Module.finrank Real (LinearMap.range (polynomialFilter A p)) = 4)
    (hintertwines : forall x,
      carrierProbeLinearEquiv e carrier (A x) =
        B (carrierProbeLinearEquiv e carrier x)) :
    ((rankFourProbeProjectorOfPolynomial carrier A p hidempotentA hrankA).sector.mapOrderIso
        e).space =
      (rankFourProbeProjectorOfPolynomial (carrier.map e) B p
        (polynomialFilter_idempotent_of_intertwines
          (carrierProbeLinearEquiv e carrier) A B hintertwines p
          hidempotentA)
        ((finrank_range_polynomialFilter_eq
          (carrierProbeLinearEquiv e carrier) A B hintertwines p).trans
          hrankA)).sector.space := by
  apply projectorSector_mapOrderIso_space_eq e carrier
  exact polynomialFilter_intertwines
    (carrierProbeLinearEquiv e carrier) A B hintertwines p

/-! ## Nonvacuity control -/

/-- The coordinate-polynomial filter of the identity on four scalar
coordinates is an idempotent projector with four-dimensional range. This
checks the polynomial-projector certificate without claiming graph origin. -/
theorem identity_polynomial_filter_rank_four_witness :
    let P : Module.End Real (Fin 4 -> Real) := LinearMap.id
    (polynomialFilter P Polynomial.X).comp
          (polynomialFilter P Polynomial.X) =
        polynomialFilter P Polynomial.X ∧
      Module.finrank Real
          (LinearMap.range (polynomialFilter P Polynomial.X)) = 4 := by
  dsimp only
  constructor
  · rw [polynomialFilter_X]
    ext x
    rfl
  · rw [polynomialFilter_X, LinearMap.range_id, finrank_top]
    simp

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialFilter_intertwines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialFilter_intertwines

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialProjectorSector_mapOrderIso_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialProjectorSector_mapOrderIso_space_eq

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialFilter_idempotent_of_intertwines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.polynomialFilter_idempotent_of_intertwines

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.identity_polynomial_filter_rank_four_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector.identity_polynomial_filter_rank_four_witness

end PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector
