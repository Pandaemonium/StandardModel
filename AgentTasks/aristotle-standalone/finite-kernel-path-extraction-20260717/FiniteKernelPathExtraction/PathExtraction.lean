import Mathlib

/-!
# Finite matrix-power path extraction

This focused handoff asks for the exact path semantics of a nonzero finite
matrix-power entry. Matrix rows are targets and columns are sources.

`HasKernelPath K n source target` records `n` composable nonzero primitive
entries of `K`. `HasRelationPath step n source target` records the same path in
an arbitrary declared step relation. The headline theorem should extract the
former from `(K ^ n) target source != 0`; the remaining theorems transport the
path to a declared relation and collapse a positive-length path under a
transitive ambient precedence relation.

The real coefficient field is intentional. No positivity assumption is used:
a nonzero finite sum has a nonzero summand, and a nonzero product has nonzero
factors.
-/

noncomputable section

namespace FiniteKernelPathExtraction

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- An explicit chain of nonzero primitive target-source entries of `K`. -/
inductive HasKernelPath (K : Matrix V V Real) : Nat -> V -> V -> Prop
  | nil (vertex : V) : HasKernelPath K 0 vertex vertex
  | cons {n : Nat} {source middle target : V}
      (edge : K middle source != 0)
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
    forall (n : Nat) (source target : V),
      (K ^ n) target source != 0 -> HasKernelPath K n source target := by
  sorry

/-- Primitive nonzero entries obey a supplied directed step relation. -/
def KernelSupportedOn
    (K : Matrix V V Real) (step : V -> V -> Prop) : Prop :=
  forall target source, K target source != 0 -> step source target

/-- A kernel path transports pointwise to any relation supporting all
primitive nonzero entries. -/
theorem HasKernelPath.toRelationPath
    (K : Matrix V V Real) (step : V -> V -> Prop)
    (hSupport : KernelSupportedOn K step) :
    forall {n : Nat} {source target : V},
      HasKernelPath K n source target ->
        HasRelationPath step n source target := by
  sorry

/-- Headline composition: a nonzero matrix-power entry yields an explicit
path in every declared primitive support relation. -/
theorem matrixPower_entry_ne_zero_has_supportedPath
    (K : Matrix V V Real) (step : V -> V -> Prop)
    (hSupport : KernelSupportedOn K step)
    (n : Nat) (source target : V)
    (hPower : (K ^ n) target source != 0) :
    HasRelationPath step n source target := by
  sorry

/-- A positive-length path whose primitive steps imply a transitive ambient
relation places its source before its target. -/
theorem HasRelationPath.implies_transitive_relation
    (step before : V -> V -> Prop)
    (hStep : forall {source target}, step source target -> before source target)
    (hTransitive : forall {x y z}, before x y -> before y z -> before x z) :
    forall {n : Nat} {source target : V},
      HasRelationPath step (n + 1) source target -> before source target := by
  sorry

/-- Primitive three-event link kernel `0 -> 1 -> 2`. -/
def threeLinkKernel : Matrix (Fin 3) (Fin 3) Real :=
  !![0, 0, 0; 1, 0, 0; 0, 1, 0]

/-- Directed nearest-neighbor step on the three-event chain. -/
def threeLinkStep (source target : Fin 3) : Prop :=
  source.val + 1 = target.val

/-- Nonvacuous control: the primitive endpoint entry is zero, its square is
nonzero, and path extraction returns a two-step primitive chain. -/
theorem threeLink_square_nonzero_and_supportedPath :
    threeLinkKernel 2 0 = 0 /\
      (threeLinkKernel ^ 2) 2 0 != 0 /\
      HasRelationPath threeLinkStep 2 0 2 := by
  sorry

end FiniteKernelPathExtraction

end
