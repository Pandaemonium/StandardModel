# Aristotle job C264: flavored / matrix Wilson square and gap transfer

This is a non-blocking strategy/proof-design job for the PhysicsSM null-edge Gate C1 program. Codex is continuing the local finite/free scalar `Kfree/Hfree` assembly, so do not work on that path.

Context:
- C262 showed scalar Wilson supplies a uniform inverse-symbol gap but cannot supply branch/flavor selection, a target spectral island, or a nonzero origin chiral index.
- The likely physical branch-retention layer needs an Adams-style flavored/species-splitting matrix branch mass `W_branch(k)`.
- The scalar square theorem `K_star_mul` works because `m(k) I` is central. For a matrix-valued `W_branch`, cross terms must be controlled explicitly.

Please read the included Gate C1 plan and scalar symbol files, then produce a report named:

GateC1_FlavoredWilsonSquareGap_Plan.md

Answer:
1. What is the cleanest abstract Lean interface for `W_branch(k)`?
2. What exact commutation/anticommutation/Hermiticity hypotheses make `K_branch(k)^* K_branch(k)` reduce to a usable positive form?
3. What theorem should generalize `K_star_mul` and `K_symbol_l2NormSq_gap`?
4. Can scalar `firstBandMu` be reused, or do we need a new flavored spectral lower-bound certificate?
5. Give near-Lean statements for a new `TetraBranchWilsonSymbol.lean` file.

Do not claim physical branch retention unless the theorem includes a target island and nonzero chiral index. This job is about the algebra/gap-transfer layer only.
