import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw

/-!
# Gate YM1: Lemma 2b - the independent-plaquette ensemble expectation bridge

This module closes the "ensemble expectation" half of freeze Theorem 2
(`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` section 4) that
`Theorem2AreaLaw.lean` explicitly left open: nothing there identified the
iterated convolution `iterConv w chi m 1` with an actual EXPECTATION VALUE.

The classical 2D argument has two layers:

1. Tree-gauge change of variables: on an open 2D rectangle, the link-field
   ensemble pushes forward to INDEPENDENT plaquette variables (one group
   element per plaquette, product weight). NOT proved here; it is the
   remaining geometric layer, documented below.
2. The independent-plaquette computation: once plaquette variables are
   independent, the Wilson-loop expectation factorizes and the in-region sum
   is exactly the iterated convolution. THIS layer is what this module proves,
   for any finite group `G`, any finite plaquette index type `nu`, and any
   ordered loop region `e : Fin m -> nu` (an embedding: distinct plaquettes,
   listed in the comb order in which the loop holonomy multiplies them).

## Contents

- `orderedProd`: the ordered (noncommutative) product of a tuple of plaquette
  variables, via `List.ofFn`/`List.prod` since `Finset.prod` needs
  commutativity.
- `sum_weight_orderedProdInv_eq_iterConv` (Lemma 2b core): summing
  `(prod_i w(U_i)) * chi((U_0 * ... * U_{m-1})^{-1} * A)` over all tuples of
  plaquette variables IS `iterConv w chi m A`. No hypotheses on `w` or `chi`.
- `sum_weight_orderedProd_eq_iterConv_of_inv`: for inversion-symmetric `w`
  (the Wilson weight is, by unitarity), the observable can be the UN-inverted
  ordered holonomy `chi(U_0 * ... * U_{m-1})`.
- `partition`, `loopNumerator`, `loopExpectation`: the independent-plaquette
  ensemble over a finite plaquette type `nu`, with the Wilson-loop observable
  attached to an ordered region embedding `e : Fin m -> nu`.
- `partition_eq_pow`: `Z = (sum_g w g)^(card nu)` (plaquette independence).
- `loopNumerator_factor`: out-of-region plaquettes integrate out, leaving
  `(sum_g w g)^(card nu - m)` times the in-region tuple sum.
- `loopExpectation_eq_iterConv_div`: the expectation is
  `iterConv w chi m 1 / (sum_g w g)^m`.
- `wilson_loop_expectation_area_law`: the headline finite identity. For the
  Wilson weight and a simple complex `FDRep` `R`, the Wilson-loop expectation
  in the independent-plaquette ensemble is EXACTLY
  `chi_R(1) * wilsonNormalizedGamma^m` - the area law, as a true
  expectation value, with `m` the number of enclosed plaquettes.

## What this module does NOT prove (explicit, not silently assumed)

- The tree-gauge change of variables: that the LINK-field ensemble of
  `LatticeEnsemble`/`PlaquetteEnsemble` on a 2D open rectangle pushes forward
  to this independent-plaquette ensemble, with the Wilson loop over a
  rectangular circuit becoming the ordered product of enclosed plaquette
  variables. That is the single remaining layer of freeze Theorem 2 and needs
  the 2D lattice geometry (spanning-tree gauge-fixing bijection).
- Any infinite-volume or continuum statement. Everything here is a finite
  identity over a finite plaquette index type.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`FusionConvolution` (Lemma 2a + iteration), `Theorem2AreaLaw` (Wilson
specialization scalars).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace IndependentPlaquetteEnsemble

open scoped Matrix

open FusionConvolution CategoryTheory

variable {G : Type} [Group G] [Fintype G]

/-! ## Ordered products of plaquette tuples -/

/-- Ordered (noncommutative) product of a tuple of group elements:
`orderedProd U = U 0 * U 1 * ... * U (m-1)`. Uses `List.ofFn`/`List.prod`
because `Finset.prod` requires commutativity and plaquette variables in a
nonabelian gauge group do not commute. -/
def orderedProd {m : ℕ} (U : Fin m → G) : G :=
  (List.ofFn U).prod

omit [Fintype G] in
@[simp] lemma orderedProd_zero (U : Fin 0 → G) : orderedProd U = 1 := by
  simp [orderedProd]

omit [Fintype G] in
lemma orderedProd_cons {m : ℕ} (h : G) (V : Fin m → G) :
    orderedProd (Fin.cons h V) = h * orderedProd V := by
  simp [orderedProd, List.ofFn_succ]

omit [Fintype G] in
/-- Peeling the LAST factor instead of the first: needed for the
order-reversal bookkeeping below. -/
lemma orderedProd_castSucc_mul_last {m : ℕ} (U : Fin (m + 1) → G) :
    orderedProd U = orderedProd (fun i : Fin m => U i.castSucc) * U (Fin.last m) := by
  rw [orderedProd, List.ofFn_succ']
  simp [orderedProd]

omit [Fintype G] in
/-- Reversing the tuple order and inverting each entry inverts the ordered
product: `(U_(m-1))^(-1) * ... * (U_0)^(-1) = (U_0 * ... * U_(m-1))^(-1)`.
This is the tuple-level form of `(a*b)^(-1) = b^(-1) * a^(-1)`. -/
lemma orderedProd_revInv {m : ℕ} (U : Fin m → G) :
    orderedProd (fun i => (U i.rev)⁻¹) = (orderedProd U)⁻¹ := by
  induction m with
  | zero => simp
  | succ m ih =>
      have hcons : (fun i : Fin (m + 1) => (U i.rev)⁻¹)
          = Fin.cons ((U (Fin.last m))⁻¹)
              (fun j : Fin m => (((fun k : Fin m => U k.castSucc) j.rev)⁻¹)) := by
        funext i
        refine Fin.cases ?_ ?_ i
        · simp [Fin.rev_zero]
        · intro j
          simp [Fin.rev_succ]
      rw [hcons, orderedProd_cons, ih (fun k : Fin m => U k.castSucc),
        orderedProd_castSucc_mul_last U, mul_inv_rev]

/-! ## Lemma 2b core: tuple sums are iterated convolutions -/

/-- **Lemma 2b core.** Summing the product weight times the character of the
INVERTED ordered plaquette holonomy (shifted by `A`) over all independent
plaquette tuples is exactly the iterated convolution `iterConv w chi m A`.
No hypotheses on `w` or `chi` are needed at this level; the inversion in the
observable is forced by the oracle-pinned `h^(-1) * A` convolution order. -/
theorem sum_weight_orderedProdInv_eq_iterConv (w chi : G → ℂ) :
    ∀ (m : ℕ) (A : G),
      (∑ U : Fin m → G, (∏ i, w (U i)) * chi ((orderedProd U)⁻¹ * A))
        = iterConv w chi m A := by
  intro m
  induction m with
  | zero =>
      intro A
      simp [iterConv]
  | succ m ih =>
      intro A
      rw [iterConv]
      rw [← Equiv.sum_comp (Fin.consEquiv fun _ : Fin (m + 1) => G)
        (fun U : Fin (m + 1) → G =>
          (∏ i, w (U i)) * chi ((orderedProd U)⁻¹ * A))]
      rw [Fintype.sum_prod_type]
      refine Finset.sum_congr rfl ?_
      intro h _hh
      rw [← ih (h⁻¹ * A), Finset.mul_sum]
      refine Finset.sum_congr rfl ?_
      intro V _hV
      have happ : (Fin.consEquiv fun _ : Fin (m + 1) => G) (h, V) = Fin.cons h V := rfl
      rw [happ, Fin.prod_univ_succ]
      simp only [Fin.cons_zero, Fin.cons_succ]
      rw [orderedProd_cons, mul_inv_rev, mul_assoc ((orderedProd V)⁻¹) h⁻¹ A]
      ring

/-- For an inversion-symmetric single-plaquette weight (the Wilson weight is,
for a unitary representation), the observable can be the UN-inverted ordered
loop holonomy: the reversal-and-inversion change of variables on the tuple
space converts one form into the other. -/
theorem sum_weight_orderedProd_eq_iterConv_of_inv
    (w chi : G → ℂ) (hw : ∀ g : G, w g⁻¹ = w g) (m : ℕ) :
    (∑ U : Fin m → G, (∏ i, w (U i)) * chi (orderedProd U))
      = iterConv w chi m 1 := by
  rw [← sum_weight_orderedProdInv_eq_iterConv w chi m 1]
  have hinvol : Function.Involutive
      (fun (U : Fin m → G) => fun i => (U i.rev)⁻¹) := by
    intro U
    funext i
    simp
  rw [← Equiv.sum_comp hinvol.toPerm
    (fun U : Fin m → G => (∏ i, w (U i)) * chi ((orderedProd U)⁻¹ * 1))]
  refine Finset.sum_congr rfl ?_
  intro U _hU
  have hperm : (hinvol.toPerm : (Fin m → G) → (Fin m → G)) U
      = fun i => (U i.rev)⁻¹ := rfl
  rw [hperm, orderedProd_revInv U, inv_inv, mul_one]
  congr 1
  rw [← Equiv.prod_comp (Fin.revPerm : Equiv.Perm (Fin m))
    (fun i => w (U i))]
  refine Finset.prod_congr rfl ?_
  intro i _hi
  exact (hw (U i.rev)).symm

/-! ## The independent-plaquette ensemble -/

section Ensemble

variable {ν : Type} [Fintype ν] [DecidableEq ν]

omit [Group G] [Fintype ν] [DecidableEq ν] in
/-- Independence workhorse: the sum of a product weight over ALL functions
`mu -> G` factorizes into the per-site sum, one factor per site. -/
lemma sum_prod_weight (μ : Type) [Fintype μ] [DecidableEq μ] (w : G → ℂ) :
    (∑ U : μ → G, ∏ p, w (U p)) = (∑ g : G, w g) ^ Fintype.card μ := by
  classical
  rw [← Fintype.piFinset_univ, ← Finset.prod_univ_sum]
  simp [Finset.prod_const, Finset.card_univ]

omit [Group G] [Fintype ν] [DecidableEq ν] in
/-- Splitting an independent-plaquette sum over a disjoint sum type: the
in-region part (`kappa1`, carrying an arbitrary observable of the in-region
restriction) factorizes from the out-of-region part (`kappa2`), which
contributes one single-plaquette sum per plaquette. Stated over abstract
types rather than subtypes so that `Fintype` instances unify against the
caller's goal instead of being re-synthesized. -/
lemma sum_pi_sumType_split (κ₁ κ₂ : Type) [Fintype κ₁] [DecidableEq κ₁]
    [Fintype κ₂] [DecidableEq κ₂] (w : G → ℂ) (F : (κ₁ → G) → ℂ) :
    (∑ U : κ₁ ⊕ κ₂ → G, (∏ x, w (U x)) * F (fun i => U (Sum.inl i)))
      = (∑ V : κ₁ → G, (∏ i, w (V i)) * F V)
        * (∑ g : G, w g) ^ Fintype.card κ₂ := by
  rw [← Equiv.sum_comp (Equiv.sumArrowEquivProdArrow κ₁ κ₂ G).symm
    (fun U : κ₁ ⊕ κ₂ → G => (∏ x, w (U x)) * F (fun i => U (Sum.inl i))),
    Fintype.sum_prod_type]
  rw [← sum_prod_weight κ₂ w, Finset.sum_mul]
  refine Finset.sum_congr rfl ?_
  intro V _hV
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro W _hW
  have hprod :
      (∏ x : κ₁ ⊕ κ₂, w ((Equiv.sumArrowEquivProdArrow κ₁ κ₂ G).symm (V, W) x))
        = (∏ i : κ₁, w (V i)) * ∏ j : κ₂, w (W j) := by
    rw [← Finset.univ_disjSum_univ, Finset.prod_disjSum]
    congr 1
  have hobs :
      (fun i => (Equiv.sumArrowEquivProdArrow κ₁ κ₂ G).symm (V, W) (Sum.inl i)) = V :=
    rfl
  rw [hprod, hobs]
  ring

/-- Partition function of the independent-plaquette ensemble: one free group
variable per plaquette, product of local weights. -/
def partition (w : G → ℂ) (ν : Type) [Fintype ν] [DecidableEq ν] : ℂ :=
  ∑ U : ν → G, ∏ p, w (U p)

/-- Wilson-loop numerator: the loop region is an ordered embedding
`e : Fin m -> nu` of `m` DISTINCT plaquettes (comb order), and the observable
is `chi` of the ordered product of the region's plaquette variables. -/
def loopNumerator (w chi : G → ℂ) {m : ℕ} (e : Fin m ↪ ν) : ℂ :=
  ∑ U : ν → G, (∏ p, w (U p)) * chi (orderedProd fun i => U (e i))

/-- Wilson-loop expectation in the independent-plaquette ensemble. -/
def loopExpectation (w chi : G → ℂ) {m : ℕ} (e : Fin m ↪ ν) : ℂ :=
  loopNumerator w chi e / partition w ν

omit [Group G] in
/-- Plaquette independence: the partition function is the `card nu`-th power
of the single-plaquette sum. -/
theorem partition_eq_pow (w : G → ℂ) :
    partition w ν = (∑ g : G, w g) ^ Fintype.card ν := by
  unfold partition
  exact sum_prod_weight ν w

/-- Transport form of the factorization: if the plaquette type `nu` is
enumerated by a sum type `Fin m ⊕ kappa2` whose left summand lists the loop
region in comb order, then the loop numerator factorizes. Abstract in the
out-of-region type `kappa2` so instances unify rather than re-synthesize. -/
theorem loopNumerator_factor_of_equiv {κ₂ : Type} [Fintype κ₂]
    (w chi : G → ℂ) {m : ℕ} (e : Fin m ↪ ν)
    (Φ : Fin m ⊕ κ₂ ≃ ν) (hΦ : ∀ i : Fin m, Φ (Sum.inl i) = e i) :
    loopNumerator w chi e
      = (∑ V : Fin m → G, (∏ i, w (V i)) * chi (orderedProd V))
        * (∑ g : G, w g) ^ Fintype.card κ₂ := by
  classical
  rw [loopNumerator, ← Equiv.sum_comp (Φ.arrowCongr (Equiv.refl G))
    (fun U : ν → G => (∏ p, w (U p)) * chi (orderedProd fun i => U (e i))),
    ← sum_pi_sumType_split (Fin m) κ₂ w (fun V => chi (orderedProd V))]
  refine Finset.sum_congr rfl ?_
  intro U' _hU'
  have happ : ∀ q : ν, (Φ.arrowCongr (Equiv.refl G) U') q = U' (Φ.symm q) := by
    intro q
    simp [Equiv.arrowCongr_apply]
  congr 1
  · rw [← Equiv.prod_comp Φ
      (fun q : ν => w ((Φ.arrowCongr (Equiv.refl G) U') q))]
    refine Finset.prod_congr rfl ?_
    intro x _hx
    rw [happ (Φ x), Equiv.symm_apply_apply]
  · congr 2
    funext i
    rw [happ (e i), ← hΦ i, Equiv.symm_apply_apply]

/-- Out-of-region plaquettes integrate out: the loop numerator is the
single-plaquette sum to the power `card nu - m`, times the in-region tuple
sum. This is the factorization step of Lemma 2b. -/
theorem loopNumerator_factor (w chi : G → ℂ) {m : ℕ} (e : Fin m ↪ ν) :
    loopNumerator w chi e
      = (∑ g : G, w g) ^ (Fintype.card ν - m)
        * ∑ V : Fin m → G, (∏ i, w (V i)) * chi (orderedProd V) := by
  classical
  have hcard : Fintype.card ((Set.range (⇑e))ᶜ : Set ν) = Fintype.card ν - m := by
    rw [Fintype.card_compl_set, Set.card_range_of_injective e.injective,
      Fintype.card_fin]
  rw [loopNumerator_factor_of_equiv w chi e
    ((Equiv.sumCongr (Equiv.ofInjective e e.injective)
      (Equiv.refl ((Set.range (⇑e))ᶜ : Set ν))).trans
      (Equiv.Set.sumCompl (Set.range (⇑e))))
    (by
      intro i
      simp [Equiv.trans_apply, Equiv.sumCongr_apply, Sum.map_inl,
        Equiv.Set.sumCompl_apply_inl]),
    hcard, mul_comm]

/-- Lemma 2b, ensemble numerator form: for an inversion-symmetric local
weight, the Wilson-loop numerator is the out-of-region power of the
single-plaquette sum times the iterated convolution at the identity. -/
theorem loopNumerator_eq_iterConv (w chi : G → ℂ)
    (hw : ∀ g : G, w g⁻¹ = w g) {m : ℕ} (e : Fin m ↪ ν) :
    loopNumerator w chi e
      = (∑ g : G, w g) ^ (Fintype.card ν - m) * iterConv w chi m 1 := by
  rw [loopNumerator_factor w chi e,
    sum_weight_orderedProd_eq_iterConv_of_inv w chi hw m]

/-- **Lemma 2b.** The Wilson-loop expectation in the independent-plaquette
ensemble is the iterated convolution at the identity, normalized by the
`m`-th power of the single-plaquette sum. The out-of-region factors cancel
between numerator and partition function. -/
theorem loopExpectation_eq_iterConv_div (w chi : G → ℂ)
    (hw : ∀ g : G, w g⁻¹ = w g) (hS : (∑ g : G, w g) ≠ 0)
    {m : ℕ} (hm : m ≤ Fintype.card ν) (e : Fin m ↪ ν) :
    loopExpectation w chi e
      = iterConv w chi m 1 / (∑ g : G, w g) ^ m := by
  rw [loopExpectation, loopNumerator_eq_iterConv w chi hw e, partition_eq_pow w]
  have hpow : (∑ g : G, w g) ^ Fintype.card ν
      = (∑ g : G, w g) ^ (Fintype.card ν - m) * (∑ g : G, w g) ^ m := by
    rw [← pow_add, Nat.sub_add_cancel hm]
  rw [hpow]
  have h1 : (∑ g : G, w g) ^ (Fintype.card ν - m) ≠ 0 := pow_ne_zero _ hS
  have h2 : (∑ g : G, w g) ^ m ≠ 0 := pow_ne_zero _ hS
  field_simp

/-- **Theorem 2, independent-plaquette form (the area law as a true
expectation value).** For the Wilson local weight of a unitary representation
`rho` and a simple complex `FDRep` `R`, the Wilson-loop expectation over an
ordered region of `m` distinct plaquettes in the independent-plaquette
ensemble is EXACTLY `chi_R(1) * wilsonNormalizedGamma^m`.

The sole remaining layer of freeze Theorem 2 is geometric: identifying the 2D
open-rectangle LINK ensemble with this independent-plaquette ensemble via the
tree-gauge change of variables. -/
theorem wilson_loop_expectation_area_law {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R]
    {m : ℕ} (hm : m ≤ Fintype.card ν) (e : Fin m ↪ ν) :
    loopExpectation (Theorem2AreaLaw.wilsonLocalWeightC beta rho) R.character e
      = R.character 1 * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ m := by
  have hS : (∑ g : G, Theorem2AreaLaw.wilsonLocalWeightC beta rho g) ≠ 0 := by
    have := Theorem2AreaLaw.wilsonPlaquetteSumC_ne_zero (G := G) beta rho
    simpa [Theorem2AreaLaw.wilsonPlaquetteSumC] using this
  rw [loopExpectation_eq_iterConv_div _ R.character
    (Theorem2AreaLaw.wilsonLocalWeightC_inv_of_unitary beta rho hmul hone hunit)
    hS hm e]
  have := Theorem2AreaLaw.wilson_iterConv_normalizedGamma_at_one
    (G := G) beta rho hmul hone R m
  simpa [Theorem2AreaLaw.wilsonPlaquetteSumC] using this

/-- Norm form of the area law: the absolute value of the Wilson-loop
expectation is `|chi_R(1)| * |gamma|^m`. In particular, whenever
`|wilsonNormalizedGamma| < 1`, the expectation decays EXPONENTIALLY IN THE
AREA `m` - the confinement-shaped statement of freeze Theorem 2, now as a
kernel-checked property of a true expectation value (in the
independent-plaquette ensemble; the tree-gauge bridge to the link ensemble
remains the missing geometric layer). -/
theorem norm_wilson_loop_expectation {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R]
    {m : ℕ} (hm : m ≤ Fintype.card ν) (e : Fin m ↪ ν) :
    ‖loopExpectation (Theorem2AreaLaw.wilsonLocalWeightC beta rho) R.character e‖
      = ‖R.character 1‖
        * ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖ ^ m := by
  rw [wilson_loop_expectation_area_law beta rho hmul hone hunit R hm e,
    norm_mul, norm_pow]

end Ensemble

end IndependentPlaquetteEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
