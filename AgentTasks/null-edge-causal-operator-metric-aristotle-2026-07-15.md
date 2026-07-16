# Causal-operator metric bridge: Aristotle semantic audit

```yaml
aristotle:
  project_id: 8d39e609-03bf-4295-bc00-eb92810a39c5
  task_id: b371397e-d354-4379-bfbb-1daf0ae70fcb
  target_file: PhysicsSM/Draft/NullEdge/CausalOperatorMetric.lean
  expected_module: PhysicsSM.Draft.NullEdge.CausalOperatorMetric
  submission_project: AgentTasks/aristotle-submit/causal-operator-metric-20260715-project
  output_dir: AgentTasks/aristotle-output/8d39e609-03bf-4295-bc00-eb92810a39c5
  status: completed and harvested 2026-07-15
```

## Objective

Audit the corrected causal-operator metric identity and design the strongest
next formal theorem toward principal-symbol reconstruction without pretending
to construct a causal set, a wave operator, a probe algebra, dimension,
signature, or continuum convergence.

Semantic context pack:

```text
AgentTasks/context-packs/causal-operator-metric-20260715-20260715-064508.md
```

## Locked interpretation

1. `A` is an abstract characteristic-zero field representing scalar values at
   one evaluation point. It is not a function algebra or a causal set.
2. `L : A -> A` is deliberately not assumed linear for the three elementary
   cancellation identities. No locality or differential-operator claim follows
   from those declarations alone.
3. `addScalarPotential L V` is the pointwise scalar perturbation
   `u |-> L u + V * u`.
4. `correctedCarreDuChamp_eq_metricPair` assumes the exact product rule at the
   displayed pair `f,h` and `box 1 = 0`; it does not derive either premise.
5. The intended continuum application is `box = Box_g` and
   `metricPair = g^{-1}(df,dh)`, with a causal operator converging to
   `Box_g + V`. The current module proves only the algebraic cancellation.
6. Claim grade is `M [comp]`, because the principal-symbol product calculation
   is standard; the null-edge causal reconstruction remains conjectural.

## Required audit

1. Run only
   `lake env lean CausalOperatorMetricAudit/CausalOperatorMetric.lean`.
2. Verify every product order and the factor `1/2` over an arbitrary
   characteristic-zero field.
3. Check whether `correctedCarreDuChamp_comm` and the constant-annihilation
   theorem are correct without assuming linearity of `L`.
4. Check exact potential cancellation, including the `f * h * L 1` sign.
5. Audit whether the product-rule theorem has the right hypotheses and
   quantifier order for a pointwise principal-symbol identity.
6. Identify any false implication in calling this a metric bridge: bilinearity,
   derivation/chain rules, nondegeneracy, Lorentzian signature, dimension,
   locality, and convergence must remain separate obligations unless proved.
7. Recommend the strongest next Lean theorem in each of two layers:
   a convergence theorem showing joint convergence on `1,f,h,fh` transports
   the corrected pairing, and a function-algebra theorem giving bilinearity and
   first-order/chain properties from suitable second-order-operator axioms.
8. If a theorem or docstring needs correction, return exact replacement Lean.
   Do not weaken a correct statement or add geometric assumptions merely for
   prose convenience.

## Required report

Return command results, declaration-level semantic verdicts, exact corrections,
assumption/axiom footprint, and proposed signatures for the two successor
theorems. Finish with statement changes, proof holes, and every geometric or
analytic input that remains supplied.

## Submission record

- The live source passed direct Lean, its targeted build, and the aggregate
  `PhysicsSMDraft` build before submission.
- The exact focused upload passed
  `lake env lean CausalOperatorMetricAudit/CausalOperatorMetric.lean` after its
  Mathlib cache was populated; generated `.lake` dependencies were removed
  before upload.
- Submitted project: `8d39e609-03bf-4295-bc00-eb92810a39c5`.
- Submitted task: `b371397e-d354-4379-bfbb-1daf0ae70fcb`.
- Initial task state: `QUEUED`.

## Harvest record

- Final task state: `COMPLETE`.
- Harvested with
  `python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-causal-operator-metric-aristotle-2026-07-15.md 8d39e609-03bf-4295-bc00-eb92810a39c5`.
- Aristotle reran the required focused Lean command successfully with no
  diagnostics and found no statement, proof, sign, factor, or product-order
  defect.
- The audit confirms that the checked module is only an algebraic bridge.
  Locality, a probe algebra, causal-operator construction, convergence,
  dimension, nondegeneracy, signature, and scale remain separate obligations.
- Aristotle proposed joint convergence on exactly `1`, `f`, `h`, and `f * h`
  as the next analytic interface. The live module now contains the corresponding
  checked transport theorem, stated with four limits along one filter.
- Returned reports:
  `AgentTasks/aristotle-output/8d39e609-03bf-4295-bc00-eb92810a39c5/extracted/project-files.tar/causal-operator-metric-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`
  and `SEMANTIC_AUDIT.md` in the same directory.
