# Luminal-motion checkerboard program: publication advance

**Status:** Codex evaluation and concrete advance, 2026-06-11.
**Related draft:** `Sources/Luminal_Motion_Checkerboard_Research_Program.md`.
**Lean advance:** `PhysicsSM/Spinor/Checkerboard.lean`.

## Bottom line

The program has a real publication path, but the publishable core should be
narrowed:

1. **Do not lead with ontology.** "All motion is luminal" is a useful slogan,
   but the theorem-level content is about exact propagator expansions and
   finite path sums.
2. **The near-term publishable result is formal verification.** A Lean-checked
   finite Feynman-checkerboard development would be novel enough to be useful
   even though the analytic continuum limit is known in the literature.
3. **The 3+1D structure theorem is plausible but mostly synthesis.** Foster and
   Jacobson already have a four-dimensional checkerboard with spin projectors
   and mass/chirality flip amplitude. A paper should frame any 3+1D result as
   a cleaned-up theorem package, not as discovery from scratch.
4. **The causal-set Dirac propagator is the high-risk flagship.** Johnston's
   scalar hop-stop result is source-supported; the spinor version remains the
   best genuinely open target, but it needs numerical falsification before a
   proof campaign.

## Source checks completed

- Skopenkov--Ustinov, "Feynman checkers: towards algorithmic quantum theory",
  arXiv:2007.12879; Russian Math. Surveys 77:3 (2022), 73-160.  The arXiv
  abstract says they solve Feynman's 1965 problem and develop the rigorous
  asymptotics of the one-dimensional model.
- Foster--Jacobson, "Spin on a 4D Feynman Checkerboard", arXiv:1610.01142;
  Int. J. Theor. Phys. 56 (2017), 129-144.  The abstract confirms the
  projector path integral, no fermion doubling in their scheme, and the
  `i epsilon m` chirality-flip amplitude.
- Johnston, "Particle propagators on discrete spacetime", arXiv:0806.3083;
  Class. Quantum Grav. 25 (2008), 202001.  The abstract confirms the matrix
  geometric-series path sum and matching, in a suitable sense, to the causal
  retarded Klein-Gordon propagator for sprinklings in 1+1 and 3+1 Minkowski
  space.
- Gaveau--Jacobson--Kac--Schulman, "Relativistic Extension of the Analogy
  between Quantum Mechanics and Brownian Motion", Phys. Rev. Lett. 53 (1984),
  419-422.  This is the telegraph/Poisson analytic-continuation source.
- Bialynicki-Birula, "Dirac and Weyl Equations on a Lattice as Quantum
  Cellular Automata", arXiv:hep-th/9304070; Phys. Rev. D 49 (1994), 6920-6927.
  The abstract confirms local unitary lattice dynamics, continuum Weyl limit,
  and a sum-over-histories connection.
- D'Ariano--Perinotti, "Derivation of the Dirac Equation from Principles of
  Information Processing", arXiv:1306.1934; Phys. Rev. A 90 (2014), 062106.
  The abstract confirms emergence of the 3+1 Dirac equation from locality,
  homogeneity, unitarity, and isotropy assumptions.
- Baez--Huerta, "Division Algebras and Supersymmetry II", arXiv:1003.3436.
  The abstract supports the division-algebra dimensions 3, 4, 6, and 10, but
  this is not by itself a theorem about checkerboards.
- Jacobson, "Feynman 1947 letter on path integral for the Dirac equation",
  arXiv:2408.15070.  The commentary is important evidence that some naive
  higher-dimensional Lorentz-covariant path-integral attempts are divergent or
  nonlocal.

## Corrections before publication

- Replace "every Standard Model particle except the Higgs" by a safer claim:
  "free Dirac fermions, Weyl mass mixing, and QCD composite rest mass have
  precise luminal/path-sum readings; massive gauge bosons require a separate
  vector-boson analysis."
- Do not say that Zitterbewegung proves literal trembling.  Keep it as
  representation-dependent motivation.  The invariant object is the propagator
  or evolution kernel.
- The phrase "expected number of corners" needs a specified measure.  In the
  quantum checkerboard the amplitudes are complex; any "expectation" must be
  defined either after taking a probability distribution or as a generating
  function identity.
- The division-algebra dimension sentence needs a caveat.  The standard
  `SL(2,K)` Lorentz story gives spacetime dimensions 3, 4, 6, and 10.  The
  1+1 checkerboard is a special two-ray case, not literally another item in
  that same `2 x 2 Hermitian over K` list.
- The 3+1 null-polygon theorem should cite Foster--Jacobson and the broader
  worldline/spin-factor literature.  The likely new contribution is a clean
  theorem statement, convention table, and formal algebraic spin-projector
  lemmas, not the mere existence of projector-weighted paths.

## Concrete Lean advance

`PhysicsSM/Spinor/Checkerboard.lean` adds a trusted, no-sorry finite
checkerboard skeleton:

- `Direction`, `Direction.step`, `Direction.flip`;
- `turnWeight mu`, with straight steps weighted by `1` and reversals by `mu`;
- `endpoint`, `terminalDirection`, and `pathWeight`;
- `histories n`, the finite list of all length-`n` left/right histories;
- `mem_histories_length`, proving every generated history has length `n`;
- `pathSum`, the finite path sum between directed endpoints;
- `pathSum_succ`, the first-step decomposition of the exact finite path sum.

This is WP1a's first kernel-checked theorem.  It deliberately avoids analytic
claims and so does not depend on distribution theory, Bessel functions, or a
choice of continuum normalization.

`PhysicsSM/Spinor/CheckerboardDynamics.lean` now promotes the next finite
dynamics layer to trusted code:

- `histories_nodup` and `length_histories`, proving the generated histories
  are duplicate-free and have cardinality `2^n`;
- `pathWeight_eq_pow_turnCount`, identifying the multiplicative corner weight
  with a power of the scalar corner amplitude;
- `pathSum_last_step`, the endpoint-side recursion;
- `evolve` and `pathSum_eq_iterate_evolve`, packaging the two directed
  endpoint sums as a local two-component lattice evolution;
- `pathSum_klein_gordon`, the exact finite second-order telegraph recursion
  in which the corner weight enters through `mu^2`.
- `physicalCornerWeight` and `pathSum_klein_gordon_physical_corner`, the
  specialization `mu = i epsilon m`, where the second-order coefficient is
  `-epsilon^2 m^2`.

## Next theorem sequence

The next publication-grade Lean targets should stay finite.

Completed trusted targets:

1. Prove `histories` is duplicate-free and has cardinality `2^n`.
2. Define `turnCount` and prove `pathWeight mu d h = mu ^ turnCount d h`.
3. Package the two directed endpoint sums as a two-component lattice spinor and
   prove the finite endpoint recursion and telegraph recursion.

Remaining finite targets:

1. Prove the closed binomial formulas for paths with fixed endpoint,
   terminal direction, and number of turns.
2. Combine the closed binomial formulas into endpoint-level kernel closed
   forms.  This is queued as Aristotle task
   `62a3c14d-d084-4a24-b1e6-4e86a4ec605b`.
3. Relate the closed forms to the standard checkerboard kernel normalization.
4. Only after these finite theorems are complete, decide whether the continuum
   limit is formalized in Lean or cited to Skopenkov--Ustinov as an analytic
   theorem outside the verified contribution.

## Proposed paper framing

Working title:

> A formally verified finite core of Feynman's checkerboard

Main claim:

> The finite combinatorial checkerboard path sum, with a scalar corner weight,
> satisfies both the exact one-step directed recursion and the exact finite
> second-order telegraph recursion used in Feynman's 1+1D checkerboard model.
> These finite theorems are machine-checked in Lean 4 under the PhysicsSM
> convention/provenance discipline.

This is modest, but it is clean.  It can be paired with an expository section
explaining how Skopenkov--Ustinov supply the analytic continuum theorem and how
Foster--Jacobson supply the four-dimensional projector analogue.
