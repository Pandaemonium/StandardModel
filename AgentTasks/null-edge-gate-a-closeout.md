# Gate A super-Dirac sign closeout and theorem-interface plan

Type: no-build theorem-interface and convention-closeout note (Wave 6).
Scope: finite algebra only. No continuum claim is made or promoted here.

This note closes out Gate A by stating precisely (1) what the locked super-Dirac
square is, (2) which wrong-grading / wrong-sign witnesses protect it, (3) the
reconciled kinetic naming, (4) the promotion-safe theorem interface future Lean
code should target, (5) what to lock now in `docs/CONVENTIONS.md` vs. keep
theorem-gated, and (6) the smallest next Lean theorem that makes Gate A genuinely
pass for promotion purposes.

Sources used as the context packet (all under `materials/`):

- `null-edge-super-dirac-sign-counterexamples-report.md` (A1 + A2).
- `null-edge-kinetic-normalization-report.md` (A6).
- `null-edge-krein-double-counterexample-report.md` (C5 + C7, hygiene/stability).
- `CONVENTIONS.md` (locked conventions).
- `Null_Edge_Unified_Mass_Model_Working_Plan.md` (§20-21).
- `null-edge-next-wave-strategy.md` (Gate A decision tree, §1, §8.2).

Standing guardrails honoured throughout:

- No finite-square theorem promotion until Gate A passes.
- Spacetime chirality `Gamma_s` is never collapsed into internal grading
  `chi_E` or form degree `epsilon_form`.
- `K_null = K_full` is never used unless `Cdiamond = 0` is proved.
- `Phi_H^2` is never presented as a second additive mass on top of the
  Plucker/null-spread term; no-double-counting is preserved.

---

## 0. Locked finite-algebra setting

Everything below lives in an arbitrary associative `Ring` (matrices over `Z`,
`Z[i]`, or `C` for the explicit witnesses). The locked symbols are:

```text
Gamma_s = Gamma_s          spacetime chirality (NOT chi_E, NOT epsilon_form)
C_a     = c(alpha^a)       dual-soldered Clifford symbols
nabla_a = nabla_a          finite transports
Phi_H                      zero-order internal mass block
i                          central scalar, i^2 = -1
D_N     = sum_a C_a nabla_a
D       = i D_N + Gamma_s Phi_H
```

Clean (`+Phi_H^2`) hypotheses, locked in `docs/CONVENTIONS.md`
("Super-Dirac square signs"):

```text
(H1) Gamma_s^2 = 1
(H2) {Gamma_s, C_a} = 0
(H3) [Gamma_s, nabla_a] = 0
(H4) [Gamma_s, Phi_H] = 0          (the grading guardrail; positive sign)
(H5) [C_a, Phi_H] = 0              (no-contaminant / clean collapse)
```

---

## 1. Correct super-Dirac square statement (A1, proved)

Under (H1)-(H5) the locked graded square is, in single-mode and finite-sum form:

```text
super_dirac_square_single :
  D^2 = -D_N^2 + Phi_H^2 - i Gamma_s C (nabla Phi_H - Phi_H nabla)

super_dirac_square_sum :
  D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

Headline sign verdict (matches `CONVENTIONS.md` and Working Plan §20-21):

```text
D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

with the mass term `+Phi_H^2` holding **iff** `Phi_H` commutes with the
spacetime chirality `Gamma_s` that appears in `D` (i.e. (H4)).

Supporting proved lemmas (all `sorry`-free, kernel-checked per the A1 report):

| Lean name | Statement | Hypotheses |
|---|---|---|
| `graded_square_comm` | `(Gamma_s Phi_H)^2 = +Phi_H^2` | (H1), (H4) |
| `gs_anticomm_dNsum` | `{Gamma_s, D_N} = 0` | (H2), (H3) |
| `dNsum_Ph_commutator` | `[D_N, Phi_H] = sum_a C_a [nabla_a, Phi_H]` | (H5) |
| `cross_term_general` | `[C nabla, Phi_H] = C[nabla,Phi_H] + [C,Phi_H] nabla` | none |

`cross_term_general` is the general ring identity that exposes the contaminant
`[C, Phi_H] nabla`; the clean collapse used in `super_dirac_square_sum` is exactly
the (H5) specialisation that kills it.

---

## 2. Wrong-grading / wrong-sign counterexamples (A2, proved) and what they rule out

These are the protection facts. Each is a `sorry`-free theorem in the A1/A2
file; together they make `+Phi_H^2` counterexample-protected against any future
"regrading repair".

| Lean name | Statement | Rules out |
|---|---|---|
| `graded_square_anticomm` | `(Gamma_s Phi_H)^2 = -Phi_H^2` when `{Gamma_s, Phi_H}=0` | Making `Phi_H` odd under spacetime chirality `Gamma_s`. This flips the mass term to the tachyonic `-Phi_H^2` (failure mode M1). It forbids substituting an internal grading for `Gamma_s` to "fix" a sign. |
| `super_dirac_square_single_odd` | `D^2 = -D_N^2 - Phi_H^2 - i Gamma_s C [nabla,Phi_H]` under `{Gamma_s,Phi_H}=0` | The full odd-regime square: only the **mass** term flips; the gradient term keeps the clean sign `- i Gamma_s ...`. Rules out the audit's row-B claim that both terms flip. |
| `example_commuting_plus` | `Phi_H = diag(2,3)`, `Gamma_s = sigma_z`: `(Gamma_s Phi_H)^2 = +Phi_H^2` | Confirms the positive branch is realisable, not vacuous. |
| `example_anticommuting_minus` | `Phi_H = sigma_x`, `Gamma_s = sigma_z`: `(Gamma_s Phi_H)^2 = -Phi_H^2` | Concrete witness of the tachyonic flip (M1). |
| `example_extra_term_when_CPh_fails` | `C = sigma_x`, `Phi_H = sigma_z`: `[C,Phi_H] != 0` and `[D_N,Phi_H] != C[nabla,Phi_H]` | Failure mode M4: dropping (H5) lets the contaminant `[C,Phi_H] nabla` survive, so the clean square theorems do **not** apply. |

Audit correction (folded here): in the odd regime two sign flips occur in the
cross term and **cancel**, so the gradient term retains `- i Gamma_s sum_a C_a
[nabla_a, Phi_H]`. The earlier by-hand audit (super-Dirac double-counting audit,
§2 row B) wrongly reported `+ i ...`. The headline `+Phi_H^2 -> -Phi_H^2`
tachyon conclusion is unaffected; only that gradient sign was wrong. First
checked by an explicit `Z[i]` 2x2 matrix computation, then proved in general by
`super_dirac_square_single_odd`.

---

## 3. Name reconciliation (A6, proved)

The corpus spells the kinetic blocks several ways. The locked canonical map
(kinetic-normalization report, §3, all alias lemmas proved `rfl`/`simp`):

| Concept | Canonical Lean name | Definition | Aliases / spellings mapped from |
|---|---|---|---|
| symmetric kinetic box | `Knull` | `Boxnull = (1/4) sum_{a,b} {C_a,C_b}{nabla_a,nabla_b}` | `K_null`, `Box_null`, `K_h`, `K` |
| commutator / curvature block | `Cdiamond` | `(1/4) sum_{a,b} [C_a,C_b][nabla_a,nabla_b]` | `C_diamond` |
| frame / tetrad defect | `Tframe` | `sum_{a,b} C_a [nabla_a, C_b] nabla_b` | `T_frame` |
| combined kinetic + curvature | `Kfull` | `Kplus = sum_{a,b} C_a C_b nabla_a nabla_b` | `K_full`, `Kplus`, `K_null_plus_diamond` |
| zero-order internal mass block | `Phi_H` | block `[[0, M^dagger],[M, 0]]`, so `Phi_H^2 = diag(M^dagger M, M M^dagger)` | `Phi`, `Phi_H` |

Reconciliation of the seven requested names:

- `K_null` = `Boxnull` = canonical `Knull`. The symmetric box only.
- `Boxnull` = the existing Lean spelling of `Knull` (`Knull_eq_Boxnull : rfl`).
- `K_full` = `Kplus` = `Kfull`. The **combined** block, a different object from
  `K_null`.
- `Kplus` = `Kfull` = `Knull + Cdiamond` (`Kplus_eq_Knull_add_Cdiamond`).
- `Cdiamond` = the antisymmetric/commutator curvature block; it is exactly the
  difference `Kfull - Knull`.
- `Tframe` = frame/tetrad defect, vanishing iff `[nabla_a, C_b] = 0` for all
  `a,b` (finite tetrad postulate target).
- `Phi_H` = the zero-order internal mass block; **not** a kinetic block, and
  `Phi_H^2` is the fermion Higgs/Yukawa mass, never a second Plucker mass.

Load-bearing distinctness guardrail (proved):

```text
Kplus_eq_Knull_add_Cdiamond       : Kfull = Knull + Cdiamond
Kfull_eq_Knull_iff_Cdiamond_zero  : Kfull = Knull  <->  Cdiamond = 0
```

So `K_null` and `K_full` coincide **exactly** when `Cdiamond = 0` and differ
otherwise. They must never be used interchangeably in a trusted statement.

Kinetic decomposition identities (proved):

```text
dirac_square_eq_Kfull_add_Tframe              : D_N^2 = Kfull + Tframe
dirac_square_eq_Knull_add_Cdiamond_add_Tframe : D_N^2 = Knull + Cdiamond + Tframe
```

(`Knull`/`Cdiamond` require `[Invertible (4 : R)]`; `Kfull = Kplus` and
`D_N^2 = Kfull + Tframe` do not.)

---

## 4. Promotion-safe theorem-interface sketch for future Lean code

Future Lean files should target the four separated layers below. Layers 1-3 are
finite ring algebra and are promotion-eligible once Gate A passes; Layer 4 stays
gated regardless of Gate A.

### Layer 1 — finite ring-algebra naming identities (promotable after Gate A)

```text
Knull_eq_Boxnull                  : Knull C nabla = Boxnull C nabla
Kfull_eq_Kplus                    : Kfull C nabla = Kplus C nabla
Kplus_eq_Knull_add_Cdiamond       : Kfull = Knull + Cdiamond
Kfull_eq_Knull_iff_Cdiamond_zero  : Kfull = Knull <-> Cdiamond = 0
```

These are pure naming/aliasing; no grading, no sign convention, no metric.

### Layer 2 — graded super-Dirac square identities (the Gate A core)

```text
graded_square_comm                : (Gamma_s Phi_H)^2 = +Phi_H^2     [H1,H4]
graded_square_anticomm            : (Gamma_s Phi_H)^2 = -Phi_H^2     [H1, {Gamma_s,Phi_H}=0]
super_dirac_square_sum            : D^2 = -D_N^2 + Phi_H^2
                                          - i Gamma_s sum_a C_a [nabla_a, Phi_H]   [H1-H5]
super_dirac_square_single_odd     : odd-regime companion (-Phi_H^2)  [H1-H3,H5,{Gamma_s,Phi_H}=0]
```

Every sign result must carry its exact (anti)commutation hypothesis; the
positive sign is never manufactured by dropping a hypothesis.

### Layer 3 — kinetic matching / no-double-counting identities (promotable after Gate A)

```text
dirac_square_eq_Knull_add_Cdiamond_add_Tframe : D_N^2 = Knull + Cdiamond + Tframe
mass_shell_iff (k phi2 : R) : -k + phi2 = 0 <-> k = phi2
   -- read with k = Knull, phi2 = Phi_H^2: on shell -Knull + Phi_H^2 = 0, i.e.
   -- Knull = Phi_H^2 (ONE relation, never m_Plucker^2 + m_Higgs^2)
```

Symbol-sign convention (mostly-minus): `Knull` is normalized to plane-wave
symbol `+p^2`, the negative of the analytic d'Alembertian (`Knull = -Box_analytic`
at symbol level). Null `p^2 = 0`; massive on shell `p^2 = m^2`.

### Layer 4 — continuum-symbol claims (REMAIN GATED, do not promote)

State only behind explicit assumptions; never as trusted theorems on Gate A:

```text
- finite-to-continuum symbol and square-limit theorem;
- determinant-level branch count / no-doubling (det D_+(q) = 0 test);
- Krein physical-sector stability / real spectrum / positivity / unitarity;
- chiral mechanism (internal chiral rep / domain wall / overlap / Krein imbalance);
- B_QCD / finite color-gap;
- finite-to-EFT codimension or numerical mass prediction.
```

Krein interface status (C5/C7, proved as hygiene + counterexamples): the finite
double identity `Ddbl_kreinSelfAdjoint` (with `D_- = D_+^sharp`, `D_dbl` is
`J_dbl`-self-adjoint) is proved, but the counterexamples
`jselfadj_not_real_spectrum`, `jselfadj_not_stable`, `doubling_not_positive`
show J-self-adjointness gives **no** stability/real-spectrum/positivity. Krein
hygiene is Layer-2/3-adjacent algebra; Krein **stability** is Layer 4 and gated.

---

## 5. Convention lock recommendations for `docs/CONVENTIONS.md`

### Lock now (these are settled by A1/A2/A6 and the witnesses above)

1. Super-Dirac square sign (already "Locked as current convention"; upgrade the
   note to cite the proofs): the locked square is
   `D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`, with
   `+Phi_H^2` iff `[Gamma_s, Phi_H] = 0` and `-Phi_H^2` iff
   `{Gamma_s, Phi_H} = 0`. Backed by `super_dirac_square_sum`,
   `graded_square_comm`, `graded_square_anticomm`.
2. Audit correction: in the odd regime only the mass term flips; the gradient
   term keeps `- i Gamma_s ...`. Replace the stale "both terms flip" row.
3. Grading separation rule (already locked): keep `Gamma_s` (spacetime
   chirality), `chi_E` (internal), `epsilon_form` (form degree) distinct. The
   `graded_square_anticomm` witness is the formal teeth behind this rule.
4. Kinetic naming decision (A6): canonical `Knull` (= `Boxnull`, absorbing
   `K_null`/`Box_null`/`K_h`/`K`), `Cdiamond`, `Tframe`, and `Kfull`
   (= `Kplus`); with the locked guardrail `Kfull = Knull <-> Cdiamond = 0`.
   Add this as a "Locked kinetic naming" subsection.
5. No-double-counting reading (already locked): on shell `Knull = Phi_H^2`, never
   `m_Plucker^2 + m_Higgs^2`. Cite `mass_shell_iff`.
6. Symbol-sign of `Knull`: `+p^2`, i.e. `Knull = -Box_analytic` at symbol level.

### Keep theorem-gated (do not lock as fact)

- Frame/tetrad defect `Tframe`: keep "Working" — only the finite postulate
  `[nabla_a, C_b] = 0 -> Tframe = 0` is targeted, not generic vanishing.
- Branch-count / no-doubling: keep "Locked as an audit rule" but NOT as a
  no-doubling result; strongest allowed phrasing remains "avoids coefficient-zero
  doublers; determinant-level branches remain to be tested".
- Krein stability: keep the non-overclaim rule; J-self-adjointness is hygiene,
  not stability (C7 counterexamples are the teeth).
- All Layer-4 continuum items above.

---

## 6. Smallest next Lean theorem that makes Gate A genuinely pass

Gate A passes when A1 (sign theorem + odd companion), A2 (counterexamples), and
A6 (naming) are joined, with A3 folded into `docs/CONVENTIONS.md`. A1, A2, A6 are
each proved, but they live in **separate** files; the only thing connecting the
graded square to the canonical kinetic names is currently prose. The smallest
theorem that removes that gap and makes promotion safe is a single named bridge
theorem, in one file, importing both the super-Dirac-square file and the
kinetic-normalization file:

```text
theorem super_dirac_square_named
    [Invertible (4 : R)]
    (H1 : Gamma_s^2 = 1) (H2 : forall a, {Gamma_s, C a} = 0)
    (H3 : forall a, [Gamma_s, nabla a] = 0) (H4 : [Gamma_s, Phi_H] = 0)
    (H5 : forall a, [C a, Phi_H] = 0) :
    D^2 = -(Knull C nabla) - (Cdiamond C nabla) - (Tframe C nabla)
            + Phi_H^2
            - i • (Gamma_s * sum_a C a * [nabla a, Phi_H])
```

i.e. compose `super_dirac_square_sum` (D^2 = -D_N^2 + Phi_H^2 - i Gamma_s ...)
with `dirac_square_eq_Knull_add_Cdiamond_add_Tframe`
(D_N^2 = Knull + Cdiamond + Tframe) into the canonical-named square.

Required companion corollary (the no-double-counting closure):

```text
theorem super_dirac_mass_shell_named (xi) (m2 : R)
    (hkin : Knull C nabla = m2) (hzero : Phi_H^2 = m2) :
    -(Knull C nabla) + Phi_H^2 = 0
  -- one mass relation Knull = Phi_H^2, NOT m_Plucker^2 + m_Higgs^2
```

This bridge theorem is the genuine Gate A pass artifact: it is pure finite ring
algebra (so promotion-eligible), it forces the canonical names, it carries the
exact grading hypotheses, and it makes the kinetic/curvature/frame split and the
single on-shell mass relation visible in one statement. Recommended file:
`PhysicsSM/Draft/NullEdgeSuperDiracSquareNamed.lean`, importing both
`NullEdgeSuperDiracSignAudit` and `NullEdgeKineticNormalization`. It must be
proved (`sorry`-free, axiom-clean: `propext`, `Classical.choice`, `Quot.sound`,
plus `Lean.ofReduceBool`/`Lean.trustCompiler` only if matrix `native_decide`
witnesses are reused) before any finite-square package (`B4`/`T14`/`B5`/`D7`/`M5`)
is promoted.

---

## 7. Gate A verdict

- A1 super-Dirac sign theorem + odd companion: PROVED.
- A2 wrong-grading / wrong-sign counterexamples: PROVED (M1 tachyon, M4
  contaminant), with the audit gradient-sign correction folded in.
- A6 kinetic naming reconciliation incl. `Kfull = Knull <-> Cdiamond = 0`:
  PROVED.
- A3 convention fold-in: pending the §5 edits to `docs/CONVENTIONS.md`.
- Remaining genuine gap: the §6 single bridge theorem
  `super_dirac_square_named` (+ `super_dirac_mass_shell_named`).

Verdict: **Gate A is A.partial -> A.pass-ready.** It clears for promotion the
moment the §6 bridge theorem lands and §5's A3 edits are committed. Until then,
no finite-square theorem may be promoted.
