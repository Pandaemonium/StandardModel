import Mathlib
import PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness

/-!
# Finite Lorentz audit forcing the quadratic mass Casimir

This module supplies a scoped taxonomy anchor for the null-edge kinematic
completeness theorem. It does not attempt the full Wigner classification of
unitary irreducible Poincare representations. Instead it proves that a
symmetric real quadratic form on four-momentum which survives a small explicit
set of standard Lorentz transformations is necessarily a scalar multiple of
the Minkowski metric.

The explicit matrices are mandatory nonvacuity witnesses. Provenance:
clean-room integration of the locally verified Aristotle project
`b4554e39-c04c-471d-8c3d-617547c18325`, task
`bae860dc-dd5c-45e2-9e64-2dc993e30b11` (2026-07-21). The mathematical source
context is Wigner's classification of Poincare representations, but the result
here is deliberately much narrower: only uniqueness of a normalized quadratic
momentum scalar under the displayed finite audit.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir

open PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering (Vec4 minkowskiSq vecOfHerm)
open PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness
  (ForwardCone forwardCone_complete_futureNullEdge_representation)
open PhysicsSM.Spinor.PluckerMass

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Real

/-- Minkowski metric with signature `(+, -, -, -)`. -/
def eta : Mat4 := diagonal ![1, -1, -1, -1]

def halfTurnXY : Mat4 :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, 1]

def halfTurnXZ : Mat4 :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, -1]

def quarterTurnXY : Mat4 :=
  !![1, 0, 0, 0;
     0, 0, -1, 0;
     0, 1, 0, 0;
     0, 0, 0, 1]

def quarterTurnYZ : Mat4 :=
  !![1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, 0, -1;
     0, 0, 1, 0]

/-- The exact `3-4-5` Lorentz boost in the first spatial direction. -/
def rationalBoostX : Mat4 :=
  !![5 / 4, 3 / 4, 0, 0;
     3 / 4, 5 / 4, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

/-- Congruence invariance of a quadratic form under a linear transformation. -/
def Preserves (L Q : Mat4) : Prop := L.transpose * Q * L = Q

/-- Evaluation of a quadratic form on a four-momentum. -/
def quadraticValue (Q : Mat4) (p : Vec4) : Real :=
  dotProduct p (Q.mulVec p)

/-- The displayed metric evaluates to the exact Minkowski square used by the
null-edge kinematic completeness theorem. -/
theorem quadraticValue_eta_eq_minkowskiSq (p : Vec4) :
    quadraticValue eta p = minkowskiSq p := by
  simp [quadraticValue, eta, minkowskiSq, Matrix.mulVec, dotProduct,
    Fin.sum_univ_four]
  ring

/-- Every displayed audit transformation preserves the chosen Minkowski metric. -/
theorem audit_witnesses_preserve_eta :
    Preserves halfTurnXY eta /\
      Preserves halfTurnXZ eta /\
      Preserves quarterTurnXY eta /\
      Preserves quarterTurnYZ eta /\
      Preserves rationalBoostX eta := by
  unfold Preserves eta halfTurnXY halfTurnXZ quarterTurnXY quarterTurnYZ rationalBoostX
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  all_goals ext i j; simp [Matrix.mul_apply, Fin.sum_univ_succ]
  all_goals fin_cases i <;> fin_cases j <;> norm_num

/-- A symmetric four-momentum quadratic form invariant under the displayed
finite Lorentz audit is a scalar multiple of the Minkowski metric. -/
theorem quadratic_casimir_unique (Q : Mat4)
    (hSymm : Q.IsSymm)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q) :
    Q = Q 0 0 • eta := by
  simp only [Preserves] at hXY hXZ hRotXY hRotYZ hBoost
  have eqXY01 := congrFun (congrFun hXY 0) 1
  have eqXY02 := congrFun (congrFun hXY 0) 2
  have eqXY13 := congrFun (congrFun hXY 1) 3
  have eqXY23 := congrFun (congrFun hXY 2) 3
  have eqXZ01 := congrFun (congrFun hXZ 0) 1
  have eqXZ03 := congrFun (congrFun hXZ 0) 3
  have eqXZ12 := congrFun (congrFun hXZ 1) 2
  have eqRotXY01 := congrFun (congrFun hRotXY 0) 1
  have eqRotXY02 := congrFun (congrFun hRotXY 0) 2
  have eqRotXY11 := congrFun (congrFun hRotXY 1) 1
  have eqRotXY12 := congrFun (congrFun hRotXY 1) 2
  have eqRotXY22 := congrFun (congrFun hRotXY 2) 2
  have eqRotYZ12 := congrFun (congrFun hRotYZ 1) 2
  have eqRotYZ13 := congrFun (congrFun hRotYZ 1) 3
  have eqRotYZ23 := congrFun (congrFun hRotYZ 2) 3
  have eqRotYZ00 := congrFun (congrFun hRotYZ 0) 0
  have eqRotYZ11 := congrFun (congrFun hRotYZ 1) 1
  have eqRotYZ22 := congrFun (congrFun hRotYZ 2) 2
  have eqRotYZ33 := congrFun (congrFun hRotYZ 3) 3
  have eqRotXY00 := congrFun (congrFun hRotXY 0) 0
  have eqRotXY33 := congrFun (congrFun hRotXY 3) 3
  have eqBoost01 := congrFun (congrFun hBoost 0) 1
  have eqBoost02 := congrFun (congrFun hBoost 0) 2
  have eqBoost03 := congrFun (congrFun hBoost 0) 3
  have eqBoost12 := congrFun (congrFun hBoost 1) 2
  have eqBoost13 := congrFun (congrFun hBoost 1) 3
  have eqBoost23 := congrFun (congrFun hBoost 2) 3
  have eqBoost00 := congrFun (congrFun hBoost 0) 0
  have eqBoost11 := congrFun (congrFun hBoost 1) 1
  have eqBoost22 := congrFun (congrFun hBoost 2) 2
  have eqBoost33 := congrFun (congrFun hBoost 3) 3
  simp [halfTurnXY, halfTurnXZ, quarterTurnXY, quarterTurnYZ, rationalBoostX, Matrix.mul_apply, Fin.sum_univ_four] at eqXY01 eqXY02 eqXY13 eqXY23 eqXZ01 eqXZ03 eqXZ12 eqRotXY01 eqRotXY02 eqRotXY11 eqRotXY12 eqRotXY22 eqRotYZ12 eqRotYZ13 eqRotYZ23 eqBoost01 eqBoost02 eqBoost03 eqBoost12 eqBoost13 eqBoost23 eqRotXY00 eqRotXY11 eqRotXY22 eqRotXY33 eqRotYZ00 eqRotYZ11 eqRotYZ22 eqRotYZ33 eqBoost00 eqBoost11 eqBoost22 eqBoost33
  have h01 : Q 0 1 = 0 := by linarith
  have h02 : Q 0 2 = 0 := by linarith
  have h03 : Q 0 3 = 0 := by linarith
  have h12 : Q 1 2 = 0 := by linarith
  have h13 : Q 1 3 = 0 := by linarith
  have h23 : Q 2 3 = 0 := by linarith
  have h22 : Q 2 2 = Q 1 1 := by linarith
  have h33 : Q 3 3 = Q 2 2 := by linarith
  have hSymm01 : Q 1 0 = Q 0 1 := hSymm.apply 0 1
  have hSymm02 : Q 2 0 = Q 0 2 := hSymm.apply 0 2
  have hSymm03 : Q 3 0 = Q 0 3 := hSymm.apply 0 3
  have hSymm12 : Q 2 1 = Q 1 2 := hSymm.apply 1 2
  have hSymm13 : Q 3 1 = Q 1 3 := hSymm.apply 1 3
  have hSymm23 : Q 3 2 = Q 2 3 := hSymm.apply 2 3
  have h11 : Q 1 1 = -Q 0 0 := by linarith
  have h22' : Q 2 2 = -Q 0 0 := by linarith
  have h33' : Q 3 3 = -Q 0 0 := by linarith
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [eta, h01, h02, h03, h12, h13, h23, hSymm01, hSymm02, hSymm03,
      hSymm12, hSymm13, hSymm23, h11, h22', h33']

/-- Normalizing the time-time coefficient to one fixes the standard metric. -/
theorem normalized_quadratic_casimir_unique (Q : Mat4)
    (hSymm : Q.IsSymm)
    (h00 : Q 0 0 = 1)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q) :
    Q = eta := by
  rw [quadratic_casimir_unique Q hSymm hXY hXZ hRotXY hRotYZ hBoost, h00,
    one_smul]

/-- Under the displayed symmetry audit and standard normalization, the unique
quadratic value is exactly the Minkowski square used in the null-edge theorem. -/
theorem normalized_quadraticValue_eq_minkowskiSq (Q : Mat4)
    (hSymm : Q.IsSymm)
    (h00 : Q 0 0 = 1)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q)
    (p : Vec4) :
    quadraticValue Q p = minkowskiSq p := by
  rw [normalized_quadratic_casimir_unique Q hSymm h00 hXY hXZ hRotXY hRotYZ hBoost]
  exact quadraticValue_eta_eq_minkowskiSq p

/-- **Lorentz-audited null-edge kinematic completeness.** For any normalized
symmetric quadratic form passing the displayed finite Lorentz audit, every
future-causal momentum is a finite sum of explicitly future-pointing null
spinor edges, and the audited quadratic value equals their total pairwise
Pluecker mass.

This theorem is complete only at the level of kinematic representation. It
does not select the momentum, its scale, or its generating dynamics. -/
theorem lorentzAudited_nullEdge_mass_complete (Q : Mat4)
    (hSymm : Q.IsSymm)
    (h00 : Q 0 0 = 1)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q)
    (p : Vec4) (hp : ForwardCone p) :
    ∃ (n : Nat) (psi : Fin n -> CSpinor),
      p = vecOfHerm (finBundleMomentum psi) /\
      (forall i,
        minkowskiSq
            (PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector (psi i)) = 0 /\
          0 <=
            (PhysicsSM.Draft.NullEdge.NullEdgeSpinorSoldering.nullEdgeVector (psi i)) 0) /\
      quadraticValue Q p = finPairwisePluckerMassReal psi := by
  obtain ⟨n, psi, hpvec, hnull, hmass⟩ :=
    forwardCone_complete_futureNullEdge_representation p hp
  refine ⟨n, psi, hpvec, hnull, ?_⟩
  rw [normalized_quadraticValue_eq_minkowskiSq Q hSymm h00 hXY hXZ hRotXY hRotYZ hBoost,
    hmass]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir.audit_witnesses_preserve_eta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms audit_witnesses_preserve_eta

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir.quadratic_casimir_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quadratic_casimir_unique

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir.normalized_quadratic_casimir_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalized_quadratic_casimir_unique

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir.normalized_quadraticValue_eq_minkowskiSq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalized_quadraticValue_eq_minkowskiSq

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir.lorentzAudited_nullEdge_mass_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzAudited_nullEdge_mass_complete

end PhysicsSM.Draft.NullEdge.FiniteLorentzMassCasimir
