# Aristotle task: Baez-DVT Lie stabilizer prelude

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: Moonshot
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `bceacd0d-e4bf-4121-ac4b-2f57c465d985`
**Submission project**: `AgentTasks/aristotle-submit/baez-dvt-lie-stabilizer-prelude-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-lie-stabilizer-prelude-20260529`
**Extracted output**: `AgentTasks/aristotle-output/baez-dvt-lie-stabilizer-prelude-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Jordan/DVTStabilizerPrelude.lean`
**Type**: definition / proof / Lie-algebra scaffold

## Goal

Push the Baez / Dubois-Violette / Todorov route one level past the current
coordinate splitting by formalizing a Lie-algebra-level stabilizer prelude for
the standard pair

```text
A = h_2(O) inside h_3(O)
B = h_3(C) inside h_3(O)
A cap B = h_2(C)
```

The most valuable output is a new trusted module with sorry-free finite
coordinate theorems showing that the existing `H3O` derivation and stabilizer
APIs can express the intersection geometry needed for the Standard Model group
`S(U(2) x U(3))`.

Do **not** try to prove `Aut(h_3(O)) = F4`, `Stab(A) = Spin(9)`, or the final
compact Lie group theorem. Those are frontier claims. This job should make the
algebraic stabilizer objects sharper and more usable.

## Source and convention notes

Sources:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Michel Dubois-Violette and Ivan Todorov, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", 2018.
- Yokota, exceptional Lie group/Jordan algebra stabilizer results.

Conventions:

- Project octonion basis is the XOR binary-label convention.
- The chosen imaginary unit is `e111`.
- The chosen complex line is `span_R {1, e111}`.
- `InStandardA` is the standard `h_2(O)` block.
- `InStandardB` is the standard `h_3(C)` block.
- `InStandardAInterB` is the standard `h_2(C)` intersection.

## Existing trusted inputs

Read these files first:

```text
PhysicsSM/Algebra/Octonion/ComplexLine.lean
PhysicsSM/Algebra/Octonion/ComplexSplitting.lean
PhysicsSM/Algebra/Jordan/H3O.lean
PhysicsSM/Algebra/Jordan/H3OJordan.lean
PhysicsSM/Algebra/Jordan/Automorphism.lean
PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean
PhysicsSM/Algebra/Jordan/Stabilizer.lean
PhysicsSM/Algebra/Jordan/StabilizerDerivation.lean
PhysicsSM/Algebra/Jordan/TraceForm.lean
PhysicsSM/Algebra/Jordan/DVTAction.lean
Sources/Baez_Standard_Model_Octonions_Lean_Proof_Plan.md
Sources/Baez_Octonions_Standard_Model_Talk_Notes.md
```

Useful existing declarations include:

- `H3O`
- `jordanProduct`
- `trace`
- `traceForm`
- `InStandardA`
- `InStandardB`
- `InStandardAInterB`
- `InComplementOfB`
- `toH3CPart`
- `toComplementPart`
- `decomp_sum`
- `standardB_inter_complementOfB_eq_zero`
- `H3ODerivation`
- `DerivationStabilizesSet`
- `standardA_derivationStabilizer`
- `standardB_derivationStabilizer`
- `standardAInterB_derivationStabilizer`

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTStabilizerPrelude.lean
```

It should import only the needed local modules, probably:

```lean
import PhysicsSM.Algebra.Jordan.StabilizerDerivation
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Jordan.DVTAction
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
```

If useful, also add a root import to `PhysicsSM.lean`, but only if the new file
is fully trusted and sorry-free.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude`.

Main declarations added:

- `standardAAndB_derivationStabilizer`
- `mem_standardAAndB_iff`
- `stabilizes_A_and_B_implies_stabilizes_intersection`
- `standardAAndB_subset_standardAInterB`
- `zero_mem_standardAAndB_derivationStabilizer`
- `add_mem_standardAAndB_derivationStabilizer`
- `neg_mem_standardAAndB_derivationStabilizer`
- `standardAAndB_derivationStabilizer_commutator_mem`
- `standardB_complement_traceForm_zero`
- `h3o_standardB_plus_complement`
- `DerivationLieSubalgebra`
- `standardA_lieSubalgebra`
- `standardB_lieSubalgebra`
- `standardAInterB_lieSubalgebra`
- `standardAAndB_lieSubalgebra`
- `standardAAndB_lieSubalgebra_subset_standardAInterB`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Jordan\DVTStabilizerPrelude.lean
lake build PhysicsSM.Algebra.Furey.QopElectroweakConsistency PhysicsSM.Algebra.Furey.TrialityActionPermutation PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
pre-commit run --all-files
lake build
```

Status: sorry-free trusted integration. The full build passed with pre-existing
warnings in older modules.

## Target statements

### 1. Intersection-stabilizer predicate

Define a predicate or set for derivations stabilizing both standard summands:

```lean
def standardAAndB_derivationStabilizer : Set H3ODerivation :=
  standardA_derivationStabilizer inter standardB_derivationStabilizer
```

Use the actual set syntax that Lean accepts. If the existing stabilizer sets
are in another namespace, use qualified names rather than redefining them.

Prove:

```lean
theorem mem_standardAAndB_iff (D : H3ODerivation) :
    D in standardAAndB_derivationStabilizer <->
      D in standardA_derivationStabilizer /\ D in standardB_derivationStabilizer
```

### 2. Stabilizing A and B stabilizes A cap B

Prove the key formal prelude theorem:

```lean
theorem stabilizes_A_and_B_implies_stabilizes_intersection
    {D : H3ODerivation}
    (hA : D in standardA_derivationStabilizer)
    (hB : D in standardB_derivationStabilizer) :
    D in standardAInterB_derivationStabilizer := ...
```

This should be a direct predicate proof: if `a` lies in both `A` and `B`, then
`D a` lies in both.

### 3. Closure under commutator for the common stabilizer

Using existing commutator-closure theorems for `standardA_derivationStabilizer`
and `standardB_derivationStabilizer`, prove:

```lean
theorem standardAAndB_derivationStabilizer_commutator_mem
    {D1 D2 : H3ODerivation}
    (h1 : D1 in standardAAndB_derivationStabilizer)
    (h2 : D2 in standardAAndB_derivationStabilizer) :
    commutator D1 D2 in standardAAndB_derivationStabilizer := ...
```

Use the actual commutator name from `StabilizerDerivation.lean`.

### 4. Trace-form splitting compatibility with stabilizer predicates

If feasible, prove clean helper lemmas stating that standardB and its
complement are trace-form orthogonal and direct in the vocabulary most useful
for DVT:

```lean
theorem standardB_complement_traceForm_zero
    {b c : H3O} (hb : InStandardB b) (hc : InComplementOfB c) :
    traceForm b c = 0
```

This may already exist as `traceForm_orthogonal`; if so, re-export it with a
DVT-facing name.

Also prove a DVT-facing direct-sum theorem:

```lean
theorem h3o_standardB_plus_complement
    (a : H3O) :
    a = toH3CPart a + toComplementPart a
```

This may just re-export `decomp_sum`.

### 5. Optional: common stabilizer as a bundled Lie subalgebra-like record

If the above is easy, define a small structure bundling the common derivation
stabilizer with closure under zero, addition, negation, and commutator.
Do not import a heavy Lie algebra hierarchy unless it is painless.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken definitions of `InStandardA`, `InStandardB`, or
  `InStandardAInterB`.
- Do not claim compact Lie group isomorphisms.
- Prefer short predicate proofs and re-export lemmas over large new
  abstractions.
- Add clear docstrings explaining that this is a Lie-algebraic stabilizer
  prelude, not the final DVT theorem.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTStabilizerPrelude.lean
lake env lean PhysicsSM.lean
```

If root import is not added, the second command should still pass unchanged.

## Deliverable

Return:

- files changed;
- theorem names proved;
- whether all output is sorry-free;
- exact verification commands run;
- any remaining frontier statements that should stay in draft.
