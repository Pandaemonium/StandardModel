import PhysicsSM.Draft.NullEdgeP9OperationalGap
import PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail

/-!
# P9 operational gap under a critical coarse map

This draft module packages the T1/T2 source-visibility lesson in operational
form. `NullEdgeP9OperationalGap` proves that the six-point witness has a
diamond-local readout gap. `NullEdgeP9CoarseMapErasureGuardrail` proves that a
pre-specified coarse map collapsing the two swapped vertices erases the local
signature separator.

Scientific role: this is a finite guardrail for the P9 cosmological-constant
lane. Visibility is observer-channel dependent. A local diamond readout can see
the finite defect, while a coarse map that collapses the critical distinction
can make the same readout unable to distinguish the histories.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap

/-- Gap between two `Fin 5` coarse signatures at a fixed bucket. -/
def coarseSignatureGapAt (sigA sigB : Fin 6 -> Nat) (k : Fin 6) : Nat :=
  PhysicsSM.Draft.NullEdgeP9OperationalGap.natGap (sigA k) (sigB k)

/-- Coarse signatures are distinguishable at bucket `k` above threshold `eps`. -/
def coarseDistinguishableAt (sigA sigB : Fin 6 -> Nat) (k : Fin 6) (eps : Nat) : Prop :=
  eps <= coarseSignatureGapAt sigA sigB k

theorem coarseSignatureGap_zero_of_eq
    (sigA sigB : Fin 6 -> Nat) (k : Fin 6) (h : sigA = sigB) :
    coarseSignatureGapAt sigA sigB k = 0 := by
  subst sigB
  unfold coarseSignatureGapAt
  simp [PhysicsSM.Draft.NullEdgeP9OperationalGap.natGap]

/--
The critical coarse map erases the T1 operational gap at bucket `1`.

Before the collapse, `NullEdgeP9OperationalGap.t1_localSignature_gap_at_one`
gives a gap of `2`. After the collapse, the induced coarse signatures agree, so
the operational gap is `0`.
-/
theorem collapseCritical_coarseSignatureGap_at_one_zero :
    coarseSignatureGapAt
      (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.localIntervalSignature5
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.coarseRel
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.relA
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 0)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 4))
      (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.localIntervalSignature5
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.coarseRel
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.relB
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 0)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 4))
      (Fin.mk 1 (by decide)) = 0 := by
  exact coarseSignatureGap_zero_of_eq _ _ _
    PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical_localIntervalSignature_eq

/-- At positive threshold `1`, the critical coarse map no longer distinguishes
the two histories at bucket `1`. -/
theorem not_coarseDistinguishableAt_collapseCritical_threshold_one :
    Not (coarseDistinguishableAt
      (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.localIntervalSignature5
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.coarseRel
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.relA
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 0)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 4))
      (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.localIntervalSignature5
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.coarseRel
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.relB
          PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 0)
        (PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail.collapseCritical 4))
      (Fin.mk 1 (by decide)) 1) := by
  unfold coarseDistinguishableAt
  rw [collapseCritical_coarseSignatureGap_at_one_zero]
  decide

end PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap

end
