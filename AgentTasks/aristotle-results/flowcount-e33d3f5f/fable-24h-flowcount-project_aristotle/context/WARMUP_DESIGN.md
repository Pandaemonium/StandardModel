## 5. The 1+1 warm-up — exact statement + Lean sketch

In 1D a crossing is codimension-1 (an eigenphase through `±1`), so the charge is
the **group-velocity sign**, and — unlike 3D — the two gaps do **not** each sum to
zero: `Σ_0 (velocity sign) = Σ_π (velocity sign) = m` (the `det`-winding / the
`K₁`-type GNVW shadow **VERIFY** — Gross–Nesme–Vogts–Werner index for 1D QCA).
The invariant that *does* vanish pairs the gaps with a **relative sign** (the
"number of eigenvalues in the open upper semicircle" is a periodic integer whose
net change around the BZ is 0):

```
   Σ_{0-crossings} q  −  Σ_{π-crossings} q  =  0 ,     q := sign(group velocity).
```

A single crossing gives `±1 ≠ 0` on the left ⇒ impossible.

**Theorem (1+1 warm-up, exact statement — all hypotheses explicit).**
Let `N ≥ 1` and `U : ℂ[z, z^{-1}] → M_N(ℂ)` be given by a Laurent-polynomial
matrix `U(z) ∈ M_N(ℂ[z^{±1}])` such that `U(z) · U(z)^† = 1` for every
`z ∈ S¹ = {|z| = 1}` (finite-range, exactly unitary, 1D). Define the crossing set
`C := { z ∈ S¹ : det(U(z) − 1) · det(U(z) + 1) = 0 }`. Assume:
1. `C` is finite;
2. (nondegenerate, involutory tangent) at every `z₀ = e^{i k₀} ∈ C` there is a
   unique eigenvalue `λ(z)` of `U(z)` with `λ(z₀) ∈ {+1, −1}`, it is a **simple**
   eigenvalue of `U(z₀)`, and the real eigenphase `ε(k) := arg λ(e^{i k})` (the
   real-analytic branch through `k₀`) has `ε'(k₀) ≠ 0`.
Assign `q(z₀) := sign ε'(k₀)` if `λ(z₀) = +1` and `q(z₀) := −sign ε'(k₀)` if
`λ(z₀) = −1`. Then

```
   Σ_{z₀ ∈ C} q(z₀) = 0 .
```

**Corollary (the no-go, the actual deliverable statement).** *No finite-range 1D
walk has a single nondegenerate involutory-tangent crossing:* under hypotheses 1–2,
`|C| ≠ 1`. (A single crossing would give `Σ q = ±1 ≠ 0`.)

**Proof sketch.** Consider the integer `n(k) := #{ eigenvalues of U(e^{i k}) in the
open upper semicircle Im > 0, i.e. ε ∈ (0, π) }`. Since `U(e^{i k})` is a
continuous loop of unitaries and `C` is finite, `n` is locally constant off `C`
and changes only when an eigenphase crosses `0` (`+1`) or `π` (`−1`): crossing `+1`
upward `+1`, downward `−1`; crossing `π` upward `−1`, downward `+1`. So the jump of
`n` at `z₀` is exactly `q(z₀)`. As `k` traverses `[0, 2π]`, `n(2π) = n(0)`
(periodicity), so `Σ jumps = Σ q(z₀) = 0`. Simplicity + `ε'(k₀) ≠ 0` guarantee
each crossing is a genuine transversal `±1`-jump of a single band, so the jump
equals `q` and no cancellation is hidden inside a node. ∎

Lean-4 statement sketch (syntax only; not to be compiled here — degree-free,
uses only the eigenphase count):

```lean
-- import Mathlib
open scoped Matrix

/-- 1+1 warm-up: signed count of 0-crossings minus π-crossings vanishes;
    hence no single nondegenerate involutory-tangent crossing.  (SKETCH) -/
theorem oneD_no_single_involutory_crossing
    (N : ℕ)
    (U : ℂ[X;X⁻¹] →+* Matrix (Fin N) (Fin N) ℂ)   -- placeholder for a Laurent
                                                     -- matrix symbol z ↦ U z
    (Uunit : ∀ z : ℂ, ‖z‖ = 1 → (Usymb U z) * (Usymb U z)ᴴ = 1)
    (C : Finset ℂ)
    (hC : ∀ z, z ∈ C ↔ (‖z‖ = 1 ∧
            ((Usymb U z - 1).det = 0 ∨ (Usymb U z + 1).det = 0)))
    -- nondegenerate involutory-tangent data packaged as a charge function:
    (q : ℂ → ℤ)
    (hq : ∀ z ∈ C, q z = crossingCharge U z)          -- = ±1, sign of eigenphase
    (hsimple : ∀ z ∈ C, NondegInvolutoryCrossing U z) :  -- simple λ=±1, ε'≠0
    (∑ z ∈ C, q z) = 0 ∧ C.card ≠ 1 := by
  sorry
```

Here `Usymb`, `crossingCharge`, `NondegInvolutoryCrossing` are the interfaces to
be defined (§6 says which parts Mathlib already supports). The corollary
`C.card ≠ 1` follows from the sum being 0 and each `q z ∈ {−1, +1}`.

---

## 6. Feasibility verdict for Lean-4 + Mathlib (per ingredient)
