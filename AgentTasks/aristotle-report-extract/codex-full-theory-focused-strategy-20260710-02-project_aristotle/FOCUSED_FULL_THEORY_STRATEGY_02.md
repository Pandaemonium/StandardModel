# FOCUSED FULL THEORY STRATEGY 02

Codex focused strategy pass, 2026-07-10. Read-only synthesis; no Lean was built
or edited. Sources consulted in full: `RUN_PLAN.md`,
`THEORY_COMPLETION_MATRIX.md`, `MANUSCRIPT_CLAIM_MATRIX.md`,
`SIMULATION_BENCHMARKS.md`, the three latest Aristotle reports
(`2026-07-10_ARISTOTLE_GRAND_STRATEGY_01.md`,
`2026-07-10_ARISTOTLE_ARCHITECTURE_AUDIT_01.md`,
`2026-07-10_ARISTOTLE_LANDING_AUDIT_01.md`), and all new Lean sources under
`Strategy/Inputs` (`CheckerboardAmplitudeGluing.lean`,
`CanonicalGramTurnDictionary.lean`, `FixedMomentumManyStepContinuum.lean`,
`PositiveHodgeClassCostNoGo.lean`, `NullFactorizationSpinFiber.lean`,
`WAYChargeExchangeWitness.lean`).

Grade legend (matrix-compatible): `D` derived in-kernel from earlier layers;
`M` machine-verified finite fact; `H` conditional theorem, hypotheses displayed;
`I` imported law/dictionary/constant; `B` bridge conjecture with finite avatar
and kill; `O` open, interface not yet fixed; `K` killed route.

---

## 0. Thesis and verdict

**Thesis (state it boldly).** Invariant mass is the pairwise disagreement of null
directions; a finite null history assigns that disagreement to the corners of a
unitary walk; the walk's continuum limit is the Dirac evolution; and the
disagreement value is a gauge-class invariant of a positive decoder. One
observable — the fixed-momentum massive dispersion `omega(k;m)` with
`m^2 = det P = |psi_R wedge psi_L|^2` — now sits at the end of a chain in which
**five of the seven arrows are landed kernel-clean theorems**, not prose.

**Verdict (classify it honestly).** The five new landings convert the "coexisting
vignettes" verdict of the grand-strategy and architecture audits into **one
almost-composed spine**. What they supply is real: a composition (gluing) law, a
scale-bearing Gram-to-turn dictionary, a fixed-momentum continuum limit, an
operational-locality identity, and a class-invariance theorem. What they do
*not* yet supply is a single shared object threaded through all arrows: the
gluing law is scalar, the dictionary is on a hand-chosen spinor pair, the
class-invariance value is an eigenvalue input, and the continuum limit is
fixed-`k`. The honest state is therefore **one executable observable reachable
through a chain with exactly seven arrows, five landed and two-plus still
missing at the joints**. This document gives the shortest such chain and, for
each missing arrow, one exact theorem, one mandatory nondegenerate witness, one
kill condition, and the manuscript sentence it licenses.

The class-cost landing (`PositiveHodgeClassCostNoGo`) also **kills** a headline:
under radicality, nilpotence, and decoder descent the least-cost/variational
mass is *not* minimized over exact representatives — the cost is *constant* on
the class. Positive spectral mass survives as an **invariant**, not as a
variational selection. The manuscript must retire "variational least-cost mass"
and lead with "class-invariant spectral mass."

---

## 1. The one executable observable

> **O_star — fixed-momentum massive dispersion.**
> For null step directions with spinors `psi_R, psi_L`, set
> `m^2 := det(psi_R psi_R^H + psi_L psi_L^H) = |psi_R wedge psi_L|^2`.
> The observable is the quasienergy / dispersion `omega(k; m)` of the continuum
> generator `H(k,m) = k*sigma_z + m*sigma_x`, obtained as the `n -> infinity`
> limit of the glued unitary null-history walk at fixed momentum `k`, satisfying
> the mass shell `omega^2 = k^2 + m^2`.

`O_star` is executable *now*: it is numerically regressible against landed Lean
theorems via benchmark `S01` (exact `det P`, wedge, rank), `S05` (exact
checkerboard walk / dispersion), and `S07` (mass shell, subluminal drift), plus
a fixed-momentum step-count sweep against
`FixedMomentumManyStepContinuum.fixed_time_many_step_bound` (the explicit
`Dkm k m * t^2 / n` tail is the pass tolerance). No continuum PDE, no
uniform-in-`k` estimate, and no `3+1` lift are required to *report* `O_star`; those
are required only to *extrapolate* it (arrow A5 below).

Why this observable and not another: it is the unique quantity that (i) is built
only from primitive null-direction data, (ii) is touched by *all five* new
landings, and (iii) already has exact-arithmetic oracles. It is the shortest
executable end of the mass-kinematics spine that the audits identified as the
one genuinely composed sub-theory.

---

## 2. The shortest implication chain (primitive -> O_star)

Seven arrows. Each is marked with its grade and, when landed, the exact
declaration that realizes it. Missing arrows are labelled `A1..A7` and specified
in §4.

```
(1) primitive null history  h : NullHist
        | [O; missing A7: no primitive-ontology type in kernel]
        v
(2) amplitude of a composed history factorizes
        Z(h1 ++ h2) = Z(h1) * Z(h2)
        | [M LANDED  CheckerboardAmplitudeGluing.pathAmplitude_append]
        | [operator/monoidal/dagger upgrade: missing A2]
        v
(3) corner-mass parameter = null-direction disagreement
        Q_T m = complexify(det P . I),  m^2 = |psi_0 wedge psi_1|^2
        | [H LANDED  CanonicalGramTurnDictionary.free_mass_operator_eq_complexified_turn]
        | [dictionary is scale-bearing: fixed_pair_cannot_encode_two_turn_scales]
        | [history-step-directions -> the spinor pair: missing A1]
        v
(4) that mass is a gauge-class invariant spectral value
        { B(h+Q chi)(S(h+Q chi)) } = { mu2 }   (singleton)
        | [M LANDED  PositiveHodgeClassCostNoGo.class_cost_set_eq_singleton]
        | [identify mu2 with det P: missing A3; positive-sector selection: missing A4]
        v
(5) fixed-momentum walk converges to Dirac evolution
        walk(k eps, m eps)^n -> exp(-i t H(k,m)),  omega^2 = k^2 + m^2
        | [M LANDED  FixedMomentumManyStepContinuum.fixed_time_many_step_tendsto]
        | [uniform-in-k / spacetime propagator: missing A5]
        v
(6) EXECUTABLE OBSERVABLE  O_star = omega(k; m),  m^2 = det P
        [regressible: S01 + S05 + S07 + step-count sweep]
```

Lateral supports (they make `O_star` a *local, spin-carrying,
charge-conserving one-particle* observable rather than a bare scalar; each is
conditional):

- **Operational locality.** `FiniteNoSignaling.partialTraceB_applyLocalKrausB`
  and `TwoRegionTensorMicrocausality`: a trace-preserving local Kraus operation
  on `B` fixes the `A`-marginal exactly. Honest scope (landing audit): this is
  an identity for a *supplied* tensor factorization over *arbitrary* matrices,
  not emergent spacetime locality. Missing arrow A2' = derive the factorization
  from history disjointness.
- **Spin fiber.** `NullFactorizationSpinFiber.factorization_fiber_special_unitary`:
  the factors of a fixed momentum Gram form a torsor under `SU(2)` (the massive
  little group), with an explicit nondegenerate orbit witness. Honest scope: the
  algebraic `U(2)/SU(2)` fiber only — no spin representation, Wigner rotation, or
  spin-statistics. Missing arrow A6.
- **Charge reservoir.** `WAYChargeExchangeWitness.constructive_charge_reservoir_witness`:
  a nontrivial unitary swap conserves total binary charge and performs the basis
  turn that the WAY no-go forbids for a system-only flip. Honest scope: a
  basis-transition reservoir witness — not a weak-charge representation and not a
  Higgs mass. Feeds the interaction layer, not `O_star` directly.

**Composed today:** arrows (2),(3),(4),(5) are landed as named kernel-clean
theorems (`[propext, Classical.choice, Quot.sound]` only, per each module's
`#print axioms` guard). **Not composed today:** arrow (1) has no object (A7); the
joints between (2)-(3)-(4) share only symbols, not objects (A1, A2, A3); the
positive sector in (4) is selected, not derived (A4); the limit in (5) is
fixed-`k` (A5). The chain is *nearly* end-to-end; it is not yet a single theorem
with one shared witness.

---

## 3. The five landings, classified

| Landing | Arrow served | Grade | What it proves | Honest boundary |
|---|---|---|---|---|
| `CheckerboardAmplitudeGluing` | (2) monoidal spine | `M` | `pathAmplitude(h1++h2) = pathAmplitude(h1) * pathAmplitude(terminalDir, h2)`; turn counted once at the seam; nonzero two-segment witness | Scalar Gaussian-rational amplitude only; not an operator/tensor/dagger functor; not a continuum composition |
| `CanonicalGramTurnDictionary` | (3) Gram=turn | `H` | Under the canonical pair `(e0, m e1)`: `Q_T m = complexify(det P . I)`, `det P = m^2`; rational witness `9/25`; fixed-pair control forbids encoding two scales | The scale dictionary is *imported* input, not derived from histories; step-directions -> pair is missing |
| `FixedMomentumManyStepContinuum` | (5) continuum | `M` | `walk^n -> exp(-i t H(k,m))` at fixed `k`, explicit tail `Dkm k m t^2/n`, both steps unitary, unitary telescope (no exp-in-`n` loss) | Fixed momentum, `L2` `2x2` operator norm; not a spacetime propagator, not uniform-in-`k`, not `3+1` |
| `PositiveHodgeClassCostNoGo` | (4) class invariance | `M` + `K` | Exact directions have zero spectral pairing; class cost set `= {mu2}` singleton; landed projection witness is *not* nilpotent; nilpotent `4/25` positive-class witness | **Kills** variational least-cost mass under radicality+nilpotence+descent: cost is constant, not minimized; `mu2` is still an eigenvalue *input* |
| `NullFactorizationSpinFiber` | lateral: little group | `M` | Same-Gram factors are `M0 U`, `U` unique in `U(2)`; det-fixed => `SU(2)`; explicit `SU(2)` orbit witness | Algebraic little-group fiber only; no spin rep / statistics |
| `WAYChargeExchangeWitness` | lateral: reservoir | `M` | Unitary swap conserves total charge and exchanges basis charge; trivial-ancilla flip fails the same test | Basis reservoir only; no weak-charge rep, no Higgs mass |

The two most consequential facts for the manuscript: (a) the Gram-to-turn
dictionary is **conditional on an imported scale**, proved necessary by
`fixed_pair_cannot_encode_two_turn_scales` — so "mass = turns = wedge" is a
theorem *after* the dictionary is displayed, never before; (b) the class-cost
no-go **retires** the variational-mass headline and replaces it with a stronger,
honest one: mass is a **class invariant**.

---

## 4. The missing arrows

Each arrow: exact theorem shape (Lean-ready pseudocode), the mandatory
nondegenerate witness that must accompany it, the kill condition that would
falsify the arrow, and the single manuscript sentence it would license. These
are the *only* statements standing between the present corpus and one end-to-end
composed theorem; they are ordered by architecture-closure per proof.

### A1 — History step directions determine the mass Gram (welds arrow 3 to arrow 2)

- **Exact theorem.**
  `theorem turn_is_step_disagreement (psiR psiL : CSpinor) :`
  `  DiracWalkCarrier.turnParam psiR psiL ^ 2`
  `    = complexAbsSq (spinorWedge psiR psiL)`
  `    = (Matrix.det (psiR *ᵥ psiRᴴ + psiL *ᵥ psiLᴴ)).re`
  i.e. the checkerboard corner-mass parameter is *defined by* the two step
  spinors and equals their null-direction disagreement (not merely equal for the
  hand-chosen `(e0, m e1)`).
- **Mandatory nondegenerate witness.** The R/L step spinors realizing the nonzero
  one-turn history `[right, left, right]` with `det > 0` (reuse
  `CheckerboardAmplitudeGluing.two_segment_turn_gluing_witness` for the seam turn
  and a rational pair with `det P = 4/25`); it must exclude `m = 0` and
  straight-only histories.
- **Kill condition.** Exhibit admissible step spinors with `m != 0` but
  `spinorWedge psiR psiL = 0` (collinear steps). If that configuration is legal,
  "mass = turns" and "mass = wedge" are genuinely different objects and A1 is
  false.
- **Manuscript sentence.** "The checkerboard corner-mass parameter is exactly the
  pairwise null-direction disagreement of the walk's two step directions, so the
  history's dynamics and the state's kinematic mass are one number."

### A2 — Operator-valued monoidal dagger functor (upgrades arrow 2)

- **Exact theorem.**
  `theorem transfer_functor (h1 h2 : List Gate) :`
  `  T (h1 ++ h2) = T h1 * T h2  ∧  T (par h1 h2) = T h1 ⊗ₖ T h2`
  `    ∧  T (reverse (dagger h)) = kreinAdjoint J (T h)`
  where `T` is the ordered product of `2x2` transfer/turn gates (the operator
  lift of `pathAmplitude`).
- **Mandatory nondegenerate witness.** A two-segment history with a turn at the
  gluing seam whose operator product is nonzero and *non-diagonal* (so the seam
  turn is visible at operator level, not just in a scalar phase); the empty
  history maps to `1`.
- **Kill condition.** Non-associative gluing, a gate class breaking
  `List.prod`-multiplicativity, or `dagger` not matching the Krein adjoint on the
  witness.
- **Manuscript sentence.** "Concatenation of null histories is operator
  multiplication, disjoint union is tensor product, and orientation reversal is
  the Krein adjoint: the amplitude assignment is a monoidal dagger functor, so
  superposition and composition are not extra postulates."

### A3 — Class-invariant spectral value equals the kinematic `det P` (welds arrow 4 to arrow 3; keystone)

- **Exact theorem.** For the free carrier built from a null spinor pair with Gram
  `P`, the (now class-invariant, per `class_cost_set_eq_singleton`) decoder value
  of the harmonic representative equals the kinematic invariant:
  `theorem class_value_eq_detP (P built from psi0 psi1) :`
  `  mu2_of_class [harmonic psi] = (P.det).re = |psi0 wedge psi1|^2`.
  This is the corrected keystone: since minimization is killed, the claim is
  *identity of the class invariant with `det P`*, not *attainment of an infimum*.
- **Mandatory nondegenerate witness.** A shared rational fixture in which
  `PositiveHodgeClassCostNoGo.nilpotent_positive_class_witness` (surviving `e2`
  class, cost `4/25`) and `CanonicalGramTurnDictionary.rational_dictionary_witness`
  (`det P = 9/25` at `m = 3/5`, or a matched `4/25` pair) name the **same** `mu2`
  and the **same** `det P`; control = collinear pair, `det P = 0`, cost `0`.
- **Kill condition.** The harmonic representative's class value differs from
  `det P` for some rational witness; or the positive representative set is empty
  (the confinement branch — a *feature*, to be reported separately).
- **Manuscript sentence.** "Physical mass is a cohomology-class invariant: the
  positive decoder assigns each class the single spectral value `det P` of its
  null-direction Gram, independent of gauge representative — mass is neither
  chosen nor minimized, it is invariant."

### A4 — Invariant positive-sector existence / normalized state rule (arrow: gauge class -> physical state)

- **Exact theorem.**
  `theorem invariant_positive_sector (Q J S) (hQQ : Q∘Q=0) (hJ : J∘J=1) :`
  `  ∃ W ≤ ker Q / im Q, W is J-positive, maximal, and Aut(Q,J,S)-invariant, W ≠ 0`
  together with the normalized rule `p = J-pairing / J-norm` on `W`.
- **Mandatory nondegenerate witness.** The `e2` class with positive Krein norm
  (`Jpos` sector) invariant under the decoder automorphism group; control = the
  matched-sign `Jneg` fixture from `KreinHodgeNoGo` giving an empty positive
  sector.
- **Kill condition.** The invariant positive sector is empty or indefinite for a
  configuration with `m^2 > 0` (would collapse the state layer); or positivity is
  provably *derivable* without extra data (would make the hypothesis redundant —
  currently `hodge_without_positivity_no_go` shows it is independent).
- **Manuscript sentence.** "Physical states are the invariant `J`-positive
  cohomology classes and probability is `J`-pairing normalization, gated on the
  explicitly named positivity/Born input `H_Born` — which the theory imports, not
  derives."

### A5 — Uniform-in-momentum continuum limit (upgrades arrow 5 toward a propagator)

- **Exact theorem.**
  `theorem uniform_continuum (t : ℝ) :`
  `  Tendsto (fun n => sup_{k ∈ K} ‖walk(k t/n, m t/n)^n - exactFlow k m t‖) atTop (𝓝 0)`
  on every compact band `K`, with an explicit modulus refining `Dkm k m t^2/n`;
  then microcausal cone from the band-limited propagator.
- **Mandatory nondegenerate witness.** The `3-4-5` fixed-momentum witness extended
  across a rational momentum band, with `massless_exact_control` as the exact
  (zero-error) negative control at `m = 0`.
- **Kill condition.** No uniform bound (the constant degrades exponentially in
  `k`, so the sup diverges), or the band limit is not the Dirac generator
  `H(k,m)`.
- **Manuscript sentence.** "The finite null-history walk converges, uniformly on
  compact momentum bands, to the continuum Dirac evolution — extending the exact
  fixed-momentum limit to a genuine propagator (still `1+1`; `3+1` open)."

### A6 — Little-group action induces spin (upgrades the spin-fiber lateral support)

- **Exact theorem.**
  `theorem little_group_spin :`
  `  the SU(2) fiber of NullFactorizationSpinFiber is the image of the decoder`
  `  automorphism group acting on momentum-Gram factors, and its irreps label`
  `  half-integer spin; plus one exchange-phase theorem or a spin-statistics no-go`.
- **Mandatory nondegenerate witness.** `NullFactorizationSpinFiber.witnessFactor`
  (nontrivial det-fixed `SU(2)` orbit point) as the spin-`1/2` generator; control
  = the massless boundary `det = 0` where the fiber degenerates.
- **Kill condition.** The decoder automorphism group does not act on the fiber as
  `SU(2)`, or no consistent exchange phase exists on multi-history states.
- **Manuscript sentence.** "The massive one-particle fiber carries a canonical
  `SU(2)` little-group action whose irreducibles are the spin sectors; a particle
  species is a positive class together with its little-group representation."

### A7 — Primitive null-history ontology and its amplitude functor (arrow 1; the ground floor)

- **Exact theorem.**
  `structure NullHist` (finite oriented null events/edges, spinor decorations,
  labels, gluing `++`, tensor `par`, dagger) together with
  `def Z : NullHist -> Krein` such that the mass Gram `P`, the walk transfer
  operator `T`, and the decoder `(Q,J,S)` are all `Z` applied to *explicit*
  histories, and a redundancy relation `h ≈ h'` iff `Z h = Z h'` up to the stated
  gauge.
- **Mandatory nondegenerate witness.** The smallest nontrivial history (e.g. the
  one-turn `[right,left,right]`) enumerated with its invariants, mapped by `Z`
  onto the existing `det P = 4/25` fixture; control = a straight-only history with
  `det P = 0`.
- **Kill condition.** Two inequivalent primitive histories map to identical
  physical data with no redundancy relation accounting for it (over-counting), or
  one physical state has no primitive history preimage (under-generation).
- **Manuscript sentence.** "Reality is a finite category of oriented null
  histories; states, amplitudes, mass, spin, and geometry are all values of a
  single amplitude functor on that category — the theory's one primitive."

---

## 5. Order of attack (maximum closure per proof)

1. **A1** (turn = step disagreement) and **A3** (class value = `det P`): together
   they thread `det P` through arrows 3-4 and make "mass" one object. Highest
   coherence gain; both reuse landed rational fixtures.
2. **A2** (operator functor): lifts the scalar gluing to the monoidal spine;
   unlocks composition of `O_star` across histories.
3. **A5** (uniform continuum): turns the fixed-`k` limit into a propagator; the
   only arrow needed to *extrapolate* `O_star`.
4. **A4** (invariant positive sector): removes the last selected input on the
   state arrow; enables the honest Born statement.
5. **A6, A7**: reach — spin representation and the primitive ontology that closes
   arrow 1.

Landing A1+A3 alone converts the chain from "five landed arrows sharing symbols"
to "one composed sub-theory sharing one witness (`det P`)", which is the
`THEORY_COMPLETION_MATRIX` composition-test deliverable.

---

## 6. Honesty ledger (imported / conditional / killed)

- **Imported (`I`), must be labelled, consequences are not predictions.** The
  scale dictionary of arrow 3 (`fixed_pair_cannot_encode_two_turn_scales` proves
  it cannot be avoided); Minkowski signature and the spinor-helicity dictionary
  `|wedge|^2 = 2 p_i . p_j`; the Dirac operator as the *target* of arrow 5; the
  Born/positivity input `H_Born` in A4; the supplied tensor factorization behind
  operational locality.
- **Conditional (`H`), hypotheses on the face of the theorem.** Arrow 3
  (canonical scale dictionary); A3/A4 (radicality, nilpotence `Q∘Q=0`, descent
  `[S,Q]=0`, `J`-positive sector nonempty). Note that `class_cost_set_eq_singleton`
  needs exactly these — the same hypotheses that kill the variational story.
- **Killed (`K`), remove from headlines.** Variational least-cost mass over exact
  representatives (constant on the class under the stated hypotheses); "generates
  Lambda" (RG self-consistency round-trip, per landing audit); "everything moves
  at `c`" as a universal claim (principal-symbol statement only); any "complete
  theory" / cosmology headline while arrows A4/A5/A7 are open.
- **Derived and safe to lead (`M`/`D`).** `det P = sum |wedge|^2` (Cauchy-Binet);
  `detP_unique` (the anti-cherry-pick: the determinant is forced by universal
  null-vanishing); the four landed spine arrows (2),(3),(4),(5); operational
  no-signaling as an *operational identity* (not a physics no-signaling theorem
  over density matrices — landing-audit caveat).

---

## 7. The manuscript paragraph the completed chain licenses

Written to be *earned* once A1 and A3 land (the rest gated explicitly):

> "In the finite null-information theory, a particle's mass is the disagreement
> of its constituent null directions. Concretely, `m^2 = det P = |psi_R wedge
> psi_L|^2` for the two null step directions of its history; this same number is
> the corner weight that a unitary null-history walk deposits at every turn
> (`CanonicalGramTurnDictionary`, A1), a gauge-class invariant of the positive
> decoder that is invariant rather than minimized
> (`PositiveHodgeClassCostNoGo`, A3), and the mass gap of the continuum Dirac
> evolution recovered as the many-step limit of that walk at fixed momentum
> (`FixedMomentumManyStepContinuum`). The chain from primitive null history to
> the executable dispersion `omega^2 = k^2 + m^2` is composed of named,
> kernel-checked theorems; its remaining seams — an operator-level history
> functor, an invariant positive-sector selection, a uniform-in-momentum
> continuum limit, and the primitive-ontology object itself — are stated as
> exact theorems with witnesses and kill conditions, not deferred as future
> work."

Every clause above is either landed today or named in §4 with its exact theorem,
witness, and falsifier. That is the difference between a candidate theory with an
honest edge and an atlas hoping its regions are one continent.

END OF STRATEGY.
