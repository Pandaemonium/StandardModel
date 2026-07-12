# Science roadmap and portfolio architecture

## Portfolio principle

AFPL is hypothesis-driven but not hypothesis-captive. The null-edge program is
the flagship; conventional baselines and competing reconstructions are funded
as controls. The portfolio is reviewed quarterly and limited to six active
scientific programs plus one lab-infrastructure program.

Recommended allocation:

- 40% flagship closure and reconstruction;
- 20% independent controls and replication;
- 15% high-risk synthesis/moonshots;
- 15% simulation, phenomenology, and empirical interfaces;
- 10% formal infrastructure and metascience.

## Program P1: finite foundations and dynamics

Question: What is the minimal finite ontology, state space, and law?

Core gates:

- nondegenerate null-edge kinematics and Pluecker mass dictionary;
- exact local unitary dynamics and causal support;
- action, modular, maximum-entropy, or growth-law selection;
- physical-state/positivity and constraint reduction;
- many-body CAR/Fock composition;
- equivalence/moduli classification of carriers and decoders.

Exit: a compact axiom/API package with no prose-only physical identifications.

## Program P2: continuum, Lorentz, and QFT reconstruction

Question: Do finite regulators converge to relativistic local QFT?

Core gates:

- changing-lattice interpolation and strong convergence;
- high-frequency artifact control and no-doubling/resource theorems;
- Lorentz symmetry in the continuum or in distribution;
- local observable nets, correlation functions, and microcausality;
- interacting continuum observables and RG universality;
- comparison with standard lattice/QCA/AQFT constructions.

Kill: persistent failure of the commuting square or unavoidable wrong low-energy
degrees of freedom demotes the ontology to a finite model.

## Program P3: chiral gauge matter and Standard Model structure

Question: Can the theory force the observed matter and gauge architecture?

Core gates:

- gauge-covariant overlap/sign operator and stable index;
- anomaly interface and cancellation on derived representations;
- electroweak and color actions from intrinsic structures;
- fermion generations, flavor, neutrinos, and CP phases;
- Higgs or alternative scalar/longitudinal dynamics;
- global gauge quotient and charge normalization;
- QCD/confinement interface.

Kill: supplied representation tables or arbitrary weak actions remain
consistency constructions, not derivations.

## Program P4: geometry, gravity, and quantum spacetime

Question: Can causal order, counting, and soldering recover dynamical GR while
remaining quantum consistent?

Core gates:

- fixed-support Lorentz no-go and random-order distributional invariance;
- conformal-versus-scale reconstruction;
- matter-coupled soldering and conservation laws;
- universal finite first-law/Clausius theorem;
- continuum Einstein or alternative gravity limit;
- horizons, entropy, and black-hole benchmarks;
- positive physical sector and stability.

Kill: finite gradient identities without continuum geometry are warm-ups, not
gravity.

## Program P5: scales, parameters, and cosmology

Question: What fixes dimensionful scales and cosmological observables?

Core gates:

- dimensional transmutation and a regulator-independent scale dictionary;
- mass hierarchy and mixing parameter ledger;
- count/Lambda conjugacy, sign, variance, and stochastic dynamics;
- cosmological evolution and observational constraints;
- dark matter, dark energy, inflation, and baryogenesis implications;
- held-out predictions and uncertainty propagation.

Kill: fitted reference scales or hidden dimensional inputs cannot be described
as predictions.

## Program P6: synthesis and discriminating predictions

Question: What does the framework explain or predict that standard
descriptions do not?

Core gates:

- explicit intertwiners between allegedly unified sectors;
- assumption and parameter compression;
- derivation graph from primitives to observables;
- simulations tied to proved invariants;
- benchmark suite against known physics;
- distinctive predictions, exclusions, and feasible tests;
- external hostile review.

Kill: shared polynomial forms, matching dimensions, or common vocabulary do
not establish unification.

## Program P0: lab reliability and formal infrastructure

Question: Is AFPL improving its own reliability faster than its complexity?

Core gates:

- persistent state validation and deterministic artifacts;
- calibrated forecasts and blocker tracking;
- cross-model semantic audits;
- literature/source provenance and knowledge-graph health;
- procedure experiments with preregistered metrics;
- incident disclosure and recovery;
- clean public archives and independent reproduction.

## Dependency spine

```text
P1 finite foundations
  -> P2 continuum/QFT
     -> P3 chiral gauge matter
     -> P4 matter-coupled geometry
        -> P5 scales/cosmology
           -> P6 integrated predictions

P0 reliability constrains every arrow.
```

Work may proceed in parallel, but a downstream result cannot erase an unmet
upstream gate. Every project states which arrows it assumes and which it proves.
