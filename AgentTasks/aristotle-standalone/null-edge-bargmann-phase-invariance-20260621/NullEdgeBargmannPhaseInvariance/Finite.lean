import PhysicsSM.Draft.NullEdgeBargmannPhasePort

noncomputable section

namespace NullEdgeBargmannPhaseInvariance

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
  sorry

/-- Unit complex phase rescaling leaves a rank-one spinor projector unchanged. -/
theorem rankOneProjector_phase_invariant
    (u : Complex) (psi : CSpinor)
    (hu : starRingEnd Complex u * u = 1) :
    rankOneProjector (u • psi) = rankOneProjector psi := by
  sorry

/-- Closed Bargmann product scaling under three independent complex rescalings. -/
theorem bargmannTriple_smul
    (a b c : Complex) (psi phi chi : CSpinor) :
    bargmannTriple (a • psi) (b • phi) (c • chi) =
      ((starRingEnd Complex a * a) *
          (starRingEnd Complex b * b) *
          (starRingEnd Complex c * c)) *
        bargmannTriple psi phi chi := by
  sorry

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
  sorry

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
  sorry

end NullEdgeBargmannPhaseInvariance

end
