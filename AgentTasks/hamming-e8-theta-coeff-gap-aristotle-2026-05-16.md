# Hamming E8 theta coefficient gap Aristotle job - 2026-05-16

Status: submitted to Aristotle.

Purpose: follow up on job `9215f082-2baa-4e13-837c-9335ddf88aad` by isolating
the exact remaining coefficient theorem after the SPL/Eisenstein side was
proved.

## Local work before submission

Integrated the useful theorem returned by job
`9215f082-2baa-4e13-837c-9335ddf88aad` into:

```text
PhysicsSM/Draft/E8ThetaSPLBridge.lean
```

Added:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

This target file contains two checked sanity lemmas:

```lean
theorem hammingThetaConvolutionCoeff_zero :
    hammingThetaConvolutionCoeff 0 = 1

theorem hammingThetaConvolutionCoeff_one :
    hammingThetaConvolutionCoeff 1 = 240 * sigma3 1
```

and one intentional draft `sorry`:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

The file also contains the closing theorem:

```lean
theorem thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

which will become sorry-free automatically once the coefficient theorem is
proved.

## Literature and public-code search

The search did not find public Lean code proving this exact all-coefficient
Construction A formula.

Useful public references found or rechecked:

- Error Correction Zoo records that the extended `[8,4,4]` Hamming code is
  doubly even, self-dual, and yields the E8 Gosset lattice by Construction A.
  URL: `https://errorcorrectionzoo.org/c/eeight`.
- Nebe-Sloane's online E8 code-lattice catalogue entry gives a public
  cross-check for the same code-lattice construction.
  URL: `https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html`.
- OEIS A004009 identifies the E4 q-expansion with the E8 theta series and
  records the formula `a(n) = 240 * sigma_3(n)` for `n > 0`.
  URL: `https://oeis.org/A004009`.
- Sphere-Packing-Lean already contains the modular-form theta constants and
  the identity used locally as `SpherePacking.ModularForms.E4_eq_thetaE4`
  (rendered in Lean source as `E4_eq_thetaE4` with Unicode in the actual
  declaration name).
  URL: `https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint.pdf`.
- Mathlib exposes modular-form q-expansion algebra, but not a ready-made
  theorem translating the Hamming Construction A weight enumerator into the
  SPL theta-polynomial q-expansion.
  URL:
  `https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/ModularForms/EisensteinSeries/QExpansion.html`.

Zotero searches on 2026-05-16 for the missing exact theorem did not reveal new
local library items beyond the references already listed in
`Sources/Hamming_E8_Zotero_Source_Map.md`.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-theta-coeff-gap-20260516-project
```

This was copied from the prior SPL theta bridge package and refreshed with the
current source files needed for the target theorem. It remains source-only and
does not include `.lake`, `.git`, or old Aristotle output.

## Aristotle target file

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Main target:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

Fallback requested if the full theorem is out of reach:

- a conditional theorem isolating the one-dimensional even/odd theta
  q-expansion facts; or
- a formal power-series theorem proving that the Hamming weight-enumerator
  convolution is the q-expansion of `SpherePacking.ModularForms.thetaE4`.

## Submitted job

| Job | Aristotle ID | Status |
|-----|--------------|--------|
| Hamming Construction A coefficient formula | `a9a170c1-b4ec-4a0e-8468-ca2db69e6f75` | queued at submission check |

## Local verification

```text
lake env lean PhysicsSM/Draft/E8ThetaSPLBridge.lean
lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
lake env lean -o .lake/build/lib/lean/PhysicsSM/Draft/E8ThetaSPLBridge.olean -i .lake/build/lib/lean/PhysicsSM/Draft/E8ThetaSPLBridge.ilean -c .lake/build/ir/PhysicsSM/Draft/E8ThetaSPLBridge.c PhysicsSM/Draft/E8ThetaSPLBridge.lean
aristotle list
```

Results:

- `E8ThetaSPLBridge.lean` passed direct Lean checking.
- `E8ThetaCoeffGapAristotle.lean` passed direct Lean checking with exactly the
  intentional draft `sorry`.
- The direct olean refresh was needed because a full Lake build of the SPL
  bridge timed out in the live Windows checkout after re-elaborating
  dependencies.
- `aristotle list` confirmed job `a9a170c1-b4ec-4a0e-8468-ca2db69e6f75` was
  created and queued.

## Result check - 2026-05-16

`aristotle list` now reports:

```text
a9a170c1-b4ec-4a0e-8468-ca2db69e6f75 COMPLETE_WITH_ERRORS 4 hours ago 100%
```

Downloaded archive:

```text
AgentTasks/aristotle-output/hamming-e8-theta-coeff-gap-20260516-result
```

Extracted archive:

```text
AgentTasks/aristotle-output/hamming-e8-theta-coeff-gap-20260516-extracted
```

The CLI printed:

```text
Project finished but had trouble parsing the input. Getting the results...
```

Aristotle did not close the main all-`n` theorem.  The returned summary says
the run produced partial draft progress:

- proofs of the coefficient formula for `n = 0, 1, 2, 3`;
- a wrapper theorem for `n <= 3`;
- a conditional theorem
  `hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq`, showing that the
  all-`n` coefficient formula follows from
  `E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series`;
- a helper file `PhysicsSM/Draft/E8ThetaCoeffHelper.lean`.

The original theorem
`hammingThetaConvolutionCoeff_eq_e4Coeff` still contains one intentional draft
`sorry` in the returned file, so this job is not a trusted completion.

Verification of returned files against the live checkout:

```text
lake env lean <extracted>/PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
lake env lean <extracted>/PhysicsSM/Draft/E8ThetaCoeffHelper.lean
```

Results:

- `E8ThetaCoeffGapAristotle.lean` elaborated, with one warning that the main
  theorem still uses `sorry`.
- `E8ThetaCoeffHelper.lean` elaborated without warnings.
- Attempting to check inside the extracted project itself triggered package
  fetching and failed before Lean elaboration with `git` exit code 128, so the
  meaningful check was done through the live repo environment.
