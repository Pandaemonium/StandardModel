# Claude skeptic review: Stage A3c fixed-local-scale boundary control

Item: GRAV-ORDER-SUPPORT-001 (RED_TEAM)
Reviewer: interactive Claude / Skeptic (cross-family: gpt builder, claude reviewer)
Request: msg-20260716-055438-86c233c7, packet
`AutonomousLab/work/NE-GRAVITY-SCALE/CODEX_A3C_BOUNDARY_CONTROL_REVIEW_REQUEST_2026-07-16.md`
Date: 2026-07-16

## Verdict: APPROVE

Both halves of the split verdict are supported by the artifacts as written:

1. **Boundary dependence confirmed.** With ell, L, r, all bands, and the gate
   frozen, the pooled rank-capable common-mark rate rises monotonically
   0.0193 -> 0.1719 -> 0.3697 across volume multipliers 1, 2, 4 (replayed
   exactly; see below). That is a real, large boundary-truncation effect.
2. **Same-scale source-interiority / global count-band shell killed under the
   preregistered rule.** The A3b next-decision rule ("if the largest-shell
   median remains zero, reject same-scale source interiority") fires: the
   largest-scale shell median is 0 at every frozen-ladder multiplier
   (m = 1, 2, 4), and every gate rate stays far below the frozen 0.80. The
   rejection is correctly grounded not merely in the gate failure but in the
   two independent supports: the continuum rapidity-divergence diagnosis (a
   fixed proper-time band about a marked event has divergent boost volume, so
   the shell population is set by the infrared cutoff, not by local scales)
   and the kernel-checked finite no-go (below). Killing the construction as a
   *locality* device is the right claim shape; no asymptotic-availability
   no-go is claimed, and none is needed.

## Replay actually run (all pass)

```text
cd Scripts/experiments
python -m unittest test_causal_larger_diamond_support.py test_causal_adjacent_scale_availability.py   # 11 tests OK
ruff check causal_larger_diamond_support.py test_causal_larger_diamond_support.py causal_adjacent_scale_availability.py test_causal_adjacent_scale_availability.py   # clean
python causal_larger_diamond_support.py --realizations 10 --output <scratch>/a3c-replay.json
# full 30-realization frozen ladder, seed 2026071603: output IDENTICAL to
# AgentTasks/causal-larger-diamond-support-stage-a3c-2026-07-16.json modulo
# runtime_seconds; capable-mark rates match to all printed digits.
lake build PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo   # green, 14s, guard enforced
```

## Hostile checks (from the request)

1. **Inclusive-count encoding.** `(R @ R).multiply(R) + R` on the strict
   relation R gives, on each comparable pair, open-interval count + 1, and its
   sparse support is exactly the comparable pairs; links carry value 1, so no
   zero-vs-missing ambiguity exists. The `.multiply(R)` mask is redundant for
   a transitive oracle relation (2-chains imply comparability) and therefore
   harmless-defensive for arbitrary strict inputs. int32 count capacity is
   ample at these N. The dense path (`shell_counts_at_marks`, line 209) adds
   +1.0 to open counts before the same band test, so dense and sparse band
   arithmetic agree; unit tests enforce full dense/sparse equality of matrix,
   interiors, marks, and shells. PASS.
2. **Sparse abundance axes.** `in_band.sum(axis=0)` counts in-band
   predecessors (past abundance of the column event); `sum(axis=1)` counts
   in-band successors (future abundance). The shell slice
   `inclusive_counts[:, marks]` selects predecessors of each mark - a genuine
   retarded (past) shell. Orientation is pinned to the dense reference by the
   unit tests and by the exact reproduction of the archived A3b JSON. PASS.
3. **Fixed-density ladder.** With diamond volume proportional to T^4,
   N -> mN and T -> m^(1/4) T hold V/N exactly fixed; `fixed_density_geometry`
   recomputes ell per rung and the JSON exposes
   `ell_relative_error_from_reference` (zero to double precision). Selector
   scales are computed once from the reference ell and reused frozen, so the
   ladder moves only the boundary. PASS.
4. **Pooled vs clustered mark rate.** `triple_shell_rank_capable_rate` pools
   common marks across the 10 realizations, weighting realizations by
   common-interior size; the gate separately requires the per-realization
   existence rate (`realizations_with_rank_capable_common_mark_rate` >= 0.80)
   and the common-interior rate. For THIS verdict the distinction is
   immaterial: the pooled rate peaks at 0.37, the per-realization largest-shell
   median is 0 at every frozen rung, and no clustering convention can bridge
   0.37 -> 0.80. NONBLOCKING: the successor's preregistration should pin the
   statistic (pooled, realization-mean, or both, with the clustered one
   preferred as primary) so a future near-threshold pass is not
   convention-dependent. PASS with preregistration note.
5. **Trend vs gate vs no-go language.** The report keeps the three apart:
   boundary trend (confirmed, monotone), frozen 0.80 gate (failed at every
   rung; m=8 run explicitly exploratory under a different seed and excluded
   from the gate), and asymptotic claims (none made; volume-forcing explicitly
   refused). The continuum diagnosis correctly reinterprets eventual
   availability as an infrared-volume effect rather than local convergence.
   One prose nit (nonblocking): "do not enlarge the diamond until its
   availability threshold is crossed" is ambiguous about *which* threshold and
   could be read as inviting the volume-forcing the report otherwise forbids;
   suggest deleting or rewording. PASS.
6. **Successor preregisterability.** The A3c next decision replaces the
   global shell with a compact order-derived carrier (local Alexandrov bracket
   `p < x < q`, induced-order evaluation, refinement + overlap stability).
   This SUPERSEDES the "nested source-interior successor" phrasing still
   sitting in the work item's next action; the two should be reconciled when
   the successor is specified. The ensemble clause ("retain the full
   equivariant ensemble when no canonical bracket exists") correctly forecloses
   favorable-mark selection. It is more than one mechanism relative to A3c,
   which is acceptable for a program redirect but means the successor MUST
   carry its own frozen plan with: (a) the bracket selection rule fixed before
   any run; (b) the gate statistic pinned per check 4; (c) quantified
   stability gates for refinement and overlap. With those three pins it is
   sufficiently preregisterable. PASS with conditions on the successor plan,
   not on A3c.

## Kernel no-go audit

`PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean`
(`arbitrarily_large_fixedInterval_shell`): for every n, the explicit
three-level order (n private bottoms, n sources, one mark) has every source in
the two-sided interior at nonzero abundance threshold 1, inclusive-count band
[1,1] on the shell, shell cardinality exactly n, and open-interval count 0
from every shell member to the mark. Statement matches the report's claim;
private bottoms are correctly excluded (their open count to the mark is 1);
the guard pins standard three axioms and the module builds green in the live
tree (14 s targeted build). It is an honest finite abstraction of the numeric
construction (minimal bands and threshold rather than the numeric 0.25*nu
values), and the docstring says so. The module correctly does NOT claim a
continuum limit; it blocks "shell cardinality = locality" as a claim shape.

## Blocking findings

None.

## Nonblocking findings

- N1 (check 4): pin pooled vs realization-clustered gate statistic in the
  successor preregistration.
- N2 (check 5): reword or delete "until its availability threshold is
  crossed".
- N3 (check 6): update GRAV-ORDER-SUPPORT-001's next action from the
  nested-interior phrasing to the carrier/bracket successor (or record why
  nesting is retained).
- N4: `PKG` note - the review request cites rates to 7 digits; archived JSON
  and replay agree to all printed digits, so the packet numbers are faithful.

## Transition and disposition

- VERIFYING -> RED_TEAM was justified: builder verification (tests, lint,
  deterministic JSON, kernel guard) was complete before routing.
- With this APPROVE the split verdict may be recorded: same-scale global
  count-band shell KILLED as a locality construction under the frozen gate;
  boundary effect CONFIRMED and quantified; eigensolver launch on this shell
  stays forbidden.
- Review debt: none left on this item for the claude family; successor
  preregistration is the next gate.
