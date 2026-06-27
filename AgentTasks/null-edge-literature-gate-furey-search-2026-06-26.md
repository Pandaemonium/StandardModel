# Null-edge literature search: Gate C and Furey finite-layer clues - 2026-06-26

Purpose: targeted literature pass for the active blockers after Wave 14/15:
post-gauge ghost safety, nodal-set exhaustion, canonical/Krein branch selection,
Furey `Phi_H`, number-parity `chi_E`, `Jbar`/conjugate-ideal bridges, and
Yukawa/intertwiner prediction language.

## Search/curation status

Semantic Scholar/arXiv API calls were rate-limited during the interactive pass,
so metadata for new papers was pulled from arXiv web pages and records were added
manually to Zotero, then mirrored into Neo4j using the same `Paper` node shape as
`Scripts/lit/lit_ingest.py`. The Neo4j paper embedder was run afterward.

Already curated before this pass:

| arXiv | Paper | Why it remains important |
|---|---|---|
| 2311.12790 | Golterman-Shamir, propagator zeros and lattice chiral gauge theories | Keeps ghost-zero safety as an independent Gate C clause. A flavored index is not enough. |
| 1611.08388 | Weber, QCD with flavored minimally doubled fermions | Template for flavored mass and no-fine-tuning arguments, but does not fix the split coefficient. |
| 2112.13501 | Yumoto-Misumi, lattice fermions as spectral graphs | Template for spectral-graph zero-locus classification. |
| 2505.07923 | Furey, graded superalgebra of lightest SM particles | Supports a grading/parity view of the Furey internal layer. |

Newly added to Zotero/Neo4j in this pass:

| arXiv | Zotero key | Main tag lane | Use |
|---|---|---|---|
| 2311.11320 | Z2DPSX6K | graph-dirac, gate-c | Graph-matrix/lattice-operator dictionary for C64 nodal-set work. |
| 2206.06912 | EPT6PUTC | furey-internal, chi-e | Octonionic internal complex structure; useful but not identical to electroweak `chi_E`. |
| 2210.10126 | CZJ5T2J3 | furey-internal, higgs, triality | Division-algebraic symmetry breaking and left-right Higgs representations; best clue for `Phi_H` representation carrier. |
| 1906.02297 | SHPRQMGH | finite-spectral-triple, yukawa | Matrix-Yukawa duality and finite spectral triple renormalization; useful for FUR-H10 dimension/modulus audit. |
| 2602.19767 | RCFWIVSS | gate-c, flavored-chirality, index-anomaly | Four-dimensional MDF index theorem using flavored mass and modified chirality. Strong Route-B support. |
| 2502.07354 | HU6CCST9 | gate-c, taste-breaking, counterterm | KW taste breaking and tree-level improvement; reinforces counterterm/tuning caution. |
| 2409.15024 | CIQCUN6I | gate-c, eigenvalue, taste-breaking | Eigenvalue-pair splitting diagnostic for would-be zero modes and residue/ghost-safety audits. |
| 2003.10803 | MRHI9RJM | gate-c, dispersion, species-split | KW/BC dispersion and spectral range as a function of lifting parameter `r`. |

## Analysis by blocker

### Gate C projected release

The literature strongly supports the project shift from bare branch chirality to
Route B: projection plus flavored mass/splitting plus modified chirality. The new
2026 four-dimensional MDF index paper is especially on-point: topology and
zero-mode chirality are detected only after flavored mass and modified chirality
are introduced. This matches our Lean result that the bare Clifford symbol has a
chirality-balanced kernel and needs projection.

The next proof obligations should be stated in the vocabulary of
`NullEdgeProjectedGateCRelease`:

1. projected branch projectors,
2. one-dimensional projected kernels,
3. modified/flavored chirality alignment,
4. Krein-positive retained sector,
5. ghost-zero safety,
6. species-splitting audit,
7. controlled determinant-zero locus.

A useful publication phrase is: "Gate C is released only after the projected,
flavored, ghost-safe sector is constructed." Avoid saying the flavored index
alone solves doubling.

### Ghost safety and residue diagnostics

Golterman-Shamir remains the controlling warning: propagator zeros can carry
anomaly-like information while still behaving as ghost states after gauge fields
are included. The new Durr/Weber and Ammer/Durr papers suggest concrete
observables for C63-style Lean/prose audits: dispersion relations, spectral range,
near-degenerate eigenvalue pairs, and taste splitting of would-be zero modes.

Actionable theorem shape: do not merely prove `GhostZeroSafe`; prove or assume a
positive-residue/pole-like survivor predicate and show fatal propagator-zero
states are excluded from the retained sector.

### Nodal-set exhaustion

Yumoto-Misumi 2112.13501 and Yumoto-Misumi 2311.11320 jointly support using
spectral-graph matrices to classify determinant-zero loci. The second paper is a
newly added bridge between graph matrices and lattice operators. It should feed
C64: translate the tetrahedral operator into a graph-matrix normal form, then ask
whether known branch lines exhaust the zero locus or whether additional sheets or
curves survive.

### Krein lock and canonical selector

C65 shows `{0,2}` is canonical once the Krein sign is locked, but not from
chirality/taste/energy/grading alone. The literature search did not find a direct
MDF theorem deriving a Lorentzian/Krein branch sign from tetrahedral taste data.
That means K3 is correctly framed: either derive the Krein lock from an external
retarded/advanced, causal, reflection, or preferred-covector structure, or prove
that it remains an input convention.

### Furey finite layer

The Furey/internal-space literature helps most on representation architecture,
not on numerical mass prediction.

Todorov 2206.06912 reinforces that an octonionic complex structure is central to
lepton/quark splitting and Pati-Salam/Spin(10)-style organization. But this
supports the H2 caution: complex structure is not automatically electroweak
chirality. `chi_E` should still be treated as a grading/parity operator unless a
specific theorem proves otherwise.

Furey-Hughes 2210.10126 is the best new clue for `Phi_H`: left-right symmetric
Higgs representations can arise from quaternionic triality. This does not fix
Yukawa magnitudes, but it may constrain the representation carrier of the finite
Higgs operator. The narrow FUR-H7A/H8A/H9A jobs are therefore pointed in the right
direction: first build coordinate bridges, then ask whether triality/left-right
structure restricts the admissible intertwiners.

Gesteau 1906.02297 is useful for FUR-H10 and Gate F: matrix-Yukawa duality may
organize RG flow and finite-spectral-triple Yukawa spaces, but it does not by
itself make Yukawa inputs predicted. It supports a dimension/codimension audit,
not a magnitude claim.

## Bottom line

This pass does not close a gate outright. It sharpens three gates:

| Gate | Literature effect |
|---|---|
| Gate C | Strongly supports Route B: modified/flavored chirality after projection/splitting is the correct object. |
| Ghost safety | Reinforces the need for a separate residue/pole-like survivor condition. |
| Gate F | Reinforces conservative prediction language: split and Yukawa coefficients remain moduli unless additional representation/intertwiner constraints are proved. |

The most valuable next questions are now:

1. Can C63 prove a pole-like positive-residue survivor condition, not just index
   nonzero?
2. Can C64 translate the tetrahedral symbol into a graph-matrix normal form and
   classify the full zero locus?
3. Can K3 derive the Krein sign from causal/retarded-advanced structure, or is it
   an explicit convention?
4. Can FUR-H10 show a nontrivial codimension for admissible Furey `Phi_H`
   intertwiners, or are they still full-rank moduli?
