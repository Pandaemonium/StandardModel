# C21 actual flat tetrahedral Clifford symbol and per-branch kernel chirality -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 0999d1a1-b710-4d99-9da1-1b7acc4225a7
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

## C21 — actual flat tetrahedral Clifford symbol and per-branch kernel chirality

I built the operator-level data that Gate C (C19) had isolated as its remaining blocker, and computed the per-branch kernel honestly. The result is a **corrected verdict**, not a forced release.

### New module: `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`
Kernel-clean (every theorem depends only on `propext, Classical.choice, Quot.sound`), builds with no `sorry`. Registered in `PhysicsSMDraft.lean` for full-repo integration.

**The actual operator (was missing before):**
- Weyl/chiral gamma matrices on `Spin = Fin 2 ⊕ Fin 2` in the locked mostly-minus signature `η = diag(+,-,-,-)`, with `clifford_relation : {γᵘ,γᵛ} = 2ηᵘᵛ•1`.
- The Clifford symbol `c(p) = Σ_μ p_μ γ^μ = [[0,A(p)],[B(p),0]]`, with `cliffordSymbol_eq_sum` and the central identity `cliffordSymbol_sq : c(p)·c(p) = (mink p)•1` (so the determinant branch condition is exactly `p² = 0`). The covector `pCov`, the Minkowski square `mink`, and the four branches are reused from `TetrahedralNullBranch`/`NullEdgeFlavoredChirality`.

**The per-branch kernel computation (the heart of C21):**
- On every null covector the symbol is nilpotent (`cliffordSymbol_sq_zero`), and its kernel contains **both** a right-handed (`γ₅ = +1`) and a left-handed (`γ₅ = -1`) zero mode, linearly independent (`null_kernel_chirality_plus`, `null_kernel_chirality_minus`, `null_kernel_both_chiralities`).
- Specialized to the four high-momentum branches: each is a genuine determinant branch (`branch_cliffordSymbol_sq_zero`, `branch_cliffordSymbol_ne_zero`), and the requested `branchKernel_chirality_sign` proves the branch kernel is **two-dimensional and chirality-balanced**.

**Corrected Gate C verdict (honest, not forced):**
- The C19 obligation transcribed at operator level (`BareOperatorAssignsSingleSign`) is proved **false**: `no_full_symbol_single_chirality : ¬ ∃ ε, BareOperatorAssignsSingleSign ε`. Branch 0 alone already carries both chirality signs, so no single per-branch sign `g5 a` is forced by the bare operator — consistent with the existing `naive_index_zero`.
- This is exactly the caution flagged in the task: the full Dirac symbol kernel is 2-dimensional; a single-chirality `g5 a` only emerges after an energy/Krein/Weyl projection. That projection is made explicit as the precise remaining obligation `OperatorForcesAlignmentAfterProjection`, with the next Lean targets (energy split, Krein signature, projected `γ₅ = g5 a`) enumerated.

### Report
`AgentTasks/null-edge-c21-actual-clifford-symbol-note.md` records the conventions, the full theorem inventory, the corrected verdict, and the acceptance criteria for upgrading Gate C from PENDING.

**Bottom line:** Gate C remains PENDING. The actual operator data does not force the aligned signs; instead it gives a two-dimensional chirality-balanced branch kernel, so the C19 `OperatorForcesAlignment` hypothesis is not discharged by the bare symbol. No theorem statements were weakened; the open part is isolated in an explicit projection obligation, and the negative result is proved rather than assumed.
