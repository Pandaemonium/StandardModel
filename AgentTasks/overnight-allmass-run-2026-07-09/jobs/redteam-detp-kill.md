# claude-redteam-detp-kill — STRATEGY/AUDIT: red-team the central claim "mass = det P null-edge disagreement" and produce the strongest kill-test

## This is a STRATEGY / AUDIT job, not a proof job. Deliver an analysis document, no Lean required.

You are auditing a physics-formalization program (blind to its repo). Its HEADLINE claim is:
"All mass comes from massless edges" -- concretely, for a two-null-edge state the rest mass squared is
the Plucker determinant `mass^2 = det P` where `P` is the (PSD) momentum/Gram matrix of the two null
directions, so `mass = 0 <-> the two null edges are collinear (det P = 0)` and `mass != 0 <-> they
disagree`. This is read across the particle table: massless fermion = 1 null edge (rank 1); massive
fermion = 2 (zigzag); photon = 1 null edge, 2 polarizations; massive vector = 2 edges, 3 polarizations
(longitudinal = the mass); the scalar Higgs self-mass is held OUTSIDE (spin-0, no zigzag). The program
grades claims T (source-verified) / M (machine-checked, finite avatar) / C (conjecture with kill).

## Your job: RED-TEAM it. Find where it breaks. Be adversarial but fair.

Address, concretely and with specifics:

1. **Counterexamples to universality.** Is there a massive state whose mass is NOT expressible as a
   null-edge (Plucker) disagreement? Consider: (a) the scalar Higgs -- is holding it "outside" honest,
   or does it expose that the mechanism is not universal? (b) composite / bound-state mass (hadrons,
   binding energy) -- does `det P` capture QCD confinement mass, or is that a different mechanism smuggled
   in? (c) massive higher-spin / gravitino -- does the "edges = pol - 1" counting survive spin >= 3/2?
   (d) off-shell or virtual states.

2. **The det-P shape.** `mass^2 = det P` for a 2x2 PSD `P` is `(v0 w1 - v1 w0)^2` -- the SQUARED wedge.
   Where does the sign / reality live? For complex spinors is `det P = |det M|^2` (nonneg) the right
   object, or does it hide a phase that matters? Is "disagreement" a metric, a symplectic area, or a
   determinant -- and do these come apart for >2 edges (rank > 2)?

3. **Convention pitfalls.** Metric signature (+,-,-,-) vs (-,+,+,+); the null cone's two sheets
   (future/past); little-group vs Lorentz; where could a sign or a factor of 2 silently corrupt the
   "mass^2 = 2 * disagreement" vs "= disagreement" statements?

4. **The strongest single KILL-TEST.** Propose ONE concrete, decidable test that would FALSIFY the
   claim "mass = det P null-edge disagreement" as a universal mechanism -- something a formalization or a
   calculation could check and that the program has NOT obviously already passed. State the expected
   result if the claim holds, and the result that would kill it.

5. **Originality honesty.** The program now tags the general "mass from masslessness" idea as [import]
   (Kaluza-Klein / Bars two-time / twistor / Zitterbewegung lineage) and claims only the FINITE
   det-P-disagreement mechanism + kernel grade as [orig]. Is that division fair, or is the det-P/Plucker-
   mass identification itself already standard (spinor-helicity `p = lambda~lambda`, `det = 0` for null)?
   If so, what -- if anything -- is genuinely new?

## Output format
A structured markdown analysis: for each of (1)-(5), a short verdict (holds / partially / breaks) with
the specific reasoning; then a ranked list of the TOP 3 threats to the headline claim, and the single
best kill-test spelled out. Be specific and technical; cite standard physics where relevant. Honesty
over generosity -- the point is to find real problems before reviewers do.
