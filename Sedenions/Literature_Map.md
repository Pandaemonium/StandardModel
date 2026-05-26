# Literature Map for the Sedenion Program

This document records the current source map.  It separates what the source
supports from what remains a research conjecture.

## Zero Divisors and Box-Kites

Primary source:

- Robert P. C. de Marrais, "The 42 Assessors and the Box-Kites they fly:
  Diagonal Axis-Pair Systems of Zero-Divisors in the Sedenions' 16 Dimensions",
  arXiv:math/0011260.
  <https://arxiv.org/abs/math/0011260>

Supported use:

- 168 primitive unit zero divisors;
- 42 assessors;
- seven box-kites;
- box-kite combinatorics as a known background structure.

Research use:

- recode the assessor/box-kite system as affine-plane geometry over `F_2^4`;
- compare the de Marrais signs with the Cayley-Dickson twisting cochain.

## Cayley-Dickson Twists and Cocycle Language

Primary source:

- Helena Albuquerque and Shahn Majid, "Quasialgebra structure of the
  octonions", arXiv:math/9802116.
  <https://arxiv.org/abs/math/9802116>

Supported use:

- octonions and higher Cayley-Dickson-like algebras can be described via
  twisted group-algebra/quasialgebra structures;
- sign data should be treated cohomologically, not as an arbitrary table.

Research use:

- formulate the sedenion sign rule as a cochain on `F_2^4`;
- restrict that cochain to zero-divisor affine planes;
- test whether the restriction defines a canonical quadratic or `Z_4`
  refinement.

## Stabilizer States and Quadratic Forms

Primary source:

- Jeroen Dehaene and Bart De Moor, "The Clifford group, stabilizer states,
  and linear and quadratic operations over GF(2)", arXiv:quant-ph/0304125.
  <https://arxiv.org/abs/quant-ph/0304125>

Supported use:

- stabilizer states and Clifford operations can be represented using binary
  linear data and quadratic forms.

Research use:

- convert signed zero-divisor affine planes into quadratic-phase states;
- determine whether the resulting 4-sparse states are stabilizer states;
- extract stabilizer generators.

## Barnes-Wall, Clifford, Kerdock, and Quantum Codes

Primary sources:

- Gabriele Nebe, Eric M. Rains, and Neil J. A. Sloane, "The invariants of the
  Clifford groups", arXiv:math/0001038.
  <https://arxiv.org/abs/math/0001038>
- Vadym Kliuchnikov and Sebastian Schoennenbeck, "Stabilizer operators and
  Barnes-Wall lattices", arXiv:2404.17677.
  <https://arxiv.org/abs/2404.17677>
- Amolak Ratan Kalra and Pulkit Sinha, "Stabilizer Ranks, Barnes Wall
  Lattices and Magic Monotones", arXiv:2503.04101.
  <https://arxiv.org/abs/2503.04101>

Supported use:

- Barnes-Wall lattices, Clifford groups, Kerdock structures, quantum codes,
  and stabilizer states are tightly connected;
- Barnes-Wall minimal vectors are related to stabilizer states;
- Barnes-Wall norms can be used in magic-state resource questions.

Research use:

- test whether signed sedenion plaquettes land in a Barnes-Wall first shell;
- test whether the sedenion `S_3` action is Clifford, lattice-preserving, or
  magic-generating.

## Sedenions, S3, and Three Generations

Primary sources:

- Niels Gresnigt, Liam Gourlay, and Abhinav Varma, "Three generations of
  colored fermions with S_3 family symmetry from Cayley-Dickson sedenions",
  arXiv:2306.13098.
  <https://arxiv.org/abs/2306.13098>
- Liam Gourlay and Niels Gresnigt, "Algebraic realisation of three fermion
  generations with S_3 family and unbroken gauge symmetry from C ell(8)",
  arXiv:2407.01580.
  <https://arxiv.org/abs/2407.01580>
- "Electroweak Structure and Three Fermion Generations in Clifford Algebra
  with S3 Family Symmetry", arXiv:2601.07857.
  <https://arxiv.org/abs/2601.07857>

Supported use:

- recent physics models use an `S_3` family symmetry in complex
  Clifford-algebra constructions motivated by sedenions;
- the `Cl(8)` model improves earlier charge and linear-dependence issues;
- the `Cl(10)` extension targets the full electroweak sector.

Research use:

- compute whether the relevant `S_3` action preserves zero-divisor supports,
  signed cocycles, or stabilizer plaquettes;
- test whether the order-three action is Clifford-like or magic-generating in
  the Barnes-Wall/stabilizer representation.

## Secondary Orientation Sources

- Error Correction Zoo, qubit stabilizer and Barnes-Wall-related entries:
  <https://errorcorrectionzoo.org/>

Use only for orientation.  Primary mathematical claims should be checked
against papers or formalized directly.
