# POST_KEYSTONE_AUDIT_06 — post-keystone mass, positivity, and continuum audit

Independent source-level audit for job `codex-keystone-wave-audit-20260710-06`.
Scope: the six landed snapshots under `Sources/`
(`HodgePluckerMassBridge`, `PositiveHodgePhysicalMass`,
`PositiveSectorIntertwinerInvariance`, `SummableFourierContinuumLift`,
`D4NullRaySpinorFactorization`, `UnitaryHistoryComposition`), the three current
proof targets under `Targets/` (`SpinorHodge`, `D4Walk`, `UnitaryTransfer`), the
prior audit (`Docs/2026-07-10_ARISTOTLE_KEYSTONE_WAVE_AUDIT_05.md`), both control
matrices (`Docs/MANUSCRIPT_CLAIM_MATRIX.md`, `Docs/THEORY_COMPLETION_MATRIX.md`),
and the benchmark manifest (`Docs/SIMULATION_BENCHMARKS.md`).

**No source files were edited.** Findings first, ordered by severity.

Grades: `CLOSED` (the kernel statement proves exactly what its caption claims and
is a landed, non-`s o r r y` theorem), `PARTIAL` (statement is honest but strictly
narrower than the surrounding prose, or rests on supplied data / an absent
import), `OPEN` (the claimed arrow is a `s o r r y` target, or is not in the kernel
at all).

Verification legend:
- `[verified-here]` re-elaborated in this Lean/Mathlib (v4.28.0), or its
  arithmetic re-derived here.
- `[source-only]` module imports upstream `PhysicsSM.Draft.NullEdge.*` /
  `PhysicsSM.Spinor.*` files **absent** from this package; it cannot be
  recompiled here and its `#print a x i o ms … #guard_msgs` guard is **not
  enforceable in this tree**. Per the task, the live repo reports
  `[propext, Classical.choice, Quot.sound]` and passes
  `OvernightTheoryAxiomGuard`; this is **not** counted as a live-tree failure,
  but every statement below is audited from source text and re-derived
  arithmetic, not from an executed guard here.
- `[s o r r y-target]` a proof target under `Targets/` whose body is `by s o r r y`; the
  statement is audited (and its truth re-derived here), the proof does not yet
  exist.

---

## F0 (SEVERITY: MEDIUM) — package build surface unchanged; landings are source-only, targets are s o r r y

Two structural facts frame every grade.

1. **The only buildable target is a stub.** `lakefile.toml` builds exactly the
   library `Audit` = `Audit/Core.lean`, whose sole theorem is
   `PostKeystoneAudit.package_marker : True` `[verified-here]`. It proves nothing
   about the corpus.

2. **All six `Sources/` snapshots are `[source-only]`.** Every upstream import
   (`PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo`,
   `…PositiveHodgeRayleigh`, `…CanonicalGramTurnDictionary`,
   `…FiniteFourierContinuumLift`, `…HistoryOperatorMonoidalDagger`,
   `…D4NullShellLattice`, `PhysicsSM.Spinor.PluckerMass`) is absent from this
   package (confirmed by search: no such file outside `.lake`). Their a x i o m
   guards therefore cannot be executed here. This is the same F0 recorded by
   Audit-05; it is unchanged, and per the task it is not treated as a live-tree
   build failure.

3. **The three `Targets/` files import only `Mathlib` and are `s o r r y` stubs.**
   They are self-contained and elaborate as s o r r y-targets, but every headline
   theorem in them is `by s o r r y`; each is `OPEN` until a non-`s o r r y` proof lands.
   Their statements were re-derived here and are true and non-vacuous (details
   per question).

Recommendation: the matrices should keep the six `Sources/` snapshots at
`[import]`/source-only in this package, and mark the three `Targets/` rows
`OPEN / s o r r y`. No matrix row may read a `Targets/` statement as achieved.

---

## Question-by-question findings

### Q1 — Does `quartetSAt m` + the parameterized Hodge–Pluecker theorem *derive* mass on a family, or *encode* the answer? Strongest honest headline?

`PositiveHodgePhysicalMass` (`quartetSAt`, `quartetSAt_class_cost`,
`parameterized_nondegenerate_quartet_witness`,
`parameterized_quartet_two_scale_control`) and
`HodgePluckerMassBridge` (`parameterized_quartet_class_cost_eq_canonical_plucker`,
`parameterized_bridge_two_scale_control`) — `[source-only]`, arithmetic
`[verified-here]`.

**Verdict: it derives class-*invariance* and the correct functional form
`m ↦ m²` on a genuine one-parameter family, but it *encodes* the numerical mass:
`m²` is written into the decoder definition, and the "for every exact
representative" quantifier ranges over a family that is a fixed point of the
relevant component. Grade CLOSED as a theorem; PARTIAL for the physics.**

Detail, all re-derived here:
- `quartetSAt m := toLin' diag(0,0,m²,0)`. The pairing formula
  `quartetB x (quartetSAt m x) = m²·(x 2)²` (`quartetSAt_decoder_pairing_formula`)
  is exact, and the Krein form `quartetBMatrix = [[0,1,·,·],[1,0,·,·],diag(1),
  diag(-1)]` is genuinely indefinite and nondegenerate
  (`quartetB_left_nondegenerate`, `quartet_e2_positive = 1`,
  `quartet_e3_negative = -1`). The nilpotent constraint is genuine
  (`quartetQ_ne_zero`, `quartetQ_sq = 0`, `quartetQ qe1 = qe0`,
  `quartetB qe0 qe1 = 1`): the exact direction is **not** globally null, which is
  the real content that rules out the degenerate `diag(0,1,1)` failure mode
  Audit-05/earlier flagged.
- `quartetSAt_class_cost m chi : quartetB (qe2+quartetQ chi)
  (quartetSAt m (qe2+quartetQ chi)) = m²`, with **no** `mu2 = m²` hypothesis.
  Composed with `canonical_plucker_mass`, the bridge gives
  `= complexAbsSq (spinorWedge edge0 (edge1 m))` for **every** real `m` and
  **every** `chi`. Two distinct nonzero scales (`4/25`, `9/25`) are exhibited and
  proved distinct — this rules out a relabelled single-point coincidence.

**Where it is encoding, not derivation:**
1. `m²` is a literal coefficient in the definition of `quartetSAt`; the former
   named hypothesis `hmu : mu2 = m²` has been relocated into the decoder, not
   discharged from dynamics. (`class_cost_eq_canonical_plucker` still carries the
   explicit `hmu` for the abstract case; the parameterized theorem removes it only
   by construction.)
2. The class cost is `m²·(x 2)²` and **every** exact representative
   `x = qe2 + quartetQ chi` has `x 2 = 1` (`quartetQ` only writes component `0`).
   So "for every `chi`" is over a family that is constant in the sole component
   the cost sees — the invariance is real (it *is* the class-cost no-go), but the
   quantifier is weaker than it reads.
3. Nothing selects this decoder, this Krein form, or the scale `m` from primitive
   data; the positive-sector selection and decoder/dynamics selection remain open
   (correctly disclaimed in the module docstring and matrix M3).

**Strongest honest headline:** *"An explicit one-parameter family of
nondegenerate indefinite-Krein nilpotent fixtures realizes, for every real scale
`m` and every exact cohomology representative, a class-invariant spectral cost
exactly `m²`, equal on the nose to the canonical Plücker invariant
`normSq(wedge(e0, m·e1))`, with `4/25` and `9/25` as distinct nonzero controls —
removing the former `mu2 = m²` premise. The decoder carrying that eigenvalue is
supplied (with `m²` baked in), not derived from carrier dynamics; positive-sector
and decoder selection remain open."*

### Q2 — Would the arbitrary-spinor Hodge target close a real composition arrow beyond the canonical pair?

`Targets/SpinorHodge.lean` (`arbitrary_pair_class_cost_eq_plucker`,
`arbitrary_pair_controls`, with `SFromPair`, `turnScale`, `wedge`) —
`[s o r r y-target]`, arithmetic `[verified-here]`.

**Verdict: YES — it is a genuine coverage extension from the single canonical
pair `(e0, m·e1)` to an *arbitrary* decorated spinor pair `(psi, phi)`, which is
exactly the arrow needed to feed the six D4 Gaussian spinor decorations into the
mass decoder. But it is still a *supplied dictionary*, not a derivation: the
decoder is defined from the pair. Grade if landed: PARTIAL.**

Detail, re-derived here:
- `SFromPair psi phi := SAt (turnScale psi phi)`, `turnScale psi phi :=
  Real.sqrt (normSq (wedge psi phi))`, `SAt m x := ![0,0,m²·x 2,0]`.
- For `x = e2q + Q chi` (so `x 2 = 1`),
  `B x (SFromPair psi phi x) = turnScale² = (√ normSq(wedge))² = normSq(wedge psi
  phi)` (since `normSq ≥ 0`, `Real.sq_sqrt` applies). That equals the RHS. True
  for every `psi, phi, chi`.
- `arbitrary_pair_controls` is non-vacuous and correct:
  `(canonical0, canonical1(2/5)) ↦ 4/25`, `(canonical0, canonical1(3/5)) ↦ 9/25`,
  and the **collinear zero control** `(canonical0, collinear=![3,0]) ↦ 0`
  (wedge `= 1·0 − 0·3 = 0`). Two nonzero scales + a genuine zero rule out a
  renamed one-point fixture.

**What it closes / does not close:** it removes the "canonical pair only" hidden
restriction of `HodgePluckerMassBridge` — the earlier bridge only spoke about
`edge0, edge1 m`, whereas any Gaussian-integer decoration produced by
`D4NullRaySpinorFactorization` is an *arbitrary* pair. So this is a real
composition arrow "arbitrary decorated pair → its Plücker disagreement → decoder
class cost." It does **not** derive mass: the decoder `SFromPair` is constructed
from the pair via `turnScale`, i.e. the answer is encoded into the decoder — the
same supplied-dictionary status as Q1, now generalized. The `Q`/`B` convention
matches the quartet convention (null `0–1` block, positive `2`, negative `3`;
`Q e1 = e0`, `Q² = 0`), so it composes cleanly with the landed layer.

### Q3 — Does `SummableFourierContinuumLift` prove a countable synthesis theorem, an infinite-volume theorem, or a continuum/PDE theorem?

`SummableFourierContinuumLift` (`infinite_fourier_error_bound`,
`infinite_fourier_tendsto`, `geometric_envelope_witness`) — `[source-only]`,
statement `[verified-here]` by inspection.

**Verdict: a countable synthesis (infinite-mode) error/convergence theorem —
nothing more. It is NOT an infinite-volume theorem and NOT a continuum/PDE
theorem. Grade CLOSED as a countable-synthesis statement; the "continuum" caption
overstates.**

Detail:
- `infinite_fourier_error_bound`: over an arbitrary index `ι` and Banach `E`,
  `‖synthInfinite φ approx − synthInfinite φ exact‖ ≤ ε·∑' k, g k` under
  `Summable g`, `g ≥ 0`, `ε ≥ 0`, `‖φ k‖ ≤ 1`, summability of *both* synthesized
  series (`ha`, `he`), and pointwise `‖approx − exact‖ ≤ ε·g`. The **summable
  envelope `∑' g`** replaces the divergent `card ι` factor of the finite grid —
  a real upgrade to countably many modes.
- `infinite_fourier_tendsto` gives norm convergence for vanishing `ε n`;
  `geometric_envelope_witness` supplies a normalized nonzero envelope
  (`∑' = 1`, positive first term). Consistent and nondegenerate.

**Overreach, precisely:**
1. `ι` is an abstract (at most countable) *mode* index; it is **not** identified
   with position space, momentum space, a volume, or a continuum. There is no
   integral over a continuum of momenta, no `L²`/inverse-Fourier statement, and
   no PDE/propagator. "Continuum lift" is a naming overreach.
2. `ha`/`he` (summability of the synthesized series) are *assumed*: this is a
   relative synthesis-*error* theorem, not an *existence*/convergence-of-synthesis
   theorem — it presupposes the series converge.
3. It does not prove the checkerboard walk supplies the required envelope
   (correctly disclaimed).

Matrix note: `MANUSCRIPT_CLAIM_MATRIX` M5 calls this "countable position-space
convergence." That mildly **overstates** it: the index is an abstract countable
mode set, not position space, and summability of the synthesized series is an
input. The `THEORY_COMPLETION` "Continuum and QFT recovery" row is accurate
("countable norm convergence landed under explicit summability hypotheses").

### Q4 — Does `PositiveSectorIntertwinerInvariance` establish only presentation invariance, or actual physical-sector selection?

`PositiveSectorIntertwinerInvariance` (`Sector`, `sectorEquiv`,
`positive_sector_nonempty_invariant`, `boost`, `boost_preserves_pairing`,
`rational_boost_sector_controls`) — `[source-only]`, statement `[verified-here]`
by inspection.

**Verdict: presentation invariance ONLY. No physical-sector selection. This is
exactly what the module's own docstring says. Grade CLOSED for the invariance
claim; the "sector selection" reading is OPEN.**

Detail: `Sector B := {x // 0 < B x x}` is the *entire* strictly-positive cone of
the supplied form; `sectorEquiv` / `positive_sector_nonempty_invariant` state that
a pairing-preserving linear equivalence `phi` carries that cone to the target
cone and preserves nonemptiness. That is precisely "an isometry of the form
preserves its positive cone" — invariance of the description under a change of
presentation. There is **no** selection principle: nothing singles out a physical
sector among inequivalent pairings, no Krein `J`-decomposition into `±` sectors,
no invariant subspace, no Born/probability rule. The rational Lorentz `boost`
(`!![5/4,3/4;3/4,5/4]`, `det = 1`, `boost_preserves_pairing`,
`rational_boost_sector_controls`: `boost timeUnit ≠ timeUnit`, norm `+1`
preserved, spacelike direction stays `−1`) confirms a boost *moves* a positive
vector while preserving the form — again presentation invariance, not selection.
The module docstring states this verbatim ("This is presentation invariance
only… It does not select a preferred physical sector…"), so caption and kernel
agree. The `THEORY_COMPLETION` "Positivity and probability" row correctly keeps
universal sector selection open.

### Q5 — Is the D4 finite-walk target correctly stated, and can its six-state coin be connected to the four-component Clifford symbol without a new intertwiner/no-go theorem?

`Targets/D4Walk.lean` (`six_roots_are_unit_luminal`, `shift_preserves_inner`,
`coin_preserves_inner`, `walk_preserves_norm`, `nontrivial_shift_control`) —
`[s o r r y-target]`, statements + arithmetic `[verified-here]`.

**Verdict (statement): correctly stated and non-vacuous — but it is a *generic*
discrete-time quantum-walk norm-preservation theorem for an *arbitrary* supplied
`6×6` unitary coin, with no Clifford/Dirac content.**
**Verdict (connection): NO — the six-state coin cannot be connected to the
four-component Clifford symbol without a new intertwiner (or a no-go). This is a
genuine OPEN structural gap.**

Statement audit (all re-derived here):
- `six_roots_are_unit_luminal`: `futureNullRoot d = ![1, s0, s1, s2]` with `s` a
  spatial unit vector, so `minkowskiSq = 1 − 1 = 0` and `Σ sᵢ² = 1`. True for all
  six directions.
- `coin_preserves_inner`: `coin U` mixes only the `Direction` factor at fixed
  position; `Σ_d conj(U d e)·U d f = (UᴴU)_{ef} = δ_{ef}` gives inner-product
  preservation from `Uᴴ U = 1`. True. `shift` is precomposition with a bijection
  (`shiftEquiv.symm`), hence inner-preserving; `walk = shift ∘ coin`, so
  `walk_preserves_norm` follows. Correctly stated.
- `nontrivial_shift_control`: `advance 5 (origin5, 0)` moves the site by
  `![1,0,0]` in `ZMod 5`, `≠ origin5`. True and nontrivial (`NeZero 5`).

Connection audit — three distinct dimensionalities are in play:
- the walk **coin** acts on `Direction = Fin 6` (a `6×6` unitary);
- the landed **Clifford symbol** `Clifford3Plus1WalkSymbol` is `4×4`
  (`H(k,m)² = (|k|²+m²)I`, component velocities `±1`) — a four-component
  Dirac object;
- the D4 spinor **decorations** (`D4NullRaySpinorFactorization`) are
  `2`-component Weyl spinors (`CSpinor = Fin 2 → ℂ`).

`walk_preserves_norm` is proved for a *generic* `6×6` unitary `U`; it never
touches the Clifford algebra, the `4×4` symbol, or the `2`-spinor decorations, and
it does not derive the coin from the null-root data (the null structure enters
only through the six spatial shift vectors). Therefore the physical claim "the D4
walk is the Dirac/Clifford walk" is **not** established: bridging the `6`-dim coin
space to the `4`-dim Dirac space (or the `2`-dim Weyl space) requires an explicit
`6 → 4` (resp. `6 → 2`) intertwiner respecting the unitary/Clifford structure, or
a no-go proving no such structure-preserving map exists. No such theorem is in the
corpus. Until one lands, the six-direction coin and the four-component Clifford
symbol are two unconnected objects sharing only the D4 alphabet.

### Q6 — Vacuities, hidden dictionaries, supplied normalizations, convention mismatches, and matrix rows that over/understate the kernel

**Supplied dictionaries (disclosed; must not be upgraded to derivations):**
1. **`m²` inside the decoder** `quartetSAt` / `SAt` (Q1, Q2): the mass eigenvalue
   is a definitional coefficient, not derived; the former `hmu` lives in the
   definition.
2. **Decoder-from-pair** `SFromPair … = SAt (turnScale …)` (Q2): the arbitrary
   pair's answer `normSq(wedge)` is written into the decoder via `turnScale`.
3. **Transfer normalization = unitarity** (Q-next / `Targets/UnitaryTransfer`):
   `physicalTransfer` is unitary exactly under `c²+s²=1`,
   `normSq uL = normSq uR = 1` (displayed hypotheses — honest).
4. **Spinor decorations + `2/2/2/2/1/1` projective scale**
   (`D4NullRaySpinorFactorization`, carried from Audit-05): the Gaussian spinors
   and the per-ray `rayScale` are hand-assigned; `rankOneHermitian` fixes a null
   direction only up to positive scale, so the specific scale is what makes the
   two sides equal on the nose.
5. **`(+ − − −)` signature with coordinate `0` selected as time** (carried): the
   time axis is selected, not derived.

**Vacuity / weak-quantifier notes:**
- `quartet`/`SpinorHodge` "for every exact representative `chi`": the cost sees
  only component `2`, and `qe2 + Q chi` has component `2 ≡ 1` for all `chi`; the
  class-invariance is real but the quantifier is over a fixed point of the cost
  (Q1.2, `[verified-here]`).
- `D4Walk.walk_preserves_norm` quantifies over an arbitrary unitary coin: broad,
  but the physical (Clifford/Dirac) coin is never singled out (Q5).
- None of the audited statements is vacuously true, uses a contradictory
  hypothesis, or is definitionally `True` (checked; the `Targets` are honest
  non-vacuous claims, currently `s o r r y`).

**Convention consistency (good):** `PositiveHodgePhysicalMass.quartetB` and
`SpinorHodge.B` use the *same* Krein form (null `0–1` block, positive `2`,
negative `3`) and the same `Q` (`Q e1 = e0`, `Q² = 0`); `IsUnitary` is two-sided
in `UnitaryHistoryComposition`, `D4Walk`, and `UnitaryTransfer`. No mismatch.

**Convention overreach (captions outrunning kernels):**
- `SummableFourierContinuumLift` "continuum": abstract countable mode index, not a
  continuum (Q3).
- `PositiveSectorIntertwinerInvariance` "Sector": the whole positive cone, not a
  representation/physical sector (Q4).
- `D4Walk` "D4 null walk": generic quantum walk with D4 shift vectors; no Dirac
  coin (Q5).

**Matrix rows that OVERSTATE the kernel:**
- `MANUSCRIPT_CLAIM_MATRIX` M5 "countable **position-space** convergence" — the
  index is an abstract countable mode set, and summability of the synthesized
  series is assumed (Q3).
- `MANUSCRIPT_CLAIM_MATRIX` M6 "twelve … explicit spinor factors" — the
  factorization decorates only the **six future** axial rays; the twelve are
  *roots*, not twelve spinor decorations (carried from Audit-05).
- Any reading of the three `Targets/` statements
  (`SpinorHodge.arbitrary_pair_*`, `D4Walk.walk_preserves_norm`,
  `UnitaryTransfer.physicalTransfer_*`) as achieved overstates them: they are
  `s o r r y` (F0.3).

**Matrix rows that UNDERSTATE / are accurate:**
- `THEORY_COMPLETION` "Quantum composition" says "physical checkerboard-transfer
  unitarity job running" — accurate: `Targets/UnitaryTransfer` is exactly that job
  and is still `s o r r y` (OPEN). The general consumer
  (`UnitaryHistoryComposition.replicated_history_operator_unitary`) has already
  landed, so only the gate arrow remains.
- `MANUSCRIPT_CLAIM_MATRIX` has **no row** for the three current `Targets/`
  statements. Add them as OPEN rows (arbitrary-pair mass extension; D4 walk
  norm-preservation + coin↔Clifford intertwiner gap; physical-transfer unitarity)
  so the control surface tracks the live frontier.

---

## CLOSED / PARTIAL / OPEN summary

| Item | Module / target | Status here | Grade | One line |
|---|---|---|---|---|
| F0 | build surface + guards | `[source-only]` / stub | **OPEN (MED)** | only `Audit/Core.lean` (`= True`) builds; 6 snapshots import absent files; 3 targets are `s o r r y` |
| Q1 | `quartetSAt` + `parameterized_quartet_class_cost_eq_canonical_plucker` | `[source-only]` | **CLOSED\* / PARTIAL** | derives class-invariance + `m↦m²` on a family; `m²` baked into decoder, `x 2≡1`, decoder not derived |
| Q2 | `SpinorHodge.arbitrary_pair_class_cost_eq_plucker` | `[s o r r y-target]` | **OPEN** (→ PARTIAL) | extends bridge canonical→arbitrary pair (feeds D4 decorations); decoder still supplied via `turnScale` |
| Q3 | `SummableFourierContinuumLift.infinite_fourier_error_bound` | `[source-only]` | **CLOSED\* / PARTIAL** | true countable synthesis bound; NOT infinite-volume, NOT continuum/PDE; series-summability assumed |
| Q4 | `PositiveSectorIntertwinerInvariance.positive_sector_nonempty_invariant` | `[source-only]` | **CLOSED\* / PARTIAL** | presentation invariance only; no sector selection, no Born |
| Q5a | `D4Walk.walk_preserves_norm` | `[s o r r y-target]` | **OPEN** (→ CLOSED, generic) | correctly stated norm-preservation for an arbitrary `6×6` unitary coin |
| Q5b | six-state coin ↔ `4×4` Clifford symbol | not in corpus | **OPEN** | needs a new `6→4` (or `6→2`) intertwiner or a no-go; absent |
| Q-next | `UnitaryTransfer.physicalTransfer_unitary` (+ history) | `[s o r r y-target]` | **OPEN** (→ CLOSED) | exactly Audit-05's named next arrow; true, with rational witness + real non-unitary control |

`*` = source-only in this package; live-tree guard reported by the task but not
executable here.

---

## Strongest honest end-to-end chain after the landed keystones

Every arrow is real; each carries its true status. The chain is *source-level*
(F0) and it stops being quantum / physical at named supplied arrows.

```
selected D4 null shell (12 axial null roots, decidable)               [prior, verified]
  → 6 future axial null rays decorated by Gaussian 2-spinors,
     rankOneHermitian(spinor r) = pauliHalf(scaledRoot r)             [D4NullRaySpinorFactorization  CLOSED*, supplied 2/2/2/2/1/1 scale]
  → one-parameter indefinite-Krein nilpotent fixture family:
     for every m and every exact representative, class cost = m²
     = normSq(wedge(e0, m·e1)),  4/25 ≠ 9/25 controls                 [quartetSAt + parameterized bridge  CLOSED*/PARTIAL — decoder supplied]
  ⟂ decoder / scale / positive-sector selection from dynamics        [SUPPLIED / OPEN]
  (⤳ if SpinorHodge lands: same equality for an ARBITRARY decorated
      pair — closes canonical→arbitrary coverage, still supplied)     [Q2 OPEN → PARTIAL]

  ‖ any history of two-sided-unitary gates is unitary
     (sequential, parallel/Kronecker, replicated)                     [UnitaryHistoryComposition  CLOSED*]
  ⟂ unitarity of the physical checkerboard transfer gate             [OPEN — UnitaryTransfer target is exactly this arrow]

  positive cone of a real pairing is preserved by any
     pairing-preserving equivalence (presentation invariance)         [PositiveSectorIntertwinerInvariance  CLOSED*]
  ⟂ invariant physical-sector selection + Born rule                  [OPEN]

  countable Fourier synthesis error bound + norm convergence
     under a summable mode envelope                                   [SummableFourierContinuumLift  CLOSED*]
  ⟂ walk-specific envelope + infinite-volume / L² / PDE recovery     [OPEN]
```

Net: two supplied dictionaries (`m²` inside the decoder; transfer-gate
unitarity) and one missing bridge (`6→4` coin↔Clifford intertwiner) separate this
from checked chains "null directions → mass API" and "primitive path sum →
unitary finite-history evolution." The `3+1` Clifford *walk* (as opposed to the
algebraic symbol), position-space/PDE continuum, sector selection, and Born rule
remain outside the chain (OPEN).

---

## One exact next theorem (highest value)

Close the single arrow that upgrades the *entire* quantum-composition layer from
PARTIAL to CLOSED and whose general consumer has already landed
(`UnitaryHistoryComposition.replicated_history_operator_unitary`): prove the
physical checkerboard transfer gate is two-sided unitary under its displayed
normalization. This is already written as the self-contained s o r r y-target
`Targets/UnitaryTransfer.physicalTransfer_unitary`; landing it (and its history
corollary) is the minimal, highest-leverage move.

```lean
-- Targets/UnitaryTransfer.lean  (imports: Mathlib only; self-contained)
theorem physicalTransfer_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1) :
    IsUnitary (physicalTransfer c s uL uR) := by
  s o r r y   -- re-derived true here: (Uᴴ U)_{ll}=c²|uL|²+s²|uR|²=1, off-diag=0, etc.

-- corollary via the ALREADY-LANDED replicated/history laws:
theorem physical_transfer_history_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1) (hL : Complex.normSq uL = 1)
    (hR : Complex.normSq uR = 1) (n : ℕ) :
    IsUnitary (historyOperator (List.replicate n (physicalTransfer c s uL uR))) := by
  s o r r y
```

- **Witness (mandatory, nondegenerate; already present as
  `rational_massive_transfer_controls`):** `(c,s) = (3/5, 4/5)`, `uL = 1`,
  `uR = I` gives an exact two-sided unitary with `physicalTransfer 3/5 4/5 1 I ≠ 1`
  (nontrivial), while the real symmetric `wrongRealTurnTransfer`
  (`3/5` diagonal, `4/5` off-diagonal) is **not** unitary. Re-derived here:
  `(3/5)²+(4/5)² = 1`, diagonal `UᴴU` entries `= 1`, off-diagonal `= 0`; the wrong
  control has row-norm `9/25+16/25=1` but a nonzero off-diagonal overlap, so it
  fails. `physicalTransfer_eq_turnTransfer` then identifies it with the
  checkerboard `turnTransfer (i·s/c)` (attaching it to the primitive path-sum
  layer).
- **Kill / falsifier:** if no normalization of `(c, s, uL, uR)` makes
  `physicalTransfer` two-sided unitary, OR if `physicalTransfer_eq_turnTransfer`
  fails (the checkerboard corner/phase convention is not this matrix), then the
  checkerboard evolution is not the claimed unitary transfer: the operator-history
  layer of M5 must be restated around a contraction / CP map, and the "unitary
  histories" headline retracted to a non-unitary transfer statement.

This converts Q-next (and `THEORY_COMPLETION` "Quantum composition") from PARTIAL
to CLOSED, discharges the last non-landed dependency of the quantum-composition
chain, and is strictly smaller than either the mass-keystone extension
(`SpinorHodge`, which still leaves the decoder supplied) or the `6→4`
coin↔Clifford intertwiner (Q5b, which likely needs new structure or a no-go).
Prerequisite for the *guard* (not for the math): vendor the transfer/history
upstreams so the theorem and its a x i o m guard build in-package.
