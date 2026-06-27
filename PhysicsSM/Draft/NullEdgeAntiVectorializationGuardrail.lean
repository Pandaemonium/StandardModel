import Mathlib

/-!
# Aristotle C95: anti-vectorialization guardrail for Gate C1

This module is a small, self-contained, finite theorem package that formalizes the
*anti-vectorialization guardrail* for the null-edge Gate C program, independently of
the concrete null-edge operator.

## Scientific role

The point of this file is to make precise, and prove, the following slogan used by
C93/C94 progress accounting:

> Overlap/Ginsparg–Wilson interface + regulator health + modified chirality is **not**
> by itself a Gate C1 release. An honest candidate can be *vectorlike*: every plus
> chirality survivor is paired by a minus chirality survivor, so the net index is zero.
> C1 release additionally requires anti-vectorialization data
> (`AntiVectorlikeWitness` / nonzero net index).

The deliberately weak external health predicate `C0Healthy` plays the role of the C0
external-species-health flag. It is a *toy* external-health flag, **not** a second
ghost-safety API: if C92 later exposes a canonical ghost predicate, this module should
import/reuse it rather than re-deriving health here.

## Summary of what is established

* `vectorlike_implies_zero_index`  : a vectorlike finite spectrum has net index `0`.
* `nonzero_index_forbids_vectorlike` : the anti-vectorlike witness forbids vectorlikeness.
* `c0_health_does_not_forbid_vectorlike` : a **concrete finite table** that is C0-healthy
  *and* vectorlike (a C0-healthy vectorlike countermodel).
* `exists_c0_healthy_antivectorlike` : a **concrete finite table** that is C0-healthy
  *and* carries the anti-vectorlike witness (a C0-healthy non-vectorlike witness).
* `c0_cannot_decide_c1` : both of the above at once, so C0 health is compatible with
  both vectorlike and non-vectorlike finite spectra; hence C0 cannot decide C1.

## Hypothesis accounting

No global assumptions are introduced. `C0Healthy` is a C0 hypothesis (external health),
and `AntiVectorlikeWitness` (equivalently nonzero `NetIndex`) is the additional **C1**
hypothesis that release predicates must demand. Crucially, nonzero index is *not* part
of `C0Healthy`.
-/

namespace PhysicsSM.Draft.NullEdgeAntiVectorializationGuardrail

open Finset

/-- A single physical mode/branch in the finite spectrum table.

* `chiralitySign`  : intended to be `+1` or `-1` for physical chiral modes.
* `multiplicity`   : the (natural-number) weight/degeneracy of the mode.
* `isPhysical`     : whether the mode is in the physical sector.
* `c0Healthy`      : the toy external (C0) health flag for the mode. -/
structure Mode where
  chiralitySign : ℤ
  multiplicity : ℕ
  isPhysical : Bool
  c0Healthy : Bool
deriving DecidableEq, Repr

/-- A finite spectrum table: a finite indexed family of modes. -/
structure Spectrum where
  size : ℕ
  modes : Fin size → Mode

/-- The finset of physical-mode indices of a spectrum. -/
def physical (B : Spectrum) : Finset (Fin B.size) :=
  Finset.univ.filter (fun i => (B.modes i).isPhysical = true)

/-- The (signed) net index of a spectrum: the sum, over physical modes, of
`chiralitySign * multiplicity`. This is the integer-valued index. -/
def NetIndex (B : Spectrum) : ℤ :=
  ∑ i ∈ physical B, (B.modes i).chiralitySign * ((B.modes i).multiplicity : ℤ)

/-- Total multiplicity of physical `+1`-chirality modes. -/
def plusCount (B : Spectrum) : ℕ :=
  ∑ i ∈ (physical B).filter (fun i => (B.modes i).chiralitySign = 1),
    (B.modes i).multiplicity

/-- Total multiplicity of physical `-1`-chirality modes. -/
def minusCount (B : Spectrum) : ℕ :=
  ∑ i ∈ (physical B).filter (fun i => (B.modes i).chiralitySign = -1),
    (B.modes i).multiplicity

/-- The natural-count form of the nonzero-index condition. -/
def netIndexNonzero (B : Spectrum) : Prop := plusCount B ≠ minusCount B

/-- The finite, *honest* secretly-vectorlike condition.

This is **not** defined as `plusCount = minusCount`. It is the richer statement that
there is an involution `σ` on mode indices which, on the physical sector, has no fixed
points, preserves multiplicity, and swaps chirality. Such a pairing is exactly the
mechanism by which every plus-chirality survivor is matched to a minus-chirality
survivor. -/
def VectorlikeSpectrum (B : Spectrum) : Prop :=
  ∃ σ : Fin B.size → Fin B.size,
    Function.Involutive σ ∧
    (∀ i, (B.modes i).isPhysical = true → (B.modes (σ i)).isPhysical = true) ∧
    (∀ i, (B.modes i).isPhysical = true → σ i ≠ i) ∧
    (∀ i, (B.modes i).isPhysical = true →
      (B.modes (σ i)).multiplicity = (B.modes i).multiplicity) ∧
    (∀ i, (B.modes i).isPhysical = true →
      (B.modes (σ i)).chiralitySign = - (B.modes i).chiralitySign)

/-- The deliberately weak external (C0) health predicate: every physical mode carries
the C0 health flag. This is a toy external-health flag and deliberately does **not**
mention the index. -/
def C0Healthy (B : Spectrum) : Prop :=
  ∀ i, (B.modes i).isPhysical = true → (B.modes i).c0Healthy = true

/-- The C1 discriminator / anti-vectorlike witness: the net index is nonzero.

This is the data that a genuine C1 release predicate must demand *in addition* to C0
health, a regulator, and a modified chirality construction. -/
def AntiVectorlikeWitness (B : Spectrum) : Prop := NetIndex B ≠ 0

/-! ### Core guardrail theorems -/

/-- A vectorlike finite spectrum has zero net index: the chirality-swapping,
multiplicity-preserving, fixed-point-free involution pairs the contributions of `i`
and `σ i` so that they cancel. -/
theorem vectorlike_implies_zero_index (B : Spectrum) (h : VectorlikeSpectrum B) :
    NetIndex B = 0 := by
  obtain ⟨σ, hinv, hphys, hfix, hmul, hsign⟩ := h
  unfold NetIndex
  apply Finset.sum_involution (g := fun i _ => σ i)
  · intro a ha
    have hpa : (B.modes a).isPhysical = true := by simpa [physical] using ha
    rw [hsign a hpa, hmul a hpa]
    ring
  · intro a ha _
    have hpa : (B.modes a).isPhysical = true := by simpa [physical] using ha
    exact hfix a hpa
  · intro a ha
    have hpa : (B.modes a).isPhysical = true := by simpa [physical] using ha
    simp only [physical, Finset.mem_filter, Finset.mem_univ, true_and]
    exact hphys a hpa
  · intro a _
    exact hinv a

/-- The anti-vectorlike witness (nonzero net index) forbids vectorlikeness. -/
theorem nonzero_index_forbids_vectorlike (B : Spectrum)
    (h : AntiVectorlikeWitness B) : ¬ VectorlikeSpectrum B := by
  intro hv
  exact h (vectorlike_implies_zero_index B hv)

/-! ### Concrete finite countermodels and witnesses -/

/-- A concrete C0-healthy **vectorlike** spectrum: one `+1` mode and one `-1` mode,
both physical and healthy, each of multiplicity `1`. -/
def B0 : Spectrum where
  size := 2
  modes := ![⟨1, 1, true, true⟩, ⟨-1, 1, true, true⟩]

/-- A concrete C0-healthy spectrum with a **single** physical `+1` mode of
multiplicity `1`: it is healthy and carries the anti-vectorlike witness. -/
def B1 : Spectrum where
  size := 1
  modes := ![⟨1, 1, true, true⟩]

theorem B0_c0Healthy : C0Healthy B0 := by unfold C0Healthy; decide

theorem B0_vectorlike : VectorlikeSpectrum B0 :=
  ⟨(![1, 0] : Fin 2 → Fin 2), (by intro x; fin_cases x <;> rfl),
    by decide, by decide, by decide, by decide⟩

theorem B1_c0Healthy : C0Healthy B1 := by unfold C0Healthy; decide

theorem B1_netIndex : NetIndex B1 = 1 := by decide

theorem B1_antiVectorlike : AntiVectorlikeWitness B1 := by
  unfold AntiVectorlikeWitness; decide

/-- C0 health does **not** forbid vectorlikeness: there is a concrete finite table
that is C0-healthy and vectorlike. -/
theorem c0_health_does_not_forbid_vectorlike :
    ∃ B, C0Healthy B ∧ VectorlikeSpectrum B :=
  ⟨B0, B0_c0Healthy, B0_vectorlike⟩

/-- A discriminating example: a concrete finite table that is C0-healthy and carries
the anti-vectorlike witness (nonzero index). -/
theorem exists_c0_healthy_antivectorlike :
    ∃ B, C0Healthy B ∧ AntiVectorlikeWitness B :=
  ⟨B1, B1_c0Healthy, B1_antiVectorlike⟩

/-- The clean same-C0-health comparison guardrail: there exist two C0-healthy finite
spectra, one vectorlike and one carrying the anti-vectorlike witness. Hence C0 health
is compatible with both, so C0 health cannot decide C1 release. -/
theorem c0_cannot_decide_c1 :
    ∃ Bv Bw, C0Healthy Bv ∧ C0Healthy Bw ∧
      VectorlikeSpectrum Bv ∧ AntiVectorlikeWitness Bw :=
  ⟨B0, B1, B0_c0Healthy, B1_c0Healthy, B0_vectorlike, B1_antiVectorlike⟩

end PhysicsSM.Draft.NullEdgeAntiVectorializationGuardrail
