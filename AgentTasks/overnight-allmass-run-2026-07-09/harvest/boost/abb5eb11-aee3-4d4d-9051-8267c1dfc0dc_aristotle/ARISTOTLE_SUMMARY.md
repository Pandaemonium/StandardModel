# Summary of changes for run abb5eb11-aee3-4d4d-9051-8267c1dfc0dc
Delivered `RequestProject/Main.lean` (namespace `RationalBoostInvariance`) plus `ARISTOTLE_SUMMARY.md`, a self-contained, purely rational finite-matrix development. The project builds cleanly with `lake build` (~11s, well under 3 min) with no `sorry`/`admit`/`native_decide`/new axioms; every headline theorem's axiom footprint is verified in-file via `#guard_msgs (whitespace := lax) in #print axioms <thm>` to be exactly `[propext, Classical.choice, Quot.sound]`.

Model (all over ℚ): `eta2 = !![1,0;0,-1]`, boost `L = !![5/4,3/4;3/4,5/4]` (from β=3/5 ⇒ γ=5/4, γβ=3/4), pairing `mdot2 u v = u₀v₀ − u₁v₁`, and spinor matrix `Pmat E k = !![E+k,0;0,E−k]`.

Results proved:
1. `boost_on_shell : Lᵀ * eta2 * L = eta2` (metric preserved) and `det_boost : det L = 1`.
2. `boost_preserves_interval : ∀ p, mdot2 (L *ᵥ p) (L *ᵥ p) = mdot2 p p` (interval invariant).
3. `mass_boost_invariant` (payload): `det (Pmat (L*ᵥ(E,k))₀ (L*ᵥ(E,k))₁) = det (Pmat E k)`, with `det_Pmat : det (Pmat E k) = E² − k²` — the mass² is boost-invariant.
4. `frame_dependence_control : (L*ᵥ(1,0))₀ ≠ (1,0)₀` — a single component (naive minor) changes, unlike the determinant.
5. `boost_invariance_verdict` packages all of the above.

Non-degeneracy witnesses included in-file: `boost_of_rest` ((1,0) ↦ (5/4,3/4)), `massive_witness` (p=(5,3), m²=16 preserved), `null_witness` (p=(1,1) stays null).

Techniques used: `fin_cases` + `Matrix.mul_apply`/`Matrix.det_fin_two` + `norm_num`/`ring`; no Real/Complex, no `nlinarith`. Scope is honestly a 1+1D rational SO(1,1) boost avatar tied to the (+,-,-,-) convention, not the full SO(1,3), as documented in the file and summary. All work is committed and pushed.

# Rational-boost invariance of the Plücker mass

`RequestProject/Main.lean` (namespace `RationalBoostInvariance`) is a self-contained, purely
rational finite-matrix development showing that "mass = det P" is genuinely frame-independent
*because* it is the little-group spinor determinant, not an arbitrary 4-vector minor.

## Model (all over `ℚ`, `(+,-)`/(+,-,-,-) convention)

- `eta2 = !![1, 0; 0, -1]` — the `(t,x)` Minkowski metric.
- `L = !![5/4, 3/4; 3/4, 5/4]` — the explicit rational Lorentz boost from the Pythagorean
  rapidity `β = 3/5 ⇒ γ = 5/4`, `γβ = 3/4` (`γ² − (γβ)² = 25/16 − 9/16 = 1`).
- `mdot2 u v = u₀v₀ − u₁v₁` — the Minkowski square pairing.
- `Pmat E k = !![E+k, 0; 0, E−k]` — the little-group Hermitian (here real) matrix, with
  `det Pmat = E² − k²`.

## Results (all kernel-checked, no `sorry`/`native_decide`/new axiom)

1. `boost_on_shell : Lᵀ * eta2 * L = eta2` — `L` preserves the metric; `det_boost : det L = 1`.
2. `boost_preserves_interval : ∀ p, mdot2 (L *ᵥ p) (L *ᵥ p) = mdot2 p p` — the interval is invariant.
3. `mass_boost_invariant` (payload): `det (Pmat (L *ᵥ (E,k))₀ (L *ᵥ (E,k))₁) = det (Pmat E k)` —
   the spinor determinant (mass²) is boost-invariant. Supported by `det_Pmat : det (Pmat E k) = E² − k²`.
4. `frame_dependence_control : (L *ᵥ (1,0))₀ ≠ (1,0)₀` — a single component (a naive minor) DOES
   change under the boost, unlike the determinant.
5. `boost_invariance_verdict` — packages all of the above into one statement.

Non-degeneracy witnesses (in-file): `boost_of_rest` (`(1,0) ↦ (5/4, 3/4)`), `massive_witness`
(`p = (5,3)`, `m² = 16` preserved), `null_witness` (`p = (1,1)` stays null).

Each headline theorem is checked in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>`, confirming the footprint is exactly
`[propext, Classical.choice, Quot.sound]`.

**Honest scope.** This is a `1+1`D rational boost avatar (`SO(1,1)`), tied to the `(+,-,-,-)`
convention; it is not the full `SO(1,3)`.

The project builds cleanly (`lake build`) in well under 3 minutes.
