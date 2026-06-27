import Mathlib

/-!
# Scalar/gauge null kinetic reconstruction theorem

This file proves the finite linear-algebra core behind the null-edge scalar/Higgs
kinetic reconstruction (Working Plan §19.4, proof-chain entries T8/T13, and the
dual-soldered conventions of `docs/NULLSTRAND.md`).

## Setting and conventions

Let `V` be a real vector space (the tangent space of the null-frame patch).  Its
covectors live in `Module.Dual ℝ V`.  A **dual-soldered null frame** is a finite
family of primitive null-edge directions `ell_a ∈ V` together with the dual
covector basis `α^a ∈ Module.Dual ℝ V` characterised by

```text
α^a (ell_b) = δ^a_b .
```

The active architecture solders the Clifford symbol to the **dual covectors**
`α^a`, never to the diagonal flats `ell_a^♭`; see `docs/NULLSTRAND.md`.  The
diagonal architecture `∑_a c(ell_a^♭) ∇_{ell_a}` is rejected (trace obstruction),
which is why the reconstruction below uses `α^a` and the inverse-Gram weights.

## Main results

* `repr_eq_apply_predual` : in a dual covector basis the `a`-th coordinate of a
  covector `ξ` is exactly the edge evaluation `ξ (ell_a)`.

* `covector_bilin_reconstruction` : the **reconstruction identity** for an
  arbitrary bilinear form `B` on covectors,
  `B ξ η = ∑_{a,b} B(α^a, α^b) · ξ(ell_a) · η(ell_b)`.
  With `B = g^{-1}` and `G^{ab} = g^{-1}(α^a, α^b)` this is
  `g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ell_a) η(ell_b)`.

* `inverse_gram` : the coefficients `G^{ab} = g^{-1}(α^a, α^b)` are literally the
  matrix inverse of the Gram matrix `g_{ab} = g(ell_a, ell_b)`, i.e.
  `∑_b g_{ab} G^{bc} = δ_a^c`.  This justifies the name *inverse-Gram weights*.

* `inverse_gram_reconstruction` : the two facts combined, stated directly with the
  induced inverse metric `g^{-1}(ξ,η) = g(g♯ξ, g♯η)`.

* `higgs_kinetic_reconstruction` : the documented scalar/Higgs corollary
  (`ξ = η = dH`): the Lorentzian kinetic symbol `⟨DH, DH⟩_{g^{-1}}` is
  reconstructed from the null-edge derivatives `∇_a H := dH(ell_a)` and the
  inverse-Gram weights, `⟨DH,DH⟩ = ∑_{a,b} G^{ab} (∇_a H)(∇_b H)`.

* `euclidean_collapse_guardrail` : the **guardrail**.  The naive positive edge
  sum `∑_a (∇_a H)^2` is recovered *exactly* in the Euclidean special case
  `G^{ab} = δ^{ab}`.  For a genuine Lorentzian inverse-Gram matrix the
  off-diagonal weights survive, so the reconstruction is *not* ordinary
  graph/lattice Higgs theory with null labels.

The encoding of nondegeneracy: a symmetric bilinear form `g` is nondegenerate iff
the musical map `v ↦ g(v, ·)` is a linear isomorphism `V ≃ Module.Dual ℝ V`.  We
encode its inverse `g♯` as a linear map `sharp : Module.Dual ℝ V →ₗ[ℝ] V` with the
defining "raising" property `hsharp : g (sharp ξ) v = ξ v`.  This is exactly the
data of the inverse metric, and existence of such a `sharp` is equivalent to
nondegeneracy of `g`.
-/

namespace PhysicsSM
namespace Draft

open Module
open scoped BigOperators

variable {V : Type*} [AddCommGroup V] [Module ℝ V] {n : ℕ}

/-- In a basis `α` of the covector space with predual edge vectors `ell` (so that
`α a (ell b) = δ_{ab}`), the `a`-th coordinate of a covector `ξ` is its evaluation
on the null edge `ell a`. -/
theorem repr_eq_apply_predual
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdual : ∀ a b, α a (ell b) = if a = b then (1 : ℝ) else 0)
    (ξ : Module.Dual ℝ V) (a : Fin n) :
    α.repr ξ a = ξ (ell a) := by
  conv_rhs => rw [← α.sum_repr ξ]
  simp only [LinearMap.coe_sum, Finset.sum_apply, LinearMap.smul_apply, smul_eq_mul]
  rw [Finset.sum_eq_single a]
  · rw [hdual a a]; simp
  · intro b _ hb; rw [hdual b a, if_neg hb]; ring
  · intro h; simp at h

/-- **Reconstruction identity.**  For any bilinear form `B` on covectors and a dual
covector basis `α` with predual null edges `ell`,
`B ξ η = ∑_{a,b} B(α^a, α^b) · ξ(ell_a) · η(ell_b)`.

Specialising `B` to the inverse metric `g^{-1}` and writing `G^{ab} = g^{-1}(α^a, α^b)`
this is the null-edge scalar kinetic reconstruction
`g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ell_a) η(ell_b)`. -/
theorem covector_bilin_reconstruction
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdual : ∀ a b, α a (ell b) = if a = b then (1 : ℝ) else 0)
    (ξ η : Module.Dual ℝ V) :
    B ξ η = ∑ a, ∑ b, (B (α a) (α b)) * ξ (ell a) * η (ell b) := by
  conv_lhs => rw [← α.sum_repr ξ, ← α.sum_repr η]
  simp only [map_sum, map_smul, LinearMap.sum_apply, LinearMap.smul_apply, smul_eq_mul,
    repr_eq_apply_predual α ell hdual]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun b _ => ?_
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun a _ => ?_
  ring

/-- **Inverse-Gram weights are the matrix inverse of the Gram matrix.**

Let `g` be a symmetric bilinear form on `V`, and let `sharp = g♯` be the inverse
musical isomorphism (`hsharp : g (sharp ξ) v = ξ v`, encoding nondegeneracy of
`g`).  The induced inverse metric on covectors is
`g^{-1}(ξ,η) = g(sharp ξ, sharp η)`, written here `LinearMap.compl₁₂ g sharp sharp`.

With the null-frame basis `ell` and its dual covector basis `α = ell.dualBasis`,
the Gram matrix is `g_{ab} = g(ell_a, ell_b)` and the inverse-Gram coefficients are
`G^{bc} = g^{-1}(α^b, α^c)`.  Then `∑_b g_{ab} G^{bc} = δ_a^c`, i.e. `G` is `g⁻¹`. -/
theorem inverse_gram
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hsym : ∀ u v, g u v = g v u)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (hsharp : ∀ (ξ : Module.Dual ℝ V) (v : V), g (sharp ξ) v = ξ v)
    (ell : Basis (Fin n) ℝ V)
    (a c : Fin n) :
    ∑ b, (g (ell a) (ell b)) *
        ((LinearMap.compl₁₂ g sharp sharp) (ell.dualBasis b) (ell.dualBasis c))
      = if a = c then (1 : ℝ) else 0 := by
  have hG : ∀ b, (LinearMap.compl₁₂ g sharp sharp) (ell.dualBasis b) (ell.dualBasis c)
      = (ell.dualBasis b) (sharp (ell.dualBasis c)) := by
    intro b; rw [LinearMap.compl₁₂_apply, hsharp]
  simp only [hG]
  have hexp : sharp (ell.dualBasis c)
      = ∑ b, (ell.dualBasis b (sharp (ell.dualBasis c))) • ell b := by
    conv_lhs => rw [← ell.sum_repr (sharp (ell.dualBasis c))]
    refine Finset.sum_congr rfl fun b _ => ?_
    rw [Basis.dualBasis_apply]
  have hstep : g (ell a) (sharp (ell.dualBasis c))
      = ∑ b, (g (ell a) (ell b)) * (ell.dualBasis b (sharp (ell.dualBasis c))) := by
    conv_lhs => rw [hexp]
    rw [map_sum]
    refine Finset.sum_congr rfl fun b _ => ?_
    rw [map_smul, smul_eq_mul, mul_comm]
  rw [← hstep, hsym, hsharp, Basis.dualBasis_apply_self]

/-- **Inverse-Gram reconstruction**, stated directly with the induced inverse
metric `g^{-1}(ξ,η) = g(sharp ξ, sharp η)` and the dual covector basis
`α = ell.dualBasis`.  This is the §19.4 identity
`g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ell_a) η(ell_b)` with
`G^{ab} = g^{-1}(α^a, α^b)` the inverse-Gram weights certified by `inverse_gram`. -/
theorem inverse_gram_reconstruction
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (ell : Basis (Fin n) ℝ V)
    (ξ η : Module.Dual ℝ V) :
    (LinearMap.compl₁₂ g sharp sharp) ξ η
      = ∑ a, ∑ b,
          ((LinearMap.compl₁₂ g sharp sharp) (ell.dualBasis a) (ell.dualBasis b))
            * ξ (ell a) * η (ell b) := by
  refine covector_bilin_reconstruction _ ell.dualBasis (fun a => ell a) ?_ ξ η
  intro a b
  rw [Basis.dualBasis_apply_self]
  by_cases h : a = b
  · subst h; simp
  · rw [if_neg (fun h' => h h'.symm), if_neg h]

/-- **Scalar/Higgs kinetic reconstruction (interpretation corollary).**

Let `dH : Module.Dual ℝ V` be the differential of a real scalar/Higgs field and
write the null-edge derivatives `∇_a H := dH (ell_a)`.  Then the Lorentzian
kinetic symbol `⟨DH, DH⟩_{g^{-1}} = g^{-1}(dH, dH)` is reconstructed from the
null-edge derivatives weighted by the inverse-Gram matrix
`G^{ab} = g^{-1}(α^a, α^b)`:

```text
⟨DH, DH⟩_{g^{-1}} = ∑_{a,b} G^{ab} (∇_a H)(∇_b H).
```

The cross terms (`a ≠ b`) carry the Lorentzian inverse-Gram weights; they are not
cosmetic (see `euclidean_collapse_guardrail`). -/
theorem higgs_kinetic_reconstruction
    (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (sharp : Module.Dual ℝ V →ₗ[ℝ] V)
    (ell : Basis (Fin n) ℝ V)
    (dH : Module.Dual ℝ V) :
    (LinearMap.compl₁₂ g sharp sharp) dH dH
      = ∑ a, ∑ b,
          ((LinearMap.compl₁₂ g sharp sharp) (ell.dualBasis a) (ell.dualBasis b))
            * dH (ell a) * dH (ell b) :=
  inverse_gram_reconstruction g sharp ell dH dH

/-- **Guardrail: the Euclidean/graph-like sum is only the diagonal special case.**

If (and only if, on the diagonal data) the inverse-Gram matrix is the identity,
`G^{ab} = δ^{ab}`, does the reconstruction collapse to the naive positive edge sum
`∑_a (∇_a H)^2`.  A genuine Lorentzian inverse-Gram matrix has surviving
off-diagonal weights, so the reconstruction `higgs_kinetic_reconstruction` is *not*
the Euclidean graph-Higgs sum.  This is the precise sense in which the null
substrate does mathematical work for scalar kinetics. -/
theorem euclidean_collapse_guardrail
    (B : (Module.Dual ℝ V) →ₗ[ℝ] (Module.Dual ℝ V) →ₗ[ℝ] ℝ)
    (α : Basis (Fin n) ℝ (Module.Dual ℝ V)) (ell : Fin n → V)
    (hdual : ∀ a b, α a (ell b) = if a = b then (1 : ℝ) else 0)
    (hdiag : ∀ a b, B (α a) (α b) = if a = b then (1 : ℝ) else 0)
    (ξ : Module.Dual ℝ V) :
    B ξ ξ = ∑ a, (ξ (ell a)) ^ 2 := by
  rw [covector_bilin_reconstruction B α ell hdual ξ ξ]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [Finset.sum_eq_single a]
  · rw [hdiag a a]; simp; ring
  · intro b _ hb; rw [hdiag a b, if_neg (fun h => hb h.symm)]; ring
  · intro h; simp at h

end Draft
end PhysicsSM
