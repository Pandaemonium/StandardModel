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
  **Seed implemented:** `PhysicsSM/Draft/NullEdge/Carrier/FiniteCarrierAction.lean`
  defines the finite multiplier action `S_D(psi, chi) = Re <D psi, chi>` and
  proves stationarity iff `D psi = 0` and `D† chi = 0`. This is the direct
  EOM scaffold, not yet a Hamiltonian flow or uniqueness theorem for the
  interacting carrier.
- **D2 - Conserved quantities.** From `S` and its symmetries, define energy and
  the "disagreement charge"; prove conservation under the D1 evolution. These
  are the **validation invariants** for simulations.
  **Finite seed implemented:** `PhysicsSM/Draft/NullEdge/Carrier/FiniteUnitaryEvolution.lean`
  proves that an isometric finite step conserves norm, inner products, and any
  commuting self-adjoint energy observable along the discrete orbit. This is the
  finite validation-invariant layer, not yet a Noether theorem from the carrier
  action.
- **D3 - Discrete time evolution / transfer operator.** The natural stepper is
  the carrier's transfer operator (the Feynman-checkerboard / quantum-walk
  route, F8/T6; Foster-Jacobson). A simulation = iterating it. Kernel-adjacent:
  unitarity/Krein-isometry of the step; the continuum limit is the F8 import.
  **Finite seed implemented:** `FiniteUnitaryEvolution.lean` defines a generic
  finite orbit and proves conservation along all iterates under isometry /
  commutation hypotheses. The actual carrier checkerboard/transfer operator is
  still a specialization target.
- **D4 - RG flow.** Iterate the §9 Schur decimation into a *flow* (many
  blocking steps), tracking how the mass budget and `N_m` move - the
  coarse-graining dynamics, directly simulatable.
  **Finite seed implemented:** `PhysicsSM/Draft/NullEdge/Carrier/FiniteRGFlow.lean`
  proves generic invariant and monotone-observable facts for finite iterated
  maps, giving the proof scaffold for turning Schur decimation from one step
  into a controlled flow.
- **D5 - Canonical ensemble / thermodynamic limit (Tier-2 borrow).** Partition
  function over the carrier spectrum; study `N_m` accumulation and the
  condensate in the large-complex limit.
  **Finite seed implemented:** `PhysicsSM/Draft/NullEdge/Carrier/FiniteCanonicalEnsemble.lean`
  defines a finite partition function, Boltzmann probabilities, expected energy,
  free energy, and entropy, and proves `Z > 0`, `p_i > 0`, and
  `sum_i p_i = 1` for nonempty finite state spaces. This does not prove the
  thermodynamic limit or any condensate statement.

## Simulation harness (the concrete groundwork)

"Rigorous dynamics simulation" here = a numerical carrier simulator whose every
output is **validated against the kernel-checked M-theorems** (budget sums to 1;
`det P` = pairwise mass; balanced closure; positivity on the sector). PhysLean
gives the *theory* (what to simulate: action, EOM, conserved quantities,
ensemble) and the invariants; the engine is ours (numpy oracle, the pattern of
`Scripts/oracle/probe_multiedge_positive_sector.py` etc.).

**First artifact (this run):** `Scripts/oracle/carrier_dynamics_harness.py` - a
parametrized carrier builder + observable computer with five validated blocks:
kinematics, budget, unitary evolution, an RG-decimation flow seed, and a finite
canonical ensemble over the sector spectrum. Each block is checked against a
landed or draft kernel identity. It is the simulation seed the D1-D5 roadmap
plugs into.

## Implemented seeds (2026-07-08)

- **D1 finite action/EOM:** `FiniteCarrierAction.lean`
  - `carrierAction D psi chi := Re <D psi, chi>`.
  - `multiplierStationary_iff_eom`: stationarity in all multiplier variations is
    exactly `D psi = 0`.
  - `fieldStationary_iff_adjoint_eom`: stationarity in all carrier-field
    variations is exactly `D† chi = 0`.
  - `stationaryPair_iff_eom_pair`: a stationary pair is a primal/adjoint EOM
    pair.
- **D5 finite ensemble normalization:** `FiniteCanonicalEnsemble.lean`
  - `partitionFunction`, `probability`, `expectedEnergy`,
    `helmholtzFreeEnergy`, `thermodynamicEntropy`.
  - `partitionFunction_pos`, `probability_pos`, `sum_probability_eq_one`.
- **D2/D3 finite conservation and transfer scaffolding:**
  `FiniteUnitaryEvolution.lean`
  - finite orbit iteration;
  - one-step norm, inner-product, and energy conservation;
  - all-time norm and energy conservation along the orbit.
- **D4 finite RG-flow scaffolding:** `FiniteRGFlow.lean`
  - finite orbit iteration for arbitrary step maps;
  - invariant preservation along the orbit;
  - monotone-observable preservation along the orbit.
- **Harness:** `Scripts/oracle/carrier_dynamics_harness.py`
  - all five blocks PASS on the current two-edge carrier seed.

## First concrete steps (ranked)

The finite D1-D5 skeleton now exists. The next work should specialize and
strengthen it rather than add another abstract layer.

1. Strengthen D1 from multiplier-action scaffold to a natural quadratic or
   first-order carrier action for the actual interacting `D`, with hypotheses
   stating exactly when the Euler equation is `D psi = 0`, `D†D psi = 0`, or a
   mass-shell equation.
2. Specialize D2 to carrier observables: prove the concrete mass/energy and
   disagreement charges commute with the chosen carrier stepper.
3. Specialize D3 to the checkerboard / quantum-walk transfer operator used by
   the harness and connect it to the F8 continuum import.
4. Specialize D4 from generic finite maps to the Schur-decimation theorem and
   track mass-budget evolution over many blocking steps.
5. Strengthen D5: build on the finite canonical ensemble to state the
   large-complex limit needed for the near-zero-mode/condensate question.
