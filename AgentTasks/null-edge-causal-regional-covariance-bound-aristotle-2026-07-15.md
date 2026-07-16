# Regional causal-operator covariance bound: Aristotle task

```yaml
aristotle:
  project_id: 24bb1a3f-a6b2-4f6e-9e9a-2e24a2b1f92c
  task_id: 406fd5e5-26e3-49b7-ade7-ba1bdd2507b8
  target_file: RegionalCovarianceBound.lean
  expected_module: RegionalCovarianceBound
  submission_project: AgentTasks/aristotle-submit/causal-regional-covariance-20260715-project
  output_dir: AgentTasks/aristotle-output/24bb1a3f-a6b2-4f6e-9e9a-2e24a2b1f92c
  status: complete and integrated 2026-07-15
```

## Objective

Prove the two displayed finite theorems without weakening their statements and
audit what additional graph geometry would be required to apply them to the
A44 compact regional causal operator.

The live program now has:

- an exact bit-packed transitive relation and exact per-pivot interval counts;
- a relabeling-covariant tied count-depth selector;
- one finite continuum target per selected pivot;
- all four affine and all ten symmetric quadratic row channels;
- a literal diagonal/off-diagonal residual-square ledger;
- one `N=100000`, 16-pivot development graph with Lorentzian regional mean but
  metric error `0.546` and major-channel effective pivot counts around `4-12`.

This is not a concentration result. The task is to formalize a correct
dependency-degree upper bound and identify the missing physical hypotheses,
not to retrofit a pass to the observed graph.

Semantic context pack:

```text
AgentTasks/context-packs/causal-regional-covariance-20260715-220258.md
```

The preceding semantic-index refresh timed out locally after two minutes. The
context pack completed from the existing index, and the decisive live files
and artifacts are included directly in the focused package.

## Exact theorem reading

For `m>0`, `C i j` is an ordered covariance contribution. Each row has a
declared neighbor set excluding itself, of cardinality at most `degree`.
Diagonal entries are at most `sigmaSq`; neighbor covariances are at most
`kappa*sigmaSq`; every undeclared off-diagonal covariance is nonpositive. The
target is

```text
averageCovariance <= sigmaSq * (1 + degree*kappa) / m.
```

The theorem intentionally retains negative outside covariance. Do not replace
it by an absolute-covariance bound, add symmetry, assume independence, or hide
positivity. Ordered neighbor sets are permitted because the live ledger uses
ordered off-diagonal sums.

The second theorem should compose that finite bound with Mathlib's Chebyshev
inequality. It remains conditional on `variance A mu <= averageCovariance`.

## Required work

1. Run `lake env lean RegionalCovarianceBound.lean` first.
2. Prove both theorems with no proof holes, extra assumptions, unsafe code, or
   changed definitions.
3. Add small helper lemmas if they make the finite sum decomposition legible.
4. Add `#print axioms` results or a concise axiom report.
5. Return `REGIONAL_COVARIANCE_AUDIT.md` explaining:
   - whether the theorem's factor is sharp under its hypotheses;
   - how directed versus symmetric neighbor declarations affect the bound;
   - which exact graph predicates could define neighbors from overlap of
     tapered Alexandrov germs;
   - what must be proved to obtain finite `degree` and `kappa` along a
     refinement family;
   - why the one-graph effective pivot counts are not estimates of those
     constants;
   - the smallest honest multi-graph A44N development schedule suggested by
     the supplied `N=100000` resource and residual results.
6. End with an implement/revise/stop verdict. Do not claim continuum GR,
   concentration, or an `N=400000` authorization.

## Locked claim boundary

The Lean kernel can verify the conditional finite inequality. It cannot prove
that the A44 random rows realize `C`, that non-neighbor covariances are
nonpositive, or that overlap degree and covariance ratio remain bounded. Those
are the substantive geometric/probabilistic debts and must remain explicit.

## Submission record

- The live standalone source passed
  `lake env lean AgentTasks/aristotle-standalone/causal-regional-covariance-20260715/RegionalCovarianceBound.lean`
  with exactly two explicit proof handoffs.
- The focused package fetched the pinned Mathlib cache and passed
  `lake env lean RegionalCovarianceBound.lean` with the same two handoffs.
- Submitted project: `24bb1a3f-a6b2-4f6e-9e9a-2e24a2b1f92c`.
- Submitted task: `406fd5e5-26e3-49b7-ade7-ba1bdd2507b8`.
- Initial project state: `RUNNING`; initial task state: `QUEUED`.
- Follow-up task state: `IN_PROGRESS` while the project remains `RUNNING`.

## Harvest and integration

- Aristotle returned both theorem proofs with unchanged definitions and
  hypotheses, plus `REGIONAL_COVARIANCE_AUDIT.md`.
- The returned source passed the pinned command
  `lake env lean RegionalCovarianceBound.lean`.
- The proof bodies were integrated into the standalone handoff and
  `PhysicsSM/Draft/NullEdge/RegionalCovariance.lean`.
- The live module adds build-enforced axiom guards. Both the finite covariance
  bound and its conditional Chebyshev wrapper use only `propext`,
  `Classical.choice`, and `Quot.sound`.
- No proof handoff remains in either integrated file.

Semantic review preserved the ordered covariance ledger, directed neighbor
sets, nonpositive undeclared entries, explicit physical variance hypothesis,
and every positivity assumption. The theorem does not establish those
hypotheses for A44 rows.

The audit's recommended three-fresh-graph `N=100000` development pilot was run
independently and passed its frozen empirical gate. The later implementation
trace shows that the current global pivot selector and predecessor future
counts make the conservative read-overlap graph complete. This blocks a
bounded-degree application without an additional covariance-decay theorem or
a localization redesign.
