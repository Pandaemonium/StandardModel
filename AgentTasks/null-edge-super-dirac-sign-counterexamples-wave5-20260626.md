# Aristotle task: Gate A super-Dirac sign theorem and grading counterexamples

- project_id: 9b92ed92-5f8e-4e2e-a475-86d2c71f45e4
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-super-dirac-sign-counterexamples-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-super-dirac-sign-counterexamples-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` (namespace
`PhysicsSM.Draft.SuperDirac`, nested -> collision-safe), wired into `PhysicsSMDraft.lean`;
report at `AgentTasks/null-edge-super-dirac-sign-counterexamples-report.md`. Gate A super-Dirac
sign over an arbitrary associative `Ring A` with central `Im` (`Im^2=-1`): `super_dirac_square_single`
and `super_dirac_square_sum` (`D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a[nabla_a,Phi]` under
H1-H5), `graded_square_comm`/`graded_square_anticomm` (`(Gamma_s Phi)^2 = +/-Phi^2` per
`[Gamma_s,Phi]=0` vs `{Gamma_s,Phi}=0`), `super_dirac_square_single_odd` (wrong-grading
tachyonic `-Phi^2`), and `cross_term_general` (`[C nabla,Phi] = C[nabla,Phi] + [C,Phi]nabla`,
the contaminant when H5 fails).

**Substantive finding:** this job CORRECTS the earlier by-hand audit
(`null-edge-super-dirac-sign-double-counting-audit.md` Section 2 row B), which claimed both the
mass and gradient terms flip sign in the odd regime. Only the MASS flips (`+Phi^2 -> -Phi^2`);
the two cross-term sign flips cancel so the gradient term keeps its clean sign. Verified by an
explicit Gaussian-integer matrix computation; the audit's headline tachyon conclusion is
unaffected.

**native_decide note (Draft-only policy, 2026-06-26):** the 4 illustrative
`Matrix (Fin 2) (Fin 2) ZZ` examples (`σz_sq`, `example_commuting_plus`,
`example_anticommuting_minus`, `example_extra_term_when_CPh_fails`) use `n a t i v e _ d e c i d e`,
so they carry `Lean.ofReduceBool` + `Lean.trustCompiler`. Per the lifted policy this is
permitted in `PhysicsSM/Draft/`; these examples must be reproved kernel-checked before any
promotion to trusted. The 8 substantive algebraic theorems are kernel-clean
(`propext, Classical.choice, Quot.sound`; the sum/odd/anticomm lemmas even tighter,
`propext, Quot.sound`).

Verified: full `lake build PhysicsSMDraft` exit 0 (8675 jobs); `#print axioms` as above;
pre-commit clean.

## Structuralized (wave6 native-decision-audit, 2026-06-26)

Superseded the native_decide note above: the wave6 `native-decision-audit` job
(`ddcfe2e0`) replaced all four `n a t i v e _ d e c i d e` matrix-example proofs with
structural, kernel-checked proofs (entrywise expansion via `Matrix.mul_apply` +
`Fin.sum_univ_two`, plus a distinguishing-entry witness for the two inequalities).
Statements are byte-for-byte unchanged (verified by diff). The file now has **zero**
`n a t i v e _ d e c i d e`, and `#print axioms` on all four examples shows only
`propext, Classical.choice, Quot.sound` -- the `Lean.ofReduceBool` / `Lean.trustCompiler`
trust holes are gone, so the whole module is kernel-pure and promotion-eligible.
Companion report `null-edge-super-dirac-sign-counterexamples-report.md` updated to match.
Verified: `lake build PhysicsSM.Draft.NullEdgeSuperDiracSignAudit` exit 0, full
`lake build PhysicsSMDraft` exit 0 (8675 jobs), axioms clean, pre-commit clean.
