# Gate C C1 release-datum and domain-wall / projected-overlap audit (C105)

Date: 2026-06-27.
Dependency class: C1 strategy/audit job (report only; no new Lean artifact forced).

Context packs:

```text
AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md
AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md
```

## 0. Scope and posture (read first)

This audit fixes the **C1 release datum** and ranks the candidate C1 routes. It does
**not** announce any release. The standing Gate C posture is unchanged:

```text
C0 scalar Wilson gap : promising / bankable theorem (external species health only).
Raw full-bare-overlap : UNSAFE unless a mass-window theorem is proved.
C1 release           : requires the release datum below plus branch-line /
                       projector / domain-wall data, all clauses discharged.
```

Two hard rules govern everything that follows:

1. **C0 is not C1.** An anti-Hermitian symbol plus a positive scalar Wilson mass
   gaps non-origin torus species (`‖(A + mI)v‖ ≥ m‖v‖`, the RA-Wilson accretive
   gap, already banked in `PhysicsSM.Draft.NullEdgeRAWilsonGap` /
   `NullEdgeGateC0SpeciesHealth`). This is species health only. It does **not**
   polarize the balanced origin kernel and does **not** discharge a single
   chirality. Nothing in this report may be cited as a C1 or full-Gate-C release.

2. **No gauge-charged branch may be removed by a propagator zero alone**
   (Golterman–Shamir, arXiv:2311.12790, arXiv:2505.20436). Removal of an unwanted
   gauge-charged branch must come from a *true inverse-propagator mass gap* or
   from an explicit composite/interpolating-field theorem. Propagator-zero mirror
   removal for a gauge-charged branch is **disallowed** in this audit unless a
   dedicated ghost-safety theorem is supplied for that exact branch.

The relevant facts already proved in-repo and reused below:

- C21 (`NullEdgeActualCliffordSymbol`, reproduced in `NullEdgeProjectedBranchChirality`):
  the bare tetrahedral Clifford symbol has a 2-dimensional, chirality-balanced
  kernel on each null branch — no single bare chirality per branch.
- C88 (`NullEdgeTasteOnlyOriginNoGo`): a taste-only / scalar-on-origin involution
  cannot polarize the balanced origin kernel.
- C81 (`NullEdgeKreinOverlapSignTrap`): `J`-self-adjointness alone does **not**
  give the real-spectrum / gapped sign-function data an overlap/GW flow needs.
- C47/C48 (`NullEdgeGateCGhostZeroSafety`): six-way `ZeroKind` classification,
  `IsFatalGhost`, `PostGaugeGhostSafe`, `KreinPositivePhysicalSector`.
- C59 (`NullEdgeProjectedGateCRelease`): the seven-clause projected release
  predicate `ProjectedGateCRelease` and its negative guardrails.
- C95 (`NullEdgeAntiVectorializationGuardrail`): overlap/GW + regulator health +
  modified chirality is still vectorlike (net index 0) without an explicit
  anti-vectorlike / nonzero-index witness.

---

## 1. Final C1 release datum schema

A Gate C1 release is a property of a **record**, not of a bare corrected symbol.
The release datum is

```text
ReleaseData = (D_gap, Pi_phys, D_phys, Gamma_lat, KreinData, GhostData, IndexData, ModuliData)
```

### 1.1 Required fields

| Field | Meaning | Existing Lean anchor |
|---|---|---|
| `D_gap` | C0 species-gapped external symbol (anti-Herm. + positive scalar Wilson `W(q) ≥ 0`, `W>0` off origin). | `NullEdgeRAWilsonGap`, `NullEdgeGateC0SpeciesHealth.RAWilsonC0Data` |
| `Pi_phys` | Physical-sector projector: local or controlled quasi-local, gauge-covariant, **non-scalar on the origin kernel**. | `NullEdgeGaugeCovariantBranchProjectors.DressedBranchProjector`; target `Pi_br` from C104 |
| `D_phys` | The retained physical operator after projection / splitting / domain-wall reduction. | `NullEdgeProjectedGateCRelease.ProjData` |
| `Gamma_lat` | The lattice chirality grading actually used (GW `γ̂₅`, not naive `γ₅`). | `NullEdgeProjectedBranchChirality` (`g5` line); Lüscher hep-lat/9802011 |
| `KreinData` | Fundamental symmetry `J`, branch signatures, retained-sector orientation lock. | `NullEdgeBranchKreinSignatures`, `NullEdgeKreinPositiveReleaseCriterion`, `NullEdgeKreinLockOrigin` |
| `GhostData` | Per-zero `ZeroKind` classification + post-gauge contract. | `NullEdgeGateCGhostZeroSafety.ZeroDatum`, `PostGaugeGhostSafe` |
| `IndexData` | Flavored/spectral-flow index + anti-vectorlike witness. | `NullEdgeFlavoredChirality`, `NullEdgeFlavoredSpectralFlowAPI`, `NullEdgeAntiVectorializationGuardrail` |
| `ModuliData` | Ledger of every species-splitting / counterterm coefficient and its moduli status. | `NullEdgeSymmetryForcedSpeciesSplit`, `NullEdgeForbiddenCountertermCodim`, `NullEdgeRegulatorLegalGateCRelease` |

### 1.2 Required clauses (all mandatory; conjunction = release)

These mirror, and should be discharged through, the seven clauses of
`NullEdgeProjectedGateCRelease.ProjectedGateCRelease` plus the post-gauge contract:

```text
(R1) C0SpeciesGap      : D_gap has no non-origin torus kernel (W>0 off origin).      [C0, bankable]
(R2) ProjectorLegal    : Pi_phys is local or controlled quasi-local AND gauge-covariant
                         AND non-scalar on the balanced origin kernel.
(R3) OriginOneWeylLine : the projected origin kernel is one-dimensional and Gamma_lat-pure
                         (selects exactly one Weyl line; defeats the C21/C88 balance).
(R4) MirrorGapped      : every mirror / unwanted branch is either absent or removed by a
                         TRUE inverse-propagator mass gap — NOT by a gauge-charged propagator zero.
(R5) GhostSafe         : every propagator zero is classified (ZeroKind) and none is a
                         fatalGhostZero; gauge-charged zeros carry a composite/interpolating-field
                         removal theorem; PostGaugeGhostSafe holds.
(R6) KreinPositive     : retained physical sector is J-positive AND the Krein/sign orientation
                         is locked as an explicit convention (K3), with real-spectrum data
                         established independently of J-self-adjointness (C81 trap avoided).
(R7) ContinuumWeyl     : D_phys reduces to a continuum Weyl symbol on the retained line.
(R8) IndexNonzero      : flavored / spectral-flow index is nonzero AND an anti-vectorlike
                         witness rules out a vectorlike pairing (C95).
(R9) AnomalyAccounted  : gauge/gravitational anomaly of the retained chiral content is computed
                         and matches the intended Standard-Model assignment.
(R10) ModuliLedgered   : every splitting/counterterm coefficient is symmetry-forced or recorded
                         as a free modulus.
```

Release predicate: `C1Release(ReleaseData) := R1 ∧ R2 ∧ … ∧ R10`.

Guardrails that must remain provable (already true in-repo, do not regress):
`R8` alone does not give `R5` (`index_not_sufficient`), `R6` alone does not give
`R3` (`kreinPositive_not_chirality`), and `R3` alone does not give `R5`
(`chirality_not_ghostSafe`). These are the standing negative theorems of C59.

---

## 2. Route comparison

Five candidate C1 routes, scored against the clauses of §1.2.

| Route | Mechanism for R3 (one Weyl line) | Mechanism for R4 (mirror) | Native to null-edge? | Verdict |
|---|---|---|---|---|
| **A. Raw overlap on full `D_+`** | sign(`Γ_s X_ρ`), `X_ρ = D_+ + rW·I − ρ·I` | overlap projection | yes (no extra data) | **HAZARD.** Singular-crossing risk; needs a mass-window theorem first. |
| **B. Projected overlap after `Pi_br`** | overlap on the `Pi_br`-retained subspace | branch split before overlap | yes, *if* `Pi_br` exists locally | **Preferred** if C104 yields a local/gauge-safe `Pi_br`. |
| **C. Spinor-line / matrix-valued Wilson** | non-scalar Wilson term that lifts one origin line | matrix Wilson mass | yes | Viable; must beat the C88 scalar no-go by being genuinely non-scalar on the origin kernel. |
| **D. Domain-wall / boundary construction** | chiral zero-mode localized on a wall | bulk mass / opposite wall | imported, not native | Standard and robust, but watch the single-wall anti-vectorialization trap. |
| **E. Controlled quasi-local projector** | quasi-local `Pi_phys` with decay bound | quasi-local split | fallback | Use only if no strictly local `Pi_br` exists (C104 no-go fork). |

### 2.1 Route A — raw overlap on full `D_+`

The shifted Hermitian kernel `H_ρ(q) = Γ_s X_ρ(q)`, `X_ρ(q) = D_+(q) + rW(q)I − ρI`,
must be invertible along the whole zero locus. If an unwanted branch germ obeys
`q(t)→0`, `D_+(q(t))v(t)=0`, and `rW(q(t))=ρ`, then `X_ρ(q(t))v(t)=0` and the sign
kernel is singular (the C102 singular-crossing mechanism). Because C0 only gaps
*non-origin* zeros and the dangerous germ approaches the origin where `W→0`, the
C0 gap does not protect this route. **Not a default C1 route.**

### 2.2 Route B — projected overlap after `Pi_br`

Split branches first with the C104 classifier `T_br` / `Pi_br = (1+T_br)/2`, then run
overlap only on the retained subspace. This removes the balanced second line *before*
the sign function is formed, so the C102 crossing on the discarded germ is no longer in
the overlap domain. This is the most null-edge-native viable route, **conditional on
C104 producing a `Pi_br` that is (i) an involution/projector, (ii) non-scalar on the
origin kernel, (iii) gauge-covariant, and (iv) local or provably quasi-local.**

### 2.3 Route C — spinor-line / matrix-valued Wilson

Replace the scalar Wilson weight `W(q)I` by a **matrix-valued** mass `M(q)` that is
non-scalar on the balanced origin kernel. C88/C103 show a scalar-on-origin term that
vanishes at the origin cannot polarize the kernel; a nonzero scalar removes the
intended mode. So the minimal escape hatch is precisely a term whose *line structure*
at the origin differs between the two Weyl lines. Viable, but the lifting coefficient
is a modulus unless symmetry-forced (`NullEdgeSymmetryForcedSpeciesSplit`).

### 2.4 Route D — domain-wall / boundary construction

Localize one chirality on a wall (Kaplan arXiv:0912.2560 review). Robust and
well-understood, but **not native** (needs an extra dimension / boundary). The critical
warning: arXiv:2402.09774 shows a *single* domain wall with nontrivial gauge/topological
background can recover an opposite-chirality zero mode at a singularity, making the
effective theory vectorlike rather than chiral. Any single-wall null-edge construction
must discharge the C95 anti-vectorialization clause `R8` explicitly.

### 2.5 Route E — controlled quasi-local projector

If C104 returns a *no-go* for a strictly local gauge-safe `Pi_br`, fall back to a
quasi-local projector with an explicit exponential/polynomial decay bound. Locality in
`R2` is then replaced by a controlled-quasi-locality certificate. This is the program's
designated escape if the native local classifier cannot exist.

---

## 3. "Must prove before use" list per route

```text
Route A (raw overlap on full D_+):
  A1. Mass-window theorem: ∃ a choice of (r, ρ) and a neighborhood of the origin such
      that rW(q) − ρ never vanishes along ANY determinant-zero branch germ reaching
      the origin (rules out the C102 singular crossing). UNTIL PROVED, route A is barred.
  A2. Real-spectrum / gap of H_ρ on the whole torus (NOT merely J-self-adjointness; C81).
  A3. Anti-vectorlike index witness (C95) for the resulting overlap operator.

Route B (projected overlap after Pi_br):
  B1. Existence of Pi_br: involution/projector, non-scalar on origin kernel,
      separates branch GERMS not taste labels (C104 deliverable).
  B2. Gauge covariance of Pi_br (link-dressed), reusing DressedBranchProjector.
  B3. Locality or quasi-locality bound for Pi_br.
  B4. After projection: ProjectedKernelOneDim + ProjectedChiralityAligned (C59 R3),
      then A2/A3 restricted to the retained subspace.
  B5. Mirror branch removed by a true inverse-propagator gap (R4), NOT a gauge-charged
      propagator zero.

Route C (spinor-line / matrix-valued Wilson):
  C1. Non-scalarity theorem: M(q) acts differently on the two origin Weyl lines
      (defeats C88/C103 scalar no-go).
  C2. One-Weyl-line selection at the origin (R3).
  C3. Hermiticity/positivity of the modified kernel (no new fatal zeros; R5).
  C4. Moduli ledger entry for the lifting coefficient (R10), ideally symmetry-forced.

Route D (domain-wall / boundary):
  D1. Localized single-chirality zero mode on the wall (free theory).
  D2. Anti-vectorialization theorem: with the intended gauge/topological background no
      opposite-chirality mode reappears (directly addresses arXiv:2402.09774); R8.
  D3. Bulk gap / second-wall accounting for the mirror (R4).
  D4. Locality of the boundary construction (R2) and anomaly inflow accounting (R9).

Route E (controlled quasi-local projector):
  E1. Quasi-locality certificate: explicit decay bound for Pi_phys.
  E2. All of B1, B4, B5 with "local" replaced by the E1 bound.
```

A clause shared by **every** route: any gauge-charged branch slated for removal needs
either a true inverse-propagator gap or a composite/interpolating-field removal theorem
(`NullEdgeCompositeZeroEscape`). Propagator-zero removal of a gauge-charged branch is
never accepted by default.

---

## 4. Ghost / anomaly / Krein / locality audit table

For each route, the status of the four hardest cross-cutting obligations. Legend:
`OPEN` = must be proved; `HAZARD` = known specific failure mode; `REUSE` = existing
in-repo machinery applies; `N/A` = not introduced by this route.

| Route | Ghost-zero (R5) | Anomaly (R9) | Krein / sign (R6) | Locality (R2) |
|---|---|---|---|---|
| A. raw overlap | HAZARD — origin-reaching germ crossing makes sign kernel singular; gauge-charged zeros uncontrolled. REUSE `ZeroKind`/`PostGaugeGhostSafe`. | OPEN | HAZARD — C81: `J`-self-adjoint ≠ real spectrum; needs independent gap proof. | likely OK (overlap is quasi-local) but R3 fails first. |
| B. projected overlap | OPEN but tractable — classify zeros on retained subspace; REUSE C47/C48 + `NullEdgeCompositeZeroEscape`. | OPEN | OPEN — lock retained sector (K3 `NullEdgeKreinLockOrigin`); REUSE `NullEdgeKreinPositiveReleaseCriterion`. | OPEN — depends on `Pi_br` locality (C104). |
| C. matrix Wilson | OPEN — verify M(q) adds no fatal zero; REUSE `ZeroKind`. | OPEN | REUSE — Hermitian matrix mass keeps real spectrum if PSD. | OK if M(q) is a finite-range stencil. |
| D. domain-wall | REUSE — bulk gap controls zeros; but single-wall HAZARD (arXiv:2402.09774). | OPEN — anomaly inflow must match retained chirality. | REUSE — standard DW positivity. | N/A native; extra dimension. |
| E. quasi-local proj. | OPEN — same as B with decay-bounded projector. | OPEN | OPEN — as B. | HAZARD — must certify decay; strict locality lost by construction. |

Cross-cutting non-negotiables (hold for all rows):

- A computed nonzero index never substitutes for ghost safety
  (`index_not_sufficient`, `NullEdgeAntiVectorializationGuardrail`).
- Krein positivity never substitutes for chirality (`kreinPositive_not_chirality`).
- Chirality never substitutes for ghost safety (`chirality_not_ghostSafe`).
- The retained branch labels are an orientation **convention** consumable by Gate C
  but **not** a prediction (K3); Gate F must not read them as physics.

---

## 5. Recommendation: next two Lean theorem targets

Ranked to maximize information per wave. Both are conditional/no-go-tolerant, so neither
can produce a false release.

### Target 1 (highest priority) — Route A mass-window **dichotomy** theorem

File: `PhysicsSM/Draft/NullEdgeOverlapMassWindow.lean`.
Prove the clean fork that decides whether raw overlap (Route A) is even admissible:

```text
Either (WINDOW)  ∃ (r, ρ) and origin neighborhood U with
                 ∀ q ∈ U, ∀ v ≠ 0, D_+(q) v = 0 → r·W(q) − ρ ≠ 0
                 (so X_ρ is nonsingular along the zero locus in U; Route A admissible),
or     (CROSSING) the C102 singular-crossing germ exists in every such U
                 (so Route A is barred and the program must use Route B/C/D/E).
```

This converts the standing "HAZARD" verdict on Route A into a theorem and, in the
CROSSING branch, formally justifies prioritizing `Pi_br`. It reuses the C102
singular-crossing algebra and the C0 `W(q)=Σ(1−cos q_a)` weight. Keep it finite/germ-
level if analytic paths are heavy.

### Target 2 — Route B projected-overlap release **assembly** theorem

File: `PhysicsSM/Draft/NullEdgeProjectedOverlapRelease.lean`.
Assuming the C104 `Pi_br` interface (`PiBrProjector`, `TbrNonScalarOnOriginKernel`,
`TbrSeparatesBranchGerms`, gauge-covariance), prove:

```text
PiBr legal (involution + non-scalar on origin kernel + germ-separating + gauge-covariant + local)
  ∧ overlap-on-retained gives ProjectedKernelOneDim ∧ ProjectedChiralityAligned
  ∧ MirrorGapped by true inverse-propagator gap
  ∧ GhostSafe (PostGaugeGhostSafe) ∧ KreinPositive (locked) ∧ IndexNonzero (anti-vectorlike)
  →  ProjectedGateCRelease (C59 predicate).
```

i.e. show Route B *assembles* the existing seven-clause `ProjectedGateCRelease` from
the `Pi_br` data, so the only remaining open inputs are the concrete `Pi_br`
construction (C104) and its locality bound. This makes Route B's residual obligation
exactly one object — the local gauge-safe `Pi_br` — and nothing else.

Sequencing note: Target 1 should run first; its CROSSING branch is the formal
green-light to invest the next wave in C104 `Pi_br` + Target 2, while its WINDOW branch
would reopen Route A. Neither target asserts release; both are gated by clauses that
remain open.

---

## 6. Acceptance check against the C105 brief

- Final C1 release datum schema with required fields and clauses — §1. ✔
- Route comparison over the five named routes — §2. ✔
- "Must prove before use" list per route — §3. ✔
- Ghost / anomaly / Krein / locality audit table — §4. ✔
- Recommendation for the next two Lean theorem targets — §5. ✔
- Does not advertise C0 as C1 or as full Gate C release — §0, R1 flagged "C0, bankable",
  every route left with OPEN clauses. ✔
- Treats propagator-zero mirror removal as disallowed for gauge-charged branches absent
  an explicit ghost-safety theorem — §0 rule 2, R4/R5, §3 shared clause, §4 non-negotiables. ✔
- Specific enough to drive the next wave without a new strategy pass — §5 names files,
  predicates, and the run order. ✔

No Lean artifact is produced by this job: the deliverable is this audit, and the
machinery it references (C0 gap, `ZeroKind`/`PostGaugeGhostSafe`, `ProjectedGateCRelease`,
Krein lock, anti-vectorialization guardrail) already exists in `PhysicsSM/Draft/`. The
two recommended targets in §5 are the next files to create.
