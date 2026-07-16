# Finite causal-order operator: Aristotle semantic audit

```yaml
aristotle:
  project_id: ff45b96a-3412-44f2-b0b1-c8b8f179ce80
  task_id: 96f20f5a-4531-4558-a9cb-031fa2ca8873
  target_file: PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
  submission_project: AgentTasks/aristotle-submit/finite-causal-order-operator-20260715-project
  output_dir: AgentTasks/aristotle-output/ff45b96a-3412-44f2-b0b1-c8b8f179ce80
  status: completed and harvested 2026-07-15
```

## Objective

Audit the first concrete finite causal-order realization of the causal-operator
metric bridge. Check the exact Benincasa-Dowker local and smeared four-dimensional
coefficients, finite-order combinatorics, order-isomorphism covariance,
inverse-square scaling, and function-level corrected pairing without attributing
dimension, Lorentzian signature, manifold reconstruction, or continuum
convergence to the checked declarations.

Semantic context pack (generated against the existing repo index after a full
index refresh timed out):

```text
AgentTasks/context-packs/finite-causal-order-operator-20260715-20260715-075538.md
```

Primary source conventions:

- Benincasa and Dowker, arXiv:1001.2725, equations (2), (8), and (9).
- Belenchia et al., arXiv:1510.04656, Hawking-Ellis sign convention for the
  source continuum operator. The project uses the opposite `(+---)` wave-
  operator sign, represented by an explicit overall negation.

## Locked interpretation

1. `FiniteCausalOrder` bundles a finite strict order through irreflexivity and
   transitivity. The combinatorial operator and covariance proofs need only the
   relation and decidability; they do not derive those order laws.
2. `OpenInterval C y x` is the set of events strictly after `y` and strictly
   before `x`. `pastLayer C n x` therefore selects past events `y` with exactly
   `n` intervening events.
3. `sourceLocal4DOperator` is the source-sign four-dimensional local retarded
   causal-set operator. `projectLocal4DOperator` is exactly its negation.
4. `sourceSmeared4DOperator` implements the broad nonlocal kernel with
   `epsilon = (ell / nonlocalityScale)^4`. The explicit `epsilon = 1` branch
   preserves exact local reduction despite totalized division in Lean.
5. The same-scale reduction is an algebraic statement under `ell != 0`; a
   physical use still owes positive microscopic and nonlocality scales.
6. `OrderIso` proves covariance only under finite event relabeling preserving
   the order relation. It does not transport scale assignments, probe choices,
   a manifold embedding, a tetrad, or a spin structure.
7. `correctedPairingAt` is now a genuine function-level expression: the
   operator receives `1`, `f`, `h`, and `f*h` as fields before evaluation at an
   event. Exact scalar-potential cancellation is algebraic, not a convergence
   theorem.
8. The two-event witness establishes nonvacuity of the layer sum only. It is not
   a four-dimensional causal-set witness.
9. Claim grade is `M [comp]` for the finite algebra and covariance. The
   continuum reconstruction remains conjectural and separately gated.

## Required audit

1. Run only
   `lake env lean FiniteCausalOrderOperatorAudit/FiniteCausalOrderOperator.lean`.
2. Check that `FiniteCausalOrder` is a strict finite order and that prose does
   not imply irreflexivity or transitivity are used where the proofs only use
   relation preservation.
3. Verify the orientation of `OpenInterval`, the layer convention, and exact
   preservation of interval counts under `OrderIso`.
4. Verify the local coefficient sequence `[1, -9, 16, -8]` and prefactor
   `4 / (sqrt 6 * ell^2)` against equations (2) and (8) of arXiv:1001.2725.
5. Verify every factor and falling-factorial term in the smeared kernel against
   equation (9), including the `epsilon = 1` branch and exact local reduction.
6. Audit the source/project sign conversion against the stated metric
   conventions. Flag any claim that requires a convention beyond an overall
   wave-operator sign.
7. Check all relabeling proofs and state precisely what they do not establish:
   scale, probe, embedding, dimensional, signature, or continuum covariance.
8. Verify the exact inverse-square scale theorem and whether its hypotheses are
   algebraically and physically described correctly.
9. Verify the function-level corrected pairing, its symmetry, exact scalar-
   potential cancellation, and equivariance for the local and smeared project
   operators.
10. Check the nonvacuity witness and all displayed axiom guards.
11. Identify any false implication that the module proves four-dimensionality,
    Lorentzian signature, locality, consistency, concentration, or continuum
    convergence. None may be inferred merely from the coefficient choice.
12. Recommend the strongest next Lean theorem toward an intrinsic probe sector
    that can connect this concrete finite operator to the existing abstract
    convergence-transport theorem without supplying the desired metric by
    assumption.
13. If a declaration or docstring needs correction, return exact replacement
    Lean. Do not weaken a correct theorem.

## Required report

Return the command result, declaration-level semantic verdicts, source-formula
audit, exact corrections if any, assumption/axiom footprint, overclaim audit,
and a proposed signature for the strongest successor theorem. Finish with
statement changes, proof holes, and every geometric or analytic input still
supplied rather than derived.

## Submission record

- The live source passed
  `lake env lean PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`
  before packaging.
- Context generation succeeded, but the preceding full semantic-index refresh
  timed out; the pack therefore used the existing index.
- The focused package initially needed an explicit `PhysicsSM` library root.
  After that packaging correction, the exact required command passed with exit
  code 0. Generated `.lake` dependencies were removed before upload.
- Submitted project: `ff45b96a-3412-44f2-b0b1-c8b8f179ce80`.
- Submitted task: `96f20f5a-4531-4558-a9cb-031fa2ca8873`.
- Initial task state: `QUEUED`.

## Harvest record

- Final task state: `COMPLETE`.
- Harvested with
  `python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-finite-causal-order-operator-aristotle-2026-07-15.md ff45b96a-3412-44f2-b0b1-c8b8f179ce80`.
- Aristotle reran the exact focused Lean command with exit code 0 and no
  diagnostics. The audited source was unchanged, contained no proof holes,
  and matched the local coefficients, prefactor, smeared kernel, endpoint
  branch, sign negation, and scale law in the cited source conventions.
- No theorem statement or proof correction was required. Three module-doc
  tightenings were applied: covariance is explicitly event-relabeling at fixed
  numerical scales, the project sign is only an overall algebraic negation,
  and the claim grade is the locked `M [comp]`.
- Aristotle proposed an order-natural `IntrinsicProbeSector` and a concrete
  varying-carrier convergence theorem whose target is constructed from six
  independent scalar limits. Both are now implemented and kernel checked as
  `IntrinsicProbeSector` and
  `tendsto_intrinsicProbePairing_projectSmeared4D`; no target metric, rank, or
  signature is assumed.
- Returned reports:
  `AgentTasks/aristotle-output/ff45b96a-3412-44f2-b0b1-c8b8f179ce80/extracted/project-files.tar/finite-causal-order-operator-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`
  and `SEMANTIC_AUDIT.md` in the same directory.
