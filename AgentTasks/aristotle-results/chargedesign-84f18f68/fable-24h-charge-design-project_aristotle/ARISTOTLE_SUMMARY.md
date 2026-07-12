# Summary of changes for run 76dc6e93-7a60-40b6-8623-23583d70e9d1
Delivered `CHARGE_DESIGN_MEMO.md` (strategy/design job; no Lean proving required). Grounded it in the two provided sources (`context/MEMO_3PLUS1_ATTACK.md` and `context/FullBlochZeroClassification.lean`, whose crossing-locus SOS results and 0↔π mass-sign flip are cited directly), and cross-checked every feasibility claim against the actual pinned Mathlib.

The memo covers all six requested items with concrete formulas:

1. **A1 — local charge, algebraically.** Defines `Q(k₀) = deg_{k₀}(d)`, the local topological degree of a real d-vector extracted from a 2×2 Weyl block. Spells out the licensed reduction from the full internal space to the 2×2 block via the Feshbach/Schur complement `S = A − B D⁻¹ C` on `W = ker(U(k₀)∓1)`, with the exact licence condition (`dim ker = 2`, `D(k₀)` invertible) using `Matrix.det_fromBlocks₁₁`; notes why plain `adjugate` is blind and the `(N−2)` compound is the coordinate-free alternative. Gives the explicit d-vector `d_a = −(s/2) Im tr(σ_a S)`, the charge as `sign det v` (velocity matrix) in the nondegenerate case, and the Eisenbud–Levine–Khimshiashvili signature/Bézout formula for the degenerate fallback.

2. **A2 — sum-zero.** States per-gap vanishing over 𝕋³, separates the honest topological reason (boundary-free degree over a closed manifold) from the exact-algebra reformulation to build (global/toric residue identity normalized by the Laurent-unit monomial-determinant structure), and offers a pragmatic per-class resultant route that is exact now.

3. **A3 — tangent forces charge.** Defines involutory unit-speed Dirac tangent (invertible velocity `v`, definite `v vᵀ`) and shows it forces `Q = sign det v = ±1 ≠ 0`.

4. **Validation protocol** for all three named symbols: (a) the repo cubic walk (8 Floquet-paired nodes at cos qx=cos qy=cos qz=0, expected ±1 summing to 0, with the "four crossings" count flagged as census-determined via corner aliasing); (b) Gupta–Short (fails A3's involutory/`det v≠0` hypothesis — explained via `StationaryAmplitudeNoGo`); (c) the zero-determinant-flow witness — explicitly argues the design **sees** it (charge built from the traceless block, independent of the abelian `m`) and marks the exact per-node computation as the binding acceptance gate.

5. **Feasibility verdict** as a per-ingredient table (what exists in Mathlib — matrices/det/adjugate/charpoly/Schur/univariate Laurent/resultant; what must be built — multivariate Laurent-unit theory, ELK signature, degree/residue theory), identifying the general A2 sum-zero as the single hardest step, plus the fully explicit 1+1 warm-up theorem (all hypotheses spelled out), its no-go corollary (`|C| ≠ 1`), a periodic-eigenphase-count proof sketch, and a Lean-4 syntax sketch.

6. **Failure modes** F1–F6 (blindness, non-additivity, non-vanishing sum, degeneracy escape, higher degeneracy, abelian-coboundary collapse) with the program implication of each; concludes the two decisive gates are the cubic walk (±1, total 0) and the m=0 witness (Q≠0).

References are cited by name with KNOWN/VERIFY/physics-attribution flags (no fabricated sources). The file is committed and pushed to the main branch.
