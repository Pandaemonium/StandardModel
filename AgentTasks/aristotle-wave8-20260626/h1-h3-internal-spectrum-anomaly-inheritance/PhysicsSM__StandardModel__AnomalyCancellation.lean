import Mathlib.Tactic.NormNum

/-!
# Standard Model anomaly cancellation as exact rational arithmetic

This module records the one-generation Standard Model anomaly-cancellation
checks as small rational identities. It is deliberately modest:

- it does not formalize path integrals,
- it does not define characteristic classes,
- it does not construct anomaly polynomials,
- it does not prove the Green-Schwarz mechanism.

Instead, it verifies the exact charge sums that appear after the usual
representation-theoretic reduction of the anomaly calculation. This makes the
normalization and multiplicity conventions explicit and gives later physics
formalizations a kernel-checked arithmetic target to connect to.

## Convention

All fermions are represented as left-handed Weyl fermions. The usual
right-handed Standard Model fields are therefore represented by their
left-handed charge-conjugate fields. Hypercharge is normalized by
`Q = T3 + Y / 2`.

For one generation, the left-handed multiplets are:

* `Q_L`: color multiplicity `3`, weak multiplicity `2`, hypercharge `1/3`.
* `L_L`: color multiplicity `1`, weak multiplicity `2`, hypercharge `-1`.
* `u_R^c`: color multiplicity `3`, weak multiplicity `1`, hypercharge `-4/3`.
* `d_R^c`: color multiplicity `3`, weak multiplicity `1`, hypercharge `2/3`.
* `e_R^c`: color multiplicity `1`, weak multiplicity `1`, hypercharge `2`.

Provenance: Aristotle job `f4ff2cbc-e135-4ecc-b867-9178d66e5c6b`, reviewed and
rewritten with project-local comments and descriptive declaration names.
-/

namespace PhysicsSM.StandardModel.AnomalyCancellation

/-! ## Charge data -/

/--
The exact rational type used for anomaly-charge arithmetic.

Using `Rat` prevents floating-point normalization drift and makes every
identity in this file decidable by exact arithmetic.
-/
abbrev Charge := Rat

/--
Hypercharge of the left-handed quark doublet `Q_L`.

The multiplicity `3 * 2` is not included in this constant; multiplicities are
shown explicitly in the anomaly sums below.
-/
def quarkDoubletHypercharge : Charge := 1 / 3

/-- Hypercharge of the left-handed lepton doublet `L_L`. -/
def leptonDoubletHypercharge : Charge := -1

/--
Hypercharge of the left-handed charge-conjugate anti-up field `u_R^c`.

The sign is opposite the usual right-handed up-quark hypercharge because all
fields in this file are left-handed Weyl fields.
-/
def antiUpHypercharge : Charge := -4 / 3

/-- Hypercharge of the left-handed charge-conjugate anti-down field `d_R^c`. -/
def antiDownHypercharge : Charge := 2 / 3

/-- Hypercharge of the left-handed charge-conjugate positron field `e_R^c`. -/
def antiElectronHypercharge : Charge := 2

/-! ## Local anomaly sums -/

/--
The mixed gravitational-`U(1)_Y` anomaly sum for one generation.

Each term is multiplied by the number of Weyl fermions in the corresponding
gauge multiplet: color multiplicity times weak multiplicity.
-/
def gravitationalHyperchargeSum : Charge :=
  6 * quarkDoubletHypercharge +
  2 * leptonDoubletHypercharge +
  3 * antiUpHypercharge +
  3 * antiDownHypercharge +
  antiElectronHypercharge

/--
The mixed gravitational-`U(1)_Y` anomaly cancels for one generation.
-/
theorem gravitationalHyperchargeSum_eq_zero :
    gravitationalHyperchargeSum = 0 := by
  norm_num [gravitationalHyperchargeSum, quarkDoubletHypercharge,
    leptonDoubletHypercharge, antiUpHypercharge, antiDownHypercharge,
    antiElectronHypercharge]

/--
The cubic `U(1)_Y` anomaly sum for one generation.

The expression is `sum multiplicity * Y^3` over the five left-handed
multiplet types listed in the module docstring.
-/
def cubicHyperchargeSum : Charge :=
  6 * quarkDoubletHypercharge ^ 3 +
  2 * leptonDoubletHypercharge ^ 3 +
  3 * antiUpHypercharge ^ 3 +
  3 * antiDownHypercharge ^ 3 +
  antiElectronHypercharge ^ 3

/-- The cubic `U(1)_Y` anomaly cancels for one generation. -/
theorem cubicHyperchargeSum_eq_zero :
    cubicHyperchargeSum = 0 := by
  norm_num [cubicHyperchargeSum, quarkDoubletHypercharge,
    leptonDoubletHypercharge, antiUpHypercharge, antiDownHypercharge,
    antiElectronHypercharge]

/--
The mixed `SU(2)^2 U(1)_Y` anomaly sum.

Only weak doublets contribute. The quark doublet has three colors and the
lepton doublet has one color.
-/
def su2SquaredU1HyperchargeSum : Charge :=
  3 * quarkDoubletHypercharge + leptonDoubletHypercharge

/-- The mixed `SU(2)^2 U(1)_Y` anomaly cancels for one generation. -/
theorem su2SquaredU1HyperchargeSum_eq_zero :
    su2SquaredU1HyperchargeSum = 0 := by
  norm_num [su2SquaredU1HyperchargeSum, quarkDoubletHypercharge,
    leptonDoubletHypercharge]

/--
The mixed `SU(3)^2 U(1)_Y` anomaly sum.

Only color triplets contribute. The quark doublet contributes twice because it
has two weak components.
-/
def su3SquaredU1HyperchargeSum : Charge :=
  2 * quarkDoubletHypercharge + antiUpHypercharge + antiDownHypercharge

/-- The mixed `SU(3)^2 U(1)_Y` anomaly cancels for one generation. -/
theorem su3SquaredU1HyperchargeSum_eq_zero :
    su3SquaredU1HyperchargeSum = 0 := by
  norm_num [su3SquaredU1HyperchargeSum, quarkDoubletHypercharge,
    antiUpHypercharge, antiDownHypercharge]

/-! ## Witten global `SU(2)` anomaly -/

/--
The number of weak doublets in one generation.

There are three color copies of `Q_L` and one `L_L`, for a total of four
left-handed `SU(2)` doublets.
-/
def numberOfWeakDoublets : Nat := 4

/--
The Witten `SU(2)` global anomaly is absent because the number of weak
doublets is even.
-/
theorem numberOfWeakDoublets_even :
    Even numberOfWeakDoublets := by
  exact ⟨2, rfl⟩

end PhysicsSM.StandardModel.AnomalyCancellation
