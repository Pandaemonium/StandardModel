# Null-edge kinetic naming and mass-shell normalization report (job A6)

Type: Lean proof/formalization plus convention-alignment report.
Deliverable file: `PhysicsSM/Draft/NullEdgeKineticNormalization.lean`.

Build status: the file compiles kernel-clean (no `sorry`). Every theorem's
axiom set is `{propext, Classical.choice, Quot.sound}` (the `mass_shell_iff`
lemma uses only `{propext, Quot.sound}`). Only the single created file and its
one project dependency were built; no unrelated full-repo build was run.

## 1. Scope

This is **naming / finite-algebra normalization, not a continuum theorem**
(PROMPT guardrail). The file works in the same abstract finite operator algebra
as `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`: the null-edge symbols
`C_a = c(α^a)` and finite transports `∇_a` are elements of an arbitrary
(possibly non-commutative) `Ring R` indexed by a `Fintype ι`, with
`D_N = ∑_a C_a ∇_a`.

The job disentangles, in finite algebra, the objects flagged as name-colliding
across the corpus by
`AgentTasks/null-edge-sign-normalization-dashboard.md` (conflicts C-1, C-2, C-3)
and `AgentTasks/aristotle-wave-integration-triage.md` §3-A.

## 2. What was reused vs. added

To keep a single source of truth (and to avoid re-deriving the finite square),
the deliverable **imports** the existing finite-algebra definitions and identities
from `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean` rather than redefining
them:

- reused definitions: `Boxnull`, `Cdiamond`, `Tframe`, `Kplus`, `DN`;
- reused identities: `boxnull_add_cdiamond`, `dirac_square_decomp`,
  `dirac_square_full_decomp`.

The new file only adds the canonical *names* and the alias/identity lemmas that
normalize them.

## 3. Canonical naming decision (closes C-1, C-2)

| concept | canonical Lean name | definition | aliases mapped from |
|---|---|---|---|
| symmetric kinetic block | `Knull` | `Boxnull = ¼ ∑_{a,b} {C_a,C_b}{∇_a,∇_b}` | `Box_null`, `K_h`, `K` |
| commutator / curvature block | `Cdiamond` | `¼ ∑_{a,b} [C_a,C_b][∇_a,∇_b]` | `C_diamond` |
| frame defect | `Tframe` | `∑_{a,b} C_a [∇_a,C_b] ∇_b` | `T_frame` |
| combined kinetic + curvature | `Kfull` | `Kplus = ∑_{a,b} C_a C_b ∇_a ∇_b` | `K_null_plus_diamond` |

The choice fixes **one** symbol (`Knull`) for the symmetric box that the corpus
otherwise spells four different ways (`K_null`, `Box_null`, `K_h`, `K`), with a
`rfl`/`simp` alias lemma `Knull_eq_Boxnull` tying it to the existing Lean
spelling. This resolves dashboard conflict **C-1** (kinetic-operator name
proliferation, including the two core docs disagreeing).

### Guardrail (C-2): `Kplus` / `K_full` is NOT `K_null`

The object called `Kplus` in the tetrad-postulate report is the combined
kinetic + curvature block, i.e. `K_full`, and equals `K_null + C_diamond` — a
**different** object from `K_null`. The file makes this explicit and machine-
checked:

- `Kplus_eq_Knull_add_Cdiamond : Kplus C nab = Knull C nab + Cdiamond C nab`;
- `Kfull_eq_Knull_iff_Cdiamond_zero : Kfull C nab = Knull C nab ↔ Cdiamond C nab = 0`.

The second lemma is the formal anti-double-counting guardrail: `K_full` and
`K_null` coincide **exactly** when the curvature block `C_diamond` vanishes, and
differ otherwise, so the two names must never be used interchangeably in a
trusted statement (Working Plan §20.4 failure mode).

## 4. Identity lemmas (the requested finite-algebra package)

All three requested identities are stated and proved:

```text
Kfull_eq_Knull_add_Cdiamond                    : K_full = K_null + C_diamond
dirac_square_eq_Kfull_add_Tframe               : D_N² = K_full + T_frame
dirac_square_eq_Knull_add_Cdiamond_add_Tframe  : D_N² = K_null + C_diamond + T_frame
```

`K_null`, `Cdiamond` (i.e. the symmetric/antisymmetric split) require
`[Invertible (4 : R)]`; the `K_full = Kplus` and `D_N² = K_full + T_frame`
statements do not, so the `Invertible 4` instance is `omit`ted there.

## 5. Mass-shell naming convention (closes C-3)

The mass-shell convention is documented in the module/declaration docstrings and
captured by one lemma:

- Metric is mostly-minus `+t² − x²` (`docs/CONVENTIONS.md`, "Metric signature"):
  null `p² = 0`, massive on-shell `p² = m²`.
- `K_null` is normalized to plane-wave symbol `+p²`. It is the *negative* of the
  analytic d'Alembertian (symbol `−p²`): `K_null = −Box_analytic` at the symbol
  level. This is exactly the symbol-sign that dashboard conflict **C-3** asks
  every file using the kinetic block to restate.
- No-double-counting mass-shell reading: `−K_null + Phi_H² = 0` gives `p² = m²`,
  equivalently `K_null = Phi_H²` on-shell (one relation, never
  `m_Plucker² + m_Higgs²`).

This last equivalence is formalized abstractly as
`mass_shell_iff (k phi2 : R) : -k + phi2 = 0 ↔ k = phi2`
(with `k` standing for `K_null` and `phi2` for `Phi_H²`).

## 6. Guardrail compliance

- "Do not conflate `Kplus` with `K_null`; `Kplus = K_null + C_diamond`" — enforced
  by `Kplus_eq_Knull_add_Cdiamond` and `Kfull_eq_Knull_iff_Cdiamond_zero`.
- "Naming / finite-algebra normalization, not a continuum theorem" — the file is
  pure finite ring algebra over an arbitrary `Ring R`; no continuum, no
  Gamma_s/Phi square, no metric realization is claimed. (The graded super-Dirac
  square `D²` remains a separate Gate A target and is intentionally not touched
  here.)

## 7. Theorem inventory

`PhysicsSM/Draft/NullEdgeKineticNormalization.lean`, namespace
`PhysicsSM.Draft`:

- `Knull`, `Kfull` — canonical definitions.
- `Knull_eq_Boxnull`, `Kfull_eq_Kplus` — alias lemmas (`rfl`).
- `Kfull_eq_Knull_add_Cdiamond` — `K_full = K_null + C_diamond`.
- `dirac_square_eq_Kfull_add_Tframe` — `D_N² = K_full + T_frame`.
- `dirac_square_eq_Knull_add_Cdiamond_add_Tframe` — `D_N² = K_null + C_diamond + T_frame`.
- `Kplus_eq_Knull_add_Cdiamond` — guardrail C-2.
- `Kfull_eq_Knull_iff_Cdiamond_zero` — guardrail C-2 (distinctness criterion).
- `mass_shell_iff` — mass-shell reading `−K_null + Phi_H² = 0 ↔ K_null = Phi_H²`.
