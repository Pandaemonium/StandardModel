# C171 — Anomaly/index and locality/control import certificates

**Job:** design the certificate package that C159 (`GateC1_NU` assembly)
consumes after the finite / gap / homotopy pieces (C154, C156, C160-C166, C170)
are in place.

**Verdict.** `GateC1_NU` is **not** closed. What is delivered is a *typed
import boundary*: every physically loaded claim (anomaly cancellation, index
match, locality, well-defined measure, ghost-freedom, gapped homotopy) is carried
as a named, explicit certificate field. Two of the forbidden shortcuts (GW⇒
anomaly-free, sign⇒locality) are *proved* to fail. Formalized, proof-placeholder-free, in
`RequestProject/C171.lean` (axioms: `propext`, `Classical.choice`, `Quot.sound`).

---

## 1. Certificate stack

```text
ReferenceImportContract
├── kind : RefKind                        -- directFlavoredOverlap | abstractBlock | domainWall
├── AnomalyIndexCertificate               -- §1  anomaly / index import
│     index_transported, reference_anomaly_free, anomaly_transported
├── LocalityControlCertificate            -- §2  locality / control
│     coeff_nonneg, shells_summable, admissible
├── DetGhostControlCertificate            -- §3  determinant-line / ghost (kept visible)
│     det_line_trivial, no_ghost_zero
└── SubgapCertificate                     -- §4  interface to C164/C170
      gap_pos, subgap
        │
        ▼
   reference_import_valid  ⇒  GateC1_NU_ImportValid   (§5, C159 precondition bundle)
```

The contract is **mode-parametric** (`RefKind`). The recommended order from C166
is: `abstractBlock` first (cheapest, C172), `domainWall` second,
`directFlavoredOverlap` last. The *same* four certificate families are required
for every mode; only the way each field is discharged differs (see §Literature
mapping and §Open checks).

---

## 2. Anomaly / index import contract (constraint #1)

`AnomalyIndexCertificate A` over data `A : AnomalyImportData`
(`refIndex neIndex : ℤ`, `refAnomalyCoeff neAnomalyCoeff gwResidual : ℝ`):

| field | meaning | discharged by |
|---|---|---|
| `index_transported : A.neIndex = A.refIndex` | sector-signature match transports the index | C154 + gapped homotopy |
| `reference_anomaly_free : A.refAnomalyCoeff = 0` | reference matter content is anomaly-free | **reference index theorem** (per mode) |
| `anomaly_transported : A.neAnomalyCoeff = A.refAnomalyCoeff` | gapped homotopy keeps the anomaly coefficient invariant | C164/C170 sub-gap |

Transfer: `AnomalyIndexCertificate.ne_anomaly_free` ⇒
`neAnomalyCoeff = 0 ∧ neIndex = refIndex`.

**Boundary proved:** `gw_alone_insufficient` — a model can satisfy `GWHolds`
(`gwResidual = 0`) exactly and still have `neAnomalyCoeff ≠ 0`. So
`reference_anomaly_free` is independent: anomaly cancellation must come from the
reference index theorem, never from GW algebra.

Per-mode source of `reference_anomaly_free`:
* `directFlavoredOverlap` — index theorem for the flavored-overlap kernel
  (single-flavor naive/minimally-doubled overlap, Creutz/Kimura/Misumi).
* `abstractBlock` — the block reference *posits* an anomaly-free light sector
  (C172); the field is an assumption flagged for later replacement.
* `domainWall` — boundary-mode index from the 5D bulk + residual-mass control.

---

## 3. Locality / control contract (constraint #2)

`LocalityControlCertificate L` over `L : LocalityData`
(`coeff : ℕ → ℝ`, `admissibility admissibilityCrit : ℝ`):

| field | meaning | discharged by |
|---|---|---|
| `coeff_nonneg` | shell bounds nonnegative | construction |
| `shells_summable : Summable L.coeff` | path-shell weights summable | C156 path-shell summability |
| `admissible : admissibility < admissibilityCrit` | inside the admissibility window | 2203.06116 staggered-overlap locality |

Transfers: `total_weight_finite` (finite total weight) and `tail_vanishes`
(far-field shell weight → 0).

**Boundary proved:** `sign_alone_insufficient` — a kernel can have a well-defined
±1 sign at every shell yet have non-summable weights. So locality must come from
summability **or** admissibility, never from the existence of a sign function.

Two interchangeable routes are exposed so the import does not over-commit:
* **C156 route** — supply `shells_summable` directly (e.g. exponential decay).
* **Admissibility route** — supply `admissible` and cite the
  staggered/overlap locality theorem under admissibility.

---

## 4. Determinant-line / ghost control (constraint #3)

`DetGhostControlCertificate G` over `G : DetGhostData`
(`detLineWinding : ℤ`, `ghostMass2 : ℝ`):

| field | meaning |
|---|---|
| `det_line_trivial : detLineWinding = 0` | determinant line globally trivial ⇒ measure well defined |
| `no_ghost_zero : 0 < ghostMass2` | no ghost pole on the physical sheet |

These are first-class fields precisely so the determinant-line and ghost-zero
issues are **not hidden** (constraint #3). They are *not* implied by anomaly or
locality data and must be discharged separately per mode.

---

## 5. Sub-gap homotopy certificate (interface to C164/C170)

`SubgapCertificate H` over `H : HomotopyData` (`normDiff refGap : ℝ`):
`gap_pos : 0 < refGap`, `subgap : normDiff < refGap`. Transfer
`uniform_gap : 0 < refGap − normDiff` (no zero crossing along the straight line).
This is the typed handoff from C170's `SubgapHomotopyBound`.

---

## 6. Exact hypotheses to check before importing

**Before importing anomaly/index** (all three required, none optional):
1. `index_transported` — sector signatures matched (C154) and stable along the homotopy.
2. `reference_anomaly_free` — reference index theorem applies to the chosen `RefKind`.
3. `anomaly_transported` — `SubgapCertificate` holds (no crossing ⇒ invariance).

**Before importing locality** (route A or route B, plus nonnegativity):
4. `coeff_nonneg`.
5a. `shells_summable` (C156 route), **or**
5b. `admissible` with a cited staggered/overlap-under-admissibility theorem.

**Always, regardless of import:**
6. `det_line_trivial` and `no_ghost_zero` (else the measure / spectrum claims are void).

---

## 7. Lean / API design

File `RequestProject/C171.lean`, namespace `GateC1.C171`.

Data: `RefKind`, `AnomalyImportData`, `LocalityData`, `DetGhostData`,
`HomotopyData`.

Certificates (Prop): `AnomalyIndexCertificate`, `LocalityControlCertificate`,
`DetGhostControlCertificate`, `SubgapCertificate`.

Bundle: `ReferenceImportContract`; precondition predicate
`GateC1_NU_ImportValid`.

Theorem dependency graph:
```text
AnomalyIndexCertificate.ne_anomaly_free ─┐
LocalityControlCertificate.shells_summable ─┤
DetGhostControlCertificate.{det_line_trivial,no_ghost_zero} ─┼─► reference_import_valid
SubgapCertificate.uniform_gap ──────────────┘                     (⇒ GateC1_NU_ImportValid)

gw_alone_insufficient        -- proves the §2 claim boundary
sign_alone_insufficient      -- proves the §3 claim boundary
```

`reference_import_valid` is the single export C159 calls; it returns *only* the
import preconditions, nothing about gauge dynamics.

---

## 8. Literature mapping (motivation only; never load-bearing)

| reference | used as motivation for | enters a theorem? |
|---|---|---|
| Creutz/Kimura/Misumi 1011.0761, 1110.2482 | flavored mass / single-flavor naive overlap ⇒ `reference_anomaly_free` for `directFlavoredOverlap` | only via the field, not as an axiom |
| Adams 1008.2833 | staggered-overlap flavored mass / taste splitting ⇒ level-resolving `W_branch` | no |
| Chreim/Hoelbling/Zielinski 2203.06116 | staggered-overlap locality under admissibility ⇒ `admissible` route | only via the field |

No theorem depends on the literature except through an explicit reference
hypothesis carried as certificate data, per the constraint.

---

## 9. Open checks (per mode)

* **directFlavoredOverlap:** verify the index theorem actually applies to the
  chosen single-flavor kernel; verify `shells_summable`/`admissible` for that
  kernel; confirm `gwResidual` regime and `det_line_trivial`.
* **abstractBlock (C172):** `reference_anomaly_free` is *assumed*; flagged for
  replacement once a direct reference matures. Block model proves one-sector
  content + bad-sector gap only.
* **domainWall:** residual-mass / `ghostMass2` control; boundary-index
  computation; locality of the 4D effective operator.
* **all modes:** the `anomaly_transported` field relies on the C170 sub-gap
  bound `‖H_ne − H_ref‖ < γ`; if that bound is too large, retune `W_branch`
  (C170 failure modes) — do not weaken the certificate.

---

## 10. Claim-boundary checklist (forbidden without certificates)

| claim | required certificate | proved-independent shortcut |
|---|---|---|
| anomaly cancellation / index match | `AnomalyIndexCertificate` | `gw_alone_insufficient` (GW ⇏ anomaly-free) |
| locality / far-field control | `LocalityControlCertificate` | `sign_alone_insufficient` (sign ⇏ summable) |
| well-defined fermion measure | `det_line_trivial` | — |
| no propagating ghost | `no_ghost_zero` | — |
| uniformly gapped homotopy | `SubgapCertificate` | — |
| **`GateC1_NU` closed** | **still forbidden** | gauge dynamics, determinant line as a measure, SM internality (C165) remain external |
