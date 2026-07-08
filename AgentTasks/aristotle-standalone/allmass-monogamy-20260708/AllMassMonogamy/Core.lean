/-
# Mass monogamy: the Plucker mass is superadditive, and the excess is binding

Proof job (Aristotle). Roadmap item **F3** (`STRENGTHENING_ROADMAP.md`), a new
self-contained finite theorem. The kinematic mass of a bundle of null Weyl
spinors is `det P = sum_{i<j} |psi_i wedge psi_j|^2` - *exhaustively pairwise*.
This file asks for the **monogamy / superadditivity** structure of that
distribution, which (to the program's knowledge) is not in the amplitudes
literature in this packaging, and which is the *kinematic root of binding
energy*: when two sub-bundles are combined, the total mass squared exceeds the
sum of the parts by exactly the cross-pair disagreement.

All Mathlib-only; no carrier, no physics. Targets are stated below; prove them
kernel-clean (no `s o r r y`). You may adjust indexing (append vs. subset) to
whatever is cleanest in Mathlib, as long as the stated mathematics is preserved.

## Definitions (provided)

- `Spinor := Fin 2 -> C`; `wedge psi phi := psi 0 * phi 1 - psi 1 * phi 0` (the
  Plucker coordinate / SL(2) invariant of two spinors).
- `pairwiseMass psi := sum over i<j of `Complex.normSq (wedge (psi i) (psi j))`
  (the real invariant mass squared of the bundle).

## Targets

- **T-nonneg (warmup):** `0 <= pairwiseMass psi`. [provided, easy]
- **T-single (warmup):** a one-spinor bundle is massless: `pairwiseMass` of any
  `psi : Fin 1 -> Spinor` is `0`. And `wedge psi psi = 0`.
- **F3a - SUPERADDITIVITY (the headline).** For `psi : Fin m -> Spinor` and
  `phi : Fin n -> Spinor`, let `psi ++ phi : Fin (m+n) -> Spinor` be their
  concatenation (`Fin.append`). Then
  `pairwiseMass (Fin.append psi phi)
      = pairwiseMass psi + pairwiseMass phi
        + (sum_{i,j} Complex.normSq (wedge (psi i) (phi j)))`,
  and in particular
  `pairwiseMass psi + pairwiseMass phi <= pairwiseMass (Fin.append psi phi)`.
  The excess is the total CROSS disagreement between the two sub-bundles - the
  finite, kinematic seed of binding: combining bundles *creates* mass equal to
  their mutual non-collinearity.
- **F3b - EQUALITY / monogamy characterization.** Equality
  `pairwiseMass (Fin.append psi phi) = pairwiseMass psi + pairwiseMass phi`
  holds iff every cross pair is collinear: `wedge (psi i) (phi j) = 0` for all
  `i, j` (the two sub-bundles share no disagreement - one common beam between
  them). i.e. two bundles bind iff they disagree.

## Why it matters

F3a is the kinematic theorem behind the `Delta` binding-energy finding
(`DELTA_BINDING_ENERGY_FINDING.md`): mass is created off-diagonally when
sub-bundles are combined, exactly as binding is off-diagonal in the dynamical
carrier. F3b says binding vanishes precisely for mutually collinear (non-
disagreeing) sub-bundles - the kinematic image of "no binding without
interaction". Provenance: all-mass overnight run 2026-07-08, roadmap F3 [orig].
-/

import Mathlib

namespace AllMassMonogamy

open scoped BigOperators

/-- A complex Weyl 2-spinor. -/
abbrev Spinor := Fin 2 → ℂ

/-- The spinor wedge / Plucker coordinate: the `SL(2,C)` invariant of two
spinors. Vanishes iff the two are collinear. -/
def wedge (psi phi : Spinor) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

/-- The set of ordered pairs `i < j` of a finite index. -/
def upperPairs (n : ℕ) : Finset (Fin n × Fin n) :=
  Finset.univ.filter (fun p => p.1 < p.2)

/-- Pairwise Plucker mass squared of a finite bundle:
`sum_{i<j} |psi_i wedge psi_j|^2`. Real and nonnegative. -/
def pairwiseMass {n : ℕ} (psi : Fin n → Spinor) : ℝ :=
  ∑ p ∈ upperPairs n, Complex.normSq (wedge (psi p.1) (psi p.2))

/-- **T-nonneg (warmup, provided).** The pairwise mass is nonnegative. -/
theorem pairwiseMass_nonneg {n : ℕ} (psi : Fin n → Spinor) :
    0 ≤ pairwiseMass psi :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

/-- **T-single-wedge (warmup, provided).** A spinor does not disagree with
itself. -/
theorem wedge_self (psi : Spinor) : wedge psi psi = 0 := by
  unfold wedge; ring

/- The real targets F3a (superadditivity) and F3b (equality characterization)
are stated in the module docstring; add them here and prove them. -/

end AllMassMonogamy
