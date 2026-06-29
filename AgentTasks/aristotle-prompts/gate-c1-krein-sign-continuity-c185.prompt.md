Project name: gate-c1-krein-sign-continuity-c185

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C178 flags silent Krein-sign flips as a high-risk failure mode. Gate C1 import needs Krein/spectral health: the physical branch residue must keep the intended sign and the bad sector must not hide negative-norm ghost branches.

Task:
Develop a KreinSignContinuity / spectral-health certificate for the reference-import route.

Requested output:
1. Define a finite-sector `KreinSignCertificate` recording the intended Krein sign/residue sign for each sector.
2. Prove or state a continuity theorem: along a gapped homotopy with no sector crossing and nonzero residue form, the Krein sign cannot flip.
3. Identify what extra hypotheses are needed beyond a spectral gap: nondegenerate restricted Krein form, projector continuity, and no collision with null directions.
4. Give a failure/no-go example where spectral gap alone is not enough to ensure Krein positivity if the form degenerates.
5. Provide Lean/API structures compatible with the seven-slot sector signature.

Do not claim Krein self-adjointness alone gives positivity or unitarity.
