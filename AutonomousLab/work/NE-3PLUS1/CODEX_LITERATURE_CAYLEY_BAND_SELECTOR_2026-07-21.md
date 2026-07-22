# Literature pass: inverse Cayley route to a live HNU band selector

Date: 2026-07-21  
Work item: `QCA-3PLUS1-001`

## Question

Can the live massive HNU walk's proved zero/pi Floquet gap be converted into a
finite Hermitian spectral-sector selector without first formalizing a matrix
logarithm and branch-cut functional calculus?

## Primary-source result

Yes. Bourne develops index theory for gapped chiral unitaries and split-step
quantum walks using a Cayley transform and indices of pairs of projections.
This validates the structural route from a unitary with an excluded branch
point to self-adjoint/index data; it does not prove any HNU-specific statement.

- C. Bourne, "Index Theory of Chiral Unitaries and Split-Step Quantum Walks,"
  SIGMA 19 (2023) 053, arXiv:2211.10601,
  DOI: 10.3842/SIGMA.2023.053.
- Source page: <https://arxiv.org/abs/2211.10601>
- Zotero key: `24HUDNBG` (added to collection `9W59V3K9`).
- Neo4j: synced as `Paper.paper_key = 24HUDNBG`, embedded in
  `paper_embedding`, and recovered as the top hit for the held-out query
  "Cayley transform chiral unitary band projector split-step quantum walk"
  (cosine score `0.861`).

The broader Floquet literature likewise treats gaps at `+1` and `-1` as the
distinguished quasienergy gaps and attaches band or time-dependent invariants
to gapped unitary evolutions. Existing graph anchors include:

- S. Tauber, "Topological boundary invariants for Floquet systems and quantum
  walks," arXiv:1708.01173, Zotero `TTBJSPCC`.
- T. Higashikawa, H. Fujita, and M. Sato / related HNU single-Weyl Floquet
  literature already indexed under the repository's HNU source packet.

## Locality gate from QCA literature

The Cayley construction does not automatically inherit the walk's strict
position-space locality. Zimboras, Farrelly, Farkas, and Masanes prove that
there are QCAs for which every time-independent generating Hamiltonian is fully
nonlocal. They also prove a positive result in one dimension: quasi-free
fermionic QCAs admit quasi-local generators, with exponential decay in the
massive/zero-winding case and algebraic decay in the critical/nonzero-winding
case.

- Z. Zimboras, T. Farrelly, S. Farkas, and L. Masanes, "Does causal dynamics
  imply local interactions?", Quantum 6 (2022) 748, arXiv:2006.10707,
  DOI: 10.22331/q-2022-06-29-748.
- Source page: <https://arxiv.org/abs/2006.10707>
- Zotero key: `26R9MW26` (collection `9W59V3K9`).
- Neo4j: synced as `Paper.paper_key = 26R9MW26`; 22 full-text chunks are
  embedded. A held-out abstract query for a causal unitary with a local
  effective Hamiltonian recovered it first with score `0.841`.

The mechanism in their positive theorem is informative for the HNU route.
Zero band winding permits analytic periodic quasienergies and eigenprojectors;
their Fourier coefficients then decay exponentially. Nonzero winding inserts
a sawtooth term whose Fourier coefficients decay only algebraically. This is a
one-dimensional theorem, not a direct result for the four-dimensional HNU
fiber, but it identifies the right theorem gate: analyticity and topological
triviality of the selected band must be established before the Cayley sector is
called quasi-local.

## Projector locality is weaker than a localized basis

Two further sources separate notions that should not be bundled into one HNU
gate:

- M. Benzi, P. Boito, and N. Razouk, "Decay Properties of Spectral Projectors
  with Applications to Electronic Structure," SIAM Review 55 (2013) 3-64,
  arXiv:1203.3953, DOI: 10.1137/100814019, Zotero `8CPJCV8S`, Neo4j 66
  full-text chunks.
- D. Monaco and G. Panati, "Symmetry and localization in periodic crystals:
  triviality of Bloch bundles with a fermionic time-reversal symmetry,"
  arXiv:1601.02906, DOI: 10.1007/s10440-014-9995-8, Zotero `7DZU5VPE`,
  Neo4j 18 full-text chunks.

Benzi--Boito--Razouk prove exponential off-diagonal decay for spectral
projectors of sparse gapped Hermitian systems. Monaco--Panati identify Bloch
bundle triviality as the obstruction to a smooth periodic Bloch frame and the
associated almost-exponentially localized composite Wannier basis. The
combined lesson is important: topological obstruction to a globally localized
orthonormal basis does not by itself forbid decay of the gauge-invariant
projector kernel. For HNU, therefore, the ordered targets should be:

1. canonical pointwise projector;
2. continuity/analyticity and decay of the projector kernel;
3. only then, if needed, a globally localized orthonormal basis.

Conflating steps 2 and 3 would turn a possible Wannier obstruction into a
false no-go against projector quasi-locality.

## Repository fit

The live HNU family has exactly the required finite hypotheses:

1. `massiveHNU_unitary`: each fiber is unitary.
2. `massiveHNU_zero_pi_gap`: for `0 < a < pi` and momentum in the closed
   Brillouin cube, both `det(U - 1)` and `det(U + 1)` are nonzero.
3. `OverlapSignExistence.certifiedSign_exists`: every invertible Hermitian
   finite matrix has a certified sign.
4. `OverlapSignHermitian.signCertificate_isHermitian`: that certified sign is
   a self-adjoint involution.

Define

```text
A(U) = i (U - 1) (U + 1)^-1.
```

The `-1` gap makes the denominator invertible and, with unitarity, makes `A`
Hermitian. The `+1` gap makes `A` invertible. Its certified sign then gives the
orthogonal projector `(1 - sign(A))/2` onto one Cayley-sign sector.

## What this would establish

- A band projector is derived from the actual live HNU fiber, rather than
  supplied as external data.
- The fixed-mass HNU global gap composes with the existing overlap/sign API.
- The physical-sector program can use Hermitian projector perturbation and
  adiabatic tools without first building a logarithm of the Floquet unitary.

## What it would not establish

- The Cayley transform contains a matrix inverse and is generally not a
  finite-range position-space operator. Strict locality is not inherited, and
  causal discrete evolution alone does not imply even quasi-locality of a
  time-independent generator.
- Existence of two sign sectors does not decide which sector is physically
  occupied.
- Pointwise projectors do not yet give continuity, quasi-local decay,
  neighboring-step norm bounds, or an adiabatic theorem for the live schedule.
- The fixed nonzero mass angle remains an input; no observed scale is derived.

## Formal action

The typechecked target
`PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` states the generic Cayley
algebra, its live HNU instantiation, certified-sign existence, and the
orthogonal-projector conclusion. Aristotle project
`19f45c37-0a02-4c70-9f98-bb6f9dcdf227` is assigned to close its six proof
handoffs without changing the statements.

If that job lands, the next theorem should be continuity and a quantitative
projector-difference bound on a compact momentum/refinement window. Before
that analytic rung, expose one finite algebraic composition theorem: the
negative-Cayley projector is unique and commutes with the actual live HNU
endpoint. Its honest name is a canonical negative-principal-quasienergy
projector, not yet a physical-sector release or a proof that one chirality or
one microscopic companion has been removed. The rest-frame kill test is

```text
P(a, 0) = (1 - beta) / 2.
```

Failure would reveal a Cayley sign/order error or the wrong occupied-band
convention. Passing it would still leave rank two, continuity, companion
removal, and quasi-locality as separate obligations. If the Cayley generator
becomes badly conditioned as the refinement path approaches the branch cut,
that failure is the correct physical-sector obstruction to report.

The subsequent locality rung should be stated independently:

1. prove that the selected HNU eigenprojector and Cayley quasienergy extend
   analytically to a uniform complex strip, or record the exact obstruction;
2. audit the selected band for winding or the relevant higher-dimensional
   topological class;
3. derive an explicit exponential or algebraic Fourier-tail bound for the
   projector kernel;
4. promote the band selector to a quasi-local real-space sector; and
5. separately ask whether the selected bundle admits a global localized
   orthonormal basis.

Failure at this rung would not invalidate the finite band projector or the
changing-lattice continuum theorem. It would block the stronger claim that the
projected physical sector has a local microscopic Hamiltonian realization.
