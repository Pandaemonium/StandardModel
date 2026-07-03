import PhysicsSM.Draft.NullEdge.GateMP.SCGGramPositivity

/-!
# Gate MP aggregator: the Measure Problem sector

This is a pure import aggregator for the Gate MP draft tree - the finite
mathematics of growth-measure candidates for the null-edge program (see
`Sources/Null_Edge_Measure_Problem.md`, the program's declared central open
problem). It currently collects the Gram-positivity and back-reaction
machinery for the SCG (skeleton-conditioned checkerboard growth) candidate:

    lake build PhysicsSM.Draft.NullEdge.GateMP

`SCGGramPositivity`: for a factorized decoherence functional
`D(g,g') = sum_s P(s) A_s(g) conj(A_s(g'))`, strong positivity (quantum-measure
entrance requirement R4) holds unconditionally, and a decoration-dependent
skeleton weight preserves positivity exactly when it is a PSD kernel - the
standing design constraint on any future back-reacting extension.

The module is draft-trust and is not added to the default trusted build
target; the no-arg `lake build` is the SPL-free trusted core and does not
include the NullEdge gate tree. Adding a new MP module? Add its import here
so the aggregate check stays complete.
-/
