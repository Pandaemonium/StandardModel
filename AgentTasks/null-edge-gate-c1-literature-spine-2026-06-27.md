# Gate C1 literature spine: overlap, flavored mass, domain wall, locality, anomaly

Date: 2026-06-27
Status: Added/verified in Zotero and mirrored into Neo4j collection `Null Edge Gate C1 overlap references` (`9WIG8WGR`).

## Why this matters

The current Gate C1 operator ansatz is best understood as a null-edge version of a known overlap/Ginsparg-Wilson construction:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

The literature spine says we should not invent a new regulator for novelty. We should interpret `W_branch` as a null-edge analogue of a flavored/species-splitting Wilson term and import as much as possible from overlap, domain-wall, and staggered-overlap fermions.

## Reference spine and project role

### Core overlap/Ginsparg-Wilson construction

- Ginsparg and Wilson, "A remnant of chiral symmetry on the lattice" (`XM6QTH2P`, DOI `10.1103/PhysRevD.25.2649`): original GW relation.
- Neuberger, "Exactly massless quarks on the lattice" (`9H7HA39S`, arXiv `hep-lat/9707022`): overlap operator construction.
- Neuberger, "More about exactly massless quarks on the lattice" (`R8NJ8GQN`, arXiv `hep-lat/9801031`): overlap/GW algebra.
- Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation" (`N68MN4ET`, arXiv `hep-lat/9802011`): exact lattice chiral symmetry from GW.

Gate C1 use: treat the overlap/GW algebra as the reference interface. Once a null-edge kernel gives a gapped sign involution, the GW/projector algebra follows.

### Locality and admissibility

- Hernandez, Jansen, and Luscher, "Locality properties of Neuberger's lattice Dirac operator" (`BEG87SU5`, arXiv `hep-lat/9808010`): locality of the overlap operator under admissibility/smoothness assumptions.

Gate C1 use: this is the standard locality/admissibility template. Our preferred combinatorial path-sum decay should be compared to or used as a null-edge version of this locality theorem.

### Index and anomaly import

- Hasenfratz, Laliena, and Niedermayer, "The index theorem in QCD with a finite cut-off" (`KP6NKZ4M`, arXiv `hep-lat/9801021`): finite-cutoff index theorem.
- Kikukawa and Yamada, "Weak coupling expansion of massless QCD with a Ginsparg-Wilson fermion and axial U(1) anomaly" (`WKGCSCKT`, arXiv `hep-lat/9806013`): anomaly behavior for GW/overlap fermions.

Gate C1 use: anomaly/index behavior should be imported through a gapped homotopy to a standard overlap/domain-wall construction where possible.

### Flavored-mass / matrix-valued Wilson analogues

- Adams, "Pairs of chiral quarks on the lattice from staggered fermions" (`FB5USF4N`, arXiv `1008.2833`): staggered-overlap/flavored-mass construction.
- Adams, "Index and overlap construction for staggered fermions" (`WDI4V5QN`, arXiv `1103.6191`): index and overlap construction in the staggered/flavored setting.
- Hoelbling, "Single flavor staggered fermions" (`RUEV6CJD`, arXiv `1009.5362`): single-flavor staggered Wilson direction.
- Misumi, "New fermion discretizations and their applications" (`F28KTBA5`, arXiv `1211.6999`): review of flavored-mass and new lattice discretizations.

Gate C1 use: `W_branch` should be developed as a null-edge flavored/species-splitting mass term, not as an arbitrary correction. This is the closest literature match to the branch-Pauli/qutrit finite seed.

### Domain-wall and import-mode fallback

- Kaplan, "A Method for Simulating Chiral Fermions on the Lattice" (`2QXTHNTN`, arXiv `hep-lat/9206013`): domain-wall fermion foundation.
- Kikukawa, "Domain wall fermion and chiral gauge theories on the lattice with exact gauge invariance" (`N66TWUXG`, arXiv `hep-lat/0105032`): domain-wall/chiral gauge exact-gauge-invariance route.
- Kaplan, "Chiral Gauge Theory at the Boundary between Topological Phases" (`A98U2E8B`, arXiv `2312.01494`): modern topological-boundary framing.

Gate C1 use: if native null-edge overlap cannot be completed, import mode should be domain-wall/topological-boundary first, not an ad hoc mirror-decoupling construction.

### Warnings and failure modes

- Golterman and Shamir, "Propagator zeros and lattice chiral gauge theories" (`8NRUZ46K`, arXiv `2311.12790`): propagator zeros act like ghost states when gauge fields are turned on.
- Poppitz and Shang, "Chiral Lattice Gauge Theories Via Mirror-Fermion Decoupling: A Mission (im)Possible?" (`WPPE5WBW`, arXiv `1003.5896`): mirror-decoupling pitfalls and anomaly constraints.

Gate C1 use: enforce the no-propagator-zero rule. Mirrors/bad branches must be removed by true inverse-propagator gaps or a standard overlap/domain-wall mechanism.

## Zotero and Neo4j status

Created Zotero collection:

```text
Null Edge Gate C1 overlap references
collection_key: 9WIG8WGR
```

Zotero additions in this pass:

```text
9H7HA39S  Neuberger 1997
R8NJ8GQN  Neuberger 1998
BEG87SU5  Hernandez-Jansen-Luscher 1998
KP6NKZ4M  Hasenfratz-Laliena-Niedermayer 1998
WKGCSCKT  Kikukawa-Yamada 1998
FB5USF4N  Adams 2010
WDI4V5QN  Adams 2011
RUEV6CJD  Hoelbling 2010
F28KTBA5  Misumi 2012
2QXTHNTN  Kaplan 1992
N66TWUXG  Kikukawa 2001
WPPE5WBW  Poppitz-Shang 2010
XM6QTH2P  Ginsparg-Wilson 1982
A98U2E8B  Kaplan 2023
```

Already present in Zotero and mirrored/linked in Neo4j:

```text
N68MN4ET  Luscher 1998
8NRUZ46K  Golterman-Shamir 2023
```

Neo4j status: all 16 references were upserted as `Paper` nodes and linked to collection `9WIG8WGR`, with role tags such as `overlap-fermions`, `ginsparg-wilson`, `overlap-locality`, `flavored-mass`, `domain-wall-fermions`, `overlap-anomaly`, and `ghost-warning`.

## New Aristotle jobs suggested by the literature spine

1. Adams/flavored-mass translation: map `W_branch` to staggered-overlap/flavored-mass species splitting.
2. Locality/admissibility bridge: compare Hernandez-Jansen-Luscher locality to null-edge combinatorial path-sum control.
3. Domain-wall import-mode contract: map Kaplan/Kikukawa domain-wall constructions to the null-edge branch/kernel interface.
4. Propagator-zero ghost audit: turn Golterman-Shamir into a formal no-zero-removal checklist for Gate C1.
