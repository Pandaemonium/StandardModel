# Aristotle semantic context pack

Generated: 2026-07-09T14:22:08
Query: `structured closure holonomy winding protected low modes singlet binding carrier closure plane finite index`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` [the free/regulator level (new since the previous draft).]

Score: `0.766`

```text
### the free/regulator level (new since the previous draft).

For the zig-zag story to be non-circular on a finite substrate, exact
handedness must exist there in the first place, despite Nielsen-Ninomiya. The
program has now kernel-checked, at the free level: the GW overlap release
with exact Weyl projectors (Gate C1); and the full finite chiral-index
calculus - integer index, certified sign with
existence/uniqueness/self-adjointness, index = signature = eigenvalue-sign
counts, unitary invariance, and an explicit nonzero-flux witness with the
correct flux response (Gate C2). Grade `M [orig-packaging]`; stated
interpretation-free per Round 8. The **vanishing statement is now also
proved** (harvested 2026-07-03, Aristotle job 2b9ab4ce,
`OverlapIndexVanishing.lean`): a gapped overlap operator forces index zero, a
nonzero index forces exact zero modes, and the pi-flux witness's index `-1`
pins a genuine zero mode - topological protection of masslessness as a finite
theorem, and (a strict bonus) with no Hermiticity hypothesis needed. What
would close the layer fully beyond the free level: (i) gauge-background
locality and the index-density (anomaly) bridge, the program's named C2
successors; (ii) eventually, interacting statements. The free layer,
including protection, is done and machine-checked in both directions: flux
drives the index, and the index obstructs the gap.
```

### 2. `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md` [2. What is proved]

Score: `0.756`

```text
s `gamma5`, `eps` - Hermiticity turned out to be unnecessary, so the
ported statements are strictly more general than the submitted ones -

- `overlapIndex_eq_zero_of_isUnit_dov` (gapped form): an invertible overlap
  operator `Dov = 1 + gamma5 eps` forces index `0`;
- `exists_zero_mode_of_overlapIndex_ne_zero` (zero-mode form): a nonzero
  chiral index forces an exact zero mode of `Dov` - masslessness is
  topologically protected;
- `flux_witness_has_zero_mode`: instantiated at the pi-flux triangle, whose
  index `-1` therefore pins a genuine exact zero mode.

Proof mechanism (fully algebraic, no spectral theory): `A = gamma5 - eps` and
`B = gamma5 + eps` anticommute; `(eps gamma5) Dov^2 = B^2` makes `B` invertible
whenever `Dov` is; then `B^{-1} A B = -A` gives `Tr(gamma5 - eps) = 0`. This
closes the free-layer index arc in both directions: flux drives the index
(section 2f), and the index obstructs the gap (this section).
```

### 3. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Spinor-network closure as the source-visibility phase space]

Score: `0.755`

```text
### Spinor-network closure as the source-visibility phase space

The missed connection with the highest leverage is spinor networks / twisted
geometries. In LQG fixed-graph phase space, spinors on half-edges reconstruct
holonomy-flux data, and closure is the moment-map constraint at a node. This
is almost exactly the finite architecture needed for the null-edge
source-visibility branch.

The correction is important: for a visible spinor fan with weights `w_i` and
celestial directions `n_i`, the closure vector

```text
C = sum_i w_i n_i
```

is the spatial momentum / dipole, while the Pluecker mass is the Casimir

```text
m^2 = (1/4) * ((sum_i w_i)^2 - |C|^2).
```

Thus `C = 0` is a rest-frame or polyhedral-closure condition, not by itself
"no matter." The source-visibility question should instead ask which closure
constraint is being tested: visible momentum closure, BF face closure
`sum_f B_f = 0`, or internal bookkeeping closure. The useful finite claim is
that closure defects are moment-map defects that can pair with a diamond
surface/curvature functional, while closure-satisfying internal bookkeeping is
a candidate for boundary-only contribution.

**Lean/prose targets.**

- `spinorFanClosureVector`: define `C = sum_i w_i n_i` from the visible fan.
- `pluckerMass_eq_energy_sq_sub_closureDefect_sq`: the celestial-moment identity
  expressed in spinor-network closure language.
- `closed_spinorFan_is_restFrame`: closure means zero spatial momentum for the
  visible fan, not zero mass.
- `closureDefect_pairing_eq_visibleMomentumFlux`: pair closure defects with a
  finite diamond/source functional.
- `bfClosure_satisfied_implies_boundaryDiamondPairing`: the separate BF-style
  source-visibility target for `sum_f B_f = 0`.

**Status update, 2026-06-21.** Aristotle project
```

### 4. `AgentTasks/null-edge-overnight-run-plan-2026-06-21.md` [Gate 1: closure identity banked]

Score: `0.753`

```text
### Gate 1: closure identity banked

The completed spinor-network closure proof gives:

```text
pairwise angular mass = ((sum_i w_i)^2 - |C|^2) / 4.
```

Integrate this, but state the lesson correctly: `C = 0` is rest-frame visible
closure, not no source.
```

### 5. `AgentTasks/null-edge-p9-source-visibility-api-output.md` [6. Physics confidence scores (1-10) for the core definitions]

Score: `0.748`

```text
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
```

### 6. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` [11. The chirality substrate: program anchors for the zig-zag story]

Score: `0.746`

```text
l-checked
(`PhysicsSM/Draft/NullEdge/GateC2/OverlapIndexVanishing.lean`, harvested from
Aristotle job 2b9ab4ce and rewired onto the repo index): an invertible
("gapped", mass-admitting) overlap operator forces index `0`
(`overlapIndex_eq_zero_of_isUnit_dov`), so a nonzero chiral index forces an
exact zero mode (`exists_zero_mode_of_overlapIndex_ne_zero`) - and the
pi-flux witness, whose index is `-1`, therefore carries a genuine exact zero
mode (`flux_witness_has_zero_mode`). Hermiticity turned out to be unnecessary
(the proof is purely algebraic: `gamma5 - eps` and `gamma5 + eps`
anticommute, and invertibility of the overlap operator forces the latter
invertible, giving `Tr(gamma5 - eps) = 0`), so the ported statements are
strictly more general than the ones originally posed. This formalizes
"topological protection of masslessness" and completes the substrate half of
the zig-zag story at the free level.
```

### 7. `AgentTasks/model-calls/gemini/2026-06-24-round-021-adversarial-next-target.md` [Adversarial Critique of the Candidates  To keep the manuscript timeline aggressive and mathematically rigorous, we must aggressively filter out vague plumbing, redundant bounds, and tautological geome]

Score: `0.745`

```text
### Adversarial Critique of the Candidates  To keep the manuscript timeline aggressive and mathematically rigorous, we must aggressively filter out vague plumbing, redundant bounds, and tautological geometry.   *   **Candidate 1 (P2 Constrained-closure): Demoted.** "Closure" currently lacks a rigid topological/graph-theoretic definition in the active Lean API. Guessing an angle or index constraint just to force `trace=2` risks becoming a tautological, physics-free algebra exercise. If we assume the answer by defining "admissible" as "trivial holonomy," Aristotle will just prove $A \implies A$. *   **Candidate 3 (P9-F quotient packaging): Demoted.** The packet acknowledges this is likely a duplicate of the existing `NullEdgeP9ScreenQuotientBound`. Packaging for the sake of packaging has zero manuscript value and wastes an integration round. *   **Candidate 4 (P1/P7 observer-channel bridge): Demoted.** Dangerously underdefined. The "exact channel API" does not exist yet. Asking Aristotle to simultaneously invent a non-trivial physics API *and* prove its properties is a guaranteed hallucination/failure loop. *   **Candidate 2 (P2/P3 super-Dirac bridge): Salvageable, but deeply flawed as written.** Connecting a scalar identity to a "curvature block" sounds like software-engineering API glue, not mathematics. If the definitions aren't perfectly aligned, Aristotle will yield trivial type-casting rather than a manuscript-worthy theorem.   **The pivot:** We must extract the *mathematical core* of Candidate 2. The core physical question is how the *additive* Dirac operator (the sum of branch reflections on a diamond, dictating the step operator) algebraically bounds the *multiplicative* holonomy (the 4-reflection cycle trace). For $2 \times 2$ matrices, this is not a vague corre
```

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md` [2.3 Closed composite — **gauge invariance** (`loopComposite_gauge_invariant`)]

Score: `0.745`

```text
### 2.3 Closed composite — **gauge invariance** (`loopComposite_gauge_invariant`)

For a transport `W` that returns to the base vertex (a closed Wilson loop /
length-balanced path), contracted into a Hermitian singlet with the base field,

```text
loopComposite a W ψ  =  cinner (ψ a) (W *ᵥ ψ a),
cinner (g a *ᵥ ψ a) ((gaugeLink g W a a) *ᵥ (g a *ᵥ ψ a)) = cinner (ψ a) (W *ᵥ ψ a).
```

The `g a` of the field and the `g a` of its conjugate cancel: the closed
composite is **exactly gauge invariant**.

---
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.719`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.716`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 3. Two-twistor particle models and free massive higher spin fields

Score: `0.716`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 4. Confinement of quarks

Score: `0.716`
DOI: `10.1103/physrevd.10.2445`
URL: https://doi.org/10.1103/physrevd.10.2445

### 5. From Twistor-Particle Models to Massive Amplitudes

Score: `0.714`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087
