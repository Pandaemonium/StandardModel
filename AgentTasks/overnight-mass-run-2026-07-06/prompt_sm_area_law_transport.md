Formalize the finite/abstract WILSON AREA-LAW TRANSPORT bookkeeping inspired by
Faizal-Shabir arXiv:2606.19362, without making a continuum claim.

Desired mathematical content:

The paper's continuum area-law route separates the strong-coupling base from a
step-scaling transport inequality with summable losses and explicit
perimeter/cusp counterterms. We want the safe abstract scalar core:

```text
sigma_{k+1} >= sigma_k - delta_k
sum_k delta_k < sigma_0
--------------------------------
uniform positive lower bound on sigma_k
```

and, if feasible, a simple area-perimeter inequality transport lemma where
perimeter/cusp factors are explicit local counterterm data rather than hidden
constants.

Context:

- `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`
- `AgentTasks/context-packs/sm-area-law-transport-20260706-061955.md`
- Existing finite area-law and transfer files under
  `PhysicsSM/Draft/NullEdge/GateYM`, especially the strong-coupling/KP outline,
  `StrongCouplingPolymerMap.lean`, and current Wilson slab modules.

Target:

- Prefer a new module
  `PhysicsSM/Draft/NullEdge/GateYM/AreaLawTransport.lean`.
- Prove the scalar string-tension transport lemma first with finite prefix sums.
- Optional: add a finite step lemma of the shape
  `W_{k+1}(C') <= exp(perimeter/cusp correction) * W_k(C) + defect_k`
  implies a transported area-perimeter bound under explicit hypotheses.

Constraints:

- Do not claim continuum string tension or physical confinement.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, or statement weakening.
- Keep area, perimeter, cusp, and defect terms explicit.
- Check with
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/AreaLawTransport.lean`.
  If broad `lake build` stalls, skip it and report.

Finish with a concise report: proved lemmas, omitted harder transport pieces,
and exact commands run.

```yaml
aristotle:
  project_id: f0973966-c46c-4e6f-926b-891e9a2398a7
  task_id: 671d797b-e27d-4dd0-8c9a-c0367d4ce28d
  target_file: PhysicsSM/Draft/NullEdge/GateYM/AreaLawTransport.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.AreaLawTransport
  submission_project: AgentTasks/aristotle-submit/sm-area-law-transport-20260706-project
  output_dir: AgentTasks/aristotle-output/f0973966-c46c-4e6f-926b-891e9a2398a7
  status: submitted 2026-07-06 06:25 PDT
```
