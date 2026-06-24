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

## Literature pass: P9 Hodge/projector guardrails

Semantic Scholar was rate-limited, so this pass used OpenAlex, arXiv, Crossref,
Zotero duplicate checks, and Neo4j linking.

Already present and re-emphasized:

- `DM6NREPA`: Arnold-Falk-Winther finite element exterior calculus.
- `PU8Q5WKT` and `G2JGSV9B`: causal-set Sorkin-Johnston entropy and the
  area-law/volume-law truncation caveat.

Added to Zotero collection `9W59V3K9` and linked in Neo4j:

- `CWXAFIF4`: Hansen-Ghrist, *Toward a spectral theory of cellular sheaves*.
- `TSAQXS9N`: Dodziuk, *Finite-Difference Approach to the Hodge Theory of
  Harmonic Forms*.
- `D7352JCI`: Edelsbrunner-Olsbock, *Tri-partitions and Bases of an Ordered
  Complex*.

Scientific consequence: next P9 jobs should not merely prove abstract
zero-pairing or mean-zero lemmas. They should move toward explicit finite
Hodge projectors, harmonic-basis/projected-source separation, projected noise
positivity/strictness, and condition-number or spectrum diagnostics.

## Submitted P9 harmonic/projector follow-up jobs

Submitted four Aristotle jobs after the P9 Hodge/projector literature pass:

- `a0dadc4c-2ea3-4741-b96b-508a795d1e1b`:
  `null-edge-p9-orthogonal-projector-core-20260623`.
- `6dfa769d-2271-4cbf-aca6-4a05e7827254`:
  `null-edge-p9-strict-projected-kernel-20260623`.
- `e6ef0730-727a-48e9-a5df-5be70830db99`:
  `null-edge-p9-conditioned-response-bound-20260623`.
- `689020dd-79b1-4b50-9971-6d40ac8dd801`:
  no-code `null-edge-p9-explicit-hodge-projector-strategy-20260623`.

All three proof jobs were submitted as focused standalone packages whose target
files typechecked locally with only the intended proof-hole warnings. The
strategy job asks Aristotle to design the explicit finite diamond Hodge
projector and projected source/noise theorem scaffold before we overclaim P9.

## Integrated P9 orthogonal-projector core

Integrated Aristotle project `a0dadc4c-2ea3-4741-b96b-508a795d1e1b` into:

- `PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore`

Theorems:

- `projected_is_harmonicTest`
- `harmonic_pairing_eq_projected_pairing`
- `residual_orthogonal_to_harmonicTest`
- `harmonic_tests_see_only_projected_source`

Scientific role: this proves the clean abstract projector statement that P9 now
needs. For a finite self-adjoint idempotent projector, harmonic tests see only
the projected source and the residual is orthogonal to harmonic tests. This is
still abstract linear algebra; it becomes physically meaningful only when the
projector is supplied by a concrete finite diamond metric/Hodge construction.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
lake build PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9OrthogonalProjectorCore.lean
```

All targeted checks passed; placeholder and non-ASCII scans were clean.

## Received P9 explicit Hodge-projector strategy result

Aristotle project `689020dd-79b1-4b50-9971-6d40ac8dd801` returned a no-code
strategy/audit artifact:

```text
AgentTasks/aristotle-output/689020dd-79b1-4b50-9971-6d40ac8dd801/extracted/project-files.tar/null-edge-p9-explicit-hodge-projector-strategy-20260623_aristotle/P9_STRATEGY.md
```

Key takeaways:

- The current P9 spine is generic finite linear algebra until the projector is
  pinned to a geometry-dependent finite Hodge Laplacian.
- Tier A should define and prove well-posedness of explicit cochain spaces,
  incidence maps, SPD metric blocks, adjoints, self-adjointness, and the
  Laplacian sum-of-squares PSD identity.
- Tier B's keystone is `ker L1 = ker d1 cap ker d0star`; this is the theorem
  that turns the harmonic channel into a real finite Hodge object.
- Tier C then proves exact-source invisibility and projected-noise/rank bounds
  with respect to that concrete projector.
- Tier D is the physics-making target: a fixed finite diamond response
  separation where harmonic rank, trace, spectrum, or response differs between
  explicit incidence-plus-metric choices.

The optional returned `P9Skeleton.lean` is not integrated because it is a design
skeleton with proof holes and was not build-checked. Next proof jobs should be
Tier A, not more abstract projector lemmas.

## Submitted P9 Tier-A weighted Hodge jobs

Submitted two focused Aristotle jobs for the explicit finite Hodge layer:

- `32a7fb73-8801-453d-8f8c-5c794e4dbe30`:
  `null-edge-p9-weighted-adjoint-core-20260623`.
- `23a1472a-e255-48b5-9314-6b13b6286af1`:
  `null-edge-p9-weighted-laplacian-energy-20260623`.

Both target files typechecked locally with only the intended proof-hole
warnings. These jobs move P9 from abstract projector folklore toward an
explicit diagonal-metric Hodge API: weighted adjoints, then a 1-Laplacian
sum-of-squares identity.

## Literature pass: P9 Tier-A finite Hodge guardrails

Used OpenAlex/Crossref after Semantic Scholar rate limits. Added to Zotero
collection `9W59V3K9` and linked in Neo4j:

- `8JFSI9CS`: Arnold-Falk-Winther, *Finite element exterior calculus: from
  Hodge theory to numerical stability*.
- `9RE64BCV`: Ribando-Gros et al., *Combinatorial and Hodge Laplacians:
  Similarities and Differences*.

Scientific consequence: the Tier-A weighted-adjoint and Laplacian-energy jobs
should be read as a metric-compatible finite Hodge scaffold, not as generic
graph Laplacian folklore. The Ribando-Gros et al. guardrail is especially useful:
P9 must state which metric/Hodge operator it uses, because a combinatorial graph
Laplacian does not automatically give the same decomposition or continuum
interpretation.

## Integrated P9 strict projected-kernel and conditioned-response cores

Integrated Aristotle projects:

- `6dfa769d-2271-4cbf-aca6-4a05e7827254` into
  `PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel`.
- `e6ef0730-727a-48e9-a5df-5be70830db99` into
  `PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound`.

New strict/no-hidden-mode theorems:

- `projectedKernel_response_eq_response_projectedTest`
- `projectedKernel_strict_on_nonzero_projectedTest`
- `projectedKernel_response_zero_iff_projectedTest_zero`

New conditioned-response theorems:

- `normSq_nonneg`
- `zero_response_forces_zero_projected_norm`
- `response_ratio_le_beta`
- `alpha_le_response_ratio`
- `response_ratio_between`

Scientific role: these are the finite guardrails requested by the P9 critique.
The projected noise response is no longer merely positive-semidefinite: under a
positive-definite finite kernel, it has no hidden null modes except tests killed
by projection. Separately, a two-sided response bound gives a condition-number
style interval for the response-to-projected-norm ratio.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ConditionedResponseBound.lean
lake build PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel
lake build PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean PhysicsSM/Draft/NullEdgeP9ConditionedResponseBound.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean PhysicsSM/Draft/NullEdgeP9ConditionedResponseBound.lean
```

All targeted checks passed; placeholder and non-ASCII scans were clean.

## Integrated P9 harmonic/source-visibility cluster

Integrated five completed Aristotle jobs that make the P9 source-visibility
conjecture more algebraically concrete.

Draft modules:

- `PhysicsSM.Draft.NullEdgeP9ClosedWitness`
  - `boundarySource_pairing_eq_boundary_potential_pairing`
  - `boundaryExact_invisible_to_closed_tests`
  - `not_invisible_of_closed_witness`
  - `not_boundaryExact_of_closed_witness`
  - Role: a closed bulk test with nonzero pairing certifies visible source
    content and rules out boundary-exact bookkeeping.
- `PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp`
  - Role: closed bulk tests see the residual/visible source component, while
    boundary-exact perturbations vanish against closed tests.
- `PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound`
  - Role: bounded observer tests and small cell weights bound the diagonal
    noise response by `T * eps * ampSqSum`.
- `PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse`
  - Role: a self-adjoint finite projector makes harmonic tests see only the
    projected source; boundary perturbations vanish if the projector
    annihilates boundary sources.
- `PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel`
  - Role: projected noise-kernel response equals the original kernel response
    on the projected test, so positive-semidefinite response is preserved by
    projection.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ClosedWitness.lean
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryVisibleDecomp.lean
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedNoiseBound.lean
lake env lean PhysicsSM/Draft/NullEdgeP9HarmonicProjectorResponse.lean
lake env lean PhysicsSM/Draft/NullEdgeP9ProjectedNoiseKernel.lean
lake build PhysicsSM.Draft.NullEdgeP9ClosedWitness
lake build PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp
lake build PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound
lake build PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse
lake build PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <five P9 harmonic/source modules>
rg -n "[^\x00-\x7F]" <five P9 harmonic/source modules>
```

All targeted checks passed. The placeholder and non-ASCII scans were clean
after replacing Aristotle's Unicode tactic sugar with ASCII proof structure.

## P4 critique and next P9 queue decision

External-model and Spark delegation:

- Gemini 2.5 Pro reviewed the sharpened null-step Dirac universality package.
  Its strongest contribution was to confirm the claim boundary: the invariant
  dynamical mass target is the unnormalized determinant `det(P_vis) = m^2`,
  while `det(rho_vis)` is an observer-conditioned `m / E` readout. It also
  sharpened the prior-art warning around homogeneous quantum walks and QCAs:
  the publishable dynamics target must derive Dirac dispersion and low-energy
  Dirac spinors, not just repeat known walk unitarity.
- Spark/Goodall reviewed the overnight plan and proposed the next non-duplicate
  Aristotle queue. Its highest-value immediate targets were finite P9
  source-visibility statements: a visibility API spine, BF-closure/no-bulk
  divergence, and residual variance / weighted noise suppression.

Decision:

- Keep the three P4 jobs already running.
- Use the remaining Aristotle capacity for three focused P9 jobs, provided the
  statements are narrowed to finite toy algebra rather than broad physics
  slogans.
- Hold the observer-channel invariant stack until the current P4 visible
  determinant job returns.
- Hold the next super-Dirac first-order package until the smaller P4/P9 layers
  stabilize.

Submitted P9 jobs:

- `24bc10a1-69f5-4402-aca1-7d703ea6c0ae`
  `null-edge-p9-closed-witness-20260623`: closed-test nonzero pairing witnesses
  bulk visibility and rules out boundary-exact bookkeeping.
- `3f39ceda-a85a-4c36-bda7-908cf513215d`
  `null-edge-p9-boundary-visible-decomp-20260623`: boundary-exact perturbations
  do not change closed-test source pairings or invisibility.
- `9812606b-fbd9-4207-8833-3fc79a33e1bf`
  `null-edge-p9-weighted-noise-bound-20260623`: bounded observer tests plus
  max-weight cell suppression imply a combined weighted noise-response bound.

Literature/graph pass:

- Local `neo4j_doc_search.py` was unavailable in the base shell because the
  `neo4j` Python package is installed only in the tool environment, so this
  pass used the Neo4j MCP and OpenAlex/Crossref-style scholarly search.
- Existing graph support already includes everpresent-Lambda papers and
  stochastic-gravity/noise-kernel guardrails.
- Added Zotero item `4KXZ8IJE`: Martin-Verdaguer, *Stochastic semiclassical
  gravity*, Phys. Rev. D 60 (1999), DOI `10.1103/physrevd.60.084008`.
- Linked `4KXZ8IJE` in Neo4j to the null-edge claim "P9 mean-zero source is not
  noise invisibility" as a response-law/noise-kernel guardrail.
- Updated `Sources/Null_Edge_Key_Conjectures.md` and
  `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` to cite `4KXZ8IJE`.

Claude critique:

- Claude Sonnet 4.6 gave a useful adversarial read on P9. The main warning was
  that boundary-exact invisibility and zero-mean residual lemmas are generic
  finite algebra unless the next layer uses causal-diamond-specific structure.
- Useful promoted targets: explicit finite Hodge/harmonic projector, rank/nullity
  or Betti-number separation, harmonic-noise positive-definiteness, condition
  number under refinement, and flat-vs-de-Sitter finite diamond pilots.
- Less useful output: a continuation drifted into observational foreground and
  dark-energy Fisher-matrix issues, which are premature before the finite
  response law exists.
- Updated `Sources/Null_Edge_Key_Conjectures.md` and
  `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` with the harmonic
  projector and numerical-pilot gates.

## Integrated P4 fixed-point/no-go results

Integrated three completed Aristotle jobs:

- `5b9efeba-acde-470a-9b66-812acb8f488e` ->
  `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant`
  - `visibleBoost_det_invariant`
  - `traceNormalize_det_eq_det_div_trace_sq`
  - `traceNormalize_det_eq_det_inv_trace_sq`
  - Role: the unnormalized visible determinant is invariant under
    determinant-one visible congruence, while trace-normalized determinant
    formulas explicitly encode the observer-conditioned readout.
- `a3346e59-dd7a-4760-a761-31a048aa19a6` ->
  `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass`
  - `no_2x2_anticommutant_of_all_pauli`
  - `mass_term_forces_LR_doubling`
  - Role: a single Weyl `2 x 2` Pauli space cannot host an invertible mass
    matrix anticommuting with all Pauli matrices; the Dirac mass term forces
    a doubled `L plus R` space.
- `b6f7bbc8-2376-461d-98aa-253cda38ed21` ->
  `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy`
  - `isotropicFlip_iff_scalar`
  - `scalarFlip_commutes_all`
  - Role: Pauli isotropy forces the flip generator to have no vector part;
    the scalar flip commutes with all Pauli directions, while vector flip
    components are anisotropic couplings rather than mass.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP4VisibleDetInvariant.lean
lake env lean PhysicsSM/Draft/NullEdgeP4PauliNo2x2Mass.lean
lake build PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant
lake build PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass
lake env lean PhysicsSM/Draft/NullEdgeP4ScalarFlipIsotropy.lean
lake build PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP4VisibleDetInvariant.lean PhysicsSM/Draft/NullEdgeP4PauliNo2x2Mass.lean PhysicsSM/Draft/NullEdgeP4ScalarFlipIsotropy.lean
```

All checks passed. The first `PhysicsSMDraft.lean` check was run in parallel
with targeted builds and failed because the new `.olean` did not exist yet;
rerunning after the targeted builds passed.

## Submitted P9 projector/noise jobs

Motivation: the Claude adversarial critique was right that P9 needs an explicit
projector/noise layer to avoid becoming generic boundary-exact vocabulary.

Submitted:

- `dcaa53fb-7c55-441f-b56b-ded744d7e6ed`
  `null-edge-p9-harmonic-projector-response-20260623`: harmonic tests see only
  the projected source, and boundary-exact perturbations vanish when the
  projector annihilates boundary sources.
- `914a99b2-b1b7-4721-9cf0-c7f50558bd39`
  `null-edge-p9-projected-noise-kernel-20260623`: projected-kernel response is
  the original response on projected tests, so positive kernels remain positive
  after projection.

## Submitted P9 harmonic pilot strategy job

- `de152449-2632-4a5f-b1dc-e0f22d5a07a6`
  `null-edge-p9-harmonic-pilot-strategy-20260623`: no-code Aristotle audit of
  the finite `DiamondSourceVisibility` / harmonic-projector API, theorem
  targets, numerical pilot specification, demotion criteria, and literature
  guardrails. This fills a lane with strategy rather than another duplicate
  proof job, matching the run requirement to intersperse proof work with
  critique/grand-strategy work.

Spark/Newton numerical-pilot plan:

- Smallest feasible script: `Scripts/p9/pilot.py` plus
  `Scripts/p9/p9_schema.json`.
- Quantities: finite chain maps `D0`, `D1`, metric blocks, Hodge-style
  projector `Pi_H`, Betti number by SVD rank, projected noise spectrum/trace/
  condition number, boundary perturbation regression, and Pluecker/closure
  source witnesses.
- Positive signal: boundary perturbations are invisible up to tolerance,
  harmonic trace has a stable coarse-grained or renormalized large-scale
  statistic, projected kernel stays positive on the visible harmonic sector, and
  witnesses agree with source pairing.
- Demotion signal: boundary regression failure, volume-scaling harmonic trace
  after the stated coarse-graining, no stable large-scale readout despite
  refinement or renormalization, projected-kernel PSD failure, or witness false
  positives/negatives.

## Implemented first P9 numerical pilot scaffold

Added:

- `Scripts/p9/pilot.py`
- `Scripts/p9/p9_schema.json`

The script builds small finite chain segments, computes the 1-cochain Hodge
projector from `D0`, `D1`, computes Betti number by SVD ranks, projects a
finite residual noise kernel, reports projected-noise eigenvalues/trace/
condition number, and runs boundary-exact perturbation regression for closed
tests.

Smoke runs:

```text
python Scripts/p9/pilot.py --geometry cycle4 --out AgentTasks/p9-pilot-cycle4-2026-06-23.json
python Scripts/p9/pilot.py --geometry filled_triangle --out AgentTasks/p9-pilot-filled-triangle-2026-06-23.json
python Scripts/p9/pilot.py --geometry two_triangle_disk --out AgentTasks/p9-pilot-two-triangle-disk-2026-06-23.json
```

Initial sanity results:

- `cycle4`: `betti1 = 1`, `harm_dim = 1`, projected-noise trace approximately
  `1`, condition number `1`, boundary regression at floating-point tolerance.
- `filled_triangle` and `two_triangle_disk`: `betti1 = 0`, `harm_dim = 0`,
  projected-noise trace `0`, boundary regression at floating-point tolerance.

Interpretation: this is a working finite diagnostic harness for the P9
harmonic-projector gate. It is not yet evidence for cosmological-constant
leverage; that requires a size sweep and geometry-sensitive causal-diamond
family.

## Updated P9 numerical pilot with metric-profile hook

Extended `Scripts/p9/pilot.py` with diagonal edge metric weights:

- `--metric-profile flat` keeps the original identity metric.
- `--metric-profile expanded --expansion-rate 0.35` applies a normalized
  exponential edge-midpoint-time weight as a toy expanded metric profile.

Important convention fix: for a weighted, non-Euclidean projector, the projected
covariance/noise kernel must use `P K P^T`, not `P K P`; otherwise the expanded
toy can spuriously lose positive-semidefiniteness.

New smoke runs:

```text
python Scripts/p9/pilot.py --geometry cycle4 --metric-profile flat --out AgentTasks/p9-pilot-cycle4-flat-2026-06-23.json
python Scripts/p9/pilot.py --geometry cycle4 --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-cycle4-expanded-2026-06-23.json
python Scripts/p9/pilot.py --geometry filled_triangle --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-filled-triangle-expanded-2026-06-23.json
python Scripts/p9/pilot.py --geometry two_triangle_disk --metric-profile flat --out AgentTasks/p9-pilot-two-triangle-disk-flat-2026-06-23.json
python Scripts/p9/pilot.py --geometry two_triangle_disk --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-two-triangle-disk-expanded-2026-06-23.json
```

Results:

- `cycle4` flat: harmonic dimension `1`, projected-noise trace `1.0`,
  projected PSD check passes.
- `cycle4` expanded: harmonic dimension `1`, projected-noise trace about
  `1.1131485`, shifted Laplacian spectrum, projected PSD check passes.
- filled examples: harmonic dimension `0`, projected-noise trace `0`, projected
  PSD check passes.

Interpretation: the pilot can now detect metric sensitivity without changing
the combinatorics, but this is still a toy edge-weight profile. The next
scientific step is to replace it with a recorded SJ/correlation or
causal-diamond metric and run a size/refinement sweep.

Added a parameterized `--geometry cycle --cycle-size N` hook and ran a first toy
expanded-metric size sweep:

```text
python Scripts/p9/pilot.py --geometry cycle --cycle-size 4 --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-cycle-n4-expanded-2026-06-23.json
python Scripts/p9/pilot.py --geometry cycle --cycle-size 6 --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-cycle-n6-expanded-2026-06-23.json
python Scripts/p9/pilot.py --geometry cycle --cycle-size 8 --metric-profile expanded --expansion-rate 0.35 --out AgentTasks/p9-pilot-cycle-n8-expanded-2026-06-23.json
```

Toy sweep result:

- `N=4`: harmonic dimension `1`, projected trace about `1.0300`, PSD and
  boundary-regression checks pass.
- `N=6`: harmonic dimension `1`, projected trace about `1.0358`, PSD and
  boundary-regression checks pass.
- `N=8`: harmonic dimension `1`, projected trace about `1.0379`, PSD and
  boundary-regression checks pass.

This is a harness sanity check only: it shows the metric-weighted projector can
register a stable nontrivial response on a one-cycle family, not that P9 has a
cosmological-constant mechanism.

## Meta-analysis: P4 null-step Dirac universality feedback

Integrated the user-supplied null-step Dirac universality development note into
the active roadmap.

Main sharpenings:

- P4 should be split into a near-term homogeneous null-step quantum-walk
  fixed-point package and a harder causal-set spinor-propagator frontier.
- The finite homogeneous package should prove the forced `L plus R` doubling,
  scalar off-diagonal flip as mass, small-momentum Dirac dispersion, and the
  invariant bridge `det(P_vis)=m^2`.
- Normalized `det(rho_vis)` belongs only to the frame-relative `m/E` readout.
- An `l=1` flip component is a Lorentz-violating vector/axial coupling unless
  removed by isotropy; the `l=1` sector remains a direction-autocorrelation and
  dipole-deficit diagnostic, not the primitive mass term.
- The static/dynamical bridge should first be tested in decohered or Markov
  channel limits before being claimed for coherent unitary walks.

Docs updated:

- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`

Next useful Aristotle targets:

```text
no_2x2_anticommutant_of_all_pauli
mass_term_forces_LR_doubling
isotropicFlip_iff_scalar
flipGenerator_scalarPart_eq_diracMass
flipGenerator_l1_vectorPart_breaks_isotropy
walkVisibleMomentum_det_eq_massSq
walkVisibleMomentum_det_sl2_invariant
walkNormalizedCoin_det_eq_massRatioSq
```

## Integrated Aristotle tranche: P11/QW/P7/P9 finite lemmas

Integrated six completed focused Aristotle jobs as draft modules:

- `PhysicsSM.Draft.NullEdgeP11LifetimeThreshold`
  - `lifetime_gt_threshold_of_exp_bound`
  - Role: finite logarithmic threshold condition for the P11 long-lived-sector
    story.
- `PhysicsSM.Draft.NullEdgeQWNormPreservation`
  - `Rz_preserves_normSq`
  - `Rx_preserves_normSq`
  - `Ua_preserves_normSq`
  - Role: concrete norm preservation for the null-step quantum-walk gates.
- `PhysicsSM.Draft.NullEdgeP7BlochContractionPurity`
  - `blochContraction_purity_antitone`
  - `blochContraction_purity_strict`
  - Role: observer-channel Bloch contraction decreases purity.
- `PhysicsSM.Draft.NullEdgeP9DeltaPairTestBasis`
  - `noiseResponse_deltaTest_eq_noiseKernel_self`
  - `noiseResponse_pairTest_eq_diag_diag_cross`
  - `noiseInvisible_of_delta_pair_tests_zero`
  - Role: finite delta/pair tests detect entries of a symmetric noise kernel.
- `PhysicsSM.Draft.NullEdgeP9NoiseBilinearCauchy`
  - `noiseBilinear_cauchy_schwarz`
  - Role: positive-semidefinite bilinear control for finite P9 noise response.
- `PhysicsSM.Draft.NullEdgeP9NoiseResponseAmplitudeZero`
  - `noiseResponse_eq_weighted_square_sum`
  - `noiseResponse_eq_zero_iff_testAmplitude_zero`
  - Role: under positive weights, zero response is equivalent to vanishing
    centered test amplitudes.

Integration notes:

- The `integrate_completed.py` helper successfully fetched five outputs but
  did not discover candidates because focused-package targets are named
  `Core.lean`; one output hit a Windows extraction path issue after the target
  file had already extracted. Exact target files were inspected and copied into
  draft modules.
- Namespaces were adjusted to `PhysicsSM.Draft.*`, and `PhysicsSMDraft.lean`
  imports were added.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP11LifetimeThreshold.lean
lake env lean PhysicsSM/Draft/NullEdgeQWNormPreservation.lean
lake env lean PhysicsSM/Draft/NullEdgeP7BlochContractionPurity.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DeltaPairTestBasis.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseBilinearCauchy.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoiseResponseAmplitudeZero.lean
lake build PhysicsSM.Draft.NullEdgeP11LifetimeThreshold
lake build PhysicsSM.Draft.NullEdgeQWNormPreservation
lake build PhysicsSM.Draft.NullEdgeP7BlochContractionPurity
lake build PhysicsSM.Draft.NullEdgeP9DeltaPairTestBasis
lake build PhysicsSM.Draft.NullEdgeP9NoiseBilinearCauchy
lake build PhysicsSM.Draft.NullEdgeP9NoiseResponseAmplitudeZero
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <six new modules>
```

All targeted checks passed. The placeholder scan was clean.

## Literature cadence: P4 null-step/QCA frontier

Ran a P4 literature pass after integrating the six-job tranche. Semantic
Scholar was rate-limited, so the search used arXiv/OpenAlex/Crossref and exact
Zotero/Neo4j duplicate checks.

Added to Zotero and linked in Neo4j to
`null-edge-p2p4-null-step-qw-dirac-bridge`:

- `964TN6X7`: Terry Farrelly, *A review of Quantum Cellular Automata*,
  Quantum 4, 368 (2020), DOI `10.22331/q-2020-11-30-368`.
  Role: broad QCA prior-art guardrail for locality, bounded-speed unitary
  dynamics, continuum limits, and classification context.
- `VIAIBSRI`: Nathanael Eon, Giuseppe Di Molfetta, Giuseppe Magnifico, Pablo
  Arrighi, *A relativistic discrete spacetime formulation of 3+1 QED*,
  Quantum 7, 1179 (2023), DOI `10.22331/q-2023-11-08-1179`.
  Role: high-relevance P4 source because it uses lightlike circuit wires,
  starts from the Dirac quantum walk, and extends to gauge-invariant
  multi-particle QED dynamics.

Search result:

- The causal-set spinor-propagator frontier remains less sourced in the local
  library. ArXiv/OpenAlex searches for "causal set Dirac/fermion propagator"
  did not reveal a clean Johnston-style spinor extension, which supports
  keeping that target as a hard frontier rather than a near-term theorem claim.

## Submitted P4 finite theorem batch

Submitted three focused Aristotle jobs from the sharpened null-step Dirac
universality feedback:

- `a3346e59-dd7a-4760-a761-31a048aa19a6`:
  `null-edge-p4-pauli-no-2x2-mass-20260623`.
  Targets: `no_2x2_anticommutant_of_all_pauli`,
  `mass_term_forces_LR_doubling`.
- `b6f7bbc8-2376-461d-98aa-253cda38ed21`:
  `null-edge-p4-scalar-flip-isotropy-20260623`.
  Targets: `isotropicFlip_iff_scalar`, `scalarFlip_commutes_all`.
- `5b9efeba-acde-470a-9b66-812acb8f488e`:
  `null-edge-p4-visible-det-invariant-20260623`.
  Targets: `visibleBoost_det_invariant`,
  `traceNormalize_det_eq_det_div_trace_sq`,
  `traceNormalize_det_eq_det_inv_trace_sq`.

These are intentionally Tier-A finite packages: no causal-set propagator or
full scaling-limit claim is being asked of Aristotle in this batch.

## Meta-analysis and P9 refocus: Hodge/conservation feedback

New user-supplied Claude feedback sharpened P9 in a useful way. The productive
pattern in the overnight run has been finite toy theorems plus explicit
guardrails; the risk is accumulating many scalar lemmas without a single
geometric object. The Hodge/conservation framing gives the next geometric
object:

```text
diamond bookkeeping cochain
SJ-style finite metric / adjoint
exact sector       -> boundary/gauge invisibility
defect sector      -> visible matter/closure source
harmonic sector    -> candidate Lambda-channel
harmonic covariance -> stochastic noise kernel
```

Refocus decision: stop prioritizing additional mean-zero scalar variants unless
they feed this Hodge package. P9 should now prioritize:

- a finite `DiamondHodgeMetric` / codifferential scaffold;
- exact/coexact/harmonic projection definitions;
- theorem targets for exact-sector invisibility and defect-sector visibility;
- numerical Betti-scaling and harmonic-noise-trace pilots;
- a response-law strategy before claiming cosmological-constant amplitude
  leverage.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

## Integrated P9 block-aliasing guardrail

Integrated Aristotle project:

- `ec32c1bf-13b1-43f8-a749-9455d7c15265`
  `null-edge-p9-block-aliasing-guardrail-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail`

Theorems:

- `blockAverageCoarseTrace4_eq_average_sq`
- `blockAverage4_eq_zero_of_sum_zero`
- `blockAverageCoarseTrace4_eq_zero_of_sum_zero`
- `blockAverageCoarseTrace4_nonneg`

Scientific role: this is the finite artifact guardrail extracted from the P9
offset sweep. A size-4 block-average coarse map annihilates a rank-one mode
with zero within-block sum, and the rank-one coarse trace is nonnegative as a
square. Thus a zero coarse trace can be pure block alignment, not physical
source invisibility.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
lake build PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9BlockAliasingGuardrail.lean
```

All targeted checks passed. The first `PhysicsSMDraft.lean` check raced the
targeted build and failed before the `.olean` existed; rerunning after the
targeted build passed.

## Integrated P9 retarded Green-series scaffold

Integrated Aristotle project:

- `5f79548b-1c36-473a-8780-7ef254b090c8`
  `null-edge-p9-retarded-green-series-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries`

Theorems:

- `applyKernel_vecSum_range`
- `applyKernel_iterateApply`
- `oneMinusK_retardedSeries_eq_of_nilpotent`
- `retardedSeries_is_right_inverse_on_nilpotent_vector`

Scientific role: this is the finite response-law scaffold for P9. Under
nilpotence on a vector, the finite retarded/Neumann series terminates and
solves `(I - K) y = x` exactly. This is deliberately discrete-first: it gives a
finite replacement for a formal Green function without assuming pointwise
continuum behavior.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
lake build PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RetardedGreenSeries.lean
```

All targeted checks passed. Aristotle reported no statement or definition
changes, no remaining proof holes, and no added assumptions or nonstandard
constructs.

## P9 matched flat-vs-deformed ensemble pilot

Added script:

- `Scripts/p9/pilot_ensemble.py`

Generated aggregate output:

- `AgentTasks/p9-pilot-matched-diamond-ensemble-2026-06-23.json`

The wrapper reuses `Scripts/p9/pilot.py` and runs matched flat-diamond versus
deformed/de-Sitter-style diamond families across sizes `3..8` and seeds `0..9`.
It reports projected-noise trace density, coarse block trace densities,
within-family seed spread, flat-vs-deformed separation, and a simple
`10 * spread` threshold with an absolute tolerance fallback.

Scientific result:

- boundary perturbation regressions passed for all runs;
- projected PSD checks passed for all runs;
- the main fine projected-noise trace-density signal did not meet the `10x`
  spread threshold for sizes `4..8` (ratios were about `2.3..4.1`);
- the coarse block-size `4` statistic did pass the threshold for sizes `4..8`,
  but this is plausibly a coarse-map alignment artifact and should be treated
  as a guardrail target, not as a cosmological signal.

Interpretation: the pilot is now discriminating enough to demote easy
overclaims. P9 still has a live finite route, but the publishable numerical
claim should be phrased as a controlled readout program: fixed coarse map,
seed/error bars, boundary-invariance check, and separation thresholds before
any cosmological-constant language.

Verification:

```text
python -m py_compile Scripts/p9/pilot_ensemble.py
python Scripts/p9/pilot_ensemble.py --sizes 3,4,5,6,7,8 --seeds 0,1,2,3,4,5,6,7,8,9 --out AgentTasks/p9-pilot-matched-diamond-ensemble-2026-06-23.json
```

## Submitted P9 selected-sector trace-density proof job

Submitted focused Aristotle job:

- `28e0de6b-bf59-4e3e-ac0c-4c1a92669e3c`
  `null-edge-p9-selected-sector-trace-density-20260623`
  (`task_id: 4aa6de33-bd9c-407f-9395-9e16092a067c`)

Target:

```lean
selectedProjector_basis_diag_mem
selectedProjector_basis_diag_not_mem
selectedProjector_trace_eq_count
selectedProjector_trace_density_eq_count_div
selectedProjector_trace_density_le_boundary_div
```

Scientific role: this formalizes the finite area-vs-volume trace-density
scaffold. A Boolean-selected observer sector with `k` visible modes in an
`n`-cell space has coordinate trace `k` and trace density `k/n`; if geometry
later bounds `k` by a boundary-size count, the density has the corresponding
finite boundary-over-volume bound.

Pre-submit verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-selected-sector-trace-density-20260623-project/NullEdgeP9SelectedSectorTraceDensity/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-selected-sector-trace-density-20260623/NullEdgeP9SelectedSectorTraceDensity/Core.lean AgentTasks/null-edge-p9-selected-sector-trace-density-aristotle-2026-06-23.md
```

The Lean preflight found exactly five intended proof-hole warnings and no other
errors. Non-ASCII scan was clean. Aristotle accepted the submission and reported
the task as queued/running.

## Integrated P9 selected-sector trace-density scaffold

Integrated Aristotle project:

- `28e0de6b-bf59-4e3e-ac0c-4c1a92669e3c`
  `null-edge-p9-selected-sector-trace-density-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity`

Theorems:

- `selectedProjector_basis_diag_mem`
- `selectedProjector_basis_diag_not_mem`
- `selectedProjector_trace_eq_count`
- `selectedProjector_trace_density_eq_count_div`
- `selectedProjector_trace_density_le_boundary_div`

Scientific role: this banks the finite area-vs-volume trace-density scaffold.
A Boolean-selected observer sector with `k` selected modes in an `n`-cell
readout has trace density `k/n`; a later geometry theorem can turn a
boundary-size bound on `k` into a boundary-over-volume readout bound.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
lake build PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9SelectedSectorTraceDensity.lean
```

All targeted checks passed. Aristotle reported no statement or definition
changes, no remaining proof holes, and no added assumptions or nonstandard
constructs. The integration helper hit an archive-extraction issue on the
task-note path, so the returned target file was diffed manually and integrated
with ASCII Lean syntax.

## P9 block-offset aliasing critique and sweep

Gemini reviewed the matched-ensemble pilot and flagged the block-size `4`
separation as likely aliasing: the offset-0 block grid appears to annihilate
flat harmonic fluctuations by alignment, while the deformed metric breaks that
alignment.

Implemented offset-aware coarse projections in:

- `Scripts/p9/pilot.py`
- `Scripts/p9/pilot_ensemble.py`
- `Scripts/p9/p9_schema.json`

Generated:

- `AgentTasks/p9-pilot-matched-diamond-offset-sweep-2026-06-23.json`
- `AgentTasks/p9-pilot-compat-flat-diamond-n4-flat-offset0-2026-06-23.json`

Observed result:

- boundary perturbation regressions still pass;
- projected PSD checks still pass;
- offset `0` reproduces the dramatic flat block-4 near-zero statistic;
- offset `1` makes the flat block-4 trace density about `0.17..0.18`;
- offset `3` makes the flat block-4 trace density about `0.29..0.30`;
- offset `2` gives both flat and deformed trace densities near `0.50`, and the
  flat-vs-deformed separation fails the `10x` threshold.

Scientific consequence: the block-size `4` result should be treated as an
aliasing guardrail, not as a positive geometry signal. P9 needs either an
offset-invariant statistic or an intrinsic coarse map, such as a causal
Alexandrov/block construction, before coarse trace separation can be advertised.

Verification:

```text
python -m py_compile Scripts/p9/pilot.py Scripts/p9/pilot_ensemble.py
python Scripts/p9/pilot.py --geometry flat_diamond --cycle-size 4 --metric-profile flat --coarse-block-sizes 1,2,4 --out AgentTasks/p9-pilot-compat-flat-diamond-n4-flat-offset0-2026-06-23.json
python Scripts/p9/pilot_ensemble.py --sizes 4,5,6,7,8 --seeds 0,1,2,3,4,5,6,7,8,9 --coarse-block-sizes 4 --coarse-offsets 0,1,2,3 --out AgentTasks/p9-pilot-matched-diamond-offset-sweep-2026-06-23.json
```

## Integrated P9 causal support bound

Integrated Aristotle project:

- `1dc86a62-8505-45d2-80b5-cffbb4a6b82c`
  `null-edge-p9-causal-support-bound-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9CausalSupportBound`

Theorems:

- `applyKernel_vanishes_off_reach`
- `response_zero_of_causally_separated_supports`
- `response_eq_zero_of_target_outside_reach`

Scientific role: this is the first finite causal-support guardrail added after
the C4/Hodge spine. A response kernel supported inside a chosen causal relation
cannot propagate a localized source outside that source's discrete causal
reach, and causally separated source/target supports have zero response. This
does not solve P9's cosmological response-law problem, but it prevents the
source-response layer from being merely arbitrary matrix algebra.

Verification:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md 1dc86a62-8505-45d2-80b5-cffbb4a6b82c
lake env lean PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CausalSupportBound.lean
lake build PhysicsSM.Draft.NullEdgeP9CausalSupportBound
lake env lean PhysicsSMDraft.lean
```

All targeted checks passed. The first draft-root import check raced the
targeted build before the new `.olean` existed; rerunning after the targeted
build passed.

## Literature pass: causal-set retarded/nonlocal response guardrail

Spark literature triage identified a missing source anchor for the P9
causal-support and response-law lane.

New source added to Zotero collection `9W59V3K9`:

- `DQ9CF6I2`: Siavash Aslanbeigi, Mehdi Saravani, and Rafael D. Sorkin,
  "Generalized Causal Set d'Alembertians," arXiv `1403.1622`.

Neo4j link added:

- `DQ9CF6I2` supports claim
  `P9_retarded_nonlocal_causal_response_guardrail`.

Scientific consequence: P9 kernels should be compared against causal-set
retarded/nonlocal d'Alembertian operators, including infrared recovery
conditions and stability caveats. The finite support theorem is a guardrail,
not a replacement for a stable large-scale response operator.

Additional source added after the first pass:

- `I72KXVQA`: Marian Boguna and Dmitri Krioukov, "Local d'Alembertian for causal
  sets," arXiv `2506.18745`.

Neo4j link added:

- `I72KXVQA` supports claim
  `P9_edge_neighbor_local_dalembertian_guardrail`.

Scientific consequence: the `edgeNeighbor_N` lane should be judged against both
nonlocal retarded causal-set operators and newer claims that local causal-set
d'Alembertian operators can converge using intrinsic causal-set distance data.
This strengthens the case for testing finite effective locality instead of
assuming microscopic bounded point valency.

## Submitted P9 edge-neighbor reach job

Submitted Aristotle project:

- `af7b61f3-c743-428a-b989-f30239f3fc03`
  `null-edge-p9-edge-neighbor-reach-20260623`

Task:

- `d88f469d-1a0a-4efb-bed7-b8a5601be0ee`

Staged source:

- `AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean`

Task note:

- `AgentTasks/null-edge-p9-edge-neighbor-reach-aristotle-2026-06-23.md`

Targets:

- `edgeNeighborN_subrelation`
- `edgeNeighborN_induced_of_original`
- `kernelSupported_edgeNeighborN_to_rel`
- `iterateApply_supported_in_exact_reach`
- `responseAtStep_zero_of_target_outside_exact_reach`

Scientific role: this job attacks the next P9 locality layer after the causal
support theorem. It formalizes `edgeNeighbor_N` as effective link locality, not
a fundamental bounded-valency assumption, and asks Aristotle to prove that
iterated finite response kernels cannot escape bounded step reach.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
```

The Lean preflight found exactly the five intended proof-hole warnings and no
other errors; non-ASCII scan was clean. The focused package helper reported
five proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach`

Verification:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-edge-neighbor-reach-aristotle-2026-06-23.md af7b61f3-c743-428a-b989-f30239f3fc03
lake env lean PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
lake build PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach
lake env lean PhysicsSMDraft.lean
```

All targeted checks passed. The first draft-root import check raced the
targeted build before the new `.olean` existed; rerunning after the targeted
build passed.

## Submitted P9 retarded nilpotent reach job

Submitted Aristotle project:

- `dd4fb31d-a4d4-4d1e-a565-510c57aafe3a`
  `null-edge-p9-retarded-nilpotent-reach-20260623`

Task:

- `a24c6395-edc0-44dc-bd1e-71a8a9b95213`

Staged source:

- `AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean`

Task note:

- `AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md`

Targets:

- `applyKernel_vanishes_off_reach`
- `iterateApply_supported_in_exact_reach`
- `no_reach_beyond_rank`
- `iterateApply_eq_zero_beyond_rank`

Scientific role: this job turns the causal-set retarded/nonlocal response
literature into a finite theorem target. If a support relation strictly
decreases a rank on a finite diamond, exact reach is empty beyond the rank
height and iterated response kernels vanish. This would give P9 a clean finite
retarded-horizon theorem, independent of any fine-grained continuum limit.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors; non-ASCII scan was clean. The focused package helper reported
four proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach`

Verification:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md dd4fb31d-a4d4-4d1e-a565-510c57aafe3a
lake env lean PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
lake build PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach
lake env lean PhysicsSMDraft.lean
```

All targeted checks passed. The first draft-root import check raced the
targeted build before the new `.olean` existed; rerunning after the targeted
build passed.

## Banked explicit P9 Ward/conservation theorem name

Spark/Boyle suggested submitting
`eventConservation_kills_defect_source` as the next finite Ward target. Main
thread review found the theorem was already proved under the older name
`PhysicsSM.Draft.NullEdgeP9BoundarySource.boundaryExact_source_eq_zero` and
also packaged as
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore.boundaryExact_invisible_to_closed_tests`.

Added a discoverability alias:

- `PhysicsSM.Draft.NullEdgeP9BoundarySource.eventConservation_kills_defect_source`

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
lake build PhysicsSM.Draft.NullEdgeP9BoundarySource
lake env lean PhysicsSMDraft.lean
```

All targeted checks passed. Scientific role: this makes the finite Ward seed
discoverable under the plan's own theorem name and avoids duplicate Aristotle
work. The open P9 work is now the geometry-dependent source functional,
metric/codifferential convention, response law, and scaling/stability pilot.

## Submitted P9 finite retarded Green series job

Submitted Aristotle project:

- `5f79548b-1c36-473a-8780-7ef254b090c8`
  `null-edge-p9-retarded-green-series-20260623`

Task:

- `8c0c3b2b-2a54-49be-bcba-3614fabcb9ee`

Staged source:

- `AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean`

Task note:

- `AgentTasks/null-edge-p9-retarded-green-series-aristotle-2026-06-23.md`

Targets:

- `applyKernel_vecSum_range`
- `applyKernel_iterateApply`
- `oneMinusK_retardedSeries_eq_of_nilpotent`
- `retardedSeries_is_right_inverse_on_nilpotent_vector`

Scientific role: this is the first finite P9 response-law scaffold after the
support/horizon lemmas. Under a nilpotence assumption `K^H x = 0`, the finite
retarded series `sum_{m < H} K^m x` should solve `(I - K)Gx = x`. If proved,
this gives the acyclic-retarded branch a terminating Green operator rather than
only a support theorem.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-green-series-20260623/NullEdgeP9RetardedGreenSeries/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors; non-ASCII scan was clean. The focused package helper reported
four proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

## Literature pass: finite Hodge/DEC stability guardrails

Cadence reason: this slice integrated or submitted five P9/C4 Aristotle jobs,
so it triggered the overnight plan's literature-search floor.

Semantic Scholar remained rate-limited. The pass used Zotero, Neo4j, OpenAlex,
Crossref, and a targeted web search. Existing active anchors were confirmed:

- `DM6NREPA`: Arnold-Falk-Winther, "Finite element exterior calculus,
  homological techniques, and applications" (2006).
- `8JFSI9CS`: Arnold-Falk-Winther, "Finite element exterior calculus: from
  Hodge theory to numerical stability" (2010).

New source added to Zotero collection `9W59V3K9`:

- `WB8WBSBX`: Zhu-Christiansen-Hu-Hirani, "Convergence and Stability of
  Discrete Exterior Calculus for the Hodge Laplace Problem in Two Dimensions",
  arXiv `2505.08966`.

Neo4j link added:

- `WB8WBSBX` supports claim `P9_discrete_hodge_stability_guardrail`.

Scientific consequence: the Hodge-projector route should cite FEEC/DEC as
prior art for finite complexes, bounded/stable projection, and geometric
conditions. The null-edge novelty should be the source/noise observer-channel
readout and its geometry-moving coarse statistic, not generic finite Hodge
decomposition.

## Submitted P9 causal-support bound

Submitted Aristotle project:

- `1dc86a62-8505-45d2-80b5-cffbb4a6b82c`
  `null-edge-p9-causal-support-bound-20260623`

Task:

- `54127700-6d2b-4e9f-a187-3c582b93b070`

Target:

- `AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean`

Scientific role: Gemini's adversarial critique correctly flagged that the P9
C4 package is still generic finite linear algebra unless it knows about causal
support or geometry movement. This job isolates the smallest finite causal
guardrail: a response kernel supported inside a causal relation cannot send a
localized source outside that source's discrete causal reach, and causally
separated source/target supports have zero response.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-causal-support-bound-20260623/NullEdgeP9CausalSupportBound/Core.lean AgentTasks/null-edge-p9-causal-support-bound-aristotle-2026-06-23.md
```

The Lean preflight found exactly three intended proof holes; non-ASCII scan was
clean.

## P9 geometry-moving pilot check

Spark/Aquinas inspected `Scripts/p9/*` and reported a bounded pilot state with
flat/de Sitter-like diamond families and coarse projection diagnostics. Main
thread ran:

```text
python Scripts/p9/pilot.py --geometry flat_diamond --cycle-size 3 --metric-profile flat --coarse-block-sizes 1,2,4 --seed 0 --out AgentTasks/p9-pilot-flat-diamond-n3-flat-2026-06-23.json
python Scripts/p9/pilot.py --geometry de_sitter_diamond --cycle-size 3 --metric-profile expanded --expansion-rate 0.35 --coarse-block-sizes 1,2,4 --seed 0 --out AgentTasks/p9-pilot-de-sitter-diamond-n3-expanded-2026-06-23.json
python -m json.tool AgentTasks/p9-pilot-flat-diamond-n3-flat-2026-06-23.json
python -m json.tool AgentTasks/p9-pilot-de-sitter-diamond-n3-expanded-2026-06-23.json
```

Both JSON outputs parse cleanly. Hygiene checks on `Scripts/p9/pilot.py`,
`Scripts/p9/p9_schema.json`, and the two output JSON files passed for non-ASCII
and trailing whitespace.

Pilot measurements:

- Flat diamond, `n=3`, block sizes `1,2,4`: projected trace `5.0`, coarse
  traces `5.0`, `3.0`, and approximately `0`; boundary and PSD checks passed.
- De Sitter-like diamond, `n=3`, expanded metric, block sizes `1,2,4`:
  projected trace about `5.125478`, coarse traces about `5.125478`,
  `3.042665`, and `0.042665`; boundary and PSD checks passed.

Interpretation: this is a toy but correctly shaped geometry-moving pilot. It
does not prove cosmological-constant leverage. It does show that the existing
pilot machinery can detect metric/geometry movement in the coarse projected
noise statistic while preserving the boundary and PSD checks. The next pilot
should pre-register a size sweep and pass/demote threshold.

Follow-up exact-enumeration diamond check:

```text
python Scripts/p9/pilot.py --geometry flat_diamond --cycle-size 2 --metric-profile flat --coarse-block-sizes 1,2,4 --seed 0 --out AgentTasks/p9-pilot-flat-diamond-n2-flat-2026-06-23.json
python Scripts/p9/pilot.py --geometry de_sitter_diamond --cycle-size 2 --metric-profile expanded --expansion-rate 0.35 --coarse-block-sizes 1,2,4 --seed 0 --out AgentTasks/p9-pilot-de-sitter-diamond-n2-expanded-2026-06-23.json
python -m json.tool AgentTasks/p9-pilot-flat-diamond-n2-flat-2026-06-23.json
python -m json.tool AgentTasks/p9-pilot-de-sitter-diamond-n2-expanded-2026-06-23.json
```

Summary over the exact-enumeration diamond strip sizes:

| case | edges | harmonic dim | projected trace | block-2 trace | block-4 trace | checks |
|---|---:|---:|---:|---:|---:|---|
| flat `n=2` | 8 | 3 | `3.0` | `2.0` | `~0` | boundary/PSD/coarse ok |
| de Sitter-like `n=2` | 8 | 3 | `3.084243` | `2.021724` | `0.021724` | boundary/PSD/coarse ok |
| flat `n=3` | 12 | 5 | `5.0` | `3.0` | `~0` | boundary/PSD/coarse ok |
| de Sitter-like `n=3` | 12 | 5 | `5.125478` | `3.042665` | `0.042665` | boundary/PSD/coarse ok |

The geometry-moving signal is consistent but small: the expanded/de Sitter-like
profile raises the projected trace by roughly `2.5%` to `2.8%` in these two
toy cases. The coarse block-4 signal remains nonzero for the expanded profile
while the flat toy collapses to numerical zero. Caveat: the coarse block-2 and
block-4 condition proxies become large in the expanded cases, so the next pilot
must distinguish real geometry movement from emerging conditioning problems.

## Integrated P9 coarse boundary-invariance core

Integrated Aristotle project:

- `e9a2ef62-0ab6-4db5-97a8-b2c904585fae`
  `null-edge-p9-coarse-boundary-invariance-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance`

Theorems:

- `pushforward_boundary_invariant`
- `response_boundary_invariant`
- `pushforward_boundary_invariant_pointwise`

Scientific role: this is the boundary-artifact guardrail for the C4 P9
coarse-grained variance route. If a fixed coarse-graining map annihilates a
boundary perturbation, the coarse source and any quadratic response built from
that coarse source are unchanged. This supports the corrected discrete-first
gate by making the observer-scale readout invariant under declared invisible
bookkeeping.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseBoundaryInvariance.lean
```

All targeted checks passed. Statement-identity review showed only proof-body
changes. The integration helper hit an archive extraction edge case on this
focused package, so the returned `Core.lean` was inspected directly from the
downloaded archive.

## Integrated P9 two-cell trace separation

Integrated Aristotle project:

- `99cd5c39-15f2-445c-a065-2e7a05555ea8`
  `null-edge-p9-two-cell-trace-separation-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation`

Theorems:

- `trace_diagonalKernel2`
- `identityR2_coarse_diagonal_trace`
- `two_cell_trace_separates`
- `two_cell_trace_strict_mono`

Scientific role: this is a small non-vacuity theorem for the C4 P9 route. A
fixed two-cell readout can distinguish explicit diagonal kernels, and the
coarse trace is strictly monotone with the sum of the two diagonal weights.
It does not yet encode causal geometry, but it proves the coarse statistic can
move when the finite kernel weights move.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
lake build PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9TwoCellTraceSeparation.lean
```

All targeted checks passed. Statement-identity review showed only proof-body
changes.

## Submitted P9 Hodge-projector instantiation

Submitted Aristotle project:

- `8f067f6a-5b77-47ed-be85-0bbe9c22b7db`
  `null-edge-p9-hodge-projector-instantiation-20260623`

Task:

- `d09cdb60-5a9f-4d66-8089-fc940dd2e80a`

Target:

- `AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean`

Scientific role: this is the next P9 bridge recommended by the Spark/Bohr C4
triage. It aims to prove that a self-adjoint idempotent projector whose range
lies in the weighted finite Hodge harmonic sector annihilates exact boundary
bookkeeping, so projected pairings and quadratic responses become
boundary-invariant. If successful, it upgrades the current abstract projector
API into a concrete finite Hodge/source-visibility mechanism.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean AgentTasks/null-edge-p9-hodge-projector-instantiation-aristotle-2026-06-23.md
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean AgentTasks/null-edge-p9-hodge-projector-instantiation-aristotle-2026-06-23.md
```

The Lean preflight found exactly four intended proof holes; non-ASCII scan was
clean.

## Integrated P9 Hodge-projector instantiation

Integrated Aristotle project:

- `8f067f6a-5b77-47ed-be85-0bbe9c22b7db`
  `null-edge-p9-hodge-projector-instantiation-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation`

Theorems:

- `hodgeProjector_annihilates_exact`
- `hodgeProjector_boundary_invariant`
- `hodgeProjector_projectedResponse_boundary_invariant`
- `hodgeProjector_pairing_boundary_invariant`

Scientific role: this is the concrete finite-Hodge bridge that the P9
source-visibility lane needed. If `Pi_H` is self-adjoint, idempotent, and its
range lies in the weighted finite Hodge harmonic sector, then `Pi_H` kills
exact boundary bookkeeping. Therefore projected sources, projected quadratic
responses, and projected pairings are invariant under adding exact boundary
bookkeeping. This upgrades earlier abstract projector assumptions into a
finite Hodge/source-visibility mechanism.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
lake build PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
```

All targeted checks passed. The returned proof used Unicode bullets; the
integrated proof was translated to ASCII Lean syntax.

## Integrated P9 coarse-kernel PSD core

Integrated Aristotle project:

- `6d1abbf8-7cdd-4e8b-a74f-9b2be12e35f3`
  `null-edge-p9-coarse-kernel-psd-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD`

Theorems:

- `response_coarseKernel_eq_response_pullback`
- `coarseKernel_psd`
- `psd_diag_nonneg`
- `trace_coarseKernel_nonneg`

Scientific role: this is the core C4 well-definedness theorem package. A fixed
coarse-graining map pushes a finite PSD noise kernel to a PSD coarse kernel,
coarse response equals fine response against the pulled-back test, and the
coarse trace is nonnegative. It makes `tr(R K R^T)` a legitimate finite
observer-scale variance statistic before the harder geometry-sensitivity
question is asked.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean
```

All targeted checks passed. Statement-identity review showed only proof-body
changes and cosmetic comment changes. Aristotle used a Unicode reverse arrow in
one proof; the integrated version was translated to ASCII syntax.

Index refresh:

```text
Scripts/lit/neo4j_paper_search.py
Scripts/lit/neo4j_doc_search.py
```

The paper index embedded the new Loukas item, and the doc index refreshed the
touched plan, conjecture, ledger, task-note, and new P9 Lean chunks.

## Submitted C4 coarse-kernel and boundary-invariance jobs

Submitted two focused Aristotle jobs that directly implement the C4 roadmap
from the discrete coarse-graining strategy:

- `6d1abbf8-7cdd-4e8b-a74f-9b2be12e35f3`
  `null-edge-p9-coarse-kernel-psd-20260623`
  (`task_id: bd1b57d2-df97-47fa-aba2-002cb92e2466`):
  prove that coarse response equals fine response on pulled-back tests, that
  `R K R^T` preserves PSD, and that the coarse kernel trace is nonnegative.
- `e9a2ef62-0ab6-4db5-97a8-b2c904585fae`
  `null-edge-p9-coarse-boundary-invariance-20260623`
  (`task_id: 8318fbeb-3689-4698-9528-2cc3128ff1a2`):
  prove that if `R` annihilates a boundary perturbation, then the coarse source
  and quadratic coarse response are unchanged.
- `99cd5c39-15f2-445c-a065-2e7a05555ea8`
  `null-edge-p9-two-cell-trace-separation-20260623`
  (`task_id: 6c7310c0-9ea8-4345-81aa-b8a6a0219985`):
  prove that a fixed two-cell coarse readout distinguishes explicit diagonal
  kernels, giving a small non-vacuity witness for geometry-sensitive trace
  motion.

Scientific role: these are the first focused finite theorem jobs aimed
specifically at the P9 C4 variance route. They test
well-definedness, boundary-artifact invariance, and trace sensitivity for a
fixed coarse-graining operator before any flat-vs-de-Sitter pilot is allowed to
count as evidence.
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`

Model log updated:

- `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`

## Integrated observer/super-Dirac Aristotle tranche

Integrated five completed Aristotle jobs:

- `24d7e228-3636-4398-801f-32dc0cca70a6`
  `null-edge-observer-partial-trace-20260623`
  -> `PhysicsSM.Draft.NullEdgeObserverPartialTrace`.
  Role: hidden partial trace commutes with visible congruence, and determinant
  is invariant under determinant-one visible congruence.
- `c0ddd3bf-04b6-44c4-8eff-db4472f226e9`
  `null-edge-super-dirac-product-grading-krein-20260623`
  -> `PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein`.
  Role: product grading oddness and finite `J`-self-adjointness scaffolding.
- `1de5924b-07e9-4052-bc88-161e881d896b`
  `null-edge-super-dirac-mass-shell-bridge-20260623`
  -> `PhysicsSM.Draft.NullEdgeSuperDiracMassShellBridge`.
  Role: no-double-count mass-shell constraint between kinetic Pluecker symbol
  and Yukawa square.
- `c60a6698-2567-49f6-92c4-541094a1f322`
  `null-edge-diamond-two-triangle-curvature-20260623`
  -> `PhysicsSM.Draft.NullEdgeDiamondTwoTriangleCurvature`.
  Role: scalar additive diamond defect equals a difference of two triangle
  curvature defects.
- `6387b084-fa39-4e19-bc2c-64828962b899`
  `null-edge-superconnection-cross-term-higgs-kinetic-20260623`
  -> `PhysicsSM.Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic`.
  Role: finite superconnection cross terms are explicitly Higgs kinetic blocks.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeObserverPartialTrace.lean
lake env lean PhysicsSM/Draft/NullEdgeSuperDiracProductGradingKrein.lean
lake env lean PhysicsSM/Draft/NullEdgeSuperDiracMassShellBridge.lean
lake env lean PhysicsSM/Draft/NullEdgeDiamondTwoTriangleCurvature.lean
lake env lean PhysicsSM/Draft/NullEdgeSuperconnectionCrossTermHiggsKinetic.lean
lake build PhysicsSM.Draft.NullEdgeObserverPartialTrace
lake build PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein
lake build PhysicsSM.Draft.NullEdgeSuperDiracMassShellBridge
lake build PhysicsSM.Draft.NullEdgeDiamondTwoTriangleCurvature
lake build PhysicsSM.Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" <five new modules>
git diff --check -- <five new modules plus touched docs>
```

All checks passed. The placeholder scan returned no matches.

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

## Integrated P9 source-visibility/noise feedback

The latest source-visibility/noise feedback was useful because it tightened the
P9 gate from "prove Hodge/projector facts" to "prove geometry-discriminating
Hodge/projector facts." I updated the program docs to require a flat-vs-de
Sitter-like finite diamond pilot with explicit pass/fail criteria:

- compare harmonic dimension, projected-noise trace, smallest positive projected
  eigenvalue, or projected condition number;
- require separation larger than within-family sprinkling spread, with a working
  target of `> 10x` the spread;
- require monotone response as the expansion parameter varies;
- require boundary-exact perturbation invariance and either refinement
  stability or a named coarse-graining / renormalization prescription;
- demote P9 if the effect is geometry-blind, unstable after that stated
  coarse-graining, boundary-artifactual, hand-tuned through arbitrary metric
  weights, or lacks a response law to curvature, expansion, vacuum energy, or a
  unimodular conjugate variable.

Files updated:

- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`

This should keep the next P9 proof and pilot jobs aimed at publishable content
rather than generic finite Hodge algebra.

## Corrected P9 conditioning gate after user pushback

User pushback: the Aristotle strategy job was too strict when it treated an
ill-conditioned fine-scale harmonic channel as automatically meaning "no
continuum interpretation." The null-edge program is allowed to be fundamentally
discrete, with continuum-like behavior emerging only after coarse-graining or
renormalization.

Updated gate: fine-scale ill-conditioning is a diagnostic, not a fatal failure.
P9 should be demoted only if no stable large-scale statistic survives after the
stated coarse-graining/renormalization prescription, or if the discriminating
quantity is geometry-blind, boundary-artifactual, hand-tuned through arbitrary
weights, or unconnected to a source/curvature response law.

Files updated:

- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md`

## Submitted P9 harmonic-kernel core job

Submitted focused Aristotle job:

- `0a6aa9da-d023-4af4-a70a-d966975b8b84`
  `null-edge-p9-harmonic-kernel-core-20260623`: prove the finite weighted
  Hodge kernel theorem `harmonic_iff_closed_and_coclosed`, with positive
  diagonal weights and explicit `codiff w0 w1 d0` convention.

This job was shaped by Spark/Huygens theorem-audit feedback. It also respects
the corrected discrete-first gate: the theorem is a finite algebraic Hodge
kernel statement, not yet a claim that fine-grained continuum behavior exists.
The later physics gate is stable coarse-grained or renormalized harmonic
response, not microscopic condition-number niceness.

## Submitted P9 discrete coarse-graining strategy job

Submitted no-code Aristotle strategy/audit job:

- `6b4325a0-5dd1-4985-80c2-fef93375f77d`
  `null-edge-p9-discrete-coarse-graining-strategy-20260623`: ask Aristotle to
  design P9 coarse-grained or renormalized harmonic/source observables under the
  corrected discrete-first gate.

Spark/Banach independently triaged candidate observables:

- harmonic-sector density;
- projected-noise trace density;
- projected spectral edge / condition number after coarse-graining;
- closed-test source-response split;
- renormalized residual-fluctuation law.

Most publishable near-term route: source-split with projected observables, then
projected trace/eigenvalue scaling under a stated coarse-graining or
renormalization prescription.

## Literature cadence: P9 Laplacian coarse-graining guardrail

Ran a focused source pass for the corrected P9 discrete-first gate. Semantic
Scholar was not needed; OpenAlex, arXiv, and Crossref were sufficient.

Added to Zotero collection `9W59V3K9` and linked in Neo4j to claim
`P9_discrete_coarse_grained_harmonic_observables`:

- `RA8QNNKW`: Nurisso et al., "Higher-order Laplacian renormalization,"
  *Nature Physics* 21 (2025), DOI `10.1038/s41567-025-02784-1`.
- `AN5RZGJZ`: Caldarelli et al., "Laplacian renormalization group: an
  introduction to heterogeneous coarse-graining," *JSTAT* (2024), DOI
  `10.1088/1742-5468/ad57b1`.
- `UR5ADCBP`: Loures, Piovesana, and Brum, "Laplacian Coarse Graining in
  Complex Networks," arXiv `2302.07093`.

Scientific consequence: the corrected P9 gate now has external support. The
program can tolerate fine-scale discrete ill-conditioning if a
coarse-grained/renormalized harmonic-source statistic is stable and
geometry-discriminating. The next pilot should report trace densities,
harmonic-sector densities, or projected spectral edges after an explicit
coarse-graining map, rather than treating microscopic condition numbers as a
binary pass/fail criterion.

## Submitted P9 coarse residual-variance proof job

Submitted focused Aristotle job:

- `5626ed17-206a-4c75-8073-a1aec026a458`
  `null-edge-p9-coarse-residual-variance-20260623`: prove that a block map from
  fine residual cells to coarse cells preserves total residual variance when
  coarse block variance is defined as the sum of fine variances in the block.

Scientific role: this is the first small formal spine for the corrected
coarse-grained P9 gate. It says the residual-noise statistic can be moved from
fine cells to coarse cells by an explicit map without changing total variance;
later work can add scale normalization, geometry, and response laws.

## Integrated P3 crossed-module fake-flatness job

Integrated Aristotle project:

- `1f2a340d-e077-4dfe-a682-c018f5e99fea`
  `null-edge-p3-crossed-module-fake-flatness-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP3CrossedModule`

Theorems:

- `fakeFlat_verticalCompose`
- `fakeFlat_horizontalCompose`
- `crossedModule_2cell_interchange`

Scientific role: this banks the finite higher-gauge algebra behind P3. A
crossed-module 2-cell label remains fake-flat under vertical and horizontal
composition, and the 2-cell labels satisfy the double-category interchange law.
The remaining physics task is no longer the abstract interchange law; it is to
define the causal-diamond surface label and show that fake-flatness is forced by
the finite geometry rather than optional packaging.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP3CrossedModule.lean
lake build PhysicsSM.Draft.NullEdgeP3CrossedModule
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP3CrossedModule.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP3CrossedModule.lean
```

The targeted Lean checks passed. Placeholder and non-ASCII scans were clean
after replacing Aristotle's Unicode proof text with ASCII proof structure.

## P9 numerical pilot: cycle-size harmonic trace sweep

Ran the finite P9 pilot on cycle graphs with `3 <= E <= 12`, for both the flat
edge metric and the toy expanded metric profile:

```text
python Scripts/p9/pilot.py --geometry cycle --cycle-size <n> --metric-profile flat
python Scripts/p9/pilot.py --geometry cycle --cycle-size <n> --metric-profile expanded --expansion-rate 0.35
```

Outputs were written to:

```text
AgentTasks/p9-pilot-cycle-n<n>-flat-2026-06-23.json
AgentTasks/p9-pilot-cycle-n<n>-expanded-2026-06-23.json
```

Observed summary:

- `harm_dim = 1` for every cycle, as expected for the one harmonic 1-cycle.
- flat projected-noise trace stays numerically `1`.
- expanded projected-noise trace stays near `1.01` to `1.04` despite increasing
  edge count and a metric weight spread growing to about `1.79`.
- projected condition number remains `1`.
- boundary-exact perturbation regression passes for all runs.

Scientific interpretation: this is a toy positive signal for the corrected
discrete-first P9 gate. The harmonic-channel trace is an `O(1)` topological /
coarse observable on this family, not a microscopic volume-scaling quantity.
Equivalently, trace density decays like `1/E`. This does not yet give
cosmological-constant leverage because cycles are not causal diamonds and the
metric profile is artificial, but it supports the strategy of testing stable
coarse-grained harmonic observables rather than rejecting the model for
fine-scale discrete ill-conditioning.

Next pilot target: replace bare cycles with nested causal-diamond-like cell
families and compare flat versus expanded/deformed metrics using the same
reported observables: harmonic dimension, projected-noise trace, trace density,
smallest projected spectral edge, condition number, and boundary-perturbation
regression.

## Submitted P9 rank-one harmonic trace proof job

Submitted focused Aristotle job:

- `a775c905-af53-4cba-8b49-81d5822fdc10`
  `null-edge-p9-rankone-harmonic-trace-20260623`
  (`task_id: 7b2b43ad-55dd-4f36-9a30-270b746ffbba`)

Target:

```lean
meanProjector_basis_diag
meanProjector_trace_eq_one
meanProjector_trace_density
```

Scientific role: formalize the toy cycle-pilot signal as finite algebra. The
rank-one mean/harmonic projector has trace `1`, so its trace density is `1/n`.
This does not prove a causal-diamond cosmology claim, but it gives a small
kernel-checkable theorem for the corrected P9 gate: stable large-scale
projected observables can be meaningful in a fundamentally discrete model even
when microscopic continuum behavior is not assumed.

Local pre-submit check:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-rankone-harmonic-trace-20260623/NullEdgeP9RankOneHarmonicTrace/Core.lean
```

The check passed with exactly the three intended proof-hole warnings.

## Reviewed P9 discrete coarse-graining strategy job

Reviewed no-code Aristotle project:

- `6b4325a0-5dd1-4985-80c2-fef93375f77d`
  `null-edge-p9-discrete-coarse-graining-strategy-20260623`

Main result: Aristotle endorsed the corrected discrete-first gate but sharpened
the burden. P9 should not be killed by microscopic ill-conditioning or by the
absence of a pointwise continuum field limit. It should be tested by a
pre-specified coarse-graining map `R` and a large-scale statistic that:

- reaches a stable plateau under the fixed coarse-graining ladder;
- moves with geometry, especially flat versus de Sitter-like diamonds;
- is invariant under boundary-exact perturbations;
- is not produced by hand-tuned metric weights or a post-hoc `R`.

Prioritization change: build the coarse-grained noise-kernel variance route
first. Push the already-positive finite kernel to `R K R^T` and track
`tr(R K R^T)`. This reuses the existing PSD/Cauchy-Schwarz/noise-kernel spine
and asks one sharp question: does the plateau retain flat-vs-de-Sitter
dependence? Treat Green-function/source-response susceptibility as the stronger
follow-up after visible-subspace invertibility and regulated Green-operator
stability are in hand.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

## Integrated P9 coarse residual-variance identity

Integrated Aristotle project:

- `5626ed17-206a-4c75-8073-a1aec026a458`
  `null-edge-p9-coarse-residual-variance-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance`

Theorems:

- `blockVariance_nonneg`
- `coarseVariance_eq_amplitudeSqSum`
- `coarseVariance_density_eq_amplitudeSqSum_div_scale`

Scientific role: this is a small but clean formal spine for the corrected P9
coarse-graining gate. If fine residual amplitudes are assigned to coarse
blocks, the total coarse block variance equals the original fine variance.
Thus variance readouts can be moved through an explicit coarse-graining map
before adding geometry, response laws, or normalization.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseResidualVariance.lean
```

All targeted checks passed. The first `PhysicsSMDraft.lean` check timed out at
180 seconds; rerunning with a longer timeout passed.

## Integrated P9 rank-one harmonic trace toy theorem

Integrated Aristotle project:

- `a775c905-af53-4cba-8b49-81d5822fdc10`
  `null-edge-p9-rankone-harmonic-trace-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace`

Theorems:

- `meanProjector_basis_diag`
- `meanProjector_trace_eq_one`
- `meanProjector_trace_density`

Scientific role: this formalizes the simplest toy version of the P9 cycle
pilot. The mean projector onto constant vectors has coordinate trace `1`, so
its trace density is `1/n`. This is not a causal-diamond theorem, but it is a
kernel-checked finite witness for the discrete-first idea that a projected
harmonic statistic can be `O(1)` while the microscopic cell count grows.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
lake build PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RankOneHarmonicTrace.lean
```

All targeted checks passed. The returned proof used a Unicode not-equal symbol;
the integrated proof uses ASCII `Not (...)` instead. The first umbrella import
check raced the targeted build and failed before the `.olean` existed; rerunning
after the targeted build passed.

## Integrated P9 weighted adjoint core

Integrated Aristotle project:

- `32a7fb73-8801-453d-8f8c-5c794e4dbe30`
  `null-edge-p9-weighted-adjoint-core-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore`

Theorems:

- `weighted_adjoint_coboundary_codiff`
- `codiff_zero_of_zero_target_metric`

Scientific role: this is the first explicit Tier-A finite Hodge ingredient for
P9. Given diagonal weights on adjacent cochain spaces, the `codiff` definition
is the weighted adjoint of the coboundary. This moves the harmonic-projector
story away from generic "there exists a projector" algebra and toward a
metric-dependent finite diamond Hodge API.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
```

All targeted checks passed. Aristotle's returned proof used Unicode inverse,
sum, forall, and not-equal symbols; the integrated proof was translated to
ASCII Lean syntax. The first umbrella import check raced the targeted build and
failed before the `.olean` existed; rerunning after the targeted build passed.

## Integrated P9 harmonic-kernel core

Integrated Aristotle project:

- `0a6aa9da-d023-4af4-a70a-d966975b8b84`
  `null-edge-p9-harmonic-kernel-core-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore`

Theorems:

- `dotW_self_eq_zero_iff_of_pos`
- `weighted_adjoint_coboundary_codiff`
- `weighted_lap1_energy_eq_down_plus_up`
- `harmonic_iff_closed_and_coclosed`

Scientific role: this is the strongest P9 formal result integrated in this
continuation. With positive diagonal weights, the kernel of the finite weighted
1-Laplacian is exactly the intersection of closed and coclosed 1-cochains. This
makes the P9 slogan `ker d cap ker delta` a concrete finite theorem and gives
the source-visibility/noise branch an explicit Hodge kernel, not merely an
abstract projector.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
lake build PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
```

All targeted checks passed. Aristotle's returned proof used Unicode tactic
syntax and symbols; the integrated proof was translated to ASCII Lean control
flow and notation.

## Integrated P9 weighted Laplacian energy core

Integrated Aristotle project:

- `23a1472a-e255-48b5-9314-6b13b6286af1`
  `null-edge-p9-weighted-laplacian-energy-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy`

Theorems:

- `weighted_adjoint_coboundary_codiff`
- `dotW_comm`
- `dotW_self_nonneg`
- `weighted_lap1_energy_eq_down_plus_up`
- `weighted_lap1_energy_nonneg`

Scientific role: this is the Tier-A finite Hodge sum-of-squares identity for
P9. The weighted 1-Laplacian pairing splits into down-energy and up-energy
terms, and is nonnegative under nonnegative source/face weights. Together with
`NullEdgeP9HarmonicKernelCore`, this gives the harmonic-channel branch an
explicit finite Hodge algebra rather than only abstract projector assumptions.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedLaplacianEnergy.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9WeightedLaplacianEnergy.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedLaplacianEnergy.lean
```

All targeted checks passed. Aristotle's returned proof used Unicode inverse,
reverse-rewrite, and not-equal symbols; the integrated proof was translated to
ASCII Lean syntax. The first umbrella import check raced the targeted build and
failed before the `.olean` existed; rerunning after the targeted build passed.

## Literature pass: C4 coarse-graining operator guardrail

Semantic Scholar remained rate-limited, so this pass used OpenAlex, Crossref,
arXiv, and the local Neo4j paper index. The local index confirmed that the
already-added Laplacian coarse-graining sources `AN5RZGJZ` and `UR5ADCBP` are
the closest existing project anchors.

New source added to Zotero collection `9W59V3K9`:

- `PTU4XM4U`: Andreas Loukas, "Graph reduction with spectral and cut
  guarantees," arXiv `1808.10650`.

Neo4j link added:

- `PTU4XM4U` supports claim `P9_prespecified_coarse_graining_operator`.

Scientific consequence: the C4 P9 pilot should not invent or tune a
coarse-graining map after seeing the output. It should choose `R` from an
established graph/cellular reduction family with spectral/cut guarantees, then
test whether `tr(R K R^T)` has a stable, geometry-moving plateau.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
## Submitted P9 coarse-map guardrail batch

Submitted three Aristotle jobs after the block-aliasing/offset-sweep result
made the next P9 issue clearer:

- `f9b645e7-80d3-464b-95ba-ce79a91fe374`
  (`task_id: 93422773-9511-4e4a-867a-87c52aa2f7f0`):
  `null-edge-p9-offset-window-guardrail-20260623`. Proof target for the
  finite offset-artifact warning: a single block-window zero is not
  offset-invariant, and even all shifted four-cell window traces can annihilate
  a nonzero high-frequency mode.
- `e831cb23-db32-4cf6-b2ad-6f03c0908f15`
  (`task_id: d83def02-f759-483e-b0a8-c0fc7cb66fcf`):
  `null-edge-p9-boundary-volume-scaling-20260623`. Proof target for the
  area-vs-volume density scaffold: in the toy four-dimensional scaling model,
  boundary-over-volume density is `C / L`, falls below `eps` beyond a scale
  threshold, and halves when the linear scale doubles.
- `a27b17de-4660-46b9-88dc-976dc237c903`
  (`task_id: 1d228ef7-ca88-4c2d-badb-f154c90fdbfb`):
  no-code strategy/audit job asking Aristotle for intrinsic or observer-forced
  P9 coarse maps after the block-aliasing warning.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-offset-window-guardrail-20260623/NullEdgeP9OffsetWindowGuardrail/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-boundary-volume-scaling-20260623/NullEdgeP9BoundaryVolumeScaling/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-offset-window-guardrail-20260623-project/NullEdgeP9OffsetWindowGuardrail/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-boundary-volume-scaling-20260623-project/NullEdgeP9BoundaryVolumeScaling/Core.lean
```

All four Lean preflight checks passed with exactly the intended proof-hole
warnings. The focused submission helper reported no proof-escape or unsafe
tokens. Non-ASCII scans on the new staged files were clean.

Scientific reason: this batch keeps P9 honest under the corrected
discrete-first gate. Fine-scale discreteness is acceptable; after-the-fact or
alignment-sensitive coarse maps are not.

## Literature pass: intrinsic causal-set graph observables

Focused search target:

```text
causal set coarse graining intrinsic graph observables causal diamonds
```

Local semantic doc search first recovered the existing C4/coarse-graining
guardrail notes and the Loukas graph-reduction source. External search then
surfaced a new, directly relevant paper:

- Zotero `RC5XF8RD`: Astrid Eichhorn, Harald Mack, Kim Tuyen Le, Fabian Wagner,
  "Charting causal set configuration space with graph observables," arXiv
  `2605.27514`.

Neo4j update:

- Added Paper `RC5XF8RD` to collection `9W59V3K9`.
- Added claim `P9_intrinsic_graph_observable_guardrail`.
- Linked `RC5XF8RD -[:SUPPORTS {relation: 'guardrail'}]->` that claim.

Scientific consequence: the next P9 numerical and theorem work should test
intrinsic causal-set observables before treating block-average coarse maps as
physical. The useful candidates from the paper are link-degree distributions,
symmetrized-Hasse graph Laplacian spectra, and causal-interval abundance. These
are better aligned with a discrete-first ontology than a hand-tuned continuum
curvature statistic.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`

## Integrated P9 offset-window guardrail

Integrated Aristotle project:

- `f9b645e7-80d3-464b-95ba-ce79a91fe374`
  `null-edge-p9-offset-window-guardrail-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail`

Theorems:

- `single_window_zero_not_offset_invariant`
- `nonzero_mode_all_window_traces_zero`
- `all_window_sums_zero_implies_all_traces_zero`

Scientific role: this formalizes the negative-control lesson from the P9
offset sweep. A single aligned block zero need not survive offset shift, and
even all shifted four-cell block traces can annihilate a nonzero high-frequency
mode. This proves that block-average invisibility can be arithmetic alignment,
not source invisibility.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
lake build PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9OffsetWindowGuardrail.lean
```

All targeted checks passed after translating Aristotle's proof syntax to ASCII.

## Integrated P9 boundary-over-volume scaling scaffold

Integrated Aristotle project:

- `e831cb23-db32-4cf6-b2ad-6f03c0908f15`
  `null-edge-p9-boundary-volume-scaling-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling`

Theorems:

- `boundaryDensity4_eq_C_div_L`
- `boundaryDensity4_le_eps_of_scale_ge`
- `boundaryDensity4_double_scale`

Scientific role: this is the small finite arithmetic scaffold behind the P9
area-vs-volume route. In the toy four-dimensional scaling model, a
boundary-sized visible sector has density `C / L`, falls below any positive
threshold once the scale is large enough, and halves under scale-doubling.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
lake build PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9BoundaryVolumeScaling.lean
```

All targeted checks passed. The nonnegative coefficient hypothesis is retained
as the physical boundary-size regime even though the algebraic proof does not
need it.

## Reviewed P9 intrinsic coarse-map strategy

Reviewed Aristotle project:

- `a27b17de-4660-46b9-88dc-976dc237c903`
  `null-edge-p9-intrinsic-coarse-map-strategy-20260623`

Useful result: Aristotle independently recommends spectral Hodge coarse modes
as the first publishable intrinsic route, with Alexandrov/interval abundance
and Sorkin-Johnston screen/window channels as alternatives. The strategy is
aligned with the new `RC5XF8RD` literature guardrail and with the corrected
discrete-first gate: microscopic ill-conditioning is allowed only if the
large-scale observer statistic remains stable under nuisance sweeps.

## Submitted P9 intrinsic order-observable invariance job

Submitted Aristotle project:

- `e71998cf-0c45-4dba-8677-639cf47576af`
  (`task_id: 29e79cdc-dcca-4536-b3b4-61b8147221d1`)
  `null-edge-p9-intrinsic-order-observables-20260623`

Targets:

- `intervalCard_transportRel`
- `intervalAbundance_transportRel`
- `outDegree_transportRel`
- `outDegreeHistogram_transportRel`

Scientific role: first formal bridge from the new causal-set observable source
`RC5XF8RD` into Lean-facing theorem work. The target proves that interval
abundance and out-degree histograms are invariant under finite relabeling, so
they are genuinely intrinsic order observables rather than artifacts of a block
grid or vertex labeling.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-intrinsic-order-observables-20260623/NullEdgeP9IntrinsicOrderObservables/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-intrinsic-order-observables-20260623-project/NullEdgeP9IntrinsicOrderObservables/Core.lean
```

Both checks passed with exactly four intended proof-hole warnings.

## Submitted P9 weighted-projector residual orthogonality job

Submitted Aristotle project:

- `d9318fe9-73b3-4e86-9553-95cbf3b4cc9b`
  (`task_id: 4024001a-7719-4981-a2f3-68d89a814945`)
  `null-edge-p9-weighted-projector-residual-orthogonal-20260623`

Targets:

- `weighted_projected_pairing_eq`
- `weighted_residual_orthogonal_to_projected`
- `weighted_projected_test_pairing_decomposition`

Scientific role: this follows Aristotle's P9 intrinsic coarse-map strategy by
turning the spectral/Hodge-coarse-mode idea into a finite algebra target. A
weighted self-adjoint idempotent projector should make residual source
components invisible to projected/coarse tests, giving the P9 observer-channel
readout a clean orthogonal decomposition.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-residual-orthogonal-20260623/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-residual-orthogonal-20260623-project/NullEdgeP9WeightedProjectorResidualOrthogonal/Core.lean
```

Both checks passed with exactly three intended proof-hole warnings; non-ASCII
and escape-hatch scans were clean.

## Integrated P9 intrinsic order-observable invariance

Integrated Aristotle project:

- `e71998cf-0c45-4dba-8677-639cf47576af`
  `null-edge-p9-intrinsic-order-observables-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables`

Theorems:

- `intervalCard_transportRel`
- `intervalAbundance_transportRel`
- `outDegree_transportRel`
- `outDegreeHistogram_transportRel`

Scientific role: this is the first formal bridge from the new causal-set graph
observable source `RC5XF8RD` into Lean. It proves that interval abundance and
out-degree histograms are invariant under finite relabeling, so they are
intrinsic order observables rather than artifacts of a chosen vertex labeling.
This directly supports the corrected discrete-first P9 gate: use intrinsic
order observables or observer-forced coarse maps before trusting block-offset
statistics.

Integration note: Aristotle returned `COMPLETE_WITH_ERRORS`, but the completion
report says all targets were solved, statements unchanged, and no proof holes
or escape hatches remained. The only remaining issue was benign linter noise
about unused decidable hypotheses. The live module adds targeted linter
suppression for that warning. The helper again hit the Windows bundled-task-note
extraction-path issue, so integration used the returned target file and
`git diff --no-index`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean
lake build PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9IntrinsicOrderObservables.lean
```

All targeted checks passed.

## Gemini critique: P9 Hodge/intrinsic-observable next gates

Queried Gemini CLI with a concise P9 context pack after integrating the weighted
projector, intrinsic-order, and weighted-Laplacian self-adjointness results.

Main steering:

- The current P9 stack is formally clean but can still be generic finite linear
  algebra unless it couples to causal-order geometry.
- Highest-value next targets:
  1. defect/curvature sensitivity benchmark;
  2. covariant coarse-graining stability;
  3. Sorkin-style fluctuation scaling from intrinsic graph/spectral data.
- Recommended framing: "kinematic filtering mechanism for bulk noise," not a
  claimed solution of the cosmological-constant problem.
- Failure modes: observer tuning, boundary-artifact dominance, and
  graph-theoretic degeneracy/isohistogram blindness.

Follow-up: stage a focused no-code Aristotle strategy job asking for a
Lean-friendly theorem ladder for those three P9 gates.

## Integrated P9 weighted-projector residual orthogonality

Integrated Aristotle project:

- `d9318fe9-73b3-4e86-9553-95cbf3b4cc9b`
  `null-edge-p9-weighted-projector-residual-orthogonal-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal`

Theorems:

- `weighted_projected_pairing_eq`
- `weighted_residual_orthogonal_to_projected`
- `weighted_projected_test_pairing_decomposition`

Scientific role: this is the weighted version of the P9 projected-source
orthogonality theorem. It says that a weighted self-adjoint idempotent
projector splits a finite source into projected and residual components, and
projected observer tests see only the projected component. This strengthens the
spectral/Hodge coarse-mode route because it gives the observer-channel readout a
weighted orthogonality law rather than an unweighted toy law.

Integration note: `integrate_completed.py` downloaded the result but hit a
Windows extraction-path issue on a bundled task-note path. The target file was
still extracted; the integration used `git diff --no-index` against the staged
source and manually copied the proof bodies with ASCII Lean syntax.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
```

All targeted checks passed.

## Submitted P9 weighted 1-Laplacian self-adjointness job

Submitted Aristotle project:

- `bfbb0923-97d7-4966-9051-53e69c3b4d75`
  (`task_id: 7f89b5ce-8d1c-44fa-bf55-f401a69cdc3e`)
  `null-edge-p9-weighted-lap1-self-adjoint-20260623`

Targets:

- `dotW_lap1_bilinear_eq_down_plus_up`
- `weighted_lap1_selfAdjoint`

Scientific role: this is the spectral-legitimacy bridge for the P9 Hodge route.
The existing weighted-adjoint and energy identities show positivity on the
diagonal; this target asks for the bilinear/self-adjoint form needed before
using the explicit finite weighted Laplacian to define spectral coarse modes.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-lap1-self-adjoint-20260623/NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-lap1-self-adjoint-20260623-project/NullEdgeP9WeightedLap1SelfAdjoint/Core.lean
```

Both checks passed with exactly two intended proof-hole warnings; non-ASCII and
escape-hatch scans were clean.

## Integrated P9 weighted 1-Laplacian self-adjointness

Integrated Aristotle project:

- `bfbb0923-97d7-4966-9051-53e69c3b4d75`
  `null-edge-p9-weighted-lap1-self-adjoint-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint`

Theorems:

- `dotW_lap1_bilinear_eq_down_plus_up`
- `weighted_lap1_selfAdjoint`

Scientific role: this is a high-leverage finite Hodge result for P9. The
existing weighted-Laplacian energy theorem was a diagonal sum-of-squares
identity. This module proves the bilinear version and self-adjointness of the
explicit weighted 1-Laplacian, which is the algebra needed before treating its
spectral subspaces/projectors as observer-channel coarse modes.

Integration note: Aristotle's focused package also checked that the new
theorems depend only on standard axioms. The helper downloaded the result but
hit the recurring Windows bundled-task-note extraction issue; integration used
the extracted target file and `git diff --no-index`, with manual ASCII
translation of left-arrow tokens.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint
lake env lean PhysicsSMDraft.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedLap1SelfAdjoint.lean
```

All targeted checks passed.

## Submitted P9 weighted-projector Pythagorean identity job

Submitted Aristotle project:

- `4e23c58d-5c87-4a94-aa27-e728babc395e`
  (`task_id: 87e7ba4d-9b7a-4a81-bfd8-9f43fbcd664c`)
  `null-edge-p9-weighted-projector-pythagorean-20260623`

Targets:

- `weighted_residual_orthogonal_to_projected`
- `source_eq_projected_plus_residual`
- `weighted_projector_pythagorean`

Scientific role: this is the norm/noise companion to the newly integrated
weighted residual-orthogonality theorem. If proved, it splits source energy
into projected observer-channel energy plus residual energy, which is a much
stronger P9 readout than a zero-pairing statement alone.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-projector-pythagorean-20260623/NullEdgeP9WeightedProjectorPythagorean/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-weighted-projector-pythagorean-20260623-project/NullEdgeP9WeightedProjectorPythagorean/Core.lean
```

Both checks passed with exactly three intended proof-hole warnings; non-ASCII
and escape-hatch scans were clean.

## Corrected P9 discrete-first gate

Updated the overnight plan and P9 explicit-Hodge strategy pack to remove
Aristotle's overstrict "no continuum interpretation" failure gate. A
fundamentally discrete model is acceptable. The relevant failure condition is
the absence of a stable pre-specified coarse-grained, renormalized, or
observer-channel readout, or a readout that survives only through hand-tuned
weights, boundary artifacts, or geometry-blind statistics.

## Submitted P9 defect/coarse-stability strategy job

Submitted no-code Aristotle strategy/audit project:

- `cd647147-43b7-4ca2-a5ef-bc8e88b535c9`
  (`task_id: 9ddbb804-85ba-47f4-b6f2-793ddfaa9560`)
  `null-edge-p9-defect-coarse-stability-strategy-20260623`

Scientific role: ask Aristotle for a concrete theorem/numerical ladder for
defect sensitivity, covariant coarse-graining stability, and Sorkin-style
fluctuation scaling. The prompt frames P9 as a kinematic filtering mechanism
for bulk noise, not as a solved cosmological-constant problem.

## Literature pass: P9 defect/coarse-stability anchors

Ran local semantic searches:

```text
Scripts/lit/neo4j_doc_search.py --query "P9 source visibility finite Hodge projector intrinsic causal order observables coarse graining stability defect curvature sensitivity Sorkin fluctuations"
Scripts/lit/neo4j_paper_search.py --query "causal set graph observables interval abundance coarse graining Hodge Laplacian source visibility cosmological constant fluctuations Sorkin"
```

Top paper anchors returned from the null-edge collections:

- `RC5XF8RD`: graph observables for causal-set configuration space;
- `G3FT8BXC`: Sorkin discreteness residue/cosmological constant;
- `8QCBDKVD` and `ZCN6Q6IB`: causal-set links/directions;
- `K5CFI3HI`: everpresent Lambda fluctuation model;
- `I37GR6S4`: bosonic fields in causal-set theory;
- `WCCDDR3H`: Benincasa-Dowker-Glaser continuum-limit guardrail.

The search reinforces the next P9 emphasis: couple the finite Hodge/projector
stack to intrinsic causal-order observables and defect sensitivity, rather
than adding more generic linear-algebra wrappers.

## Spark integration/backlog triage

Spark worker `Franklin` checked the recent Aristotle queue and task notes.
Result: no completed Lean Aristotle project was found waiting for integration
in the sampled recent queue. The one missing live module is the still-running
weighted-projector Pythagorean job `4e23c58d-5c87-4a94-aa27-e728babc395e`.
The active no-code strategy job `cd647147-43b7-4ca2-a5ef-bc8e88b535c9` has no
Lean integration action until it returns a strategy report.

## Submitted P9 defect-sensitivity benchmark proof job

Submitted focused Aristotle project:

- `aca96818-d575-44e4-97cb-949aa461dfe6`
  (`task_id: d899a2a1-0ace-4926-833f-a305b80c22c3`)
  `null-edge-p9-defect-sensitivity-benchmark-20260623`

Targets:

- `defectReadout_add_commonMode`
- `defectReadout_add_differentialMode`
- `defectReadout_eq_zero_iff_equal`
- `defectResponse_nonneg`
- `differentialMode_creates_defect_of_ne_zero`

Scientific role: this is the smallest formal defect-sensitivity benchmark for
P9. Common-mode two-triangle curvature bookkeeping should be invisible to the
diamond-defect readout, while a differential curvature perturbation should be
visible. This directly answers the latest P9 critique that the program needs
defect/curvature sensitivity, not only Hodge projector algebra.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-defect-sensitivity-benchmark-20260623/NullEdgeP9DefectSensitivityBenchmark/Core.lean
```

The preflight passed with exactly five intended proof-hole warnings; non-ASCII
and escape-hatch scans were clean.

## Integrated P9 weighted-projector Pythagorean identity

Integrated Aristotle project:

- `4e23c58d-5c87-4a94-aa27-e728babc395e`
  `null-edge-p9-weighted-projector-pythagorean-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean`

Theorems:

- `weighted_residual_orthogonal_to_projected`
- `source_eq_projected_plus_residual`
- `weighted_projector_pythagorean`

Scientific role: this is the weighted norm/noise decomposition companion to
the residual-orthogonality theorem. A weighted self-adjoint idempotent
projector splits a finite source into projected observer-channel energy plus
residual energy. This turns P9's projected-source readout from a zero-pairing
statement into a genuine Pythagorean energy split.

Integration note: the helper downloaded the result but hit the recurring
Windows bundled-task-note extraction path issue. The target file was still
extracted and reviewed with `git diff --no-index`; only proof bodies changed.
The extracted file had mojibake around left-arrow tokens, so the live module
uses equivalent ASCII Lean syntax.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedProjectorPythagorean.lean
```

All targeted checks passed. The first draft-root check raced the targeted build
and failed before the `.olean` existed; rerunning sequentially passed.

## Integrated P9 defect-sensitivity benchmark

Integrated Aristotle project:

- `aca96818-d575-44e4-97cb-949aa461dfe6`
  `null-edge-p9-defect-sensitivity-benchmark-20260623`

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark`

Theorems:

- `defectReadout_add_commonMode`
- `defectReadout_add_differentialMode`
- `defectReadout_eq_zero_iff_equal`
- `defectResponse_nonneg`
- `differentialMode_creates_defect_of_ne_zero`

Scientific role: this is the first formal defect-sensitivity benchmark in the
new P9 gate. Common-mode two-triangle curvature bookkeeping is invisible to the
linearized diamond-defect readout, while a differential curvature perturbation
is visible and creates a nonzero defect from a flat baseline.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
lake build PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
```

All targeted checks passed. The first draft-root check raced the targeted build
and failed before the `.olean` existed; rerunning sequentially passed.

## Strategy result: P9 iso-histogram separation gate

Aristotle strategy project:

- `cd647147-43b7-4ca2-a5ef-bc8e88b535c9`
  `null-edge-p9-defect-coarse-stability-strategy-20260623`

Most important output: P9 should graduate from generic finite Hodge algebra
only after an iso-histogram separation result. The target is a pair of finite
causal sets with identical out-degree and interval-abundance histograms,
separated by a frozen projected observer readout, with order-isomorphism
invariance and stability under a pre-specified Alexandrov or spectral coarse
map with an explicit scale-uniform bound.

Demotion/failure modes: observer tuning, block/grid aliasing, boundary-artifact
dominance, global-weight leakage, histogram blindness, and vacuous
non-uniform stability bounds. The Sorkin-style numerical pilot should test
`Delta R / mean(R) ~ 1 / sqrt(N)` against iso-histogram, random-weight, and
boundary-stripped null controls.

## Submitted P9 iso-histogram separation proof job

Submitted focused Aristotle project:

- `66f5c60f-a1db-4764-8e42-8ff665ebd271`
  (`task_id: a3bf2e9e-8627-4563-b79a-ac6735521231`)
  `null-edge-p9-isohistogram-separation-20260623`

Targets:

- `relA_irreflexive`
- `relA_transitive`
- `relB_irreflexive`
- `relB_transitive`
- `same_outDegreeSignature`
- `same_inDegreeSignature`
- `same_intervalSignature`
- `jointReadout21_relA`
- `jointReadout21_relB`
- `jointReadout21_separates`

Scientific role: this is the next proof target from the strategy report. It
exhibits two five-point strict transitive relations with the same out-degree,
in-degree, and interval-abundance signatures, but a frozen joint in/out-degree
readout separates them. If Aristotle proves it, P9 has its first explicit
finite witness that common intrinsic histograms can be incomplete.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623/NullEdgeP9IsohistogramSeparation/Core.lean
```

The preflight passed with exactly ten intended proof-hole warnings; non-ASCII
and escape-hatch scans were clean.

## Claude critique: cheap iso-histogram witness is not enough

Queried Claude CLI for an adversarial critique of the `Fin 5`
iso-histogram witness. Claude's useful verdict: the target is true but cheap,
because it mainly proves that marginal histograms do not determine a joint
distribution. It is missing a diamond-local observer channel, a coarse map, and
a noise class.

Follow-up target recommended by Claude:

- T1: matched joint in/out-degree histograms and global interval-abundance
  histograms, but a diamond-local interval readout differs;
- T2: add a pre-specified coarse map and prove equivariance/stability;
- T3: add a noise class and prove the diamond-local separation survives
  geometry-blind external noise.

## Submitted P9 diamond-local separation proof job

Submitted focused Aristotle project:

- `04524791-1cc4-4ccc-816d-e0d278a7e770`
  (`task_id: 347422a5-12b0-4e8e-b9b2-055f09d95ac7`)
  `null-edge-p9-diamond-local-separation-20260623`

Targets:

- `relA_irreflexive`
- `relA_transitive`
- `relB_irreflexive`
- `relB_transitive`
- `same_jointDegreeSignature`
- `same_intervalSignature`
- `diamondCard_relA_0_4`
- `diamondCard_relB_0_4`
- `localIntervalSignature_relA_0_4_at_one`
- `localIntervalSignature_relB_0_4_at_one`
- `localIntervalSignature_0_4_separates`

Scientific role: this is the stronger T1 witness. Two six-point strict
transitive relations have the same joint in/out-degree signature and same
global interval-abundance signature. The chosen diamond from `0` to `4` has
the same cardinality in both relations, but the local interval-size signature
differs. This is much closer to an observer-channel separator than the cheap
global marginals-vs-joint witness.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623/NullEdgeP9DiamondLocalSeparation/Core.lean
```

The preflight passed with exactly eleven intended proof-hole warnings; non-ASCII
and escape-hatch scans were clean.

## Integrated P9 iso-histogram sanity witness

Integrated Aristotle project:

- `66f5c60f-a1db-4764-8e42-8ff665ebd271`
  (`task_id: a3bf2e9e-8627-4563-b79a-ac6735521231`)
  `null-edge-p9-isohistogram-separation-20260623`

Live module:

- `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`

Banked theorem cluster:

- `relA_irreflexive`
- `relA_transitive`
- `relB_irreflexive`
- `relB_transitive`
- `same_outDegreeSignature`
- `same_inDegreeSignature`
- `same_intervalSignature`
- `jointReadout21_relA`
- `jointReadout21_relB`
- `jointReadout21_separates`

Scientific role: this is a low-weight guardrail, not a P9 flagship theorem.
It proves that separate in-degree, out-degree, and interval-abundance histograms
do not determine a frozen joint in/out-degree readout. The result justifies the
stricter T1/T2/T3 ladder, but it does not by itself show source visibility,
coarse stability, or cosmological leverage.

Verification:

```text
git diff --no-index -- AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623/NullEdgeP9IsohistogramSeparation/Core.lean AgentTasks/aristotle-output/66f5c60f-a1db-4764-8e42-8ff665ebd271/extracted/project-files.tar/null-edge-p9-isohistogram-separation-20260623-project_aristotle/NullEdgeP9IsohistogramSeparation/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9IsohistogramSeparation.lean
lake build PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9IsohistogramSeparation.lean AgentTasks/null-edge-p9-isohistogram-separation-aristotle-2026-06-23.md
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9IsohistogramSeparation.lean AgentTasks/null-edge-p9-isohistogram-separation-aristotle-2026-06-23.md
```

Next action: check and integrate the stronger diamond-local T1 witness if
Aristotle completes it successfully.

## Literature/semantic pass: P9 coarse-map stability

Ran local semantic searches for P9 coarse-map stability, diamond-local interval
signatures, and source-visibility observer channels.

Commands:

```text
$env:PYTHONIOENCODING='utf-8'; $py='C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe'; & $py Scripts/lit/neo4j_doc_search.py --query 'P9 coarse map stability equivariant Alexandrov spectral coarse graining diamond local interval signature observer channel source visibility'
$py='C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe'; & $py Scripts/lit/neo4j_paper_search.py --query 'causal set observables coarse graining interval abundance spectral Laplacian coarse graining source visibility cosmological constant'
```

Useful hits:

- `RC5XF8RD`, causal-set graph observables, remains the main guardrail for
  intrinsic interval/degree/Laplacian diagnostics.
- `AN5RZGJZ` and `UR5ADCBP`, Laplacian renormalization / Laplacian coarse
  graining, support making T2 a stability/equivariance test for an explicit
  coarse map rather than demanding fine-grained continuum behavior.
- `G3FT8BXC`, `K5CFI3HI`, and `IHVSDGUC` remain the P9 cosmological-constant
  collision sources: finite P9 filtering is interesting only if it gives a
  structural mean-zero/noise-channel mechanism, not just another fluctuating
  Lambda slogan.

No new Zotero additions were needed in this pass because the key papers are
already present in the null-edge paper index.

## Submitted P9 coarse-map erasure guardrail

Submitted focused Aristotle project:

- `748e6c8d-509e-49de-b022-758c8b921ba6`
  `null-edge-p9-coarse-map-erasure-guardrail-20260623`

Targets:

- `coarseRel_equal_implies_localSignature_equal`
- `collapseCritical_identifies_swapped_vertices`
- `collapseCritical_preserves_endpoints`
- `collapseCritical_coarseRel_eq`
- `collapseCritical_diamondCard_eq`
- `collapseCritical_localIntervalSignature_eq`
- `collapseCritical_erases_T1_at_one`

Scientific role: this is a T2 failure-control theorem. It does not claim that
the P9 observer channel is stable under coarse graining. It proves the opposite
guardrail for a natural critical-collapse map: coarse preprocessing can erase
the T1 diamond-local separator. The upshot is that every positive P9 coarse
map must be pre-specified and tested; stability cannot be assumed from the
finite separation witness alone.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-coarse-map-erasure-guardrail-20260623-project/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
```

Both Lean checks passed with exactly seven intended proof-hole warnings; the
non-ASCII scan was clean.

## Integrated P9 diamond-local T1 separation witness

Integrated Aristotle project:

- `04524791-1cc4-4ccc-816d-e0d278a7e770`
  (`task_id: 347422a5-12b0-4e8e-b9b2-055f09d95ac7`)
  `null-edge-p9-diamond-local-separation-20260623`

Live module:

- `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`

Banked theorem cluster:

- `relA_irreflexive`
- `relA_transitive`
- `relB_irreflexive`
- `relB_transitive`
- `same_jointDegreeSignature`
- `same_intervalSignature`
- `diamondCard_relA_0_4`
- `diamondCard_relB_0_4`
- `localIntervalSignature_relA_0_4_at_one`
- `localIntervalSignature_relB_0_4_at_one`
- `localIntervalSignature_0_4_separates`

Scientific role: this is the first genuinely useful P9 T1 witness. The two
six-point strict transitive relations match joint in/out-degree and global
interval-abundance signatures. The diamond from `0` to `4` has cardinality
four in both, but the local interval-size signature differs. This is stronger
than the cheap `Fin 5` marginals-vs-joint witness because the separation is
diamond-local and survives common global signature controls. It is still not
source-visibility physics without T2 coarse-map stability and T3 noise
robustness.

Review notes:

- Aristotle reported no statement or definition changes and no remaining proof
  holes.
- The extracted proof used Unicode logical symbols in two local helper
  statements; the integrated file normalizes those proof bodies to ASCII.

Verification:

```text
aristotle show 04524791-1cc4-4ccc-816d-e0d278a7e770 --limit 100
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-diamond-local-separation-aristotle-2026-06-23.md 04524791-1cc4-4ccc-816d-e0d278a7e770
git diff --no-index -- AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623/NullEdgeP9DiamondLocalSeparation/Core.lean AgentTasks/aristotle-output/04524791-1cc4-4ccc-816d-e0d278a7e770/extracted/project-files.tar/null-edge-p9-diamond-local-separation-20260623-project_aristotle/NullEdgeP9DiamondLocalSeparation/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean
lake build PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean AgentTasks/null-edge-p9-diamond-local-separation-aristotle-2026-06-23.md
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean AgentTasks/null-edge-p9-diamond-local-separation-aristotle-2026-06-23.md
```

Next action: integrate the coarse-map erasure guardrail if Aristotle completes
it, then design the positive admissible coarse-map class carefully rather than
hand-tuning a preserving map.

## Integrated P9 coarse-map erasure guardrail

Integrated Aristotle project:

- `748e6c8d-509e-49de-b022-758c8b921ba6`
  (`task_id: 2fc5836a-227c-4fb2-939a-d1d50b9f0c7f`)
  `null-edge-p9-coarse-map-erasure-guardrail-20260623`

Live module:

- `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`

Banked theorem cluster:

- `coarseRel_equal_implies_localSignature_equal`
- `collapseCritical_identifies_swapped_vertices`
- `collapseCritical_preserves_endpoints`
- `collapseCritical_coarseRel_eq`
- `collapseCritical_diamondCard_eq`
- `collapseCritical_localIntervalSignature_eq`
- `collapseCritical_erases_T1_at_one`

Scientific role: this is the negative T2 guardrail. It proves that the
diamond-local T1 separator is not automatically stable under coarse graining:
the explicit map collapsing the critical swapped vertices makes the coarse
relations, diamond cardinalities, local interval signatures, and the readout at
`1` agree. This is exactly the kind of falsification control we want: positive
T2 preservation now has to name a pre-specified admissible coarse-map class.

Review notes:

- Aristotle reported no statement or definition changes and no remaining proof
  holes.
- The extracted proof contained a mojibake arrow in the final congruence helper
  and no final newline; the integrated file normalizes those proof bodies to
  ASCII.
- The helper hit the known Windows extraction issue for a bundled task note, so
  integration used manual diff inspection.

Verification:

```text
aristotle show 748e6c8d-509e-49de-b022-758c8b921ba6 --limit 100
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-coarse-map-erasure-guardrail-aristotle-2026-06-23.md 748e6c8d-509e-49de-b022-758c8b921ba6
git diff --no-index -- AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623/NullEdgeP9CoarseMapErasureGuardrail/Core.lean AgentTasks/aristotle-output/748e6c8d-509e-49de-b022-758c8b921ba6/extracted/project-files.tar/null-edge-p9-coarse-map-erasure-guardrail-20260623-project_aristotle/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean
lake build PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean
```

Next action: submit the T3 diamond-locality/noise-invariance theorem, which
formalizes that external relation changes cannot affect the local interval
signature when closed-diamond membership and internal diamond relation data are
held fixed.

## Submitted P9 diamond-locality/noise-invariance theorem

Submitted focused Aristotle project:

- `5d92d60b-eeb0-48b2-99ea-642040c54bf9`
  `null-edge-p9-diamond-locality-noise-invariance-20260623`

Targets:

- `localIntervalCard_eq_of_diamond_local_agreement`
- `localIntervalAbundance_eq_of_diamond_local_agreement`
- `localIntervalSignature_eq_of_diamond_local_agreement`

Scientific role: this is the clean T3 locality/noise-invariance theorem. It
abstracts the diamond-local readout away from the small witnesses: if two finite
relations have the same closed diamond and agree on all relation entries among
vertices in that diamond, then the local interval-size signature is identical.
This is the formal statement that external geometry-blind relation noise cannot
affect a frozen local observer channel when it does not change the measured
diamond.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-locality-noise-invariance-20260623/NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
lake env lean AgentTasks/aristotle-submit/null-edge-p9-diamond-locality-noise-invariance-20260623-project/NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-diamond-locality-noise-invariance-20260623/NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
```

Both Lean checks passed with exactly three intended proof-hole warnings; the
non-ASCII scan was clean.

## Submitted P9 positive T2 coarse-map strategy job

Submitted no-code Aristotle strategy project:

- `412b3682-fc82-47fb-abaf-fe5465a3d201`
  `null-edge-p9-positive-t2-coarse-map-strategy-20260623`

Prompt:

- `AgentTasks/aristotle-strategy-packs/null-edge-p9-positive-t2-coarse-map-strategy-20260623/PROMPT.md`

Scientific role: after banking the T1 diamond-local separator and the negative
T2 critical-collapse erasure guardrail, this asks Aristotle to propose the next
positive admissible coarse-map class. The requested output is a ranked theorem
scaffold, not Lean code, with explicit warnings against hand-tuned preserving
maps.

## Spark/literature triage: admissible positive T2 coarse maps

Spark/Sartre produced:

- `AgentTasks/spark-p9-positive-t2-coarse-map-literature-triage-2026-06-23.md`

Local paper search also returned the same main anchors:

- `RC5XF8RD`: causal-set graph observables, especially interval abundance and
  intrinsic order diagnostics.
- `AN5RZGJZ`, `UR5ADCBP`, `RA8QNNKW`: Laplacian renormalization/coarse graining
  as the mathematical template for a fixed spectral/Hodge coarse map.
- `PTU4XM4U`: graph reduction/spectral-cut style guarantees, useful for
  observer-forced graph-reduction controls.

Triage result:

- C1 Alexandrov/subdiamond restriction is the most publishable/physics-facing
  class because it is closest to causal-set order geometry.
- C2 spectral/Hodge projector maps are the most Lean-friendly next theorem
  class because the repo already has finite projector, PSD, Hodge, and
  boundary-invariance scaffolds.
- C3 fixed graph-reduction maps are useful for pilots but need strict
  admissibility metadata to avoid post-hoc block alignment.

No new Zotero/Neo4j additions were needed; all cited anchors are already in the
null-edge index.

Meta-analysis: the Lean-friendly C2 route is partly already banked. In
particular, `PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD` proves that coarse
response for `R K R^T` equals fine response against the pulled-back test and
that PSD kernels stay PSD. `PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel`
proves the analogous projection identity. The next positive T2 theorem should
therefore not duplicate generic PSD transport; it should connect a fixed
coarse map or projector to the diamond-local observable and include a
nontriviality/admissibility condition that rules out the critical-collapse
erasure guardrail.

## Integrated P9 diamond-locality/noise-invariance theorem

Integrated focused Aristotle project:

- `5d92d60b-eeb0-48b2-99ea-642040c54bf9`
  `null-edge-p9-diamond-locality-noise-invariance-20260623`

Live module:

- `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance`

Task note:

- `AgentTasks/null-edge-p9-diamond-locality-noise-invariance-aristotle-2026-06-23.md`

Theorems integrated:

- `localIntervalCard_eq_of_diamond_local_agreement`
- `localIntervalAbundance_eq_of_diamond_local_agreement`
- `localIntervalSignature_eq_of_diamond_local_agreement`

Scientific role: this is the banked T3 locality/noise guardrail. If two finite
relations have the same closed diamond and agree on every relation entry among
vertices in that diamond, then the local interval-size signature is identical.
External relation noise cannot affect the frozen diamond-local observer channel
unless it changes the measured diamond membership or the internal relation data.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondLocalityNoiseInvariance.lean
lake build PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance
lake env lean PhysicsSMDraft.lean
```

## Reviewed P9 positive T2 coarse-map strategy

Completed no-code Aristotle strategy project:

- `412b3682-fc82-47fb-abaf-fe5465a3d201`
  `null-edge-p9-positive-t2-coarse-map-strategy-20260623`

Task:

- `e005b18e-1c9e-448c-bafa-5cdc56075a00`

Report:

- `AgentTasks/aristotle-output/412b3682-fc82-47fb-abaf-fe5465a3d201/extracted-strategy/null-edge-p9-positive-t2-coarse-map-strategy-20260623_aristotle/P9_PositiveT2_CoarseMap_Strategy.md`

Scientific result: Aristotle selected Class A, Alexandrov endpoint-preserving
subdiamond restriction, as the best positive T2 proof target. The backup routes
are interval-rank threshold filtration as a scale-window dichotomy and
spectral/Laplacian projection as an expected no-go or weighted-rescue theorem.

Next proof package:

- `NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`
- primary lemmas `subdiamond_convex`,
  `subdiamond_restriction_preserves_ic`, and
  `subdiamond_restriction_preserves_localIntervalSignature`
- follow-up finite witness corollary
  `NullEdgeP9SubdiamondRestrictionSeparatesWitness`

Guardrail: the endpoint rule must be fixed before comparing the T1 pair and
should be intrinsic/order-isomorphism-invariant or explicitly observer-forced.
The positive theorem should be contrasted with the banked critical-collapse
erasure guardrail so the preservation result is not hand-tuned.

## Submitted P9 subdiamond restriction positive-T2 proof job

Submitted focused Aristotle project:

- `a46df819-3986-4fb0-a404-c441aaaf9653`
  `null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623`

Task:

- `7e27b984-0f9b-4cce-a631-85911429833b`

Standalone source:

- `AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean`

Submission project:

- `AgentTasks/aristotle-submit/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623-project`

Targets:

- `subdiamond_convex`
- `subdiamond_restriction_preserves_ic`
- `subdiamond_restriction_preserves_localIntervalAbundance`
- `subdiamond_restriction_preserves_localIntervalSignature`

Scientific role: this is the first positive T2 Class A theorem package. It
formalizes the order-theoretic claim that Alexandrov/subdiamond restriction is
an admissible observer-forced coarse map: subdiamonds are convex under a
transitive causal relation, and the local interval readout restricted to a
subdiamond agrees with direct measurement in that subdiamond. If solved, it
will be the positive companion to the banked critical-collapse erasure
guardrail.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean AgentTasks/null-edge-p9-subdiamond-restriction-preserves-local-readout-aristotle-2026-06-23.md
```

The standalone source check passed with exactly four intended proof holes and
the non-ASCII scan was clean. A packaged-project local check failed only because
the new focused Lake project had no built Mathlib oleans after dependency clone;
the generated `.lake` directory was removed before upload.

## Locally integrated P9 subdiamond restriction positive-T2 theorem

Codex completed the submitted Class A theorem locally before Aristotle returned,
then canceled Aristotle task `7e27b984-0f9b-4cce-a631-85911429833b` in project
`a46df819-3986-4fb0-a404-c441aaaf9653` to avoid spending proof budget twice on
the same finite order-theory lemma.

Live module:

- `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`

Imported in:

- `PhysicsSMDraft.lean`

Theorems proved:

- `subdiamond_convex`
- `subdiamond_restriction_preserves_ic`
- `subdiamond_restriction_preserves_localIntervalAbundance`
- `subdiamond_restriction_preserves_localIntervalSignature`

Scientific role: this is the first positive T2 Class A theorem. It proves that
Alexandrov/subdiamond restriction is a preserving observer-forced coarse map for
the local interval-size readout under a transitive causal relation. It is the
positive companion to the banked critical-collapse erasure guardrail, and it
turns P9's coarse-map question from "some maps erase the signal" into "the
admissible class matters."

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean
lake build PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout
lake env lean PhysicsSMDraft.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean AgentTasks/null-edge-p9-subdiamond-restriction-preserves-local-readout-aristotle-2026-06-23.md
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
```

Follow-up: instantiate this generic preservation theorem on the six-point T1
witness, or prove the Class B interval-rank threshold dichotomy if the witness
instantiation is too tautological.
## 2026-06-23 continuation: P9/P7 focused restart

Queue check:

- `aristotle list --limit 30` showed the recent queue mostly `IDLE`, with the
  newest P9 cluster already locally integrated or recorded.
- Verified the high-value P9 T1/T2/T3 modules rather than duplicating them:
  - `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`
  - `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`
  - `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`
  - `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance`
  - `PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal`
  - `PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark`

Verification run:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean
lake env lean PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondLocalityNoiseInvariance.lean
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedProjectorResidualOrthogonal.lean
lake env lean PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
```

All six targeted checks passed.

Literature/semantic pass:

- Ran local semantic searches for P9 source visibility, Alexandrov/subdiamond
  coarse maps, interval abundance, causal-set graph observables, and
  everpresent-Lambda comparison.
- Useful local hits were already indexed: `RC5XF8RD`, `AN5RZGJZ`, `UR5ADCBP`,
  `G3FT8BXC`, `K5CFI3HI`, and `IHVSDGUC`.
- External scholarly fallback: OpenAlex returned Surya's causal-set review
  (`10.1007/s41114-019-0023-1`), already conceptually covered; Crossref results
  were mostly generic coarse-graining or unrelated molecular papers. arXiv
  meta-search hit rate limits and INSPIRE timed out. No new Zotero additions.

Model/subagent use:

- Spark/Dewey triaged the recent Aristotle queue. It correctly identified the
  P9 T1/T2/T3 cluster as the highest-value integration surface and confirmed
  the updated overnight plan already contains mandatory physics context,
  Aristotle next-step requests, Gemini/Claude alternation, scoring, and priority
  refreshes.
- Gemini CLI attempt failed with a socket/API error after noisy workspace
  scanning. No scientific guidance used.
- Claude bare adversarial critique succeeded. Main useful guidance: demote T3
  unless "external" noise is independently characterized, require quantitative
  visibility/lower-bound packaging for T1, and prioritize the observer-channel
  theorem that determinant mass does not reconstruct hidden coherence.

Fresh Aristotle submissions:

- `9beafa4e-1932-4276-8aeb-59bea669c6ac`
  `null-edge-p9-operational-gap-20260623`, task
  `87d5fc11-bb04-4c75-9a76-cb5673faa476`, status `RUNNING`.
  Scientific value: packages the T1 diamond-local separation as an explicit
  operational readout gap.
- `c8076caa-ae7f-4bb0-99d2-0856f5bfe786`
  `null-edge-p7-coherence-not-determined-by-det-20260623`, task
  `855b5ab6-6047-4324-ad6a-2716922a2380`, status `RUNNING`.
  Scientific value: finite counterexample showing trace-one determinant mass
  does not determine off-diagonal chirality coherence.

Next actions:

- Integrate the two running jobs when they become `IDLE`.
- If the P7 counterexample succeeds, submit the positive-semidefinite companion
  so the witness lives inside the intended physical density class.
- If the P9 operational gap succeeds, submit a follow-up T2 quantitative
  preservation/erasure threshold rather than another qualitative scaffold.

## 2026-06-23 continuation: fresh job integration

Integrated fresh Aristotle/local jobs:

- `9beafa4e-1932-4276-8aeb-59bea669c6ac`
  `null-edge-p9-operational-gap-20260623`, task
  `87d5fc11-bb04-4c75-9a76-cb5673faa476`.
  Integrated as `PhysicsSM.Draft.NullEdgeP9OperationalGap`.
  Result: the T1 diamond-local separation witness now has an explicit
  operational readout gap at bucket `1`.
- `c8076caa-ae7f-4bb0-99d2-0856f5bfe786`
  `null-edge-p7-coherence-not-determined-by-det-20260623`, task
  `855b5ab6-6047-4324-ad6a-2716922a2380`.
  Integrated as `PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet`.
  Result: two trace-one real symmetric density proxies have the same determinant
  but different squared off-diagonal coherence.

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-operational-gap-20260623/NullEdgeP9OperationalGap/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9OperationalGap.lean
lake build PhysicsSM.Draft.NullEdgeP9OperationalGap
lake env lean AgentTasks/aristotle-standalone/null-edge-p7-coherence-not-determined-by-det-20260623/NullEdgeP7CoherenceNotDeterminedByDet/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean
lake build PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet
lake env lean PhysicsSMDraft.lean
```

Low-token integration notes:

- `Scripts/aristotle/integrate_completed.py` fetched both jobs, but focused
  standalone packages do not auto-map as `PhysicsSM/...` candidates.
- The helper also hit the known nested-path extraction issue on the P7 job after
  the useful files had already been extracted.
- Diff review confirmed Aristotle changed proof bodies only; Codex adapted the
  P9 proof to ASCII `Fin.mk` syntax before integrating.

Next high-value follow-ups:

- P7: positive-semidefinite / trace-one companion for the coherence
  counterexample.
- P9: quantitative T2 threshold showing when the operational gap survives,
  shrinks, or is erased under a pre-specified coarse map.

## 2026-06-23 continuation: local guardrails and audit submission

Local finite theorem progress:

- Extended `PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet` with
  `psdProxy` and
  `determinant_does_not_determine_coherenceSq_in_densityClass`.
  Role: the same-det different-coherence witness now lives in a conservative
  trace-one positive-semidefinite proxy class, not merely in arbitrary
  trace-one symmetric matrices.
- Extended the same P7 module with `tracePair`, `offDiagReadout`, and
  `determinant_does_not_determine_operationalReadout_in_densityClass`.
  Role: the determinant/coherence gap is operationally separable by an explicit
  off-diagonal finite readout, not merely by inspecting a hidden coordinate.
- After Aristotle's audit, strengthened the P7 separator again with
  `effectProxy`, `xBasisEffect`, and
  `determinant_does_not_determine_positiveEffectReadout_in_densityClass`.
  Role: the same-det different-coherence pair is separated by a bounded
  X-basis-style positive effect, a cleaner finite POVM-style witness.
- Added `determinant_does_not_determine_twoOutcomeReadout_in_densityClass`.
  Role: the positive effect plus its complement sums to the trace-one total, so
  the witness is now a two-outcome finite readout proxy rather than a single
  free linear functional.
- Added `PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap`.
  Role: packages the T2 erasure guardrail operationally; the named critical
  coarse map sends the bucket-`1` gap to zero and fails threshold-one
  distinguishability.
- Added `PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity`.
  Role: answers the adversarial vacuity critique by proving the proper
  subdiamond `(0,3)` still separates the two six-point histories by the local
  signature readout.

External model escalation:

- Gemini constructive query succeeded after moving out of the repo working
  directory. Its most useful suggestion was a coarse-map/decoherence bridge,
  but it overreached by assuming geometric coarse maps should determine the
  `2 x 2` coherence proxies. Provisional score: 5/10.
- Claude adversarial query identified three sharper finite tests: coarse-map
  universality, subdiamond non-vacuity, and operational distinguishability of
  the P7 coherence gap. The subdiamond non-vacuity test was immediately
  validated by finite search and Lean proof. Provisional score: 8/10.

Aristotle submission:

- Submitted no-code adversarial audit project
  `080f98c5-8d0c-4ae6-9967-d63d8ab86528`, task
  `da56c47e-a08a-4411-b59a-e7f4f0dc29ac`.
  Task note:
  `AgentTasks/null-edge-p9-p7-operational-adversarial-audit-aristotle-2026-06-23.md`.
  Role: ask Aristotle to rank the next P9/P7 theorem targets after the local
  operational-gap, coarse-map erasure, non-vacuity, and density-class
  coherence guardrails.
- Integrated the audit substance into the task note. Main useful outputs:
  strongest next P9 target is a coarse-map dichotomy/negative-class test, and
  strongest P7 polishing target is a positive X-basis effect separator. The P7
  separator is now locally banked.
- Local finite search found that the strongest P9 dichotomy is false for all
  surjective `Fin 6 -> Fin 5` maps: the map
  `0,1,2,3,4,5 |-> 0,1,2,3,3,4` keeps the critical pair `1,2` distinct while
  erasing the bucket-one local signature. This is a useful demotion guardrail:
  P9 must name an admissible coarse-map class.
- Submitted focused Aristotle proof job
  `fc1b0531-466f-4dec-93e6-d983f1024e56`, task
  `66649453-d495-43c1-b6d1-5c3c455a8af8`, to formalize that noncritical
  coarse-erasure counterexample without importing a broken draft module.
- Integrated the completed proof as
  `PhysicsSM.Draft.NullEdgeP9NoncriticalCoarseErasure`.
  Result: `nonCriticalErasingMap_is_noncritical_erasure` proves that the map
  `0,1,2,3,4,5 |-> 0,1,2,3,3,4` keeps the critical pair `1,2` distinct but
  erases the bucket-one local signature after induced coarse relation. This
  demotes unrestricted surjective coarse-map universality and forces P9 to
  specify an admissible coarse-map/observer-channel class.

Verification run so far:

```text
lake env lean PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean
lake env lean PhysicsSM/Draft/NullEdgeP9OperationalGapCoarseMap.lean
lake env lean PhysicsSM/Draft/NullEdgeP9SubdiamondNonvacuity.lean
lake env lean PhysicsSMDraft.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
```

Next actions:

- Poll and integrate the Aristotle audit result.
- Add docs references for the new P7 density-class guardrail and P9
  non-vacuity/erasure wrappers.
- Run `lake env lean PhysicsSMDraft.lean` after the aggregate import settles.

## 2026-06-23 continuation: verification and strategy triage

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean
lake env lean PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
lake build PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet PhysicsSM.Draft.NullEdgeP9NoncriticalCoarseErasure PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean PhysicsSM/Draft/NullEdgeP9OperationalGap.lean PhysicsSM/Draft/NullEdgeP9OperationalGapCoarseMap.lean PhysicsSM/Draft/NullEdgeP9SubdiamondNonvacuity.lean PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean PhysicsSM/Draft/NullEdgeP9OperationalGap.lean PhysicsSM/Draft/NullEdgeP9OperationalGapCoarseMap.lean PhysicsSM/Draft/NullEdgeP9SubdiamondNonvacuity.lean PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
git diff --check
```

Outcome: all checks passed after repairing the P7 two-outcome theorem proof to
avoid invalid generated case tags.

Aristotle completion triage:

- Spark triage found one non-integrated-looking item:
  `AgentTasks/null-edge-p11-channel-sector-strategy-aristotle-2026-06-23.md`
  (`40413c03-ef9e-4692-be1e-7a60df4ce689`), plus several already-reviewed P9
  strategy notes.
- Reviewed the P11 strategy output. The returned scaffold is useful but the
  extracted source/report contains mojibake in physics notation, so it was not
  copied into the repo.
- Integrated the substance into the task note and marked it
  `strategy-reviewed`. Main lesson: a P11 particle-sector model must keep a
  calibrated readout containing both normalized celestial state and discarded
  trace/energy scale; normalized channel output alone cannot define invariant
  mass.

Scientific significance:

- Publication-value score `2`: useful guardrail for ontology/P11, but lower
  priority than the active P7/P1 observer-channel theorem and P9 admissible
  coarse-map/source-visibility lane.

Next action:

- Submit at most one high-value follow-up proof job after the focused
  literature/model triage returns, prioritizing either an observer-channel
  relative-entropy/readout theorem or an admissible P9 coarse-map theorem.

## 2026-06-23 late loop: admissible coarse-map job

Literature/model triage:

- Spark/Lovelace docs triage highlighted already-cited P7/P9 references and
  confirmed the claim boundary: keep recoverability/invisibility one-way, keep
  visible determinant and diamond-source branches distinct, and require a
  formal admissible coarse-map hypothesis before any T2 non-erasure theorem.
- Gemini constructive analysis proposed using P7 information preservation to
  define a P9 safe coarse-map class.
- Claude adversarial analysis sharpened the target away from raw KL equality
  toward common exact recovery, because exact recovery is constructive and
  avoids zero-support pitfalls.

Fresh Aristotle submission:

- Submitted focused proof job
  `406f955e-dbb7-45a4-9e64-66d4ffb9cde5`, task
  `e1a1b690-1250-411a-8885-9e46d1181562`.
  Task note:
  `AgentTasks/null-edge-p9-exact-recovery-admissible-coarse-map-aristotle-2026-06-23.md`.
  Target:
  `exactRecovery_pullsBack_distinguishingTest`.
  Scientific value: defines a constructive admissible coarse-map guardrail for
  P9. If a common recovery map restores both fine sources, every selected fine
  distinguishing test pulls back to a coarse observer test. This is a positive
  counterpart to the noncritical coarse-erasure counterexample.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-exact-recovery-admissible-coarse-map-20260623/NullEdgeP9ExactRecoveryAdmissibleCoarseMap/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-exact-recovery-admissible-coarse-map-20260623/NullEdgeP9ExactRecoveryAdmissibleCoarseMap/Core.lean AgentTasks/null-edge-p9-exact-recovery-admissible-coarse-map-aristotle-2026-06-23.md
```

Outcome: source file typechecks with exactly one intended proof hole and no
non-ASCII in the staged file/task note.

Local integration while Aristotle runs:

- Added `PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap`.
- Proved locally:
  - `exactRecovery_preserves_distinction`;
  - `erased_distinction_not_exactRecoverable`;
  - `exactRecovery_pullsBack_distinguishingTest`.
- Imported the module in `PhysicsSMDraft.lean`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
lake build PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
```

Outcome: all passed. Aristotle job remains useful for an independent proof
check and its requested next-step recommendations.

Aristotle completion:

- `406f955e-dbb7-45a4-9e64-66d4ffb9cde5`, task
  `e1a1b690-1250-411a-8885-9e46d1181562`, completed.
- Aristotle solved `exactRecovery_pullsBack_distinguishingTest` with unchanged
  theorem statement and no assumptions or escape hatches.
- The extracted Aristotle proof used non-ASCII syntax in the standalone
  namespace, so the already-integrated ASCII repo module remains the live
  source.
- Useful next-step guidance: continue the lane; add a composition lemma for
  admissible/recoverable channels; add a no-go check against known erasing
  maps; and strengthen the abstract channel shell with genuine stochastic
  positivity/normalization before advertising an information-theoretic recovery
  result.

Scientific significance:

- Publication-value score `3`: this supplies the first positive
  information-theoretic admissibility certificate for P9 coarse maps, paired
  with the existing erasure counterexamples.

Follow-up Aristotle submission:

- Submitted focused proof job
  `6ba5e2b1-389a-47e6-b784-d225d691868e`, task
  `c88eab9e-03ff-4ac8-93a4-e99446d0f348`.
  Task note:
  `AgentTasks/null-edge-p9-stochastic-exact-recovery-observable-pullback-aristotle-2026-06-23.md`.
  Target:
  `exactRecovery_pullsBack_distinguishingObservable`.
  Scientific value: upgrades the algebraic exact-recovery guardrail to finite
  normalized distributions, column-stochastic observer channels, and observable
  expectations.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623/NullEdgeP9StochasticExactRecoveryObservablePullback/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623/NullEdgeP9StochasticExactRecoveryObservablePullback/Core.lean AgentTasks/null-edge-p9-stochastic-exact-recovery-observable-pullback-aristotle-2026-06-23.md
```

Outcome: source file typechecks with exactly three intended proof holes and no
non-ASCII in the staged file/task note.

Local integration while Aristotle runs:

- Added `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback`.
- Proved:
  - stochastic pushforward normalization for finite distributions;
  - `expect_pullbackObservable_eq_expect_recovered`;
  - `exactRecovery_pullsBack_distinguishingObservable`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `3`: this upgrades the P9 admissible coarse-map
  theorem from an abstract channel/test shell to normalized finite
  distributions, column-stochastic observer channels, and observable
  expectations. It is now a genuine finite stochastic exact-recovery guardrail:
  if a coarse observer channel has a common stochastic recovery for two fine
  source distributions, every fine observable that distinguishes the sources
  pulls back to a coarse observable distinguishing the coarse outputs.

Verification:

```text
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryObservablePullback.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryObservablePullback.lean
git diff --check
```

Outcome: all passed. A first parallel `PhysicsSMDraft.lean` check raced the
targeted build and failed because the new `.olean` did not yet exist; the rerun
after the targeted build passed.

Open Aristotle status:

- `6ba5e2b1-389a-47e6-b784-d225d691868e`, task
  `c88eab9e-03ff-4ac8-93a4-e99446d0f348`, remained running at the time of
  local integration. Use it for independent proof comparison and requested
  next-step guidance when complete.

Aristotle completion:

- `6ba5e2b1-389a-47e6-b784-d225d691868e`, task
  `c88eab9e-03ff-4ac8-93a4-e99446d0f348`, completed.
- Aristotle reported unchanged theorem statements, no remaining proof holes,
  no added assumptions, and no escape hatches.
- Returned code was not copied because it used the standalone namespace and
  Unicode Lean notation; the verified ASCII repo module remains the source of
  record.
- Useful next-step guidance: prove quantitative gap preservation for the
  pulled-back observable, test that `col_sum` is load-bearing, and audit
  channel/recovery orientation against the P7 Petz/data-processing scaffold.

## 2026-06-23 late loop: stochastic recovery composition

Spark/Pasteur source triage:

- Judged stochastic exact-recovery composition scientifically meaningful rather
  than mere bookkeeping, because it is the closure property needed for an
  admissible observer-channel class.
- Relevant prior-art neighborhood: finite Markov kernels, Blackwell
  sufficiency/comparison of experiments, Le Cam/Torgersen randomization, Petz
  recovery, and data-processing equality.
- Recommendation: continue the lane, while keeping the theorem source-pair
  scoped and explicitly excluding the known erasing-map counterexamples.

Fresh Aristotle submission:

- Submitted focused proof job
  `53d2e069-8b2e-4478-8c25-53282f26b36b`, task
  `5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0`.
  Task note:
  `AgentTasks/null-edge-p9-stochastic-exact-recovery-composition-aristotle-2026-06-23.md`.
  Target:
  `Stoch.apply_comp` and `PairExactRecoverable.comp`.
  Scientific value: proves that the exact stochastic admissible observer-channel
  class is closed under composition on the selected source pair, making the
  P9 positive class structurally usable.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
```

Outcome: source file typechecks with exactly two intended proof holes and no
non-ASCII in the staged file.

Local integration while Aristotle runs:

- Added `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition`.
- Proved:
  - `FinDist.ext`;
  - `Stoch.comp`;
  - `Stoch.apply_comp`;
  - `PairExactRecoverable.comp`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `3`: exact stochastic recovery is now closed under
  composition on the selected source pair. This makes the exact-recovery
  admissible observer-channel class structurally usable, rather than a one-off
  witness, while keeping the claim boundary finite and exact.

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryComposition.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition
lake env lean PhysicsSMDraft.lean
git diff --check
```

Outcome: all passed. Aristotle job
`53d2e069-8b2e-4478-8c25-53282f26b36b`, task
`5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0`, remained in progress at local
integration time and should be used for independent proof comparison and
next-step advice when complete.

Aristotle completion:

- `53d2e069-8b2e-4478-8c25-53282f26b36b`, task
  `5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0`, completed.
- Aristotle independently solved `Stoch.apply_comp` and
  `PairExactRecoverable.comp`, reported unchanged theorem statements, no proof
  holes, no added assumptions, and no escape hatches.
- The live repo module was kept instead of copying returned code because it is
  ASCII-clean and extends the existing stochastic API instead of duplicating it.
- Useful next-step guidance: prove associativity/functoriality of `Stoch.comp`,
  test that erasing channels are not recoverable for separated pairs, and decide
  whether P9 requires fixed-pair or family-uniform recoverability.

Follow-up Aristotle submission:

- Submitted focused proof job
  `ebd742af-00c2-45eb-9bf1-51e775195ed4`, task
  `6417d07e-520e-4db9-adf7-08e258f4de66`.
  Task note:
  `AgentTasks/null-edge-p9-stochastic-exact-recovery-gap-aristotle-2026-06-23.md`.
  Target:
  `exactRecovery_preserves_observableGap`.
  Scientific value: sharpens the stochastic pullback theorem from qualitative
  non-equality preservation to exact preservation of the numerical expectation
  gap under common exact recovery.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
```

Outcome: source file typechecks with exactly one intended proof hole and no
non-ASCII in the staged file.

## 2026-06-23 late loop: P2 partial-dephasing rate scaffold

Local Lean integration:

- Added `PhysicsSM.Draft.NullEdgeP2PartialDephasingRateBridge`.
- Proved exact one-step identities for the real two-level chiral proxy
  `[[q,c],[c,1-q]]` under partial dephasing `c |-> a*c`:
  - `partialDephasing_det_gap`;
  - `partialDephasing_purity_loss`;
  - `partialDephasing_massRatioSq_gap`;
  - `partialDephasing_det_monotone`;
  - `partialDephasing_purity_antitone`;
  - `partialDephasing_massRatioSq_monotone`;
  - `partialDephasing_massRatioSq_strict`.
- Extended the same module with:
  - `iteratedPartialDephasing_massRatioSq_gap`;
  - `iteratedPartialDephasing_massRatioSq_monotone`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `2`: this is still a one-step finite channel theorem,
  not a continuum dynamics result. It nevertheless directly upgrades the P7/P1
  observer-channel story from a scalar rewrite to a named dephasing-channel
  increment law: dephasing increases determinant/mass-ratio-square exactly by
  the lost squared coherence. The iterated theorem upgrades this to an
  `n`-step finite scaffold, still without claiming a continuum generator.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP2PartialDephasingRateBridge.lean
lake build PhysicsSM.Draft.NullEdgeP2PartialDephasingRateBridge
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP2PartialDephasingRateBridge.lean
git diff --check
```

Outcome: targeted file checks and targeted module build passed. The scan
returned no matches.

## 2026-06-23 late loop: P7 recoverability audit completion

Aristotle completion:

- Project `d9eae3c7-a4f9-4c1d-be04-667be344b27d`, task
  `0d2ecb15-2ab0-4503-a61b-3a63c5b20fa2`, completed.
- Task note:
  `AgentTasks/null-edge-p7-proper-time-recoverability-audit-aristotle-2026-06-23.md`.
- No Lean edits or builds were requested.

Useful accepted guidance:

- Next high-value P7/P1/P4 theorem: a concrete same-determinant but different
  KL/data-processing-deficit witness under the same observer channel.
- Treat KL/Petz equality as support-sensitive; do not state an equality/recovery
  physics claim without full-support or interior hypotheses.
- The P2 partial-dephasing scaffold is the right cheap step toward a finite
  proper-time rate law.

Deferred or rejected guidance:

- Approximate recovery remains deferred until a metric or deficiency notion is
  selected.
- Broad KL equality characterization is lower priority than the concrete
  same-mass/different-deficit witness.

Next action:

- Spark/Noether is doing a bounded read-only triage of the existing KL and
  observer-channel files to decide whether the same-determinant/different-
  deficit witness should be proved locally or submitted to Aristotle.

Spark/Noether completion:

- Noether found that the rational witness is feasible using the existing
  `rhoCoh` and `rhoTilt` same-determinant states and a common complete-dephasing
  two-outcome channel.
- It recommended local scaffolding for the definitions and Aristotle for the
  strict KL non-equality, because the remaining proof touches logarithmic
  inequalities.

Follow-up Aristotle submission:

- Submitted focused proof job
  `83bb049d-c38a-42d0-b8bf-f6cc839f1a0c`, task
  `a21280df-00ac-4e67-8b81-4d616aa31186`.
- Task note:
  `AgentTasks/null-edge-p7-same-det-different-dp-deficit-aristotle-2026-06-23.md`.
- Target:
  `same_det_different_dpDeficit`.
- Scientific value: if solved, this proves determinant/mass-ratio agreement
  does not determine KL data-processing deficit under the same observer
  channel, giving P7 operational bite beyond scalar mixedness.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p7-same-det-different-dp-deficit-20260623/NullEdgeP7SameDetDifferentDPDeficit/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p7-same-det-different-dp-deficit-20260623/NullEdgeP7SameDetDifferentDPDeficit/Core.lean
```

Outcome: source file typechecks with exactly one intended proof handoff and no
non-ASCII.

## 2026-06-23 interruption: super-Dirac analysis integrated into docs

User supplied two super-Dirac analyses focused on Lorentzian/Krein structure,
gauge-network prior art, and the missing symbol theorem.

Integrated doc changes:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`

Scientific significance:

- Publication-value score `3`: the super-Dirac branch is now sharpened around
  the symbol/soldering theorem rather than more abstract `D^2` algebra.
  The docs now identify Marcolli-van Suijlekom gauge networks as the closest
  graph spectral-triple prior art, add Perez-Sanchez's Higgs-loss continuum
  warning, separate `eta` / `JReal` / `Sigma_m`, and promote
  `massShellConstraint_iff_kernel_on_bundleMode` plus low-order finite spectral
  action as clean theorem gates.

Verification:

```text
git diff --check -- Sources/Null_Edge_Key_Conjectures.md Sources/Null_Edge_Causal_Graph_Publication_Plan.md Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
```

Outcome: passed.

Local integration while Aristotle runs:

- Added `PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable`.
- Proved `erased_pair_not_exactRecoverable`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `3`: exact stochastic recovery now excludes fully
  erased separated source pairs. This is the no-go counterpart to the positive
  admissibility class and directly fences off the known P9 erasing-map
  counterexamples.

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticErasureNotRecoverable.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable
lake env lean PhysicsSMDraft.lean
git diff --check
```

Outcome: all passed. Aristotle job
`65561c72-4f30-468c-9193-e25290d8ea79`, task
`742a157e-e016-4db6-b941-0db89b32ddbf`, remained in progress at local
integration time and should be used for independent proof comparison and
next-step advice when complete.

Aristotle completion:

- `65561c72-4f30-468c-9193-e25290d8ea79`, task
  `742a157e-e016-4db6-b941-0db89b32ddbf`, completed.
- Aristotle independently solved `erased_pair_not_exactRecoverable`, reported
  unchanged theorem statement, no proof holes, no added assumptions, and no
  escape hatches.
- The live repo module was kept instead of copying returned code because it is
  ASCII-clean and extends the existing stochastic API.
- Useful next-step guidance: build an explicit two-source erasing-channel
  example, add a positive sharpness example, and postpone approximate recovery
  until a metric/deficiency notion is defined.

## 2026-06-23 late loop: P7 proper-time / purity bridge

Spark/Lorentz P7 theorem triage:

- Recommended several high-value P7 targets: recoverability-gap/source-
  visibility bounds, data-processing equality characterization, same-det but
  different recoverability deficit, and a two-level coherence-to-dephased-mass
  bridge.
- The highest-return targets are support-sensitive and touch older files with
  convention/encoding risks, so this slice banked a clean scalar bridge first.

Local Lean integration:

- Added `PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge`.
- Proved:
  - `properTimeRatioSq_eq_two_linearEntropy`;
  - `purity_eq_one_sub_half_properTimeRatioSq`;
  - `blochContraction_linearEntropy_monotone`;
  - `blochContraction_properTimeRatioSq_monotone`;
  - `blochContraction_linearEntropy_strict`;
  - `blochContraction_properTimeRatioSq_strict`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `2`: this is finite scalar algebra rather than a new
  dynamics theorem, but it cleanly names the static bridge the P7/P1/P4 story
  uses: for a normalized celestial qubit, squared proper-time ratio equals twice
  visible linear entropy, and unital visible contractions monotonically increase
  both.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP7ProperTimePurityBridge.lean
lake build PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP7ProperTimePurityBridge.lean
git diff --check
```

Outcome: all passed.

Fresh Aristotle strategy submission:

- Submitted no-code audit job
  `d9eae3c7-a4f9-4c1d-be04-667be344b27d`, task
  `0d2ecb15-2ab0-4503-a61b-3a63c5b20fa2`.
  Task note:
  `AgentTasks/null-edge-p7-proper-time-recoverability-audit-aristotle-2026-06-23.md`.
  Source prompt:
  `AgentTasks/aristotle-strategy-packs/null-edge-p7-proper-time-recoverability-audit-20260623/PROMPT.md`.
- Purpose: ask Aristotle to choose the next hard P7/P1/P4 theorem target after
  the proper-time/purity bridge, with particular attention to KL equality,
  exact-recovery gap, same-det/different-deficit witnesses, and finite rate-law
  scaffolds.

Literature pass:

- Semantic Scholar-backed meta-search hit a rate limit, so the fallback ladder
  used OpenAlex and Crossref directly.
- Added to Zotero:
  - `QAQA2SRN`: Le Cam, "Comparison of experiments---a short review", DOI
    `10.1214/lnms/1215453569`;
  - `QJGJ6KA7`: Torgersen, "Stochastic orders and comparison of experiments",
    DOI `10.1214/lnms/1215459865`;
  - `9SN4VCVJ`: Fritz, Gonda, Perrone, and Rischel, "Representable Markov
    categories and comparison of statistical experiments in categorical
    probability", DOI `10.1016/j.tcs.2023.113896`.
- Added project-scoped Neo4j `Paper` nodes and linked them to claim
  `p9_exact_stochastic_recovery_admissible_channels`.
- Claim-boundary effect: exact recovery should be framed as a classical
  comparison-of-experiments / Markov-kernel sufficiency certificate, not as a
  new standalone information-theory principle.

Local integration while Aristotle runs:

- Added `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap`.
- Proved `exactRecovery_preserves_observableGap`.
- Imported the module in `PhysicsSMDraft.lean`.

Scientific significance:

- Publication-value score `3`: common exact stochastic recovery now preserves
  the numerical expectation gap of any fine observable after pullback to the
  coarse observer channel. This is a stronger operational source-visibility
  statement than merely preserving non-equality.

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryGap.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap
lake env lean PhysicsSMDraft.lean
git diff --check
```

Outcome: all passed. Aristotle job
`ebd742af-00c2-45eb-9bf1-51e775195ed4`, task
`6417d07e-520e-4db9-adf7-08e258f4de66`, remained in progress at local
integration time and should be used for independent proof comparison and
next-step advice when complete.

Aristotle completion:

- `ebd742af-00c2-45eb-9bf1-51e775195ed4`, task
  `6417d07e-520e-4db9-adf7-08e258f4de66`, completed.
- Aristotle independently solved `exactRecovery_preserves_observableGap`,
  reported unchanged theorem statement, no proof holes, no added assumptions,
  and no escape hatches.
- The live repo module was kept instead of copying returned code because it is
  ASCII-clean and extends the existing stochastic API.
- Useful next-step guidance: prove a family version, prove strictness/nonzero
  variants, prove that erased separated pairs are not exactly recoverable, and
  audit the same-recovery-channel semantics against Blackwell/Petz conventions.

Follow-up Aristotle submission:

- Submitted focused proof job
  `65561c72-4f30-468c-9193-e25290d8ea79`, task
  `742a157e-e016-4db6-b941-0db89b32ddbf`.
  Task note:
  `AgentTasks/null-edge-p9-stochastic-erasure-not-recoverable-aristotle-2026-06-23.md`.
  Target:
  `erased_pair_not_exactRecoverable`.
  Scientific value: proves the no-go side of the admissible-channel story. If
  a stochastic observer channel collapses two genuinely distinct fine source
  distributions to the same coarse output, then it cannot be exactly
  recoverable for that pair.

Preflight verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
```

Outcome: source file typechecks with exactly one intended proof hole and no
non-ASCII in the staged file.
