# Summary of changes for run a839c46d-b70e-48a8-9606-7e8004643c08
Delivered `RequestProject/Main.lean` (namespace `HiggsLongitudinalMode`) and `ARISTOTLE_SUMMARY.md`, a finite kernel-checked degree-of-freedom counting proof that a massive vector's third (longitudinal) polarization is the eaten null Goldstone / the mass. All content is explicit finite linear algebra over ℚ with the Minkowski metric `η = diag(1,-1,-1,-1)`.

Model: momentum `k : Fin 4 → ℚ`; the Minkowski dot-with-`k` is a linear functional `dotK k : (Fin 4 → ℚ) →ₗ[ℚ] ℚ`, and the transverse/polarization space is `LinearMap.ker (dotK k)`. The core lemma `finrank_ker_eq_three` shows this kernel is 3-dimensional whenever the functional is nonzero (rank–nullity).

Explicit rational witnesses (mandatory non-degeneracy): null `k_null = (1,1,0,0)` with `k·k = 0`; timelike `k_time = (5,3,0,0)` with `k·k = 25−9 = 16 = 4² > 0`; transverse `epsT1 = (0,0,1,0)`, `epsT2 = (0,0,0,1)`; longitudinal `epsL = (3,5,0,0)`.

Four headline theorems, each with the counts stated in-theorem:
1. `massless_two_polarizations` — for null `k_null`, the transverse-mod-gauge space (kernel quotiented by the gauge direction `k`, which lies in the kernel since `k·k = 0`) has dimension 2; the two transverse polarizations are exhibited (in-kernel + linearly independent).
2. `massive_three_polarizations` — for timelike `k_time`, the transverse space has dimension 3 (no gauge quotient); two transverse polarizations plus the longitudinal `epsL` are exhibited (all in-kernel + linearly independent, hence a basis).
3. `longitudinal_is_mass` — the exact count law `physDim k = 2 + [k·k ≠ 0]`, and the third polarization exists iff `k·k ≠ 0`; as m → 0 the gauge direction re-enters the kernel and the count drops 3 → 2.
4. `higgs_counting_verdict` — packages `physDim k_null = 2`, `physDim k_time = 3`, `physDim k_time = physDim k_null + 1`: `2 (transverse) + 1 (longitudinal/eaten Goldstone) = 3` for a massive vector, dropping to 2 when massless. `physDim k = finrank(ker(dotK k)) − [k·k = 0]` unifies both constructions.

Constraints satisfied: Mathlib-only (finrank/Submodule API, ring/norm_num/fin_cases); no sorry/admit/native_decide/new axioms/`@[implemented_by]`; no Complex, Real.sqrt, or trig; no high-degree nlinarith. The file builds via `lake build RequestProject.Main` in well under 3 minutes, and every headline theorem's axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with `#guard_msgs (whitespace := lax) in #print axioms …`. Honest scope: a finite DOF-counting statement, not the dynamical Higgs mechanism. All work is committed and pushed.

# Higgs longitudinal mode = mass (the eaten null Goldstone)

Finite, kernel-checked degree-of-freedom counting for vector-boson polarizations, the
gauge/Higgs-channel avatar of "mass from massless". All content is explicit finite linear
algebra over `ℚ` with the Minkowski metric `η = diag(1,-1,-1,-1)`.

File: `RequestProject/Main.lean`, namespace `HiggsLongitudinalMode`.

## Model

- Momentum `k : Fin 4 → ℚ`; the Minkowski "dot with `k`" is the linear functional
  `dotK k : (Fin 4 → ℚ) →ₗ[ℚ] ℚ`, `ε ↦ ∑ᵢ ηᵢ εᵢ kᵢ`.
- Transverse (polarization) space of `k` = `LinearMap.ker (dotK k)`.
- `finrank_ker_eq_three`: whenever the dot functional is nonzero, the transverse space is
  `3`-dimensional (rank–nullity: `dim ℚ⁴ = 4`, image `= ℚ`).

## Explicit rational witnesses (mandatory non-degeneracy)

- Null `k_null = (1,1,0,0)`, `k·k = 1 − 1 = 0`.
- Timelike `k_time = (5,3,0,0)`, `k·k = 25 − 9 = 16 = 4² > 0`.
- Transverse `epsT1 = (0,0,1,0)`, `epsT2 = (0,0,0,1)`; longitudinal `epsL = (3,5,0,0)`.

## Headline theorems (each with in-file `#print axioms` guard)

1. `massless_two_polarizations` — for null `k_null` (`k·k = 0`, `k ≠ 0`), the
   transverse-mod-gauge space (kernel quotiented by the gauge direction `k`, which lies
   in the kernel) has dimension `2`; the two transverse polarizations are exhibited
   (transverse + linearly independent).
2. `massive_three_polarizations` — for timelike `k_time` (`k·k = 16`), the transverse
   space has dimension `3` (no gauge quotient); two transverse polarizations plus the
   longitudinal `epsL` are exhibited (all transverse + linearly independent, hence a
   basis).
3. `longitudinal_is_mass` — the exact count law `physDim k = 2 + [k·k ≠ 0]`, with the
   third (longitudinal) polarization existing **iff** `k·k ≠ 0`; as `m → 0` the gauge
   direction re-enters the kernel and the count drops `3 → 2`.
4. `higgs_counting_verdict` — package: `physDim k_null = 2`, `physDim k_time = 3`,
   `physDim k_time = physDim k_null + 1`, i.e. `2 (transverse) + 1 (longitudinal/eaten
   Goldstone) = 3`, dropping to `2` when massless.

Here `physDim k = finrank (ker (dotK k)) − [k·k = 0]` unifies both real constructions:
for null `k` the gauge direction is in the kernel and is subtracted (`3 − 1 = 2`); for
timelike `k` it is not (`3 − 0 = 3`).

## Verification

- Builds with `lake build RequestProject.Main` (well under 3 min).
- No `sorry`/`admit`/`native_decide`, no new axioms, no `Complex`/`Real.sqrt`/trig.
- Axiom footprint of every headline theorem is exactly
  `[propext, Classical.choice, Quot.sound]`, checked in-file via
  `#guard_msgs (whitespace := lax) in #print axioms …`.

## Honest scope

This is a finite DOF-counting statement (`2 (massless) + 1 (Goldstone) = 3 (massive)`),
not the dynamical Higgs mechanism.
