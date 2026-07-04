# Four-day YM run: per-task directions and tiers

Read the matching queue item in program-doc section 14 first; this file
adds first moves, Lean-level pointers, pitfalls, and baseline / strong /
shocking tiers. Entry-point module inventory and verified API facts are in
`PREP_NOTES.md` - do not re-derive them.

## T0 - Preflight (day 1, first cycle; ~30 min)

First moves: `git status` clean check against the planning baseline;
`aristotle list` reconciliation against the ledger registry (expect
`d4a9bd1f` unitarizability RUNNING or COMPLETE - harvest it FIRST if
complete, per T4); `Scripts/oracle/validate_lgt_core.py` green;
aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` green (8060 jobs
at planning time). Post the baseline heartbeat.
Baseline: all checks recorded in ledger. There is no strong/shocking tier;
do not gold-plate preflight.

## T1 - Q1: Wilson cut factorization (RP-LINK closure; flagship)

**Goal.** Instantiate `ReflectionPositivityKernel` (RP-KER) for the
Wilson product weight on a link-reflection lattice:
`wilson_reflectionForm_nonneg`.

**First moves.** (1) Re-read `ReflectionPositivityKernel.lean`'s
mirror-coordinate convention. (2) Start with the MINIMAL geometry:
`ReflectionCutExample.twoLayerCutLattice` (all links cross the plane, so
`A = unit`-like degenerate sides - check whether it is too degenerate to
be informative; if so, build the three-layer example: one positive layer,
one negative layer, cut links between). (3) Produce the mirror
coordinates: an equiv `LinkField ~ (A -> G) x (C -> G) x (A -> G)` from
`ReflectionCore`'s link classification (positive/negative/cut), with the
negative factor parametrized THROUGH the reflection involution. This is
pure plumbing of the same kind as `TreeGaugeBridge` - use the sum-type
split pattern (PREP_NOTES gotcha 1), not subtype predicates.

**The mathematical content.** Split the plaquette family into
positive-side, negative-side (mirror-paired), and cut plaquettes.
Positive x mirrored-negative product weight is the factorized class
(`cutKernel_posSemidef_of_factorized`) - Codex's
`WilsonReflectionCompatibility` mirror-pair machinery supplies the
identification of the negative-side product with the mirror conjugate.
Cut plaquettes: their weight couples `(a, b)` through the cut variables;
show the coupling kernel is PSD via
`WilsonWeightPositivity.wilsonKernel_posSemidef` (the one-plaquette
kernel IS the positive-definite-function statement) combined with
`hadamard_posSemidef` (pointwise products of PSD kernels, for several cut
plaquettes) - then it is a nonnegative mixture
(`cutKernel_posSemidef_of_mixture`) by spectral decomposition
(`Matrix.IsHermitian.spectral_theorem` or the CFC route; a PSD matrix is
`sum_k lambda_k v_k v_k^H` with `lambda_k >= 0`). A clean intermediate
lemma to bank on the way: `cutKernel` of a POINTWISE PRODUCT of weights is
the Hadamard product of `cutKernel`s (one `ext` + `rfl`-grade proof; put
it in a small connector module since RP-KER stays Mathlib-only).

**Pitfalls.** The reflection involution's fixed-point-free-on-vertices
property (no on-plane vertices) is what makes the link classification
clean - do not silently switch to site reflection. The antilinear slot in
`reflectionForm` is the `b` argument; getting the conjugation on the
wrong side produces a false statement for nonabelian `G` (sanity-check on
`G = Z3` with a complex character weight via a small oracle fixture,
T14). Wilson weight is REAL, so `starRingEnd` acts trivially on it - the
conjugation matters only in observables; state the weight complex anyway
for uniformity (cast via `Theorem2AreaLaw.wilsonLocalWeightC`).

**Tiers.** Baseline: mirror coordinates + factorized (no-cut-plaquette)
RP on a concrete lattice. Strong: cut-plaquette mixture argument closed,
`wilson_reflectionForm_nonneg` on the concrete lattice, axiom-audited.
Shocking: the general link-reflection lattice (abstract `Reflection`
structure + a mirror-paired-family hypothesis), stated so Q2 can consume
it directly, plus the Hadamard/`cutKernel` connector lemma bank.

## T2 - Q2: transfer Hilbert space from RP (design-first)

**Goal.** From `IsReflectionPositive W`: inner-product space + positive
self-adjoint transfer operator.

**First moves.** Resolve `design:q2-transfer-polarization` in
`DISCUSSION.md` BEFORE writing Lean. Decisions needed: (a) the pairing -
define `reflectionPairing W f g` (the off-diagonal sesquilinear form
whose diagonal is `reflectionForm`), fix argument order once; (b) the
quotient route - RECOMMENDED: finite-dimensional matrix route. The
pairing is `sum_c star (f .c) K_c (g .c)` for the PSD matrices
`K_c = cutKernel W c`; assemble the block-diagonal PSD matrix `K` on the
function space `A x C -> C` (finite!) and define the Hilbert space as the
range/column space of `K` (or quotient by `ker K`), with inner product
induced by `K`. Mathlib assets: `Matrix.PosSemidef.sqrt`-era
`CFC.sqrt`, `Matrix.toLin`, `LinearMap.range`/`ker` quotients,
`FiniteDimensional`. This avoids `InnerProductSpace.Core` definiteness
plumbing entirely: define the space as `range (CFC.sqrt K)` with the
standard inner product - positivity is free, self-adjointness of the
compressed transfer operator is a finite computation. (c) What the
transfer operator IS at this layer: the one-slab convolution/compression;
`TransferPositivity.compression_posSemidef` is the existing atom.

**Pitfalls.** Do not claim a Hamiltonian or physical Hilbert space -
Krein caveat stands; this is the OS/GNS-at-finite-level construction.
Keep the statement abstract over `W` with `IsReflectionPositive W` as the
only hypothesis, so Q1's Wilson instance plugs in.

**Tiers.** Baseline: design thread resolved + statement file frozen with
documented handoffs. Strong: the inner-product space + positivity of the
compressed transfer operator kernel-checked abstractly. Shocking: applied
to Q1's Wilson instance - "the first formalized OS transfer construction
for an interacting lattice gauge ensemble" (novelty check via T12 before
using that phrase anywhere).

## T3 - Q3: D12 sector-correct transfer decomposition (design theorem)

**Goal.** Flux-sector decomposition; transfer preserves sectors; local
plaquette algebra preserves the trivial sector. Supersedes any naive
Gauss-sector gap statement.

**First moves.** Resolve `design:q3-flux-sector`. The freeze's
`TransferGapDefinition.lean` already has the predicate shell
(Gauss-invariant / zero-momentum / trivial 't Hooft flux) - build the
DECOMPOSITION on a concrete small lattice first (the 2x2 torus where the
oracle found the flux-line phenomenon; `TorusEvenCover` has the Z2 torus
machinery). Define the flux label as the winding-cycle holonomy class
(center-valued for the relevant sectors); prove: (i) the label is
gauge-invariant; (ii) multiplication by a local plaquette class function
does not change it; (iii) the transfer kernel (Q2's object, or at minimum
the fusion convolution `FusionTransferSpectrum.convLeftLinear` acting on
the class-function sector) commutes with the label projection.

**Pitfalls.** This is where a fake mass gap enters - the run's kill
condition applies: if the lowest excitation is always a flux sector, the
`finiteMassGap` target gets RENAMED (flux gap), and the report says so.
Keep "flux gap" and "glueball/local gap" as two named definitions from
the first commit. For nonabelian `G` the 't Hooft label lives in
center/conjugacy data - if the general definition resists, the Z2 torus
case IS the deliverable (it is where the phenomenon was discovered).

**Tiers.** Baseline: design resolved + Z2-torus sector decomposition
stated with handoffs. Strong: Z2-torus decomposition + preservation
theorems kernel-checked. Shocking: general finite-G statement, plus the
two named gap definitions wired into `TransferGapDefinition`.

## T4 - Q4: harvest unitarizability (`d4a9bd1f`)

Follow `AgentTasks/ym-gap-unitarizability-aristotle-2026-07-04.md`'s
checklist verbatim: download (`tar -xzf` despite the name), diff against
skeleton, semantic review (statement unchanged, no `[Simple R]` added),
local `lake env lean` + axiom audit, integrate as
`GateYM/FDRepUnitarizable.lean`, then add to `WilsonVacuumDominance` the
hypothesis-free corollaries (`norm_wilsonNormalizedGamma_le_one'`,
`wilsonStringTension_nonneg'`). If the job FAILED: read the failure note,
fix the route (the file docstring has the full matrix-algebra plan),
resubmit once; two failures = park + do it locally as a slow lane.
Baseline: harvested + reviewed. Strong: integrated + corollaries.
Shocking: also Q5 done same day.

## T5 - Q5: eigenvalue reality and ordering (after T4)

**Route.** From the unitary matrix model: `chi(g^{-1}) = conj(chi(g))`
(trace of the inverse of a unitary matrix = conjugate trace: inverse =
conjugate transpose, `Matrix.trace_conjTranspose`). Then the Wilson raw
fusion scalar `sum_g w(g) chi(g^{-1})` equals its own conjugate (reindex
`g -> g^{-1}`, use `wilsonLocalWeight_inv_of_unitary` for `w` and the
conj-character identity) - REAL. With `chi(1) = finrank > 0` real and the
one-plaquette sum real positive, `wilsonNormalizedGamma` is REAL, and
`|gamma| <= 1` (T4) becomes `-1 <= gamma <= 1`. Deliverable:
`wilsonNormalizedGamma_real`, `wilsonNormalizedGamma_mem_Icc`, and the
ordering statement against the vacuum eigenvalue in
`FusionTransferSpectrum` language. Pitfall: do NOT claim positivity of
`gamma` (false in general - alternating characters at negative-ish
couplings); the interval is the honest statement.
Baseline: reality. Strong: interval + ordering. Shocking: wired into a
`finiteMassGap`-shaped statement for the fusion operator on the
class-function sector (clearly labeled as the FUSION spectrum, not yet
the full transfer spectrum).

## T6 - Q6: KP finite polymer conclusion (Aristotle-heavy)

**Goal.** On `PolymerKPCriterion`'s frozen structures: absolute
convergence of the finite cluster expansion + the tail bound
`sum over clusters touching X at distance >= R <= C exp(-m R)`.

**First moves.** One `idea:` round on the statement shape (adopted
scoping: finite polymer set, NO full Ursell generality; tree-graph bound;
distance via an abstract `size`/`diam` function on polymers). Then a
STRATEGY Aristotle job first ("state the minimal finite KP conclusion
package and its lemma DAG"), then the proof package. Search Mathlib for
existing tree/forest combinatorics before defining any (lean-explore +
grep; `Mathlib.Combinatorics.SimpleGraph.Acyclic` exists,
exponential-bound analysis lemmas exist).

**Pitfalls.** This is the run's hardest genuinely-new formalization; two
failed proof jobs on the same statement = park with the failure DAG
recorded (that document is itself a deliverable). Keep the polymer model
ABSTRACT - no gauge theory in the statement (Q7 does the mapping).

**Tiers.** Baseline: statement frozen + strategy job returned + lemma DAG
recorded. Strong: convergence theorem kernel-checked. Shocking: tail
bound too, in the form Q8 consumes.

## T7 - Q7: strong-coupling polymer map (statement layer this run)

Map the finite-group character expansion of the Wilson weight into the Q6
polymer model; verify KP at small `beta` with volume-uniform constants.
This run: freeze the MAP (polymer = connected plaquette set with
nontrivial representation labels; weight = product of normalized
character coefficients; the `wilsonNormalizedGamma` machinery already
computes the single-plaquette coefficient) + the oracle fixture for the
KP constant on a small lattice (T14). Proof push only if Q6 lands early.
Kill condition live: non-volume-uniform constants get reported.
Baseline: map frozen + fixture. Strong: KP condition verified for Z2 at
explicit small beta. Shocking: general finite G with explicit beta_0.

## T8 - Q8: exponential clustering of local loops (after Q6+Q7)

Observable-level first: connected correlators of local plaquette/loop
class functions decay exponentially at strong coupling. Only start after
Q6 strong tier; otherwise convert effort into the statement file + the
named-lemma list. Baseline: statement frozen. Strong: proved from Q6+Q7.
Shocking: uniform in volume, stated on the Q2 transfer language.

## T9 - Q9 doorstep: the cyclicity prerequisite (stretch)

Do NOT attempt the full gap assembly unless Q1-Q3 and Q6-Q8 are strong by
day 3. The named prerequisite worth freezing regardless: the local
plaquette algebra is cyclic/dense on the vacuum in the trivial-flux
sector (statement only, with the honest note that this is where fake gaps
slip in). Baseline: statement + note. Anything more is bonus.

## T10 - Q10: infinite-volume local state (stretch; statement only)

Only as a day-4 statement freeze if Q6 landed: infinite-volume local
expectations DEFINED by the convergent cluster series; finite-volume
convergence to them. No proof attempt this run.

## T11 - Q11: boundary-circuit lasso identification

**Goal.** `chi(hol U (rect boundary)) = chi(orderedProd of ALL plaquette
holonomies)` as an ENSEMBLE statement on `RectTreeGauge`'s lattice,
completing freeze Theorem 2 end-to-end.

**Route (already derived - see the memory note in program-doc section 14
item Q11).** (1) Define the boundary circuit walk on `rectLattice` (a
typed `Walk`, bottom-right-top-left; pin with a `rfl` holonomy formula
lemma exactly like `rectPlaquette_hol_formula`). (2) Prove the
TREE-GAUGE-SLICE identity: at tree links = 1, `hol` of the boundary =
`orderedProd` over plaquettes in row-major order with `i` REVERSED within
each row (per-row telescoping `P(i,j)|_{t=1} = v(i+1,j) * v(i,j)^{-1}`).
(3) The ensemble reduction: every configuration is a rooted gauge
transform of its tree-slice representative; plaquette coordinates change
by componentwise conjugation; class functions kill it. Steps (1)-(2) are
a clean focused Aristotle package (conventions pinned by `rfl` lemmas,
per the `1d9b5b19` pattern); step (3) is in-repo plumbing on
`GaugeCoreGeneral.hol_gauge` + `RectTreeGauge.rectCoordinatization`.
**Pitfall:** the pointwise identity at GENERAL tree values is expected
FALSE - do not let any package attempt it.
Baseline: boundary walk + `rfl` pin + package submitted. Strong:
tree-slice identity harvested + verified. Shocking: ensemble reduction
closed - freeze Theorem 2 done, YM1 paper unit complete.

## T12 - YM-LIT (standing lane)

Priorities this run: (1) source-verify the RP attribution chain
(Osterwalder-Seiler 1978; the Menotti-style "RP for Wilson-type actions"
reference from the 2026-07-04 external review is UNVERIFIED - existence
check before anything cites it); (2) Kotecky-Preiss 1986 exact statement
+ a modern exposition cross-check; (3) novelty check for "first
formalized reflection positivity for interacting LGT" BEFORE any such
phrase ships; (4) keep the arXiv:2606.19362 flag standing (user reviews
it; agents do not). Protocol per the overnight plan (searches logged,
ingest via `lit_ingest.py`, pre-add existence check keyed on
arxiv_id/doi). Log in this directory's `LIT_LOG.md` (create on first
use).

## T13 - Paper-unit outlines (day-end / saturation lane)

Two units, outline only (no claim language until T12 clears it):
(1) "Finite-group lattice gauge theory, formalized: exact 2D area law"
- YM1 unit: Elitzur + even-cover + fusion + area law + concrete lattice;
inventory which theorems/files constitute it and what is missing (Q11).
(2) "Formalized reflection positivity for lattice gauge ensembles" - RP
unit: RP-KER + Q1 + Q2 skeleton. Deliverable: one markdown outline per
unit under `AgentTasks/paper-units/`, theorem-by-file table with axiom
footprints.

## T14 - Oracle fixtures (support lane)

New fixtures wanted: (1) RP small-case numeric check (Z3, complex
character observable, verify `reflectionForm >= 0` numerically and that
flipping the conjugation slot BREAKS it - guards T1's antilinearity);
(2) fusion spectrum numerics (eigenvalues of `convLeft` for S3 at a few
beta values; cross-check `wilsonNormalizedGamma` reality (T5) and
`|gamma| <= 1`); (3) KP constant fixture for T7 (small-lattice polymer
enumeration). Extend `Scripts/oracle/validate_lgt_core.py` versioned
(v0.3), record tool/version/command per CAS policy; oracle output
corroborates, never proves.
