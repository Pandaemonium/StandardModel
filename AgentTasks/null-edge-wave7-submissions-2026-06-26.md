# Null-edge Aristotle Wave 7 submissions

Date: 2026-06-26.

Purpose: launch the next literature-informed no-build Aristotle wave after the DEC, graph-species, quiver spectral-action, FMS, finite spectral-triple, and generalized Lichnerowicz literature pass.

| Job | Aristotle project | Focus | Package |
| --- | --- | --- | --- |
| d13-dec-hodge-dirac-convergence | `6a41d1e8-ebd1-4458-aaf4-8bf295b138ab` | D13 DEC Hodge-Dirac convergence adaptation strategy | AgentTasks/aristotle-wave7-20260626/d13-dec-hodge-dirac-convergence |
| c17-c18-spectral-graph-flavored-chirality | `dfe4f606-002d-486f-8a02-e341247bed47` | C17/C18 spectral-graph species and flavored chirality audit | AgentTasks/aristotle-wave7-20260626/c17-c18-spectral-graph-flavored-chirality |
| e11-f12-quiver-spectral-action-parameter-audit | `081b4816-ee9b-482b-9d44-1990982d33c7` | E11/F12 quiver spectral-action novelty and parameter-count audit | AgentTasks/aristotle-wave7-20260626/e11-f12-quiver-spectral-action-parameter-audit |
| d14-d15-connection-causal-falsification | `73233ce4-6b13-4e68-939f-398063be5b50` | D14/D15 connection-Laplacian and causal dAlembertian falsification audit | AgentTasks/aristotle-wave7-20260626/d14-d15-connection-causal-falsification |
| h11-d16-finite-spectral-triple-super-dirac | `0a90837b-d105-4b60-8213-7f2965c9f5c8` | H11/D16 finite spectral-triple moduli and generalized Lichnerowicz audit | AgentTasks/aristotle-wave7-20260626/h11-d16-finite-spectral-triple-super-dirac |
| wave8-master-strategy-after-literature | `5b6f7fe8-93bb-4408-adfd-c06ecd9fb115` | Wave 8 master strategy after literature and Wave 7 audits | AgentTasks/aristotle-wave7-20260626/wave8-master-strategy-after-literature |

Notes:
- These are no-build strategy/audit packages.
- Each package includes COMMON_CONTEXT.md plus copied planning docs current at submission time.
- Integrate returned jobs semantically before launching proof-heavy Wave 8.

## Integration (2026-06-26)

All six jobs integrated as no-build strategy/audit deliverables (markdown placed in
`AgentTasks/`, oddly-cased filenames normalized to the `null-edge-` convention):

| Job | Deliverable(s) | Headline |
| --- | --- | --- |
| d13-dec-hodge-dirac-convergence | `null-edge-dec-hodge-dirac-convergence-strategy.md` | Null-edge operator is a soldered Clifford-module (FEEC/connection-Laplacian) Dirac op, NOT de Rham `d+delta`. Verdict **conditional**: inherit the cochain scaffold + connection-Laplacian lane, but do NOT inherit the Dabetic-Hiptmair convergence theorem (no SPD Hodge star under the null Gram; Krein doubling violates its hypotheses). |
| c17-c18-spectral-graph-flavored-chirality | `null-edge-c17-c18-gate-c-audit.md` | Gate C `FATAL-FOR-NAIVE-FLAT`/`PENDING`; proposes a **flavored chirality** `Gamma_f = Gamma_s . T` from the tetrahedral taste structure and the flavored index `tr(Gamma_f P_null)` as the release criterion. (See Lean-draft note below.) |
| e11-f12-quiver-spectral-action-parameter-audit | `null-edge-e11-f12-quiver-spectral-action-audit.md` | Operator-unification layer is **reconstruction** (special case of published quiver/finite-spectral-triple theory, arXiv:2401.03705); only the Plucker finite identities stand apart. Recommends a forbidden-counterterm **codimension** theorem as the single realistic first prediction target. |
| d14-d15-connection-causal-falsification | `null-edge-connection-laplacian-convergence-audit.md`, `null-edge-causal-dalembertian-falsification-probe.md` | D14: 10-row connection-Laplacian convergence checklist; the non-Hermitian retarded `D_+` conflicts with the symmetric-elliptic hypotheses, so converge the symmetric (Krein) square and recover causality separately. D15: null-edge operator is **local** (Boguna-Krioukov column, not Sorkin/ASS nonlocal); 8-probe falsification checklist, settle symbol-level stability first. |
| h11-d16-finite-spectral-triple-super-dirac | `null-edge-h11-d16-finite-spectral-triple-moduli-lichnerowicz-audit.md` | The target square **is** the generalized Lichnerowicz formula of a Dirac-Yukawa operator; `Phi_H` is a separate chi_E-odd Krein-self-adjoint Yukawa map inside (not equal to) the Cacic finite-Dirac moduli. Gate H forces Gate A to finish; run H11 as a prediction gate measuring internal free-parameter dimension. |
| wave8-master-strategy-after-literature | `null-edge-wave8-master-strategy.md` | Two-track Wave 8 plan (Track FIN now; Track CONT gated on a nonfatal Gate C), kill-switch/downgrade matrix, the 5 ripest Lean proof jobs (A1, H1, H3, B6/B9, C16) and 5 no-build audits, and the publication sequence (P1 -> P1.5; hold the branch/Krein audit as the standing hedge). |

Lean-draft dedup decision: the c17-c18 package also shipped a verified
`RequestProject/TetrahedralNodalStructure_Draft.lean` (`decide`-proved, no sorry in live
code). It was **not** integrated as a module: all of its proved theorems (the `(pi,pi,pi,0)`
mass-shell null branch with nonzero coefficient vector, exactly 5 null corners, all-pi and
single-axis corners gapped) are already proven in a stronger Lorentzian form in
`PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean` (wave5). Its genuinely-new content
(the flavored-chirality `Gamma_f` existence + the `tr(Gamma_f P_null)` species-imbalance index,
and the Krein-double index) is `sorry`-staged and becomes a real proof target once a `Gamma_f`
operator is committed -- a Wave 8 job, not this integration.

All seven docs are recommendations/audits, not proofs; no Lean source, CONVENTIONS.md, or
manuscript change is performed here. Several cite papers worth curating via
`Scripts/lit/lit_ingest.py` (e.g. arXiv:2401.03705 quiver spectral action, 2603.12882 lattice
FMS, 2505.07923 Furey, 2506.18745 Boguna-Krioukov) if not already in the collection.
pre-commit clean.
