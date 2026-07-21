# Task: the Chevalley incidence lemma - genuine Krasnov pairs meet in dimension 3

Project: Lean 4 (v4.28.0) + Mathlib. Spin(10) selector chain, the ONE
remaining geometric blocker (named by the predecessor project's
PROOF_STATUS, included as PREDECESSOR_PROOF_STATUS.md). Self-contained
nine-module package: the SpinorTenfold Clifford/purity/orbit tree, the
integrated transitivity file (refutation + StandardizablePair + proven
conditional reduction), the integrated standardizable-pairs file (the
annihilator invariant + vacuum fiber + PROVEN corrected-S1 reduction), and
the target.

## Target

`PhysicsSM/Draft/Spin10AnnihilatorIncidence.lean` - three theorems ending
in a hole:

1. `annihilator_smul` - equivariance warm-up (diagonal form; if the
   natural statement is the two-argument transport
   `annihilatorIntersectionDim (g ψ₁) (g ψ₂) = annihilatorIntersectionDim ψ₁ ψ₂`,
   prove THAT, rename accordingly, and use it - the diagonal special case
   is then trivial; record the change).
2. `annihilatorIntersectionDim_eq_three_of_genuine` - THE blocker: purity
   + orthogonality + projective distinctness force common-annihilator
   dimension exactly 3. Route: the landed basis-pair trichotomy
   (`SpinorTenfoldBasisTrichotomyAristotle`-style results in the included
   tree: `dim(N_S ∩ N_T) = 5 - |S Δ T| ∈ {1, 3, 5}`) settles basis
   monomials; move general pure spinors to monomials with the included
   orbit machinery and transport the annihilator equivariantly;
   orthogonality excludes `d = 5`... precisely: the DIAGONAL stratum is
   `d = 5` (excluded by projective distinctness) and the generic
   transversal stratum `d = 1` is excluded by the orthogonality
   (gamma-bilinear) hypothesis - verify which exclusion pairs with which
   hypothesis against the included Fierz/pairing lemmas and document it.
3. `inVacuumThreeFiber_of_genuine` - corollary packaging.

## Pre-registered honesty license

If the genuine-pair dimension is a different odd value under the repo's
conventions, prove the true value, rename, record prominently, and state
the corrected fiber corollary consistently (do not modify the included
files). A kernel counterexample is a first-class outcome. If the general
case resists, prove the basis-monomial case + the equivariance transport
and return a precise report of the single missing normal-form step.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/Spin10AnnihilatorIncidence.lean`
  first.

## Success criteria

Target 2 proven is FULL success (it unblocks the entire corrected-S1
chain via the already-proven reduction). Completion report: solved
targets, statement changes, remaining holes, axioms used.

## RESTART ADDENDUM (2026-07-19 08:30)

First harvest applied: two-argument equivariance, the basis-monomial
annihilator characterization, the dimension formula, the basis genuine
=> 3 theorem, scalar invariance, and the normal-form TRANSPORT BRIDGE are
all PROVEN in the target - do not modify them. ONE hole remains and is
the entire job: the general `annihilatorIntersectionDim_eq_three_of_genuine`.
Two acceptable routes: (a) via the transport bridge, if you can construct
the simultaneous basis normal form (a parallel job is attacking the
single-spinor chart lemmas; you may prove your own normal-form helpers);
(b) a DIRECT coordinate proof of the Chevalley incidence bound (both
inequalities on the common-annihilator dimension from purity +
orthogonality + distinctness). Route (b) needs no orbit machinery and is
in scope. All other instructions unchanged.
