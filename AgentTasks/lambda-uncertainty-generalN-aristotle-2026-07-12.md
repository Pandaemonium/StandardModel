# Aristotle task: general-N finite Fourier support-uncertainty

Upgrade target for the null-edge cosmological-constant manuscript
(`Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`,
Section 6). Generalizes `PhysicsSM/Draft/NullEdge/LambdaConjugacy.support_uncertainty`
(currently `ZMod 4` only, by a case-specific argument) to arbitrary `N`.

Target theorem (Donoho--Stark support uncertainty on `ZMod N`):
for `N >= 1` and nonzero `f : ZMod N -> C`,
`N <= (supp f).card * (supp (ZMod.dft f)).card`.

Self-contained: imports only Mathlib, reuses Mathlib's bundled `ZMod.dft` (`𝓕`).
Statement typechecks in the pinned toolchain (only `sorry` warnings). Proof route
(Plancherel + `‖.‖_infty <= ‖.‖_1` + Cauchy--Schwarz on the support) is written in
the file docstring.

Manuscript effect: retires the "ZMod 4 witness only" scope caveat in Section 6;
the finite `Lambda`--volume conjugacy uncertainty relation becomes general-`N`.

```yaml
aristotle:
  project_id: e22d0fe7-fc6a-4607-bd16-97fe5c2a2b96
  task_id: TBD
  target_file: AgentTasks/aristotle-standalone/lambda-uncertainty-generalN-20260712/LambdaUncertaintyGeneralN/Uncertainty.lean
  expected_module: LambdaUncertaintyGeneralN.Uncertainty
  submission_project: AgentTasks/aristotle-submit/lambda-uncertainty-generalN-20260712-project
  output_dir: AgentTasks/aristotle-output/e22d0fe7-fc6a-4607-bd16-97fe5c2a2b96
  status: INTEGRATED 2026-07-12 (support_uncertainty kernel-clean, guard-pinned)
```

Success criterion: `support_uncertainty` proved with no `sorry`/`admit`/`axiom`/
`native_decide`; the two saturation `example`s are a bonus. Kernel footprint
`[propext, Classical.choice, Quot.sound]` expected.
