# Summary of changes for run 112921ef-374c-42f7-badc-d7b4126dccba
Delivered `RequestProject/Main.lean` (namespace `LambdaFrameConstraint`) and `ARISTOTLE_SUMMARY.md`, formalizing the finite linear-algebra core of "frame-blindness forces the Poisson/everpresent branch." Everything is over ℚ with explicit dimension k = 3; the file builds in well under 3 minutes with no `sorry`/`admit`/`native_decide`/new axiom, using only `ring`/`norm_num`/`fin_cases`/`simp`/`linarith` (no `Real`/`Complex`, no high-degree `nlinarith`).

Model: `Jm` (all-ones J), `ones` (uniform direction), and `FrameBlind C` := C commutes with every permutation matrix (`C * σ.permMatrix ℚ = σ.permMatrix ℚ * C`), the finite avatar of Lorentz frame-blindness.

Headline theorems (all four requested targets):
1. `perm_inv_iff_aI_bJ`: a symmetric rational C is frame-blind iff C = a•I + b•J. (Symmetry hypothesis kept as requested; noted in docstring that it is actually unnecessary since commuting with all permutations already forces symmetry.)
2. `suppressed_dir_is_uniform` (payload): for C = a•I + b•J with a ≠ 0, any nonzero null eigenvector is uniform (v = fun _ ↦ c, c ≠ 0) and a + 3b = 0 — a frame-blind ensemble suppresses only the grand-total mode.
3. `nonuniform_suppression_breaks_symmetry` (payload): explicit symmetric PSD witness C' = !![1,1,0;1,1,0;0,0,0] that annihilates the non-uniform direction ![1,-1,0] but is not frame-blind (fails commuting with swap 0 2) and is not of the form a•I + b•J.
4. `frame_blind_everpresent_verdict`: packages (A) frame-blind + nondegenerate ⇒ only uniform mode suppressed (regional variance extensive, the everpresent/Poisson branch) and (B) realizable non-uniform suppression must break frame-blindness.

Mandatory non-degeneracy witnesses are in-file: `uniform_suppressed_witness` (a = 1, b = -1/3, so a + 3b = 0, with the matrix annihilating `ones`) plus the fully explicit C' above (`Cp_isSymm`, `Cp_posSemidef`, `Cp_suppresses_nonuniform`, `Cp_not_frameBlind`, `Cp_not_aIbJ`).

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`, all confirming the footprint is exactly [propext, Classical.choice, Quot.sound]. Honest scope (the continuum Lorentz-invariance ⇒ Poisson step is imported, not proved here) is stated in the docstrings and summary. Work is committed and pushed.

# claude-lambda-frame-constraint — summary

Finite linear-algebra core of "frame-blindness forces the Poisson (everpresent) branch."
All results live in `RequestProject/Main.lean`, namespace `LambdaFrameConstraint`, over the rationals
`ℚ` with the explicit dimension `k = 3`. Kernel-checked; footprint exactly
`[propext, Classical.choice, Quot.sound]` (verified in-file with `#guard_msgs … #print axioms` on
every headline). No `sorry`/`admit`/`native_decide`/new axiom; no `Real`/`Complex`; only
`ring`/`norm_num`/`fin_cases`/`simp`/`linarith`.

## Model

* `Jm` — the all-ones `3 × 3` matrix `J`.
* `ones : Fin 3 → ℚ` — the uniform (grand-total) direction.
* `FrameBlind C` — permutation invariance: `C` commutes with every permutation matrix
  (`C * σ.permMatrix ℚ = σ.permMatrix ℚ * C` for all `σ : Equiv.Perm (Fin 3)`). This is the finite
  avatar of Lorentz frame-blindness.

## Headline results

1. `perm_inv_iff_aI_bJ` — a symmetric rational `C` is frame-blind **iff** `C = a • I + b • J` for
   some `a, b : ℚ`. (The requested symmetry hypothesis is kept but turns out unnecessary: commuting
   with all permutation matrices already forces symmetry.)
2. `suppressed_dir_is_uniform` (payload) — for `C = a • I + b • J` with nondegenerate base variance
   `a ≠ 0`, the only null eigenvector is uniform: `C *ᵥ v = 0`, `v ≠ 0` ⇒ `v = fun _ ↦ c` with
   `c ≠ 0`, and `a + 3·b = 0`. A frame-blind ensemble can suppress only the grand-total mode.
3. `nonuniform_suppression_breaks_symmetry` (payload) — explicit witness
   `C' = !![1,1,0; 1,1,0; 0,0,0]` (the rank-one `w wᵀ`, `w = ![1,1,0]`): symmetric
   (`Cp_isSymm`), positive semidefinite (`Cp_posSemidef`), annihilates the non-uniform direction
   `![1,-1,0]` (`Cp_suppresses_nonuniform`), yet is not frame-blind (`Cp_not_frameBlind`, via
   `swap 0 2`) and is not of the form `a • I + b • J` (`Cp_not_aIbJ`).
4. `frame_blind_everpresent_verdict` — the package: (A) any frame-blind ensemble with `a ≠ 0`
   suppresses at most the uniform mode (regional variance stays extensive — the everpresent/Poisson
   branch); (B) hyperuniform suppression of a regional mode is realizable only by a covariance that
   breaks frame-blindness.

Mandatory non-degeneracy witnesses are in-file: `uniform_suppressed_witness` gives the explicit
`a = 1, b = -1/3` (so `a + 3b = 0`) with `(1•I + (-1/3)•J) *ᵥ ones = 0`; the non-uniform witness `C'`
above is fully explicit.

## Honest scope

Permutation invariance is the finite avatar of Lorentz frame-blindness; the continuum
"Lorentz-invariance ⇒ Poisson" step is imported, not proved here. This is the finite structural core
of "the hyperuniform branch costs a preferred frame."
