# Hamming E8 missing math Aristotle jobs - 2026-05-08

Status: submitted 2026-05-08.

Purpose: submit the remaining mathematical strengthening targets for the
Hamming -> Construction A -> E8 manuscript.

These jobs are split by dependency profile. Jobs M1 and M2 use an
SPL-enabled submission project and must keep all Sphere-Packing-Lean-dependent
code under `PhysicsSM/Draft`. Jobs M3-M5 are SPL-free.

## Submission projects

```text
AgentTasks/aristotle-submit/hamming-e8-missing-spl-20260508-project
AgentTasks/aristotle-submit/hamming-e8-missing-core-20260508-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| M1: SPL surjectivity and `LinearEquiv`/isometry | `AgentTasks/aristotle-output/hamming-e8-spl-linearequiv-isometry` | `c3e8e971-2bea-4284-8f34-ddf1c7f3a624` | queued |
| M2: packing/density transfer packaging | `AgentTasks/aristotle-output/hamming-e8-packing-transfer` | `63605819-d7fc-4f17-bd15-9bfcb1c54296` | queued |
| M3: full theta-series identity moonshot | `AgentTasks/aristotle-output/hamming-e8-full-theta-series` | `ba573638-dd89-4ec5-b231-ff3362be3d59` | queued |
| M4: promote/re-export `[8,4,4]` uniqueness theorem | `AgentTasks/aristotle-output/hamming-844-uniqueness-promote` | `987d1d37-3e03-43fa-97a0-a6868f5ddc31` | queued |
| M5: rank-8 even unimodular E8 uniqueness draft/formal target | `AgentTasks/aristotle-output/hamming-e8-even-unimodular-uniqueness` | `96528dd5-bbe8-4408-aa1f-78c2a53f66d6` | queued |

Submission notes:

- M1 initially hit a transient SSL upload error before returning a job ID. A
  retry succeeded as `c3e8e971-2bea-4284-8f34-ddf1c7f3a624`.
- M5 initially hit a CLI argument-splitting error due to a long quoted theorem
  phrase in the prompt. A retry with the prompt passed as one quoted argument
  succeeded as `96528dd5-bbe8-4408-aa1f-78c2a53f66d6`.
- The SPL submission project has the upstream `SpherePacking` `[[require]]`
  block enabled for Aristotle's Linux environment.
- The core submission project keeps Sphere-Packing-Lean disabled.

## Exact resubmissions

The following failed jobs were resubmitted on 2026-05-08 with the same
submission project, destination, and prompt text, to test whether the failures
were transient Harmonic-side issues.

| Original job | Retry job | Task | Status |
|--------------|-----------|------|--------|
| `ba573638-dd89-4ec5-b231-ff3362be3d59` | `d940a392-9808-4746-906d-780cb20a0758` | M3 full theta-series identity moonshot | queued |
| `987d1d37-3e03-43fa-97a0-a6868f5ddc31` | `d5f3dabe-67d1-4587-bac5-a239e1b56f85` | M4 promote/re-export `[8,4,4]` uniqueness theorem | queued |

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted
  `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented handoff statements only if the target is
  genuinely blocked.
- Do not weaken theorem statements silently.
- Keep conventions explicit:
  - Construction A integer norm has short squared norm `4`;
  - scaled E8 norm divides the form by `2`;
  - SPL uses the standard half-integer E8 model;
  - theta index uses `Q(z) = sqNorm(z) / 4` in `E8ThetaSeries.lean`.

## M1: SPL surjectivity and `LinearEquiv`/isometry

Dependency profile: SPL-enabled.

Write scope:

- Primary: `PhysicsSM/Draft/E8SpherePackingImported.lean`
- Optional helper under `PhysicsSM/Draft`
- Do not add SPL imports to trusted core files.

Context:

`PhysicsSM/Draft/E8SpherePackingImported.lean` already proves:

```lean
constructionAToSPLTransition
constructionAToSPLTransition_det
constructionAToSPLTransition_factorization
constructionAToSPLTransition_gram
constructionAToE8
constructionAToE8_mem_E8
constructionAToE8_injective
```

Goal:

Upgrade the current injective map into the strongest available
equivalence/isometry bridge.

Preferred endpoint:

```lean
theorem constructionAToE8_surjective_onto_E8 :
    -- every element of Submodule.E8 R has integer coefficients/preimage
    -- under constructionAToE8, using span_E8Matrix and unimodularity

noncomputable def constructionAToE8LinearEquiv :
    -- a LinearEquiv-shaped object between the coefficient lattice or
    -- Construction A basis lattice and Submodule.E8 R

theorem constructionAToE8_isometry :
    -- preserves the scaled Gram form / Euclidean squared norm
```

Acceptable fallback endpoints:

1. A theorem proving surjectivity onto the row-span of `E8Matrix R`.
2. A theorem proving an explicit inverse coefficient map using the unimodular
   inverse of `constructionAToSPLTransition`.
3. A theorem proving the image is exactly `Submodule.E8 R` as a set, even if
   the final `LinearEquiv` packaging is awkward.
4. A draft statement with exact blockers if mathlib's `Submodule`/`LinearEquiv`
   API makes the full theorem too costly.

Minimum useful result:

- A sorry-free theorem that reduces the remaining gap from "surjectivity and
  isometry" to a smaller named API/packaging issue.

## M2: packing/density transfer packaging

Dependency profile: SPL-enabled.

Write scope:

- Primary: `PhysicsSM/Draft/E8SpherePackingImported.lean`
- Optional helper under `PhysicsSM/Draft`

Goal:

Use the best bridge available from M1's current context to package the
Sphere-Packing-Lean density theorem as a manuscript-facing theorem for the
code-built E8 model.

Important: do not claim more than is proved. If full packing transfer needs M1
surjectivity/isometry and that is not available, return a precise theorem that
bundles the density statement with the exact bridge hypotheses.

Preferred endpoint:

```lean
theorem constructionA_E8_density_from_spl :
    -- a statement saying the code-built/scaled Construction A E8 lattice has
    -- the same density as SPL's E8Packing, via the proved equivalence/isometry
```

Fallback endpoints:

1. A theorem bundling:
   - `E8Packing_density`;
   - `constructionAToE8_mem_E8`;
   - `constructionAToE8_injective`;
   - the Gram congruence theorem;
   - any surjectivity/equivalence theorem available.
2. A theorem giving a clean "conditional density transfer": if a map is a
   surjective isometry, then the density theorem applies to the transported
   packing.
3. A draft theorem statement with exact blockers and no fake density claim.

Minimum useful result:

- A manuscript-facing theorem or conditional theorem that makes the final
  density endpoint precise without overclaiming.

## M3: full theta-series identity moonshot

Dependency profile: SPL-free.

Write scope:

- Primary: `PhysicsSM/Coding/E8ThetaSeries.lean`
- Optional draft: `PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean`

Context:

`PhysicsSM/Coding/E8ThetaSeries.lean` currently proves:

```lean
sigma3_one
sigma3_two
sigma3_three
e8ShellCount_zero
e8ShellCount_four
e8ShellCount_eight
e8ShellCount_twelve
thetaCoeff_eq_e4Coeff_one
thetaCoeff_eq_e4Coeff_two
thetaCoeff_eq_e4Coeff_three
```

Goal:

Attempt the full theta-series identity for the Construction A E8 lattice:

```text
Theta_E8(q) = E4(q) = 1 + 240 * sum_{n >= 1} sigma_3(n) q^n.
```

Preferred endpoint:

- Define a formal power series or coefficient function suitable for the full
  statement.
- Prove `thetaCoeffE8 n = 240 * sigma3 n` for all relevant positive `n`, if
  feasible.

Realistic fallback endpoints:

1. Prove the next coefficient(s), especially the `q^4` coefficient
   `17520 = 240 * sigma3 4`.
2. Build a general finite shell-count API that reduces each coefficient to a
   finite coordinate enumeration with proved coordinate bounds.
3. Define the full theorem statement in draft with a clear proof plan and exact
   missing infrastructure, while keeping trusted code sorry-free.

Minimum useful result:

- Either a new trusted coefficient beyond `q^3`, or a serious reusable
  coefficient API for future theta work.

## M4: promote/re-export `[8,4,4]` uniqueness theorem

Dependency profile: SPL-free.

Write scope:

- `PhysicsSM/Coding/HammingConstructionAE8Final.lean`
- Optional: move or mirror the public wrapper from
  `PhysicsSM/Draft/Hamming844Uniqueness.lean` into a trusted coding file, if
  appropriate.

Context:

The uniqueness theorem is proved:

```lean
PhysicsSM.Coding.extendedHamming8_unique_up_to_equivalence
```

but the public wrapper currently lives in `PhysicsSM/Draft/Hamming844Uniqueness.lean`.
The proof machinery lives in trusted files:

```lean
PhysicsSM/Coding/Hamming844UniquenessBasic.lean
PhysicsSM/Coding/Hamming844Classification.lean
```

Goal:

Make the uniqueness theorem manuscript-citation-friendly from trusted code.

Preferred endpoint:

- Move or re-export the theorem in a trusted module so the manuscript can cite
  it without pointing to `PhysicsSM/Draft`.
- Add an alias in `HammingConstructionAE8Final.lean`, for example:

```lean
theorem code_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 := ...
```

Constraints:

- Do not duplicate large proof bodies.
- Do not import draft files into trusted files.
- If moving the wrapper creates an import cycle, add a tiny trusted wrapper
  module with the right imports.

Minimum useful result:

- A sorry-free trusted theorem alias suitable for the manuscript.

## M5: rank-8 even unimodular E8 uniqueness draft/formal target

Dependency profile: SPL-free unless Aristotle identifies a compelling reason
otherwise.

Write scope:

- Preferred draft file: `PhysicsSM/Draft/E8EvenUnimodularUniqueness.lean`
- Optional trusted helper under `PhysicsSM/Lie/Exceptional/` or
  `PhysicsSM/Coding/` only if fully proved and broadly useful.

Goal:

Explore whether the classical theorem "the rank-8 positive-definite even
unimodular lattice is E8 up to isometry" can be stated or partially formalized
in the current project/mathlib environment.

Important:

This is not on the critical path because the manuscript uses explicit
Cartan/root/SPL bridges. This job should not churn on a huge classification
proof. Its value is in a clean theorem statement, API survey, and any small
trusted precursors.

Preferred endpoint:

- A draft theorem statement using existing mathlib lattice/quadratic-form
  concepts, with documented hypotheses and a proof-plan comment.

Fallback endpoints:

1. A trusted helper theorem showing our Construction A lattice satisfies one
   standard hypothesis in the exact format needed by a future uniqueness
   theorem.
2. A source/API map listing the mathlib definitions that should represent
   lattice, rank, evenness, unimodularity, positive definiteness, and isometry.
3. A draft theorem with a precise blocker list and no fake axioms.

Minimum useful result:

- A clean handoff artifact that prevents the manuscript from citing an
  unformalized uniqueness theorem as if it were already proved.
