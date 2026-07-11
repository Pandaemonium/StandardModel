import PhysicsSM.Draft.NullEdge.GradedDecompUniqueness

/-!
# Uniqueness from two separating sign gradings

Chirality alone gives only an odd/even split. This module proves the positive
classification control: if two internal decompositions are graded by the same
pair of sign operators, then the joint decomposition is unique. The proof
combines the signs into one operator with four distinct eigenvalues and applies
the existing graded-decomposition uniqueness theorem.

The theorem is intentionally conditional. It does not assert that solder
degree, edge exchange, locality, or another physically intrinsic second
grading has already been constructed for every carrier.

Provenance: theorem design and proof returned by Aristotle project
`cb571b0d-b79a-41a2-ad6a-3294b9c13a76`, then adapted to the live project
namespace and independently checked. It reuses Mathlib direct-sum/eigenspace
infrastructure through `NullEdgeCloser.decomposition_unique`.
-/

namespace PhysicsSM.Draft.NullEdge.ChannelSelectorUniqueness

/-- Sign associated with a Boolean sector label. -/
def sgn (b : Bool) : ℝ := if b then 1 else -1

/-- The combined grade `sgn i + 2 * sgn j` separates all four sign sectors. -/
theorem sgn_grade_injective :
    Function.Injective (fun ij : Bool × Bool => sgn ij.1 + 2 * sgn ij.2) := by
  rintro ⟨a1, a2⟩ ⟨b1, b2⟩ h
  cases a1 <;> cases a2 <;> cases b1 <;> cases b2 <;>
    simp_all [sgn] <;> norm_num at h

/-- Two internal decompositions graded by the same pair of sign operators
coincide. Acting by the displayed scalars already supplies the required joint
sector structure; no separate commutativity hypothesis is needed. -/
theorem two_sign_gradings_decomposition_unique
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (P Q : Module.End ℝ V)
    (W W' : Bool × Bool → Submodule ℝ V)
    (hInt : DirectSum.IsInternal W) (hInt' : DirectSum.IsInternal W')
    (hPW : ∀ ij, ∀ x ∈ W ij, P x = sgn ij.1 • x)
    (hQW : ∀ ij, ∀ x ∈ W ij, Q x = sgn ij.2 • x)
    (hPW' : ∀ ij, ∀ x ∈ W' ij, P x = sgn ij.1 • x)
    (hQW' : ∀ ij, ∀ x ∈ W' ij, Q x = sgn ij.2 • x) :
    W = W' := by
  let D : Module.End ℝ V := P + (2 : ℝ) • Q
  refine NullEdgeCloser.decomposition_unique D
    (fun ij => sgn ij.1 + 2 * sgn ij.2) sgn_grade_injective W W' hInt hInt' ?_ ?_
  · intro ij x hx
    have hp := hPW ij x hx
    have hq := hQW ij x hx
    change (P + (2 : ℝ) • Q) x = _
    simp [hp, hq]
    module
  · intro ij x hx
    have hp := hPW' ij x hx
    have hq := hQW' ij x hx
    change (P + (2 : ℝ) • Q) x = _
    simp [hp, hq]
    module

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorUniqueness.sgn_grade_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sgn_grade_injective

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_sign_gradings_decomposition_unique

end PhysicsSM.Draft.NullEdge.ChannelSelectorUniqueness
