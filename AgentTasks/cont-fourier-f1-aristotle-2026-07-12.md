# Aristotle task: representative-safe inverse-Fourier transport

## Objective

Close F1 of `CONT-FOURIER-001`. Package the landed componentwise changing-cell
error as an actual four-component `L2` representative, prove its exact norm
identity, and transport strong convergence through Mathlib's vector-valued
inverse Fourier linear isometry.

This is a position-space `L2` reconstruction theorem only. It does not identify
the reconstructed flow with a Dirac PDE or an unbounded generator.

## Exact target

`AgentTasks/aristotle-targets/codex_afpl_cont_fourier_f1.lean`

Run the narrow file first:

```text
lake env lean AgentTasks/aristotle-targets/codex_afpl_cont_fourier_f1.lean
```

Close all ten proof holes without changing definitions, statements, or
hypotheses. Small named helper lemmas are welcome.

## Required proof architecture

1. Derive `cellPacket_memLp` with `memLp_indicator_const`, then derive
   `embedFinite_memLp` by a finite sum.
2. Use `MemLp.of_eval_piLp` for the Euclidean spinor representative and prove
   the pointwise norm identity with the existing `spinor_norm_sq_eq_sum`.
3. Commute the finite coordinate sum with the integral using each component's
   derived `MemLp.integrable_norm_pow` proof.
4. Bridge the actual representative to `Lp` using `MemLp.toLp`. Prove its norm
   square equals the integral, for example via `Lp.norm_toLp`, `lpNorm`, and
   the exponent-two integral formula; do not assume the norm identity.
5. Convert the landed squared-energy limit into norm convergence using
   nonnegativity and continuity of `Real.sqrt`.
6. Preserve the repository's domain honestly: `Momentum3 = Fin 3 -> Real`
   carries the product sup norm and has no compatible Euclidean inner-product
   instance. Use the displayed `PiLp.volume_preserving_ofLp` bridge into
   `FourierMomentum3 = EuclideanSpace Real (Fin 3)` and its `Lp` isometry.
7. Finish with the inverse of
   `MeasureTheory.Lp.fourierTransform_li FourierMomentum3 Spinor` and exact
   norm preservation.

## Semantic gates

- The input remains an actual representative built from `embeddedErrorComponent`;
  do not replace it by an arbitrary assumed `Lp` sequence.
- The componentwise `MemLp` hypotheses on the source field remain unchanged.
- The Euclidean-domain bridge is explicit and volume preserving. Do not install
  a false inner-product instance on the repository's sup-norm `Momentum3`.
- The final result is inverse-Fourier transport of strong convergence. It is not
  a PDE, generator-domain, Lorentz-invariance, or continuum-QFT theorem.
- Mathlib's derivative convention carries a `2 * pi` factor. No theorem in this
  target may erase or pre-empt that later F3 normalization obligation.

## Nondegeneracy and wrong-shape controls

- `embedFinite_isometry` and the existing one-cell witness prevent an
  almost-everywhere-zero or wrong-normalization packaging.
- `positionErrorLp_norm_eq` must be an exact Plancherel norm identity, not only
  a convergence implication.
- The first typecheck correctly rejected direct Fourier use on `Momentum3`
  because no real inner-product instance exists; the explicit volume-preserving
  bridge is the required repair.

## Context preflight

- API map:
  `AutonomousLab/work/NE-CONTINUUM/CODEX_CONT-FOURIER-001_API_MAP_2026-07-12.md`.
- Semantic context pack:
  `AgentTasks/context-packs/cont-fourier-f1-20260712-20260712-221045.md`.
- The full repository index refresh exceeded its three-minute execution bound;
  the pack was generated successfully from the existing index. This freshness
  limitation is recorded rather than hidden.

## Local status

Codex independently closed all ten target holes while the Aristotle task was
running. The proof was promoted to
`PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`; its direct Lean check,
8042-job targeted build, and 8404-job aggregate axiom-guard build all pass.
The direct `Momentum3` Fourier statement had correctly failed typeclass
resolution and remains replaced by the explicit volume-preserving
Euclidean-domain bridge.

The Aristotle task was canceled before completion to release capacity. No
Aristotle output was harvested or used in the landed proof.

```yaml
aristotle:
  project_id: 2c46e3db-0272-4c7e-80bf-d3421552a3ce
  task_id: 0fcf5a8b-eede-411f-add8-7fdb0f17dba2
  target_file: AgentTasks/aristotle-targets/codex_afpl_cont_fourier_f1.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
  submission_project: AgentTasks/aristotle-submit/cont-fourier-f1-20260712-project
  output_dir: AgentTasks/aristotle-output/2c46e3db-0272-4c7e-80bf-d3421552a3ce
  status: cancelled-local-proof-complete
```
