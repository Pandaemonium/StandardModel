import Mathlib
import PhysicsSM.Gauge.StandardModelBlockHom

/-!
# Gauge.StandardModelZ6Kernel

Exact kernel reconstruction for the Standard Model covering map
`coveringMap : ℂ → M₂(ℂ) → M₃(ℂ) → M₂(ℂ) × M₃(ℂ)`.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))` is
  `ι(α, g, h) = (α³ • g, α⁻² • h)`

Its kernel consists of triples `(α, g, h)` with `ι(α, g, h) = (I₂, I₃)`.
Unfolding forces `g = α⁻³ • I₂` and `h = α² • I₃`. The determinant-one
constraints `det(g) = 1`, `det(h) = 1` then force `α⁶ = 1`, giving exactly
six kernel elements indexed by the sixth roots of unity.

This module proves both directions:
- **Forward**: if `coveringMap α g h = (1, 1)` and the determinant-one
  constraints hold, then `α⁶ = 1` and `(α, g, h)` is a `CoveringKernelElt`.
- **Backward**: every `CoveringKernelElt` maps to `(1, 1)` (already in
  `StandardModelSubgroup`).

These together identify the kernel of the covering map as exactly the set
of `CoveringKernelElt` values — the ℤ₆ subgroup.

## Claim boundary

This is the algebraic kernel identification for the concrete matrix covering
map. No topological Lie group quotient theorem is claimed.

## Convention

Hypercharge convention: `Q = T₃ + Y/2`, matching the project standard.
Covering map exponents: `α³` on U(2), `α⁻²` on U(3).

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 17–21.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## Forward direction: kernel membership implies reconstruction -/

/--
If `coveringMap α g h = (1, 1)`, then the first component satisfies
`(α ^ 3) • g = 1`. This is the raw equation extracted from the product pair.
-/
theorem coveringMap_eq_one_fst_eq {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1)) :
    (α ^ 3) • g = 1 := by
  have := congr_arg Prod.fst hk
  simpa [coveringMap] using this

/--
If `coveringMap α g h = (1, 1)`, then the second component satisfies
`(α⁻¹ ^ 2) • h = 1`. This is the raw equation extracted from the product pair.
-/
theorem coveringMap_eq_one_snd_eq {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1)) :
    (α⁻¹ ^ 2) • h = 1 := by
  have := congr_arg Prod.snd hk
  simpa [coveringMap] using this

/--
If `coveringMap α g h = (1, 1)` then `α ≠ 0`.

Proof: if `α = 0` then `α³ • g = 0 ≠ I₂`.
-/
theorem coveringMap_eq_one_phase_ne_zero {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1)) :
    α ≠ 0 := by
  intro hα
  have h1 := coveringMap_eq_one_fst_eq hk
  simp [hα] at h1

/--
**Kernel reconstruction, SU(2) component.**
If `coveringMap α g h = (1, 1)`, then `g = (α⁻¹ ^ 3) • 1`.

This matches `CoveringKernelElt.su2Part`.
-/
theorem coveringMap_eq_one_implies_su2Part {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1)) :
    g = (α⁻¹ ^ 3) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  have hne : α ≠ 0 := coveringMap_eq_one_phase_ne_zero hk
  have h1 := coveringMap_eq_one_fst_eq hk
  have hα3 : α ^ 3 ≠ 0 := pow_ne_zero 3 hne
  -- From (α ^ 3) • g = 1, we get g = (α ^ 3)⁻¹ • 1
  have : g = (α ^ 3)⁻¹ • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    rw [← h1, smul_smul, inv_mul_cancel₀ hα3, one_smul]
  rw [this, inv_pow]

/--
**Kernel reconstruction, SU(3) component.**
If `coveringMap α g h = (1, 1)`, then `h = (α ^ 2) • 1`.

This matches `CoveringKernelElt.su3Part`.
-/
theorem coveringMap_eq_one_implies_su3Part {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1)) :
    h = (α ^ 2) • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  have hne : α ≠ 0 := coveringMap_eq_one_phase_ne_zero hk
  have h2 := coveringMap_eq_one_snd_eq hk
  have hα2 : α⁻¹ ^ 2 ≠ 0 := pow_ne_zero 2 (inv_ne_zero hne)
  -- From (α⁻¹ ^ 2) • h = 1, we get h = (α⁻¹ ^ 2)⁻¹ • 1
  have : h = (α⁻¹ ^ 2)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
    rw [← h2, smul_smul, inv_mul_cancel₀ hα2, one_smul]
  rw [this, inv_pow, inv_inv]

/--
**Phase constraint from SU(3) determinant.**
If `coveringMap α g h = (1, 1)` and `h.det = 1`, then `α ^ 6 = 1`.

Proof: `h = α² • I₃`, so `det(h) = (α²)³ = α⁶ = 1`.
-/
theorem coveringMap_eq_one_det_su3_implies {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1))
    (hh : h.det = 1) :
    α ^ 6 = 1 := by
  have hsu3 := coveringMap_eq_one_implies_su3Part hk
  rw [hsu3] at hh
  simp only [det_smul, Fintype.card_fin, det_one, mul_one] at hh
  -- hh : (α ^ 2) ^ 3 = 1, need α ^ 6 = 1
  rw [← pow_mul] at hh
  exact hh

/--
**Phase is a sixth root of unity.**
If `coveringMap α g h = (1, 1)` and the determinant-one constraints hold
for both `g` (SU(2)) and `h` (SU(3)), then `α ^ 6 = 1`.

The proof uses the SU(3) determinant: `det(α² • I₃) = α⁶ = 1`.
-/
theorem coveringMap_eq_one_implies_phase_pow_six {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1))
    (_hg : g.det = 1) (hh : h.det = 1) :
    α ^ 6 = 1 :=
  coveringMap_eq_one_det_su3_implies hk hh

/-! ## The exact kernel characterization -/

/--
**Forward direction of the exact kernel theorem.**
If `coveringMap α g h = (1, 1)` and both determinant-one constraints hold,
then there exists a `CoveringKernelElt` whose phase is `α` and whose
components match `g` and `h`.
-/
theorem coveringMap_eq_one_of_kernelElt {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hk : coveringMap α g h = (1, 1))
    (hg : g.det = 1) (hh : h.det = 1) :
    ∃ k : CoveringKernelElt,
      k.phase = α ∧
      g = k.su2Part ∧
      h = k.su3Part := by
  refine ⟨⟨α, coveringMap_eq_one_implies_phase_pow_six hk hg hh⟩, rfl, ?_, ?_⟩
  · exact coveringMap_eq_one_implies_su2Part hk
  · exact coveringMap_eq_one_implies_su3Part hk

/--
**Backward direction of the exact kernel theorem.**
Every `CoveringKernelElt` maps to `(1, 1)` under the covering map.

This is a restatement of `coveringKernel_maps_to_one` for the iff.
-/
theorem kernelElt_implies_coveringMap_eq_one (k : CoveringKernelElt) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) := by
  have hne : k.phase ≠ 0 := by
    intro h
    have := k.phase_pow_six
    simp [h] at this
  exact coveringKernel_maps_to_one k hne

/--
**Exact kernel theorem for the Standard Model covering map.**

A triple `(α, g, h)` with `det(g) = 1` and `det(h) = 1` maps to the
identity `(I₂, I₃)` under the covering map if and only if it arises from
a `CoveringKernelElt` — i.e., `α` is a sixth root of unity,
`g = α⁻³ • I₂`, and `h = α² • I₃`.

This identifies the kernel of `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
as exactly the ℤ₆ subgroup generated by the sixth roots of unity.
-/
theorem coveringMap_eq_one_iff_kernelElt {α : ℂ}
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (hg : g.det = 1) (hh : h.det = 1) :
    coveringMap α g h = (1, 1) ↔
      ∃ k : CoveringKernelElt,
        k.phase = α ∧
        g = k.su2Part ∧
        h = k.su3Part := by
  constructor
  · exact fun hk => coveringMap_eq_one_of_kernelElt hk hg hh
  · rintro ⟨k, rfl, rfl, rfl⟩
    exact kernelElt_implies_coveringMap_eq_one k

/-! ## Finite enumeration note

The concrete six-element list `sixCoveringKernelElts` and its injectivity theorem
live in `StandardModelBlockHom`. This module stops at the exact reconstruction
iff; a cardinality/bijection wrapper can build on that theorem.
-/

end PhysicsSM.Gauge.StandardModelSubgroup
