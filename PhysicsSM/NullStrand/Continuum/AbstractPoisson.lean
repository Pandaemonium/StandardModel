import Mathlib

/-!
# NullStrand.Continuum.AbstractPoisson

Manifest node CONT-001: in a real Hilbert space, a bounded coercive bilinear form
`B` has a unique weak solution of `B u w = ⟪f, w⟫` for every test vector `w`. This
is the abstract Lax–Milgram wrapper that the continuum weighted angular Poisson
problem (W13) reduces to; the geometric sphere-Sobolev instance (CONT-002) is a
separate later node, so this layer deliberately claims nothing about the sphere.

Provenance: clean-room statement; proof from Aristotle project
`eea53903-3816-424b-8344-341b014e8ed0`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

open scoped RealInnerProductSpace

namespace PhysicsSM.NullStrand.Continuum

/-- CONT-001. A bounded coercive bilinear form on a real Hilbert space has a
unique weak solution for every Riesz-represented source. -/
theorem coerciveWeightedPoisson_exists_unique
    {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V] [CompleteSpace V]
    (B : V →L[ℝ] V →L[ℝ] ℝ) (coercive : IsCoercive B) (f : V) :
    ∃! u : V, ∀ w, B u w = inner ℝ f w := by
  refine ⟨coercive.continuousLinearEquivOfBilin.symm f, ?_, ?_⟩
  · intro w
    have h := coercive.continuousLinearEquivOfBilin_apply
      (coercive.continuousLinearEquivOfBilin.symm f) w
    rw [ContinuousLinearEquiv.apply_symm_apply] at h
    rw [← h]
  · intro u' hu'
    have hlax : ∀ w, (inner ℝ f w : ℝ) = B u' w := fun w => (hu' w).symm
    have hf : f = coercive.continuousLinearEquivOfBilin u' :=
      coercive.unique_continuousLinearEquivOfBilin hlax
    rw [hf, ContinuousLinearEquiv.symm_apply_apply]

end PhysicsSM.NullStrand.Continuum
