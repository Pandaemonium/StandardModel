import PhysicsSM.Draft.H3OSpectralInvariants

/-!
# Closed form of `sigmaH3O` (P7 flagship, brick-D interface lemma)

**Status: DRAFT.** `sigmaH3O` is defined spectrally as
`(1/2)((tr X)^2 - tr (X o X))`. The flagship composition (brick D: the
unconditional real-spectrum theorem, fed by the Aristotle reduction lemmas
`h3o-reduction-lemmas-20260718` / d3298b14) matches invariants against the
complex-witness Hermitian data, which is stated in the CLOSED form. This
module proves the two forms agree:

  `sigmaH3O X = alpha*beta + beta*gamma + gamma*alpha
                - |x|^2 - |y|^2 - |z|^2`

with `|.|^2 = Octonion.normSq = octonionInner` with itself (coordinate sum
of squares). Mechanical expansion of the Jordan product diagonal.
-/

noncomputable section

namespace PhysicsSM.Draft.H3OSigmaClosedForm

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Draft.H3OCharacteristicEquation

/-- The spectral `sigmaH3O` equals the closed Freudenthal form. -/
theorem sigmaH3O_closed_form (X : H3O) :
    sigmaH3O X
      = X.alpha * X.beta + X.beta * X.gamma + X.gamma * X.alpha
        - PhysicsSM.Algebra.Octonion.normSq X.x
        - PhysicsSM.Algebra.Octonion.normSq X.y
        - PhysicsSM.Algebra.Octonion.normSq X.z := by
  unfold sigmaH3O
  simp [trace, jordanProduct, octonionInner,
    PhysicsSM.Algebra.Octonion.normSq]
  ring

/-- info: 'PhysicsSM.Draft.H3OSigmaClosedForm.sigmaH3O_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3OSigmaClosedForm.sigmaH3O_closed_form

end PhysicsSM.Draft.H3OSigmaClosedForm
