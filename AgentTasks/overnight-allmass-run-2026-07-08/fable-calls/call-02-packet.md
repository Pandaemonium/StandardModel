# Fable-5 call 02: two hard theorems + the state-of-the-program synthesis

You are the most capable theorist on this formalization program. Since
call-01 (which you used to RESOLVE the central positivity crux S1-CC as a
structured no-go — closure is exactly balanced on the physical sector), the
executors have kernel-checked the algebraic engine of your resolution
(`anticonj_odd_pow_trace_zero`, `anticonj_charpoly_eq`,
`half_constraint_rigidity` in `GateYM/S1CCBalancedInertia.lean`), the
finite half of the inertia count (`countP_pos_eq_countP_neg...`), and the
pre-registered numeric kill probe passed (`sig(J Q_C|_{V'/N}) = (2,2,0)`,
exactly balanced). The S1-CC crux is effectively closed.

Spend most effort on Part B and Part C. You have read-only repo + graph +
Mathlib/PhysLean access; the collaborator brief
(`AgentTasks/overnight-allmass-run-2026-07-08/COLLABORATOR_BRIEF_2026-07-08.md`)
and the S1-CC resolution
(`AgentTasks/overnight-allmass-run-2026-07-08/S1CC_RESOLUTION.md`) are the
context core.

## Part A (brief): certify or correct the balanced-inertia bridge

The one remaining Lean step in the S1-CC capstone: from
`anticonj_charpoly_eq` ((-B).charpoly = B.charpoly, kernel-checked) to
`n_+ = n_-` for Hermitian B, via the eigenvalue multiset being
negation-invariant. Codex has `card_pos_eq_card_neg_of_multiset_map_neg_eq`
(the multiset half). The missing bridge: charpoly-equality =>
Hermitian-eigenvalue-multiset negation-invariance. Give the cleanest
Mathlib route (the exact lemmas: `Matrix.IsHermitian.eigenvalues`, the
charpoly-as-product-over-eigenvalues connection, `Polynomial.roots`
multiset equality), or flag if it needs a nonstandard step. Keep it short.

## Part B (main theorem ask): the chiral winding invariant (C4)

Setting: a unitary transfer `W` on `2V` directed legs of a decorated
transport cycle, carrying a CHIRAL involution `Gamma` (`Gamma W Gamma =
W^dagger`, `Gamma^2 = 1`; concretely the edge-orientation-reversal grading).
Kernel-checked: such `W` has `det W = +-1` (`chiral_det_eq_pm_one`).
Numerically (probe `p1_zeromode_symmetry_invariant.py`): the even-V
half-winding (alternating-phase) decoration pins BOTH `+1` and `-1`
eigenvalues for EVERY hop amplitude `|t|`, at even dimension `2V` where
determinant parity alone does NOT force a pinned eigenvalue.

QUESTION: what is the correct finite invariant that forces the DOUBLE
pinning (a `+1` AND a `-1` eigenvalue), stated so it is Lean-formalizable?
Candidates: a chiral winding number a la Asboth-Obuse (arXiv:1303.1199,
in the graph) `nu_0, nu_pi in Z` for 0- and pi-quasienergy modes; a
`Z x Z` index from the two chiral sectors of `Gamma`; a spectral-flow
count. Give: (a) the precise definition of the invariant in finite terms
(no bulk-boundary limit — this is a closed finite loop), (b) the theorem
"invariant = k forces at least k pinned modes at quasienergy 0 (resp pi)",
(c) the computation of the invariant for the half-winding decoration
showing it equals 1 for both, (d) a pre-registered kill condition. If the
right object is NOT a winding number, say what it is (a Pfaffian sign? a
Clifford-module `Z_2`?).

## Part C (strategic synthesis): the highest-leverage next moves

Tonight the program resolved its #1 crux (closure positivity) and landed
the mass-budget decomposition, the finite Banks-Casher count, the RG-Schur
mass-generation witness (both scalar and propagator-general), the chiral
zero-mode determinant law, and the S1a leading-closure-energy core. The
manuscript "All mass from null edges" is drafted and audited.

With the closure-positivity crux closed, what are the THREE highest-leverage
next targets for the program — the ones that would most increase what it can
honestly claim about mass? Rank them, and for the top one give a concrete
first theorem. Consider: (i) the KP forest injection (strong-coupling gap
completion, now a well-posed combinatorics problem); (ii) the total-operator
positivity on the doublet-free complement (the survivor of S1-CC — an
aperture/turn-dominance Weyl bound); (iii) the S5 first-meson witness (a
color-singlet two-point decay rate); (iv) the S6 mass-budget on a genuine
color-singlet state (vs tonight's single-edge witness); (v) something we are
not seeing. Be specific about which would move the honest-claim frontier
most, and why.

## Output format

- Part A: the Mathlib route (or the blocker), <= 8 lines.
- Part B: definition, theorem statement(s), the half-winding computation,
  kill condition. Grade each (T / M-target / MEMO / C).
- Part C: ranked top-3 with justification; a concrete first theorem for #1.
