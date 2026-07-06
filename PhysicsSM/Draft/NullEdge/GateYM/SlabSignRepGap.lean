import PhysicsSM.Draft.NullEdge.GateYM.SlabFullSpectrumGap
import PhysicsSM.Draft.NullEdge.GateYM.SlabCenterWitness

/-!
# Gate YM / NE-U4: a GENUINE full-slab center-flux gap via the SIGN representation

`SlabCenterWitness.slabFullBlock_no_centerWitness` REFUTED the existence of an
honest two-state center-flux `FiniteFluxGapWitness` for the full connected
two-plaquette Wilson block over the **trivial** representation of `Z2`: the
trivial character is constant, so the Wilson weight is flux-BLIND and the block
has a single (degenerate) positive eigenvalue.

This module carries out the CORRECTED direction flagged there.  We use the
**sign representation** `signRho : Z2 → Matrix (Fin 1) (Fin 1) ℂ`,
`signRho g = (if g = 1 then 1 else -1)` — the nontrivial one-dimensional unitary
representation, whose character `reChar signRho g = ±1` SEPARATES the two `Z2`
classes (contrast the trivial rep's constant `+1`).

## What is established (all kernel-checked, no `s o r r y`)

1. **Flux dependence.**  `wilsonKernel_signRho` shows the per-link Wilson kernel
   is `exp (β · (if g = h then 1 else -1))` — genuinely `(g,h)`-dependent.  Hence
   `slabWeightMirror_signRho` computes the full connected slab weight explicitly
   as `signWeightA β a b`, a product over the two spatial links of the
   flux-dependent factor.  `slabSignBlock_flux_dependent` exhibits two entries of
   the block that DISAGREE (`exp (2β) ≠ exp (-2β)`), the exact contrast with the
   flux-blind trivial-rep block `SlabCenterWitness.slabWeightMirror_trivialRho_const`.

2. **The explicit block.**  `slabSignBlock β := rpBlockMatrix (slabWeightMirror β signRho)`
   is computed entrywise (`slabSignBlock_apply`) and its action on a vector
   (`slabSignBlock_mulVec`).

3. **Genuine two-state center-flux structure.**  The per-cut `4 × 4` block is the
   Kronecker square of the exactly-solvable one-link `2 × 2` kernel
   `[[e^β, e^{-β}], [e^{-β}, e^β]]`.  Its spectrum is
   `{(e^β+e^{-β})², (e^β+e^{-β})(e^β-e^{-β}) (×2), (e^β-e^{-β})²}`.  We exhibit
   the vacuum eigenvector (trivial center charge) with eigenvalue
   `lam0 = (e^β+e^{-β})²` and the flux eigenvector (nontrivial center charge,
   the sign character on the second spatial link) with eigenvalue
   `lamFlux = (e^β+e^{-β})(e^β-e^{-β})`, with `0 < lamFlux < lam0`.  These live in
   genuinely disjoint one-dimensional center sectors preserved by the block.

4. **The honest witness + gap.**  `slabSignFluxWitness` packages the above as a
   `TwoStateTransferZ2Sector.FiniteFluxGapWitness` whose transfer IS the block —
   the analogue of the REFUTED trivial-rep center-witness, now TRUE — and
   `slabSignBlock_closureGap_pos : 0 < (slabSignFluxWitness β hβ).fluxGap` is the
   genuine full-block NE-U4 center-flux gap.

## Documented true structure (not a two-eigenvalue block)

Unlike a literal `2 × 2` transfer, the full `32 × 32` sign-rep block is NOT
two-state: per cut it carries THREE distinct positive eigenvalues
`lam0 > lamFlux (×2) > (e^β-e^{-β})²`, times eight cut sectors.  The
`FiniteFluxGapWitness` does not require the block to have exactly two
eigenvalues — it requires two ordered, strictly-positive eigenvectors in
disjoint preserved sectors, which the sign rep supplies (and the trivial rep
provably cannot).  So the corrected claim is genuinely TRUE; the extra positive
eigenvalues are recorded here as the honest full spectral structure.

Claim label: **finite identity** (genuine full connected-slab center-flux gap,
sign representation).  No new `axiom`, no `native_decide`, no weakening.
-/

noncomputable section

set_option linter.unusedFintypeInType false
set_option linter.unusedDecidableInType false

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabSignRepGap

open scoped BigOperators ComplexOrder Matrix
open SlabTransferGap SlabFullSpectrumGap WilsonSlabConnected
open TransferHilbertBlock

/-! ## Z2 basics -/

/-- The nontrivial element of `Z2`. -/
def gen : Z2 := Multiplicative.ofAdd (1 : ZMod 2)

theorem z2_cases (g : Z2) : g = 1 ∨ g = gen := by revert g; decide
theorem gen_ne_one : gen ≠ 1 := by decide
theorem gen_mul_gen : gen * gen = 1 := by decide

/-! ## The sign representation -/

/-- The nontrivial one-dimensional unitary (sign) representation of `Z2`:
`signRho g = 1` if `g = 1`, else `-1`.  Its character `reChar signRho g = ±1`
SEPARATES the two `Z2` classes, unlike the constant trivial character. -/
def signRho : Z2 → Matrix (Fin 1) (Fin 1) ℂ := fun g => if g = 1 then 1 else -1

theorem signRho_one : signRho 1 = 1 := by simp [signRho]

theorem signRho_mul (g h : Z2) : signRho (g * h) = signRho g * signRho h := by
  rcases z2_cases g with hg | hg <;> rcases z2_cases h with hh | hh <;> subst hg <;> subst hh <;>
    simp [signRho, gen_ne_one, gen_mul_gen]

theorem signRho_unit (g : Z2) : (signRho g)ᴴ * signRho g = 1 := by
  rcases z2_cases g with hg | hg <;> subst hg <;> simp [signRho, gen_ne_one]

/-- **The sign character separates the classes:** `reChar signRho g = ±1`. -/
theorem reChar_signRho (g : Z2) :
    WilsonWeightPositivity.reChar signRho g = if g = 1 then (1 : ℝ) else -1 := by
  unfold WilsonWeightPositivity.reChar signRho
  split
  · simp [Matrix.trace_one]
  · rw [Matrix.trace_neg, Matrix.trace_one]; simp

/-- **The Wilson per-link kernel is flux-DEPENDENT for the sign rep:**
`wilsonKernel β signRho g h = exp (β · (if g = h then 1 else -1))`. -/
theorem wilsonKernel_signRho (beta : ℝ) (g h : Z2) :
    WilsonWeightPositivity.wilsonKernel beta signRho g h
      = Real.exp (beta * (if g = h then 1 else -1)) := by
  unfold WilsonWeightPositivity.wilsonKernel
  simp only [Matrix.of_apply]
  rw [reChar_signRho]
  congr 2
  by_cases h' : g = h
  · simp [h']
  · rw [if_neg (by simpa [mul_inv_eq_one] using h'), if_neg h']

/-! ## The explicit slab weight -/

/-- The `±1` sign of an equality test on `Z2`. -/
def sgnEq (x y : Z2) : ℝ := if x = y then 1 else -1

/-- The explicit connected-slab Wilson weight of the sign rep, as a function of
the positive-side and mirrored negative-side spatial links only (the cut cancels
in each plaquette holonomy): a PRODUCT over the two spatial links of the
flux-dependent factor `exp (β · sgnEq)`. -/
def signWeightA (beta : ℝ) (a b : Z2 × Z2) : ℝ :=
  Real.exp (beta * sgnEq a.1 b.1) * Real.exp (beta * sgnEq a.2 b.2)

/-- The sign character on a single `Z2` factor. -/
def chiC (x : Z2) : ℝ := if x = 1 then 1 else -1

/-- **The connected slab's Wilson weight is flux-DEPENDENT for the sign rep.**
`slabWeightMirror β signRho a c b = signWeightA β a b`.  The cut `c` cancels
(abelian), but — unlike the trivial rep's constant `exp (2β)` — the weight now
depends on whether the positive and mirror spatial links agree. -/
theorem slabWeightMirror_signRho
    (beta : ℝ) (a : Z2 × Z2) (c : Z2 × Z2 × Z2) (b : Z2 × Z2) :
    slabWeightMirror (G := Z2) (n := 1) beta signRho a c b
      = ((signWeightA beta a b : ℝ) : ℂ) := by
  unfold slabWeightMirror
  rw [slab_weight_slabMirrorConfig_eq_wilsonKernel_prod]
  congr 1
  have huniv : (Finset.univ : Finset SlabPlaq) = {SlabPlaq.pA, SlabPlaq.pB} := by decide
  rw [huniv, Finset.prod_insert (by decide), Finset.prod_singleton,
    wilsonKernel_signRho, wilsonKernel_signRho]
  rcases a with ⟨a0, a1⟩; rcases b with ⟨b0, b1⟩; rcases c with ⟨c0, c1, c2⟩
  simp only [slabEWord]
  unfold signWeightA sgnEq
  have hA : (c0 * a0 * c1⁻¹ = c0 * b0 * c1⁻¹) ↔ (a0 = b0) := by
    rw [mul_left_inj, mul_right_inj]
  have hB : (c1 * a1 * c2⁻¹ = c1 * b1 * c2⁻¹) ↔ (a1 = b1) := by
    rw [mul_left_inj, mul_right_inj]
  simp only [hA, hB]

/-! ## The explicit block -/

/-- **The FULL connected two-plaquette slab transfer block over `Z2` with the
SIGN rep**: `rpBlockMatrix (slabWeightMirror β signRho)`, i.e.
`slabTransferBlock (G := Z2) β signRho`. -/
def slabSignBlock (beta : ℝ) : Matrix SlabIdx SlabIdx ℂ :=
  slabTransferBlock (G := Z2) (n := 1) beta signRho

/-- The sign-rep block is positive semidefinite (reuse of the RP engine). -/
theorem slabSignBlock_posSemidef (beta : ℝ) (hbeta : 0 ≤ beta) :
    (slabSignBlock beta).PosSemidef :=
  slabTransferBlock_posSemidef beta hbeta signRho signRho_mul signRho_one signRho_unit

/-- The sign-rep block is Hermitian. -/
theorem slabSignBlock_isHermitian (beta : ℝ) (hbeta : 0 ≤ beta) :
    (slabSignBlock beta).IsHermitian :=
  (slabSignBlock_posSemidef beta hbeta).isHermitian

/-- **The block, explicitly.**  On the diagonal cut sectors it is the
flux-dependent weight `signWeightA β q.2 p.2`; off them it vanishes. -/
theorem slabSignBlock_apply (beta : ℝ) (p q : SlabIdx) :
    slabSignBlock beta p q
      = if p.1 = q.1 then ((signWeightA beta q.2 p.2 : ℝ) : ℂ) else 0 := by
  unfold slabSignBlock slabTransferBlock TransferHilbertBlock.rpBlockMatrix
  simp only [Matrix.of_apply]
  split
  · rw [slabWeightMirror_signRho]
  · rfl

/-- The action of the block on a vector: within each cut sector it is the
`4 × 4` flux-dependent kernel over the positive-side fibre. -/
theorem slabSignBlock_mulVec (beta : ℝ) (v : SlabIdx → ℂ) (p : SlabIdx) :
    (slabSignBlock beta *ᵥ v) p
      = ∑ a : Z2 × Z2, ((signWeightA beta a p.2 : ℝ) : ℂ) * v (p.1, a) := by
  have hexpand : (slabSignBlock beta *ᵥ v) p = ∑ q, slabSignBlock beta p q * v q := by
    simp [Matrix.mulVec, dotProduct]
  rw [hexpand]
  simp only [slabSignBlock_apply, ite_mul, zero_mul]
  rw [Fintype.sum_prod_type]
  rw [Finset.sum_eq_single p.1]
  · simp only [if_true]
  · intro q1 _ hne
    apply Finset.sum_eq_zero
    intro q2 _
    rw [if_neg (fun h => hne h.symm)]
  · intro h; exact absurd (Finset.mem_univ _) h

/-- **Flux dependence (contrast to the trivial rep).**  Two entries of the block
in the SAME cut sector disagree: `exp (2β) ≠ exp (-2β)`.  This is the exact
failure of the flux-blindness `SlabCenterWitness.slabWeightMirror_trivialRho_const`
that doomed the trivial-rep center-witness. -/
theorem slabSignBlock_flux_dependent (beta : ℝ) (hbeta : 0 < beta) :
    slabSignBlock beta ((1 : Z2 × Z2 × Z2), (1, 1)) ((1 : Z2 × Z2 × Z2), (1, 1))
      ≠ slabSignBlock beta ((1 : Z2 × Z2 × Z2), (1, 1)) ((1 : Z2 × Z2 × Z2), (gen, gen)) := by
  intro h
  rw [slabSignBlock_apply, slabSignBlock_apply] at h
  simp only [if_true, Complex.ofReal_inj] at h
  have l1 : signWeightA beta ((1 : Z2), (1 : Z2)) ((1 : Z2), (1 : Z2))
      = Real.exp beta * Real.exp beta := by
    simp [signWeightA, sgnEq]
  have l2 : signWeightA beta (gen, gen) ((1 : Z2), (1 : Z2))
      = Real.exp (-beta) * Real.exp (-beta) := by
    simp [signWeightA, sgnEq, gen_ne_one]
  rw [l1, l2, ← Real.exp_add, ← Real.exp_add, Real.exp_eq_exp] at h
  nlinarith [hbeta]

/-! ## Eigenvalues and the key row sums -/

/-- The vacuum (trivial center) eigenvalue `(e^β + e^{-β})²`. -/
def lam0 (beta : ℝ) : ℝ := (Real.exp beta + Real.exp (-beta)) ^ 2

/-- The flux (nontrivial center) eigenvalue `(e^β + e^{-β})(e^β - e^{-β})`. -/
def lamFlux (beta : ℝ) : ℝ :=
  (Real.exp beta + Real.exp (-beta)) * (Real.exp beta - Real.exp (-beta))

theorem lam0_pos (beta : ℝ) : 0 < lam0 beta := by
  unfold lam0
  have := add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
  positivity

theorem lamFlux_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < lamFlux beta := by
  unfold lamFlux
  have h1 : 0 < Real.exp beta + Real.exp (-beta) :=
    add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
  have h2 : Real.exp (-beta) < Real.exp beta := Real.exp_lt_exp.mpr (by linarith)
  have : 0 < Real.exp beta - Real.exp (-beta) := by linarith
  positivity

theorem lamFlux_lt_lam0 (beta : ℝ) : lamFlux beta < lam0 beta := by
  unfold lamFlux lam0
  have h1 : 0 < Real.exp beta + Real.exp (-beta) :=
    add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
  have h2 : 0 < Real.exp (-beta) := Real.exp_pos _
  nlinarith [h1, h2]

/-- Single-factor row sum on one `Z2`: `∑ a₀ exp(β·sgnEq a₀ b₀) = e^β + e^{-β}`,
independent of `b₀`. -/
theorem singleSum (beta : ℝ) (b0 : Z2) :
    ∑ a0 : Z2, Real.exp (beta * sgnEq a0 b0) = Real.exp beta + Real.exp (-beta) := by
  have huniv : (Finset.univ : Finset Z2) = {1, gen} := by decide
  rw [huniv, Finset.sum_insert (by decide), Finset.sum_singleton]
  rcases z2_cases b0 with hb | hb <;> subst hb <;>
    simp only [sgnEq, if_pos, gen_ne_one, if_neg (Ne.symm gen_ne_one), if_false,
      mul_one, mul_neg_one]
  all_goals ring

/-- Single-factor flux sum on one `Z2`:
`∑ a₁ exp(β·sgnEq a₁ b₁)·χ(a₁) = (e^β - e^{-β})·χ(b₁)`. -/
theorem fluxSingleSum (beta : ℝ) (b1 : Z2) :
    ∑ a1 : Z2, Real.exp (beta * sgnEq a1 b1) * chiC a1
      = (Real.exp beta - Real.exp (-beta)) * chiC b1 := by
  have huniv : (Finset.univ : Finset Z2) = {1, gen} := by decide
  rw [huniv, Finset.sum_insert (by decide), Finset.sum_singleton]
  rcases z2_cases b1 with hb | hb <;> subst hb <;>
    simp only [sgnEq, chiC, if_pos, gen_ne_one, if_neg (Ne.symm gen_ne_one), if_false,
      mul_one, mul_neg_one]
  all_goals ring

/-- **Vacuum row sum:** `∑ a signWeightA β a b = lam0 β`, independent of `b`.
This is the vacuum eigenvalue equation on the `4 × 4` per-cut block. -/
theorem signWeightA_row_sum (beta : ℝ) (b : Z2 × Z2) :
    ∑ a : Z2 × Z2, signWeightA beta a b = lam0 beta := by
  rw [Fintype.sum_prod_type]
  simp only [signWeightA]
  rw [Finset.sum_congr rfl (fun a0 _ => by rw [← Finset.mul_sum, singleSum])]
  rw [← Finset.sum_mul, singleSum]
  unfold lam0; ring

/-- **Flux row sum:** `∑ a signWeightA β a b · χ(a₂) = lamFlux β · χ(b₂)`.
This is the flux eigenvalue equation on the `4 × 4` per-cut block, with the sign
character `χ` on the second spatial link as the center-flux quantum number. -/
theorem signWeightA_flux_sum (beta : ℝ) (b : Z2 × Z2) :
    ∑ a : Z2 × Z2, signWeightA beta a b * chiC a.2 = lamFlux beta * chiC b.2 := by
  rw [Fintype.sum_prod_type]
  simp only [signWeightA]
  rw [Finset.sum_congr rfl (fun a0 _ => by
    rw [Finset.sum_congr rfl (fun a1 _ => by ring :
      ∀ a1 ∈ Finset.univ,
        Real.exp (beta * sgnEq a0 b.1) * Real.exp (beta * sgnEq a1 b.2) * chiC a1
          = Real.exp (beta * sgnEq a0 b.1) * (Real.exp (beta * sgnEq a1 b.2) * chiC a1)),
      ← Finset.mul_sum, fluxSingleSum])]
  rw [← Finset.sum_mul, singleSum]
  unfold lamFlux; ring

/-! ## The eigenvectors and center sectors -/

/-- The fixed cut sector (identity cut) that carries the eigenvectors. -/
def cfix : Z2 × Z2 × Z2 := 1

/-- The vacuum eigenvector: constant on the fixed cut sector (trivial center
charge), zero elsewhere. -/
def vacuumVecSign : SlabIdx → ℂ := fun p => if p.1 = cfix then 1 else 0

/-- The flux eigenvector: the sign character of the second spatial link on the
fixed cut sector (nontrivial center charge), zero elsewhere. -/
def fluxVecSign : SlabIdx → ℂ := fun p => if p.1 = cfix then ((chiC p.2.2 : ℝ) : ℂ) else 0

/-- **Vacuum eigenvector equation** with eigenvalue `lam0 β`. -/
theorem slabSignBlock_mulVec_vacuum (beta : ℝ) :
    slabSignBlock beta *ᵥ vacuumVecSign = (lam0 beta : ℂ) • vacuumVecSign := by
  funext p
  rw [slabSignBlock_mulVec, Pi.smul_apply, smul_eq_mul]
  have hconst : ∀ a : Z2 × Z2, vacuumVecSign (p.1, a) = vacuumVecSign p := fun _ => rfl
  simp only [hconst]
  rw [← Finset.sum_mul]
  have hsum : (∑ a : Z2 × Z2, ((signWeightA beta a p.2 : ℝ) : ℂ)) = ((lam0 beta : ℝ) : ℂ) := by
    rw [← Complex.ofReal_sum, signWeightA_row_sum]
  rw [hsum]

/-- **Flux eigenvector equation** with eigenvalue `lamFlux β`. -/
theorem slabSignBlock_mulVec_flux (beta : ℝ) :
    slabSignBlock beta *ᵥ fluxVecSign = (lamFlux beta : ℂ) • fluxVecSign := by
  funext p
  rw [slabSignBlock_mulVec, Pi.smul_apply, smul_eq_mul]
  by_cases hp : p.1 = cfix
  · have hval : ∀ a : Z2 × Z2, fluxVecSign (p.1, a) = ((chiC a.2 : ℝ) : ℂ) := by
      intro a; simp only [fluxVecSign, hp, if_pos]
    simp only [hval]
    have hsum : (∑ a : Z2 × Z2, ((signWeightA beta a p.2 : ℝ) : ℂ) * ((chiC a.2 : ℝ) : ℂ))
        = ((lamFlux beta * chiC p.2.2 : ℝ) : ℂ) := by
      rw [← signWeightA_flux_sum beta p.2, Complex.ofReal_sum]
      exact Finset.sum_congr rfl (fun a _ => by rw [Complex.ofReal_mul])
    rw [hsum]
    push_cast; ring
  · have hval : ∀ a : Z2 × Z2, fluxVecSign (p.1, a) = 0 := by
      intro a; simp only [fluxVecSign, hp, if_neg, not_false_iff]
    simp only [hval, mul_zero, Finset.sum_const_zero]

theorem chiC_one : chiC (1 : Z2) = 1 := by simp [chiC]
theorem chiC_gen : chiC gen = -1 := by simp [chiC, gen_ne_one]

theorem vacuumVecSign_cfix (a : Z2 × Z2) : vacuumVecSign (cfix, a) = 1 := by
  simp [vacuumVecSign]
theorem fluxVecSign_cfix (a : Z2 × Z2) :
    fluxVecSign (cfix, a) = ((chiC a.2 : ℝ) : ℂ) := by simp [fluxVecSign]

/-- The vacuum center sector (span of the vacuum eigenvector). -/
def vacuumSectorSign : Submodule ℂ (SlabIdx → ℂ) := Submodule.span ℂ {vacuumVecSign}

/-- The flux center sector (span of the flux eigenvector). -/
def fluxSectorSign : Submodule ℂ (SlabIdx → ℂ) := Submodule.span ℂ {fluxVecSign}

theorem vacuumVecSign_ne_zero : vacuumVecSign ≠ 0 := by
  intro h
  have := congrFun h (cfix, (1, 1))
  simp only [vacuumVecSign, if_pos, Pi.zero_apply] at this
  exact one_ne_zero this

theorem fluxVecSign_ne_zero : fluxVecSign ≠ 0 := by
  intro h
  have := congrFun h (cfix, (1, 1))
  simp only [fluxVecSign, if_pos, chiC, Pi.zero_apply] at this
  norm_num at this

theorem transfer_preserves_vacuumSectorSign (beta : ℝ) :
    ∀ v ∈ vacuumSectorSign, (slabSignBlock beta).mulVecLin v ∈ vacuumSectorSign := by
  intro v hv
  rw [vacuumSectorSign, Submodule.mem_span_singleton] at hv ⊢
  obtain ⟨a, rfl⟩ := hv
  refine ⟨a * (lam0 beta : ℂ), ?_⟩
  rw [map_smul, Matrix.mulVecLin_apply, slabSignBlock_mulVec_vacuum, smul_smul]

theorem transfer_preserves_fluxSectorSign (beta : ℝ) :
    ∀ v ∈ fluxSectorSign, (slabSignBlock beta).mulVecLin v ∈ fluxSectorSign := by
  intro v hv
  rw [fluxSectorSign, Submodule.mem_span_singleton] at hv ⊢
  obtain ⟨a, rfl⟩ := hv
  refine ⟨a * (lamFlux beta : ℂ), ?_⟩
  rw [map_smul, Matrix.mulVecLin_apply, slabSignBlock_mulVec_flux, smul_smul]

/-- **The two center sectors are genuinely disjoint.**  The vacuum and flux
eigenvectors are linearly independent (evaluate at `(cfix,(1,1))` and
`(cfix,(1,gen))`), so their spans intersect trivially. -/
theorem sectorsSign_disjoint : vacuumSectorSign ⊓ fluxSectorSign = ⊥ := by
  rw [Submodule.eq_bot_iff]
  intro x hx
  simp only [Submodule.mem_inf, vacuumSectorSign, fluxSectorSign,
    Submodule.mem_span_singleton] at hx
  obtain ⟨⟨a, ha⟩, ⟨b, hb⟩⟩ := hx
  have h1 := congrFun (ha.trans hb.symm) ((cfix, ((1 : Z2), (1 : Z2))) : SlabIdx)
  have h2 := congrFun (ha.trans hb.symm) ((cfix, ((1 : Z2), gen)) : SlabIdx)
  rw [Pi.smul_apply, Pi.smul_apply, vacuumVecSign_cfix, fluxVecSign_cfix,
    smul_eq_mul, smul_eq_mul] at h1 h2
  simp only [chiC_one, chiC_gen, Complex.ofReal_one, Complex.ofReal_neg,
    mul_one, mul_neg_one] at h1 h2
  -- h1 : a = b, h2 : a = -b ⇒ b = 0
  have hbb : b = -b := by rw [h1] at h2; exact h2
  have hb0 : b = 0 := by linear_combination hbb / 2
  rw [← ha, h1, hb0, zero_smul]

/-! ## The honest witness and the genuine center-flux gap -/

/-- **The honest full-block center-flux witness for the SIGN rep.**  Every field
carries genuine content: the transfer IS the full connected two-plaquette block
`slabSignBlock β`, the vacuum `(lam0)` and flux `(lamFlux)` eigenvectors are
exact, they live in disjoint preserved one-dimensional center sectors, and
`0 < lamFlux < lam0`.  This is the analogue of the trivial-rep center-witness
REFUTED by `SlabCenterWitness.slabFullBlock_no_centerWitness` — now TRUE, because
the sign character makes the block flux-dependent. -/
def slabSignFluxWitness (beta : ℝ) (hbeta : 0 < beta) :
    TwoStateTransferZ2Sector.FiniteFluxGapWitness (SlabIdx → ℂ) where
  transfer := (slabSignBlock beta).mulVecLin
  vacuumSector := vacuumSectorSign
  fluxSector := fluxSectorSign
  lambda0 := lam0 beta
  lambdaFlux := lamFlux beta
  lambda0_pos := lam0_pos beta
  lambdaFlux_pos := lamFlux_pos hbeta
  lambdaFlux_lt_lambda0 := lamFlux_lt_lam0 beta
  transfer_preserves_vacuumSector := transfer_preserves_vacuumSectorSign beta
  transfer_preserves_fluxSector := transfer_preserves_fluxSectorSign beta
  vacuum := vacuumVecSign
  vacuum_mem := Submodule.mem_span_singleton_self _
  vacuum_ne_zero := vacuumVecSign_ne_zero
  vacuum_eigen := by
    rw [Matrix.mulVecLin_apply]; exact slabSignBlock_mulVec_vacuum beta
  fluxExcitation := fluxVecSign
  fluxExcitation_mem := Submodule.mem_span_singleton_self _
  fluxExcitation_ne_zero := fluxVecSign_ne_zero
  fluxExcitation_eigen := by
    rw [Matrix.mulVecLin_apply]; exact slabSignBlock_mulVec_flux beta
  sectors_disjoint := sectorsSign_disjoint

/-- The witness transfer is exactly the sign-rep full connected block. -/
theorem slabSignFluxWitness_transfer (beta : ℝ) (hbeta : 0 < beta) :
    (slabSignFluxWitness beta hbeta).transfer = (slabSignBlock beta).mulVecLin :=
  rfl

/-- **THE GENUINE FULL-BLOCK NE-U4 CENTER-FLUX GAP.**  The center-flux gap of
the full connected two-plaquette Wilson block over the sign representation is
strictly positive — the honest, TRUE analogue of the REFUTED trivial-rep
center-witness gap. -/
theorem slabSignBlock_closureGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < (slabSignFluxWitness beta hbeta).fluxGap :=
  (slabSignFluxWitness beta hbeta).fluxGap_pos

end SlabSignRepGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
