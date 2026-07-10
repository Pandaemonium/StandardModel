import PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition

/-!
# A four-plus-two invariant block architecture

After choosing coordinates `C^6 ~= C^4 x C^2`, the canonical inclusion of the
four-component factor is injective and isometric. A block-diagonal evolution
intertwines that inclusion whenever the auxiliary evolution fixes zero, and a
nonzero two-component auxiliary vector lies outside the embedded factor.

This is the constructive architecture demanded by the six-versus-four rank
obstruction. It does not prove that `ExplicitSixChannelCoin.axisBlockCoin`, the
D4 shift, or the Clifford symbol is conjugate to this block form. That concrete
coin-and-shift invariance theorem remains open.

Provenance: the corrected block-intertwiner proof was completed by Aristotle
project `4475a2ed-fef9-4239-af57-c5516772ab87`. Aristotle identified that the
unrestricted statement for an arbitrary auxiliary function was false; the
necessary condition `A 0 = 0` is displayed here. Project composition added on
2026-07-10.
-/

open scoped BigOperators ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.SixFourInvariantBlock

open PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition

abbrev SixBlock := DiracSpace × AuxiliarySpace

noncomputable def inner4 (x y : DiracSpace) : Complex :=
  ∑ i, conj (x i) * y i

noncomputable def inner2 (x y : AuxiliarySpace) : Complex :=
  ∑ i, conj (x i) * y i

noncomputable def inner6 (x y : SixBlock) : Complex :=
  inner4 x.1 y.1 + inner2 x.2 y.2

def includeDirac : DiracSpace → SixBlock :=
  fun v => (v, 0)

def blockCoin (H : DiracSpace → DiracSpace)
    (A : AuxiliarySpace → AuxiliarySpace) : SixBlock → SixBlock :=
  fun x => (H x.1, A x.2)

theorem include_dirac_injective : Function.Injective includeDirac := by
  intro a b h
  simpa [includeDirac] using congrArg Prod.fst h

theorem include_dirac_isometry (v w : DiracSpace) :
    inner6 (includeDirac v) (includeDirac w) = inner4 v w := by
  simp [inner6, includeDirac, inner2]

/-- The four-component factor is invariant under a supplied block evolution.
The condition `A 0 = 0` is automatic for a linear auxiliary coin. -/
theorem dirac_block_intertwiner
    (H : DiracSpace → DiracSpace)
    (A : AuxiliarySpace → AuxiliarySpace) (hA : A 0 = 0)
    (v : DiracSpace) :
    blockCoin H A (includeDirac v) = includeDirac (H v) := by
  simp [blockCoin, includeDirac, hA]

/-- A genuinely nonzero auxiliary vector lies outside the embedded Dirac
factor. -/
theorem auxiliary_outside_control :
    (0, (![1, 0] : AuxiliarySpace)) ∉ Set.range includeDirac := by
  rintro ⟨v, hv⟩
  have h2 := congrArg (fun p => p.2 0) hv
  simp [includeDirac] at h2

noncomputable def includeDiracDirection
    (e : DirectionSpace ≃ₗ[Complex] SixBlock) (v : DiracSpace) :
    DirectionSpace :=
  e.symm (includeDirac v)

noncomputable def directionBlockCoin
    (e : DirectionSpace ≃ₗ[Complex] SixBlock)
    (H : DiracSpace → DiracSpace)
    (A : AuxiliarySpace → AuxiliarySpace) : DirectionSpace → DirectionSpace :=
  fun x => e.symm (blockCoin H A (e x))

/-- In any chosen `4+2` coordinates, the induced six-channel block evolution
intertwines the embedded four-component factor. -/
theorem direction_block_intertwiner
    (e : DirectionSpace ≃ₗ[Complex] SixBlock)
    (H : DiracSpace → DiracSpace)
    (A : AuxiliarySpace → AuxiliarySpace) (hA : A 0 = 0)
    (v : DiracSpace) :
    directionBlockCoin e H A (includeDiracDirection e v) =
      includeDiracDirection e (H v) := by
  simp [directionBlockCoin, includeDiracDirection,
    dirac_block_intertwiner H A hA v]

/-- The direction space admits a chosen four-component inclusion and a
nonzero auxiliary state outside it. -/
theorem direction_has_four_plus_two_block :
    ∃ e : DirectionSpace ≃ₗ[Complex] SixBlock,
      Function.Injective (includeDiracDirection e) ∧
        e.symm (0, (![1, 0] : AuxiliarySpace)) ∉
          Set.range (includeDiracDirection e) := by
  obtain ⟨e⟩ := four_plus_two_decomposition
  refine ⟨e, e.symm.injective.comp include_dirac_injective, ?_⟩
  rintro ⟨v, hv⟩
  apply auxiliary_outside_control
  exact ⟨v, e.symm.injective hv⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourInvariantBlock.direction_block_intertwiner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms direction_block_intertwiner

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourInvariantBlock.direction_has_four_plus_two_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms direction_has_four_plus_two_block

end PhysicsSM.Draft.NullEdge.SixFourInvariantBlock
