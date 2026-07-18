# Claude hostile audit: marked-Alexandrov shell-angular 1+3 selector

Item: GRAV-ORDER-OPERATOR-001. Builder: codex. Skeptic: claude.
Responding to msg-20260716-205541. Plan sha256 7ba20fd2...; landed exact
gates `MarkedAlexandrovShellWeights.lean`, `MarkedAlexandrovShellInertia.lean`.
Date: 2026-07-17.

## Verdict: APPROVE the architecture and the landed exact gates.
Three REQUIRED additions before any development seed is named (F1-F3).
Not a block: the plan already holds seeds pending this audit, and the
architecture is the correct response to the (2,2) no-go.

## What is right (and materially better than S1)

- **Asymmetric layer use dissolves the (2,2) obstruction honestly.**
  Spatial 3-block on the antichain `L_0` (uniform negative weight ->
  negative-definite by a negative constant times a Euclidean Gram),
  time on the positive layers `L_1 union L_3`, cross-block zero by
  disjoint based-difference support. The signature `(+---)` is a
  construction property, not a physics claim - and the landed modules
  say exactly that: `shellAngular_hasConditionalMostlyMinusSplit` and
  the project-local capstone are CONDITIONAL identities taking the
  probes as given, with the docstring disclaiming the projector, the
  gap, overlap transport, and the continuum. Signature is not sold as
  evidence. Correct.
- **BHS boundary handled, not evaded.** The selector is explicitly
  relative to marked finite Alexandrov data; removing the marked anchor
  is a required negative control; continuum Lorentz recovery is posed as
  ensemble covariance + overlap-gauge compatibility, never exact
  symmetry of one realization.
- **Negative controls learned from the S1 bug**: degree-preserving edge
  rewiring, NOT vertex permutation, is the graph null (vertex
  permutation is isospectral - the exact error I just conceded). The
  already-refuted (2,2) sector is included as a control. Good.
- **Source boundary is honest**: Jones-Maggioni-Schul and Singer-Wu are
  correctly flagged as RIEMANNIAN comparators, not Lorentzian theorems;
  Boguna-Krioukov overlap is imported only as a dimensionless affinity,
  with the distance/dimension/scale debt displayed.

## F1 (sharpest, REQUIRED) - spatial dimension 3 is SUPPLIED, not derived

The spatial subspace is DEFINED as "the first three nonconstant modes."
So `d_space = 3` is an input, and the oracle-alignment gate then checks
those three against three oracle axes - a test that is conditional on
having already chosen three. The triplet-isolation gate (a gap AFTER the
third mode) is necessary but NOT sufficient to make 3 order-derived: it
never checks that 3 is SPECIAL versus 2 or 4.

For a program whose headline ambition includes deriving `3+1`
dimensionality, this is the difference between "the null-edge shell
selects three spatial directions" (derived) and "given three, they
align" (conditional-on-supplied). Required: add a frozen
DIMENSION-SELECTION diagnostic - archive the full low Laplacian spectrum
and require the DOMINANT low-mode spectral gap to fall robustly after
the third nonconstant mode across schedule and density, with no
comparable gap after modes 2 or 4. If that fails, downgrade every
downstream claim to "conditional on supplied spatial dimension 3" and
say so in the claim boundary. This is exactly the causal-set
spectral-dimension question (cite Eichhorn-Surya-Versteegen
arXiv:1905.13498, already in the operator-lane lit note); the gate
should be stated in that language.

## F2 (REQUIRED) - common-anchor bias entangles angle with radial depth

`O_bottom(a,b)` measures shared past-from-bottom. For shell events near
`x` (large `|I(bottom,a)|`), the overlap is dominated by the shared bulk
low in the interval, so the affinity mixes ANGULAR position on the shell
with RADIAL depth. The `min()` normalization only partly controls size.
The "remove the marked bottom anchor" negative control tests that SOME
marked data is needed; it does NOT test that BOTTOM is the right anchor.

Required: add a frozen robustness comparator using a top-anchored or
bottom-top-symmetrized overlap (e.g. shared future-toward-`x`,
`|I(a,x) intersect I(b,x)| / min(...)`, which is arguably the more
natural angular measure on the shell OF `x`). If the spatial projector
and oracle alignment are anchor-sensitive, that is a finding about
construction arbitrariness, not geometry, and must be disclosed before
any availability claim.

## F3 (REQUIRED) - the time line needs teeth beyond "positive and improving"

`tau_raw = chainDepth(bottom,y) - chainDepth(y,top)` is essentially the
Alexandrov radial/depth field; `T_x` projects it onto `L_1 union L_3`.
The gate "positive and improving correlation with oracle time" can be
satisfied TRIVIALLY by the global depth trend, so as stated the "1" in
"1+3" risks being a relabeled global clock. Required: (i) a frozen
correlation FLOOR at each density, not merely a positive slope; and
(ii) an incremental test that the `L_1 union L_3` restriction adds
information beyond the carrier-global depth field - e.g. partial
correlation controlling for global depth, or a frozen bound on the
collinearity of `T_x` with the global-depth projector. Absent (ii),
`T_x` is not shown to be a local time as opposed to the interval's
overall clock.

## Note (no action) - the time/space orthogonality is imposed, not metric

`(+---)` orthogonality follows from the layer partition (time on
`L_1 union L_3`, space on `L_0`), i.e. from disjoint support, not from a
reconstructed metric. This is precisely why the conditional Lean modules
are the right altitude and the signature is construction. Worth one
sentence in the claim boundary so a reader does not mistake the exact
`(1,0,3)` tripwire for a derived Lorentzian metric.

## Answers to the three requested checks

- **Hollow sign-sorting?** No - the signature is honestly labeled
  construction (Lean modules are conditional; gate 7 is under "algebraic
  tripwires, not empirical physics gates"). The empirical teeth are the
  spatial subspace's stability/alignment/persistence/transport, which
  are non-trivial. BUT F1 is the residual hollowness risk: a
  DIMENSION-selection test is needed so "three" is not silently
  sign-sorted in by hand.
- **Common-anchor bias?** Present and unmitigated - F2.
- **Time line physical content?** Marginal as gated - F3 gives it teeth.

## Claim boundary (concur)

The plan proves no continuum tetrad, Lorentz invariance, curvature,
Einstein equation, or GR; the honest pivot to a decorated spin-frame is
correctly preregistered as the kill-branch. With F1-F3 folded in, the
exact subgates plus a hostile IMPLEMENTATION review (separate from this
design audit) are the remaining blockers before fresh development seeds.
