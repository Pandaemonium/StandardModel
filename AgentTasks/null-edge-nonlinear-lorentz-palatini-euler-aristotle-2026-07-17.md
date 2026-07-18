# Aristotle job: nonlinear Lorentz Palatini link Euler equation

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-009`

```yaml
aristotle:
  project_id: ba01e5f8-8b5c-49d5-bf74-bb22809af646
  task_id: 9e2bbc24-e7a5-4008-9647-1e585a95ee31
  target_file: PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-nonlinear-lorentz-palatini-euler-20260717-project
  output_dir: AgentTasks/aristotle-output/ba01e5f8-8b5c-49d5-bf74-bb22809af646
  status: completed_comparison_harvested
```

## Target

Reorganize the exact formal product/inverse response of the scalar nonlinear
Lorentz plaquette action into an explicit local functional for every varied
directed link. Prove:

1. the global response is the sum of the four-family local link functionals;
2. each local functional is the dot product of six coordinate coefficients
   with the link probe;
3. a supported component probe extracts the corresponding local coefficient;
4. formal connection stationarity is equivalent to vanishing of every local
   six-component coefficient.

## Convention lock

- metric: mostly-minus `(+,-,-,-)`;
- bivector basis: `(12,13,23,01,02,03)`;
- link insertion: `delta U = U hat(X)`;
- plaquette: `H=A B^(-1)`;
- tangent: `delta H H^(-1)` with the exact four-corner adjoint ordering already
  proved in `LorentzPlaquetteTangent.lean`;
- scalar local action: `-1/2 tr(hat(B_ab)(H_ab-I))`;
- formal response: `-1/2 tr(hat(B_ab) delta H_ab)`;
- curvature face `ab` uses the complementary coframe coefficient
  `(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`.

The second and fourth local contributions are reindexed from predecessor sites
using `(shift direction).symm`. Product order, face orientation, and all signs
must be preserved exactly. If the displayed local functional is incorrect,
return a counterexample or corrected formula rather than silently changing the
theorem.

## Inputs

- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerAristotle.lean`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAction.lean`
- `PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean`
- `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean`
- `AgentTasks/context-packs/nonlinear-lorentz-palatini-euler-20260717-195711.md`

## Preflight

The target passes under the pinned repository toolchain with exactly four
intentional proof-hole warnings and no other diagnostics:

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerAristotle.lean
```

The live predecessor modules contain no proof placeholders or native evaluator
shortcuts. The target is draft handoff code and is not imported by the GR
facade until all four proofs are completed, semantically reviewed, guarded,
and rebuilt.

## Submission

Submitted on 2026-07-17 as project
`ba01e5f8-8b5c-49d5-bf74-bb22809af646`, task
`9e2bbc24-e7a5-4008-9647-1e585a95ee31`. Initial state was project `RUNNING`,
task `QUEUED`. Aristotle was instructed to run the narrow target before any
broad build, preserve all four contribution families exactly, and return a
counterexample or corrected formula rather than modifying a false statement.

## In-progress local reduction

A 15-minute read-only snapshot showed no proof changes, while the task
remained in progress. Local work then closed Targets 2, 3, and 4 without
altering their statements. The live handoff now kernel-checks:

- additivity and real homogeneity of `lorentzGenerator`, `lorentzAdjoint`, and
  `nonlinearWeightedAdjointFaceResponse`;
- `nonlinearLinkEulerLinearMap`, packaging the four-family local response as a
  real linear map on the six link coordinates;
- the exact six-coordinate expansion of the local response;
- extraction by a supported site/direction/component probe;
- equivalence between formal stationarity and vanishing of all six local
  coefficients, conditional only on Target 1.

The target file was then reduced to exactly one proof hole, in
`nonlinearCoframePlaquetteFirstResponse_eq_localEuler`. Aristotle was
redirected in `instruct` mode to work exclusively on this global four-family
reindexing theorem, using
`nonlinearCoframePlaquetteFirstResponse_eq_rightTrivialized`, the exact
adjoint-sum theorem, `Finset.sum_comm`, and `Equiv.sum_comp` for the two
predecessor-site terms.

## Local completion and promotion

The same route was completed locally before the remote task returned. Four
small finite-sum lemmas make the proof transparent: cycle `(a,b,x)` to
`(x,a,b)` or `(x,b,a)`, then reindex the two predecessor families by the first
or second shift equivalence. A response-splitting lemma distributes the exact
four-corner adjoint tangent through the scalar trace response. The four global
sum equalities then close the target by linear combination with all signs and
transport orderings unchanged.

The completed module was promoted to
`PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEuler.lean`, moved into the
namespace `PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler`, given
build-enforced standard-three axiom guards, and imported by `GRFoundations`.
A direct check passed with no warnings or proof placeholders:

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEuler.lean
```

Aristotle was instructed to stop proof search and immediately return or
finalize the project. Any later remote result is now an independent comparison
artifact, not the source of the live proof.

The promoted module subsequently passed the targeted GR-facade build and the
full 8,319-job repository build. As of the final local verification on
2026-07-17, Aristotle still reported the remote task as `IN_PROGRESS` despite
the stop instruction; this does not affect the guarded live theorem.

## Remote completion and comparison harvest

The remote task later completed before it could be cancelled. Its final archive
was harvested to
`AgentTasks/aristotle-output/ba01e5f8-8b5c-49d5-bf74-bb22809af646/project-files.zip`;
the target and `ARISTOTLE_SUMMARY.md` were extracted under the `final/`
subdirectory. Aristotle reports all four targets complete with unchanged
statements and the standard-three axiom footprint.

The extracted target also passes directly under the current pinned repository
toolchain. It has several unused-simplifier and tactic-style warnings, and its
global proof is less explicit about the predecessor reindexing than the live
module. The guarded local proof is therefore retained; the remote result is an
independent corroborating artifact rather than an integration source.
