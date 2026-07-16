# Claude cross-family review: ExactFlowTimeGroup (0704b7da)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle job 0704b7da, in-progress snapshot)
- Work item: `CONT-FOURIER-001`
- Source: `PhysicsSM/Draft/NullEdge/ExactFlowTimeGroup.lean` (86 lines),
  sha256 22c050cc... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Item-by-item (codex's five checks)

1. **`exactFlow_add_time` orientation.** `U(s+t) = U(s) * U(t)` via
   `Matrix.exp_add_of_commute`. The scalar-algebra bullet proves
   `-(s:C) • (I*H) + -(t:C) • (I*H) = -((s+t):C) • (I*H)` (`add_smul`,
   `neg_add`, `Complex.ofReal_add`), matching `exactFlow = exp(-(t)*(I*H))` =
   `exp(-itH)`. Correct one-parameter-group orientation.

2. **Both inverse orders, no hidden commutativity.** `exactFlow_mul_neg_time`
   (`U(t)*U(-t)=1`) from `exactFlow_add_time t (-t)` + `t+(-t)=0` + `U(0)=1`;
   `exactFlow_neg_time_mul` (`U(-t)*U(t)=1`) by `convert ... using 1 <;> ring`.
   The only `Commute` witness is
   `Commute.smul_left (Commute.smul_right (Commute.refl _) _) _` -- scalar
   multiples of the SAME matrix `I*H` commuting with itself. No commutativity
   beyond matrix-with-itself is used.

3. **Statements match the preserved standalone target.** sha256 matches the
   builder's; docstring records "No theorem statement was changed." The five
   statements are the natural group law, both inverse orders, the zero-time
   specialization, and the nonconstant-generator control.

4. **Nonconstant-generator control.** `nonconstant_generator_control :
   H 1 0 0 0 != H 0 0 0 0` (via `ExactFlowMomentumLipschitz.H_x_witness_ne`)
   shows the generator genuinely depends on momentum, so the group law is not a
   trivial constant/zero-generator statement -- non-vacuous. It is a pure matrix
   inequality, NOT an L2 or PDE claim. The docstring explicitly disclaims strong
   L2 continuity, the unbounded generator, Fourier transport, and the
   position-space PDE.

5. **Guards.** Five in-file `#guard_msgs (whitespace := lax) in #print axioms`
   blocks (add_time, mul_neg_time, neg_time_mul, zero_time_control,
   nonconstant_generator_control), each pinning
   `[propext, Classical.choice, Quot.sound]`.

## Overclaim tests

- Vacuity: none (`nonconstant_generator_control` guards the trivial-generator
  reading; group law genuine).
- Hollow telescoping: none (`exp_add_of_commute` group law with genuine scalar
  algebra + commute proof).
- Docstring overreach: none -- docstring is finite-dim/pointwise and disclaims
  L2/generator/Fourier/PDE.
- False shape: none -- `U(s+t)=U(s)U(t)` is the correct one-parameter-group
  shape.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup`: exit 0. A build
  target compiles the module and its five in-file `#guard_msgs` blocks, so all
  five guards fired and PASSED -- the axiom footprint is
  `[propext, Classical.choice, Quot.sound]`, build-enforced (a guard mismatch
  would fail the build; none did). The only build-graph output was non-fatal
  `ring`-fallback trace from unrelated modules, no errors/sorry in this module.

## Narrowest defensible claim

At each fixed momentum and mass, the exact finite-dimensional (4x4 complex)
Dirac flow `exactFlow` is a matrix one-parameter group in real time:
`U(s+t) = U(s) U(t)`, `U(t) U(-t) = U(-t) U(t) = 1`, specializing to the
zero-time identity, with a genuinely momentum-dependent (nonconstant) generator.
No strong `L2` continuity, unbounded-generator identification, Fourier transport,
or position-space PDE is claimed.
