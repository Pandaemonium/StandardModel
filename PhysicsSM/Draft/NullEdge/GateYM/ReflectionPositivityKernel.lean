import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.HermitianFromRealQuadraticForm

/-!
# Gate YM3: the master finite reflection-positivity kernel lemma (RP-KER)

RP-LINK - Osterwalder-Seiler reflection positivity for the Wilson lattice
ensemble - has been blocked on its "assembly" layer: cut factorization,
positive-side observable algebra, and the PSD argument. This module proves
the ASSEMBLY THEOREM abstractly, reducing all of RP-LINK to a single
checkable condition:

> the reflected weight kernel, at each fixed configuration of the cut
> links, is a positive-semidefinite matrix in the (positive side) x
> (mirrored negative side) indices.

## Mirror-coordinate convention (read before instantiating)

Configurations are triples `(a, c, b) : A x C x A`:

- `A` = configurations of the POSITIVE-side links;
- `C` = configurations of the CUT links (fixed by the reflection);
- the third coordinate `b : A` parametrizes the NEGATIVE-side links BY
  THEIR MIRROR IMAGES: the geometric negative-side configuration is
  `theta(b)`. The antilinear time-reflection is built into the form below
  (`starRingEnd` on the `b` slot). Producing this parametrization from the
  geometric `Reflection` structure (link classification, involution) is the
  INSTANTIATOR's job, using the existing T3 stack (`ReflectionCore`,
  `ReflectionEnsemble`, `WilsonReflectionCompatibility`).

With that convention, the Osterwalder-Seiler functional
`<(Theta F) F> = sum_config weight * conj(F(negative side)) * F(positive side)`
for a positive-side observable `F(a, c, b) = f(a, c)` is exactly
`reflectionForm W f` below.

## What is proved

- `reflectionForm_nonneg` (**the master lemma**): if every cut kernel
  `cutKernel W c` is `Matrix.PosSemidef`, then `0 <= reflectionForm W f`
  for EVERY positive-side observable `f` - reflection positivity, in the
  complex `StarOrderedRing` order (nonnegative real, zero imaginary part).
- `cutKernel_posSemidef_of_factorized`: weights that factorize across the
  cut (`W a c b = h a c * conj (h b c)`, the no-cut-plaquette case: the
  negative-side weight is the mirror conjugate of the positive-side weight)
  have PSD cut kernels - the classic Gram square.
- `cutKernel_posSemidef_of_mixture`: nonnegative-mixture weights
  (`W a c b = sum_k h k a c * conj (h k b c)`) have PSD cut kernels. This
  is the form the Wilson CUT-PLAQUETTE couplings take after a spectral
  decomposition of the one-plaquette kernel: any PSD coupling kernel is
  such a finite mixture, so cut plaquettes are covered IN PRINCIPLE by this
  corollary plus `WilsonWeightPositivity.wilsonKernel_posSemidef` and
  Schur products (`hadamard_posSemidef`) - that assembly is the remaining
  RP-LINK work, now a kernel-algebra exercise (see the program document
  work queue).
- `cutKernel_mul`: cut kernels turn pointwise products of weights into
  Hadamard products of cut kernels. This is the small connector needed to
  assemble several cut-plaquette coupling kernels before applying Schur
  product positivity.
- `complex_hadamard_posSemidef` and `cutKernel_mul_posSemidef`: complex
  Schur-product closure for cut kernels, and the corresponding product-
  weight PSD corollary.
- `cutKernel_finset_prod_posSemidef`: the finite-product version, intended
  for the product over all cut-plaquette coupling factors once each factor
  has been identified as a PSD cut kernel.
- `reflectionForm_nonneg_of_factorized` / `_of_mixture`: the end-to-end RP
  statements for those two weight classes.
- `cutKernel_posSemidef_of_reflectionPositive` (**the Q2 bridge, converse
  of `reflectionForm_nonneg`**): `IsReflectionPositive W` ALONE (no
  separate symmetry assumption) forces every `cutKernel W c` to be
  `Matrix.PosSemidef`. This is the missing direction needed for the
  transfer-Hilbert-space construction (program document Q2): a reflection-
  positive ensemble weight yields a genuine PSD kernel to build the
  physical Hilbert space from, without having to separately verify
  Hermitian-ness. Provenance: `HermitianFromRealQuadraticForm.lean`
  (Aristotle project `72cccd22`, see that module's docstring).

## What is NOT claimed

No lattice geometry is touched here: no claim that the Wilson weight on a
given reflection lattice HAS the factorized/mixture form (that is the
geometric bookkeeping + kernel-PSD assembly queued for the T3 lane), and no
Hilbert-space reconstruction, transfer operator, or gap statement. Krein
caveat from the standing conventions applies: RP is an algebraic
positivity statement; physical-Hilbert-space interpretation is a separate
layer.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites: Mathlib only
(deliberately - so this module can also ship inside focused Aristotle
packages).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionPositivityKernel

open scoped BigOperators ComplexOrder Kronecker Matrix

variable {A C : Type} [Fintype A] [Fintype C]

/-- The Osterwalder-Seiler reflection form in mirror coordinates: the
weighted pairing of a positive-side observable with its time-reflection.
`W a c b` is the total ensemble weight of the configuration with positive
side `a`, cut `c`, and negative side the mirror image of `b`; the
`starRingEnd` on the `b` slot is the antilinearity of the reflection. -/
def reflectionForm (W : A → C → A → ℂ) (f : A → C → ℂ) : ℂ :=
  ∑ c : C, ∑ b : A, ∑ a : A,
    (starRingEnd ℂ) (f b c) * W a c b * f a c

/-- The reflected weight kernel at a fixed cut configuration: the matrix
pairing the mirrored negative side (row) with the positive side (column). -/
def cutKernel (W : A → C → A → ℂ) (c : C) : Matrix A A ℂ :=
  Matrix.of fun b a => W a c b

omit [Fintype A] [Fintype C] in
/-- Cut kernels send pointwise products of reflected weights to Hadamard
products of cut kernels. This is the bookkeeping connector for assembling
several independent cut-plaquette coupling kernels before a Schur-product
PSD argument. -/
theorem cutKernel_mul (W1 W2 : A → C → A → ℂ) (c : C) :
    cutKernel (fun a c' b => W1 a c' b * W2 a c' b) c =
      cutKernel W1 c ⊙ cutKernel W2 c := by
  ext b a
  simp [cutKernel, Matrix.hadamard_apply]

set_option linter.unusedFintypeInType false in
/-- Complex Schur product theorem: the Hadamard product of two complex PSD
matrices is PSD. This is the cut-kernel version of the real Schur product
lemma in `WilsonWeightPositivity`, proved directly from Mathlib's
Kronecker-product PSD theorem and submatrix closure. -/
theorem complex_hadamard_posSemidef {ι : Type*} [Fintype ι]
    {M N : Matrix ι ι ℂ} (hM : M.PosSemidef) (hN : N.PosSemidef) :
    (M ⊙ N).PosSemidef := by
  have hK : (M ⊗ₖ N).PosSemidef := hM.kronecker hN
  have hSub := hK.submatrix (fun i : ι => (i, i))
  have hEq :
      (M ⊗ₖ N).submatrix (fun i : ι => (i, i)) (fun i : ι => (i, i)) =
        M ⊙ N := by
    ext i j
    simp [Matrix.submatrix_apply, Matrix.kroneckerMap_apply, Matrix.hadamard_apply]
  rwa [hEq] at hSub

omit [Fintype C] in
set_option linter.unusedFintypeInType false in
/-- Product-weight PSD closure for cut kernels. If two reflected weights
have PSD cut kernels at every cut configuration, then their pointwise
product also has PSD cut kernels. -/
theorem cutKernel_mul_posSemidef (W1 W2 : A → C → A → ℂ)
    (hW1 : ∀ c : C, (cutKernel W1 c).PosSemidef)
    (hW2 : ∀ c : C, (cutKernel W2 c).PosSemidef) (c : C) :
    (cutKernel (fun a c' b => W1 a c' b * W2 a c' b) c).PosSemidef := by
  rw [cutKernel_mul]
  exact complex_hadamard_posSemidef (hW1 c) (hW2 c)

/-- Reflection positivity of a weight in mirror coordinates: the reflection
form is nonnegative on every positive-side observable. -/
def IsReflectionPositive (W : A → C → A → ℂ) : Prop :=
  ∀ f : A → C → ℂ, 0 ≤ reflectionForm W f

/-- The reflection form at one cut configuration is the PSD quadratic form
of the cut kernel. -/
lemma reflectionForm_eq_sum_dotProduct (W : A → C → A → ℂ) (f : A → C → ℂ) :
    reflectionForm W f
      = ∑ c : C, star (fun a => f a c) ⬝ᵥ (cutKernel W c *ᵥ fun a => f a c) := by
  refine Finset.sum_congr rfl ?_
  intro c _hc
  simp only [dotProduct, Matrix.mulVec, cutKernel, Matrix.of_apply,
    Pi.star_apply, starRingEnd_apply, Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro b _hb
  refine Finset.sum_congr rfl ?_
  intro a _ha
  ring

/-- **Master finite reflection-positivity lemma (RP-KER).** If the
reflected weight kernel is positive semidefinite at every cut
configuration, the ensemble is reflection positive: the
Osterwalder-Seiler form is nonnegative on all positive-side observables.

This reduces RP-LINK to a kernel-PSD check, the language of the existing
Route B engine (`WilsonWeightPositivity`). -/
theorem reflectionForm_nonneg (W : A → C → A → ℂ)
    (hK : ∀ c : C, (cutKernel W c).PosSemidef) :
    IsReflectionPositive W := by
  intro f
  rw [reflectionForm_eq_sum_dotProduct]
  refine Finset.sum_nonneg ?_
  intro c _hc
  exact (hK c).dotProduct_mulVec_nonneg (fun a => f a c)

omit [Fintype C] in
/-- Factorized weights have PSD cut kernels: if the total weight splits as
(positive-side factor) x (mirror conjugate factor) - the no-cut-plaquette
situation - the cut kernel is a rank-one Gram square. -/
theorem cutKernel_posSemidef_of_factorized (h : A → C → ℂ) (c : C) :
    (cutKernel (fun a c' b => h a c' * (starRingEnd ℂ) (h b c')) c).PosSemidef := by
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
  · ext b a
    simp only [cutKernel, Matrix.conjTranspose_apply, Matrix.of_apply,
      starRingEnd_apply, star_mul', star_star]
    ring
  · intro x
    have hform : star x ⬝ᵥ
        ((cutKernel (fun a c' b => h a c' * (starRingEnd ℂ) (h b c')) c) *ᵥ x)
          = star (∑ b : A, h b c * x b) * ∑ a : A, h a c * x a := by
      rw [star_sum, Finset.sum_mul_sum]
      simp only [dotProduct, Matrix.mulVec, cutKernel, Matrix.of_apply,
        Pi.star_apply, starRingEnd_apply, Finset.mul_sum]
      refine Finset.sum_congr rfl ?_
      intro b _hb
      refine Finset.sum_congr rfl ?_
      intro a _ha
      rw [star_mul']
      ring
    rw [hform]
    exact star_mul_self_nonneg _

omit [Fintype C] in
set_option linter.unusedFintypeInType false in
/-- Finite-product PSD closure for cut kernels. If every factor indexed by
`s` has PSD cut kernels at every cut configuration, then the pointwise
product over `s` also has PSD cut kernels. The empty product is the
rank-one factorized constant-one kernel. -/
theorem cutKernel_finset_prod_posSemidef {K : Type} (s : Finset K)
    (W : K → A → C → A → ℂ)
    (hW : ∀ k, k ∈ s → ∀ c : C, (cutKernel (W k) c).PosSemidef) (c : C) :
    (cutKernel (fun a c' b => ∏ k ∈ s, W k a c' b) c).PosSemidef := by
  classical
  revert hW c
  induction s using Finset.induction_on with
  | empty =>
      intro _hW c
      simpa using cutKernel_posSemidef_of_factorized (fun _ _ => (1 : ℂ)) c
  | insert k s hk ih =>
      intro hW c
      have hkPSD : ∀ c : C, (cutKernel (W k) c).PosSemidef :=
        hW k (Finset.mem_insert_self k s)
      have hsPSD :
          ∀ c : C, (cutKernel (fun a c' b => ∏ j ∈ s, W j a c' b) c).PosSemidef := by
        intro c'
        exact ih (fun j hj => hW j (Finset.mem_insert_of_mem hj)) c'
      have hmul := cutKernel_mul_posSemidef (W k)
        (fun a c' b => ∏ j ∈ s, W j a c' b) hkPSD hsPSD c
      simpa [Finset.prod_insert hk] using hmul

omit [Fintype C] in
/-- Nonnegative mixtures of factorized weights have PSD cut kernels. Any
PSD cross-cut coupling is such a mixture (spectral decomposition), so this
is the general form the Wilson cut-plaquette layer reduces to. -/
theorem cutKernel_posSemidef_of_mixture {K : Type} [Fintype K]
    (h : K → A → C → ℂ) (c : C) :
    (cutKernel (fun a c' b => ∑ k : K, h k a c' * (starRingEnd ℂ) (h k b c'))
      c).PosSemidef := by
  have hsplit : cutKernel
      (fun a c' b => ∑ k : K, h k a c' * (starRingEnd ℂ) (h k b c')) c
        = ∑ k : K, cutKernel
            (fun a c' b => h k a c' * (starRingEnd ℂ) (h k b c')) c := by
    ext b a
    simp [cutKernel, Matrix.sum_apply]
  rw [hsplit]
  refine Finset.sum_induction _ Matrix.PosSemidef ?_ ?_ ?_
  · intro M N hM hN
    exact hM.add hN
  · exact Matrix.PosSemidef.zero
  · intro k _hk
    exact cutKernel_posSemidef_of_factorized (h k) c

/-- End-to-end reflection positivity for factorized weights. -/
theorem reflectionForm_nonneg_of_factorized (h : A → C → ℂ) :
    IsReflectionPositive (fun a c b => h a c * (starRingEnd ℂ) (h b c)) :=
  reflectionForm_nonneg _ (cutKernel_posSemidef_of_factorized h)

/-- End-to-end reflection positivity for nonnegative-mixture weights. -/
theorem reflectionForm_nonneg_of_mixture {K : Type} [Fintype K]
    (h : K → A → C → ℂ) :
    IsReflectionPositive
      (fun a c b => ∑ k : K, h k a c * (starRingEnd ℂ) (h k b c)) :=
  reflectionForm_nonneg _ (cutKernel_posSemidef_of_mixture h)

/-- End-to-end reflection positivity for pointwise products of two weights
whose cut kernels are PSD at every cut configuration. This is the finite
two-factor assembly step behind products of cut-plaquette coupling
kernels. -/
theorem reflectionForm_nonneg_of_mul_posSemidef (W1 W2 : A → C → A → ℂ)
    (hW1 : ∀ c : C, (cutKernel W1 c).PosSemidef)
    (hW2 : ∀ c : C, (cutKernel W2 c).PosSemidef) :
    IsReflectionPositive (fun a c b => W1 a c b * W2 a c b) :=
  reflectionForm_nonneg _
    (fun c => cutKernel_mul_posSemidef W1 W2 hW1 hW2 c)

/-- End-to-end reflection positivity for finite pointwise products of
weights whose cut kernels are PSD at every cut configuration. This packages
the finite cut-plaquette product assembly once each individual coupling
kernel has been checked. -/
theorem reflectionForm_nonneg_of_finset_prod_posSemidef {K : Type}
    (s : Finset K) (W : K → A → C → A → ℂ)
    (hW : ∀ k, k ∈ s → ∀ c : C, (cutKernel (W k) c).PosSemidef) :
    IsReflectionPositive (fun a c b => ∏ k ∈ s, W k a c b) :=
  reflectionForm_nonneg _
    (fun c => cutKernel_finset_prod_posSemidef s W hW c)

/-- **Converse to `reflectionForm_nonneg` (Q2 bridge).** Reflection
positivity of `W` alone forces every cut kernel to be positive
semidefinite - no separate Hermitian/symmetry hypothesis is needed, since
it is derived from realness by polarization
(`HermitianBridge.posSemidef_of_forall_dotProduct_real_nonneg`). The
"block-diagonal-in-`C`" matrix a transfer-Hilbert-space construction would
build is exactly the direct sum of these `cutKernel W c`, so its
`PosSemidef` is equivalent to this family of statements. -/
theorem cutKernel_posSemidef_of_reflectionPositive [DecidableEq C]
    (W : A → C → A → ℂ) (hW : IsReflectionPositive W) (c : C) :
    (cutKernel W c).PosSemidef := by
  classical
  have key : ∀ g : A → ℂ,
      star g ⬝ᵥ (cutKernel W c *ᵥ g)
        = reflectionForm W (fun a c' => if c' = c then g a else 0) := by
    intro g
    rw [reflectionForm_eq_sum_dotProduct, Finset.sum_eq_single c]
    · simp
    · intro c' _ hc'
      have : (fun a => (if c' = c then g a else (0 : ℂ))) = (0 : A → ℂ) := by
        funext a; simp [hc']
      rw [this]; simp
    · intro h; exact absurd (Finset.mem_univ c) h
  refine HermitianBridge.posSemidef_of_forall_dotProduct_real_nonneg
    (cutKernel W c) (fun g => ?_) (fun g => ?_)
  · rw [key g]; simpa using ((hW _).2).symm
  · rw [key g]; simpa using (hW _).1

end ReflectionPositivityKernel
end GateYM
end NullEdge
end Draft
end PhysicsSM
