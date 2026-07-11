# Design+oracle job: is the C protection law the Cedzich et al. half-period invariant? (C gates 1-2)

DESIGN job with exact-computation obligations (memo + typechecking
statements; no large builds). Freeze-aware: prioritize the decision, then
statements.

Context: our palindromic walk W = S.C.S on the four-site register (see
context/ModeInvariantHalfWinding.lean and SignWallDefectRouteBConcrete.lean)
has, for derived sign fields: a kernel-checked involutive-compression
engine; an explicit two-wall fixture with exact +-1 modes; full-walk
zero/four-wall no-mode certificates; and PROVABLY BLIND determinants (both
levels) and naive trace indices. An independent enumeration found the
two-wall fields with equal 2pi winding split 8-vs-4 by a POSITIONAL
criterion (fixedSingleton: whether a wall pair sits on the reflection-fixed
sites). The general protecting invariant is unformalized - the paper's
central open gate.

LITERATURE ANCHOR (the design must engage it): Cedzich, Geib, Werner,
Werner, "Chiral Floquet Systems and Quantum Walks at Half-Period", Ann.
Henri Poincare 22 (2021), DOI 10.1007/s00023-020-00982-6 (arXiv likely
2006.04634). For chiral Floquet systems, invariants at HALF-PERIOD /
symmetric time frames refine the full-period winding; our palindromic
W = S.C.S is exactly a symmetric-time-frame walk (Asboth pair of chiral
frames: C^(1/2) S C^(1/2) and S^(1/2) C S^(1/2) analogues).

Tasks, ranked:
1. DECISION by exact computation: compute the half-period / symmetric-frame
   chiral invariants (the pair of frame windings / half-step indices in the
   Cedzich et al. sense, adapted to the finite four-site register - use the
   half-step decomposition of the palindromic walk and the chiral grading
   from the context file) for the three fixtures (two-wall fixed-pair,
   two-wall non-fixed-pair if distinct, zero-wall, four-wall). Do they
   reproduce the 8-vs-4 positional split and the mode counts (2+2 vs 0)?
   Report the exact values.
2. If YES: give Lean-ready statements formalizing the invariant on the
   finite register (Mathlib-only, style of the context files), the theorem
   "invariant nonzero implies involutive compression self-adjointness"
   (connecting to the landed engine), and the fixture evaluations - the
   full closure plan for the paper's gates 1-2.
3. If NO (the half-period invariants are also blind): report exactly which
   values coincide, and evaluate the next candidate: the mirror-graded
   winding (invariant computed in each reflection-parity sector of the
   chiral frame). Same deliverables.
4. Name what the invariant reads from the derived field (value-only
   discipline) and its relation to the fixedSingleton criterion.
5. Honest fallback: if neither candidate separates the fixtures, say so
   with the computed table - that itself sharpens the paper's open gate to
   "finer than half-period and mirror-graded invariants".

Deliverable: HALFPERIOD_INVARIANT_DESIGN.md + optional statement file. Do
not modify the context modules.
