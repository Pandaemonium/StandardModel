import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLawSUN

/-!
# Gate YM: finite center-twist partition bridge

This module is the first small bridge from the finite center-shift/electric
sector API in `CenterFluxSector` to the Tomboulis-Yaffe/Kanazawa
`TYAreaLawSUN.TwistSystem` API.

It does not construct an `SU(N)` Haar measure, derive reflection-positivity
monotonicity, prove a continuum one-form symmetry, or build an `H^2(K,Z(G))`
background field. Instead it names the finite contract that the missing
configuration-to-partition bridge must satisfy: a family of twist predicates on a
finite configuration space, a Boltzmann weight, and the three scalar facts
needed to turn the resulting finite sums into a `TwistSystem`.

Claim label: finite identity / bridge contract. Provenance: one-form symmetry
terminology follows GKSW [AXAWAGGB] only as framing; the twist-system notation
and area-law base follow Tomboulis-Yaffe 1985 [N7SIEMAC] and Kanazawa
[K9FIBTZC], as documented in `TYAreaLawSUN`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace CenterFluxSector

open TYAreaLawSUN

variable {Config Shift : Type*} {N : Nat} [NeZero N]

/-- Finite twisted partition sum for a weight and a family of twist sectors.

The predicate `twistSector k x` is deliberately abstract: in a later concrete
torus/Haar bridge it should express that configuration `x` carries the center
twist label `k`. -/
def twistedPartition [Fintype Config] (weight : Config -> Real)
    (twistSector : Fin N -> Config -> Prop) (k : Fin N) : Real := by
  classical
  exact ∑ x : Config, if twistSector k x then weight x else 0

omit [NeZero N] in
/-- Nonnegative pointwise weights give nonnegative finite twisted partition
sums. This is only positivity of a finite sum, not reflection positivity. -/
theorem twistedPartition_nonneg [Fintype Config] (weight : Config -> Real)
    (twistSector : Fin N -> Config -> Prop)
    (hweight : forall x, 0 <= weight x) (k : Fin N) :
    0 <= twistedPartition weight twistSector k := by
  classical
  unfold twistedPartition
  exact Finset.sum_nonneg (fun x _hx => by
    by_cases hx : twistSector k x
    · simpa [hx] using hweight x
    · simp [hx])

omit [NeZero N] in
/-- Reindexing a finite twisted partition sum by a center-shift permutation
does not change the value, provided both the sector predicate and the weight are
pulled back along the same permutation.

This is a finite bookkeeping identity. It is not the physical statement that a
specific action or measure is center-shift invariant. -/
theorem twistedPartition_shiftConfig_reindex [Fintype Config]
    (S : ShiftSystem Config Shift) (weight : Config -> Real)
    (twistSector : Fin N -> Config -> Prop) (s : Shift) (k : Fin N) :
    twistedPartition
        (fun x : Config => weight (S.shiftConfig s x))
        (fun k x => twistSector k (S.shiftConfig s x)) k
      = twistedPartition weight twistSector k := by
  classical
  unfold twistedPartition ShiftSystem.shiftConfig
  exact Equiv.sum_comp (S.shift s)
    (fun x : Config => if twistSector k x then weight x else 0)

/-- A purely finite sufficient condition for twist monotonicity: if every
configuration in the `k`-twisted sector also lies in the periodic sector, then
nonnegative pointwise weights give `Z_k <= Z_0`.

This is not reflection positivity. It is a bookkeeping lemma for concrete
finite models whose twist sectors are explicitly nested. -/
theorem twistedPartition_le_of_sector_subset [Fintype Config]
    (weight : Config -> Real)
    (twistSector : Fin N -> Config -> Prop)
    (hweight : forall x, 0 <= weight x) (k : Fin N)
    (hsubset : forall x, twistSector k x -> twistSector 0 x) :
    twistedPartition weight twistSector k <=
      twistedPartition weight twistSector 0 := by
  classical
  unfold twistedPartition
  apply Finset.sum_le_sum
  intro x _hx
  by_cases hk : twistSector k x
  · have h0 : twistSector 0 x := hsubset x hk
    simp [hk, h0]
  · by_cases h0 : twistSector 0 x
    · simp [hk, h0, hweight x]
    · simp [hk, h0]

/-- A finite configuration-level bridge into the abstract `TwistSystem` API.

The fields `Z_nonneg`, `Z_zero_pos`, and `Z_le` are intentionally explicit.
For a concrete lattice measure, `Z_le` is the hard reflection-positivity /
twist-monotonicity input; this structure merely records where that proof must
enter. -/
structure FiniteCenterTwistBridge (Config Shift : Type*) [Fintype Config]
    (N : Nat) [NeZero N] (S : ShiftSystem Config Shift) where
  /-- Boltzmann weight assigned to each finite configuration. -/
  weight : Config -> Real
  /-- Predicate selecting configurations in each center-twist sector. -/
  twistSector : Fin N -> Config -> Prop
  /-- Nonnegativity of every twisted finite partition sum. -/
  Z_nonneg : forall k, 0 <= twistedPartition weight twistSector k
  /-- Strict positivity of the periodic partition sum. -/
  Z_zero_pos : 0 < twistedPartition weight twistSector 0
  /-- Twist monotonicity: twisting does not increase the partition sum. -/
  Z_le : forall k,
    twistedPartition weight twistSector k <= twistedPartition weight twistSector 0

namespace FiniteCenterTwistBridge

variable [Fintype Config] {S : ShiftSystem Config Shift}

/-- Build a finite center-twist bridge from pointwise nonnegative weights,
strict positivity of the periodic partition sum, and explicit inclusion of
each twisted sector in the periodic sector.

This narrows the contract for simple finite models. It does not replace the
reflection-positivity / twist-monotonicity proof needed for an honest lattice
gauge measure. -/
def ofSectorSubset (S : ShiftSystem Config Shift)
    (weight : Config -> Real)
    (twistSector : Fin N -> Config -> Prop)
    (hweight : forall x, 0 <= weight x)
    (hzero_pos : 0 < twistedPartition weight twistSector 0)
    (hsubset : forall k x, twistSector k x -> twistSector 0 x) :
    FiniteCenterTwistBridge Config Shift N S where
  weight := weight
  twistSector := twistSector
  Z_nonneg := twistedPartition_nonneg weight twistSector hweight
  Z_zero_pos := hzero_pos
  Z_le := fun k =>
    twistedPartition_le_of_sector_subset weight twistSector hweight k
      (hsubset k)

/-- The partition family extracted from a finite center-twist bridge. -/
def Z (B : FiniteCenterTwistBridge Config Shift N S) : Fin N -> Real :=
  twistedPartition B.weight B.twistSector

/-- Convert a finite center-twist bridge into the abstract TY/Kanazawa
`TwistSystem`. -/
def toTwistSystem (B : FiniteCenterTwistBridge Config Shift N S) :
    TwistSystem N where
  Z := B.Z
  Z_nonneg := B.Z_nonneg
  Z_zero_pos := B.Z_zero_pos
  Z_le := B.Z_le

/-- The abstract twist system uses exactly the finite partition sums supplied by
the bridge. -/
@[simp]
theorem toTwistSystem_Z (B : FiniteCenterTwistBridge Config Shift N S)
    (k : Fin N) :
    B.toTwistSystem.Z k = twistedPartition B.weight B.twistSector k := rfl

/-- The periodic partition function of the induced `TwistSystem` is exactly the
finite periodic sum of the bridge. -/
@[simp]
theorem toTwistSystem_Z_zero (B : FiniteCenterTwistBridge Config Shift N S) :
    B.toTwistSystem.Z 0 = twistedPartition B.weight B.twistSector 0 := rfl

/-- The induced `TwistSystem` ratio is the corresponding finite twisted
partition ratio. -/
@[simp]
theorem toTwistSystem_ratio (B : FiniteCenterTwistBridge Config Shift N S)
    (k : Fin N) :
    B.toTwistSystem.ratio k =
      twistedPartition B.weight B.twistSector k /
        twistedPartition B.weight B.twistSector 0 := rfl

/-- The induced `tyBaseSUN` is the center-average base computed from the finite
twisted partition sums. -/
theorem toTwistSystem_tyBaseSUN_eq
    (B : FiniteCenterTwistBridge Config Shift N S) :
    B.toTwistSystem.tyBaseSUN =
      1 - (1 / (N : Real)) *
        ∑ k : Fin N,
          twistedPartition B.weight B.twistSector k /
            twistedPartition B.weight B.twistSector 0 := rfl

end FiniteCenterTwistBridge

end CenterFluxSector
end GateYM
end NullEdge
end Draft
end PhysicsSM
