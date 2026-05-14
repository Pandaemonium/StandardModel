import Mathlib.Tactic

/-!
# Furey electroweak charge table and Gell-Mann–Nishijima identity

This module defines a finite table of conventional electroweak quantum number
assignments for the eight fermion states in one Furey sector (the Jbar ideal)
and proves the Gell-Mann–Nishijima identity `Q = T₃ + Y / 2` for every entry.

## Claim boundary

**This is a conventional charge table bridge, not a derivation of weak isospin
from octonionic ladder operators.** The values of `T₃` (weak isospin third
component) and `Y` (weak hypercharge) are taken from the Standard Model
literature and recorded here so that downstream modules can connect Furey's
`Q_op` eigenvalues to the full electroweak quantum numbers.

A future module should derive `T₃` from Furey's quaternionic or Dixon-algebra
structure; until that derivation exists, this table is simply a trusted
bookkeeping device.

## Sector: Jbar (particle) states

The eight states of the Jbar ideal correspond to one generation of Standard
Model fermions (particles, not antiparticles):

| Index | State   | Particle            | Q    | T₃   | Y    |
|-------|---------|---------------------|------|-------|------|
|   0   | omega-bar       | neutrino nu_e         |  0   | +1/2  | -1   |
|   1   | v-bar_1      | down quark d (red)  | -1/3 | -1/2  | +1/3 |
|   2   | v-bar_2      | down quark d (green)| -1/3 | -1/2  | +1/3 |
|   3   | v-bar_3      | down quark d (blue) | -1/3 | -1/2  | +1/3 |
|   4   | v-bar_4      | up quark u (red)    | +2/3 | +1/2  | +1/3 |
|   5   | v-bar_5      | up quark u (green)  | +2/3 | +1/2  | +1/3 |
|   6   | v-bar_6      | up quark u (blue)   | +2/3 | +1/2  | +1/3 |
|   7   | nu-bar        | electron e-         | -1   | -1/2  | -1   |

The signs follow the Peskin-Schroeder / Weinberg convention `Q = T₃ + Y / 2`.

Note: the charge assignments in `AnomalyBridge.lean` list the `Q_op`
eigenvalues as `{0, -1/3, -1/3, -1/3, -2/3, -2/3, -2/3, -1}` for the Jbar
states. That table uses Furey's convention where the `Q_op` eigenvalue is
the *negative* of the physical electric charge for the particle states
(because Furey's `Q_op` is defined via `Q = -(1/3)(N₁+N₂+N₃)` which gives
the antiparticle charge on J). In the present table, we use the physical
electric charge `Q` directly, so e.g. the up quark has `Q = +2/3`.

## Sources

- M. Peskin and D. Schroeder, *An Introduction to Quantum Field Theory*, §20.2.
- S. Weinberg, *The Quantum Theory of Fields*, Vol. 2, Ch. 21-22.
- Furey, arXiv:1806.00612 (charge operator eigenvalues on Jbar).

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey.HyperchargeBridge

/-! ## Finite state type -/

/-- The eight fermion states in one Furey sector (Jbar ideal), indexed by `Fin 8`. -/
abbrev FureyState := Fin 8

/-- Human-readable labels for the eight Jbar states.
Not used in proofs; provided for documentation. -/
def stateLabel : FureyState -> String
  | ⟨0, _⟩ => "nu_L (neutrino)"
  | ⟨1, _⟩ => "d_r (down, red)"
  | ⟨2, _⟩ => "d_g (down, green)"
  | ⟨3, _⟩ => "d_b (down, blue)"
  | ⟨4, _⟩ => "u_r (up, red)"
  | ⟨5, _⟩ => "u_g (up, green)"
  | ⟨6, _⟩ => "u_b (up, blue)"
  | ⟨7, _⟩ => "e_L (electron)"

/-! ## Quantum number assignments -/

/-- Electric charge `Q` for each Jbar state (physical convention). -/
def QValue : FureyState -> ℚ
  | ⟨0, _⟩ =>  0
  | ⟨1, _⟩ => -1/3
  | ⟨2, _⟩ => -1/3
  | ⟨3, _⟩ => -1/3
  | ⟨4, _⟩ =>  2/3
  | ⟨5, _⟩ =>  2/3
  | ⟨6, _⟩ =>  2/3
  | ⟨7, _⟩ => -1

/-- Third component of weak isospin `T₃` for each Jbar state.

**Convention note:** `T₃` is taken from the Standard Model literature.
It is *not* derived from the Furey ladder operators in this module.
A future derivation from the quaternionic or Dixon-algebra structure
would replace this table with a computed result. -/
def T3Value : FureyState -> ℚ
  | ⟨0, _⟩ =>  1/2
  | ⟨1, _⟩ => -1/2
  | ⟨2, _⟩ => -1/2
  | ⟨3, _⟩ => -1/2
  | ⟨4, _⟩ =>  1/2
  | ⟨5, _⟩ =>  1/2
  | ⟨6, _⟩ =>  1/2
  | ⟨7, _⟩ => -1/2

/-- Weak hypercharge `Y` for each Jbar state (Peskin-Schroeder convention). -/
def YValue : FureyState -> ℚ
  | ⟨0, _⟩ => -1
  | ⟨1, _⟩ =>  1/3
  | ⟨2, _⟩ =>  1/3
  | ⟨3, _⟩ =>  1/3
  | ⟨4, _⟩ =>  1/3
  | ⟨5, _⟩ =>  1/3
  | ⟨6, _⟩ =>  1/3
  | ⟨7, _⟩ => -1

/-! ## Gell-Mann-Nishijima identity -/

/--
**Gell-Mann-Nishijima relation** for every state in the Furey Jbar sector:
`Q = T₃ + Y / 2`.

This is verified by exact rational arithmetic over the finite table.
It does not rely on any algebraic derivation from octonionic operators;
it is pure Standard Model bookkeeping applied to the Furey state dictionary.
-/
theorem Q_eq_T3_add_halfY : ∀ (s : FureyState), QValue s = T3Value s + YValue s / 2 := by
  intro s; fin_cases s <;> simp [QValue, T3Value, YValue] <;> norm_num

/-! ## Individual state identities

For convenience, we also state the identity for each state individually.
These are immediate corollaries of `Q_eq_T3_add_halfY`. -/

theorem Q_eq_T3_add_halfY_neutrino :
    QValue ⟨0, by omega⟩ = T3Value ⟨0, by omega⟩ + YValue ⟨0, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_d_red :
    QValue ⟨1, by omega⟩ = T3Value ⟨1, by omega⟩ + YValue ⟨1, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_d_green :
    QValue ⟨2, by omega⟩ = T3Value ⟨2, by omega⟩ + YValue ⟨2, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_d_blue :
    QValue ⟨3, by omega⟩ = T3Value ⟨3, by omega⟩ + YValue ⟨3, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_u_red :
    QValue ⟨4, by omega⟩ = T3Value ⟨4, by omega⟩ + YValue ⟨4, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_u_green :
    QValue ⟨5, by omega⟩ = T3Value ⟨5, by omega⟩ + YValue ⟨5, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_u_blue :
    QValue ⟨6, by omega⟩ = T3Value ⟨6, by omega⟩ + YValue ⟨6, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

theorem Q_eq_T3_add_halfY_electron :
    QValue ⟨7, by omega⟩ = T3Value ⟨7, by omega⟩ + YValue ⟨7, by omega⟩ / 2 :=
  Q_eq_T3_add_halfY _

/-! ## Charge multiset verification

We verify that the charge multiset matches the expected Standard Model values. -/

/-- The electric charges of all 8 states, as a list. -/
def chargeList : List ℚ := (List.finRange 8).map QValue

/-- The charge multiset is `{0, -1/3, -1/3, -1/3, +2/3, +2/3, +2/3, -1}`. -/
theorem chargeList_eq :
    chargeList = [0, -1/3, -1/3, -1/3, 2/3, 2/3, 2/3, -1] := by
  simp [chargeList, List.finRange, QValue]

/-- The sum of all electric charges in the sector is zero (anomaly-cancellation
    necessary condition for the U(1)_em gravitational anomaly). -/
theorem charge_sum_zero :
    chargeList.sum = 0 := by
  simp [chargeList, List.finRange, QValue]
  norm_num

end PhysicsSM.Algebra.Furey.HyperchargeBridge
