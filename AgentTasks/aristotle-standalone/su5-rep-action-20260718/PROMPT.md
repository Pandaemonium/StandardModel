# Task: the su(5) action on 5* (+) Lambda^2(5) (+) 1 as one representation (item-3 remainder)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, SM-derivation lane.
Self-contained two-file package: `SU5HyperchargeUnification.lean` (PROVEN,
Mathlib-only - the Cartan-level hypercharge tables `Y5`/`Y5bar`/`Y10`,
tracelessness, quantization, block commutation) and the target.

## Target

`PhysicsSM/Draft/NullEdge/SU5RepresentationAction.lean` - seven theorems
ending in a hole. Content: upgrade the LANDED charge tables from
eigenvalue tables to an actual Lie-algebra representation:

1. `lambda2Act_antisymm` - the `A * W + W * Aᵀ` action preserves
   antisymmetry (short: transpose algebra).
2. `dualAct_bracket`, `lambda2Act_bracket` - both actions are Lie-algebra
   representations (commutator compatibility; matrix algebra, `ring_nf` /
   `noncomm_ring`-grade after unfolding `mulVec` composition; the dual
   action needs `Matrix.transpose_mul` + `mulVec` composition lemmas).
3. `dualAct_YGen_eigen` - the diagonal hypercharge generator acts on the
   dual basis covector `Pi.single i 1` with eigenvalue `Y5bar i` (the
   landed dual table). Diagonal `mulVec` on `Pi.single` is a one-line
   computation plus the `Y5bar = -Y5` definition.
4. `lambda2Act_YGen_eigen` - on `wedgeBasis i j = single i j 1 - single j i 1`
   the eigenvalue is `Y10 i j = Y5 i + Y5 j` (the landed pair-sum table).
   Diagonal-times-single entrywise computation.
5. `rep_hypercharge_trace_zero` - the one-generation eigenvalue sum over
   `5*` basis + the `i < j` wedge pairs + the singlet vanishes (finite
   rational arithmetic; `decide` or `norm_num [Fin.sum_univ_five]`).
6. `blockDiagonal_comm_YGen` - block-diagonal generators commute with the
   hypercharge generator (entrywise: `Y5` is constant on each block by the
   landed `Y5_const_color` / `Y5_const_weak`).

## Why this matters

The ten-goals status map's item-3 open remainder is verbatim "the full
SU(5) group action on the 5* (+) 10 (+) 1 as one rep (vs the Cartan-level
result here)". This job closes the Lie-algebra-level version and makes the
landed tables THEOREMS ABOUT A REPRESENTATION rather than standalone
arithmetic.

## Pre-registered honesty license

If a sign/transpose convention must flip for the eigenvalue theorems to
hold (dual action `-(Aᵀ)` vs `-(Aᴴ)` style), fix the convention ONCE
consistently across the file, record it prominently in the docstrings, and
keep the eigenvalue payload exact. Do not modify the included proven file.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/SU5RepresentationAction.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All seven theorems (or honestly convention-corrected versions) proven,
zero holes, and a completion report: solved targets, convention choices,
axioms used.
