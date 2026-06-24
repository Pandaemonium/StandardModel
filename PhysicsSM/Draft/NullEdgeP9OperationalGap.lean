import Mathlib.Tactic

/-!
# P9 diamond-local iso-histogram separation witness

This draft module strengthens the cheap iso-histogram guardrail. Two strict
transitive relations on `Fin 6` have the same joint in/out-degree signature and
the same global interval-abundance signature. The diamond from `0` to `4` has
the same cardinality in both relations, but its local interval-size signature
differs.

This is a finite T1 witness for the P9 gate: a diamond-local readout can
separate structures that agree on common global histogram diagnostics. It is
still a finite guardrail, not a cosmological-constant theorem; T2/T3 must test
coarse-map stability and geometry-blind noise robustness.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9OperationalGap.T1

/-- First six-point strict finite relation. -/
def relA (a b : Fin 6) : Prop :=
  (a = 0 /\ b = 1) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 0 /\ b = 5) \/
  (a = 1 /\ b = 4) \/
  (a = 1 /\ b = 5) \/
  (a = 2 /\ b = 3) \/
  (a = 2 /\ b = 4) \/
  (a = 3 /\ b = 4)

/-- Second six-point strict finite relation. -/
def relB (a b : Fin 6) : Prop :=
  (a = 0 /\ b = 2) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 0 /\ b = 5) \/
  (a = 1 /\ b = 4) \/
  (a = 1 /\ b = 5) \/
  (a = 2 /\ b = 3) \/
  (a = 2 /\ b = 4) \/
  (a = 3 /\ b = 4)

instance relA_decidableRel : DecidableRel relA := by
  intro a b
  unfold relA
  infer_instance

instance relB_decidableRel : DecidableRel relB := by
  intro a b
  unfold relB
  infer_instance

def outDegree (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R] (a : Fin 6) : Nat :=
  (Finset.univ.filter fun b : Fin 6 => R a b).card

def inDegree (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R] (b : Fin 6) : Nat :=
  (Finset.univ.filter fun a : Fin 6 => R a b).card

def intervalCard (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (a b : Fin 6) : Nat :=
  (Finset.univ.filter fun x : Fin 6 => R a x /\ R x b).card

def intervalAbundance (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter fun p : Prod (Fin 6) (Fin 6) => intervalCard R p.1 p.2 = k).card

def jointDegreeCount (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (i o : Nat) : Nat :=
  (Finset.univ.filter fun a : Fin 6 => inDegree R a = i /\ outDegree R a = o).card

def jointDegreeSignature (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R] :
    Fin 7 -> Fin 7 -> Nat :=
  fun i o => jointDegreeCount R i.val o.val

def intervalSignature (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R] :
    Fin 7 -> Nat :=
  fun k => intervalAbundance R k.val

def inClosedDiamond (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (x y z : Fin 6) : Prop :=
  (z = x \/ R x z) /\ (z = y \/ R z y)

def diamondCard (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (x y : Fin 6) : Nat := by
  classical
  exact (Finset.univ.filter fun z : Fin 6 => inClosedDiamond R x y z).card

def localIntervalCard (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (x y a b : Fin 6) : Nat := by
  classical
  exact (Finset.univ.filter fun z : Fin 6 =>
    inClosedDiamond R x y z /\ R a z /\ R z b).card

def localIntervalAbundance (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (x y : Fin 6) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod (Fin 6) (Fin 6) =>
    inClosedDiamond R x y p.1 /\
    inClosedDiamond R x y p.2 /\
    localIntervalCard R x y p.1 p.2 = k).card

def localIntervalSignature (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (x y : Fin 6) : Fin 7 -> Nat :=
  fun k => localIntervalAbundance R x y k.val

def IrreflexiveRel (R : Fin 6 -> Fin 6 -> Prop) : Prop :=
  forall a, Not (R a a)

def TransitiveRel (R : Fin 6 -> Fin 6 -> Prop) : Prop :=
  forall a b c, R a b -> R b c -> R a c

theorem relA_irreflexive : IrreflexiveRel relA := by
  unfold IrreflexiveRel
  decide

theorem relA_transitive : TransitiveRel relA := by
  unfold TransitiveRel
  decide

theorem relB_irreflexive : IrreflexiveRel relB := by
  unfold IrreflexiveRel
  decide

theorem relB_transitive : TransitiveRel relB := by
  unfold TransitiveRel
  decide

theorem same_jointDegreeSignature :
    jointDegreeSignature relA = jointDegreeSignature relB := by
  decide

theorem same_intervalSignature :
    intervalSignature relA = intervalSignature relB := by
  decide

theorem diamondCard_relA_0_4 :
    diamondCard relA 0 4 = 4 := by
  unfold diamondCard inClosedDiamond
  rw [Finset.filter_congr_decidable]
  decide

theorem diamondCard_relB_0_4 :
    diamondCard relB 0 4 = 4 := by
  unfold diamondCard inClosedDiamond
  rw [Finset.filter_congr_decidable]
  decide

theorem localIntervalSignature_relA_0_4_at_one :
    localIntervalSignature relA 0 4 1 = 0 := by
  have hlc : forall a b : Fin 6, localIntervalCard relA 0 4 a b
      = (Finset.univ.filter fun z : Fin 6 =>
          ((z = 0 \/ relA 0 z) /\ (z = 4 \/ relA z 4)) /\ relA a z /\ relA z b).card := by
    intro a b
    unfold localIntervalCard inClosedDiamond
    rw [Finset.filter_congr_decidable]
  unfold localIntervalSignature localIntervalAbundance inClosedDiamond
  simp only [hlc]
  rw [Finset.filter_congr_decidable]
  decide

theorem localIntervalSignature_relB_0_4_at_one :
    localIntervalSignature relB 0 4 1 = 2 := by
  have hlc : forall a b : Fin 6, localIntervalCard relB 0 4 a b
      = (Finset.univ.filter fun z : Fin 6 =>
          ((z = 0 \/ relB 0 z) /\ (z = 4 \/ relB z 4)) /\ relB a z /\ relB z b).card := by
    intro a b
    unfold localIntervalCard inClosedDiamond
    rw [Finset.filter_congr_decidable]
  unfold localIntervalSignature localIntervalAbundance inClosedDiamond
  simp only [hlc]
  rw [Finset.filter_congr_decidable]
  decide

theorem localIntervalSignature_0_4_separates :
    localIntervalSignature relA 0 4 != localIntervalSignature relB 0 4 := by
  rw [bne_iff_ne, ne_eq]
  intro h
  have h1 := congrFun h 1
  rw [localIntervalSignature_relA_0_4_at_one,
    localIntervalSignature_relB_0_4_at_one] at h1
  exact absurd h1 (by decide)

end PhysicsSM.Draft.NullEdgeP9OperationalGap.T1

namespace PhysicsSM.Draft.NullEdgeP9OperationalGap

open PhysicsSM.Draft.NullEdgeP9OperationalGap.T1

/-- Absolute difference on natural-number readouts. -/
def natGap (a b : Nat) : Nat :=
  if a <= b then b - a else a - b

/-- Gap between two signature functions at a fixed finite bucket. -/
def signatureGapAt (sigA sigB : Fin 7 -> Nat) (k : Fin 7) : Nat :=
  natGap (sigA k) (sigB k)

/-- A readout distinguishes two signatures at bucket `k` with threshold `eps`. -/
def distinguishableAt (sigA sigB : Fin 7 -> Nat) (k : Fin 7) (eps : Nat) : Prop :=
  eps <= signatureGapAt sigA sigB k

theorem natGap_zero_left (n : Nat) :
    natGap 0 n = n := by
  simp [natGap]

theorem t1_localSignature_gap_at_one :
    signatureGapAt (localIntervalSignature relA 0 4)
      (localIntervalSignature relB 0 4) (Fin.mk 1 (by decide)) = 2 := by
  have hk : (Fin.mk 1 (by decide) : Fin 7) = (1 : Fin 7) := rfl
  unfold signatureGapAt
  rw [hk, localIntervalSignature_relA_0_4_at_one,
    localIntervalSignature_relB_0_4_at_one, natGap_zero_left]

theorem t1_localSignature_distinguishable_threshold_one :
    distinguishableAt (localIntervalSignature relA 0 4)
      (localIntervalSignature relB 0 4) (Fin.mk 1 (by decide)) 1 := by
  unfold distinguishableAt
  rw [t1_localSignature_gap_at_one]
  decide

theorem t1_localSignature_distinguishable_threshold_two :
    distinguishableAt (localIntervalSignature relA 0 4)
      (localIntervalSignature relB 0 4) (Fin.mk 1 (by decide)) 2 := by
  unfold distinguishableAt
  rw [t1_localSignature_gap_at_one]

end PhysicsSM.Draft.NullEdgeP9OperationalGap
end
