import PhysicsSM.Draft.NullEdgeP9OperationalGap

/-!
# P9 proper subdiamond non-vacuity witness

This draft module answers an adversarial concern about the positive T2
subdiamond-preservation theorem. If every proper subdiamond of the six-point T1
witness were too small to separate the two relations, then preservation under
Alexandrov restriction would be formally true but operationally thin.

The theorem below records a concrete non-vacuity check: the proper endpoint pair
`(0,3)` still separates the two histories by the same local-signature readout.
The parent separator `(0,4)` is therefore not the only finite diamond that sees
the defect.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity

open PhysicsSM.Draft.NullEdgeP9OperationalGap.T1

theorem relA_diamondCard_0_3 :
    diamondCard relA 0 3 = 2 := by
  unfold diamondCard inClosedDiamond
  rw [Finset.filter_congr_decidable]
  decide

theorem relB_diamondCard_0_3 :
    diamondCard relB 0 3 = 3 := by
  unfold diamondCard inClosedDiamond
  rw [Finset.filter_congr_decidable]
  decide

theorem relA_diamond_0_3_proper_inside_parent :
    diamondCard relA 0 3 < diamondCard relA 0 4 := by
  rw [relA_diamondCard_0_3, diamondCard_relA_0_4]
  decide

theorem relB_diamond_0_3_proper_inside_parent :
    diamondCard relB 0 3 < diamondCard relB 0 4 := by
  rw [relB_diamondCard_0_3, diamondCard_relB_0_4]
  decide

theorem localIntervalSignature_relA_0_3_at_one :
    localIntervalSignature relA 0 3 1 = 0 := by
  have hlc : forall a b : Fin 6, localIntervalCard relA 0 3 a b
      = (Finset.univ.filter fun z : Fin 6 =>
          ((z = 0 \/ relA 0 z) /\ (z = 3 \/ relA z 3)) /\ relA a z /\ relA z b).card := by
    intro a b
    unfold localIntervalCard inClosedDiamond
    rw [Finset.filter_congr_decidable]
  unfold localIntervalSignature localIntervalAbundance inClosedDiamond
  simp only [hlc]
  rw [Finset.filter_congr_decidable]
  decide

theorem localIntervalSignature_relB_0_3_at_one :
    localIntervalSignature relB 0 3 1 = 1 := by
  have hlc : forall a b : Fin 6, localIntervalCard relB 0 3 a b
      = (Finset.univ.filter fun z : Fin 6 =>
          ((z = 0 \/ relB 0 z) /\ (z = 3 \/ relB z 3)) /\ relB a z /\ relB z b).card := by
    intro a b
    unfold localIntervalCard inClosedDiamond
    rw [Finset.filter_congr_decidable]
  unfold localIntervalSignature localIntervalAbundance inClosedDiamond
  simp only [hlc]
  rw [Finset.filter_congr_decidable]
  decide

/--
The T1 witness has a proper subdiamond separator. This keeps the
subdiamond-preservation result from being merely a whole-diamond tautology.
-/
theorem properSubdiamond_0_3_localSignature_separates :
    localIntervalSignature relA 0 3 != localIntervalSignature relB 0 3 := by
  rw [bne_iff_ne, ne_eq]
  intro h
  have h1 := congrFun h 1
  rw [localIntervalSignature_relA_0_3_at_one,
    localIntervalSignature_relB_0_3_at_one] at h1
  exact absurd h1 (by decide)

end PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity

end
