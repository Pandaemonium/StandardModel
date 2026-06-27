# Null-edge Aristotle Wave 10 submissions

Date: 2026-06-26.

Purpose: follow up on the mostly integrated Wave 9 results. The centerpiece is the exact Gate C obligation isolated by C19: prove or refute `OperatorForcesAlignment` from the actual tetrahedral Clifford symbol and branch kernels. c20 massive branch lifting is still running, so this wave avoids duplicating it.

| Slug | Type | Aristotle project | Target |
| --- | --- | --- | --- |
| c21-actual-clifford-symbol-branch-chirality | Proof/Audit | `6ee1e518-65b9-40c3-94c8-055d86f09078` | Build the actual tetrahedral Clifford symbol and discharge or refute OperatorForcesAlignment. |
| c22-branch-projectors-krein-signatures | Proof/Audit | `82bc44f9-4739-43b5-92e4-3291bbd57597` | Construct branch projectors and Krein signatures for the actual or conditional Gate C branch data. |
| d18-d0-positive-dec-proxy-plan | Strategy/Proof-scoping | `c25e2dc9-bb4f-4431-bfb0-d85b5df92c8c` | Turn Gate D0 into a theorem plan after finite square and null quadrature are assembled. |
| e12-fms-finite-composite-theorem-target | Proof/Audit | `a475b746-262d-417c-8af8-55ff534e3253` | Make FMS electroweak language theorem-level via a finite gauge-invariant link composite. |
| f15-genuine-prediction-candidate-ledger | Prediction/Strategy | `716104ab-26cb-4ace-a88a-4580baf994eb` | Find realistic structural prediction candidates after f14 concluded the counterterm codimension is reconstruction. |
| m12-p1-release-clean-crosswalk-patch | Manuscript/Audit | `8b043b4d-5bee-4e54-a679-36f8c1062978` | Prepare exact P1 crosswalk corrections after i7/m11 without applying them automatically. |

Notes:
- Focused packages are under `AgentTasks/aristotle-wave10-20260626/`.
- Full-repo submission is intentionally avoided because previous full-repo Aristotle submit failed on the local `SpherePacking` dependency.
- Returned Lean must be integrated into the full repository and checked before any trust claim.
- No local build or pre-commit is run by this submission step.

## Integration (2026-06-26)

Five of the six jobs completed and are integrated (c21 still running). Three new
kernel-checked Lean modules (e12, d18, c22) and two report-only deliverables (f15, m12).
All new theorems depend only on `propext, Classical.choice, Quot.sound` (no `sorry`,
no `native_decide`). The two focused packages shipped their `ARISTOTLE_SUMMARY.md`
but not the standalone `AgentTasks/*.md` reports; those summaries are preserved
verbatim as the named report files. Verified: `lake build PhysicsSMDraft` exit 0
(8687 jobs); 14 headline theorems `#print axioms`-clean.

| Job | Lean | Report | Headline |
| --- | --- | --- | --- |
| e12 | **new** `PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean` | `null-edge-fms-finite-composite-report-2026-06-26.md` | **Gate E, theorem-level FMS.** Non-abelian electroweak link stiffness `linkStiffnessEW = sum_e ||U_e H_t - H_s||^2` with exact gauge invariance (`linkStiffnessEW_gauge_invariant`). Orbit stiffness: `holonomyCost_eq_zero_iff_stabilizer` / `_pos_of_not_stabilizer`; `massForm_eq = (v^2/8)(x0^2+x1^2+(x2-x3)^2)`, `massForm_kernel = span{Q} = u(1)_em` (unique photon direction). Corrected FMS composite `H_s^dagger tau^a U_e H_t` with `fmsSinglet_gauge_invariant`; W/Z leading-term theorems `fms_leading_W` (`(v^2/4)(x0 - i x1)`), `fms_leading_Z` (`(v^2/4)(x2 - x3)`), `fms_linear_expansion_W` (vacuum constant vanishes). Coefficients isolated: `mW = gv/2`, `mZ = sqrt(g^2+g'^2)v/2`, `massForm_physical_normalization`. Reuses `NullEdgeElectroweakStabilizer`. Gauge-invariant orbit-stiffness reconstruction with explicit W/Z leading term -- NOT a completed pole/two-point composite-spectrum theorem. |
| c22 | **new** `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean` | `null-edge-c22-branch-projectors-krein-report.md` | **Gate C branch projectors + Krein signatures, CONDITIONAL.** Branch-projector algebra over the existing `Pbranch`: idempotence, orthogonality, symmetry, rank-one (`Pbranch_trace = 1`), completeness (`sum_a P_a = Pnull`). `branchChirality a = tr(Gs P_a) = g5 a` (`branchChirality_eq`), reconnecting C19's index `tr(GammaFlavOp s . Pnull) = sum_a s_a . branchChirality a`. Krein signatures (modeled `kreinJ`): `branchKreinSig a = tr(J P_a) = (-1)^a`, pattern `(+,-,+,-)`, sum zero (signature `(2,2)`), `exists_krein_negative_branch`. **Overclaim guards:** `kreinSig_ne_chirality` (Krein pattern `(+,-,+,-)` != chirality `(+,+,-,-)`), `modeled_release_not_kreinPositive` (aligned chirality does NOT entail Krein positivity), `branch_krein_no_stability_guard` (re-export: Krein J-self-adjointness alone != stability). Residual obligation `ReleasesKreinPositive` stated as `Prop`, not assumed. Computed against **modeled** (not operator-forced) gradings; promotion to a forced Gate C statement remains PENDING on C21 supplying the actual tetrahedral Clifford symbol eigenspaces. |
| d18 | **new** `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean` | `null-edge-d18-d0-positive-dec-proxy-plan.md` | **Gate D0 proof contract + positive-proxy scaffold.** Mathlib-only, builds standalone. Two proven positive faces: `scalar_inverse_gram_nonneg` (PosSemidef Gram => nonnegative quadrature, positive face of d17), `connection_laplacian_nonneg` / `connection_laplacian_energy_eq` (`sum_a T_a* T_a >= 0`, positive face of b17 `K_null`), plus `euclidean_edge_energy_nonneg`. Open D0 obligations stated as `structure`/`def` contracts (`D0SymbolData`, `D0SymbolContract` for `[D_h,M_f]=c(df)+O(h)`, `D0QuadratureContract`) -- specified, not asserted, so no `sorry`. Report gives the D0 hypothesis table (`D0_ONLY` positive-metric assumptions vs Lorentzian/Krein replacements, explicit non-inheritance rule) and the full Gate D dependency DAG. No continuum/Krein/stability claim. |
| f15 | (none -- audit) | `null-edge-f15-genuine-prediction-candidate-ledger.md` | **Prediction-candidate ledger.** 13-row moduli table for the finite P2 architecture, each tagged Free / Convention-fixed / Posited-constraint / Operator-determined. Verdict generalizes f14: the EFT-rich moduli (`Phi_H`, Higgs potential, spectral function, cutoff, irrelevant ops) are all currently *free*, so `F : M_finite -> M_EFT` is full-rank on the EFT sector -- **nothing formalized is yet a Gate-F prediction.** Ranked first-prediction targets: (1) operator-forced branch chirality / flavored-index rigidity (gated on the unproven falsifiable `OperatorForcesAlignment`), (2) anomaly-selected hypercharge codimension, (3) forbidden-Pauli coefficient. Proposes exact `sorry`-handoff Lean statements; no new axioms. |
| m12 | (none -- manuscript patch, **not auto-applied**) | `null-edge-m12-p1-release-clean-crosswalk-patch.md` | **P1 crosswalk patch text.** Verified the i7 convention banners *did* land in both trusted Spinor files, but the P1 manuscript + publication plan are still in their pre-correction overclaiming state (the prose fixes prior notes reported "applied" were never written). Provides O1-O7 (seven overclaim locations for the absent `TwistorPluckerMass` module), U1-U7 (upgrades for the now-bannered SL(2,C) covariance + masslessness interface, incl. `spinorAction`->`actSpinor` fix), and Patches A-F (exact replacement blocks). Verdict: P1 is "release-clean after the convention-banner rebuild", not "release-clean now". Left as recommendation -- manuscript is user-owned. |

Not auto-applied (deliberate, user-owned): m12 proposes corrective edits to
`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` and
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md` (downgrade the over-marked
twistor rows, upgrade the now-bannered SL(2,C) covariance rows). These are honest
overclaim fixes but they edit user-owned manuscript files, so they are captured in
the report rather than applied here -- consistent with how i7/m11 were handled.
