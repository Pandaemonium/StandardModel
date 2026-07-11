# Design+proof job: localization and symmetry-resolved stability for the pinned defect modes (C lane, final gates)

Two ranked deliverables on the K6 palindromic register family of
context/HalfPeriodInvariant.lean (which harvested cleanly and is now
landed; do not modify the context modules). An external expert (Pro)
supplied the proof templates; adapt, verify, and transcribe honestly.

## Deliverable 1 (PROOF, kernel-only target): transfer-contraction localization

For the SC-family walk at the 3-4-5 coin, the lambda = +-1 transfer
matrices were verified exactly (sympy, pre-registered):
  T(lam, sg) = [[1/(lam c), -i s sg / c], [i s sg / c, lam / c]],
  det T = 1, eigenvalues {1/2, 2} at lam = +1 and {-1/2, -2} at lam = -1,
  stable eigenvector (i, 1) or (-i, 1) depending on sg.
Pro's template: if the bulk transfer at lam has a stable subspace with
contraction ratio rho < 1 (here EXACTLY rho = 1/2), then every pinned
defect mode obeys |psi_x| <= C rho^{d(x, defect)}, by iterating the
transfer relation; in a rational fixture the contraction is certified by
an exact PSD matrix inequality (here even simpler: exact eigenvector
algebra over QQ(i)).
Lean shape (choose the cleanest honest one):
  (a) family statement on the L=8 two-wall fixture of the landed
      WallModeWitness-type: the exact mode vector components satisfy the
      exact geometric halving |psi_{x+1}|^2 = (1/4)-scaled recursion in
      the bulk region (pure rational arithmetic on the explicit
      vectors), stated as "the landed mode is (1/2)-per-site localized
      away from the walls" with exact constants; plus
  (b) the abstract one-step lemma: if v is in the stable eigenspace of
      the exact T above then T v has coordinates scaled by exactly 1/2
      (rational algebra, no analysis).
  Avoid asymptotic language; exact finite statements only.

## Deliverable 2 (DESIGN + typechecking statements): symmetry-resolved stability

The protected 8 fields split by WHICH reflection commutes with W(b):
  - the 4 non-fixed singletons satisfy [R_site, W] = 0 where R_site is
    the landed reflR (site-centered axis through sites 1, 3);
  - the 4 domain blocks instead satisfy a BOND-centered reflection
    symmetry (axis through bonds; e.g. ++-- is fixed by the swap
    0<->1, 2<->3). Verify this exactly and name the second reflection
    R_bond; check [R_bond, Gamma] as well.
  - the 4 blind fields (fixed singletons) commute with NEITHER (landed:
    reflR_comm_walk_iff).
This two-reflection split is the finite avatar of the two chiral
timeframes and should be stated as such (design memo).
Pro's stability template, to adapt: with P_eps the spectral projection
at eps in {+1, -1} and P_r = (1 + r R)/2 for the applicable reflection,
  nu_{eps, r} = trace(Gamma P_r P_eps)
is an integer, and under continuous perturbations preserving unitarity,
Gamma-chirality, the applicable reflection symmetry, and an open gap
around eps (defect modes excepted), it is constant - modes can vanish
only in opposite-chirality pairs within a sector.
Tasks:
  (1) compute the exact tuples (nu_{+1,+}, nu_{+1,-}, nu_{-1,+},
      nu_{-1,-}) for all 8 protected fields with their applicable
      reflection (exact rational eigendata; the +-1 eigenspaces are
      2-dimensional on singletons and 4-dimensional on blocks per the
      landed audit). Report whether the sectorwise indices are nonzero
      (the "globally cancelling, sectorwise protected" pattern) - the
      landed global signed index is (0,0) for every field.
  (2) If nonzero: write typechecking Lean statements for the finite
      stability theorem in the cleanest finite form - e.g. for a
      CONTINUOUS path W_s of unitaries with Gamma W_s Gamma = W_s^T,
      R W_s = W_s R, and 1 (resp. -1) isolated in spec(W_s) with
      constant total multiplicity near eps... state carefully; if
      continuity-based statements are too analytic for Mathlib matrix
      API, give the strongest discrete version (e.g. invariance under
      conjugation by Gamma-and-R-commuting unitaries, plus a rank
      argument for small perturbations) and say exactly what is lost.
  (3) Honest boundary: if the sectorwise indices are ALL ZERO too (the
      landed pattern suggests balanced chirality is possible), report
      the table and state the consequence plainly: symmetry-resolved
      chirality is also blind, and stability must come from a different
      mechanism (e.g. the self-adjointness discriminator itself as a
      discrete invariant under sign-pattern-preserving deformations).
      That negative would also be a bankable result - do not force a
      positive.

Deliverable: PINNED_STABILITY_DESIGN.md + statements file; exact
computation tables for every claim; native_decide only for finite
rational facts with disclosure, kernel-only where feasible.
