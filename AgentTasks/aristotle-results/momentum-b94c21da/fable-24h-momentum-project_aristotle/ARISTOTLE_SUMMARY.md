# Summary of changes for run 00b840dd-3003-4507-9b74-17329031fd9a
All `sorry` theorems in `PairMomentumBlocks.lean` (T1 momentum kit through T5 charpoly) are now proved; `lake build` succeeds with no `sorry`/`admit`/`axiom`/`@[implemented_by]`, and `#print axioms` on the targets shows only `propext`, `Classical.choice`, `Quot.sound`, `Lean.trustCompiler`, and `Lean.ofReduceBool`.

The original theorem statements are unchanged (only the proof bodies were filled), and the convention-pinned definitions were left intact.

Approach (see `ARISTOTLE_SUMMARY.md` for the full per-theorem disclosure): kernel `decide` on these `ℂ`-matrix identities is infeasible (`ℂ` is noncomputable and kernel `ℚ` reduction gets stuck), so I introduced a computable Gaussian-rational model `GR` (= `ℚ(i)`) with an injective ring homomorphism `GR.toC : GR →+* ℂ`, discharged the finite matrix identities over `GR`, and transferred them to `ℂ` with fully kernel-checked ring-homomorphism reasoning plus injectivity. New files: `GRCore.lean` (the `GR` ring, matrices, and array-backed materialisation), `GRFacts.lean`, and `GRDiag.lean`.

native_decide disclosure: because every result transfers from the `GR` facts, all target theorems transitively use a single disclosed `native_decide` (the `Lean.ofReduceBool` axiom). The finite Gaussian-rational identities are decided by one batched `native_decide` in `GRFacts.lean` (`grFacts`), and T5's characteristic polynomial is obtained from an explicit diagonalisation `Qinv·U2g·Q = D` checked by one disclosed `native_decide` in `GRDiag.lean`, followed by `Matrix.charpoly_units_conj'`/`charpoly_diagonal`/`charpoly_map` and a kernel-checked regrouping of the 28 linear factors into the stated block product. T1's `one_particle_translation_invariance` is a direct kernel `simp` with no `native_decide`. Kernel `decide` was preferred but not achievable, so the disclosed `native_decide` fallback (explicitly permitted for the non-T5 items) was used; the transfer layer itself is ordinary kernel-checked proof.

Every displayed constant was first reproduced by an exact `sympy` oracle and then re-verified inside Lean by the `native_decide` computations; no identity failed, so the kill condition was not triggered.

Build note: `native_decide` recompiles `GR`-specialised code per call, so the facts are batched into as few invocations as possible; building `GRFacts.lean` is the slow step (~15 minutes, one-time), and the other modules build quickly.

# Summary — momentum block-diagonalization of the free pair lift (T1–T5)

All `sorry` theorems in `PairMomentumBlocks.lean` (T1 momentum kit through T5 charpoly)
are now proved. `lake build` succeeds; a `#print axioms` check on the target theorems shows
only `propext`, `Classical.choice`, `Quot.sound`, `Lean.trustCompiler`, and `Lean.ofReduceBool`.

The originally submitted theorem **statements are unchanged** (only the `:= by sorry` bodies were
filled in), and the convention-pinned definitions at the top of `PairMomentumBlocks.lean`
(`modeIdx`, `S1`, `C1`, `U1`, `T1`, `pairFst`/`pairSnd`, `minorLift`, `U2`, `T2`, `K2`, `V`, `P`,
`Rplus`, `Rminus`) were not modified. No `axiom` or `@[implemented_by]` was introduced.

## Method and native_decide disclosure (please read)

Kernel `decide` on these `ℂ`-matrix identities is not viable: `ℂ` is noncomputable, and even the
underlying `ℚ` arithmetic gets stuck under kernel reduction. The identities were therefore
discharged over a **computable Gaussian-rational model** and transferred to `ℂ`:

* `GRCore.lean` defines `GR` (computable `ℚ(i)`, `structure { re im : ℚ }`) with a `CommRing`
  instance and an **injective ring homomorphism** `GR.toC : GR →+* ℂ`, `⟨x,y⟩ ↦ x + y·i`.
  It also defines the `GR` analogues of every matrix (`U2g`, `T2g`, `Pg`, `K2g`, `Vg`,
  `Rplus_g`, `Rminus_g`) and an array-backed materialisation (`toArr`/`ofArr`/`mkEq`) used only
  to make the finite computations evaluate efficiently.
* `GRFacts.lean` proves one big Gaussian-rational fact `grFacts` **by a single, disclosed
  `native_decide`** and extracts the individual "clean" identities `gr_*`.
* `GRDiag.lean` gives an explicit eigenvector matrix `Qg`, its inverse `Qinvg`, and the diagonal
  `Dg` of eigenvalues; `Qinvg * U2g * Qg = Dg` is checked by **one disclosed `native_decide`**,
  giving `U2g.charpoly = ∏ (X - C eigenvalue)` (via `Matrix.charpoly_units_conj'` and
  `Matrix.charpoly_diagonal`).
* `PairMomentumBlocks.lean` proves, **fully kernel-checked (no `native_decide` in this file)**,
  the correspondences `U2 = Φ U2g`, `T2 = Φ T2g`, `P K = Φ (Pg K)`, `K2 = Φ K2g`, `V = Φ Vg`,
  `Rplus/Rminus = Φ …` (with `Φ = GR.toC.mapMatrix`), and transfers each theorem to its `GR`
  fact using ring-hom naturality (`map_mul`, `map_add`, `map_pow`, `map_nsmul`, trace/mulVec
  naturality) plus injectivity of `GR.toC`. T5 additionally uses `Matrix.charpoly_map` and a
  kernel-checked regrouping of the 28 linear factors into the stated block product.

### Per-theorem route

Because every theorem transfers from the `GR` facts, every target theorem transitively depends on
the single disclosed `native_decide` (axiom `Lean.ofReduceBool`). The intended preference was
"`native_decide` only for T5"; kernel `decide` proved infeasible here, so a **disclosed
`native_decide` is used as the permitted fallback** for the finite Gaussian-rational identities,
while the entire transfer to `ℂ` is ordinary kernel-checked reasoning.

* **T1** `one_particle_translation_invariance` — direct kernel `simp` (8×8), no `native_decide`.
* **T1** `pair_translation_order_four`, `pair_translation_invariance`,
  `momentum_projector_idem/complete/commutes`, `momentum_block_dims` — transfer + `grFacts`
  (`native_decide`).
* **T2** `block_annihilator_K0/K1/K2/K3` — transfer + `grFacts` (`native_decide`).
* **T3** `plusminus_counts_K0`, `plusminus_counts_K2`, `Rplus_P2_projector` — transfer + `grFacts`
  (`native_decide`).
* **T4** `kick_breaks_translation`, `composed_breaks_translation`,
  `kick_support_momentum_neutral` — transfer + `grFacts` (`native_decide`).
* **T5** `charpoly_U2_block_product` — explicit diagonalisation checked by `native_decide`
  (`GRDiag.diagRaw`), then `Matrix.charpoly_units_conj'`/`charpoly_diagonal`/`charpoly_map` and a
  kernel regrouping of the linear factors.

Every displayed constant was independently reproduced by an exact `sympy` oracle before
formalisation, and then re-verified inside Lean by the `native_decide` computations above (the
oracle also reproduced the composed-step data as a convention gate). No displayed identity failed,
so the kill condition was not triggered.

## Build notes

`native_decide` recompiles Gaussian-rational-specialised code per call, so the finite facts are
batched into as few `native_decide` invocations as possible (`GRFacts.grFacts` and
`GRDiag.diagRaw`). Building `GRFacts.lean` therefore takes on the order of ~15 minutes once;
the other modules build quickly.
