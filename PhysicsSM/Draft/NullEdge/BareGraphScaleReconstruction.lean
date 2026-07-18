import Mathlib

/-!
# Bare-graph scale boundary and calibrated four-dimensional reconstruction

This module isolates the scale half of the Malament/order-number split used by
the null-edge GR program.

The bare finite relation supplies relabeling orbits. A positive scalar field
that is invariant under relation automorphisms remains invariant after every
positive global rescaling, so relabeling invariance alone leaves a complete
rescaling ray admissible. On a vertex-transitive relation it cannot even select
an inhomogeneous invariant scalar field.

The sharper identifiability statement is observation-theoretic. If a
nontrivial positive rescaling changes a physical target by Weyl weight one but
leaves the bare observation unchanged, no function of that observation can
reconstruct the target exactly on both realizations. This is the precise
absolute-scale no-go: it uses indistinguishability under the forgetful
bare-graph observation, not relabeling invariance by itself.

Event number supplies volume only after a density calibration `density` is
specified: `countingVolume density n = n / density`. Distinct positive
calibrations give distinct volumes for every nonempty region.

The constructive half then specializes to four dimensions. Given a
nondegenerate representative coframe `e` and a positive target volume, the
positive conformal factor is the fourth root of the target/base volume ratio.
The resulting coframe has exactly the target volume, and this positive factor
is unique. Taking the target to be calibrated counting volume closes the finite
scale equation exactly.

This is a reconstruction boundary, not a derivation of density, a coframe, or
manifoldlikeness from a bare graph. It records precisely which extra datum
breaks the global scale degeneracy. The graph statements are clean-room finite
algebra. The continuum interpretation follows the standard causal
order-plus-volume reconstruction principle; metric signature is not used in
the determinant-volume calculation.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction

/-! ## Relabeling-invariant graph data -/

variable {V : Type*}

/-- An equivalence preserves a bare directed relation in both directions. -/
def RelationAutomorphism (R : V -> V -> Prop) (T : V ≃ V) : Prop :=
  ∀ x y, R (T x) (T y) ↔ R x y

/-- A scalar observable is intrinsic to the bare relation when every relation
automorphism leaves it pointwise invariant. -/
def GraphInvariant (R : V -> V -> Prop) (s : V -> Real) : Prop :=
  ∀ (T : V ≃ V), RelationAutomorphism R T -> ∀ x, s (T x) = s x

/-- Every pair of vertices lies in the same relation-automorphism orbit. -/
def VertexTransitive (R : V -> V -> Prop) : Prop :=
  ∀ x y, ∃ T : V ≃ V, RelationAutomorphism R T ∧ T x = y

/-- Global scalar multiplication preserves graph invariance. -/
theorem graphInvariant_const_mul
    (R : V -> V -> Prop) (s : V -> Real) (hs : GraphInvariant R s)
    (lambda : Real) :
    GraphInvariant R (fun x => lambda * s x) := by
  intro T hT x
  change lambda * s (T x) = lambda * s x
  rw [hs T hT x]

/-- On a vertex-transitive relation, every graph-invariant scalar field is
constant. Thus an inhomogeneous conformal factor requires symmetry-breaking
data or a nonhomogeneous relational environment. -/
theorem graphInvariant_constant_of_vertexTransitive
    (R : V -> V -> Prop) (s : V -> Real)
    (htrans : VertexTransitive R) (hs : GraphInvariant R s) :
    ∀ x y, s x = s y := by
  intro x y
  obtain ⟨T, hT, hxy⟩ := htrans x y
  calc
    s x = s (T x) := (hs T hT x).symm
    _ = s y := congrArg s hxy

/-- Any positive graph-invariant scale belongs to a nontrivial positive
rescaling family. This records closure of the admissible invariant data under
global rescaling; the observation-level no-go below supplies the stronger
nonidentifiability conclusion. -/
theorem bareGraphScale_rescaling_ray
    [Nonempty V] (R : V -> V -> Prop) (s : V -> Real)
    (hs : GraphInvariant R s) (hpos : ∀ x, 0 < s x)
    (lambda : Real) (hlambda : 0 < lambda) (hne : lambda ≠ 1) :
    ∃ s' : V -> Real,
      GraphInvariant R s' ∧ (∀ x, 0 < s' x) ∧ s' ≠ s := by
  refine ⟨fun x => lambda * s x, graphInvariant_const_mul R s hs lambda,
    fun x => mul_pos hlambda (hpos x), ?_⟩
  intro heq
  let x : V := Classical.choice inferInstance
  have hx := congrFun heq x
  change lambda * s x = s x at hx
  have hsne : s x ≠ 0 := (hpos x).ne'
  apply hne
  apply mul_right_cancel₀ hsne
  simpa using hx

/-! ## Absolute-scale identifiability boundary -/

/-- An estimator reconstructs a scalar target exactly when applying it to the
observable data of every realization returns that realization's target. -/
def ExactScalarReconstruction
    {X O : Type*} (observe : X -> O) (target : X -> Real)
    (estimate : O -> Real) : Prop :=
  forall x, estimate (observe x) = target x

/-- **Hidden-rescaling no-go.** Suppose a nontrivial positive global
rescaling leaves the observable data unchanged while a positive physical
target has Weyl weight one. No estimator using only that observable can
reconstruct the target exactly on all realizations.

For the GR program, `X` may be a class of continuum or decorated realizations,
`O` their bare finite-relation observations, and `target` a physical length.
The theorem does not assume that such a realization map has already been
derived; rather, it states the exact gate that any claimed bare-graph absolute
scale reconstruction must defeat. -/
theorem no_exact_scalar_reconstruction_of_hidden_rescaling
    {X O : Type*}
    (observe : X -> O) (target : X -> Real)
    (rescale : Real -> X -> X) (x : X) (lambda : Real)
    (hlambdaPos : 0 < lambda) (hlambdaNe : lambda ≠ 1)
    (hhidden : observe (rescale lambda x) = observe x)
    (hweight : target (rescale lambda x) = lambda * target x)
    (htarget : 0 < target x) :
    Not (Exists fun estimate : O -> Real =>
      ExactScalarReconstruction observe target estimate) := by
  intro hexists
  obtain ⟨estimate, hexact⟩ := hexists
  have hsame : target (rescale lambda x) = target x := by
    calc
      target (rescale lambda x) = estimate (observe (rescale lambda x)) :=
        (hexact (rescale lambda x)).symm
      _ = estimate (observe x) := congrArg estimate hhidden
      _ = target x := hexact x
  have hrescaledPos : 0 < target (rescale lambda x) := by
    rw [hweight]
    exact mul_pos hlambdaPos htarget
  have htargetNe : target x ≠ 0 := by
    rw [← hsame]
    exact hrescaledPos.ne'
  have hmul : lambda * target x = 1 * target x := by
    rw [← hweight, hsame]
    simp
  apply hlambdaNe
  exact mul_right_cancel₀ htargetNe hmul

/-! ## Count-volume calibration -/

/-- Region volume inferred from event count at a specified positive density. -/
def countingVolume (density : Real) (n : Nat) : Real :=
  (n : Real) / density

/-- A nonempty count at positive density gives positive volume. -/
theorem countingVolume_pos
    {density : Real} {n : Nat} (hdensity : 0 < density) (hn : 0 < n) :
    0 < countingVolume density n := by
  exact div_pos (Nat.cast_pos.mpr hn) hdensity

/-- The same nonzero count gives different volumes under distinct positive
density calibrations. Count alone therefore does not fix absolute volume. -/
theorem countingVolume_requires_density_calibration
    {density1 density2 : Real} {n : Nat}
    (h1 : 0 < density1) (h2 : 0 < density2) (hn : 0 < n)
    (hne : density1 ≠ density2) :
    countingVolume density1 n ≠ countingVolume density2 n := by
  intro h
  have hcross :
      (n : Real) * density2 = (n : Real) * density1 := by
    exact (div_eq_div_iff h1.ne' h2.ne').mp h
  have hnR : 0 < (n : Real) := Nat.cast_pos.mpr hn
  apply hne
  nlinarith

/-! ## Positive four-dimensional conformal reconstruction -/

/-- Nonnegative real fourth root, written as two principal square roots. -/
def fourthRoot (r : Real) : Real :=
  Real.sqrt (Real.sqrt r)

/-- The chosen fourth root is always nonnegative. -/
theorem fourthRoot_nonneg (r : Real) : 0 ≤ fourthRoot r :=
  Real.sqrt_nonneg _

/-- A positive input has a positive fourth root. -/
theorem fourthRoot_pos {r : Real} (hr : 0 < r) : 0 < fourthRoot r := by
  exact Real.sqrt_pos.2 (Real.sqrt_pos.2 hr)

/-- The chosen fourth root has fourth power equal to every nonnegative input. -/
theorem fourthRoot_pow_four {r : Real} (hr : 0 ≤ r) :
    fourthRoot r ^ 4 = r := by
  calc
    fourthRoot r ^ 4 = (Real.sqrt (Real.sqrt r) ^ 2) ^ 2 := by
      unfold fourthRoot
      ring
    _ = (Real.sqrt r) ^ 2 := by
      rw [Real.sq_sqrt (Real.sqrt_nonneg r)]
    _ = r := Real.sq_sqrt hr

/-- A real square coframe in physical spacetime dimension four. -/
abbrev Coframe4 := Matrix (Fin 4) (Fin 4) Real

/-- Absolute determinant of a four-dimensional coframe. -/
def coframeVolume (e : Coframe4) : Real :=
  |e.det|

/-- Positive Weyl rescaling of a representative coframe. -/
def conformalCoframe (omega : Real) (e : Coframe4) : Coframe4 :=
  omega • e

/-- Four-dimensional coframe volume has Weyl weight four. -/
theorem coframeVolume_conformalCoframe
    (omega : Real) (e : Coframe4) (homega : 0 ≤ omega) :
    coframeVolume (conformalCoframe omega e) =
      omega ^ 4 * coframeVolume e := by
  unfold coframeVolume conformalCoframe
  rw [Matrix.det_smul]
  simp [abs_mul, abs_pow, abs_of_nonneg homega]

/-- Positive conformal factor selected by a target/base volume ratio. -/
def calibratedConformalScale (e : Coframe4) (targetVolume : Real) : Real :=
  fourthRoot (targetVolume / coframeVolume e)

/-- Positive base and target volumes give a positive selected scale. -/
theorem calibratedConformalScale_pos
    (e : Coframe4) (targetVolume : Real)
    (he : 0 < coframeVolume e) (htarget : 0 < targetVolume) :
    0 < calibratedConformalScale e targetVolume := by
  exact fourthRoot_pos (div_pos htarget he)

/-- The selected conformal factor reconstructs the target volume exactly. -/
theorem calibratedConformalScale_reconstructs
    (e : Coframe4) (targetVolume : Real)
    (he : 0 < coframeVolume e) (htarget : 0 < targetVolume) :
    coframeVolume
        (conformalCoframe (calibratedConformalScale e targetVolume) e) =
      targetVolume := by
  rw [coframeVolume_conformalCoframe _ _
    (calibratedConformalScale_pos e targetVolume he htarget).le]
  unfold calibratedConformalScale
  rw [fourthRoot_pow_four (div_nonneg htarget.le he.le)]
  exact div_mul_cancel₀ targetVolume he.ne'

/-- Two positive Weyl factors producing the same nonzero coframe volume are
equal. -/
theorem positive_conformalScale_unique
    (e : Coframe4) (targetVolume omega1 omega2 : Real)
    (he : 0 < coframeVolume e)
    (homega1 : 0 < omega1) (homega2 : 0 < omega2)
    (hvolume1 :
      coframeVolume (conformalCoframe omega1 e) = targetVolume)
    (hvolume2 :
      coframeVolume (conformalCoframe omega2 e) = targetVolume) :
    omega1 = omega2 := by
  have hpows : omega1 ^ 4 = omega2 ^ 4 := by
    rw [coframeVolume_conformalCoframe omega1 e homega1.le] at hvolume1
    rw [coframeVolume_conformalCoframe omega2 e homega2.le] at hvolume2
    apply mul_right_cancel₀ he.ne'
    exact hvolume1.trans hvolume2.symm
  exact (pow_left_inj₀ homega1.le homega2.le
    (by norm_num : (4 : Nat) ≠ 0)).mp hpows

/-- Conformal factor obtained from a calibrated event count. -/
def countCalibratedScale
    (density : Real) (n : Nat) (e : Coframe4) : Real :=
  calibratedConformalScale e (countingVolume density n)

/-- **Calibrated scale reconstruction.** A positive density, nonempty event
count, and nondegenerate representative coframe determine a unique positive
Weyl factor whose coframe volume equals calibrated counting volume. -/
theorem calibrated_count_fixes_positive_conformal_scale
    (density : Real) (n : Nat) (e : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n) (he : 0 < coframeVolume e) :
    let omega := countCalibratedScale density n e
    0 < omega ∧
      coframeVolume (conformalCoframe omega e) = countingVolume density n ∧
      ∀ omega' : Real, 0 < omega' ->
        coframeVolume (conformalCoframe omega' e) = countingVolume density n ->
        omega' = omega := by
  dsimp only
  have htarget : 0 < countingVolume density n :=
    countingVolume_pos hdensity hn
  refine ⟨calibratedConformalScale_pos e _ he htarget,
    calibratedConformalScale_reconstructs e _ he htarget, ?_⟩
  intro omega' homega' hvolume'
  exact positive_conformalScale_unique e _ omega' _
    he homega' (calibratedConformalScale_pos e _ he htarget)
    hvolume' (calibratedConformalScale_reconstructs e _ he htarget)

/-! ## Nonvacuity controls -/

/-- A constant observation of real-valued realizations cannot recover the
identity target when multiplication by two is observationally invisible. This
is an explicit witness for every hypothesis of the hidden-rescaling no-go. -/
theorem hidden_rescaling_no_go_nonvacuous_witness :
    Not (Exists fun estimate : Unit -> Real =>
      ExactScalarReconstruction (fun _ : Real => Unit.unit)
        (fun y : Real => y) estimate) := by
  apply no_exact_scalar_reconstruction_of_hidden_rescaling
    (observe := fun _ : Real => Unit.unit)
    (target := fun y : Real => y)
    (rescale := fun r y : Real => r * y)
    (x := 1) (lambda := 2)
  · norm_num
  · norm_num
  · rfl
  · norm_num
  · norm_num

/-- A two-vertex bare relation has a genuine positive rescaling family. -/
theorem bareGraphScale_nonvacuous_witness :
    ∃ s' : Fin 2 -> Real,
      GraphInvariant (fun _ _ : Fin 2 => True) s' ∧
      (∀ x, 0 < s' x) ∧
      s' ≠ (fun _ => 1) := by
  apply bareGraphScale_rescaling_ray
      (fun _ _ : Fin 2 => True) (fun _ => 1) (lambda := 2)
  · intro T _ x
    rfl
  · intro x
    norm_num
  · norm_num
  · norm_num

/-- Eight events represent different volumes at densities one and two. -/
theorem countingVolume_calibration_witness :
    countingVolume 1 8 = 8 ∧ countingVolume 2 8 = 4 := by
  norm_num [countingVolume]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.no_exact_scalar_reconstruction_of_hidden_rescaling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.no_exact_scalar_reconstruction_of_hidden_rescaling

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.bareGraphScale_rescaling_ray' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.bareGraphScale_rescaling_ray

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.graphInvariant_constant_of_vertexTransitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.graphInvariant_constant_of_vertexTransitive

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.calibrated_count_fixes_positive_conformal_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.calibrated_count_fixes_positive_conformal_scale

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.bareGraphScale_nonvacuous_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction.bareGraphScale_nonvacuous_witness

end PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
