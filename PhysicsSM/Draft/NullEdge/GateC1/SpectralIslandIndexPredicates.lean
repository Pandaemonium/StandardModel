import Mathlib

/-!
# Gate C1 — spectral-island and branch-index predicates (C265, draft)

This module is the *draft-safe, finite-dimensional* predicate layer requested by
Aristotle job C265.  It fixes the Lean vocabulary for the three branch-retention
clauses identified in the C262 audit:

1. a **separated target spectral island** (gap of width `delta > 0` in the
   spectrum of a Hermitian sign-kernel `H`);
2. a **nonzero origin chiral index** of the target island
   (`Tr (gamma5 * P)` for the island projector `P`);
3. a **true inverse bad-sector gap** on the complement
   (an inverse-propagator lower bound `Kᴴ K ≥ gamma` on `range (1 - P)`,
   *not* a propagator zero / mirror removal).

Everything here is finite-matrix linear algebra over `ℂ`.  There is no
functional calculus, no operator norm, no overlap-locality or gauge-field
dependence — exactly the regime the C263 plan recommends for the index layer.

The companion design report is `GateC1_SpectralIslandIndex_Predicates.md`.

The decisive *no-go* of the design — the **zero-index commuting trap** — is
proved here (`zero_index_commuting_trap`): a balance symmetry that anticommutes
with `gamma5` and commutes with the island projector forces the chiral index to
vanish.  This is the obstruction that a genuine `W_branch` must avoid.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace SpectralIslandIndex

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-! ## 1. Separated target spectral island (explicit finite spectrum) -/

/-- **Explicit-spectrum island predicate.**  The Hermitian kernel `H` has a
spectral gap `(c, c + delta)`: every eigenvalue lies on or below `c` (the
complement / bad sector) or on or above `c + delta` (the target island), and at
least one eigenvalue lies in the island.  `delta > 0` is the separation. -/
def HasSeparatedIsland (H : Matrix n n ℂ) (hH : H.IsHermitian)
    (c delta : ℝ) : Prop :=
  0 < delta ∧
    (∃ i, c + delta ≤ hH.eigenvalues i) ∧
    (∀ i, hH.eigenvalues i ≤ c ∨ c + delta ≤ hH.eigenvalues i)

/-! ## 2. Abstract Riesz / spectral projector predicate -/

/-- **Abstract island projector predicate.**  `P` is an orthogonal projector
(`P² = P`, `Pᴴ = P`) that commutes with `H` (so it is a spectral projector), and
it is order-separated from the complement: on its range `H ≥ (c + delta)`, on the
complement `H ≤ c`, expressed by positive-semidefiniteness of the compressed
operators.  This is the finite-dimensional Riesz projector packaged as a
predicate, with no resolvent integral. -/
structure IsIslandProjector (H P : Matrix n n ℂ) (c delta : ℝ) : Prop where
  idempotent : P * P = P
  hermitian : Pᴴ = P
  commutes : P * H = H * P
  /-- On the island `range P`, `H ≥ c + delta`. -/
  gapAbove : (P * H * P - (c + delta : ℂ) • P).PosSemidef
  /-- On the complement `range (1 - P)`, `H ≤ c`. -/
  gapBelow : ((c : ℂ) • (1 - P) - (1 - P) * H * (1 - P)).PosSemidef

/-! ## 3. Origin chiral index (finite trace, no analytic index theory) -/

/-- **Chiral index of a projector.**  For a chirality involution `gamma5` and an
island projector `P`, the origin chiral index is the finite trace
`Tr (gamma5 * P)`.  When `gamma5` is a Hermitian involution and `P` a spectral
projector this trace is a (real) integer — the net chirality on the island — but
the predicate layer only needs nonvanishing, so we keep it `ℂ`-valued and assert
`≠ 0` for clause (2). -/
def chiralIndex (gamma5 P : Matrix n n ℂ) : ℂ := (gamma5 * P).trace

/-- **Overlap normalization of the index.**  For the normalized overlap
`Dov = 1 + gamma5 * eps`, the GW-modified chirality `gamma5 (1 - ½ Dov)` has
trace `-½ Tr (gamma5 * eps)`; this is the index used by the C263 bridge plan. -/
def overlapIndex (gamma5 eps : Matrix n n ℂ) : ℂ :=
  (-(1 / 2 : ℂ)) * (gamma5 * eps).trace

/-! ## 4. The branch-retention certificate (exactly three clauses) -/

/-- **Branch-retention certificate.**  Bundles *exactly* the three clauses of the
C262 criterion for a finite-dimensional null-edge branch kernel:

* `K` is the (free / Wilson) symbol matrix,
* `H` is the Hermitian sign-kernel (e.g. `H = gamma5 * K`),
* `P` is the target island projector,
* `gamma5` is the chirality involution.

Clause 1 (`islandSeparation`): `H` has a `delta`-separated island and `P` is its
spectral projector.  Clause 2 (`nonzeroIndex`): the island carries a nonzero
origin chiral index.  Clause 3 (`inverseBadSectorGap`): the complement has a
true inverse-propagator gap `Kᴴ K ≥ gamma` (not a propagator zero). -/
structure BranchRetentionCertificate
    (gamma5 H K P : Matrix n n ℂ) (hH : H.IsHermitian) (c delta : ℝ) : Prop where
  /-- Clause 1: separated target spectral island, with `P` its projector. -/
  islandSeparation : HasSeparatedIsland H hH c delta ∧ IsIslandProjector H P c delta
  /-- Clause 2: nonzero origin chiral index of the target island. -/
  nonzeroIndex : chiralIndex gamma5 P ≠ 0
  /-- Clause 3: true inverse bad-sector gap on the complement `range (1 - P)`. -/
  inverseBadSectorGap :
    ∃ gamma : ℝ, 0 < gamma ∧
      ((1 - P) * (Kᴴ * K) * (1 - P) - (gamma : ℂ) • (1 - P)).PosSemidef

/-! ## 5. Zero-index commuting trap (decisive no-go theorem) -/

/-
**Zero-index commuting trap.**  If a balance involution `Jb` is a
Hermitian-free involution (`Jb² = 1`) that *anticommutes* with the chirality
`gamma5` and *commutes* with the island projector `P`, then the chiral index
vanishes: `Tr (gamma5 * P) = 0`.

This is the structural obstruction the C262/C263 documents warn about:
balance-commuting spectral projectors classify route/taste, not chirality, and
carry zero index.  A physical `W_branch` must therefore break this balance
symmetry on the target island.

Proof: conjugation by the balance involution preserves the trace
(`Tr (Jb X Jb) = Tr X`), while `Jb (gamma5 * P) Jb = (Jb gamma5 Jb)(Jb P Jb)
= (-gamma5)(P)`, so `Tr (gamma5 P) = -Tr (gamma5 P)`.
-/
theorem zero_index_commuting_trap
    (gamma5 P Jb : Matrix n n ℂ)
    (hJb : Jb * Jb = 1)
    (hanti : Jb * gamma5 = -(gamma5 * Jb))
    (hcomm : Jb * P = P * Jb) :
    chiralIndex gamma5 P = 0 := by
  have h_trace : (Jb * (gamma5 * P) * Jb).trace = (gamma5 * P).trace := by
    rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ ← mul_assoc, hJb ] ;
  simp_all +decide [ ← mul_assoc, chiralIndex ];
  grind

/-! ## 6. Acceptance tests -/

/-- Pauli `Z` (chirality) on two components. -/
def gZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Pauli `X` (a candidate balance symmetry / sign-kernel piece). -/
def gX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Projector onto the first component (a one-dimensional island). -/
def gP : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 0]

/-
**Acceptance test (nonzero index exists).**  An anticommuting chirality and a
one-dimensional island projector give a nonzero origin chiral index — the
nontrivial side of the trap.  This certifies clause (2) is satisfiable.
-/
theorem acceptance_nonzero_index : chiralIndex gZ gP ≠ 0 := by
  -- Compute the product gZ * gP and its trace.
  simp [chiralIndex, gZ, gP]

/-
**Acceptance test (trap fires).**  `gZ` and `gX` anticommute and `gX` commutes
with the *balanced* projector `½(1 + gX)`; the index there vanishes, matching the
zero-index trap.
-/
theorem acceptance_trap_zero :
    chiralIndex gZ ((1 / 2 : ℂ) • (1 + gX)) = 0 := by
  unfold chiralIndex gZ gX ;
  norm_num [ Matrix.trace, Matrix.mul_apply ];
  norm_num [ Matrix.vecMul, dotProduct ]

end SpectralIslandIndex
end GateC1
end NullEdge
end Draft
end PhysicsSM
