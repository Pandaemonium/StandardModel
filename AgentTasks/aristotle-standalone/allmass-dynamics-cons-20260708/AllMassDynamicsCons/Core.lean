/-
# D-conservation: unitary carrier evolution conserves norm and energy

Proof job (Aristotle). Roadmap items **D2/D3** (dynamics groundwork;
`AgentTasks/overnight-allmass-run-2026-07-08/DYNAMICS_GROUNDWORK.md`). This is
the kernel version of the conservation laws the simulation harness
(`Scripts/oracle/carrier_dynamics_harness.py`) checks numerically: on a definite
physical sector the carrier Hamiltonian generates a *unitary* evolution under
which the norm and the energy are conserved. These are the invariants a rigorous
dynamics simulation validates against.

Setup (Mathlib-only). Finite-dimensional complex inner product space `H`, and a
self-adjoint Hamiltonian `T : H ->L[C] H` (`IsSelfAdjoint T` - on the physical
sector `T = D^#D|_P`, the positive mass operator of the T2 witness). The
evolution is the one-parameter unitary group `U t := exp(t • (-I • T))` (i.e.
`exp(-i t T)`; use `ContinuousLinearMap.exp` / `NormedSpace.exp` or the finite
matrix exponential - whatever Mathlib spelling is cleanest).

## Targets (prove kernel-clean, no `s o r r y`)

- **evolution_unitary:** `U t` is a linear isometry / unitary - for all `psi`,
  `‖U t psi‖ = ‖psi‖` (probability/norm conservation). Equivalently
  `(U t)^# * (U t) = 1`.
- **energy_conserved:** the energy is conserved along the flow:
  for all `t`, `inner (U t psi) (T (U t psi)) = inner psi (T psi)` (a complex
  equality; the real part is the physical energy). Key fact: `T` commutes with
  `U t = exp(-i t T)`.
- **(if clean) generator:** `U` solves the Schrödinger equation
  `deriv (fun t => U t psi) t = -I • T (U t psi)` (the carrier evolves by its
  Hamiltonian). Deliver the two conservation laws for certain; the generator
  statement if the `exp`-derivative API is clean.

Run `lake env lean AllMassDynamicsCons/Core.lean` (Mathlib-only). Report semantic
alignment; the load-bearing content is norm + energy conservation under the
Hamiltonian flow. Commit + push.

Provenance: all-mass overnight run 2026-07-08, roadmap D2/D3 [orig]; unitary
Hamiltonian evolution + conservation is classical [import].
-/

import Mathlib

namespace AllMassDynamicsCons

/-- Placeholder so the Mathlib-only package is valid. Replace with the setup
(`H`, self-adjoint `T`, the evolution `U t = exp(-i t T)`) and the theorems
evolution_unitary, energy_conserved, generator from the module docstring. -/
theorem package_ok : True := trivial

end AllMassDynamicsCons
