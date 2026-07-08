/-
# D1: the finite carrier action and its Euler-Lagrange equation of motion

Proof job (Aristotle). Roadmap item **D1** (dynamics groundwork; see
`AgentTasks/overnight-allmass-run-2026-07-08/DYNAMICS_GROUNDWORK.md`). This gives
the null-edge carrier its first *derived* (not posited) dynamics: an action whose
Euler-Lagrange equation is the carrier equation `D psi = 0`. Clean-room in the
spirit of PhysLean's `Mathematics/VariationalCalculus` / `ClassicalMechanics/
EulerLagrange` (which we cannot import - version-pinned).

Setup (Mathlib-only). Finite-dimensional complex inner product space `H`, and the
carrier operator `D : H ->L[C] H`. Define the **Dirichlet action**
`energy psi := ‖D psi‖ ^ 2`.

## Targets (prove kernel-clean, no `s o r r y`)

- **energy_eq_form:** `energy psi = ((ContinuousLinearMap.adjoint D) ∘L D).reApplyInnerSelf psi`.
  The action equals the `D^#D` quadratic form - i.e. the mass functional §4 is
  the on-shell action. (`‖D psi‖^2 = <D psi, D psi> = <psi, D^#D psi>`.)
- **energy_nonneg:** `0 <= energy psi`.
- **eom_iff (the equation of motion):** `energy psi = 0 <-> D psi = 0`. The
  action's minimizers/zeros are exactly the harmonic (massless) states - the
  finite carrier EOM. (Ties to §8 protected massless modes: `ker D`.)
- **critical_iff_ker (the Euler-Lagrange characterization):** the critical
  points of `energy` are exactly `ker (D^#D) = ker D`. State this in whatever
  Mathlib gradient/derivative spelling is cleanest - e.g. prove
  `HasGradientAt energy (2 • (ContinuousLinearMap.adjoint D) (D psi)) psi` (so
  the gradient is `2 D^#D psi` and vanishes iff `D^#D psi = 0`), OR, if the
  gradient API is heavy, deliver the variational form: for all `h`,
  the directional derivative of `energy` at `psi` in direction `h` is
  `2 * (inner (D^#D psi) h).re`, hence stationary at `psi` iff `D^#D psi = 0`
  iff `D psi = 0`. Deliver `eom_iff` for certain; `critical_iff_ker` as far as
  the derivative API cleanly allows.

Run `lake env lean AllMassDynamicsD1/Core.lean` (Mathlib-only). Report semantic
alignment - the load-bearing content is that the Dirichlet action's EOM is
`D psi = 0` (so dynamics is *derived* from an action). Commit + push.

Provenance: all-mass overnight run 2026-07-08, roadmap D1 [orig]; the
Dirichlet-action / harmonic-map argument is classical [import].
-/

import Mathlib

namespace AllMassDynamicsD1

/-- Placeholder so the Mathlib-only package is valid. Replace with the D1 setup
(`H`, `D`, `energy`) and the theorems energy_eq_form, energy_nonneg, eom_iff,
critical_iff_ker from the module docstring. -/
theorem package_ok : True := trivial

end AllMassDynamicsD1
