# Q11 (round 2). The real-structure seam: build J_R, close C8, settle the sign tables

Round-1 flagged two gaps that our own analysis has since identified as ONE
object (build on this; overturn it loudly if wrong): the missing NCG real
structure J_R (section 5c: "the serious gap") and the C8 seam of the strand
construction (section 5d: the internal top-form pairing must cohere with the
Layer-D # slot - "the seam most likely to bite"). The bilinear top-form pairing
`Lambda^k x Lambda^{5-k} -> Lambda^5` cannot by itself produce our
SESQUILINEAR Krein form; the missing antilinear identification
`conj(Lambda^k) = Lambda^{5-k} (x) det^{-1}` IS a real structure. One
construction should close both gaps, derive unimodularity honestly, and settle
the fermion-quadrupling question - or fail in a way that is itself a
publishable obstruction.

## Setup (concrete; all spaces finite)

Strand fiber `F = Lambda(C^3 + C^2)` (32-dimensional), gauge group
`G = S(U(3) x U(2))` acting through `C^5`; internal grading `(-1)^F`; the
matter architecture `W = C^2_+ (x) Lambda^even + C^2_- (x) Lambda^odd`.
Candidate real structure: `J_R := (an antilinear conjugation theta on C^5,
extended to Lambda C^5) composed with (a degree-reversing duality using the
top form)`, possibly also composed with edge-orientation reversal on the base
complex. Layer-D data: the Krein fundamental symmetry J (linear), the #
antiautomorphism on operators, the carrier D with turn phi.

## The questions

1. CONSTRUCTION. Give the explicit J_R on `Lambda C^5` (formula on monomials,
   with signs): the composition of monomial conjugation and Hodge-type duality
   `e_S -> +/- e_{S^c}`. Compute, as exact finite statements: `J_R^2` per
   degree (the (-1)^{k(k+1)/2}-type sign - display the table); `J_R g J_R^{-1}`
   for `g in G` (should be `conj(g)`, making J_R intertwine the rep with its
   conjugate); `J_R (-1)^F J_R^{-1}` (the epsilon''-sign); and the induced
   sesquilinear form `B(x, y) := top-coefficient of (J_R x) wedge y` -
   Hermitian? with what per-degree signs? what graded inertia?
2. KO PLACEMENT. Assemble the (J_R^2, J_R D = +/- D J_R, J_R Gamma = +/-
   Gamma J_R) sign triple for the FULL architecture (Weyl factor included,
   base edge-reversal included if needed) and place it in the KO-dimension /
   (t,s)-signature table of indefinite spectral triples (Bizi-Besnard-Brouder
   conventions). Verdict: do the signs land where Lorentzian resolutions of
   fermion quadrupling live (KO-dim 6-like), so that quadrupling never
   afflicts this architecture - or not? If no consistent sign assignment
   exists, characterize the obstruction precisely (which axiom fails, on
   which degree sector).
3. UNIMODULARITY, HONESTLY. With your J_R in hand, redo row C8: exactly which
   coherence conditions (B Hermitian; B-adjoint = # on the decoration algebra;
   G-equivariance) are needed to force `det(g) = 1`, and are they THEOREMS of
   the construction or additional axioms? If additional, name them and give
   the minimal counterexample when dropped (the B-L direction should reappear
   exactly when the relevant condition is dropped - show it).
4. THE MAJORANA ENTRY. With J_R constructed, the Majorana-type pairing
   `<J_R psi, D psi>` becomes available. Does the unique gauge-exact bare turn
   (the sterile Majorana of row C3) coincide with the J_R-pairing on the
   vacuum/top sector? State the finite identity, and then run the
   ORDER-CONDITION CHECK on this entry (first-order vs Boyle-Farnsworth
   second-order) - the round-1 arbitration target, now fully specified.
5. LADDER. The 3-5 Lean-ready statements (with the sign tables as decidable
   finite claims on the 32-dimensional fiber, and the kappa=2-witness
   instantiation where the base enters).

## Success criterion

Either the explicit J_R with its complete sign table + the honest
unimodularity verdict + the order-condition result, OR a precise obstruction
theorem ("no antilinear J_R with properties X exists on this architecture
because Y"), with the smallest failing degree sector exhibited. Partial sign
tables with the hard cases identified are acceptable; vague optimism is not.
