# Null-edge Route B master strategy after C21 (S10)

Date: 2026-06-27.
Type: master strategy (no-build).

Provenance: synthesized from the post-C21/C22 kernel-checked outcomes and the
Wave 11 integration record, against `Sources/NullStrand_Lean_Roadmap_Improved.md`
(Gate C projected-release architecture, §"Post-C21 Gate C projected-release
architecture"), `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, the
ambitious job backlog, and the five returned audit notes (k2, c43/c44, c45/c46,
c47/c48, f15).

This document is deliberately decisive. It does not inflate prediction claims.
Gate F prediction language stays **OFF** throughout: even on the most favorable
Gate C outcome, the species-splitting coefficient `r` remains a free modulus
(c45/c46), so no rank/codimension deficit in `F : M_finite -> M_EFT` is created
at the level of `r`.

---

## 0. Post-C21 picture (locked facts)

These are kernel-checked or now formalized as criteria and are treated as fixed
inputs for this strategy:

| Fact | Source | Status |
| --- | --- | --- |
| Bare four-component tetrahedral symbol assigns **no single ordinary chirality sign** to a high branch (`no_full_symbol_single_chirality`). | C21 | Kernel-checked. Route A is dead. |
| Modeled branch Krein pattern is `(+,-,+,-)`; not all branches Krein-positive. | C22 | Kernel-checked. |
| Bare determinant zeros are **extended nodal CURVES**, not isolated species (each high branch lies on a full line through the 3pi-corner and the origin; every `{0,pi}^4` null corner lies on one of four lines). | c43/c44 | Kernel-checked. Whether these lines *exhaust* the zero locus is flagged, NOT asserted. |
| Krein positivity is available only **after physical-sector projection** (`Pphys = Pbranch 0 + Pbranch 2`, the healthy `{0,2}` Dirac pair; `{1,3}` is the excluded ghost pair). Blanket positivity is unsatisfiable. | k2 / C22 | Criterion kernel-checked for modeled gradings. |
| Ghost-zero safety is **mandatory and independent**: a Route B dataset with maximal flavored index 4 still fails release if it harbours a fatal ghost zero (`index_nonzero_not_sufficient`). | c47/c48 | Criterion kernel-checked; physical residue/weak-coupling inputs remain open. |
| The natural Weber splitting term `M_split = r*T_lin` is **TUNABLE** (a protected modulus at best, not a magnitude prediction); partition is a discrete Z3 modulus absent a canonical selector. | c45/c46 | Kernel-checked adversarial core. |
| Remaining Gate C theorem: **`OperatorForcesAlignmentAfterProjection`**. | roadmap §post-C21 | OPEN, falsifiable. |

The remaining Gate C obligation decomposes (roadmap §post-C21) into:

```
NodalSetControlled          -- partially done (c43/c44); exhaustion open
BranchProjectorsControlled  -- OPEN (point-split projector P_a, gauge-covariant)
ProjectedKernelOneDim       -- OPEN (needs the actual Clifford symbol decider)
ProjectedChiralityAligned   -- OPEN (the headline content)
ProjectedKreinPositive      -- criterion done (k2); needs instantiation on D_phys
GhostZeroSafe               -- criterion done (c47/c48); needs physical inputs
SpeciesSplittingAudited     -- done: verdict TUNABLE (c45/c46)
```

So three of the seven predicates have shipped (species, plus criteria for Krein
and ghost), one is half-shipped (nodal), and **three carry genuine open theorem
content**: `BranchProjectorsControlled`, `ProjectedKernelOneDim`,
`ProjectedChiralityAligned`. These three, plus the nodal-exhaustion and the two
criterion-instantiations, are the entire residual Gate C surface.

---

## 1. Strategic roadmap for the next 2-3 waves

Guiding rule (carried from the backlog): **integrate before expanding**. Wave 11
shipped six new modules and one report; the highest-value next move is not a
broad new proof wave but (a) closing the integration gaps Wave 11 left behind,
(b) instantiating the two criteria on the actual operator, and (c) driving the
three open theorem-content predicates with a single concrete point-split
projector.

### Wave 12 - integration freeze + criterion instantiation

Purpose: pay down the Wave 11 integration debt (see §3) and turn the two
criteria from "modeled-grading" form into instantiations against the real
operator interfaces, without yet needing the full Clifford-symbol decider.

| Pri | Job | Type | Deliverable |
| --- | --- | --- | --- |
| 1 | **W12-1 Wave-11 report reconstruction.** Restore the four missing report files (c43/c44, d19, e13, m13 - see §3) verbatim from the returned summaries, so docs match the integration claim. | audit/manuscript | four `AgentTasks/*.md` files |
| 1 | **W12-2 Gate C projected-release skeleton.** Single module `NullEdgeProjectedGateCRelease.lean` defining the 7 predicates and the conjunction `OperatorForcesAlignmentAfterProjection := ...`, importing k2's `KreinPositiveSector`/`Pphys` and c47/c48's `GhostZeroSafe`/`PostGaugeGhostSafe`, with each open predicate left as a named `sorry` obligation. | proof (skeleton) | `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` |
| 2 | **W12-3 Krein instantiation.** Instantiate k2's `Pphys_kreinPositive` against the actual branch-signature object used by the real operator (replace the modeled grading with the C22 signatures), discharging `ProjectedKreinPositive` for the canonical physical sector. | proof | extend k2 module |
| 2 | **W12-4 Nodal-exhaustion target.** State (and attempt) `nodal_locus_is_four_lines_union_origin` (or its honest refutation): the determinant-zero set of the *scalar* `p(q)^2` equals the union of the four branch lines (mod the flagged higher-dim caveat). Closes `NodalSetControlled`. | proof | `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean` (extend) |
| 3 | **W12-5 P1 crosswalk patch application** (m13 A-F). Apply the six minimal hunks demoting the absent `TwistorPluckerMass` wrapper trusted->pending and the `spinorAction`->`actSpinor` identifier fix. | manuscript | P1 manuscript + publication plan edits |

Hard scheduling rule: W12-2 must compile as a skeleton (predicates + conjunction,
all open parts `sorry`) before any Wave 13 chirality job is launched. This makes
every later proof a drop-in `sorry`-fill against a fixed interface.

### Wave 13 - the actual Clifford-symbol decider and projected chirality

Purpose: attack the three open theorem-content predicates with one explicit
point-split projector. This is the wave that can *close or refute* Gate C.

| Pri | Job | Type | Deliverable |
| --- | --- | --- | --- |
| 1 | **W13-1 Tetrahedral Clifford symbol.** Define the actual `c(p(q))` (the C21 symbol object), prove `c(p_a)^2 = 0`, `rank c(p_a) = 2`, `dim ker c(p_a) = 2`. | proof | `PhysicsSM/Draft/NullEdgeTetrahedralCliffordSymbol.lean` |
| 1 | **W13-2 Point-split projector control** (`BranchProjectorsControlled`). Prove for `P_a(q) = ((1+cos q_a)/2) * prod_{b!=a} ((1-cos q_b)/2)`: `P_a(q^b)=delta_ab`, `P_a(0)=0`. | proof | same module |
| 2 | **W13-3 Projected kernel one-dim** (`ProjectedKernelOneDim`). With the projector, `finrank (P_a . ker c(p_a)) = 1`. | proof | depends on W13-1/2 |
| 2 | **W13-4 Projected chirality alignment** (`ProjectedChiralityAligned`, the headline). On the projected one-dim kernel, `Pker Gamma_s Pker = g5_a Pker`. **Falsifiable**: if it comes out mixed even after projection, record the refutation - that is a publishable branch-audit no-go, not a failure. | proof / disproof | depends on W13-3 |

Decision fork after Wave 13: if W13-4 lands, `OperatorForcesAlignmentAfterProjection`
closes (modulo the physical ghost input of Wave 14) for the *specified projected*
operator `D_phys`, never the bare `D_+`. If W13-4 refutes, freeze Gate C at the
projected level and publish the conditional-release/no-go package - the program
survives as controlled branch architecture (roadmap "Route B is not a failed
program").

### Wave 14 - physical ghost input and species selector (uncertainty closeout)

Purpose: discharge the two remaining physics-dependent obligations, both of which
are potential kill-switches, and test the one upside that could move Gate F.

| Pri | Job | Type | Deliverable |
| --- | --- | --- | --- |
| 1 | **W14-1 PostGaugeGhostSafe instantiation.** Supply residue signs + weak-coupling deformation and discharge c47/c48's open `PostGaugeGhostSafe` for `D_phys` (no ghost generation, residue-sign control, projection persistence, joint index+safety survival). **Kill-switch candidate.** | proof/audit | extend c47/c48 module + audit |
| 2 | **W14-2 Canonical species selector.** Attempt the verdict-changing residual from c45/c46: exhibit (or refute) a canonical C/reflection + preferred-covector symmetry forcing the 2+2 partition. Success upgrades partition modulus -> forced texture (structural-prediction *candidate* only; `r` stays free). | proof/audit | `NullEdgeSymmetryForcedSpeciesSplit.lean` (extend) |
| 3 | **W14-3 Gate C release verdict review.** Combine W12-W14 into a four-valued verdict (RELEASED / PENDING-SAFETY / DOWNGRADED-GHOST-HAZARD / REDESIGN-REQUIRED) per c47/c48's release language. | strategy | `AgentTasks/null-edge-gate-c-release-verdict.md` |

---

## 2. Proof targets ranked by gate-closing value

"Gate-closing value" = how much the target advances or terminates the single
remaining Gate C theorem and reduces program uncertainty, weighted against cost
and against whether it is falsifiable now.

| Rank | Target | Predicate closed | Why | Cost / risk |
| --- | --- | --- | --- | --- |
| **1** | **Projected chirality alignment** `Pker Gamma_s Pker = g5_a Pker` for the explicit point-split projector (W13-4). | `ProjectedChiralityAligned` | This *is* the headline of `OperatorForcesAlignmentAfterProjection`. It either closes Gate C (with W14) or refutes the last alignment route - both outcomes maximally reduce uncertainty. | High; needs W13-1..3 first; falsifiable. |
| **2** | **Actual Clifford symbol decider + projected one-dim kernel** (W13-1, W13-3). | `ProjectedKernelOneDim` | Necessary precondition for Rank 1; converts C21's negative bare result into a concrete projected kernel object. Nothing downstream is justified without it. | High; pure finite linear algebra once the symbol is fixed. |
| **3** | **Nodal-set exhaustion** (the four lines + origin exhaust `{p(q)^2=0}`, or its refutation) (W12-4). | `NodalSetControlled` | Cheap finite computation; until it lands, branch-projector language is *unjustified* (c43/c44 explicitly flagged this). High value-per-cost; a clean falsifier. | Low-medium; clean. |
| **4** | **PostGaugeGhostSafe** instantiation with real residue/weak-coupling input (W14-1). | `GhostZeroSafe` (physical) | Kill-switch: a fatal gauge-coupled ghost zero blocks release even at index 4. Resolving it removes the single largest "could kill the program" risk. | High; depends on physical inputs not yet in Lean. |
| **5** | **Branch-projector control** `P_a(q^b)=delta_ab`, `P_a(0)=0`, then gauge-covariant/link-dressed version (W13-2). | `BranchProjectorsControlled` | Mechanical free-field part is easy; the gauge-covariant version is the real content and feeds W14-1. | Low (free-field) / high (covariant). |
| **6** | **Krein instantiation on `D_phys`** (W12-3). | `ProjectedKreinPositive` | k2 already gives the criterion and the canonical `Pphys`; this is wiring the modeled result to the real signatures. Important but low residual risk. | Low-medium. |
| **7** | **Canonical species selector** (Weber upgrade) (W14-2). | `SpeciesSplittingAudited` -> texture | Only target with prediction *upside* (forbidden-counterterm/forced-texture class), but low probability and still no magnitude. `r` stays a modulus regardless. | High; speculative. |

Ranks 1-3 are the critical path. Rank 4 is the dominant kill-switch. Ranks 5-7
are supporting/wiring/upside. **Do Rank 3 first** (cheap, justifies everything
else), then Ranks 2->1, with Rank 4 as the gating physics input.

---

## 3. Missing / un-integrated audits and jobs

The Wave 11 integration record claims "those summaries are preserved verbatim as
the named report files." That is only true for three of seven jobs. **Four
referenced report files do not exist in the repo:**

| Job | Referenced report file | Present? | Action |
| --- | --- | --- | --- |
| c43/c44 | `AgentTasks/null-edge-spectral-graph-nodal-classification-plan.md` | **MISSING** | reconstruct from returned summary (W12-1) |
| d19 | `AgentTasks/null-edge-d19-d0-symbol-contract-step-note.md` | **MISSING** | reconstruct (W12-1) |
| e13 | `AgentTasks/null-edge-e13-fms-composite-observable-next-note.md` | **MISSING** | reconstruct (W12-1) |
| m13 | `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md` | **MISSING** | reconstruct (W12-1) |
| k2 | `null-edge-k2-krein-positive-release-criterion-note.md` | present | - |
| c47/c48 | `null-edge-golterman-shamir-ghost-zero-audit.md` | present | - |
| c45/c46 | `null-edge-weber-flavored-qcd-splitting-audit.md` | present | - |

Additional report-only / un-applied items that are recorded but **not integrated
into docs or manuscripts**:

1. **m13 P1 crosswalk patches A-F** - explicitly *not auto-applied* (user-owned).
   The release-blocking overclaims O1-O7 (the absent
   `PhysicsSM.Spinor.TwistorPluckerMass` is marked trusted/re-verified) and the
   mandatory U1 `spinorAction`->`actSpinor` identifier fix are still pending in
   the P1 manuscript and publication plan. **This blocks a clean P1 release.**
   Action: W12-5.
2. **f15 genuine-prediction-candidate ledger** - integrated as a report, but its
   conclusions (nothing currently formalized is a Gate-F prediction; free EFT
   moduli make `F` full-rank; only structural route is Gate-C branch-chirality
   forcing) are not yet reflected as an explicit "prediction language OFF" banner
   in the manuscripts. Action: fold into the P1.5 claim-ledger (see §4).
3. **d19 (Gate D0 symbol-contract step) and e13 (Gate E next FMS theorem)** -
   landed as kernel-checked modules but with no report files and no roadmap
   cross-reference. They are not on the Gate C critical path; they belong to the
   P1.5 reconstruction body (§4) and should be cited there rather than left
   orphaned.

Recommendation: Wave 12 job W12-1 closes (1) the four missing report files and
W12-5 closes the m13 application; (2)-(3) are folded into the P1.5 paper assembly.

---

## 4. Next publication priority

**Decision: P1 cleanup *first* (small, days), then the P1.5 finite-operator /
finite-reconstruction paper as the next *substantial* publication. The Gate C
projected-release proof is NOT the next publication - it is a parallel
uncertainty-reducing proof track that publishes as a branch-audit / conditional-
release paper regardless of whether it closes.**

Rationale:

- **P1 cleanup is nearly done and is the strongest, most defensible result**
  (finite Plucker mass: `det(P) = sum_{i<j} |psi_i ^ psi_j|^2`). Its only
  blocker is the m13 overclaim set (O1-O7) and the U1 identifier fix - hours of
  edits plus a convention-banner rebuild, no new mathematics. Releasing P1
  clean is the highest expected-value, lowest-risk publication move and should
  not wait behind anything. Do it in Wave 12 (W12-5).

- **P1.5 is the right next substantial paper because the body already exists and
  is honest.** Wave 11 plus prior waves have produced a coherent set of
  kernel-checked *reconstruction/consistency* theorems: Yukawa checkerboard /
  rectangular spectrum, electroweak stabilizer rank, scalar/gauge null-kinetic
  reconstruction, Abelian Higgs link stiffness, the d19 D0 quadrature contract,
  the e13 gauge-invariant FMS composite, plus the Gate-C *criteria* (k2 Krein
  release, c47/c48 ghost-zero safety) and the Gate-C *structural findings*
  (c43/c44 extended nodal curves, c45/c46 Weber-tunable). Packaged honestly as
  "finite null-edge reconstruction architecture + branch audit", this is a large,
  durable, low-risk publication that needs **no** Gate C closure and **no**
  prediction claim. f15's verdict (everything formalized is reconstruction/
  consistency; `F` full-rank as written) is exactly the honest framing for it.

- **Gate C projected-release should NOT gate publication.** It is the highest
  scientific-uncertainty target, but it is (a) hard, (b) gated on the falsifiable
  `ProjectedChiralityAligned` and the physics-input `PostGaugeGhostSafe`, and (c)
  *prediction-irrelevant even on success*: c45/c46 proves the species-splitting
  coefficient `r` stays a free modulus, so Gate F prediction language stays OFF
  at the level of `r` no matter how Gate C resolves. Therefore Gate C belongs in
  a separate paper whose value is the branch-audit / conditional-release result -
  publishable as a no-go OR a conditional release, per the roadmap's "Route B is
  a publishable branch-audit result, not a failed program."

Publication sequence:

```
1. P1 (origin-of-mass / finite Plucker)   -> release after m13 cleanup (Wave 12)
2. P1.5 (finite reconstruction + branch audit) -> assemble from existing modules
3. Gate C projected-release / branch-audit -> parallel proof track, publishes
   either as conditional release (if W13-4 + W14-1 land) or as a no-go branch
   audit (if they refute). Never blocks 1 or 2.
```

---

## 5. Adversarial risk register

Three tiers: **KILL** (could end the program), **DOWNGRADE** (prediction ->
reconstruction, or release -> conditional), **ENGINEERING** (formalization /
integration work only).

### KILL - could end (or fatally redesign) the program

| Risk | Trigger | Mitigation / current status |
| --- | --- | --- |
| **Gauge-coupled fatal ghost zero.** A propagator zero becomes a gauge-coupled ghost-like state after weak coupling (Golterman-Shamir hazard). | W14-1 `PostGaugeGhostSafe` refutes for every admissible projector. | c47/c48 already formalized the hazard and the four-valued verdict; `index_nonzero_not_sufficient` proves index alone never releases. This is the single largest residual risk - schedule W14-1 early. Stop rule: "gauge-coupled ghost-like zeros -> fatal unless removed by composite theorem." |
| **Krein growing physical modes.** Even the projected physical sector `Pphys` harbours complex/unstable modes under the actual operator dynamics. | Krein instantiation (W12-3) shows the `{0,2}` sector is indefinite/unstable on `D_phys`. | k2 proved a positive criterion for modeled gradings; risk is in instantiation. Stop rule: "Krein growing modes -> redesign retarded/Krein layer." |
| **Nodal locus is genuinely higher-dimensional / complex-sheet.** The determinant-zero set is not exhausted by the four lines but is an extended surface or complex branch sheet. | W12-4 refutes exhaustion. | c43/c44 explicitly flagged this as open ("certified nodal components; whether they exhaust the locus is NOT asserted"). If it is a surface, "modified-chirality analogy is probably the wrong tool" -> redesign. |
| **Projected chirality still mixed.** `ProjectedChiralityAligned` is false for every locality/gauge-admissible projector. | W13-4 refutes. | Then bare AND projected alignment both fail; Gate C cannot release for any `D_phys` in this family -> publish no-go, redesign operator or accept vector-like spectrum. |

### DOWNGRADE - prediction -> reconstruction (does not kill, removes a claim)

| Risk | Effect |
| --- | --- |
| **Species-splitting coefficient `r` stays a free modulus.** c45/c46 already proves this (verdict TUNABLE). | Gate F prediction language at the level of `r` is permanently OFF. Program remains *reconstruction*, not prediction. Already priced in. |
| **No canonical pairing-selecting symmetry** (W14-2 refutes). | The 2+2 partition stays a discrete Z3 modulus; even the structural forced-texture *candidate* is lost. Program keeps only forbidden-counterterm-class structural results. |
| **`F : M_finite -> M_EFT` full-rank** (f15 ledger: free EFT moduli `Phi_H`, Higgs potential, spectral function, cutoff, Pauli operators). | Whole program is "unified finite reconstruction", not prediction. This is the *expected* honest outcome and the basis for the P1.5 paper - a downgrade only relative to the most ambitious hope, not a failure. |
| **FMS composite carries residual charge** (e13 `O^W` is custodial-covariant, not a full scalar). | W/Z language stays reconstruction-level (leading-term carrier), not a pole/spectrum theorem. |

### ENGINEERING / formalization - work, not risk to the thesis

| Item | Note |
| --- | --- |
| Four missing Wave-11 report files; m13 patches un-applied; d19/e13 un-cross-referenced (§3). | Pure integration debt; Wave 12 W12-1/W12-5. |
| Pre-existing broken default build target (sibling files import absent upstream modules `TetrahedralHighMomentumNullBranch`, `KreinDoubleAndCounterexamples`, `NullEdgeFlavoredChirality`). | k2 reconstructed faithful minimal versions; new modules kept self-contained. Needs a one-time module-hierarchy consolidation (backlog I5/G0) so the whole tree builds. |
| Krein/ghost criteria are stated for *modeled* gradings. | Instantiation against real signatures is wiring (W12-3, W14-1), not new theory. |
| Branch-projector free-field facts (`P_a(q^b)=delta_ab`, `P_a(0)=0`). | Mechanical finite computation (W13-2). |
| P1 convention-banner rebuild after m13 hunks. | Mechanical. |

---

## 6. One-paragraph executive verdict

Gate C now reduces to one falsifiable theorem,
`OperatorForcesAlignmentAfterProjection`, whose only genuinely open content is the
chain *actual Clifford symbol decider -> projected one-dimensional kernel ->
projected chirality alignment*, with a hard independent ghost-safety gate on top.
The fastest uncertainty reduction is: (Rank 3) prove or refute nodal-set
exhaustion cheaply; (Ranks 2->1) build the symbol decider and decide projected
chirality; (Rank 4) discharge the gauge-coupled ghost gate, the dominant
kill-switch. Publish P1 immediately after the m13 cleanup, ship the P1.5 finite
reconstruction + branch audit as the next substantial paper from the modules that
already exist, and keep the Gate C projected-release as a parallel track that
publishes as a conditional-release or a no-go either way. Throughout, prediction
language stays OFF: even a fully closed Gate C leaves `r` a free modulus, so the
program's honest standing is unified finite *reconstruction*, with structural
forced-texture the only - and still speculative - prediction upside.
