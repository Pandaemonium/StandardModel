import Mathlib

/-!
# Shell-angular four-component sampling and dual recovery

This focused file isolates the exact rank gate behind the marked-shell Higgs
derivative proposal. One time probe is supported, in based-difference
coordinates, on a radial set. Three spatial probes are supported on a disjoint
shell. A nonzero radial time difference and difference-coordinate independence
of the spatial triple force the resulting four-component sample map to be
injective. Finite-dimensional linear algebra then supplies a real linear left
inverse, whose real/imaginary extension recovers arbitrary complex derivative
components exactly.

The support sets and probes are supplied. This file does not construct them
from a causal order, prove conditioning, select a continuum tetrad, or establish
convergence. The target is finite exact algebra only.
-/

noncomputable section

namespace ShellAngularDualRecovery

open scoped BigOperators ComplexConjugate

variable {U : Type*} [Fintype U] [DecidableEq U]

/-- Difference coordinate of a real probe relative to one marked anchor. -/
def basedDifference (x : U) (f : U -> Real) (y : U) : Real :=
  f y - f x

/-- Every nonzero based difference of `f` is contained in `S`. -/
def BasedSupportedOn (x : U) (S : Finset U) (f : U -> Real) : Prop :=
  forall y, y ∉ S -> basedDifference x f y = 0

/-- Four component labels: one distinguished time component and three spatial
components. -/
abbrev ShellAngularIndex := Option (Fin 3)

/-- Real sample map associated with one radial time probe and three shell
probes. `none` is the time coefficient and `some i` is spatial coefficient
`i`. -/
def shellAngularSampleLinearMap
    (x : U) (time : U -> Real) (space : Fin 3 -> U -> Real) :
    (ShellAngularIndex -> Real) →ₗ[Real] (U -> Real) where
  toFun coefficient := fun y =>
    coefficient none * basedDifference x time y +
      ∑ i, coefficient (some i) * basedDifference x (space i) y
  map_add' coefficient other := by
    funext y
    simp only [Pi.add_apply, add_mul, Finset.sum_add_distrib]
    ring
  map_smul' scalar coefficient := by
    funext y
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply, mul_assoc]
    rw [mul_add, Finset.mul_sum]

/-- Complex sample synthesis with the same real shell-angular frame. -/
def shellAngularSynthesizeComplex
    (x : U) (time : U -> Real) (space : Fin 3 -> U -> Real)
    (derivative : ShellAngularIndex -> Complex) : U -> Complex :=
  fun y =>
    derivative none * (basedDifference x time y : Complex) +
      ∑ i, derivative (some i) *
        (basedDifference x (space i) y : Complex)

/-- Extend a real linear recovery map to complex samples by applying it to
real and imaginary parts separately. -/
def complexifyRecovery
    (recovery : (U -> Real) →ₗ[Real] (ShellAngularIndex -> Real))
    (samples : U -> Complex) : ShellAngularIndex -> Complex :=
  fun i =>
    (recovery (fun y => (samples y).re) i : Complex) +
      (recovery (fun y => (samples y).im) i : Complex) * Complex.I

/-- The displayed shell-angular formula is exactly the underlying function of
the bundled real sample map. -/
theorem shellAngularSampleLinearMap_apply
    (x : U) (time : U -> Real) (space : Fin 3 -> U -> Real)
    (coefficient : ShellAngularIndex -> Real) (y : U) :
    shellAngularSampleLinearMap x time space coefficient y =
      coefficient none * basedDifference x time y +
        ∑ i, coefficient (some i) * basedDifference x (space i) y := by
  sorry

/-- Disjoint radial/shell support and explicit nondegeneracy make the
four-component real sample map injective. -/
theorem shellAngularSampleLinearMap_injective
    (x : U) (shell radial : Finset U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (hdisjoint : Disjoint shell radial)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧ basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    Function.Injective (shellAngularSampleLinearMap x time space) := by
  sorry

/-- The same hypotheses express injectivity as the kernel condition consumed
by Mathlib's linear left-inverse construction. -/
theorem shellAngularSampleLinearMap_ker_eq_bot
    (x : U) (shell radial : Finset U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (hdisjoint : Disjoint shell radial)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧ basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    (shellAngularSampleLinearMap x time space).ker = ⊥ := by
  sorry

/-- A shell-angular sample map satisfying the rank gate admits a real linear
left inverse on the full finite sample space. -/
theorem exists_shellAngularLeftInverse
    (x : U) (shell radial : Finset U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (hdisjoint : Disjoint shell radial)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧ basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    exists recovery : (U -> Real) →ₗ[Real] (ShellAngularIndex -> Real),
      recovery.comp (shellAngularSampleLinearMap x time space) =
        LinearMap.id := by
  sorry

/-- A real left inverse of the shell-angular sample map recovers every complex
four-component derivative exactly after separate real/imaginary extension. -/
theorem complexifyRecovery_synthesize_of_leftInverse
    (x : U) (time : U -> Real) (space : Fin 3 -> U -> Real)
    (recovery : (U -> Real) →ₗ[Real] (ShellAngularIndex -> Real))
    (hLeft : recovery.comp (shellAngularSampleLinearMap x time space) =
      LinearMap.id)
    (derivative : ShellAngularIndex -> Complex) :
    complexifyRecovery recovery
      (shellAngularSynthesizeComplex x time space derivative) = derivative := by
  sorry

/-- **Controlled complex dual recovery.** The shell/radial support split and
the two explicit nondegeneracy hypotheses jointly supply one real recovery map
that exactly extracts every complex time-plus-three-space derivative vector. -/
theorem exists_shellAngularComplexRecovery
    (x : U) (shell radial : Finset U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (hdisjoint : Disjoint shell radial)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧ basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    exists recovery : (U -> Real) →ₗ[Real] (ShellAngularIndex -> Real),
      forall derivative : ShellAngularIndex -> Complex,
        complexifyRecovery recovery
          (shellAngularSynthesizeComplex x time space derivative) =
            derivative := by
  sorry

end ShellAngularDualRecovery

end
