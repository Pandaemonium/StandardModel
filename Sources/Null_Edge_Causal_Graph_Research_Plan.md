# Null-edge causal graph program: literature-grounded research plan

Companion to [`Null_Edge_Causal_Graph_Strengthened_Program.md`](Null_Edge_Causal_Graph_Strengthened_Program.md)
and the bibliography [`Null_Edge_Causal_Graph_Bibliography.md`](Null_Edge_Causal_Graph_Bibliography.md).

**Compiled:** 2026-06-21.
**Library:** Zotero collection "Null-Edge Causal Graph Program" (`9W59V3K9`) and the
Neo4j `coglab` graph (`Collection {collection_key:"9W59V3K9"}`). ~79 papers, tagged
`null-edge-program` plus per-pillar cluster tags.
**Method note:** searches run through the `scholarly` MCP server (INSPIRE-HEP and
OpenAlex backends); see [`../Scripts/MCP_SERVERS.md`](../Scripts/MCP_SERVERS.md).

## How to read this plan

For each pillar: **(i)** the anchor literature now in the library, **(ii)** what it
buys us, **(iii)** the concrete next Lean target (with proposed module/lemma names),
and **(iv)** the falsification hook. The discipline of the program is preserved:
finite, kernel-checkable algebra/combinatorics first; continuum physics stays an
explicitly conjectural layer.

The repo already has theorem islands to build on:
`PhysicsSM.Spinor.Checkerboard`, `PhysicsSM.Draft.SpinCoherentProjectorAristotle`,
`PhysicsSM.Draft.WeylCliffordBridgeAristotle`,
`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`,
`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle`.

## New synthesis: the bivector/BF spine

Claude's bivector note gives a useful integration principle: do not treat
the Plucker mass theorem and the causal-diamond holonomy theorem as unrelated
islands. Treat them as two finite shadows of a `Lambda^2`-valued object on
the null-edge graph.

The conservative version is:

```text
Bivector cochain B:
  mass sector   = simplicity defect / Gram determinant of a null-spinor fan
  gauge sector  = pairing of B with a diamond curvature defect
  gravity route = long-horizon Plebanski/BF interpretation, not yet a theorem
```

This is sharp because it turns "mass from null spread" and "curvature from
diamond disagreement" into one finite algebraic vocabulary. It also keeps
the speculative part in the right place: Plebanski gravity, Urbantke metric
reconstruction, and simplicity constraints are continuum/self-dual two-form
technology; the repo should first formalize the finite wrapper, then only
later ask whether the continuum interpretation survives.

**Reference anchors to add or cite defensively.**

- Plebanski/Krasnov self-dual two-form formulation: Krasnov `0904.0423`.
- Gravity/Yang-Mills/Higgs from enlarged Plebanski-type gauge group:
  Torres-Gomez-Krasnov `0911.3793`; Krasnov `1112.5097`; Smolin `0712.0977`.
- Energetic causal sets as the closest edge-momentum causal-set precedent:
  Cortes-Smolin `1308.2206`, `1307.6167`, `1407.0032`.
- Topological/Kahler-Dirac graph mass-gap precedent:
  Bianconi `2106.02929`, `2309.07851`.

**Claim boundary.** The finite novelty remains the kernel-checkable
Plucker/holonomy package and its graph-native synthesis. The continuum claim
"one two-form unifies gravity, Yang-Mills, and Higgs" has substantial prior
art in Krasnov/Smolin-style Plebanski programs. The null-edge program's
defensible angle is the finite causal-graph, Plucker-mass, and Lean-verified
version of the story.

**New Lean targets.**

- `NullEdgeBivector`: define the finite `B` wrapper whose local components are
  spinor wedges or diamond surface labels.
- `bivector_massDefect_eq_plucker`: identify the `B` simplicity/Gram defect
  with `finPairwisePluckerMassReal`.
- `bivector_pairing_respects_diamond_composition`: show that the finite
  `B`-weighted diamond pairing is compatible with the already-proved
  vertical and horizontal path-pair composition laws.
- `topological_dirac_sq_eq_laplacian`: extend the cochain seed toward the
  Bianconi/Kahler-Dirac finite operator.
- `gapped_topological_dirac_sq`: for a finite matrix model, prove that adding
  a chiral mass term gives the expected algebraic square when the anticommutator
  hypotheses are explicit.

**Caveats.**

- In Lorentzian signature, self-dual two-forms are naturally complex; any
  Urbantke/Plebanski interpretation needs explicit reality conditions.
- The QGT/Berry-curvature analogy is interesting but should stay a numerical
  or conceptual pilot until it produces a finite theorem or a source-backed
  model.
- AHH massive spinor-helicity already owns the two-spinor on-shell mass
  identity. Our trusted theorem is the finite `n`-edge Cauchy-Binet bundle
  identity and its graph interpretation.

---

## Observable-relative nullity as a diagnostics layer

The graph-theoretic "null edges as kernels" note is useful, but it should be
integrated as an API/diagnostics layer rather than as a new physics pillar. The
safe definition is:

```text
Given a graph observable F, an edge or chain x is F-null when deleting,
contracting, quotienting, or gauge-normalizing x has zero effect on F.
Approximate F-nullity measures small effect on F.
```

This clarifies why no single definition of "null edge" should be expected.
The same edge can be connectivity-null, spectrally visible, quotient-null after
coarse-graining, gauge-null up to a vertex phase, or homology-null only as part
of a chain. That fits the program's existing theorem spine: Plucker mass is an
observable on null-spinor bundles, causal-diamond defects are observables on
path pairs, and order-complex cohomology sees chains rather than isolated
edges.

**2026-06-21 Zotero/Neo4j additions.** Added `UFHN99H4` (Spielman-Srivastava
effective-resistance sparsification), `N7T76U5H` (Schaub-Benson-Horn-Lippner-
Jadbabaie normalized Hodge 1-Laplacian), `33X7ZETB` (Roddenberry-Frantzen-
Schaub-Segarra Hodgelets), `FNP9V3DT` (Lange-Liu-Peyerimhoff-Post magnetic
Laplacians), `GNEARI9Q` (Fabila-Carrasco-Lledo-Post magnetic Laplacian
matrices), and `S78BASEN` (Kannan-Kumar-Pragada gain-graph Laplacians). All are
tagged `observable-relative-nullity` in the library/graph.

**Lean targets this suggests.**

- `quotient_incidence_internal_edge_eq_zero`: an edge internal to a quotient
  block maps to zero incidence in the quotient operator.
- `exact_one_cochain_has_trivial_cycle_holonomy`: an exact Abelian 1-cochain
  has trivial holonomy on every cycle.
- `tree_phase_assignment_is_gauge_trivial`: phases supported on a spanning
  tree can be removed by a vertex gauge transformation.
- `homology_null_boundary_chain`: a boundary chain is zero in homology, so
  topological nullity is naturally chainwise rather than edgewise.
- `laplacian_rankOne_modeShift`: first-order shift of a simple Laplacian
  eigenvalue under an edge update is the squared endpoint difference of the
  eigenmode.

**Claim boundary.** Connectivity and matroid nullity are standard graph theory,
and spectral/gauge/homology nullity have mature literatures. The project should
claim the observable-relative language as a useful organizing convention for
the null-edge causal graph program, not as a new discovery of those standard
notions.

---

## Pillar 1 — Mass as a Plucker spread of null spinors

**Literature (tags `mass-twistor`, `massive-spinor-helicity`).**
Modern massive spinor-helicity gives the cleanest target: Arkani-Hamed-Huang-Huang
*Scattering Amplitudes for All Masses and Spins* (`1709.04891`) writes a massive
momentum as a little-group-covariant pair of spinors — exactly the
`P^{AA'} = sum_i psi_i^A bar psi_i^{A'}` picture. The two-twistor mass models
(de Azcarraga `hep-th/0510161`, `1409.7169`; Bette `hep-th/0405166`; Bars single-twistor
`hep-th/0512091`; Albonico `2203.08087`; Kim `2102.07063`) realize mass as a two-twistor
invariant. Okano-Kugo's no-go theorem (`1606.01339`) bounds how far the n-twistor
description can be pushed. Dittmaier `hep-ph/9805445` and Ni `2501.09062` give the
Weyl-van der Waerden / helicity-chirality bookkeeping.

**What it buys us.** A finite-dimensional linear-algebra keystone: the determinant
identity `det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2`, mass as
total pairwise Plucker spread, zero iff collinear.

**Next Lean target.** New trusted module `PhysicsSM/Spinor/PluckerMass.lean`, building
on `SpinorHelicityRankOneAristotle`:
- `complex_plucker_mass_identity` : `det (∑ i, ψ i • (ψ i)ᴴ) = ∑ i j, ‖ψ i ∧ ψ j‖²` (i<j),
- `complex_plucker_mass_nonneg`,
- `complex_plucker_mass_eq_zero_iff_collinear`.
Then a matching lemma to the two-twistor mass invariant (`twistor_mass_eq_plucker`),
scoped to the spinor chart only — no full Penrose transform.

**Status update, 2026-06-21.** `PhysicsSM.Spinor.PluckerMass` now promotes the
finite determinant identity, the real-valued nonnegativity wrapper, and the
mass-zero/common-direction criterion to a trusted no-sorry module. The
remaining Pillar 1 work is the twistor-incidence interpretation layer.

**Falsification.** Failure of the determinant identity, or mismatch with the physical
invariant-mass convention `m^2 = det P`.

---

## Pillar 2 — Chirality flips and checkerboard / quantum-walk universality

**Literature (tags `checkerboard`, `quantum-walk`).**
The 1+1 core is well covered (Foster 4D checkerboard `1610.01142`, D'Ariano-Perinotti
Dirac QCA `1406.1021`, Earle `1012.1564`). For the higher-dimensional and universality
question: Bialynicki-Birula *Dirac and Weyl equations on a lattice as QCA*
(`hep-th/9304070`), Meyer QCA-to-lattice-gas (`quant-ph/9604003`), the Arrighi
honeycomb/curved-spacetime walks (`1803.01015`, `1505.07023`), Mlodinow-Brun
(`1802.03910`, `2006.08927`), Marquez-Martin fermion confinement via QW in 2D+1/3D+1
(`1612.08027`), Chandrashekar multi-dim Dirac walks, and Kauffman discrete physics
(`hep-th/9603202`). 't Hooft's deterministic CA (`1992`) anchors the discrete-determinism angle.

**What it buys us.** Concrete higher-dimensional walk constructions whose continuum
limits are Dirac/Weyl — the evidence base for the chirality-flip universality
conjecture (`m_eff = C * nu`).

**Next steps.** (a) Promote the no-sorry endpoint-kernel closed forms from
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` into the trusted
checkerboard theorem surface after a semantic/documentation audit. (b) State
the universality conjecture precisely as a renewal/random-history statement
(Stage-2 paper, not yet Lean). (c) Numerical pilot:
isotropic null-edge flip ensemble dispersion relation (oracle script, justifies tests
not theorems).

**Falsification.** Isotropic flip ensembles fail to flow to a Dirac dispersion, or
`m_eff` depends non-universally on microscopic flip distribution details.

---

## Pillar 3 — Higgs as permission for chirality flips

**Status.** Literature search returned mostly phenomenology, not the conceptual target;
this pillar is best served by the repo's own Standard Model representation modules
(`PhysicsSM.StandardModel.Representations`, `.Bosons`, and the Furey electroweak packages)
rather than new external papers.

**Next Lean target.** Representation bookkeeping, not dynamics:
`yukawa_vertex_hypercharge_neutral` and `higgs_permits_left_right_flip` — prove the
hypercharge neutrality of a `Ψ_L ⊗ H → Ψ_R` vertex from existing charge assignments.

**Falsification.** Representation bookkeeping fails to match SM Yukawa quantum numbers.

---

## Pillar 4 — Twistor incidence as the continuum target

**Literature (tag `mass-twistor`).** The two-twistor models above plus Bars'
single-twistor multi-sector description (`hep-th/0512091`) give the incidence machinery.

**Next step.** A narrow source note / Lean draft `TwistorPluckerMass`: define only the
spinor part of the two-twistor invariant, record `SL(2,C)` / dotted-undotted / signature
conventions, and prove the reduction to `|psi_1 ∧ psi_2|^2`. Defer Penrose transform and
twistor cohomology.

**Status update, 2026-06-21.** `PhysicsSM.Draft.TwistorPluckerMass`
now provides this narrow spinor-chart wrapper, with a companion hand-proof
note in `Twistor_Plucker_Matching_Wrapper_2026-06-21.md`. It also records the
explicit convention bridge between `m^2 = det(P)` and the common
trace-pairing convention `P^2 = 2 det(P)`. It is no-sorry draft code, but
remains draft-facing because it is convention packaging rather than a full
twistor-incidence formalization.

**Falsification.** The two-twistor mass invariant does not reduce to the Plucker term,
or incidence reconstruction needs extra non-null structure.

---

## Pillar 5 — Causal-diamond holonomy instead of plaquettes

**Literature (tags `causal-set-gauge`, `higher-gauge`, `spin-foam`, `discrete-gravity`).**
Sverdlov *Gauge Fields in Causal Set Theory* (`0807.2066`) and *Bosonic Fields*
(`0807.4709`) are the direct precedent for gauge fields on causal sets. Baez *Higher
Yang-Mills* (`hep-th/0206130`) and *Teleparallel Gravity as Higher Gauge Theory*
(`1204.4339`) supply the 2-connection language for the diamond/higher-gauge upgrade.
Spin foams (Baez intro `gr-qc/9905087`, Livine-Oriti causality `gr-qc/0210064`) and
Regge/simplicial dynamics (Dittrich `0807.2806`) are the adjacent discrete gauge-gravity
methods.

**Next Lean target.** Finite + Abelian first:
`PhysicsSM/Draft/CausalDiamondHolonomy.lean` — a finite DAG diamond, two paths, edge
labels in an abelian group, `path_holonomy` as edge-label product, vertex gauge
transformations, and `holonomy_defect_gauge_invariant` (endpoints fixed). Keep the
continuum Stokes statement as documented interpretation only.

**Status update, 2026-06-21.** The finite Abelian target has been promoted to
trusted code as `PhysicsSM.Gauge.CausalDiamondHolonomy`. The same trusted
module also proves the non-Abelian endpoint-conjugation law and class-function
gauge invariance. It now also contains a path-pair abstraction for glued
diamonds, with vertical and horizontal composition laws for the holonomy
defect and the Abelian multiplication specialization. Literature additions
from this pass: Wilson `QDII2KHM` in Neo4j, plus Zotero keys `AHK54SN9`,
`K9XTAJUM`, and `Z38RZX2Q` for higher-gauge/surface-holonomy context.

**Falsification.** Path-comparison defects are not gauge invariant, or their continuum
limit fails to reproduce field strength.

---

## Pillar 6 — Gravity through null-horizon thermodynamics

**Literature (tag `spacetime-thermodynamics`).** Jacobson's seminal `gr-qc/9504004`
and entanglement-equilibrium `1505.04753`, Eling-Guedens-Jacobson `gr-qc/0602001`,
Padmanabhan `1312.3253`, Verlinde `1001.0785`, Wald-Noether-charge entropy
`gr-qc/9307038`, Bekenstein bound `quant-ph/0311049`, the null Raychaudhuri equation
(Bak `2312.17214`), and Swingle's *Spacetime from Entanglement* review
(`10.1146/annurev-conmatphys-033117-054219`).

**Next steps (finite observables first).** Define, on a finite causal graph:
edge-crossing count for a screen, null momentum flux through a cut, and nested-diamond
coarse-graining. The continuum Clausius/Raychaudhuri derivation stays a long-horizon
conjecture (links to the Benincasa-Dowker curvature route in Pillar 8).

**Falsification.** Edge-count entropy and momentum flux do not yield
Raychaudhuri/Clausius behavior under coarse-graining.

---

## Pillar 7 — Fermions through order complexes and Kahler-Dirac structure

**Literature (tags `dirac-kahler`, `discrete-geometry`, `lattice-fermion`).**
Becher-Joos *Dirac-Kahler Equation and Fermions on the Lattice* (`10.1007/BF01614426`)
is the foundation; Kanamori (`hep-lat/0309120`) and Watterson (`0706.4385`) give the
chiral/flavour projection. The discretization toolkit: Desbrun *Discrete Exterior
Calculus* (`math/0508341`), Arnold-Falk-Winther *Finite Element Exterior Calculus*
(`10.1017/s0962492906210018`), Leopardi *Abstract Hodge-Dirac Operator and its Stable
Discretization* (`10.1137/15m1047684`). The doubling obstruction is Nielsen-Ninomiya
(`10.1016/0550-3213(82)90011-6`) with the Ginsparg-Wilson resolution (Luscher
`hep-lat/9802011`); Aoki lattice Weyl (`2402.09774`) for the chiral-surface angle.

**What it buys us.** A graph-native home for graded fermionic data via `d + delta` on the
order complex, with a clear-eyed view of the doubling problem it must navigate.

**Next Lean target.** Finite combinatorics:
`PhysicsSM/Draft/OrderComplex.lean` — chains in a finite poset, coboundary operator,
`coboundary_sq_eq_zero` (`d^2 = 0`); then `PhysicsSM/Draft/KahlerDiracGraph.lean` for the
`d + delta` operator. Becher-Joos and Leopardi fix the conventions.

**Falsification.** The graph cochain operator cannot reproduce a Weyl/Dirac continuum
sector without reintroducing hidden lattice structure (the Nielsen-Ninomiya trap).

---

## Pillar 8 — Causal-set foundations and discrete fields

**Literature (tag `causal-set`).** Foundations: Bombelli-Lee-Meyer-Sorkin
(`10.1103/PhysRevLett.59.521`), the Surya Living Review (`1903.11544`), Henson review
(`gr-qc/0601121`), Bombelli *Discreteness without symmetry breaking* (`gr-qc/0605006`),
Rideout-Sorkin sequential growth (`gr-qc/9904062`), Sorkin *Light, Links and Causal Sets*
(`0910.0673`). Fields/curvature: Benincasa-Dowker scalar curvature (`1001.2725`), Johnston
propagators (`0909.0944`, `1010.5514`), BDG continuum limit (`2007.13192`), spectral
dimension (Eichhorn `1311.2530`).

**Role.** This is the ambient discrete-causal setting. The near-term, repo-faithful
contribution is the *finite* order-complex and diamond-holonomy machinery (Pillars 5, 7);
causal-set Dirac propagators and the d'Alembertian are Stage-4 continuum targets.

---

## Pillar 9 — Quantum measure, histories, and the Bell/Tsirelson question

**Literature (tag `quantum-measure`).** Sorkin *Quantum mechanics as quantum measure
theory* (`gr-qc/9401003`) and *Quantum dynamics without the wave function*
(`quant-ph/0610204`) formalize the decoherence-functional / quantum-measure view that the
program's "quantum measure over causal histories" needs. (Tsirelson-bound search returned
mostly fringe results; revisit with a targeted, authenticated query later.)

**Falsification.** The decoherence functional cannot produce quantum correlations while
preserving operational no-signalling and strong positivity.

---

## Internal algebra layer (context, not spacetime)

**Literature (tag `internal-algebra`).** Kept deliberately light because the repo already
formalizes much octonion/Furey/Spin(10)/E8 content. Singh *Trace dynamics and division
algebras* (`2009.05574`) is a useful bridge between the internal algebra and a quantum-gravity
/ unification narrative. The program's stance holds: octonions/triality label internal
transition rules, not observed spacetime coordinates.

---

## Sequenced work plan (literature-grounded)

**Stage 0 — conventions.** One convention table (signature, Pauli matrices, spinor
indices, twistor incidence, checkerboard corner weight, hypercharge). Done before any new
trusted physics claim.

**Stage 1 — finite Lean theorems (kernel-checkable, no analysis):**
1. Promote the no-sorry checkerboard endpoint-kernel closed forms after
   semantic audit.
2. Promote `SpinCoherentProjectorAristotle` and `WeylCliffordBridgeAristotle`.
3. `PluckerMass.lean`: identity, nonnegativity wrapper, and collinearity are
   now trusted; add twistor chart matching (Pillar 1).
4. `yukawa_vertex_hypercharge_neutral` (Pillar 3).
5. `PhysicsSM.Gauge.CausalDiamondHolonomy`: finite Abelian gauge invariance,
   non-Abelian endpoint covariance, and class-function invariance are now
   trusted; vertical and horizontal path-pair composition laws are now
   trusted; next develop the 2-categorical/higher-gauge wrapper (Pillar 5).
6. `OrderComplex.lean`: `d^2 = 0` (Pillar 7).
7. `NullEdgeBivector`: draft a finite `B`-cochain wrapper tying Plucker
   mass defects to diamond surface pairings, with the continuum BF/Plebanski
   reading kept in comments/prose only.
8. `KahlerDiracGraph`: build the finite topological Dirac operator from the
   cochain seed, then prove `D^2 = Laplacian` and the algebraic chiral
   mass-gap square under explicit adjoint/anticommutation hypotheses.
9. `ObservableNullity`: package the quotient, exact-cochain, tree-gauge,
   boundary-chain, and rank-one spectral-nullity lemmas as diagnostics for
   finite graph observables.

**Stage 2 — finite-dimensional synthesis:** two-twistor/Plucker spinor-chart
matching is now drafted; next package the null-step projector + Plucker mass
theorems with the bivector/BF wrapper, state the chirality-flip universality
conjecture precisely, and write an expository paper tying Lean results to
checkerboard / Foster-Jacobson / energetic-causal-set / Plebanski-BF
literature.

**Stage 3 — numerical/probabilistic pilots (oracle scripts):** isotropic flip-ensemble
dispersion; effective-mass universality test; abelian diamond holonomy on random diamonds;
graph observables vs expected curvature/flux; QGT/Fubini-Study mass-spread and
Berry-curvature diagnostics on the celestial `CP^1` direction space; approximate
spectral/gauge/homology nullity signatures for coarse-graining pilots.

**Stage 4 — long-horizon continuum:** causal-set Dirac propagator (Johnston route);
diamond-holonomy continuum limit; higher-gauge 2-connection over diamonds;
Plebanski/Urbantke reality-condition analysis for the bivector wrapper;
null-horizon Clausius derivation; decoherence-functional Bell/Tsirelson analysis.

## Falsification ledger

Maintained in the strengthened-program note; each pillar above lists its failure mode.
Every new conjecture must enter the ledger before it is promoted from prose to a Lean target.

## Using the tooling going forward

- **Search:** `python Scripts/mcp/mcp_call.py scholarly search-inspirehep --args '{"query":"...","limit":8}'`
  (avoid `search-papers` until a Semantic Scholar key is set — its SS leg 429s).
- **Add to Zotero:** `zotero_add_item_by_arxiv` / `zotero_add_item_by_doi` with
  `collection_key:"9W59V3K9"` and tags.
- **Graph:** new papers are synced into the `coglab` Neo4j graph as `Paper` nodes linked
  `IN_COLLECTION` to `9W59V3K9`, with `AUTHORED_BY`/`HAS_TAG`. Query relevance with
  `read-cypher`; a future enrichment pass can add `Concept`/`ABOUT` links per pillar.
