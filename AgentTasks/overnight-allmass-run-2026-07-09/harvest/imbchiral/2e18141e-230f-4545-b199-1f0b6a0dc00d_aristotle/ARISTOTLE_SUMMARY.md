# Summary of changes for run 2e18141e-230f-4545-b199-1f0b6a0dc00d
Delivered `RequestProject/Main.lean` (namespace `ImbalancedChiralProtection`) and `ARISTOTLE_SUMMARY.md`, formalizing the correct chiral zero-mode protection for an *imbalanced* grading, replacing the rigged balanced toy. The project builds cleanly with no warnings, and every headline theorem carries an in-file `#print axioms` guard confirming the exact footprint `[propext, Classical.choice, Quot.sound]` (no sorry/admit/native_decide/new axioms; Mathlib-only; no Real/Complex; proofs via `fin_cases`/`simp`/`ring`/`norm_num`).

Model: `Gamma = diag(1,1,-1)` on ℚ³, `H+ = span(e₀,e₁)` (dim 2), `H- = span(e₂)` (dim 1). Odd operator `D b0 b1 c0 c1 = !![0,0,b0; 0,0,b1; c0,c1,0]`; even operator `E a b c = diag(a,b,c)`.

Results:
- `D_is_odd`: `Γ·D = -D·Γ`; `E_is_even`: `Γ·E = E·Γ`.
- `index_is_one`: `tr Γ = 1 = dim H+ − dim H-` (imbalanced).
- `D_mulVec_kernel` / `odd_has_zero_mode` (payload): for every odd `D` there is a nonzero `v ∈ H+` (`v 2 = 0`) with `D v = 0`, via the `1×2`-kernel argument (`v = ![c1,-c0,0]`, or `e₀` when `(c0,c1)=0`) — robust to every odd perturbation.
- `odd_zero_mode_witness`: explicit non-degenerate case `b = c = (1,1)`, `v = ![1,-1,0]`.
- `even_can_gap`: the grading-breaking even term `E 1 0 0 = diag(1,0,0)` added to odd base `D 0 0 0 1` acts on `H+` as the invertible block `diag(1,1)` (det 1 ≠ 0), leaving no nonzero zero mode in `H+`.
- `chiral_protection_verdict`: packages imbalance + every-odd-perturbation protection + even-gap contrast.

Honest scope noted in docstrings/summary: a finite rational avatar whose robustness is the `1×2`-kernel rank argument valid for any imbalanced grading — the genuine index/SSH-BdG protection the balanced 2D toy could not exhibit. All work is committed and pushed.

# Imbalanced grading ⇒ genuine chiral zero-mode protection

`RequestProject/Main.lean` (namespace `ImbalancedChiralProtection`) formalizes the *correct*
chiral zero-mode protection statement, replacing the rigged balanced 2D toy that could not exhibit it.

## Model (finite, rational)

- `Gamma = diag(1,1,-1)` on `ℚ³`: `H+ = span(e₀,e₁)` (dim 2), `H- = span(e₂)` (dim 1), index `+1`.
- Odd operator (anticommutes with `Γ`): `D b0 b1 c0 c1 = !![0,0,b0; 0,0,b1; c0,c1,0]`.
- Even operator (commutes with `Γ`): `E a b c = diag(a,b,c)`.

## Results (all kernel-checked, footprint `[propext, Classical.choice, Quot.sound]`)

1. `D_is_odd` — `Γ · D = -D · Γ` for all coefficients; `E_is_even` — `Γ · E = E · Γ`.
2. `index_is_one` — `tr Γ = 1 = dim H+ - dim H-`: the grading is imbalanced.
3. `D_mulVec_kernel` / `odd_has_zero_mode` (payload) — for **every** odd `D` there is a nonzero
   `v ∈ H+` (`v 2 = 0`) with `D v = 0`. The `H+ → H-` block `(c0,c1)` is a `1×2` map, so its kernel
   is ≥ `2 − 1 = 1`-dimensional: witness `v = ![c1,-c0,0]` (its `H-` output is `c0·c1 − c1·c0 = 0`),
   or `e₀` when `(c0,c1) = 0`. This is genuine robustness — the mode survives every odd perturbation.
4. `odd_zero_mode_witness` — explicit non-degenerate case `b = c = (1,1)` with `v = ![1,-1,0]`.
5. `even_can_gap` (honest contrast) — the even, grading-breaking term `E 1 0 0 = diag(1,0,0)` added
   to the odd base `D 0 0 0 1` acts on `H+` as the invertible block `diag(1,1)` (det `1 ≠ 0`), so the
   sum has **no** nonzero zero mode in `H+`.
6. `chiral_protection_verdict` — packages the imbalance (`tr Γ = 1`), the every-odd-perturbation
   protection, and the even-gap contrast.

Each headline theorem is followed by an in-file `#guard_msgs (whitespace := lax) in #print axioms`
check confirming the exact `[propext, Classical.choice, Quot.sound]` footprint. No
`sorry`/`admit`/`native_decide`/new axioms; Mathlib-only; proofs use `fin_cases`/`simp`/`ring`/
`norm_num`; no `Real`/`Complex`. Honest scope: a finite rational avatar; the robustness is the
`1×2`-kernel rank argument valid for any imbalanced grading, not a cherry-picked example.
