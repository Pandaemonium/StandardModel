# Summary of changes for run b60b80fb-4af9-46d3-80c3-148729f25c6a
Completed the complete-walk multiplicity census for the 16-field family: all four `sorry`s in `CensusMultiplicity.lean` are now proved, the module builds cleanly, contains no `sorry`/`admit`/`axiom`, and each of the four target theorems depends only on the allowed axioms (`propext`, `Classical.choice`, `Quot.sound`, plus `Lean.ofReduceBool`/`Lean.trustCompiler` from `native_decide`). Only `CensusMultiplicity.lean` was changed; the three context modules under `PhysicsSM/Draft/NullEdge/` were imported and used unmodified.

What was proved (statements unchanged from the originals):
- `census_rank_minus` / `census_rank_plus`: `(Wof b ∓ 1).rank = 6/4/8` for singleton/block/control fields.
- `census_multiplicity`: `dim ker (Wof b ∓ 1) = 2/4/0` for both signs.
- `census_blind_same_multiplicity`: every two-wall singleton has minus-kernel dimension 2.

Proof structure (one-helper strategy from the docstring):
- `le_rank_of_minor`: a nonzero p×p minor forces `rank ≥ p` (submatrix is a unit; submatrix rank ≤ full rank).
- `rank_null_cert` (singletons/blocks): from kernel-vector columns `N` with `(reindex e8 e8 M)*N = 0`, a nonzero k-minor of `N` (so `N.rank = k`), and a nonzero (8−k)-minor of `M`, it combines `rank_add_rank_le_card_of_mul_eq_zero` with rank–nullity to pin `M.rank = 8−k` and `dim ker = k`. `e8 : V8 ≃ Fin 8` is `finProdFinEquiv`, `(site,comp) ↦ 2*site+comp`, matching the certificate index order.
- `rank_null_full` (controls): certifies invertibility via an explicit right inverse and rank–nullity.
- `census_all` reduces `b` to its four booleans via `cases` and dispatches each of the 16 concrete fields to its per-field certificate lemma; the four public theorems are projections/corollaries.

Which tactic per fact:
- Kernel-vector products `M*N = 0`, the N-minor and M-minor determinant nonzero-ness, and the control right-inverse products: `native_decide` (draft lane, matching the sibling modules).
- The classification `if` reductions over `wallCount`/`isSingleton` in `census_all` and `census_blind_same_multiplicity`: `decide`.
- The linear-algebra helpers themselves are ordinary term/tactic proofs (no `decide`/`native_decide`).

Certificate fidelity and KILL CONDITION: every census entry matches the module's certificate table; no mismatch was found. Consistency is enforced by the build itself — each per-field lemma proves the concrete rank/nullity from the certificate kernel data via `native_decide`, and `census_all` then checks by `decide` that those concrete numbers equal the `if wallCount/isSingleton` classification, so a genuine transcription mismatch would fail one of these steps rather than pass silently.

One deviation from the suggested recipe, with reason: for the zero-/four-wall controls the docstring proposed certifying `det (Wof b ∓ 1) ≠ 0`, but `native_decide` cannot compile an 8×8 Leibniz determinant (it aborts). Instead the controls are certified by an explicit computable Gauss–Jordan right inverse (`gjInv`) checked by the cheap product `(reindex e8 e8 M) * gjInv (…) = 1` via `native_decide`, giving `IsUnit` and hence full rank 8 / trivial kernel. `gjInv` is used only as an unverified candidate-inverse producer whose output is validated by that product equation, so no soundness depends on it being a genuine inverse.
