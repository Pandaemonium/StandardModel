# Overnight publication run (2026-07-11): RUN PLAN

Start: 2026-07-10 evening PDT. Dawn audit begins at 07:00 PDT.

Executors: **Codex + Claude (Fable), co-equal**. Coordinate only through the
append-only `LEDGER.md` in this directory. Aristotle is the proof, strategy,
and adversarial-audit fleet. `AGENTS.md` and the repository convention documents
remain binding.

## 0. Mission

Turn the null-edge research program into the strongest defensible publication
portfolio the present mathematics can support. Optimize for papers that a
skeptical top-tier editor can identify as important in one sentence, that an
expert referee cannot dismiss as a reparametrization or finite toy, and that a
reader can reproduce from a clean artifact.

The ambition is field-level impact:

1. make Paper A a near-submission-quality flagship with one unmistakable result;
2. close the decisive theorem gate for as many of Papers B-E as possible;
3. develop Paper F as a genuine classification of carrier decompositions and
   consolidate Paper G only where the result is genuinely reusable;
4. make every surviving claim stronger, clearer, better positioned, and easier
   to falsify;
5. leave a complete submission package, not just improved prose.

Top-tier acceptance cannot be guaranteed by wording. The run earns that target
by closing hard theorems, confronting nearest prior art, exposing assumptions,
providing negative controls, and making the scientific consequence impossible
to miss. Stronger adjectives never substitute for a stronger result.

## 1. Documents and startup order

Read in this order:

1. `AGENTS.md`, `docs/NULLSTRAND.md`, `docs/CONVENTIONS.md`, and
   `docs/BUILD.md`.
2. `Sources/Null_Edge_Publication_Portfolio_2026-07-10.md`.
3. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.
4. `NULL-EDGE_TARGET_AUDIENCE.md`.
5. `AgentTasks/null-edge-so-what-closure-2026-07-10/GOAL_PROMPT_CODEX.md`.
6. `AgentTasks/null-edge-paper-adversarial-review-aristotle-2026-07-10.md`.
7. The latest relevant Lean modules, guards, simulation results, and recent run
   ledger entries before claiming a paper or theorem lane.

Run-local documents of record:

- `LEDGER.md`: append-only coordination and scientific decisions;
- `PAPER_GATE_MATRIX.md`: one row per publication gate;
- `MANUSCRIPT_CLAIM_MATRIX.md`: exact prose-to-theorem/source map;
- `REFEREE_OBJECTION_REGISTER.md`: strongest anticipated objections and their
  disposition;
- `ARISTOTLE_QUEUE.md`: ranked jobs, seeds, kills, and harvest state;
- `LIT_SEARCH_LOG.md`: literature and public Lean-package searches;
- `HONEST_SCORECARD.md`: dawn verdicts;
- `MORNING_REPORT.md`: final handoff.

## 2. Standing state: harvest before invention

At startup run `aristotle list --limit 40`. The live frontier at plan creation
contains the following high-value work; verify status because it may have
changed:

- `57fc7076`: full-Bloch split helper;
- `5337cc9e`, `d13856aa`: full-Bloch minus/plus branches;
- `b605f8b8`: finite CAR second quantization;
- `14ce545e`: strict-QCA successor strategy;
- `7ea06419`: changing-lattice ultraviolet tail;
- `c6cdee4d`: earlier full-Bloch determinant project;
- `47b0fbe6`: doubler-free regulator result, already harvested in part;
- `b4b82493`: earlier L2/PDE bridge;
- `d6da22f3`: complete-paper adversarial review, already dispositioned but
  retained as a baseline.

Download proof-complete snapshots even if remote verification is still active.
Do not submit replacements until the current source has been inspected. A
remote build failure is not a mathematical failure if the returned theorem
source is complete and passes locally.

Every harvested result receives one of four verdicts:

1. **landed**: unchanged statement, semantic audit, witness/control, guard,
   targeted build, documentation;
2. **killed**: exact counterexample or no-go, promoted as a result;
3. **sharpened**: precise blocker and typechecking handoff;
4. **rejected**: proof does not establish the intended claim, with reason.

## 3. Publication priority stack

### P0. Paper A: ship the flagship

Working paper: `From Null-Spinor Area to a Dirac Gap`.

The paper must answer, in its abstract and first two pages:

> What is forced by the null-spinor data, what is new beyond assigning a Dirac
> mass, and what observable or structural consequence follows?

Mandatory closures tonight:

1. resolve every advertised full-Bloch formula or remove it from the headline;
2. state the strongest exact all-zone obstruction and distinguish zero modes,
   pi modes, and body-center crossings;
3. make the canonical chain visually and mathematically explicit:
   null spinors -> complex Pluecker coordinate -> unique Hermitian rest operator
   -> exact unitary dynamics -> phase-sensitive histories/local connection;
4. include the constant-mass reparametrization baseline and then identify the
   first theorem that escapes it;
5. state continuum results at their exact fixed-momentum, compact-support, or
   changing-lattice scope;
6. supply a nearest-work comparison table with theorem-level differences;
7. expose all negative results: strict-QCA obstruction, phase-lift obstruction,
   homogeneous scale-selection collapse, and RG-family nonclosure;
8. complete artifact, data/code availability, assumptions, conventions,
   theorem index, and reproducibility statements.

Upgrade gate for a prestige physics venue: Paper A must absorb either a
protected defect theorem from Paper C or a strict finite-range alias-controlled
`3+1` successor from Paper B. Without one, optimize it as a superb specialist
mathematical-physics paper rather than pretending the upgrade already landed.

### P1. Paper C: protected Pluecker defect theorem

This is the highest-upside independent theorem race.

Target chain:

```text
local nonzero spinor pairs away from a defect
-> patched complex Pluecker field
-> exact transition/link cocycle
-> finite winding/index operator
-> explicit localized mode
-> stability under a displayed perturbation class
```

Required controls: zero winding, no global real lift for winding one, gap away
from the defect, nonzero localized eigenvector, and a perturbation that remains
inside the theorem's hypotheses. Kill condition: if the local walk is
spectrally equivalent to an arbitrary assigned complex mass field with no
additional invariant consequence, say so and keep the phase result inside A.

### P2. Paper B: strict `3+1` QCA theorem

Return one complete scientific result:

1. a concrete finite-range, exactly unitary, alias-controlled successor with a
   full Dirac tangent and complex Pluecker mass compatibility; or
2. a sharp resource lower bound proving what must increase: internal dimension,
   cell size, range, substep count, or symmetry breaking.

Corner sampling is forbidden as a completion criterion. The all-Bloch
determinant, characteristic polynomial, or equivalent exact spectral
classification is mandatory. The Wilson Hamiltonian remains a comparison
control, not a strict-QCA solution.

### P3. Paper D: changing-lattice continuum theorem

Close the bridge from exact finite walks to the position-space Dirac PDE:

- changing Hilbert spaces and exact Fourier normalization;
- explicit sampling and interpolation maps;
- walk-specific product-DFT conjugacy;
- compact/tail decomposition for a stated Sobolev class;
- strong `L2` convergence on compact time intervals;
- identification of the limiting multiplier with the Dirac flow;
- explicit rate where proved, qualitative convergence where not.

Do not claim operator-norm convergence, variable-coefficient convergence, or a
continuum field theory unless those statements actually land.

### P4. Paper E: local CAR lift and operational interaction

Close creation covariance, functoriality, unitarity, and inherited locality of
the finite Fock lift. Then compute one quantity that a one-particle assigned
mass model does not contain: a phase-dependent scattering phase, transition
probability, bound-state shift, threshold, or exact selection rule.

The rank-two kick is a seed. The paper is earned only when it sits inside the
local many-fermion dynamics and has an operational consequence.

### P5. Paper F decomposition moduli; Paper G reusable formalization

Paper F is now an explicit classification program, detailed in
`FOUR_CHANNEL_CLASSIFICATION_PROGRAM.md`. Classify all admissible refinements of
the canonical chirality-even/odd carrier-square split, modulo gauge, carrier
isomorphism, edge relabeling, and selector-preserving coordinate changes. The
first target is the type-only moduli space: soldering is canonically odd, while
aperture, closure, and turn inhabit one even sector and admit nonunique
refinements. The second target asks which additional structures -- solder
degree, edge exchange, locality, positivity, information monotonicity, and
refinement naturality -- select the displayed four-channel orbit uniquely.

Return either a necessary-and-sufficient selector theorem or a sharp
underdetermination theorem with inequivalent nonzero examples. Do not confuse
the exact four-term expansion of the chosen carrier square with canonicity of
the named decomposition. Positive Hodge and decoder-moduli results belong here
when they act as classification invariants or selectors.

Paper G gets work only when it makes APIs reusable outside this project,
reduces assumptions, promotes draft results, or creates a clean
artifact/tutorial. Neither paper benefits from another disconnected witness.

### P6. General-audience companion

After the research claims freeze, update
`Sources/Null_Edge_General_Audience_Manuscript_2026-07-09.tex` so its bold
ontology matches the strongest audited science. Preserve accessibility. Put
technical boundaries in footnotes, not in the reader's path. Do not spend the
overnight on final PDF polish; compile only for content-breaking layout errors.

## 4. The top-tier referee test

Every active research paper must pass all of these before being called ready:

1. **Headline:** one sentence that matters without mentioning Lean.
2. **Novelty:** direct comparison with the three nearest constructions at the
   level of assumptions and conclusions.
3. **Necessity:** explanation of why the result is not a change of variables,
   fitted parameter, finite enumeration, or dressed telescoping identity.
4. **Scope:** exact finite, asymptotic, reconstruction, consistency, or
   prediction label.
5. **Nondegeneracy:** an explicit nonzero witness and a boundary/negative
   control.
6. **Physical consequence:** a spectral, dynamical, topological, locality,
   interaction, continuum, or falsification consequence.
7. **Reproducibility:** source, theorem anchors, build command, artifact
   manifest, deterministic benchmark, and license/provenance record.
8. **Failure:** a preregistered condition under which the interpretation dies.
9. **Communication:** abstract, introduction, figures, theorem statements, and
   conclusion all tell the same scientific story.
10. **Human responsibility:** authorship, affiliations, ORCIDs, contributor
    roles, and AI-use disclosure are named as pre-submission tasks rather than
    silently invented.

## 5. Manuscript architecture requirements

For Paper A and every newly earned manuscript:

- title names the actual result, not the whole ontology;
- abstract contains problem, construction, theorem, consequence, and boundary;
- introduction reaches the novelty theorem before broad interpretation;
- nearest prior work appears early and is specific;
- notation/conventions are frozen in one visible place;
- each major claim cites an exact formal declaration or an external source;
- theorem statements expose load-bearing hypotheses;
- figures explain mechanisms or data, never decorate;
- negative theorems are integrated into the argument;
- discussion says what a standard model with assigned mass can and cannot mimic;
- conclusion states the scientific wager and next decisive experiment/theorem;
- appendices separate proof detail, formal anchors, and artifact instructions.

Fable owns prose architecture by default. Codex may make narrow claim-correction
edits after recording them in the ledger. Avoid simultaneous edits to the same
manuscript section.

## 6. Aristotle fleet discipline

Each agent keeps approximately 5-7 useful prefixed jobs in its lane, subject to
the service limit and the harvest-first rule:

- Codex uses `codex-pub-...`;
- Fable uses `fable-pub-...`.

Required mix per agent when capacity permits:

- 3-4 proof/composition jobs aimed at P0-P4;
- 1 adversarial audit job;
- 1 strategy or theorem-design job;
- no filler.

Each agent submits one **grand strategy** job at startup and at least every 90
minutes. It receives the complete portfolio, theorem frontier, known no-gos,
target audience, and manuscript claim. Focused strategy jobs should be more
frequent when theorem shape is unclear. Keep 1-2 audit jobs running across the
combined fleet.

Two-hour stall rule: preserve any proof-complete subset, abandon or cancel the
stalled tail where possible, and resubmit a smaller target. Log every action.

Every nontrivial submission includes:

- a semantic context pack from `Scripts/aristotle/make_context_pack.py` unless
  the target is truly standalone;
- exact seed imports and definitions;
- theorem statements that already typecheck;
- nonzero witness and negative control;
- explicit prohibited weakening;
- expected axiom footprint;
- manuscript consequence and kill condition.

## 7. Literature and public Lean references

Run a literature/package pass at least every 30 minutes. Delegate to Spark when
available; if Spark is out of budget, unresponsive, or unavailable, search
directly and continue. Use abstract search to rank papers and full-text chunk
search before relying on an internal claim.

Priority literature lanes:

- strict QCA locality, Floquet aliases, fermion doubling, and minimal internal
  dimensions;
- discrete Dirac/checkerboard walks and all-zone spectral classifications;
- Jackiw-Rebbi/domain-wall/index/localized-mode theorems for discrete walks;
- strong continuum limits for lattice quantum walks and splitting methods;
- CAR second quantization, causal locality, and interacting quantum walks;
- spinor-helicity/Pluecker mass constructions and phase observability;
- formalized physics and proof-assistant artifact standards.

Consult PhysLean before formalizing physics objects. Consult lean-quantum,
SciLean, Kraft, testing-lower-bounds, Plausible, CSLib, LeanCamCombi, and
Sphere-Packing-Lean when relevant. Reference and clean-room port only unless a
separate version/license audit approves a dependency. Log repository,
module/file, version gap, license, and convention mismatch.

## 8. Simulation and artifact standard

Simulation work serves theorem interpretation and reproducibility. It does not
upgrade a conjecture into a theorem.

For each paper, provide where relevant:

- deterministic configuration and seed;
- exact arithmetic fixtures where possible;
- floating-point tolerance and sensitivity report;
- theorem-linked invariants;
- negative controls that fail when signs, ordering, or normalization change;
- machine-readable JSON/CSV output;
- a concise command from a clean checkout;
- a table stating imported, fitted, and held-out quantities.

At least one held-out discriminator should be preregistered before calculation.
If no parameter-free observable exists, say so explicitly.

## 9. Coordination and landing discipline

Before editing or submitting, append a lane claim to `LEDGER.md`. The newest
nonconflicting claim owns the file/rung. Do not overwrite peer work. Cross-audit
completed work rather than duplicating it.

Each landing requires:

1. exact statement unchanged or documented change;
2. semantic and convention review;
3. explicit nonvacuity witness and control;
4. targeted Lean check/build;
5. axiom/placeholder/trust scan and guard pin for flagships;
6. draft-root import edge where required;
7. manuscript claim and matrix update in the same work cycle;
8. provenance and literature note;
9. `git diff --check` and appropriate pre-commit checks.

The four standing over-claim audits are vacuity, hollow telescoping,
docstring-outruns-kernel, and false shape. Also audit convention drift, hidden
fitted inputs, finite-to-continuum slippage, and Hamiltonian/QCA conflation.

## 10. Schedule (PDT)

| Time | Phase | Required output |
| --- | --- | --- |
| 18:00-18:45 | P0 harvest and claims | fleet inventory, snapshots, lane claims, first strategy/audit jobs |
| 18:45-21:30 | Paper A closure | full-Bloch disposition, central chain audit, abstract/intro architecture |
| 21:30-01:00 | Decisive theorem races | C defect/index, B strict QCA, D changing lattice, E CAR/observable |
| 01:00-03:30 | Composition wave | integrate winners, submit focused closers, build artifacts and comparisons |
| 03:30-05:30 | Manuscript wave | Paper A full pass; earned B-E manuscript sections/skeletons; figures/tables |
| 05:30-06:30 | Submission package | claims, references, artifact manifest, referee objections, general companion sync |
| 06:30-07:00 | Landing freeze | harvest only; no broad new jobs; builds, guards, matrices |
| 07:00-08:30 | HARD AUDIT | independent semantic, manuscript, literature, artifact, and venue-readiness review |

Every 30 minutes: literature/package pass. Every 90 minutes: grand strategy per
agent. Every work cycle: harvest, review, integrate, verify, refill, ledger.

## 11. Division of labor

### Codex default lane

- proof harvest, integration, and theorem composition;
- Paper A full-Bloch and exact-scope closure;
- Papers B and D technical theorem races;
- Lean guards, assumptions, artifacts, and claim matrix;
- proof-linked simulations and reproducibility commands;
- independent audit of Fable's prose and literature claims.

### Fable default lane

- Paper A argument, title, abstract, introduction, discussion, and conclusion;
- nearest-work synthesis and exact novelty table;
- Papers C and E theorem design and physical consequence framing;
- referee-objection register, figures/tables, and venue-specific positioning;
- general-audience synchronization after claim freeze;
- independent audit of Codex landings and manuscript anchors.

### Shared

- P0 harvest and Aristotle fleet;
- Paper C defect/index and Paper E operational observable when either is close;
- submission-readiness verdicts;
- dawn scorecard and morning report.

## 12. Dawn hard audit

At 06:30 freeze broad construction. At 07:00 both agents become adversarial
referees.

Lean/artifact audit:

- rebuild every new module and flagship guard;
- inspect source and assumptions of every headline theorem;
- scan placeholders and expanded trust;
- verify witnesses, controls, import edges, and convention locks;
- rerun deterministic simulations and failure controls;
- record any known unrelated full-build blocker exactly.

Manuscript audit:

- verify every theorem name and source independently;
- test every abstract sentence against the claim matrix;
- remove claims that depend on a silently fitted mass, phase, scale, or beta
  function;
- distinguish strict QCA locality from local Hamiltonian evolution;
- distinguish fixed-momentum, finite Fourier, compact-support, and
  changing-lattice limits;
- verify related-work comparisons from the actual sources;
- ask the hostile-referee questions in `REFEREE_OBJECTION_REGISTER.md`;
- compile manuscripts only enough to catch content-breaking TeX failures.

Publication audit:

- assign each paper `READY`, `NEAR-READY`, `THEOREM-GATED`, `MERGE`, or `DEFER`;
- name the strongest venue justified by the completed result, not aspiration;
- produce a prioritized one-week follow-up list;
- make the morning report lead with the most important scientific result.

## 13. Success criteria

Minimum strong night:

1. Paper A has a complete, coherent, audited manuscript and artifact plan.
2. One P1-P4 decisive theorem gate lands or dies by an exact no-go.
3. Every headline claim has a theorem/source anchor and boundary.
4. The nearest-work comparison survives a hostile novelty audit.
5. All available high-value Aristotle outputs are harvested or dispositioned.

Excellent night:

- Paper A earns its prestige upgrade gate through B or C;
- two additional paper gates close;
- a parameter-independent operational or topological consequence lands;
- the changing-lattice PDE theorem or local CAR automorphism closes;
- a reproducible release artifact runs from one documented command.

Extraordinary night:

- a complete protected-defect theorem, alias-controlled strict `3+1` QCA, or
  strong changing-lattice Dirac limit lands and becomes the new field-level
  headline;
- the result is independently adversarially audited, manuscript-integrated,
  and packaged before dawn.

## 14. The rule that matters most

Do not settle for a catalog of ingenious finite lemmas. Build papers around
results that change what a researcher can construct, prove, calculate, or rule
out. Be bold about the theory's organizing claim and merciless about the
evidence. Every open arrow becomes a named theorem race, every failure becomes
a sharp no-go, and every successful theorem must visibly answer "so what?"
