# Hamming E8 SPL theta bridge Aristotle job - 2026-05-15

Status: submitted to Aristotle.

Purpose: replace the broad "prove `Theta_E8 = E4`" target with the narrower
coefficient bridge left after importing Sphere-Packing-Lean's existing
level-one identity.

## Local work completed before submission

Added:

```text
PhysicsSM/Draft/E8ThetaSPLBridge.lean
```

This file proves:

- coefficientwise casting `PowerSeries Int -> PowerSeries Complex` is injective;
- the local formal `e4Series` from
  `PhysicsSM.Draft.E8ThetaModularAristotle` matches SPL's `qExpansion 1 E₄`
  after casting coefficients to `Complex`;
- SPL's theorem `SpherePacking.ModularForms.E₄_eq_thetaE4` identifies that
  q-expansion with the q-expansion of `SpherePacking.ModularForms.thetaE4`;
- the local Construction A theta coefficients are the Hamming
  weight-distribution convolution from
  `PhysicsSM.Coding.ConstructionAThetaConvolution`;
- therefore the full local integer identity
  `E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series` follows from a
  single coefficient bridge:

```lean
∀ n : Nat,
  PowerSeries.coeff n splThetaE4Series =
    (hammingThetaConvolutionCoeff n : Complex)
```

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-spl-theta-bridge-20260515-project
```

The package is source-only and contains:

- `PhysicsSM/`
- `PhysicsSM.lean`
- `PhysicsSMDraft.lean`
- a minimal `PhysicsSMSPL.lean`
- `lean-toolchain`
- `lakefile.toml`
- `lake-manifest.json`
- `AGENTS.md`
- `README.md`
- the Windows-safe SPL fork source slice needed for modular forms

The package intentionally excludes:

- `.lake`
- `.git`
- old Aristotle output
- unrelated SPL `Dim8`/`Dim24` sources, which are not needed for this modular
  forms coefficient job and contain Windows long-path hazards.

The package-local SPL root `SpherePacking.lean` was minimized to:

```lean
import SpherePacking.ModularForms.Lv1Lv2Identities
```

## Aristotle target file

```text
PhysicsSM/Draft/E8ThetaSPLBridgeAristotle.lean
```

Main target:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff
    (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

The file contains one intentional `sorry` for this theorem.  It also contains
the immediate consequence:

```lean
theorem thetaSeries_eq_e4Series_from_spl_thetaE4 :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

which closes by applying the reduction theorem from
`PhysicsSM.Draft.E8ThetaSPLBridge`.

## Submitted job

| Job | Aristotle ID | Status |
|-----|--------------|--------|
| SPL theta-polynomial coefficient bridge | `9215f082-2baa-4e13-837c-9335ddf88aad` | in progress, 1% at submission check |

## Local verification

```text
lake env lean PhysicsSM/Draft/E8ThetaSPLBridge.lean
lake build SpherePacking.ModularForms.Lv1Lv2Identities
lake build PhysicsSMSPL
lake env lean AgentTasks/aristotle-submit/hamming-e8-spl-theta-bridge-20260515-project/PhysicsSM/Draft/E8ThetaSPLBridgeAristotle.lean
aristotle list
```

Results:

- `E8ThetaSPLBridge.lean` passed.
- `SpherePacking.ModularForms.Lv1Lv2Identities` passed.
- `PhysicsSMSPL` passed with preexisting linter warnings and preexisting draft
  `sorry` warnings outside the new bridge file.
- the package handoff file parsed from the main checkout and reported exactly
  the intentional `sorry` in the Aristotle target theorem.
- `aristotle list` confirmed job `9215f082-2baa-4e13-837c-9335ddf88aad` was
  created and `IN_PROGRESS`.

## Expected difficulty

SPL already proves the analytic modular-form identity `E₄ = thetaE4`, but the
local fork does not appear to expose direct q-expansion coefficient formulas
for `H₂`, `H₄`, or `thetaE4`.  If Aristotle cannot prove the full bridge, useful
partial output would be a small conditional theorem isolating those missing
theta-constant q-expansion facts.

## Result review - 2026-05-16

Aristotle job `9215f082-2baa-4e13-837c-9335ddf88aad` finished with status
`COMPLETE_WITH_ERRORS`.

Downloaded artifact:

```text
AgentTasks/aristotle-output/hamming-e8-spl-theta-bridge-20260516-result
```

Extracted artifact:

```text
AgentTasks/aristotle-output/hamming-e8-spl-theta-bridge-20260516-extracted/
```

Useful result integrated into:

```text
PhysicsSM/Draft/E8ThetaSPLBridge.lean
```

The job proved the SPL-side coefficient theorem:

```lean
theorem splThetaE4Series_coeff_eq_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (ArithmeticFunction.sigma 3 n : Complex)
```

This is mathematically useful because it confirms that the SPL theta-polynomial
q-expansion is already identified with the normalized Eisenstein `E4`
q-expansion. I added the local `sigma3` restatement:

```lean
theorem splThetaE4Series_coeff_eq_local_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (sigma3 n : Complex)
```

and the reduction theorem:

```lean
theorem thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff
    (hcount : forall n : Nat,
      hammingThetaConvolutionCoeff n =
        if n = 0 then 1 else 240 * sigma3 n) :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

The original main target remains open. After this result, the remaining gap is
purely the all-coefficient Construction A count:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

The result summary also noted a stack-overflow issue in heavy native evaluation
paths. I added `moreLeanArgs = ["-s65536"]` to the local Lean libraries in
`lakefile.toml`, matching the stack setting used in the returned job.
