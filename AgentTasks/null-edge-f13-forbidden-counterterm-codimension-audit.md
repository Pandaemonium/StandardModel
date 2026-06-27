# F13 forbidden-counterterm codimension theorem — Aristotle return

Date: 2026-06-26. Type: prediction audit + Lean pilot (kernel-checked).

Inputs: `PROMPT.md`, `COMMON_CONTEXT.md`, the Wave 8 master strategy, and the
existing finite drafts (`PhysicsSM__Draft__NullEdgeSuperDiracBlockCore.lean`,
`PhysicsSM__Draft__NullEdgeSuperDiracSignAudit.lean`,
`PhysicsSM__Draft__NullEdgeScalarKineticReconstruction.lean`).

Lean deliverable: `PhysicsSM__Draft__NullEdgeForbiddenCountertermCodim.lean`
(builds clean; axioms `propext, Classical.choice, Quot.sound` only; no `sorry`,
no `axiom`, no `opaque`).

---

## 0. Executive verdict

> **Genuine codimension *candidate*, but presently weak as a stand-alone
> prediction.** The chirality grading `Γ_s` *does* forbid a real counterterm —
> the diagonal (chirality-preserving / same-Weyl) bare mass — and the forbidding
> is a clean, kernel-checked codimension-`(card L)²+(card R)²` statement, not a
> convention. However, on its own this is the *generic* NCG odd-operator
> constraint shared by quiver/finite-spectral-triple actions, so it is
> reconstruction-grade unless combined with a constraint that the *comparison*
> theory (generic graded quiver) actually relaxes. The honest framing for Gate F
> is: this is the **template** and the **proof-of-concept** for a codimension
> theorem (it shows the machinery and the counting work and are kernel-safe), and
> it becomes a *prediction* only once paired with the H8/H11 internal-moduli
> audit showing the null-edge constraints cut *below* the generic graded baseline.

Recommendation: keep prediction language **off** (consistent with the
COMMON_CONTEXT safe-thesis guardrail and §5 of the master strategy: "Until
H11 + H8 show a genuine codimension reduction, prediction language must stay
off"). Ship the theorem as the *codimension-statement template* feeding F9/F12/H8,
and as a kernel-checked illustration that the grading removes parameters rather
than tuning them.

---

## 1. Counterterm inventory (finite null-edge square `L ⊕ R`)

The ambient object is a finite self-adjoint operator on `L ⊕ R` with chirality
grading `Γ_s = diag(+1_L, −1_R)`. "Generic EFT / generic quiver spectral action"
= an arbitrary self-adjoint fluctuation `M`. The locked null-edge architecture
demands a **graded (odd)** Dirac term, `{Γ_s, D} = 0`, plus the sign/grading data
already frozen in the Gate-A sign audit.

| # | Operator / counterterm | Form-degree / chirality | Status under locked null-edge assumptions | Why |
|---|---|---|---|---|
| 1 | Off-diagonal Higgs/Yukawa block `offDiagonal φ ψ` (`L↔R`) | odd (chirality-flipping) | **Allowed** | `offDiagonal_isOdd`: anticommutes with `Γ_s`; squares to the diagonal mass block `ψφ` (`offDiagonal_sq_leftBlock`). This is the physical fermion mass channel. |
| 2 | Diagonal same-Weyl bare mass `m·e_{LL}` or `m·e_{RR}` (`L→L` / `R→R`) | even (chirality-preserving) | **Forbidden** | `odd_diag_left_zero` / `odd_diag_right_zero`: any odd operator has identically zero diagonal blocks. A nonzero such entry ⇒ not odd (`diag_left_nonzero_not_odd`). This is the F13 forbidden counterterm. |
| 3 | Internal zero-order block `Φ_H` with `[Γ_s, Φ_H] = 0` (chirality-even, squares to `+Φ²`) | even but enters via `Γ_s Φ` | **Allowed (tuned)** | Sign audit `graded_square_comm`: with `[Γ_s,Φ]=0`, `(Γ_s Φ)² = +Φ²`. The term that enters `D` is the *odd* combination `Γ_s Φ`, so it respects oddness. The internal moduli of `Φ_H` are the **free/tuned** parameters H8/H11 must bound. |
| 4 | Wrong-grading internal block `{Γ_s, Φ} = 0` (squares to `−Φ²`) | odd `Φ` | **Forbidden (fatal)** | Sign audit `graded_square_anticomm` / `super_dirac_square_single_odd`: tachyonic `−Φ²`. Excluded by the frozen `+Φ²` convention, not by a tunable choice. |
| 5 | `[C_a, Φ] ≠ 0` contaminant (symbol/mass non-commuting) | mixed | **Forbidden by (H5)** | Sign audit `cross_term_general` + `example_extra_term_when_CPh_fails`: a surviving `[C,Φ]∇` term breaks the clean square. (H5) `[C_a,Φ]=0` is a locked structural assumption. |
| 6 | Diagonal "gauge-field"-type fluctuation that commutes with `Γ_s` | even | **Absent by convention / not a mass counterterm** | Such an even self-adjoint term is a legitimate vector/connection fluctuation in NCG, not a forbidden mass term; it is simply *not* part of the zero-order mass channel. Listed to keep the classification honest: not all even operators are "forbidden", only the even *mass* counterterm #2 is, by virtue of being claimed as a mass while violating oddness. |

Legend: **Allowed** = admissible under locked assumptions; **Forbidden** =
provably excluded by a locked symmetry/sign assumption; **Tuned** = admissible but
parametrically free (the moduli danger); **Absent-by-convention** = not written
in the action but not symmetry-forbidden.

### Separating forbidden from merely-absent (prompt item 3)

- **#2 is genuinely forbidden** (symmetry obstruction): no choice of basis or
  action makes a nonzero same-Weyl mass anticommute with `Γ_s`. Proven:
  `odd_diag_left_zero`, `odd_diag_right_zero`, `diag_left_nonzero_not_odd`.
- **#3's internal moduli are merely tuned/free**, not forbidden — this is exactly
  the H8/H11 trap: the internal `Φ_H` block can carry free parameters that refill
  the EFT. The F13 theorem does *not* touch these.
- **#4/#5 are forbidden by frozen sign/locality conventions** (Gate A), already
  formalized in the sign-audit draft; F13 does not re-litigate them.
- **#6 is absent by convention**, not forbidden; flagged to avoid over-claiming.

---

## 2. The locked assumption that forbids #2

| Ingredient | Statement | Role |
|---|---|---|
| Grading | `Γ_s = diag(+1_L, −1_R)`, `Γ_s² = 1` | defines chirality sectors |
| Oddness (the lock) | `{Γ_s, D} = 0` i.e. `IsOdd D` | every admissible null-edge / NCG Dirac term is chirality-flipping |
| Consequence | entrywise `{Γ_s, M}_{ab} = (χ(a)+χ(b))·M_{ab}` (`anticomm_entry`) | diagonal blocks carry factor `±2`, off-diagonal blocks factor `0` |

The single assumption doing the work is **oddness of the Dirac term**
(first-order/odd condition of the spectral triple), combined with the frozen
chirality sign `Γ_s = diag(+1,−1)`. No Krein, taste, or locality input is needed
for #2 — it is pure grading. (That is also why it is, by itself, generic.)

---

## 3. Moduli-rank / codimension statement (prompt item 4)

- **Ambient parameter space**: all operators on `L ⊕ R`,
  `dim_ℂ = (card L + card R)²`.
- **Parameter removed**: the two diagonal blocks `(M|_{L→L}, M|_{R→R})`, i.e. the
  forbidden same-Weyl mass counterterms, of total complex dimension
  `(card L)² + (card R)²`.
- **Admissible (odd) locus**: the off-diagonal subspace, `dim_ℂ = 2·card L·card R`,
  realized as `LinearMap.ker diagBlocks`.

Codimension theorem (kernel-checked):

```
finrank_ℂ ( Operators ⧸ ker diagBlocks ) = (card L)² + (card R)² .
```

`diagBlocks` is the linear "extract diagonal blocks" map; it is surjective
(`diagBlocks_surjective`) and its kernel is exactly the odd subspace
(`mem_ker_diagBlocks_iff`). The quotient finrank is the count of forbidden
parameters. Sanity check (`Fin 1 ⊕ Fin 1`): ambient `4`, admissible odd `2`,
codimension `2` — proven as a concrete `example`.

---

## 4. Candidate Lean theorem (prompt item 5) — DELIVERED

The headline statement, fully proved in
`PhysicsSM__Draft__NullEdgeForbiddenCountertermCodim.lean`:

```lean
theorem forbidden_counterterm_codimension :
    Module.finrank ℂ
        (Matrix (Sum L R) (Sum L R) ℂ ⧸ (LinearMap.ker (diagBlocks (L := L) (R := R))))
      = Fintype.card L ^ 2 + Fintype.card R ^ 2
```

supported by the structural theorems:

- `odd_diag_left_zero`, `odd_diag_right_zero` — the forbidding (diagonal mass
  vanishes on any odd operator);
- `offDiagonal_isOdd` — the allowed Yukawa channel is odd;
- `isOdd_iff_offDiagonal` — admissible ⇔ purely off-diagonal (nothing diagonal
  hides inside a legal fluctuation);
- `diag_left_nonzero_not_odd` — the "cannot be represented" contrapositive;
- `mem_ker_diagBlocks_iff`, `diagBlocks_surjective` — kernel = odd subspace,
  surjectivity, giving the codimension.

All entrywise; no continuum claim; axioms `propext, Classical.choice, Quot.sound`.

---

## 5. Effect on Gate F prediction language (prompt item 6)

1. **What it buys.** A reusable, kernel-safe *codimension template*:
   `finrank(ambient ⧸ admissible) = removed-parameter-count`. This is precisely
   the `rank(dF) < dim M_EFT` shape Gate F demands, demonstrated to be provable
   in this architecture. F9/F12/H8 should reuse `diagBlocks`/`quotKerEquivRange`
   for the real internal-moduli count.

2. **What it does NOT yet buy.** A *prediction*. The forbidding of #2 is the
   generic NCG odd-operator constraint, also satisfied by the comparison theories
   (graded quiver / finite spectral triple). So by the Wave 7 reconstruction
   verdict, F13 alone is reconstruction-grade. The free parameters that threaten
   prediction live in counterterm #3 (the internal `Φ_H` moduli), which F13 does
   not constrain.

3. **The upgrade path to a real prediction.** Compose F13's codimension counting
   with H8/H11: show that the *null-edge-specific* locks (legal-Yukawa-flip H4,
   gauge-neutral + internal-odd + square-to-`+Φ²` H5, anomaly inheritance H3)
   remove *additional* directions in the `Φ_H` moduli space that a generic graded
   quiver leaves free. Only a codimension *gap* against the generic baseline is a
   prediction. F13 supplies the certified counting machine; H8/H11 must supply the
   gap.

4. **Guardrail compliance.** Keep prediction language off until that gap is shown
   (COMMON_CONTEXT safe thesis; master strategy §5). Present F13 as: "the chirality
   grading removes the same-Weyl mass counterterm at codimension `(card L)²+(card R)²`,
   certifying that the mass channel is the off-diagonal Yukawa block alone" —
   a structural/accounting result, not a parameter-counting prediction.

---

## 6. One-line classification summary

- **Allowed**: #1 off-diagonal Yukawa.
- **Forbidden (symmetry)**: #2 diagonal same-Weyl mass — the F13 target, proven.
- **Forbidden (frozen sign/locality, Gate A)**: #4, #5.
- **Tuned/free (moduli danger, not F13)**: #3 internal `Φ_H`.
- **Absent-by-convention (not forbidden)**: #6 even gauge-type fluctuation.

Verdict: **genuine codimension candidate and a kernel-checked template; too weak
to be a stand-alone prediction until the H8/H11 internal-moduli gap is
established. Not blocked by Gate C** (this is C-independent finite linear algebra).
