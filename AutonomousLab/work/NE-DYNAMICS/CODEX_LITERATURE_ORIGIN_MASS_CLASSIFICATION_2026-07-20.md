# Literature memo: origin-of-mass classification and spectral reconstruction

Date: 2026-07-20
Role: Codex Archivist
Work item: `MASS-ORIGIN-001`
Mission prompt: `AutonomousLab/prompts/CODEX_MASS_3PLUS1_LITERATURE_GOAL_2026-07-20.md`

## Executive result

The literature supports a sharper architecture than the slogan "one mechanism
creates all mass."

1. Within the renormalizable Standard Model, one supplied Higgs vacuum datum
   participates in three mathematically distinct response calculations:
   gauge-orbit stiffness, Yukawa fermion maps, and the radial Hessian of the
   scalar potential.
2. These are shared-input mechanisms, not one identical mass term. The gauge
   couplings, Yukawa matrices, scalar potential, and vacuum scale remain visible
   inputs.
3. Neutrino mass is outside the minimal renormalizable Standard Model field
   content. A right-handed singlet permits a Dirac branch; the dimension-five
   Weinberg operator permits a Majorana branch; a seesaw adds heavy-sector data.
4. Composite hadron mass is the rest-frame response of the interacting QCD
   Hamiltonian. Its finer split into quark energy, gluon energy, explicit quark
   mass, and trace anomaly is not a second independent list of masses and is
   scheme dependent below the trace/traceless split.
5. A finite operator gap is not yet a physical mass. The clean reconstruction
   ladder is: positive physical Hilbert space and evolution, positive spectral
   measure for a gauge-invariant two-point observable, isolated spectral support
   with nonzero overlap, dispersion/rest-energy identification, and a controlled
   changing-lattice limit.

This changes the proof queue. The next finite theorem should package a single
explicit Higgs datum into the three electroweak response sectors while exposing
all independent couplings. It must not claim a derived vacuum, flavor hierarchy,
Higgs pole, or physical Standard Model completion.

## Search health and method

- Zotero read and write were live.
- Neo4j exact Cypher, abstract vector search, and full-text chunk search were
  live.
- Scholarly arXiv and web primary-source search were live. One broad scholarly
  meta-search hit a Semantic Scholar HTTP 429; arXiv, INSPIRE, Crossref, web,
  Zotero, and Neo4j remained usable.
- `neo4j_paper_search.py` initially exposed a Windows code-page output failure
  on some Unicode results. Setting `PYTHONUTF8=1` removed the failure.
- Lean semantic search was live for Mathlib and PhysLean (`Physlib`). No useful
  PhysLean Kallen-Lehmann or lattice-transfer API was found.

Search sequence used:

1. exact Zotero and Neo4j checks by DOI/arXiv ID;
2. Neo4j abstract ranking for origins of mass, transfer/correlation gaps, and
   shared Higgs/Yukawa data;
3. Neo4j full-text chunks for QCD mass decomposition and glueball correlation
   extraction;
4. primary/authoritative online sources for current Standard Model conventions;
5. Mathlib and PhysLean semantic API search;
6. deduplicated Zotero ingestion and Neo4j/index refresh.

## Source map

### 1. Electroweak shared datum

**Particle Data Group, "Status of Higgs Boson Physics," 2025, Sec. 11.2.**

- Current authoritative convention source:
  `https://pdg.lbl.gov/2025/reviews/rpp2025-rev-higgs-boson.pdf`.
- The scalar Lagrangian contains a covariant-derivative term and a separately
  parameterized potential.
- A vacuum representative `H0 = (0, v / sqrt 2)` breaks
  `SU(2)_L x U(1)_Y` to `U(1)_Q`.
- The same `v` enters
  `m_W^2 = g^2 v^2 / 4`,
  `m_Z^2 = (g^2 + g'^2) v^2 / 4`,
  `m_H^2 = 2 lambda v^2`, and
  `m_f = y_f v / sqrt 2`.
- The photon stabilizer remains massless. Three scalar directions supply the
  longitudinal weak-boson modes and one radial direction remains.
- The review explicitly notes that the Higgs mass is not predicted by the
  Standard Model and that the Yukawa hierarchy remains unexplained.

**Theorem consequence.** A shared-data theorem is legitimate if it proves that
one displayed `H0` is consumed by three separately parameterized maps. It is
false shape to say that one datum alone derives all three sectors.

**Formal anchors already present.**

- `GaugeMassGram.gaugeMassMatrix_posSemidef` and
  `GaugeMassGram.diagonal_zero_iff_stabilizer`;
- `HiggsTangentDecomposition.tangent_eq_radial_add_physicalOrbit`;
- `HiggsDoubletRadialCurvature.radialMassSquared` and
  `radialMassSquared_pos`;
- `HiggsDofConservation.dof_conserved_general`;
- `GateYM.YukawaTurnAmplitude.flavorMassTerm` and its chiral controls.

**PhysLean references.** Semantic search found the current physics-library
shapes `StandardModel.HiggsField.Potential`,
`StandardModel.HiggsField.EffectivePotential.IsInvariant.eq_on_orbits`,
`StandardModel.HiggsField.guage_orbit`, and
`TwoHiggsDoublet.massTerm_eq_gramVector`. PhysLean is version-pinned away from
this project, so these are clean-room API and convention references only.

### 2. Scope of an origin-of-mass claim

**Frank Wilczek, "Origins of Mass," arXiv:1206.7114.**

- Zotero key: `QW978F9Q`.
- Distinguishes dynamical QCD mass of ordinary matter from electroweak symmetry
  breaking for weak bosons and fermions.
- Explicitly states that the Higgs particle's own mass is a free parameter in
  the Standard Model treatment.

**Theorem consequence.** The mechanism matrix must separate elementary
electroweak response from composite QCD rest energy. Pluecker kinematics may
organize a common finite architecture, but it cannot replace either dynamical
calculation by vocabulary.

### 3. Neutrino branches

**Steven Weinberg, "Baryon- and Lepton-Nonconserving Processes," Phys. Rev.
Lett. 43 (1979), DOI 10.1103/PhysRevLett.43.1566.**

- New Zotero key: `4B4VURM2`.
- New Neo4j node uses canonical key `4B4VURM2`.
- Primary source for the leading dimension-five lepton-number-violating
  operator that yields a Majorana neutrino mass after electroweak symmetry
  breaking.

**Stephen F. King, "Right-handed neutrinos: seesaw models and signatures,"
arXiv:2502.07877.**

- Zotero key: `F9XEX6C5`.
- Current pedagogical map of right-handed Dirac, canonical seesaw, inverse
  seesaw, and related branches.

**Theorem consequence.** Exhaustiveness must be indexed by field content and
operator dimension. The minimal renormalizable Standard Model has no neutrino
mass map; adding a right-handed singlet or the Weinberg operator changes the
admissible universe.

**Formal anchors already present.**

- `NeutrinoDiracMajorana.lean`;
- `NeutrinoSeesaw.lean` and `SchurSeesaw.lean`;
- `NeutrinoCPSeesawBridge.lean`;
- `NeutrinoMassMechanismCapstone.lean`.

### 4. Composite mass and non-double-counting

**Xiangdong Ji, "Breakup of hadron masses and energy-momentum tensor of QCD,"
Phys. Rev. D 52 (1995) 271, arXiv:hep-ph/9502213,
DOI 10.1103/PhysRevD.52.271.**

- New Zotero key: `S9VK6WJB`.
- New Neo4j node and 21 full-text chunks use canonical key `S9VK6WJB`.
- Full-text section "Breakup of the Hadron Masses" states that the finite
  energy-momentum tensor has a unique, scale-independent trace/traceless split.
- The subsequent split into renormalized quark/gluon pieces and quark-mass/trace
  anomaly pieces is renormalization- and regularization-scheme dependent.
- The hadron mass is the rest-frame Hamiltonian expectation (equivalently, in
  field-theory language, associated with Green-function poles).

**Anti-double-counting rule.** Composite mass is one rest-state spectral
response. Quark kinetic/potential energy, gluon energy, explicit quark mass,
and anomaly are a chosen decomposition of that response. They must not be added
again as independent mass mechanisms on top of the hadron mass.

**Program consequence.** A finite SU(3) bridge should first prove a
gauge-invariant sector, positive evolution, correlation decay, and a transfer
gap. A detailed proton mass budget is a later, convention- and scheme-locked
energy-momentum-tensor theorem.

### 5. Positive transfer dynamics

**M. Luescher, "Construction of a selfadjoint, strictly positive transfer
matrix for Euclidean lattice gauge theories," Commun. Math. Phys. 54 (1977)
283, DOI 10.1007/BF01614090.**

- New Zotero key: `99FVMMKD`.
- New Neo4j node uses canonical key `99FVMMKD`.
- Supplies the classic positive self-adjoint transfer-matrix target for Wilson
  lattice gauge theory.

**K. Osterwalder and E. Seiler, "Gauge field theories on a lattice," Annals of
Physics 110 (1978) 440, DOI 10.1016/0003-4916(78)90039-8.**

- Existing Zotero key: `SMH5768W`.
- Supplies reflection positivity and reconstruction for lattice gauge/Higgs
  systems.

**Theorem consequence.** "Positive matrix entries" and "positive transfer
operator" are not interchangeable. The finite QCD bridge needs a declared
inner product, self-adjoint/positive operator, physical sector, and observable
overlap.

### 6. Positive spectral measure and mass extraction

**Kouta Usui, "A Note on Reflection Positivity and the
Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation
Functions," arXiv:1201.3415.**

- Zotero key: `R3JICUIK`.
- Theorem 2.1: Hermiticity, translation invariance, reflection positivity, and
  polynomial correlation bounds yield a unique bounded positive spectral
  measure for the Euclidean two-point function.
- Sec. 3 reconstructs the Hilbert space, transfer operator, Hamiltonian, and
  commuting momenta.
- Theorem 4.1: a spectral density negative on a positive-measure set forces at
  least one reconstruction assumption to fail.

**David Dudal, Orlando Oliveira, and Martin Roelfs, "Kallen-Lehmann Spectral
Representation of the Scalar SU(2) Glueball," arXiv:2103.11846,
DOI 10.1140/epjc/s10052-022-10213-3.**

- New Zotero key: `DPJ6N6WS`.
- New Neo4j node and 14 full-text chunks use canonical key `DPJ6N6WS`.
- Numerical proof of concept: extract a scalar-glueball spectral density from
  gauge-invariant lattice two-point data; the ground-state mass agrees with the
  conventional large-Euclidean-time exponential extraction.
- This is an operational model for the desired observable, not a general
  theorem and not an SU(3) continuum mass-gap proof.

**Theorem consequence.** The first formal target should be finite and exact:
for a positive self-adjoint transfer operator with a selected vacuum and an
observable having nonzero overlap with an isolated first excited eigenspace,
the connected two-point sequence is a positive sum of exponentials and its
asymptotic decay rate equals the visible transfer gap. The continuum pole claim
must remain a successor theorem.

**Mathlib references.** Semantic search found useful building blocks for
positive semidefinite Gram operators and self-adjoint spectral decompositions,
including `Matrix.posSemidef_gram`,
`Matrix.PosSemidef.dotProduct_mulVec_zero_iff`,
`LinearMap.IsSymmetric.eigenvalues`, and
`LinearMap.IsSymmetric.directSumDecomposition`. No existing Mathlib or PhysLean
API directly supplies the full finite transfer-correlation theorem.

## Recommended mechanism classes

The mechanism matrix should use the following top-level rows.

1. **Kinematic null-composition invariant.** Pluecker/Gram determinant and
   rest-operator gap. This explains an allowed finite gap form, not its selected
   value or physical pole by itself.
2. **Fermion chiral turn.** A gauge-equivariant Yukawa map evaluated on `H0`.
   Inputs: representation, `Y_f`, and `H0`.
3. **Broken gauge-orbit stiffness.** Gram matrix of `X |-> X H0` with the
   unbroken stabilizer as kernel. Inputs: representation, gauge couplings, and
   `H0`.
4. **Scalar radial curvature.** Hessian of the supplied scalar potential normal
   to the vacuum orbit. Inputs: potential and `H0`.
5. **Neutrino extension.** Dirac, Majorana/Weinberg, or seesaw response relative
   to declared extra fields/operators and symmetry costs.
6. **Composite interacting rest energy.** Gauge-invariant transfer/correlation
   spectrum of the many-body QCD sector. Its internal energy-momentum
   decomposition is a subordinate, scheme-locked budget, not another row.
7. **Inertial/gravitational response.** A separate equivalence test asking
   whether the same total rest response sources acceleration and gravity. It is
   not an additional additive mass contribution.

## Queue changes

1. **Promote now:** scoped mechanism matrix and shared-Higgs-data packaging
   theorem.
2. **Next exact semantic bridge:** finite positive transfer correlation theorem
   with a nonzero-overlap witness and an orthogonality control.
3. **Next QCD construction:** nonabelian finite gauge-invariant observable plus
   positive transfer operator; do not jump directly to "proton mass derived."
4. **Neutrino gate:** state exhaustiveness by field content and operator
   dimension before composing existing Dirac/Majorana/seesaw modules.
5. **Manuscript wording:** retain "finite representatives of principal mass-gap
   mechanisms" until the QCD transfer, spectral reconstruction, and continuum
   gates are green.

## Knowledge-base changes

Dedup checks were run before every add. Added:

| Zotero key | External ID | Neo4j/full text |
|---|---|---|
| `99FVMMKD` | DOI `10.1007/BF01614090` | node embedded; no full text |
| `4B4VURM2` | DOI `10.1103/PhysRevLett.43.1566` | node embedded; no full text |
| `DPJ6N6WS` | arXiv `2103.11846` | node embedded; 14 chunks |
| `S9VK6WJB` | arXiv `hep-ph/9502213` | node embedded; 21 chunks |

The paper vector index was refreshed after ingestion. Canonical graph keys are
bare Zotero item keys and all four nodes are connected to collection
`9W59V3K9`.

## Exact next theorem suggested by this pass

Define one finite record containing a displayed Higgs vacuum scale `v`, scalar
coupling `lambda`, Yukawa matrix `Y`, and gauge-orbit action. Prove in one
theorem that:

- the fermion turn uses exactly the supplied product `v * Y`;
- the gauge mass Gram matrix is positive semidefinite and its diagonal vanishes
  exactly on the stabilizer of the same vacuum vector;
- the radial mass coefficient is exactly `2 * lambda * v^2`;
- `v = 0` simultaneously kills all three vacuum-induced responses;
- `Y = 0`, a stabilizing gauge generator, and `lambda = 0` independently kill
  only their corresponding sectors;
- an explicit rational/nonzero witness prevents the theorem from being a bundle
  of vacuous zero identities.

This theorem is a convention-locked reconstruction from shared data. It is not
a derivation of `v`, `Y`, `lambda`, a physical pole, or observed masses.

## 2026-07-21 03:00 PDT refresh: physical Majorana masses

The newly landed mixed pseudo-Dirac module exposed one semantic gap that should
be closed before calling its algebraic roots masses. A complex symmetric
Majorana mass matrix is diagonalized by unitary congruence, not ordinary
similarity diagonalization. Its physical nonnegative masses are the Takagi
values, equivalently its singular values; they can differ from the complex
eigenvalues used in the present two-state algebraic module.

Primary/source anchors:

- A. V. Borisov and A. P. Isaev, *Neutrino Mass in Effective Field Theory*,
  arXiv:2312.17714, Appendix C, gives a proof of Takagi diagonalization for
  Majorana mass matrices. Added to Zotero as `I9NUBC9A` after exact arXiv-ID
  deduplication found no Neo4j node.
- The Particle Data Group neutrino-mixing review writes the Majorana mass
  matrix diagonalization as `V^T M V = diag(m_i)` and uses the resulting
  nonnegative entries as the physical masses.
- Adhikary, Chakraborty, and Ghosal, arXiv:1307.0988, is a concrete
  three-generation mass/mixing analysis, useful as a downstream convention
  check rather than the abstract factorization source.

Lean API search over Mathlib and PhysLean found Hermitian unitary
diagonalization and singular-value primitives (`LinearMap.singularValues`,
`LinearMap.singularValues_nonneg`, `LinearMap.singularValues_fin`, and
`Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary`) but no direct
Autonne-Takagi theorem. The clean next target is therefore not to relabel the
existing complex roots. It is to prove, first in the exact two-state branch,
that the squared physical masses are the nonnegative eigenvalues of `M^* M`,
recover the pure-Dirac degeneracy, and state the relation to the mixed
pseudo-Dirac splitting. A full arbitrary-dimension Takagi theorem is a larger
library contribution and should remain a separate successor.

**Queue change.** Add a guarded `MixedPseudoDiracPhysicalMass` rung before any
finite neutrino-exhaustiveness capstone. Its mandatory control is a complex
symmetric matrix whose algebraic eigenvalue moduli do not equal its singular
values, preventing the old eigenvalue language from surviving by accident.
