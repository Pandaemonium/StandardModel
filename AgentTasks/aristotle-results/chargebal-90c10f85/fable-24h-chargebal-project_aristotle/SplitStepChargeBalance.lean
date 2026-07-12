import Mathlib

/-!
# Charge balance of the split-step walk's crossing census (fixtures)

The corrected strict-3+1 program defines the local charge of a
nondegenerate two-band crossing as the sign of the exact real `3 x 3`
crossing Jacobian (velocity matrix).  An exact oracle (2026-07-11) ran
the Schur-reduction recipe on the null-edge Paper A massive split walk
(3-4-5 mass angle) at all eight crossing nodes
`q_j in {pi/2, 3pi/2}` and both quasienergy gaps, with the result that
the entire census involves exactly TWO Jacobians:

  `Jplus  = (4/5) * diag(-1, 1, -1)`   (det = +64/125),
  `Jminus = -Jplus`                     (det = -64/125),

distributed by the parity of the number of `3pi/2` coordinates: at gap
`0` the node with `t` such coordinates carries `Jplus` iff `t` is even;
at gap `pi` the assignment is reversed.  Consequently:

* every node is a nondegenerate cone (`det = +-64/125 = +-cos^3` of the
  mass angle - never zero on the principal branch);
* per node, the two gap charges are opposite (Floquet pairing with the
  `s`-orientation flip);
* the eight charges sum to zero at each gap separately.

This file states the fixture-level census.  The symbol-to-Jacobian
derivation (Schur reduction of the live Bloch symbol) is deliberately
NOT claimed here; these are the oracle-extracted jets, stated as
explicit matrices, with the sign and sum theorems kernel-checked.

## Targets (all kernel; no native_decide)

T1: `Jplus.det = 64/125` and `Jminus.det = -64/125`; the sign-charges
are `+1` and `-1` (state via the local definition `chargeOf` below,
mirroring the landed `SU2LocalCrossingCharge.localCrossingCharge`).

T2 (census function + Floquet opposition): with
`census : (Fin 2 -> Fin 2 -> Fin 2) -> Bool -> J3` assigning each node
(three bits) and gap (`false` = gap 0, `true` = gap pi) its Jacobian by
the parity rule, prove `chargeOf (census n false) = -(chargeOf (census n true))`
for every node `n`.

T3 (sum zero per gap): the sum over the eight nodes of
`chargeOf (census n g)` is `0` for each gap `g`.

Statements must not be weakened; if any arithmetic fails, prove the
corrected identity, name it, stop.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SplitStepChargeBalance

abbrev J3 := Matrix (Fin 3) (Fin 3) ℝ

/-- Sign charge of a crossing Jacobian (mirrors
`SU2LocalCrossingCharge.localCrossingCharge`). -/
noncomputable def chargeOf (J : J3) : ℤ :=
  if 0 < J.det then 1 else if J.det < 0 then -1 else 0

/-- The positive-orientation Jacobian of the split-step census. -/
def Jplus : J3 := !![-(4/5 : ℝ), 0, 0; 0, (4/5 : ℝ), 0; 0, 0, -(4/5 : ℝ)]

/-- The negative-orientation Jacobian. -/
def Jminus : J3 := -Jplus

/-- Parity of a node's `3pi/2`-coordinate count (node = three bits,
`true` meaning the coordinate is `3pi/2`). -/
def nodeParity (n : Fin 3 → Bool) : Bool :=
  Bool.xor (Bool.xor (n 0) (n 1)) (n 2)

/-- The census: gap 0 (`g = false`) carries `Jplus` at even nodes;
gap pi reverses the assignment. -/
def census (n : Fin 3 → Bool) (g : Bool) : J3 :=
  if Bool.xor (nodeParity n) g then Jminus else Jplus

/-- T1a: the positive Jacobian has determinant `64/125` and charge `+1`. -/
theorem Jplus_det_charge : Jplus.det = 64/125 ∧ chargeOf Jplus = 1 := by
  have h : Jplus.det = 64/125 := by
    simp [Jplus, Matrix.det_fin_three]; norm_num
  refine ⟨h, ?_⟩
  unfold chargeOf; rw [h]; norm_num

/-- T1b: the negative Jacobian has determinant `-64/125` and charge `-1`. -/
theorem Jminus_det_charge : Jminus.det = -(64/125) ∧ chargeOf Jminus = -1 := by
  have h : Jminus.det = -(64/125) := by
    simp [Jminus, Jplus, Matrix.det_fin_three]; norm_num
  refine ⟨h, ?_⟩
  unfold chargeOf; rw [h]; norm_num

/-- The charge of `Jplus` is `+1`. -/
theorem chargeOf_Jplus : chargeOf Jplus = 1 := Jplus_det_charge.2

/-- The charge of `Jminus` is `-1`. -/
theorem chargeOf_Jminus : chargeOf Jminus = -1 := Jminus_det_charge.2

/-- The charge of a census node reduces to the parity-selected sign `±1`. -/
theorem chargeOf_census (n : Fin 3 → Bool) (g : Bool) :
    chargeOf (census n g) = if Bool.xor (nodeParity n) g then -1 else 1 := by
  unfold census
  cases Bool.xor (nodeParity n) g <;> simp [chargeOf_Jplus, chargeOf_Jminus]

/-- T2: per node, the two gap charges are opposite (Floquet pairing). -/
theorem census_floquet_opposition (n : Fin 3 → Bool) :
    chargeOf (census n false) = -(chargeOf (census n true)) := by
  unfold census
  cases nodeParity n <;> simp [chargeOf_Jplus, chargeOf_Jminus]

/-- T3: the eight node charges sum to zero at each gap. -/
theorem census_sum_zero (g : Bool) :
    (Finset.univ : Finset (Fin 2 × Fin 2 × Fin 2)).sum
        (fun t => chargeOf (census (fun i =>
          if i = 0 then t.1 = 1 else if i = 1 then t.2.1 = 1 else t.2.2 = 1) g))
      = 0 := by
  simp only [chargeOf_census]
  cases g <;> decide

end PhysicsSM.Draft.NullEdge.SplitStepChargeBalance
