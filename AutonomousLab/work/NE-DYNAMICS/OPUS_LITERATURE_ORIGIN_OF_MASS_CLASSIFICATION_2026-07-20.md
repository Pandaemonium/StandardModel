# Literature map: origin-of-mass classification, the response-spectrum unifier, and the gap-to-pole boundary

Date: 2026-07-20
Role: Opus / Claude (interactive) - independent co-executor synthesis + review
Item: MASS-ORIGIN-001 (co-executor lane; complements Codex A0 construction)
Status: primary-source literature pass + mechanism-matrix scaffolding + proof-queue impact

This memo is the mass-side mirror of Codex's 3+1 literature memo
(`AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_3PLUS1_STAY_FLOQUET_2026-07-20.md`).
It supplies the source-grounded taxonomy that gate A0 (the origin-of-mass
mechanism matrix) requires but that no memo yet covers. It does not touch
Codex's MASS-ORIGIN-001 Lean construction; it feeds it.

## Search question

Is there an accepted classification of mass terms - by representation, symmetry
breaking, spectral response, or operator algebra - that can DEFINE the A0
mechanism class and its exhaustiveness scope, and where do the program's finite
mechanisms sit inside it? (Standing source question #1 of the mission.)

## Executive conclusion

Yes, and it splits into two literature pillars that jointly scope A0:

1. **The response-spectrum unifier already exists in the literature as the
   Connes-Chamseddine spectral action.** All Standard Model masses - fermion,
   gauge, Higgs - are encoded in ONE Dirac operator `D` on a spectral triple,
   with fermion masses the entries of the finite Dirac operator `D_F`, gauge and
   Higgs sectors the inner fluctuations `D_A = D + A + J A J^{-1}`, and symmetry
   breaking the choice of finite geometry `F` rather than an added-by-hand
   potential. This is precisely Codex's Visionary "each mechanism produces a
   response operator whose spectral scale obstructs gapless transport" thesis,
   and it is a decades-established formal anchor. Its lesson for the program:
   the Yukawa data are FREE entries of `D_F` constrained only by the
   first-order/order-one axioms and the representation content - which
   independently confirms the repository finding that `Y` in `flavorMassTerm Y`
   is an unconstrained matrix. The NCG framework therefore supports a MODULI
   reading of A2, not a uniqueness reading.

2. **Symmetric mass generation (SMG) is the boundary case that A0's
   exhaustiveness must name.** SMG gaps fermions WITHOUT any symmetry-breaking
   bilinear condensate, via anomaly-constrained interactions, producing a
   self-energy with a PROPAGATOR ZERO rather than a mass pole. It is a genuine
   mass mechanism that is NOT a single bilinear/quadratic response operator, so
   A0 must either add it as a row under an enlarged (quartic/interaction) class
   or scope it out with an explicit anomaly-free-multiplet hypothesis. SMG also
   sharpens the A4 gap-to-pole gate: a spectral gap that is a propagator zero is
   not a physical pole.

These two pillars bracket A0: the spectral action is the maximal unifier (one
operator, all masses) and SMG is the mechanism that escapes the bilinear-response
class the program currently uses.

## Kernel landing this pass (independent, Opus)

`PhysicsSM/Draft/NullEdge/GapPoleResponseObstruction.lean` -
`gap_does_not_fix_pole` (kernel-checked, standard three axioms). Two unitarily
conjugate Hermitian involutions of `C^2` - IDENTICAL spectrum `{-1,+1}`,
identical gap `2` - with physical two-point spectral weight `1` versus `0` at the
shared lower gap edge (the `physWeight = (1 - H)/2` Lagrange residue in the fixed
physical direction). The weight-`0` case is a genuine gap edge carrying no
physical pole - a finite realization of the SMG propagator-zero phenomenon. This
makes the A4 obligation exact: any "internal gap = physical mass" statement must
supply the physical-sector embedding as independent data, because the gap is
blind to it. Realizes Codex Visionary falsifier #4 as a theorem.

## Source map

### 1. The response-spectrum unifier: Connes-Chamseddine spectral action

- **A. H. Chamseddine, A. Connes, "Noncommutative Geometry as a Framework for
  Unification of all Fundamental Interactions including Gravity. Part I,"
  arXiv:1004.0464** [Neo4j 8HGA475I]. The spectral action `Tr f(D_A/Lambda)`
  plus the fermionic term generates the full SM + gravity Lagrangian from one
  Dirac operator. (chunk 0 confirms authorship/framing.)
- **A. Connes et al., "Gravity and the standard model with neutrino mixing,"
  arXiv:hep-th/0610241** (chunk 2): the Higgs is the inner fluctuation of `D`
  along the discrete direction, NOT added by hand; symmetry breaking is the
  choice of finite geometry `F`. This paper also carries NEUTRINO MIXING and the
  seesaw within the same `D_F`, directly relevant to gate A5.
- **"Renormalizing Yukawa interactions in the SM with matrices and NCG,"
  arXiv:1906.02297** (chunk 6, "The Spectral Action"): treats the Yukawa
  entries of `D_F` as the running data - explicit confirmation that Yukawas are
  free `D_F` parameters, not geometrically selected.
- Semi-Riemannian NCG thesis arXiv:1812.00038 (chunk 133) computes the bosonic
  and fermionic actions separately - a template for the A0 non-overlap
  (boson-sector vs fermion-sector) law.

Convention note before theorem-level use: NCG uses a Euclidean/Lorentzian
signature and a `J` real structure with the first-order axiom
`[[D,a],J b J^{-1}] = 0`; the program's `Gamma5F` chirality grading and the
`Y (x) 1_spin` turn are the finite-geometry off-diagonal block of `D_F`. Any
port must bridge the `J`/order-one axioms to the program's Kronecker grading;
consult chunk-level text before asserting an NCG theorem.

Proof-queue consequence: the spectral action is the correct LITERATURE ANCHOR
column for every A0 row and the formal-anchor target for the "response spectrum"
framing. It supports A2-as-moduli (Yukawas free, constrained by axioms +
representations) over A2-as-uniqueness.

### 2. Symmetric mass generation (the exhaustiveness boundary)

- **Y.-Y. Li, J. Wang, "Quantum Many-Body Lattice C-R-T Symmetry:
  Fractionalization, Anomaly, and Symmetric Mass Generation," arXiv:2412.19691**
  [Neo4j 9FFS4GFC] (chunks 0,1,51): SMG on staggered/lattice fermions; the
  gapping is symmetric and anomaly-gated, tied to CRT fractionalization.
- **N. Butt, S. Catterall et al., "Anomalies and symmetric mass generation for
  Kahler-Dirac fermions," arXiv:2101.01026** (chunk 0): Kahler-Dirac SMG - the
  Kahler-Dirac operator is geometrically the closest lattice analogue to the
  program's discrete-geometry Dirac/checkerboard spirit; worth a dedicated read
  for a possible null-edge SMG realization.
- **M. Golterman, Y. Shamir, "Constraints on the symmetric mass generation
  paradigm for lattice chiral gauge theories," arXiv:2505.20436**
  [Neo4j AV4P6E5X] (chunk 0): constraints/obstructions on SMG for chiral gauge
  theories - the honest counterweight; SMG is not unconstrained.
- **"Propagator zeros and lattice chiral gauge theories," arXiv:2311.12790**
  (chunk 7): the gapped fermion has a self-energy PROPAGATOR ZERO, not a mass
  pole - the analytic content behind my `gap_does_not_fix_pole` landing.
- **"CPT-Symmetric Kahler-Dirac Fermions," arXiv:2511.11548** [ZZCFUGH8]:
  related Kahler-Dirac symmetry structure.

Proof-queue consequence: A0 must declare its operator class as
BILINEAR/QUADRATIC RESPONSE and name SMG as the explicit out-of-scope
interaction-induced mechanism (anomaly-free-multiplet condition), OR add an
interaction row. Either way the exhaustiveness claim is only meaningful with SMG
named. This is the target of Aristotle job 93652564.

### 3. The textbook representation/symmetry classification (A0 backbone)

The standard mass-term taxonomy that defines the A0 rows (well established,
convention anchors only):

- Dirac mass: `Gamma`-odd off-diagonal `psibar_L M psi_R + h.c.`, needs both
  chiralities; representation: `L` and `R` in conjugate reps of the gauge group.
- Majorana mass: `psi^T C M psi`, needs a real/pseudoreal rep and violates the
  associated fermion number; the Weinberg dimension-5 operator
  `(L H)(L H)/Lambda` is its effective-field-theory origin.
- Seesaw (types I/II/III): a heavy state integrated out gives the light
  Majorana mass as a Schur complement `M_nu = -m_D M_R^{-1} m_D^T`.
- Gauge-boson mass: Higgs mechanism, mass^2 = gauge-orbit stiffness (Gram of
  generator images of the vacuum); the unbroken direction is the stabilizer.
- Higgs radial mass: potential Hessian `2 lambda v^2`.
- Composite/binding mass: a transfer-matrix spectral gap / correlation-decay
  rate on a gauge-invariant sector (lattice QCD).

These map ONE-TO-ONE onto the program's finite modules: `YukawaTurnAmplitude`
(Dirac turn), `GaugeMassGram` (orbit stiffness), `HiggsDoubletRadialCurvature`
(Hessian), and the pending neutrino Schur / SU(3) transfer rows. The
representation-theoretic legality conditions (which `Y` blocks are allowed) are
exactly the A2 moduli question (Aristotle job 37f6c2ac).

### 4. The composite/QCD bridge (A3) and the Kallen-Lehmann map (A4)

Second literature pass (2026-07-20) resolved the A3/A4 source anchors:

- **Osterwalder-Seiler, "Construction of a selfadjoint, strictly positive
  transfer matrix for Euclidean lattice gauge theories" (1977)**
  [Neo4j 99FVMMKD] is the rigorous finite A3 bridge: REFLECTION POSITIVITY
  yields a self-adjoint STRICTLY POSITIVE transfer matrix `T = e^{-a H}` with
  `H >= 0` on a physical Hilbert space, so a transfer spectral gap is a genuine
  Hamiltonian gap and equals the correlation-decay rate. This is exactly the
  "positive transfer operator or reflection-positive finite analogue" A3 asks
  for; it should be the source-audited API the A3 finite `SU(3)` bridge is built
  on. Companion: "Gauge field theories on a lattice" (1978) [SMH5768W].
- **Kallen-Lehmann spectral representation** (arXiv:1201.3415 [R3JICUIK] on RP
  and the KL representation of two-point functions; arXiv:2103.11846 [DPJ6N6WS]
  the SU(2) glueball KL representation) is the correlator-level A4 gap-to-pole
  map: the two-point function is an integral over a spectral density whose
  support/poles are the physical masses. CONSEQUENCE FOR THE LANDINGS: the
  `physWeight` in `gap_does_not_fix_pole` and the observable overlap in
  `transfer_gap_does_not_fix_correlation_mass` ARE the KL spectral weight at the
  gap edge. So the two Opus obstructions are precisely the finite statement that
  a spectral gap with vanishing KL weight (a propagator zero) is not a physical
  pole - the exact A4 semantic content, now tied to the standard framework.
- Recent (2025-2026) constructive YM mass-gap claims exist
  (arXiv:2606.19362 SU(N) [BH39WBRV]; arXiv:2506.00284 pure SU(3) [Q942D77M])
  but are unvalidated frontier work; the mission scopes the continuum gap as
  open, so cite these only as the target literature, not as settled input.
  Tomboulis-Yaffe SU(N) inequality (arXiv:0808.3442 [K9FIBTZC]) is the standard
  finite confinement/gap inequality tool. Overlap/GW massless quarks
  (hep-lat/9707022 [9H7HA39S]) anchor the chiral side.

Proof-queue consequence: A3's finite bridge = reflection positivity -> positive
transfer matrix (OS 99FVMMKD); A4's reconstruction = Kallen-Lehmann spectral
representation, and the Opus gap-to-pole landings are the finite KL-weight
obstruction. Check PhysLean / lean-quantum for an existing transfer-matrix or
spectral-measure API before fixing the A3/A4 Lean interface.

## Mechanism-matrix scaffolding (input to Codex A0)

Recommended A0 columns, per row: primitive data | symmetry / representation |
response operator (class) | positivity notion | gap observable | continuum
bridge | physical input (supplied, free) | prediction | formal anchor
(program module) | literature anchor | kill condition.

Recommended rows and their response-operator class:
1. Charged-fermion Dirac mass - `Gamma`-odd turn block - `YukawaTurnAmplitude` -
   anchor NCG `D_F` off-diagonal / Higgs mechanism.
2. Gauge-boson mass - PSD orbit Gram - `GaugeMassGram` - anchor Higgs mechanism.
3. Higgs radial mass - potential Hessian - `HiggsDoubletRadialCurvature`.
4. Neutrino Dirac / Majorana / seesaw - `Gamma`-odd map / Schur complement -
   anchor NCG neutrino mixing hep-th/0610241, Weinberg operator.
5. Composite/binding mass - transfer/correlation spectral gap - pending A3 -
   anchor lattice QCD reflection positivity.
6. Inertial/gravitational response - action variation under frame/metric -
   separate equivalence grade (A6).

Boundary (NOT a row unless class is enlarged): symmetric mass generation -
interaction-induced anomaly-gated gap / propagator zero - anchor SMG sources.

Non-overlap law (RESOLVED, kernel-checked, Aristotle job 93652564 returned +
independently verified, landed as
`PhysicsSM/Draft/NullEdge/MassResponseNonOverlap.lean`): the `Gamma`-odd turn
block (fermion mass, row 1) is Hilbert-Schmidt orthogonal to the `Gamma`-even
Gram and Hessian blocks (rows 2, 3), so row 1 cannot double-count against rows
2/3. IMPORTANT CORRECTION to the naive reading: evenness ALONE does NOT give
orthogonality - two even blocks (gauge Gram vs Higgs Hessian) need not be
Hilbert-Schmidt orthogonal (`even_even_not_orthogonal` is the exact
counterexample), so rows 2 vs 3 are separated NOT by parity but by TYPED DOMAINS
/ provenance (generator-image space vs scalar-normal fluctuation space, the
`HiggsTangentDecomposition` split). Additional returned findings: row 4
(neutrino) is the same `Gamma`-odd form as row 1 and needs a provenance
convention to avoid double-counting; exhaustiveness holds only relative to a
tagged response-witness class, under a precise Single-response-witness
hypothesis that EXCLUDES interaction-induced fermion gaps whose only witness is
a Green-function zero (SMG) - naming SMG as exactly the boundary, and tying it to
`gap_does_not_fix_pole` (gap data alone cannot distinguish poles, zeros,
binding, and SMG).

## Independent-review queue (Codex 3+1 headlines) - opened this pass

To audit next for vacuity / hidden inputs / false shape / physics overclaim
(cross-family required; Codex cannot self-certify):
- `HNUMassiveGlobalGap` - "global exclusion of both +1 and -1 crossings for
  0<a<pi": verify "global" is genuinely full Brillouin zone vs a sampled/endpoint
  claim; check the `0<a<pi` interval endpoints.
- `Strict3Plus1LocalityFrontier` - Wilson-Cayley strict-locality obstruction +
  corrected charge-balance frontier: confirm the obstruction is not vacuous and
  the "corrected" theorem is the intended shape (this integrates my B4
  Wilson-Cayley design; check semantic alignment).
- `IntrinsicRankFourDavisKahanBridge` - resolvent bridge: check the Davis-Kahan
  hypotheses (gap nonvacuity, self-adjointness) hold for the intended operator.
- `Spin10VacuumStabilizerBasisTwo` - basis-two affine-chart reductions: check the
  basis-two restriction is disclosed as a genuine scope limitation.

## Zotero / Neo4j / index status

- Neo4j READ reachable this pass; abstract and chunk retrieval worked for all
  cited papers. Keys recorded inline (8HGA475I, 9FFS4GFC, AV4P6E5X, ZZCFUGH8;
  others by arXiv ID).
- Zotero write NOT attempted this pass (Codex reported `WinError 10061` refusal
  on 2026-07-20; treat as source-ingestion debt). New high-value records owed:
  hep-th/0610241, 1906.02297, 2101.01026, 2311.12790, 2505.20436, and the NCG
  Part I 1004.0464 confirmation. Deduplicate on arXiv ID before adding.
- Neo4j paper/doc index refresh owed after this memo lands (doc search would not
  yet find it).

## Proof-queue impact (concrete changes)

1. A2 should be reframed as a MODULI/classification gate, not uniqueness: the
   Yukawa data are free `D_F` entries (NCG) and free `Y` (repo), so
   "uniquely represented by Pluecker" is false without extra
   gauge-equivariance/grading hypotheses. (Job 37f6c2ac.)
2. A0 exhaustiveness is only well-posed with the operator class declared as
   bilinear/quadratic response and SMG named as the boundary. (Job 93652564.)
3. A1 shared-Higgs: test whether the fermion map factors through the vacuum
   VECTOR or only the scalar `v`; if only `v`, "shared data" is weaker than
   advertised. (Job cda24762.)
4. A4 gap-to-pole now has a kernel obstruction (`gap_does_not_fix_pole`): the
   reconstruction ladder MUST carry the physical-sector overlap; the SMG
   propagator-zero case is the extremal witness.
5. A5 neutrino: NCG hep-th/0610241 is the source anchor for the Majorana/seesaw
   branch inside one Dirac operator.

## Next actions (dependency order)

1. Round the Aristotle audit fleet to >= 5 (add: gap-to-pole resolvent/transfer
   extension; and either the non-overlap Lean lemma or the HNU global
   counterexample-search once the semantic audit finds a candidate).
2. Independent semantic audit of the four Codex 3+1 headlines above (read
   modules; escalate concrete candidates to Aristotle).
3. Dedicated lattice-QCD transfer-matrix literature pass for A3 (reflection
   positivity, transfer gap <-> correlation decay <-> pole).
4. Feed this mechanism-matrix scaffold to Codex A0 via mailbox (done: notice
   msg-20260720-071648).
5. Zotero ingestion of the six owed records when the connection is restored;
   refresh Neo4j indexes.
