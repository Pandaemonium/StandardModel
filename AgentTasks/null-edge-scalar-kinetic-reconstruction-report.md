# Report: null-edge scalar/Higgs kinetic reconstruction (Lean)

Target file: `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean`
(imports `Mathlib`). All declarations are kernel-checked and `sorry`-free; each
depends only on the standard axioms `propext, Classical.choice, Quot.sound`.

## What was proved

The file establishes the finite linear-algebra core requested in PROMPT.md and in
Working Plan §19.4 / proof-chain T8, T13: the Lorentzian scalar/gauge kinetic
symbol is reconstructed from null-edge derivatives weighted by the inverse-Gram
matrix, using the **dual covectors** `α^a` (not diagonal flats `ell_a^♭`).

### Conventions / setting

* `V` is a real vector space (the tangent space of a null-frame patch); covectors
  live in `Module.Dual ℝ V`.
* A dual-soldered null frame is a finite family of primitive null edges
  `ell_a ∈ V` together with the dual covector basis `α^a ∈ Module.Dual ℝ V`
  characterised by `α^a (ell_b) = δ^a_b`. In the file the general statements take
  `α` as a `Basis (Fin n) ℝ (Module.Dual ℝ V)` with predual `ell : Fin n → V` and
  hypothesis `hdual : α a (ell b) = if a = b then 1 else 0`; the inverse-Gram
  statements specialise `α := ell.dualBasis` for a basis `ell : Basis (Fin n) ℝ V`.
* Nondegeneracy of a symmetric bilinear form `g` is encoded by the inverse
  musical isomorphism `g♯`, supplied as `sharp : Module.Dual ℝ V →ₗ[ℝ] V` with the
  raising property `hsharp : g (sharp ξ) v = ξ v`. Existence of such a `sharp` is
  exactly nondegeneracy. The induced inverse metric on covectors is
  `g^{-1}(ξ,η) = g(sharp ξ, sharp η)`, written `LinearMap.compl₁₂ g sharp sharp`.

### Theorems

1. `repr_eq_apply_predual` — in a dual covector basis the `a`-th coordinate of a
   covector is the edge evaluation `ξ(ell_a)`.

2. `covector_bilin_reconstruction` — for any bilinear form `B` on covectors,
   `B ξ η = ∑_{a,b} B(α^a, α^b) · ξ(ell_a) · η(ell_b)`.
   With `B = g^{-1}` and `G^{ab} = g^{-1}(α^a, α^b)` this is the §19.4 identity
   `g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ell_a) η(ell_b)`.

3. `inverse_gram` — the coefficients `G^{ab} = g^{-1}(α^a, α^b)` are literally the
   matrix inverse of the Gram matrix `g_{ab} = g(ell_a, ell_b)`:
   `∑_b g_{ab} G^{bc} = δ_a^c`. This certifies the name *inverse-Gram weights*
   (requires `g` symmetric and the `sharp`/nondegeneracy data).

4. `inverse_gram_reconstruction` — items 2+3 combined, stated directly with the
   induced inverse metric and `α := ell.dualBasis`.

5. `higgs_kinetic_reconstruction` — the documented scalar/Higgs corollary
   (`ξ = η = dH`): writing the null-edge derivatives `∇_a H := dH(ell_a)`,
   `⟨DH, DH⟩_{g^{-1}} = ∑_{a,b} G^{ab} (∇_a H)(∇_b H)`.

6. `euclidean_collapse_guardrail` — the guardrail. The naive positive edge sum
   `∑_a (∇_a H)^2` is recovered **only** in the diagonal special case
   `G^{ab} = δ^{ab}`. For a genuine Lorentzian inverse-Gram matrix the
   off-diagonal weights survive, so the reconstruction is not Euclidean
   graph/lattice Higgs theory with null labels.

## Guardrails honored

* The Clifford/kinetic data is soldered to the dual covectors `α^a`, never to the
  diagonal flats `ell_a^♭`; the diagonal architecture is not used.
* The Euclidean positive edge sum is explicitly separated from the Lorentzian
  inverse-Gram reconstruction (`euclidean_collapse_guardrail`), making precise the
  §19.4 point that the cross terms / inverse-Gram weights are not cosmetic.
* The inverse metric `g^{-1}` is the genuine induced inverse form, and `G` is
  certified as the matrix inverse of the Gram matrix (`inverse_gram`).

## The tetrahedral 3+1 frame is a special case

The simplex null-solder frame of `docs/NULLSTRAND.md` (for `d = 4`,
`ell_A = (1, n_A)`, `α^A = 1/4 dt + 3/4 n_A·dx`, `α^A(ell_B) = δ^A_B`) is an
instance of the general hypotheses (`n = 4`, `ell` the simplex null edges, `α`
their dual covectors), so the general theorem subsumes it; no separate concrete
specialization was required.

## Commands run

* `lake env lean PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean`
  (compiles with no errors or warnings).
* `#print axioms` on all five theorems →
  `[propext, Classical.choice, Quot.sound]` only.
* `grep sorry` → none.

Only the single created file was elaborated; no unrelated full-repo build was run.

## Remaining generalization gaps

* Nondegeneracy is encoded via the supplied inverse musical map `sharp` plus
  `hsharp` rather than derived from a Mathlib `LinearMap.BilinForm.Nondegenerate`
  instance; deriving `sharp` from nondegeneracy would remove that hypothesis but
  is purely API plumbing.
* `higgs_kinetic_reconstruction` is stated for a real scalar differential
  `dH : Module.Dual ℝ V`. A complex / multi-component Higgs (`⟨DH, DH⟩` with
  conjugation, or doublet-valued derivatives) would follow by applying the same
  bilinear reconstruction componentwise; this was left as a documented extension.
* The statements are at the fixed-frame algebraic level. The local-frame /
  covariant version (`ell_a = ell_a(x)`, `α^a = α^a(x)`, curvature via holonomy
  around finite null diamonds, §19.5) and the continuum-limit recovery are out of
  scope for this finite-identity job.
