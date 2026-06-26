# Aristotle semantic context pack

Generated: 2026-06-25T15:07:16
Query: `NullStrand Fock cutoff Bell QFT direction marginal equivariance preserves direction marginal composition minimal Bell rates`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Remaining high-value challenges]

Score: `0.765`

```text
-horizon entropy/flux route and Bell/decoherence-functional layer
  remain research directions. They need finite observables and falsifiable
  pilots before they should be elevated to theorem targets.
```

### 2. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]

Score: `0.758`

```text
finite diamond can be equipped
with an SJ-style correlation state and a modular surrogate
`K_disc = -log sigma_diamond`; the proposed ANEC/QNEC analogue then becomes a
second-difference or convexity test for relative entropy along nested diamonds.
The caveat is essential: causal-set entropy examples recover area-law behavior
only after a Pauli-Jordan spectral truncation, so any SJ-based pilot must state
that truncation before making horizon-entropy claims.

The QGT/QFI, resource-theory, and Renyi-alpha extensions should remain gated.
They are promising because the celestial `CP^1` layer already has a real
Fubini-Study metric and imaginary Berry curvature, and because only some
divergence families obey data processing. They become theorem branches only
after the resource theory, free operations, or admissible parameter region is
fixed.

The frame-invariance audit adds a new mandatory theorem layer. Under
`SL(2,C)` spin-frame changes,

```text
P_vis |-> A P_vis A^dagger,
det(A P_vis A^dagger) = det(P_vis),
```

so `det(P_vis) = m^2` is the Lorentz scalar. By contrast,
`rho = P_vis / Tr(P_vis)` depends on the observer's timelike normalization, and
`det(rho) = det(P_vis) / Tr(P_vis)^2` computes `(m/E)^2`. The finite program
should therefore add explicit wrappers:

```lean
visibleReduced_boost_eq_congruence
det_visibleReduced_boost_invariant
normalizedVisible_boost_is_filtering
normalizedVisible_det_eq_massRatio_sq
restFrame_iff_normalizedMomentum_maximallyMixed
```

The kinematic mass/concurrence correspondence also has direct prior art,
notably Chin-Lee `arXiv:1407.2492`, and the non-covariance of reduced spin
entropy under boosts is a standard relativistic-quantum-information warning
from Peres-Scudo-Terno `quant-ph/0203033` / PRL 88, 230402 and
Gingrich-Adami `quant-ph/0
```

### 3. `PhysicsSM/Draft/NullEdgeQWUnitarity.lean`

Score: `0.758`

```text
namespace PhysicsSM.Draft.NullEdgeQWUnitarity
```

### 4. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 9 — Quantum measure, histories, and the Bell/Tsirelson question]

Score: `0.756`

```text
## Pillar 9 — Quantum measure, histories, and the Bell/Tsirelson question

**Literature (tag `quantum-measure`).** Sorkin *Quantum mechanics as quantum measure
theory* (`gr-qc/9401003`) and *Quantum dynamics without the wave function*
(`quant-ph/0610204`) formalize the decoherence-functional / quantum-measure view that the
program's "quantum measure over causal histories" needs. The curated Gemma4 pass added
Salgado's sum-rule identities `gr-qc/9903015` (`7QR6F4VK`), Dowker-Johnston-Surya
on extension and strong positivity `1007.2725` (`UC5T4NKA`), Bub on the Tsirelson
bound `1208.3744` (`AIHKUCDK`), and Dowker-Wilkes on strong positivity
`2011.06120` (`DRPQH4ME`).

**Next finite target.** Before claiming any Bell/Tsirelson physics, formalize the
finite event-algebra layer:

```lean
grade2_sum_rule
decoherenceFunctional_stronglyPositive_gram
strongPositivity_closed_under_tensor_product_finite
```

These are finite algebra targets only; the operational Tsirelson claim remains a
later theorem or falsification test.

**Falsification.** The decoherence functional cannot produce quantum correlations while
preserving operational no-signalling and strong positivity.

---
```

### 5. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Falsification-aware priority map]

Score: `0.755`

```text
21 spinor-network/phase-space triage additions.** Source anchors to
review/add when the Zotero workflow next runs: Dupuis-Speziale-Tambornino
spinors/twistors in loop gravity (`1201.2120`) for twisted-geometry closure
and moment maps; Arkani-Hamed et al. positive Grassmannian (`1212.5605`) for
Pluecker-cell stratification; Kim-Lee massive ambitwistor zig-zag theory
(`2301.06203`) for the phase/symplectic target; Ruskai-Szarek-Werner qubit
CPTP maps (`quant-ph/0101003`) for Bloch-channel dynamics; Klyachko quantum
marginals (`quant-ph/0511102`) for hierarchy as a spectrum polytope; Faulkner-
Leigh-Parrikar-Wang ANEC (`1605.08072`) for the null-energy inequality audit;
and Dowker-Philpott-Sorkin swerves (`0810.5591`) as a phenomenology hazard for
stochastic flip dynamics.

**2026-06-21 relative-entropy triage update.** The ANEC/QNEC/source-visibility
branch and the proper-time/concurrence branch should be organized by one
monotonicity principle: relative entropy/data processing under a specified
observer or coarse-graining map. Faulkner-Leigh-Parrikar-Wang (`1605.08072`)
is the continuum template for deriving null-energy positivity from modular
Hamiltonians and relative entropy. The finite null-edge analogue should first
define the observer channel, then prove the appropriate monotonicity theorem.
This also clarifies what the LOCC restriction in the concurrence branch is
doing: it is not a separate ad hoc rule, but the channel class under which the
chosen reduced observable is monotone.

**2026-06-21 information-theory source additions.** Added the following to
Zotero collection `9W59V3K9` and Neo4j: Faulkner-Leigh-Parrikar-Wang ANEC
`B68T629C` (`1605.08072`), Ceyhan-Faulkner QNEC/ANEC `TFGTQQTU`
(`1812.04683`), Casini relative-entropy Bekenstein bound `S9FTNNRU`
(`0804.2
```

### 6. `AgentTasks/null-edge-grand-strategy-v3-output.md` [0. What materially changed since grand-strategy v2]

Score: `0.751`

```text
one standalone.**
  `LeanContext/RelativeEntropy/NullEdgeRelativeEntropyObserverRoadmap.lean`
  checks `FinDist`, `FinObs` (column-stochastic), `applyObs`/`pushforward`,
  `FinObs.comp`, `klDiv`, `klDiv_self`, `klDiv_nonneg` (Gibbs),
  `klDiv_eq_zero_iff`, `klDiv_dataProcessing` (DPI — headline; not in Mathlib),
  `observerLoss_nonneg`, and `observerLoss_zero_of_exactRecovery` (finite exact
  Petz). The `recoverabilityGap` is defined.

* **Cluster B (celestial channel) — the *scalar isotropic* sub-case is done.**
  `LeanContext/CelestialScalarChannel/Finite.lean` proves
  `scalarChannel_massRatioSq_mono_of_contraction`. The full affine-Bloch /
  SO(3) / unital-contraction class (v2's B) is still open (T8).

Net: A (angular), G-Layer-1, and P7-classical are banked as **standalone
artifacts not yet promoted to trusted `PhysicsSM` modules**. The highest-value
work is now (i) the few *bridge* theorems that connect these islands to the
trusted complex `PluckerMass` and concurrence anchors, and (ii) **promotion** of
the clean islands into trusted modules with de-duplicated definitions.

---
```

### 7. `AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md` [Wave 2: Suppression & Concurrence]

Score: `0.751`

```text
### Wave 2: Suppression & Concurrence
4. **`null-edge-p9-weighted-residual-suppression-threshold`** (Proof/Counterexample)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP9WeightedSuppressionThreshold.lean`
   - *Task:* Find the exact threshold where weighted residual noise beats $1/\sqrt{V}$ everpresent-Lambda scaling.
5. **`null-edge-p6-mass-ratio-eq-concurrence`** (Proof)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP6MassConcurrence.lean`
   - *Task:* Prove the normalized determinant mass ratio equals the concurrence for a finite qubit with internal state.
6. **`null-edge-p7-qubit-concurrence-mass-ratio-monotonicity`** (Proof)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP7Monotonicity.lean`
   - *Task:* Prove mass ratio is monotone under unital Bloch contraction.
```

### 8. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]

Score: `0.751`

```text
the non-covariance of reduced spin
entropy under boosts is a standard relativistic-quantum-information warning
from Peres-Scudo-Terno `quant-ph/0203033` / PRL 88, 230402 and
Gingrich-Adami `quant-ph/0205179` / PRL 89, 270402. The program's novelty
should be claimed in the finite null-edge packaging, Lean-checked bundle
generalization, and dynamical/channel use of the mass ratio, not in the bare
two-qubit concurrence analogy.

The dynamical version should be a finite qubit-channel statement. A CPTP
channel on the visible celestial density matrix acts affinely on the Bloch
ball,

```text
r |-> T r + t,
```

while the mass ratio is `sqrt(1 - |r|^2)`. Thus the l=1 relaxation conjecture
should be stated as a spectral property of a channel or generator, not as a
raw flip-count slogan. Visible unitaries preserve `|r|`; depolarizing or
unital visible channels can increase the mass ratio by contracting `|r|`;
entangling hidden dynamics are not visible channels and can reverse the
monotonicity. Broad LOCC/local language should be replaced by the explicit
channel class being used.

The new big-physics development note
`Sources/Null_Edge_Big_Physics_Inquiry_Development.md` sharpens this into
three concrete inquiry lines. First, nonorthogonal internal labels replace the
orthogonal Pluecker sum by an exterior-square Gram formula
`det(M G M^dagger) = w^dagger (Lambda^2 G) w`; this is now isolated as the
draft Lean handoff `PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle` and is
the finite spine for the flavor-overlap/Yukawa-hierarchy proposal. Second,
the normalized determinant identity makes `2 sqrt(det rho_vis) = m/E` a
proper-time-rate/concurrence wrapper, with monotonicity claims restricted first
to explicit unital visible-channel classes and with entangling hidden dynamics
kept
```

## Scoped paper hits

No paper hits returned.
