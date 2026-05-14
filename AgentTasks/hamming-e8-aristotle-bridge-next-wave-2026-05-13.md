# Hamming E8 Aristotle bridge next wave - 2026-05-13

Status: submitted 2026-05-14.

Purpose: plan the next ambitious Aristotle proof-job wave for the Hamming
Construction A to E8 manuscript, based on the current Lean code rather than
the older 2026-05-07/08 job queues.

## Baseline examined

Current local checks run on 2026-05-13:

```text
lake build PhysicsSM.Coding.HammingConstructionAE8Final
lake build PhysicsSM.Coding.E8SpherePackingMatrixBridge
lake build PhysicsSM.Draft.E8EvenUnimodularUniqueness
lake build PhysicsSM.Draft.Hamming844Uniqueness
lake build PhysicsSM.Coding.E8ThetaSeriesQ5
lake build PhysicsSM.Coding.ConstructionAThetaWeightBridge
lake build PhysicsSM.Algebra.Octonion.E8WeylOrbitConvergence
```

All completed successfully. The `E8EvenUnimodularUniqueness` target still has
the expected draft `sorry`s:

```text
e8Gram_posDef
e8_even_unimodular_uniqueness
```

The main theorem index currently builds, but it does not yet re-export all
publication-facing theorem families:

- `[8,4,4]` uniqueness is proved in `PhysicsSM.Coding.Hamming844Classification`
  and wrapped in `PhysicsSM.Draft.Hamming844Uniqueness`, but not exposed from
  `HammingConstructionAE8Final`.
- The dependency-free SPL-shaped matrix bridge builds in
  `PhysicsSM.Coding.E8SpherePackingMatrixBridge`, but is not exposed from the
  final theorem index.
- Theta coefficients through `q^5` and the weight-enumerator bridge build, but
  are not exposed from the final theorem index.
- Weyl orbit convergence builds, but the final theorem index imports only the
  lighter Weyl orbit API.
- The direct imported Sphere-Packing-Lean bridge is intentionally not part of
  the default Windows build.

## Submission strategy

Use two submission profiles:

```text
Core profile:
  project-dir: C:/Projects/StandardModel
  no Sphere-Packing-Lean dependency
  write only trusted SPL-free code unless explicitly told to use Draft

SPL profile:
  copy of this project with SpherePacking enabled in lakefile.toml
  run on Aristotle's Linux environment
  keep all direct SPL imports under PhysicsSM/Draft
```

Recommended parallelism:

- Submit A1, A2, A4, A5, A6, A8, and A9 under the core profile.
- Submit A3 under the SPL profile.
- Submit A7 as a moonshot only after A6 lands or if we want a deliberately
  high-risk background job.

Shared constraints for every job:

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted
  `sorry`.
- Trusted modules must remain sorry-free.
- Draft modules may contain documented `sorry`s only when the theorem is
  genuinely blocked and the blocker is precise.
- Do not weaken theorem statements silently.
- Do not import `PhysicsSM.Draft` modules into trusted `PhysicsSM.Coding`
  modules.
- Keep the norm conventions explicit:
  - Construction A integer model has short squared norm `4`.
  - The scaled E8 form divides the quadratic form by `2`.
- The SPL half-integer model is already in root squared norm `2`.

## Submitted jobs

| Job | Output directory | Aristotle ID | Status at submission |
|-----|------------------|--------------|----------------------|
| A1: theorem-index consolidation | `AgentTasks/aristotle-output/hamming-e8-a1-theorem-index-20260513` | `56a79161-9189-4f5f-a2bd-e070907a5118` | in progress |
| A2: SPL-free coordinate equivalence | `AgentTasks/aristotle-output/hamming-e8-a2-coordinate-bridge-20260513` | `89f80c0d-810f-4ea8-a2a3-6b0826b6b890` | in progress |
| A3: direct SPL bridge package | `AgentTasks/aristotle-output/hamming-e8-a3-spl-bridge-package-20260513` | `a06efb5e-1833-48be-ad04-56c9e66b99be` | in progress |
| A4: native-trust reduction | `AgentTasks/aristotle-output/hamming-e8-a4-trust-reduction-20260513` | `623854f1-0cc9-47c3-bf7f-9c27eb367c17` | in progress |
| A5: half-integer equality | `AgentTasks/aristotle-output/hamming-e8-a5-halfinteger-equality-20260513` | `fcac936a-4cc8-418b-a234-3703db5f352b` | in progress |
| A6: structural theta bridge | `AgentTasks/aristotle-output/hamming-e8-a6-theta-structural-20260513` | `3235cdbd-a203-4558-9391-b9f00206bb29` | in progress |
| A7: theta moonshot | `AgentTasks/aristotle-output/hamming-e8-a7-theta-moonshot-20260513` | `593c3ad8-f83a-4025-ac52-d0e7665a7de1` | in progress |
| A8: E8 positive-definite certificate | `AgentTasks/aristotle-output/hamming-e8-a8-posdef-20260513` | `20a5d24c-067a-46c6-a4ea-be423ad8ea96` | in progress |
| A9: Weyl packaging | `AgentTasks/aristotle-output/hamming-e8-a9-weyl-packaging-20260513` | `19ce1a52-b6ae-46c3-afaf-289157cb414d` | in progress |
| A10: root import hygiene | `AgentTasks/aristotle-output/hamming-e8-a10-root-import-hygiene-20260513` | `a014f706-8140-43d3-8fa3-958d279af1bc` | in progress |

Submission notes:

- A1 was created by the initial bulk submission before the local shell command
  timed out. It is inferred from the first new Aristotle ID returned by
  `aristotle list`.
- Submitting core jobs directly from the live working tree hit a packaging
  error because the Aristotle CLI tried to archive old extracted output under
  `AgentTasks/aristotle-output`. The remaining core jobs were submitted from
  the clean submission copy
  `AgentTasks/aristotle-submit/hamming-e8-missing-core-20260508-project`,
  after refreshing the relevant source files from the live tree.
- The SPL job A3 was submitted from
  `AgentTasks/aristotle-submit/hamming-e8-missing-spl-20260508-project`, after
  refreshing the current SPL bridge files. This avoids enabling the upstream
  Sphere-Packing-Lean dependency in the native Windows checkout.
- The first A10 upload hit a transient SSL `bad record mac`; a retry succeeded
  as `a014f706-8140-43d3-8fa3-958d279af1bc`.

## Integration notes - 2026-05-14

Completed jobs integrated into the live tree:

- A2 (`89f80c0d-810f-4ea8-a2a3-6b0826b6b890`): added
  `PhysicsSM/Coding/E8SpherePackingCoordinateBridge.lean`, a trusted
  SPL-free transition-matrix bridge from Construction A coefficients to the
  local SPL-shaped basis.
- A8 (`20a5d24c-067a-46c6-a4ea-be423ad8ea96`): added
  `PhysicsSM/Lie/Exceptional/E8PositiveDefinite.lean` and replaced the
  `e8Gram_posDef` proof hole in
  `PhysicsSM/Draft/E8EvenUnimodularUniqueness.lean`. The full rank-8 even
  unimodular classification theorem remains a documented draft `sorry`.
- A9 (`19ce1a52-b6ae-46c3-afaf-289157cb414d`): added
  `PhysicsSM/Algebra/Octonion/E8WeylPublication.lean` and re-exported the
  Weyl permutation/orbit-convergence aliases from
  `PhysicsSM/Coding/HammingConstructionAE8Final.lean`.
- A3 (`a06efb5e-1833-48be-ad04-56c9e66b99be`): integrated the
  manuscript-facing SPL bridge package theorems into
  `PhysicsSM/Draft/E8SpherePackingImported.lean`.
- A4 (`623854f1-0cc9-47c3-bf7f-9c27eb367c17`): reduced the native-compiler
  trust boundary in `PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean`.
  Central determinant and Gram/Cartan bridge proofs now use triangularity,
  row operations, `fin_cases`, `simp`, and `norm_num` rather than
  `native_decide`. `E8SpherePackingShape.lean` was updated to document the
  remaining finite-computation trust boundary.
- A5 (`fcac936a-4cc8-418b-a234-3703db5f352b`): added
  `PhysicsSM/Coding/E8HalfIntegerBasisBridge.lean`, proving that the doubled
  half-integer E8 lattice equals the integer span of the local doubled
  SPL-shaped basis rows, plus a bundled Construction A to half-integer bridge.
- A6 (`3235cdbd-a203-4558-9391-b9f00206bb29`, `COMPLETE_WITH_ERRORS`):
  integrated the useful theta/weight-enumerator result into
  `PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean`. The new bridge
  covers `q^3`/`sqNorm = 12`, with per-weight contributions
  `(448, 448, 0)` for Hamming weights `(0, 4, 8)` and the theorem
  `hamming_thetaCoeff_from_weight_distribution_3`.
  Local adaptation: the returned `weightContribRange7` definition enumerated
  all `Fin 8 -> Fin 7` vectors and was too slow on Windows, so the live
  definition indexes only parity-compatible odd/even coordinate choices while
  preserving the canonical weight-contribution meaning.
- A7 (`593c3ad8-f83a-4025-ac52-d0e7665a7de1`): added
  `PhysicsSM/Coding/E8ThetaSeriesQ6.lean`, proving the `q^6` theta/E4
  coefficient match, and updated
  `PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean` with a conditional
  modular-form-uniqueness theorem. The full theta identity and general
  coefficient theorem remain documented draft `sorry`s.

Special note on A1:

- The bundle downloaded for A1 (`56a79161-9189-4f5f-a2bd-e070907a5118`)
  contained SPL bridge-package content overlapping A3 rather than the
  theorem-index consolidation described in this task file. The richer A3
  version was integrated once; A1 was treated as duplicate/overlapping output.

Import hygiene:

- Direct broad `import Mathlib` lines introduced in new trusted helper files
  were removed. `E8SpherePackingCoordinateBridge.lean` now imports the local
  matrix bridge only, and `E8PositiveDefinite.lean` imports the specific
  Matrix PosDef and tactic modules it uses.
- The A5 and A7 trusted helper files were integrated without direct
  `import Mathlib`; they import the nearest local modules instead. The
  moonshot draft import was narrowed to `PhysicsSM.Coding.E8ThetaSeriesQ6`.
- Several older project files still begin with `import Mathlib`. Those were
  pre-existing and were not narrowed in this integration pass.

Verification run after integration:

```text
lake build PhysicsSM.Lie.Exceptional.E8PositiveDefinite
lake build PhysicsSM.Coding.E8SpherePackingCoordinateBridge
lake build PhysicsSM.Coding.HammingConstructionAE8Final
lake build PhysicsSM.Draft.E8EvenUnimodularUniqueness
lake build PhysicsSM.Algebra.Octonion.E8WeylPublication
lake build PhysicsSM.Coding.E8HalfIntegerBasisBridge
lake build PhysicsSM.Coding.E8ThetaSeriesQ6
lake build PhysicsSM.Draft.E8ThetaSeriesMoonshot
lake env lean PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
lake env lean PhysicsSM/Coding/E8SpherePackingShape.lean
lake env lean PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean
```

The first five completed successfully after the initial integration wave. The
A5/A7 commands were run during the second integration wave. The SPL-dependent
`PhysicsSM.Draft.E8SpherePackingImported` theorem package was verified by
Aristotle in the SPL/Linux submission copy, but was not rebuilt locally after
the Windows crash report. The A4/A6 follow-up commands above were run locally
on 2026-05-14; the theta-weight bridge check is slow on Windows (about 7.5
minutes) because it still contains several finite `native_decide` computations.

## A1: Publication theorem-index consolidation

Profile: core.

Write scope:

```text
PhysicsSM/Coding/HammingConstructionAE8Final.lean
```

Optional helper:

```text
PhysicsSM/Coding/HammingConstructionAE8Publication.lean
```

Goal: turn the current theorem index into the manuscript-facing theorem table
advertised by the draft paper.

Tasks:

1. Import only trusted modules needed for already-proved results:
   `Hamming844Classification`, `E8SpherePackingMatrixBridge`,
   `E8ThetaSeriesQ5`, `ConstructionAThetaWeightBridge`, and
   `E8WeylOrbitConvergence`, unless this creates an import cycle.
2. Add a trusted alias for uniqueness:

```lean
theorem code_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 := ...
```

3. Add trusted aliases for the dependency-free SPL-shaped matrix bridge:

```lean
theorem spl_basis_det : splE8BasisQ.det = 1 := ...
theorem spl_gram_to_cartan : ... := ...
theorem spl_gram_congruent_to_scaled_constructionA : ... := ...
theorem gram_determinants_match : ... := ...
```

4. Add trusted aliases for theta coefficients through `q^5`:

```lean
theorem thetaCoeff_eq_e4Coeff_one : ...
theorem thetaCoeff_eq_e4Coeff_two : ...
theorem thetaCoeff_eq_e4Coeff_three : ...
theorem thetaCoeff_eq_e4Coeff_four : ...
theorem thetaCoeff_eq_e4Coeff_five : ...
```

5. Add trusted aliases for the structural weight-enumerator bridge:

```lean
theorem theta1_from_weight_dist : ...
theorem theta2_from_weight_dist : ...
theorem theta1_bridge_eq_e4 : ...
theorem theta2_bridge_eq_e4 : ...
```

6. Add trusted aliases for Weyl orbit convergence:

```lean
theorem rootWordTable_correct : ...
theorem rootWordTable_length_le : ...
theorem simpleClosure_from_firstRoot_covers_rootList : ...
```

Expected output:

- A sorry-free theorem index that lets the manuscript cite one module for all
  default-build local claims.
- No proof search should be needed beyond resolving imports and names.

Minimum useful result:

- A new sorry-free wrapper module if editing the existing final index would
  create import cycles.

## A2: SPL-free coordinate equivalence to the local SPL-shaped basis

Profile: core.

Write scope:

```text
PhysicsSM/Coding/E8SpherePackingCoordinateBridge.lean
```

Allowed source material:

- Reuse the SPL-free definitions in
  `PhysicsSM.Coding.E8SpherePackingMatrixBridge`.
- Reuse the transition-map ideas from
  `PhysicsSM.Draft.E8SpherePackingImported`, but do not import that draft file
  into trusted code.

Goal: promote the strongest SPL-free part of the imported bridge into trusted
code. The current dependency-free bridge proves congruent Gram matrices; this
job should produce an actual coordinate map between Construction A basis
coefficients and the local SPL-shaped basis rows.

Preferred definitions and theorems:

```lean
def constructionAToSPLTransition : Matrix (Fin 8) (Fin 8) Int := ...

theorem constructionAToSPLTransition_det :
    constructionAToSPLTransition.det = 1 := ...

theorem constructionAToSPLTransition_factorization :
    constructionAToSPLTransition * e8BasisChangeMatrix =
    splToCartanTransition.transpose := ...

theorem constructionAToSPLTransition_gram :
    (constructionAToSPLTransition.map (Int.castRingHom Rat)).transpose *
      splE8GramQ *
      (constructionAToSPLTransition.map (Int.castRingHom Rat)) =
    e8ScaledGramQ := ...

noncomputable def constructionACoeffToSPLQ :
    (Fin 8 -> Int) ->l[Int] (Fin 8 -> Rat) := ...

theorem constructionACoeffToSPLQ_mem_span
    (c : Fin 8 -> Int) :
    constructionACoeffToSPLQ c
      in Submodule.span Int (Set.range splE8BasisQ.row) := ...

theorem constructionACoeffToSPLQ_range_eq_span :
    Set.range constructionACoeffToSPLQ =
      (Submodule.span Int (Set.range splE8BasisQ.row) : Set (Fin 8 -> Rat)) := ...

theorem constructionACoeffToSPLQ_inner
    (c1 c2 : Fin 8 -> Int) :
    dot-product statement using e8ScaledGramQ := ...
```

Acceptable fallback:

- Prove the transition determinant, factorization, inverse, and Gram theorem
  only. This is still useful because it moves the core coordinate bridge out of
  the SPL-dependent draft.

Minimum useful result:

- A trusted theorem showing the local SPL basis row-span and the scaled
  Construction A coefficient lattice are isometric by an explicit unimodular
  integer transition.

## A3: Direct SPL imported theorem package and density transport

Profile: SPL.

Write scope:

```text
PhysicsSM/Draft/E8SpherePackingImported.lean
```

Optional new file:

```text
PhysicsSM/Draft/HammingConstructionAE8SPLFinal.lean
```

Goal: validate and package the direct Sphere-Packing-Lean bridge in an
SPL-enabled environment. The current file already contains strong declarations
such as `constructionAToE8Equiv` and `constructionAToE8_inner`, but the default
Windows build cannot check them because SPL is disabled.

Tasks:

1. Build the file with actual imports:

```lean
import SpherePacking.Dim8.E8.Basic
import SpherePacking.Dim8.E8.Packing
```

2. Repair names or APIs if SPL has drifted.
3. Add a compact manuscript-facing theorem package:

```lean
theorem constructionA_to_imported_E8_bridge_package :
    -- bundle matrix equality, span equality, LinearEquiv, and inner product
```

4. Add the strongest honest density theorem available:

```lean
theorem constructionA_E8_density_from_spl :
    -- either a direct transported density theorem for a constructed packing,
    -- or a precise theorem bundling E8Packing_density with the proved
    -- equivalence/isometry data.
```

Constraints:

- Do not claim that a new Construction A packing has density `pi^4 / 384`
  unless that exact packing is defined and connected to SPL's packing by a
  checked equality or isometry.
- If full packing transport is blocked by SPL's packing API, state and prove a
  conditional theorem that isolates the missing API.

Minimum useful result:

- A compiling SPL-enabled draft file proving `constructionAToE8Equiv` and
  `constructionAToE8_inner` against current SPL declarations, plus a density
  theorem whose statement is honest enough for the manuscript.

## A4: Reduce `Lean.trustCompiler` in finite matrix bridges

Profile: core.

Write scope:

```text
PhysicsSM/Coding/E8SpherePackingShape.lean
PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
```

Optional helper:

```text
PhysicsSM/Coding/E8MatrixCertificates.lean
```

Goal: replace selected `native_decide` matrix and determinant proofs with
kernel-reduced certificates where feasible. The manuscript can still use
`native_decide`, but reducing the trust boundary for the matrix bridge would
make the paper much stronger.

Priority theorem families:

```lean
e8BasisChangeMatrix_det
e8BasisChange_gram_eq_cartan
splE8BasisQ_det
splE8GramQ_eq
splE8GramQ_det
splToCartanTransition_det
splGram_to_cartan
constructionA_scaledGram_to_cartan
```

Preferred proof style:

- Use `norm_num`, `ring_nf`, `fin_cases`, and explicit determinant/matrix
  certificates.
- `decide` is acceptable; `native_decide` is the thing to avoid for this job.
- Keep proofs readable enough that a reviewer can audit the certificate shape.

Acceptable fallback:

- Produce a new theorem table classifying exactly which declarations still use
  `native_decide` and which have kernel-only replacements.

Minimum useful result:

- At least one central Cartan/Gram bridge theorem and one determinant theorem
  proved without `native_decide`.

## A5: Real half-integer model equality, not just matching minimum norms

Profile: core.

Write scope:

```text
PhysicsSM/Coding/E8HalfIntegerBridge.lean
```

Optional helper:

```text
PhysicsSM/Coding/E8HalfIntegerBasisBridge.lean
```

Motivation: the current theorem `halfIntegerE8_to_scaledConstructionA` is only
a weak existence statement using a fixed short Construction A vector. It is
not a reverse bridge from an arbitrary half-integer vector to the Construction
A model.

Goal: prove an actual bidirectional bridge between the doubled half-integer
model and a basis-generated model.

Preferred endpoints:

```lean
theorem splE8BasisDoubled_rows_span_halfIntE8Doubled :
    -- every y in halfIntE8Doubled is an Int-linear combination of the
    -- rows of splE8BasisDoubled, and every such combination is in
    -- halfIntE8Doubled

theorem halfIntE8Doubled_eq_span_splE8BasisDoubled :
    -- submodule/addsubgroup equality form of the same result

theorem constructionA_to_halfInteger_full_bridge :
    -- combine Construction A basis spanning with A2's transition matrix
    -- to identify the scaled Construction A lattice with the half-integer
    -- E8 coordinate model, up to the documented normalization.
```

Hints:

- `splE8BasisDoubled` is already defined in
  `E8SpherePackingMatrixBridge.lean`.
- The rows of `splE8BasisDoubled` are the standard generators:
  `2e1`, `-e_i + e_{i+1}` doubled, and the all-ones glue vector.
- Membership in `halfIntE8Doubled` is the parity condition
  `forall i j, y i % 2 = y j % 2` plus `4 | sum_i y_i`.
- A constructive proof should express:
  - same parity even case by differences and the `4, -2, 2` rows;
  - same parity odd case by subtracting the all-ones row, reducing to even.

Minimum useful result:

- A non-vacuous theorem that every `y in halfIntE8Doubled` has integer
  coefficients in the local SPL doubled basis.

## A6: General structural theta bridge from the Hamming weight enumerator

Profile: core.

Write scope:

```text
PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean
```

Optional helper:

```text
PhysicsSM/Coding/ConstructionAThetaProduct.lean
```

Goal: upgrade the current early-shell weight bridge into a reusable
Construction A theta product formula, at least at the coefficient-counting
level.

Preferred endpoint:

Define even/odd one-dimensional lift-count functions and prove a general
finite coefficient formula:

```lean
def evenLiftCoeff (n : Nat) : Nat := ...
def oddLiftCoeff (n : Nat) : Nat := ...

theorem constructionA_shellCount_eq_weightEnumerator_sum
    (s : Int) :
    shell count at s =
      sum over codewords c in extendedHamming8 of
        product over coordinates of even/odd lift counts depending on c i := ...
```

Then specialize using the Hamming weight distribution `(1,14,1)`:

```lean
theorem hamming_thetaCoeff_from_weight_distribution
    (s : Int) :
    shell count at s =
      weightContribution 0 s + 14 * weightContribution 4 s +
      weightContribution 8 s := ...
```

Acceptable fallback:

- Prove the structural formula for all shells whose coordinate bound is
  already available in the finite range API.
- Extend the weight-enumerator derivation from coefficients `q^1` and `q^2`
  to `q^3`, `q^4`, and `q^5`.

Minimum useful result:

- One theorem replacing a pure `native_decide` shell count with a derivation
  from the Hamming weight distribution for a new coefficient beyond `q^2`.

## A7: Full theta-series identity moonshot

Profile: core, possibly draft.

Write scope:

```text
PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean
```

Optional trusted helper:

```text
PhysicsSM/Coding/E8ThetaSeriesQ6.lean
```

Goal: make an aggressive attempt at the full identity
`Theta_E8 = E4`, without faking missing modular-forms theory.

Preferred endpoint:

```lean
theorem thetaCoeffE8_eq_e4Coeff_general (n : Nat) (hn : 0 < n) :
    Set.ncard {z : Fin 8 -> Int |
      z in e8IntLattice and sqNorm z = 4 * (n : Int)} =
    240 * sigma3 n := ...
```

Realistic fallback endpoints:

1. Prove coefficient `q^6` with a complete coordinate-bound/spike
   decomposition.
2. Prove a conditional theorem:

```lean
theorem thetaE8_eq_e4_of_modular_form_uniqueness
    (hModular : suitable modular-form uniqueness hypothesis)
    (hFirstCoeff : suitable normalization hypothesis) :
    thetaE8PowerSeries = e4PowerSeries := ...
```

3. Replace the two moonshot `sorry`s with a documented draft theorem whose
   hypotheses exactly identify the missing modular-forms theorem.

Minimum useful result:

- Either one more trusted theta coefficient or a cleaner theorem statement
  that prevents the manuscript from overstating the theta result.

## A8: Positive-definite E8 Gram certificate and uniqueness frontier

Profile: core.

Write scope:

```text
PhysicsSM/Draft/E8EvenUnimodularUniqueness.lean
```

Optional trusted helper:

```text
PhysicsSM/Lie/Exceptional/E8PositiveDefinite.lean
```

Goal: split the achievable part from the huge classification theorem.

First target:

```lean
theorem e8Gram_posDef : IsPosDef_over_reals e8Gram := ...
```

Preferred proof route:

- Provide an explicit Cholesky, LDL, or sum-of-squares certificate for
  `x^T e8Gram x > 0` when `x != 0`.
- Alternatively prove Sylvester's criterion by computing all leading principal
  minors and connecting to Mathlib's positive-definite API.

Second target, moonshot:

```lean
theorem e8_even_unimodular_uniqueness
    (G : Matrix (Fin 8) (Fin 8) Int)
    (hSymm : G.IsSymm)
    (hEven : IsEvenGram G)
    (hUnimod : IsUnimodularGram G)
    (hPosDef : IsPosDef_over_reals G) :
    IntCongruent G e8Gram := ...
```

Hard constraint:

- Do not leave a fake proof of the classification theorem. If the full proof
  is too large, keep that theorem in draft and instead improve the blocker
  documentation with exact mathlib APIs and any trusted precursor lemmas.

Minimum useful result:

- Close `e8Gram_posDef` and leave the full classification as the only
  remaining `sorry` in this file.

## A9: Weyl orbit and permutation packaging

Profile: core.

Write scope:

```text
PhysicsSM/Coding/HammingConstructionAE8Final.lean
```

Optional helper:

```text
PhysicsSM/Algebra/Octonion/E8WeylPublication.lean
```

Goal: make the Weyl material citation-ready and, if possible, strengthen it
from list-closure facts to permutation-action facts.

Current available files:

```text
PhysicsSM/Algebra/Octonion/E8WeylBasic.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbit.lean
PhysicsSM/Algebra/Octonion/E8WeylPermutations.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean
```

Preferred endpoints:

```lean
theorem simpleReflection_permutes_rootSubtype
    (i : Fin 8) :
    Function.Bijective (simple reflection on root subtype) := ...

theorem simpleClosure_from_firstRoot_covers_rootList : ...

theorem rootWordTable_correct : ...

theorem rootWordTable_length_le : ...
```

Then re-export stable aliases from the final theorem index.

Minimum useful result:

- The existing orbit-convergence theorems become part of the citation-friendly
  manuscript theorem index.

## A10: Root import hygiene and draft split

Profile: core, engineering-heavy but useful for Aristotle if it can repair
imports automatically.

Write scope:

```text
PhysicsSM.lean
```

Optional new root:

```text
PhysicsSMDraft.lean
```

Goal: the root `PhysicsSM.lean` currently imports some `PhysicsSM.Draft`
modules, including draft files with intentional `sorry`s. For publication,
the default root should either:

- import only trusted modules, or
- explicitly be documented as a development root rather than a trusted root.

Tasks:

1. Move draft imports to `PhysicsSMDraft.lean`, if that is compatible with CI.
2. Keep `PhysicsSM.lean` as the trusted no-sorry root.
3. Make sure default target behavior matches the repository's intended CI.

Minimum useful result:

- A clean separation between trusted theorem imports and draft frontier imports.

This is not a proof-search job, so it should be lower priority than A1-A9.

## Recommended first submissions

Submit these first:

```text
A1 publication theorem-index consolidation
A2 SPL-free coordinate equivalence
A3 direct SPL imported theorem package
A5 half-integer model equality
A8 positive-definite E8 Gram certificate
```

Then submit the stretch wave:

```text
A4 native-trust reduction
A6 structural theta product
A7 full theta moonshot
A9 Weyl packaging
A10 root import hygiene
```

## Example submit command

For a core-profile job:

```powershell
& "$env:USERPROFILE\.local\bin\aristotle.exe" submit `
  --project-dir "C:/Projects/StandardModel" `
  --destination "AgentTasks/aristotle-output/<job-output-name>" `
  "<paste the job prompt here>"
```

For the SPL-profile job, use an SPL-enabled copy of the project as
`--project-dir`; do not enable the upstream SPL dependency directly in the
native Windows working tree.
