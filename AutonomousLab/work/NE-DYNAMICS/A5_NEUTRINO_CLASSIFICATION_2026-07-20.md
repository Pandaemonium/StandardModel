# Neutrino mass operator classification (gate A5)

The formalization is in `RequestProject/Main.lean` under the namespace
`NeutrinoMass`.

## Classification

1. **Minimal left-handed content.** `OddBlock K VL VR` records the two
   chirality-odd off-diagonal maps. With `VR = Fin 0 → K`,
   `oddBlock_rightSlot_zero` proves that every such block equals zero, and
   `oddAction_rightSlot_zero` proves that its action on `VL × VR` is the zero
   linear map. Separately, `leftNeutrino_renormalizableMajorana_forbidden`
   models hypercharge invariance as vanishing total additive charge and proves
   that two fields of hypercharge `-1/2` cannot form an invariant bilinear.

2. **Right-handed singlet / Dirac branch.** After replacing the empty slot by
   the one-dimensional complex space `Fin 1 → ℂ`,
   `oneGenerationDiracTurn` is the identity linear map and
   `oneGenerationDiracTurn_nonzero` proves it is nonzero.

3. **Majorana / Weinberg branch.** `weinbergProfile` records the
   `(L H)(L H)/Λ` operator as dimension five, non-renormalizable, dependent on
   a heavy scale, Majorana, and lepton-number violating by two units.
   `diracProfile` instead records the renormalizable Dirac branch as preserving
   fermion number. `dirac_weinberg_classification` proves these profile facts.
   These fields encode the standard operator interpretation: after electroweak
   symmetry breaking, the Weinberg operator produces an effective Majorana
   mass.

4. **Finite seesaw.** For the real symmetric one-generation matrix
   `[[0,mD],[mD,MR]]`, `seesaw_schur_complement` identifies the light Schur
   complement as `-(mD^2/MR)`. For `MR ≠ 0`,
   `seesaw_block_diagonalization` proves this by explicit triangular congruence.
   `seesaw_approximation_controlled` proves that when `|mD/MR| ≤ ε`, the heavy
   component of the residual for the standard approximate light vector is at
   most `ε` times the magnitude of the approximate light mass.

`complete_four_branch_classification` collects all four branches in one
parameterized theorem.

## Verification and axioms

The project builds with Mathlib using `lake build RequestProject`. The Lean
sources contain no `sorry`, `admit`, new `axiom`, `opaque`, `unsafe`, or
`native_decide` declarations.

Axiom inspection of the principal classification and seesaw theorems reports
only the standard Mathlib axioms:

- `propext`
- `Classical.choice`
- `Quot.sound`

The minimal empty-slot block theorem itself needs only `propext` and
`Quot.sound`.

## Source anchors

The physical classification follows the supplied anchors: the dimension-five
operator of Weinberg (1979), `(L H)(L H)/Λ`, and the finite seesaw block
interpretation associated with Connes et al., *Gravity and the standard model
with neutrino mixing* (arXiv:hep-th/0610241).
