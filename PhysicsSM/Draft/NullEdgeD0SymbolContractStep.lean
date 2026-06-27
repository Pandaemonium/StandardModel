import Mathlib
import PhysicsSM.Draft.NullEdgeD0PositiveProxy

/-!
# D19 / Gate D0 — first implemented symbol-contract step

This module is the Aristotle deliverable for proof-chain task **D19** of the
null-edge unified-mass program.  Task **D18**
(`PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean`) packaged the open continuum
gate **D0** as *contracts* — bundled `Prop`s such as

* `D0PositiveProxy.D0SymbolContract` for `‖[D_h, M_f] − c(df)‖ ≤ C·h`, and
* `D0PositiveProxy.D0QuadratureContract` for `|quad_h f − g⁻¹(df,df)| ≤ C·h`,

without inhabiting them.  This file takes the **smallest honest next step**: it
turns the *finite commutator identity* into an *implemented finite estimate*, and
**inhabits one of the two D0 contracts** in a concrete positive/Euclidean
scalar finite-difference model.

## Scope and honesty discipline (unchanged from D18)

* Everything here is **positive / Euclidean / Hodge–Dirac**.  No Lorentzian,
  Krein, retarded, or advanced claim is made or used.  The scalar model is the
  doubly-diagonal Euclidean regime that the d17
  `gauge_euclidean_collapse_guardrail` isolates.
* The file is `sorry`-free and axiom-clean.  It contains genuinely proven finite
  identities and a genuinely proven `O(h)` estimate, and uses them to inhabit
  `D0QuadratureContract` for a concrete model.

## What is proved here

1. **Finite Dirac commutator Leibniz identity** (`dirac_comm_leibniz`).  The pure
   associative-ring step
   `[∑_a C_a ∇_a, M_f] = ∑_a C_a [∇_a, M_f]`,
   valid whenever the scalar multiplier `M_f` commutes with each Clifford
   generator `C_a` (the physical statement that `f` is a scalar and the `C_a`
   act on spinor indices).  This is the algebraic backbone of `[D_h, M_f]`.

2. **Scalar finite-difference exact commutator identity** (`fdiff_comm_exact`).
   The exact (no error term) discrete Leibniz rule
   `[∇_h, M_f] u = (∇_h f) · (τ_h u)`,
   where `∇_h` is the forward difference quotient at mesh `h` and `τ_h` the
   shift.  This is the concrete realisation of one Clifford channel of
   `[D_h, M_f]`.

3. **First-order symbol consistency** (`fd_deriv_consistency`).  The genuine
   `O(h)` estimate
   `|(f(h) − f(0))/h − f′(0)| ≤ M·h`
   under a uniform bound `M` on the second derivative.  This is the analytic
   heart of `[D_h, M_f] = c(df) + O(h)` reduced to one scalar channel.

4. **Contract inhabitation** (`d0_quadrature_contract_fd`).  Combining 3 with an
   elementary `a² − b² = (a−b)(a+b)` bound, we *prove*
   `D0QuadratureContract fdQuad derivSq`
   for the concrete finite-difference quadrature `fdQuad h f = ((f(h)−f(0))/h)²`
   converging to `derivSq f = f′(0)²`.  This is the first time a D0 contract is
   turned from a *stated* obligation into an *implemented* theorem.

## What remains before Gate D proper (explicit list)

* **Operator-norm `D0SymbolContract`.**  Inhabiting the operator-level contract
  needs a fixed (`h`-independent) proxy operator space with a genuine operator
  (semi)norm, plus uniform-in-`h` control of `(∇_h f)·τ_h − f′·` in that norm.
  Items 2–3 give the pointwise content; the missing API is a function-space
  norm with a `‖·‖`-version of `fd_deriv_consistency` uniform over a compact set.
* **Multi-edge Clifford assembly.**  Combining `dirac_comm_leibniz` with the
  per-channel estimate to bound `‖[D_h,M_f] − ∑_a C_a (∂_a f)·‖`; needs a
  Clifford-module norm and the finite tetrad postulate `[∇_a, C_b] = 0`.
* **DEC / Whitney / de Rham reconstruction.**  Identifying the finite proxy
  Dirac `D_h` with the de Rham–Hodge–Dirac operator under mesh refinement; not
  yet in scope and unchanged from the D18 statement.
* Everything downstream (connection/holonomy perturbation, dual-soldered
  Clifford symbol, Lorentzian/Krein audit, retarded perturbation) remains open
  and is deliberately untouched here.
-/

namespace PhysicsSM
namespace Draft
namespace D0SymbolContractStep

open scoped BigOperators

/-! ## 1. Finite Dirac commutator Leibniz identity (pure ring) -/

/-
**Finite Dirac commutator Leibniz identity.**  In any associative ring, for a
finite Clifford family `C` and connection family `nab`, if the scalar multiplier
`m` (the proxy `M_f`) commutes with every Clifford generator `C a`, then the
commutator of the finite Dirac operator `D_N = ∑_a C_a ∇_a` with `m` distributes
over the Clifford generators:

```text
[∑_a C_a ∇_a, m] = ∑_a C_a [∇_a, m].
```

This is the algebraic backbone of `[D_h, M_f]`: the whole `h`-dependence and all
the symbol content is concentrated in the per-channel commutators `[∇_a, m]`.
-/
theorem dirac_comm_leibniz
    {ι : Type*} [Fintype ι] {A : Type*} [Ring A]
    (C nab : ι → A) (m : A) (hcomm : ∀ a, m * C a = C a * m) :
    (∑ a, C a * nab a) * m - m * (∑ a, C a * nab a)
      = ∑ a, C a * (nab a * m - m * nab a) := by
  simp +decide [ mul_sub, ← mul_assoc, Finset.sum_mul, Finset.mul_sum, hcomm ]

/-! ## 2. Scalar finite-difference exact commutator identity -/

/-- Forward shift by mesh `h`. -/
def shiftF (h : ℝ) (u : ℝ → ℝ) : ℝ → ℝ := fun x => u (x + h)

/-- Forward finite-difference quotient at mesh `h` (the scalar proxy `∇_h`). -/
noncomputable def fdiff (h : ℝ) (u : ℝ → ℝ) : ℝ → ℝ := fun x => (u (x + h) - u x) / h

/-- Pointwise multiplication operator `M_f`. -/
def mulF (f u : ℝ → ℝ) : ℝ → ℝ := fun x => f x * u x

/-
**Exact scalar finite-difference commutator identity.**  The discrete
Leibniz rule with no error term:

```text
[∇_h, M_f] u = (∇_h f) · (τ_h u),
```

i.e. `∇_h (f·u) − f·(∇_h u) = (∇_h f)·(τ_h u)`.  This is the concrete realisation
of a single Clifford channel of `[D_h, M_f]` and holds for every mesh `h`
(including `h = 0`, where both sides vanish).
-/
theorem fdiff_comm_exact (h : ℝ) (f u : ℝ → ℝ) :
    fdiff h (mulF f u) - mulF f (fdiff h u) = mulF (fdiff h f) (shiftF h u) := by
  funext x; simp +decide [ mulF, shiftF, fdiff ] ; ring

/-! ## 3. First-order symbol consistency estimate -/

/-
**First-order symbol consistency.**  If `f` is differentiable, its derivative
is differentiable, and the second derivative is bounded by `M`, then the forward
difference quotient approximates the derivative to first order:

```text
|(f(h) − f(0))/h − f′(0)| ≤ M · h    (for h > 0).
```

This is the analytic core of `[∇_h, M_f] = c(df) + O(h)` for one scalar channel:
the discrete symbol `∇_h f` converges to the principal symbol `f′` at rate `h`.
-/
theorem fd_deriv_consistency
    (f : ℝ → ℝ) (hf : Differentiable ℝ f) (hf' : Differentiable ℝ (deriv f))
    (M : ℝ) (hM : ∀ x, |deriv (deriv f) x| ≤ M) {h : ℝ} (hh : 0 < h) :
    |(f h - f 0) / h - deriv f 0| ≤ M * h := by
  have h_bound : ∀ x ∈ Set.Icc 0 h, |deriv f x - deriv f 0| ≤ h * M := by
    intro x hx; by_cases hx' : x = 0 <;> simp_all +decide [ mul_comm ] ;
    · exact le_trans ( abs_nonneg _ ) ( hM 0 );
    · have := exists_deriv_eq_slope ( f := deriv f ) ( show x > 0 from lt_of_le_of_ne hx.1 ( Ne.symm hx' ) );
      exact this ( hf'.continuous.continuousOn ) ( hf'.differentiableOn ) |> fun ⟨ c, hc₁, hc₂ ⟩ => abs_le.mpr ⟨ by nlinarith [ abs_le.mp ( hM c ), mul_div_cancel₀ ( deriv f x - deriv f 0 ) ( sub_ne_zero_of_ne hx' ) ], by nlinarith [ abs_le.mp ( hM c ), mul_div_cancel₀ ( deriv f x - deriv f 0 ) ( sub_ne_zero_of_ne hx' ) ] ⟩;
  -- By the Mean Value Theorem, there exists some $c \in (0, h)$ such that $f(h) - f(0) = deriv f(c) * h$.
  obtain ⟨c, hc⟩ : ∃ c ∈ Set.Ioo 0 h, f h - f 0 = deriv f c * h := by
    have := exists_deriv_eq_slope f hh;
    exact this ( hf.continuous.continuousOn ) ( hf.differentiableOn ) |> fun ⟨ c, hc₁, hc₂ ⟩ => ⟨ c, hc₁, by rw [ hc₂, sub_zero, div_mul_cancel₀ _ hh.ne' ] ⟩;
  grind +splitImp

/-! ## 4. Inhabiting the D0 quadrature contract -/

/-- Regularity class of admissible test scalars for the Euclidean scalar proxy:
differentiable functions with differentiable, uniformly bounded second
derivative.  Every such function admits the `O(h)` finite-difference estimate. -/
def NiceFn : Type :=
  {f : ℝ → ℝ //
    Differentiable ℝ f ∧ Differentiable ℝ (deriv f) ∧
      ∃ M : ℝ, 0 ≤ M ∧ ∀ x, |deriv (deriv f) x| ≤ M}

/-- Concrete finite-difference scalar null-quadrature at mesh `h`, evaluated at
the origin with unit null edge: `fdQuad h f = ((f(h) − f(0))/h)²`.  This is the
positive Euclidean (doubly-diagonal) face of the d17 inverse-Gram quadrature. -/
noncomputable def fdQuad (h : ℝ) (F : NiceFn) : ℝ := ((F.1 h - F.1 0) / h) ^ 2

/-- The continuum target of `fdQuad`: `derivSq f = f′(0)²`, i.e. `g⁻¹(df,df)`
in the Euclidean unit-edge model. -/
noncomputable def derivSq (F : NiceFn) : ℝ := (deriv F.1 0) ^ 2

/-
**First implemented D0 contract.**  The finite-difference scalar quadrature
`fdQuad` satisfies the D18 `D0QuadratureContract` with continuum value `derivSq`:
for every admissible `f` there is a uniform constant `C ≥ 0` and a mesh threshold
`h₀ > 0` with

```text
|fdQuad_h f − f′(0)²| ≤ C · h    for all 0 < h ≤ h₀.
```

This turns the stated D0 quadrature obligation into a proven finite estimate in
the positive/Euclidean Hodge–Dirac proxy regime.
-/
theorem d0_quadrature_contract_fd :
    PhysicsSM.Draft.D0PositiveProxy.D0QuadratureContract fdQuad derivSq := by
  intro F;
  obtain ⟨ M, hM₀, hM ⟩ := F.2.2.2;
  refine' ⟨ M * ( 2 * |deriv F.1 0| + M ), _, 1, _, _ ⟩ <;> try positivity;
  intro h hh hh'; have := fd_deriv_consistency F.1 F.2.1 F.2.2.1 M hM hh; simp_all +decide [ fdQuad, derivSq ] ;
  rw [ abs_le ] at *;
  constructor <;> cases abs_cases ( deriv F.val 0 ) <;> nlinarith [ mul_le_mul_of_nonneg_left hh'.ge hM₀ ]

end D0SymbolContractStep
end Draft
end PhysicsSM
