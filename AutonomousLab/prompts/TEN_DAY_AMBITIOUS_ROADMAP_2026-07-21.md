# Ten-day ambitious autonomous roadmap (2026-07-21 -> 2026-07-31)

Mission entry point for the unattended multi-agent run while the Director is away.
Executors: **Opus/Claude** and **Sol** (co-equal), with **Aristotle** as the prover.
This file is the durable spec; the daily ledger records progress against it.

## The bar

Outstanding science means a small number of genuine, kernel-checked, publication-grade
results that resolve recognized gaps, plus honest no-gos - **not volume**. The test for
every result: *would an outside expert find this novel, and is the statement exactly the
intended mathematics?* A hollow theorem, an over-claimed docstring, or an unwitnessed
conditional is a failure even if it compiles. A kernel refutation of a target is a
first-class success.

## Director's calibration (binding)

- **Risk posture: BALANCED.** Run the four flagships AND the reliable backbone in parallel.
  Guarantee a floor of landed results even if the swings miss.
- **Git authority: AUTO-COMMIT, NO PUSH.** Commit landed+audited results to the dated branch
  `auto/ten-day-run-2026-07-21` (create from `main`). Never push. Never touch `main`
  directly. Commit messages end with the Co-Authored-By line per repo policy.
- **Aristotle budget: Aim for ~8-10 jobs running at all times. Focus on impactful,
  important results, audit jobs, and strategy jobs.
- **Front-line lanes:** origin of mass + Lambda; Standard Model (S2b); 3+1 walk + GR.
  Foundational math (E8, Spin(10), YM) runs on the backbone.

## Division of labor

- **Opus/Claude:** origin of mass (A2-A6, manuscript P1), the Lambda no-go (Flagship A),
  SM chirality/electroweak audit, and the **continuous adversarial-audit lane** over every
  flagship (own and Sol's).
- **Sol:** the 3+1 continuum closure and the alias-free regulator, the GR interior-Einstein
  witness (Flagship D), and the foundational-math backbone.
- **Shared:** S2b (Flagship C) - co-designed, ladder algebra from either side.
- **Cross-family audit is mandatory:** each executor's flagship must survive an independent
  refutation attempt by the *other* executor (and, where cheap, an Aristotle adversarial
  job) before it is called landed. Same-model self-review is not sufficient.

---

## The four moonshot flagships

Each has a pre-registered GATE (what would confirm it) and KILL-CONDITION (when to stop and
document). No churning: if a proof route stalls past its kill-condition, land the partial,
write the obstruction, and move on.

### Flagship A - The Lorentz-invariant Lambda no-go [Opus] (crown jewel)

**Target.** A kernel-checked theorem that a Poincare-invariant, finite-variance correlation
structure is forced to white noise (Poisson), because boost orbits carry infinite invariant
measure - the non-compact continuum analogue of the landed finite stabilizer-orbit result
(`StabilizerOrbitCorrelationDecay`, `HyperuniformityRankDichotomy`).
**Why it matters.** A real contribution to the everpresent-Lambda / causal-set question,
independent of the program's ontology, with an identifiable audience. Highest-value swing.
**Gate.** A finite-dimensional-but-non-compact model (or a discretized boost orbit) where the
infinite-measure -> vanishing-correlation implication is provable, with a genuine
non-compact witness that separates it from the compact case.
**Kill-condition.** If non-compactness cannot be captured without trivializing the statement,
document the exact obstruction and bank the compact-group result as the honest ceiling.
**Discipline.** Run the causal-set + hyperuniformity literature BEFORE writing any physical
gloss. The last gloss here was withdrawn; do not repeat it.

### Flagship B - Origin of mass, closed and written [Opus]

**Target.** (1) P1 manuscript release-ready, built around kinematic completeness (landed) +
the three-mass-notions synthesis + the A4 dichotomy + the Yukawa moduli no-go. (2) Push A3
past the three-state abelian toy to a genuine non-abelian composite model. (3) Attack A6
(inertial = gravitational) - which needs two *independently motivated* derivations to meet,
not a hypothesis-free identity.
**Gate.** A3: a real gauge group with >3 states discharging all four obligations. A6: an
inertial-response `M` and a gravitational-source `M` from separate constructions, proven
equal under a stated model.
**Kill-condition.** A6 may be genuinely open; if the two derivations cannot be made to meet,
keep it OPEN and write P1 around what is landed. Do not manufacture an identity.

### Flagship C - Electroweak S2b: W+- and T3 from the ladder [shared]

**Target.** Derive `W+-` and the `T3` eigenvalues from the `C(x)H` quaternionic ladder
operators, closing the precise electroweak gap; close via the `WeakIsospinLadderDerived`
uniqueness handle (`[T3,T]=T`, `[Y,T]=0`, correct action forces `T = TPlusEnd`).
**Gate.** The `C(x)H` spin/chirality sector + `B_j = i e_7 | beta_j` ladders giving `T_j`
eigenvalues matching the target table, closed by uniqueness.
**Kill-condition.** If the ladder-origin genuinely needs structure beyond what is buildable,
land the partial (the `C(x)H` sector + the uniqueness handle) and document the exact missing
step. Do not relabel supplied tables as derived.

### Flagship D - GR interior-Einstein, witnessed [Sol]

**Target.** Discharge the five `FinitePalatiniBoundaryFlux` structural predicates with the
concrete `3^4` vacuum-Weyl-jet carrier (`NonlinearLorentzPalatiniConcreteVacuumWeylJet`),
turning the conditional interior-Einstein theorem into a witnessed one and removing the
vacuity caveat. Separately: test `PeriodicVacuumWeylAnalyticNoBranch` against an averaged
(Regge-style) stationarity condition before headlining it.
**Gate.** The carrier satisfies all five predicates, instantiated as a Lean witness.
**Kill-condition.** If the carrier does not satisfy them, that is informative - the
predicates are stronger than the carrier supports; document precisely and keep the theorem
conditional.

## Reliable backbone (steady landable value regardless of the swings)

- MC continuum-ladder closure (Sol's lane; discharge the three independent preconditions,
  wire MC2 -> MC4, decide the `2 pi` convention once).
- Full E8 root-system formalization (currently only a determinant theorem - graded partial).
- Spin(10) Selector closure (the marked-transitivity + Fierz holes).
- YM Kotecky-Preiss crux toward the finite area law.
- Neutrino A5 completions (with the symmetry-of-the-inverse Majorana caveat).
- Keep every landed flagship's docstring audited (the standing anti-over-claim lane).

## Operating protocol (what makes 10 days unattended safe and productive)

1. **Adversarial audit before "landed."** No result enters the "done" ledger until it has
   survived a hostile refutation attempt (cross-executor, plus an Aristotle adversarial job
   where cheap). Every flagship carries a build-enforced `#print axioms` guard.
2. **Green-tree invariant.** Never leave the root build red overnight. On a red tree: if it
   is your file, fix it; if it is the peer's leased file, flag precisely and route around it;
   watch for build-vs-write races (add root imports LAST, never run the formatter alongside
   the build).
3. **Aristotle saturation, budget-paced.** Keep the prover loaded on the hardest targets;
   loop-until-dry on discovery. Log cumulative USD spend daily; throttle at 80% of the cap.
4. **Kill-conditions enforced.** When a route stalls past its gate, stop, land the partial,
   write the obstruction. No grinding.
5. **Director queue.** Anything irreversible or outward-facing - a push, a submission, an
   external post, a claim that would go in an abstract, deleting a peer's work, spending
   beyond the cap - queues in `state/DIRECTOR_QUEUE.md` for the Director's return. The agents
   do not decide these unilaterally.
6. **Daily ledger.** A dated entry each cycle in the lab ledger: what landed (with grades),
   what was refuted, what was corrected, Aristotle spend to date, and the honest open list.
   Keep `SCIENTIFIC_RESULTS_OVERVIEW.md` current as the living record.
7. **Claim discipline (the day's hard-won lesson).** Grade every result (T/M/M-conditional/
   C/Open); distinguish mechanism from derivation and representation from explanation; run
   the domain literature before writing any physical gloss; check that every "headline" has
   load-bearing hypotheses (a hypothesis-free identity is not evidence); when weakening a
   claim, grep the whole artifact for the strong form.

## What the Director returns to (success criteria)

A dated branch of kernel-checked, axiom-guarded, cross-audited commits; ideally 2-4 flagship
results landed or honestly killed with documented obstructions; a release-ready P1 manuscript
and progress on Area-to-Dirac-Gap; a current results overview; a daily ledger telling the
whole story including the no-gos and corrections; Aristotle spend under USD 500; the tree
green; and a Director queue of the few decisions that were genuinely theirs to make. The
measure is not lines of Lean - it is how much of the honest frontier moved.
