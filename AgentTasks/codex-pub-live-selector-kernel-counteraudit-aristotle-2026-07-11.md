# Aristotle counter-audit: is the claimed live solder selector actually proved?

Name this project `codex-pub-live-selector-kernel-counteraudit-20260711`.

Perform a hostile review-only counter-audit of
`LIVE_SELECTOR_DESIGN_AUDIT_2026-07-11.md` against the exact
`CarrierRigidity.lean` and `ChannelSelectorDescent.lean` sources. Do not edit
files.

The design report labels solder degree a `POSITIVE LIVE SELECTOR`, but also
admits that `kernel_solder_homogeneous` and surjectivity/corestriction are open
proof obligations. Its relation table lists the abstract carrier axioms while
explicitly excluding concrete-witness coincidences, even though every
representation-specific identity belongs to the kernel of evaluation into the
concrete matrix carrier.

Audit these precise issues:

1. Does homogeneity of the displayed R1--R8/A1--A4 relations imply homogeneity
   of the full evaluation kernel? Only if those relations generate the kernel;
   is that theorem stated or proved anywhere?
2. Distinguish three targets: the free algebra modulo the declared homogeneous
   ideal; the universal carrier presented by the axioms; and the live concrete
   matrix representation. For which target, if any, does solder degree descend?
3. Are concrete matrix coincidences legitimately excludable from the kernel,
   or only from the chosen defining ideal? Could a mixed-degree concrete
   relation kill descent?
4. Is `POSITIVE LIVE SELECTOR` justified, or must the verdict be
   `TYPECHECKING PROGRAM WITH OPEN KERNEL THEOREM`?
5. Give the exact shortest Lean theorem/counterexample computation that settles
   the concrete 4x4 carrier: either prove the full kernel is degree-stable or
   exhibit `x` with `eval x = 0` but `eval(P x) != 0`.
6. Audit the claim that no pair of natural sign selectors separates four
   channels: is the enumerated list exhaustive, or only a check of three chosen
   signs? State the safe theorem sentence.

Return severity-ranked findings, corrected verdict, exact replacement language,
and a proof/counterexample target. Reject reasoning that treats an unproved
kernel-generation statement as “mathematics settled.”

```yaml
aristotle:
  project_id: 6833acfa-0112-4a83-93cb-cf496354afd7
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-live-selector-kernel-counteraudit-20260711-project
  output_dir: AgentTasks/aristotle-output/6833acfa-0112-4a83-93cb-cf496354afd7
  status: harvested-counterexample-landed
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Harvest verdict

Task `8a373aaf-b2f6-4612-a557-4f697e42ede1` returned a decisive
counterexample. In the live rational carrier,
`P = c1 * kadj c1 = diag(1,1,0,0)` is nonzero and idempotent. Therefore the
degree-two word and its degree-four square evaluate to the same operator, while
raw solder-degree weighting would assign them coefficients two and four.

The positive live-selector claim is refuted. The result was independently
integrated as the kernel-checked module
`PhysicsSM/Draft/NullEdge/ChannelSolderDegreeNoGo.lean`. The full hostile report
is preserved under this project's `result/` extraction.
