# CodeLatticeE8 Theta Series Packaging Plan

This note describes how the theta-series material should be presented in the
new reviewer-facing `CodeLatticeE8` package family.  The goal is not merely to
move existing files.  The goal is to make the mathematical story easy to audit:

1. define the local shell-counting problem;
2. prove the Construction A convolution formula;
3. specialize it to the extended Hamming code;
4. compare the resulting formal series with the Eisenstein coefficients;
5. keep the analytic modular-form proof behind an explicit SPL boundary.

The guiding principle is that the trusted core package should contain only the
finite and algebraic content that does not require Sphere-Packing-Lean or
analytic modular-form infrastructure.  The full analytic theorem belongs in the
SPL companion package until the relevant modular-form dimension and
q-expansion APIs are available directly in mathlib.

Status update, 2026-05-20: the first core slice has been implemented:

- `CodeLatticeE8/Theta/Sigma.lean`;
- `CodeLatticeE8/ConstructionA/ThetaLift.lean`;
- `CodeLatticeE8/E8/ThetaCoefficients.lean`;
- `CodeLatticeE8/E8/ThetaConvolution.lean`;
- `CodeLatticeE8/E8/ThetaSeries.lean`.

The promoted core currently contains the semantic zero/short-shell theta facts
and a finite Hamming weight-contribution table through `q^6`.  The structural
Construction A convolution theorem and the SPL analytic bridge remain the next
promotion targets.

Status update, 2026-05-21: five focused Aristotle jobs were submitted for the
remaining publication/theta work.  The job record is:

```text
AgentTasks/code-lattice-e8-publication-theta-aristotle-2026-05-21.md
```

The submitted jobs are:

- `f2f6f9c3-4ede-48b3-9863-ca97beac07ab` — remove small theta
  `native_decide` arithmetic checks.  Integrated 2026-05-21.
- `e72b19c0-eec6-4c0f-b661-b6a112c70d49` — promote the core Construction A
  theta convolution theorem.  Integrated 2026-05-21; four private finite
  Hamming-code checks remain in that proof.
- `c6bdb730-4af3-4e09-8190-5c2ef4e6c718` — reduce root-list
  `native_decide` classification.  Integrated 2026-05-21.
- `b5779bc1-d8be-4777-a4bf-ee444176dffe` — reduce root-bridge
  `native_decide` permutation checks.  Partially integrated 2026-05-21:
  the monolithic permutation check is gone, but five local list facts remain.
- `4467eb82-0899-4a42-94ac-432293e21812` — design/port the optional
  SPL-facing full theta theorem package.  Integrated 2026-05-21 as a
  conditional SPL root with documented analytic blockers.

Follow-up `56691706-08a0-4637-8aa7-fcc19945abce` removed the remaining
root-bridge `native_decide` checks and was integrated 2026-05-21.

Post-integration status, 2026-05-21:

- `CodeLatticeE8.E8.thetaShellCount_eq_convolution` is now in the standalone
  package and gives the semantic all-shell Construction A convolution theorem.
- The remaining standalone `native_decide` boundary is four private finite
  Hamming-code checks in `CodeLatticeE8/ConstructionA/ThetaConvolution.lean`.
- `CodeLatticeE8SPL` now exists as a sorry-free optional root.  Its main
  `Theta_E8 = E4` consequences are conditional on the missing all-coefficient
  analytic bridge, and the blockers are documented in `CodeLatticeE8/SPL/*`.

## 2026-05-21 Packaging Decision

The cleanest final presentation should **not** put the full analytic theorem
directly in the standalone `CodeLatticeE8` root.  The standalone root should
stay finite, algebraic, and Mathlib-only.  The full identity
`Theta_E8 = E4` should be exposed by the optional root `CodeLatticeE8SPL`,
because the current proof route uses Sphere-Packing-Lean's modular-form
dimension and theta-function infrastructure.

The intended final theorem chain should be:

1. Core package defines the Hamming Construction A shell coefficient
   semantically:

   ```lean
   def hammingThetaCoeff (n : Nat) : Nat :=
     Set.ncard (hammingE8Shell (4 * (n : Int)))
   ```

   The exact name can vary, but the coefficient function should count the
   semantic shell, not a finite table.

2. Core package proves the finite/combinatorial Construction A theorem:

   ```lean
   theorem hammingThetaCoeff_eq_convolution (n : Nat) :
       hammingThetaCoeff n = hammingThetaConvolutionCoeff n
   ```

   Here `hammingThetaConvolutionCoeff` is the Hamming weight-enumerator
   convolution using the one-coordinate even/odd lift counts.

3. Core package keeps the finite-range theorem for the manuscript:

   ```lean
   theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_le_six
       (n : Nat) (hn : n <= 6) :
       hammingThetaConvolutionCoeff n = e4Coeff n
   ```

   This theorem is valuable even after the all-coefficient SPL theorem exists,
   because it gives a self-contained finite audit trail.

4. SPL companion package proves the analytic modular-form identity:

   ```lean
   theorem thetaE8_MF_eq_E4 : thetaE8_MF = E4
   ```

   This theorem belongs in `CodeLatticeE8/SPL/E8ThetaModular.lean`.

5. SPL companion package proves q-expansion transport:

   ```lean
   theorem thetaE8_MF_qExpansion_coeff_eq_hammingThetaCoeff (n : Nat) :
       (qExpansion 1 thetaE8_MF).coeff n = (hammingThetaCoeff n : Complex)
   ```

   This is the key bridge theorem.  It should be isolated in
   `CodeLatticeE8/SPL/QExpansionBridge.lean` so reviewers can audit the
   analytic-to-combinatorial normalization separately.

6. SPL companion package exposes the all-coefficient result:

   ```lean
   theorem hammingThetaCoeff_eq_e4Coeff (n : Nat) :
       hammingThetaCoeff n = e4Coeff n
   ```

   This is the cleanest formulation of the representation-number theorem.

7. Only after the coefficient theorem is available should the package state a
   formal power series theorem:

   ```lean
   theorem thetaSeries_hammingE8_eq_e4Series :
       thetaSeries_hammingE8 = e4Series
   ```

   This theorem should live in `CodeLatticeE8/SPL/MainTheorem.lean` unless the
   formal-series definitions are completely Mathlib-only and the analytic
   dependence is hidden behind an imported SPL theorem.

This split gives the paper two honest claims:

- **Standalone core theorem**: the Hamming Construction A coefficients are
  computed by a verified finite/combinatorial convolution, and this matches
  `E4` through the displayed range.
- **Optional SPL theorem**: using SPL modular forms and q-expansion transport,
  the same semantic coefficient function equals `E4` for every coefficient.

The manuscript should cite the first theorem in the main formalization table
and the second theorem as the optional analytic completion.  It should not
describe draft `PhysicsSM` files as final package artifacts once the
`CodeLatticeE8SPL` modules exist.

## Trust Tiers

### Tier 1: Core, local, sorry-free

Package root: `CodeLatticeE8`

This tier should contain the material a reviewer can build on a normal checkout:

- definitions of the relevant local theta coefficients;
- the Construction A shell decomposition;
- the convolution formula grouped by Hamming weight;
- the Hamming `[8,4,4]` specialization;
- finite coefficient checks through the range used in the manuscript;
- the elementary `sigma3` / `E4` coefficient normalization used by the formal
  power series.

This tier may contain carefully isolated finite computation, but each use of
`native_decide` should be documented in the module docstring and should prove a
bounded finite statement, not hide a mathematical bridge.

### Tier 2: SPL companion, sorry-free but optional

Package root: `CodeLatticeE8SPL`

This tier may import Sphere-Packing-Lean.  It should contain the analytic
modular-form comparison:

- the SPL E8 theta modular form;
- the theorem that the modular form equals `E4`;
- the bridge from SPL's shell count to the Construction A shell count;
- the q-expansion coefficient comparison, when it is fully kernel-checked;
- the final theorem identifying the Hamming convolution coefficients with the
  `E4` coefficients.

This package is mathematically trusted when it builds, but it is not part of
the lightweight core package because it depends on SPL and inherits SPL's
platform constraints.

### Tier 3: Draft and handoff material

Package root: `CodeLatticeE8Draft`

This tier should contain unfinished analytic bridges and exploratory theta
identities:

- q-expansion bridge statements with open proof holes;
- analytic weight-enumerator bridges that still require convergence or
  coefficient-extraction work;
- theta duplication identities not yet integrated into the final route;
- failed or partial Aristotle output, with proof plans and failure notes.

Draft files may contain documented `sorry`s.  They should not be cited as final
theorems in the manuscript.

## Proposed Module Layout

### Core package

```text
CodeLatticeE8/
  Theta/
    Sigma.lean
    FormalSeries.lean
  ConstructionA/
    ThetaLift.lean
    ThetaConvolution.lean
  E8/
    ThetaCoefficients.lean
    ThetaSeries.lean
```

`CodeLatticeE8/Theta/Sigma.lean`

This file should contain the elementary arithmetic normalization:

- `sigma3`;
- `e4Coeff`;
- small coefficient facts, preferably named by coefficient rather than by proof
  method;
- the bridge from the local `sigma3` definition to mathlib's divisor-sum API if
  the import cost is acceptable.

This module should be short.  It is the place where a reader learns exactly
which normalization of `E4 = 1 + 240 * sum sigma3(n) q^n` is being used.

`CodeLatticeE8/Theta/FormalSeries.lean`

This file should contain the formal power series definitions, once they are
ready to move out of the E8-specific coefficient files:

- the integer-valued theta series attached to a coefficient function;
- the integer-valued `E4` series;
- coercion lemmas to complex coefficients, if they do not require SPL.

If this file would be mostly wrappers at first, it can be delayed.  The more
important immediate goal is to make the coefficient theorem names stable.

`CodeLatticeE8/ConstructionA/ThetaLift.lean`

This file should contain the one-coordinate finite lift API:

- finite sets of even and odd integer lifts bounded by a target norm;
- cardinality lemmas for these finite lift sets;
- the coordinate-level contribution functions used by the convolution formula.

This module is the right home for the material currently represented by the
`ConstructionAConvolutionHelpers` cluster.

`CodeLatticeE8/ConstructionA/ThetaConvolution.lean`

This file should contain the main generic Construction A counting theorem:

- `weightContribConvolution`;
- `residueShellSet`;
- `constructionAShellSet`;
- shell-set finiteness;
- shell-set decomposition as a union over codewords;
- disjointness of the codeword fibers;
- the grouped formula by Hamming weight.

The intended public theorem should be something close to:

```lean
theorem constructionAShellCount_eq_weight_distribution_convolution :
    ...
```

The statement should be generic enough to explain the method, but not so
abstract that the proof becomes brittle or unreadable.  If the fully generic
statement causes friction, prefer a clean binary-code version specialized to
`Fin n -> ZMod 2`.

`CodeLatticeE8/E8/ThetaCoefficients.lean`

This file should specialize the generic convolution theorem to the extended
Hamming code:

- `hammingThetaConvolutionCoeff`;
- coefficient facts for the manuscript range;
- comparisons with `e4Coeff` for the verified finite range;
- a theorem collecting the verified range, for example:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_le_six
    {n : Nat} (hn : n <= 6) :
    hammingThetaConvolutionCoeff n = e4Coeff n := ...
```

The exact range should match the manuscript.  If the current manuscript only
needs coefficients through `q^6`, do not make the public theorem look like an
infinite identity.

`CodeLatticeE8/E8/ThetaSeries.lean`

This file should be the reader-facing summary of the core theta work:

- the Hamming Construction A theta series as a formal integer series;
- the normalized `E4` formal integer series;
- the finite-range equality theorem;
- pointers in comments to the SPL companion module for the infinite analytic
  equality.

This module should be pleasant to read and should avoid exposing internal
bounded-search encodings unless the reader asks for implementation detail.

### SPL companion package

```text
CodeLatticeE8/
  SPL/
    E8ThetaModular.lean
    ShellBridge.lean
    QExpansionBridge.lean
    ThetaBridge.lean
    MainTheorem.lean
```

`CodeLatticeE8/SPL/E8ThetaModular.lean`

This file should contain the SPL-facing modular form:

- `thetaE8_MF`;
- `thetaE8_MF_eq_E4`;
- the limit at infinity used to pin down the scalar.

This is the natural clean home for the material currently represented by the
`E8ThetaDim8MF` cluster.

`CodeLatticeE8/SPL/ShellBridge.lean`

This file should compare the package's Construction A shell with the SPL E8
shell:

- the basis and normalization bridge;
- the theorem identifying shell cardinalities;
- any coordinate transport lemmas needed by q-expansion extraction.

This file should state conventions very explicitly: doubled coordinates,
actual squared norm, shell index, and the scaling between the integer model and
SPL's lattice model.

`CodeLatticeE8/SPL/QExpansionBridge.lean`

This file should contain only the coefficient-extraction API:

- coefficient of `thetaE8_MF` equals the SPL shell count;
- the SPL shell count equals the Construction A shell count;
- therefore coefficient of `thetaE8_MF` equals the Hamming convolution
  coefficient.

If any part of this bridge is still incomplete, this file belongs in
`CodeLatticeE8Draft`, not in the SPL companion package.

`CodeLatticeE8/SPL/ThetaBridge.lean`

This file should combine the core convolution theorem with the SPL analytic
theorem:

- `hammingThetaConvolutionCoeff_eq_e4Coeff`;
- formal complex series equality, if already proved;
- an integer-series equality only after injectivity/coercion issues are fully
  closed.

`CodeLatticeE8/SPL/MainTheorem.lean`

This file should contain a small number of final public statements with clean
names.  For example:

```lean
theorem thetaSeries_hammingE8_eq_e4Series : ...
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) : ...
```

The file should be boring in the best sense: import the bridge files, state the
main theorem, and prove it by composing named results.

### Draft package

```text
CodeLatticeE8Draft/
  Theta/
    DuplicationIdentities.lean
    QExpansionBridge.lean
    WeightEnumeratorAnalyticBridge.lean
    AristotleHandoffs.lean
```

Draft modules should retain useful failed work, but public theorem names should
make the status clear.  Avoid names that look final if the theorem still has a
`sorry`.

## Reader-Facing Narrative

The polished presentation should let the reader follow this chain:

1. `H_8` has weight distribution `1, 14, 1`.
2. Construction A decomposes the shell count into codeword fibers.
3. Each codeword fiber factors into one-coordinate even/odd lift counts.
4. Therefore the E8 theta coefficient is a Hamming weight convolution.
5. In the verified finite range, that convolution equals the `E4` coefficient.
6. In the SPL companion package, the analytic modular-form theorem upgrades the
   comparison to the infinite identity.

The core package should not ask the reader to understand modular forms before
they can audit the finite Construction A calculation.  Conversely, the SPL
package should not reprove the finite combinatorics; it should import the core
theorems and focus on analytic identification.

## Target Public Theorem Names

The exact statement shapes may change during migration, but the package should
aim for names in this style:

```lean
-- Core arithmetic normalization
CodeLatticeE8.Theta.sigma3
CodeLatticeE8.Theta.e4Coeff

-- Generic Construction A coefficient formula
CodeLatticeE8.ConstructionA.weightContribConvolution
CodeLatticeE8.ConstructionA.constructionAShellSet
CodeLatticeE8.ConstructionA.constructionAShellCount_eq_weight_distribution_convolution

-- Hamming/E8 specialization
CodeLatticeE8.E8.hammingThetaConvolutionCoeff
CodeLatticeE8.E8.hammingThetaConvolutionCoeff_eq_e4Coeff_of_le_six
CodeLatticeE8.E8.thetaSeries_hammingE8_coeff_eq_convolution

-- SPL companion
CodeLatticeE8.SPL.thetaE8_MF
CodeLatticeE8.SPL.thetaE8_MF_eq_E4
CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff
CodeLatticeE8.SPL.hammingThetaConvolutionCoeff_eq_e4Coeff
CodeLatticeE8.SPL.thetaSeries_hammingE8_eq_e4Series
```

Avoid including agent names, job names, or proof-method names in public
declarations.  If a theorem uses finite computation internally, document that in
the module docstring rather than in the theorem name.

## Migration Phases

### Phase 0: Inventory and semantic review

Make a table before moving code:

```text
current declaration | current file | sorry-free? | native_decide? | SPL? |
intended destination | manuscript citation
```

The first-pass source inventory should include:

- `PhysicsSM/Coding/ConstructionAConvolutionHelpers.lean`;
- `PhysicsSM/Coding/ConstructionAThetaConvolution.lean`;
- `PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean`;
- `PhysicsSM/Coding/E8ThetaSeries.lean`;
- `PhysicsSM/Coding/E8ThetaSeriesQ5.lean`;
- `PhysicsSM/Coding/E8ThetaSeriesQ6.lean`;
- `PhysicsSM/Coding/E8ThetaSigmaBridge.lean`;
- `PhysicsSM/Draft/E8ThetaDim8MF.lean`;
- `PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean`;
- `PhysicsSM/Draft/E8ThetaSPLBridge.lean`;
- `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean`;
- `PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean`;
- `PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean`;
- `PhysicsSM/Draft/ThetaDuplicationIdentities.lean`;
- `PhysicsSM/Draft/ThetaDuplicationProof.lean`.

### Phase 1: Move the elementary arithmetic normalization

Create `CodeLatticeE8/Theta/Sigma.lean`.

Move or restate the `sigma3` and `e4Coeff` definitions first.  This gives the
rest of the package a stable target for coefficient comparisons.

### Phase 2: Move the generic finite lift and convolution API

Create:

- `CodeLatticeE8/ConstructionA/ThetaLift.lean`;
- `CodeLatticeE8/ConstructionA/ThetaConvolution.lean`.

During this phase, replace old `PhysicsSM` imports with clean package imports.
Use existing clean names for the binary code, Hamming code, Construction A set,
and squared norm.

### Phase 3: Specialize to Hamming/E8 coefficients

Create `CodeLatticeE8/E8/ThetaCoefficients.lean`.

Move the Hamming convolution coefficient and finite checked coefficient facts.
Prefer theorem statements that explain the mathematics:

- grouped by Hamming weight;
- coefficient equals `E4` in a finite range;
- no hidden analytic assumptions.

### Phase 4: Add the core reader-facing summary

Create `CodeLatticeE8/E8/ThetaSeries.lean`.

This should be the file cited by the manuscript for the core result.  It should
export a small set of final theorem names and hide implementation details behind
imports.

### Phase 5: Move the SPL analytic bridge

Create the `CodeLatticeE8/SPL` module cluster and wire it under
`CodeLatticeE8SPL.lean`.

Only move the SPL theorem chain once each target file builds without `sorry`.
If a bridge theorem still depends on an unfinished q-expansion extraction, keep
that file in `CodeLatticeE8Draft`.

### Phase 6: Update manuscript references

After the modules build, update the manuscript so Appendix B cites the new
names:

- core finite coefficient theorem from `CodeLatticeE8/E8/ThetaSeries.lean`;
- optional analytic theorem from `CodeLatticeE8/SPL/MainTheorem.lean`;
- any remaining open analytic bridge from `CodeLatticeE8Draft/Theta/...`.

The manuscript should explicitly distinguish "proved in the standalone core
package" from "proved in the SPL companion package" from "remaining draft
bridge".

## Acceptance Checklist

Before considering the theta migration publication-ready:

- `lake build CodeLatticeE8` passes.
- `lake build CodeLatticeE8SPL` passes on the SPL-enabled checkout.
- `CodeLatticeE8` contains no imports from `PhysicsSM`, `CodeLatticeE8Draft`,
  or `CodeLatticeE8SPL`.
- Trusted modules contain no `sorry`, `admit`, `axiom`, `opaque`, or
  `unsafe def`.
- Every `native_decide` in trusted theta files is documented in the module
  docstring and proves a finite bounded statement.
- The theorem index lists the final public theta declarations.
- The manuscript cites only declarations that exist in the clean package family.
- Draft theta files have explicit proof-handoff comments for every `sorry`.

## Suggested Immediate Next Step

Start with `CodeLatticeE8/Theta/Sigma.lean` and
`CodeLatticeE8/ConstructionA/ThetaLift.lean`.  They are low-risk, clarify the
coefficient normalization, and make the rest of the migration less tangled.

After those build, migrate the generic convolution theorem before touching the
SPL analytic files.  This keeps the finite combinatorics stable and gives the
analytic bridge a clean target.
