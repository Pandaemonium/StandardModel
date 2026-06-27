# Gate A super-Dirac sign theorem and grading counterexamples — report

**Lean-backed deliverable. Generated 2026-06-26.**

This report accompanies the kernel-checked Lean file
`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean`, which discharges the Gate A
super-Dirac sign job in `PROMPT.md`.  Every claim labelled "proved" below is
backed by a `sorry`-free theorem in that file; the file builds against Mathlib
`v4.28.0` and **every** theorem depends only on the allowed kernel axioms
(`propext`, `Classical.choice`, `Quot.sound`).  The four concrete
`Matrix (Fin 2) (Fin 2)` examples previously used `native_decide`
(`Lean.ofReduceBool`, `Lean.trustCompiler`); as of the Wave 6 native-decision
structuralization pass they are now kernel-checked by entrywise expansion
(`Matrix.mul_apply` + `Fin.sum_univ_two`), so no `native_decide` trust hole
remains in this file.  See
`AgentTasks/null-edge-native-decision-structuralization-report.md`.

Sources followed:

- `PROMPT.md` (job specification and target identities).
- `AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md` (the by-hand
  audit; §1, §2, §6).
- `AgentTasks/null-edge-sign-normalization-dashboard.md` (sign/normalization
  cross-check).
- `docs/CONVENTIONS.md` ("Super-Dirac square signs", "Gradings").
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, §20-21.

## 0. Scope and conventions

This is **finite algebra**, not a continuum claim.  The operators live in an
arbitrary associative `Ring A`:

```text
Gs   = Γ_s    spacetime chirality (kept distinct from internal χ_E / form degree)
C a  = c(α^a) dual-soldered Clifford symbols
nab a = ∇_a   finite transports
Ph   = Φ_H    internal mass block
Im   = i      central scalar with i² = -1
D_N  = ∑_a C_a ∇_a        D = i D_N + Γ_s Φ
```

Standing clean (`+Φ²`) hypotheses (`docs/CONVENTIONS.md`):

```text
(H1) Γ_s² = 1
(H2) {Γ_s, C_a} = 0
(H3) [Γ_s, ∇_a] = 0
(H4) [Γ_s, Φ]   = 0
(H5) [C_a, Φ]   = 0
```

The grading guardrail is respected: `Γ_s` is *only* spacetime chirality and is
never substituted by an internal grading.  The positive theorems use (H4)
`[Γ_s, Φ] = 0`; the negative companion uses `{Γ_s, Φ} = 0`.

## 1. Theorems proved

| Lean name | Statement | Hypotheses |
|---|---|---|
| `graded_square_comm` | `(Γ_s Φ)² = +Φ²` | `Γ_s²=1`, `[Γ_s,Φ]=0` |
| `graded_square_anticomm` | `(Γ_s Φ)² = -Φ²` | `Γ_s²=1`, `{Γ_s,Φ}=0` |
| `super_dirac_square_single` | `D² = -D_N² + Φ² - i Γ_s C (∇Φ-Φ∇)` | (H1)-(H5), single mode |
| `super_dirac_square_single_odd` | `D² = -D_N² - Φ² - i Γ_s C (∇Φ-Φ∇)` | (H1)-(H3),(H5), `{Γ_s,Φ}=0` |
| `gs_anticomm_dNsum` | `{Γ_s, D_N} = 0` | (H2),(H3) |
| `dNsum_Ph_commutator` | `[D_N, Φ] = ∑_a C_a [∇_a, Φ]` | (H5) |
| `super_dirac_square_sum` | `D² = -D_N² + Φ² - i Γ_s ∑_a C_a [∇_a, Φ]` | (H1)-(H5), finite sum |
| `cross_term_general` | `[C∇, Φ] = C[∇,Φ] + [C,Φ]∇` | none (any ring) |

The finite-sum theorem `super_dirac_square_sum` is the full PROMPT target; the
single-mode `super_dirac_square_single` is the core sign lemma it specialises.

### Headline sign verdict (matches `PROMPT.md`, `docs/CONVENTIONS.md`)

Under (H1)-(H5) the graded square is

```text
D² = -D_N² + Φ² - i Γ_s ∑_a C_a [∇_a, Φ],
```

with `+Φ²` **iff** `Φ` commutes with the spacetime chirality `Γ_s` that appears
in `D`.  Making `Φ` odd under that same `Γ_s` flips the mass term to the
tachyonic `-Φ²`.

## 2. Wrong-grading counterexample facts

* `graded_square_anticomm` is exactly the requested companion
  `if {Γ_s, Φ} = 0 then (Γ_s Φ)² = -Φ²`.
* `super_dirac_square_single_odd` shows the full square in the odd regime: the
  zero-order term becomes `-Φ²` (the fatal M1 tachyon).

### Correction to the audit's odd-case gradient sign

The by-hand audit
(`AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md`, §2 row B)
states that in the odd (`{Γ_s, Φ} = 0`) regime *both* the mass term and the
gradient term flip sign, giving `+ i Γ_s ∑_a C_a [∇_a, Φ]`.  **This is
incorrect.**  In the odd regime two sign flips occur in the cross term and they
cancel:

1. combining `D_N Γ_s Φ + Γ_s Φ D_N` introduces one extra sign (because
   `Γ_s Φ = -Φ Γ_s`), and
2. relocating `Γ_s` past `[D_N, Φ]` introduces another, because with `Φ` odd the
   commutator `[D_N, Φ]` now *commutes* with `Γ_s` (it carries one `C` factor,
   anticommuting, and one `Φ` factor, anticommuting — net even), instead of
   anticommuting as in the clean case.

Hence only the **mass** term flips; the gradient term keeps the clean-case sign
`- i Γ_s ∑_a C_a [∇_a, Φ]`.  The audit's *headline* conclusion (the
`+Φ² → -Φ²` tachyon) is unaffected — only the gradient-term sign in row B was
wrong.

This was first verified by an explicit `GaussianInt` (= ℤ[i]) matrix
computation (`Gs = σ_z`, `C = σ_x`, `∇ = diag(1,2)`, `Φ = σ_x`, central
`i` realised as a scalar matrix): the `-i …` form holds and the `+i …` form
fails.  The corrected identity is then proved in general in
`super_dirac_square_single_odd`.  A correction note is embedded in that
theorem's docstring.

## 3. Tiny matrix examples (`Matrix (Fin 2) (Fin 2) ℤ`)

With `Γ_s = σ_z = diag(1,-1)`:

| Lean name | Setup | Shows |
|---|---|---|
| `example_commuting_plus` | `Φ = diag(2,3)` (commutes with `σ_z`) | `(Γ_s Φ)² = +Φ²` |
| `example_anticommuting_minus` | `Φ = σ_x` (`{Γ_s, Φ}=0`) | `(Γ_s Φ)² = -Φ²` |
| `example_extra_term_when_CPh_fails` | `C = σ_x`, `Φ = σ_z`, `∇ = 1` | `[C,Φ] ≠ 0` and `[D_N,Φ] ≠ C[∇,Φ]` |

The third example realises failure mode **M4** (`[C_a, Φ] ≠ 0`): the clean
collapse `[D_N, Φ] = C [∇, Φ]` fails because the contaminant `[C, Φ] ∇`
(here `[σ_x, σ_z] = !![0,-2;2,0] ≠ 0`) survives.  The general decomposition
`cross_term_general` exhibits this contaminant abstractly, so the clean square
theorems genuinely do **not** apply when (H5) fails.

## 4. Guardrails honoured

* **Gradings kept distinct.**  `Γ_s` is spacetime chirality only; no internal
  grading `χ_E` or form degree stands in for it.  The positive theorems use
  `[Γ_s, Φ] = 0`; the negative companion uses `{Γ_s, Φ} = 0`.  The contrast is
  the formal M1/M2 sign-trap guardrail.
* **No hypothesis weakening.**  Each sign result carries the exact
  (anti)commutation hypothesis it needs; the `+Φ²` sign is never manufactured by
  dropping or weakening a hypothesis.  In particular the `-Φ²` companion is a
  genuine theorem about the odd regime, not a vacuous restatement.
* **Generalisation path.**  The full finite-sum theorem
  `super_dirac_square_sum` is proved, so no generalisation gap remains for the
  `∑_a` structure.  Connections to the kinetic decomposition
  `D_N² = Box_null + C_diamond + T_frame` live in the companion file
  `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`.

## 5. Verdict

Gate A super-Dirac sign theorem and its wrong-grading counterexamples are
formalised and kernel-checked.  The corpus sign convention
`D² = -D_N² + Φ² - i Γ_s ∑_a C_a [∇_a, Φ]` (with `+Φ²` gated by `[Γ_s, Φ]=0`)
is confirmed, and one sign error in the audit's odd-case gradient term is
corrected and documented.
