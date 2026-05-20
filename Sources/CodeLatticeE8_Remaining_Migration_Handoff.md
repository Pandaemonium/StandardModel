# CodeLatticeE8 Remaining Migration Handoff

Date: 2026-05-20

Audience: Claude or the next proof/migration agent.

Purpose: continue migrating the Hamming-to-E8 development from the research
workspace under `PhysicsSM` into the elegant, polished, reviewer-facing package
`CodeLatticeE8`.

## Executive Summary

The clean package now exists and builds:

```text
CodeLatticeE8.lean
CodeLatticeE8SPL.lean
CodeLatticeE8Draft.lean
```

The default root `CodeLatticeE8.lean` is intended to be the paper-facing,
standalone, Mathlib-only package.  It must not import `PhysicsSM.*`, draft
files, or direct Sphere-Packing-Lean files.

Current promoted content:

- binary vectors and binary linear codes;
- code equivalence under coordinate permutation;
- the `[n,k,d]` predicate;
- the concrete extended Hamming `[8,4,4]` code;
- structural weight distribution and parameter theorems;
- self-duality and Type II status for the Hamming code;
- uniqueness of binary linear `[8,4,4]` codes up to equivalence;
- Construction A as an integer subgroup of `Z^8`;
- the mod-four norm theorem for doubly-even codes;
- the Hamming Construction A minimum unscaled norm theorem;
- explicit Hamming Construction A basis vectors;
- a spanning theorem for that basis;
- the raw and scaled Gram matrices;
- determinant proofs for the raw Gram determinant `256` and scaled determinant
  `1`;
- scaled minimum squared norm `2`;
- a thin publication theorem index.

The main remaining pieces are:

1. short-vector enumeration and completeness;
2. the 240-root list and semantic root classification;
3. the bridge between Construction A short vectors and the root list;
4. local Cartan-matrix comparison;
5. optional SPL bridge;
6. Weyl-reflection/orbit material;
7. local theta coefficient/convolution results;
8. SPL-dependent or conditional analytic theta material.

## Nonnegotiable Rules For The Clean Package

For files imported by `CodeLatticeE8.lean`:

- all code should be elegant and publication-worthy
- no `import PhysicsSM...`;
- no `sorry`;
- no `admit`;
- no `axiom`;
- no `opaque`;
- no `unsafe`;
- no job-provenance names such as `Aristotle`, `NoNative`, `Final`,
  `Imported`, or `Helper` in public module names or theorem names;
- no silent convention changes;
- no weakening theorem statements merely to make proofs pass;
- no direct SPL imports.

Prefer to keep `CodeLatticeE8` free of `native_decide`.  If a finite
enumeration proof is genuinely the right final artifact, isolate it, document
its trust profile in the module docstring and theorem index, and update the
manuscript table.  The current promoted package has avoided `native_decide` in
public trusted files where possible.

For `CodeLatticeE8SPL.lean`:

- direct Sphere-Packing-Lean imports are allowed;
- do not import `CodeLatticeE8SPL` from `CodeLatticeE8.lean`;
- keep Windows/SPL caveats documented.

For `CodeLatticeE8Draft.lean`:

- documented `sorry`s are allowed;
- use draft files for conditional theta arguments and incomplete real-lattice
  bridges;
- every `sorry` should include a proof handoff note.

## Current Clean Package Layout

Current files:

```text
CodeLatticeE8/
  Code/
    Binary.lean
    Dual.lean
    Equivalence.lean
    Hamming844.lean
    Hamming844Basic.lean
    Hamming844Permutation.lean
    Hamming844Systematic.lean
    Hamming844Uniqueness.lean
    Hamming844WeightEnumerator.lean
    LinearCode.lean

  ConstructionA/
    Basic.lean
    Even.lean
    Norm.lean

  E8/
    Basis.lean
    Determinant.lean
    Gram.lean
    HammingConstruction.lean
    Minimum.lean
    Span.lean

  Publication/
    TheoremIndex.lean
```

Root files:

```text
CodeLatticeE8.lean
CodeLatticeE8SPL.lean
CodeLatticeE8Draft.lean
```

Each newly promoted theorem cluster should update:

1. the target Lean module docstring;
2. `CodeLatticeE8/Publication/TheoremIndex.lean`;
3. `CodeLatticeE8.lean`, if the root description changes materially;
4. `Sources/Hamming_ConstructionA_E8_Manuscript_Revision.md`;
5. `Sources/Hamming_E8_Clean_Packaging_Plan.md`, if the plan status changes.

## Important Recent Lesson: Determinants

Do not ask Lean to evaluate the full `8 x 8` determinant directly.  A direct
test of

```lean
example : hammingConstructionGram.det = 256 := by
  native_decide
```

hit deep recursion.

The clean solution is in:

```text
CodeLatticeE8/E8/Determinant.lean
```

The proof strategy:

1. define `hammingConstructionBasisMatrix`;
2. split rows/columns into `{0,1,2,3}` and `{4,5,6,7}`;
3. use `Matrix.twoBlockTriangular_det`;
4. compute the small block determinants `-1` and `16`;
5. prove `hammingConstructionBasisMatrix.det = -16`;
6. derive `hammingConstructionGram.det = 256` from `B * B.transpose`;
7. derive `hammingConstructionScaledGram.det = 1` from `Matrix.det_smul`.

Follow this pattern for future finite matrix facts: expose mathematical
structure, avoid giant raw evaluators.

## Suggested Migration Order

### 0. Start With An Inventory Table

Before each cluster, make or update a small table with:

- declaration name in the source namespace;
- current source file;
- whether it is sorry-free;
- whether it uses `native_decide`;
- whether it imports SPL;
- intended clean destination;
- manuscript citation status;
- whether it should be renamed or split.

Useful commands:

```powershell
rg --files PhysicsSM/Coding | rg "E8|Theta|ConstructionA|Hamming|Short|Sphere|Half"
rg --files PhysicsSM/Algebra/Octonion | rg "E8|Integral|Weyl|Root"
rg --files PhysicsSM/Draft | rg "E8|Theta|Hamming|ConstructionA|Root|Sphere|Cartan|Weyl|Short|NoNative"
rg -n "sorry|admit|axiom|unsafe|native_decide" PhysicsSM/Coding PhysicsSM/Algebra/Octonion PhysicsSM/Draft
```

Do not copy a source file wholesale.  Port the mathematical core into a clean
module with clean imports and reviewer-facing names.

### 1. Short Vectors

Target:

```text
CodeLatticeE8/E8/ShortVectors.lean
```

Likely source files:

```text
PhysicsSM/Coding/E8ShortVectors.lean
PhysicsSM/Draft/E8ShortVectorsStructuralAristotle.lean
PhysicsSM/Draft/E8ShortVectorsNoNativeAristotle.lean
PhysicsSM/Coding/HammingConstructionAE8Final.lean
```

Goal:

- define the short shell in clean-package terms;
- prove every listed short vector lies in `hammingConstructionA`;
- prove every listed short vector has `sqNorm = 4`;
- prove completeness of the short-vector classification;
- prove the short shell has cardinality `240`.

Preferred public theorem shapes:

```lean
def isShortHammingE8Vector (z : Fin 8 -> Int) : Prop := ...

def shortHammingE8VectorList : List (Fin 8 -> Int) := ...

theorem mem_shortHammingE8VectorList_iff
    (z : Fin 8 -> Int) :
    z in shortHammingE8VectorList <-> isShortHammingE8Vector z := ...

theorem shortHammingE8VectorList_nodup :
    shortHammingE8VectorList.Nodup := ...

theorem shortHammingE8VectorList_length :
    shortHammingE8VectorList.length = 240 := ...

theorem hammingConstructionA_short_vector_count :
    Set.ncard {z : Fin 8 -> Int | z in hammingConstructionA /\ sqNorm z = 4} = 240 := ...
```

Naming can be adjusted to match existing package style.  The important point is
that the count should be tied semantically to `hammingConstructionA` and
`sqNorm`, not only to an isolated list.

Implementation guidance:

- Prefer the structural proof in `E8ShortVectorsStructuralAristotle.lean` over
  raw list evaluation if it ports cleanly.
- Reuse `extendedHamming8_weight_distribution` and the Construction A parity
  facts already promoted.
- Keep the normalization explicit: short means unscaled `sqNorm = 4`, which is
  scaled norm `2`.
- If a list is retained, separate list mechanics from semantic shell
  theorems.

### 2. Root List And Semantic Root Classification

Target:

```text
CodeLatticeE8/E8/Roots.lean
```

Likely source files:

```text
PhysicsSM/Algebra/Octonion/IntegralOctonion.lean
PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean
PhysicsSM/Draft/E8RootSemanticHelpers.lean
PhysicsSM/Draft/E8RootSemanticAristotle.lean
```

Goal:

- port the doubled-coordinate E8 root predicate;
- port or recreate the explicit 240-element root list;
- prove length, no duplicates, and semantic completeness;
- avoid importing the project octonion implementation unless genuinely needed.

Recommended clean namespace:

```lean
namespace CodeLatticeE8.E8.Roots
```

Possible public declarations:

```lean
def normSqD (v : Fin 8 -> Int) : Int := ...
def dotD (v w : Fin 8 -> Int) : Int := ...
def IsE8RootD (v : Fin 8 -> Int) : Prop := ...
def rootList : List (Fin 8 -> Int) := ...

theorem rootList_length : rootList.length = 240 := ...
theorem rootList_nodup : rootList.Nodup := ...
theorem mem_rootList_iff_isE8RootD
    (v : Fin 8 -> Int) : v in rootList <-> IsE8RootD v := ...
theorem rootList_normSqD
    (v : Fin 8 -> Int) (hv : v in rootList) : normSqD v = 8 := ...
```

Notes:

- The source file lives under `PhysicsSM/Algebra/Octonion`, but much of the
  root-list content is just integer vectors.  Extract that integer-vector
  content first.
- Keep the convention note: these are doubled coordinates.  Actual E8 root
  norm squared is `2`; doubled-coordinate norm squared is `8`.
- The source file currently uses finite enumeration proofs.  Look at the
  semantic Aristotle files before accepting list-only proof style.

### 3. Construction A Short Shell To Root List Bridge

Target:

```text
CodeLatticeE8/E8/RootBridge.lean
```

Likely source files:

```text
PhysicsSM/Coding/E8RootBridge.lean
PhysicsSM/Coding/E8RootBridgeIsometry.lean
PhysicsSM/Coding/HammingConstructionAE8Final.lean
PhysicsSM/Draft/E8ShellBridgeHelper.lean
PhysicsSM/Draft/E8ShellBridgeNoNativeAristotle.lean
```

Goal:

- show the Construction A short shell corresponds to the 240 root list;
- record the normalization map explicitly;
- prove the bridge preserves the relevant quadratic form.

Things to check carefully:

- source and target coordinate conventions;
- whether the bridge is identity, a permutation, a sign change, or a more
  substantial coordinate transform;
- unscaled Construction A norm `sqNorm = 4`;
- doubled-root norm `normSqD = 8`;
- scaled E8 norm `sqNorm / 2 = 2`.

Preferred public theorem shapes:

```lean
def constructionAShortToRootD (z : Fin 8 -> Int) : Fin 8 -> Int := ...

theorem constructionAShortToRootD_mem_rootList
    {z : Fin 8 -> Int}
    (hz : z in hammingConstructionA) (hsq : sqNorm z = 4) :
    constructionAShortToRootD z in Roots.rootList := ...

theorem rootList_mem_to_constructionAShort
    {r : Fin 8 -> Int} (hr : r in Roots.rootList) :
    exists z, z in hammingConstructionA /\ sqNorm z = 4 /\
      constructionAShortToRootD z = r := ...
```

If the source proof uses an explicit permutation theorem such as `bridge_perm`,
give it a mathematical name, not a provenance name.

### 4. Local Cartan Bridge

Targets:

```text
CodeLatticeE8/E8/CartanBridge.lean
```

Optional split if the file grows:

```text
CodeLatticeE8/E8/Cartan.lean
CodeLatticeE8/E8/CartanBridge.lean
```

Likely source files:

```text
PhysicsSM/Coding/E8SpherePackingShape.lean
PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
```

Goal:

- define or import a clean local E8 Cartan matrix without importing the
  research namespace;
- prove the Cartan determinant and diagonal facts if needed locally;
- prove a clean transition/congruence statement between the local scaled Gram
  matrix and the Cartan matrix;
- keep any direct SPL comparison out of this file.

Guidance:

- If the clean package needs only an explicit matrix comparison, define the
  Cartan matrix locally in `CodeLatticeE8.E8`.
- If the existing proof imports broad `PhysicsSM.Lie.Exceptional.*` modules,
  do not carry that dependency into the clean root.  Recreate the small matrix
  facts locally.
- If there is a direct comparison with SPL's `E8Matrix`, put that in
  `CodeLatticeE8SPL`, not in `CodeLatticeE8`.
- Avoid huge determinant evaluation.  Use structured matrix proof patterns
  analogous to `E8/Determinant.lean`.

### 5. Optional SPL Bridge

Targets:

```text
CodeLatticeE8/SPL/BasisBridge.lean
CodeLatticeE8/SPL/ShellBridge.lean
CodeLatticeE8/SPL/ThetaBridge.lean
```

Root:

```text
CodeLatticeE8SPL.lean
```

Likely source files:

```text
PhysicsSM/Draft/E8SpherePackingImported.lean
PhysicsSM/Draft/E8SpherePackingBridge.lean
PhysicsSM/Coding/E8SpherePackingCoordinateBridge.lean
PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
PhysicsSM/Coding/E8HalfIntegerBasisBridge.lean
PhysicsSM/Coding/E8HalfIntegerBridge.lean
```

Goal:

- expose a clean bridge from local `CodeLatticeE8` objects to SPL's E8 model;
- keep the bridge optional;
- never import the SPL root into `CodeLatticeE8.lean`.

Windows/SPL caveat:

- The repo currently uses a local Windows-safe SPL fork path in `lakefile.toml`.
- Upstream SPL has `Aux.lean` filenames that are reserved names on Windows.
- Preserve the optional root boundary to avoid making the core package
  platform-sensitive.

### 6. Weyl Cluster

Targets:

```text
CodeLatticeE8/E8/WeylReflections.lean
CodeLatticeE8/E8/WeylOrbit.lean
CodeLatticeE8/E8/WeylPermutations.lean
```

Likely source files:

```text
PhysicsSM/Algebra/Octonion/E8WeylBasic.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbit.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean
PhysicsSM/Algebra/Octonion/E8WeylPermutations.lean
PhysicsSM/Algebra/Octonion/E8WeylPublication.lean
PhysicsSM/Draft/E8WeylSemanticAristotle.lean
```

Goal:

- package the verified Weyl-reflection and orbit material as an E8-structure
  strengthening;
- keep it separate from the central Construction A theorem chain so it does
  not block the paper package.

Guidance:

- Port this after `Roots.lean` and `RootBridge.lean` are stable.
- Prefer root-list based statements to octonion-specific statements unless the
  octonion interpretation is essential.
- The manuscript can cite this as an appendix-level strengthening.
- Watch for large finite computations.  If retained, document the trust
  profile.

### 7. Local Theta Coefficients And Convolution

Targets:

```text
CodeLatticeE8/ConstructionA/ThetaConvolution.lean
CodeLatticeE8/E8/ThetaConvolution.lean
CodeLatticeE8/E8/ThetaCoefficients.lean
```

Likely source files:

```text
PhysicsSM/Coding/ConstructionAConvolutionHelpers.lean
PhysicsSM/Coding/ConstructionAThetaConvolution.lean
PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean
PhysicsSM/Coding/E8ThetaSeries.lean
PhysicsSM/Coding/E8ThetaSeriesQ5.lean
PhysicsSM/Coding/E8ThetaSeriesQ6.lean
PhysicsSM/Coding/E8ThetaSigmaBridge.lean
PhysicsSM/Draft/ConstructionAThetaBoundedShellAristotle.lean
PhysicsSM/Draft/ConstructionAThetaConvolutionAristotle.lean
PhysicsSM/Draft/ConstructionAThetaNoNativeAristotle.lean
```

Core-safe theta content:

- finite shell counts;
- Construction A convolution identities;
- weight-enumerator bridge statements;
- coefficient checks through the currently proved range;
- no analytic modular-form assumptions;
- no SPL imports.

Keep these normalizations explicit:

```text
theta coefficient index n counts the unscaled shell sqNorm z = 4 * n.
```

Suggested public theorem names:

```lean
def hammingThetaConvolutionCoeff (n : Nat) : Int := ...

theorem hammingThetaConvolutionCoeff_zero : ... := ...
theorem hammingThetaConvolutionCoeff_one : ... := ...
theorem hammingThetaConvolutionCoeff_two : ... := ...

theorem hammingThetaCoeff_eq_e4Coeff_of_le_six
    (n : Nat) (hn : n <= 6) : ... := ...
```

Use actual statements that align with existing definitions.  The names above
are only a sketch.

### 8. Conditional Or SPL-Dependent Theta Material

Targets:

```text
CodeLatticeE8Draft/Theta...      -- if conditional or still sorry-backed
CodeLatticeE8/SPL/ThetaBridge.lean
CodeLatticeE8SPL.lean
```

Likely source files:

```text
PhysicsSM/Draft/E8ThetaDim8MF.lean
PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean
PhysicsSM/Draft/E8ThetaSPLBridge.lean
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
PhysicsSM/Draft/E8QExpansionExtraction.lean
PhysicsSM/Draft/ThetaDuplicationIdentities.lean
PhysicsSM/Draft/ThetaDuplicationProof.lean
```

Trust tiers:

1. Core: local finite coefficients and convolution identities.  These can go
   under `CodeLatticeE8`.
2. Optional SPL: sorry-free results that depend directly on SPL modular-form or
   E8 infrastructure.  These go under `CodeLatticeE8SPL`.
3. Draft: conditional analytic bridges, q-expansion transport gaps, theta
   duplication identities with incomplete proofs, or any file with documented
   `sorry`.  These stay under `CodeLatticeE8Draft`.

Do not claim the full formal power series identity `Theta_E8 = E4` in the core
package unless the coefficient/q-expansion bridge is genuinely closed and
kernel-checked.

### 9. Generic Type II Real-Lattice Bridge

Possible targets:

```text
CodeLatticeE8/ConstructionA/Dual.lean
CodeLatticeE8/ConstructionA/TypeII.lean
CodeLatticeE8Draft/ConstructionA/RealBridge.lean
```

Likely source file:

```text
PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

Guidance:

- The integer-coordinate self-duality and Type II code facts are already
  promoted for the concrete Hamming code.
- Generic real/scaled-lattice statements have been harder and should not block
  the core package.
- Promote small integer-coordinate lemmas first.
- Keep real-coordinate or dual-lattice API in draft until the statement and
  proof are stable.

## Verification Checklist After Each Cluster

Run the narrow build first:

```powershell
lake build CodeLatticeE8.E8.ShortVectors
```

or the relevant module.

Then run:

```powershell
lake build CodeLatticeE8
```

Run clean-package scans:

```powershell
rg -n "^import .*PhysicsSM|\bsorry\b|\badmit\b|\baxiom\b|\bunsafe\b|\bopaque\b" CodeLatticeE8 CodeLatticeE8.lean CodeLatticeE8SPL.lean CodeLatticeE8Draft.lean
rg -n "Aristotle|NoNative|Final|Helper|Imported|PhysicsSM" CodeLatticeE8 CodeLatticeE8.lean CodeLatticeE8SPL.lean CodeLatticeE8Draft.lean
```

If the cluster intentionally uses finite computation, also search for it and
document it:

```powershell
rg -n "native_decide|trustCompiler" CodeLatticeE8 CodeLatticeE8.lean
```

Before handing back:

```powershell
pre-commit run --all-files
lake build
```

As of this handoff, `lake build` passes but prints many pre-existing linter
warnings in old `PhysicsSM` files.  Do not treat those old warnings as part of
the clean package migration unless the current task touches those files.

## Documentation Checklist

Every promoted cluster should include:

- a module docstring saying what the module proves;
- convention notes for scaling, basis order, coordinate order, root
  normalization, and theta index normalization where relevant;
- source/provenance notes in docstrings for nontrivial imports from the
  research workbench;
- a theorem-index entry;
- manuscript table updates;
- a note if the theorem uses finite computation rather than a structural proof.

Avoid statements like "obvious", "just compute", or "final result".  The clean
package should read as if it was designed from the final mathematical story.

## Current Dirty Worktree Caveat

At the time this handoff was written, the worktree was not clean.  Known dirty
items included:

```text
PhysicsSMDraft.lean
Sources/Hamming_ConstructionA_E8_Manuscript_Revision.md
Sources/Hamming_E8_Clean_Packaging_Plan.md
lakefile.toml
CodeLatticeE8.lean
CodeLatticeE8/
CodeLatticeE8Draft.lean
CodeLatticeE8SPL.lean
several PhysicsSM/Draft/Hamming844*NoNativeAristotle.lean files
```

Do not revert unrelated changes.  If a file already has user or prior-agent
edits, read it before modifying it.

## High-Level Desired End State

The reviewer-facing package should eventually look like this:

```text
CodeLatticeE8/
  Code/
    Binary.lean
    Dual.lean
    Equivalence.lean
    Hamming844.lean
    Hamming844WeightEnumerator.lean
    Hamming844Uniqueness.lean
    LinearCode.lean

  ConstructionA/
    Basic.lean
    Norm.lean
    Even.lean
    ThetaConvolution.lean

  E8/
    HammingConstruction.lean
    Basis.lean
    Span.lean
    Gram.lean
    Determinant.lean
    Minimum.lean
    ShortVectors.lean
    Roots.lean
    RootBridge.lean
    CartanBridge.lean
    WeylReflections.lean
    WeylOrbit.lean
    WeylPermutations.lean
    ThetaConvolution.lean
    ThetaCoefficients.lean

  SPL/
    BasisBridge.lean
    ShellBridge.lean
    ThetaBridge.lean

  Publication/
    TheoremIndex.lean
```

Only import the pieces that are fully trusted into `CodeLatticeE8.lean`.
Optional SPL files should be imported by `CodeLatticeE8SPL.lean`.  Conditional
or unfinished files should be imported by `CodeLatticeE8Draft.lean`.

## First Concrete Task Recommendation

Start with `CodeLatticeE8/E8/ShortVectors.lean`.

Reason:

- it directly follows the already promoted minimum-norm and determinant
  material;
- it is central to the manuscript's kissing-number claim;
- it unlocks the root bridge and makes the later Cartan/Weyl material more
  natural;
- there are already source files and Aristotle outputs specifically aimed at
  structural/no-native versions.

Suggested first pass:

1. Read `CodeLatticeE8/E8/HammingConstruction.lean`,
   `CodeLatticeE8/E8/Minimum.lean`, and `CodeLatticeE8/E8/Determinant.lean`.
2. Read `PhysicsSM/Coding/E8ShortVectors.lean`.
3. Read `PhysicsSM/Draft/E8ShortVectorsStructuralAristotle.lean`.
4. Draft a clean `ShortVectors.lean` module docstring and definitions.
5. Port one semantic theorem at a time.
6. Build after each theorem.
7. Only update the root and manuscript once the module is clean.
