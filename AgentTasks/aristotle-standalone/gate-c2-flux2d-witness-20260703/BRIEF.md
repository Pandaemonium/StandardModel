# Gate C2: the 2D Wilson-Dirac zero-to-nonzero flux index

Complete all 26 sorry-marked declarations in
PhysicsSM/Draft/NullEdge/GateC2/FluxOverlapIndex2D.lean (do NOT change any of
the numbered theorem statements; helper lemmas/defs may be added freely).
This project also includes the dependency chain
(PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean,
GateC1/OverlapIndexToy.lean, and the GateC2/ files
OverlapIndexIntegrality/OverlapIndexEndIntegrality/OverlapIndexEigenspace/
OverlapIndexMatrixSignature/OverlapSignCertificate/OverlapSignExistence/
GaugeOverlapInterface/GaugeIndexInertiaForm/HermitianSylvester.lean) copied
verbatim from the main repository and already fully proved (no sorry in any
of those files) - use them as-is, they define overlapIndex, Dov, epsCFC,
gaugeOverlap_index_eigenvalue_count_form, and
HermitianSylvester.congruence_preserves_inertia (Sylvester's law of inertia
for complex Hermitian matrix congruence), all of which the target file needs.

The target file's own module docstring contains: full physics context, the
oracle-verified numeric provenance of every explicit matrix given, a
section-by-section map of what's proved, and detailed proof-strategy notes
for each class of sorry (Hermitian-ness via sparsity not dense expansion,
discrete-Fourier-orthogonality for the unitary/block-diagonalization steps,
direct rational arithmetic for the 8 block congruences, matrix-algebra
assembly for the combined congruence, and reuse of the already-proved
qform/maxPosDimF machinery inside HermitianSylvester.lean for the
diagonal-matrix eigenvalue-sign-count bridge). Start by running
`lake env lean PhysicsSM/Draft/NullEdge/GateC2/FluxOverlapIndex2D.lean` (do
NOT run a full lake build first - the dependency files are already Mathlib-
only and should typecheck directly).

This is an ambitious, multi-part target; a partial result (some sorries
closed, others left with a documented reason) is a valuable and acceptable
outcome - report exactly what was closed and what remains, and do not weaken
any theorem statement to make progress. Deliverables for every sorry closed:
no sorry, no native_decide, axiom footprint
[propext, Classical.choice, Quot.sound].
