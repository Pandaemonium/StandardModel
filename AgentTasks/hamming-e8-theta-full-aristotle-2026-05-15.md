# Hamming E8 full theta-series Aristotle job - 2026-05-15

Status: the original job failed internally in Aristotle; the follow-up retry
`d2f72efe-37e7-461f-8c11-a2b2383cb508` completed and has been integrated as a
sorry-free conditional modular-route scaffold.

Purpose: ask Aristotle to attack the full identity

```text
Theta_E8 = E4
```

for the Hamming Construction A E8 lattice, using the classical modular-forms
route when available and otherwise returning the sharpest conditional scaffold
around the missing modular-forms API.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-theta-full-20260515-project
```

This package was made from the older SPL-free core submission copy
`hamming-e8-missing-core-20260508-project`, then refreshed with the current
`PhysicsSM` tree. This avoids old extracted Aristotle output and avoids the
optional Sphere-Packing-Lean dependency for this core modular-forms job.

## Submitted job

| Job | Output directory | Aristotle ID | Final status |
|-----|------------------|--------------|----------------------|
| Full theta-series modular route | no patch; CLI result failed | `fc487c8a-cca9-496b-b08e-26315bdba7d2` | failed internally |

Attempting to retrieve the result with `aristotle result` produced:

```text
ERROR - Project failed due to an internal error. The team at Harmonic has been notified; please try again.
```

No mathematical counterexample or partial Lean patch was provided.  The
scaffold in `PhysicsSM/Draft/E8ThetaModularAristotle.lean` remains the current
retry target for the full `Theta_E8 = E4` route.

Follow-up: the full theta scaffold was resubmitted on 2026-05-15 as
`d2f72efe-37e7-461f-8c11-a2b2383cb508` using the refreshed package recorded in
`AgentTasks/hamming-e8-strengthening-retry-2026-05-15.md`. The result did not
prove the unconditional theorem. It instead confirmed the expected Mathlib
modular-forms blockers and replaced the old `sorry` with a conditional theorem
whose hypothesis packages the missing analytic modularity and uniqueness input.

## Primary write scope

```text
PhysicsSM/Draft/E8ThetaModularAristotle.lean
```

Optional write scope:

```text
PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean
PhysicsSM/Draft/*.lean
```

Trusted `PhysicsSM/Coding` files were explicitly kept out of the requested
write scope unless Aristotle finds a fully checked, sorry-free helper that is
essential.

## Main target

```lean
theorem PhysicsSM.Coding.E8ThetaAristotle.thetaSeries_eq_e4Series :
    thetaSeries = e4Series
```

The integrated scaffold defines:

- `thetaSeries`: the formal Construction A E8 theta series, with coefficient
  `Set.ncard {z | z in e8IntLattice and sqNorm z = 4 * n}`;
- `e4Series`: the normalized Eisenstein `E4` q-series, with coefficient
  `1` at `n = 0` and `240 * sigma3 n` for `n > 0`;
- a proved abstract uniqueness wrapper;
- the proved constant-coefficient comparison
  `const_coeff_eq : coeff 0 thetaSeries = coeff 0 e4Series`;
- proved coefficient-extraction consequences from a series equality.

## Expected mathematical route

1. Prove the analytic theta series of the Construction A E8 lattice is a
   weight-4 modular form for `SL_2(Z)`, using evenness, unimodularity, and
   rank 8.
2. Prove or reuse the normalized `E4` q-expansion
   `1 + 240 * sum_{n >= 1} sigma3(n) q^n`.
3. Use uniqueness/dimension one of `M_4(SL_2(Z))`.
4. Compare constant coefficients.

## Expected blocker

Pinned Mathlib has useful q-expansion and Eisenstein-series APIs, but
`Mathlib/NumberTheory/ModularForms/LevelOne.lean` appears to still lack the
finite-dimensionality/dimension-one theorem for weight `4`.

The full theorem is blocked in pinned Mathlib. The integrated fallback is a
precise conditional theorem whose hypotheses isolate:

- theta-series modularity of even unimodular rank-8 lattices;
- normalized `E4` q-expansion;
- uniqueness/dimension-one of weight-4 level-one modular forms;
- constant coefficient agreement.

## Local verification before submission

```text
lake env lean PhysicsSM/Draft/E8ThetaModularAristotle.lean
```

Result: succeeded with the intended warning that
`thetaSeries_eq_e4Series` uses `sorry`.

## Local verification after integration

```text
lake build PhysicsSM.Draft.E8ThetaModularAristotle
```

Result: succeeded. The integrated file contains no `sorry`, `admit`, `axiom`,
or `unsafe` token.

An attempted check of the older
`PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean` timed out after 124 seconds on
Windows, likely because that file imports the heavier q^5/q^6 coefficient
modules. The new Aristotle scaffold intentionally avoids those imports.
