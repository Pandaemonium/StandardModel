# Null-edge Codex overnight run ledger

Date: 2026-06-23

Objective: keep up to six worthwhile Aristotle jobs running while integrating
completed results, doing literature searches often enough to sharpen targets,
and prioritizing publishable progress.

## Startup integration

Integrated Aristotle project `24156b85-0176-455e-9f92-e80cb94502b8` as:

```text
PhysicsSM.Draft.NullEdgeYukawaMassOperator
```

Main value: legal Higgs/Yukawa flips now have a finite off-diagonal scalar mass
operator that anticommutes with chirality and squares to the expected
`mass * mass` block.

Local checks run:

```text
lake env lean PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean
lake build PhysicsSM.Draft.NullEdgeYukawaMassOperator
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean
pre-commit run --files PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean PhysicsSMDraft.lean
```

Also verified live integrated modules from the previous batch:

```text
PhysicsSM.Draft.NullEdgeP9WeightedSuppressionThreshold
PhysicsSM.Draft.NullEdgeP9ResidualVarianceCellArea
PhysicsSM.Draft.NullEdgeP3CrossedModule
PhysicsSM.Draft.NullEdgeP7PetzRecovery
PhysicsSM.Draft.NullEdgeP6Concurrence
```

Minor cleanup: removed one unused simp argument warning in
`PhysicsSM.Draft.NullEdgeP7PetzRecovery`.

Additional integrations from the current run:

- `3cfb5bcc-f262-45a2-8941-3151350a4617` integrated as
  `PhysicsSM.Draft.NullEdgeP7ObserverLoss`. Value: observer loss plus recovery
  loss equals recoverability gap; source-defect bounds can be lifted from
  observer loss to full recoverability gap under a nonnegative recovery-loss
  hypothesis.
- `c91d864e-60d7-44dc-bbf7-1bfa97e5ac4a` integrated as
  `PhysicsSM.Draft.NullEdgeP1SL2Frame`. Value: determinant invariance under
  `SL(2,C)` congruence, supporting the invariant-mass versus
  observer-conditioned-mixedness split.

Reviewed but not integrated:

- `45929669-f4b1-4cbf-9f49-e4f624ef66bc` returned a useful
  `DiamondScreen` / `CellMeasure` / `CurvatureDefect` / `Observer` API skeleton
  for P9, but it is an explicit handoff skeleton with proof holes. Keep it as
  design guidance and revise it using the recoverability-vs-invisibility caveat
  before live Lean integration.

## Literature pass

Semantic shell helpers could not see the Neo4j environment variables in this
session, so this pass used scholarly MCP searches plus direct Neo4j MCP queries.
Semantic Scholar was rate-limited; OpenAlex, arXiv, and Crossref worked.

Sources added to Zotero and Neo4j:

- `PU8Q5WKT`: Surya, X, Yazdi, *Entanglement Entropy of Causal Set de Sitter
  Horizons*, arXiv:2008.07697.
- `P8PE3SZ9`: Zhu and Yazdi, *On the (Non)Hadamard Property of the SJ State in
  a 1+1D Causal Diamond*, arXiv:2212.10592.
- `2IR54QB2`: Sharma, *Equality conditions for the quantum f-relative entropy
  and generalized data processing inequalities*, DOI:10.1109/ISIT.2010.5513655.
- `4RRBQPGM`: Sutter, Tomamichel, Harrow, *Strengthened monotonicity of
  relative entropy via pinched Petz recovery map*, DOI:10.1109/ISIT.2016.7541401.

Follow-up Pro critique sources added after the user supplied the strengthened
memo:

- `3VBEK82X`: Chin and Lee, *Momentum bispinor, two-qubit entanglement and
  twistor space*, arXiv:1407.2492. Guardrail for P1 mass/concurrence prior art.
- `RW63ZR9E`: Blume-Kohout, Ng, Poulin, Viola, *The structure of preserved
  information in quantum processes*, arXiv:0705.4282. Guardrail for stable
  particle sectors as preserved/noiseless channel structures.
- `KDEECE8M`: Hawkins, Markopoulou, Sahlmann, *Evolution in Quantum Causal
  Histories*, hep-th/0302111. Guardrail for finite causal quantum processes.

Immediate theorem consequence: the P9 Sorkin-Johnston branch should treat
spectral truncation/windowing as a core finite definition, because the causal
set SJ entropy literature finds area-law behavior only after Pauli-Jordan
spectral truncation and volume-law behavior without it.

Immediate guidance consequence: P1/P6 should prefer the observer-conditioned
state `rho_{p|u}` over the bare shorthand `P / Tr(P)` unless a frame is fixed.
P2/P4 should prioritize chirality coherence and null-step quantum walks as the
dynamical bridge to `m/E`. P7/P9 must not conflate recoverability with
invisibility.

## Running Aristotle jobs

Earlier running job:

- `45929669-f4b1-4cbf-9f49-e4f624ef66bc`:
  `null-edge-p9-diamond-source-visibility-api-design`.

New jobs submitted:

- `3b36d45f-be28-43d2-9708-1df8513d30f3`:
  `null-edge-p9-mean-fluctuation-decomposition-20260623`.
  Target: finite mean/fluctuation decomposition for P9 residuals.
- `92472afd-969e-4f62-a667-d0da3ec1e8f9`:
  `null-edge-p9-boundary-exact-invisibility-20260623`.
  Target: summation-by-parts theorem showing boundary-exact bookkeeping is
  invisible to closed bulk tests.
- `3cfb5bcc-f262-45a2-8941-3151350a4617`:
  `null-edge-p7-observer-loss-factorization-20260623`.
  Target: observer-loss plus recovery-loss factorization of recoverability gap.
- `c91d864e-60d7-44dc-bbf7-1bfa97e5ac4a`:
  `null-edge-p1-sl2-det-frame-audit-20260623`.
  Target: SL(2,C) determinant invariance for the two-spinor momentum block.
- `4153d0e4-480f-4002-9ebb-64461384197a`:
  `null-edge-strategy-audit-grand-20260623`.
  Target: high-level theorem strategy and physics-alignment audit over the
  current program docs.
- `1892cad4-d2fd-4fdc-9ec4-341bc3376f01`:
  `null-edge-p9-antisymmetric-mean-zero-20260623`.
  Target: antisymmetric hidden relabeling forces zero constant-defect pairing.
- `bf397487-cd52-44c3-906d-ac883ed8922c`:
  `null-edge-p1-observer-conditioned-ratio-20260623`.
  Target: scalar algebra for `2 sqrt(det rho_{p|u}) = m / E_u`.
- `2febd95e-93c5-4b2a-94fb-e8d845465dbe`:
  `null-edge-p2-chirality-coherence-20260623`.
  Target: two-level chirality coherence equals `m/E` before observer dephasing
  or tracing.

Queue after submission: six running jobs.

## Next wake-up checklist

1. Run `aristotle list --limit 20`.
2. For any `IDLE` project above, run the integration helper dry-run first.
3. Use diff/statements/targeted Lean checks to integrate proof jobs.
4. Read the grand strategy/audit report for target-selection changes.
5. Before submitting five more jobs, do another focused literature pass if five
   jobs have completed or if a new P9/P7 claim touches prior art.

## Subsequent integration notes

- Read Aristotle strategy/audit project `4153d0e4-480f-4002-9ebb-64461384197a`.
  Useful guidance: protect the invariant/frame-relative split around
  `det(P)=m^2` versus observer-normalized `det(rho)=(m/E)^2`; promote the P1
  frame-audit and celestial-moment wrappers; keep P9 non-tautological by
  separating recoverability from actual source invisibility; prioritize the P3
  crossed-module interchange test.
- Triaged older completed jobs:
  - `ce4d21d4-0b8d-4344-977c-db3bee6bd950`
    (`NullEdgeP9ResidualVarianceCellArea`) was already live with only namespace
    and module-wrapper differences from the Aristotle return.
  - `1f2a340d-e077-4dfe-a682-c018f5e99fea`
    (`NullEdgeP3CrossedModule`) was already live with only namespace and module
    wrapper differences.
  - `5579296d-ca61-4852-8d9a-592cdf3676ca`
    (`NullEdgeP9WeightedSuppressionThreshold`) was already live with only
    namespace and module-wrapper differences.
  - `f8caf89b-6245-489d-b5b3-ae3e0a9ebf80`
    (`NullEdgeP6Concurrence`) was already live, and the repo version keeps extra
    local concurrence lemmas.
  - `bff2387a-31ae-486d-b42a-66d2b76e50c8`
    (SJ reference state) produced no useful repo diff.
- Integrated `1892cad4-d2fd-4fdc-9ec4-341bc3376f01` as
  `PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero`, proving
  `antisymmetric_relabeling_constantPairing_zero`.
- Integrated `bf397487-cd52-44c3-906d-ac883ed8922c` as
  `PhysicsSM.Draft.NullEdgeP1ObserverConditioned`, proving
  `two_sqrt_observerConditionedDet_eq_mass_over_energy`. This is the scalar
  theorem boundary for `det(rho_{p|u}) = m^2 / (4 E_u^2)`.
- Integrated `2febd95e-93c5-4b2a-94fb-e8d845465dbe` as
  `PhysicsSM.Draft.NullEdgeP2ChiralityCoherence`, proving
  `chiralityCoherence_positiveProjectorLR_eq_mass_over_energy`. This supports
  the Pro-critique chain: Higgs/Yukawa mass coupling first creates left/right
  chirality coherence of size `m/E`; visible mixedness requires a later observer
  channel or trace.
- Added a permanent caveat docstring to
  `PhysicsSM.Draft.NullEdgeP7PetzRecovery.petzMap_recovers_q`, explaining why
  the column-stochasticity hypothesis is essential.
- Added the strategy/audit report as
  `AgentTasks/null-edge-grand-strategy-audit-report-2026-06-23.md`.

Verification for this increment:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9AntisymmetricMeanZero.lean
lake env lean PhysicsSM/Draft/NullEdgeP7PetzRecovery.lean
lake env lean PhysicsSM/Draft/NullEdgeP1ObserverConditioned.lean
lake env lean PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean
lake build PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero
lake build PhysicsSM.Draft.NullEdgeP7PetzRecovery
lake build PhysicsSM.Draft.NullEdgeP1ObserverConditioned
lake build PhysicsSM.Draft.NullEdgeP2ChiralityCoherence
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP9AntisymmetricMeanZero.lean,PhysicsSM/Draft/NullEdgeP7PetzRecovery.lean,PhysicsSM/Draft/NullEdgeP1ObserverConditioned.lean,PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
```

## Literature cadence update

Semantic Scholar remained rate-limited, so the literature pass used arXiv,
OpenAlex, and Crossref. Useful result added:

- `I7G53I6T`: Arnault et al., *Quantum simulation of quantum relativistic
  diffusion via quantum walks*, arXiv:1911.09791. Added to Zotero and Neo4j.
  Relevance: a discrete-time quantum walk with a Dirac Hamiltonian continuum
  limit and chirality-flip / chirality-dependent phase-flip Lindblad terms.
  This is directly useful prior art for the P2/P4 chirality-coherence and
  null-step quantum-walk lane.

Already-present sources confirmed:

- `PU8Q5WKT`: causal-set SJ de Sitter horizon entropy and truncation.
- `JZEJ4VXA`: D'Ariano et al., discrete-time Dirac quantum walk in 3+1D.
- `STUCFHB7`: Surya causal-set review.

## Six-job Aristotle wave submitted

- `57e1bb24-b509-4009-847b-f7dd834bc53c`:
  `null-edge-p1-celestial-moment-20260623`.
  Target: `four_blochDet_eq_monopole_sq_sub_dipole_sq`.
- `a08816d2-e435-407f-82ee-5132345cae9f`:
  `null-edge-p1-restframe-bloch-20260623`.
  Target: `blochRadiusSq_zero_iff_restFrame`.
- `48cfdb49-934b-470e-b6fc-9ce7c3deee97`:
  `null-edge-p2-dephasing-determinant-20260623`.
  Target: `dephasedDet_sub_chiralDet_eq_coherenceSq`.
- `20a4f1b1-c77d-41ef-89ec-3539d607542a`:
  `null-edge-p9-weighted-antisymmetric-mean-zero-20260623`.
  Target: `antisymmetric_relabeling_weightedPairing_zero`.
- `43b1ec7e-dd69-4b4b-ada6-fcfc4e7cb62e`:
  `null-edge-p7-recoverability-invisibility-separation-20260623`.
  Target: `recoverable_not_imply_constantInvisible`.
- `88745842-fe14-492c-92ef-8e0b86bbf890`:
  `null-edge-p9-visible-plucker-source-api-20260623`.
  Target: `visibleSource_of_nonzero_pluckerSpread`.

## Six-job wave integrated

All six jobs returned clean proof modules and were integrated as draft Lean
modules:

- `PhysicsSM.Draft.NullEdgeP1CelestialMoment`
  - `four_blochDet_eq_monopole_sq_sub_dipole_sq`
  - Scientific role: scalar celestial moment identity, mass as monopole/dipole
    deficit.
- `PhysicsSM.Draft.NullEdgeP1RestFrameBloch`
  - `blochRadiusSq_zero_iff_restFrame`
  - Scientific role: normalized block is maximally mixed exactly when the
    spatial Bloch/dipole vector vanishes.
- `PhysicsSM.Draft.NullEdgeP2DephasingDeterminant`
  - `dephasedDet_sub_chiralDet_eq_coherenceSq`
  - Scientific role: observer dephasing converts removed chirality coherence
    into determinant growth.
- `PhysicsSM.Draft.NullEdgeP9WeightedAntisymmetricMeanZero`
  - `antisymmetric_relabeling_weightedPairing_zero`
  - Scientific role: hidden relabeling antisymmetry forces zero weighted source
    pairing for invariant observer weights.
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation`
  - `recoverable_not_imply_constantInvisible`
  - Scientific role: formal toy guardrail separating recoverability from source
    invisibility.
- `PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI`
  - `visibleSource_of_nonzero_pluckerSpread`
  - Scientific role: nonzero scalar Pluecker spread sources the stated finite
    observable.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1CelestialMoment.lean
lake env lean PhysicsSM/Draft/NullEdgeP1RestFrameBloch.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingDeterminant.lean
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedAntisymmetricMeanZero.lean
lake env lean PhysicsSM/Draft/NullEdgeP7RecoverabilityInvisibilitySeparation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9VisiblePluckerSourceAPI.lean
lake build PhysicsSM.Draft.NullEdgeP1CelestialMoment
lake build PhysicsSM.Draft.NullEdgeP1RestFrameBloch
lake build PhysicsSM.Draft.NullEdgeP2DephasingDeterminant
lake build PhysicsSM.Draft.NullEdgeP9WeightedAntisymmetricMeanZero
lake build PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation
lake build PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP1CelestialMoment.lean,PhysicsSM/Draft/NullEdgeP1RestFrameBloch.lean,PhysicsSM/Draft/NullEdgeP2DephasingDeterminant.lean,PhysicsSM/Draft/NullEdgeP9WeightedAntisymmetricMeanZero.lean,PhysicsSM/Draft/NullEdgeP7RecoverabilityInvisibilitySeparation.lean,PhysicsSM/Draft/NullEdgeP9VisiblePluckerSourceAPI.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP1CelestialMoment.lean PhysicsSM/Draft/NullEdgeP1RestFrameBloch.lean PhysicsSM/Draft/NullEdgeP2DephasingDeterminant.lean PhysicsSM/Draft/NullEdgeP9WeightedAntisymmetricMeanZero.lean PhysicsSM/Draft/NullEdgeP7RecoverabilityInvisibilitySeparation.lean PhysicsSM/Draft/NullEdgeP9VisiblePluckerSourceAPI.lean PhysicsSMDraft.lean
```

## Context/literature cadence before third wave

- Attempted `Scripts/lit/neo4j_doc_search.py` semantic search with the
  lean-explore Python. The shell environment lacks `NEO4J_URI`,
  `NEO4J_USERNAME`, and `NEO4J_PASSWORD`, so unattended shell semantic search
  needs the documented MCP/session wrapper before it is reliable.
- Used MCP Neo4j queries as fallback. The relevant hits continued to point to
  P9 source visibility, closure, SJ truncation, and the P1/P2 observer-conditioned
  mass-ratio guardrails. No new paper was added in this pass beyond the already
  added Arnault et al. quantum-walk source `I7G53I6T`.

## Third six-job Aristotle wave submitted

- `af3fa2f3-cc53-46c4-a91a-c92b47720f52`:
  `null-edge-p1-normalized-bloch-det-20260623`.
  Target: `four_normalizedBlochDet_eq_one_sub_blochRadiusSq`.
- `f2191d44-17df-4071-84d4-562826f5097a`:
  `null-edge-p1-mass-ratio-velocity-20260623`.
  Target: `massRatioSq_eq_one_sub_speedSq`.
- `8d3af9e8-998c-4e6f-9994-345a5492f715`:
  `null-edge-p2-dephasing-purity-20260623`.
  Target: `chiralPurity_sub_dephasedPurity_eq_two_coherenceSq`.
- `5e1fd63b-650c-4bfb-9c34-54bbe18611cd`:
  `null-edge-p9-paired-cancellation-20260623`.
  Target: `pairedSourcePairing_zero`.
- `043ce3f9-580d-4a65-a817-cdbb156ed28f`:
  `null-edge-p9-max-weight-residual-bound-20260623`.
  Target: `weightSqSum_le_eps_mul_weightSum`.
- `317e10b8-a444-4662-a528-20eed9425900`:
  `null-edge-p7-constant-test-perturbation-20260623`.
  Target: `constantTest_add_invisible_eq`.

## Third six-job wave integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP1NormalizedBlochDet`
  - `four_normalizedBlochDet_eq_one_sub_blochRadiusSq`
  - Role: normalized P1 identity `4 det(rho) = 1 - |r|^2`.
- `PhysicsSM.Draft.NullEdgeP1MassRatioVelocity`
  - `massRatioSq_eq_one_sub_speedSq`
  - Role: scalar observer-conditioned guardrail `(m/E)^2 = 1 - v^2`.
- `PhysicsSM.Draft.NullEdgeP2DephasingPurity`
  - `chiralPurity_sub_dephasedPurity_eq_two_coherenceSq`
  - Role: dephasing removes chirality coherence and reduces purity by the
    corresponding squared coherence contribution.
- `PhysicsSM.Draft.NullEdgeP9PairedCancellation`
  - `pairedSourcePairing_zero`
  - Role: explicit paired hidden positive/negative source cancellation.
- `PhysicsSM.Draft.NullEdgeP9MaxWeightResidualBound`
  - `weightSqSum_le_eps_mul_weightSum`
  - Role: reusable residual-noise bound from uniform cell-weight control.
- `PhysicsSM.Draft.NullEdgeP7ConstantTestPerturbation`
  - `constantTest_add_invisible_eq`
  - Role: adding a constant-test invisible residual does not change the
    background constant source test.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedBlochDet.lean
lake env lean PhysicsSM/Draft/NullEdgeP1MassRatioVelocity.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingPurity.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedCancellation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9MaxWeightResidualBound.lean
lake env lean PhysicsSM/Draft/NullEdgeP7ConstantTestPerturbation.lean
lake build PhysicsSM.Draft.NullEdgeP1NormalizedBlochDet
lake build PhysicsSM.Draft.NullEdgeP1MassRatioVelocity
lake build PhysicsSM.Draft.NullEdgeP2DephasingPurity
lake build PhysicsSM.Draft.NullEdgeP9PairedCancellation
lake build PhysicsSM.Draft.NullEdgeP9MaxWeightResidualBound
lake build PhysicsSM.Draft.NullEdgeP7ConstantTestPerturbation
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP1NormalizedBlochDet.lean,PhysicsSM/Draft/NullEdgeP1MassRatioVelocity.lean,PhysicsSM/Draft/NullEdgeP2DephasingPurity.lean,PhysicsSM/Draft/NullEdgeP9PairedCancellation.lean,PhysicsSM/Draft/NullEdgeP9MaxWeightResidualBound.lean,PhysicsSM/Draft/NullEdgeP7ConstantTestPerturbation.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP1NormalizedBlochDet.lean PhysicsSM/Draft/NullEdgeP1MassRatioVelocity.lean PhysicsSM/Draft/NullEdgeP2DephasingPurity.lean PhysicsSM/Draft/NullEdgeP9PairedCancellation.lean PhysicsSM/Draft/NullEdgeP9MaxWeightResidualBound.lean PhysicsSM/Draft/NullEdgeP7ConstantTestPerturbation.lean PhysicsSMDraft.lean
```

## Literature cadence after third wave

Added two P9 closure/twisted-geometry anchors to Zotero and Neo4j:

- `63MQ6KC3`: Freidel and Speziale, *Twisted geometries: A geometric
  parametrisation of SU(2) phase space*, arXiv:1001.2748.
  Relevance: canonical twisted-geometry parametrization of graph phase space,
  including face areas/normals and closure/geometricity context.
- `BC9Q4QNG`: Speziale and Zhang, *Null twisted geometries*, arXiv:1311.3279.
  Relevance: direct prior art for null hypersurface spin-network/twistor
  geometry, useful for the null-edge P9 closure and null-horizon lane.

## Fourth six-job Aristotle wave submitted

- `b5c9283a-ac0f-4454-968a-e5ae25c29026`:
  `null-edge-p1-normalized-det-nonneg-20260623`.
  Target: `normalizedBlochDet_nonneg_iff_radius_le_one`.
- `8a382505-aaa4-4371-b431-5d7608a1e03e`:
  `null-edge-p1-mass-ratio-bounds-20260623`.
  Target: `massRatioSq_bounds_of_speedSq_bounds`.
- `18fdc4f4-04aa-4156-a26a-ca212c8aa185`:
  `null-edge-p2-dephasing-det-monotone-20260623`.
  Target: `chiralDet_le_dephasedDet`.
- `23482033-631a-4019-a3b7-a0a41023b0a9`:
  `null-edge-p9-closure-defect-20260623`.
  Target: `closureDefectSq_zero_iff_closed`.
- `0b750cb5-f6a5-4930-80ff-6b3b58c6c679`:
  `null-edge-p9-closure-visible-source-20260623`.
  Target: `visibleClosureSource_of_nonzero_component`.
- `b28351f1-f058-4357-b176-252c795be00d`:
  `null-edge-p9-meanzero-fluctuation-20260623`.
  Target: `pairedSqSum_eq_two_mul_sourceSqSum`.

## Fourth six-job wave integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP1NormalizedDetNonneg`
  - `normalizedBlochDet_nonneg_iff_radius_le_one`
  - Role: normalized determinant is nonnegative exactly inside the Bloch ball.
- `PhysicsSM.Draft.NullEdgeP1MassRatioBounds`
  - `massRatioSq_bounds_of_speedSq_bounds`
  - Role: if `0 <= v^2 <= 1`, then `0 <= (m/E)^2 <= 1`.
- `PhysicsSM.Draft.NullEdgeP2DephasingDetMonotone`
  - `chiralDet_le_dephasedDet`
  - Role: removing real chirality coherence cannot decrease this determinant.
- `PhysicsSM.Draft.NullEdgeP9ClosureDefect`
  - `closureDefectSq_zero_iff_closed`
  - Role: closure-defect square vanishes exactly when all closure components
    vanish.
- `PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource`
  - `visibleClosureSource_of_nonzero_component`
  - Role: a nonzero closure component produces a nonzero source in the stated
    scalar closure-defect observable.
- `PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation`
  - `pairedSqSum_eq_two_mul_sourceSqSum`
  - Role: paired mean-zero hidden bookkeeping can still carry nonzero second
    moment.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetNonneg.lean
lake env lean PhysicsSM/Draft/NullEdgeP1MassRatioBounds.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingDetMonotone.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ClosureDefect.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ClosureVisibleSource.lean
lake env lean PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
lake build PhysicsSM.Draft.NullEdgeP1NormalizedDetNonneg
lake build PhysicsSM.Draft.NullEdgeP1MassRatioBounds
lake build PhysicsSM.Draft.NullEdgeP2DephasingDetMonotone
lake build PhysicsSM.Draft.NullEdgeP9ClosureDefect
lake build PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource
lake build PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP1NormalizedDetNonneg.lean,PhysicsSM/Draft/NullEdgeP1MassRatioBounds.lean,PhysicsSM/Draft/NullEdgeP2DephasingDetMonotone.lean,PhysicsSM/Draft/NullEdgeP9ClosureDefect.lean,PhysicsSM/Draft/NullEdgeP9ClosureVisibleSource.lean,PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP1NormalizedDetNonneg.lean PhysicsSM/Draft/NullEdgeP1MassRatioBounds.lean PhysicsSM/Draft/NullEdgeP2DephasingDetMonotone.lean PhysicsSM/Draft/NullEdgeP9ClosureDefect.lean PhysicsSM/Draft/NullEdgeP9ClosureVisibleSource.lean PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean PhysicsSMDraft.lean
```

## Literature cadence before fifth wave

Checked the new P11/channel-sector anchors before submitting more Aristotle
jobs. Both were already present in Zotero and Neo4j:

- `RW63ZR9E`: Blume-Kohout, Ng, Poulin, and Viola, *The structure of preserved
  information in quantum processes*, arXiv:0705.4282. Role: fixed observable
  algebras, noiseless subsystems, and preserved-information guardrail for
  treating particle species as stable channel sectors.
- `KDEECE8M`: Hawkins, Markopoulou, and Sahlmann, *Evolution in Quantum Causal
  Histories*, arXiv:hep-th/0302111. Role: finite causal networks of matrix
  algebras and completely positive maps; guardrail for not presenting this as a
  brand-new primitive process formalism.

Decision: no duplicate Zotero/Neo4j additions needed. The fifth wave includes
one P11 strategy/scaffold job to force a concrete finite channel/readout target
instead of ontology prose.

Verification:

```text
Zotero search: preserved information quantum processes -> RW63ZR9E
Zotero search: Evolution in Quantum Causal Histories -> KDEECE8M
Neo4j query confirmed Paper nodes for RW63ZR9E and KDEECE8M
```

## Fifth six-job Aristotle wave submitted

- `4d0b6f2c-e26e-424d-8ca9-7aa71b0ca63a`:
  `null-edge-p1-two-null-split-20260623`.
  Target: `kPlus_null`, `kMinus_null`, and
  `kPlus_add_kMinus_eq_momentum`.
  Role: observer-axis two-null split behind the frame-conditioned P1
  decomposition theorem.
- `9a5bb9c6-973e-4d11-8811-5cd0b7c2bb23`:
  `null-edge-p1-normalized-det-zero-20260623`.
  Target: `normalizedBlochDet_eq_zero_iff_radius_eq_one`.
  Role: normalized Bloch determinant zero endpoint, supporting
  "massless means pure celestial direction" after an observer normalization.
- `5f746180-c842-42b6-85ac-e094df9f11ac`:
  `null-edge-p2-dephasing-strict-20260623`.
  Target: `chiralDet_lt_dephasedDet_of_coherence_ne_zero`.
  Role: strict scalar determinant increase after explicit chirality dephasing
  when real coherence is nonzero.
- `33cb0788-8d3e-4cb8-a160-c5183975d732`:
  `null-edge-p9-closure-visible-any-20260623`.
  Target: `visibleClosureSource_of_any_nonzero_component`.
  Role: coordinate-independent scalar closure-source visibility diagnostic.
- `19fcf2d0-4aa1-4788-88e5-345a57d7980a`:
  `null-edge-p9-paired-fluctuation-positive-20260623`.
  Target: `sourceSqSum_pos_of_exists_nonzero` and
  `pairedSqSum_pos_of_exists_nonzero`.
  Role: mean-zero paired bookkeeping still has strictly positive second moment
  when any source amplitude is nonzero.
- `40413c03-ef9e-4692-be1e-7a60df4ce689`:
  `null-edge-p11-channel-sector-strategy-20260623`.
  Target: strategy/scaffold for stable particle sectors of finite causal
  quantum channels.
  Role: force the ontology into concrete data: transfer channel, calibrated
  momentum readout, observer channel, stable/metastable sector, and branch
  theorem targets.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-split-20260623/NullEdgeP1TwoNullSplit/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-normalized-det-zero-20260623/NullEdgeP1NormalizedDetZero/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-dephasing-strict-20260623/NullEdgeP2DephasingStrict/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-closure-visible-any-20260623/NullEdgeP9ClosureVisibleAny/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-paired-fluctuation-positive-20260623/NullEdgeP9PairedFluctuationPositive/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-channel-sector-strategy-20260623/NullEdgeP11ChannelSectorStrategy/Stub.lean
git diff --check -- fifth-wave staged files
```

## Fifth wave proof jobs integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP1TwoNullSplit`
  - `kPlus_null`
  - `kMinus_null`
  - `kPlus_add_kMinus_eq_momentum`
  - Role: observer-axis two-null split; a frame-conditioned algebraic guardrail
    for the P1 two-null decomposition language.
- `PhysicsSM.Draft.NullEdgeP1NormalizedDetZero`
  - `normalizedBlochDet_eq_zero_iff_radius_eq_one`
  - Role: normalized Bloch determinant vanishes exactly at the pure celestial
    endpoint.
- `PhysicsSM.Draft.NullEdgeP2DephasingStrict`
  - `chiralDet_lt_dephasedDet_of_coherence_ne_zero`
  - Role: explicit chirality dephasing strictly increases this determinant
    whenever real coherence is nonzero.
- `PhysicsSM.Draft.NullEdgeP9ClosureVisibleAny`
  - `visibleClosureSource_of_any_nonzero_component`
  - Role: any nonzero scalar closure-defect component yields a visible closure
    source in this diagnostic.
- `PhysicsSM.Draft.NullEdgeP9PairedFluctuationPositive`
  - `sourceSqSum_pos_of_exists_nonzero`
  - `pairedSqSum_pos_of_exists_nonzero`
  - Role: paired mean-zero bookkeeping retains strictly positive second moment
    when any source amplitude is nonzero.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullSplit.lean
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetZero.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingStrict.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ClosureVisibleAny.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedFluctuationPositive.lean
lake build PhysicsSM.Draft.NullEdgeP1TwoNullSplit
lake build PhysicsSM.Draft.NullEdgeP1NormalizedDetZero
lake build PhysicsSM.Draft.NullEdgeP2DephasingStrict
lake build PhysicsSM.Draft.NullEdgeP9ClosureVisibleAny
lake build PhysicsSM.Draft.NullEdgeP9PairedFluctuationPositive
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP1TwoNullSplit.lean,PhysicsSM/Draft/NullEdgeP1NormalizedDetZero.lean,PhysicsSM/Draft/NullEdgeP2DephasingStrict.lean,PhysicsSM/Draft/NullEdgeP9ClosureVisibleAny.lean,PhysicsSM/Draft/NullEdgeP9PairedFluctuationPositive.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP1TwoNullSplit.lean PhysicsSM/Draft/NullEdgeP1NormalizedDetZero.lean PhysicsSM/Draft/NullEdgeP2DephasingStrict.lean PhysicsSM/Draft/NullEdgeP9ClosureVisibleAny.lean PhysicsSM/Draft/NullEdgeP9PairedFluctuationPositive.lean PhysicsSMDraft.lean AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md
```

## Sixth five-job refill submitted

P11 channel-sector strategy remained running, so five open proof slots were
refilled.

- `6c826756-2cf8-4acd-bf78-186ba9c0d49e`:
  `null-edge-p1-two-null-energy-positive-20260623`.
  Target: nonnegative energy factors for the observer-axis two-null split.
- `baf217c8-06ff-45bc-a95a-444c4be6f401`:
  `null-edge-p1-normalized-det-positive-20260623`.
  Target: `normalizedBlochDet_pos_iff_radius_lt_one`.
- `1c2eecb1-a3da-4803-9b29-1e2a00e191c2`:
  `null-edge-p2-dephasing-gap-20260623`.
  Target: exact determinant gap equals squared real coherence.
- `f33cfc3c-ed83-4907-be2f-c254e4e26180`:
  `null-edge-p9-paired-zero-characterization-20260623`.
  Target: source-square and paired second moment vanish exactly when all source
  amplitudes vanish.
- `60fdb79b-1338-4b05-bda3-75fb21b07d2f`:
  `null-edge-p9-weighted-benchmark-bound-20260623`.
  Target: max-weight residual estimate packaged as a benchmark comparison.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-energy-positive-20260623/NullEdgeP1TwoNullEnergyPositive/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-normalized-det-positive-20260623/NullEdgeP1NormalizedDetPositive/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-dephasing-gap-20260623/NullEdgeP2DephasingGap/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-paired-zero-characterization-20260623/NullEdgeP9PairedZeroCharacterization/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-benchmark-bound-20260623/NullEdgeP9WeightedBenchmarkBound/Core.lean
git diff --check -- sixth-wave staged files
```

## Sixth-wave proof jobs integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP1TwoNullEnergyPositive`
  - `kPlus_energy_nonneg_of_sum_nonneg`
  - `kMinus_energy_nonneg_of_diff_nonneg`
  - `split_energies_nonneg`
  - Role: positivity guardrail for observer-axis two-null components.
- `PhysicsSM.Draft.NullEdgeP1NormalizedDetPositive`
  - `normalizedBlochDet_pos_iff_radius_lt_one`
  - Role: normalized determinant is positive exactly inside the observer
    radius endpoint.
- `PhysicsSM.Draft.NullEdgeP2DephasingGap`
  - `dephasedDet_sub_chiralDet_eq_coherenceSq`
  - `dephasedDet_eq_chiralDet_add_coherenceSq`
  - Role: exact determinant gap after dephasing is the squared real coherence.
- `PhysicsSM.Draft.NullEdgeP9PairedZeroCharacterization`
  - `sourceSqSum_eq_zero_iff_forall_zero`
  - `pairedSqSum_eq_zero_iff_forall_zero`
  - Role: paired second moment vanishes exactly when all source amplitudes
    vanish.
- `PhysicsSM.Draft.NullEdgeP9WeightedBenchmarkBound`
  - `weightSqSum_le_eps_mul_weightSum`
  - `weightSqSum_le_benchmark_of_max_and_total_bound`
  - Role: max-weight residual estimate packaged as a benchmark comparison.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullEnergyPositive.lean
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetPositive.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingGap.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedZeroCharacterization.lean
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedBenchmarkBound.lean
lake build PhysicsSM.Draft.NullEdgeP1TwoNullEnergyPositive
lake build PhysicsSM.Draft.NullEdgeP1NormalizedDetPositive
lake build PhysicsSM.Draft.NullEdgeP2DephasingGap
lake build PhysicsSM.Draft.NullEdgeP9PairedZeroCharacterization
lake build PhysicsSM.Draft.NullEdgeP9WeightedBenchmarkBound
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP1TwoNullEnergyPositive.lean,PhysicsSM/Draft/NullEdgeP1NormalizedDetPositive.lean,PhysicsSM/Draft/NullEdgeP2DephasingGap.lean,PhysicsSM/Draft/NullEdgeP9PairedZeroCharacterization.lean,PhysicsSM/Draft/NullEdgeP9WeightedBenchmarkBound.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP1TwoNullEnergyPositive.lean PhysicsSM/Draft/NullEdgeP1NormalizedDetPositive.lean PhysicsSM/Draft/NullEdgeP2DephasingGap.lean PhysicsSM/Draft/NullEdgeP9PairedZeroCharacterization.lean PhysicsSM/Draft/NullEdgeP9WeightedBenchmarkBound.lean PhysicsSMDraft.lean
```

## P11 channel-sector strategy integrated as report

Aristotle job `40413c03-ef9e-4692-be1e-7a60df4ce689` produced a useful
strategy scaffold rather than a narrow proof-only return. Integrated the
distilled report as:

- `AgentTasks/null-edge-p11-channel-sector-strategy-report-2026-06-23.md`.

Key result:

```text
P11 needs calibrated readout:
  readout(P) = (normalize(P), Tr(P))
  reconstruct(readout(P)) = P
```

Most important warning: a normalized CPTP/channel state can lose the absolute
energy scale. P11 mass statements should consume either the unnormalized
momentum block `P` or the pair `(rho, Tr(P))`, not `rho` alone.

Updated `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` with the first P11
proof gate:

- determinant rescaling under normalization;
- exact readout reconstruction when `Tr(P) != 0`;
- explicit counterexample showing normalized state alone loses determinant mass
  scale.

## Seventh six-job wave submitted

- `ae81c881-ab03-4a1c-9c6f-ec1c72e38fb2`:
  `null-edge-p11-readout-core-20260623`.
  Target: determinant rescaling under normalization, calibrated reconstruction,
  and a counterexample that normalized state alone loses determinant-mass scale.
- `b60f4f32-1078-451e-8415-19240dd9bf67`:
  `null-edge-p2-dephasing-equality-iff-20260623`.
  Target: dephasing equality iff real chirality coherence is zero.
- `68d8c48c-99f0-471b-aff3-a9c32104e62c`:
  `null-edge-p9-paired-positive-iff-20260623`.
  Target: paired/source second moment is positive iff some source amplitude is
  nonzero.
- `9c3efbcc-686b-43a5-b777-cf83f1a6053a`:
  `null-edge-p1-normalized-det-sign-20260623`.
  Target: normalized determinant negative/nonpositive sign classification.
- `2611e1e1-6a1c-4c1b-bc1e-d9bf64a7cf8a`:
  `null-edge-p1-two-null-uniqueness-20260623`.
  Target: uniqueness inside the observer-axis right/left null ansatz.
- `e818cb6b-006a-4b7b-9c1c-921d18946413`:
  `null-edge-p9-stochastic-source-strategy-20260623`.
  Target: P9 `DiamondNoiseSource` strategy using stochastic-gravity guardrail
  `PRCWRMFC`.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-readout-core-20260623/NullEdgeP11ReadoutCore/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-dephasing-equality-iff-20260623/NullEdgeP2DephasingEqualityIff/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-paired-positive-iff-20260623/NullEdgeP9PairedPositiveIff/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-normalized-det-sign-20260623/NullEdgeP1NormalizedDetSign/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-uniqueness-20260623/NullEdgeP1TwoNullUniqueness/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-source-strategy-20260623/NullEdgeP9StochasticSourceStrategy/Stub.lean
git diff --check -- seventh-wave staged files
```

## Literature cadence after seventh-wave submission

Ran a focused P1/P11 frame-audit search. Added two guardrail papers already
named in the publication plan but not yet present locally:

- `QDUD2CDE`: Peres, Scudo, and Terno, *Quantum Entropy and Special Relativity*,
  PRL 88, 230402, DOI `10.1103/PhysRevLett.88.230402`.
  Role: reduced spin density matrices and spin entropy are not Lorentz scalars.
- `Z2MFSJJU`: Gingrich and Adami, *Quantum Entanglement of Moving Bodies*, PRL
  89, 270402, DOI `10.1103/PhysRevLett.89.270402`.
  Role: spin/momentum entanglement changes under Lorentz transformations.

Decision: these reinforce the P1/P11 rule that `rho = P / Tr(P)` is a
frame-relative normalized state. The invariant mass statement must remain
`det(P) = m^2`, with any normalized mixedness advertised as `m/E_u`.

Verification:

```text
arXiv search found Peres-Scudo-Terno `quant-ph/0203033`.
Zotero duplicate searches found no existing matching items.
zotero_add_item_by_doi 10.1103/PhysRevLett.88.230402 -> QDUD2CDE
zotero_add_item_by_doi 10.1103/PhysRevLett.89.270402 -> Z2MFSJJU
Neo4j Paper nodes merged for QDUD2CDE and Z2MFSJJU.
```

## Literature cadence after sixth-wave submission

Ran a focused P9 search on stochastic gravity, noise kernels, and stress-tensor
fluctuations. Added the most useful guardrail source:

- `PRCWRMFC`: Hu and Verdaguer, *Stochastic Gravity: Theory and Applications*,
  Living Reviews in Relativity 7, 2004, DOI `10.12942/lrr-2004-3`.
  Role: separates mean stress-tensor sourcing from stress-tensor
  fluctuation/noise-kernel sourcing. This is directly relevant to the P9 finite
  theorems that produce mean-zero but nonzero second moments.

Decision: update P9 claim boundary. A theorem proving mean-zero residuals is
not enough for cosmological-constant leverage; a nonzero second moment may still
source stochastic metric fluctuations unless the finite diamond observer
channel, boundary-exactness condition, or response law kills that noise source.

Verification:

```text
OpenAlex/Crossref search found Hu-Verdaguer stochastic gravity review.
Zotero duplicate search found no existing item.
zotero_add_item_by_doi 10.12942/lrr-2004-3 -> PRCWRMFC
Neo4j Paper node merged for PRCWRMFC with P9 guardrail claim.
```

## Seventh-wave proof jobs integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP11ReadoutCore`
  - `det_normalize_eq_det_div_trace_sq`
  - `reconstruct_readout`
  - `normalized_channel_loses_energy_scale`
  - Role: calibrated P11 readout theorem. Normalized states alone can lose the
    determinant-mass scale; the readout `(normalize P, Tr P)` reconstructs the
    unnormalized momentum block when the trace is nonzero.
- `PhysicsSM.Draft.NullEdgeP2DephasingEqualityIff`
  - `dephasedDet_eq_chiralDet_iff_coherence_zero`
  - `chiralDet_le_dephasedDet_and_eq_iff`
  - Role: dephasing equality holds exactly when real chirality coherence is
    zero.
- `PhysicsSM.Draft.NullEdgeP9PairedPositiveIff`
  - `sourceSqSum_pos_iff_exists_nonzero`
  - `pairedSqSum_pos_iff_exists_nonzero`
  - Role: paired/source second moment is positive exactly when some source
    amplitude is nonzero.
- `PhysicsSM.Draft.NullEdgeP1NormalizedDetSign`
  - `normalizedBlochDet_neg_iff_one_lt_radius`
  - `normalizedBlochDet_nonpos_iff_one_le_radius`
  - Role: sign classification for normalized determinant beyond the physical
    Bloch-ball endpoint.
- `PhysicsSM.Draft.NullEdgeP1TwoNullUniqueness`
  - `observer_axis_split_coefficients_unique`
  - `observer_axis_split_vectors_unique`
  - Role: uniqueness inside the observer-axis right/left null ansatz.

Integrated strategy/scaffold return as:

- `AgentTasks/null-edge-p9-stochastic-source-strategy-report-2026-06-23.md`
  - Role: P9 stochastic-gravity guardrail. Mean-zero source bookkeeping is not
    gravitational invisibility when the noise response remains nonzero.
    The next proof-only target is `null-edge-p9-diamond-noise-source-core`.

Updated `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` so P9 explicitly
targets a `DiamondNoiseSource` core and a follow-on observer-visible
`noiseResponse` suppression theorem.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP11ReadoutCore.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingEqualityIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedPositiveIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetSign.lean
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullUniqueness.lean
lake build PhysicsSM.Draft.NullEdgeP11ReadoutCore
lake build PhysicsSM.Draft.NullEdgeP2DephasingEqualityIff
lake build PhysicsSM.Draft.NullEdgeP9PairedPositiveIff
lake build PhysicsSM.Draft.NullEdgeP1NormalizedDetSign
lake build PhysicsSM.Draft.NullEdgeP1TwoNullUniqueness
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP11ReadoutCore.lean,PhysicsSM/Draft/NullEdgeP2DephasingEqualityIff.lean,PhysicsSM/Draft/NullEdgeP9PairedPositiveIff.lean,PhysicsSM/Draft/NullEdgeP1NormalizedDetSign.lean,PhysicsSM/Draft/NullEdgeP1TwoNullUniqueness.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
Select-String -Path AgentTasks/null-edge-p9-stochastic-source-strategy-report-2026-06-23.md -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP11ReadoutCore.lean PhysicsSM/Draft/NullEdgeP2DephasingEqualityIff.lean PhysicsSM/Draft/NullEdgeP9PairedPositiveIff.lean PhysicsSM/Draft/NullEdgeP1NormalizedDetSign.lean PhysicsSM/Draft/NullEdgeP1TwoNullUniqueness.lean AgentTasks/null-edge-p9-stochastic-source-strategy-report-2026-06-23.md PhysicsSMDraft.lean
```

## Literature cadence before eighth-wave submission

Ran a focused dynamics/P9 literature pass. Semantic Scholar was rate-limited on
one query, so the pass used the fallback providers and existing Neo4j state.

Added a useful P2/P4 source to Zotero and linked it to the existing Neo4j paper
node:

- `JU96F5N6`: Kevissen Sellapillay, Arrighi, and Di Molfetta,
  *A discrete relativistic spacetime formalism for 1+1-QED with continuum
  limits*, arXiv:2103.13150.
  Role: gauge-invariant QCA guardrail for the null-step dynamics lane. It
  recovers the Kogut-Susskind Schwinger model in one limit and the free Dirac
  equation in the continuous spacetime one-particle sector.

Confirmed existing P2/P4 source:

- `I7G53I6T`: Arnault et al., quantum relativistic diffusion via quantum walks.

## Eighth six-job Aristotle wave submitted

- `36dc1456-a115-4cff-8557-0dded3bf3fd5`:
  `null-edge-p9-diamond-noise-source-core-20260623`.
  Target: finite `DiamondNoiseSource` core separating mean invisibility from
  noise invisibility, with explicit mean-zero/noise-nonzero witnesses.
- `8b239101-cf6f-4e75-b8f3-645182d08949`:
  `null-edge-p11-readout-rescale-core-20260623`.
  Target: normalization is invariant under nonzero scalar rescaling, while
  determinant mass scales quadratically.
- `e6c29932-ced9-4b55-965d-df00e2936a53`:
  `null-edge-p1-two-null-mass-product-20260623`.
  Target: product of observer-axis right/left null energies recovers timelike
  mass square.
- `f3125897-d94e-4392-aecb-93d71dbcfc34`:
  `null-edge-p9-noise-response-suppression-20260623`.
  Target: observer-visible diagonal noise response bounded by test-window
  strength times residual amplitude square sum.
- `5309aec6-1669-4bbd-88da-ad303be61edb`:
  `null-edge-p2-dephasing-purity-equality-20260623`.
  Target: dephasing purity equality iff real chirality coherence is zero.
- `00dd71c5-70bd-477f-9b40-6770b2024bd9`:
  `null-edge-null-step-quantum-walk-strategy-20260623`.
  Target: strategy/scaffold for the null-step quantum-walk dynamics bridge,
  using `JU96F5N6` and the existing P2/P4 theorem spine.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-noise-source-core-20260623/NullEdgeP9DiamondNoiseSource/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-readout-rescale-core-20260623/NullEdgeP11ReadoutRescale/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-mass-product-20260623/NullEdgeP1TwoNullMassProduct/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-response-suppression-20260623/NullEdgeP9NoiseResponseSuppression/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-dephasing-purity-equality-20260623/NullEdgeP2DephasingPurityEquality/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-null-step-quantum-walk-strategy-20260623/NullEdgeNullStepQuantumWalkStrategy/Stub.lean
```

## Eighth-wave proof jobs integrated

Integrated clean proof returns as:

- `PhysicsSM.Draft.NullEdgeP9DiamondNoiseSource`
  - `exists_meanZero_noise_nonzero`
  - `noiseKernel_self_nonneg`
  - `meanInvisible_imp_meanResponse_zero`
  - `noiseInvisible_imp_noiseResponse_zero`
  - `gravInvisible_imp_allResponses_zero`
  - `exists_meanZero_noiseResponse_nonzero`
  - `meanBoundaryExact_meanResponse_zero_of_closed`
  - `exists_meanBoundaryExact_closed_noiseResponse_nonzero`
  - Role: this is the strongest P9 guardrail so far. It proves in a finite
    diamond-noise API that mean-zero or mean-boundary-exact bookkeeping can
    leave an observer-visible noise response, while `GravInvisible` kills both
    mean and noise responses.
- `PhysicsSM.Draft.NullEdgeP11ReadoutRescale`
  - `trace_smul`
  - `normalize_smul_eq_normalize`
  - `massSq_smul_eq_sq_mul`
  - `scaled_same_normalized_state_different_mass`
  - Role: normalized readout forgets nonzero scalar scale while determinant
    mass scales quadratically; P11 must carry calibrated scale.
- `PhysicsSM.Draft.NullEdgeP1TwoNullMassProduct`
  - `split_energy_product_eq_massSq_div_four`
  - `four_mul_split_energy_product_eq_massSq`
  - `split_energy_product_nonneg_of_timelike`
  - Role: product of observer-axis right/left null energies recovers the
    timelike mass square.
- `PhysicsSM.Draft.NullEdgeP9NoiseResponseSuppression`
  - `diagonalNoiseResponse_nonneg`
  - `diagonalNoiseResponse_le_testBound_mul_ampSqSum`
  - `diagonalNoiseResponse_eq_ampSqSum_for_unit_test`
  - Role: first suppression theorem stated on an observer-visible diagonal
    noise response rather than a bare second moment.
- `PhysicsSM.Draft.NullEdgeP2DephasingPurityEquality`
  - `chiralPurity_sub_dephasedPurity_eq_two_coherenceSq`
  - `chiralPurity_eq_dephasedPurity_iff_coherence_zero`
  - `dephasedPurity_le_chiralPurity`
  - Role: dephasing purity equality holds exactly when real chirality coherence
    is zero.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingPurityEquality.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseResponseSuppression.lean
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullMassProduct.lean
lake env lean PhysicsSM/Draft/NullEdgeP11ReadoutRescale.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondNoiseSource.lean
lake build PhysicsSM.Draft.NullEdgeP2DephasingPurityEquality
lake build PhysicsSM.Draft.NullEdgeP9NoiseResponseSuppression
lake build PhysicsSM.Draft.NullEdgeP1TwoNullMassProduct
lake build PhysicsSM.Draft.NullEdgeP11ReadoutRescale
lake build PhysicsSM.Draft.NullEdgeP9DiamondNoiseSource
lake env lean PhysicsSMDraft.lean
Select-String -Path PhysicsSM/Draft/NullEdgeP2DephasingPurityEquality.lean,PhysicsSM/Draft/NullEdgeP9NoiseResponseSuppression.lean,PhysicsSM/Draft/NullEdgeP1TwoNullMassProduct.lean,PhysicsSM/Draft/NullEdgeP11ReadoutRescale.lean,PhysicsSM/Draft/NullEdgeP9DiamondNoiseSource.lean -Pattern '\bsorry\b|\badmit\b|axiom|opaque|unsafe|native_decide'
git diff --check -- PhysicsSM/Draft/NullEdgeP2DephasingPurityEquality.lean PhysicsSM/Draft/NullEdgeP9NoiseResponseSuppression.lean PhysicsSM/Draft/NullEdgeP1TwoNullMassProduct.lean PhysicsSM/Draft/NullEdgeP11ReadoutRescale.lean PhysicsSM/Draft/NullEdgeP9DiamondNoiseSource.lean PhysicsSMDraft.lean AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md
```

## Literature cadence before ninth-wave refill

Ran a focused P9 stochastic-gravity/noise-kernel literature pass. Added:

- `867EE9U7`: Rosario Martin and Enric Verdaguer,
  *Stochastic semiclassical fluctuations in Minkowski spacetime*, PRD 61,
  DOI `10.1103/physrevd.61.124024`.
  Role: concrete stochastic-gravity guardrail showing that stress-tensor
  fluctuations can induce metric fluctuations. This supports the new P9 rule:
  nonzero finite `noiseResponse` cannot be advertised as gravitationally
  invisible merely because the mean source vanishes.

## Ninth five-job refill submitted

The null-step quantum-walk strategy job `00dd71c5-70bd-477f-9b40-6770b2024bd9`
was still running, so five proof slots were refilled:

- `5c387255-629e-4b80-8dcb-09c6f01c0a4b`:
  `null-edge-p9-boundary-exact-noise-invisible-20260623`.
  Target: per-configuration boundary exactness kills closed-test mean response
  and response noise.
- `7fd769bb-2071-4820-83dd-0c00f5998cb5`:
  `null-edge-p9-noise-diagonal-test-20260623`.
  Target: a cell-local test reads a diagonal noise-kernel entry.
- `4fe2b5fa-8321-4022-980a-aa66114ba9a8`:
  `null-edge-p1-two-null-massless-iff-20260623`.
  Target: with nonnegative null energies, split mass square vanishes iff one
  component is absent and is positive iff both are present.
- `408dbf7c-24a9-4892-9e1f-521e72bbe333`:
  `null-edge-p11-readout-injective-20260623`.
  Target: calibrated pair `(normalize P, Tr P)` reconstructs the unnormalized
  momentum block.
- `1f0162da-cc0a-41ba-bb33-75b7ac0af6c7`:
  `null-edge-p9-unit-noise-positive-iff-20260623`.
  Target: unit-test diagonal noise response is positive iff some residual
  amplitude is nonzero.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-boundary-exact-noise-invisible-20260623/NullEdgeP9BoundaryExactNoiseInvisible/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-diagonal-test-20260623/NullEdgeP9NoiseDiagonalTest/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-massless-iff-20260623/NullEdgeP1TwoNullMasslessIff/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-readout-injective-20260623/NullEdgeP11ReadoutInjective/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-unit-noise-positive-iff-20260623/NullEdgeP9UnitNoisePositiveIff/Core.lean
```

## Integrated null-step quantum-walk strategy result

Integrated Aristotle job:

- `00dd71c5-70bd-477f-9b40-6770b2024bd9`:
  `null-edge-null-step-quantum-walk-strategy-20260623`.

New repo artifacts:

- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`
- `AgentTasks/null-edge-null-step-quantum-walk-strategy-report-2026-06-23.md`

Proved declarations:

- `trace_Ua`
- `det_Ua`
- `IsQuasienergy`
- `isQuasienergy_iff_trace`
- `sinOmegaSq`
- `sinOmegaSq_eq`
- `coherenceSq`
- `tendsto_sin_mul_div`
- `coherenceSq_continuum`
- `coherenceSq_continuum_mE`

Scientific significance:

- This is the strongest current P2/P4 dynamics bridge. It gives a finite
  null-step quantum walk whose trace gives the lattice Dirac quasienergy
  relation and whose squared chirality coherence converges to `(m/E)^2` in the
  continuum limit.
- It directly supports the publication spine:
  `Plucker geometry -> observer-conditioned celestial qubit -> chirality
  coherence -> null-step dynamics -> stable channel sectors`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeNullStepQuantumWalkCore.lean
lake build PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore
```

Both checks passed after removing one unused simp-argument warning from the
returned proof.

## Tenth single-slot refill submitted

Submitted one focused follow-up after integrating the null-step quantum-walk
strategy result:

- `0c78bae6-b4b2-4643-907c-a7ec5e4b276d`:
  `null-edge-qw-exp-provenance-20260623`.
  Target: prove `Rz_eq_exp` and `Rx_eq_exp`, connecting the Euler closed-form
  quantum-walk gates to literal matrix exponentials of Pauli generators. This is
  optional for the finite coherence theorem, but useful for publication
  notation and referee auditability.

Pre-submission check:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-qw-exp-provenance-20260623/NullEdgeQWExpProvenance/Core.lean
```

The file elaborated with two intended proof-hole warnings.

## Literature cadence after null-step quantum-walk integration

Ran a focused P2/P4 literature pass on Dirac quantum walks and quantum cellular
automata. Added to Zotero collection `9W59V3K9` and mirrored into Neo4j under
claim `null-edge-p2p4-null-step-qw-dirac-bridge`:

- `XK9ZRDNJ`: Frederick W. Strauch,
  *Connecting the discrete- and continuous-time quantum walks*,
  DOI `10.1103/physreva.74.030301`.
  Role: guardrail for the discrete/continuous quantum-walk-to-Dirac bridge.
- `QSB24VR9`: Frederick W. Strauch,
  *Relativistic effects and rigorous limits for discrete- and continuous-time
  quantum walks*, DOI `10.1063/1.2759837`.
  Role: guardrail for rigorous Dirac limits, localization, and relativistic
  effects in quantum walks.
- `BVJBTK8J`: Alessandro Bisio, Giacomo Mauro D'Ariano, Paolo Perinotti, and
  Alessandro Tosini,
  *Free quantum field theory from quantum cellular automata: derivation of Weyl,
  Dirac and Maxwell quantum cellular automata*, arXiv `1601.04832`.
  Role: prior art for QCA derivations of Weyl/Dirac dynamics in the relativistic
  limit.
- `KCQGEDJE`: Alessandro Bisio, Giacomo Mauro D'Ariano, Paolo Perinotti, and
  Alessandro Tosini,
  *Weyl, Dirac and Maxwell Quantum Cellular Automata*, arXiv `1601.04842`.
  Role: prior art and phenomenological guardrail for QCA dispersion.

Existing Zotero item `JZEJ4VXA` already covers D'Ariano-Mosco-Perinotti-Tosini
3+1 Dirac quantum walks.

## Integrated ninth-wave proof batch

Integrated five Aristotle jobs:

- `1f0162da-cc0a-41ba-bb33-75b7ac0af6c7`:
  `null-edge-p9-unit-noise-positive-iff-20260623`.
- `408dbf7c-24a9-4892-9e1f-521e72bbe333`:
  `null-edge-p11-readout-injective-20260623`.
- `4fe2b5fa-8321-4022-980a-aa66114ba9a8`:
  `null-edge-p1-two-null-massless-iff-20260623`.
- `7fd769bb-2071-4820-83dd-0c00f5998cb5`:
  `null-edge-p9-noise-diagonal-test-20260623`.
- `5c387255-629e-4b80-8dcb-09c6f01c0a4b`:
  `null-edge-p9-boundary-exact-noise-invisible-20260623`.

New draft modules:

- `PhysicsSM.Draft.NullEdgeP9UnitNoisePositiveIff`
  - `diagonalNoiseResponse_eq_ampSqSum_for_unit_test`
  - `unitNoiseResponse_pos_iff_exists_nonzero`
  - Role: a unit diagonal test has positive noise response exactly when at
    least one residual amplitude is nonzero.
- `PhysicsSM.Draft.NullEdgeP11ReadoutInjective`
  - `trace_smul_normalize`
  - `eq_of_same_normalize_and_trace`
  - Role: calibrated readout `(normalize P, trace P)` reconstructs the
    unnormalized momentum block, so normalized channel state alone is not the
    invariant mass datum.
- `PhysicsSM.Draft.NullEdgeP1TwoNullMasslessIff`
  - `splitMassSq_eq_zero_iff_left_or_right_zero`
  - `splitMassSq_pos_iff_left_and_right_pos`
  - Role: in the two-null observer-axis split, the mass square vanishes iff one
    component is absent and is positive iff both null components are present.
- `PhysicsSM.Draft.NullEdgeP9NoiseDiagonalTest`
  - `noiseResponse_deltaTest_eq_noiseKernel_self`
  - `exists_test_noiseResponse_nonzero_of_diagonal_nonzero`
  - Role: a cell-local test reads the diagonal of the finite noise kernel.
- `PhysicsSM.Draft.NullEdgeP9BoundaryExactNoiseInvisible`
  - `boundaryExact_configResponse_zero_of_closed`
  - `boundaryExact_meanResponse_zero_of_closed`
  - `boundaryExact_responseNoise_zero_of_closed`
  - Role: if each configuration source is boundary-exact, closed tests kill both
    mean response and response noise. This is a stronger P9 invisibility
    criterion than mean-zero alone.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9UnitNoisePositiveIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP11ReadoutInjective.lean
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullMasslessIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseDiagonalTest.lean
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryExactNoiseInvisible.lean
lake build PhysicsSM.Draft.NullEdgeP9UnitNoisePositiveIff
lake build PhysicsSM.Draft.NullEdgeP11ReadoutInjective
lake build PhysicsSM.Draft.NullEdgeP1TwoNullMasslessIff
lake build PhysicsSM.Draft.NullEdgeP9NoiseDiagonalTest
lake build PhysicsSM.Draft.NullEdgeP9BoundaryExactNoiseInvisible
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9UnitNoisePositiveIff.lean PhysicsSM/Draft/NullEdgeP11ReadoutInjective.lean PhysicsSM/Draft/NullEdgeP1TwoNullMasslessIff.lean PhysicsSM/Draft/NullEdgeP9NoiseDiagonalTest.lean PhysicsSM/Draft/NullEdgeP9BoundaryExactNoiseInvisible.lean
git diff --check -- <integrated batch files>
```

All checks passed. Minor returned linter warnings were cleaned during
integration.

## Literature cadence after ninth-wave integration

Ran a focused P9 literature pass on stochastic gravity and exact/boundary-source
invisibility. Added:

- `TXN5JSZ5`: Bei Lok Hu and Enric Verdaguer,
  *Stochastic Gravity: Theory and Applications*,
  DOI `10.12942/lrr-2008-3`.
  Role: main P9 guardrail that stress-tensor fluctuations/noise kernels are
  gravitational source data distinct from the mean stress tensor. This supports
  the finite theorem distinction: mean-zero bookkeeping is not enough; a serious
  invisibility claim must kill the relevant noise response or make it
  boundary-exact for the tests in question.

Mirrored into Neo4j under claim
`null-edge-p9-mean-zero-not-noise-invisibility`.

## Integrated quantum-walk exponential-provenance job

Integrated Aristotle job:

- `0c78bae6-b4b2-4643-907c-a7ec5e4b276d`:
  `null-edge-qw-exp-provenance-20260623`.

New draft module:

- `PhysicsSM.Draft.NullEdgeQWExpProvenance`
  - `Rz_eq_exp`
  - `Rx_eq_exp`
  - `Ua_eq_exp_product`

Scientific significance:

- This proves that the Euler closed-form `Rz` and `Rx` gates used in the
  null-step quantum-walk core match literal matrix exponentials of Pauli
  generators. It is not needed for the trace/coherence theorem, but it makes the
  paper-facing notation directly formal.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeQWExpProvenance.lean
lake build PhysicsSM.Draft.NullEdgeQWExpProvenance
lake env lean PhysicsSMDraft.lean
```

All checks passed.

## Eleventh six-job refill submitted

Submitted six focused follow-up jobs:

- `21bd32fa-3bfe-4a4d-a9b3-cbec08971fb5`:
  `null-edge-p9-noise-kernel-determined-by-tests-20260623`.
  Target: all zero observer test responses imply the finite noise kernel is
  zero entrywise.
- `e935fbeb-1cee-4f4e-a3db-5793cf81aa0e`:
  `null-edge-p9-boundary-exact-perturbation-invariant-20260623`.
  Target: adding a boundary-exact perturbation leaves closed-test mean response
  and response noise unchanged.
- `dcb87aab-08ca-4a47-87ce-ef30258747ba`:
  `null-edge-p11-normalize-same-iff-scale-20260623`.
  Target: equality of normalized blocks is equivalent to trace-scaled equality
  of unnormalized blocks.
- `1c210b65-ba73-4a5b-9a5d-fae11957b285`:
  `null-edge-p2-walk-projector-coherence-bridge-20260623`.
  Target: the null-step walk continuum coherence ratio equals the squared
  positive-energy chiral-projector coherence.
- `8faf5ba8-12a9-40f6-809d-b0eb6c0d8304`:
  `null-edge-p1-two-null-mass-ratio-velocity-20260623`.
  Target: the observer-axis two-null split obeys `m^2 / E^2 = 1 - v^2`.
- `c66705b3-bd3c-4b0b-878c-d4d407b44747`:
  `null-edge-p9-grav-invisible-api-20260623`.
  Target: name `GravInvisible` as mean invisibility plus noise invisibility, and
  prove boundary-exact closed-test invisibility.

Pre-submission checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-kernel-determined-by-tests-20260623/NullEdgeP9NoiseKernelDeterminedByTests/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-boundary-exact-perturbation-invariant-20260623/NullEdgeP9BoundaryExactPerturbationInvariant/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-normalize-same-iff-scale-20260623/NullEdgeP11NormalizeSameIffScale/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-walk-projector-coherence-bridge-20260623/NullEdgeP2WalkProjectorCoherenceBridge/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p1-two-null-mass-ratio-velocity-20260623/NullEdgeP1TwoNullMassRatioVelocity/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-grav-invisible-api-20260623/NullEdgeP9GravInvisibleAPI/Core.lean
```

All six elaborated with intended proof-hole warnings only.

## Integrated five eleventh-wave follow-up jobs

Integrated five of the six follow-up jobs; the sixth P9 noise-kernel job was
still running at the time and is recorded separately below.

New draft modules:

- `PhysicsSM.Draft.NullEdgeP11NormalizeSameIffScale`
  - `trace_smul_normalize`
  - `same_normalize_iff_trace_scaled`
  - `same_normalize_of_scalar_multiple`
  - Role: equality of normalized momentum blocks is equivalent to
    trace-scaled equality of unnormalized blocks.
- `PhysicsSM.Draft.NullEdgeP9GravInvisibleAPI`
  - `MeanInvisible`
  - `NoiseInvisible`
  - `GravInvisible`
  - `boundaryExact_configResponse_zero_of_closed`
  - `boundaryExact_gravInvisible_of_closed`
  - Role: names the P9 guardrail that gravitational invisibility must kill both
    mean response and noise response.
- `PhysicsSM.Draft.NullEdgeP1TwoNullMassRatioVelocity`
  - `splitEnergy`
  - `splitSpatial`
  - `splitMassSq`
  - `split_massRatioSq_eq_one_sub_velocitySq`
  - Role: the observer-axis two-null split obeys the standard
    `m^2 / E^2 = 1 - v^2` identity.
- `PhysicsSM.Draft.NullEdgeP2WalkProjectorCoherenceBridge`
  - `positiveProjectorLR`
  - `chiralityCoherence`
  - `chiralityCoherence_positiveProjectorLR_sq`
  - `walk_limit_ratio_eq_projector_coherence_sq`
  - Role: connects the null-step walk coherence limit with the positive-energy
    chiral projector coherence.
- `PhysicsSM.Draft.NullEdgeP9BoundaryExactPerturbationInvariant`
  - `boundaryExact_perturb_configResponse_eq`
  - `boundaryExact_perturb_meanResponse_eq`
  - `boundaryExact_perturb_responseNoise_eq`
  - Role: adding a boundary-exact perturbation leaves closed-test mean response
    and response noise unchanged.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP11NormalizeSameIffScale.lean
lake env lean PhysicsSM/Draft/NullEdgeP9GravInvisibleAPI.lean
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullMassRatioVelocity.lean
lake env lean PhysicsSM/Draft/NullEdgeP2WalkProjectorCoherenceBridge.lean
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryExactPerturbationInvariant.lean
lake build PhysicsSM.Draft.NullEdgeP11NormalizeSameIffScale
lake build PhysicsSM.Draft.NullEdgeP9GravInvisibleAPI
lake build PhysicsSM.Draft.NullEdgeP1TwoNullMassRatioVelocity
lake build PhysicsSM.Draft.NullEdgeP2WalkProjectorCoherenceBridge
lake build PhysicsSM.Draft.NullEdgeP9BoundaryExactPerturbationInvariant
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <five integrated modules>
git diff --check -- <five integrated modules and task notes>
```

All checks passed. Minor returned linter warnings were cleaned during
integration.

## Integrated P9 noise-kernel determined-by-tests job

Integrated Aristotle job:

- `21bd32fa-3bfe-4a4d-a9b3-cbec08971fb5`:
  `null-edge-p9-noise-kernel-determined-by-tests-20260623`.

New draft module:

- `PhysicsSM.Draft.NullEdgeP9NoiseKernelDeterminedByTests`
  - `noiseKernel_symm`
  - `noiseResponse_deltaTest_eq_noiseKernel_self`
  - `noiseResponse_pairTest_eq_diag_diag_cross`
  - `noiseKernel_eq_zero_of_all_noiseResponses_zero`

Scientific significance:

- This is the strongest finite P9 noise-invisibility guardrail so far. It proves
  that if every observer test function has zero quadratic noise response, then
  the whole finite noise kernel vanishes entrywise. In particular, P9 cannot
  hide behind mean-zero bookkeeping if a test-visible noise kernel remains.

Verification:

```text
lake env lean AgentTasks/aristotle-output/21bd32fa-3bfe-4a4d-a9b3-cbec08971fb5/extracted/project-files.tar/null-edge-p9-noise-kernel-determined-by-tests-20260623-project_aristotle/NullEdgeP9NoiseKernelDeterminedByTests/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseKernelDeterminedByTests.lean
lake build PhysicsSM.Draft.NullEdgeP9NoiseKernelDeterminedByTests
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9NoiseKernelDeterminedByTests.lean
```

All checks passed. The placeholder scan was clean.

## Submitted third six-job batch

Submitted another six focused standalone Aristotle jobs after integrating the
second-batch P9/P7/P11/QW results.

Projects:

- `d3b26a65-ba27-4daf-bb9d-c54a924ae5ae`
  - Name: `null-edge-p9-noise-response-amplitude-zero-20260623`
  - Role: under strictly positive weights, characterize zero noise response by
    vanishing centered test amplitudes.
- `445bf634-7390-42f3-aa62-b67c741ea9b3`
  - Name: `null-edge-p9-noise-bilinear-cauchy-20260623`
  - Role: prove the finite P9 noise-response bilinear pairing satisfies
    Cauchy-Schwarz.
- `193f5fbb-572c-4620-b05c-6864e3a98249`
  - Name: `null-edge-p9-delta-pair-test-basis-20260623`
  - Role: show delta and pair tests form a finite detection basis for the noise
    kernel.
- `8743e94d-694d-4f42-85f8-9e70c5dcab4d`
  - Name: `null-edge-p7-bloch-contraction-purity-20260623`
  - Role: express observer-channel mixedness as purity loss under Bloch
    contraction.
- `a6acc2fa-cb06-4117-8154-c55a240d70f3`
  - Name: `null-edge-qw-norm-preservation-20260623`
  - Role: turn QW unitarity into concrete two-component spinor norm
    preservation.
- `0618f638-d966-4fa9-9ba7-f56f921f2760`
  - Name: `null-edge-p11-lifetime-threshold-20260623`
  - Role: prove a finite logarithmic threshold inequality for metastable
    lifetimes.

Pre-submit checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-response-amplitude-zero-20260623/NullEdgeP9NoiseResponseAmplitudeZero/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-bilinear-cauchy-20260623/NullEdgeP9NoiseBilinearCauchy/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-delta-pair-test-basis-20260623/NullEdgeP9DeltaPairTestBasis/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p7-bloch-contraction-purity-20260623/NullEdgeP7BlochContractionPurity/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-qw-norm-preservation-20260623/NullEdgeQWNormPreservation/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-lifetime-threshold-20260623/NullEdgeP11LifetimeThreshold/Core.lean
```

All staged targets elaborated locally with only intentional draft proof-hole
warnings. Aristotle accepted all six submissions.

## Integrated remaining QW unitarity job

The final second-batch job completed and was integrated.

New draft module:

- `PhysicsSM.Draft.NullEdgeQWUnitarity`
  - `Rz_unitary`
  - `Rx_unitary`
  - `Ua_unitary`
  - Role: the closed-form null-step Pauli rotations and one-step walk product
    are unitary for the explicit finite predicate `M.conjTranspose * M = 1`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeQWUnitarity.lean
lake build PhysicsSM.Draft.NullEdgeQWUnitarity
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeQWUnitarity.lean
```

All checks passed. The placeholder scan was clean.

## Submitted six-job follow-up batch

Submitted six focused standalone Aristotle jobs after checking that the staged
standalone targets elaborate locally and that near-match completed jobs were
not duplicates.

Projects:

- `c5c4f15d-8e48-4f86-a430-3983f7cbdb42`
  - Name: `null-edge-p9-noise-kernel-entry-recovery-20260623`
  - Role: recover finite symmetric noise-kernel entries from observer test
    responses.
- `0a59d14c-d60a-4eaf-9d61-9a2d4b1f2eef`
  - Name: `null-edge-p9-noise-response-nonneg-20260623`
  - Role: prove nonnegativity of finite diagonal/Gram noise responses under
    nonnegative weights.
- `0aefef23-ff04-4689-9eb1-8fbafb00b35c`
  - Name: `null-edge-p2-projector-dephased-det-mass-ratio-20260623`
  - Role: derive the dephased two-chirality determinant mass-ratio identity
    from `E^2 = p^2 + m^2`.
- `668eca1c-4c4c-4aac-b066-dcc2b17afc33`
  - Name: `null-edge-p1-observer-two-null-algebra-20260623`
  - Role: prove the finite two-null observer algebra for energy, momentum,
    determinant, and normalized mass ratio.
- `b9327e56-86db-44da-a819-9657b0504b93`
  - Name: `null-edge-p11-metastable-log-lifetime-20260623`
  - Role: prove positivity and scaling identities for the logarithmic
    metastable-lifetime formula.
- `00bf48ec-8497-4418-8738-b00ea52d928f`
  - Name: `null-edge-p7-bloch-contraction-mixedness-20260623`
  - Role: show Bloch-radius contraction increases the normalized
    mass-ratio/mixedness functional.

Submission notes:

- The local staged targets passed `lake env lean` before submission, with only
  the intended draft proof-hole warnings.
- Aristotle accepted all six projects and reported them as `RUNNING`.
- The CLI warned that the focused packages have no `.lake` directory. This is
  the expected lightweight standalone-package warning, not a local elaboration
  failure.

## Reconciled completed strategy/P9 outputs

While the six follow-up jobs were running, reconciled several older completed
outputs whose task notes still said `submitted`.

Marked integrated:

- `null-edge-null-step-quantum-walk-strategy-20260623`
  (`00dd71c5-70bd-477f-9b40-6770b2024bd9`).
- `null-edge-strategy-audit-grand-20260623`
  (`4153d0e4-480f-4002-9ebb-64461384197a`).
- `null-edge-p9-meanzero-fluctuation-20260623`
  (`b28351f1-f058-4357-b176-252c795be00d`), noting Aristotle reported
  `COMPLETE_WITH_ERRORS` but the local draft module elaborates cleanly.
- `null-edge-p9-residual-variance-cell-area-20260623`
  (`ce4d21d4-0b8d-4344-977c-db3bee6bd950`).
- `null-edge-p9-stochastic-source-strategy-20260623`
  (`e818cb6b-006a-4b7b-9c1c-921d18946413`).

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondNoiseSource.lean
lake env lean PhysicsSM/Draft/NullEdgeQWExpProvenance.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ResidualVarianceCellArea.lean
lake env lean PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
```

All four targeted checks passed.

## Literature cadence: P9 stochastic-gravity guardrail

Semantic Scholar was still rate-limited, so this pass used OpenAlex, Crossref,
arXiv, Zotero, and Neo4j fallbacks.

Confirmed existing keys:

- `PRCWRMFC`, `TXN5JSZ5`: Hu-Verdaguer stochastic-gravity reviews.
- `5T5BQ6PT`: Phillips-Hu explicit noise-kernel construction.
- `STUCFHB7`: Surya causal-set review.
- `ZP7E648U`: Ahmed-Dodelson-Greene-Sorkin everpresent Lambda.

Added to Zotero and linked in Neo4j to
`null-edge-p9-mean-zero-not-noise-invisibility`:

- `PW8MXJ8I`: Hu-Matacz, "Back reaction in semiclassical gravity: The
  Einstein-Langevin equation", DOI `10.1103/physrevd.51.1577`.
- `K8SI5KZ9`: Campos-Verdaguer, "Stochastic semiclassical equations for weakly
  inhomogeneous cosmologies", DOI `10.1103/physrevd.53.1927`.

Plan update: the publication plan now cites these keys in the P9
stochastic-gravity guardrail. The theorem consequence is stronger: P9 should
continue prioritizing finite definitions and theorems that distinguish
`MeanInvisible`, `NoiseInvisible`, response zero, and boundary-exact source
bookkeeping.

## Integrated six-job follow-up batch

All six follow-up Aristotle jobs completed and were integrated into
`PhysicsSM/Draft`, then imported by `PhysicsSMDraft.lean`.

New draft modules:

- `PhysicsSM.Draft.NullEdgeP9NoiseKernelEntryRecovery`
  - `noiseKernel_symm`
  - `noiseResponse_deltaTest_eq_noiseKernel_self`
  - `noiseResponse_pairTest_eq_diag_diag_cross`
  - `noiseKernel_entry_recovered_from_tests`
  - Role: finite observer tests recover diagonal and off-diagonal entries of
    the P9 noise kernel.
- `PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg`
  - `noiseResponse_eq_weighted_square_sum`
  - `noiseResponse_nonneg_of_weights_nonneg`
  - Role: the finite P9 noise response is a nonnegative weighted square sum
    under nonnegative weights.
- `PhysicsSM.Draft.NullEdgeP2ProjectorDephasedDetMassRatio`
  - `dephasedDet_chiralWeight_eq_mass_ratio_sq`
  - Role: dephased two-chirality determinant equals `m^2/(4E^2)` on the scalar
    mass shell.
- `PhysicsSM.Draft.NullEdgeP1ObserverTwoNullAlgebra`
  - `splitEnergy_eq`
  - `splitSpatial_eq`
  - `splitMassSq_eq_E_sq_sub_s_sq`
  - `splitMassSq_eq_four_product`
  - Role: observer-axis two-null split algebra for P1.
- `PhysicsSM.Draft.NullEdgeP11MetastableLogLifetime`
  - `lifetimeDenom_pos_of_lt_one`
  - `metastableLifetime_pos`
  - Role: positivity guardrail for the metastable logarithmic lifetime formula.
- `PhysicsSM.Draft.NullEdgeP7BlochContractionMixedness`
  - `blochContraction_massRatioSq_monotone`
  - Role: unital Bloch-radius contraction cannot decrease the normalized
    mixedness / mass-ratio-square functional.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseKernelEntryRecovery.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseResponseNonneg.lean
lake env lean PhysicsSM/Draft/NullEdgeP2ProjectorDephasedDetMassRatio.lean
lake env lean PhysicsSM/Draft/NullEdgeP1ObserverTwoNullAlgebra.lean
lake env lean PhysicsSM/Draft/NullEdgeP11MetastableLogLifetime.lean
lake env lean PhysicsSM/Draft/NullEdgeP7BlochContractionMixedness.lean
lake build PhysicsSM.Draft.NullEdgeP9NoiseKernelEntryRecovery
lake build PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg
lake build PhysicsSM.Draft.NullEdgeP2ProjectorDephasedDetMassRatio
lake build PhysicsSM.Draft.NullEdgeP1ObserverTwoNullAlgebra
lake build PhysicsSM.Draft.NullEdgeP11MetastableLogLifetime
lake build PhysicsSM.Draft.NullEdgeP7BlochContractionMixedness
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <six new modules>
```

All targeted checks passed. The placeholder scan was clean.

## Submitted second six-job follow-up batch

After the prior six jobs completed and were integrated, submitted another six
focused standalone Aristotle jobs. This batch was shaped by the P9
stochastic-gravity literature pass and the grand-strategy emphasis on
observer-conditioned theorem surfaces.

Projects:

- `21d9c86c-fb31-4a9b-8c61-3b3d54b470a6`
  - Name: `null-edge-p9-response-characterization-20260623`
  - Role: characterize `MeanInvisible`, `NoiseInvisible`, and
    `GravInvisible` by vanishing finite observer responses.
- `814f9fee-3b3b-44f2-95b0-8c882b541d5c`
  - Name: `null-edge-p9-noise-cauchy-schwarz-20260623`
  - Role: prove weighted covariance/noise-kernel Cauchy-Schwarz under
    nonnegative weights.
- `a370b5f2-5a2f-4d23-a6f7-82bd8d47335f`
  - Name: `null-edge-p9-positive-weight-noise-zero-20260623`
  - Role: under strictly positive weights, convert zero self-noise into
    centered-source vanishing.
- `a64d164d-152f-4b98-9024-2829971b4d58`
  - Name: `null-edge-p7-bloch-contraction-strict-20260623`
  - Role: prove genuine Bloch-radius contraction strictly increases the
    normalized mixedness functional away from zero radius.
- `10c02f69-708a-4007-b96e-40f62475ce80`
  - Name: `null-edge-p11-metastable-lifetime-monotone-20260623`
  - Role: prove logarithmic metastable lifetime increases as eigenvalue
    modulus approaches one.
- `ff86d416-599d-4003-a2f8-7a68f01a505a`
  - Name: `null-edge-qw-unitarity-20260623`
  - Role: certify closed-form null-step Pauli rotations and the one-step walk
    as unitary finite quantum evolution.

Pre-submit checks:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-response-characterization-20260623/NullEdgeP9ResponseCharacterization/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-noise-cauchy-schwarz-20260623/NullEdgeP9NoiseCauchySchwarz/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-positive-weight-noise-zero-20260623/NullEdgeP9PositiveWeightNoiseZero/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p7-bloch-contraction-strict-20260623/NullEdgeP7BlochContractionStrict/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p11-metastable-lifetime-monotone-20260623/NullEdgeP11MetastableLifetimeMonotone/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-qw-unitarity-20260623/NullEdgeQWUnitarity/Core.lean
```

All staged targets elaborated locally with only intentional draft proof-hole
warnings. Aristotle accepted all six submissions. The focused-package `.lake`
warning is expected.

## Literature cadence: null-step quantum-walk / Dirac-QCA lane

While the second six-job batch was running, ran a QW/QCA literature pass using
OpenAlex, Crossref, arXiv, Zotero, and Neo4j fallbacks.

Confirmed existing keys:

- `JZEJ4VXA`: D'Ariano-Mosco-Perinotti-Tosini 3+1 Dirac quantum walk.
- `BVJBTK8J`, `KCQGEDJE`: Bisio-D'Ariano-Perinotti-Tosini QCA/free-field
  derivations.
- `G7NXEZBU`: Sato-Katori Dirac quantum walk with ultraviolet cutoff.

Added to Zotero and linked in Neo4j to
`null-edge-p2p4-null-step-qw-dirac-bridge`:

- `4F87TGCN`: Arrighi-Nesme-Forets, "The Dirac equation as a quantum walk:
  higher dimensions, observational convergence", DOI
  `10.1088/1751-8113/47/46/465302`.
- `PTHQB2RM`: Arnault-Perez-Arrighi-Farrelly, "Discrete-time quantum walks as
  fermions of lattice gauge theory", DOI `10.1103/physreva.99.032110`.
- `VHPN6G7D`: Arrighi-Facchini-Forets, "Discrete Lorentz covariance for quantum
  walks and quantum cellular automata", DOI `10.1088/1367-2630/16/9/093007`.

Plan update: the publication plan's P2/P4 dynamics-paper source paragraph now
cites these keys. This strengthens the claim boundary: our finite QW theorem
cluster should be presented as a sourced null-step/Dirac-dynamics bridge, not
as a newly discovered quantum-walk construction.

## Integrated five completed jobs from second batch

Five of the six second-batch jobs completed; `null-edge-qw-unitarity-20260623`
remains running.

New draft modules:

- `PhysicsSM.Draft.NullEdgeP9ResponseCharacterization`
  - `meanResponse_deltaTest_eq_meanSource`
  - `meanInvisible_iff_all_meanResponses_zero`
  - `noiseKernel_symm`
  - `noiseResponse_deltaTest_eq_noiseKernel_self`
  - `noiseResponse_pairTest_eq_diag_diag_cross`
  - `noiseInvisible_iff_all_noiseResponses_zero`
  - `gravInvisible_iff_all_responses_zero`
  - Role: finite P9 source invisibility is characterized by response
    functionals over observer tests.
- `PhysicsSM.Draft.NullEdgeP9NoiseCauchySchwarz`
  - `weightedDot_cauchy_schwarz`
  - `noiseKernel_cauchy_schwarz`
  - Role: P9 finite noise kernels satisfy covariance Cauchy-Schwarz under
    nonnegative weights.
- `PhysicsSM.Draft.NullEdgeP9PositiveWeightNoiseZero`
  - `weighted_square_sum_eq_zero_iff`
  - `centered_eq_zero_of_self_noise_zero`
  - `noiseInvisible_iff_centered_zero_all_cells`
  - Role: with strictly positive weights, zero noise forces centered-source
    vanishing.
- `PhysicsSM.Draft.NullEdgeP7BlochContractionStrict`
  - `blochContraction_massRatioSq_strict`
  - Role: strict observer-channel contraction strictly increases normalized
    mixedness away from zero Bloch radius.
- `PhysicsSM.Draft.NullEdgeP11MetastableLifetimeMonotone`
  - `lifetimeDenom_antitone_on_unit`
  - `metastableLifetime_monotone_in_r`
  - Role: metastable lifetime increases as the eigenvalue modulus approaches
    one from below.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ResponseCharacterization.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseCauchySchwarz.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PositiveWeightNoiseZero.lean
lake env lean PhysicsSM/Draft/NullEdgeP7BlochContractionStrict.lean
lake env lean PhysicsSM/Draft/NullEdgeP11MetastableLifetimeMonotone.lean
lake build PhysicsSM.Draft.NullEdgeP9ResponseCharacterization
lake build PhysicsSM.Draft.NullEdgeP9NoiseCauchySchwarz
lake build PhysicsSM.Draft.NullEdgeP9PositiveWeightNoiseZero
lake build PhysicsSM.Draft.NullEdgeP7BlochContractionStrict
lake build PhysicsSM.Draft.NullEdgeP11MetastableLifetimeMonotone
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <five new modules>
```

All checks passed. The placeholder scan was clean.

## Literature cadence before next Aristotle submissions

Ran a source pass for the next proposed P9/P2-P4 jobs.

Added:

- `5T5BQ6PT`: Phillips-Hu, *Noise kernel in stochastic gravity and stress
  energy bitensor of quantum fields in curved spacetimes*. Role: P9 source for
  treating the finite noise kernel as the relevant stress-fluctuation guardrail.
- `G7NXEZBU`: Sato-Katori, *Dirac equation with an ultraviolet cutoff and a
  quantum walk*. Role: P2/P4 guardrail for quantum-walk Dirac dynamics.

Neo4j:

- Linked `5T5BQ6PT` to `null-edge-p9-mean-zero-not-noise-invisibility`.
- Linked `G7NXEZBU` to `null-edge-p2p4-null-step-qw-dirac-bridge`.

Constraint reinforced:

- The next P9 jobs should prioritize recovering or proving positivity of the
  finite noise kernel, because stochastic gravity treats noise-kernel response
  as gravitational source data, not harmless bookkeeping.

## Literature cadence after P9 source/residual integrations

Ran a P1 frame-dependence source pass before further integrations.

Confirmed in Zotero:

- `QDUD2CDE`: Peres-Scudo-Terno, *Quantum Entropy and Special Relativity*.
- `Z2MFSJJU`: Gingrich-Adami, *Quantum Entanglement of Moving Bodies*.

Neo4j maintenance:

- Linked both sources to claim
  `null-edge-p1-frame-dependent-spin-entanglement-guardrail`.

Constraint reinforced:

- P1 must separate invariant `det(P) = m^2` from frame-relative normalized
  mixedness/concurrence. Reduced spin or entanglement quantities are not
  Lorentz scalars without an observer/readout convention.

## Integrated P1 normalization plus P9 exact/mean batch

Confirmed and marked integrated six completed jobs already present in the draft
tree.

Draft modules:

- `PhysicsSM.Draft.NullEdgeP1NormalizedDetNonneg`
  - Role: normalized determinant nonnegativity for the frame-audited P1 wrapper.
- `PhysicsSM.Draft.NullEdgeP1NormalizedDetSign`
  - Role: normalized determinant sign guardrail.
- `PhysicsSM.Draft.NullEdgeP1TwoNullUniqueness`
  - Role: uniqueness conditions for the observer-axis two-null split.
- `PhysicsSM.Draft.NullEdgeP9BoundaryExact`
  - `cellPairing_coboundary_eq_boundaryPairing`
  - `boundaryExact_invisible_to_closed_tests`
  - Role: boundary-exact bookkeeping pairs only through the test boundary, so
    closed tests cannot see it.
- `PhysicsSM.Draft.NullEdgeP9MeanFluctuation`
  - `secondMoment_eq_centered_plus_mean_term`
  - `mean_zero_secondMoment_eq_centered`
  - `mean_term_le_secondMoment`
  - Role: residual second moment splits into centered fluctuation plus squared
    mean. The Aristotle project reported `COMPLETE_WITH_ERRORS`, but the
    integrated module elaborates cleanly and passed the repo checks below.
- `PhysicsSM.Draft.NullEdgeP9WeightedAntisymmetricMeanZero`
  - Role: weighted antisymmetric finite source bookkeeping has zero mean.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetNonneg.lean
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedDetSign.lean
lake env lean PhysicsSM/Draft/NullEdgeP1TwoNullUniqueness.lean
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryExact.lean
lake env lean PhysicsSM/Draft/NullEdgeP9MeanFluctuation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedAntisymmetricMeanZero.lean
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <P1/P9 exact-mean modules>
git diff --check -- <P1/P9 exact-mean modules>
```

All checks passed. The placeholder scan was clean.

## Literature cadence after readout / dephasing integrations

Ran a P9-oriented source pass before further integrations.

Search status:

- Used Zotero, Crossref, OpenAlex, and Neo4j exact-key search.
- The relevant everpresent-Lambda and causal-set guardrails were already present
  in the graph, so no new Zotero item was added.

Useful confirmations:

- `K5CFI3HI`: Das-Nasiri-Yazdi, *Aspects of Everpresent Lambda (I)*.
  Role: fluctuating sign-changing cosmological-constant model with
  `1 / sqrt(V)` scaling.
- `IHVSDGUC`: Das-Nasiri-Yazdi, *Aspects of Everpresent Lambda (II)*.
  Role: observational tests and CMB-era amplitude tension.
- `G3FT8BXC`: Sorkin et al., *Is the cosmological constant a nonlocal quantum
  residue of discreteness of the causal set type?*
  Role: original causal-set residue motivation.

Constraint reinforced:

- P9 must prove more than mean-zero bookkeeping. It needs either a finite source
  functional whose noise response is killed by boundary-exact or
  observer-invisible data, or a residual-fluctuation law that avoids importing
  the known CMB-era amplitude tension unchanged.

## Integrated P9 source-visibility / residual guardrail batch

Confirmed and marked integrated six completed P9 jobs already present in the
draft tree.

Draft modules:

- `PhysicsSM.Draft.NullEdgeP9ClosureDefect`
  - Role: finite closure-defect scalar bookkeeping.
- `PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource`
  - `visibleClosureSource_of_nonzero_component`
  - Role: a nonzero closure-defect component sources the toy visible source.
- `PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero`
  - Role: antisymmetric relabeling gives mean-zero source bookkeeping.
- `PhysicsSM.Draft.NullEdgeP9PairedCancellation`
  - Role: paired source contributions cancel in the finite mean.
- `PhysicsSM.Draft.NullEdgeP9PairedPositiveIff`
  - Role: paired quadratic response positivity/equality guardrail.
- `PhysicsSM.Draft.NullEdgeP9MaxWeightResidualBound`
  - Role: residual response is bounded by the maximum weight scale.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ClosureDefect.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ClosureVisibleSource.lean
lake env lean PhysicsSM/Draft/NullEdgeP9AntisymmetricMeanZero.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedCancellation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9PairedPositiveIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP9MaxWeightResidualBound.lean
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <P9 source/residual guardrail modules>
git diff --check -- <P9 source/residual guardrail modules>
```

All checks passed. The placeholder scan was clean.

## Literature cadence after P1 / Pro-spine integrations

Ran a second source pass before further integrations.

Search status:

- Semantic Scholar remained rate-limited, so this pass used Crossref, OpenAlex,
  Zotero, and Neo4j.

Added:

- `M6HR9WD6`: Ruskai, Szarek, Werner,
  *An analysis of completely-positive trace-preserving maps on M2*,
  DOI `10.1016/s0024-3795(01)00547-x`.
  Role: P7 guardrail for the finite observer-channel API. Celestial-qubit
  channels should respect the affine Bloch-ball / complete-positivity
  constraints of qubit CPTP maps, not arbitrary linear maps.

Neo4j:

- Linked `M6HR9WD6` to claim
  `null-edge-p7-qubit-cptp-channel-api`.

## Integrated readout / dephasing / observer-loss batch

Confirmed and marked integrated six completed jobs already present in the draft
tree.

Draft modules:

- `PhysicsSM.Draft.NullEdgeP11ReadoutCore`
  - `det_normalize_eq_det_div_trace_sq`
  - `reconstruct_readout`
  - `normalized_channel_loses_energy_scale`
  - Role: a normalized channel alone loses invariant mass scale; the calibrated
    readout must include the trace/scale.
- `PhysicsSM.Draft.NullEdgeP2DephasingDetMonotone`
  - `chiralDet_le_dephasedDet`
  - Role: dephasing left/right coherence cannot decrease the toy determinant.
- `PhysicsSM.Draft.NullEdgeP2DephasingEqualityIff`
  - `dephasedDet_eq_chiralDet_iff_coherence_zero`
  - `chiralDet_le_dephasedDet_and_eq_iff`
  - Role: determinant equality after dephasing occurs exactly at zero coherence.
- `PhysicsSM.Draft.NullEdgeP2DephasingPurity`
  - Role: purity-side companion for the dephasing interpretation.
- `PhysicsSM.Draft.NullEdgeP7ConstantTestPerturbation`
  - Role: constant-test observer perturbation guardrail.
- `PhysicsSM.Draft.NullEdgeP7ObserverLoss`
  - Role: finite observer-loss bookkeeping for P7/P9.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP11ReadoutCore.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingDetMonotone.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingEqualityIff.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingPurity.lean
lake env lean PhysicsSM/Draft/NullEdgeP7ConstantTestPerturbation.lean
lake env lean PhysicsSM/Draft/NullEdgeP7ObserverLoss.lean
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <readout/dephasing/observer-loss modules>
git diff --check -- <readout/dephasing/observer-loss modules>
```

All checks passed. The placeholder scan was clean.

## Literature cadence after eleventh-wave integration

Ran the required literature/source pass after integrating six more jobs.

Search / source status:

- The local Neo4j semantic script was blocked in this shell by missing
  `NEO4J_URI`, `NEO4J_USERNAME`, and `NEO4J_PASSWORD`.
- Semantic Scholar MCP searches returned HTTP 429 rate-limit responses.
- Used arXiv/OpenAlex fallbacks and exact Zotero/Neo4j key checks instead.

Useful source confirmations:

- `3VBEK82X`: Chin-Lee, *Momentum bispinor, two-qubit entanglement and twistor
  space*. Role: P1 prior-art guardrail for mass/concurrence analogies.
- `RW63ZR9E`: Blume-Kohout, Ng, Poulin, Viola, *The structure of preserved
  information in quantum processes*. Role: P11 stable/noiseless sector prior
  art.
- `KDEECE8M`: Hawkins, Markopoulou, Sahlmann, *Evolution in Quantum Causal
  Histories*. Role: prior art for finite causal quantum process language.
- `BHNTND4W`: Fawzi-Renner, *Quantum conditional mutual information and
  approximate Markov chains*. Role: P7 recoverability guardrail.
- `7V9FV86B`: Jacobson, *Entanglement Equilibrium and the Einstein Equation*.
  Role: P9 gravity guardrail; finite source functionals are not yet Einstein
  dynamics without response, conservation, universality, and limit hypotheses.

Neo4j maintenance:

- Repaired the Jacobson node metadata so `paper_key`, `key`, and `zotero_key`
  all resolve to `7V9FV86B`.

No new papers were added because the Pro critique's cited sources were already
present in Zotero and the graph.

## Integrated Pro-spine theorem batch

Integrated five completed jobs that directly match the 2026-06-23 Pro critique.

New draft modules:

- `PhysicsSM.Draft.NullEdgeP1ObserverConditioned`
  - `observerConditionedDet`
  - `two_sqrt_observerConditionedDet_eq_mass_over_energy`
  - Role: scalar algebra for `2 sqrt(det rho_{p|u}) = m / E_u`.
- `PhysicsSM.Draft.NullEdgeP2ChiralityCoherence`
  - `positiveProjectorLR`
  - `chiralityCoherence`
  - `chiralityCoherence_positiveProjectorLR_eq_mass_over_energy`
  - Role: Higgs/Yukawa mass coupling appears first as left/right chirality
    coherence `m / E`.
- `PhysicsSM.Draft.NullEdgeP2DephasingDeterminant`
  - `chiralDet`
  - `dephasedDet`
  - `dephasedDet_sub_chiralDet_eq_coherenceSq`
  - Role: an explicit dephasing/observer channel turns removed chirality
    coherence into determinant growth.
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation`
  - `Recoverable`
  - `ConstantInvisible`
  - `recoverable_not_imply_constantInvisible`
  - Role: toy guardrail that recoverability alone does not imply source
    invisibility.
- `PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI`
  - `pluckerSourceSq`
  - `VisibleSource`
  - `visibleSource_of_nonzero_pluckerSpread`
  - Role: nonzero Plucker spread gives a nonzero visible scalar source in the
    toy P9 API.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1ObserverConditioned.lean
lake env lean PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean
lake env lean PhysicsSM/Draft/NullEdgeP2DephasingDeterminant.lean
lake env lean PhysicsSM/Draft/NullEdgeP7RecoverabilityInvisibilitySeparation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9VisiblePluckerSourceAPI.lean
lake build PhysicsSM.Draft.NullEdgeP1ObserverConditioned
lake build PhysicsSM.Draft.NullEdgeP2ChiralityCoherence
lake build PhysicsSM.Draft.NullEdgeP2DephasingDeterminant
lake build PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation
lake build PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <five Pro-spine modules>
```

All targeted checks passed. The placeholder scan was clean.

## Integrated P1 frame-audit cluster

Confirmed and marked integrated six completed P1 jobs already present in the
draft tree.

Draft modules:

- `PhysicsSM.Draft.NullEdgeP1SL2Frame`
  - `sl2_congruence_det_invariant`
  - Role: the unnormalized two-spinor determinant is invariant under
    `SL(2,C)` congruence, while normalized celestial mixedness remains
    observer-conditioned.
- `PhysicsSM.Draft.NullEdgeP1ObserverConditioned`
  - already recorded above in the Pro-spine batch.
- `PhysicsSM.Draft.NullEdgeP1CelestialMoment`
  - Role: scalar celestial monopole/dipole mass-moment wrapper.
- `PhysicsSM.Draft.NullEdgeP1RestFrameBloch`
  - Role: rest-frame / maximal normalized mixedness guardrail.
- `PhysicsSM.Draft.NullEdgeP1NormalizedBlochDet`
  - Role: normalized Bloch determinant algebra for the visible celestial qubit.
- `PhysicsSM.Draft.NullEdgeP1MassRatioVelocity`
  - Role: `m^2 / E^2 = 1 - v^2` scalar bridge.
- `PhysicsSM.Draft.NullEdgeP1MassRatioBounds`
  - Role: if `0 <= v^2 <= 1`, then the observer-conditioned mass-ratio square
    lies in `[0,1]`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP1SL2Frame.lean
lake env lean PhysicsSM/Draft/NullEdgeP1MassRatioBounds.lean
lake env lean PhysicsSM/Draft/NullEdgeP1RestFrameBloch.lean
lake env lean PhysicsSM/Draft/NullEdgeP1CelestialMoment.lean
lake env lean PhysicsSM/Draft/NullEdgeP1NormalizedBlochDet.lean
lake env lean PhysicsSM/Draft/NullEdgeP1MassRatioVelocity.lean
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <P1 frame-audit modules>
git diff --check -- <P1 frame-audit modules>
```

All checks passed. The placeholder scan was clean.
