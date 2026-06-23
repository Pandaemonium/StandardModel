# Aristotle task: null-step quantum-walk dynamics strategy

```yaml
aristotle:
  project_id: 00dd71c5-70bd-477f-9b40-6770b2024bd9
  target_file: NullEdgeNullStepQuantumWalkStrategy/Stub.lean
  expected_module: NullEdgeNullStepQuantumWalkStrategy.Stub
  submission_project: AgentTasks/aristotle-submit/null-edge-null-step-quantum-walk-strategy-20260623-project
  output_dir: AgentTasks/aristotle-output/00dd71c5-70bd-477f-9b40-6770b2024bd9
  status: integrated
```

This is a strategy/scaffold job, not a proof-only job.

Goal: design the next finite proof package connecting the discrete null-step
quantum walk

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)
```

to:

- the quasienergy relation `cos(omega a) = cos(k a) cos(mu a)`;
- chirality coherence `|sin(mu a)| / |sin(omega a)|`;
- the continuum limit `mu / sqrt(k^2 + mu^2) = m / E`;
- the existing P2/P4 checkerboard and chirality-coherence theorem spine;
- the gauge-QCA prior art `JU96F5N6`.

Please return:

- a concise physics audit of what is standard versus new;
- the smallest Lean-friendly theorem statements to prove first;
- a proposed standalone `Core.lean` scaffold, with proof holes allowed;
- which theorem should be sent as the next proof-only Aristotle job;
- any reasons the proposed bridge is mathematically or physically misleading.
