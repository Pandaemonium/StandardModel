# codex quantitative Dirac-walk continuum bridge, 2026-07-09 15:00

aristotle:
  project_id: ca016cbf-3151-4aef-b9ab-16f3f22b6247
  target_file: PhysicsSM/Draft/NullEdge/QuantitativeDiracWalkContinuum.lean
  expected_module: PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum
  submission_project: AgentTasks/aristotle-submit/codex-frontier-wave-1500-20260709-project
  output_dir: AgentTasks/aristotle-output/ca016cbf-3151-4aef-b9ab-16f3f22b6247
  status: submitted 2026-07-09 15:03 PDT

You are Aristotle. Push the existing finite `1+1D` Dirac quantum-walk symbol
beyond its landed first derivative toward the strongest kernel-checkable
quantitative continuum bridge.

Target:

```text
PhysicsSM/Draft/NullEdge/QuantitativeDiracWalkContinuum.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit
import PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound
import PhysicsSM.Draft.NullEdge.ExactCheckerboardPathSum
```

Context pack:

```text
AgentTasks/context-packs/quantitative-dirac-walk-continuum-20260709-150057.md
```

## Mission

The existing theorem
`ContinuumLimit.Ustep_hasDerivAt_generator` proves only the derivative at zero:

```text
Ustep(k*eps,m*eps) = I - i*eps*(k*sigma_z + m*sigma_x) + o(eps).
```

Prove a genuinely stronger quantitative or sequential statement. Prefer the
following ladder, keeping every landed rung if the final rung is too hard.

1. Define an explicit entrywise matrix norm or finite max-entry seminorm on
   `Matrix (Fin 2) (Fin 2) C` and prove its triangle/submultiplicative bounds
   needed below. Reuse a Mathlib norm if it makes the proof cleaner.
2. Prove exact first and second derivatives of
   `eps |-> Ustep (k*eps) (m*eps)` at zero. State the second-order coefficient
   explicitly, including the noncommuting `sigma_z*sigma_x` cross term.
3. Prove an explicit one-step Taylor remainder bound on a displayed interval,
   for example `|eps| <= 1`:

```text
norm(Ustep(k*eps,m*eps) - (I - i*eps*H(k,m)))
  <= C(k,m) * eps^2
```

   with an honest explicit nonnegative `C(k,m)`. A slightly looser polynomial
   constant is fine; a mere `O(eps^2)` proposition without a usable bound is
   weaker but still worth landing if rigorously stated.
4. If feasible, prove fixed-momentum Lie-Trotter convergence of the finite
   matrices:

```text
(Ustep (k*t/n) (m*t/n))^n -> exp (-i*t*H(k,m))
```

   as `n -> infinity`, or a finite-`n` error bound tending to zero. Use Mathlib's
   matrix exponential / normed-algebra APIs. This is a fixed `2x2` symbol
   theorem, not a PDE or strong-operator continuum limit.
5. Connect the generator to `dirac_mass_shell`, and give an exact nondegenerate
   witness such as `(k,m)=(3,4)`: `H^2=25 I`, the derivative is nonzero, and the
   second-order/cross structure is nontrivial.
6. State the massless control `m=0`, where the shift is exact and there is no
   turn/corner mixing, consistently with `ExactCheckerboardPathSum`.

Preferred names:

```lean
Ustep_second_derivative_at_zero
Ustep_second_order_coefficient
Ustep_taylor_remainder_bound
Ustep_power_converges_to_dirac_flow
three_four_five_quantitative_witness
massless_exact_control
quantitative_dirac_walk_continuum_verdict
```

## Non-negotiable boundary

Do not claim convergence of a spacetime walk, a Dirac PDE, a continuum
propagator, or a `3+1D` theory unless the corresponding topology and theorem are
actually formalized. The top target is fixed-momentum convergence in a finite
`2x2` normed algebra. If Mathlib lacks a tractable Trotter API, land the exact
second derivative and explicit remainder bound, then record the precise blocker.

PhysLean's harmonic-oscillator and finite variational/dynamics patterns were
consulted only as clean-room API references; the local `ContinuumLimit` module
sets the conventions and must remain the source of `sigma_x`, `sigma_z`, and
`Ustep`. Add axiom-footprint guard pins for every headline and run the narrow
target before returning.

Literature addendum (15:42 PDT): Arrighi, Forets, and Nesme,
`The Dirac equation as a quantum walk: higher dimensions, observational
convergence`, arXiv:1307.3524, is the direct operator-splitting/Trotter-Kato
precedent and reports `O(epsilon^2)` observational convergence at fixed time.
Use it as provenance and a theorem-shape check only; do not import its continuum
claim into a weaker fixed-momentum Lean result.

## 2026-07-09 16:06 PDT snapshot/status note

An in-progress snapshot now contains the full explicit remainder-bound and
finite-norm payload, with only two proof holes remaining:
`Ustep_hasDerivAt_first` and `Uderiv_hasDerivAt_zero`. A `--mode ask --wait`
request asked Aristotle to focus on those exact derivatives and confirm no
statement weakening; the CLI timed out after 124 seconds without a response.
The original task remains running. No partial file has been integrated.

## 2026-07-09 16:18 PDT local partial landing

The proof-complete load-bearing subset has now been integrated locally as
`PhysicsSM/Draft/NullEdge/QuantitativeDiracWalkContinuum.lean`: max-entry norm
lemmas, the explicit `C(k,m) eps^2` one-step remainder, algebraic cross
coefficient, `(3,4,5)` witness, massless exact control, and verdict. Two defects
in the snapshot remainder proof were repaired locally (off-diagonal bound
chaining and the diagonal imaginary-sign norm equality). The unresolved
all-`eps` first derivative and derivative-of-derivative declarations were
removed from the live module, so it is placeholder-free and does not claim a
second derivative. Targeted `lake build` passes. The remote job remains running
only for the stronger derivative completion.
