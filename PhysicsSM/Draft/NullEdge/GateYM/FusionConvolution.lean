import Mathlib

/-!
# Gate YM1: fusion by convolution, abstract iteration core

This draft module starts the finite-group part of PKG-YM1-C from the overnight
YM run, following the convention correction in
`AgentTasks/overnight-ym-run-2026-07-03/PREP_NOTES.md` section 1 and the
statement freeze
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` section 4.

The oracle v0.2 Z3 complex-character fixture made the argument order
load-bearing: the general fusion lemma must be stated in convolution form

```text
sum_h w(h) chi(h^{-1} A) = c * chi(A),
```

not in the naive `chi(A h)` order unless the weight is inversion-symmetric.
This file proves the part of theorem 2 that does not need character theory:
once a function `chi` is an eigenfunction of this convolution operator, applying
the independent plaquette convolution `n` times multiplies it by `c^n`.

The character-orthogonality theorem that supplies `c = |G| w_hat_R / d_R` is a
successor statement. This module is the reusable finite-sum induction that turns
that one-step fusion identity into the exact area-law factor.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (abstract convolution iteration core for the
2D exact solution).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FusionConvolution

open BigOperators

variable {G : Type*} [Group G] [Fintype G]

/-- The convolution operator in the oracle-pinned argument order:
`(T_w chi)(A) = sum_h w(h) chi(h^{-1} A)`. -/
def convLeft (w chi : G → ℂ) (A : G) : ℂ :=
  ∑ h : G, w h * chi (h⁻¹ * A)

/-- Repeated independent plaquette convolution. The base case is the input
function `chi`; the successor step applies the same left-convolution operator
one more time. -/
def iterConv (w chi : G → ℂ) : ℕ → G → ℂ
  | 0, A => chi A
  | n + 1, A => ∑ h : G, w h * iterConv w chi n (h⁻¹ * A)

/-- If `chi` is an eigenfunction of the convolution operator with eigenvalue
`c`, then `n` independent plaquette convolutions multiply `chi` by `c^n`.

This is the formal induction behind the finite-group 2D exact solution after
the one-step fusion lemma has been supplied by character orthogonality. -/
theorem iterConv_eigen (w chi : G → ℂ) (c : ℂ)
    (heig : ∀ A : G, convLeft w chi A = c * chi A) :
    ∀ (n : ℕ) (A : G), iterConv w chi n A = c ^ n * chi A := by
  intro n
  induction n with
  | zero =>
      intro A
      simp [iterConv]
  | succ n ih =>
      intro A
      rw [iterConv]
      calc
        ∑ h : G, w h * iterConv w chi n (h⁻¹ * A)
            = ∑ h : G, w h * (c ^ n * chi (h⁻¹ * A)) := by
                refine Finset.sum_congr rfl ?_
                intro h _hh
                rw [ih]
        _ = c ^ n * ∑ h : G, w h * chi (h⁻¹ * A) := by
                rw [Finset.mul_sum]
                refine Finset.sum_congr rfl ?_
                intro h _hh
                ring
        _ = c ^ n * convLeft w chi A := by
                simp [convLeft]
        _ = c ^ n * (c * chi A) := by
                rw [heig A]
        _ = c ^ (n + 1) * chi A := by
                ring

end FusionConvolution
end GateYM
end NullEdge
end Draft
end PhysicsSM
