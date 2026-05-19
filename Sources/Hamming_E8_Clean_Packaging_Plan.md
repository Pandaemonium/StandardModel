# Clean Packaging Plan for the Hamming-to-E8 Lean Development

Status: planning draft.

This document proposes how to repackage the current Hamming-to-E8 Lean work
into cleaner, reviewable packages.  The current `PhysicsSM` repository should
be treated as the research workbench: it records the full history of exploratory
formalization, Aristotle handoffs, SPL bridges, theta-series work, manuscript
notes, and physics-adjacent experiments.  A publishable Lean artifact should be
smaller, more direct, and organized around the mathematical story of the paper.

The goal is not to erase the research history.  The goal is to extract from it
a package that reads as if it were designed around the final theorem chain.

## Executive Recommendation

Create a clean package tentatively named:

```text
CodeLatticeE8
```

This package should contain the finite/combinatorial Hamming-to-E8 development
and should build without Sphere-Packing-Lean by default.  SPL-dependent bridges
should live behind a separate root file or package extension.

Recommended split:

```text
CodeLatticeE8
  Core Hamming -> Construction A -> E8 development

CodeLatticeE8SPL
  Optional bridge to Sphere-Packing-Lean's E8 objects and theta infrastructure

CodeLatticeE8Draft
  Temporary staging area for in-progress or conditional results
```

Longer term, the generic Construction A theorem for Type II codes could become
either:

1. a small reusable sublibrary inside `CodeLatticeE8`;
2. a separate coding/lattice package;
3. eventually a mathlib contribution, if the surrounding coding-theory API is
   mature enough.

For now, keep it local to `CodeLatticeE8`.  It is too useful to omit, but too
large to force upstream before the paper package is stable.

## Package Boundaries

### Package 1: `CodeLatticeE8`

This is the main paper package.  It should contain:

- binary vectors and binary linear codes over `ZMod 2`;
- Hamming weight and binary dot product;
- dual codes, self-duality, doubly-evenness, and Type II codes;
- the extended `[8,4,4]` Hamming code;
- the weight enumerator of the extended Hamming code;
- Construction A as an integer subgroup;
- the generic Type II Construction A theorem, once polished;
- the explicit rank-eight Construction A basis;
- the scaled Gram matrix and determinant;
- short-vector enumeration;
- root-list, octonionic-root, Weyl-reflection, and Cartan comparisons that do
  not require SPL;
- theta-series coefficient statements whose dependencies are local and
  sorry-free.

The root file should be something like:

```text
CodeLatticeE8.lean
```

and should import only trusted, sorry-free files.

### Package 2: `CodeLatticeE8SPL`

This should be optional.  It should not be imported by `CodeLatticeE8.lean`.

It should contain:

- the bridge from the local Construction A E8 model to SPL's E8 model;
- any theorem transporting local shell counts to SPL's E8 shells;
- the theta-series bridge if it uses SPL modular-form infrastructure;
- possible PR-ready lemmas for SPL.

The root file should be:

```text
CodeLatticeE8SPL.lean
```

This keeps the core package lightweight and makes SPL failures or dependency
changes less disruptive.

### Package 3: `CodeLatticeE8Draft`

This is a staging root, not a publication target.  It may contain:

- conditional theta arguments;
- Aristotle handoff files while they are being integrated;
- exploratory generic Construction A statements;
- candidate SPL PR files before they are cleaned.

The root file should be:

```text
CodeLatticeE8Draft.lean
```

It may import files with documented `sorry`s.  It should never be the root used
for the paper's kernel-checked theorem table.

## Trust Boundaries

The clean package should distinguish three different issues that are easy to
blur in the research repo:

1. **Sorry-free status.** Trusted roots must not import declarations with
   `sorry`, `admit`, fake axioms, or unsafe placeholders.
2. **SPL dependency.** Direct imports from Sphere-Packing-Lean belong behind
   `CodeLatticeE8SPL.lean`, not the default `CodeLatticeE8.lean`.
3. **Finite-computation trust.** Some sorry-free results use `native_decide`
   over explicit finite lists, and therefore have `Lean.trustCompiler` in their
   axiom set. These results can be included in the clean package, but the
   theorem index and manuscript table should mark them clearly.

This is especially important for the Hamming `[8,4,4]` uniqueness theorem, the
240-root list, root-list bridges, and Weyl-orbit computations.  They are
mathematically valuable and should not be hidden, but their trust profile is
different from small structural proofs that use only the Lean kernel plus the
usual classical axioms.

## Proposed Module Layout

The following layout is intentionally close to mathlib style: small modules,
descriptive names, theorem files grouped by mathematical object, and no job
names in module names.

```text
CodeLatticeE8/
  Code/
    Binary.lean
    HammingWeight.lean
    DotProduct.lean
    Dual.lean
    TypeII.lean
    Hamming844.lean
    Hamming844WeightEnumerator.lean
    Hamming844Uniqueness.lean

  ConstructionA/
    Basic.lean
    Norm.lean
    Even.lean
    Dual.lean
    TypeII.lean
    ThetaConvolution.lean

  E8/
    HammingConstruction.lean
    Basis.lean
    Gram.lean
    CartanBridge.lean
    Roots.lean
    RootBridge.lean
    ShortVectors.lean
    WeylReflections.lean
    WeylOrbit.lean
    WeylPermutations.lean
    ThetaConvolution.lean
    ThetaCoefficients.lean
    MainTheorems.lean

  SPL/
    BasisBridge.lean
    ShellBridge.lean
    ThetaBridge.lean
    SpherePackingBridge.lean

  Paper/
    MainTheorems.lean
    TheoremIndex.lean
```

The `Paper/` directory should remain optional and very thin.  If the name feels
too much like external documentation, use `Publication/` or keep the re-export
files directly under `E8/MainTheorems.lean` and `E8/TheoremIndex.lean`.

The Weyl files should not become a blocker for the main Hamming-to-E8
extraction.  They are important verified E8 structure and should be packaged,
but the paper narrative can cite them as a strengthening or appendix-level
cluster rather than making them central to the Construction A theorem chain.

Root files:

```text
CodeLatticeE8.lean
CodeLatticeE8SPL.lean
CodeLatticeE8Draft.lean
```

If retained, `Paper/` should re-export and bundle theorem statements cited by
the manuscript, not contain substantial proofs.

## Current-to-Clean Theorem Map

This table is a starting inventory, not a complete migration list.

| Current area | Clean destination | Notes |
|-------------|-------------------|-------|
| `PhysicsSM/Coding/ConstructionA.lean` | `CodeLatticeE8/ConstructionA/Basic.lean` and `Code/Binary.lean` | Split binary-code definitions from Construction A definitions. |
| `PhysicsSM/Coding/HammingSelfDual.lean` | `Code/Dual.lean`, `Code/TypeII.lean`, `Code/Hamming844.lean` | Generic dual-code API should be separated from the concrete Hamming code proof. |
| `PhysicsSM/Coding/Hamming844Classification.lean` | `Code/Hamming844Uniqueness.lean` | The uniqueness theorem is already sorry-free, but it uses finite computation and should be marked with the `native_decide` trust boundary. |
| `PhysicsSM/Coding/HammingWeightEnumerator.lean` | `Code/Hamming844WeightEnumerator.lean` | Include the concrete weight distribution and MacWilliams-style identity.  Later, extract general MacWilliams API if appropriate. |
| `PhysicsSM/Coding/ConstructionALatticeProperties.lean` | `ConstructionA/Norm.lean`, `ConstructionA/Even.lean` | Keep the mod-four norm lemma generic. |
| `PhysicsSM/Draft/ConstructionATypeIIAristotle.lean` | `ConstructionA/Dual.lean`, `ConstructionA/TypeII.lean` | Promote the integer-coordinate duality/evenness theorem first.  Keep real scaled-lattice API separate until its statement is stable. |
| `PhysicsSM/Coding/HammingConstructionAE8Final.lean` | `E8/MainTheorems.lean` and `Paper/MainTheorems.lean` | The final paper-facing root should be a clean theorem index. |
| `PhysicsSM/Coding/E8Basis*.lean` | `E8/Basis.lean`, `E8/Gram.lean` | Remove duplicate historical wrappers. |
| `PhysicsSM/Coding/E8ShortVectors*.lean` | `E8/ShortVectors.lean` | Keep the structural no-enumeration version if available. |
| `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean` | `E8/Roots.lean` | The 240-element doubled-coordinate E8 root list is significant and should be explicit in the clean layout.  Mark `native_decide` use. |
| `PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean` | `E8/Roots.lean` | Completeness of the root predicate/list belongs next to the root-list definitions. |
| `PhysicsSM/Coding/E8RootBridge.lean` | `E8/RootBridge.lean` | Dedicated bridge between Construction A short vectors and the octonionic E8 root list.  Distinctive paper result. |
| `PhysicsSM/Algebra/Octonion/E8WeylBasic.lean` | `E8/WeylReflections.lean` | Weyl reflection formula and root-list preservation.  Mark finite-computation trust boundary. |
| `PhysicsSM/Algebra/Octonion/E8WeylOrbit*.lean`, `E8WeylPermutations.lean` | `E8/WeylOrbit.lean`, `E8/WeylPermutations.lean` | Package as optional core-strengthening E8 structure.  Do not let this block the basic Construction A extraction. |
| `PhysicsSM/Coding/E8SpherePackingShape.lean` | `E8/CartanBridge.lean` | Local Gram/Cartan congruence belongs in core. |
| `PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean` | `E8/CartanBridge.lean` or `SPL/BasisBridge.lean` | Dependency-free clean-room SPL matrix comparison can stay in core if framed as a matrix comparison; direct SPL imports go under `SPL/`. |
| `PhysicsSM/Draft/E8SpherePackingImported.lean` | `SPL/BasisBridge.lean`, `SPL/SpherePackingBridge.lean` | This is the actual direct SPL import bridge and must remain outside the default root. |
| `PhysicsSM/Coding/ConstructionAThetaConvolution.lean` | `E8/ThetaConvolution.lean` | Local finite/combinatorial theta convolution belongs in core if sorry-free. |
| `PhysicsSM/Coding/E8ThetaSeries*.lean` | `E8/ThetaCoefficients.lean` | Finite checked coefficients, such as q^1 through q^6, belong in core if sorry-free. |
| `PhysicsSM/Draft/E8Theta*.lean` | `SPL/ThetaBridge.lean` or `CodeLatticeE8Draft` | Split by trust tier: local sorry-free pieces, SPL-dependent modular-form bridges, and open/draft analytic gaps. |
| `AgentTasks/*` | Not copied | Keep as provenance in research repo, not in the clean package. |

## Naming and Style Guidelines

Follow mathlib naming preferences where possible:

- namespaces should be short and mathematical, for example
  `CodeLatticeE8.Code`, `CodeLatticeE8.ConstructionA`, and
  `CodeLatticeE8.E8`;
- theorem names should describe the statement, not the proof source;
- avoid suffixes such as `Aristotle`, `NoNative`, `Helper`, `Final`, and
  `Imported` in the clean package;
- use lowercase theorem names with object-first naming, for example
  `ConstructionA.sqNorm_dvd_four_of_doublyEven`;
- use module docstrings at the top of every significant file;
- include source and convention notes for major definitions;
- keep imports small and local;
- avoid root files that import draft or SPL-dependent material by accident.

Examples of names to prefer:

```lean
ConstructionA.mem_iff_reduceModTwo_mem
ConstructionA.sqNorm_mod_four_eq_hammingWeight
ConstructionA.scaledDualInt_eq_self_of_selfDual
ConstructionA.scaledEven_of_doublyEven
ConstructionA.evenUnimodular_of_typeII
Hamming844.isTypeII
Hamming844.weightEnumerator
HammingConstructionE8.scaledGram_det
HammingConstructionE8.shortVector_card
```

Names to avoid in the cleaned package:

```lean
foo_aux
final_result
E8ThetaCoeffGapAristotle
E8ShellBridgeNoNativeAristotle
some_theorem_v2
```

The historical names may remain in `PhysicsSM` and `AgentTasks`; they just
should not be the public interface of the extracted package.

## Trusted, Draft, and Optional Roots

Use three roots with explicit trust boundaries:

```text
CodeLatticeE8.lean       trusted, no sorry, no SPL
CodeLatticeE8SPL.lean    trusted, no sorry, imports SPL
CodeLatticeE8Draft.lean  draft, may contain documented sorries
```

The manuscript theorem table should cite only declarations reachable from
`CodeLatticeE8.lean` or, for SPL-specific claims, `CodeLatticeE8SPL.lean`.

Draft modules should remain visible but not confusable with completed theorem
files.  A draft theorem with a `sorry` is a handoff marker, not a result.

## SPL-Facing Contribution Strategy

The strongest potential SPL contribution is not the whole Hamming-code
development.  It is the E8 theta-series and lattice-interface material that
fits naturally into SPL's existing goals.

Likely SPL-facing candidates:

1. A clean theorem that SPL's `E8Lattice` has theta series `E4`.
2. A q-expansion coefficient theorem for SPL's E8 theta series.
3. Small reusable dual-lattice or theta helper lemmas, if they are general and
   not project-specific.
4. Possibly a compact Construction A comparison theorem, if SPL maintainers
   want a coding-theoretic provenance bridge for their E8 model.

Less suitable for SPL:

- the full Hamming `[8,4,4]` uniqueness proof;
- the manuscript-specific theorem index;
- job provenance files;
- project-specific root-list bridges unrelated to SPL's existing E8 API;
- physics-facing commentary.

Recommended SPL PR path:

1. First produce a clean local `CodeLatticeE8SPL` module.
2. Remove all dependencies on the paper package except the minimum necessary
   bridge theorem.
3. Rename files and declarations to match SPL style.
4. Split helper lemmas into general and E8-specific files.
5. Open a small PR first, ideally one theorem cluster at a time.

Do not make the first SPL PR a giant import of the paper package.  A small,
reviewable PR has a much better chance of being accepted.

## Mathlib-Facing Possibilities

Some pieces could eventually belong in mathlib, but this should be later.

Good candidates after cleanup:

- binary Hamming weight lemmas for `Fin n -> ZMod 2`;
- dot-product and orthogonal-code API over finite fields;
- generic `dualCode` lemmas if mathlib has or wants a coding-theory namespace;
- a clean statement of the MacWilliams transform/identity for binary codes,
  starting from the concrete extended-Hamming identity if it generalizes
  naturally;
- generic Construction A definitions;
- the theorem that Type II binary codes give even unimodular Construction A
  lattices, once the lattice API statement is stable.

Reasons to wait:

- mathlib may prefer a more general coding-theory abstraction than this paper
  needs;
- the real-lattice packaging may need careful API design;
- pushing upstream too early can freeze awkward names or definitions.

## Extraction Procedure

### Phase 0: Freeze the research theorem inventory

Create a table listing:

- declaration name;
- current file;
- whether it is sorry-free;
- whether it depends on `native_decide` / `Lean.trustCompiler`;
- whether it uses SPL;
- whether it is cited by the manuscript;
- whether it is generic or E8-specific;
- intended clean destination.

This should be mechanical and reviewable.

Recommended inventory columns:

```text
declaration | current file | sorry-free? | native_decide/trustCompiler? |
SPL? | manuscript role | generic/E8-specific | destination | notes
```

Start from `PhysicsSM/Coding/HammingConstructionAE8Final.lean`, because it is
already a partial theorem index, then extend outward to the files it does not
fully cover: Hamming uniqueness, theta-series files, no-native replacements,
SPL bridges, octonionic roots, and Weyl-orbit files.  Do not move files before
this inventory exists; otherwise promotion will be ad hoc and easy to
duplicate.

### Phase 1: Create the clean package skeleton

Add:

```text
CodeLatticeE8/
CodeLatticeE8.lean
CodeLatticeE8SPL.lean
CodeLatticeE8Draft.lean
```

Initially, copy no proofs.  Add empty module docstrings and import roots.

### Phase 2: Move generic code API

Move or copy the generic binary-code and Construction A definitions first:

- binary vectors;
- Hamming weight;
- binary dot product;
- dual code;
- Type II predicate;
- Construction A membership;
- norm parity lemmas.

At this stage, no E8-specific code should be imported.

### Phase 3: Promote the generic Type II theorem

Promote the integer-coordinate dual theorem first.  Then, once complete and
reviewed, promote the real scaled lattice version.

Suggested final theorem stack:

```lean
ConstructionA.sqNorm_dvd_four_of_doublyEven
ConstructionA.scaledDualInt_eq_self_of_selfDual
ConstructionA.scaledEven_of_doublyEven
ConstructionA.scaledSelfDual_of_selfDual
ConstructionA.evenUnimodular_of_typeII
```

The exact final statement of `evenUnimodular_of_typeII` should match the chosen
real lattice API.  If that API is not yet mature, keep the integer-coordinate
theorem trusted and put the real theorem in draft until it is polished.

Fallback rule: do not let the real-coordinate bridge block the paper package.
If the real `1 / sqrt 2` lattice API is still awkward, promote:

```lean
ConstructionA.sqNorm_dvd_four_of_doublyEven
ConstructionA.scaledDualInt_eq_self_of_selfDual
ConstructionA.integerTypeII_package
```

to the trusted package and leave:

```lean
ConstructionA.scaledSelfDual_of_selfDual
ConstructionA.evenUnimodular_of_typeII
```

in `CodeLatticeE8Draft` with a clear statement of the missing API bridge.

### Phase 4: Move the Hamming `[8,4,4]` code

Move the concrete code only after the generic API is stable.

Target files:

```text
Code/Hamming844.lean
Code/Hamming844WeightEnumerator.lean
Code/Hamming844Uniqueness.lean
```

Avoid exposing parity-check-matrix implementation details in theorem names.

### Phase 5: Move the E8 Construction A model

Move:

- the Construction A integer lattice for Hamming844;
- explicit basis;
- span theorem;
- Gram theorem;
- scaled determinant theorem;
- short-vector theorem;
- Cartan comparison;
- octonionic 240-root list and completeness theorem;
- Construction A short-vector to octonionic-root bridge;
- Weyl-reflection closure, simple-reflection permutations, and orbit
  convergence, as a separate E8-structure cluster.

The first six items become the core Construction A package.  The root bridge is
also central if the manuscript cites the octonionic comparison.  The Weyl
cluster is valuable and should be packaged, but it should not block the basic
Hamming-to-E8 extraction.

### Phase 6: Move theta-series results

Separate theta files into three groups:

1. **Local, sorry-free, core.** Construction A theta convolution and finite
   coefficient checks, such as the q^1 through q^6 shell counts matching the
   `E4` coefficients.  These can go in `E8/ThetaConvolution.lean` and
   `E8/ThetaCoefficients.lean`.
2. **Conditional or SPL-dependent.** Modular-form comparison, q-expansion
   extraction, SPL theta-polynomial bridges, and theorem reductions that are
   sorry-free but depend on SPL or on analytic modular-form infrastructure.
   These belong in `CodeLatticeE8SPL` unless they can be made SPL-free.
3. **Open draft.** Any theorem still requiring a q-expansion transport lemma,
   theta-duplication identity, Sturm/dimension theorem not available in
   mathlib, or an all-coefficient representation formula not yet fully
   reviewed.  These belong in `CodeLatticeE8Draft`.

Only the first group belongs in the default core root.

The clean plan should avoid a single catch-all `E8/ThetaSeries.lean` file.
That name hides too many different trust/dependency levels.  Prefer small files
whose names reveal whether they are local finite combinatorics, SPL bridges, or
draft analytic arguments.

### Phase 7: Build paper theorem index

Create:

```text
CodeLatticeE8/E8/MainTheorems.lean
```

This should collect the declarations cited in the manuscript and provide short
docstrings explaining each theorem's role.  It should not contain long proofs.

If a separate publication namespace is desired, use `Publication/` rather than
`Paper/`, or keep `Paper/` as a thin alias layer only.  The theorem index should
make trust boundaries visible: no `sorry`, SPL or no SPL, and whether a theorem
uses finite computation through `native_decide`.

### Phase 8: Prepare SPL PR branch

From the cleaned `SPL/` modules, make a separate branch or extraction that can
be compared against SPL style.  The PR should be small and should not require
maintainers to review the whole paper package.

## Verification Targets

Every promoted file should pass a targeted check:

```text
lake build CodeLatticeE8.Path.To.Module
```

Before claiming a root is trusted:

```text
lake build CodeLatticeE8
```

For the optional SPL root:

```text
lake build CodeLatticeE8SPL
```

For a release candidate:

```text
pre-commit run --all-files
lake build
```

Also run a no-sorry scan over trusted roots.  Draft files may contain documented
handoff sorries, but the trusted roots should not import them.

Add a lightweight import hygiene check for the default root.  At minimum, grep
the clean root imports for research-phase names:

```text
Aristotle
NoNative
Helper
Imported
AgentTasks
SpherePacking
```

Some words may appear legitimately in comments, but they should not appear in
public module names imported by `CodeLatticeE8.lean`.  `SpherePacking` should
only appear under the optional `CodeLatticeE8SPL` root.

Also run an axiom/trust audit for the theorem index.  The goal is not to ban
all `native_decide` results, but to record which cited theorems depend on
`Lean.trustCompiler`.

## Provenance Policy

The clean package should preserve provenance without preserving workflow noise.

Keep:

- source references in module docstrings;
- convention notes for scaling, norms, Gram matrices, basis order, and theta
  indexing;
- theorem comments explaining why a statement matters.

Do not keep in public theorem names:

- Aristotle job IDs;
- agent names;
- retry numbers;
- "no native" implementation history;
- temporary file names.

Historical provenance remains in `AgentTasks/` and `Sources/` in the research
repo.  The clean package should cite sources and mathematical conventions, not
the path by which the proof was discovered.

## Suggested Public Narrative

The cleaned package should support this simple narrative:

```text
1. Define binary linear codes over ZMod 2.
2. Define Type II codes.
3. Prove generic Type II Construction A even/unimodular facts.
4. Define the extended Hamming [8,4,4] code.
5. Prove it is Type II and has the expected weight enumerator.
6. Apply Construction A.
7. Exhibit the E8 Gram data, roots, short vectors, and theta coefficients.
8. Package Weyl/reflection/orbit facts as an E8-structure strengthening.
9. Optionally bridge to SPL's E8 model and theta infrastructure.
```

That story is more compelling than the current research-repo structure because
it lets a reader understand the proof in the same order as the mathematics.

## Risks and Mitigations

### Risk: moving code breaks hidden dependencies

Mitigation: copy first, then delete or deprecate only after the clean package
builds.  Keep `PhysicsSM` intact until the extraction stabilizes.

### Risk: generic APIs become over-engineered

Mitigation: generalize only where the paper already needs it.  For example,
generic Type II Construction A is worthwhile; a full coding-theory hierarchy is
not needed for this paper.

### Risk: SPL-facing files import too much local code

Mitigation: keep the SPL root separate and inspect its import graph.  The SPL
PR should contain a small theorem cluster, not the whole paper package.

### Risk: theorem statements are correct but awkward

Mitigation: before moving a theorem into `CodeLatticeE8.lean`, check:

- Is this the mathematical statement the manuscript needs?
- Are scaling and norm conventions explicit?
- Is the theorem name stable?
- Does the theorem belong in a generic module or an E8-specific module?

## Near-Term Action List

1. Inventory all theorem declarations used by the manuscript theorem table,
   starting from `HammingConstructionAE8Final.lean` and extending to roots,
   Weyl, theta, SPL, and no-native files.
2. Mark each declaration by sorry-free status, SPL dependency, and
   `native_decide` / `Lean.trustCompiler` dependency.
3. Create the `CodeLatticeE8` skeleton in a branch or subdirectory.
4. Promote generic code and integer-coordinate Construction A modules first.
5. Promote Hamming844, root-list, root-bridge, basis/Gram, and short-vector
   modules second.
6. Promote Weyl/orbit modules as a distinct E8-structure cluster, not as a
   blocker for the Construction A core.
7. Keep theta and SPL bridges separated by trust/dependency tier.
8. Put real Type II scaled-lattice statements in draft if their API is not yet
   clean enough for the core root.
9. Update the manuscript theorem table to cite the clean package declarations.

The best end state is three artifacts:

```text
PhysicsSM
  Research workbench and historical development.

CodeLatticeE8
  Clean, paper-facing Lean package.

SPL PR branch
  Small upstreamable theorem cluster, probably theta/E8-facing.
```
