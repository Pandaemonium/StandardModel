# Aristotle strategy/audit job: four-day Yang-Mills run, day-1 whole-ladder audit

You are acting as a research strategist and adversarial auditor for a
Lean 4 formalization program, not as a Lean prover. Do NOT attempt a Lean
build. Return a written report.

Formatting requirements: ASCII only, LF line endings. In prose, write Lean
escape-hatch tokens in spaced form (`s o r r y`, `a x i o m`,
`n a t i v e _ d e c i d e`), never raw.

## Standalone context (assume you are blind to the repository)

A Lean 4 project (Mathlib-based, toolchain v4.28.0) is running a
four-day, two-agent (co-equal, coordinating via a shared ledger and
discussion log) autonomous push on a lattice-gauge-theory formalization
ladder, climbing toward - but explicitly NOT claiming - the Clay
Millennium "Yang-Mills existence and mass gap" problem. The canonical
work queue is twelve items, Q1-Q12, each a specific finite-mathematics
target on the way to a finite-lattice mass-gap theorem:

- Q1: link-reflection positivity (RP-LINK) for the Wilson weight -
  reduce to a kernel-PSD check via a master lemma (RP-KER), then
  instantiate it concretely.
- Q2: build a genuine (finite, algebraic OS/GNS-style) transfer Hilbert
  space and self-adjoint transfer operator FROM Q1's reflection
  positivity.
- Q3: a sector decomposition (Gauss-invariant / zero-momentum / trivial
  flux) so the eventual mass-gap definition measures the right
  excitation, not a global winding-flux mode a prior finite-volume
  oracle check found could be mistaken for the local glueball gap.
- Q4: every finite-dimensional representation of a finite group is
  unitarizable (Weyl's unitarian trick), needed to discharge a matrix-
  model hypothesis elsewhere.
- Q5: reality and an interval bound on a normalized fusion eigenvalue
  (the single-plaquette transfer eigenvalue), ordering it below the
  vacuum eigenvalue.
- Q6: a finite Kotecky-Preiss cluster-expansion CONCLUSION (convergence
  + a distance-decay tail bound) built on an already-frozen KP CONDITION.
- Q7: map the finite-group strong-coupling character expansion of the
  Wilson weight into Q6's abstract polymer model.
- Q8: exponential clustering of local loop observables at strong
  coupling, from Q6+Q7.
- Q9: a named prerequisite lemma (local plaquette-algebra cyclicity on
  the vacuum sector) for the eventual gap assembly - deliberately
  separated out because skipping it is exactly how a fake mass gap
  could slip in.
- Q10: define infinite-volume local expectations via the Q6 convergent
  cluster series (statement only this run).
- Q11: the last piece of a already-proved 2D exact-solution area-law
  theorem (a "lasso" identity relating a boundary Wilson loop's holonomy
  to an ordered product of enclosed plaquette holonomies under a
  tree-gauge slice).
- Q12/T12-T14: literature source verification, paper-unit outlines, and
  oracle (numerical convention-pinning, never proof) fixtures - standing
  support lanes, not proof targets.

Program disciplines assumed and auditable: no statement weakening;
draft-vs-trusted separation with kernel-checked axiom audits on every
theorem; oracle-first convention pinning (a Python numerical fixture
checks every new convention-sensitive statement BEFORE the Lean
statement is frozen, and is never itself cited as proof); a hard rule
against conflating (a) spectral mass gap, (b) Wilson-loop area law
confinement, (c) entanglement area law (an unrelated third notion); no
lattice-regime result is ever presented as "the prize"; person-name
attributions held back from claim language until sources are verified;
every design/statement decision goes through a peer cross-review thread
before Lean is written, with the standard three questions (what changes
the target, what would demote the claim, what is the most ambitious
defensible version).

## RUN-STATE as of day 1, hour ~4 (submitting agent: claude/Sonnet-5)

Both agents worked in parallel with zero file-claim conflicts. Current
state per the shared task board:

**Closed / kernel-checked this run:**
- Q4 CLOSED: every finite-dim complex representation of a finite group
  is unitarizable (Weyl-averaged Gram matrix, matrix-level, harvested
  from an Aristotle proof job).
- Q5 CLOSED: the fusion eigenvalue's reality (via Q4's unconditional
  unitary model plus a reindexing argument) and its membership in
  `[-1, 1]` (combining reality with an already-proved norm bound). The
  report explicitly does NOT claim the eigenvalue is nonnegative (false
  in general for alternating characters) - the two-sided bound is the
  honest statement.
- Q1 BASELINE TIER REACHED, NOT FULLY CLOSED: a genuine geometric
  obstruction was found and fixed (naively reflecting a 2D rectangular
  lattice through a coordinate axis, with a single uniform edge
  orientation on both sides, violates the abstract reflection
  structure's endpoint-swap axioms for every edge transverse to the
  reflected direction - verified by direct finite computation, not
  assumed). The fix (a general "doubled lattice" construction: two
  copies of any base lattice, the second with reversed orientation,
  glued by a canonical always-valid reflection with zero cut links) is
  proved and committed. Using it, the master RP kernel lemma was
  instantiated at a GENUINE gauge-invariant Wilson local weight function
  (not a per-link toy substitute, which was explicitly considered and
  rejected as not gauge-invariant). EXPLICITLY NOT YET SHOWN: that the
  actual two-plaquette mirror ENSEMBLE weight (as opposed to the
  algebraic factorized shape used) reduces to this form for independent
  mirror coordinates - by hand computation the raw mirror-plaquette
  holonomy is a differently-ordered group word, not evidently conjugate
  to the target for a nonabelian group. This gap is recorded as the
  concrete next Q1 step, not silently assumed away.
- Q3: a magnetic (Wilson-loop winding-support) sector layer was built
  first, then an external audit (Aristotle-quality strategy/red-team
  call) found that a "local plaquette flips preserve the sector label"
  claim assumed during design was FALSE in general (explicit small-
  torus counterexample), and correctly identified that the load-bearing
  notion should be an ELECTRIC (center-shift-eigenvalue) sector
  decomposition instead, with shift-invariant diagonal observables (which
  plaquette holonomy functions are, but winding Wilson loops are not) as
  the correct preservation mechanism. The team accepted this finding,
  retracted the false design-thread claim, and is mid-build on the
  corrected electric-sector construction (shift operators, sector
  eigenconditions, projection idempotence/orthogonality/resolution-of-
  identity, and abstract kernel-preservation-by-reindexing theorems all
  landed for a concrete finite-group torus and the Z2 case
  specifically). The actual transfer-matrix instantiation is explicitly
  gated on Q2, which does not exist yet.
- Q6: an Aristotle strategy job returned a report splitting the target
  into three parts: absolute convergence and a per-polymer bound are
  supported by the bare frozen KP condition with no extra hypotheses;
  an exponential DISTANCE-decay tail is NOT supported by the bare
  condition alone (it is not even statable without a metric/distance
  structure) and needs either a distance-weighted KP condition or an
  explicit energy-distance coercivity hypothesis added on top. A
  candidate Lean statement freeze reflecting this split is drafted and
  awaiting peer cross-review before any Lean file is created.
- Q2: a design proposal exists (finite block-diagonal PSD matrix
  indexed by cut-configuration times positive-side-configuration,
  Hilbert space as the range of the matrix's operator square root inside
  the ambient function space, transfer operator as an abstract
  compression with hypotheses rather than a claimed concrete one-slab
  kernel) but has NOT yet been cross-reviewed or converted to Lean.
- Q7: design-only, gated on Q6's exact interface landing first.
- Q9: a statement-only stretch module was just started (bare claim,
  no consequences).
- Q11: the boundary-circuit typed walk and its holonomy formula
  (pinned by a definitional/`rfl` lemma) are proved; a focused package
  for the next lemma (the tree-gauge-slice identity relating the
  boundary holonomy to an ordered plaquette product) is drafted and
  awaiting peer review before Aristotle submission.
- Support lanes: a source-verification pass located and confirmed a
  real published reference for one attribution but found its abstract-
  level scope narrower than any future claim language may assume;
  conservative paper-unit theorem-inventory outlines were drafted for
  two prize-adjacent units with no novelty claims; an oracle fixture
  suite (numerical, never cited as proof) is at 44/44 including new
  guards for the reflection-positivity kernel, the fusion-eigenvalue
  spectrum, and small-lattice cluster-expansion constants (one guard
  found that a candidate coupling/energy pair passes the KP condition
  at small volume but FAILS it by moderate volume at a nearby coupling -
  a live warning against assuming any convergence constant is volume-
  uniform from a small-volume check alone).

**Aristotle usage so far this run:** ONE proof-harvest (Q4) that was
already running when the run started, plus ONE freshly-submitted
strategy job (Q6, described above). An internal audit at hour ~4 found
ZERO Aristotle jobs running against an eight-slot budget, and the
program is now correcting this with a standing rule to submit
audit/strategy jobs on every open design/review thread in parallel with
peer review, not just for proof targets. THIS SUBMISSION IS PART OF THAT
CORRECTION.

**Known honest negatives / self-caught errors this run (listed because
they are as valuable as proofs and should inform your sequencing
advice):** the Q1 lattice-orientation obstruction above; the Q3
plaquette-flip-preservation retraction above; a v1 proof-job statement
in an earlier session that had a normalization bug caught by a trivial-
case sanity check before it could contaminate downstream work; a stale-
build-passed-when-it-should-not-have near-miss caught by re-running the
literal touched file rather than trusting a cached aggregate build.

## Deliverable

Return a report named `FourDay_YM_Day1_Strategy_Audit.md` answering,
numbered:

1. SEQUENCING CRITIQUE. Given the current state above, is the
   Q1-through-Q9 dependency order (RP-LINK -> transfer Hilbert space ->
   sector-correct transfer -> unitarizability/ordering -> KP -> strong-
   coupling map -> clustering -> cyclicity -> gap assembly) still the
   right one, or has today's work (especially the Q1 ensemble-
   identification gap and the Q3 electric-sector correction) revealed a
   better order? Which currently-parallel-but-independent lanes (Q2 vs
   Q6/Q7 vs Q11) should be resequenced relative to each other given
   actual velocity so far?
2. LEMMA DAG TO THE YM4 GAP. Lay out, as concretely as you can from the
   state described, the remaining lemma dependency graph from where the
   run stands NOW to a genuine finite-volume spectral-gap statement
   (not the Clay continuum problem - the finite lattice gap only). Label
   each node provable-now / needs-design / blocked-on-another-Q-item /
   genuinely-open-research. Be specific about where Q1's ensemble gap,
   Q2's design, and Q3's sector-correctness converge.
3. WHAT THE RUN IS NOT SEEING. Read between the state description for
   a risk the team has not flagged: a hidden assumption in the Q1
   doubled-lattice construction that will not survive contact with a
   genuine cut-plaquette (not-yet-built) instance; a mismatch between
   Q2's proposed finite-matrix Hilbert space and what Q3's eventual
   sector projections will need to act on; a KP distance-tail hypothesis
   in Q6 that will turn out to be either too strong (unverifiable for
   the actual Wilson strong-coupling expansion) or too weak (not enough
   to prove Q8's clustering); anything else.
4. ARISTOTLE-UTILIZATION AUDIT. Given the specific finding that the
   8-slot Aristotle budget sat empty against multiple genuinely open
   design questions (Q2's finite-matrix bridge lemma, Q3's
   commutation-with-shift-operators infrastructure, Q11's tree-gauge
   identity), which SPECIFIC open threads right now would benefit most
   from an audit/strategy job versus a direct proof-attempt job versus
   staying purely peer-reviewed? Rank the top three candidates for an
   immediate submission today, with a one-line justification each.
5. EMBARRASSMENT AUDIT. Where is this four-day push most likely to
   embarrass itself publicly or waste the remaining three days:
   a convention slip surviving from the doubled-lattice construction
   into a later "real" lattice instance; a sector-decomposition claim
   quietly reverting to the retracted magnetic-support notion in a
   later file that does not import the corrected electric layer;
   overclaiming the Q1 baseline result as full RP-LINK closure in any
   day-end report; anything else specific to this state.
6. VERDICT. One paragraph: given three days remaining, should day 2
   prioritize closing Q1's ensemble-identification gap, building Q2 from
   the current design proposal, or pushing Q6/Q7/Q8 toward the
   clustering result? State the strongest argument against your own
   recommendation.

Ground every judgment in the mathematics as described; where you rely on
literature or standard lattice-gauge-theory knowledge, name the source so
the team can verify it (they will not trust unnamed citations).
