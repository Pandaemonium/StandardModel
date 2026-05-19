# Hamming E8 shell bridge no-native basis job - 2026-05-18

Status: submitted to Aristotle.

Purpose: remove the `Lean.trustCompiler` dependency from the Construction A
basis reconstruction part of the E8 shell-count bridge.

## Target file

```text
PhysicsSM/Draft/E8BasisSpanningNoNativeAristotle.lean
```

## Primary targets

Please prove the following declarations without using `native_decide`,
`unsafe`, `axiom`, or new opaque placeholders:

```lean
theorem basisLinearCombination_reconstruction_no_native
    (z : Fin 8 -> Int) (hz : z ∈ hammingConstructionALattice) :
    ∀ j : Fin 8,
      z j = ∑ i : Fin 8, basisLinearCombination z i * e8CodeBasisInt i j

theorem e8CodeBasisInt_spans_hammingConstructionALattice_no_native
    (z : Fin 8 -> Int) (hz : z ∈ hammingConstructionALattice) :
    z ∈ Submodule.span Int (Set.range e8CodeBasisInt)
```

The parity/divisibility lemmas above them are useful subtargets and may be
proved first.

## Important trust constraint

Do not close these targets by using the existing theorem
`basisLinearCombination_reconstruction`, because that theorem currently
depends on `native_decide` and hence `Lean.trustCompiler`.

At the end, please run or report:

```lean
#print axioms PhysicsSM.Coding.basisLinearCombination_reconstruction_no_native
#print axioms PhysicsSM.Coding.e8CodeBasisInt_spans_hammingConstructionALattice_no_native
```

The expected axiom set should contain only standard Lean foundations such as
`propext`, `Classical.choice`, and `Quot.sound`; it should not contain
`Lean.trustCompiler`.

## Proof sketch

The old proof used finite enumeration over the 256 binary words.  A structural
proof should instead:

1. Use `mem_e8IntLattice_iff_parityCheck` to obtain
   `Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0`.
2. Expand the relevant parity-check row to get the four Hamming parity
   equations:
   * `w 1 + w 2 + w 3 + w 4 = 0`;
   * `w 0 + w 2 + w 3 + w 5 = 0`;
   * `w 0 + w 1 + w 3 + w 6 = 0`;
   * `w 0 + w 1 + w 2 + w 7 = 0`.
3. Convert those equalities in `ZMod 2` into integer divisibility by 2 using
   `ZMod.intCast_zmod_eq_zero_iff_dvd`.
4. Finish the reconstruction coordinate-by-coordinate with
   `Int.ediv_mul_cancel`, `fin_cases`, `ring`, `omega`, or `linarith`.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-e8-shell-no-native-basis-20260518-project
```

Planned command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-e8-shell-no-native-basis-20260518 -TaskNote AgentTasks/hamming-e8-shell-no-native-basis-aristotle-2026-05-18.md -CheckPath PhysicsSM/Draft/E8BasisSpanningNoNativeAristotle.lean
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| Basis reconstruction without native_decide | `45b7b33d-f38e-4835-b707-3ed57c76f8f0` | created |

## Integration result

Status: integrated on 2026-05-18.

Result package fetched with:

```text
aristotle result 45b7b33d-f38e-4835-b707-3ed57c76f8f0 --destination AgentTasks\aristotle-output\hamming-e8-shell-no-native-basis-20260518
```

Integrated file:

```text
PhysicsSM/Draft/E8BasisSpanningNoNativeAristotle.lean
```

The returned proof was preferred over the copy bundled in the final shell job,
because it is the dedicated basis job output and has the cleaner proof script.

Verification run after integration:

```text
lake env lean PhysicsSM\Draft\E8BasisSpanningNoNativeAristotle.lean
lake build PhysicsSM.Draft.E8BasisSpanningNoNativeAristotle PhysicsSM.Draft.E8TransitionMatrixNoNativeAristotle PhysicsSM.Draft.E8ShellBridgeNoNativeAristotle
lake build PhysicsSM.Draft.E8ThetaMFBridgeAristotle PhysicsSM.Draft.E8ThetaCoeffGapAristotle
```

Axiom checks for the integrated declarations report only the standard Lean
foundations `propext`, `Classical.choice`, and `Quot.sound`.
