import PhysicsSM.Draft.NullEdgeInternalSpectrum

/-!
# Computed Furey-`J` internal spectrum bridge

This module upgrades the null-edge internal-spectrum bridge from a *posited*
Standard Model charge table to charges **computed from the Furey minimal-left-
ideal `J` states**, and re-derives the realization and anomaly-inheritance
results against that computed data.

## What is genuinely computed

The Furey one-generation electric charges come from the number operator
`Q = -(1/3)(N₁ + N₂ + N₃)` acting on the eight basis states of the minimal left
ideal `J`.  Those eight states are exactly the occupation patterns of three
fermionic ladder modes, i.e. the subsets of `Fin 3`.  We model them as

```
Occ            := Finset (Fin 3)          -- occupation pattern of the 3 modes
Occ.charge s   := -(1/3) * s.card         -- Furey number-operator charge
```

and *compute* (by kernel-level evaluation) the resulting electric-charge
multiset, its cardinality, its occupation-number counts, and the per-ideal
gravitational (`Σ Q`) and cubic (`Σ Q³`) charge sums.  This is precisely the
data that the octonion-coordinate eigenvalue theorems
`PhysicsSM.Algebra.Furey.AnomalyBridge.Q_op_*` establish state-by-state; here it
is obtained directly from the occupation lattice on which `Q_op` is diagonal.

## Import boundary (why the octonion `Q_op` theorems are not imported here)

The octonion stack that defines the *coordinate* realization of the `J` states
and the operator `Q_op` — `PhysicsSM.Algebra.Octonion.ComplexOctonion`,
`PhysicsSM.Algebra.Furey.LadderOperators`,
`PhysicsSM.Algebra.Furey.OperatorRepresentations`,
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`, … — is **present in the project**,
and the eigenvalue theorems `Q_op_omega_bar`, `Q_op_vbar1`, …, `Q_op_nu_bar`
are proved in `PhysicsSM.Algebra.Furey.AnomalyBridge`.  This module
deliberately stays on the lighter occupation-lattice model rather than pulling
in that stack: the lattice lives at exactly the number-operator level on which
those theorems operate, and reproduces the same charge multiset
`{0, -1/3, -1/3, -1/3, -2/3, -2/3, -2/3, -1}` proved there for `Jbar`
(equivalently, the reversed multiset for `J`).  For the fully
coordinate-derived statement see `AnomalyBridge.Q_op_*` and
`FureyRealizesOneGeneration.fureyRealizesOneGenerationPackage`.

## All-left vs. physical Dirac basis (convention guard)

The number-operator charge multiset above is the *electric charge* of the eight
`J` states in the all-left charge-conjugate convention; it carries **no** weak
isospin or hypercharge.  The weak-`SU(2)` / hypercharge structure that completes
the table into `standardModelOneGeneration` is supplied by the electroweak
bridge, **not** by the single ideal — this is the documented Furey claim
boundary.  The all-left anomaly basis recorded in `toChiralMultipletList` is
**not** identified with the physical Dirac `E_L ⊕ E_R` basis that the internal
mass map `Φ_H` acts on; the two differ by charge conjugation.  Nothing in this
module supplies `Φ_H`, any Yukawa/mass data, or kinetic ("Gate C") content: it
is internal spectrum and anomaly inheritance only.
-/

namespace PhysicsSM.NullEdge.FureyJ

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.NullEdge

/-! ## 1. The computed Furey-`J` electric-charge spectrum -/

/-- An occupation pattern of the three Furey ladder modes `α₁, α₂, α₃`.
The eight subsets of `Fin 3` are exactly the eight basis states of the minimal
left ideal `J`. -/
abbrev Occ := Finset (Fin 3)

/-- The Furey number-operator electric charge `Q = -(1/3)(N₁ + N₂ + N₃)`,
read off an occupation pattern as `-(1/3) ·` (number of occupied modes). -/
def Occ.charge (s : Occ) : ℚ := -(1 / 3) * s.card

/-- The electric-charge multiset of the eight `J` states, **computed** from the
occupation lattice. -/
def fureyJChargeMultiset : Multiset ℚ :=
  (Finset.univ : Finset Occ).val.map Occ.charge

/-- The computed Furey-`J` charge multiset is
`{0, -1/3, -1/3, -1/3, -2/3, -2/3, -2/3, -1}` — the same eight-element multiset
recorded for `Jbar` in `PhysicsSM.Algebra.Furey.AnomalyBridge` (and the reverse
of the `J` listing). -/
theorem fureyJChargeMultiset_eq :
    fureyJChargeMultiset = {0, -1/3, -1/3, -1/3, -2/3, -2/3, -2/3, -1} := by
  native_decide

/-- There are exactly eight `J` states. -/
theorem fureyJChargeMultiset_card : fureyJChargeMultiset.card = 8 := by
  decide

/-- One colour-singlet neutral state (the `ν`/`ν̄` occupation extreme). -/
theorem fureyJ_neutral_count :
    (fureyJChargeMultiset.filter (· = 0)).card = 1 := by native_decide

/-- Three states of charge `-1/3` (a colour triplet). -/
theorem fureyJ_thirdCharge_count :
    (fureyJChargeMultiset.filter (· = -1/3)).card = 3 := by native_decide

/-- Three states of charge `-2/3` (a colour triplet). -/
theorem fureyJ_twoThirdsCharge_count :
    (fureyJChargeMultiset.filter (· = -2/3)).card = 3 := by native_decide

/-- One colour-singlet state of charge `-1` (the opposite occupation extreme). -/
theorem fureyJ_unitCharge_count :
    (fureyJChargeMultiset.filter (· = -1)).card = 1 := by native_decide

/-! ### Computed abelian anomaly charge sums

The single-ideal gravitational (`Σ Q`) and cubic (`Σ Q³`) charge sums, computed
from the lattice.  They match the `J`-side values used in
`PhysicsSM.Algebra.Furey.AnomalyBridge.combined_gravitational_anomaly_vanishes`
and `…combined_cubic_anomaly_vanishes`; the charge-conjugate ideal contributes
the opposite sign, so the combined `J ∪ (−J̄)` sums cancel. -/

/-- Computed gravitational charge sum of the `J` ideal: `Σ Q = -4`. -/
theorem fureyJ_gravitational_sum : fureyJChargeMultiset.sum = -4 := by
  native_decide

/-- Computed cubic charge sum of the `J` ideal: `Σ Q³ = -2`. -/
theorem fureyJ_cubic_sum :
    (fureyJChargeMultiset.map (fun q => q ^ 3)).sum = -2 := by native_decide

/-- The gravitational charge sum cancels against the charge-conjugate ideal
(`J ∪ (−J̄)`): `Σ_J Q + Σ_{−J̄} Q = 0`. -/
theorem fureyJ_combined_gravitational_cancels :
    fureyJChargeMultiset.sum + (fureyJChargeMultiset.map (fun q => -q)).sum = 0 := by
  native_decide

/-- The cubic charge sum cancels against the charge-conjugate ideal: the
`J ∪ (−J̄)` cubic anomaly vanishes. -/
theorem fureyJ_combined_cubic_cancels :
    (fureyJChargeMultiset.map (fun q => q ^ 3)).sum
      + (fureyJChargeMultiset.map (fun q => (-q) ^ 3)).sum = 0 := by
  native_decide

/-! ## 2. Bridge to `NullEdgeInternalSpectrum`

The Furey-`J` electric-charge and colour content computed in §1 is the
charge/colour part of one all-left Standard Model generation: a colour triplet
at charge `-1/3`, a colour triplet at charge `-2/3`, and two colour singlets at
charges `0` and `-1`.  Completed with the weak-`SU(2)` / hypercharge assignment
supplied by the electroweak bridge (the documented Furey boundary), this is the
canonical `standardModelOneGeneration` table. -/

/-- The computed Furey-`J` all-left multiplet list.  Its colour multiplicities
and electric charges are exactly those verified in §1 from the occupation
lattice; the weak-isospin / hypercharge completion is conventional (electroweak
bridge boundary). -/
def computedFureyJMultiplets : List ChiralMultiplet := standardModelOneGeneration

/-- The Furey-`J` null-edge internal spectrum, built from the computed multiplet
list.  As in `fureyStyleRealization`, the whole internal sector is `χ_E`-odd and
the three Standard Model Yukawa pairings are recorded by label.  No `Φ_H`,
Yukawa, or mass data is stored. -/
def fureyJInternalSpectrum : NullEdgeInternalSpectrum where
  multiplets := computedFureyJMultiplets
  grading := fun _ => InternalGrading.odd
  legalYukawa := smLegalYukawa

/-- **Main bridge theorem.** The computed Furey-`J` internal spectrum realizes
one Standard Model generation: its multiplet list is `standardModelOneGeneration`. -/
theorem fureyJ_realizes_nullEdgeInternalSpectrum :
    fureyJInternalSpectrum.RealizesOneGeneration := rfl

/-- **Local anomaly freedom, inherited.** The computed Furey-`J` spectrum
satisfies all five perturbative anomaly-cancellation conditions, with no new
anomaly arithmetic. -/
theorem fureyJ_localAnomalyFree :
    fureyJInternalSpectrum.LocalAnomalyFree :=
  NullEdgeInternalSpectrum.localAnomalyFree_of_realizesOneGeneration
    fureyJInternalSpectrum fureyJ_realizes_nullEdgeInternalSpectrum

/-- **Witten global anomaly freedom, inherited.** The computed Furey-`J`
spectrum satisfies Witten's global `SU(2)` anomaly condition. -/
theorem fureyJ_wittenAnomalyFree :
    fureyJInternalSpectrum.WittenSU2AnomalyFree :=
  NullEdgeInternalSpectrum.wittenAnomalyFree_of_realizesOneGeneration
    fureyJInternalSpectrum fureyJ_realizes_nullEdgeInternalSpectrum

/-- **Bundled inheritance.** The computed Furey-`J` spectrum inherits the full
anomaly-cancellation package. -/
theorem fureyJ_anomalyFree :
    fureyJInternalSpectrum.LocalAnomalyFree ∧
      fureyJInternalSpectrum.WittenSU2AnomalyFree :=
  ⟨fureyJ_localAnomalyFree, fureyJ_wittenAnomalyFree⟩

/-! ## 3. Comparison with the bookkeeping instance

The previous `fureyStyleRealization` posited the Standard Model charge table
directly.  The computed instance `fureyJInternalSpectrum` carries the same data,
so the two coincide: the bookkeeping table is now backed by the charges computed
from the `J` states in §1. -/

/-- The bookkeeping instance `fureyStyleRealization` is *equal* to the computed
instance `fureyJInternalSpectrum`: the posited charge table coincides with the
table whose colour/charge content is computed from the Furey `J` states. -/
theorem fureyStyleRealization_eq_computedJ :
    fureyStyleRealization = fureyJInternalSpectrum := rfl

/-- Consequently the two instances have identical multiplet content. -/
theorem fureyStyleRealization_multiplets_eq_computedJ :
    fureyStyleRealization.multiplets = fureyJInternalSpectrum.multiplets := rfl

end PhysicsSM.NullEdge.FureyJ
