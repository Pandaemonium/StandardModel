import PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

/-!
# Corrected causal pairing as a weighted-difference operator

The direct finite retarded operator is diagonal plus a strict-past term. Its
polynomial spectrum can therefore be too poor to select a nontrivial probe
sector. The corrected principal-symbol pairing is a different object: its
diagonal term cancels, and the remaining form is a symmetric weighted sum of
finite differences.

This module proves that distinction exactly for every layered finite causal
operator. It is finite algebra only. It does not prove positivity, Lorentzian
inertia, rank four, a spectral gap, or continuum convergence.

Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator

open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

variable {V : Type*} [Fintype V]

/-- The strict-past row weight, including the layered-operator prefactor. -/
def layeredPastWeight
    (C : FiniteCausalOrder V) (prefactor : Real)
    (coefficient : Nat -> Real) (x y : V) : Real :=
  if C.before y x then
    prefactor * coefficient (C.openIntervalCount y x)
  else 0

/-- Symmetric weighted finite-difference form at one marked event. -/
def weightedDifferenceForm
    (weight : V -> Real) (x : V) (f h : V -> Real) : Real :=
  (2 : Real)⁻¹ *
    ∑ y : V, weight y * (f y - f x) * (h y - h x)

/-- Euclidean dot product on finite real scalar fields. -/
def fieldDot (f h : V -> Real) : Real :=
  ∑ z : V, f z * h z

/-- Canonical ambient endomorphism representing the weighted-difference form
with respect to `fieldDot`. Its second term makes every output sum to zero. -/
def weightedDifferenceOperator [DecidableEq V]
    (weight : V -> Real) (x : V) : Module.End Real (V -> Real) where
  toFun h z :=
    (2 : Real)⁻¹ *
      (weight z * (h z - h x) -
        if z = x then ∑ y : V, weight y * (h y - h x) else 0)
  map_add' h k := by
    funext z
    simp only [Pi.add_apply]
    by_cases hzx : z = x
    · subst z
      simp only [if_pos, sub_self, mul_zero, zero_sub]
      have hsum :
          (∑ y : V, weight y * (h y + k y - (h x + k x))) =
            (∑ y : V, weight y * (h y - h x)) +
              ∑ y : V, weight y * (k y - k x) := by
        rw [<- Finset.sum_add_distrib]
        apply Finset.sum_congr rfl
        intro y _
        ring
      rw [hsum]
      ring
    · simp [hzx]
      ring
  map_smul' c h := by
    funext z
    simp only [RingHom.id_apply, Pi.smul_apply, smul_eq_mul]
    by_cases hzx : z = x
    · subst z
      simp only [if_pos, sub_self, mul_zero, zero_sub]
      have hsum :
          (∑ y : V, weight y * (c * h y - c * h x)) =
            c * ∑ y : V, weight y * (h y - h x) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro y _
        ring
      rw [hsum]
      ring
    · simp [hzx]
      ring

/-- The weighted-difference operator represents the symmetric difference form
under the canonical finite-field dot product. -/
theorem fieldDot_weightedDifferenceOperator
    [DecidableEq V] (weight : V -> Real) (x : V) (f h : V -> Real) :
    fieldDot f (weightedDifferenceOperator weight x h) =
      weightedDifferenceForm weight x f h := by
  classical
  let S : Real := ∑ y : V, weight y * (h y - h x)
  have hdelta :
      (∑ z : V, f z * (if z = x then S else 0)) = f x * S := by
    simp [mul_ite]
  have hleft :
      (∑ z : V, f z *
        ((2 : Real)⁻¹ *
          (weight z * (h z - h x) - if z = x then S else 0))) =
        (2 : Real)⁻¹ *
          ((∑ z : V, f z * (weight z * (h z - h x))) - f x * S) := by
    calc
      _ = ∑ z : V, (2 : Real)⁻¹ *
          (f z * (weight z * (h z - h x)) -
            f z * (if z = x then S else 0)) := by
        apply Finset.sum_congr rfl
        intro z _
        ring
      _ = (2 : Real)⁻¹ *
          ((∑ z : V, f z * (weight z * (h z - h x))) -
            ∑ z : V, f z * (if z = x then S else 0)) := by
        rw [<- Finset.mul_sum, Finset.sum_sub_distrib]
      _ = _ := by rw [hdelta]
  have hright :
      (∑ y : V, weight y * (f y - f x) * (h y - h x)) =
        (∑ y : V, f y * (weight y * (h y - h x))) - f x * S := by
    calc
      _ = ∑ y : V,
          (f y * (weight y * (h y - h x)) -
            f x * (weight y * (h y - h x))) := by
        apply Finset.sum_congr rfl
        intro y _
        ring
      _ = (∑ y : V, f y * (weight y * (h y - h x))) -
          ∑ y : V, f x * (weight y * (h y - h x)) := by
        rw [Finset.sum_sub_distrib]
      _ = _ := by
        rw [<- Finset.mul_sum]
  unfold fieldDot weightedDifferenceOperator weightedDifferenceForm
  simp only [LinearMap.coe_mk, AddHom.coe_mk]
  change (∑ z : V, f z *
      ((2 : Real)⁻¹ *
        (weight z * (h z - h x) - if z = x then S else 0))) = _
  rw [hleft, hright]

/-- Every output of the weighted-difference operator lies in the canonical
zero-sum field subspace. -/
theorem weightedDifferenceOperator_mem_zeroSum
    [DecidableEq V] (weight : V -> Real) (x : V) (h : V -> Real) :
    weightedDifferenceOperator weight x h ∈ zeroSumFieldSubspace V := by
  classical
  let S : Real := ∑ y : V, weight y * (h y - h x)
  have hdelta : (∑ z : V, if z = x then S else 0) = S := by
    simp
  rw [zeroSumFieldSubspace, LinearMap.mem_ker]
  unfold fieldSumLinearMap weightedDifferenceOperator
  simp only [LinearMap.coe_mk, AddHom.coe_mk]
  change (∑ z : V, (2 : Real)⁻¹ *
      (weight z * (h z - h x) - if z = x then S else 0)) = 0
  calc
    _ = (2 : Real)⁻¹ *
        ((∑ z : V, weight z * (h z - h x)) -
          ∑ z : V, if z = x then S else 0) := by
      rw [<- Finset.mul_sum, Finset.sum_sub_distrib]
    _ = 0 := by rw [hdelta]; simp [S]

/-- The weighted finite-difference form is symmetric. -/
theorem weightedDifferenceForm_comm
    (weight : V -> Real) (x : V) (f h : V -> Real) :
    weightedDifferenceForm weight x f h =
      weightedDifferenceForm weight x h f := by
  unfold weightedDifferenceForm
  apply congrArg (fun z => (2 : Real)⁻¹ * z)
  apply Finset.sum_congr rfl
  intro y _
  ring

/-- The canonical weighted-difference operator is self-adjoint with respect to
the finite-field Euclidean pairing. -/
theorem weightedDifferenceOperator_selfAdjoint
    [DecidableEq V] (weight : V -> Real) (x : V) (f h : V -> Real) :
    fieldDot f (weightedDifferenceOperator weight x h) =
      fieldDot h (weightedDifferenceOperator weight x f) := by
  rw [fieldDot_weightedDifferenceOperator,
    fieldDot_weightedDifferenceOperator]
  exact weightedDifferenceForm_comm weight x f h

/-- Restrict the canonical weighted-difference operator to the zero-sum probe
space. The ambient operator already has zero-sum range, so no chosen basis or
projection is required. -/
def zeroSumWeightedDifferenceOperator [DecidableEq V]
    (weight : V -> Real) (x : V) :
    Module.End Real (zeroSumFieldSubspace V) where
  toFun h := ⟨weightedDifferenceOperator weight x h.1,
    weightedDifferenceOperator_mem_zeroSum weight x h.1⟩
  map_add' h k := by
    apply Subtype.ext
    exact map_add (weightedDifferenceOperator weight x) h.1 k.1
  map_smul' c h := by
    apply Subtype.ext
    exact map_smul (weightedDifferenceOperator weight x) c h.1

/-- The restricted operator represents the same weighted-difference form. -/
theorem fieldDot_zeroSumWeightedDifferenceOperator
    [DecidableEq V] (weight : V -> Real) (x : V)
    (f h : zeroSumFieldSubspace V) :
    fieldDot f.1 (zeroSumWeightedDifferenceOperator weight x h).1 =
      weightedDifferenceForm weight x f.1 h.1 := by
  exact fieldDot_weightedDifferenceOperator weight x f.1 h.1

/-- **Difference-form identity.** The corrected pairing of every layered
finite causal operator depends only on its strict-past row. The diagonal
coefficient cancels exactly. -/
theorem correctedPairingAt_layeredOperator_eq_weightedDifferenceForm
    (C : FiniteCausalOrder V) (prefactor diagonal : Real)
    (coefficient : Nat -> Real) (x : V) (f h : V -> Real) :
    correctedPairingAt
        (C.layeredOperator prefactor diagonal coefficient) x f h =
      weightedDifferenceForm
        (layeredPastWeight C prefactor coefficient x) x f h := by
  classical
  have hcore :
      C.layeredPastSum coefficient (f * h) x -
          f x * C.layeredPastSum coefficient h x -
          h x * C.layeredPastSum coefficient f x +
          f x * h x * C.layeredPastSum coefficient 1 x =
        ∑ y : V, if C.before y x then
          coefficient (C.openIntervalCount y x) *
            (f y - f x) * (h y - h x)
        else 0 := by
    unfold FiniteCausalOrder.layeredPastSum
    simp only [Pi.mul_apply, Pi.one_apply, Finset.mul_sum]
    rw [<- Finset.sum_sub_distrib, <- Finset.sum_sub_distrib,
      <- Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro y _
    by_cases hyx : C.before y x
    · simp [hyx]
      ring
    · simp [hyx]
  have hweighted :
      prefactor *
          (C.layeredPastSum coefficient (f * h) x -
            f x * C.layeredPastSum coefficient h x -
            h x * C.layeredPastSum coefficient f x +
            f x * h x * C.layeredPastSum coefficient 1 x) =
        ∑ y : V, layeredPastWeight C prefactor coefficient x y *
          (f y - f x) * (h y - h x) := by
    rw [hcore, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro y _
    by_cases hyx : C.before y x
    · simp [layeredPastWeight, hyx]
      ring
    · simp [layeredPastWeight, hyx]
  calc
    correctedPairingAt
        (C.layeredOperator prefactor diagonal coefficient) x f h =
        (2 : Real)⁻¹ * prefactor *
          (C.layeredPastSum coefficient (f * h) x -
            f x * C.layeredPastSum coefficient h x -
            h x * C.layeredPastSum coefficient f x +
            f x * h x * C.layeredPastSum coefficient 1 x) := by
      unfold correctedPairingAt FiniteCausalOrder.layeredOperator
      simp only [Pi.mul_apply, Pi.one_apply]
      ring
    _ = weightedDifferenceForm
        (layeredPastWeight C prefactor coefficient x) x f h := by
      unfold weightedDifferenceForm
      rw [mul_assoc, hweighted]

/-- The corrected pairing restricted to zero-sum probes is represented by a
canonical self-adjoint endomorphism of that same probe space. -/
theorem correctedPairingAt_layeredOperator_eq_fieldDot
    [DecidableEq V]
    (C : FiniteCausalOrder V) (prefactor diagonal : Real)
    (coefficient : Nat -> Real) (x : V)
    (f h : zeroSumFieldSubspace V) :
    correctedPairingAt
        (C.layeredOperator prefactor diagonal coefficient) x f.1 h.1 =
      fieldDot f.1
        (zeroSumWeightedDifferenceOperator
          (layeredPastWeight C prefactor coefficient x) x h).1 := by
  rw [fieldDot_zeroSumWeightedDifferenceOperator]
  exact correctedPairingAt_layeredOperator_eq_weightedDifferenceForm
    C prefactor diagonal coefficient x f.1 h.1

/-- Effective project-sign prefactor for the local/smeared branch convention. -/
def projectSmearedEffectivePrefactor
    (ell nonlocalityScale : Real) : Real :=
  if smearingEpsilon ell nonlocalityScale = 1 then
    -sourceLocal4DPrefactor ell
  else
    -(4 / (Real.sqrt 6 * nonlocalityScale ^ 2))

/-- Effective layer coefficient for the local/smeared branch convention. -/
def projectSmearedEffectiveCoefficient
    (ell nonlocalityScale : Real) (n : Nat) : Real :=
  let epsilon := smearingEpsilon ell nonlocalityScale
  if epsilon = 1 then sourceLocal4DCoefficient n
  else sourceSmeared4DCoefficient epsilon n

/-- The project-sign smeared operator is one layered operator with an explicit
branch-dependent prefactor and coefficient function. -/
theorem projectSmeared4DOperator_eq_layeredOperator
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real) :
    projectSmeared4DOperator C ell nonlocalityScale =
      C.layeredOperator
        (projectSmearedEffectivePrefactor ell nonlocalityScale) (-1)
        (projectSmearedEffectiveCoefficient ell nonlocalityScale) := by
  funext phi x
  unfold projectSmeared4DOperator sourceSmeared4DOperator
    sourceLocal4DOperator projectSmearedEffectivePrefactor
    projectSmearedEffectiveCoefficient
  by_cases hepsilon : smearingEpsilon ell nonlocalityScale = 1
  · simp [hepsilon, FiniteCausalOrder.layeredOperator]
  · simp [hepsilon, FiniteCausalOrder.layeredOperator]

/-- The actual project smeared pairing is represented on zero-sum probes by
the canonical weighted-difference endomorphism. -/
theorem correctedPairingAt_projectSmeared4D_eq_fieldDot
    [DecidableEq V]
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real) (x : V)
    (f h : zeroSumFieldSubspace V) :
    correctedPairingAt
        (projectSmeared4DOperator C ell nonlocalityScale) x f.1 h.1 =
      fieldDot f.1
        (zeroSumWeightedDifferenceOperator
          (layeredPastWeight C
            (projectSmearedEffectivePrefactor ell nonlocalityScale)
            (projectSmearedEffectiveCoefficient ell nonlocalityScale) x)
          x h).1 := by
  rw [projectSmeared4DOperator_eq_layeredOperator]
  exact correctedPairingAt_layeredOperator_eq_fieldDot
    C (projectSmearedEffectivePrefactor ell nonlocalityScale) (-1)
      (projectSmearedEffectiveCoefficient ell nonlocalityScale) x f h

/-- Nonzero two-event witness: one weighted finite difference is sent to the
zero-sum vector `(1,-1)`. -/
theorem twoEvent_weightedDifferenceOperator_witness :
    let weight : Fin 2 -> Real := fun i => if i = 0 then 2 else 0
    let probe : Fin 2 -> Real := fun i => if i = 0 then 1 else 0
    weightedDifferenceOperator weight 1 probe 0 = 1 ∧
      weightedDifferenceOperator weight 1 probe 1 = -1 := by
  norm_num [weightedDifferenceOperator, Fin.sum_univ_two]

end PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_layeredOperator_eq_weightedDifferenceForm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_layeredOperator_eq_weightedDifferenceForm

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_layeredOperator_eq_fieldDot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_layeredOperator_eq_fieldDot

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_projectSmeared4D_eq_fieldDot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.correctedPairingAt_projectSmeared4D_eq_fieldDot

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.twoEvent_weightedDifferenceOperator_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator.twoEvent_weightedDifferenceOperator_witness
