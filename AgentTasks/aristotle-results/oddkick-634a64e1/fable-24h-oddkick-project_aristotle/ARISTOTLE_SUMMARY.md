# Summary of changes for run 3fb113a3-81ba-4f91-90cf-bdad8902641f
All five `sorry`-ed theorems in `GammaOddKickDichotomy.lean` are now proved, and the file builds cleanly. Each target theorem depends only on the standard axioms `propext`, `Classical.choice`, `Quot.sound` — no `native_decide`, no `Lean.ofReduceBool`, no added axioms, and the convention-pinned definitions (`G1`, `pairFst`, `pairSnd`, `minorLift`, `G2`, `oddH`) are left exactly as given.

The oracle facts all held as stated; nothing needed correction.

Approach — a computable Gaussian-integer twin. Since every entry of `G1` (hence `G2`) is a Gaussian integer, I added a computable mirror `G1g`, `minorLiftg`, `G2g` over `GaussianInt = ℤ[i]` and the ring homomorphism `phi : ℤ[i] →+* ℂ` (`GaussianInt.toComplex`). Bridge lemmas `G1_eq`, `minorLift_map`, `G2_eq` give `G2 = G2g.map phi`. This lets all finite linear-algebra facts be discharged by kernel `decide` on integer data and transported to ℂ along `phi`.

- T1 `no_odd_generator_on_samesite_block`: from `decide`d row/column supports of `G2g` (rows/cols 0 and 13 are single `-1` entries), transported to ℂ, the anticommutation equation collapses at each of the four block entries to `-(H i j) = H i j`, forcing `H = 0`; off-support entries vanish by hypothesis.
- T2a `oddH_odd`: decompose `oddH a w = a•(Pg.map phi) + w•(Qg.map phi)` over the `{1,8}` block; the two parameter-free identities `G2g*Pg = -(Pg*G2g)` and `G2g*Qg = -(Qg*G2g)` are full 28×28 `decide`s over `GaussianInt`, transported via `Matrix.map_mul`.
- T2b `oddH_isHermitian` and T2c `oddH_ne_zero`: entrywise conjugate-transpose check, and reading off the `(1,1)`/`(1,8)` entries.
- T3 `G2_signed_permutation`: the entire signed-permutation census `census_g` is a single kernel `decide` over `GaussianInt`; each per-column result is transported to the ℂ `mulVec` statement (with the two same-site fixed columns 0 and 13 given directly).

The complete quantified census, the two matrix-product identities, and all support lemmas are proved by kernel `decide` (with raised `maxRecDepth`/`maxHeartbeats`), keeping everything within the allowed axiom set.
