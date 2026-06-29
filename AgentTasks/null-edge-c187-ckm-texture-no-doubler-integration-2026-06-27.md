# Summary of changes for run 489305ee-2196-4bd8-b8ef-eb3145464df0
Built a self-contained, fully-verified Lean theorem/API package answering C179/C187: "a finite CKM texture does not reintroduce Brillouin-zone doublers, provided it is not used as the kinetic lattice operator." Everything lives in `RequestProject/Main.lean`, builds cleanly with no proof placeholders and only the standard kernel dependencies (`propext`, `Classical.choice`, `Quot.sound`).

Framework (finite-dimensional matrices/operators):
- `IsDoubler M q := ¬ IsUnit (M q)` — a momentum zero/doubler is a point where the operator-valued kernel fails to be invertible.
- `NoUnwantedDoubler M Unwanted := ∀ q ∈ Unwanted, IsUnit (M q)` — the full kernel stays invertible on the unwanted region (everything except the single physical zero); a new doubler is a point of `Unwanted` where it becomes singular.

Requested outputs delivered:
1. Safest formulation = multiplicative/tensor coupling `K(q) ⊗ F` with an invertible texture. `kronecker_isUnit_iff_left` proves `IsUnit (K q ⊗ F) ↔ IsUnit (K q)` over a field (texture invertible, internal flavor space nonempty) — no gap assumption needed.
2. Main theorems:
   - `tensor_noNewDoubler`: invertible texture creates no new doubler.
   - `tensor_preserves_zero`: the physical zero is not washed out by an invertible texture.
   - `additive_noNewDoubler_of_gap`: the additive/mass-deformation coupling `K(q) + F(q)` (Kronecker sum `K⊗I + I⊗F`) is safe under an explicit gap condition — if the kernel is invertible with gap ≥ g (`‖(K q)⁻¹‖ ≤ 1/g`) and the texture stays strictly under the gap (`‖F q‖ < g`), no new doubler appears. Proved abstractly in any finite complex operator algebra via bounded-perturbation (`Units.add`). The genuine CKM case is the constant texture `F q = F₀`; q-dependence is allowed only under the pointwise gap bound.
3. Failure modes as rigorous counterexamples:
   - `fail_singular_texture`: a non-invertible texture (`F = 0`) makes the tensor kernel singular even at a perfectly regular kinetic factor — invertibility of `F` is indispensable; this is also the "gauge-mixing / wrong-tensor-factor" failure.
   - `fail_additive_sign_flip`: a sign flip whose norm reaches the gap (`‖F‖ = ‖(K)⁻¹‖⁻¹`) closes it and produces a new zero, proving the strict inequality `‖F q‖ < g` is sharp; this is also the mechanism by which a momentum-dependent CKM factor that climbs to the gap reintroduces a doubler.
4. Lean-ready statements are exactly the named theorems above (matrices over a field for the tensor case; abstract normed operator algebra for the additive case).
5. Interaction with C170/C181 and C175 is documented in the module docstring: `g` (doubler gap) and the texture-norm bound are the parametric slots to be instantiated by the C170/C181 mass-gap and texture constants, and the C175 no-go is respected because the hypotheses force the texture to act on a separate internal factor or as a small (quasi-)q-independent additive deformation — never as the kinetic operator.

The hypotheses are stated explicitly and not hidden; the additive coupling is shown to be unsafe without the gap condition, and the corrected safe couplings (invertible tensor coupling unconditionally, additive coupling under the strict gap bound) are the proven theorems.
