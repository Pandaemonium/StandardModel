# claude-positive-sector-classification — Suite C rung C1: the carrier -> {positive, balanced, protected-null, indefinite} map

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Suite C reads particles as positive-sector codes. Rung C1: classify a finite carrier's physical
sector by the signature of its (real symmetric) sector form S into four disjoint classes and prove
the classification is exhaustive and mutually exclusive, with an explicit witness in each class.

## The model (REAL symmetric n x n, small n, rational)

A carrier sector form is a real symmetric matrix S. Define four classes by the signs of its
eigenvalues (equivalently by leading principal minors / a signature invariant):
- POSITIVE: S positive-definite (all eigenvalues > 0) — a massive positive-sector code.
- INDEFINITE: S has both a positive and a negative eigenvalue — unphysical/ghost sector.
- PROTECTED-NULL: S PSD with a nontrivial kernel (>=1 zero eigenvalue, none negative) — a protected
  massless mode.
- BALANCED: S = 0 on the sector (or traceless-nilpotent degenerate) — the degenerate/edge case.

## Targets (small explicit rational symmetric matrices)

1. `class_predicates`: define `IsPositive S`, `IsIndefinite S`, `IsProtectedNull S`, `IsBalanced S`
   as decidable/clean predicates on the eigenvalue signs (use PosDef / PSD + kernel / indefinite via
   an explicit vector giving negative value).
2. `classification_exhaustive`: every real symmetric S (nonzero, on a fixed small dimension, e.g.
   2x2 or 3x3) falls into exactly one of {Positive, Indefinite, ProtectedNull} (Balanced = the S=0
   edge) — prove exhaustive (`IsPositive ∨ IsProtectedNull ∨ IsIndefinite` for S != 0 PSD-or-not)
   and pairwise-exclusive (each pair is contradictory).
3. `witnesses`: exhibit an explicit rational S in each class with a distinguishing vector:
   Positive `!![2,0;0,3]`; ProtectedNull `!![1,0;0,0]` (kernel `(0,1)`); Indefinite `!![1,0;0,-1]`
   (negative on `(0,1)`); Balanced `0`. Prove each lands in its class.
4. `physical_reading` (payload): package — the physical (massive) sector is exactly POSITIVE; the
   protected massless modes are PROTECTED-NULL; INDEFINITE is unphysical. So "which particles are
   physical" is a signature classification of the sector form. Honest scope: a finite linear-algebra
   classification of sector forms, not a derivation of the SM particle content.

MANDATORY non-degeneracy: the four witnesses explicit and distinct; the distinguishing vectors
(kernel vector, negative-value vector) exhibited nonzero in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL symmetric rational matrices; Mathlib PosDef/PSD API + ring/norm_num/
decide/fin_cases; NO Complex, NO Real.sqrt, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace PositiveSectorClass) + ARISTOTLE_SUMMARY.md.
