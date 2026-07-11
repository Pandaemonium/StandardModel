# Findings — adversarial audit of the harvested full-Bloch helper base

Audited source (left unedited, per instruction):
`AgentTasks/aristotle-standalone/null-edge-full-bloch-determinants-only-20260710/NullEdgeBlochDet/Determinants.lean`
(83 lines).

Machine-checked anchor: `FullBlochHelperAudit/Main.lean` (builds, sorry-free).
Independent oracle: `Scripts/oracle/derive_split4_floquet_polynomial.py`.

Findings are ordered by severity.

---

## S1 (BLOCKER) — The two determinant theorems the plus/minus jobs consume are unproven `sorry`

* `NullEdgeBlochDet.det_splitStep_sub_one` — body is `by sorry` (line 68).
* `NullEdgeBlochDet.det_splitStep_add_one` — body is `by sorry` (line 74).

These are exactly the "+1" and "−1" all-momentum determinant identities the
separate plus/minus proof jobs are said to feed off. As harvested they carry
**no proof content**. Any downstream job that `import`s this file and cites
either theorem inherits `sorryAx`; the plus/minus jobs therefore **may not**
treat the helper base as a proved foundation. They must each discharge their own
determinant identity from the definitions. (The definitions themselves are
sound — see S3/S4 — so a from-scratch proof targets the correct object.)

## S2 (HIGH) — The named "helpers" do not exist in the harvested base

The task asks to audit `det_fin_four`, `factor_alpha1/2/3`, `factor_beta`, and a
"huge `splitStep_eq`". A full-repo search finds these names **only in the task
prompt** — none occur in any `.lean` file. Concretely:

* There is no `det_fin_four` helper, and Mathlib at this toolchain has **no**
  `Matrix.det_fin_four` either (only `det_fin_two` / `det_fin_three` exist,
  confirmed by `#check`). So the 24-term `4×4` expansion is neither in the base
  nor available off the shelf; each downstream job must build it.
* There are no per-factor lemmas `factor_alpha1/2/3` / `factor_beta` and no
  `splitStep_eq` entrywise-expansion lemma. The base exposes only the raw
  `def`s `alpha1..3`, `beta`, `factor`, `splitStep`.

Consequence: the "helper base" provides essentially no reusable lemma
scaffolding — only definitions plus two `sorry` statements plus one small proved
control lemma. Expectations that these helpers can be relied upon are unfounded.

## S3 (INFO / PASS) — Clifford matrices and `factor`/`splitStep` conventions are faithful

Checked entry-by-entry against the SymPy oracle's matrices:

* `alpha1, alpha2, alpha3, beta` are transcribed **exactly** as in the oracle
  (same entries, same `-I`/`I` placement, `beta = diag(1,1,-1,-1)`).
* `factor x A = cos x • 1 − (I·sin x) • A` matches the oracle
  `factor = cos·I − i·sin·generator`.
* `splitStep = factor qx α1 * factor qy α2 * factor qz α3 * factor θ β` — the
  multiplication order matches the oracle `walk` exactly (α1·α2·α3·β).

Independent Lean verification (sorry-free, in `Main.lean`): each generator
satisfies `A² = 1` (`alpha1_sq … beta_sq`), confirming they are genuine Dirac
α/β Clifford generators, not mis-transcriptions.

## S4 (INFO / PASS) — Polynomial conventions preserved; determinant identities hold numerically

* `spectralBase`, `zeroModePolynomial = spectralBase − 2·cosθ·cx·cy·cz`, and
  `piModePolynomial = spectralBase + 2·cosθ·cx·cy·cz` are copied verbatim from
  the oracle (`zero_mode`, `pi_mode`).
* The claimed identities `det(U − I) = 4·zeroMode` and `det(U + I) = 4·piMode`
  were re-verified **numerically** over 3000 random `(qx,qy,qz,θ)`: maximum
  absolute error ≈ `9.0e-15`. This confirms the sorried statements target the
  correct (uncorrected) object — they are not a "corrected-but-different"
  polynomial. (This is a finite numeric check, **not** a proof; S1 stands.)
* Body-center control `body_center_both_polynomials_zero` (θ arbitrary,
  qx=qy=qz=π/2) is genuinely proved in the source by `simp` and is re-proved
  independently in `Main.lean`. Axiom footprint: `propext`, `Classical.choice`,
  `Quot.sound` only.

## S5 (INFO / PASS) — No heartbeat/depth or trust-masking settings

* The harvested file contains **no** `set_option maxHeartbeats`, no
  `maxRecDepth`, no `set_option … linter … false`. The only build tuning is at
  the package level (`lakefile.toml`: `moreLeanArgs = ["-s65536"]`, a stack-size
  bump, and `maxSynthPendingDepth = 3`) — neither affects logical trust.
* No `axiom` declarations and no `@[implemented_by]` in the source.

## Placeholder / axiom footprint (exact)

* `sorry`: 2 occurrences — lines 68 (`det_splitStep_sub_one`) and 74
  (`det_splitStep_add_one`).
* `axiom`: 0. `@[implemented_by]`: 0. `set_option`: 0.
* Only fully-proved declaration: `body_center_both_polynomials_zero`
  (axioms: propext, Classical.choice, Quot.sound).

---

## Bottom line for the plus/minus jobs

* **Safe to rely on:** the *definitions* (`alpha1..3`, `beta`, `factor`,
  `splitStep`, `spectralBase`, `zeroModePolynomial`, `piModePolynomial`) and the
  proved `body_center_both_polynomials_zero`. Conventions are faithful to the
  oracle (S3/S4) with no hidden settings (S5).
* **Not safe to rely on:** `det_splitStep_sub_one` and `det_splitStep_add_one` —
  both are `sorry` (S1). Citing them propagates `sorryAx`. Neither the promised
  `det_fin_four` nor the per-factor / `splitStep_eq` helpers exist (S2), so each
  job must derive the 4×4 expansion and the identity itself. The target
  identities are correct (numerically confirmed), so such from-scratch proofs
  are attacking the right statement.
