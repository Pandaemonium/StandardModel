Project name: gate-c1-ckm-texture-no-doubler-reintroduction-c187

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C179 says CKM should be texture/table, not literal naive physical operator. The desired operator-side reference is Wilson/Neuberger overlap or domain-wall. We need a theorem saying that adding CKM as a finite flavor/branch texture does not reintroduce Brillouin-zone doublers, provided it is not used as the kinetic lattice operator.

Task:
Develop a Lean-ready finite theorem/API package for “finite texture does not create new momentum zeros/doublers” under clear hypotheses.

Possible model:
- K(q) is the resolved kinetic/reference inverse kernel with the desired single physical zero and heavy doubler sectors.
- F is a finite branch/flavor texture acting on an internal tensor factor, independent of q and gauge-internal.
- The full kernel is either K(q) tensor I + I tensor F, or an overlap mass/texture deformation controlled by a gap condition.

Requested output:
1. State the safest mathematical formulation: tensor product, direct sum, additive mass deformation, or projector coupling.
2. Prove or sketch a theorem: if K has no unwanted zero and F is bounded/invertible/gap-compatible, then the full operator has no new unwanted zero.
3. Identify failure modes: non-invertible texture, momentum-dependent CKM factor, gauge-mixing texture, sign flip closing the gap.
4. Give Lean-ready theorem statements for finite-dimensional matrices/operators.
5. Explain how this theorem interacts with the C170/C181 constants and the C175 no-go.

Do not hide the hypotheses. If the theorem is false for additive coupling, identify the corrected safe coupling.
