# API map: CONT-FOURIER-001

- Model/role: Codex / Research Scientist.
- Work item: `CONT-FOURIER-001`.
- Result: the vector-valued Fourier-Plancherel API exists in the pinned Mathlib;
  the remaining work is a representation bridge plus an explicit momentum
  convention and generator domain.

## Direct Mathlib support

Module `Mathlib.Analysis.Fourier.LpSpace` defines

```lean
MeasureTheory.Lp.fourierTransformₗᵢ :
  Lp F 2 volume ≃ₗᵢ[Complex] Lp F 2 volume
```

where the base space `E` is a finite-dimensional real inner-product space and
the fibre `F` is any complete complex inner-product space. In the repository,
the intended specialization is

```text
E = Momentum3 = EuclideanSpace Real (Fin 3)
F = Spinor    = EuclideanSpace Complex (Fin 4)
```

so no componentwise scalar Fourier transform or new product-space instance is
needed. The same module supplies:

- `MeasureTheory.Lp.norm_fourier_eq`;
- `MeasureTheory.Lp.inner_fourier_eq`;
- the inverse transform as the inverse linear isometry equivalence;
- `SchwartzMap.toLp_fourier_eq` and its inverse analogue; and
- compatibility with tempered distributions.

`MemLp.toLp`, `MemLp.coeFn_toLp`, and `Lp.norm_toLp` in
`Mathlib.MeasureTheory.Function.LpSpace.Basic` provide the bridge from an actual
representative with a `MemLp` proof to an `Lp` element.

## Derivative and convention support

Module `Mathlib.Analysis.Distribution.SchwartzSpace.Fourier` supplies the
vector-valued Schwartz identities

- `SchwartzMap.fourier_fderivCLM_eq`;
- `SchwartzMap.fourier_lineDerivOp_eq`; and
- `SchwartzMap.lineDeriv_eq_fourierMultiplierCLM`.

For Mathlib's convention, a directional derivative transforms to multiplication
by `2 * pi * I * <frequency, direction>`. The landed repository symbol is

```text
H(k,m) = k_1 alpha_1 + k_2 alpha_2 + k_3 alpha_3 + m beta
```

and `exactFlow k m t = exp(-i t H(k,m))`. Therefore the matching position-space
free Hamiltonian is not writable as an unscaled `-i alpha dot grad + m beta`
under Mathlib's frequency coordinate. One must choose and document one of:

1. call the Mathlib Fourier variable `xi` and use physical momentum
   `k = 2*pi*xi`; or
2. define the position generator with the explicit factor
   `-(i/(2*pi)) alpha dot grad + m beta`.

Silently dropping this factor would be a false-shape theorem even if every Lean
line compiled.

## PhysLean check

`lean-explore packages=["Physlib"]` was searched for a free Dirac PDE/Fourier
evolution theorem. It exposes concrete gamma-matrix and finite time-evolution
APIs, but no theorem matching this free spinor `L2` reconstruction gate was
found. PhysLean remains a convention reference only and is not imported because
its pinned version differs from this repository.

## Required representation bridge

The integrated theorem is currently componentwise:

```lean
Tendsto
  (fun N => sum j, integral x, norm (embeddedErrorComponent ... j x)^2)
  atTop (nhds 0)
```

It must not be fed to Fourier-Plancherel by verbal identification. The first
Lean rung should define

```text
embeddedErrorSpinor N x = (j |-> embeddedErrorComponent ... j x)
```

and prove:

1. strong measurability and `MemLp embeddedErrorSpinor 2 volume`;
2. the exact norm identity
   `integral ||embeddedErrorSpinor N x||^2 = sum_j integral ||component_j||^2`;
3. convergence of the corresponding `Lp Spinor 2` norm to zero; and
4. the same convergence after applying the inverse Fourier linear isometry.

Items 3-4 are then short consequences of the integrated energy limit and
Plancherel. Items 1-2 are the nontrivial representative-safe packaging work.

## Theorem ladder

### F1: unitary transport

Bundle the existing error into vector-valued `Lp`, prove its norm tends to zero,
and transport that norm through `fourierTransformₗᵢ.symm`. This is a genuine
position-space strong-convergence statement for the reconstructed error, but it
does not yet identify a PDE.

### F2: exact multiplier evolution on L2

Define the pointwise unitary `exactFlow(k,m,t)` as a bounded multiplication
operator on vector-valued `Lp`. Prove its group law and unitarity at the `Lp`
level. Compose it with Fourier and inverse Fourier to define the exact
position-space evolution.

### F3: generator identification on a displayed core

Use Schwartz spinors as the first domain. With the explicit `2*pi` convention,
prove that Fourier conjugation identifies the spatial Dirac differential
operator with multiplication by `H(k,m)`. Then identify the evolution equation
first in Schwartz space or tempered distributions. A later theorem may close
the unbounded-operator/domain statement on the natural Sobolev domain.

### F4: nondegenerate controls

- zero field gives zero error;
- a nonzero Schwartz wave packet exercises the spatial derivative and mass
  terms;
- the `2*pi`-omitted generator fails the symbol identity;
- a merely componentwise `MemLp` hypothesis is not treated as a chosen
  representative until the spinor bundling proof is complete.

## Submission decision

Do not submit the full PDE theorem to Aristotle yet. Prepare F1 as a focused
typechecking target. The existing Mathlib isometry makes F1 high-probability and
semantically clean. F2 and F3 should remain separate because bounded multiplier
evolution and unbounded generator identification have different failure modes.

## Search provenance

- `lean-explore`, package `Mathlib`, query: vector-valued Fourier-Plancherel on
  `L2`.
- `lean-explore`, package `Mathlib`, query: Fourier transform of vector-valued
  derivatives.
- `lean-explore`, package `Physlib`, queries: free Dirac equation, Fourier
  evolution, and gamma matrices.
- Local source checked under the pinned checkout:
  `.lake/packages/mathlib/Mathlib/Analysis/Fourier/LpSpace.lean`.
