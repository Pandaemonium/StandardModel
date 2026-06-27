import Mathlib
import PhysicsSM.Draft.NullEdgeScalarKineticReconstruction

/-!
# Scalar/gauge null-quadrature and the covariant Higgs-gradient reconstruction (D17)

This file realises task **D17** of the null-edge program (Working Plan §24-25,
Theorem D in §17.x, and the dual-solder conventions of `docs/NULLSTRAND.md`).  It
takes the finite scalar inverse-Gram quadrature identity already proven in
`PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` and lifts it to the
**gauge-covariant Higgs-gradient** setting, in the purely finite/algebraic form
available now.

## Target identities (Working Plan §17.4 / §25.2)

Scalar null-quadrature (already available, re-exported here as
`scalar_null_quadrature`):

```text
g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ℓ_a) η(ℓ_b).
```

Covariant Higgs-gradient reconstruction (the new content):

```text
g^{-1}(D H, D H)  =  ∑_{a,b} G^{ab} ⟪∇_a^A H, ∇_b^A H⟫.
```

Here `H` is a Higgs/scalar field valued in a real gauge representation `E`
equipped with a (gauge-invariant) bilinear inner product `q = ⟪·,·⟫`.  The
covariant differential is modelled by a linear map `DH : V →ₗ[ℝ] E`, and the
null-edge covariant derivative is `∇_a^A H := DH(ℓ_a) ∈ E`.

## Clean inner-product abstraction

We take the gauge inner product abstractly as a bilinear form
`q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ`.  This is the minimal data needed: no positivity,
completeness, or smoothness is used.  The left-hand "intrinsic" object
`g^{-1}(DH, DH')` is the tensor metric `g^{-1} ⊗ q` evaluated on the
`E`-valued one-forms; in this finite setting we *characterise* it by its
frame-independent component expansion (`gauge_null_quadrature`), which is the
mathematically honest way to package `g^{-1} ⊗ q` without tensor-product
machinery.

## Main results

* `gaugeNullKinetic` : the null-frame inverse-Gram contraction
  `∑_{a,b} B(α^a,α^b) · q(DH(ℓ_a), DH'(ℓ_b))` of two `E`-valued one-forms.

* `gauge_null_quadrature` : the **frame-independence / reconstruction theorem**.
  The null-edge contraction equals the manifestly frame-independent component
  expansion `∑_{i,j} q(e_i,e_j) · B(H_i, H'_j)`, where `H_i := e^i ∘ DH` are the
  scalar component covectors of the gauge multiplet.  This is the `E`-valued
  analogue of `covector_bilin_reconstruction` and is the precise sense in which
  the LHS is a genuine intrinsic quantity, not a frame artefact.

* `gauge_inverse_gram_reconstruction` : the §25.2 identity with `B = g^{-1}`,
  `g^{-1}(DH,DH') = ∑_{a,b} G^{ab} q(∇_a H, ∇_b H')
                  = ∑_{i,j} q(e_i,e_j) g^{-1}(dH_i, dH'_j)`.

* `gauge_higgs_kinetic_reconstruction` : the documented Higgs corollary
  (`DH = DH'`), the covariant Higgs-gradient reconstruction.

* `gauge_kinetic_orthonormal_collapse` : for an orthonormal gauge frame
  (`q(e_i,e_j) = δ_{ij}`) the reconstruction reduces to the multiplet sum of
  scalar reconstructions `∑_i B(H_i, H'_i)`, i.e. one scalar kinetic term per
  internal component.

* `gauge_euclidean_collapse_guardrail` : the **guardrail**.  Only when *both* the
  inverse-Gram matrix is Euclidean (`G^{ab} = δ^{ab}`) *and* the gauge frame is
  orthonormal does the reconstruction collapse to the naive positive edge sum
  `∑_a ⟪∇_a H, ∇_a H⟫`.  A genuine Lorentzian inverse-Gram matrix keeps the
  cross terms, so the covariant Higgs kinetics is *not* ordinary graph/lattice
  Higgs theory with null labels.
-/

namespace PhysicsSM
namespace Draft

open Module
open scoped BigOperators

variable {V : Type*} [AddCommGroup V] [Module ℝ V] {n : ℕ}
variable {E : Type*} [AddCommGroup E] [Module ℝ E] {m : ℕ}

/-- **Scalar null-quadrature identity (re-export).**  The §17.4 inverse-Gram
reconstruction `g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ℓ_a) η(ℓ_b)` with
`G^{ab} = g^{-1}(α^a, α^b)`, taken verbatim from
`inverse_gram_reconstruction`.  Stated here so the gauge file is a self-contained
statement of both halves of Theorem D. -/
theorem scalar_null_quadrature
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (ell : Basis (Fin n) ℝ V)
    (ξ η : Module.Dual ℝ V) :
    (LinearMap.compl₁₂ g sharp sharp) ξ η
      = ∑ a, ∑ b,
          ((LinearMap.compl₁₂ g sharp sharp) (ell.dualBasis a) (ell.dualBasis b))
            * ξ (ell a) * η (ell b) :=
  inverse_gram_reconstruction g sharp ell ξ η

/-- The null-frame inverse-Gram contraction of two `E`-valued one-forms
`DH, DH' : V →ₗ[ℝ] E`:
`∑_{a,b} B(α^a, α^b) · q(DH(ℓ_a), DH'(ℓ_b))`.

With `B = g^{-1}`, `q = ⟪·,·⟫` and `∇_a^A H = DH(ℓ_a)` this is the right-hand
side of the covariant Higgs-gradient reconstruction
`∑_{a,b} G^{ab} ⟪∇_a^A H, ∇_b^A H⟫`. -/
noncomputable def gaugeNullKinetic
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (DH DH' : V →ₗ[ℝ] E) : ℝ :=
  ∑ a, ∑ b, (B (α a) (α b)) * q (DH (ell a)) (DH' (ell b))

/-
**Gauge null-quadrature / frame-independence theorem.**

For any bilinear form `B` on covectors, any gauge inner product
`q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ`, a dual covector basis `α` with predual null edges `ell`,
and a basis `eE` of the gauge representation `E`, the null-edge contraction of two
`E`-valued one-forms equals the manifestly frame-independent component expansion

```text
∑_{a,b} B(α^a,α^b) q(DH(ℓ_a), DH'(ℓ_b))
  = ∑_{i,j} q(e_i, e_j) · B(H_i, H'_j),
```

where `H_i := e^i ∘ DH` (and `H'_j := e^j ∘ DH'`) are the scalar component
covectors of the gauge multiplet, `e^i = eE.coord i`.  The right-hand side does
not mention the null frame `ell`, so the left-hand contraction is a genuine
intrinsic quantity.  This is the `E`-valued analogue of
`covector_bilin_reconstruction`.
-/
theorem gauge_null_quadrature
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdual : ∀ a b, α a (ell b) = if a = b then (1 : ℝ) else 0)
    (eE : Basis (Fin m) ℝ E)
    (DH DH' : V →ₗ[ℝ] E) :
    gaugeNullKinetic B q α ell DH DH'
      = ∑ i, ∑ j, q (eE i) (eE j)
          * B (eE.coord i ∘ₗ DH) (eE.coord j ∘ₗ DH') := by
  -- Expand `q (DH (ell a)) (DH' (ell b))` using the basis `eE` of `E`.
  have h_expand : ∀ a b, q (DH (ell a)) (DH' (ell b)) = ∑ i, ∑ j, (eE.coord i (DH (ell a))) * (eE.coord j (DH' (ell b))) * (q (eE i) (eE j)) := by
    intro a b
    have h_expand : ∀ x y : E, q x y = ∑ i, ∑ j, (eE.coord i) x * (eE.coord j) y * (q (eE i) (eE j)) := by
      intro x y
      have h_expand : q x y = q (∑ i, (eE.coord i) x • eE i) (∑ j, (eE.coord j) y • eE j) := by
        simp +decide [ eE.sum_repr ];
      simp +decide only [h_expand, map_sum, LinearMap.map_smulₛₗ, smul_eq_mul];
      simp +decide [ mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ];
      exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring )
    exact h_expand (DH (ell a)) (DH' (ell b));
  -- Apply the expansion to rewrite the left-hand side of the goal.
  have h_lhs : gaugeNullKinetic B q α ell DH DH' = ∑ i, ∑ j, (q (eE i) (eE j)) * (∑ a, ∑ b, (B (α a) (α b)) * (eE.coord i (DH (ell a))) * (eE.coord j (DH' (ell b)))) := by
    simp +decide only [gaugeNullKinetic, h_expand, mul_comm, mul_left_comm, Finset.mul_sum _ _ _];
    simp +decide only [mul_assoc, Finset.sum_mul];
    simp +decide only [← Finset.sum_product'];
    refine' Finset.sum_bij ( fun x _ => ( x.2.2.1, x.2.2.2, x.1, x.2.1 ) ) _ _ _ _ <;> simp +decide;
  convert h_lhs using 4;
  convert covector_bilin_reconstruction B α ell hdual _ _ using 1

/-
**Inverse-Gram gauge reconstruction (Working Plan §25.2).**

Specialising `gauge_null_quadrature` to the induced inverse metric
`B = g^{-1} = compl₁₂ g sharp sharp` and the canonical dual frame
`α = ell.dualBasis`:

```text
g^{-1}(DH, DH')  =  ∑_{a,b} G^{ab} q(∇_a H, ∇_b H')
                 =  ∑_{i,j} q(e_i, e_j) · g^{-1}(dH_i, dH'_j),
```

with `G^{ab} = g^{-1}(α^a, α^b)` the inverse-Gram weights (certified by
`inverse_gram`) and `dH_i := e^i ∘ DH` the scalar component differentials.
-/
theorem gauge_inverse_gram_reconstruction
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (ell : Basis (Fin n) ℝ V)
    (eE : Basis (Fin m) ℝ E)
    (DH DH' : V →ₗ[ℝ] E) :
    gaugeNullKinetic (LinearMap.compl₁₂ g sharp sharp) q ell.dualBasis (fun a => ell a) DH DH'
      = ∑ i, ∑ j, q (eE i) (eE j)
          * (LinearMap.compl₁₂ g sharp sharp) (eE.coord i ∘ₗ DH) (eE.coord j ∘ₗ DH') := by
  apply gauge_null_quadrature;
  aesop

/-- **Covariant Higgs-gradient reconstruction (Higgs corollary, `DH = DH'`).**

The documented §25.2 identity for a Higgs field `H` valued in the gauge
representation `E`:

```text
g^{-1}(D H, D H)  =  ∑_{a,b} G^{ab} ⟪∇_a^A H, ∇_b^A H⟫
                  =  ∑_{i,j} q(e_i,e_j) g^{-1}(dH_i, dH_j).
```

The cross terms (`a ≠ b`) carry the Lorentzian inverse-Gram weights and are not
cosmetic (see `gauge_euclidean_collapse_guardrail`). -/
theorem gauge_higgs_kinetic_reconstruction
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (ell : Basis (Fin n) ℝ V)
    (eE : Basis (Fin m) ℝ E)
    (DH : V →ₗ[ℝ] E) :
    gaugeNullKinetic (LinearMap.compl₁₂ g sharp sharp) q ell.dualBasis (fun a => ell a) DH DH
      = ∑ i, ∑ j, q (eE i) (eE j)
          * (LinearMap.compl₁₂ g sharp sharp) (eE.coord i ∘ₗ DH) (eE.coord j ∘ₗ DH) :=
  gauge_inverse_gram_reconstruction g sharp q ell eE DH DH

/-
**Orthonormal-gauge-frame collapse.**

If the gauge frame is orthonormal for the inner product `q`
(`q(e_i, e_j) = δ_{ij}`), the reconstruction reduces to the multiplet sum of the
scalar reconstructions: one scalar kinetic term per internal component,

```text
∑_{a,b} B(α^a,α^b) q(DH(ℓ_a), DH'(ℓ_b)) = ∑_i B(H_i, H'_i).
```

The null/Lorentzian structure still lives entirely in `B = g^{-1}`; the gauge
index just sums diagonally.
-/
theorem gauge_kinetic_orthonormal_collapse
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdual : ∀ a b, α a (ell b) = if a = b then (1 : ℝ) else 0)
    (eE : Basis (Fin m) ℝ E)
    (hortho : ∀ i j, q (eE i) (eE j) = if i = j then (1 : ℝ) else 0)
    (DH DH' : V →ₗ[ℝ] E) :
    gaugeNullKinetic B q α ell DH DH'
      = ∑ i, B (eE.coord i ∘ₗ DH) (eE.coord i ∘ₗ DH') := by
  rw [ gauge_null_quadrature B q α ell hdual eE DH DH' ]
  simp [ hortho ]

/-- **Guardrail: the Euclidean positive edge sum is the doubly-diagonal special
case.**

Only when *both* the inverse-Gram matrix is the identity (`B(α^a,α^b) = δ^{ab}`)
*and* the gauge frame is orthonormal (`q(e_i,e_j) = δ_{ij}`) does the covariant
reconstruction collapse to the naive positive edge sum

```text
∑_{a,b} B(α^a,α^b) q(DH(ℓ_a), DH(ℓ_b)) = ∑_a ⟪∇_a H, ∇_a H⟫.
```

A genuine Lorentzian inverse-Gram matrix keeps the off-diagonal cross terms, so
`gauge_higgs_kinetic_reconstruction` is *not* the Euclidean graph-Higgs sum.
This is the precise sense in which the null substrate does mathematical work for
the gauge/Higgs kinetics.
-/
theorem gauge_euclidean_collapse_guardrail
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdiag : ∀ a b, B (α a) (α b) = if a = b then (1 : ℝ) else 0)
    (DH : V →ₗ[ℝ] E) :
    gaugeNullKinetic B q α ell DH DH = ∑ a, q (DH (ell a)) (DH (ell a)) := by
  unfold gaugeNullKinetic
  simp [ hdiag ]

end Draft
end PhysicsSM
