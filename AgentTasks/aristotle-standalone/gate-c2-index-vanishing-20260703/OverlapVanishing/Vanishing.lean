import Mathlib

/-!
# The overlap-index vanishing theorem: nonzero index forces exact zero modes

PROOF TARGETS for Aristotle (complete both `sorry`s; do NOT change the
statements). Self-contained, Mathlib only.

## Context (not needed for the proofs)

In finite lattice chiral-fermion theory the normalized overlap operator of a
chirality involution `g` (gamma_5) and a sign involution `e` is
`Dov = 1 + g e`, and the lattice chiral index is
`overlapIndex = (1/2)(Tr g - Tr e)`.  A companion development has already
kernel-checked that this index is an integer, equals a signature difference,
and is nonzero for explicit gauge-flux configurations.  This file supplies
the missing physical keystone - TOPOLOGICAL PROTECTION OF MASSLESSNESS:

> if the index is nonzero, the overlap operator has exact zero modes
> (equivalently: an invertible - "gapped", massive - overlap operator forces
> index zero).

## The mathematics

This is the finite-dimensional index of a pair of orthogonal projections
(Avron-Seiler-Simon).  Both `g` and `e` are HERMITIAN involutions, so
`P = (1 + g)/2` and `Q = (1 + e)/2` are orthogonal projections and
`overlapIndex = Tr(P - Q)`.

Proof sketch (verified by hand; use freely):

1. Set `A = P - Q` and `B = 1 - P - Q`.  Then `A` and `B` are Hermitian and
   satisfy the two classical identities
   `A^2 + B^2 = 1` and `A B + B A = 0`
   (expand; both use only `P^2 = P`, `Q^2 = Q`).
2. `A` is Hermitian, so it diagonalizes with real eigenvalues; `Tr A` is the
   sum of eigenvalues with multiplicity.
3. Anticommutation makes `B` map the `lam`-eigenspace of `A` into the
   `(-lam)`-eigenspace.  On an eigenspace with `lam^2 != 1`, `B` is
   injective there (for `A x = lam x`, `B^2 x = (1 - lam^2) x != 0`), so
   `dim E_lam <= dim E_{-lam}` and symmetrically: the dimensions are EQUAL,
   and the `lam + (-lam)` contributions to `Tr A` cancel.  Hence
   `Tr A = dim E_{+1}(A) - dim E_{-1}(A)`.
4. Eigenvectors of `A` at `+-1` lie in `ker Dov`: if `A x = x` then (using
   `||Px - x|| , ||Qx||` extremality for orthogonal projections, or directly
   from `A^2 x = x` and `B^2 x = 0` with the identities) `P x = x` and
   `Q x = 0`, i.e. `g x = x`, `e x = -x`, so `g e x = -x` and
   `(1 + g e) x = 0`.  Symmetrically for `A x = -x` (`g x = -x`, `e x = x`).
5. If `Dov` is invertible (`IsUnit`), its kernel is trivial, so both
   `+-1`-eigenspaces vanish and `overlapIndex = (1/2) Tr(g - e) = Tr(P - Q)
   = Tr A = 0`.
6. The corollary is the contrapositive plus "non-invertible matrix over a
   field has a nontrivial kernel"
   (`Matrix.exists_mulVec_eq_zero_iff` / determinant characterization).

An equivalent alternative route, if it proves easier in Mathlib: the product
`V = g e` is unitary (both factors Hermitian involutions are unitary), and
`g V g = V^{-1} = V^*`, so the spectrum of `V` is stable under conjugation;
`ker Dov = ker (1 + V)` is the `(-1)`-eigenspace of `V`; on the orthogonal
complement of the `+-1`-eigenspaces of `V`, `g` and `e` exchange the paired
`lam, conj lam` eigenspaces and contribute zero to `Tr g - Tr e`.  Either
route is acceptable; the statements below must not change.

## Deliverables

No `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`.  If a statement appears false,
STOP and report rather than weakening it.
-/

noncomputable section

namespace OverlapVanishing

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Normalized overlap operator of a chirality/sign involution pair. -/
def Dov (g e : Matrix n n ℂ) : Matrix n n ℂ := 1 + g * e

/-- Lattice chiral index in trace form: `(1/2)(Tr g - Tr e)`. -/
def overlapIndex (g e : Matrix n n ℂ) : ℂ :=
  (1 / 2 : ℂ) * (g.trace - e.trace)

/-- **Vanishing theorem (gapped form).**  For Hermitian involutions `g`, `e`:
if the overlap operator `Dov = 1 + g e` is invertible (a "gapped" /
mass-admitting operator), the chiral index vanishes. -/
theorem overlapIndex_eq_zero_of_isUnit_dov
    (g e : Matrix n n ℂ) (hg : g.IsHermitian) (he : e.IsHermitian)
    (hg2 : g * g = 1) (he2 : e * e = 1) (hunit : IsUnit (Dov g e)) :
    overlapIndex g e = 0 := by
  sorry

/-- **Vanishing theorem (zero-mode form).**  A nonzero chiral index forces an
exact zero mode of the overlap operator: masslessness is topologically
protected. -/
theorem exists_zero_mode_of_overlapIndex_ne_zero
    (g e : Matrix n n ℂ) (hg : g.IsHermitian) (he : e.IsHermitian)
    (hg2 : g * g = 1) (he2 : e * e = 1)
    (hidx : overlapIndex g e ≠ 0) :
    ∃ psi : n → ℂ, psi ≠ 0 ∧ (Dov g e) *ᵥ psi = 0 := by
  sorry

end OverlapVanishing
