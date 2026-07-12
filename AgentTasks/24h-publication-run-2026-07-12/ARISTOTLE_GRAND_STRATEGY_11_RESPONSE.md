# Grand strategy 11 — three decisive theorem chains for Gates B, D, F

Adversarial, publication-oriented. Scope respected: the corrected `(1 + tz^2)^2`
chart factor is mandatory in every B ideal-membership statement; the omitted
`z = -1` boundary is **not** empty (it contains the exact alias `(-1,1,-1)`);
D point-evaluation is provably not an `L2` operator; F open-disk uniqueness is
basis-relative, not canonical. None of the already-landed results below are
re-proposed — they are used as compositional inputs.

Bottom line up front. Three theorem chains, one per gate, each of which flips a
grade cell in `PAPER_GATE_MATRIX.md` and legitimately upgrades a manuscript
claim. Ranked by expected publication yield per unit risk:

1. **B — kernel census capstone** (highest yield: turns an oracle census into a
   theorem and repairs a live scientific error before referees find it).
2. **D — strong-convergence + intertwining bridge** (turns "contraction, but"
   into an actual continuum limit; the single largest open manuscript gap).
3. **F — locality/dynamics selector or sharp residual-moduli theorem** (either a
   genuine selection theorem or the honest impossibility statement; both are
   publishable, and one of them is mandatory to stop overclaiming).

Everything else in the portfolio (A/A′ freeze, C freeze, E, G, Jordan–Clifford)
is deliberately excluded: it is either frozen or not on the critical path to
closing B/D/F.

---

## CHAIN B — Complete kernel-checked stationary-Weyl identity-crossing census

### Strategic thesis

Gate B already owns everything *except a theorem that ties the pieces together
over the whole torus*. The affine-chart interior is classified in Lean; the
seven `z=-1` strata and the corrected ideal certificate are external CAS only.
The referee-facing weakness is twofold: (a) the census is "oracle" grade, and
(b) a prior memo asserted the `pi`-boundary has no identity root — which is
**false**. The exact oracle finds the nondegenerate alias `weylStep(-1,1,-1)=I`.
This must be landed as a Lean theorem *before* any "complete classification"
prose ships, or the paper is one Groebner reduction away from retraction.

### Landed inputs to compose (do not re-prove)

From `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`:
`weylStep`, `weylStep_unitary`, `weylStep_one`, `exists_stationary_amplitude_isotropic_weyl_fixture`,
`axis_gammaZero_nonzero`.
From `StationaryAmplitudeWeylRootClassification.lean`:
`rootPoly`, `excludedPoly`, `rootPoly_existsUnique_real`, `excludedPoly_pos`,
`real_elimination_factor_iff`.
From `StationaryAmplitudeWeylAlgebraicOffAxisAlias.lean`: `unitPhase`,
`unitPhase_on_circle`, `unitPhase_ne_one_of_ne_zero`, `tangent_coordinates_nonzero`,
`walkN`/`scalar_cancel` (the tangent-chart matrix normal form).
From `StationaryAmplitudeWeylAlias.lean` / `...ExactOffCornerAlias.lean`: the
existing interior aliases.

### Theorem shapes (three sub-lemmas + capstone)

**B1 — chart-cleared ideal identity (the corrected certificate, as a `ring`
identity).** State exactly the chart-cleared form; the bare product is false and
must never be a Lean theorem.

```lean
theorem stationaryWeyl_chartCleared_ideal_identity (tx ty tz : ℚ) :
    (1 + tz ^ 2) ^ 2 * tz * certRootPoly tx ty tz * certExcludedPoly tx ty tz
      = certQx tx ty tz * certFx tx ty tz
      + certQy tx ty tz * certFy tx ty tz
      + certQz tx ty tz * certFz tx ty tz := by
  ring
```

`certQx/certQy/certQz` come verbatim from the sidecar's `--emit-lean` output
(degrees 18/17/18; SHA-256 pinned in the certificate memo). This is a pure
`ring` check — zero search risk once the coefficients are transcribed. Pair it
with the real-cancellation corollary already available via `excludedPoly_pos`
and `1 + tz^2 > 0` to recover the real elimination implication *without* the
false membership claim.

**B2 — seven-stratum boundary chart lemmas** (transcendental-free), exactly as
enumerated in the boundary-oracle memo:

```lean
theorem no_x_boundary_identity  (ty tz : ℝ) : weylStep (-1) (tangentPhase ty) (tangentPhase tz) ≠ 1
theorem no_y_boundary_identity  (tx tz : ℝ) : weylStep (tangentPhase tx) (-1) (tangentPhase tz) ≠ 1
theorem no_z_boundary_identity  (tx ty : ℝ) : weylStep (tangentPhase tx) (tangentPhase ty) (-1) ≠ 1
theorem no_xy_boundary_identity (tz : ℝ)    : weylStep (-1) (-1) (tangentPhase tz) ≠ 1
theorem no_yz_boundary_identity (tx : ℝ)    : weylStep (tangentPhase tx) (-1) (-1) ≠ 1
theorem xz_boundary_identity_iff (ty : ℝ)   : weylStep (-1) (tangentPhase ty) (-1) = 1 ↔ ty = 0
theorem all_neg_one_not_identity            : weylStep (-1) (-1) (-1) ≠ 1
theorem weylStep_neg_one_one_neg_one        : weylStep (-1) 1 (-1) = 1
```

Each reduces, after `tangentPhase` clearing (multiply by `(1+t^2)` on each live
axis, which is nonzero), to a polynomial system whose reduced lex Groebner basis
is `⟨1⟩` (empty variety ⇒ `≠ 1`) or `⟨ty⟩` (⇒ `ty=0`). The exact primitive
numerators `Fx,Fy,Fz` per stratum are already printed in the oracle memo; feed
them as `important_additional_prompt_context`.

**B3 — chart surjectivity.** Every unit complex phase `≠ -1` has a real tangent
coordinate:

```lean
theorem unit_phase_ne_neg_one_has_tangent (z : ℂ) (hz : normSq z = 1) (h : z ≠ -1) :
    ∃ t : ℝ, tangentPhase t = z
```

This is the one genuinely analytic piece (stereographic/half-angle chart). It is
independent of the algebra and should be a *separate* subagent target.

**B-capstone — torus identity-crossing census.**

```lean
theorem boundary_identity_iff
    (zx zy zz : ℂ) (hx : normSq zx = 1) (hy : normSq zy = 1) (hz : normSq zz = 1)
    (hboundary : zx = -1 ∨ zy = -1 ∨ zz = -1) :
    weylStep zx zy zz = 1 ↔ (zx = -1 ∧ zy = 1 ∧ zz = -1)
```

and the full-torus union with the interior alias classification from
`StationaryAmplitudeWeylAlgebraicOffAxisAlias` (root `rootPoly_existsUnique_real`)
to state the complete crossing set over `T^3`.

### Nondegeneracy witnesses

`weylStep_neg_one_one_neg_one : weylStep (-1) 1 (-1) = 1` (boundary crossing is
real, not vacuous), `all_neg_one_not_identity` (corner is a genuine non-alias —
exact `u0 = 7/25`), `axis_gammaZero_nonzero` and
`exists_stationary_amplitude_isotropic_weyl_fixture` (the symbol is dynamically
nontrivial: nonzero onsite band, isotropic `3/5` moments), and
`excludedPoly_pos` (the excluded sextic never vanishes over ℝ, so the interior
census is not corrupted by a spurious branch).

### Likely Mathlib API

`Matrix.ext_iff` / `Complex.ext_iff` to reduce matrix equality to four complex,
eight real, polynomial equations; `Complex.normSq`, `Complex.ofReal_*`,
`field_simp` to clear `(1+t^2)` denominators; `ring`/`linear_combination` with
the Groebner cofactors for the `⟨1⟩` strata; `polyrith`/`nlinarith` fallback for
the `⟨ty⟩` iff. B1 is pure `ring`.

### Principal risk

Coefficient transcription error in B1 (174/170/178 rational terms). Mitigation:
generate them mechanically from `--emit-lean`, never by hand; the SHA-256 pins in
the certificate memo are the acceptance gate. Secondary risk: B3's chart
surjectivity is the only non-mechanical lemma and could stall — but it is
textbook and orthogonal to the algebra.

### Fallback statements (still publishable)

- If B-capstone's unit-circle surjectivity stalls: ship B1+B2 as the
  **"seven-stratum boundary census + chart-cleared ideal certificate"** theorem
  (already a complete, honest upgrade of the oracle claims) and keep the torus
  capstone as stated-but-`sorry`-free-pending.
- If B1 coefficient transcription is intractable in one pass: ship the *saturated*
  statement `bare ∈ I : ⟨(1+tz^2)^∞⟩` plus `real_elimination_factor_iff`, which
  is the honest real-root consequence and needs no 400 KB cofactor dump.

### Manuscript claim upgrade

Row B in `PAPER_GATE_MATRIX.md`: "exact boundary oracle" → **kernel-checked**
seven-stratum boundary census; and the corrected census sentence must read "the
`pi`-boundary contributes exactly one crossing `(-1,1,-1)`", explicitly
retiring the false "no `pi`-boundary root" wording. In `MANUSCRIPT_CLAIM_DELTA`,
the ideal certificate row moves from external-CAS to M/orig with the mandatory
`(1+tz^2)^2` factor stated. Do **not** upgrade to "complete Brillouin-zone Weyl
cone classification" — the fixture is one explicit isotropic symbol, not a
generic-symbol theorem.

---

## CHAIN D — Strong `L2` convergence and live-walk → Dirac-flow intertwining

### Strategic thesis

D's honest scorecard is "contraction landed, but contraction does not imply
strong convergence or intertwining." That "but" is the entire continuum claim.
The gate is *not* another energy inequality; it is a limit theorem plus a
composition. The chain has exactly three joints and each is independently
attackable.

### Landed inputs to compose

`ChangingMomentumCellProjection.lean`: `projectFinite`, `cellAverage`,
`projectFinite_eq_average`, `projectFinite_const_one_on_cell`, cell measurability
/ disjointness lemmas.
`ChangingMomentumCellProjectionL2.lean`: `projectFinite_L2_contraction`,
`integral_norm_sq_projectFinite_eq_sum`, `cellAverage_energy_le`,
`projectFinite_pointSpike_zero`, `projectFinite_one_nonzero`.
`ChangingMomentumPointSamplerNoGo.lean`: the AE no-go (point sampling is not an
`L2` operator — the reason the cell average is the right object).
`FullLiveCoefficientConvergence.*` and `LiveWeighted3Plus1Walk.liveModeError_tendsto_zero`
(the countable-momentum coefficient convergence with UV tail control).
The `h^(-3/2)` finite-support `L2(R^3)` isometry into disjoint momentum cells
(cited in the gate matrix / claim delta) — the Fourier bridge object.

### Theorem shapes (three joints + capstone)

**D1 — strong `L2` convergence under mesh refinement + box exhaustion.** For a
fixed square-integrable profile, the cell-average projection converges *in `L2`
norm* (not merely contracts) as `h → 0` along an exhausting box schedule
`s = boxSchedule N`:

```lean
theorem projectFinite_tendsto_L2
    (f : Momentum3 → ℂ) (hf : Integrable (fun x => ‖f x‖ ^ 2)) :
    Filter.Tendsto
      (fun N => ∫ x, ‖projectFinite (hSchedule N) (boxSchedule N) f x - f x‖ ^ 2)
      Filter.atTop (nhds 0)
```

**Proof architecture (give this to the subagent).** Three-epsilon:
1. dense reduction — approximate `f` in `L2` by a bounded continuous
   compactly-supported `g` (Mathlib: `MeasureTheory.MemLp.exists_boundedContinuous_eLpNorm_sub_le`,
   `HasCompactSupport.exist_eLpNorm_sub_le_of_continuous`);
2. for such `g`, cell-average error `→ 0` by uniform continuity on the compact
   support plus box exhaustion catching the support (this is where
   `cellAverage_energy_le` + Lebesgue differentiation / dominated convergence
   `MeasureTheory.tendsto_integral_of_dominated_convergence` do the work);
3. transfer back using `projectFinite_L2_contraction` (the projection is a
   nonexpansive map, so the dense-approximation error is not amplified) and the
   `L2` triangle inequality `MeasureTheory.eLpNorm_sub_le`.

The already-landed contraction is *load-bearing* precisely at step 3 — this is
how "contraction" is upgraded to "strong convergence."

**D2 — arbitrary-`L2` three-epsilon extension.** The same statement for
arbitrary `f ∈ L2` (drop `Integrable`-of-square packaging, phrase via `MemLp f 2`),
by density of the compact-smooth class. Largely subsumed by D1's architecture;
split it out so the analytic density lemma is proved once.

**D3 — momentum→position Fourier intertwining.** Compose D1 with the `h^(-3/2)`
finite-support isometry `Φ_h : ℓ²(cells) → L2(R^3)` and
`FullLiveCoefficientConvergence.fullModeError_tendsto_zero` so that the
projected live `3+1` walk, pushed through `Φ_h`, converges in `L2(R^3)` to the
image of the exact evolved profile:

```lean
theorem live_projected_walk_tendsto_dirac_flow
    (ψ : ...four-spinor square-summable profile...) (m : ℕ) (hm : |m| ≤ M) (t : ℝ) :
    Filter.Tendsto
      (fun N => ‖ Φ (hSchedule N) (liveStep (schedule N) ψ)
                  - diracFlow t (Φ0 ψ) ‖ ^ 2 )
      Filter.atTop (nhds 0)
```

with `diracFlow` the position-space Dirac evolution to be *identified* (the gate
matrix's open item "identify the position-space Dirac flow"). Identification =
show the momentum multiplier `exp(-i t H(k))` transported through `Φ` is the
free Dirac propagator; use the `ContinuumL2MultiplierBridge` object already in
the tree.

**D-capstone.** Package D1–D3 as: *the live changing-lattice `3+1` walk, cell-
averaged and Fourier-lifted, converges strongly in `L2(R^3)` to the free Dirac
flow along any exhausting mesh/box schedule.*

### Nondegeneracy witnesses

`projectFinite_one_nonzero` (projection reproduces genuine data, not zero),
`projectFinite_pointSpike_zero` (it correctly annihilates AE-null spikes — proof
that the object is the *right* AE-invariant one), `walkErrorEnvelope_nonzero_fixture`
and `fullModeError_outside_control` (an omitted mode carries its genuine negative
exact coefficient — the error is real, not a definitional zero). These block the
vacuity referee: the limit is not `0 = 0`.

### Likely Mathlib API

`MeasureTheory.MemLp` / `Lp`, `eLpNorm`, `eLpNorm_sub_le`,
`MemLp.exists_boundedContinuous_eLpNorm_sub_le`,
`HasCompactSupport.exist_eLpNorm_sub_le_of_continuous`,
`tendsto_integral_of_dominated_convergence`, `MeasureTheory.integral_indicator`,
`MeasureTheory.setIntegral_le_integral`, `Filter.Tendsto`/`Metric.tendsto_atTop`,
Lebesgue-differentiation (`MeasureTheory.tendsto_average_...`) for the cell mean.

### Principal risk

The Lebesgue-differentiation step (cell average → pointwise value a.e., then to
`L2`) is the hard analytic core and Mathlib's differentiation API is finicky in
`R^n`. Mitigation: restrict the dense class to *continuous compactly supported*
`g` where cell-average → `g` is uniform (elementary, avoids the differentiation
theorem entirely); only the density lemma then touches heavy API. Secondary risk:
D3's Dirac-flow *identification* is a modeling choice — pin the Fourier
convention explicitly (the run plan flags convention-sensitivity) and state D3
relative to that named convention.

### Fallback statements

- If full `R^3` differentiation stalls: ship D1 for the *continuous
  compactly-supported* class as the strong-convergence theorem, with the
  arbitrary-`L2` extension stated-pending. This already upgrades the gate from
  "contraction only."
- If D3 identification is contested: ship the *intertwining up to the named
  multiplier* — "projected live walk converges to `Φ(exp(-itH)ψ)`" — leaving the
  "= free Dirac propagator" as a separate, clearly-scoped multiplier lemma.

### Manuscript claim upgrade

Row D: "AE-valid finite projection and exact `L2` contraction" → **strong `L2`
convergence of the cell-average projection under mesh refinement and box
exhaustion**, and (with D3) the first genuine changing-lattice → Dirac
continuum-limit statement. Keep the kill condition visible: point evaluation
still cannot define an `L2` operator (cite the no-go), so the claim is about the
cell-average object only. Do not claim operator-norm or strong-*resolvent*
convergence — the theorem is strong `L2` convergence on profiles.

---

## CHAIN F — Locality/dynamics selector, or the sharp residual-moduli theorem

### Strategic thesis

Every landed F no-go kills a selector that is **commutator-blind, linear,
additive, or full-shift-invariant**. That is a deliberately narrow class, and
the paper currently over-suggests arbitrariness. Two honest publishable
endgames exist; pick based on what the subagent can actually land, but *state
one of them* — shipping only the no-gos invites the referee complaint "you never
tried a local/nonlinear selector."

Attack on overclaiming (both directions): the open-disk coordinate uniqueness
(`distinct disk points give distinct positive sectors`) is uniqueness **in a
chosen four-matrix basis**, not canonicity of that basis. The manuscript must
not let "unique coordinates" drift into "canonical decomposition."

### Landed inputs to compose

`ChannelSelectorRigidity.selector_rigid_iff_injective`,
`...no_finite_selector_rigidifies`; `ChannelNaturalityNoGo.invariant_selector_constant`;
`ChannelCommutatorSelectorClassification.selector_factors_through_trace`,
`...no_commutatorBlind_selector_injective`;
`ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree`;
`live_refinement_fibre_is_nontrivial_torsor`;
`GateF2/InvariantPotentialNogo.lean`:
`distinct_spectrum_kills_invariant_gradient`,
`invariant_critical_point_has_repeated_eigenvalue`.

### Endgame F-A (preferred) — a graph-local / commutator-sensitive selector that
### IS injective on the zero-sum torsor

Construct an explicit selector `S` that uses data the no-gos exclude — a
finite-range/locality-weighted or *commutator-sensitive nonlinear* score — and
prove it separates the torsor, defeating the project's own obstructions on their
own carrier.

```lean
-- S is not commutator-blind and not additive; it reads soldering/locality data.
def localSelector : RefinementFibre → ℝ := ...

theorem localSelector_injective_on_torsor :
    Function.Injective (localSelector ∘ torsorParam)

theorem localSelector_not_commutatorBlind : ¬ CommutatorBlind localSelector
theorem localSelector_breaks_full_shift  : ¬ FullShiftInvariant localSelector
```

then classify the induced stabilizer/quotient and *compare it to the open-disk
coordinates* (the gate's explicit ask):

```lean
theorem localSelector_quotient_eq_openDisk_coords : ...
```

**Why this is not blocked.** `no_commutatorBlind_selector_injective` requires
commutator-blindness; `no_finite_selector_rigidifies` requires additivity into a
finite target; `invariant_selector_constant` requires full-shift invariance. A
locality/soldering-weighted nonlinear `S` satisfies none of these hypotheses, so
no landed theorem contradicts F-A. The subagent must exhibit the witness that
`S` violates each hypothesis (the `not_*` lemmas above) — that is the
nondegeneracy fixture.

### Endgame F-B (guaranteed, honest) — sharp residual-moduli theorem

If no compelling `S` is found, prove the *impossibility within the scoped
admissible class* precisely, so the paper states an exact residual rather than a
vibe:

```lean
theorem residual_moduli_is_full_torsor :
    (⋂ S ∈ ScopedAdmissibleSelectors, fibre_of S) = wholeTorsor
```

i.e. the intersection over all scoped-admissible (linear/additive/commutator-
blind/shift-invariant) selectors of their selected fibres is exactly the affine
zero-sum torsor: within the scoped class the moduli are irreducible. Pair with
`positive_quadratic_selectors_disagree` (positive metrics select, but disagree,
so metric choice is external data) to give the exact statement: *selection is
possible only after importing a metric or leaving the scoped class.*

### Nondegeneracy witnesses

`live_refinement_fibre_is_nontrivial_torsor` (the moduli are genuinely nonzero —
without it F-B is vacuous), `positive_quadratic_selectors_disagree` (positive
selectors exist and genuinely disagree — the ambiguity is real, not a proof
artifact). For F-A: the `not_commutatorBlind` / `not_FullShiftInvariant`
witnesses are mandatory or the "defeats the no-gos" claim is empty.

### Likely Mathlib API

`Function.Injective`, `AffineSubspace`/torsor API (`AddTorsor`, `vadd`),
`Finset.sum`/zero-sum-shift linear algebra, `Matrix.trace`, inner-product /
`InnerProductSpace` for the positive-metric quadratic selectors, `⋂`/`Set.iInter`
for F-B. F is finite-dimensional rational linear algebra throughout — low
Mathlib-analysis risk, higher *modeling* risk.

### Principal risk

F-A's risk is that any locality selector we can define is secretly reducible to
trace/spectrum on this one carrier (the carrier is small — `4x4`), so injectivity
fails and F-A collapses into F-B. Mitigation: test injectivity numerically with
`#eval`/`decide` on the explicit rational torsor *before* asking for a proof; if
the candidate is not injective on the finite torsor, discard it immediately.
F-B's risk is definitional overreach in "ScopedAdmissibleSelectors" — keep the
scope class syntactically explicit (exactly the four landed hypotheses), never a
blanket "all selectors."

### Fallback statements

- If F-A candidates all collapse: ship F-B as the paper's spine ("Rigid
  coefficients, noncanonical channels: the residual moduli are exactly the
  zero-sum torsor within the scoped selector class") — this is already the draft's
  honest thesis and needs no new physics.
- If F-B's full intersection is hard: ship the pairwise version (any two scoped-
  admissible selectors agree only on the torsor) plus the explicit disagreement
  witness — weaker but still exact.

### Manuscript claim upgrade

Row F: "theorem-level classification spine" → either (F-A) **a locality/dynamics
selector that separates the moduli, with its quotient identified against the
open-disk coordinates**, or (F-B) **an exact residual-moduli theorem** stating
selection is impossible within the scoped class without imported metric data.
Mandatory guard in prose: replace any "unique/canonical decomposition" phrasing
with "coordinate-unique in the chosen four-matrix basis; basis canonicity is
not claimed." Do not let scoped no-gos be stated as "no selector can work" —
they cover exactly the four hypothesis classes and nothing more.

---

## Cross-cutting: overclaims to kill before submission

- **B:** "no `pi`-boundary identity root" is FALSE — the exact alias `(-1,1,-1)`
  exists; and the bare `tz p5 p6` ideal membership is FALSE without `(1+tz^2)^2`.
  Ship neither. Also: the isotropic symbol is one fixture, not a generic Weyl-cone
  theorem.
- **D:** contraction ≠ convergence ≠ intertwining; point evaluation is not an
  `L2` operator. Claim strong `L2` convergence of the cell-average object only,
  at a named Fourier convention.
- **F:** basis-relative coordinate uniqueness is not canonicity; scoped no-gos
  are hypothesis-bounded, not universal.

## Elegant-but-strategically-weak (deprioritize)

- Further B interior aliases (`9-40-41`, additional off-corner points): pretty,
  but the census capstone subsumes their strategic value — one more alias does
  not move the grade.
- Additional F *scoped* no-gos (more linear/additive variants): each is another
  instance of the same hypothesis class and strengthens the overclaim risk
  rather than the paper. Spend the budget on F-A/F-B instead.
- D quantitative rate refinements beyond the landed quartic-window bound: the
  gate is the *limit*, not a sharper constant.

## Sequencing

Land **B1** (pure `ring`, near-zero risk) and **D1** density lemma first as
quick grade-movers, in parallel with the **B2** stratum lemmas (independent,
batchable 7-up). Then **B-capstone**/**B3** and **D2/D3** as the deeper joints.
Run **F-A** numerical injectivity screens (`#eval`) concurrently and fall to
**F-B** the moment a candidate fails on the finite torsor.
