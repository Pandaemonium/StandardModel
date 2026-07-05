# Aristotle grand-strategy job: whole-project big-picture audit (2026-07-05)

You are acting as a RESEARCH STRATEGIST and ADVERSARIAL AUDITOR for an entire
Lean 4 formalization project, not as a Lean prover. Do NOT attempt a Lean build
and do NOT try to prove anything. Return a written report.

Formatting: ASCII only, LF line endings. In prose, write Lean escape-hatch
tokens in spaced form (`s o r r y`, `a x i o m`, `n a t i v e _ d e c i d e`),
never raw.

## Your task

Give BIG-PICTURE strategic guidance on the whole project: its coherence,
soundness, priorities, risks, blind spots, and the highest-value directions.
This is a mid-run "grand-strategy" review requested by the project lead. Be
candid and adversarial - the point is to find what the project is getting wrong
or not seeing, not to cheerlead.

## BROWSE THE REPOSITORY - do not trust this prompt's summary

You have the full repository in your project directory. READ IT. Do not rely on
my prose below; verify every claim against the actual files, and where the Lean
source and the prose disagree, trust the Lean and call out the gap. Suggested
reading order:

- `AGENTS.md` (root) - the always-on rules, conventions, and program philosophy.
- `README.md`, `docs/NULLSTRAND.md`, `docs/NERD_ROADMAP.md`,
  `docs/CONVENTIONS.md` - program-level guidance.
- `Sources/*.md` - the informal program docs, proof plans, and literature
  syntheses that motivate the formalizations (e.g. the Baez octonion/SM primer
  and proof plan, the null-strand Bohm-Bell theory, the null-edge unification
  synthesis, the CodeLattice E8 theorem maps, the exceptional-Jordan lit search).
- `Index/` - generated index documents (if present).
- `PhysicsSM/` - the actual Lean 4 code. This is the source of truth. The layers
  are `Algebra/` (octonions, division algebras, Furey complex-octonion SM
  states), `Clifford/`, `Spinor/`, `Lie/` (E8, exceptional), `Gauge/`,
  `StandardModel/`, `Supersymmetry/`, and `Draft/` (experimental, may contain
  `s o r r y`). Under `Draft/NullEdge/` are the null-edge program, the Yang-Mills
  mass-gap ladder (`GateYM/`), the finite-kinematics gate (`GateI1/`), and a new
  QCD-mass-formalism substrate (`QMF/`).
- `AgentTasks/` - task notes, Aristotle prompts/outputs, and (under
  `fourday-ym-run-2026-07-05/`) the live four-day Yang-Mills run: `RUN_PLAN.md`,
  `LEDGER.md` (task board), `DISCUSSION.md` (design threads), daily reports.

Sample widely across `PhysicsSM/` rather than reading one subtree. Check the
module docstrings - they state what is trusted vs draft, what conventions are
used, and what is claimed vs open.

## The programs you are assessing (orient, then verify)

The project's stated ambition: formalize the mathematical structures behind
Standard Model physics, kernel-checked, with exact provenance and documented
conventions. It contains several partly-connected programs:

1. Division algebras -> SM structure: complex octonions, Furey-style minimal
   left ideals of the associative left-multiplication algebra, `SU(3)` color +
   electroweak charges, one generation, anomaly bookkeeping.
2. E8 / exceptional Lie theory: root systems, E8, a Code-Lattice-E8 / theta
   track, exceptional Jordan algebra.
3. Spinors / Clifford: `Cl(6)`, CAR relations, pure spinors, a Spin(10)
   stabilizer / Selector-Theorem program.
4. The NullStrand / null-edge program: a finite null-edge Dirac algebra, "mass
   as a Pluecker / wedge obstruction," a super-Dirac square, Krein
   self-adjointness (see `docs/NULLSTRAND.md`).
5. The Yang-Mills mass-gap ladder: a rung-by-rung finite lattice-gauge-theory
   formalization (reflection positivity, transfer operator, Kotecky-Preiss
   cluster expansion, a Theorem-2 area-law track), Clay problem as a
   NON-claimed, non-scheduled summit. Items Q1-Q12; three "mountains" M1-M3.
6. A QCD-mass-formalism (QMF) ladder: a compact-group reflection-positivity /
   Haar substrate reaching `SU(N)`, toward a finite sector-spectral "mass"
   definition; continuum permanently parked.
7. An octonion / null-edge "unification thesis": whether ALL mass can be
   described via null edges, and whether the octonion (gauge/charge) structure
   and the null-edge (mass) geometry genuinely couple or merely co-locate. A
   prior red-team audit concluded "co-location, not coupling" for the current
   bridges; see `AgentTasks/octonion-nulledge-unification-thesis.md` and the
   `...-REDTEAM-audit.md`.

Program disciplines to audit against (from `AGENTS.md`): the Lean kernel is the
source of truth; no statement weakening; strict draft-vs-trusted separation with
axiom audits; octonion non-associativity handled explicitly (a project-specific
XOR basis, NOT Baez/Furey verbatim); physics conventions documented (metric
signature, chirality, hypercharge normalization, etc.); a hard rule against
conflating spectral mass gap vs Wilson-loop area law vs entanglement area law;
lattice results never presented as the continuum prize; person-name attributions
held back until sources are verified.

## Deliverables (the report)

1. CORE THESIS. Is there a single coherent research vision, or several loosely
   related programs sharing a repo? State, in your own words, what you think the
   project's central claim/bet actually is, and whether it is a genuine research
   program or drifts into numerology. Where is the line?

2. PROGRAM-BY-PROGRAM TRIAGE. For each of the 7 programs above (and anything
   else you find), classify the current state as SOLID (kernel-checked, sound,
   well-scoped), PROMISING (tractable, partially done), SPECULATIVE (unclear
   statements or conventions), or AT-RISK (likely false, unformalizable, or
   convention-fragile). Cite specific files/theorems. Flag any over-claims where
   a docstring or task note says more than the Lean actually proves.

3. HIGHEST-VALUE DIRECTIONS. Where should effort concentrate to maximize genuine
   verified progress toward the stated goal? Rank the top 5 concrete
   opportunities. For each, name the single highest-value next theorem (a real
   Lean target, as specific as you can make it) and why it matters.

4. RISKS AND NO-GO ANALYSIS. What could waste months or embarrass the project?
   Identify likely-false claims, convention-fragile results, hidden analytic
   assumptions, group-vs-Lie-algebra-vs-representation confusions, associativity
   assumptions for octonions, or Standard-Model normalization ambiguities.
   Which stated summits (Clay YM, "SM from octonions," "all mass from null
   edges") are genuine long-horizon targets vs mirages, and what is the honest
   nearest defensible claim for each?

5. BLIND SPOTS. What is the project NOT seeing? Missing connections between
   programs, redundant effort, a cleaner formulation, an available Mathlib tool
   it is not using, or a structural weakness in how it is organized.

6. CONCRETE RECOMMENDATIONS. A prioritized action list: what to do next, what to
   stop doing, what to restructure. Include a suggested 3-6 month arc that a
   two-agent-plus-Aristotle team could realistically execute, with checkpoints.

7. DECISIVE QUESTIONS. The 3-5 questions whose answers would most change the
   project's strategy - the things the lead should resolve before investing
   further.

Be specific and cite files. A blunt, well-evidenced critique is far more
valuable than diplomatic hedging. If a whole program looks like a dead end, say
so and say why. If the core bet is sound, say what would make it fail.
