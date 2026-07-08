# Dynamics groundwork: what to borrow from PhysLean, and the roadmap

**Goal (user, 2026-07-08):** develop the program's *dynamics* as much as
possible and lay groundwork for **rigorous dynamics simulations**. This doc
records what to borrow (clean-room) from PhysLean and the concrete roadmap.

## Where the dynamics stands now (thin)

The program's kernel-checked dynamics is currently:

- the **static** carrier operator `D` and its Krein square `4 D^#D = Q_A+Q_C+
  4Q_T+E_#` (a mass *budget*, not an evolution);
- **one** Schur-complement / decimation step (§9, `RGSchurMassWitness`) - a
  single discrete RG blocking, not a flow;
- the mass **functional** `min spec(D^#D|P)` (a Rayleigh quotient - variational
  in spirit, but not derived from an action).

**The gap:** there is no action principle, no equation of motion, no
conservation law, no time evolution, and no ensemble / thermodynamic structure.
Everything is posited, not *derived* and not *evolved*. That is exactly what a
dynamics + simulation program needs.

## What to borrow from PhysLean (clean-room; version-pinned, so consult + port)

PhysLean has formalized precisely the machinery we lack (see `docs/PHYSLEAN.md`
for access; we cannot `import`, so port the API design and cross-check
conventions).

- **Tier 1 - the variational / action framework (the biggest lever).**
  - `Physlib/Mathematics/VariationalCalculus/` - `HasVarGradient`,
    `HasVarAdjDeriv`, `HasVarAdjoint`, `IsTestFunction`,
    `fundamental_theorem_of_variational_calculus`, `AdmissibleVariation`.
  - `Physlib/ClassicalMechanics/` - `EulerLagrange.lean`,
    `HamiltonsEquations.lean`, `def lagrangian`, `def hamiltonian`,
    `def gradLagrangian`, `def toCanonicalMomentum`, `def energy`, and
    conservation theorems (`kineticEnergy_conserved`, `linearMomentum_conserved`).
  - `Physlib/ClassicalFieldTheory/Local/Variation.lean` - field-theory action
    variation.
  - **Use:** turn "the carrier `D` and the mass functional we posited" into
    "the Euler-Lagrange equation of a carrier **action** `S`." In the finite
    setting the variation is an ordinary gradient (kernel-eatable, no
    distributions), so this is directly formalizable. Payoff: evolution,
    conservation laws (Noether), and the mass functional as the on-shell
    action/energy all become *consequences of one action* - and it feeds carrier
    rigidity (T7: "the carrier is the unique EOM of a natural finite action").
- **Tier 2 - the canonical ensemble / thermodynamic limit.**
  - `Physlib/StatisticalMechanics/CanonicalEnsemble/{Basic,Finite,TwoState}.lean`
    - `partitionFunction`, `partitionZ`, `helmholtzFreeEnergy`,
    `thermodynamicEntropy`, and the free-energy identity.
  - **Use:** the §9 condensate kill said near-zero-mode accumulation needs a
    *thermodynamic limit or structured background*. A finite canonical ensemble
    over the carrier spectrum (partition function, free energy, entropy) makes
    the `N_m` / condensate question a well-posed statistical-mechanics
    computation instead of an open hope.
- **Tier 3 - worked dynamical systems as Lean templates.** ClassicalMechanics
  has fully-worked harmonic oscillator, wave equation, damped oscillator, free
  particle (action -> EOM -> solution -> conserved quantities). These are the
  patterns to mirror for the carrier's own solvable dynamics.

## The dynamics roadmap (D1-D5)

Ordered so each step is simulatable and kernel-anchored.

- **D1 - Finite carrier action + EOM (Tier-1 borrow).** Define a finite action
  `S[psi]` on the complex whose Euler-Lagrange equation is the carrier equation
  `D psi = 0` (or `D^#D psi = m^2 psi`). Kernel target: state `S`, its finite
  variation `gradS`, and prove `gradS psi = 0 <-> D psi = 0`. Gives the program
  its first *derived* (not posited) dynamics. Connects to T7 rigidity.
- **D2 - Conserved quantities.** From `S` and its symmetries, define energy and
  the "disagreement charge"; prove conservation under the D1 evolution. These
  are the **validation invariants** for simulations.
- **D3 - Discrete time evolution / transfer operator.** The natural stepper is
  the carrier's transfer operator (the Feynman-checkerboard / quantum-walk
  route, F8/T6; Foster-Jacobson). A simulation = iterating it. Kernel-adjacent:
  unitarity/Krein-isometry of the step; the continuum limit is the F8 import.
- **D4 - RG flow.** Iterate the §9 Schur decimation into a *flow* (many
  blocking steps), tracking how the mass budget and `N_m` move - the
  coarse-graining dynamics, directly simulatable.
- **D5 - Canonical ensemble / thermodynamic limit (Tier-2 borrow).** Partition
  function over the carrier spectrum; study `N_m` accumulation and the
  condensate in the large-complex limit.

## Simulation harness (the concrete groundwork)

"Rigorous dynamics simulation" here = a numerical carrier simulator whose every
output is **validated against the kernel-checked M-theorems** (budget sums to 1;
`det P` = pairwise mass; balanced closure; positivity on the sector). PhysLean
gives the *theory* (what to simulate: action, EOM, conserved quantities,
ensemble) and the invariants; the engine is ours (numpy oracle, the pattern of
`Scripts/oracle/probe_multiedge_positive_sector.py` etc.).

**First artifact (this run):** `Scripts/oracle/carrier_dynamics_harness.py` - a
parametrized carrier builder + observable computer + one discrete evolution and
one RG-decimation step, each validated against a landed M-identity. It is the
seed the D1-D5 roadmap plugs into.

## First concrete steps (ranked)

1. Build the validated simulation harness (D3/D4 numeric seed) - this run.
2. D1 finite carrier action + EOM - clean-room from PhysLean's
   `VariationalCalculus`/`EulerLagrange`; an Aristotle-ripe Lean target once the
   finite action is stated.
3. D2 conserved quantities; D5 canonical ensemble (Tier-2 borrow) for the
   condensate question.
