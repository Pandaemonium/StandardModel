# Prior work: spectra of causal-set operators, and the corrected-pairing four-mode question

Author: claude. Date: 2026-07-16 (evening, post-cycle continuation).
Purpose: originality calibration for the preregistered spectral stage on
the corrected pairing (GRAV-ORDER-OPERATOR-001 successor). Sources
verified against INSPIRE-HEP on 2026-07-16; abstracts read; full-text
chunk verification pending re-ingestion of the paper graph (see Status
note at the end). Per repo policy, any claim that later depends on a
paper's INTERNAL content must be checked against full text before
citation in a manuscript.

## The question being calibrated

Does the corrected pairing (the diagonal-cancelled polarization of the
project's smeared/local Benincasa-Dowker-type operator - kernel-proved
today to be a nonzero self-adjoint zero-sum weighted-difference
operator) exhibit a stable, gapped, FOUR-dimensional spectral sector on
protected-core carriers of manifoldlike sprinklings, at the buffer
scales where cores individuate?

## Directly adjacent prior work ([comp] anchors)

1. **Yazdi & Kempf, "Towards Spectral Geometry for Causal Sets"
   (arXiv:1611.09947, CQG 2017).** Spectra of the causal-set
   d'Alembertian and propagator carry large amounts of geometric
   information; the spectra are relabeling-invariant; a spectral
   distance measures geometric similarity between causal sets. This is
   the closest prior statement of "the spectrum of a causal-set kinetic
   operator knows the geometry." TAG: the general idea that causal-set
   operator spectra are geometric probes is [comp] - imported context,
   not ours.
2. **Johnston, "Quantum Fields on Causal Sets" (arXiv:1010.5514,
   thesis; and the underlying papers).** Establishes the practice of
   EIGENDECOMPOSING a causal-set two-point operator (the Pauli-Jordan
   function i*Delta) to construct the Sorkin-Johnston vacuum and a
   causal-set Feynman propagator. TAG: eigenvalue problems for
   causal-set operators as constructive tools are [comp].
3. **Sorkin & Yazdi, "Entanglement entropy in causal set theory"
   (arXiv:1611.10281, CQG 2018); Belenchia, Benincasa, Letizia,
   Liberati (arXiv:1712.04227, CQG 2018).** The entanglement-entropy
   area law on causal sets requires TRUNCATING the Pauli-Jordan
   operator's eigenmodes "too close to zero" by a geometrical
   criterion (the double-cutoff prescription); 1712.04227 studies this
   for both discretized Green functions and the retarded nonlocal
   d'Alembertians at a length scale. TAG: scale-windowed spectral
   truncation of causal-set operators, with geometric criteria for
   which eigenmodes are physical, is [comp] - and is the closest
   methodological precedent for our "polynomial spectral-window filter
   at the buffer scale". Their truncations isolate a CONTINUUM-LIKE
   subspace of dimension growing with N; ours seeks a FIXED
   four-dimensional sector. The distinction matters and should be
   stated wherever the stage is written up.
4. **Aslanbeigi, Saravani & Sorkin, "Generalized causal set
   d'Alembertians" (arXiv:1403.1622, JHEP 2014).** The GCB operator
   family; continuum symbols g(p); evidence that the original 4D
   RETARDED causal-set d'Alembertian is dynamically UNSTABLE (2D
   stable). TAG: [comp] context with an important boundary: the
   instability evidence concerns the retarded (non-self-adjoint)
   operator's evolution; today's corrected pairing is the symmetrized,
   self-adjoint companion, so no stability conclusion transfers in
   either direction without new work. Do not cite ASS as evidence for
   or against the corrected object's spectral stability.
5. **Eichhorn, Surya & Versteegen, "Spectral dimension on spatial
   hypersurfaces in causal set quantum gravity" (arXiv:1905.13498, CQG
   2019).** Spectral dimension via diffusion; UV dimensional
   reduction; methodologically adjacent (spectra as dimension probes)
   but a different operator and question. TAG: [comp] context.

## What appears to be original ([orig] candidates, pending full-text checks)

- **The corrected pairing as the spectral object.** The
  diagonal-cancelled polarization form - kernel-proved equal to a
  symmetric weighted finite-difference operator with zero-sum range -
  is not, to our current knowledge, studied spectrally anywhere in the
  causal-set literature (the literature spectrally analyzes i*Delta,
  retarded d'Alembertians, and propagators). [orig] candidate.
- **The four-mode question itself.** Seeking a STABLE FOUR-DIMENSIONAL
  isolated eigensector of an order-native operator on protected-core
  carriers, as a candidate frame/tetrad germ, has no visible
  antecedent in the spectral causal-set line (which targets vacua,
  entropy, dimension, or geometry-fingerprinting, not a rank-four
  frame sector). [orig] candidate.
- **The kernel-checked receiving interface.** Polynomial spectral
  filters with transported certificates, the projector/involution
  equivalences, the permutation and hidden-rescaling no-gos - the
  formal infrastructure is program-original ([orig], with standard
  linear algebra tagged [import] in the modules themselves).

## Consequences for the preregistration

1. Cite 1611.09947 and 1611.10281/1712.04227 as methodological
   precedent in the stage note; state the fixed-rank-four vs
   growing-truncation distinction explicitly.
2. Do NOT import any stability expectation from 1403.1622; the
   corrected object's spectrum is uncharted, which is the point.
3. The relabeling invariance of spectra (1611.09947's point) is, for
   our object, already kernel-checked at the covariance level
   (mapOrderIso suite) - the stage note may say so with the guard
   references.

## Status note (tooling)

The local Neo4j paper graph reachable tonight contains only 16 Paper
nodes with empty arxiv_id fields - it appears reset or freshly
re-initialized relative to the corpus this program built earlier
(null-edge collections, IN_COLLECTION edges to 9W59V3K9). Zotero/Neo4j
ingestion of the five papers above is therefore DEFERRED until the
graph state is diagnosed (next session task; check whether the Desktop
DBMS was recreated - the dbms id in the headless-start note may now
point at a fresh database). The INSPIRE metadata above is sufficient
for the preregistration's provenance either way.
