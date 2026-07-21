# Task: formalize the Wilson-Cayley walk (candidate refutation of universal torus doubling)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper B lane.
Self-contained package (13 modules). Your predecessor project designed
this candidate counterexample precisely (its frontier report is included
as PREDECESSOR_PLAN.md - read it first); this job formalizes it.

## Target

`PhysicsSM/Draft/NullEdge/WilsonCayleyWalk.lean` - the three-lemma plan
plus assembly:

1. `wilsonK_sq` - Clifford square via the included pairwise-anticommuting
   Hermitian `alpha1/2/3, beta` (their relations are landed in
   `Compact3Plus1DiracRate`).
2. `wilsonK_eq_zero_iff` - zero set = origin lattice: `sin q_j = 0` for
   all `j` AND `s(q) = 0` forces every `q_j` in `2πℤ` (the `s = 0` part
   kills the odd-π branches of `sin = 0`).
3. `cayley_mem_unitary`, `cayley_crossings` - the general Cayley package:
   `1 + iK` is invertible for Hermitian `K` (eigenvalues `1 + iλ ≠ 0`),
   unitarity by direct computation, and the exact crossing dictionary
   `U - 1 = -2iK (1+iK)⁻¹` (singular iff `det K = 0`),
   `U + 1 = 2 (1+iK)⁻¹` (never singular).
4. `wilsonCayleyWalk` - assemble the `AdmissibleWalk` fields. The Dirac
   tangent needs the derivative of the Cayley transform at `0`:
   `U'(0) = -2i K'(0) = -i alpha_j` along axis `j` (Mathlib's
   `HasDerivAt` calculus through matrix multiplication and
   `Ring.inverse`; `K(0) = 0` simplifies the quotient rule at the
   evaluation point).
5. `wilsonCayley_no_offlattice_crossing` + `not_admissible_doubling_torus`
   - the refutation assembly from 1-4.

## Honesty protocol (pre-registered)

- If any field of `AdmissibleWalk` genuinely FAILS for this walk (e.g. a
  differentiability subtlety at the tangent), that is a first-class
  finding: report exactly which field and why - it means the candidate
  is inadmissible and the universal gate survives this attack.
- Do not modify included modules. The interpretive caveat (the interface
  omits locality; a verified refutation means the interface cannot state
  Nielsen-Ninomiya, not that lattice doubling is physically evaded) is
  already recorded in the module docstring - keep it.
- Partial success order: 3 (Cayley package) > 1-2 (Wilson symbol) > 4-5.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/WilsonCayleyWalk.lean`.

## Success criteria

Full refutation assembled is full success; the Cayley package + Wilson
symbol lemmas with a precise blocker report is partial success.
Completion report: solved targets, any inadmissibility findings, axioms.

## RESTART ADDENDUM (2026-07-19 08:25)

First harvest applied: `wilsonK_isHermitian`, `cayley_denom_det_ne_zero`,
and FULL `cayley_mem_unitary` are PROVEN; the walk structure has its
unitary field closed. Remaining holes are the job, in priority order:
`cayley_crossings` (the crossing dictionary - the counterexample's core),
`wilsonK_sq`, `wilsonK_eq_zero_iff`, then the walk fields
(`wilsonCayley_periodic`/`continuous`/`origin`/`dirac`), then the two
refutation statements. Partial success = dictionary + squares landed.
