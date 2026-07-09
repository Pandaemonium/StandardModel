# claude-photon-single-edge — the photon is a single null edge; a massive vector is two (mass = disagreement), across spin

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Complete the "mass from massless" statement across the particle table on the BOSON/gauge side,
tying the momentum-level edge count (MasslessEdgeCount) to the polarization count
(HiggsLongitudinalMode). A massless gauge boson (photon) is a SINGLE null direction: its momentum
Gram is rank-1 (`det = 0`, massless) AND it has 2 transverse polarizations. A massive vector is
two null edges (rank-2 momentum, `det > 0` = mass) AND 3 polarizations (the 3rd = the disagreement
/ eaten mode). So "mass = null-edge disagreement" holds for spin-1 too, and the polarization
count tracks the edge count.

## The model (explicit rational; momentum Gram + polarization space)

Photon: null momentum `k` (`k.k = 0` under `eta = diag(1,-1,-1,-1)`), momentum Gram `P = k k^T`-
style rank-1 PSD. Massive vector: timelike `k` (`k.k = m^2 > 0`), and `P` built as a rank-2 PSD
(two null constituents summing to the timelike `k`, from MassNullDecomposition's converse).

## Targets

1. `photon_one_edge`: for null `k != 0`, the momentum structure is rank-1 (`det P = 0`) = ONE null
   edge, and (from HiggsLongitudinalMode's result, restated) has 2 physical polarizations. Massless
   spin-1 = a single null direction, no disagreement, `m = 0`.
2. `massive_vector_two_edges`: for timelike `k` (`k.k = m^2 > 0`), `k = k1 + k2` with `k1, k2` null
   (two null edges), `m^2 = 2 k1.k2` (the disagreement), rank-2, AND 3 polarizations. Massive
   spin-1 = two disagreeing null edges; the mass IS their disagreement; the 3rd polarization is the
   extra edge.
3. `edge_count_eq_pol_minus_one` (payload): the number of null edges (rank) = (polarization count -
   1) for spin-1: massless (1 edge, 2 pol), massive (2 edges, 3 pol) -- `edges = pol - 1`, and
   `mass != 0 iff edges = 2 iff pol = 3`. The polarization/DOF count is the edge count shifted by
   the transverse baseline. State the exact relation.
4. `universal_verdict`: package -- "mass = disagreement of null edges" is UNIVERSAL across spin:
   spin-1/2 (MassNullDecomposition, fermion momentum) and spin-1 (here, gauge/vector) both read
   mass off the null-edge count of the momentum Gram; the boson's extra polarization is the extra
   edge. Closes the fermion/boson scope caveat of sec 2b. Honest scope: momentum-level + DOF
   counting, not the dynamical field theory.

MANDATORY non-degeneracy: null `k = (1,1,0,0)` (`k.k = 0`, rank-1, `det = 0`, 2 pol); timelike
`k = (5,3,0,0)` (`k.k = 16 = 4^2`, m = 4) with an explicit null split `k1, k2` and `m^2 = 2 k1.k2
= 16`, rank-2, 3 pol -- all explicit rationals in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational vectors/matrices; Mathlib rank/finrank + ring/norm_num/
decide/fin_cases; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace PhotonSingleEdge) + ARISTOTLE_SUMMARY.md.
