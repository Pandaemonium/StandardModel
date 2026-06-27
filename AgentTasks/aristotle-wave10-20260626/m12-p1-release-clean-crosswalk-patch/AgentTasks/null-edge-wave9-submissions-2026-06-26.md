# Null-edge Aristotle Wave 9 submissions

Date: 2026-06-26.

Purpose: follow up on the integrated Wave 8 proof wave by turning the Gate A
bridge and Gate C flavored-chirality mechanism into release criteria, publication
cleanup, and the next finite square/quadrature theorems.

(Note: the original submission table was regenerated here; the first write was
corrupted by a PowerShell here-string templating bug.)

| Slug | Type | Aristotle project | Target |
| --- | --- | --- | --- |
| c19-gate-c-release-forced-flavored-chirality | Proof/Audit | `e6c265e2-dd5f-479e-9c55-d1ac7ababd4a` | Gate C release: force flavored-chirality signs from the actual operator (**integrated**; see below) |
| c20-massive-branch-lifting-audit | Proof/Audit | `2869964e-5656-4eb5-9b72-1b24c64a0ab7` | Massive branch lifting for `det(iD_+ + Gamma_s Phi_H)` |
| b17-post-gate-a-finite-lichnerowicz-square | Proof | `c6270c7a-f02a-495c-91a5-252f1493d617` | Post-Gate-A finite dual-soldered Lichnerowicz square |
| d17-scalar-gauge-null-quadrature | Proof | `a26418a2-01a3-4278-b1e3-058a5763581f` | Scalar/gauge null quadrature and Higgs-gradient reconstruction |
| i7-plucker-trusted-convention-banner | Audit/Patch | `e45b5294-03a2-4912-8d63-5ec5d4426f49` | Trusted Plucker convention banner and P1 crosswalk cleanup |
| f14-counterterm-codim-to-prediction-ledger | Prediction/Audit/Proof | `ba3b4861-26d4-4af9-8ce5-120e63f3ef36` | Forbidden-counterterm codimension to prediction-ledger bridge |
| m11-p1-p15-release-crosswalk-after-wave8 | Manuscript/Audit | `a5957a05-cdcf-4bf3-bcf0-fb6720dfdc48` | P1/P1.5 release crosswalk after Wave 8 |

Notes:
- The first full-repo submit attempt failed because Aristotle does not support the
  repo local dependency `SpherePacking`; the successful submissions use focused packages.
- Focused packages include selected Lean/source/doc snapshots plus prompts. Returned
  Lean should be integrated into the full repo before trust claims.
- No local build or pre-commit was run as part of submission.
- Submit outputs are stored beside the prompts in `AgentTasks/aristotle-wave9-20260626/`.

## Integration (2026-06-26)

Six of the seven jobs completed and are integrated (c20 still running). Two new
kernel-checked Lean modules, two safe modifications to already-integrated files, and five
reports. All new/changed theorems depend only on `propext, Classical.choice, Quot.sound`
(no `sorry`, no `native_decide`). Verified: trusted `lake build PhysicsSM` exit 0 (8294 jobs)
and `lake build PhysicsSMDraft` exit 0 (8683 jobs).

| Job | Lean | Report | Headline |
| --- | --- | --- | --- |
| b17 | **new** `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean` | `null-edge-b17-finite-lichnerowicz-bridge-report.md` | `finite_lichnerowicz_square`: `D^2 = -K_null - C_diamond - T_frame + Phi^2 - i Gamma_s sum_a C_a[nabla_a,Phi]`, the named Gate-A-hypothesis version (`_gateA`), the `+/-Phi^2` `_sign_bridge`, and the tetrad-postulate specialization (`T_frame` drops). Reuses existing defs; only new name is the alias `Knull := Boxnull`. The finite super-Dirac square, assembled. |
| d17 | **new** `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean` | `null-edge-d17-scalar-gauge-null-quadrature-note.md` | `scalar_null_quadrature` (re-export) + the gauge/Higgs version: `gauge_null_quadrature`, `gauge_higgs_kinetic_reconstruction` (`g^{-1}(DH,DH) = sum G^{ab} <nabla_a H, nabla_b H>`), and `gauge_euclidean_collapse_guardrail` (the naive positive edge sum is recovered ONLY in the doubly-diagonal Euclidean+orthonormal case -- the null substrate does irreducible work). |
| i7 | **patch** (banner docstrings) `PhysicsSM/Spinor/PluckerObstruction.lean`, `PhysicsSM/Spinor/PluckerMassCovariance.lean` | `null-edge-plucker-trusted-promotion-audit.md` | Machine-checkable convention/provenance banners added to the two trusted Spinor files (metric, spinor/bispinor, determinant-mass normalization, Plucker bracket, SL(2,C) action, supersession of older drafts). Diff-verified docstring-only (declarations byte-identical). This is the promotion-readiness step the wave6 promotion-bridge required. |
| f14 | **patch** (+3 lemmas) `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` | `null-edge-forbidden-counterterm-prediction-ledger.md` | Added `ambient_finrank` (`(|L|+|R|)^2`), `admissible_odd_finrank` (`2|L||R|`), `ambient_eq_admissible_add_codimension` (the literal codimension split). Diff-verified purely additive. Adversarial report verdict: this is a **consistency/reconstruction theorem, not a first prediction** -- "forbid the diagonal block" and "choose Phi_H chi_E-odd" are the *same* statement, so the codimension is built into the posited oddness, not derived. Prediction language stays off. |
| m11 | (none -- audit) | `null-edge-p1-p15-release-crosswalk-after-wave8.md` | P1/P1.5 release crosswalk. Recommendation: **ship P1 after convention banners** (now added by i7), not held for a missing theorem. Twistor rows over-marked `trusted` must be downgraded (module absent). |
| c19 (integrated 2026-06-26) | **new** `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` | `null-edge-c19-gate-c-release-criterion-note.md` | **Gate C: PENDING, not RELEASED -- and built so as not to overclaim.** Proves the operator flavored index reduces to `tr(GammaFlavOp s . Pnull) = sum_a s_a g5_a` (`flavoredOp_index`); the conditional release `OperatorForcesAlignment bc -> Releases bc` (`gateC_conditional_release`); and the **forcing/uniqueness** result `aligned_signs_forced` (a maximal +/-1 release index +/-4 is attained **iff** `s = +/- g5`) with `flavoredOp_index_le_four`. So the taste signs are NOT a free model choice -- they are forced up to a global sign by any +/-1 operator branch chirality; the wave-8 hand-model is exactly the `s = g5` instance (`model_realizes_alignment`). The single remaining blocker is isolated as the explicit hypothesis `OperatorForcesAlignment` (that the actual flat tetrahedral Clifford symbol `c(p(q))` assigns chirality eigenvalue `g5 a` to the branch-`a` zero mode) -- which needs the Clifford symbol + per-branch kernel/chirality, data not yet in the Lean files. Verified: full `lake build PhysicsSMDraft` exit 0 (8684 jobs); 7 headline theorems kernel-clean; no `native_decide`. |

Not auto-applied (deliberate, user-owned): both i7 and m11 also propose corrective edits to
`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` and the publication plan (downgrade
the over-marked twistor rows from `trusted` to `absent/audit`; upgrade the SL(2,C) covariance
row to `trusted`). These are honest overclaim fixes, but they edit the manuscript and two jobs
touched it independently, so they are left as recommendations (captured in the two reports)
rather than applied here. pre-commit clean.
