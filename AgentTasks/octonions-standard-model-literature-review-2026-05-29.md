# Literature review: octonions and Standard Model next theorem jobs

**Prepared**: 2026-05-29
**Purpose**: Source notes and theorem-target rationale for the next Aristotle
wave on the Furey/Baez/Dubois-Violette/Todorov formalization track.

## Sources consulted

- John Baez, "Can We Understand the Standard Model?", Perimeter talk/slides,
  2021. Useful for the `S(U(2) x U(3))` framing, the `Z6` quotient, and the
  view of the Standard Model group as preserving a compatible complex
  structure, volume form, and `4+6` splitting. Links:
  <https://pirsa.org/21040002> and
  <https://math.ucr.edu/home/baez/standard/standard_web.pdf>.
- Cohl Furey, "Charge quantization from a number operator",
  arXiv:1603.04078. Useful for the `Q_op`/number-operator charge table and the
  `SU(3)_c x U(1)_em` ladder-operator route.
  Link: <https://arxiv.org/abs/1603.04078>.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of division
  algebraic ladder operators", arXiv:1806.00612. Useful for the one-generation
  gauge-symmetry bridge and the global group quotient
  `SU(3) x SU(2) x U(1) / Z6`.
  Link: <https://arxiv.org/abs/1806.00612>.
- Cohl Furey and Mia Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948. Useful for the triality-triple API and for treating
  `tri(C) + tri(H) + tri(O)` as a long-term target rather than a current
  theorem.
  Link: <https://arxiv.org/abs/2409.17948>.
- Ivan Todorov and Michel Dubois-Violette, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", arXiv:1806.09450. Useful for the `h_2(O)`, `h_3(C)`, and
  common-stabilizer route.
  Link: <https://arxiv.org/abs/1806.09450>.
- Ivan Todorov, "Exceptional quantum algebra for the standard model of particle
  physics", arXiv:1911.13124. Useful for the exact intersection claim:
  the lepton-quark splitting and the special Jordan subalgebra lead to
  `S(U(3) x U(2))`.
  Link: <https://arxiv.org/abs/1911.13124>.
- Latham Boyle, "The Standard Model, The Exceptional Jordan Algebra, and
  Triality", arXiv:2006.16265. Useful as an adjacent source for the
  exceptional Jordan algebra plus triality picture.
  Link: <https://arxiv.org/abs/2006.16265>.
- Michel Dubois-Violette and Ivan Todorov, "Exceptional quantum geometry and
  particle physics", 2018. Useful for the `C + C^3` quark-lepton splitting
  language and for the three off-diagonal octonionic entries as generation
  data.
  Link: <https://doaj.org/article/4f1e326a6e0e474282e6a59986a9d4e6>.

## Formalization implications

The literature points to three layers that are useful before attempting major
group-identification theorems:

1. Finite algebraic API.
   Prove role permutations, action data, charge tables, and anomaly sanity
   checks as exact small Lean theorems. These are trusted scaffolds for Furey
   and Furey-Hughes.

2. Stabilizer/restriction API.
   Prove that the stabilizers preserve the chosen subspaces and that actions
   restrict to intersections. These are honest formal shadows of the Baez/DVT
   route without claiming the final compact Lie group isomorphism.

3. Complex-line action API.
   Prove that octonion maps fixing `e111` preserve the chosen complex line and
   the `C^3` complement, and commute with the selected complex structure on
   that complement. This is the next safe step toward the informal
   `G2`-stabilizer-to-`SU(3)` statement.

## Jobs prepared from this review

- `furey-triality-linear-equivariance-aristotle-2026-05-29.md`
- `furey-triality-action-monoid-aristotle-2026-05-29.md`
- `furey-jbar-su2-anomaly-aristotle-2026-05-29.md`
- `furey-j-sector-qop-bridge-aristotle-2026-05-29.md`
- `baez-g2-fixed-complex-line-aristotle-2026-05-29.md`
- `baez-dvt-stabilizer-restriction-aristotle-2026-05-29.md`

Existing related active job:

- `furey-triality-permutation-linear-aristotle-2026-05-29.md`,
  Aristotle job `22f1a9eb-7eb3-4b0f-9b90-79b159492197`, still in progress as
  of this review.

## Follow-up literature pass: 2026-05-29 evening

Additional source checks:

- Baez's octonions-and-Standard-Model slides emphasize that the true gauge
  group is `S(U(2) x U(3))`, that it acts on the octonionic qubit `h2(O)` while
  preserving `h2(C)`, and that the spinor-space characterization is commuting
  with right multiplication by the chosen octonionic imaginary unit.
  Link: <https://math.ucr.edu/home/baez/standard/standard_octonions_web.pdf>.
- Krasnov's `SO(9)` paper gives the direct centralizer formulation: the
  Standard Model group is characterized inside `Spin(9)` by commuting with the
  complex structure on `O^2` defined by a unit imaginary octonion.
  Link: <https://arxiv.org/abs/1912.11282>.
- Krasnov's 2025 ECM writeup shifts the same theme to aligned commuting
  complex structures and pure spinors in `Spin(10)`. This is a later target;
  for now the formalizable step is still the concrete complex-linear and
  Hermitian API for the `O^2` coordinate model.
  Link: <https://arxiv.org/abs/2504.16465>.
- Furey's thesis and ladder-operator paper keep pointing at small finite
  operator/charge-table theorems as the safest formal substrate before making
  representation-theoretic claims.
  Links: <https://arxiv.org/abs/1611.09182> and
  <https://arxiv.org/abs/1806.00612>.
- Furey-Hughes' triality paper motivates turning the finite role-permutation
  and action-data scaffold into a proper linear representation API before
  attempting anything resembling `tri(C) + tri(H) + tri(O)`.
  Link: <https://arxiv.org/abs/2409.17948>.

Follow-up jobs submitted:

- `krasnov-qubit-coordinate-linear-aristotle-2026-05-29.md`,
  job `7367c40a-97d5-4999-91e1-df9a4d422f83`
- `krasnov-qubit-hermitian-unitary-aristotle-2026-05-29.md`,
  job `1b237619-fc1e-45a9-be78-f60c06229cda`
- `baez-sm-block-homomorphism-aristotle-2026-05-29.md`,
  job `6a49742e-22f2-45b0-8432-686b89df56f4`
- `furey-triality-permutation-representation-aristotle-2026-05-29.md`,
  job `3a8a8fce-12cc-482b-9b4d-f457c08aeeae`
- `baez-dvt-block-action-monoid-aristotle-2026-05-29.md`,
  job `e16397ef-57d7-470d-9284-ed0ce33f684b`

Submission project:
`AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`.

## Integration update: 2026-05-30

Integrated completed jobs:

- J-sector `Q_op` eigenvalue bridge,
  job `9f5a049f-bef5-4b32-abc5-765037d39692`,
  into `PhysicsSM/Algebra/Furey/QopJEigenBridge.lean`.
- Standard Model block homomorphism laws,
  job `6a49742e-22f2-45b0-8432-686b89df56f4`,
  into `PhysicsSM/Gauge/StandardModelBlockHom.lean`.
- Krasnov Hermitian/unitary coordinate API,
  job `1b237619-fc1e-45a9-be78-f60c06229cda`,
  into `PhysicsSM/Spinor/KrasnovQubitHermitian.lean`.

Failed without downloadable artifact:

- Krasnov coordinate-linear API,
  job `7367c40a-97d5-4999-91e1-df9a4d422f83`.
