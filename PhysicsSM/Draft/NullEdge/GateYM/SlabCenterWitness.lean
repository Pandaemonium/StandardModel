import PhysicsSM.Draft.NullEdge.GateYM.SlabFullSpectrumGap

/-!
# Gate YM / NE-U4: RESOLUTION of the `slabFullBlock_centerWitness` handoff

`SlabFullSpectrumGap.slabFullBlock_centerWitness` CLAIMS (as an existence
`s o r r y`) that the FULL connected two-plaquette Wilson slab transfer block over
`G = Z2` with the **trivial** `1 × 1` unitary representation `trivialRho`
reduces to an honest two-state `TwoStateTransferZ2Sector.FiniteFluxGapWitness`
on its `Z2` center sectors, with two DISTINCT strictly-positive eigenvalues
`lambdaFlux < lambda0` (a genuine center-flux gap).

## Verdict: the claim is FALSE for the trivial representation.

This module records the kernel-checked **refutation** and the corrected true
center structure.  The root cause is elementary:

* The trivial representation has a **constant** character:
  `reChar trivialRho g = 1` for every `g`, hence the Wilson per-link kernel
  `wilsonKernel β trivialRho g h = exp β` is **constant** in `(g, h)`
  (`slabWeightMirror_trivialRho_const`).  So the connected slab's Wilson weight
  carries NO flux dependence whatsoever: `slabWeightMirror β trivialRho a c b`
  is the constant `exp (2 β)`.

* Consequently the full block is
  `slabFullBlock β (c₁, b) (c₂, a) = if c₁ = c₂ then exp (2 β) else 0`
  (`slabFullBlock_apply`): it is `exp (2 β)` times a matrix that is
  block-diagonal in the cut coordinate `c ∈ Z2³`, each block being the
  `4 × 4` all-ones matrix over `A = Z2 × Z2`.

* Every such block is (a scalar times) a rank-one all-ones matrix, so the
  full `32 × 32` block satisfies
  `slabFullBlock β *ᵥ (slabFullBlock β *ᵥ v) = (4 · exp (2 β)) • (slabFullBlock β *ᵥ v)`
  (`slabFullBlock_mulVec_sq`).  Its ONLY eigenvalues are
  `4 · exp (2 β)` (multiplicity `8`, one per cut sector) and `0`
  (multiplicity `24`).  In particular any strictly-positive eigenvalue is
  FORCED to equal `4 · exp (2 β)` (`slabFullBlock_pos_eigenvalue_unique`).

* A `FiniteFluxGapWitness` needs two eigenvectors with strictly-positive and
  strictly-ordered eigenvalues `0 < lambdaFlux < lambda0`.  Both must equal
  `4 · exp (2 β)`, contradicting `lambdaFlux < lambda0`.  Hence NO such witness
  exists: `slabFullBlock_no_centerWitness`.

## What this means for `slabFullClosureGap_pos`

`SlabFullSpectrumGap.slabFullClosureGap_pos` is derived (via `Classical.choose`)
from the FALSE `slabFullBlock_centerWitness`, so with the trivial rep it does
NOT become unconditional: it rests on a `s o r r y` whose statement is refuted here.
The genuine one-link sector gap `SlabTransferGap.neU4ClosureGap` is unaffected —
it is proved directly from the exactly-solvable one-link `Z2` slab
(`TwoStateTransferZ2Sector.fluxGapWitness`), NOT from this full-block reduction.

The corrected reading: with the trivial representation the full connected block
has a single (highly degenerate) positive center eigenvalue `4 · exp (2 β)` and
a large kernel; there is no second, lighter center-flux eigenvalue, so there is
no two-state flux gap intrinsic to this block.  A genuine center-flux splitting
requires a representation whose character actually separates the `Z2` classes
(e.g. the sign representation `g ↦ (-1)^g`), NOT the trivial one used to define
`slabFullBlock`.

Claim label: **finite identity** (kernel-checked negative + corrected center
structure).  No new `axiom`, no `native_decide`, no weakening.
-/

noncomputable section

set_option linter.unusedFintypeInType false
set_option linter.unusedDecidableInType false

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabCenterWitness

open scoped BigOperators ComplexOrder Matrix
open SlabTransferGap SlabFullSpectrumGap WilsonSlabConnected

/-! ## Step 1: the trivial representation gives a constant Wilson weight -/

/-- The trivial representation has constant character real part `1`. -/
theorem reChar_trivialRho (g : Z2) :
    WilsonWeightPositivity.reChar trivialRho g = 1 := by
  unfold WilsonWeightPositivity.reChar trivialRho
  rw [Matrix.trace_one]
  simp

/-- The Wilson per-link kernel of the trivial representation is the constant
`exp β`. -/
theorem wilsonKernel_trivialRho (beta : ℝ) (g h : Z2) :
    WilsonWeightPositivity.wilsonKernel beta trivialRho g h = Real.exp beta := by
  unfold WilsonWeightPositivity.wilsonKernel
  simp only [Matrix.of_apply]
  rw [reChar_trivialRho]
  ring_nf

/-- **The connected slab's Wilson weight is constant for the trivial rep.**
`slabWeightMirror β trivialRho a c b = exp (2 β)`, independent of the positive
side `a`, the cut `c`, and the mirrored negative side `b`. -/
theorem slabWeightMirror_trivialRho_const
    (beta : ℝ) (a : Z2 × Z2) (c : Z2 × Z2 × Z2) (b : Z2 × Z2) :
    slabWeightMirror (G := Z2) (n := 1) beta trivialRho a c b
      = ((Real.exp (2 * beta) : ℝ) : ℂ) := by
  unfold slabWeightMirror
  rw [slab_weight_slabMirrorConfig_eq_wilsonKernel_prod]
  congr 1
  rw [Finset.prod_congr rfl (fun k _ => wilsonKernel_trivialRho beta _ _),
    Finset.prod_const]
  have hcard : (Finset.univ : Finset WilsonSlabConnected.SlabPlaq).card = 2 := by decide
  rw [hcard, ← Real.exp_nat_mul]
  norm_num

/-! ## Step 2: the full block explicitly -/

/-- **The full connected block, explicitly.**  For the trivial rep it is
`exp (2 β)` on the diagonal cut sectors and `0` off them:
`slabFullBlock β (c₁, b) (c₂, a) = if c₁ = c₂ then exp (2 β) else 0`. -/
theorem slabFullBlock_apply (beta : ℝ) (p q : SlabIdx) :
    slabFullBlock beta p q
      = if p.1 = q.1 then ((Real.exp (2 * beta) : ℝ) : ℂ) else 0 := by
  unfold slabFullBlock slabTransferBlock TransferHilbertBlock.rpBlockMatrix
  simp only [Matrix.of_apply]
  split
  · rw [slabWeightMirror_trivialRho_const]
  · rfl

/-- The action of the full block on a vector: it sums the vector
over the positive-side fibre of the row's cut, scaled by `exp (2 β)`. -/
theorem slabFullBlock_mulVec (beta : ℝ) (v : SlabIdx → ℂ) (p : SlabIdx) :
    (slabFullBlock beta *ᵥ v) p
      = ((Real.exp (2 * beta) : ℝ) : ℂ) * ∑ a : Z2 × Z2, v (p.1, a) := by
  have hexpand : (slabFullBlock beta *ᵥ v) p
      = ∑ q, slabFullBlock beta p q * v q := by
    simp [Matrix.mulVec, dotProduct]
  rw [hexpand]
  simp only [slabFullBlock_apply, ite_mul, zero_mul]
  rw [Fintype.sum_prod_type]
  rw [Finset.sum_eq_single p.1]
  · simp only [if_true, Finset.mul_sum]
  · intro q1 _ hne
    apply Finset.sum_eq_zero
    intro q2 _
    rw [if_neg (fun h => hne h.symm)]
  · intro h; exact absurd (Finset.mem_univ _) h

/-! ## Step 3: the block squares to a scalar multiple of itself -/

/-- **The full block is idempotent up to the scalar `4 · exp (2 β)`.**  Applying
the block twice equals `4 · exp (2 β)` times applying it once, because each cut
sector block is a rank-one all-ones matrix on the `4`-element positive-side
fibre. -/
theorem slabFullBlock_mulVec_sq (beta : ℝ) (v : SlabIdx → ℂ) :
    slabFullBlock beta *ᵥ (slabFullBlock beta *ᵥ v)
      = ((4 * Real.exp (2 * beta) : ℝ) : ℂ) • (slabFullBlock beta *ᵥ v) := by
  funext p
  rw [Pi.smul_apply, smul_eq_mul, slabFullBlock_mulVec]
  conv_lhs =>
    rw [Finset.sum_congr rfl (fun a _ => slabFullBlock_mulVec beta v (p.1, a))]
  rw [slabFullBlock_mulVec]
  dsimp only
  rw [Finset.sum_const, Finset.card_univ, (by decide : Fintype.card (Z2 × Z2) = 4),
    nsmul_eq_mul]
  push_cast
  ring

/-! ## Step 4: uniqueness of the positive eigenvalue -/

/-- **Every strictly-positive eigenvalue of the full block equals
`4 · exp (2 β)`.**  If `v ≠ 0` and `slabFullBlock β *ᵥ v = (μ : ℂ) • v` for a
real `μ`, then either `μ = 0` or `μ = 4 · exp (2 β)`.  There is no second,
lighter positive center eigenvalue. -/
theorem slabFullBlock_eigenvalue_dichotomy
    (beta : ℝ) {v : SlabIdx → ℂ} {mu : ℝ}
    (hv : v ≠ 0)
    (heig : slabFullBlock beta *ᵥ v = (mu : ℂ) • v) :
    mu = 0 ∨ mu = 4 * Real.exp (2 * beta) := by
  have hsq := slabFullBlock_mulVec_sq beta v
  rw [heig, Matrix.mulVec_smul, heig, smul_smul, smul_smul] at hsq
  have hscal : (mu : ℂ) * (mu : ℂ)
      = ((4 * Real.exp (2 * beta) : ℝ) : ℂ) * (mu : ℂ) := by
    have hsub : ((mu : ℂ) * (mu : ℂ)
        - ((4 * Real.exp (2 * beta) : ℝ) : ℂ) * (mu : ℂ)) • v = 0 := by
      rw [sub_smul, hsq, sub_self]
    rcases smul_eq_zero.1 hsub with h | h
    · exact sub_eq_zero.1 h
    · exact absurd h hv
  have hreal : mu * mu = (4 * Real.exp (2 * beta)) * mu := by exact_mod_cast hscal
  have hfac : mu * (mu - 4 * Real.exp (2 * beta)) = 0 := by linear_combination hreal
  rcases mul_eq_zero.1 hfac with h | h
  · left; exact h
  · right; linarith [sub_eq_zero.1 h]

/-! ## Step 5: the refutation -/

/-- **REFUTATION (verified negative).**  There is NO honest two-state
`FiniteFluxGapWitness` whose transfer is the full connected block over the
trivial representation: the block has a single positive eigenvalue
`4 · exp (2 β)`, so two distinct strictly-positive ordered eigenvalues cannot
both be realised.  This refutes the existence claimed (as a `s o r r y`) by
`SlabFullSpectrumGap.slabFullBlock_centerWitness`. -/
theorem slabFullBlock_no_centerWitness (beta : ℝ) :
    ¬ ∃ W : TwoStateTransferZ2Sector.FiniteFluxGapWitness (SlabIdx → ℂ),
        W.transfer = (slabFullBlock beta).mulVecLin := by
  rintro ⟨W, hW⟩
  -- vacuum and flux excitation are eigenvectors with real eigenvalues
  have hvac : slabFullBlock beta *ᵥ W.vacuum = (W.lambda0 : ℂ) • W.vacuum := by
    have := W.vacuum_eigen
    rw [hW] at this
    simpa [Matrix.mulVecLin_apply] using this
  have hflux : slabFullBlock beta *ᵥ W.fluxExcitation
      = (W.lambdaFlux : ℂ) • W.fluxExcitation := by
    have := W.fluxExcitation_eigen
    rw [hW] at this
    simpa [Matrix.mulVecLin_apply] using this
  -- both eigenvalues are forced to be `4 · exp (2 β)`
  have h0 : W.lambda0 = 4 * Real.exp (2 * beta) := by
    rcases slabFullBlock_eigenvalue_dichotomy beta W.vacuum_ne_zero hvac with h | h
    · exact absurd h (ne_of_gt W.lambda0_pos)
    · exact h
  have hf : W.lambdaFlux = 4 * Real.exp (2 * beta) := by
    rcases slabFullBlock_eigenvalue_dichotomy beta W.fluxExcitation_ne_zero hflux with h | h
    · exact absurd h (ne_of_gt W.lambdaFlux_pos)
    · exact h
  have := W.lambdaFlux_lt_lambda0
  rw [h0, hf] at this
  exact lt_irrefl _ this

end SlabCenterWitness
end GateYM
end NullEdge
end Draft
end PhysicsSM
