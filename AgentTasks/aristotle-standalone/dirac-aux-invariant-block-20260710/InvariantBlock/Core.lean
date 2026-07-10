import Mathlib

open scoped BigOperators ComplexConjugate

namespace InvariantBlock

abbrev DiracSpace := Fin 4 -> ℂ
abbrev AuxiliarySpace := Fin 2 -> ℂ
abbrev SixBlock := DiracSpace × AuxiliarySpace

noncomputable def inner4 (x y : DiracSpace) : ℂ :=
  ∑ i, conj (x i) * y i

noncomputable def inner2 (x y : AuxiliarySpace) : ℂ :=
  ∑ i, conj (x i) * y i

noncomputable def inner6 (x y : SixBlock) : ℂ :=
  inner4 x.1 y.1 + inner2 x.2 y.2

def includeDirac : DiracSpace -> SixBlock :=
  fun v => (v, 0)

def blockCoin (H : DiracSpace -> DiracSpace)
    (A : AuxiliarySpace -> AuxiliarySpace) : SixBlock -> SixBlock :=
  fun x => (H x.1, A x.2)

theorem include_dirac_injective : Function.Injective includeDirac := by
  sorry

theorem include_dirac_isometry (v w : DiracSpace) :
    inner6 (includeDirac v) (includeDirac w) = inner4 v w := by
  sorry

/-- The four-component factor is invariant and carries exactly the supplied
Dirac evolution, while two auxiliary channels remain explicit. -/
theorem dirac_block_intertwiner
    (H : DiracSpace -> DiracSpace)
    (A : AuxiliarySpace -> AuxiliarySpace) (v : DiracSpace) :
    blockCoin H A (includeDirac v) = includeDirac (H v) := by
  sorry

/-- A genuinely nonzero auxiliary vector lies outside the embedded Dirac
factor. -/
theorem auxiliary_outside_control :
    (0, (![1, 0] : AuxiliarySpace)) ∉ Set.range includeDirac := by
  sorry

end InvariantBlock
