# Summary of changes for run 93d7a0b1-04ed-40dd-8f2a-9361c367de79
Replaced the placeholder in `CARBlockReduction.lean` with the four genuine targets, all proved and kernel-only (each depends only on `propext`, `Classical.choice`, `Quot.sound`). The file builds with no errors, no warnings, and no `sorry`. The needed definitions from the reference context files were copied in verbatim (they were not imported).

What was proved:

- **T1 — the reduction isomorphism.** Defined pair-block operators as `ℂ`-linear maps `Fock (Fin 4) →ₗ Fock (Fin 4)` with support in `{lowPair, highPair}` and output depending only on the two pair amplitudes (`IsPairBlock`), packaged as a `Submodule` `pairBlock`. Built the explicit linear equivalence `blockEquiv : Matrix (Fin 2) (Fin 2) ℂ ≃ₗ[ℂ] pairBlock` with both directions (`matToOp` forward, `blockOf` inverse) and the left/right inverse lemmas (`matToOp_blockOf`, `blockOf_matToOp`). Proved the Hermitian tie `hermitian_iff : IsFockHermitian (matToOp M) ↔ M.IsHermitian`, i.e. an operator is `fockInner`-Hermitian iff its 2×2 block is a Hermitian matrix.

- **T2 — the generator is the selection family.** Bundled the CAR generator as `KopL z := matToOp !![0, z; conj z, 0]`, proved it equals the source function `Kop z` pointwise (`KopL_eq_Kop`), that it is a pair-block operator (`KopL_isPairBlock`), and that `blockOf (KopL z) = !![0, z; conj z, 0]` (`blockOf_KopL`) — the selection family member at `a = 1`.

- **T3 — the Fock-level gauge tie.** Defined `Dfock u` (the one-particle phase on mode 0). Proved (a) it preserves `fockInner` for `‖u‖ = 1` (`Dfock_preserves_fockInner`); (b) its block shadow is `Dphase u`: block-conjugation by `Dfock u` equals matrix conjugation `M ↦ Dphase u * M * (Dphase u)ᴴ` (`blockOf_conj_Dfock`, stated for a general linear operator, so it specializes to the pair-block case); (c) the exact equivariance `Kop (u*z) = Dfock u ∘ Kop z ∘ Dfock u⁻¹` for unimodular `u` (`Kop_equivariance`).

- **T4 — the bundled sharpener.** For a 2×2 unitary `U` (`U * Uᴴ = 1`): if `U.charpoly = (X - 1)^2` then `U = 1`, and if `U.charpoly = (X + 1)^2` then `U = -1` (`sharpener_pos`, `sharpener_neg`, bundled as `sharpener`).

Documented corrections/packaging choices prominently in the file docstring: T1's dependence condition is stated in the extensional form actually needed for the isomorphism (inputs agreeing on the two pair amplitudes give equal outputs); T2's `Kop` (a bare function in the source) is bundled as the linear map `KopL` with a pointwise-equality lemma; T3(b)'s conjugation direction is `Dphase u * M * (Dphase u)ᴴ` and is stated for general linear operators. No statement was weakened.
