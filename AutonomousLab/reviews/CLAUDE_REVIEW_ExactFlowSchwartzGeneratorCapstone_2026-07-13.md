# Claude review: ExactFlowSchwartzGeneratorCapstone (7f0c4cea)

- Reviewer: interactive Claude Code (claude family)
- Work item: `CONT-FOURIER-001` (T2-B); source sha a118585f... verified (222 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

The strongest HONEST generator statement the current Mathlib calculus supports:
the pointwise-in-momentum free Dirac evolution, with the Schwartz-topology rung
genuinely blocked (real Mathlib gap, correctly isolated) and everything above
Stone/L2 explicitly disclaimed.

## Checks

- **Statement/prose alignment.** Rung 1 (`exactFlowSchwartzCLM_apply_hasDerivAt_zero`)
  = fibrewise `d/dt (exactFlowSchwartzCLM m t g) k` at 0 = `fibreGenerator(k) . g k`;
  rung 4 (`..._dirac_evolution_pointwise`) rewrites it as `(-i) H(k) . g k` = the
  free Dirac evolution `d/dt psi = -i H psi` per momentum fibre; rung 3
  (`fourier_..._generator_pointwise`) Fourier-identifies with `-i` times the
  packaged position Dirac operator. Prose matches the kernel exactly.
- **Derivative orientation / sign.** `fibreGenerator = (-I) . H` (from the
  reviewed `ExactFlowGenerator`), so the derivative is `-i H . g k` - the physical
  `-i` Schroedinger/Dirac sign. Correct.
- **Fourier normalization.** Rung 3 uses `fourier_positionDiracSchwartzCLM`, which
  carries the exact `-I/(2*pi)` convention (from the reviewed capstone). Inherited
  unchanged.
- **Nonzero witness.** `exactFlowSchwartz_generator_nonzero_control`: at `k=0`,
  `m=4`, `-i H = -4 i beta` sends `e_0` to `-4 i e_0 != 0` (component-0 `norm_num`).
  Non-vacuous; carries the mass into a genuine infinitesimal motion.
- **Fréchet-topology blocker - GENUINE, not avoidable (the key question).**
  `HasDerivAt`/`fderiv` require a `NormedSpace`-valued codomain. `SpinorSchwartz`
  carries the Fréchet (countable-seminorm) topology and has NO `NormedSpace`
  instance - correctly, because `SchwartzMap` is genuinely not normable. So
  `HasDerivAt (fun t => exactFlowSchwartzCLM m t g) L 0` (whole-SchwartzMap curve)
  cannot even be TYPED. The only stateable substitute is `Filter.Tendsto` of the
  Schwartz-space difference quotient in the Schwartz topology, whose proof needs a
  "fibrewise `HasDerivAt` + temperate-growth bound => Schwartz-seminorm
  convergence" lemma (a Fréchet/bornological calculus on `SchwartzMap`, or a
  `bilinLeftCLM`-specific differentiation lemma). Mathlib provides neither. This
  is a real API gap, NOT an avoidable omission: you cannot put a `NormedSpace`
  instance on `SchwartzMap` (it is not normable), and no existing lemma discharges
  the substitute. The module's characterization is accurate, and the fibrewise
  rungs hold unconditionally without it.
- **Scope guard.** Explicitly disclaims closed self-adjoint `L2` generator,
  Stone, changing-lattice limit, interacting dynamics, Lorentz restoration;
  distinguishes pointwise-momentum (proved) from Schwartz-topology (blocked) from
  strong-`L2` (untouched). Exemplary.
- **Guards.** Six `#guard_msgs` blocks, all `[propext, Classical.choice,
  Quot.sound]`. Clean-path replay: exit 0, no errors/warnings/sorry.

## Narrowest defensible claim

For every Schwartz spinor `g` and momentum `k`, the fibrewise orbit
`t |-> (exactFlowSchwartzCLM m t g) k` is differentiable at `t=0` with derivative
`-i H(k,m) (g k)` (the free Dirac evolution in the momentum representation), and
Fourier conjugation identifies this pointwise generator with `-i` times the
packaged position-space Dirac operator in the `-I/(2*pi)` normalization. This is
pointwise-in-momentum only; differentiation in the Schwartz Fréchet topology is a
named, genuine Mathlib gap, and no closed `L2` generator / Stone / lattice-limit /
interacting-dynamics claim is made.
