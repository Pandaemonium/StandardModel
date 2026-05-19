# Hamming E8 theta weight-enumerator bridge Aristotle job - 2026-05-16

Status: Aristotle completed; useful fallback integrated; primary bridge still
draft.

Purpose: follow up on Aristotle job
`a9a170c1-b4ec-4a0e-8468-ca2db69e6f75`, which returned useful small
coefficient cases but did not close the all-coefficient theorem
`Theta_E8 = E4`.

## Result integrated from the previous job

The useful partial output from job
`a9a170c1-b4ec-4a0e-8468-ca2db69e6f75` was integrated into:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Added checked lemmas:

```lean
theorem hammingThetaConvolutionCoeff_two :
    hammingThetaConvolutionCoeff 2 = 240 * sigma3 2

theorem hammingThetaConvolutionCoeff_three :
    hammingThetaConvolutionCoeff 3 = 240 * sigma3 3

theorem hammingThetaConvolutionCoeff_le_three (n : Nat) (hn : n <= 3) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n

theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq
    (heq : E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series) (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

The main all-`n` theorem remains an intentional draft `sorry`.

## Literature search summary

No public Lean proof of the exact project theorem was found.  The useful route
from the literature is the classical Construction A theta/weight-enumerator
identity:

```text
theta(A(C)) = W_C(even_one_dim_theta, odd_one_dim_theta)
```

For the extended Hamming `[8,4,4]` code, the weight enumerator is

```text
x^8 + 14*x^4*y^4 + y^8
```

because the code has weight distribution `A_0 = 1`, `A_4 = 14`, `A_8 = 1`.
After translating the one-dimensional parity theta series into the SPL Jacobi
theta constants, this is the usual E8 theta polynomial
`H2^2 + H2*H4 + H4^2`, and SPL already proves this polynomial is `E4`.

References checked:

- Error Correction Zoo, `[8,4,4]` extended Hamming code:
  `https://errorcorrectionzoo.org/c/hamming844`.
  It records the code as the smallest doubly even self-dual code of length 8
  and says it yields the E8 Gosset lattice by Construction A.
- Nebe-Sloane lattice catalogue, E8 coding-theory version:
  `https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html`.
  It records E8 as Construction A applied to the `[8,4,4]` Hamming code.
- Sole, "Codes and Rings: Theory and Practice" slides:
  `https://www.math.univ-paris13.fr/~desert/Journ%C3%A9e-du-LAGA/LAGA_jounee_Sole.pdf`.
  It states the code/lattice dictionary and the theta-series substitution of
  one-dimensional theta series into the weight enumerator.
- Sphere-Packing-Lean blueprint:
  `https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint.pdf`.
  It documents the Jacobi theta constants and Jacobi identity used by SPL.

Local SPL source checked:

```text
AgentTasks/external/Sphere-Packing-Lean-windows-safe/SpherePacking/ModularForms/JacobiTheta.lean
AgentTasks/external/Sphere-Packing-Lean-windows-safe/SpherePacking/ModularForms/Lv1Lv2Identities.lean
```

Key local SPL declarations:

```lean
SpherePacking.ModularForms.H2
SpherePacking.ModularForms.H3
SpherePacking.ModularForms.H4
SpherePacking.ModularForms.jacobi_identity
SpherePacking.ModularForms.thetaE4
SpherePacking.ModularForms.E4_eq_thetaE4
```

The actual Lean names use Unicode subscripts in SPL source.

## New Aristotle target file

Added:

```text
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

This file introduces the formal power-series scaffolding for the literature
route:

```lean
def parityLiftCoeff (w : Nat) (i : Fin 8) (s : Nat) : Nat

noncomputable def parityLiftSeries (w : Nat) (i : Fin 8) : PowerSeries Nat

noncomputable def weightContribFormalSeries (w : Nat) : PowerSeries Nat

theorem weightContribFormalSeries_coeff (w s : Nat) :
    PowerSeries.coeff s (weightContribFormalSeries w) =
      weightContribConvolution w s

noncomputable def hammingWeightEnumeratorFormalSeries : PowerSeries Nat

theorem hammingWeightEnumeratorFormalSeries_coeff (n : Nat) :
    PowerSeries.coeff (4 * n) hammingWeightEnumeratorFormalSeries =
      hammingThetaConvolutionCoeff n

theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

The theorem `hammingWeightEnumeratorFormalSeries_coeff` is already proved from
`weightContribFormalSeries_coeff`.

There are two intentional draft `sorry`s:

1. `weightContribFormalSeries_coeff`, a pure formal product-coefficient target.
2. `splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff`, the full SPL
   coefficient bridge.

If the full SPL bridge is too hard, proving `weightContribFormalSeries_coeff`
is still valuable progress.

## Requested Aristotle work

Primary target:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

This theorem immediately proves:

```lean
theorem thetaSeries_eq_e4Series_from_spl_theta_coeff_bridge :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

and then:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_from_spl_bridge (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

Fallback target:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .weightContribFormalSeries_coeff (w s : Nat) :
    PowerSeries.coeff s (weightContribFormalSeries w) =
      weightContribConvolution w s
```

Suggested proof direction for the fallback:

1. Use `PowerSeries.coeff_prod`.
2. Compare `PowerSeries.finsuppAntidiag (Finset.univ : Finset (Fin 8)) s`
   with functions `parts : Fin 8 -> Fin (s+1)` whose entries sum to `s`.
3. Unfold `parityLiftCoeff` and `weightContribConvolution`.

Please do not weaken theorem statements.  Do not introduce axioms, opaque
constants, or unsafe declarations.  This is draft code, so an unresolved proof
may remain as `sorry`, but any remaining `sorry` should include a useful
handoff note.

## Local verification before submission

```text
lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
lake build PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
lake env lean PhysicsSMDraft.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean PhysicsSMDraft.lean
```

Results:

- The coefficient-gap file checks with one intentional draft `sorry`.
- The new weight-enumerator bridge module builds with two intentional draft
  `sorry`s.
- The draft root checks after importing the new module.
- The three touched Lean files have no non-ASCII characters.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-theta-weight-enumerator-bridge-20260516-project
```

## Submitted job

| Job | Aristotle ID | Status |
|-----|--------------|--------|
| Hamming E8 theta weight-enumerator bridge | `bf905d04-b40c-43b1-9449-8cebc7fbe995` | in progress at final check |

Submission command:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-theta-weight-enumerator-bridge-20260516-project <prompt>
```

Immediate status check:

```text
aristotle list
```

first reported:

```text
bf905d04-b40c-43b1-9449-8cebc7fbe995 QUEUED 5 secs ago -
```

Final status check before handoff:

```text
bf905d04-b40c-43b1-9449-8cebc7fbe995 IN_PROGRESS 2 mins ago 1%
```

Package note: a direct `lake build
PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle` inside the copied
submission project was started as a packaging smoke test but timed out after
184 seconds while rebuilding from the source-only package.  The live checkout
checks listed above are the meaningful local verification for the submitted
files.

## Completed Aristotle job and local follow-up

Aristotle job `bf905d04-b40c-43b1-9449-8cebc7fbe995` completed with a useful
fallback proof:

```lean
theorem weightContribFormalSeries_coeff (w s : Nat) :
    PowerSeries.coeff s (weightContribFormalSeries w) =
      weightContribConvolution w s
```

The proof was integrated through a new helper module:

```text
PhysicsSM/Draft/WeightContribCoeffProof.lean
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

The helper theorem `coeff_finset_prod_eq_sum_fin` converts Mathlib's
`PowerSeries.coeff_prod` formulation over `finsuppAntidiag` into the project's
explicit bounded-function convolution over `Fin 8 -> Fin (s + 1)`.

After local follow-up work, the bridge file also contains a sorry-free
conditional reduction of the full theorem to two precise analytic ingredients:

1. the classical theta duplication identities in SPL's conventions,

```lean
(Theta2 tau)^2 = 2 * Theta2 (2*tau) * Theta3 (2*tau)
(Theta4 tau)^2 = Theta3 (2*tau)^2 - Theta2 (2*tau)^2
```

2. the q-expansion theorem identifying the coefficients of
   `hammingThetaConstantPolynomial` with `hammingThetaConvolutionCoeff`.

The new proved reduction is:

```lean
theorem hammingThetaConstantPolynomial_eq_thetaE4_of_duplication

theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff_of_duplication

theorem thetaSeries_eq_e4Series_of_duplication

theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_duplication
```

The only remaining Lean `sorry` in
`PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean` is the original
full analytic coefficient bridge:

```lean
theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

### What is still missing

The literature result is standard, but the standard proof uses analytic facts
that are not yet present as Lean lemmas in this repo or in the checked SPL API:

- Construction A theta series equals the Hamming weight enumerator evaluated at
  the even/odd one-dimensional theta series.
- The even/odd one-dimensional theta series are exactly
  `Theta3(2*tau)` and `Theta2(2*tau)` in SPL's normalization.
- The theta duplication identities convert
  `Theta3(2*tau)^8 + 14*Theta3(2*tau)^4*Theta2(2*tau)^4
    + Theta2(2*tau)^8`
  into SPL's `thetaE4`.
- The analytic q-expansion coefficients of that theta-constant polynomial are
  the project-local finite convolution coefficients.

SPL already proves `E4_eq_thetaE4`; it does not currently expose the
Construction A coefficient bridge or the required duplication identities as
ready-to-use theorems.

### Verification after local follow-up

```powershell
lake env lean PhysicsSM\Draft\WeightContribCoeffProof.lean
lake env lean PhysicsSM\Draft\E8ThetaWeightEnumeratorBridgeAristotle.lean
lake build PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
lake build PhysicsSMDraft
pre-commit run --files PhysicsSM\Draft\WeightContribCoeffProof.lean PhysicsSM\Draft\E8ThetaWeightEnumeratorBridgeAristotle.lean
lake build
```

Results:

- `WeightContribCoeffProof.lean` checks with no `sorry`.
- `E8ThetaWeightEnumeratorBridgeAristotle.lean` checks with the one expected
  draft `sorry` on the full analytic bridge.
- The targeted module, `PhysicsSMDraft`, pre-commit check for the two touched
  files, and full `lake build` all passed.
