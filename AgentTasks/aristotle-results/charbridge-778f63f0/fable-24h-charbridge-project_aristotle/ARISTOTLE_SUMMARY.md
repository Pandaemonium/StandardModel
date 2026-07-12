# Summary of changes for run b2cc7214-34a0-41d2-a8ac-e2701d250774
Proved the deferred matrix-level characteristic-polynomial bridge (T3) for the composed 28×28 step `V = U2 · K2` of the sibling `PairSpectrumFixture` job. The result is in a new file `PairCharpolyBridge.lean` (with a small generic helper file `PairCharpolyBridgeAux.lean`), building cleanly with **no `sorry`, no errors, and no warnings**. The relevant `PairSpectrumFixture` definitions (`g`, `Vz`, `V`, `p12`, `charpoly_factorization`) are copied verbatim (not imported).

Main results (in namespace `PhysicsSM.Draft.NullEdge.PairCharpolyBridge`):
- `V_charpoly_eq` : `C (48828125 : ℂ) * V.charpoly = <the exact degree-28 right-hand side displayed in charpoly_factorization>`. Since `48828125 = 5^11`, this states that `5^11` times the characteristic polynomial of `V` equals that explicit polynomial.
- `V_charpoly_factored` : composes the above with `charpoly_factorization` to give `C 48828125 * V.charpoly = (X+1)^2 (X-1)^4 (25X²+14X+25)(5X²-6X+5)^2(5X²+6X+5)^2 · p12 X` — i.e. `charpoly V` (scaled by `5^11`) equals the explicit product of spectral factors.
- `Vz_charpoly_eq` : the integer twin's characteristic polynomial, `Vz.charpoly = Rpoly`, with `Rpoly` the explicit degree-28 integer (Gaussian) polynomial.

The computation confirmed the claimed factorization exactly — no coefficient mismatch.

Method (a full 28×28 determinant is infeasible in-kernel, so no determinant is expanded): an explicit integer (Gaussian) similarity conjugates `Vz` to a block-diagonal form `diag(16 Gaussian-integer eigenvalues) ⊕ companion(P6a) ⊕ companion(P6b)`, where `P6a·P6b` is the scaled degree-12 palindromic factor (irreducible over ℚ(i) into two Gaussian sextics). All eigenstructure was computed and verified before formalizing. The block charpoly is assembled with `charpoly_reindex`, `charpoly_fromBlocks_zero₂₁`, `charpoly_diagonal`, and a proved companion-matrix charpoly lemma; conjugation-invariance is a proved generic lemma; the transport to the physical `V` uses a proved scalar-multiple charpoly lemma.

Disclosed automation: the Gaussian-integer matrix identities (the similarity relations `S·T = d·1`, `T·S = d·1`, `T·Vz·S = d·B`, the block shape, and the companion annihilation/cyclicity facts) are checked by `native_decide`; the bridge from the literal `Vz` to its array encoding is checked by the kernel (`decide +kernel`). To make these tractable the matrices are encoded as `Array`-lookups (a literal `!![…]` form made `native_decide` prohibitively slow). Everything else is ordinary kernel-checked reasoning. `#print axioms` for the three main theorems shows only `propext`, `Classical.choice`, `Quot.sound`, plus `Lean.ofReduceBool`/`Lean.trustCompiler` (from the disclosed `native_decide`); no `sorryAx`, no added `axiom`, no `@[implemented_by]`.

All work is committed and pushed to `origin/main`.
