import Mathlib
import PhysicsSM.StandardModel.AnomalyPackage

/-!
# Family anomaly naturality

This module proves that all Standard Model anomaly coefficients and
anomaly-freedom predicates are invariant under relabeling of chiral
multiplets. More precisely, changing only the `label` field of a
`ChiralMultiplet` (which is a human-readable string with no physical
content) leaves every anomaly coefficient unchanged.

This is the anomaly-facing half of the family-symmetry naturality track:
family copies may have different labels, but if their colour representation,
weak representation, and hypercharge agree, then all anomaly coefficients
and anomaly-freedom predicates are unchanged.

## Claim boundary

This file proves anomaly naturality under label changes and gauge-data
preserving family copies. It does not assert that a particular triality or
`S₃` model supplies the physical family symmetry.

## Convention

Trusted module: all proofs are complete and no placeholder declarations are used.
-/

namespace PhysicsSM.StandardModel.FamilyAnomalyNaturality

open PhysicsSM.StandardModel.AnomalyPackage

/-! ## Gauge-data equivalence -/

/--
Two chiral multiplets have the same gauge data if they agree on colour
representation, weak representation, and hypercharge. The `label` field
is explicitly not compared.
-/
def SameGaugeData (m n : ChiralMultiplet) : Prop :=
  n.color = m.color ∧ n.weak = m.weak ∧ n.hypercharge = m.hypercharge

theorem SameGaugeData.colorMultiplicity {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    n.colorMultiplicity = m.colorMultiplicity := by
  simp only [ChiralMultiplet.colorMultiplicity, h.1]

theorem SameGaugeData.weakMultiplicity {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    n.weakMultiplicity = m.weakMultiplicity := by
  simp only [ChiralMultiplet.weakMultiplicity, h.2.1]

theorem SameGaugeData.totalMultiplicity {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    n.totalMultiplicity = m.totalMultiplicity := by
  simp only [ChiralMultiplet.totalMultiplicity, h.colorMultiplicity, h.weakMultiplicity]

/-! ### Per-multiplet contribution preservation

Each anomaly coefficient is a sum of per-multiplet contributions.
We show that `SameGaugeData` preserves each per-multiplet contribution.
-/

theorem SameGaugeData.gravitationalU1_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    ((n.totalMultiplicity : Nat) : Rat) * n.hypercharge =
    ((m.totalMultiplicity : Nat) : Rat) * m.hypercharge := by
  rw [h.totalMultiplicity, h.2.2]

theorem SameGaugeData.u1Cubed_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    ((n.totalMultiplicity : Nat) : Rat) * n.hypercharge ^ 3 =
    ((m.totalMultiplicity : Nat) : Rat) * m.hypercharge ^ 3 := by
  rw [h.totalMultiplicity, h.2.2]

theorem SameGaugeData.su2SquaredU1_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    (if n.weak.isDoublet then ((n.colorMultiplicity : Nat) : Rat) * n.hypercharge else 0) =
    (if m.weak.isDoublet then ((m.colorMultiplicity : Nat) : Rat) * m.hypercharge else 0) := by
  rw [h.2.1, h.colorMultiplicity, h.2.2]

theorem SameGaugeData.su3SquaredU1_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    (if n.color.isColored then ((n.weakMultiplicity : Nat) : Rat) * n.hypercharge else 0) =
    (if m.color.isColored then ((m.weakMultiplicity : Nat) : Rat) * m.hypercharge else 0) := by
  rw [h.1, h.weakMultiplicity, h.2.2]

theorem SameGaugeData.su3Cubed_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    (n.weakMultiplicity : Int) * n.color.cubicIndex =
    (m.weakMultiplicity : Int) * m.color.cubicIndex := by
  rw [h.weakMultiplicity, h.1]

theorem SameGaugeData.weakDoubletCount_contribution {m n : ChiralMultiplet}
    (h : SameGaugeData m n) :
    (if n.weak.isDoublet then n.colorMultiplicity else 0) =
    (if m.weak.isDoublet then m.colorMultiplicity else 0) := by
  rw [h.2.1, h.colorMultiplicity]

/-! ## Label relabeling -/

/--
Relabel a single multiplet by changing only its `label` field.
All gauge data (colour, weak, hypercharge) are preserved.
-/
def relabelMultiplet (newLabel : ChiralMultiplet → String)
    (m : ChiralMultiplet) : ChiralMultiplet :=
  { m with label := newLabel m }

/-- Relabel all multiplets in a list. -/
def relabelMultiplets (newLabel : ChiralMultiplet → String)
    (ms : List ChiralMultiplet) : List ChiralMultiplet :=
  ms.map (relabelMultiplet newLabel)

/-- Relabeling preserves gauge data. -/
theorem relabelMultiplet_sameGaugeData (newLabel : ChiralMultiplet → String)
    (m : ChiralMultiplet) :
    SameGaugeData m (relabelMultiplet newLabel m) :=
  ⟨rfl, rfl, rfl⟩

/-! ## Anomaly coefficient invariance under relabeling -/

theorem gravitationalU1Anomaly_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    gravitationalU1Anomaly (relabelMultiplets newLabel ms) =
    gravitationalU1Anomaly ms := by
  simp only [gravitationalU1Anomaly, relabelMultiplets, List.map_map]
  congr 1

theorem u1CubedAnomaly_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    u1CubedAnomaly (relabelMultiplets newLabel ms) =
    u1CubedAnomaly ms := by
  simp only [u1CubedAnomaly, relabelMultiplets, List.map_map]
  congr 1

theorem su2SquaredU1Anomaly_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    su2SquaredU1Anomaly (relabelMultiplets newLabel ms) =
    su2SquaredU1Anomaly ms := by
  simp only [su2SquaredU1Anomaly, relabelMultiplets, List.map_map]
  congr 1

theorem su3SquaredU1Anomaly_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    su3SquaredU1Anomaly (relabelMultiplets newLabel ms) =
    su3SquaredU1Anomaly ms := by
  simp only [su3SquaredU1Anomaly, relabelMultiplets, List.map_map]
  congr 1

theorem su3CubedAnomaly_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    su3CubedAnomaly (relabelMultiplets newLabel ms) =
    su3CubedAnomaly ms := by
  simp only [su3CubedAnomaly, relabelMultiplets, List.map_map]
  congr 1

theorem weakDoubletCount_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet) :
    weakDoubletCount (relabelMultiplets newLabel ms) =
    weakDoubletCount ms := by
  simp only [weakDoubletCount, relabelMultiplets, List.map_map]
  congr 1

/-! ## Predicate-level naturality -/

/--
Local anomaly freedom is preserved under relabeling.

If a multiplet list is locally anomaly free, then any relabeling of that
list is also locally anomaly free. This is immediate from the invariance
of each anomaly coefficient under relabeling.
-/
theorem LocalAnomalyFree.relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet)
    (h : LocalAnomalyFree ms) :
    LocalAnomalyFree (relabelMultiplets newLabel ms) where
  gravitational_u1 := by rw [gravitationalU1Anomaly_relabel]; exact h.gravitational_u1
  u1_cubed         := by rw [u1CubedAnomaly_relabel]; exact h.u1_cubed
  su2_squared_u1   := by rw [su2SquaredU1Anomaly_relabel]; exact h.su2_squared_u1
  su3_squared_u1   := by rw [su3SquaredU1Anomaly_relabel]; exact h.su3_squared_u1
  su3_cubed        := by rw [su3CubedAnomaly_relabel]; exact h.su3_cubed

/--
Witten SU(2) anomaly freedom is preserved under relabeling.

If the weak doublet count is even before relabeling, it remains even after
relabeling, since the count depends only on gauge data.
-/
theorem WittenSU2AnomalyFree_relabel
    (newLabel : ChiralMultiplet → String) (ms : List ChiralMultiplet)
    (h : WittenSU2AnomalyFree ms) :
    WittenSU2AnomalyFree (relabelMultiplets newLabel ms) := by
  unfold WittenSU2AnomalyFree
  rw [weakDoubletCount_relabel]
  exact h

/--
The Standard Model one-generation table remains fully anomaly free
under any relabeling of multiplet names.

This combines `LocalAnomalyFree.relabel` and `WittenSU2AnomalyFree_relabel`
with the established one-generation anomaly-freedom results.
-/
theorem standardModelOneGeneration_relabel_anomalyFree
    (newLabel : ChiralMultiplet → String) :
    LocalAnomalyFree
      (relabelMultiplets newLabel standardModelOneGeneration) ∧
    WittenSU2AnomalyFree
      (relabelMultiplets newLabel standardModelOneGeneration) :=
  ⟨LocalAnomalyFree.relabel newLabel _ standardModelOneGeneration_localAnomalyFree,
   WittenSU2AnomalyFree_relabel newLabel _ standardModelOneGeneration_wittenAnomalyFree⟩

end PhysicsSM.StandardModel.FamilyAnomalyNaturality
