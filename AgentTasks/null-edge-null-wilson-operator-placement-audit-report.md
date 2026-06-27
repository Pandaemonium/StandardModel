# C71 — Null-Wilson operator-placement audit (report)

Task: `AgentTasks/null-edge-wave17-c71-null-wilson-operator-placement-audit-aristotle-2026-06-27.md`
Context pack: `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`
Decision being audited: D13 in `AgentTasks/null-edge-decision-log-2026-06-27.md`.

Companion Lean helper (sorry-free, builds): `PhysicsSM/Draft/NullEdgeNullWilsonPlacement.lean`
(registered in `PhysicsSMDraft.lean`).

> Verify every quoted convention against the live repo before relying on it. All
> "live" references below were read directly from the snapshot; the paper claims
> (Golterman–Shamir, BCK, Kähler–Dirac) are from the context pack and should be
> reverified at use.

---

## 0. One-paragraph decision

`R_W` should enter as a **scalar Wilson kernel placed in the `Γ_s`-even,
zero-order ("mass/regulator") slot** of the Gate-A operator, i.e.

```text
D_phys = i D_N + Γ_s Φ_H + Γ_s R_W ,
```

with `R_W` required to be **`Γ_s`-even** (`[Γ_s, R_W] = 0`), **`χ_E`-even** (a
scalar in the internal carrier, `[χ_E, R_W] = 0`), **Clifford-commuting**
(`[C_a, R_W] = 0`), and **momentum-dependent** (built from the null shifts/
transports `T_a`, vanishing only at the physical origin). It shares the
*spacetime* grading of `Φ_H` (so the Gate-A square keeps the healthy `+R_W²`
sign), but it must be **tracked as a separate `χ_E`-even branch-control
counterterm, never merged into `Φ_H`** (which is `χ_E`-odd). The plain object
`D_NW = i D_N + Γ_s R_W` is therefore *correct as the regulator's contribution*,
under the stated grading hypotheses; it is **not** an overlap/domain-wall kernel
and **not** by itself a projected-sector regulator — those are heavier
constructions used only if/where the four answers below force them. Because a
scalar Wilson kernel breaks ordinary `Γ_s` chirality by construction, the Gate C
release index must be the **flavored/projected** chirality already built in the
repo (`Γ_f = Γ_s·T`, `NullEdgeProjectedBranchChirality`), with overlap/domain-
wall held in reserve as the fallback only if exact Ginsparg–Wilson lattice
chirality is later demanded.

---

## 1. Q1 — Is `D_NW = i D_N + Γ_s R_W` the correct object?

**Answer: yes, as the regulator contribution — a scalar Wilson kernel in the
`Γ_s`-even slot — provided the grading hypotheses of §2 hold. Not overlap/
domain-wall, and not (by itself) a projected-sector regulator.**

Four candidate placements, judged against the live Gate-A square
(`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean`,
`super_dirac_square_single`) and the C70 positivity target
(`W(q) = Σ_a (1 - cos q_a)`):

1. **`Γ_s R_W` with `R_W` `Γ_s`-even (scalar Wilson kernel) — CHOSEN.**
   This is structurally identical to the existing physical mass block `Γ_s Φ_H`.
   The Gate-A square gives the healthy `+R_W²`:
   `D² = -D_N² + R_W² - i Γ_s C (∇R_W - R_W ∇)` (live theorem
   `super_dirac_square_single`, specialised in the helper as
   `NullWilsonPlacement.nullWilson_square_healthy`). The Wilson shape
   `R_W ∝ Σ_a (1 - cos q_a)` is `> 0` away from the origin (C70 target
   `wilson_positive_away_origin`), so every non-origin determinant zero (each
   doubler branch) receives a strictly positive `+R_W²` mass-square cost, while
   near `q = 0` it is `O(q²)` and irrelevant to the leading Dirac symbol. This
   is exactly the textbook Wilson mechanism realised in the null-edge algebra.

2. **Bare scalar Wilson kernel *without* the `Γ_s` factor (`D = i D_N + R_W`).**
   Rejected. A naked `R_W` that anticommutes with `Γ_s` would behave like a
   second kinetic term, not a mass; one that commutes would still not assemble
   into the audited `Γ_s Φ` mass-block bookkeeping. The repo's whole sign
   discipline (`docs/CONVENTIONS.md`, the M1/M2 audit) is stated for the
   `Γ_s Φ` slot, so the regulator must use that slot to inherit the audited
   `+Φ²` guarantee. Use `Γ_s R_W`, not `R_W`.

3. **Overlap / domain-wall (Ginsparg–Wilson) kernel.** Not needed for v3, held
   in reserve. An overlap kernel `D_ov = (1/a)(1 + γ₅ sign(H))` (or a 5-D
   domain-wall tower) buys *exact* lattice chiral symmetry
   (`{γ₅, D} = a D γ₅ D`) at the price of: non-locality of `sign(H)`, a much
   larger Lean surface (operator functional calculus, a spectral-gap hypothesis
   on the kernel `H`), and a different square identity than the audited
   `super_dirac_square_single`. The program does **not** currently need exact
   `Γ_s` chirality at finite spacing — it already releases a *flavored/projected*
   chirality index (C16/C19/C58). So overlap/DW is over-powered here. It becomes
   the correct move **only if** Q3's chiral-breaking is judged unacceptable for
   the target theorem (see §3).

4. **Projected-sector regulator (regulator defined only on the retained
   physical quotient).** This is a *complement* to placement 1, not an
   alternative. `R_W` lives on the full carrier (it must, in order to gap the
   doubler branches that the projection has not yet removed); the *physical
   sector* is then cut out by the branch projectors `P_ρ`
   (`NullEdgeProjectedBranchChirality.branchProj`,
   `NullEdgeProjectedGateCRelease.BranchProjectorsControlled`). Defining `R_W`
   only inside the projected sector would be circular: the projection presupposes
   the doublers are already controlled, which is precisely what `R_W` is there to
   do. So: **regulate on the full carrier (placement 1), then project.**

Conclusion: `D_NW = i D_N + Γ_s R_W` is the right object for the regulator term,
with the §2 grading; the full physical operator is
`D_phys = i D_N + Γ_s Φ_H + Γ_s R_W` followed by the branch projection.

---

## 2. Q2 — Grading hypotheses so the Gate-A sign is not corrupted

The Gate-A sign theorem `super_dirac_square_single` needs exactly the five
standing hypotheses (H1)–(H5) of `NullEdgeSuperDiracSignAudit`. Transcribed to
`R_W` (with `Im` the central `i`, `i² = -1`; `C = C_a`; `Nb = ∇_a`):

```text
(G1)  Γ_s² = 1
(G2)  {Γ_s, C_a} = 0          kinetic Clifford symbol stays Γ_s-ODD
(G3)  [Γ_s, ∇_a] = 0
(G4*) [Γ_s, R_W] = 0          R_W is Γ_s-EVEN     ← LOAD-BEARING
(G5*) [C_a, R_W] = 0          R_W is a scalar in spinor space
```

plus the centrality `[Im, ·] = 0`, `Im² = -1`.

**(G4\*) is the single non-negotiable constraint.** It is what makes the
regulator enter the square as `+R_W²` rather than the tachyonic `-R_W²`:

- `R_W` `Γ_s`-even ⇒ `D² = -D_N² + R_W² - i Γ_s C(∇R_W - R_W∇)`
  (helper `nullWilson_square_healthy`, from live `super_dirac_square_single`).
- `R_W` `Γ_s`-odd ⇒ `D² = -D_N² − R_W² − i Γ_s C(∇R_W − R_W∇)`
  (helper `nullWilson_square_tachyonic`, from live
  `super_dirac_square_single_odd`). A `Γ_s`-odd "Wilson term" would *deepen*
  the instability instead of gapping the doublers — the M1/M2 sign trap.

Two **further** hypotheses are required not by the *spacetime*-sign square but by
the **internal grading bookkeeping** (so `R_W` does not silently pollute the
physical Yukawa sector):

```text
(G6)  [χ_E, R_W] = 0          R_W is χ_E-EVEN (a scalar regulator)
(G7)  R_W is a Lorentz/internal scalar (∝ identity on the L⊕R carrier),
      momentum-dependent through the null shifts T_a only.
```

Contrast with the physical Yukawa `Φ_H`, whose live grading facts are:
`phiH_gammaS_even` (`Φ_H` is `Γ_s`-even — same as `R_W`) **but**
`phiH_chiE_odd` (`{χ_E, Φ_H} = 0` — *opposite* to `R_W`). So `R_W` and `Φ_H`
agree on the spacetime grading (both give `+square`) and disagree on the
internal grading. (G6) is what keeps them distinguishable; dropping it is how a
"regulator" could masquerade as, or contaminate, a generation/Yukawa entry.

When `Φ_H` and `R_W` are both `Γ_s`-even and both Clifford-commuting, they add
inside one zero-order block and square to `+(Φ_H + R_W)²` — the lattice Wilson
mass shift `m → m + R_W` made formal (helper
`nullWilson_combined_block_square`).

---

## 3. Q3 — Does `R_W` break ordinary chirality? Should the release move to
overlap/domain-wall/flavored chirality?

**Answer: YES, the scalar `R_W` breaks ordinary `Γ_s` chirality by
construction. The release theorem should be stated against the
flavored/projected chirality already in the repo; overlap/domain-wall is the
reserve fallback, not the immediate move.**

Why it breaks `Γ_s` chirality: ordinary chiral symmetry is `{Γ_s, D} = 0`.
The kinetic part `i D_N` anticommutes with `Γ_s` (G2), so it is chiral; but any
`Γ_s`-*even* zero-order term `Γ_s X` *commutes* with `Γ_s`
(`Γ_s·(Γ_s X) = X = (Γ_s X)·Γ_s` when `[Γ_s, X]=0`), hence **contributes to
`{Γ_s, D}` and breaks chiral symmetry** — exactly like a mass. By (G4\*), `R_W`
is `Γ_s`-even, so `Γ_s R_W` breaks `{Γ_s, D}=0`. This is unavoidable: it is the
Nielsen–Ninomiya tradeoff. A momentum-dependent scalar that lifts the doublers
*must* break `Γ_s` chirality; that is the price the Wilson term pays, and the
reason it works.

Consequences for the release theorem:

- **Do not state Gate C release in terms of the naive `Γ_s` index.** Live
  `NullEdgeFlavoredChirality.naive_index_zero`: `tr(Γ_s P_null) = 0` — `Γ_s` is
  blind at the minimally-doubled nodes (BCK mirror cancellation). With `R_W`
  present, `Γ_s` chirality is in addition explicitly broken. The naive index is
  doubly inadequate.
- **State release against the flavored / projected chirality already built.**
  Live `flavored_index_eq_four`: `tr(Γ_f P_null) = 4` for `Γ_f = Γ_s·T`; live
  `NullEdgeProjectedBranchChirality.projectedBranch_chirality_aligned` and
  `gateC_projected_chirality_clause` give the projected one-dimensional aligned
  chirality. `R_W`'s explicit `Γ_s` breaking is *consistent* with this line:
  the flavored/taste structure `T` is exactly what survives when `Γ_s` does not.
  This is the BCK / reduced-Kähler–Dirac picture flagged in the context pack
  (arXiv:2311.02487, 2501.10336): a doubler-free lattice operator that has an
  onsite (flavored) symmetry rather than ordinary chiral symmetry.
- **Move to overlap/domain-wall only on demand.** Overlap/DW is the right answer
  *iff* a downstream target requires exact (Ginsparg–Wilson) lattice chirality
  rather than the flavored/projected index. For Gate C v3 — declared in D13 as a
  *regulated reconstruction / branch-control counterterm*, not a
  prediction — the flavored/projected chirality + Krein-positive retained
  sector + ghost safety is the chosen and sufficient route. Recording overlap/DW
  as a labelled reserve avoids over-committing the Lean surface now.

Guardrail (from D13 and the C69 off-branch audit): releasing the flavored index
does **not** by itself certify ghost safety; see §4 and C74.

---

## 4. Q4 — Same zero-order block as `Φ_H`, or separate branch-control
counterterm?

**Answer: same *spacetime* (`Γ_s`-even) zero-order block, but a *separate,
`χ_E`-even branch-control counterterm* — never merged into `Φ_H`.**

"Same block" in the precise sense that matters for the Gate-A square: `R_W` and
`Φ_H` share the `Γ_s`-even grading, so they add and square to `+(Φ_H + R_W)²`
(helper `nullWilson_combined_block_square`). That is what lets `R_W` inherit the
audited healthy sign and lets the effective mass be the Wilson-shifted
`Φ_H + R_W`.

"Separate counterterm" in every other respect, for four reasons:

1. **Internal grading differs.** `Φ_H` is `χ_E`-odd (`phiH_chiE_odd`: it is the
   genuine off-diagonal chirality-flip Yukawa on `H_L ⊕ H_R`); `R_W` must be
   `χ_E`-even, (G6), a diagonal scalar. Merging them would corrupt the
   `L⊕R`/spectral-triple bookkeeping that `NullEdgeFureyPhiH` is built to
   protect (its explicit guardrail separates the Dirac `L⊕R` carrier from the
   all-left anomaly basis).
2. **Momentum dependence differs.** `Φ_H` is the constant physical Yukawa block
   `M`; `R_W = (r/2h) Σ_a (2 − T_a − T_a^♯)` is `q`-dependent and *vanishes at
   the physical origin* (C70 `wilson_zero_iff_origin`), so it contributes
   nothing to the physical (origin) mass and everything to the doubler branches.
   A physical mass and a branch counterterm have opposite jobs at `q=0`.
3. **Claim status differs (D13).** `Φ_H` carries physical content (Yukawa/
   generation structure); `R_W` is explicitly a *regulator / branch-control
   counterterm*, "not a prediction unless `r` and the operator form are forced."
   Keeping them as distinct summands keeps the claim ledger honest.
4. **Renormalisation/decoupling.** Treating `R_W` as a counterterm makes its
   coefficient `r` a tunable regulator parameter and exposes the residue/ghost
   question (C74) and the `r→` limits, rather than burying them inside a
   physical mass.

Net: write `D_phys = i D_N + Γ_s Φ_H + Γ_s R_W` with two named, separately
graded summands; do **not** write `Γ_s (Φ_H + R_W)` as a single physical mass.

---

## 5. Q5 — Minimal Lean API for C72 / C73

The decomposition that lets C72 and C73 proceed with the smallest new surface.
Reuse verbatim wherever a live predicate exists.

### 5.1 Placement / Gate-A sign layer (this task, delivered)

`PhysicsSM/Draft/NullEdgeNullWilsonPlacement.lean` (sorry-free, builds):

- `structure NullWilsonPlacement (Im Gs C Nb RW)` — bundles (G1)–(G5\*) +
  centrality. This is the grading contract every downstream module should take
  as a hypothesis rather than re-deriving.
- `nullWilson_square_healthy` — `+R_W²` square (regulator cost positive).
- `nullWilson_square_tachyonic` — `−R_W²` if misplaced (`Γ_s`-odd): the
  guardrail.
- `nullWilson_combined_block_square` — `+(Φ_H + R_W)²` shared-block shift.

(G6)/(G7) — the `χ_E`-even, scalar character — should be added as a one-line
`[χ_E, R_W] = 0` field when C72 wires `R_W` to the concrete `Φ_H` carrier of
`NullEdgeFureyPhiH`; it is a hypothesis, not a theorem to discover.

### 5.2 Positivity layer (C70) — feeds `NodalSetControlled`

From the C70 target module `PhysicsSM/Draft/NullEdgeNullWilsonRegulator.lean`
(to be produced by C70):
`wilson_zero_iff_origin`, `wilson_positive_away_origin`,
`wilson_lifts_known_highBranches`, `wilson_lifts_cubeRootWitness`,
`wilson_lifts_cyclotomic_orbit`. These discharge the *nodal-set control* clause:
every non-origin determinant zero (including the C64 off-branch witness
`q⋆ = (2π/3,0,0,4π/3)` from `NullEdgeNodalSetExhaustion`/C66) carries strictly
positive Wilson cost.

### 5.3 Projected-release layer (C72) — reuse, don't duplicate

Live in `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`:
`ProjData`, `NodalSetControlled`, `BranchProjectorsControlled`,
`ProjectedKernelOneDim`, `ProjectedChiralityAligned`, `ProjectedKreinPositive`,
`GhostZeroSafe`, `SpeciesSplittingAudited`, and the assembled
`ProjectedGateCRelease` / `projected_gateC_release`.
Live in `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`:
`ZeroDatum`, `GhostZeroSafe`, `KreinPositivePhysicalSector`, `RouteBData`,
`GateCFullRelease`, `flavoredIndex`, `g5pattern`, and the negative guardrails
(`index_nonzero_not_sufficient`, `chirality_not_ghostSafe`).

C72's requested `projectedGateCRelease_from_wilson_residue` should be a thin
conjunction over these, with two *new* fields only:

- `NullWilsonRegulatedNodalControl D_phys` — a wrapper that says: `D_phys`'s
  nodal set is controlled *because* of the C70 Wilson positivity (i.e. bundle
  `wilson_positive_away_origin` into `NodalSetControlled`). One structure, one
  constructor.
- `PostGaugeResiduePositive D_phys` — the C74 obligation (see 5.5). Keep it an
  opaque hypothesis at C72 level; C74 supplies its content.

Guardrail to encode (D13): the release conclusion is `GateCReleased D_phys`,
**never** for bare `D_+`.

### 5.4 Gauge-covariance layer (C73)

Target `R_W^A = (r/2h) Σ_a (2 − T_a^A − (T_a^A)^♯)`. Minimal API:

- `nullWilson_flat_symbol` — trivial gauge ⇒ `(r/h) Σ_a (1 − cos q_a)`; i.e.
  `T_a → e^{i q_a}`, `T_a^♯ → e^{−i q_a}`, `2 − T − T^♯ → 2(1 − cos q_a)`.
  This is a direct algebraic identity over `ℂ`/`ℝ`; reuse C70's `W`.
- `nullWilson_gaugeCovariant` — covariance under `T_a^A ↦ g_{tgt} T_a^A g_{src}^{-1}`
  (source/target gauge action on the dressed shift). State it as: `R_W^{A}`
  conjugates by the onsite gauge transformation, i.e. it is a gauge-covariant
  operator. The proof is the standard parallel-transport bookkeeping; if the
  concrete link variables are not yet defined, ship the structure + statement
  (the task explicitly permits a clean API module over a weakened claim).
- `nullWilson_selfAdjoint_or_KreinAdjoint` — **state precisely**: because the
  Wilson shape uses the *paired* shift `T_a^♯` (the advanced/Krein partner of
  the retarded `T_a`), `R_W` is **Krein- (J-) self-adjoint** in the null-edge
  Krein space, and reduces to ordinary **Hilbert self-adjoint** in the flat
  Euclidean toy where `T_a^♯ = T_a^†` and `2 − T_a − T_a^†` is a manifestly
  positive Hermitian operator. Do **not** claim plain Hilbert self-adjointness
  in the Lorentzian/retarded setting; the correct adjoint is the Krein adjoint
  (consistent with `NullEdgeBranchKreinSignatures.kreinJ` and the C74
  left-eigenvector question). This choice is what makes the residue formula of
  §5.5 well-posed.

### 5.5 Residue / ghost-safety layer (C74) — `PostGaugeResiduePositive`

C74 is report-only (`AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md`).
The minimal Lean API it should expose for C72 to consume:

```text
structure PostGaugeResiduePositive (D_phys) : Prop where
  -- for each surviving pole/sheet j on the physical quotient,
  --   Z_j⁻¹ = w_jᴴ J (∂_{q₀} D_phys) v_j  with  Z_j > 0,
  -- where v_j is the right (kernel) mode, w_j the Krein-adjoint left mode,
  -- J the Krein form, q₀ the null-edge energy variable.
```

Reuse the live ghost calculus
(`NullEdgeGateCGhostZeroSafety.PostGaugeGhostSafe`,
`postGaugeGhostSafe_of_residue_nonneg`, `KreinPositivePhysicalSector`) as the
abstract backbone; `PostGaugeResiduePositive` is the concrete `D_phys`
instantiation. The left eigenvectors must be the **Krein-adjoint** ones (matching
§5.4), not the Hilbert adjoint.

### 5.6 Dependency order

```text
C70 (Wilson positivity, real torus)            ── done as its own module
C71 (placement + Gate-A sign)  ── NullEdgeNullWilsonPlacement.lean  [this task]
C73 (gauge covariance, flat symbol, adjointness)
C74 (residue/ghost-safety plan → PostGaugeResiduePositive API)
C72 (projected release): consumes C70 §5.2, C71 §5.1, C73 §5.4, C74 §5.5
    via thin wrappers over NullEdgeProjectedGateCRelease.
```

---

## 6. Summary of answers

| # | Question | Verdict |
|---|----------|---------|
| 1 | Is `D_NW = i D_N + Γ_s R_W` correct? | Yes — scalar Wilson kernel in the `Γ_s`-even slot. Not overlap/DW; projection is a complement, applied after regulating the full carrier. |
| 2 | Grading hypotheses to protect Gate-A sign | (G1)–(G5\*): in particular **`[Γ_s, R_W]=0`** (load-bearing, `+R_W²`); plus (G6) `[χ_E,R_W]=0` and (G7) scalar/`q`-dependent to keep `R_W` distinct from `Φ_H`. |
| 3 | Does `R_W` break ordinary chirality? | Yes, unavoidably (Nielsen–Ninomiya). State release via flavored/projected chirality (`Γ_f`, projected branch); overlap/DW only if exact GW chirality is later required. |
| 4 | Same block as `Φ_H`? | Same `Γ_s`-even square block (adds to `+(Φ_H+R_W)²`); but a separate `χ_E`-even, `q`-dependent branch-control counterterm — never merged into `Φ_H`. |
| 5 | Minimal Lean API for C72/C73 | `NullWilsonPlacement` (delivered) + C70 positivity + reuse of `NullEdgeProjectedGateCRelease`/`NullEdgeGateCGhostZeroSafety`; new wrappers `NullWilsonRegulatedNodalControl`, `PostGaugeResiduePositive`; Krein- (not Hilbert-) adjoint throughout. |

**Bottom line.** `R_W` is a scalar, `Γ_s`-even, `χ_E`-even, momentum-dependent
Wilson kernel that sits in the same spacetime square block as `Φ_H` (inheriting
the healthy `+R_W²` Gate-A sign, machine-checked in
`NullEdgeNullWilsonPlacement`) but is a logically separate branch-control
counterterm. It breaks ordinary `Γ_s` chirality on purpose, so Gate C release
proceeds through the flavored/projected chirality line, with overlap/domain-wall
held only as a reserve. The remaining gates (positivity C70, gauge covariance
C73, Krein-positive residue/ghost safety C74) are independent obligations and
none is implied by the placement alone.
