Project name: gate-c1-ckm-reference-homotopy-c176

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current strategic context:
The Gate C1 strategy is now reference-kernel import. We want to show the null-edge Hermitian overlap kernel H_ne is connected to a known CKM-style one-flavor flavored-overlap reference H_ref by a uniformly gapped homotopy. The preferred path is the straight-line homotopy

  H_t = H_ref + t (H_ne - H_ref),  t in [0,1].

Known desired criterion:
If H_ref has spectral gap gamma_ref and ||H_ne - H_ref|| < gamma_ref, then H_t remains uniformly gapped with residual gap gamma_ref - ||H_ne - H_ref||.

Problem:
Package the gapped homotopy theorem and the null-edge error budget needed to apply it to the CKM reference.

Requested results:
1. Abstract finite-dimensional theorem: if self-adjoint/Hermitian A has lower norm bound gamma on all unit vectors and ||B-A|| <= eps < gamma, then every H_t = A + t(B-A) has lower norm bound gamma - eps.
2. Consequence: sign(H_t), spectral projectors, and index/signature data are stable along the path, assuming the usual sign-functional-calculus hypotheses.
3. Null-edge application interface with error decomposition

   H_ne - H_ref = (Gamma_K - Gamma_ref) A_ref + Gamma_K (A_ne - A_ref)

   and separate bounds E_D, E_W, E_R, E_Gamma, E_gauge whose sum is < gamma_ref.

Requested output:
- Lean-ready theorem statements for the finite-dimensional norm-gap part;
- a certificate structure for the null-edge/CKM error budget;
- explicit hypotheses needed for Hermitian/Krein-Hilbertized versions;
- warning notes about statement drift or hidden assumptions.

This job should support the C159 NullEdgeReferenceOverlapImport interface.
