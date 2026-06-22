# P9 source-visibility: finite API design note

Date: 2026-06-22
Scope: design/strategy. This note specifies the smallest finite Lean-facing API
that makes the P9 source-visibility branch precise, keeping **visible closure**,
**BF/surface closure**, and **observer invisibility** rigidly separate. It is
not a continuum cosmological-constant theorem and does not claim to be.

Companion scaffold (non-imported, partially machine-checked):
`PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean`.

Primary anchors read: `LeanContext/SpinorNetworkClosure/Finite.lean`,
`LeanContext/Gauge/CausalDiamondHolonomy.lean`,
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` (sec. 0a, 0b, P9
ledger), `AgentTasks/null-edge-overnight-run-plan-2026-06-21.md` (Gates 1-4),
`AgentTasks/null-edge-grand-strategy-v2-output.md` (Cluster G).

---

## 0. One-paragraph thesis

The recently banked closure identity
`pairwiseAngularMass w u = (energy w ^ 2 - |closureVector w u|^2) / 4`
(`NullEdgeSpinorNetworkClosure.pluckerMass_eq_energy_sq_sub_closureDefect_sq`)
forces a discipline: the vanishing of the **visible** closure vector
`C = Σ_i w_i u_i` is a *rest-frame* condition, under which the visible mass is
maximal (`= E^2/4`), **not** a statement that the configuration sources nothing.
P9 must therefore measure source visibility with a **different** functional from
visible closure: the **BF/surface closure defect** `Σ_f B_f` of a diamond
screen. The deliverable API is exactly the data needed to (a) state both
closures, (b) prove that boundary-exact BF data sources nothing in the bulk,
(c) prove that a visibly-closed massive fan still sources, and (d) hang the
observer/recoverability layer off a finite coarse-graining map. Three of the
core lemmas are already machine-checked in the scaffold; the rest are scoped as
proof jobs.

---

## 1. Minimal list of finite structures and maps

Keep the vocabulary small. Eight objects, two of which are re-exports of
existing trusted anchors.

| name | kind | one-line meaning | provenance |
|---|---|---|---|
| `Bivector` | `abbrev Fin 3 → ℝ` | toy self-dual / `su(2)_L` face label (the `Λ²₊ ≅ Sym²S` component) | new (toy) |
| `Screen ι` | `structure {faces : Finset ι, B : ι → Bivector}` | the boundary 2-surface of one diamond: a finite face set carrying BF data | new |
| `VisibleFanOnScreen n` | `structure {w : Fin n → ℝ, u : Fin n → Vec3}` | the visible weighted null-edge fan localised on a screen | re-export of `NullEdgeSpinorNetworkClosure` |
| `BFBoundaryData` | `:= Screen ι` (alias) + `closureDefect`/`IsBFClosed` | the BF/Gauss-law layer of a screen | new |
| `closureDefect : Screen ι → Bivector` | def `Σ_{f∈faces} B f` | the Gauss-law / BF closure defect `Σ_f B_f` | new |
| `DiamondSourceFunctional` | `diamondSource : Screen ι → ℝ := ‖closureDefect‖²` | candidate **bulk** source of a screen | new |
| `BoundaryExact` | `Prop` (cancelling-pair / coboundary witness) | BF data is a discrete coboundary `B = δa`; strictly stronger than BF-closed | new, ties to `cochainCoboundary_comp_self_eq_zero` |
| `BulkSource` | `Prop := diamondSource S ≠ 0` | the screen genuinely sources in the bulk | new |
| `ObserverChannel` | `structure` (finite coarse-graining map + reference) | what the observer retains of the screen/fan | new; ties to `RelativeEntropyObserverChannel` |

Two source channels, deliberately distinct, both defined on the same `Screen`:

* **visible mass channel**: `visibleMass := pairwiseAngularMass w u`
  (anchor `NullEdgeSpinorNetworkClosure`). Sees angular spread of the fan.
* **BF bulk channel**: `diamondSource := ‖closureDefect‖²`. Sees Gauss-law
  violation of the surface bivector data.

Design rule: **never collapse these two functionals into one symbol.** The P9
failure mode is precisely a definition that lets `C = 0` imply
`diamondSource = 0`.

Diamond geometry itself is re-used from
`PhysicsSM.Gauge.CausalDiamondHolonomy` (`PathPair`, `DiamondLabels`,
`diamondDefect`, gluing laws); a `Diamond` for P9 purposes is a handle carrying
(i) a holonomy `PathPair`, (ii) a `Screen`, and (iii) a `VisibleFanOnScreen`.
We do **not** introduce a second diamond primitive.

### Naming changes from the candidate list

* `BFBoundaryData` is realised as `Screen ι` plus the predicate `IsBFClosed`
  rather than as a separate structure — the BF data *is* the screen's `B` field;
  a parallel structure would only invite drift between the two.
* `DiamondSourceFunctional` is realised as a plain function `diamondSource`
  (and, separately, `visibleMass`) rather than a bundled structure: there are
  exactly two source channels and bundling them hides the separation we want.
* Everything else keeps the candidate name.

---

## 2. Exact intended meanings

These are the contractual definitions. Each is stated so a later audit can check
that no theorem silently widens it.

* **visible closure** — `closureVector w u = 0`, i.e. `C = Σ_i w_i u_i = 0`.
  Physics: the visible null fan is in its rest frame / polyhedral closure holds.
  **Not** masslessness, **not** source invisibility. Under it, by the banked
  identity, `pairwiseAngularMass = E^2/4`, the *maximal* mass for that energy.

* **BF closure (Gauss-law closure)** — `closureDefect S = 0`, i.e.
  `Σ_{f∈faces} B_f = 0`. Physics: the surface bivector data satisfies the
  spin-foam/BF Gauss constraint. This is the **coherent / internal vacuum
  bookkeeping** candidate for source invisibility.

* **boundary-exact** — `B` is a discrete coboundary: there is a fixed-point-free
  orientation-reversing pairing `τ` of faces with `B (τ f) = - B f` (the finite
  model of `B = δ a`, dual to the order-complex boundary). Boundary-exact is
  **strictly stronger** than BF-closed: every coboundary closes (this is the
  finite shadow of `d∘d = 0`, anchor `cochainCoboundary_comp_self_eq_zero`), but
  a closed configuration need not be a coboundary (nontrivial homology). Keeping
  this gap visible is the honest version of "boundary-only contribution".

* **bulk source** — `diamondSource S ≠ 0`, i.e. `‖closureDefect S‖² ≠ 0`.
  Physics: the screen sources a genuine bulk diamond defect, not a boundary term.

* **observer invisible** — relative to an `ObserverChannel Φ` with reference
  `ρ₀`: the configuration's contribution lies in the kernel of `Φ`, equivalently
  the observer's relative-entropy loss `S(ρ ‖ ρ₀) - S(Φρ ‖ Φρ₀) = 0`. This is an
  **observable-relative** notion (sec. 0b of the program): a thing is null only
  with respect to a named functional. There is no absolute "invisible".

* **recoverable** — there is a recovery map `R` (Petz / rotated-Petz) with
  `R(Φ ρ) = ρ`; quantitatively, `recoveryGap = 0`. The intended theorem
  `relativeEntropyLoss_zero_iff_exactObserverRecovery` ties zero relative-entropy
  loss to exact recoverability, upgrading the binary "invisible" to the
  Fawzi-Renner approximate-Markov quantitative statement.

The chain to keep straight (each arrow is one-directional in general):

```
boundary-exact  ⇒  BF closed (Σ B_f = 0)  ⇒  diamondSource = 0  (no bulk source)
visible closed (C = 0)  ⇏  diamondSource = 0   and   ⇏  visibleMass = 0
```

---

## 3. Theorem statements (refined / split / rejected)

### Keep, refined

1. `boundaryExact_implies_bfClosed`
   `IsBoundaryExact S → IsBFClosed S`.
   The substantive content of the old `boundaryExact_source_eq_zero`: this is
   `d∘d = 0` made finite. **Machine-checked** in the scaffold via
   `Finset.sum_involution`. Confidence high.

2. `boundaryExact_source_eq_zero` (corollary)
   `IsBoundaryExact S → diamondSource S = 0`. Compose (1) with (4). Keep, but
   note it derives its value from (1); on its own it is not the interesting step.

3. `closed_visibleFan_mass_eq_restEnergy`
   `closureVector w u = 0 → pairwiseAngularMass w u = energy w ^ 2 / 4`.
   **Already banked** as `NullEdgeSpinorNetworkClosure.closed_spinorFan_is_restFrame`.
   Re-export, do not re-prove. This is the guardrail theorem.

4. `visibleClosure_not_sourceInvisibility_counterexample`
   Exhibit `w, u` with `closureVector w u = 0` **and**
   `pairwiseAngularMass w u ≠ 0`. **Machine-checked** in the scaffold (2 antipodal
   unit edges: `C = 0`, mass `= 1`). This is the flagship separation lemma and
   should be the first thing any reader of the API sees.

### Keep, but the candidate phrasing was tautological — split

5. `bfClosure_implies_no_bulkDivergence` → split into:
   * `bfClosed_source_zero : IsBFClosed S → diamondSource S = 0`
     — **tautological by construction** (`diamondSource = ‖closureDefect‖²`).
     **Machine-checked**. Useful only as plumbing; do not advertise as content.
   * the *content* lives upstream in `boundaryExact_implies_bfClosed` (1).
   Label `bfClosed_source_zero` clearly as definitional so no audit mistakes it
   for a physics result.

### Reject as stated (false), replace

6. `visibleBulkSource_additive_under_diamondGluing` — **reject the squared-source
   form.** `diamondSource = ‖·‖²` is **not** additive: for glued disjoint screens
   `‖d_S + d_T‖² = ‖d_S‖² + ‖d_T‖² + 2⟨d_S, d_T⟩ ≠ ‖d_S‖² + ‖d_T‖²` in general.
   Correct finite targets:
   * `closureDefect_additive_under_gluing`
     `closureDefect (glue S T) = closureDefect S + closureDefect T`
     (disjoint face union; the **defect** is linear). Plausible, scoped as a
     proof job; this is the BF/abelian analogue of the *Abelian* holonomy gluing
     law `pathPairDefect_verticalCompose_comm`.
   * `diamondSource_additive_iff_orthogonal`
     `diamondSource (glue S T) = diamondSource S + diamondSource T ↔ ⟨d_S,d_T⟩ = 0`.
   The non-Abelian holonomy story (`pathPairDefect_verticalCompose`'s conjugation
   correction) is the warning sign that "just add the sources" is wrong; the BF
   bivector layer is abelian, so the correct statement is linearity of the
   *defect* plus a cross-term for the *source*.

### Add (new, needed to make the branch decisive)

7. `visiblePluckerMass_sources_bulkTerm` (positive companion to (4))
   On the screen built from a visible fan, `spinorWedge ≠ 0`
   (equiv. `pairwiseAngularMass ≠ 0`) implies the *visible mass channel* is
   nonzero. State on the visible channel `visibleMass`, **not** on
   `diamondSource` — the two channels measure different things. Reuses
   `Spinor.PluckerMass.two_edge_mass_zero_iff_wedge_zero`.

8. `relativeEntropyLoss_zero_iff_exactObserverRecovery` (Gate 4)
   `observerRelEntropyLoss Φ ρ ρ₀ = 0 ↔ ∃ R, R (Φ ρ) = ρ`. The quantitative
   upgrade of "observer invisible". Hard; scoped as a downstream proof job with
   its own definition-design pass (`RelativeEntropyObserverChannel`). Do **not**
   attempt before the channel and the relative-entropy functional are defined.

### Tempting statements to avoid

* "`diamondSource = 0` ⟹ massless / source-free" — false; conflates the two
  channels (counterexample (4)).
* "visible closure ⟹ BF closure" — unproven and not expected; they are
  independent constraints on different data.
* any statement that `‖·‖²`-type sources add under gluing — false (item 6).
* anything asserting the finite API constrains the everpresent-Λ amplitude,
  Benincasa-Dowker curvature, or ANEC/QNEC as continuum results — out of scope
  by the physics-boundary clause; these are motivation only.

---

## 4. Dependency graph: current anchors → future targets

```
ANCHORS (trusted / banked)
  NullEdgeSpinorNetworkClosure.pluckerMass_eq_energy_sq_sub_closureDefect_sq
  NullEdgeSpinorNetworkClosure.closed_spinorFan_is_restFrame      ── re-export ──┐
  Spinor.PluckerMass.two_edge_mass_zero_iff_wedge_zero                            │
  Gauge.CausalDiamondHolonomy.pathPairDefect_verticalCompose(_comm)               │
  Draft.NullEdgeCochainDiamond.cochainCoboundary_comp_self_eq_zero                │
                                                                                  │
LAYER 1  finite source API (this note / scaffold)                                 │
  Screen, closureDefect, diamondSource, IsBFClosed, IsBoundaryExact   ◄───────────┘
        │
        ├─► boundaryExact_implies_bfClosed              [CHECKED]  (uses sum_involution; finite d∘d=0)
        │        └─► boundaryExact_source_eq_zero       [corollary]
        ├─► bfClosed_source_zero                        [CHECKED, tautological]
        ├─► closed_visibleFan_mass_eq_restEnergy        [re-export of banked]
        ├─► visibleClosure_not_sourceInvisibility       [CHECKED]  (flagship separation)
        ├─► visiblePluckerMass_sources_bulkTerm         [JOB, easy; reuse PluckerMass]
        ├─► closureDefect_additive_under_gluing         [JOB, medium; abelian analogue of holonomy gluing]
        └─► diamondSource_additive_iff_orthogonal       [JOB, medium]
        │
LAYER 2  observer / recoverability  (needs RelativeEntropyObserverChannel first)
        ├─► ObserverChannel, observerRelEntropyLoss, recoveryGap   [DEFN JOB]
        ├─► relativeEntropyDataProcessing_for_diamondObserver      [JOB, hard]
        └─► relativeEntropyLoss_zero_iff_exactObserverRecovery     [JOB, hard]
        │
LAYER 3  positivity audit (Gate 4, continuum-facing — gated)
        └─► visiblePluckerFlux_satisfies_discreteANEC,
            diamondRelativeEntropy_secondDifference_nonnegative    [GATED; demote P9 if these fail]
```

Submit to Aristotle now: the three LAYER-1 `[JOB]` items (they are small and
reuse banked anchors). Hold LAYER 2/3 until the `RelativeEntropyObserverChannel`
definition pass lands.

---

## 5. Toy model separating visible closure from source invisibility

Minimal finite witness (machine-checked in the scaffold):

```
n = 2,  w = (1, 1),  u₀ = (1,0,0),  u₁ = (-1,0,0).
closureVector w u = (0,0,0)         -- visible closure HOLDS
energy w = 2
pairwiseAngularMass w u = (2² - 0)/4 = 1  ≠ 0   -- but the fan is massive
```

Interpretation: two back-to-back null edges of equal energy form a visibly
closed (rest-frame) configuration whose invariant mass is `1`. Visible closure
is achieved, yet the configuration is a genuine source by the mass channel.
Hence `visible closure ⇏ source invisibility`.

Complementary BF witness (also in the scaffold): a screen whose faces come in
sign-cancelling pairs (`IsBoundaryExact`) has `closureDefect = 0` and therefore
`diamondSource = 0` — a boundary-exact configuration sources nothing in the
bulk. Combining the two witnesses shows the two notions are logically
independent: one can have (visible closed, bulk sourcing) and (visible open,
bulk silent) simultaneously realisable, so neither implies the other.

---

## 6. Physics confidence scores (1-10) for the core definitions

| object / lemma | score | justification |
|---|---|---|
| `closureVector` / visible closure `C=0` | 9 | exact moment-map data; matches celestial-dipole convention; banked identity. |
| `pairwiseAngularMass` / `visibleMass` | 9 | banked, exact, central; the guardrail identity is proved. |
| `closureDefect` / BF closure `Σ B_f = 0` | 7 | correct finite Gauss-law statement, but the `Bivector := Fin 3 → ℝ` carrier is a toy `su(2)_L` stand-in; the *linear simplicity* sector tracking (EPRL vs degenerate vs `II±`) is **not** yet encoded. |
| `diamondSource = ‖closureDefect‖²` | 6 | honest bulk-source candidate, but `‖·‖²` is a choice; its physical normalisation and the bulk-vs-boundary reading are conjectural, and it is not additive. |
| `IsBoundaryExact` (cancelling-pair coboundary) | 6 | faithful finite `d∘d=0` shadow; but the real order-complex boundary map is richer, and nontrivial homology (closed-not-exact) is exactly where the physics lives and is not yet modelled. |
| `visibleClosure_not_sourceInvisibility` | 9 | the separation is real, exact, and checked; the central correct lesson of P9. |
| `boundaryExact_implies_bfClosed` | 8 | correct and checked; physical reading ("boundary-only contributes no bulk") is sound at this finite level. |
| `bfClosed_source_zero` | 4 | true but tautological; near-zero physics content by itself. |
| `ObserverChannel` / recoverability | 5 | the right framing (Fawzi-Renner / Petz), but undefined here; score reflects design intent, not a built object. |
| visible/BF channel separation discipline | 9 | the single most important design decision; prevents the headline P9 error. |

---

## 7. Failure modes that would demote the P9 branch

Demote (and say so explicitly) if any of the following hold. These sharpen the
program's own falsification ledger.

1. **Channel conflation.** Any landed definition makes `C = 0` (visible closure)
   imply `diamondSource = 0`, or unifies `visibleMass` and `diamondSource` into
   one symbol. This destroys the only correct lesson of P9.
2. **Boundary-exact leaks into the bulk.** The *intended physical* coherent /
   internal vacuum bookkeeping, when encoded, fails `IsBFClosed` (or fails
   `IsBoundaryExact` while the physics demands it be a boundary term), so the
   source functional sees it as a bulk volume term.
3. **No homology gap.** If `IsBoundaryExact ↔ IsBFClosed` in the model actually
   used (trivial homology), there is no room for "boundary-only" to be
   meaningful and the branch carries no information beyond Gauss's law.
4. **Source additivity is needed but false.** If the coarse-graining argument
   requires `diamondSource` to add under diamond gluing, it cannot (item 6);
   any result depending on it is unsound.
5. **Sector ambiguity.** The `Bivector` toy never gets upgraded to track the
   linear-simplicity sector (EPRL vs degenerate vs `II±`), so "BF closure" does
   not isolate a geometric/gravitational sector and the cosmological reading is
   vacuous.
6. **No recoverability.** Hidden bookkeeping advertised as observer-invisible is
   **not** recoverable from the observer algebra (large relative-entropy loss,
   Petz/rotated-Petz recovery fails) in the cases that matter — the quantitative
   invisibility claim collapses.
7. **Positivity violation.** The finite source fails the Gate-4 ANEC/QNEC-style
   discrete positivity (`visible null flux ≥ entropy second difference`).
8. **Amplitude tension survives.** Even with a clean mean-zero / boundary
   source, the residual inherits the everpresent-Λ CMB-era amplitude tension
   (Das-Nasiri-Yazdi) with no new suppression/correlation mechanism, and lacks a
   `√N` fluctuation pilot. In that case the finite algebra is fine but the
   *cosmological* leverage is absent — keep the algebra, drop the Λ claim.

Boundary clause (restate in every downstream module): this API is a finite
observer/source algebra. It does **not** prove Sorkin everpresent-Λ,
Benincasa-Dowker curvature, Jacobson/Clausius balance, ANEC/QNEC, or
Sorkin-Johnston entropy. Those remain motivation and source constraints only.

---

## 8. Decisive recommendation

* **Implement next** (definitions): `Screen`, `closureDefect`, `diamondSource`,
  `IsBFClosed`, `IsBoundaryExact`, plus re-exports of the banked closure anchors.
  These are in the scaffold and three of their lemmas already compile.
* **Send to Aristotle now** (proof jobs, all reuse banked anchors):
  `visiblePluckerMass_sources_bulkTerm`,
  `closureDefect_additive_under_gluing`,
  `diamondSource_additive_iff_orthogonal`.
* **Do not send yet**: anything in LAYER 2/3 — first run a definition pass for
  `RelativeEntropyObserverChannel` (observer map, relative-entropy loss,
  recovery gap), then submit `relativeEntropyLoss_zero_iff_exactObserverRecovery`.
* **Avoid**: the squared-source additivity statement, any
  `diamondSource = 0 ⇒ massless` shortcut, and any continuum-Λ claim before
  Gate 4 positivity and recoverability both pass.
```
