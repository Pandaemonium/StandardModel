# Dynamics, Yang-Mills, and the mass gap: the confinement program ladder

Status: program-expansion planning document, 2026-07-03 (claude), written at
the user's direction to bring interacting gauge dynamics and QCD/confinement
into program scope, with the Clay Millennium Prize problem ("Yang-Mills
Existence and Mass Gap") as the declared stretch summit. Claim grades per the
Round 8 calculus (`T` / `T|H` / `M` / `C`, originality tags); the Omega
firewall applies (no it-from-commit language below the motivation line);
every external result named here is cited FROM MEMORY and lives in the
verification-debt register (section 11) until source-verified.

Prose-to-proof note (Round 8, Attack 3.2): this synthesis document is
admissible because the gate queue advanced substantially today (three
Aristotle harvests integrated; F2.0 killed by proof; F2.1 and MP4 frozen; the
flux2d witness package submitted). The ladder below is written as GATES with
kill conditions, not as a manifesto.

**Status update (2026-07-03, same day - the ladder is CLIMBING):** the first
content wave landed and was verified in-repo (statement freeze + proofs:
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`, with its
section 12 verification addendum):

- **YM0 is DONE at the Z2 core level**: `GateYM/Z2GaugeCore.lean`
  kernel-checked (gauge-invariance core; four of six theorems depend on NO
  axioms, the rest on `[Quot.sound]` only), aggregator `GateYM.lean` added.
- **Track C oracle v0.1 delivered and independently reproduced** (30/30 in
  two environments): `Scripts/oracle/validate_lgt_core.py`, pinning
  conventions C-1..C-8 for the YM0-YM3 freezes.
- **YM1-YM4 + QCD1 statements are FROZEN** with complete finite-level
  proofs for Elitzur (quantitative, volume-uniform), the 2D exact solutions
  (incl. nonabelian S3, oracle-pinned to 1e-10), and the character-
  positivity engine behind reflection positivity. Two strategic findings:
  (i) the finite-G YM3 flagship is now finite mathematics END TO END (the
  RP engine is the same Gram move as `GateMP.SCGGramPositivity` - the
  shared-toolbox claim of section 0 is a lemma-level identity); (ii) the
  finite-lattice mass-gap definition D12 needs 't Hooft-flux quantum
  numbers (oracle-discovered on the 2x2 torus, where the naive Gauss-sector
  gap is a winding flux line, not a glueball).
- **PKG-YM1-A submitted** (Aristotle f501f8c8, the ladder's one active job
  per the budget rule) **and harvested**; **PKG-YM1-lattice is now CLOSED
  too** (2026-07-04, in-repo assembly, no Aristotle job needed):
  `GateYM/ElitzurLattice.lean` instantiates the abstract pairing bound at
  the one-site Z2 gauge flip, recovering the full quantitative,
  volume-uniform Elitzur theorem end to end (freeze document section 14).
  PKG-YM3-A is next, pending a Mathlib character-theory API session.
- **YM1 Theorem 2 is now a true expectation-value area law modulo one
  geometric layer** (2026-07-04 day session, all kernel-checked draft,
  standard axiom footprint): `GateYM/IndependentPlaquetteEnsemble.lean`
  proves Lemma 2b (ordered plaquette-tuple sums ARE the iterated fusion
  convolution; out-of-region plaquettes integrate out) and the headline
  `wilson_loop_expectation_area_law`:
  `<W_R> = chi_R(1) * wilsonNormalizedGamma^area` EXACTLY in the
  independent-plaquette ensemble, with norm/exponential-decay forms.
  `GateYM/TreeGaugeBridge.lean` proves the generic tree-gauge bridge: any
  `PlaquetteCoordinatization` (link fields ~ plaquette holonomies x tree
  residuals) collapses the LINK ensemble to that plaquette ensemble. The
  comb-gauge coordinatization of the CONCRETE 2D open rectangle was proved
  by Aristotle `1d9b5b19` (general `Lx x Ly` case, ~16 min; task note
  `AgentTasks/ym1-treegauge-rect-aristotle-2026-07-04.md`) and is integrated
  as `GateYM/RectTreeGauge.lean`, whose
  `rect_wilson_loop_expectation_area_law` puts the area law on a concrete
  lattice. The single remaining distance to the freeze Theorem 2 statement
  is the boundary-circuit lasso identification of the observable (next
  focused Aristotle job).
- **The YM mass-gap lane opened** (same session):
  `GateYM/FusionTransferSpectrum.lean` upgrades Lemma 2a to genuine
  `Module.End` spectral statements (vacuum eigenvector = constant function
  with eigenvalue the one-plaquette sum; simple-`FDRep` characters are
  eigenvectors of the fusion transfer operator), plus the string-tension
  form `|<W_R>| = |chi_R(1)| exp(-sigma * area)`;
  `GateYM/WilsonVacuumDominance.lean` proves `|gamma| <= 1` and
  `sigma >= 0` (vacuum dominance) under an explicit unitary matrix-model
  hypothesis - discharging it is finite-group unitarizability (Weyl
  averaging), the next gap-lane Aristotle target. NOT yet claimed: any
  identification with the D12 `finiteMassGap` (needs eigenvalue
  reality/ordering).

Where it sits: sibling to `Sources/Null_Edge_Measure_Problem.md` (the
program's central open problem) and `Sources/Null_Edge_Dynamics_Gate_D.md`
(program-native dynamics routes); consumer of the Gate C1/C2 lattice
machinery (`PhysicsSM/Draft/NullEdge/GateC1`, `GateC2`); feeds
`docs/NERD_ROADMAP.md` (roadmap integration is a follow-up edit, not done
here).

## 0. "Adding dynamics": two senses, and which one this document adds

The program currently lacks dynamics in two different senses, and conflating
them would be a planning error:

1. **Program-native dynamics** - the growth law of the decorated null graph.
   This is the Measure Problem, already documented, gated (MP1'-MP4, D0-D8),
   and in progress. THIS DOCUMENT DOES NOT DUPLICATE IT.
2. **Interacting gauge dynamics on a fixed finite lattice** - Wilson-type
   lattice gauge theory (LGT): link variables in a compact group, plaquette
   action, Haar-measure path integral, transfer matrix, Wilson loops. This is
   what QCD/confinement lives in, it is ALSO the standard mathematical road
   toward the Millennium problem, and the program has never touched it beyond
   fixed background fields (the flux witnesses). THIS is what this document
   adds.

The two share a toolbox (transfer operators, polymer/cluster expansions,
reflection positivity, character expansions), so rungs built here are
reusable for the Measure Problem track and vice versa. That shared toolbox is
a real efficiency argument for climbing this ladder, independent of the
summit.

## 1. What is actually being attempted (the prize, stated exactly)

The Clay problem ("Yang-Mills Existence and Mass Gap", official statement by
Jaffe-Witten; text and CMI rules in the debt register) requires, for ANY
compact simple gauge group `G`:

1. **Existence**: construct a quantum Yang-Mills theory on `R^4` satisfying
   axiomatic properties at least as strong as the cited standards
   (Wightman axioms, or Euclidean Osterwalder-Schrader axioms plus
   reconstruction) - a genuine CONTINUUM quantum field theory, non-trivial
   (interacting), with the gauge group built in correctly.
2. **Mass gap**: a constant `Delta > 0` such that every state orthogonal to
   the vacuum has energy at least `Delta` (equivalently, exponential
   clustering of correlations).

Fine print that the program commits to respecting, on pain of the F2.0
lesson (motivated redefinition is self-deception):

- The prize problem is PURE Yang-Mills, no quarks. "QCD proper" (fermions,
  chiral symmetry breaking, hadrons) is an extension beyond the prize, not
  the prize.
- The prize criterion is the MASS GAP, not confinement. Wilson-loop area law
  (confinement of static fundamental charges) is closely associated physics
  but is neither the stated criterion nor interchangeable with it. This
  document keeps three DISTINCT notions separated at all times:
  (a) mass gap (spectral statement), (b) Wilson-loop area law (confinement
  statement), (c) entanglement area law (a THIRD, unrelated-in-this-context
  notion from Round 6's Hastings note - never to be conflated with (b)).
- A lattice theorem is not the prize. The lattice is the standard VEHICLE
  (uniform-in-spacing bounds followed by a controlled continuum limit is the
  community's envisioned route), but the final statement lives in the
  continuum. The program's discrete ontology does NOT license redefining the
  target; if anything the program's own two-column architecture (Round 8)
  says exactly this - Column B is where exact continuum statements live, and
  the prize is a Column B statement.
- CMI procedure: qualifying publication, a waiting period (nominally two
  years), and general acceptance in the community. A machine-checked proof
  would materially help acceptance but does not bypass the process.

## 2. Honest position assessment

**What the program has that is genuinely relevant:**

- A working culture and toolchain for KERNEL-CHECKED finite lattice operator
  theory (Gates C1/C2: GW/overlap operators, index calculus, explicit gauge
  backgrounds with holonomy and gauge-invariance lemmas - the flux witnesses
  already contain link variables, plaquette holonomy, and Wilson-type terms).
- The Aristotle pipeline, which today routinely closes finite linear-algebra
  and combinatorics packages in hours.
- Mathlib assets verified TODAY via lean-explore: Haar measure on compact
  groups (`MeasureTheory.Measure.haarMeasure`, with regularity on compact
  spaces) EXISTS; `Matrix.specialUnitaryGroup` / `Matrix.unitaryGroup` with
  group structure EXIST; finite-group representation/character theory exists.
  Peter-Weyl does NOT exist in Mathlib (checked; no hits); cluster/polymer
  expansion machinery does NOT exist (checked; no hits). Reflection
  positivity and lattice transfer matrices: absent (unsurprising).
- The gauge-as-code identification (Round 6): Z2 lattice gauge theory IS the
  toric code, so the finite-group rungs below double as quantum-memory
  formalization with a second interested community.
- For the QCD extension specifically: the C1/C2 overlap-fermion machinery is
  THE modern lattice-QCD fermion technology - the program accidentally
  already owns the hard fermionic half.

**What the program lacks:**

- Any interacting path integral: no Haar-integrated partition function has
  ever been written in this repo.
- All the constructive-QFT analysis: cluster expansions, RG blocking,
  uniform bounds, reconstruction theorems. None formalized by anyone, ever.
- Analysis horsepower generally: the program's wins are finite algebra;
  YM4+ needs genuine hard analysis formalized, which is slower by an order
  of magnitude.

**The honest probability statement.** The mass-gap problem has been open for
~50 years; the strongest partial results (Balaban's UV-stability program;
the disputed Magnen-Rivasseau-Seneor construction; the modern probabilistic
school) have not closed it, and rung YM6 below - carrying the gap through
the strong-to-weak-coupling crossover - is the actual open problem with NO
known route, here or anywhere. The prize is a decade-class lottery ticket
CONDITIONAL on everything else going perfectly. Therefore the ladder is
designed so that its expected value is dominated by the rungs, not the
summit: every rung below is a first-of-its-kind formalization deliverable,
publishable and community-facing on its own, and several are reusable for
the Measure Problem track. We climb the known face first; nobody has even
formalized the base camp.

**The one genuinely novel contribution this program could make to the
Millennium problem itself:** the Balaban audit (YM5). Balaban's 1980s
UV-stability papers for 4D lattice Yang-Mills run to thousands of pages and
are, by broad admission, trusted-in-outline but unverified-in-detail by the
community. Machine-checking that chain - or finding its gaps - is exactly
what this program's method is for, would be historic either way, and does
not require solving any open problem to be valuable.

## 3. The three tracks

- **Track A (prize-facing formalization ladder, YM0-YM8):** climb the KNOWN
  results of constructive lattice gauge theory in Lean, in order of
  difficulty, then push into the open territory with the audit-first
  posture. This is the main track.
- **Track B (program-native gauge dynamics, YMG-gates):** put gauge/code
  decorations into the growth-measure candidates (SCG et al.), constrained
  by the proved back-reaction criterion. Exploratory; feeds the Measure
  Problem; NOT prize-facing; kept honest by its own kill conditions.
- **Track C (oracles):** strong-coupling series, small-volume transfer
  numerics, convention fixtures - the same oracle discipline as
  `Scripts/oracle/validate_flux2d_wilson_dirac.py`, feeding targets and
  catching convention drift before Lean work begins.

## 4. Track A: the gate ladder

Format per gate: statement -> deliverable -> dependencies -> effort ->
standalone value -> kill/exit.

**YM-LIT (the entry toll; days-to-weeks).** Literature and source
verification sprint: obtain and verify the primary sources in the debt
register (section 11), survey the modern probabilistic school's actual
state of the art, and record exact theorem statements (with hypotheses) for
everything the ladder plans to formalize. Per Round 8 rule (iv), no rung's
paper may cite an unverified import. Deliverable: annotated source pack +
corrections to this document. Kill: none (pure hygiene). NOTE: this gate is
BLOCKING for all paper-facing claims below; the ladder's Lean work can start
in parallel, but nothing ships before its imports are verified.

**YM0 (foundations; weeks, Aristotle-heavy).** Lattice gauge theory core in
Lean: configuration space `G^E` (links on a finite lattice), local gauge
action at sites, plaquette holonomy, Wilson action, gauge invariance of the
action, Wilson loop observables, center transformations; partition function
as Haar integral (compact `G`, using Mathlib's Haar measure) and as finite
sum (finite `G`); expectation values. Deliverable: the first kernel-checked
LGT core anywhere. Dependencies: none (Mathlib assets verified present).
Standalone value: high (foundation + a definitions paper is defensible).
Kill: none at this rung; if even this stalls past ~6 weeks, F-YM-PACE fires
and the ladder rescopes before consuming more budget.

**YM1 (first theorems: finite groups; 1-3 months).** On the YM0 base, for
FINITE gauge groups (Z2 first): Elitzur's theorem (local gauge symmetry
cannot break spontaneously - clean, finite, the right first nontrivial
theorem); the exact 2D solution by character expansion (finite abelian
case); Wegner's Z2 dualities (2D gauge <-> 1D Ising-type; 3D gauge <-> 3D
Ising). Everything here is finite combinatorics + finite character theory,
squarely in the program's demonstrated wheelhouse. Deliverable: "the first
formalized lattice gauge theory theorems" - a genuine publication, with the
QEC community as a second audience (Z2 LGT = toric code). Kill: none
(known mathematics); only F-YM-PACE applies.

**YM2 (2D Yang-Mills exact confinement; months).** The exact 2D area law:
`<W(C)> = f(area)` from the character/heat-kernel expansion. Do `U(1)`
first (circle Fourier analysis exists in Mathlib), finite groups already
covered by YM1. For compact NONABELIAN `G`: gated on **YM2-PW: formalize
Peter-Weyl** (verified absent from Mathlib today) - itself a headline
Mathlib contribution independent of physics. Deliverable: formalized exact
confinement in 2D + (via YM2-PW) a major Mathlib theorem. Kill: none;
YM2-PW may be handed to the Mathlib community rather than done in-house.

**YM3 (transfer matrix + reflection positivity; 3-9 months; first
flagship).** Formalize: the lattice transfer matrix; Osterwalder-Seiler
reflection positivity of the Wilson action; positivity of the transfer
operator; the reconstructed Hilbert space and Hamiltonian; the DEFINITION of
the finite-lattice mass gap as the transfer spectral ratio. Reflection
positivity is the single most load-bearing structural fact in constructive
QFT and has never been formalized by anyone. Deliverable: "formalized
reflection positivity for lattice Yang-Mills" - flagship-grade, of interest
to constructive QFT, probability, AND the lattice community (Round 8's
adversary-acquisition strategy: this is the paper that buys the program its
lattice-community referees). Kill: none (known mathematics).

**YM4 (strong-coupling confinement and mass gap; 6-18 months; second
flagship).** Formalize a convergent polymer/cluster expansion (the
Kotecky-Preiss criterion - clean inductive combinatorics, verified absent
from Mathlib, and REUSABLE for the Measure Problem's quantum-growth
estimates) and with it, for `beta < beta_0` (strong coupling), UNIFORMLY in
volume: the Wilson-loop area law, exponential clustering, and a transfer-
matrix mass gap - the Osterwalder-Seiler regime, kernel-checked, in 3D and
4D. Deliverable: **formalized confinement and mass gap at strong coupling**
- the strongest statement anyone could certify today about 4D lattice YM,
and the ladder's central medium-horizon prize-adjacent milestone. Honest
scope guard: strong coupling is the WRONG side of the continuum limit
(continuum requires `beta -> infinity`); this rung certifies known physics
in a known regime and claims nothing more. Kill: none (known mathematics);
pace applies.

**YM5 (RG scaffolding + the Balaban audit; years, open-ended;
the novel contribution).** Two sub-efforts: (a) formalize block-spin/RG
maps for lattice gauge fields and small clean lemmas of the RG toolkit;
(b) THE AUDIT: begin machine-verification of the Balaban UV-stability chain
for 4D lattice YM (or of the modern re-derivations of parts of it - debt
register), explicitly framed as an audit that succeeds by EITHER confirming
OR locating gaps. No completion promise; value accrues per verified paper.
Deliverable: rolling audit reports; any confirmed-or-refuted milestone in
that chain is a significant publication. Kill/exit: if after a pilot audit
of one paper the effort-per-page is prohibitive (F-YM-PACE at this rung),
downgrade to (a)-only and file the audit as infeasible-with-current-tools -
itself a useful datum about formal methods.

**YM6 (the crossover; OPEN - this is the actual Millennium problem).**
Carry the mass gap from the strong-coupling regime (YM4) through the
weak-coupling/continuum limit (whose UV side YM5's subject matter
controls). Known candidate MECHANISMS, all heuristic, none rigorous in 4D:
center-vortex condensation, monopole/dual-superconductor pictures, large-N
master-field routes, stochastic-quantization/PDE routes. The program
registers this rung honestly as: no route known, here or anywhere; no
schedule; no claim. The ladder's posture is to arrive at this rung with (i)
every known tool formalized and (ii) the community's attention - and then
to be positioned to formalize-as-they-emerge any partial advances from the
analytic community, or contribute audit-grade checking to attempts.
Kill: F-YM-CROSS - if YM4+YM5 complete and five years of monitoring
produce no rigorization candidate, the ladder officially drops all prize
language and continues (if at all) as a pure formalization program.

**YM7 (reconstruction and axioms; contingent on YM6-adjacent progress).**
Formalize Osterwalder-Schrader reconstruction (with the known OS-to-
Wightman subtleties - the linear-growth condition; Glaser's counterexample -
handled at full rigor) and the axiom bundle the prize text cites.
Independently valuable to constructive QFT even if YM6 never falls;
sequenced late only because its payoff concentrates there.

**YM8 (assembly; the prize statement).** For any compact simple `G`:
existence on `R^4` at the cited axiomatic standard, plus `Delta > 0`.
Listed for honesty about the summit's actual shape (note the universal
quantifier over `G` in the official text). No planning beyond YM6/YM7
feeds it; it is the asymptote, not a scheduled item.

## 5. QCD proper (the fermion extension; not the prize, genuinely native)

Where the program has an unfair advantage, because C1/C2 already built the
fermion half:

- **QCD1 (finite Banks-Casher; near-term, after YM0).** The Banks-Casher
  relation links the chiral condensate to the spectral density of the Dirac
  operator near zero. A FINITE-lattice, fixed-background version relating
  the condensate expression to the eigenvalue distribution of the overlap
  operator is finite linear algebra adjacent to the existing C2 spectral
  machinery (`epsCFC_trace_eq_inertia`, eigenvalue-count forms) - a natural,
  well-scoped Aristotle target and a genuine bridge between the mass story
  (layer 3) and QCD.
- **QCD2 (overlap fermions in dynamical gauge backgrounds).** Combine YM0's
  Haar-integrated gauge sector with the C1/C2 overlap operator: expectation
  values of the chiral index over the gauge ensemble; the index-density/
  anomaly bridge (already the named C2 successor) upgraded from fixed
  backgrounds to averaged ones. This is where "layer 6: imported context"
  in the P1 manuscript starts becoming "layer 6: program ladder exists".
- **QCD3 (chiral symmetry breaking / hadrons; far horizon).** Registered,
  not planned. Depends on YM4-class control plus fermionic expansions.

## 6. Track B: program-native gauge dynamics (YMG gates)

- **YMG1 (gauge decorations in growth measures).** Extend the SCG decoration
  layer (Measure Problem, candidate 4(e)) with link/transport decorations -
  the "code layer" of Round 6 - as part of the growth rule. The proved
  back-reaction criterion (`GateMP.SCGGramPositivity`: skeleton-weight
  coupling must be a PSD record-overlap kernel) is the standing structural
  constraint. Deliverable: a frozen definition + positivity statement
  (Gram-style, likely free again by construction). Exploratory.
- **YMG2 (confinement-as-code-distance: precise or filed).** Round 6's
  analogy ("gap as code distance") gets one chance at a precise finite
  statement connecting a string-tension-like quantity in a decorated-growth
  model to a code-distance growth rate, WITH a kill condition, or it is
  filed as an analogy and retired from serious prose. Pre-registration
  required before any computation, per the F2 discipline.

Track B claims no prize relevance. Its value is Measure-Problem-facing.

**Convention note for any future null-edge-native gauge action (YMG0-CONV,
blocking for that work when it starts).** The Track A ladder deliberately
works on abstract oriented lattices with standard (hypercubic-style)
conventions, because that is where the known constructive results live. If
and when a null-edge-NATIVE Wilson-type plaquette action is defined on the
tetrahedral/oblique translation lattice (Track B, or a future universality
comparison), its naive-continuum expansion MUST carry the oblique
metric/tetrad weights explicitly: the tetrahedral frame vectors are not
orthonormal, so the hypercubic normalization of the plaquette action
(`1/(4 g^2) F^2` with unit lattice-direction weights) cannot be borrowed
blindly. This is the same class of convention hazard the octonion
ConventionBridge exists for, and it gets the same treatment: freeze the
weights in a statement file plus oracle fixture BEFORE any Lean work, and
route any comparison to standard Wilson LGT through an explicit conversion
lemma, not a silent identification.

## 7. Track C: oracles

Small-volume strong-coupling series (character expansions), transfer-matrix
gap numerics, and Wilson-loop estimates on tiny lattices, as convention-
pinning fixtures for YM0-YM4 targets - same pattern and same honesty rules
as the C2 flux oracle (tool versions recorded; oracle output never cited as
proof; the Lean theorem depends on explicit objects only). First deliverable
whenever YM0 statements are being frozen: `Scripts/oracle/validate_lgt_core.py`.

## 8. Sequencing and resourcing (does not displace the live queue)

Nothing here preempts the current queue: the flux2d harvest (Aristotle job
a6ebbbf7, running), the F2.1 execution, the MP1' v1 pre-registration, and
the P1 verification-debt sprint all come first. The YM ladder starts as a
night-track/slack activity: YM-LIT (reading, no Lean) and YM0 (one focused
Aristotle package) are the only near-term commitments, and the budget rule
is explicit - the ladder gets no more than one active Aristotle job at a
time until YM1 ships, and is re-assessed at each rung against F-YM-SCOPE.
Recommended first actions, in order: (1) YM-LIT source pack; (2) YM0
statement file + Aristotle package; (3) QCD1 statement file (cheap, high
native synergy); (4) YM1 Elitzur.

## 9. Failure modes (registered)

- **F-YM-SCOPE:** the ladder cannibalizes the core program (C-gates,
  Measure, mass story). Control: the one-active-job budget rule; roadmap
  priority review at every rung boundary.
- **F-YM-CONFLATE:** any drift toward presenting lattice-regime results as
  the prize target, or conflating mass gap / Wilson area law / entanglement
  area law. Control: the section 1 distinctions are normative; violations
  are constitution violations (Round 8 halo ban) and auto-demote the
  offending claim. The section 13.2 mass taxonomy (fermion mass / Wilson
  regulator mass / YM gap / gravitational mass) extends this control to
  cross-lane mass language.
- **F-YM-PACE:** formalization throughput far below estimate at any rung
  (trigger: >2x the rung's high-end estimate with <50% of targets closed).
  Control: rescope or hand the rung's mathematical content to the community
  and keep only the audit role.
- **F-YM-CROSS:** YM6 has no rigorization candidate after YM4+YM5 plus five
  years of monitoring. Control: drop prize language permanently; the ladder
  continues only on formalization merits.
- **F-YM-LIT:** a load-bearing import fails source verification (e.g. a
  remembered theorem's hypotheses are stronger than assumed). Control:
  YM-LIT is blocking for publications; this document self-corrects.

## 10. Milestone and publication map

```text
rung    deliverable                                    audience
YM0     first kernel-checked LGT core                  formal methods, lattice
YM1     Elitzur + Z2 dualities + 2D exact (finite G)   lattice, QEC
YM2     2D YM exact area law (+ Peter-Weyl to Mathlib) formal math, Mathlib
YM3     formalized reflection positivity + transfer    constructive QFT
YM4     formalized strong-coupling area law + gap      constructive QFT, lattice
YM5     Balaban audit reports (rolling)                mathematical physics
QCD1    finite Banks-Casher, kernel-checked            lattice QCD
QCD2    ensemble-averaged chiral index                 lattice QCD
YMG1/2  decorated-growth gauge dynamics (or filed)     program-internal
```

Every row is a standalone win. The summit (YM8) appears in no row because
it is not a deliverable anyone can schedule; it is what the ladder points
at.

## 11. Verification-debt register (ALL cited from memory; verify before use)

Wilson (1974) strong-coupling confinement argument; Wegner (1971) Z2 gauge
dualities; Elitzur (1975); Osterwalder-Schrader I/II (1973/1975) and
Glaser's counterexample / linear-growth condition; Osterwalder-Seiler
(1978) lattice reflection positivity + strong-coupling expansion (area law,
gap, convergence regime); Seiler's 1982 lecture notes; Kotecky-Preiss
(1986) cluster-expansion criterion; Balaban's 4D lattice YM UV-stability
series (mid/late 1980s; scope: finite volume, per-scale bounds; NOT a full
construction); Magnen-Rivasseau-Seneor (1993) claimed YM4 construction
(status: disputed/incomplete - verify the current community assessment);
2D YM exact solutions (Migdal 1975 heuristic; rigorous constructions:
Driver, Sengupta, Levy; Levy's master-field results); the modern
probabilistic school on lattice gauge theories (Chatterjee's surveys and
strong-coupling Wilson-loop results; Cao-Chatterjee master-loop equations;
related recent work); 't Hooft (1978) center symmetry/vortices; dual-
superconductor picture (Mandelstam, 't Hooft); Banks-Casher (1980);
Glimm-Jaffe (constructive QFT reference); Streater-Wightman (axioms);
Jaffe-Witten official problem statement and CMI prize rules (publication +
waiting period + general acceptance - verify current wording); Hastings
(2007) 1D gap => entanglement area law (imported in Round 6; flagged here
ONLY to keep it distinct from the Wilson-loop area law). Mathlib asset
facts (Haar measure present; specialUnitaryGroup present; Peter-Weyl
absent; cluster expansions absent) were verified TODAY via lean-explore and
are [M]-grade, not debt.

## 12. Bottom line

Yes, the program can go after dynamics and QCD/confinement - by climbing
the constructive lattice gauge theory ladder that the analytic community
built but never formalized, using the toolchain that is this program's one
comparative advantage. The plan is nine rungs; the first five are known
mathematics that nobody has ever kernel-checked, each independently
publishable, each feeding tools the Measure Problem also needs; the QCD
extension reuses the program's own overlap-fermion machinery, where it is
already strong. The summit - the Millennium mass gap - sits behind rung
YM6, which is the genuine open problem and is registered here without a
schedule, without a route, and without a claim: if the analytic
breakthrough ever comes, this program intends to be the one that can
machine-check it - and the Balaban audit (YM5) is the one place where
formal verification might itself move the mathematics. Every rung pays for
itself; the lottery ticket rides on top for free. First moves: the YM-LIT
source pack, the YM0 core package, and the QCD1 Banks-Casher statement -
none of which displaces the live queue.

## 13. Interpretation appendix: the null-edge mass mechanism and the mass taxonomy

Claim label for this ENTIRE section: **interpretation/mechanism prose**, not
theorem content. Nothing here is load-bearing for any Track A rung; its job
is to state, once and in claim-disciplined language, WHY the null-edge
program cares about this ladder beyond the formalization value, and to keep
the program's distinct mass notions from bleeding into each other.
Provenance: distilled 2026-07-04 from an external model review of this
document; the review's proposed theorem ladder was REJECTED as duplicative
of Track A (and its Gauss-sector gap statement missed the 't Hooft-flux
qualification that D12 already carries - see the freeze document); only the
mechanism framing and taxonomy below survived screening.

### 13.1 The mechanism claim (interpretation)

The null-edge matter-sector story is: primitive transport is null, and
effective mass arises relationally, from node/onsite/internal structure
(turns, coin phases, cross terms between null legs). The gauge-sector
analogue, stated as a mechanism hypothesis rather than a result:

- An open gauge transport `U_(x->y)` is gauge-COVARIANT
  (`U -> g(x) U g(y)^-1`), not gauge-invariant. There is no gauge-invariant
  one-edge state; a "gluon edge" is microscopic bookkeeping, not a physical
  particle. This is a real (finite, provable) statement and is exactly what
  the YM0/YM1 gauge-invariance layer formalizes.
- The gauge-invariant sector begins at CLOSED holonomy composites (loops,
  networks): Wilson loops and plaquette-trace glueball operators. Their
  propagation in the transfer direction involves node structure, so the
  matter-sector slogan transfers: massless microscopic transport, massive
  gauge-invariant composites.
- The mass gap, in this reading, is the statement that the lightest closed
  gauge-flux composite has strictly positive transfer energy - a
  relational/composite property, NOT a primitive mass term. In particular
  the mechanism is NOT a Proca-style `m^2 A^2` term (which would break gauge
  invariance); any presentation drifting toward "we add a gauge-boson mass"
  is an F-YM-CONFLATE-class error.
- Relation between the gap and confinement, stated carefully because
  section 1 keeps them normatively distinct: at strong coupling BOTH the
  Wilson-loop area law and the transfer gap are controlled by the same
  character/cluster expansion (the same suppression of nontrivial-
  representation flux), so the mechanism picture treats them as two
  consequences of one flux-cost structure. That shared origin is a
  strong-coupling fact; it does NOT make (a) and (b) of section 1
  interchangeable, and the prize criterion remains (a).

Conjecture-language template consistent with the above (usable when Track B
or a universality comparison eventually needs it): "the gap is the minimal
transfer energy of closed gauge-flux excitations; it is not a primitive
mass assigned to an open gauge edge."

### 13.2 The mass taxonomy (normative for program prose)

Four DISTINCT mass notions circulate in this program. Conflating any two of
them in a paper or gate document is an F-YM-CONFLATE-class violation:

1. **Fermion rest mass** (mass story / C1 lane): relational, from
   node/coin/internal phases or hidden null motion on the matter graph.
2. **Wilson regulator mass** (C1 overlap kernel): the gamma5-even onsite
   inverse-propagator term `W(k) = r sum_A (1 - cos k_A)` inside the
   overlap construction. A regulator artifact with a job (doubler
   removal); never a physical mass, and never to be cited as one.
3. **Yang-Mills mass gap** (this document): minimal transfer energy of
   gauge-invariant closed flux composites in PURE gauge theory. Must be
   explainable with gauge links and gauge-invariant loops alone - fermion
   Wilson masses and Yukawa/CKM texture are out of bounds as explanations
   here by construction.
4. **Gravitational/inertial mass** (far-future dynamical-geometry layer):
   registered only. If null-edge geometry ever becomes dynamical, all of
   the above contribute stress-energy; no claims now.

The enforcement rule is the existing F-YM-CONFLATE control (section 9),
extended by this taxonomy: a claim about one row may not borrow evidence or
language from another row without an explicit conversion argument.
