import Mathlib

/-!
# Gate YM4: the Kotecky-Preiss cluster-expansion criterion (statement freeze)

Freeze section 7 (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`):
"Frozen import KP (Kotecky-Preiss criterion, Ueltschi form) - absent from
Mathlib per today's check; the single most reusable object on the
ladder." This module is a STATEMENT-FREEZE ONLY, per the freeze
document's own guidance (T5's task directions: "submit PKG-YM4-A only if
T1/T2 waves are in flight and cap has room... the statement cross-review
is tonight's real deliverable; a premature submission with wrong
hypotheses is negative progress"). No proof is attempted here.

## Citation status (`AgentTasks/overnight-ym-run-2026-07-03/LIT_LOG.md`,
item 3, verified 2026-07-04 by this run's T6 lit sprint)

Kotecky & Preiss, "Cluster expansion for abstract polymer models",
Commun. Math. Phys. 103 (1986) 491-498. The exact primary-source wording
could NOT be extracted this session (PDF-fetch tooling renders binary
streams, not text, for this paywalled/scanned source) but the criterion
below is CROSS-CONFIRMED against THREE independent secondary sources
found during T6 (a modern rederivation, Fernandez-Procacci,
"Cluster expansion for abstract polymer models: new bounds from an old
approach", arXiv:math-ph/0605041, plus two further restatements), all
agreeing up to notation, and matches this program's own freeze
document's prior citation exactly. Recommend: whoever proves this
statement should still pull the primary 1986 CMP text or the arXiv
rederivation directly to confirm the exact tail-bound formula before
attempting the proof - this file freezes the HYPOTHESIS precisely; the
CONCLUSION (below) is deliberately left as a design placeholder, not a
possibly-wrong guess.

## What is frozen here vs. what remains

FROZEN (fully formalizable now, no new infrastructure): the abstract
finite polymer system (a finite type of "polymers" with a symmetric,
reflexive-on-non-identity incompatibility relation, real weights, and a
nonnegative "energy" function `a`), and the KP CONDITION itself as a
`Finset`-sum inequality - this is the hypothesis side, and it is exactly
where a wrong formalization would poison every downstream use (per the
freeze's F-YM-LIT rule).

NOT YET FORMALIZED (needs a genuine design decision, not attempted
here): the CONCLUSION "the cluster expansion for `log Z` converges
absolutely, uniformly in volume, with the standard tail bounds." This
needs a formal definition of a "cluster" (a multiset of pairwise-
compatible-or-incompatible polymers whose incompatibility graph is
connected) and the Ursell/Mayer coefficient of a cluster - genuinely new
combinatorial infrastructure, absent from Mathlib, and NOT the same
object as the even-cover machinery already built for T2
(`TorusEvenCover.lean` - that is the Z2-torus-SPECIFIC "which plaquette
sets survive the character expansion" argument; KP's clusters are a
DIFFERENT, more general combinatorial object needed for the
strong-coupling expansion at generic `beta`, not the exact `beta`-
independent even/odd counting of the torus argument). Left as a
documented handoff below rather than guessed at.

Draft-trust: the FROZEN definitions/statement are stated (not proved);
`kpCriterion` is a `Prop`, not a theorem, so there is nothing to prove in
this file yet - no `s o r r y` needed for the frozen part. Claim label:
**statement freeze only** (per freeze document discipline: CAS/statement
freezes are not proofs). Prerequisites: Mathlib only.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PolymerKPCriterion

/-- An abstract FINITE polymer system: a finite type of polymers, a
symmetric incompatibility relation (freeze: "two polymers are
incompatible if they are related by a reflexive and symmetric
incompatibility relation `iota`; otherwise compatible" - reflexivity of
`iota` on a polymer with itself is the standard convention that a
polymer is always incompatible with itself, forcing at most one copy of
each polymer per admissible configuration), a real weight, and a
nonnegative "energy" function `a` used by the KP condition. -/
structure PolymerSystem (Gamma : Type*) [Fintype Gamma] where
  /-- Symmetric incompatibility relation. Reflexive (a polymer is always
  incompatible with itself) is the standard convention but NOT assumed
  here as a field - callers should assert `incompatible g g` explicitly
  when instantiating, since some presentations of KP treat self-
  incompatibility as definitional rather than a hypothesis. -/
  incompatible : Gamma → Gamma → Prop
  incompatible_symm : ∀ g h, incompatible g h → incompatible h g
  weight : Gamma → ℝ
  energy : Gamma → ℝ
  energy_nonneg : ∀ g, 0 ≤ energy g

variable {Gamma : Type*} [Fintype Gamma] [DecidableEq Gamma]

/-- The Kotecky-Preiss condition: for every polymer `gamma`, the weighted
sum over all polymers incompatible with it, boosted by `exp(energy)`, is
at most `energy gamma`. This is the hypothesis side of the KP theorem,
cross-confirmed (see module docstring) as: `forall gamma, sum_{gamma'
incompatible with gamma} |weight(gamma')| * exp(energy(gamma')) <=
energy(gamma)`. -/
def KPCondition (S : PolymerSystem Gamma)
    (incompatibleDecidable : ∀ g h, Decidable (S.incompatible g h)) : Prop :=
  ∀ g : Gamma,
    (∑ h ∈ Finset.univ.filter (fun h => @Decidable.decide _ (incompatibleDecidable g h) = true),
        |S.weight h| * Real.exp (S.energy h))
      ≤ S.energy g

/-
Proof handoff (design placeholder, NOT a `s o r r y` - there is no
theorem statement yet to leave unproved): the KP CONCLUSION needs a
formal definition of a "cluster" over `Gamma` (a finite sequence or
multiset of polymers whose "incompatibility graph" - vertices = the
polymers in the cluster, edges = incompatible pairs - is CONNECTED) and
the associated Ursell/Mayer combinatorial coefficient
`u(cluster) = (1/|cluster|!) * sum over spanning-connected subgraphs of
the incompatibility graph of (-1)^{#edges}` (the standard Mayer cluster
coefficient; exact normalization needs to be pinned against the primary
source before this is stated as a theorem). The intended conclusion
shape is:
  `KPCondition S h -> Summable (fun cluster => u(cluster) * prod
    (S.weight over the cluster's polymers)) ∧
    (∀ gamma, sum over clusters containing gamma of |u(cluster) * prod
      weight| <= S.energy gamma)`
(the tail bound is the "standard tail bounds" from the freeze doc).
Likely missing lemma: nothing in Mathlib defines Mayer/Ursell cluster
coefficients or connected-subgraph counting for a finite incompatibility
graph - this is confirmed genuinely absent (freeze section 2, section 7:
"absent from Mathlib per today's check"). This is real, nontrivial new
combinatorial content and should get its own design/review round before
a theorem statement is written, not a blind attempt tonight.
-/

end PolymerKPCriterion
end GateYM
end NullEdge
end Draft
end PhysicsSM
