# Summary of changes for run eac17644-2c50-4674-8dad-6349e45865f6
Delivered `RequestProject/Main.lean` (namespace `Goal3BoostCov`) plus `ARISTOTLE_SUMMARY.md`, formalizing that discrete boost covariance of the Dirac quantum walk is emergent at criticality. Mathlib-only, kernel-checked (no sorry/admit/native_decide/new axiom); both headline theorems are pinned in-file to footprint exactly `[propext, Classical.choice, Quot.sound]`. Builds with `lake build RequestProject.Main`.

Boost operator: `Boost c s = !![c,s;s,c]` acting on momentum `(ω,k)`; when `c²−s²=1` it has `det=1` (`boost_det`) and exactly preserves the Minkowski form `Q(ω,k)=ω²−k²` (`boost_preserves_form`). Nontrivial rational witness: the 3-4-5 boost `Lam = Boost (5/3) (4/3)`, with `lam_det : det=1` and `lam_ne_one : Lam ≠ 1`.

Both members of the theorem pair landed:
1. `massless_walk_boost_covariant` (WIN): on the massless line the shell is the light cone `Q=0`; `Lam` has `det=1`, is `≠1`, preserves `Q` for every momentum and hence maps the massless shell to itself; concrete fixture `(π/3,π/3) ↦ (π,π)`, both on the massless lattice shell `cos ω = cos k`.
2. `massive_walk_boost_covariance_fails` (KILL): off criticality (θ=π/3, cos²θ=1/4≠1) the same 3-4-5 boost does NOT preserve the lattice shell `cos ω = cos k · cos θ`: `(π/3,0) ↦ (5π/9,4π/9)` leaves the shell, via a clean sign obstruction `cos(5π/9)<0<cos(4π/9)·cos(π/3)`.

Honest note (also in the summary and file docstring): the covariance proved is mass-shell-set invariance plus exact invariance of the Minkowski form `Q`, not a fixed-operator spinor intertwiner (none exists, since `Ushift k` has boost-rescaled eigenvalues). The massive breaking is specifically a lattice effect of the transcendental dispersion; the continuum quadratic massive shell would itself be boost invariant, so the lattice shell is the faithful object used for the failure theorem.

The provided `seeds/` files (which carry a `PhysicsSM.…` module prefix from the wider repo and do not resolve as a standalone default target) were left untouched; the deliverable is standalone and imports only Mathlib.

# Goal III rung (e) — discrete boost covariance emerges at criticality

Deliverable: `RequestProject/Main.lean`, namespace `Goal3BoostCov`. Mathlib only,
kernel-checked (no `sorry`/`admit`/`native_decide`/new `axiom`). Both headline
theorems are pinned in-file with `#guard_msgs (whitespace := lax) in #print axioms`
to footprint exactly `[propext, Classical.choice, Quot.sound]`.

## The boost operator

`Boost c s = !![c, s; s, c]` acts on the momentum 2-vector `v = (ω, k)` (with
`v 0 = ω`, `v 1 = k`) by `Matrix.mulVec`. When `c² − s² = 1` it is a Lorentz
boost: `det = c² − s² = 1` (`boost_det`) and it exactly preserves the Minkowski
quadratic form `Q(ω,k) = ω² − k²` for *every* momentum (`boost_preserves_form`),
so its zero level set (the light cone `ω = ±k`) is invariant.

## The nontrivial rational witness

`Lam = Boost (5/3) (4/3)` — the **3-4-5 boost**, `(5/3)² − (4/3)² = 25/9 − 16/9 = 1`.
It is genuinely nontrivial:
- `lam_det : Lam.det = 1`;
- `lam_ne_one : Lam ≠ 1` (rapidity `φ = artanh(4/5) ≠ 0`).

## Which theorems landed — BOTH

Both members of the theorem pair are proved.

1. **`massless_walk_boost_covariant` (the WIN).** On the massless line the mass
   shell is the light cone `Q = 0` (seed `conical_dispersion_z_eq_one`: `ω = ±k`).
   The 3-4-5 boost has `det = 1`, is `≠ 1`, preserves `Q` for every momentum, and
   hence maps the massless shell `Q = 0` to itself. Concrete lattice fixture:
   the massless-shell point `(ω,k) = (π/3, π/3)` boosts to `(π, π)`, again on the
   massless lattice shell `cos ω = cos k`.

2. **`massive_walk_boost_covariance_fails` (the KILL of trivial universality).**
   Off the critical line (mass angle `θ = π/3`, `cos²θ = 1/4 ≠ 1`), the SAME
   3-4-5 boost does NOT preserve the hyperbolic-shifted lattice shell
   `cos ω = cos k · cos θ`: the on-shell point `(ω,k) = (π/3, 0)` boosts to
   `(5π/9, 4π/9)`, which leaves the shell. The obstruction is a clean sign
   argument: `cos(5π/9) < 0` (since `5π/9 ∈ (π/2, π)`) while
   `cos(4π/9)·cos(π/3) > 0` (since `4π/9 ∈ (0, π/2)`), so they cannot be equal.

Together: discrete boost covariance is exact on the massless (critical) line and
broken by any nonzero mass — Lorentz symmetry is emergent at criticality.

## Honest note on the form of covariance proved

The covariance landed is **mass-shell-set invariance** (plus exact invariance of
the Minkowski form `Q` under the boost), not a full spinor intertwiner
`U(Λ·p) = S(Λ) U(p) S(Λ)⁻¹`. This is faithful: no fixed-operator intertwiner
exists, because `Ushift k = diag(e^{-ik}, e^{ik})` has boost-rescaled eigenvalues
`e^{∓iβk}`, so walk operators at distinct momenta are not similar. Discrete boost
covariance is genuinely a statement about the dispersion *set*, which is exactly
what is proved here.

A further honest caveat: the *continuum* massive shell `ω² − k² = m²` would be a
`Q`-level set and hence boost invariant — the massive Dirac equation is Lorentz
covariant in the continuum. The covariance breaking in target 2 is specifically a
**lattice** effect of the transcendental dispersion `cos ω = cos k · cos θ`, and
that is precisely the shell used in `massive_walk_boost_covariance_fails`.

## Build notes

`RequestProject/Main.lean` imports only `Mathlib` and is standalone; it builds
with `lake build RequestProject.Main`. (The `seeds/` files are reference material
carrying a `PhysicsSM.…` module prefix inherited from the wider repo and were left
untouched.)
