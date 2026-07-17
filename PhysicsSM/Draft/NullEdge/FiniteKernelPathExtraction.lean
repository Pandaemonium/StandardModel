import Mathlib

/-!
# Finite matrix-power path extraction

This module proves the exact path semantics of a nonzero finite matrix-power
entry. Matrix rows are targets and columns are sources.

`HasKernelPath K n source target` records `n` composable nonzero primitive
entries of `K`. `HasRelationPath step n source target` records the same path in
an arbitrary declared step relation. A nonzero entry of `K ^ n` yields a path
of exactly length `n`; no positivity assumption is needed.

The proof bodies were recovered from Aristotle project
`16309cb8-603b-4074-a0c7-1d1cc9b30468` and replayed under the pinned project
toolchain. During integration, the standalone handoff's Boolean `!=` notation
was corrected to the intended proposition-level `≠` in every public nonzero
hypothesis.

This is finite matrix combinatorics. It does not identify the supplied
primitive relation with a continuum null relation or select physical kernel
weights. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- An explicit chain of nonzero primitive target-source entries of `K`. -/
inductive HasKernelPath (K : Matrix V V Real) : Nat -> V -> V -> Prop
  | nil (vertex : V) : HasKernelPath K 0 vertex vertex
  | cons {n : Nat} {source middle target : V}
      (edge : K middle source ≠ 0)
      (tail : HasKernelPath K n middle target) :
      HasKernelPath K (n + 1) source target

/-- An explicit chain in an arbitrary directed step relation. -/
inductive HasRelationPath (step : V -> V -> Prop) : Nat -> V -> V -> Prop
  | nil (vertex : V) : HasRelationPath step 0 vertex vertex
  | cons {n : Nat} {source middle target : V}
      (edge : step source middle)
      (tail : HasRelationPath step n middle target) :
      HasRelationPath step (n + 1) source target

/-- Every nonzero matrix-power entry has an explicit chain of nonzero
primitive entries of the same length. -/
theorem matrixPower_entry_ne_zero_hasKernelPath
    (K : Matrix V V Real) :
    ∀ (n : Nat) (source target : V),
      (K ^ n) target source ≠ 0 -> HasKernelPath K n source target := by
  intro n source target h
  induction' n with n ih generalizing source target <;>
    simp_all +decide [pow_succ, Matrix.mul_apply]
  · simp_all +decide [Matrix.one_apply]
    constructor
  · obtain ⟨middle, hmiddle⟩ :
        ∃ middle, (K ^ n) target middle * K middle source ≠ 0 := by
      exact not_forall.mp fun hall =>
        h (Finset.sum_eq_zero fun middle _ => hall middle)
    exact HasKernelPath.cons
      (by simpa using (mul_ne_zero_iff.mp hmiddle).2)
      (ih _ _ (by simpa using (mul_ne_zero_iff.mp hmiddle).1))

/-- Primitive nonzero entries obey a supplied directed step relation. -/
def KernelSupportedOn
    (K : Matrix V V Real) (step : V -> V -> Prop) : Prop :=
  ∀ target source, K target source ≠ 0 -> step source target

omit [Fintype V] [DecidableEq V] in
/-- A kernel path transports pointwise to any relation supporting all
primitive nonzero entries. -/
theorem HasKernelPath.toRelationPath
    (K : Matrix V V Real) (step : V -> V -> Prop)
    (hSupport : KernelSupportedOn K step) :
    ∀ {n : Nat} {source target : V},
      HasKernelPath K n source target ->
        HasRelationPath step n source target := by
  intro n source target h
  induction h <;> tauto

/-- A nonzero matrix-power entry yields an explicit path in every declared
primitive support relation. -/
theorem matrixPower_entry_ne_zero_has_supportedPath
    (K : Matrix V V Real) (step : V -> V -> Prop)
    (hSupport : KernelSupportedOn K step)
    (n : Nat) (source target : V)
    (hPower : (K ^ n) target source ≠ 0) :
    HasRelationPath step n source target := by
  exact HasKernelPath.toRelationPath K step hSupport
    (matrixPower_entry_ne_zero_hasKernelPath K n source target hPower)

omit [Fintype V] [DecidableEq V] in
/-- A positive-length path whose primitive steps imply a transitive ambient
relation places its source before its target. -/
theorem HasRelationPath.implies_transitive_relation
    (step before : V -> V -> Prop)
    (hStep : ∀ {source target}, step source target -> before source target)
    (hTransitive : ∀ {x y z}, before x y -> before y z -> before x z) :
    ∀ {n : Nat} {source target : V},
      HasRelationPath step (n + 1) source target -> before source target := by
  intros n source target h
  induction' n with n ih generalizing source target
  · cases h
    cases ‹HasRelationPath step 0 _ _›
    exact hStep ‹_›
  · obtain ⟨_, _, _, _, _⟩ := h
    exact hTransitive (hStep ‹_›) (ih ‹_›)

/-- Primitive three-event link kernel `0 -> 1 -> 2`. -/
def threeLinkKernel : Matrix (Fin 3) (Fin 3) Real :=
  !![0, 0, 0; 1, 0, 0; 0, 1, 0]

/-- Directed nearest-neighbor step on the three-event chain. -/
def threeLinkStep (source target : Fin 3) : Prop :=
  source.val + 1 = target.val

/-- Nonvacuous control: the primitive endpoint entry is zero, its square is
nonzero, and path extraction returns a two-step primitive chain. -/
theorem threeLink_square_nonzero_and_supportedPath :
    threeLinkKernel 2 0 = 0 ∧
      (threeLinkKernel ^ 2) 2 0 ≠ 0 ∧
      HasRelationPath threeLinkStep 2 0 2 := by
  constructor
  · change (0 : Real) = 0
    rfl
  constructor
  · simp +decide [threeLinkKernel, pow_two, Matrix.mul_apply,
      Fin.sum_univ_succ]
  · exact HasRelationPath.cons (middle := 1) (by rfl)
      (HasRelationPath.cons (middle := 2) (by rfl) (HasRelationPath.nil 2))

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction.matrixPower_entry_ne_zero_hasKernelPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matrixPower_entry_ne_zero_hasKernelPath

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction.matrixPower_entry_ne_zero_has_supportedPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matrixPower_entry_ne_zero_has_supportedPath

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction.threeLink_square_nonzero_and_supportedPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLink_square_nonzero_and_supportedPath

end PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction

end
