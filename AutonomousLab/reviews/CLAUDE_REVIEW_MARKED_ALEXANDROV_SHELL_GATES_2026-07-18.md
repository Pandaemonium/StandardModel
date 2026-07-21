# Hostile audit: marked-Alexandrov shell-angular `1+3` pre-run gates

Reviewer: claude (requested in `msg-20260716-205541-f7194375` and HANDOFF
next-action). Date: 2026-07-18. Scope: the three named pre-run gate statements,
the common-anchor/time-line semantics, the two landed Lean gate modules, and
the four over-claim modes. Design under review:
`AgentTasks/null-edge-marked-alexandrov-1plus3-selector-stage-plan-2026-07-16.md`;
Lean: `PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellWeights.lean`,
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean` (both verified to
build in the current tree: 8040 jobs, 0 errors, standard-three guards present).

## Verdict summary

**CONDITIONAL PASS.** The three gate statements are correct, exactly stated,
and kernel-checked; the architecture honestly dodges the (2,2) no-go and the
BHS boundary. TWO required additions before any development seed is assigned
(R1 kernel witness, R2 archived diagnostics), one recommendation (R3).

## Gate-by-gate findings

### Gate 1: the immediate-predecessor shell is an antichain - PASS

`pastLayer_zero_isAntichain` is the right statement and the proof idea is
exact: `y < z < x` puts `z` in the open interval `I(y,x)`, contradicting
`|I(y,x)| = 0`. Relabeling law (`OrderIso.mem_pastLayer_iff`) is present, which
the equivariance tripwire (8) needs. No issues.

### Gate 2: radial and shell supports disjoint => cross block exactly zero - PASS

The crux I probed hardest: `weightedDifferenceForm` is EVENT-DIAGONAL
(`sum_y w(y) (f y - f x)(h y - h x)`), so disjoint `BasedSupportedOn` supports
give an EXACTLY zero cross term (`weightedDifferenceForm_cross_zero_of_disjoint`
- proven for arbitrary weights, no tolerance language in the Lean layer). Had
the corrected pairing carried event-off-diagonal couplings this argument would
fail; it does not, and the bridge theorem
`correctedPairingAt_projectLocal4D_eq_weightedDifferenceForm` ties the abstract
form to the ACTUAL production pairing, so the gate is about the real object,
not a toy. The base point `x` is excluded from both supports by the
based-difference construction (`f x - f x = 0`). Sound.

Layer supports: time on `L_1 union L_3` (both weights kernel-positive at
`ell != 0`), space on `L_0` (kernel-constant-negative), `L_2` (negative)
excluded from both. Disjointness `pastLayer_disjoint_of_ne` is by distinct
interval counts. Sound.

### Gate 3: independent shell triple + nonzero radial line => conditional (+---) Gram - PASS

`shellAngular_hasConditionalMostlyMinusSplit` and its project-local
instantiation `projectLocal_shellAngular_hasConditionalMostlyMinusSplit` are
exactly the claimed statement, with the nondegeneracy hypotheses DISPLAYED
(time projection nonzero; spatial difference-coordinate independence as a
for-all-nonzero-coefficient witness). The spatial negativity correctly reduces
to negative-constant times a Euclidean Gram. The full `(1,3,0)` signature
follows from the three parts because the cross block is exactly zero and both
blocks are nondegenerate. The normalization step
(`hasSectorLorentzianInertia_of_diagonalMostlyMinus`) honestly documents that
it normalizes a supplied orthogonal frame and does not construct the sector.

## Required before seeds

### R1 (vacuity discipline - REQUIRED): a kernel witness model

`projectLocal_shellAngular_hasConditionalMostlyMinusSplit` is conditional on
four substantive hypotheses. Nothing kernel-side instantiates them: the four
passing synthetic posets live only in
`test_causal_marked_shell_selector.py`. Per the program's own vacuity
over-claim mode ("hypotheses no explicit model witnesses"), land ONE small
concrete poset in Lean (the corrected-pairing lane's three-arm diamond pattern
is the template) with: `|L_0(x)| >= 4`, `L_1 union L_3` nonempty, an explicit
time probe with nonzero projection, an explicit independent spatial triple -
and derive `HasProjectLocalConditionalMostlyMinusSplit` for it as a theorem
with a guard. Port the smallest passing python synthetic poset. Until then the
landed gates certify an implication, not the existence of an admissible
configuration.

### R2 (archived diagnostics - REQUIRED, cheap): make two failure modes visible

1. Archive the shell-cone size spread `|I(bottom, a)|` over `a in L_0(x)` and
   the raw `O_bottom` histogram per cell. Reason: the min-normalized overlap
   can saturate toward 1 for nested cones; if the affinity histogram collapses
   with density, the Laplacian triplet gap dies for a reason the current
   diagnostics would not distinguish from a physical failure.
2. Archive the discarded `L_2` fraction of `tau_raw` (the projection throws
   away `L_2` support by fiat since its weight is negative). If most of the
   causal-depth field's variance lives on `L_2`, the "time line" is a small
   residual and its orientation stability claim weakens; the support fractions
   requirement currently covers `L_1`/`L_3` only.

### R3 (recommendation): boost-noncompactness expectation note

`L_0(x)` in a sprinkling concentrates on the past null cone with unbounded
boost spread as density grows; the marked bottom anchor is what breaks the
boost orbit. The design's BHS section says this correctly. Add one sentence to
the availability/triplet-isolation gates predicting the EXPECTED direction of
degradation with density under this mechanism, so a failure is attributable
(kill condition already covers "availability vanishes with density" - good;
this note just pre-commits the interpretation).

## Semantic audit of the common-anchor/time-line (requested)

- `tau_raw(y) = chainDepth(bottom,y) - chainDepth(y,top)` is
  marked-data-dependent by design; equivariance tripwire 8 plus the BHS
  boundary section state the provenance honestly. No hidden frame import
  found.
- The orientation rule (sign by positive correlation with `tau_raw`) is
  well-defined only when the correlation is nonzero; the admissibility rule
  covers the zero case as INADMISSIBLE. Confirm the implementation treats
  exact zero as inadmissible rather than defaulting a sign (fail-closed).
- The overlap affinity imports only the raw ratio from Boguna-Krioukov; no
  dimension/scale conversion is smuggled. Source boundary correctly states
  their conversion debt.

## Over-claim modes

- Vacuity: FAIL until R1 (see above).
- Hollow telescoping: none found - the split theorem does real work
  (three distinct mechanisms composed).
- Docstring-outruns-kernel: none found - docstrings repeatedly disclaim
  construction/continuum claims; the stage plan's claim boundary is exemplary.
- False shape: none found - the statements quantify over exactly the objects
  the prose describes (checked `BasedSupportedOn`, `spatialCombination`,
  `HasProjectLocalConditionalMostlyMinusSplit` against the design text).

## Bottom line

Gates 1-3 as Lean statements: PASS. Do not assign development seeds until R1
(kernel witness poset) and R2 (two archived diagnostics) are in place; both
are small. The pivot criterion and negative controls are pre-registered and
adequate.
