# Aristotle task: Gram-weighted visible mass

Date: 2026-06-21

## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
```

This is the finite algebraic core of the flavor-overlap line developed in:

```text
Sources/Null_Edge_Big_Physics_Inquiry_Development.md
```

The trusted Plucker theorem covers orthogonal/decohered internal labels. This
task asks for the nonorthogonal internal-Gram version.

## Target file

```text
PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle
```

## Theorem targets

Main Cauchy-Binet target:

```lean
visibleDet_eq_exteriorGram_weighted_plucker
```

Important limits and bridges:

```lean
gramWeightedVisibleMomentum_one_eq_finBundleMomentum
orthonormal_internalGram_recovers_plucker_sum
rankOne_internalGram_eq_rankOneHermitian
rankOne_internalGram_implies_visible_massless
gramWeightedVisibleMomentum_twoStatePartial_eq_partialCoherence
twoStatePartialGram_det_eq_factor_mul_plucker
```

The dependent theorems already close once their direct predecessors are proved.

## Proof guidance

For the main theorem, expand entries and use finite Cauchy-Binet for:

```text
P_vis = M G M^dagger
```

where `M` is the `2 x n` matrix of visible spinors.  Equivalently, prove

```text
det(P_vis)
  =
sum_{p,q}
  det(G_{p,q})
  wedge(psi_p.1, psi_p.2) * conj(wedge(psi_q.1, psi_q.2)).
```

The exterior Gram entry is already defined as:

```lean
exteriorPairGram G p q
```

Useful imported definitions and theorems:

```lean
rankOneHermitian
spinorWedge
complexAbsSq
finBundleMomentum
finPairIndexSet
finPairwisePluckerMass
fin_bundle_plucker_mass_identity
partialCoherenceMomentum
partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker
```

For the rank-one Gram theorem, expand:

```text
G_ij = u_i conj(u_j)
```

and show:

```text
M G M^dagger =
(sum_i u_i psi_i) (sum_j u_j psi_j)^dagger.
```

For the two-state partial-coherence bridge, split on `Fin 2` indices and match
the existing definition `partialCoherenceMomentum`.

## Constraints

- Keep this module draft-facing.
- Do not modify trusted definitions or conventions.
- No final `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, or
  `n a t i v e _ d e c i d e` in the target file.
- Do not weaken theorem statements silently. If a theorem statement needs a
  sharper hypothesis or orientation convention, report it clearly.
- This is finite matrix algebra only. Do not add continuum, flavor-model, or
  phenomenological assumptions.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
lake build PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle
```

Result before submission: typechecks and targeted-builds with exactly four
intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 59f9fbb0-6172-4bb5-b54b-832072fd3e2d
  task_id: f2e2b4a0-e576-4125-b876-6e62dc4ee662
  target_file: PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-gram-weighted-mass-20260621-project
  output_dir: AgentTasks/aristotle-output/59f9fbb0-6172-4bb5-b54b-832072fd3e2d
  status: submitted
```

Submitted 2026-06-21. `aristotle submit` created project
`59f9fbb0-6172-4bb5-b54b-832072fd3e2d`. `aristotle tasks` reported task
`f2e2b4a0-e576-4125-b876-6e62dc4ee662` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Submission note: the Aristotle CLI warned that the slim package contains Lean
files but no `.lake` folder. This is expected from
`Scripts/prepare_aristotle_submission.ps1`, which intentionally excludes local
build artifacts and dependency caches. If dependency resolution fails, retry
with an alternate package strategy.

## Cycle-1 follow-up

Checked 2026-06-21 after the first 15-minute goal-cycle wait. The project was
`IDLE`, and `aristotle tasks` reported
`f2e2b4a0-e576-4125-b876-6e62dc4ee662` as `OUT_OF_BUDGET`.

The progress log showed that most of the budget was spent building the large
PhysicsSM dependency graph. A dry-run fetch with
`Scripts/aristotle/integrate_completed.py` downloaded an output file, but it
still contained proof holes and was not integrable. The partial file did suggest
a useful three-lemma decomposition of the Cauchy-Binet identity:

```text
det expansion -> hidden-index exterior fold -> visible-index wedge fold
```

Follow-up prepared:

```text
AgentTasks/null-edge-gram-weighted-cauchy-binet-core-aristotle-2026-06-21.md
AgentTasks/aristotle-submit/null-edge-gram-cauchy-binet-core-20260621-project
```

The focused follow-up was submitted as Aristotle project
`153c8555-b764-4169-9468-0abff103bd23`, task
`e194952f-8432-4cb5-b599-c7894a2fa08a`.
