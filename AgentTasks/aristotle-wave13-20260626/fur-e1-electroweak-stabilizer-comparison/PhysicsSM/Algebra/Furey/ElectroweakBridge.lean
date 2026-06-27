import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# Furey electroweak bridge

This module records the next trusted bridge between the Furey `Q_op` charge
table on the Jbar sector and the conventional one-generation Standard Model
left-handed multiplets.

Claim boundary: the weak-isospin values `targetT3` are an explicit Standard
Model target table. They are not derived here from the Furey ladder algebra.
The hypercharge table is then computed from

```text
Y = 2 * (Q - T3)
```

using the convention `Q = T3 + Y / 2`.

Source notes:
- Cohl Furey, "Charge quantization from a number operator", Phys. Lett. B 742
  (2015), 195.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of
  division algebraic ladder operators", Eur. Phys. J. C 78 (2018), 375.
- Peskin and Schroeder, Section 20.2, and Weinberg, QFT volume 2, for the
  conventional electroweak assignments.

Provenance: integrated from Aristotle job
`9d206a15-53b7-4350-9f42-3292d67e2444`, with local review and ASCII cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.ElectroweakBridge

open PhysicsSM.StandardModel.OneGenerationTable

/-! ## Finite Jbar state table -/

/-- The eight fermion states in the Furey Jbar sector, indexed by `Fin 8`. -/
abbrev JbarState := Fin 8

/--
Physical electric charge for the Jbar states.

These are the physical particle charges used in the Standard Model table, not
raw `Q_op` eigenvalues. The up-quark states have physical charge `2 / 3`,
whereas the raw Furey `Q_op` values recorded below have value `-2 / 3`.
-/
def physicalQ (s : JbarState) : Rat :=
  match s.val with
  | 0 => 0
  | 1 => -1 / 3
  | 2 => -1 / 3
  | 3 => -1 / 3
  | 4 => 2 / 3
  | 5 => 2 / 3
  | 6 => 2 / 3
  | _ => -1

/--
The raw `Q_op` eigenvalues on Jbar states, matching the finite table proved in
`PhysicsSM.Algebra.Furey.AnomalyBridge`.
-/
def rawQop (s : JbarState) : Rat :=
  match s.val with
  | 0 => 0
  | 1 => -1 / 3
  | 2 => -1 / 3
  | 3 => -1 / 3
  | 4 => -2 / 3
  | 5 => -2 / 3
  | 6 => -2 / 3
  | _ => -1

/--
For the neutrino, down quarks, and electron, the physical charge equals the raw
`Q_op` value.
-/
theorem physicalQ_eq_rawQop_leptonDown :
    forall s : JbarState,
      s.val = 0 \/ s.val = 1 \/ s.val = 2 \/ s.val = 3 \/ s.val = 7 ->
        physicalQ s = rawQop s := by
  intro s hs
  fin_cases s <;> simp_all [physicalQ, rawQop]

/--
For the up-quark states, the physical charge is the negation of the raw `Q_op`
value. This is the explicit sign bridge for indices 4, 5, and 6.
-/
theorem physicalQ_neg_rawQop_up :
    forall s : JbarState,
      s.val = 4 \/ s.val = 5 \/ s.val = 6 ->
        physicalQ s = -rawQop s := by
  intro s hs
  fin_cases s <;> simp_all [physicalQ, rawQop] <;> norm_num

/-! ## Target weak isospin and computed hypercharge -/

/--
Target weak-isospin third component for the Jbar states.

These values are conventional left-handed Standard Model assignments:
neutrino and up quarks are upper components, electron and down quarks are lower
components. They are not derived from the Furey algebra in this module.
-/
def targetT3 (s : JbarState) : Rat :=
  match s.val with
  | 0 => 1 / 2
  | 1 => -1 / 2
  | 2 => -1 / 2
  | 3 => -1 / 2
  | 4 => 1 / 2
  | 5 => 1 / 2
  | 6 => 1 / 2
  | _ => -1 / 2

/-- Target hypercharge, computed from `Y = 2 * (Q - T3)`. -/
def targetY (s : JbarState) : Rat :=
  2 * (physicalQ s - targetT3 s)

/-- Gell-Mann-Nishijima, `Q = T3 + Y / 2`, for every Jbar state. -/
theorem gellMannNishijima_all :
    forall s : JbarState, physicalQ s = targetT3 s + targetY s / 2 := by
  intro s
  simp only [targetY]
  ring

/-- The computed hypercharge values for all eight Jbar states. -/
theorem targetY_values :
    (List.finRange 8).map targetY =
      [-1, 1 / 3, 1 / 3, 1 / 3, 1 / 3, 1 / 3, 1 / 3, -1] := by
  change [targetY 0, targetY 1, targetY 2, targetY 3,
          targetY 4, targetY 5, targetY 6, targetY 7] =
      [-1, 1 / 3, 1 / 3, 1 / 3, 1 / 3, 1 / 3, 1 / 3, -1]
  simp [targetY, physicalQ, targetT3]
  norm_num

/-! ## Multiplet classification -/

/-- The two left-handed Standard Model multiplet types visible in the Jbar table. -/
inductive JbarMultiplet where
  /-- The left-handed lepton doublet, containing the neutrino and electron. -/
  | leptonDoublet
  /-- The left-handed quark doublet, with three color copies. -/
  | quarkDoublet
deriving DecidableEq, Repr

/-- Classify each Jbar state into its left-handed Standard Model multiplet. -/
def stateMultiplet (s : JbarState) : JbarMultiplet :=
  match s.val with
  | 0 => .leptonDoublet
  | 7 => .leptonDoublet
  | _ => .quarkDoublet

/-- The lepton doublet has exactly two states. -/
theorem leptonDoublet_card :
    ((List.finRange 8).filter
      (fun s => stateMultiplet s == .leptonDoublet)).length = 2 := by
  decide

/-- The quark doublet has exactly six states, three colors times two flavors. -/
theorem quarkDoublet_card :
    ((List.finRange 8).filter
      (fun s => stateMultiplet s == .quarkDoublet)).length = 6 := by
  decide

/-- The color dimension of the lepton doublet is one. -/
def leptonDoublet_colorDim : Nat := 1

/-- The weak dimension of the lepton doublet is two. -/
def leptonDoublet_weakDim : Nat := 2

/-- The color dimension of the quark doublet is three. -/
def quarkDoublet_colorDim : Nat := 3

/-- The weak dimension of the quark doublet is two. -/
def quarkDoublet_weakDim : Nat := 2

/-- All lepton-doublet Jbar states have hypercharge `-1`. -/
theorem leptonDoublet_hypercharge :
    forall s : JbarState, stateMultiplet s = .leptonDoublet -> targetY s = -1 := by
  intro s hs
  fin_cases s <;> simp_all [stateMultiplet, targetY, physicalQ, targetT3]
  all_goals norm_num

/-- All quark-doublet Jbar states have hypercharge `1 / 3`. -/
theorem quarkDoublet_hypercharge :
    forall s : JbarState, stateMultiplet s = .quarkDoublet -> targetY s = 1 / 3 := by
  intro s hs
  fin_cases s <;> simp_all [stateMultiplet, targetY, physicalQ, targetT3] <;> norm_num

/-- The lepton doublet state count equals `colorDim * weakDim`. -/
theorem leptonDoublet_stateCount :
    ((List.finRange 8).filter
      (fun s => stateMultiplet s == .leptonDoublet)).length =
        leptonDoublet_colorDim * leptonDoublet_weakDim := by
  decide

/-- The quark doublet state count equals `colorDim * weakDim`. -/
theorem quarkDoublet_stateCount :
    ((List.finRange 8).filter
      (fun s => stateMultiplet s == .quarkDoublet)).length =
        quarkDoublet_colorDim * quarkDoublet_weakDim := by
  decide

/-! ## Comparison with the conventional one-generation table -/

/-- The Jbar lepton doublet matches `L_L` in dimensions and hypercharge. -/
theorem Jbar_leptonDoublet_matches_L_L :
    And (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L)
      (And (leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L)
        (forall s : JbarState,
          stateMultiplet s = .leptonDoublet ->
            targetY s = PhysicalMultiplet.hypercharge .L_L)) := by
  exact And.intro rfl (And.intro rfl leptonDoublet_hypercharge)

/-- The Jbar quark doublet matches `Q_L` in dimensions and hypercharge. -/
theorem Jbar_quarkDoublet_matches_Q_L :
    And (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L)
      (And (quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L)
        (forall s : JbarState,
          stateMultiplet s = .quarkDoublet ->
            targetY s = PhysicalMultiplet.hypercharge .Q_L)) := by
  exact And.intro rfl (And.intro rfl quarkDoublet_hypercharge)

/--
Main bridge theorem: the Jbar left-handed multiplets match `Q_L` and `L_L` in
color dimension, weak dimension, and hypercharge after inserting the target
weak-isospin table.
-/
theorem Jbar_left_multiplets_match_Q_L_L_L :
    And
      (And (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L)
        (And (quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L)
          (forall s : JbarState,
            stateMultiplet s = .quarkDoublet ->
              targetY s = PhysicalMultiplet.hypercharge .Q_L)))
      (And (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L)
        (And (leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L)
          (forall s : JbarState,
            stateMultiplet s = .leptonDoublet ->
              targetY s = PhysicalMultiplet.hypercharge .L_L))) := by
  exact And.intro Jbar_quarkDoublet_matches_Q_L Jbar_leptonDoublet_matches_L_L

/-! ## Right-handed sector claim boundary -/

/--
The right-handed singlet sector is not realized by this Jbar-left-doublet
bridge. This proposition is deliberately just `True`, serving as a
machine-readable claim boundary rather than a physics theorem.
-/
def FureyRightHandedSectorOpen : Prop := True

/-- The right-handed-sector claim boundary is inhabited. -/
theorem fureyRightHandedSectorOpen : FureyRightHandedSectorOpen :=
  trivial

/-- The physical right-handed multiplets not matched by this Jbar bridge. -/
def unmatchedRightHandedMultiplets : List PhysicalMultiplet :=
  [.u_R, .d_R, .e_R, .nu_R]

/-- There are four unmatched right-handed multiplets. -/
theorem unmatchedRightHanded_count :
    unmatchedRightHandedMultiplets.length = 4 := by
  decide

/-- Every multiplet in `unmatchedRightHandedMultiplets` is right-handed. -/
theorem unmatchedRightHanded_chirality :
    forall m : PhysicalMultiplet,
      List.Mem m unmatchedRightHandedMultiplets -> m.chirality = .right := by
  intro m hm
  change List.Mem m
    [PhysicalMultiplet.u_R, PhysicalMultiplet.d_R,
      PhysicalMultiplet.e_R, PhysicalMultiplet.nu_R] at hm
  cases hm with
  | head _ =>
      rfl
  | tail _ hm1 =>
      cases hm1 with
      | head _ =>
          rfl
      | tail _ hm2 =>
          cases hm2 with
          | head _ =>
              rfl
          | tail _ hm3 =>
              cases hm3 with
              | head _ =>
                  rfl
              | tail _ hm4 =>
                  cases hm4

end PhysicsSM.Algebra.Furey.ElectroweakBridge
