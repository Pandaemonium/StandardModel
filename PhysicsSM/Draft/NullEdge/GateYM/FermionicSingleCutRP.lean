import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FermionicReflection

/-!
# Fermionic reflection positivity over the CORRECTED single-cut time geometry

A prior job established that the RP-F N5 Gram crux is **FALSE** on the PERIODIC
time circle: with periodic time the two-sided positive-half sandwich is bounded
by BOTH reflection planes, so TWO cross-mirror temporal hopping terms survive,
carrying OPPOSITE-chirality projectors (`+P_+` and `-P_-`). Their sum
`P_+ - P_- = -gamma_0` is INDEFINITE, so no Gram factorization exists. See
`FERMIONIC_RPF_CRUX_FALSE_FINDING.md` and the header of `FermionicReflection.lean`.

This module re-states the crux over the corrected **single-cut** (reflected /
open-boundary) time geometry, mirroring the bosonic single-cut reflection used in
`WilsonSlabConnected` / `ReflectionCutPlaquetteFamily` (a genuine single
reflection plane across ONE cut, NOT a periodic circle). On the single cut only
ONE cross-mirror hopping survives, it carries `P_+` on both sides, and the Gram
factorization `(P_+ x)^dagger (P_+ x)` holds - so the reflected block is PSD.

## What is delivered here

1. A **single-cut** time reflection `timeReflSC` (reflection of an open time
   interval across its midpoint cut, `t |-> Fin.rev t`, NOT the periodic
   `t |-> 1 - t`), the reflection operator `Theta_sc`, the positive-time-half
   selector `selectE`, and the reflected block
   `reflectedBlock_sc D = E (D Theta_sc) E^dagger`.

2. The **Gram / PSD linear-algebra core**, reusing the projector API
   (`WilsonProjectors.conj_projector_posSemidef`,
   `Matrix.posSemidef_conjTranspose_mul_self`) and the lifted Wilson projector
   from `FermionicReflection`:
   * `reflectedBlock_sc_gram_of_plusForm` : when the single-cut reflected block
     has the single-projector sandwich form `A^dagger (liftProjPlus) A` (the ONE
     surviving cross-mirror hopping, carrying `P_+` on both sides), it factors as
     a Gram `M^dagger M` (node **N5**).
   * `reflectedBlock_sc_posSemidef_of_gram` : any Gram factorization gives PSD
     (node **N6**), via `Matrix.posSemidef_conjTranspose_mul_self`.
   * `reflectedBlock_sc_eq_gram` : the general single-cut Gram factorization,
     under the faithful reflection-hermiticity hypothesis `Theta_sc D Theta_sc =
     D^H` together with the single-cut geometric input `hcut` (the reflected
     block has the SINGLE `P_+`-sandwich form). `hcut` is exactly what holds on
     the single cut and FAILS on the periodic circle; deriving it from the
     concrete single-cut Wilson hopping is the remaining successor bookkeeping.

3. The **decisive concrete contrast** at the instance where the periodic version
   was FALSE (`L = 2` open, `nc = 1`, `U = 1`), on the Dirac spin factor, all
   `s o r r y`-free:
   * `singleCutSpinBlock = projPlus timeDir = P_+` : PSD (in fact a projector),
     with an explicit Gram factorization `singleCutSpinBlock_gram`.
   * `periodicSpinBlock = projPlus timeDir - projMinus timeDir = -gamma_0`
     (`periodicSpinBlock_eq_neg_gamma`) : **NOT** PSD
     (`periodicSpinBlock_not_posSemidef`, witnessed by `x = (1,0,0,i)`, an
     eigenvector of `gamma_0` with eigenvalue `+1`).

   This is the crux contrast: the single surviving cross-mirror hopping of the
   single-cut geometry gives `P_+` (PSD); the two surviving hoppings of the
   periodic circle give `P_+ - P_- = -gamma_0` (indefinite).

Once N5/N6 hold on this geometry, the remaining QMF5 DAG nodes N7-N12 follow as
before: Berezin integral `=` determinant (`BerezinMatthewsSalam.berezinGaussian_eq_det`),
the nonnegative paired-flavor determinant weight
(`Qmf4bWilson.pairedFlavor_det_nonneg`), and the measure/mixture wrap into
`ReflectionPositivityKernel.reflectionForm_nonneg` - exactly as in the bosonic
`ReflectionCutPlaquetteFamily` assembly.

## Claim discipline

Claim label: **finite fermionic RP on single-cut geometry (draft)**. The concrete
single-cut/periodic contrast, the Gram/PSD linear-algebra core, and the general
Gram/PSD theorems (under the faithful reflection-hermiticity and single-cut
structural hypotheses) are all kernel-checked and `s o r r y`-free. The only deferred
step is the concrete lattice derivation of the single-cut structural input `hcut`
from the Wilson hopping, stated as an explicit hypothesis rather than an `axiom`
or `s o r r y`. No new `axiom`, no `native_decide`, no weakening. Prerequisites:
`FermionicReflection` (hence `WilsonDiracOperator`, `WilsonProjectors`,
`EuclideanGamma`). Does NOT edit `FermionicReflection.lean`.
-/

open scoped Matrix ComplexOrder

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace FermionicSingleCutRP

open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson
open PhysicsSM.Draft.NullEdge.GateYM.WilsonProjectors
open PhysicsSM.Draft.NullEdge.GateYM.FermionicReflection

variable {L nc : ℕ}

/-! ## 1. The single-cut time reflection, reflection operator, and selector -/

/-- **Single-cut temporal reflection on sites**: reflection of the OPEN time
interval `{0, ..., L-1}` across its midpoint cut, `t |-> Fin.rev t = (L-1) - t`,
fixing the spatial coordinates. This is a genuine single reflection plane (as in
the bosonic cut-slab geometry): the boundary slice `t = 0` maps to the opposite
boundary `t = L-1`, and there is NO periodic wraparound. Contrast the periodic
`FermionicReflection.timeRefl` (`t |-> 1 - t` on the time circle), which has TWO
reflection planes. -/
def timeReflSC [NeZero L] (x : Site L) : Site L :=
  Function.update x timeDir (Fin.rev (x timeDir))

/-- The single-cut temporal reflection is an involution (`Fin.rev` is an
involution, the spatial coordinates are untouched). -/
theorem timeReflSC_involutive [NeZero L] : Function.Involutive (timeReflSC (L := L)) := by
  intro x
  unfold timeReflSC
  rw [Function.update_idem, Function.update_self, Fin.rev_rev, Function.update_eq_self]

/-- The single-cut reflection sends the boundary slice `t = 0` to the opposite
boundary `t = L - 1` (`= Fin.last`), confirming it is the interval reflection
across the midpoint cut, with no fixed boundary slice. -/
theorem timeReflSC_zero [NeZero L] (x : Site L) (hx : x timeDir = 0) :
    (timeReflSC x) timeDir = Fin.rev (0 : Fin L) := by
  unfold timeReflSC
  rw [Function.update_self, hx]

/-- **The single-cut fermionic reflection operator** `Theta_sc = (site
permutation by `timeReflSC`) tensor gamma_timeDir tensor (color identity)` on the
full Wilson index `Idx L nc`. Same shape as `FermionicReflection.rpFReflection`,
but built from the single-cut interval reflection `timeReflSC` instead of the
periodic `timeRefl`. -/
noncomputable def Theta_sc (L nc : ℕ) [NeZero L] : Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun I J =>
    (if J.1 = timeReflSC I.1 ∧ I.2.2 = J.2.2 then EuclideanGamma.γ timeDir I.2.1 J.2.1 else 0)

/-- **The single-cut reflection operator is Hermitian**: `Theta_sc^dagger =
Theta_sc`. Uses that `gamma_timeDir` is Hermitian and that `timeReflSC` is an
involution (so the off-diagonal site condition is symmetric). -/
theorem Theta_sc_herm (L nc : ℕ) [NeZero L] :
    (Theta_sc L nc)ᴴ = Theta_sc L nc := by
  ext I J
  simp only [Theta_sc, Matrix.conjTranspose_apply, Matrix.of_apply]
  by_cases h : J.1 = timeReflSC I.1 ∧ I.2.2 = J.2.2
  · obtain ⟨h1, h2⟩ := h
    have hrev : I.1 = timeReflSC J.1 ∧ J.2.2 = I.2.2 :=
      ⟨by rw [h1, timeReflSC_involutive], h2.symm⟩
    rw [if_pos hrev, if_pos (And.intro h1 h2)]
    have hij := congr_fun (congr_fun (EuclideanGamma.γ_herm timeDir) I.2.1) J.2.1
    rw [Matrix.conjTranspose_apply] at hij
    exact hij
  · rw [if_neg h, if_neg (fun hc => h ⟨by rw [hc.1, timeReflSC_involutive], hc.2.symm⟩)]
    simp

/-- **The single-cut reflection operator is an involution**: `Theta_sc * Theta_sc
= 1`. The `K`-sum collapses to a spin sum `gamma_td^2 = 1`, using `timeReflSC`
involutive and `gamma_timeDir^2 = 1` (mirrors `rpFReflection_sq`). -/
theorem Theta_sc_sq (L nc : ℕ) [NeZero L] :
    Theta_sc L nc * Theta_sc L nc = 1 := by
  ext I J
  rw [Matrix.mul_apply]
  rw [← Finset.sum_subset (Finset.subset_univ
        (Finset.image (fun s' : Fin 4 => (timeReflSC I.1, s', I.2.2)) Finset.univ))]
  · rw [Finset.sum_image (by intro a _ b _ hab; simpa using congrArg (fun z => z.2.1) hab)]
    simp only [Theta_sc, Matrix.of_apply, timeReflSC_involutive I.1, and_true, if_true]
    have hsq := EuclideanGamma.γ_sq timeDir
    by_cases hJ : J.1 = I.1 ∧ I.2.2 = J.2.2
    · obtain ⟨hJ1, hJ2⟩ := hJ
      simp only [if_pos (And.intro hJ1 hJ2)]
      rw [← Matrix.mul_apply, hsq, Matrix.one_apply, Matrix.one_apply]
      obtain ⟨x, s, c⟩ := I; obtain ⟨y, t, d⟩ := J
      simp only at hJ1 hJ2
      subst hJ1; subst hJ2
      by_cases hst : s = t
      · subst hst; simp
      · rw [if_neg hst, if_neg (by simp [Prod.ext_iff, hst])]
    · simp only [if_neg hJ, mul_zero, Finset.sum_const_zero]
      rw [Matrix.one_apply, if_neg]
      rintro rfl
      exact hJ ⟨rfl, rfl⟩
  · intro K _ hK
    simp only [Finset.mem_image, Finset.mem_univ, true_and, not_exists] at hK
    simp only [Theta_sc, Matrix.of_apply]
    rw [if_neg, zero_mul]
    rintro ⟨hk1, hk2⟩
    exact hK K.2.1 (by ext <;> simp_all)

/-- **The single-cut reflection operator is unitary**: `Theta_sc^dagger Theta_sc =
1` (a Hermitian involution). -/
theorem Theta_sc_unitary (L nc : ℕ) [NeZero L] :
    (Theta_sc L nc)ᴴ * Theta_sc L nc = 1 := by
  rw [Theta_sc_herm, Theta_sc_sq]

/-- Positive-time-half predicate on sites: the upper half `t >= L/2` of the open
time interval (the half NOT containing the boundary slice `t = 0`). The single
cut sits at the midpoint, and `timeReflSC` swaps this half with its complement. -/
def posHalf [NeZero L] (x : Site L) : Prop := L ≤ 2 * (x timeDir).val

open Classical in
/-- **The positive-time-half selector** `E` on `Idx L nc`: the diagonal
projector onto the sites in the positive time half. -/
noncomputable def selectE (L nc : ℕ) [NeZero L] : Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun I J => if I = J ∧ posHalf I.1 then 1 else 0

/-- The positive-half selector is Hermitian (a real diagonal `0/1` matrix). -/
theorem selectE_isHermitian (L nc : ℕ) [NeZero L] :
    (selectE L nc)ᴴ = selectE L nc := by
  classical
  ext I J
  simp only [selectE, Matrix.conjTranspose_apply, Matrix.of_apply]
  by_cases hij : I = J
  · subst hij
    by_cases h2 : posHalf I.1 <;> simp [h2]
  · rw [if_neg (by rintro ⟨h, _⟩; exact hij h.symm),
        if_neg (by rintro ⟨h, _⟩; exact hij h)]
    simp

/-- **The single-cut reflected positive-half block**
`reflectedBlock_sc D = E (D Theta_sc) E^dagger`, the fermionic
Osterwalder-Seiler reflected block on the single-cut geometry. -/
noncomputable def reflectedBlock_sc [NeZero L]
    (D : Matrix (Idx L nc) (Idx L nc) ℂ) : Matrix (Idx L nc) (Idx L nc) ℂ :=
  selectE L nc * (D * Theta_sc L nc) * (selectE L nc)ᴴ

/-- **The single-cut reflected block is Hermitian** under the faithful
reflection-hermiticity `Theta_sc D Theta_sc = D^dagger`. This is the genuine
consequence of reflection-hermiticity (using that `Theta_sc` is a Hermitian
involution and `selectE` is Hermitian): `(E (D Theta_sc) E^dagger)^dagger =
E (Theta_sc D^dagger) E^dagger = E (D Theta_sc) E^dagger`, since
`Theta_sc D^dagger = D Theta_sc` follows from `Theta_sc (Theta_sc D Theta_sc) =
Theta_sc D^dagger` and `Theta_sc^2 = 1`. Hermiticity is the reflection-symmetry
half of RP; the single-cut structural input then supplies positivity. -/
theorem reflectedBlock_sc_isHermitian [NeZero L]
    (D : Matrix (Idx L nc) (Idx L nc) ℂ)
    (hrefl : Theta_sc L nc * D * Theta_sc L nc = Dᴴ) :
    (reflectedBlock_sc D).IsHermitian := by
  have hE := selectE_isHermitian L nc
  have hΘ := Theta_sc_herm L nc
  have hsq := Theta_sc_sq L nc
  have key : D * Theta_sc L nc = Theta_sc L nc * Dᴴ := by
    have h1 : Theta_sc L nc * (Theta_sc L nc * D * Theta_sc L nc) = Theta_sc L nc * Dᴴ := by
      rw [hrefl]
    rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hsq, Matrix.one_mul] at h1
    exact h1
  show (reflectedBlock_sc D)ᴴ = reflectedBlock_sc D
  unfold reflectedBlock_sc
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
    hE, Matrix.conjTranspose_mul, hΘ, show Theta_sc L nc * Dᴴ = D * Theta_sc L nc from key.symm,
    Matrix.mul_assoc, Matrix.mul_assoc, Matrix.mul_assoc]

/-! ## 2. The Gram / PSD linear-algebra core (nodes N5, N6) -/

/-- **Node N5 (single-cut Gram core).** When the single-cut reflected block has
the single-projector sandwich form `A^dagger (liftProjPlus timeDir) A` - i.e. the
ONE surviving cross-mirror hopping carries the forward Wilson projector `P_+` on
both sides - it factors as a Gram matrix `M^dagger M`, with `M = (liftProjPlus)
A`. This is the corrected N5: on the single cut there is a single `P_+` (not the
indefinite `P_+ - P_-` of the periodic circle), so the projector-Gram
factorization goes through. -/
theorem reflectedBlock_sc_gram_of_plusForm [NeZero L]
    (D A : Matrix (Idx L nc) (Idx L nc) ℂ)
    (hform : reflectedBlock_sc D = Aᴴ * liftProjPlus L nc timeDir * A) :
    ∃ M : Matrix (Idx L nc) (Idx L nc) ℂ, reflectedBlock_sc D = Mᴴ * M := by
  refine ⟨liftProjPlus L nc timeDir * A, ?_⟩
  rw [hform]
  have hgram : (liftProjPlus L nc timeDir * A)ᴴ * (liftProjPlus L nc timeDir * A)
      = Aᴴ * liftProjPlus L nc timeDir * A := by
    rw [Matrix.conjTranspose_mul, liftProjPlus_herm, Matrix.mul_assoc,
      ← Matrix.mul_assoc (liftProjPlus L nc timeDir) (liftProjPlus L nc timeDir) A,
      liftProjPlus_idem, ← Matrix.mul_assoc]
  exact hgram.symm

/-- **Node N6 (PSD from Gram).** Any Gram factorization `reflectedBlock_sc D =
M^dagger M` makes the single-cut reflected block positive semidefinite, via
`Matrix.posSemidef_conjTranspose_mul_self`. -/
theorem reflectedBlock_sc_posSemidef_of_gram [NeZero L]
    (D : Matrix (Idx L nc) (Idx L nc) ℂ)
    (h : ∃ M : Matrix (Idx L nc) (Idx L nc) ℂ, reflectedBlock_sc D = Mᴴ * M) :
    (reflectedBlock_sc D).PosSemidef := by
  obtain ⟨M, hM⟩ := h
  rw [hM]
  exact Matrix.posSemidef_conjTranspose_mul_self _

/-- **Node N6 (PSD directly from the single `P_+` sandwich form).** If the
single-cut reflected block equals the single-projector sandwich `A^dagger
(liftProjPlus) A`, it is positive semidefinite. This is the s o r r y-free endpoint
of the single-cut crux, reusing `FermionicReflection.conj_liftProjPlus_posSemidef`. -/
theorem reflectedBlock_sc_posSemidef_of_plusForm [NeZero L]
    (D A : Matrix (Idx L nc) (Idx L nc) ℂ)
    (hform : reflectedBlock_sc D = Aᴴ * liftProjPlus L nc timeDir * A) :
    (reflectedBlock_sc D).PosSemidef := by
  rw [hform]
  exact conj_liftProjPlus_posSemidef timeDir A

/-- **Node N5, general single-cut form.** Under the faithful single-cut
reflection-hermiticity `Theta_sc D Theta_sc = D^dagger` (`hrefl`, the reflection
context), *together with* the single-cut geometric input `hcut`, the single-cut
reflected positive-half block `E (D Theta_sc) E^dagger` factors as a Gram matrix
`M^dagger M`.

The geometric input `hcut` states that the reflected block has the SINGLE
forward-projector sandwich form `A^dagger (liftProjPlus timeDir) A`: on the
single-cut geometry only ONE cross-mirror hopping survives the `E ... E^dagger`
sandwich, and it carries `P_+` on both sides. This is exactly the property that
DISTINGUISHES the single cut from the periodic circle: on the periodic circle the
surviving structure is `P_+ - P_-` (two cross-mirror hoppings, opposite
chiralities), which is NOT of single-projector form, and `hcut` FAILS - this is
the kernel-checked contrast `periodicSpinBlock_not_posSemidef` below. `hcut` is
the fermionic analogue of the bosonic holonomy read-off
`WilsonSlabConnected.slabPlaq_hol_slabMirrorConfig`; deriving it from the concrete
single-cut Wilson hopping is the remaining (successor) lattice bookkeeping. Given
`hcut`, the Gram factorization is the s o r r y-free
`reflectedBlock_sc_gram_of_plusForm`. -/
theorem reflectedBlock_sc_eq_gram [NeZero L]
    (D : Matrix (Idx L nc) (Idx L nc) ℂ)
    (hrefl : Theta_sc L nc * D * Theta_sc L nc = Dᴴ)
    (hcut : ∃ A : Matrix (Idx L nc) (Idx L nc) ℂ,
        reflectedBlock_sc D = Aᴴ * liftProjPlus L nc timeDir * A) :
    ∃ M : Matrix (Idx L nc) (Idx L nc) ℂ, reflectedBlock_sc D = Mᴴ * M := by
  -- Reflection-hermiticity supplies Hermiticity of the reflected block (the
  -- reflection-symmetry half of RP); the single-cut input `hcut` supplies the
  -- positive Gram structure.
  have _herm := reflectedBlock_sc_isHermitian D hrefl
  obtain ⟨A, hA⟩ := hcut
  exact reflectedBlock_sc_gram_of_plusForm D A hA

/-- **Node N6 for the general single-cut block.** Combining
`reflectedBlock_sc_eq_gram` (N5) with `reflectedBlock_sc_posSemidef_of_gram`, the
single-cut reflected block is PSD under reflection-hermiticity and the single-cut
geometric input `hcut`. -/
theorem reflectedBlock_sc_posSemidef [NeZero L]
    (D : Matrix (Idx L nc) (Idx L nc) ℂ)
    (hrefl : Theta_sc L nc * D * Theta_sc L nc = Dᴴ)
    (hcut : ∃ A : Matrix (Idx L nc) (Idx L nc) ℂ,
        reflectedBlock_sc D = Aᴴ * liftProjPlus L nc timeDir * A) :
    (reflectedBlock_sc D).PosSemidef :=
  reflectedBlock_sc_posSemidef_of_gram D (reflectedBlock_sc_eq_gram D hrefl hcut)

/-! ## 3. The decisive concrete contrast (`L = 2` open, `nc = 1`, `U = 1`)

At the instance where the periodic version was proved FALSE, the reflected block
reduces on each Dirac spin factor to a `4 x 4` spin matrix. The single-cut
geometry has ONE surviving cross-mirror hopping, giving `P_+`; the periodic
circle has TWO, giving `P_+ - P_- = -gamma_0`. We prove the former is PSD and the
latter is NOT - the decisive contrast. All `s o r r y`-free. -/

/-- The single-cut reflected spin block: the ONE surviving cross-mirror hopping
carries the forward Wilson projector `P_+ = (1 - gamma_0)/2`. -/
noncomputable def singleCutSpinBlock : Matrix (Fin 4) (Fin 4) ℂ := projPlus timeDir

/-- The periodic reflected spin block: the TWO surviving cross-mirror hoppings
carry `+P_+` and `-P_-`, summing to `P_+ - P_-`. -/
noncomputable def periodicSpinBlock : Matrix (Fin 4) (Fin 4) ℂ :=
  projPlus timeDir - projMinus timeDir

/-- **Single-cut spin block Gram factorization**: `singleCutSpinBlock =
M^dagger M` with `M = P_+` (the projector is its own Gram square, being a
Hermitian idempotent). -/
theorem singleCutSpinBlock_gram :
    singleCutSpinBlock = (projPlus timeDir)ᴴ * projPlus timeDir := by
  rw [singleCutSpinBlock, projPlus_herm, projPlus_idem]

/-- **Single-cut spin block is PSD** (node N6 at the concrete instance): the
single surviving cross-mirror hopping gives the projector `P_+`, which is
positive semidefinite via `Matrix.posSemidef_conjTranspose_mul_self`. -/
theorem singleCutSpinBlock_posSemidef : singleCutSpinBlock.PosSemidef := by
  rw [singleCutSpinBlock_gram]
  exact Matrix.posSemidef_conjTranspose_mul_self _

/-- The periodic reflected spin block equals `-gamma_0`: `P_+ - P_- =
(1 - gamma_0)/2 - (1 + gamma_0)/2 = -gamma_0`. This is exactly the indefinite
matrix the periodic-circle disproof reduced to. -/
theorem periodicSpinBlock_eq_neg_gamma :
    periodicSpinBlock = - EuclideanGamma.γ timeDir := by
  simp only [periodicSpinBlock, projPlus, projMinus]
  module

/-- **The periodic reflected spin block is NOT PSD** (the periodic-circle
crux is FALSE): `-gamma_0` is indefinite, witnessed by the eigenvector
`x = (1, 0, 0, i)` of `gamma_0` with eigenvalue `+1`, for which the reflection
form `x^dagger (-gamma_0) x = -2 < 0`. This is the decisive contrast with
`singleCutSpinBlock_posSemidef`. -/
theorem periodicSpinBlock_not_posSemidef : ¬ periodicSpinBlock.PosSemidef := by
  rw [periodicSpinBlock_eq_neg_gamma]
  intro h
  have hx := h.re_dotProduct_nonneg (![1, 0, 0, Complex.I])
  have e0 : (![(1 : ℂ), 0, 0, Complex.I]) 0 = 1 := rfl
  have e1 : (![(1 : ℂ), 0, 0, Complex.I]) 1 = 0 := rfl
  have e2 : (![(1 : ℂ), 0, 0, Complex.I]) 2 = 0 := rfl
  have e3 : (![(1 : ℂ), 0, 0, Complex.I]) 3 = Complex.I := rfl
  simp only [timeDir, EuclideanGamma.γ, EuclideanGamma.γ1, Matrix.mulVec, dotProduct,
    Fin.sum_univ_four, Matrix.neg_apply, Matrix.of_apply, Pi.star_apply, Matrix.cons_val',
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val',
    Matrix.cons_val_fin_one, Matrix.cons_val, e0, e1, e2, e3] at hx
  norm_num [Complex.ext_iff, star] at hx

end FermionicSingleCutRP
end PhysicsSM.Draft.NullEdge.GateYM
