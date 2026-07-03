You are advising on Gate C1 of the null-edge Standard Model program.

Project goal:
Build a model that reproduces Standard Model chiral fermions using discrete lightlike/null-edge steps inspired by the Feynman checkerboard. We are not trying to invent novelty for its own sake; we want a proven physical architecture, preferably overlap/Ginsparg-Wilson/domain-wall style, interpreted through null-edge combinatorics.

Current checked Lean status:
- TetraFreeOperator.lean proves the real-space centered kinetic slash Fourier symbol `i Q(sin k)`.
- TetraFreeOperator.lean proves Kfree diagonalizes to TetraScalarWilsonSymbol.K.
- TetraScalarWilsonSymbol.lean proves scalar Wilson K star K gap identities and H gamma5 transfer.
- OverlapIndex.lean exports finite overlap-index trace formulas and now includes an integrality route via projector ranks.
- TetraBranchWilsonSymbol.lean scaffolds matrix-valued branch Wilson corrections W_branch and records that scalar Wilson is only the overlap seed/gap brick, not the physical branch selector.
- OverlapLocalityCertificates.lean packages finite-range, exponential-locality, bounded-hopping, spectral-gap, and analytic sign-approximation certificates.

Known blockers:
- Physical branch retention is not solved. We still need a concrete W_branch/projector/spectral-island construction that keeps the desired Weyl branch and gaps mirrors without ghost-zero substitution.
- We need anomaly matching against the Standard Model anomaly-cancellation layer in the repo.
- We need locality/quasi-locality tied to a literature-grade Neuberger/Hernandez-Jansen-Luscher theorem or a clearly stated nonlocal/combinatorial path-sum alternative.
- We need the final physical C1 statement: one chiral branch released, mirror sector truly gapped, anomaly and positivity/Krein audits passed.

Task:
Give an overarching strategy audit for closing full physical C1. Include:
1. The shortest credible theorem path from the current checked finite/free operator to full physical C1.
2. Which assumptions should be kept, relaxed, or discarded.
3. Whether the scalar Wilson seed plus matrix-valued branch Wilson/projector layer is the right architecture.
4. How the existing anomaly cancellation work in the repo should enter the C1 theorem.
5. The next 5-10 highest-value Lean or literature tasks, in priority order.
6. A red-team section: what could still make this architecture fail.

Success criteria:
- Be concrete: propose theorem statements or module names when possible.
- Distinguish checked Lean facts, plausible literature imports, and speculative physics.
- Do not claim C1 is solved unless all physical obligations are explicitly met.
