# Checkerboard Literature Review

Date: 2026-07-01

This review supports the next `PhysicsSM.Draft.Checkerboard1D` work package:
endpoint closed forms, small-angle generator expansion, and a carefully stated
continuum-limit theorem. It is a literature orientation, not a claim that the
Lean package has proved the continuum Dirac equation.

Local Neo4j paper/doc vector search was attempted on 2026-07-01, but Neo4j was
not running on `127.0.0.1:7687`. The review below therefore uses live arXiv and
publisher metadata plus direct inspection of available arXiv text.

## Main Takeaways For This Package

The current Lean checkerboard seed is aligned with the literature at the finite
algebra level:

- paths are finite strings of two null directions;
- a turn is a direction reversal;
- each turn carries the mass-like amplitude;
- the transfer matrix is a two-state nearest-step evolution;
- powers of the transfer matrix expand as finite endpoint-constrained path
  sums.

The next formal layer should not jump directly to a continuum theorem. The
literature separates three intermediate jobs:

1. endpoint counts by start/end direction and exact number of turns;
2. closed-form finite sums, often using binomial coefficients, Jacobi
   polynomials, Bessel functions, or hypergeometric functions;
3. an analytic scaling theorem, with lattice spacing, time scaling, initial data
   regularity, and convergence topology stated explicitly.

## Source Spine

### Feynman and Hibbs

The original checkerboard appears in Feynman and Hibbs, *Quantum Mechanics and
Path Integrals*, Problem 2-6. In the usual account, a particle moves left or
right at speed `c` on a 1+1D checkerboard and each direction change contributes
a phase proportional to `m c^2 dt / hbar`.

Lean consequence: our current `edgeAmp`/`turnCount` API is the right finite
starting point, but the exact sign and phase convention must stay explicit.

### Gersch 1981

Gersch identifies Feynman's relativistic chessboard with a one-dimensional
Ising/transfer-matrix calculation. The useful point for us is the transfer
matrix interpretation: a two-by-two matrix evolves the two velocity states, and
statistical-mechanics methods can sum path classes.

Lean consequence: continue treating `checkerStep` powers as the finite object.
Endpoint counts and grouped sums should be stated as finite matrix/path
identities before any limit.

### Jacobson-Schulman and Earle

Jacobson and Schulman supplied a constructive combinatorial argument for
checkerboard path classes. Earle's arXiv note compares approaches and writes
corrected endpoint class counts. In Earle's notation, for right-to-left paths
with `k` turn-pairs, the count has the binomial shape:

```text
binom(r - 1, k) * binom(l - 1, k)
```

with related shifted formulas for right-to-right and left-to-left classes.
Earle also emphasizes that phase conventions differ across presentations.

Lean consequence: the next finite target should be a convention-clean endpoint
count theorem. It must define whether `r,l` count edges, vertices, or available
turn slots, and it must handle boundary cases such as zero right or left edges.

### Kauffman-Noyes 1996

Kauffman and Noyes rewrite the 1+1D Dirac equation in light-cone coordinates
and solve it by finite differences. Their complex form gives Feynman's
checkerboard as a weighted sum over lattice paths; their real/rational form is
tied to bit-string interpretations.

Lean consequence: a later analytic theorem should probably be stated in
light-cone coordinates first. The current two-component recurrence is already
close to this form, but it needs a lattice field indexed by spacetime sites, not
only a direction-state vector.

### D'Ariano-Mosco-Perinotti-Tosini 2014

This paper treats the one-dimensional Dirac quantum cellular automaton as a
quantum walk and solves its discrete path integral analytically in terms of
Jacobi polynomials for arbitrary mass parameter.

Lean consequence: our unitary normalization

```text
checkerStep (cos theta) (cos theta) (i * sin theta)
```

is compatible with the quantum-walk/QCA lane. The new Lean scaffold records the
exact decomposition into identity plus reversal and a small-angle mass-scaling
predicate.

### Skopenkov-Ustinov 2020/2022 and 2022/2024

Skopenkov and Ustinov give modern rigorous treatments of Feynman checkers. The
survey develops asymptotics for small lattice spacing and large time, proves
consistency with the continuum model in a specified regime, and connects the
model to one-dimensional quantum walks and imaginary-temperature Ising
language. The later real-time lattice QFT paper modifies the model to include
electron/positron creation and annihilation, proves consistency with continuum
QFT charge density in a lattice-step limit, and gives exact hypergeometric
solutions.

Lean consequence: these sources are the best guide for the final analytic
statement, but they are far beyond the present finite algebra layer. Use them
to choose hypotheses and theorem shape; do not encode their asymptotic
conclusions as Lean facts until the analysis is available.

### Quantum Walk/QCA Literature

Bialynicki-Birula's lattice cellular-automaton work, Strauch's relativistic
quantum walks, and later Dirac QCA/split-step quantum-walk papers all reinforce
the same lesson: unitary finite evolution is natural, but the continuum Dirac
equation appears only after a scaling or small-wave-vector regime is specified.

Lean consequence: keep the finite unitary audit separate from convergence.
Unitarity of one step is a finite consistency check, not a continuum theorem.

## Proposed Lean Work Split

### Codex-side finite setup

Already added in `PhysicsSM.Draft.CheckerboardContinuumScaffold`:

- `outgoingRightCount`;
- `outgoingLeftCount`;
- `outgoingRightCount_add_outgoingLeftCount`;
- `outgoingDisplacement`;
- `isotropicStep`;
- `reversal_sq`;
- `isotropicStep_eq_cos_one_add_i_sin_reversal`;
- `isotropicStep_zero`;
- `reversal_commutes_isotropicStep`;
- `CheckerboardContinuumScale`;
- `feynmanTurnAmplitude`;
- `unitaryAngleHasMassScale`;
- `CheckerboardDiracLimitProblem`.

### Aristotle-side proof/audit targets

Ask Aristotle to work in this order:

1. Prove a parity theorem: endpoint direction is determined by turn-count
   parity, e.g. same start/end direction iff the number of turns is even.
2. Propose and, if feasible, prove endpoint count formulas matching the
   Earle/Jacobson-Schulman binomial classes under the package's explicit edge
   convention.
3. Audit whether the outgoing-edge convention is the right one for matching the
   literature, or whether the finite path tuple should instead record segment
   directions with a different indexing convention.
4. Propose exact Lean theorem statements for a small-angle generator expansion.
5. Propose the best next analytic theorem statement for a continuum Dirac
   limit, including required Mathlib analysis APIs and likely blockers.

## Sources

- R. P. Feynman and A. R. Hibbs, *Quantum Mechanics and Path Integrals*,
  Problem 2-6, McGraw-Hill, 1965.
- H. A. Gersch, "Feynman's relativistic chessboard as an ising model",
  *International Journal of Theoretical Physics* 20, 491-501 (1981),
  <https://doi.org/10.1007/BF00669436>.
- T. Jacobson and L. S. Schulman, "Quantum stochastics: the passage from a
  relativistic to a non-relativistic path integral", *J. Phys. A* 17, 375-383
  (1984).
- Keith A. Earle, "Notes on The Feynman Checkerboard Problem",
  arXiv:1012.1564, <https://arxiv.org/abs/1012.1564>.
- L. H. Kauffman and H. P. Noyes, "Discrete Physics and the Dirac Equation",
  arXiv:hep-th/9603202, <https://arxiv.org/abs/hep-th/9603202>.
- G. M. D'Ariano, N. Mosco, P. Perinotti, and A. Tosini,
  "Path-integral solution of the one-dimensional Dirac quantum cellular
  automaton", arXiv:1406.1021, <https://arxiv.org/abs/1406.1021>.
- M. Skopenkov and A. Ustinov, "Feynman checkers: towards algorithmic quantum
  theory", arXiv:2007.12879, <https://arxiv.org/abs/2007.12879>.
- M. Skopenkov and A. Ustinov, "Feynman checkers: lattice quantum field theory
  with real time", arXiv:2208.14247, <https://arxiv.org/abs/2208.14247>.
- F. W. Strauch, "Relativistic quantum walks", arXiv:quant-ph/0508096,
  <https://arxiv.org/abs/quant-ph/0508096>.
- A. Bisio, G. M. D'Ariano, and A. Tosini, "The Dirac Quantum Cellular Automaton
  in one dimension: Zitterbewegung and scattering from potential",
  arXiv:1305.0461, <https://arxiv.org/abs/1305.0461>.
