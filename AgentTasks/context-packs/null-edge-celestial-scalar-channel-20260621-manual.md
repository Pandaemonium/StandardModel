# Context pack: celestial scalar channel

Date: 2026-06-21

Target:

```text
AgentTasks/aristotle-standalone/null-edge-celestial-scalar-channel-20260621/NullEdgeCelestialScalarChannel/Finite.lean
```

Research role:

- The strengthened program recasts the flip-rate conjecture as an l=1
  channel/generator statement on visible celestial directions.
- A visible normalized celestial state has Bloch vector `r`.
- The normalized mass-ratio square is represented by `1 - |r|^2`.
- The smallest finite theorem is the isotropic scalar channel
  `r -> c r`: it scales `|r|^2` by `c^2`, and if `c^2 <= 1` it cannot decrease
  `1 - |r|^2`.

Claim boundary:

- This is not a full CPTP-channel classification.
- It does not prove continuum Dirac dynamics.
- It is a finite support theorem for the l=1 relaxation story and should later
  be generalized to affine Bloch maps or generators.

Relevant program sections:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`, sections
  `0. Dirac square-root criterion`, `1. Mass as Pluecker spread of null
  spinors`, and `2. Chirality flips generate non-collinearity`.
- `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`, rows
  `celestial-channel` and definition item `CelestialChannelDynamics`.
