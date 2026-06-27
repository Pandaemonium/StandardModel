# Aristotle strategy job: Furey ideals, anomaly cancellation, true SM gauge group, and null-edge integration

Date: 2026-06-26.

Context pack:

- `AgentTasks/context-packs/null-edge-furey-gauge-integration-20260626-213256.md`

Aristotle metadata:

```yaml
aristotle:
  project_id: 91143892-2730-4774-8b9e-c205f936cfb9
  task_id: 932dd64e-79d9-4d93-aa15-be2c99205ce6
  target_file: AgentTasks/null-edge-furey-gauge-integration-strategy-report.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-furey-gauge-integration-strategy-20260626-project
  output_dir: AgentTasks/aristotle-output/91143892-2730-4774-8b9e-c205f936cfb9
  status: integrated
```

Returned report integrated at:

```text
AgentTasks/null-edge-furey-gauge-integration-strategy-report.md
```

## Prompt to Aristotle

This is a no-build strategy/audit job. Please do not spend time running a full
`lake build` unless you need a tiny targeted lookup. The requested output is a
detailed strategy report, not Lean code.

We are trying to stitch together two large formal islands in the repo:

1. The Furey / Baez / DVT / Standard Model internal-spectrum island:
   Furey complex-octonion ideals or modules, anomaly cancellation, and the true
   Standard Model gauge group with its finite `Z6` quotient.
2. The null-edge island:
   a finite null-edge / super-Dirac operator architecture with
   `D = i D_N tensor 1 + Gamma_s tensor Phi_H`, a Gate A square theorem, and
   Gate C branch/doubler/ghost-safety issues.

We want your best strategy for integrating these into a single formal and
publication-safe architecture.

## Relevant files and modules

Please inspect the context pack first:

```text
AgentTasks/context-packs/null-edge-furey-gauge-integration-20260626-213256.md
```

Then use the repo as needed, especially these areas.

Furey / division-algebra / one-generation side:

```text
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
PhysicsSM/Algebra/Furey/LadderOperators.lean
PhysicsSM/Algebra/Furey/QuantumNumbers.lean
PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean
PhysicsSM/Algebra/Furey/OneGenerationPackage.lean
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
PhysicsSM/Algebra/Furey/FureyAnomalyDecomposition.lean
PhysicsSM/Algebra/Furey/ConjugateIdeal.lean
PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean
PhysicsSM/Algebra/Furey/ElectroweakBridge.lean
PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
PhysicsSM/Publication/FureyBaezDVTFullSynthesis.lean
PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean
```

Standard Model anomaly and true gauge group side:

```text
PhysicsSM/StandardModel/OneGenerationTable.lean
PhysicsSM/StandardModel/AnomalyPackage.lean
PhysicsSM/StandardModel/AnomalyCancellation.lean
PhysicsSM/Gauge/StandardModel.lean
PhysicsSM/Gauge/StandardModelGroup.lean
PhysicsSM/Gauge/StandardModelGroupStructure.lean
PhysicsSM/Gauge/StandardModelZ6KernelPackage.lean
PhysicsSM/Gauge/StandardModelUnitZ6Kernel.lean
PhysicsSM/Gauge/StandardModelUnitZ6QuotientGroup.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
PhysicsSM/Gauge/StandardModelCoverageImageSMBlock.lean
PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
```

Null-edge / Furey bridge side:

```text
PhysicsSM/Draft/NullEdgeInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyChiE.lean
PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean
PhysicsSM/Draft/NullEdgeFureyPhiH.lean
PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean
PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean
PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean
PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean
PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean
PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean
```

Null-edge Gate C / branch safety side:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean
PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean
PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean
PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean
PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean
PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean
PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean
PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean
PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean
PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean
```

Planning docs:

```text
Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
Sources/NullStrand_Lean_Roadmap_Improved.md
AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md
```

## What we believe is already true

Please verify this from the repo before relying on it, but our current working
understanding is:

1. Furey occupation/ideal states already realize a substantial one-generation
   internal spectrum surface.
2. Anomaly freedom is inherited through existing Standard Model anomaly
   packages, not re-proved from scratch in every Furey file.
3. There is a true Standard Model gauge group / finite quotient `Z6` formal
   surface in `PhysicsSM/Gauge`.
4. The null-edge Furey files already provide a lawful `Phi_H` interface:
   gauge covariance, `chi_E` oddness, `Gamma_s` evenness, and compatibility
   with the finite super-Dirac square.
5. `chi_E` should be treated as internal occupation-number parity, not blindly
   identified with spacetime chirality, Krein sign, edge orientation, or the
   Furey/Krasnov complex structure.
6. Gate C remains a separate kinetic/doubling/ghost-safety problem. Furey may
   help with internal selectors or legal maps, but it does not automatically
   solve branch/doubler control.

## Main questions

Please answer these in detail.

### 1. Architecture

What is the cleanest formal architecture that combines:

```text
H_null/spin/Krein/branch
H_Furey/internal
D_N
Phi_H
the true Standard Model gauge group quotient
anomaly inheritance
```

into one product picture?

Should the canonical target be a new synthesis interface such as:

```text
NullEdgeFureyGaugeSynthesis
NullEdgeFureyTrueGaugeProduct
NullEdgeAlmostCommutativeSM
```

or should we keep the existing modules separate and only add crosswalk
theorems?

### 2. Gauge group quotient

How should the true Standard Model gauge group quotient enter the Furey/null-edge
product?

Questions to address:

```text
Does the current Furey Phi_H interface respect the true quotient group, or only
the product-cover/Lie-algebra level?

Which existing Z6 quotient theorem is the right surface to cite?

What theorem would prove that the Furey internal fiber and Phi_H descend through
the true gauge group quotient?

Is the quotient issue relevant to Phi_H gauge covariance, anomaly inheritance,
or both?
```

Please propose exact Lean theorem statements or theorem names where possible.

### 3. Anomaly bridge

What is the publication-safe anomaly story?

Questions:

```text
Which theorem should be the canonical citation for one-generation anomaly
freedom?

Which theorem should be the canonical citation for the Furey-to-anomaly bridge?

Does the current Furey bridge really derive all one-generation states, or does
it still append right-handed singlets/conjugate ideal data?

What exact theorem would close the right-handed/conjugate-ideal gap?
```

Please be adversarial about claim boundaries.

### 4. Phi_H and Yukawa legality

How should `Phi_H` be stated as a Furey-compatible, true-gauge-compatible
finite Dirac/Yukawa block?

Questions:

```text
Is the existing NullEdgeFureyPhiH surface enough for the almost-commutative
product theorem, or do we need a stronger theorem over the true gauge quotient?

Does the repo currently prove that legal Furey intertwiners constrain generic
Yukawa freedom, or is Phi_H still parameterized by an arbitrary allowed block?

What should be the exact moduli/codimension audit theorem?
```

### 5. Relationship to Gate C

Does the Furey / true-gauge / anomaly island help Gate C at all?

Please distinguish:

```text
internal legality of states and maps;
projected physical branch-sector selection;
Krein-positive sector selection;
ghost-zero safety;
full nodal-set control.
```

If Furey can help Gate C, propose a precise theorem. If it cannot, say so
clearly and explain where the boundary lies.

### 6. Proposed theorem chain

Give a concrete theorem dependency chain for a paper section or Lean synthesis
module. Please separate:

```text
already kernel-checked;
kernel-checked but needing a clearer wrapper;
requires a new proof;
requires a new definition/API;
mathematically open;
physics/speculative.
```

Please include suggested module names and theorem names.

### 7. Publication language

Draft a careful paragraph explaining the stitched result to a mathematically
informed physics reader.

Avoid overclaims such as:

```text
Furey proves all SM masses;
Furey closes Gate C;
the true gauge group quotient alone predicts Yukawa values;
three generations are derived;
raw complex octonions have associative ideals.
```

Prefer precise claims about:

```text
finite internal fiber;
true gauge quotient;
anomaly-safe one-generation spectrum;
lawful Phi_H mass block;
null-edge external Dirac operator;
remaining prediction and doubling gates.
```

### 8. Next Aristotle jobs

Recommend the next 5-8 Aristotle jobs after this strategy job, sorted by
priority. Include which should be:

```text
no-build strategy/audit;
focused Lean proof;
full-repo Lean proof;
manuscript/crosswalk audit.
```

Please especially consider:

```text
Furey true-gauge quotient descent for Phi_H;
right-handed/conjugate ideal completion;
Yukawa/intertwiner moduli audit;
Furey bridge summary/crosswalk module;
NullEdgeInvolutionDistinctness;
Gate C full nodal-set classification.
```

## Output format

Please return a report with:

```text
1. Executive verdict.
2. What is already stitched together.
3. What is not yet stitched together.
4. Proposed synthesis architecture.
5. Exact theorem/module targets.
6. Claim boundaries and publication wording.
7. Interaction with Gate C.
8. Prioritized next Aristotle job list.
9. Any red flags or possible theorem falsehoods.
```

Expected durable artifact in this repo:

```text
AgentTasks/null-edge-furey-gauge-integration-strategy-report.md
```
