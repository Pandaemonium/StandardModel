# Gate C1 — Domain-Wall / Boundary Import Architecture (with CKM texture)

**Program:** Null-edge / NullStrand, Gate C1.
**Status of this document:** an *architecture + certificate stack*, not a closure
claim. Domain-wall is the **fallback / cross-check** to the recommended
Wilson/Neuberger overlap reference. Nothing here asserts that domain-wall closes
C1 automatically; the closure is exactly the conjunction of the certificates in
§3, all of which must be discharged for a concrete construction.

The formal counterpart of §3 (certificate stack) and §5 (import theorem/API) is
`RequestProject/GateC1DomainWall.lean`, which builds with no proof placeholders and no extra
kernel dependencies. This file is the prose for items 1, 2, 4, 6.

---

## 1. Concrete schematic: 5D domain-wall / bulk operator → 4D boundary operator

We want a 5D bulk Dirac operator on a slab whose **boundary effective operator**
matches (or, at finite separation, approximates) the Neuberger overlap operator
`D_ov`.

**Geometry.** A 4D lattice `×` a finite 5th ("wall-separation") direction of
length `Lz` with a domain wall at `s = 0` and an anti-wall (mirror) at `s = Lz`.

**Bulk operator (schematic).**
```
D5(x,s; y,t) = δ_st · D_W(x,y)            (4D Wilson kernel on each slice)
             + (P_- δ_{t,s+1} + P_+ δ_{t,s-1})         (5D hopping, chiral proj.)
             - M(s) · δ_st · δ_xy          (wall mass profile, sign flip at wall)
```
with `P_± = (1 ± γ5)/2`, `D_W` the Wilson operator at negative domain-wall height
`-M0 ∈ (-2,0)` (one species), and `M(s)` the **wall mass profile** changing sign
across `s = 0`. A Pauli–Villars / ghost slab subtracts the heavy bulk
determinant.

**Boundary effective operator.** Integrating out the bulk leaves a 4D operator on
the wall zero-mode:
```
D_eff = (1/Lz-controlled) projection of  D5  onto the s=0 boundary mode.
```
In the limit `Lz → ∞`, `D_eff → D_bulkBoundary`, and the standard identity is
```
D_bulkBoundary  =  D_ov  (Neuberger),     up to the matching/locality defect κ,
```
i.e. domain-wall at infinite wall separation reproduces overlap. At finite `Lz`
the difference is the **residual mass** `m_res(Lz) → 0`:
```
‖D_eff − D_bulkBoundary‖ ≤ m_res(Lz)        (= certificate C1.a).
```

In the Lean model these four objects are exactly the fields
`D_eff`, `D_bulkBoundary` (DomainWallData) and `D_ov` (OverlapReference), and the
import bound is their triangle composition
`‖D_eff − D_ov‖ ≤ ε + κ` (`ε` = residual-mass tolerance, `κ` = matching defect).

---

## 2. Where the CKM texture should live

CKM is a **finite texture/table** (an approximately-unitary `3×3` matrix), *not*
a literal naive lattice operator. The four candidate homes (Lean:
`CKMPlacement`):

| Placement | Verdict | Reason |
|---|---|---|
| **Boundary flavor coupling** | ✅ **chosen** | Texture multiplies the 4D boundary zero-mode coupling only. It is a flavor rotation on physical chiral modes, decoupled from the bulk regulator and from the gauge sector; near-unitarity and gauge-internality are stated directly on it. |
| Wall mass profile `M(s)` | ✗ | Makes `m_res`, the mirror gap, and the index all *flavor-dependent*; couples texture to the very mechanism that must stay flavor-blind. Hard to keep determinant/ghost control uniform across generations. |
| Internal branch (replica/strand) factor | ✗ | Risks tying flavor to the NullStrand branch structure; flavor mixing then becomes a branch-mixing channel — exactly failure mode 3. |
| Transfer-matrix sector label | ✗ | Makes CKM a label on transfer-matrix sectors, entangling flavor with locality/transfer-matrix control (C1.f) and with mirror-sector bookkeeping. |

**Architecture decision:** CKM lives in the **boundary flavor coupling**
(`DomainWallData.placement = boundaryFlavorCoupling`). It enters *after* the
chiral boundary mode is established, as a unitary-up-to-`δuc` rotation that
**commutes with every gauge generator's flavor representation** (Lean:
`sm_internality : ∀ a, Commute (gaugeRep a) ckm`). This keeps flavor internal to
the SM matter sector.

---

## 3. Required certificate stack (formal: `C1Certificates`)

Closure of C1 via domain-wall is *defined* to be the conjunction below. Each is a
named field of the Lean structure `GateC1_NU.C1Certificates`.

| # | Certificate | Lean field | Content |
|---|---|---|---|
| C1.a | **Residual mass bound** | `residual_mass_bound` | `‖D_eff − D_bulkBoundary‖ ≤ m_res ≤ ε` (GW-relation residual → 0). |
| C1.b | **Boundary index / inflow theorem** | `index_inflow` | `boundaryIndex = ref.index` (APS / anomaly-inflow: boundary mode count = bulk inflow = reference index). |
| C1.c | **True mirror gap** | `mirror_gap` | `0 < δm ≤ mirrorGap`: mirror (anti-wall) mode genuinely gapped, so chirality is not doubled. |
| C1.d | **Determinant / ghost control** | `det_ghost_control` | regulator gap `> 0`: bulk inverse bounded, no PV/ghost zero-mode. |
| C1.e | **SM internality** | `sm_internality` | `∀ a, Commute (gaugeRep a) ckm`: texture gauge-decoupled, flavor internal. |
| C1.f | **Locality / control** | `locality_control` | `‖D_bulkBoundary − D_ov‖ ≤ κ`: boundary operator local up to transfer-matrix matching defect. |
| C1.g | **CKM finite-texture near-unitarity** | `ckm_texture_unitary` | `ckmDefect (= ‖U†U − 1‖) ≤ δuc`. |

No single certificate is "for free"; in particular C1.a, C1.c, C1.f are the
quantitative analytic obligations, C1.b is the topological obligation, C1.e/C1.g
are the flavor obligations, C1.d is the regulator obligation.

---

## 4. Comparison with Wilson/Neuberger overlap

**Easier with domain-wall:**
- **Locality (C1.f):** the boundary operator is built from a manifestly *local*
  5D nearest-neighbour kernel; locality is structural rather than requiring the
  Neuberger sign-function / spectral-gap locality estimate.
- **Determinant / ghost control (C1.d):** the bulk + Pauli–Villars determinant is
  a local 5D determinant; no `sign(H_W)` non-analyticity to control.
- **Practical index counting (C1.b):** boundary mode count is read off the wall;
  anomaly inflow is geometric.

**Harder with domain-wall:**
- **Residual mass (C1.a):** overlap satisfies Ginsparg–Wilson *exactly*
  (`m_res = 0` by construction, i.e. `ε = 0`); domain-wall only achieves it as
  `Lz → ∞`, so C1.a is a genuine, separate quantitative certificate that overlap
  does not need.
- **True mirror gap (C1.c):** overlap has a single chirality built in; domain-wall
  must *prove* the mirror is gapped and stays decoupled — an extra obligation with
  no overlap analogue.
- **Boundary-mode count (C1.c/C1.b joint):** the doubling/mirror bookkeeping is an
  extra place to make an off-by-one error (failure mode 4).

Net: domain-wall trades the (hard) Neuberger locality/analyticity certificates for
the (new) residual-mass + mirror-gap certificates. In the formal API this is
visible as the explicit `ε`: overlap is the `ε = 0` specialisation
(`domainWall_exact`), domain-wall is the `ε > 0` general case.

---

## 5. Theorem / API for import into `GateC1_NU`

Formal statement (see `GateC1DomainWall.lean`):

```lean
theorem domainWall_import
    {E : Type u} [NormedAddCommGroup E] {GaugeGen : Type v}
    {ref : OverlapReference E} {dw : DomainWallData E}
    {gaugeRep : GaugeGen → CKMTexture} {ε δm δuc κ : ℝ}
    (cert : C1Certificates ref dw gaugeRep ε δm δuc κ) :
    C1Import ref dw gaugeRep ε δuc κ
```

`C1Import` packages the import guarantees: `operator_close : ‖D_eff − D_ov‖ ≤ ε+κ`,
`index_match`, `mirror_gapped`, `texture_internal`, `texture_unitary`. The proof
is the operator triangle inequality composing the residual-mass and locality
certificates. The corollary `domainWall_exact` shows the `ε = κ = 0` limit gives
`D_eff = D_ov` exactly (overlap recovered).

This is the import combinator: it is *conditional* on the certificate stack and
exhibits the explicit error budget, rather than asserting closure.

---

## 6. Failure modes (and where each is caught)

| Failure mode | Symptom | Caught by |
|---|---|---|
| **Residual mass not small** | `m_res(Lz)` does not fall below `ε`; `D_eff` drifts from overlap | C1.a `residual_mass_bound` fails → `operator_close` budget blows up. |
| **Mirror not gapped** | second chirality survives; effective theory is vector-like / doubled | C1.c `mirror_gap` (`δm ≤ mirrorGap`) fails; also surfaces as C1.b index mismatch. |
| **CKM coupled to gauge (branch-mixing)** | texture installed in wall-mass / branch / sector channel; flavor leaks into gauge | C1.e `sm_internality` (`Commute (gaugeRep a) ckm`) fails — this is precisely the negation enforced by choosing `boundaryFlavorCoupling`. |
| **Boundary mode-count mismatch** | doubling / off-by-one in wall vs anti-wall modes | C1.b `index_inflow` (`boundaryIndex = ref.index`) fails. |
| (related) **Ghost zero-mode** | PV/regulator gap closes | C1.d `det_ghost_control` fails. |
| (related) **Non-unitary texture** | `U†U` drifts from `1` beyond `δuc` | C1.g `ckm_texture_unitary` fails. |

Each failure mode maps to a specific certificate field; none is hidden inside the
combinator. That is the sense in which the certificate stack is *explicit* and
domain-wall does **not** close C1 automatically.
