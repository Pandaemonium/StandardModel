import Mathlib

/-!
# Shell-angular four-component sampling and dual recovery

This module isolates the exact rank gate behind the marked-shell Higgs
derivative proposal. One time probe is supported, in based-difference
coordinates, on a radial set. Three spatial probes are supported on a disjoint
shell. A nonzero radial time difference and difference-coordinate independence
of the spatial triple force the resulting four-component sample map to be
injective. Finite-dimensional linear algebra then supplies a real linear left
inverse, whose real/imaginary extension recovers arbitrary complex derivative
components exactly.

The support sets and probes are supplied. This module does not construct them
from a causal order, prove conditioning, select a continuum tetrad, or establish
convergence. The six finite proofs were produced by Aristotle project
`1b345541-a6c3-4ac1-b007-8d1bd9bf37ca`, replayed under the pinned toolchain,
and ported here without statement weakening. Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery

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

omit [Fintype U] [DecidableEq U] in
/-- The displayed shell-angular formula is exactly the underlying function of
the bundled real sample map. -/
theorem shellAngularSampleLinearMap_apply
    (x : U) (time : U -> Real) (space : Fin 3 -> U -> Real)
    (coefficient : ShellAngularIndex -> Real) (y : U) :
    shellAngularSampleLinearMap x time space coefficient y =
      coefficient none * basedDifference x time y +
        ∑ i, coefficient (some i) * basedDifference x (space i) y := by
  rfl

omit [Fintype U] [DecidableEq U] in
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
  intro coefficient coefficient' h
  ext i
  induction i <;> simp_all +decide [funext_iff]
  · obtain ⟨y, hy, hy'⟩ := htimeNonzero
    specialize h y
    simp_all +decide [shellAngularSampleLinearMap_apply]
    simp_all +decide [Finset.disjoint_left, BasedSupportedOn]
    grind
  · contrapose! hspaceIndependent
    refine' ⟨fun i => coefficient (some i) - coefficient' (some i), ‹_›, _, _⟩ <;>
      simp_all +decide [sub_eq_iff_eq_add]
    intro y hy
    specialize h y
    simp_all +decide [sub_mul, Finset.sum_sub_distrib,
      shellAngularSampleLinearMap_apply]
    simp_all +decide [Finset.disjoint_left, BasedSupportedOn]

omit [Fintype U] [DecidableEq U] in
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
  convert LinearMap.ker_eq_bot.mpr
    (shellAngularSampleLinearMap_injective x shell radial time space hdisjoint
      htimeSupport hspaceSupport htimeNonzero hspaceIndependent) using 1

omit [DecidableEq U] in
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
  let f : (ShellAngularIndex -> Real) →ₗ[Real] (U -> Real) :=
    shellAngularSampleLinearMap x time space
  have hf : Function.Injective f :=
    shellAngularSampleLinearMap_injective x shell radial time space
      hdisjoint htimeSupport hspaceSupport htimeNonzero hspaceIndependent
  exact IsSemisimpleModule.extension_property f hf LinearMap.id

omit [Fintype U] [DecidableEq U] in
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
  unfold complexifyRecovery shellAngularSynthesizeComplex
  ext i
  simp_all +decide [Complex.ext_iff, funext_iff, LinearMap.ext_iff]
  exact ⟨
    by
      simpa [shellAngularSampleLinearMap_apply] using
        hLeft (fun i => (derivative i).re) i,
    by
      simpa [shellAngularSampleLinearMap_apply] using
        hLeft (fun i => (derivative i).im) i⟩

omit [DecidableEq U] in
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
  obtain ⟨recovery, hrecovery⟩ :=
    exists_shellAngularLeftInverse x shell radial time space hdisjoint
      htimeSupport hspaceSupport htimeNonzero hspaceIndependent
  exact ⟨recovery, fun derivative =>
    complexifyRecovery_synthesize_of_leftInverse x time space recovery
      hrecovery derivative⟩

/-! ## Explicit nonvacuous finite control -/

/-- Five-point control time probe: point zero is the anchor and point one is
the radial witness. -/
def finFiveTimeProbe : Fin 5 -> Real :=
  ![0, 1, 0, 0, 0]

/-- Five-point control spatial probes: the three basis probes are supported at
shell points two, three, and four. -/
def finFiveSpaceProbe : Fin 3 -> Fin 5 -> Real :=
  ![![0, 0, 1, 0, 0], ![0, 0, 0, 1, 0], ![0, 0, 0, 0, 1]]

/-- Nonvacuous control: the displayed five-point radial/shell architecture
satisfies the rank gate and therefore exactly recovers every complex `1+3`
derivative vector. -/
theorem exists_shellAngularComplexRecovery_finFive_witness :
    exists recovery : (Fin 5 -> Real) →ₗ[Real] (ShellAngularIndex -> Real),
      forall derivative : ShellAngularIndex -> Complex,
        complexifyRecovery recovery
          (shellAngularSynthesizeComplex 0 finFiveTimeProbe finFiveSpaceProbe
            derivative) = derivative := by
  apply exists_shellAngularComplexRecovery
    (x := 0) (shell := {2, 3, 4}) (radial := {1})
    (time := finFiveTimeProbe) (space := finFiveSpaceProbe)
  · decide
  · intro y hy
    fin_cases y <;> simp_all [basedDifference, finFiveTimeProbe]
  · intro i y hy
    fin_cases i <;> fin_cases y <;>
      simp_all [basedDifference, finFiveSpaceProbe]
  · refine ⟨1, by simp, ?_⟩
    norm_num [basedDifference, finFiveTimeProbe]
  · intro a ha
    have hCoordinates : a 0 ≠ 0 ∨ a 1 ≠ 0 ∨ a 2 ≠ 0 := by
      contrapose! ha
      funext i
      fin_cases i <;> simp_all
    rcases hCoordinates with h0 | h1 | h2
    · refine ⟨2, by simp, ?_⟩
      simpa [basedDifference, finFiveSpaceProbe, Fin.sum_univ_succ] using h0
    · refine ⟨3, by simp, ?_⟩
      simpa [basedDifference, finFiveSpaceProbe, Fin.sum_univ_succ] using h1
    · refine ⟨4, by simp, ?_⟩
      simpa [basedDifference, finFiveSpaceProbe, Fin.sum_univ_succ] using h2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery.shellAngularSampleLinearMap_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms shellAngularSampleLinearMap_injective

/-- info: 'PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery.exists_shellAngularLeftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_shellAngularLeftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery.complexifyRecovery_synthesize_of_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complexifyRecovery_synthesize_of_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery.exists_shellAngularComplexRecovery' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_shellAngularComplexRecovery

/-- info: 'PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery.exists_shellAngularComplexRecovery_finFive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_shellAngularComplexRecovery_finFive_witness

end PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery

end
