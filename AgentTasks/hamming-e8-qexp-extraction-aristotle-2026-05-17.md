# Hamming E8 q-expansion extraction Aristotle job - 2026-05-17

Status: COMPLETE, integrated into the repo.

Purpose: close the last transport gap in the Hamming Construction A
`Theta_E8 = E4` route.

## Current state

The previous out-of-budget job `a7562d4b-901e-4cb2-9da7-f36066da7c3d`
returned a useful helper.  It has been integrated as:

```text
PhysicsSM/Draft/E8ShellBridgeHelper.lean
```

That helper proves the shell-count transport.  Consequently
`PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean` now proves:

```lean
theorem constructionAShellSet_ncard_eq_e8Shell (n : ℕ) :
    Set.ncard (constructionAShellSet (4 * n)) =
      Set.ncard {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)}
```

The remaining proof hole is the analytic q-expansion extraction theorem below.

## Primary target

File:

```text
PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean
```

Namespace:

```lean
namespace PhysicsSM.Coding.E8ThetaMFBridge
```

Theorem:

```lean
theorem thetaE8_MF_qExpansion_coeff_eq_e8Shell (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) thetaE8_MF).coeff n =
      (Set.ncard {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)} : ℂ)
```

Do not change this statement unless the current statement is mathematically
wrong.  Do not introduce axioms, `opaque`, or `unsafe`.

## Relevant local facts

From `PhysicsSM/Draft/E8ThetaDim8MF.lean`:

```lean
noncomputable def thetaTerm8 (τ : ℂ) (z : E8Lattice) : ℂ
noncomputable def thetaSeries8 (τ : ℂ) : ℂ
noncomputable def thetaSeriesUHP8 (z : UpperHalfPlane) : ℂ
theorem summable_thetaTerm8 {τ : ℂ} (hτ : 0 < τ.im)
theorem thetaE8_MF_apply (z : UpperHalfPlane) :
    thetaE8_MF z = thetaSeriesUHP8 z
theorem e8_evenNormSq :
    ∀ v : ℝ⁸, v ∈ E8Lattice → ∃ n : ℕ, ‖v‖ ^ 2 = (2 : ℝ) * n
```

From `PhysicsSM/Draft/E8ShellBridgeHelper.lean`:

```lean
theorem E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell
```

This shell-count theorem is already integrated.  This job should not spend
time reproving it.

## SPL blueprint

The closest existing SPL proof is the dimension-24 coefficient-2 theorem:

```text
SpherePacking/Dim24/Uniqueness/Rigidity/Classify/Niemeier/RootlessCase/QExpansionCoeffTwo.lean
```

Main blueprint declaration:

```lean
NiemeierRootless.qExpansion_coeff_two_thetaSeries_eq_thetaCoeff
```

That proof uses these helper lemmas from:

```text
SpherePacking/Dim24/Uniqueness/Rigidity/Classify/Niemeier/RootlessCase/ThetaEquality.lean
```

Important helper names:

```lean
ModularFormClass.qExpansion_coeff_eq_intervalIntegral
qParamPowInvMulThetaTerm_fun_eq_exp
intervalIntegral_tsum_intervalIntegral_qParamPowInvMulThetaTerm_eq
exp_mul_add_I_split
intervalIntegral_cexp_two_pi_mul_I_int_mul_add_I_eq_zero_of_ne_zero
```

The desired dimension-8/all-`n` proof should follow the same structure:

1. Use `qExpansion_coeff_eq_intervalIntegral` for coefficient `n`.
2. Rewrite `thetaE8_MF` using `thetaE8_MF_apply`, `thetaSeriesUHP8`, and
   `thetaSeries8`.
3. Swap the interval integral with the theta-series `tsum`, using the
   summability/majorant facts from `E8ThetaDim8MF`.
4. For each `z : E8Lattice`, use `e8_evenNormSq` to write
   `‖(z : ℝ⁸)‖ ^ 2 = 2*m`; the term integrates to `1` exactly when `m = n`
   and to `0` otherwise.
5. Convert the resulting `tsum` of an indicator over the finite shell into
   `Set.ncard {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)}`.

## Useful fallback targets

If the full theorem runs out of reach, useful progress would be any of these
sorry-free helpers, preferably in `E8ThetaMFBridgeAristotle.lean` or a small
new helper file:

```lean
lemma qParamPowInvMulThetaTerm8_fun_eq_exp ...
lemma intervalIntegral_tsum_intervalIntegral_qParamPowInvMulThetaTerm8_eq ...
lemma e8Shell_indicator_tsum_eq_ncard ...
lemma thetaE8_MF_qExpansion_coeff_eq_e8Shell_of_integral_swap ...
```

Please leave a precise handoff note if any proof hole remains.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-e8-qexp-extraction-20260517-project
```

Planned package command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-e8-qexp-extraction-20260517 -TaskNote AgentTasks/hamming-e8-qexp-extraction-aristotle-2026-05-17.md -CheckPath PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean,PhysicsSM/Draft/E8ThetaDim8MF.lean,PhysicsSM/Draft/E8ShellBridgeHelper.lean,PhysicsSM/Draft/E8ThetaMFBridgeHelper.lean
```

Package checks:

```text
No .lake/.git/local output state: checked
No compiled .olean/.ilean artifacts: checked
SpherePacking remote: https://github.com/Pandaemonium/Sphere-Packing-Lean @ windows-safe-auxiliary-renames
PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean: proof-sorry-lines=1
PhysicsSM/Draft/E8ThetaDim8MF.lean: proof-sorry-lines=0
PhysicsSM/Draft/E8ShellBridgeHelper.lean: proof-sorry-lines=0
PhysicsSM/Draft/E8ThetaMFBridgeHelper.lean: proof-sorry-lines=0
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| E8 theta q-expansion extraction | `1e9f1085-b85c-4eb8-b5b6-925ab6eaee58` | COMPLETE |

Result fetch command:

```text
aristotle result 1e9f1085-b85c-4eb8-b5b6-925ab6eaee58 --destination AgentTasks/aristotle-output/hamming-e8-qexp-extraction-20260517
```

## Integration result

Integrated files:

```text
PhysicsSM/Draft/E8QExpansionExtraction.lean
PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean
```

The job proved `thetaE8_MF_qExpansion_coeff_eq_e8Shell` by adding a generic
q-expansion extraction helper for lattice theta series.  The existing
`constructionAShellSet_ncard_eq_e8Shell` bridge and this new extraction theorem
now give a sorry-free proof path for:

```lean
E8ThetaMFBridge.hammingThetaConvolutionCoeff_eq_e4Coeff_via_MF
E8ThetaSPLBridge.hammingThetaConvolutionCoeff_eq_e4Coeff
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/E8QExpansionExtraction.lean
lake env lean PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean
lake build PhysicsSM.Draft.E8QExpansionExtraction PhysicsSM.Draft.E8ThetaMFBridgeAristotle PhysicsSM.Draft.E8ThetaCoeffGapAristotle
lake build PhysicsSMDraft
```

Known remaining draft sorries are in older alternate-route files:

```text
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
PhysicsSM/Draft/ThetaDuplicationIdentities.lean
```
