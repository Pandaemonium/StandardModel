# Summary of changes for run 4b2768bd-ed64-4961-b59e-3bc460ad7cde
Completed the adversarial audit of the harvested full-Bloch helper base (`NullEdgeBlochDet/Determinants.lean`). The source was left completely unedited. Deliverables:

- `AgentTasks/full-bloch-helper-audit-FINDINGS.md` — full findings, ordered by severity.
- `FullBlochHelperAudit/Main.lean` (module `FullBlochHelperAudit.Main`) — a machine-checked, sorry-free anchor that re-verifies the audited conventions; the whole project builds successfully.

Findings, by severity:

- S1 (BLOCKER): The two determinant identities the plus/minus jobs consume — `det_splitStep_sub_one` (line 68) and `det_splitStep_add_one` (line 74) — are both `by sorry`. They carry no proof content, so any job citing them inherits `sorryAx`. The plus/minus jobs may NOT treat the base as a proved foundation; each must discharge its own identity.
- S2 (HIGH): The named helpers in the task (`det_fin_four`, `factor_alpha1/2/3`, `factor_beta`, `splitStep_eq`) do not exist anywhere in the repo — they occur only in the prompt. Mathlib at this toolchain also has no `Matrix.det_fin_four` (only `det_fin_two`/`det_fin_three`), so the 24-term 4×4 expansion is neither provided nor available off the shelf.
- S3 (PASS): The Clifford matrices `alpha1..3`, `beta` and the `factor`/`splitStep` definitions (including multiplication order α1·α2·α3·β) match the SymPy oracle entry-for-entry. Independently verified in Lean that each generator squares to the identity.
- S4 (PASS): `spectralBase`, `zeroModePolynomial`, `piModePolynomial` are copied verbatim from the oracle (conventions preserved, not a corrected-but-different object). The identities `det(U−I)=4·zeroMode`, `det(U+I)=4·piMode` were confirmed numerically over 3000 random points (max error ≈9e-15). `body_center_both_polynomials_zero` is genuinely proved (axioms: propext, Classical.choice, Quot.sound), and re-proved in the anchor.
- S5 (PASS): No `set_option maxHeartbeats`/`maxRecDepth`/linter-disabling, no `axiom`, no `@[implemented_by]` in the source — nothing masks a semantic or trust issue. (The only build tuning is package-level stack size / synth depth, which do not affect trust.)

Placeholder/axiom footprint: exactly 2 `sorry` (lines 68, 74); 0 axioms; 0 `@[implemented_by]`; 0 `set_option`.

Bottom line: the plus/minus jobs can safely rely on the definitions and the proved body-center control, but NOT on the two determinant theorems (unproven sorries) and NOT on any of the promised expansion helpers (absent). The target identities are correct, so from-scratch proofs against these definitions attack the right statement.
