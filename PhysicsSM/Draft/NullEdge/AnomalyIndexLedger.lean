import Mathlib

/-!
# Standard Model charge moments versus oriented boundary-channel counts

This file builds an exact finite ledger that connects — and, crucially,
*separates* — three distinct objects for one Standard Model generation, in the
project convention `Q = T3 + Y/2` with **every fermion represented
left-handed**:

1. the Standard Model anomaly coefficients (gravitational `U(1)`, cubic
   `U(1)^3`, `SU(2)^2 U(1)`, `SU(3)^2 U(1)`);
2. an *oriented channel ledger*: a finite list of channels, each carrying a
   rational `charge` and an integer `weight` (a localized unilateral-shift
   defect `+m` or `-m`, additive under stacking), with an **unweighted count**
   `Σ weight`;
3. the **charge-weighted moments** (`firstMoment = Σ weight · charge`,
   `cubicMoment = Σ weight · charge³`) of that oriented ledger.

## Headline result (a no-go)

`anomaly_moments_do_not_force_zero_count`: the charge-weighted anomaly moments
of the one-generation Standard Model ledger vanish, yet its unweighted oriented
count is `15 ≠ 0`.  Charge-weighted anomaly cancellation therefore **does not**
force the unweighted oriented boundary count to vanish.  The missing datum is
orientation/mirror data: the count is the `0`-th moment, invisible to every
charge weighting.

## Classification of a one-entry aggregate augmentation

`sm_single_aug_classification`: *any* single ledger entry `c` appended to the
Standard Model ledger that cancels the unweighted count while preserving the
first moment is forced to be **charge-neutral** with `weight = -15`.  Such a
aggregate entry exists (`sink`, `smMirrored`), and preserves the first and cubic
anomaly moments (`aug_firstMoment`, `aug_cubicMoment`).  Because the Standard
Model count is `15 ≠ 0`, no empty augmentation can work.

Here one `Channel` may carry any integer weight.  Thus `sink.weight = -15`
packages fifteen elementary opposite-oriented units into one ledger entry.
The theorem is minimal only in **list-entry count** under this aggregate API;
it does not prove that one elementary mirror fermion cancels fifteen modes or
that the aggregate entry has a local physical realization.

## Scope disclaimer

These are bookkeeping / obstruction statements only.  Nothing here claims that
anomaly cancellation implies a bulk-edge correspondence, a physical mirror gap,
or a Standard Model lattice regulator.  The `stabilizedIndex` interface theorems
(`stabilizedIndex_eq_count`, `count_reverse`) are stated *abstractly*, with
their defining properties supplied as explicit hypotheses; they name, but do not
assume the physics of, a half-space defect index and its orientation reversal.

Provenance: clean-room finite ledger returned by Aristotle job
`a2f77b78-59ba-4b39-9319-152d3b446ff8`, with the aggregate-entry limitation
made explicit during integration.
-/

/- Build-enforced axiom guard: `#guard_axioms foo` fails elaboration unless the
named declaration depends only on the allowed axioms `propext`,
`Classical.choice`, `Quot.sound`. -/
open Lean Elab Command in
elab "#guard_axioms " id:ident : command => do
  let name ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let env ← getEnv
  let (_, s) := ((CollectAxioms.collect name).run env).run {}
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for ax in s.axioms do
    unless allowed.contains ax do
      throwError "declaration {name} depends on disallowed axiom {ax}"

namespace PhysicsSM.Draft.NullEdge.AnomalyIndexLedger

/-! ## Hypercharge convention (`Q = T3 + Y/2`, all fermions left-handed) -/

abbrev Charge := Rat

/-- Hypercharge of the left-handed quark doublet `Q`. -/
def yQ : Charge := 1 / 3
/-- Hypercharge of the left-handed lepton doublet `L`. -/
def yL : Charge := -1
/-- Hypercharge of the left-handed up antiquark `uᶜ`. -/
def yU : Charge := -4 / 3
/-- Hypercharge of the left-handed down antiquark `dᶜ`. -/
def yD : Charge := 2 / 3
/-- Hypercharge of the left-handed positron `eᶜ`. -/
def yE : Charge := 2

/-! ## The four one-generation anomaly cancellations (explicit identities) -/

/-- Gravitational–`U(1)` anomaly: `Σ (multiplicity · Y) = 0`. -/
theorem gravitational_moment :
    6 * yQ + 2 * yL + 3 * yU + 3 * yD + yE = 0 := by
  norm_num [yQ, yL, yU, yD, yE]

/-- Cubic `U(1)^3` anomaly: `Σ (multiplicity · Y³) = 0`. -/
theorem cubic_moment :
    6 * yQ ^ 3 + 2 * yL ^ 3 + 3 * yU ^ 3 + 3 * yD ^ 3 + yE ^ 3 = 0 := by
  norm_num [yQ, yL, yU, yD, yE]

/-- `SU(2)^2 U(1)` anomaly: sum of `Y` over the three colored quark doublets and
the single lepton doublet vanishes. -/
theorem su2_moment : 3 * yQ + yL = 0 := by
  norm_num [yQ, yL]

/-- `SU(3)^2 U(1)` anomaly: sum of `Y` over the two isospin components of the
quark doublet, `uᶜ`, and `dᶜ` vanishes. -/
theorem su3_moment : 2 * yQ + yU + yD = 0 := by
  norm_num [yQ, yU, yD]

/-! ## Oriented channel ledger (defined independently of anomaly moments) -/

/-- An oriented boundary channel: a rational `charge` and an integer `weight`
recording a localized unilateral-shift defect (`+m` or `-m`). -/
structure Channel where
  charge : Rat
  weight : Int
deriving DecidableEq, Repr

/-- A ledger is a finite stack of oriented channels; stacking is list append. -/
abbrev Ledger := List Channel

/-- Unweighted oriented count (the `0`-th moment): `Σ weight`. -/
def count (L : Ledger) : Int := (L.map Channel.weight).sum

/-- First charge moment: `Σ weight · charge`. -/
def firstMoment (L : Ledger) : Rat :=
  (L.map (fun c => (c.weight : Rat) * c.charge)).sum

/-- Cubic charge moment: `Σ weight · charge³`. -/
def cubicMoment (L : Ledger) : Rat :=
  (L.map (fun c => (c.weight : Rat) * c.charge ^ 3)).sum

/-- Orientation reversal of a single channel: negate its defect. -/
def reverseOrient (c : Channel) : Channel := ⟨c.charge, -c.weight⟩

/-- Orientation reversal of a ledger: reverse every channel's orientation. -/
def reverseLedger (L : Ledger) : Ledger := L.map reverseOrient

/-! ### Additivity under stacking -/

theorem count_append (L₁ L₂ : Ledger) :
    count (L₁ ++ L₂) = count L₁ + count L₂ := by
  simp [count]

theorem firstMoment_append (L₁ L₂ : Ledger) :
    firstMoment (L₁ ++ L₂) = firstMoment L₁ + firstMoment L₂ := by
  simp [firstMoment]

theorem cubicMoment_append (L₁ L₂ : Ledger) :
    cubicMoment (L₁ ++ L₂) = cubicMoment L₁ + cubicMoment L₂ := by
  simp [cubicMoment]

/-- Orientation reversal negates the unweighted count. -/
theorem count_reverse (L : Ledger) : count (reverseLedger L) = - count L := by
  induction L with
  | nil => simp [count, reverseLedger]
  | cons c t ih => simp [count, reverseLedger, reverseOrient] at *; omega

/-! ## The one-generation Standard Model oriented ledger -/

/-- The Standard Model generation as an oriented ledger: five channels with the
color/isospin multiplicities `6, 2, 3, 3, 1`, each with orientation `+`. -/
def smLedger : Ledger := [⟨yQ, 6⟩, ⟨yL, 2⟩, ⟨yU, 3⟩, ⟨yD, 3⟩, ⟨yE, 1⟩]

/-- The unweighted oriented count of one Standard Model generation is `15`
(the number of left-handed Weyl fermions). -/
theorem sm_count : count smLedger = 15 := by
  simp [count, smLedger]

/-- The first charge moment of the Standard Model ledger equals the
gravitational–`U(1)` anomaly, and vanishes. -/
theorem sm_firstMoment : firstMoment smLedger = 0 := by
  simp [firstMoment, smLedger, yQ, yL, yU, yD, yE]; norm_num

/-- The cubic charge moment of the Standard Model ledger equals the cubic
`U(1)^3` anomaly, and vanishes. -/
theorem sm_cubicMoment : cubicMoment smLedger = 0 := by
  simp [cubicMoment, smLedger, yQ, yL, yU, yD, yE]; norm_num

/-! ## Headline no-go: anomaly moments do not force a zero count -/

/-- **No-go.** There is a ledger — the Standard Model generation — whose first
and cubic charge moments both vanish while its unweighted oriented count is
nonzero.  Hence charge-weighted anomaly cancellation does not force the
unweighted oriented boundary count to vanish.  The missing datum is orientation
data: the count is the `0`-th moment, invisible to any charge weighting. -/
theorem anomaly_moments_do_not_force_zero_count :
    ∃ L : Ledger, firstMoment L = 0 ∧ cubicMoment L = 0 ∧ count L ≠ 0 :=
  ⟨smLedger, sm_firstMoment, sm_cubicMoment, by rw [sm_count]; decide⟩

/-! ## One-entry aggregate mirror/orientation augmentation -/

/-- A one-entry aggregate augmentation: a charge-neutral ledger entry carrying
the opposite-orientation defect `-15`.  Its weight packages fifteen elementary
units; it is not one elementary channel. -/
def sink : Channel := ⟨0, -15⟩

theorem sink_weight_ne_zero : sink.weight ≠ 0 := by decide

/-- The Standard Model ledger augmented by the neutral opposite-orientation
sink. -/
def smMirrored : Ledger := smLedger ++ [sink]

/-- The augmented ledger has vanishing unweighted oriented count. -/
theorem aug_count : count smMirrored = 0 := by
  simp [count, smMirrored, smLedger, sink]

/-- The augmentation preserves the first charge moment (still `0`). -/
theorem aug_firstMoment : firstMoment smMirrored = 0 := by
  simp [firstMoment, smMirrored, smLedger, sink, yQ, yL, yU, yD, yE]; norm_num

/-- The augmentation preserves the cubic charge moment (still `0`). -/
theorem aug_cubicMoment : cubicMoment smMirrored = 0 := by
  simp [cubicMoment, smMirrored, smLedger, sink, yQ, yL, yU, yD, yE]; norm_num

/-- **Classification (general form).** If appending a single channel `c` to a
base ledger with count `15` and vanishing first moment both cancels the count
and preserves the first moment, then `c` is charge-neutral with `weight = -15`. -/
theorem single_aug_neutral (base : Ledger) (c : Channel)
    (hcount : count (base ++ [c]) = 0)
    (hfirst : firstMoment (base ++ [c]) = 0)
    (hbaseC : count base = 15) (hbaseF : firstMoment base = 0) :
    c.charge = 0 ∧ c.weight = -15 := by
  rw [count_append, hbaseC, count] at hcount
  simp at hcount
  have hw : c.weight = -15 := by omega
  refine ⟨?_, hw⟩
  rw [firstMoment_append, hbaseF, firstMoment] at hfirst
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    zero_add, add_zero, hw] at hfirst
  have hne : ((-15 : Int) : Rat) ≠ 0 := by norm_num
  rcases mul_eq_zero.mp hfirst with h | h
  · exact absurd h hne
  · exact h

/-- **Classification (Standard Model).** Any single channel whose addition to
the Standard Model generation cancels the unweighted count and preserves the
first moment is forced to be charge-neutral with defect `-15` — exactly `sink`.
Together with `sm_count ≠ 0` (no zero-channel augmentation works) and the
existence witness `smMirrored`, this pins down the unique one-entry aggregate
augmentation.  It does not classify elementary mode count or locality. -/
theorem sm_single_aug_classification (c : Channel)
    (hcount : count (smLedger ++ [c]) = 0)
    (hfirst : firstMoment (smLedger ++ [c]) = 0) :
    c.charge = 0 ∧ c.weight = -15 :=
  single_aug_neutral smLedger c hcount hfirst sm_count sm_firstMoment

/-! ## Abstract stabilized-index interface

These theorems connect the concrete `count` to an abstract half-space defect
index.  Rather than assuming any physics, they take the index's characterizing
properties as explicit hypotheses (naming, e.g., the additivity and
single-channel normalization that a `stabilizedIndex_eq` result would supply,
and the orientation-reversal behavior). -/

/-- If `stab` is additive under stacking, vanishes on the empty ledger, and
returns a single channel's defect, then it agrees with `count` on every ledger.
This is the interface a `HalfSpaceDefectIndex.stabilizedIndex_eq` result would
discharge. -/
theorem stabilizedIndex_eq_count
    (stab : Ledger → Int)
    (hadd : ∀ L₁ L₂, stab (L₁ ++ L₂) = stab L₁ + stab L₂)
    (hnil : stab [] = 0)
    (hone : ∀ c, stab [c] = c.weight) :
    ∀ L, stab L = count L := by
  intro L
  induction L with
  | nil => simp [hnil, count]
  | cons c t ih =>
    have hsplit : stab (c :: t) = stab [c] + stab t := by
      have := hadd [c] t; simpa using this
    rw [hsplit, hone, ih, count]
    simp [count]

/-- Under the same interface, orientation reversal of the ledger negates the
abstract index — the interface counterpart of an orientation-reversal theorem. -/
theorem stabilizedIndex_reverse
    (stab : Ledger → Int)
    (hadd : ∀ L₁ L₂, stab (L₁ ++ L₂) = stab L₁ + stab L₂)
    (hnil : stab [] = 0)
    (hone : ∀ c, stab [c] = c.weight) :
    ∀ L, stab (reverseLedger L) = - stab L := by
  intro L
  rw [stabilizedIndex_eq_count stab hadd hnil hone,
      stabilizedIndex_eq_count stab hadd hnil hone, count_reverse]

/-! ## Build-enforced guards -/

set_option linter.hashCommand false

-- Concrete numeric guards (fail the build if the arithmetic drifts).
#guard count smLedger = 15
#guard count smMirrored = 0
#guard sink.weight = -15

-- Axiom guards: fail the build unless only allowed axioms are used.
#guard_axioms gravitational_moment
#guard_axioms cubic_moment
#guard_axioms su2_moment
#guard_axioms su3_moment
#guard_axioms sm_count
#guard_axioms sm_firstMoment
#guard_axioms sm_cubicMoment
#guard_axioms anomaly_moments_do_not_force_zero_count
#guard_axioms aug_count
#guard_axioms aug_firstMoment
#guard_axioms aug_cubicMoment
#guard_axioms single_aug_neutral
#guard_axioms sm_single_aug_classification
#guard_axioms count_reverse
#guard_axioms stabilizedIndex_eq_count
#guard_axioms stabilizedIndex_reverse

end PhysicsSM.Draft.NullEdge.AnomalyIndexLedger
