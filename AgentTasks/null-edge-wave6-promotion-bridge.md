# Null-edge Wave 6 promotion bridge and integration triage

Type: no-build integration / promotion-planning job. No Lean, Lake, or build
command was run; this document plans the promotion queue from the returned
Wave-6 artifacts. It promotes nothing by itself — it specifies what may be
promoted, under which prerequisites, and what is hard-stopped.

Provenance (materials/):

- `null-edge-live-proof-verification-report.md` (live elaboration + axiom-closure
  + semantic review of the four target `Draft/*.lean` files).
- `null-edge-super-dirac-sign-counterexamples-report.md` (Gate A; `A1`/`A2`).
- `null-edge-kinetic-normalization-report.md` (Gate A support; `A6`).
- `null-edge-null-solder-frame-foundations-report.md` (Gate B; `B0→B1→B3→B2`).
- `null-edge-branch-count-interpretation.md` (Gate C; `C2b`).
- `null-edge-high-momentum-branch-proof-report.md` (Gate C; `C1`/`C3`).
- `null-edge-krein-double-counterexample-report.md` (Gate C addendum; `C5`/`C7`).
- `CONVENTIONS.md` (Locked / Working / Unlocked status).
- `null-edge-next-wave-strategy.md`, `Null_Edge_Unified_Mass_Model_Working_Plan.md`
  (gate definitions and ordering).

## 0. Gate definitions used in this document

From the Working Plan (§20.1) and the next-wave strategy:

- **Gate A — convention freeze / finite sign algebra.** Hard *promotion
  prerequisite*. Until the super-Dirac `+Φ²` vs `−Φ²` sign theorem and the
  wrong-grading counterexamples (`A1`/`A2`, supported by `A6`) are accepted in
  Lean, **no finite graded-square theorem package (`B4`/`T14`/`B5`/`D7`/`M5`)
  may be promoted**.
- **Gate C — flat branch / stability audit.** *Kill switch*. Until the
  determinant-level branch count returns and is interpreted as non-fatal, **no
  continuum / no-doubling promotion and no Gate-D / chirality work (`C8`–`C12`,
  `E8`) may launch**.

Cross-cutting principle (PROMPT guardrail): the Lean kernel checks proof
*validity*, not *semantic alignment*. Every "kernel-clean" verdict below is still
subject to statement-matches-claim review and to a convention banner before it
leaves `Draft/`.

## 0.1 The G1 convention banner (prerequisite for ALL promotions)

None of the returned files carries the standardized machine-checkable
convention-import banner required by G1 criteria C5–C8. The conventions are
stated in module docstrings and are individually consistent with
`CONVENTIONS.md`, but a prose docstring is not a banner. Attaching the banner is
a *blanket* prerequisite. The banner must pin, per file, the four axes:

- **C5 metric signature** — mostly-minus Lorentzian `+(t)² − (x)²` (Locked), or
  an explicit "signature-general" tag where the statement is signature-agnostic.
- **C6 grading** — which of `Γ_s` (spacetime chirality), `χ_E` (internal), or
  `ε_form` (form degree) is in play, or "n/a (ungraded)".
- **C7 kinetic / super-Dirac sign** — the locked
  `D = i D_N + Γ_s Φ_H`, `D² = −K_h − C_diamond − T_frame + Φ_H² − i Γ_s Σ C_a[∇_a,Φ_H]`
  convention, or "n/a (no square)".
- **C8 frame normalization** — dual-soldered (`α^a = c`-soldering, `ℓ_a` for
  support), never the diagonal `c(ℓ_a^♭)` architecture except as a documented
  negative comparison; and the real-coordinate lock where relevant.

---

## 1. Classification of every returned theorem / file (Task 1)

Six categories: **PC** promotion candidate now (after banner); **DU** draft-only
but useful; **AV** artifact requiring independent verification; **GA** blocked by
Gate A; **GC** blocked by Gate C; **NP** should not be promoted.

| # | File / artifact | Main declarations | Class | Rationale |
| --- | --- | --- | --- | --- |
| 1 | `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean` | `B_EW_eq_matrix`, `ew_stabilizer_kernel`, `ew_stabilizer_kernel_finrank`, `ew_stabilizer_rank`, `ew_quadratic_form_kernel` | **PC** | Elaborates clean, no placeholder tokens, axioms `{propext, Classical.choice, Quot.sound}`, statement = locked EW structural target (`ker B_EW = u(1)_em`, `rank q = 3`). Promote as **structural theorem** after banner + real-coordinate caveat. |
| 2 | `PhysicsSM/Draft/StandardModelAnomalyAudit.lean` | `grav_anomaly_zero`, `cube_anomaly_zero`, `su2_anomaly_zero`, `su3_anomaly_zero`, `sm_anomaly_cancellation`, `sm_anomaly_cancellation_with_nu` | **PC** | Clean, exact-rational arithmetic verified independently; matches locked hypercharges. Promote as **anomaly arithmetic only** after banner + non-chirality / non-doubling disclaimer. |
| 3 | `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean` | `frame_term_vanishes`, `dirac_square_decomp`, `dirac_square_of_tetrad`, `boxnull_add_cdiamond`, `dirac_square_full_decomp`, `dirac_square_full_of_tetrad` | **DU** (ungraded identity) / **GA** (graded use) | Clean finite ring identity, promotable as a *standalone ungraded* `D_N²` decomposition after banner. But any *graded* super-Dirac square built on it is gated by Gate A. |
| 4 | `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` | `repr_eq_apply_predual`, `covector_bilin_reconstruction`, `inverse_gram`, `inverse_gram_reconstruction`, `higgs_kinetic_reconstruction`, `euclidean_collapse_guardrail` | **DU** | Correct, faithful to §19.4 inverse-Gram reconstruction, but held by backlog dependency: S8 must be re-audited vs B1/B3 and refactored onto the shared B0 `NullSolderFrame` before leaving `Draft/`. |
| 5 | `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` (+ grading counterexamples) | `superDirac_square_sign_audit` and the four wrong-grading matrix examples | **AV** then **GA** anchor | Report-asserted kernel-clean; *not* re-run by the live verification job, so it needs the same independent C13a/b/c verification before it can serve as the Gate A clearance anchor. Its `native_decide` matrix examples add `Lean.ofReduceBool`, `Lean.trustCompiler` to the axiom set (see §3 / §6). |
| 6 | `PhysicsSM/Draft/NullEdgeKineticNormalization.lean` | `K_null`/`Box_null`/`K_h` alias + normalization lemmas, `mass_shell_iff` | **DU** / Gate A support | Naming/normalization only; imports the tetrad file. Useful now to reserve `K_null` for exactly one block; not a square theorem. Promotable as a naming-hygiene lemma file after banner, but it carries no graded content. |
| 7 | `PhysicsSM/Draft/NullSolderFrameFoundations.lean` (B0→B1→B3→B2) | `NullSolderFrame` data package + simplex/inverse-Gram + diagonal-obstruction lemmas | **AV** then **DU** | Report-asserted kernel-clean (Gate B); not re-run by the live verification job. After independent verification it is the foundational B0 layer the scalar-kinetic file should refactor onto — keep in `Draft/` as active foundations. |
| 8 | `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean` (`C1`/`C3`) | `Ginv`, `Ginv_eq`, `qform`, `qform_eq`, corner branch theorems | **GC** | Finite branch-data identity (label: consistency check / no-go finite identity). Publishable as an **audit artifact**, never as a no-doubling / safety certificate. Continuum reading is hard-stopped by Gate C. |
| 9 | `Scripts/experiments/null_edge_branch_count.py` + `null-edge-branch-count-interpretation.md` (`C2a`/`C2b`) | raw branch oracle + G3 interpretation | **NP** (as certificate) / publishable audit | No-build script + interpretation. The oracle does **not** compute the load-bearing columns (`growth_rate`, `chirality`, `internal_grading`, `gauge_content`, `krein_sign`); it cannot separate benign from fatal branches. May ship as an audit, never as a success or no-go *certificate*. |
| 10 | `PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean` (`C5`/`C7`) | `sharp`, `Ddbl`, `Jdbl` self-adjointness + "J-self-adjoint ⇏ real spectrum" counterexample | **DU** (hygiene only) | Kernel-clean Lorentzian-hygiene identity + honesty counterexample. Promotable as **hygiene**, explicitly NOT a stability/real-spectrum/positivity result. Gated from any stability claim by the locked Krein non-overclaim rule and Gate C. |

---

## 2. Promotion prerequisites for each candidate (Task 2)

Applies to the **PC** rows (1, 2) and the conditionally promotable ungraded /
hygiene rows (3-ungraded, 6, 10). Each must satisfy the G1 banner (§0.1) plus the
file-specific items below.

| File | Imports | Namespace | Docstring / banner | Source provenance | Theorem-name changes | Required checks |
| --- | --- | --- | --- | --- | --- | --- |
| `NullEdgeElectroweakStabilizer.lean` | keep current Mathlib linear-algebra imports; add the shared convention-banner import | `NullEdge.Electroweak` (or repo-standard trusted namespace), out of `Draft.*` | C5 = signature-n/a (zeroth-order rep theory); C6 = n/a (ungraded); C7 = n/a (no square); C8 = **real-coordinate lock**: `B_EW` is ℝ-linear `ℝ⁴ → ℂ²`, `dim_ℝ su(2)⊕u(1) = 4`; a ℂ-coordinate reading changes the count and is forbidden as a "fix". | `CONVENTIONS.md` "Electroweak / Structural theorem"; physics-Hermitian generators `T_i = σ_i/2`, `Y(H)=1`, `Q=T_3+Y/2`, `H_0=(0,v/√2)`. | none required; optionally add a literal **quadratic-form-rank** corollary `rank q = 3` for `q(X)=‖B_EW X‖²` for exact textual match with CONVENTIONS. | re-run C13a (elaborate), C13b (placeholder scan), C13c (`#print axioms` ⊆ `{propext, Classical.choice, Quot.sound}`); confirm `hv : v ≠ 0` is load-bearing (non-vacuous). |
| `StandardModelAnomalyAudit.lean` | current rational/`norm_num` imports + banner import | `NullEdge.StandardModel` (trusted), out of `Draft.*` | C5/C6/C7/C8 = n/a (finite rational bookkeeping). Banner must embed the **non-chirality / non-doubling disclaimer** as a docstring that travels with the theorem. | `CONVENTIONS.md` hypercharges (`Q=T_3+Y/2`, `Y(Q_L)=1/6`); one-generation left-handed Weyl spectrum. | none. | re-run C13a/b/c; confirm proofs are genuine computation (`simp`/`norm_num` on explicit rationals), not vacuous. |
| `NullEdgeFiniteTetradPostulate.lean` (ungraded promotion only) | current imports + banner | `NullEdge.FiniteTetrad`; **keep graded successors in `Draft/`** | C5/C6/C7 = **n/a (ungraded `D_N²`)** — banner must state explicitly this is NOT the graded `D²`; C8 = dual-soldered finite ring algebra. | `NULLSTRAND.md` "Frame term and tetrad compatibility"; `CONVENTIONS.md` "Frame/tetrad defect" (1/4 normalizations). | keep `Kplus` (combined `Box_null + C_diamond`) **distinct** from `K_null`; do not rename to `K_null` (A6 reserves `K_null` for one block with an alias lemma). | re-run C13a/b/c; add an in-repo **non-vanishing `T_frame` witness** (`[∇_a,C_b] ≠ 0` instance) so the tetrad hypothesis is demonstrably non-vacuous. |
| `NullEdgeKineticNormalization.lean` | imports the tetrad file + banner | `NullEdge.KineticNormalization` | naming-hygiene banner; reserve `K_null` for exactly one block; record alias to legacy `K_h`. | A6 backlog; `CONVENTIONS.md` "No double counting". | establish the single canonical `K_null` name + alias lemmas. | re-run C13a/b/c (`mass_shell_iff` uses `{propext, Quot.sound}`). |
| `KreinDoubleAndCounterexamples.lean` | current `Matrix` imports + banner | `NullEdge.Krein` | banner must carry the locked **Krein non-overclaim rule** verbatim: `J`-self-adjointness is Lorentzian hygiene, NOT real spectrum / positivity / unitary evolution / stability. | `CONVENTIONS.md` "Krein / Lorentzian adjointness"; krein-stability-audit §§1-2, 5.1. | none; keep the counterexample named so it travels as the honesty pairing. | re-run C13a/b/c; confirm the counterexample genuinely exhibits a non-real spectrum. |

**Independent-verification prerequisite for AV rows (5, 7) and audit rows (8):**
before any of these is treated as established (and before #5 is used as the Gate A
clearance anchor), re-run the live-verification protocol on them exactly as was
done for the four target files: C13a smallest elaboration check, C13b placeholder
scan, C13c `#print axioms` on every main declaration. The live verification report
covered only files 1-4; everything else is still *report-asserted*.

---

## 3. Statements semantically too strong even if they kernel-check (Task 3)

The kernel certifies validity, not the physics claim. Watch for these
over-readings; none may be promoted with the stronger reading attached:

1. **EW stabilizer counts under a ℂ-coordinate reading.** `dim ker = 1`,
   `rank = 3` hold *only* because `B_EW` is ℝ-linear `ℝ⁴ → ℂ²`. Reading it as
   ℂ-linear silently changes the count. The proof is correct; the danger is the
   interpretation. The banner's C8 real-coordinate lock neutralizes this.
2. **Tetrad/`Kplus` decomposition read as a graded super-Dirac square.** The
   tetrad file proves the **ungraded** `D_N²` identity. Promoting it as if it
   established `D² = −K_h − C_diamond − T_frame + Φ_H² − i Γ_s Σ C_a[∇_a,Φ_H]`
   would be a semantic overclaim — that graded square is exactly what Gate A
   gates. Keep the ungraded label.
3. **SM anomaly audit read as "the null-edge construction realizes the chiral
   Standard Model."** It proves one-generation anomaly arithmetic and nothing
   about chirality realization, doubling, or Nielsen-Ninomiya. The non-chirality
   disclaimer must travel with it.
4. **Krein `J`-self-adjointness read as a stability theorem.** It is hygiene
   only; real spectrum / positivity / no growing modes do NOT follow, and the
   companion counterexample proves the implication fails.
5. **Branch-count oracle output read as a no-doubling certificate.** The locked
   audit rule requires a **determinant-level** test (`det D_+(q) = 0`); a nonzero
   Lorentzian null Clifford vector can still have a kernel. Coefficient-vector
   zeros alone never establish no-doubling, and the oracle omits the load-bearing
   columns, so its output is at most an audit, never a certificate (either
   direction).
6. **High-momentum branch finite identity read as a physical doubler theorem.**
   It is finite branch *data* (label S, consistency check), not a continuum
   doubling statement and not a safety certificate.
7. **`native_decide`-backed matrix examples (super-Dirac sign / grading
   counterexamples) read as having the minimal trusted axiom set.** These add
   `Lean.ofReduceBool` and `Lean.trustCompiler` beyond `{propext,
   Classical.choice, Quot.sound}`. They remain kernel-valid, but a promotion
   banner must record the enlarged axiom set rather than implying the minimal set.

---

## 4. Promoting EW stabilizer and SM anomaly arithmetic (Task 4)

Live verification reports both clean (present, elaborates, no placeholder tokens,
axioms `{propext, Classical.choice, Quot.sound}`, statement matches claim, no
vacuity). Promotion procedure, preserving caveats:

**EW stabilizer — promote as a structural theorem.**
1. Move the file out of `Draft/` into the trusted EW namespace
   (`NullEdge.Electroweak`).
2. Attach the G1 banner; set C8 = real-coordinate lock (`ℝ⁴ → ℂ²`) as an
   **explicit import** that travels with every downstream use.
3. Keep the docstring bridge from physics-Hermitian (`T_i = σ_i/2`) to the
   anti-Hermitian compact-algebra convention (the overall `i` is a scalar leaving
   kernel/rank unchanged).
4. Optionally add the literal quadratic-form-rank corollary for an exact textual
   match with CONVENTIONS' "rank q = 3".
5. **Caveat that must remain (do NOT drop):** this is a zeroth-order
   representation-theory / stabilizer statement. It does **not** prove the
   stage-2 `m_W`, `m_Z` coefficient formulas
   (`q(W,B) = v²/8·[g²((W¹)²+(W²)²)+(gW³−g′B)²]`, `m_W = gv/2`,
   `m_Z = √(g²+g′²)v/2`, `m_γ = 0`). Those remain an unproved target (backlog
   `B11`); the convention is locked but the Lean theorem is not.

**SM anomaly arithmetic — promote as anomaly arithmetic only.**
1. Move out of `Draft/` into `NullEdge.StandardModel`.
2. Attach the G1 banner (axes n/a; finite rational bookkeeping).
3. **Caveat that must remain (load-bearing, already in the file docstring):** this
   is representation/structural bookkeeping. It does **not** show the null-edge
   construction realizes the chiral Standard Model and says nothing about doubling
   / Nielsen-Ninomiya. The disclaimer must travel with the theorem on promotion.
4. Note (not a defect) the audit's deliberate scope: only the four
   hypercharge-dependent anomalies are covered; `SU(3)³` (vector-like QCD),
   `SU(2)³` (pseudoreality), and the Witten global `SU(2)` parity condition are
   out of scope by design.

Both promotions are **independent of Gate A and Gate C** — neither file makes a
graded-square, continuum, no-doubling, or stability claim, so neither gate blocks
them.

---

## 5. What stays in Draft (Task 5)

| Piece | File(s) | Why it stays in Draft | Release condition |
| --- | --- | --- | --- |
| **Super-Dirac square** | `NullEdgeSuperDiracSignAudit.lean`, grading counterexamples, `NullEdgeSuperDiracKreinCore.lean` | This is the heart of Gate A. Until the `+Φ²` vs `−Φ²` sign theorem and the wrong-grading counterexamples are independently verified and accepted, no graded finite-square package may be promoted. Also: `native_decide` examples carry the enlarged axiom set. | Gate A accepted in Lean (independent C13a/b/c verification of `A1`/`A2`, supported by `A6`). |
| **Finite tetrad (graded use)** | `NullEdgeFiniteTetradPostulate.lean` graded successors; `B4` `NullEdgeFiniteSquareDecomposition.lean` | The *ungraded* `D_N²` identity is promotable on its own (§2), but any *graded* `D²` built on it is a finite-square theorem package → Gate A. Also needs the non-vanishing `T_frame` witness. | Gate A; add `T_frame ≠ 0` witness; keep `Kplus`/`K_null` distinct. |
| **Branch count** | `null_edge_branch_count.py`, `null-edge-branch-count-interpretation.md`, `TetrahedralHighMomentumNullBranch.lean` | Finite branch *data* / no-go *interpretation* only. The oracle omits the load-bearing columns; the locked rule requires a determinant-level test. Publishable as an audit, never a certificate. | Gate C resolved (determinant-level branch count returns and is interpreted as non-fatal). Even then: audit status, not success certificate. |
| **Krein pieces** | `KreinDoubleAndCounterexamples.lean`, `NullEdgeSuperDiracKreinCore.lean` | `J`-self-adjointness is Lorentzian hygiene only; the locked non-overclaim rule forbids reading it as stability/real-spectrum/positivity. The counterexample exists precisely to keep this honest. | The hygiene identity + counterexample may ship as hygiene (with the non-overclaim banner). No stability claim until Gate C + a genuine finite-box spectral-stability result (`C6`). |
| **Scalar kinetic reconstruction** | `NullEdgeScalarKineticReconstruction.lean` | Correct but blocked by backlog dependency: S8 must be re-audited vs B1/B3 and refactored onto the shared B0 `NullSolderFrame`. | B0 `NullSolderFrameFoundations` independently verified; S8 re-audit + refactor done. |
| **NullSolderFrame foundations** | `NullSolderFrameFoundations.lean` | Active Gate-B foundations; report-asserted, not yet independently re-verified. Stays as live `Draft/` foundations the scalar-kinetic file builds on. | Independent C13a/b/c verification; then serves as the B0 base (not a standalone physics claim). |

---

## 6. Stop list (Task 6)

Do not promote / do not launch until the named gate resolves. Kernel-clean status
is irrelevant to these stops — they are semantic / gate stops.

| Stopped item | Backlog ID(s) | Blocked by | Stop reason |
| --- | --- | --- | --- |
| Finite **graded** square package | `B4`, `T14`, `B5`, `D7`, `M5` | **Gate A** | Hard promotion prerequisite (Working Plan §21.2). No finite-square theorem package until the super-Dirac sign theorem + wrong-grading counterexamples clear in Lean. |
| Graded successors of the tetrad file | (tetrad → graded `D²`) | **Gate A** | Same rule; the ungraded `D_N²` identity is the only promotable part now. |
| Super-Dirac sign / grading counterexamples used as Gate A clearance | `A1`, `A2` (support `A6`) | independent verification | Report-asserted only; not re-run by the live verification job. Must pass C13a/b/c first; record the `native_decide` axioms (`Lean.ofReduceBool`, `Lean.trustCompiler`). |
| Continuum / no-doubling / square-limit promotion | `D*`, continuum targets | **Gate C** | Kill switch (Working Plan §21.4). No continuum work until the determinant-level branch count returns non-fatal. |
| Chirality work (Nielsen-Ninomiya evasion, domain-wall, overlap) | `C8`–`C12`, `E8` | **Gate C** | Same kill switch; chirality launches only after branch count is interpreted as non-fatal. |
| Branch-count oracle output as a no-go / success **certificate** | `C2a`/`C2b` | locked audit rule + **Gate C** | Oracle omits load-bearing columns (`growth_rate`, `chirality`, `internal_grading`, `gauge_content`, `krein_sign`); coefficient-zeros ≠ no-doubling. Publishable as audit only. |
| High-momentum branch finite identity as a doubler / safety theorem | `C1`/`C3` | **Gate C** | Finite branch data (label S); not a physical doubler theorem, not a safety certificate. |
| Krein `J`-self-adjointness as a stability / real-spectrum / positivity claim | `C5`/`C7` | locked Krein non-overclaim rule + **Gate C** | Hygiene only; the counterexample proves real spectrum does not follow. |
| EW stage-2 coefficient theorem (`m_W`, `m_Z`, `m_γ=0`) | `B11` | unproved (not a gate) | Convention locked, Lean theorem not done. The EW stabilizer promotion must not be read as covering coefficients. |
| Scalar kinetic reconstruction leaving `Draft/` | S8 | B0 dependency | Must refactor onto verified `NullSolderFrame` (B0) and re-audit vs B1/B3 first. |
| `B_QCD` / proton-mass / QCD obstruction-map claims | `C*`/QCD | unlocked theorem content | No `B_QCD` until an actual finite color-holonomy gap theorem exists; Plücker does not derive proton mass. |

---

## 7. One-line summary

Promote now (after banner): **EW stabilizer** (structural theorem, real-coordinate
+ no-coefficient caveats) and **SM anomaly arithmetic** (anomaly-only,
non-chirality caveat). Promote the **ungraded tetrad `D_N²` identity**, **kinetic
naming hygiene**, and **Krein hygiene** as labelled non-overclaiming lemmas.
Keep **super-Dirac graded square**, **finite graded square**, **scalar kinetic**,
**branch count**, and **Krein stability** in Draft. Hard-stop all finite
graded-square promotion behind **Gate A** and all continuum / no-doubling /
chirality work behind **Gate C**. The kernel checked validity, not physics —
every promotion carries its convention banner and its caveats.
