import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.NullNilpotentSquare

/-!
# Move-1 BRICK 2a — the soldered square IS the aperture Gram form `Q_A`

**Move-1's second finite brick of the null-edge Weitzenbock carrier program.**

Building directly on brick 1 (`NullNilpotentSquare.lean`, which supplies the
soldered element `nullSoldered Q α x = ∑ e, xₑ • c(αₑ)` and the null Clifford
nilpotency lemmas), this module proves the *headline* structural fact of the
scalar-∇ skeleton:

> With commuting **scalar** edge weights, the null-soldered square symmetrizes to
> EXACTLY the aperture Gram form `Q_A` — one half of the full Gram double sum of
> the polarization (associated bilinear form) — and this square is a pure
> **scalar (grade-0)** element of the Clifford algebra.

The polarization keystone `CliffordAlgebra.ι_mul_ι_add_swap` turns the
anticommutator `c(αₑ)c(αf) + c(αf)c(αₑ)` into `algebraMap R _ (polar Q αₑ αf)`;
symmetrizing the double sum (legal precisely because the scalar weights commute,
`xₑ xf = xf xₑ`) collapses everything onto that symmetric Gram scalar.

## The honest delimiter: why `Q_C` needs gauge-covariant `∇`

The final result `nullSoldered_square_isScalar` shows the soldered square lands in
the image of `algebraMap R (CliffordAlgebra Q)` — it is a pure `Q_A` Gram scalar
with **no bivector part**.  In the Weitzenbock decomposition
`D^#D = Q_A + Q_C + Q_T + E`, the closure bivector slot `Q_C` is exactly the
grade-2 (bivector) content of the square.  Here it vanishes *identically*, and the
proof pinpoints the reason: the symmetrization step consumes `xₑ xf = xf xₑ`.  A
nontrivial `Q_C` therefore REQUIRES **non-commuting** weights — i.e.
gauge-covariant derivatives `∇_e` whose curvature does not cancel — which is the
honest motivation for brick 2 (the 2-complex + covariant `∇`).

## Scope / honesty (draft-trust, finite algebraic identity)

This is still the **scalar-∇ skeleton** (brick 1's simplification): the weights
`x e` are commuting stand-ins for covariant derivatives.  The headline identifies
the scalar-weight soldered square with `Q_A` EXACTLY and proves the `Q_C` bivector
slot is absent under commuting weights — an honest *structural* result, NOT the
full decomposition (no gauge holonomy, no Krein `#`-adjoint, no potential `Φ`).
Everything below is a finite Clifford-algebra identity over a field of
characteristic `≠ 2`, kernel-checked and free of `sorry`/`axiom`/`native_decide`.

## Main results

* `clifford_anticomm_polar` : the polarization keystone
  `c(a)c(b) + c(b)c(a) = algebraMap R _ (polar Q a b)` (a thin restatement of
  `CliffordAlgebra.ι_mul_ι_add_swap`).
* `nullSoldered_square_eq_half_gram` : **the headline** — the soldered square
  equals one half of the full Gram double sum of the polarization, a scalar.
* `nullSoldered_square_gram_offDiag` : for NULL `α`, the diagonal drops
  (`polar Q αₑ αₑ = 2 Q αₑ = 0`), so the Gram sum runs over distinct pairs.
* `nullSoldered_square_eq_algebraMap` : the explicit scalar value of the square.
* `nullSoldered_square_isScalar` : the square lies in the image of `algebraMap`
  (the `Q_C` bivector slot is absent) — the honest delimiter for brick 2.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R V : Type*} [Field R] [AddCommGroup V] [Module R V]

/-- **Polarization keystone.**  In the Clifford algebra the anticommutator of two
vector generators is the scalar image of the polarization (associated bilinear
form) of the quadratic form: `c(a)c(b) + c(b)c(a) = algebraMap R _ (polar Q a b)`.
Since `polar Q a b = Q (a+b) - Q a - Q b = 2 · g(a,b)`, this is the algebraic
bridge from the Clifford product to the Gram/aperture form `Q_A`.  This is a thin
restatement of `CliffordAlgebra.ι_mul_ι_add_swap`. -/
theorem clifford_anticomm_polar (Q : QuadraticForm R V) (a b : V) :
    CliffordAlgebra.ι Q a * CliffordAlgebra.ι Q b
      + CliffordAlgebra.ι Q b * CliffordAlgebra.ι Q a
      = algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) a b) :=
  CliffordAlgebra.ι_mul_ι_add_swap a b

section Soldered

variable {E : Type*} [Fintype E]

/-- **Headline (the `Q_A` Gram identity).**  The square of the null-soldered
element equals one half of the full Gram double sum of the polarization — a
central (scalar) element:
`D0² = 2⁻¹ • ∑ e, ∑ f, (xₑ xf) • algebraMap R _ (polar Q αₑ αf)`.

No nullity is needed: this holds for arbitrary vectors `α`.  Proof: expand the
square with `nullSoldered_square_expand` (brick 1); symmetrize the double sum,
which is legal precisely because the scalar weights commute (`xₑ xf = xf xₑ`,
used through `hswap`); then rewrite each anticommutator with the polarization
keystone `clifford_anticomm_polar`.  Characteristic `≠ 2` (`h2 : (2:R) ≠ 0`) is
used to divide by the resulting factor of `2`. -/
theorem nullSoldered_square_eq_half_gram (Q : QuadraticForm R V) (alpha : E → V)
    (x : E → R) (h2 : (2 : R) ≠ 0) :
    nullSoldered Q alpha x ^ 2
      = (2 : R)⁻¹ • ∑ e, ∑ f, (x e * x f) •
          algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) (alpha e) (alpha f)) := by
  set S := ∑ e, ∑ f,
      (x e * x f) • (CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha f)) with hS
  have hexp : nullSoldered Q alpha x ^ 2 = S := nullSoldered_square_expand Q alpha x
  have hswap :
      (∑ e, ∑ f,
          (x e * x f) • (CliffordAlgebra.ι Q (alpha f) * CliffordAlgebra.ι Q (alpha e))) = S := by
    rw [hS, Finset.sum_comm]
    refine Finset.sum_congr rfl (fun e _ => Finset.sum_congr rfl (fun f _ => ?_))
    rw [mul_comm (x f) (x e)]
  have hT : (∑ e, ∑ f, (x e * x f) •
      algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) (alpha e) (alpha f)))
      = (2 : R) • S := by
    have hpolar : ∀ e f,
        algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) (alpha e) (alpha f))
          = CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha f)
            + CliffordAlgebra.ι Q (alpha f) * CliffordAlgebra.ι Q (alpha e) := fun e f =>
      (clifford_anticomm_polar Q (alpha e) (alpha f)).symm
    calc ∑ e, ∑ f, (x e * x f) •
          algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) (alpha e) (alpha f))
        = ∑ e, ∑ f,
            ((x e * x f) • (CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha f))
              + (x e * x f) • (CliffordAlgebra.ι Q (alpha f) * CliffordAlgebra.ι Q (alpha e))) := by
          refine Finset.sum_congr rfl (fun e _ => Finset.sum_congr rfl (fun f _ => ?_))
          rw [hpolar e f, smul_add]
      _ = S + ∑ e, ∑ f,
            (x e * x f) • (CliffordAlgebra.ι Q (alpha f) * CliffordAlgebra.ι Q (alpha e)) := by
          rw [← Finset.sum_add_distrib]
          refine Finset.sum_congr rfl (fun e _ => ?_)
          rw [Finset.sum_add_distrib]
      _ = S + S := by rw [hswap]
      _ = (2 : R) • S := by rw [two_smul]
  rw [hexp, hT, smul_smul, inv_mul_cancel₀ h2, one_smul]

/-- **Off-diagonal Gram sum for NULL edges.**  When every `αₑ` is null
(`hα : ∀ e, Q (αₑ) = 0`), the diagonal of the Gram double sum vanishes because
`polar Q αₑ αₑ = 2 · Q αₑ = 0`.  Hence the soldered square equals one half of the
Gram sum ranging over the off-diagonal (`f ∈ univ.erase e`): the aperture form
`Q_A` is genuinely a relation between DISTINCT null edges. -/
theorem nullSoldered_square_gram_offDiag [DecidableEq E] (Q : QuadraticForm R V)
    (alpha : E → V) (hα : ∀ e, Q (alpha e) = 0) (x : E → R) (h2 : (2 : R) ≠ 0) :
    nullSoldered Q alpha x ^ 2
      = (2 : R)⁻¹ • ∑ e, ∑ f ∈ Finset.univ.erase e, (x e * x f) •
          algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar (⇑Q) (alpha e) (alpha f)) := by
  rw [nullSoldered_square_eq_half_gram Q alpha x h2]
  congr 1
  refine Finset.sum_congr rfl (fun e _ => ?_)
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ e)]
  have hdiag : QuadraticMap.polar (⇑Q) (alpha e) (alpha e) = 0 := by
    rw [QuadraticMap.polar_self, hα e]
    ring
  rw [hdiag, map_zero, smul_zero, zero_add]

/-- **The explicit scalar value of the soldered square.**  Collecting the scalars,
`D0² = algebraMap R _ (2⁻¹ * ∑ e, ∑ f, (xₑ xf) * polar Q αₑ αf)`.  This makes the
`Q_A` Gram scalar fully explicit. -/
theorem nullSoldered_square_eq_algebraMap (Q : QuadraticForm R V) (alpha : E → V)
    (x : E → R) (h2 : (2 : R) ≠ 0) :
    nullSoldered Q alpha x ^ 2
      = algebraMap R (CliffordAlgebra Q)
          ((2 : R)⁻¹ * ∑ e, ∑ f, (x e * x f) * QuadraticMap.polar (⇑Q) (alpha e) (alpha f)) := by
  rw [nullSoldered_square_eq_half_gram Q alpha x h2, map_mul, map_sum, Algebra.smul_def]
  congr 1
  refine Finset.sum_congr rfl (fun e _ => ?_)
  rw [map_sum]
  refine Finset.sum_congr rfl (fun f _ => ?_)
  rw [map_mul, Algebra.smul_def]

/-- **The honest delimiter: the soldered square is a scalar (`Q_C` is absent).**
With commuting scalar weights the null-soldered square lies in the image of
`algebraMap R (CliffordAlgebra Q)`: it is a pure grade-0 (`Q_A` Gram) scalar with
NO bivector part.  In the Weitzenbock decomposition `D^#D = Q_A + Q_C + Q_T + E`
the closure bivector slot `Q_C` is the grade-2 content — which here vanishes
identically.  A nontrivial `Q_C` therefore REQUIRES non-commuting
(gauge-covariant) weights, motivating brick 2 (the 2-complex + covariant `∇`). -/
theorem nullSoldered_square_isScalar (Q : QuadraticForm R V) (alpha : E → V)
    (x : E → R) (h2 : (2 : R) ≠ 0) :
    ∃ s : R, nullSoldered Q alpha x ^ 2 = algebraMap R (CliffordAlgebra Q) s :=
  ⟨_, nullSoldered_square_eq_algebraMap Q alpha x h2⟩

end Soldered

end PhysicsSM.Draft.NullEdge.Carrier
