# codex second-quantized channel budget, 2026-07-09 14:55

aristotle:
  project_id: f38356cf-7646-436f-8204-c0588069566c
  target_file: PhysicsSM/Draft/NullEdge/SecondQuantizedChannelBudget.lean
  expected_module: PhysicsSM.Draft.NullEdge.SecondQuantizedChannelBudget
  submission_project: AgentTasks/aristotle-submit/codex-second-quantized-channel-budget-1455-20260709-project
  output_dir: AgentTasks/aristotle-output/f38356cf-7646-436f-8204-c0588069566c
  status: submitted 2026-07-09 14:56 PDT

You are Aristotle. Build the strongest honest finite many-body lift of the
null-edge carrier's additive channel budget. This must add a real operator
identity, not merely conjoin already-landed theorems.

Target:

```text
PhysicsSM/Draft/NullEdge/SecondQuantizedChannelBudget.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare
import PhysicsSM.Draft.NullEdge.Carrier.FockMassGap
import PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction
import PhysicsSM.Draft.NullEdge.UnifiedMassBudget
```

Context pack:

```text
AgentTasks/context-packs/second-quantized-channel-budget-20260709-145510.md
```

## Primary theorem: exact additive second quantization

Work in `DGammaSquare`'s finite exterior algebra. Prove first that the global
derivation is additive in its one-particle operator, preferably as an equality
of linear maps on the entire exterior algebra:

```lean
theorem dGammaOp_add (A B : V ->ₗ[R] V) :
    dGammaOp (A + B) = dGammaOp A + dGammaOp B
```

If the strongest global statement requires a derivation-extensionality helper,
prove it by exterior-algebra induction from `dGammaOp_one`, `dGammaOp_ι`, and
`dGammaOp_mul`. Do not silently retreat to generators alone. Also prove scalar
linearity if supported by the current `CommRing` API:

```lean
dGammaOp_smul
dGammaOp_four_add
```

At minimum, an exact all-decomposable-wedges theorem is required if a genuine
global theorem is impossible under the current API; explain the exact blocker
rather than weakening the claim invisibly.

Use the result to prove the four-channel identity for arbitrary one-particle
endomorphisms `A C T E`:

```lean
dGammaOp (A + C + T + E) =
  dGammaOp A + dGammaOp C + dGammaOp T + dGammaOp E
```

This is the theorem-bearing content: an additive one-particle carrier budget
lifts exactly to every finite fermionic particle sector.

## Square/interference boundary

Prove an exact expansion showing that additivity of `dGammaOp` does **not** make
its square channelwise additive. For two channels, establish an operator or
pointwise identity of the form

```text
dGammaOp(A+B)^2 = dGammaOp(A)^2 + dGammaOp(B)^2
                  + dGammaOp(A)*dGammaOp(B)
                  + dGammaOp(B)*dGammaOp(A)
```

and give a small explicit nonzero cross-term witness (preferably over `R = Q`
or `Z`, on `V = Fin 2 -> R`, with a one-particle or two-particle decomposable
wedge). The witness must be exact and nondegenerate. This prevents prose from
claiming that four additive operator channels imply four noninteracting squared
mass contributions.

## Finite Fock gap and derived-interaction bridge

Bundle the new identities with the existing sharp facts, but keep the new
operator theorem primary:

1. `FockMassGap.secondQuantized_massGap`: the free occupation-basis gap equals
   the one-particle gap.
2. `DerivedInteraction.H2der_eq` / `derived_boundState_below_threshold`: the
   closure term lifts to a concrete off-diagonal two-body interaction and can
   bind below threshold in the excited-mode plane.
3. `DerivedInteraction.derived_wrongPlane_no_binding`: the ground-mode-plane
   closure has an exact weak-coupling obstruction.
4. Give an explicit rational/real `Fin 3` witness satisfying the strict binding
   hypotheses and, separately, one satisfying the no-binding hypotheses. Do not
   leave either existential behavior supported only by abstract inequalities.

Preferred public names:

```lean
dGammaOp_add
dGammaOp_smul
dGammaOp_four_add
dGammaOp_add_square_expansion
dGammaOp_cross_term_nonzero_witness
free_gap_and_derived_binding_packet
second_quantized_channel_budget_with_boundary
```

## Claim boundary and provenance

This is finite exterior algebra and finite matrix spectral theory only. It is
not a continuum Fock construction, interacting QFT, scattering theory, or a
derivation of physical Standard Model channel assignments. The channel maps are
generic endomorphisms until separately identified with carrier data.

PhysLean was consulted clean-room at:

```text
Physlib/QFT/PerturbationTheory/FieldStatistics/Basic.lean
Physlib/QFT/PerturbationTheory/Koszul/KoszulSignInsert.lean
Physlib/QFT/PerturbationTheory/CreateAnnihilate.lean
Physlib/QFT/PerturbationTheory/WickAlgebra/Basic.lean
Physlib/QFT/PerturbationTheory/WickAlgebra/Grading.lean
```

Those modules inform fermionic/Koszul/grading conventions but are version-pinned
away from this project and must not be imported. Use the local exterior-algebra
formalization. Add in-file build-enforced axiom-footprint guard pins for every
headline theorem, run the narrow target first, and finish with a short report of
statement changes, exact witnesses, and remaining boundaries.
