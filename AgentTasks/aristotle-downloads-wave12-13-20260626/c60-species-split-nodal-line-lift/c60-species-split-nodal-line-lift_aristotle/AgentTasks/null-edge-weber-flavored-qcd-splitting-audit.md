# C45/C46 Weber flavored-QCD no-fine-tuning audit -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 99fc50dc-f096-45ef-a30c-95036212a070
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Completed the C45/C46 Weber flavored-QCD no-fine-tuning audit for the Route B splitting `M_split = r·T` (= `r·T_lin`), delivering both requested artifacts.

## Deliverables

1. **Report** `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md` — a full adversarial audit covering all five tasks, with a forced/constrained/tunable/fatal classification table and an explicit Gate F prediction-language section.

2. **Lean module** `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean` — standalone (`import Mathlib` only, so independent of the currently-broken sibling imports), with seven theorems all proved (no `sorry`, only the standard `propext`/`Classical.choice`/`Quot.sound` axioms; verified by full re-elaboration with zero errors/warnings).

## Findings (verdict: TUNABLE — a protected modulus at best, not a prediction)

- Weber's arXiv:1611.08388 mechanism is a *technical-naturalness* result (it forbids competing taste-breaking counterterms via a C/reflection determinant-evenness argument), **not** a coefficient-fixing result. "No fine-tuning" ≠ "symmetry-forced coefficient" — this distinction is the pivot of the audit.
- Machine-checked adversarial core:
  - `g5_not_S4_invariant`: the full tetrahedral symmetry S₄ does **not** force the `(+,+,-,-)` pattern (only constants are S₄-invariant, `invariant_iff_const`).
  - `partitions_in_one_S4_orbit`(`'`): the three `2+2` pairings lie in one S₄ orbit ⇒ the partition is a non-canonical discrete (Z₃) modulus unless an external selector is exhibited.
  - `direction_forced_scale_free`: choosing a partition + tracelessness forces the *direction* `s = (s 0)·g5`, but the surviving free parameter is exactly the scale `s 0 = r`.
  - `coeff_modulus_injective` / `coeff_range_full` / `weber_best_case_still_a_modulus`: the coefficient `r` is a genuine injective real modulus; even granting the strongest Weber-style direction-forcing, `r` stays free.
- Hidden tunable parameters identified: the coefficient `r` (always free), the `2+2` partition (discrete Z₃, until a canonical C/reflection + preferred-covector selector is proven), and operator-realization/range freedom (`T` vs `T_lin` vs point-split projectors). The existing tree's Krein-vs-chirality pattern mismatch (`kreinSig_ne_chirality`) is flagged as direct evidence against a naive partition selector.

## Gate F impact

A free `r` adds a coordinate to `M_finite` that generically maps to an independent EFT direction, so it cannot contribute to a `rank(dF) < dim M_EFT` deficit. Therefore prediction language at the level of `r` must stay **off**. At best — and only if a canonical pairing-selecting symmetry of the tetrahedral operator is actually exhibited — Weber's argument yields a *structural* forbidden-counterterm/forced-texture prediction (the same admissible category as the existing `forbidden_counterterm_codimension` result), never a magnitude prediction. Two residual obligations that would change the verdict are stated precisely in the report.

Note: the pre-existing sibling files in `PhysicsSM/Draft/` import modules absent from the project (e.g. `TetrahedralHighMomentumNullBranch`, `KreinDoubleAndCounterexamples`), so a whole-project `lake build` fails for reasons unrelated to this task; the new module was kept standalone and verified independently.
