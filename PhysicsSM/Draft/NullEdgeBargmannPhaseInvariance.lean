import PhysicsSM.Draft.NullEdgeBargmannPhasePort

/-!
# Bargmann phase invariance

This draft module proves that the closed Bargmann/Pancharatnam product and its
rank-one projector trace are invariant under independent local unit complex
phase rescalings of the three spinor vertices.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeBargmannPhaseInvariance

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdgeBargmannPhasePort

/-- Closed Bargmann/Pancharatnam product of three spinor rays. -/
def bargmannTriple (psi phi chi : CSpinor) : Complex :=
  spinorInner psi phi * spinorInner phi chi * spinorInner chi psi

/--
Hermitian spinor pairing under independent complex rescalings of its two
arguments.
-/
theorem spinorInner_smul_smul
    (a b : Complex) (psi phi : CSpinor) :
    spinorInner (a • psi) (b • phi) =
      (starRingEnd Complex a * b) * spinorInner psi phi := by
  norm_num [Fin.sum_univ_two, spinorInner]
  ring

/-- Unit complex phase rescaling leaves a rank-one spinor projector unchanged. -/
theorem rankOneProjector_phase_invariant
    (u : Complex) (psi : CSpinor)
    (hu : starRingEnd Complex u * u = 1) :
    rankOneProjector (u • psi) = rankOneProjector psi := by
  ext i j
  simp only [rankOneProjector, rankOneKetBra, Matrix.vecMulVec, Pi.smul_apply,
    smul_eq_mul, map_mul, Matrix.of_apply]
  linear_combination (psi i * starRingEnd Complex (psi j)) * hu

/-- Closed Bargmann product scaling under three independent complex rescalings. -/
theorem bargmannTriple_smul
    (a b c : Complex) (psi phi chi : CSpinor) :
    bargmannTriple (a • psi) (b • phi) (c • chi) =
      ((starRingEnd Complex a * a) *
          (starRingEnd Complex b * b) *
          (starRingEnd Complex c * c)) *
        bargmannTriple psi phi chi := by
  have h1 := spinorInner_smul_smul a b psi phi
  have h2 := spinorInner_smul_smul b c phi chi
  have h3 := spinorInner_smul_smul c a chi psi
  unfold bargmannTriple
  rw [h1, h2, h3]
  ring

/--
The closed Bargmann product is invariant under independent unit complex phase
rescalings at the three vertices.
-/
theorem bargmannTriple_phase_invariant
    (a b c : Complex) (psi phi chi : CSpinor)
    (ha : starRingEnd Complex a * a = 1)
    (hb : starRingEnd Complex b * b = 1)
    (hc : starRingEnd Complex c * c = 1) :
    bargmannTriple (a • psi) (b • phi) (c • chi) =
      bargmannTriple psi phi chi := by
  rw [bargmannTriple_smul, ha, hb, hc]
  ring

/--
The closed rank-one projector trace is invariant under independent local unit
phase rescalings of the three spinors.
-/
theorem bargmannTripleTrace_phase_invariant
    (a b c : Complex) (psi phi chi : CSpinor)
    (ha : starRingEnd Complex a * a = 1)
    (hb : starRingEnd Complex b * b = 1)
    (hc : starRingEnd Complex c * c = 1) :
    trace2 (rankOneProjector (a • psi) * rankOneProjector (b • phi) *
        rankOneProjector (c • chi)) =
      trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) := by
  rw [bargmannTripleTrace_rankOne, bargmannTripleTrace_rankOne]
  exact bargmannTriple_phase_invariant a b c psi phi chi ha hb hc

end PhysicsSM.Draft.NullEdgeBargmannPhaseInvariance

end
