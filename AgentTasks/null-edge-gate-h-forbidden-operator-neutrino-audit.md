# H11 — Forbidden finite operators and neutrino stress-test audit

Status: strategy deliverable (Gate H / Gate F design).
Companion Lean skeleton: `PhysicsSM/Draft/NullEdgeLegalFiniteDiracNeutrinoAudit.lean`
(builds clean, no `sorry`/`axiom`; axiom base `propext, Classical.choice, Quot.sound`).

This audit answers the H11 brief: what *legal finite Dirac/Higgs operators* look
like, which forbidden blocks are killed by which mechanism, and where the
right-handed neutrino sits. It is written to be turned directly into Aristotle
Lean prompts without a further strategy pass.

The single load-bearing physical claim is an **absence theorem**, not a number:

> legal finite Dirac/Higgs blocks have the Standard Model block form and exclude
> leptoquark, diquark, proton-decay, wrong-hypercharge, and colored-Higgs blocks.

---

## 0. Setting and conventions (fixed by the existing repo)

We work on the doubled chiral space `L ⊕ R` of
`PhysicsSM.Draft.NullEdgeForbiddenCountertermCodim` and
`PhysicsSM.Draft.NullEdgeSuperDiracBlockCore`, with the spacetime chirality
grading `Γ_s = +1` on `L`, `-1` on `R`. A legal finite Dirac term is **odd**:
`{Γ_s, D} = 0` (the `IsOdd` predicate; `offDiagonal_isOdd`,
`odd_diag_left_zero`, `odd_diag_right_zero`).

The labels (multiplets, hypercharge, weak/colour reps) come from the trusted
`PhysicsSM.StandardModel.OneGenerationTable` and the bookkeeping layer
`PhysicsSM.Draft.NullEdgeYukawaFlip` / `NullEdgeYukawaGaugeAristotle`. Hypercharge
uses `Q = T₃ + Y/2`. The right-handed neutrino `ν_R` is already present in the
table as the optional `(1,1,0)` state, with `physicalList15` (no `ν_R`) and
`physicalList16` (with `ν_R`).

A **finite Dirac/Higgs block** is the bilinear `bar(src) · higgs · tgt` for
`src, tgt : PhysicalMultiplet` and a scalar `higgs ∈ {none, H, H̄}`. This is the
finite, labelled refinement of the `offDiagonal φ ψ` block.

---

## 1. The `LegalFiniteDirac` predicate (minimal proposal)

A block is legal iff **four independent clauses** all hold, each pinned to one
mechanism so that an illegal block fails a *named* clause — it vanishes *for a
reason*, not by being omitted from a hand-curated list. (Realized verbatim in the
Lean skeleton.)

```text
LegalFiniteDirac (src, tgt, higgs) :=
  ChiralityOdd        src.chirality ≠ tgt.chirality            -- χ_E / Γ_s grading
∧ HyperchargeNeutral  -Y(src) + Y(higgs) + Y(tgt) = 0          -- U(1)_Y gauge (Dirac, barred)
∧ WeakSinglet         Even (#doublets among src, higgs, tgt)   -- SU(2)_L gauge
∧ ColorSinglet        colorPattern src = colorPattern tgt      -- SU(3)_c gauge
```

For the **Majorana (`J_F`, no-bar) branch** the source is not barred, so the
hypercharge clause is the *separate* predicate

```text
MajoranaNeutral (src, tgt, higgs) :=  Y(src) + Y(higgs) + Y(tgt) = 0
```

(`= 2·Y(src)` for a bare same-multiplet mass). This distinction is load-bearing:
`HyperchargeNeutral` cancels *trivially* for `src = tgt`, so it would wrongly
declare every charged-state Majorana mass gauge-neutral; `MajoranaNeutral` is the
correct clause and holds iff `Y(src) = 0` (see §3).

Design notes / why this exact shape:

- **`ChiralityOdd`** is the labelled form of the `NullEdgeForbiddenCountertermCodim`
  result: `Γ_s`-oddness forces both diagonal (same-chirality) blocks to vanish.
  Any same-chirality (bare Dirac/Majorana/diquark) bilinear fails *here*.
- **`HyperchargeNeutral`** carries the bar (charge-conjugation of the source),
  so the convention is `-Y(src) + Y(higgs) + Y(tgt)`. This is exactly the
  `hyperchargeDefect` of `NullEdgeYukawaFlip`, lifted to general blocks. The
  Majorana (no-bar) variant is `MajoranaNeutral`.
- **`WeakSinglet`** uses the parity surrogate "the product of `SU(2)` reps
  contains a singlet iff the number of doublets is even" (`2⊗2 ⊃ 1`, `2⊗1 = 2`,
  `1⊗1 ⊃ 1`). Adequate for the binary doublet/singlet bookkeeping in play; it is
  **not** a full Clebsch–Gordan theory (see warnings).
- **`ColorSinglet`** uses "`bar(src) · tgt` contains a colour singlet iff the
  colour patterns agree" (`3̄⊗3 ⊃ 1`, `1⊗1 ⊃ 1`, `3̄⊗1 = 3̄`). This is correct for
  the *bar* (particle–antiparticle) convention; same-chirality `3⊗3` diquark
  contractions are a different route handled in §2.

All four clauses are decidable, so every concrete claim closes by `decide` /
`norm_num` (the `ℚ` hypercharge clause needs `norm_num`, not kernel `decide`).

---

## 2. Which mechanism kills which forbidden block

This is the core decomposition requested. The honest split is **three tiers**.

### Tier A — killed by gauge covariance alone (within the bilinear ansatz)

These need only the three gauge clauses; no `J_F`, no order-one, no `χ_E`.

| forbidden block | example | failing clause | mechanism |
|---|---|---|---|
| **leptoquark** | `bar(L_L) · d_R` | `ColorSinglet` (`1 ≠ 3`) | `SU(3)_c` |
| **wrong-hypercharge / wrong-Higgs** | `bar(Q_L) · H · u_R` (needs `H̄`) | `HyperchargeNeutral` (`= 2 ≠ 0`) | `U(1)_Y` |
| **colored-Higgs** | scalar in a colour triplet | excluded by the scalar ansatz | `SU(3)_c` (Higgs rep fixed) |

Lean (proved in the skeleton):
`leptoquark_forbidden_by_color`, `wrongHiggs_up_forbidden_by_U1`. The wrong-Higgs
example is deliberately chosen colour-**and**-weak-**and**-chirality legal, so the
*only* failing clause is `U(1)_Y` — a clean single-mechanism witness. Colored-Higgs
is excluded because `HiggsSlot` is a colour singlet by construction: a colour-triplet
scalar is simply not in the legal scalar sector, so no block routes colour through
the Higgs.

### Tier B — killed by the `χ_E` / `Γ_s` grading (needs `J_F` to even be written)

Same-chirality bilinears are *not of the `bar(L)·R` form*; they connect two fields
of equal chirality without a bar. They fail `ChiralityOdd` (they are diagonal /
`Γ_s`-even), which is exactly `odd_diag_left_zero` / `odd_diag_right_zero` of
`NullEdgeForbiddenCountertermCodim`.

- **diquark** (`q q`, `u u`, `d d`): same chirality ⇒ fails `ChiralityOdd` at the
  bilinear level. To write one at all you must invoke the real structure `J_F`
  (charge conjugation) and reinterpret it as an off-diagonal `E → E^c` block. At
  the `J_F`-extended level it is then killed *again* by colour: `3⊗3 = 3̄ ⊕ 6`
  contains no singlet. So diquark = (grading) ⊕ (gauge at the `J_F` level).
- **bare Majorana same-Weyl mass** (`ν_R ν_R`, any `e_R e_R`, …): same story —
  grading kills the naive bilinear; only `J_F` can realize it as `E_R ↔ E_R^c`.

### Tier C — killed by the order-one / bilinearity condition (only second-order)

- **proton-decay operators** (`q q q ℓ`, dimension-6 four-fermion): not bilinear,
  hence **not finite-Dirac-operator data** at all. The Dirac operator is a
  first-order (bilinear) object; multi-fermion operators can only appear as
  *composite, higher-order effective* operators. Forbidding them is the order-one /
  bilinearity condition, plus ideal-compatibility on which composites are allowed.
- **seesaw** `M_eff = -M_D M_R⁻¹ M_Dᵀ`: likewise *second-order*. It is not a legal
  primitive block; it is generated, and only when the `J_F`-Majorana `M_R` branch
  is itself admitted (§3).

### Summary of mechanisms

```text
gauge-only (3 clauses) : leptoquark, wrong-hypercharge, colored-Higgs
χ_E / Γ_s grading      : every same-chirality bilinear (diquark, bare Majorana)
J_F real structure     : required even to *formulate* Majorana / diquark
                         (then re-tested by gauge: ν_R^c passes, diquark fails colour)
order-one / bilinearity: proton decay (4-fermion) and seesaw are not primitives
ideal compatibility    : governs which second-order composites are admissible
```

---

## 3. Neutrino decision table (ν_R is a flag, not a solved mechanism)

| branch | block | gauge clauses | grading `χ_E` | verdict |
|---|---|---|---|---|
| `ν_R` **absent** | no `tgt = ν_R` block exists | — | — | nothing to forbid; `M_D = M_R = 0`, `M_eff = 0` |
| `ν_R`, **Dirac only** | `bar(L_L) · H̄ · ν_R` | all pass | odd ✓ | **legal** (canonical Yukawa) |
| `ν_R`, **Majorana** `M_R` | `ν_R · ν_R^c` (`J_F`) | `MajoranaNeutral` (`2Y=0`), weak/colour singlet | **fails** | gauge-allowed but `Γ_s`-forbidden; admissible **only via `J_F`** |
| **seesaw** `M_eff` | `-M_D M_R⁻¹ M_Dᵀ` | inherited | composite | second-order; exists **iff** the `J_F` `M_R` branch is taken |

Lean witnesses (proved in the skeleton):

- `diracNeutrino_legal` — the Dirac branch is `LegalFiniteDirac`.
- `majoranaNeutrino_gauge_allowed` — the Majorana block passes the three gauge
  clauses **using `MajoranaNeutral`** (`2·Y(ν_R) = 0`), weak singlet, colour
  singlet — i.e. genuinely because `Y(ν_R) = 0`.
- `majoranaNeutrino_forbidden_by_grading_only` — it nonetheless fails
  `ChiralityOdd`, hence is not legal; the **single** failing clause is the grading.
- `majorana_gauge_open_iff_hypercharge_zero` — for *any* right-handed multiplet
  `m`, the bare Majorana coupling `m ↔ m^c` is gauge-open **iff** `Y(m) = 0`; so
  the branch opens for `ν_R` and stays `U(1)_Y`-forbidden for every charged
  right-handed state.
- `seesaw_requires_majorana_branch` — with `M_R = 0` the seesaw
  `M_eff = -M_D M_R⁻¹ M_Dᵀ` is identically zero (the second-order obstruction).

This is the sharp separation the brief asks for: the Majorana mass is **not** a
gauge obstruction. It is gauge-perfect (a total singlet) and is excluded purely by
`Γ_s`-oddness. Whether it is ultimately admitted is decided by data *outside*
gauge covariance — the real structure `J_F`, the KO-dimension sign rules
(`J² = ±1`, `JΓ = ±ΓJ`), and the order-one condition — which reinterpret
`E_R → E_R^c` as a genuine off-diagonal odd block. Hence:

- `M_R` is **not canonical** (not forced by the legal-block clauses),
- `M_R` is **not gauge-forbidden** (it is a total singlet),
- `M_R` is a **`J_F`-conditional flag**.

Consequently the seesaw `M_eff` is a *second-order effective obstruction*: it is
never a primitive legal block, it is the composite `-M_D M_R⁻¹ M_Dᵀ`, and it is
nonzero **iff** the `J_F` Majorana branch is switched on.

---

## 4. Upgrading `NullEdgeForbiddenCountertermCodim`

That file proves the **grading-only** half: any odd operator has identically
vanishing diagonal blocks, so a same-chirality mass is removed by `Γ_s` (not by
being unwritten), with the codimension `(card L)² + (card R)²`.

To upgrade from *"diagonal same-chirality mass is forbidden"* to *"SM-legal blocks
only"* you must add the **internal-algebra data** that the pure spacetime grading
does not see:

1. **Labelled internal reps.** The internal algebra `A_F = ℂ ⊕ ℍ ⊕ M₃(ℂ)` and its
   action on `H_F`, i.e. the `(Y, SU(2)_L, SU(3)_c)` labels on every summand. Gauge
   covariance becomes "`D` is a connection / `[D, a]` has the right bimodule type."
   `LegalFiniteDirac`'s three gauge clauses are precisely this data in finite,
   decidable form.
2. **The real structure `J_F`** (charge conjugation) and its KO-dimension signs.
   This is what distinguishes "particle–antiparticle Dirac block" from
   "field–conjugate Majorana block," and is the *only* gate through which
   Majorana/diquark blocks can enter.
3. **The order-one (first-order) condition** `[[D, a], J b J⁻¹] = 0`. This both
   pins the off-diagonal structure and enforces bilinearity, excluding proton-decay
   four-fermion operators as primitives.
4. **The internal grading `χ_F`** compatible with `Γ_s` (so that `γ = Γ_s ⊗ χ_F`),
   which selects the physical chiral content.

`NullEdgeForbiddenCountertermCodim` supplies (the spacetime part of) item 4 only.
H11's `LegalFiniteDirac` adds item 1. Items 2–3 are the genuinely new internal
data and are the content of the *next* theorems (§5).

---

## 5. The first three exact Lean theorem statements to submit next

The skeleton already discharges the per-block witnesses of §2–§3 **and** the
corrected Majorana gauge condition (`majorana_gauge_open_iff_hypercharge_zero`,
replacing the originally-drafted `…_iff_singlet`, which was *false* because the
bar-convention `HyperchargeNeutral` cancels for `src = tgt`) **and** the seesaw
obstruction (`seesaw_requires_majorana_branch`). The three statements below are
the genuinely-open next rungs, escalating toward the strongest absence theorem.
Statements are exact and `sorry`-ready (namespace
`PhysicsSM.Draft.NullEdgeLegalFiniteDirac`).

### T1 (cheapest) — completeness: only the SM Yukawa blocks are legal

```lean
/-- Among all chirality-flipping blocks with a genuine Higgs insertion and a
left-handed source, the legal ones are *exactly* the Standard Model Yukawa
channels.  Forbidden families are absent, not omitted. -/
theorem legal_yukawa_complete (b : DiracBlock)
    (hsrc : b.src.chirality = .left) (hH : b.higgs ≠ .nohiggs) :
    LegalFiniteDirac b ↔ ∃ v : YukawaFlip, blockOfFlip v = b := by
  sorry
```

Cheapest because `DiracBlock` is finite (6 × 6 × 3 = 108); the proof is a finite
enumeration. Note: a naive `decide` will stall on the `ℚ` hypercharge clause, so
the prompt should suggest either an `ℤ`-scaled hypercharge (`6 * Y`) for the
enumeration, or a `Finset.filter` over an explicit `DiracBlock` `Fintype` with the
gauge clauses normalized by `norm_num`.

### T2 (medium) — `J_F` upgrades the grading-forbidden Majorana into an odd block

This is the operator-level content of "the `J_F` real structure rescues the
Majorana flag": doubling `E_R` into `E_R ⊕ E_R^c` turns the grading-forbidden
*diagonal* mass into an admissible *off-diagonal* `Γ_s`-odd block (the `IsOdd` /
`offDiagonal` machinery of `NullEdgeForbiddenCountertermCodim`).  Needs
`import PhysicsSM.Draft.NullEdgeForbiddenCountertermCodim`.

```lean
open PhysicsSM.Draft.ForbiddenCounterterm in
/-- Realized via `J_F` as an off-diagonal block on the doubled space
`E_R ⊕ E_R^c`, a right-handed Majorana mass `Mr` is `Γ_s`-odd, hence admissible —
the precise sense in which `J_F` converts the grading-forbidden diagonal mass
(`odd_diag_*_zero`) into a legal off-diagonal one. -/
theorem majorana_JF_block_isOdd {g : Type*} [Fintype g] [DecidableEq g]
    (Mr : Matrix g g ℂ) :
    IsOdd (L := g) (R := g) (offDiagonal Mr.conjTranspose Mr) := by
  sorry
```

The genuinely *new* job (separate, larger) is to thread the gauge labels through
this doubling, so that `majorana_JF_block_isOdd` is admitted **iff**
`majorana_gauge_open_iff_hypercharge_zero` holds — i.e. only for `ν_R`.

### T3 — generation-indexed completeness of the legal Dirac operator

```lean
/-- Over an index type `g` of generations, the only block-diagonal data assembling
into a `Γ_s`-odd, gauge-covariant, first-order finite Dirac operator are the four
SM Yukawa matrices (plus the Dirac neutrino block when `ν_R` is present); every
leptoquark/diquark/proton-decay/wrong-hypercharge/colored-Higgs block is forced to
zero.  (Schematic signature; the predicate `GaugeCovariantOddFirstOrder` packages
the four clauses at the matrix level.) -/
theorem legal_dirac_operator_is_SM (D : FiniteDiracData g)
    (hD : GaugeCovariantOddFirstOrder D) :
    D.blocks = SMYukawaBlocks g := by
  sorry
```

This is the matrix-level lift of T1: where T1 classifies *one* labelled block, T3
classifies the *whole* operator. It requires a small `FiniteDiracData` /
`GaugeCovariantOddFirstOrder` scaffold (the next file to author).

### The strongest eventual forbidden-operator theorem

The end target (a separate, larger job — *not* one of the three above) is the
finite-spectral-triple classification:

> For the Standard-Model finite geometry `(A_F, H_F, D_F, J_F, γ_F)`, every `D_F`
> satisfying [odd for `γ_F`] ∧ [first-order] ∧ [`J_F`-commutant] ∧ [gauge
> covariance] has block form equal to the SM Dirac/Yukawa operator, with all
> leptoquark, diquark, proton-decay, wrong-hypercharge and colored-Higgs blocks
> *identically zero*.

i.e. a genuine moduli/codimension statement — the Connes–Chamseddine "SM is the
forced finite geometry" recast as an **absence theorem**. T1–T3 are the rungs
that make this reachable without another strategy pass.

---

## 6. Warning list — overclaims to avoid

The audit and skeleton deliberately stop short of physics they do **not** earn:

- **No Yukawa values.** Nothing here fixes any coupling magnitude; legality is a
  yes/no on block *structure*, never a number.
- **No mixing angles.** No CKM/PMNS content; generation indices are not even
  resolved (the skeleton is one-generation/representation-level).
- **No generation-number derivation.** The number of families is an input
  (`physicalList15/16`), not a theorem.
- **No Gate C release.** Gate C requires `LiftNonOrigin ∧ OriginWeylPure` plus the
  ghost/Krein/gauge/counterterm clauses (`NullEdgeRegulatorLegalGateCRelease`);
  none of that is touched here. Legality of a *block* is necessary, not
  sufficient.
- **`WeakSinglet`/`ColorSinglet` are parity surrogates**, not full tensor-product
  representation theory; they are sound for the binary doublet/singlet,
  triplet/singlet bookkeeping used, and should not be read as a Clebsch–Gordan
  decomposition.
- **`ν_R` is a flag.** The Majorana branch and the seesaw are stated as
  *conditional* on the `J_F` real structure and its KO-dimension signs, which are
  not discharged here. We do **not** claim that `M_R` is canonical, nor that
  neutrinos are Majorana.
- **Finite / no continuum.** Everything is finite linear algebra and labelled
  bookkeeping on `L ⊕ R`; no continuum Dirac operator, spectral action, or
  quantum-measure claim is made.

---

## 7. Pointers

- Skeleton: `PhysicsSM/Draft/NullEdgeLegalFiniteDiracNeutrinoAudit.lean`
- Grading codimension (Tier B core): `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean`
- Block algebra: `PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean`
- Labels / hypercharge: `PhysicsSM/StandardModel/OneGenerationTable.lean`
- Yukawa hypercharge defect: `PhysicsSM/Draft/NullEdgeYukawaFlip.lean`
- Rep-pattern API: `PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean`
- Gate C release contract (not released here): `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`
