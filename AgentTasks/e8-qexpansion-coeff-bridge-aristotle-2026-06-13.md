# Aristotle task: Hamming E8 q-expansion Coefficient Bridge

Date: 2026-06-13

## Goal

Fill the single remaining `sorry` in:

```text
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
```

targeting:

```lean
hammingThetaConstantPolynomial_qExpansion_coeff
```

## Mathematical Intent

This is the q-expansion coefficient bridge: prove that the q-expansion of the analytic Hamming theta-constant polynomial `Theta3(2*tau)^8 + 14*Theta3(2*tau)^4*Theta2(2*tau)^4 + Theta2(2*tau)^8` has coefficients matching the combinatorial Construction A Hamming convolution `hammingThetaConvolutionCoeff n`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
```

Axiom check on finished targets: only `[propext, Classical.choice, Quot.sound]`.

## Submission

```yaml
aristotle:
  job_id: 7850c0f0-fbd5-44c7-9224-86e9a5870ce7
  target_file: PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
  expected_module: PhysicsSM.Draft.E8ThetaQExpansionBridgeAristotle
  submission_project: AgentTasks/aristotle-submit/e8-qexpansion-coeff-bridge-20260613-project
  output_dir: AgentTasks/aristotle-output/7850c0f0-fbd5-44c7-9224-86e9a5870ce7
  status: integrated

```
