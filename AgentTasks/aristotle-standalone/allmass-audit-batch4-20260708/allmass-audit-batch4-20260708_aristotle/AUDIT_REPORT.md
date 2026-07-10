# Adversarial over-claim audit — batch 4 (all-mass landed results)

Audit only (no proofs written; no source modified). Every statement below was
checked by hand against the Lean text; the mechanical `dGamma2` construction and
all eigenvalue/spectrum claims were re-derived independently.

## Verification status of the snapshot

- `src/InteractingTwoBody.lean` — imports only `Mathlib`; **builds and is
  axiom-pinned here** (`#print axioms … = [propext, Classical.choice, Quot.sound]`).
  No `sorry`/`admit`/`axiom`/`implemented_by`.
- `src/DerivedInteraction.lean` — imports
  `PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody`, a module path that does
  **not exist in this snapshot** (the in-repo module is `InteractingTwoBody`).
  So this file is **not rebuilt in this sandbox**; it was kernel-checked in its
  original project. I audited it mathematically instead (all pure-matrix claims
  verified by hand — see below).
- `src/CarrierGradedBudget.lean` — imports `…Carrier.EquivariantGradedIndex`
  and `…Carrier.CarrierKreinSquare`, **neither of which is present anywhere in
  the snapshot** (searched whole filesystem). Its entire mathematical content is
  inherited from `carrier_krein_square` + `graded_budget_decomposition`, which
  are **outside the audited set and cannot be inspected**. This is a material
  limitation of what can be certified here.

---

## `InteractingTwoBody.lean`

| Theorem | Statement (paraphrase) | Class | Verdict |
|---|---|---|---|
| `interaction_isHermitian` | `!![0,-κ,0;-κ,0,0;0,0,0]` is Hermitian | correct matrix fact | CLEAN |
| `H2_isHermitian` | `freeH2 + V` Hermitian | correct | CLEAN |
| `discr_nonneg` | `0 ≤ (a-c)²/4+κ²` | correct | CLEAN |
| `boundEnergy_key` | `(a-μ)(c-μ)=κ²` for `μ=boundEnergy` | correct (verified: `s²-((a-c)/2)²=κ²`) | CLEAN |
| `boundEnergy_mem_spectrum` | `boundEnergy` is an eigenvalue, evec `![-κ, be-a, 0]≠0` | correct (evec re-derived) | CLEAN |
| `boundEnergy_lower_bound` | any eigenvalue `≥ boundEnergy` | correct (det factorisation) | CLEAN |
| `boundEnergy_isLeast` | `IsLeast (spectrum2) boundEnergy` | correct | CLEAN |
| `pairThreshold_eq` | sorted ⇒ threshold `= d0+d1` | correct | CLEAN |
| `boundEnergy_lt_pairThreshold` | `boundEnergy < d0+d1` when `κ>0` | correct (strict, driven by `κ²>0`) | CLEAN |
| `interacting_boundState_below_threshold` | flagship: `IsLeast ∧ < threshold` | correct **matrix/spectral** fact | CLEAN |

**Assessment.** This file is honest. It *explicitly self-grades*: **M** (the
below-threshold eigenvalue is a real kernel-checked computation, no hand-inserted
defect) is earned; **C** (the *hadron* identification) is disclaimed in the
docstring — "its rank-one attractive *form* is inserted, not derived … NOT yet a
first-principles derivation of a hadron mass." Docstrings do **not** outrun the
kernel.

- MINOR wording nit: `interaction` is called "rank-one"; the off-diagonal
  `2×2` block `[[0,-κ],[-κ,0]]` has **rank 2** (eigenvalues `±κ`). Cosmetic;
  no bearing on any theorem. Remedy: drop "rank-one", say "off-diagonal /
  hopping coupling".

---

## `DerivedInteraction.lean`

All pure-matrix claims re-derived by hand and confirmed.

| Theorem | Statement (paraphrase) | Class | Verdict |
|---|---|---|---|
| `dGamma2_diagonal` | `dΓ(diag d)=freeH2` | correct | CLEAN |
| `Vderived_eq` | `dΓ(iκK)=!![0,-iκ,0;iκ,0,0;0,0,0]` | correct (all 9 entries checked) | CLEAN |
| `Vderived_isHermitian` / `oneBodyClosure_isHermitian` | Hermitian | correct | CLEAN |
| `Vderived_strength` | `‖V₀₁‖=|κ|` | correct | CLEAN |
| `Vderived_eq_zero_iff` | `V=0 ↔ κ=0` | correct | CLEAN |
| `H2der_eq` | `H2der=freeH2ℂ+Vderived` | correct | CLEAN |
| `Vderived_conj` | `Vderived=U·(interaction)ℂ·U⁻¹`, `U=diag(1,-i,1)` | correct (genuine unitary) | CLEAN |
| `H2der_conj` | `H2der=U·H2ℂ·U⁻¹` | correct | CLEAN |
| `conj_spectrumC`, `realComplexSpectrum`, `spectrum2_eq_realSpec` | spectrum plumbing | correct | CLEAN |
| `spectrumC_H2der` | `spectrumC(H2der)=spectrum2` | correct | CLEAN |
| `derived_boundState_below_threshold` | **derived** H binds below threshold | correct **matrix** fact | statement CLEAN; **docstring LOAD-BEARING** |
| `Vderived2_eq`, `H2der2_eq`, `Vderived2_conj`, `H2der2_conj`, `spectrumC_H2der2` | wrong-plane plumbing | correct | CLEAN |
| `Hreal2_isLeast_threshold` | wrong-plane least eig `= d0+d1` when `κ²≤(d2-d0)(d2-d1)` | correct (boundary re-derived) | CLEAN |
| `derived_wrongPlane_no_binding` | ground-plane closure ⇒ no binding | **genuine geometric no-go** | CLEAN |
| `massBlock_*` | block `λI+iκK`, ground mode at `λ-κ` | correct | CLEAN |

Answers to the three probes:

- **(a) Is `dGamma2` the honest antisymmetric second quantization, and is
  `Vderived` genuinely the closure operator?** `dGamma2` **is honest** — I
  re-derived all three columns from `dΓ(A)(eᵢ∧eⱼ)=(Aeᵢ)∧eⱼ+eᵢ∧(Aeⱼ)` in the
  ordered wedge basis `{e₀∧e₁, e₀∧e₂, e₁∧e₂}` and every entry matches. `Vderived
  = dGamma2(iκK)` is a genuine mechanical `dΓ` of a genuine one-body operator.
  **This part earns grade M.**
- **(b) Is `Vderived_conj` doing real work or hiding the same hand-drawn V?**
  Real work: `U=diag(1,-i,1)` is a genuine diagonal unitary, and the derived
  matrix `!![0,-iκ…]` is *not literally* the modelled `!![0,-κ…]` — they differ
  by the closure phase `i` and are unitarily equivalent. Transparent, not hidden.
- **(c) Is `derived_wrongPlane_no_binding` genuine or contrived?** Genuine. The
  ground-plane generator `K₂` second-quantizes to a coupling of the two *heavier*
  pairs, leaving the ground pair decoupled at threshold; the boundary
  `κ²≤(d2-d0)(d2-d1)` is exactly "smaller root of the heavy block `≥ d0+d1`",
  which I re-derived. It is the honest converse, not a straw man.

**The over-claim (docstring-outruns-kernel).** The module framing —
"Deriving the two-body interaction `V` from the carrier's closure geometry",
"first-principles", "it is **exactly** the second-quantized closure operator **of
the carrier**", "upgrading the hadron seed from grade C to grade M" — outruns
what is proved. What the kernel proves is: `dΓ` of a **chosen** curvature
`closureCurvature` (the `{1,2}` excited-mode generator) equals the modelled `V`
up to a phase gauge, hence binds. What is **not** proved, and is the decisive
input, is that `closureCurvature` **is** the carrier's actual `K`. That
identification appears **only as a docstring assertion**; the carrier module
(`CarrierKreinSquare`) is **not even imported** by this file, so there is no
formal link from `B(λ,κ)=λI+iκK` to the specific `{1,2}`-plane matrix. And the
file's own `derived_wrongPlane_no_binding` **proves that this choice is
load-bearing**: a different admissible curvature (`{0,1}`-plane) yields *no*
binding. So "the interaction is derived from the carrier" is really "**if** the
closure is posited to act among the excited modes, **then** `dΓ` reproduces the
modelled binding" — a conditional grade-M fact, with the choice of plane still a
modelling input. The residual **C** (which curvature / which modes) is renamed,
not discharged.

---

## `CarrierGradedBudget.lean`

| Theorem | Statement (paraphrase) | Class | Verdict |
|---|---|---|---|
| `carrier_graded_budget` | `4·sdim(D^#D) = Σ` four channel supertraces, `D=D0+Γφ` | thin **trace-linearity wrapper** over an off-snapshot identity | CLEAN *as stated* / **cannot be certified here**; MINOR framing |

**Assessment.** The proof body is two lines: obtain the budget from
`carrier_krein_square`, then apply `graded_budget_decomposition`. By the file's
own admission `Grade, sym` are **arbitrary** and "the identity is pure supertrace
linearity applied to the real budget." So the actual content — the **operator**
identity `4 D^#D = Q_A^# + Q_C^# + 4φ² + 4E_#` and, crucially, the
non-question-begging status of its hypotheses — lives entirely in
`carrier_krein_square`, which **is not present in this snapshot** and could not be
inspected. Therefore:

- "the graded-budget hypothesis is **discharged on the real carrier**" is only as
  strong as `carrier_krein_square`; **this audit cannot confirm or refute** that
  the carrier square isn't itself restated with question-begging assumptions,
  because that module is absent.
- The docstring is, to its credit, honest that this file is a linearity wrapper
  ("budget is supplied by `carrier_krein_square`"). So `carrier_graded_budget`
  itself is not an over-claim; it just **carries no independent content** — the
  weight is entirely borrowed. Flag: the certification chain has an
  **unavailable link**.

---

## THE single most load-bearing over-claim

**`DerivedInteraction.lean` — the "C → M / first-principles hadron / it is
exactly the carrier's closure operator" framing around
`derived_boundState_below_threshold`.**

- **Why load-bearing.** It is the headline scientific claim of the batch (the
  jump from a *modelled* attractive `V` to one *derived from the carrier*). The
  theorem statement is a clean grade-M matrix fact, but the docstrings assert an
  unconditional first-principles derivation.
- **Exact mismatch.** The kernel proves only that `dΓ` of a **hand-chosen**
  curvature (`closureCurvature`, the `{1,2}` plane) reproduces the modelled `V`
  up to a phase gauge. The claim that this curvature **is the carrier's `K`** is a
  bare docstring assertion — the carrier module is not imported and no lemma
  connects `B(λ,κ)=λI+iκK` to this specific matrix. The file's own
  `derived_wrongPlane_no_binding` proves the choice of plane is exactly what
  decides whether binding occurs, so the decisive input is modelling, not
  derivation.
- **Exact remedy (either):**
  1. **Close the gap:** import the real carrier (`CarrierKreinSquare`) and prove
     that the carrier's mass-block curvature `K` is (up to unitary/basis change)
     the excited-mode generator — i.e. *derive which plane* from the carrier data.
     Then the unconditional "C→M / first-principles" language is earned.
  2. **Downgrade the language:** restate the docstrings as a **conditional**
     grade-M result — "**if** the carrier's closure curvature acts among the
     excited modes (`closureCurvature`), then its honest second quantization `dΓ`
     reproduces the modelled below-threshold binding; the *choice of curvature
     plane* remains a modelling input, as witnessed by
     `derived_wrongPlane_no_binding`." Drop "first-principles" and
     "exactly the closure operator **of the carrier**"; keep "honest `dΓ` of a
     posited closure operator".

Secondary flag (not an over-claim in the file itself, but a **gap in the audit
chain**): `CarrierGradedBudget.lean`'s discharge is only as sound as
`carrier_krein_square`, which is **absent from the snapshot** and hence
un-auditable here.
