# Codex proof job: complex Pluecker mass in the 3+1 Dirac walk

Prove every theorem in `Plucker3Plus1ComplexMass/Core.lean` without changing
the displayed matrices, definitions, quantifiers, or phase-covariance sign.
This is the highest-value bridge between the paper's complex two-spinor mass
operator and its landed four-component successive-axis walk.

Priorities:

1. `mass4_hermitian_sq`, `spatial_anticommutes_mass_generators`, and `H4_sq`;
2. `complex_phase_covariance` and spatial commutation;
3. exact mass-coin unitarity and group law;
4. real-axis reduction and both nondegenerate/boundary controls.

The intended algebra is `beta5 = i beta gamma5`, with `beta5` Hermitian,
`beta5^2=1`, and `{beta,beta5}=0`. The chiral unitary is chosen so
`U(theta) mass4(z) U(theta)^H = mass4(exp(i theta) z)`. If that sign is false,
do not silently change it: return the exact corrected relation and a concrete
countercalculation. The `z=3+4i` control must retain both real and imaginary
mass directions.

Run `lake env lean Plucker3Plus1ComplexMass/Core.lean` first. This is finite
matrix algebra and should remain a focused Mathlib-only package. Clean-room
proof only.

```yaml
aristotle:
  project_id: 64ead89b-7476-41c9-abb6-fd2ed10cc639
  target_file: AgentTasks/aristotle-standalone/plucker-3plus1-complex-mass-20260710/Plucker3Plus1ComplexMass/Core.lean
  expected_module: Plucker3Plus1ComplexMass.Core
  submission_project: AgentTasks/aristotle-submit/codex-plucker-3plus1-complex-mass-20260710-project
  output_dir: AgentTasks/aristotle-output/64ead89b-7476-41c9-abb6-fd2ed10cc639
  status: submitted
```
