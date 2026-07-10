# Live-repository reconciliation

This focused audit predates three live landings. The repository now contains
`SuccessiveAxisDiracWalk`, which proves exact unitarity, the first derivative of
the ordered internal split step, and the `3+1` Clifford square, but still has no
position register, conditional spatial shift, or convergence rate. It also
contains `DiscretePluckerVariationalFlow` and
`DiscretePluckerFlowStability`; the selected adjacent-link action now derives
the recurrence and its conserved positive-definite invariant gives a uniform
iterate bound on `0 < mu <= 2`. Gibbs variance and the simultaneous-coin
Clifford-block no-go remain active Aristotle targets. The audit's recommendation
to distinguish the positive-real no-go from the stronger complex-scalar no-go
is retained and has been promoted to a separate proof target.

# POST_ENSEMBLE_ROUTEB_AUDIT_10

Adversarial audit of post-ensemble dynamics and Route B.

Scope audited: `Sources/ExplicitSixChannelCoin.lean`,
`Sources/ConcreteD4InvariantSector.lean`, `Sources/FiniteGibbsResponse.lean`,
`Sources/PluckerHessianSL2Invariance.lean`,
`Sources/PluckerOscillatorGroup.lean`; the active target
`Targets/Core.lean` (`DiscretePluckerFlow`); and
`Docs/{THEORY_COMPLETION_MATRIX,MANUSCRIPT_CLAIM_MATRIX,SIMULATION_BENCHMARKS,LIT_SEARCH_LOG,2026-07-10_ARISTOTLE_CURRENT_THEORY_AUDIT_09}.md`.

Ground rules honoured: source files were **not edited**; the five `Sources/*`
files import live-repository modules (`PhysicsSM.*`) that are absent from this
focused package, so they do not elaborate here. Per instruction this is recorded
as a **packaging fact**, not a live-repository failure, and their internal
mathematics is audited from the text and independent recomputation. The one item
that both belongs to this package and elaborates locally — the target
`DiscretePluckerFlow` — was checked end-to-end with the toolchain and is now
proved s o r r y-free (see §3).

Verdict tags: **[true]** recomputed and correct; **[narrow]** correct but
weaker than the caption suggests; **[open]** claimed-next, not landed;
**[packaging]** import gap only.

---

## 1. The universal positive-real Clifford-block no-go for the concrete axis coin

### 1.1 The concrete coin and its exact square

`axisBlockCoin : Matrix (Fin 6) (Fin 6) ℂ` is block-diagonal `B ⊕ B ⊕ B` with

```
B = [[3/5, 4i/5], [4i/5, 3/5]].
```

Recomputation: `B` is unitary (`(3/5)² + (4/5)² = 1`), eigenpairs
`(1,1) ↦ 3/5 + 4i/5`, `(1,-1) ↦ 3/5 − 4i/5`, each eigenvalue of the full `6×6`
coin with multiplicity three. The square is

```
B² = [[-7/25, 24i/25], [24i/25, -7/25]],   eigenvalues −7/25 ± 24i/25.
```

This matches the landed source facts exactly:
`axis_block_coin_sq_offdiag` gives `(B²)₀₁ = 24i/25` **[true]** and
`axis_block_coin_sq_ne_scalar` gives `B² ≠ r·I` for every `r ∈ ℂ` **[true]**.
`axis_block_coin_unitary`, `axis_block_coin_controls` (nonidentity, `x±` mixing
`4i/5`, no `x→y` leakage) are all recomputed correct **[true]**.

### 1.2 The no-go as proposed (Audit-09 §8)

```lean
theorem axisBlockCoin_has_no_clifford_block :
    ¬ ∃ (ι : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 6 → ℂ)) (H : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 4 → ℂ)) (r : ℝ),
        Function.Injective ι ∧
        (∀ v, axisBlockCoin.mulVec (ι v) = ι (H v)) ∧
        (∀ v, H (H v) = (r : ℂ) • v) ∧ 0 < r
```

**Truth: [true].** The intertwining `U∘ι = ι∘H` with `ι` injective forces
`im ι` to be a `U`-invariant `4`-space and `H` conjugate to `U|_{im ι}`. Since
`U` is diagonalizable with exactly two eigenvalues, each with a `3`-dimensional
eigenspace `E₊, E₋`, every `4`-space `W ⊆ E₊ ⊕ E₋` splits as
`W = (W∩E₊) ⊕ (W∩E₋)` with `dim(W∩E₊) + dim(W∩E₋) = 4` and each summand `≤ 3`,
hence **both are `≥ 1`**. Therefore `H` carries both eigenvalues, `H²` carries
both squares `−7/25 ± 24i/25`, which are distinct, so `H²` has `≥ 2` distinct
eigenvalues and is never a scalar multiple of `I`. The existential is empty; the
no-go holds. The `0 < r` conjunct is a fortiori satisfiable-free because the
squares are non-real.

### 1.3 Semantic audit — the "universal positive-real" label is a *narrowing*

**Caption risk: [narrow].** As a `¬∃`, adding the conjuncts `r ∈ ℝ` and `0 < r`
makes the statement **weaker** (it rules out fewer objects: only positive-real
Clifford squares). The mathematically true and maximally strong fact is stronger
and equally provable:

- **Preferred universal form:** quantify `r` over `ℂ` and drop `0 < r`; the claim
  "`H²` is never `r·I` for any `r ∈ ℂ`" is exactly `axis_block_coin_sq_ne_scalar`
  lifted through the conjugacy. The manuscript must not read the positive-real
  version as "no Clifford block of any kind"; it should either state the `ℂ`
  version or explicitly caption the theorem as "no positive-real Clifford square."
- **Why the distinction matters physically:** a genuine `3+1` Dirac step needs
  `H² = −k²·I` with `k` real (a *negative* real scalar, the mass-shell), or
  `r·I` with `|r| = 1` for a pure Clifford involution. The positive-real `0 < r`
  slice is not the physically decisive one; the decisive statement is
  "`H²` non-scalar," which the source already proves at the block level.

**Non-vacuity is real and must be preserved.** The no-go is *not* about the
absence of invariant `4`-spaces — one exists concretely. `ConcreteD4InvariantSector`
lands the positive anisotropic rank-four witness:
`concrete_coin_intertwines_four_sector` (the `6×6` coin restricts to `fourCoin`
`= B ⊕ B` on `span{e₀,e₁,e₂,e₃}`), `include_four_injective`,
`projector_idempotent`, `projector_commutes_axis_coin`,
`projector_commutes_every_diagonal_shift`, and the anisotropy control
`excluded_z_channel_control` (`z+ ≠ 0` but `P z+ = 0`) — all recomputed **[true]**.
So the no-go is genuinely about the **Clifford square**, and the companion
positive fact `axisBlockCoin_has_invariant_four_space` proposed in Audit-09 is
the correct non-vacuity guard and should be landed **beside** the no-go, never
folded into it.

**Bottom line §1.** The no-go is true and its intended kill is valid; land it,
but state it over `r ∈ ℂ` (or caption the positive-real restriction honestly),
and land the invariant-`4`-space witness as a separate companion so the kill is
provably non-vacuous. Status: **[open]** — neither the no-go nor its companion is
present in this package; both are correctly-specified next theorems.

---

## 2. Successive-axis four-component **Route B**

### 2.1 What Route B actually is here

Route B is a **pre-registered plan**, not a landed artifact. It appears only in
`Docs/LIT_SEARCH_LOG.md` (2026-07-10 03:40 PDT): a separate `ℂ⁴` construction in
which the 3D walk is a **product of three one-dimensional axis walks acting on the
same internal space**, parity/axis-noncorrelation forces **anticommuting**
internal operators, the massive case doubles the internal dimension to four, and
the coin flip supplies the mass term. There is **no `Route*.lean`** in `Sources/`
or `Targets/`. The audit below is therefore of the *plan's mathematical claims*
and of the nearest landed code that could be mistaken for it.

### 2.2 Exact unitarity — cheap and not the obstruction

If each axis step `U_x, U_y, U_z` on `ℂ⁴` is unitary, the successive product
`U = U_z U_y U_x` is unitary by `IsUnitary` closure under products; "exact
unitarity" of Route B is immediate and is **not** where the difficulty lives.
**Caution [narrow]:** do not advertise successive-axis unitarity as a substantive
theorem — it is a one-line consequence of factorwise unitarity.

**Do not conflate Route B with the landed oscillator group.**
`PluckerOscillatorGroup.step_composition` proves an **abelian** angle-addition law
`stepMatrix c₁ s₁ · stepMatrix c₂ s₂ = stepMatrix (c₁c₂−s₁s₂)(s₁c₂+c₁s₂)` — a
single-frequency `SO(2)`-type commuting `2×2` family. That is the **opposite** of
Route B's required **noncommuting** three-axis product. The oscillator group is
not a partial Route B and must not be cited as evidence for it.

### 2.3 Derivative/generator orientation

The physically load-bearing content is the **generator**: writing
`U_a = exp(ε G_a) + O(ε²)` (or a Cayley/coin-flip form), the continuum operator
is `Σ_a G_a` only to first order, and the **orientation/sign** of each
derivative fixes whether one obtains `+γ^a ∂_a + m` versus `−γ^a ∂_a − m` and the
handedness of the resulting Dirac operator. The coin-flip supplying the mass term
must give a **Hermitian** mass with the correct sign relative to the kinetic
generators. **Verdict [open]:** no landed statement fixes the generator, its
Hermiticity, or the mass-term orientation; this is genuine unbuilt work, not a
formality.

### 2.4 Factor ordering

Because the internal operators must **anticommute** (`{G_a, G_b} = 2δ_{ab}` for
the Clifford/Dirac structure), the three axis unitaries **do not commute**:
`U_z U_y U_x ≠ U_x U_y U_z`, differing at `O(ε²)` by commutator terms. Consequences
the plan must resolve before any claim:

- The first-order (Lie–Trotter) generator sum is ordering-independent, but the
  discrete step and all `O(ε²)` corrections are **not**; a **symmetrized**
  (Strang-type) ordering is generally required to keep the step Hermitian/parity-
  correct and to make the naive generator the true continuum limit.
- Any "successive-axis = simultaneous coin" identification is only a
  **continuum-limit** statement, never an exact finite one; the finite successive
  product is a *different operator* from the simultaneous `B ⊕ B ⊕ B` coin of §1.

**Verdict [open]:** factor ordering is a real mathematical decision with physical
content; it is unaddressed in code.

### 2.5 What remains before a spatial walk or continuum propagator

1. A **spatial/position register** and conditional shifts `S_a` (shift-by-internal-
   state). None exists; the current D4 objects are internal-space only.
2. **Exact finite unitarity** of the full coin-and-shift successive walk on
   (position ⊗ ℂ⁴).
3. A **generator/dispersion** theorem: the symbol in momentum space and its
   small-`ε` expansion.
4. A **continuum-limit (Trotter/Lie-product) convergence** theorem yielding the
   `3+1` Dirac propagator, with an explicit remainder bound.
5. A **positivity/energy** statement (real mass shell, positive norm sector).

**Bottom line §2.** Route B is correctly reasoned as a *plan* and correctly kept
separate from the simultaneous six-channel coin. Its only "easy" ingredient
(unitarity of a product) is genuine; everything with physical content (generator
orientation, factor ordering, spatial shift, continuum limit) is **[open]**. No
over-claim exists yet **because nothing is landed** — the risk is prospective:
future captions must not present unitarity or the abelian oscillator group as
Route B progress.

---

## 3. The discrete variational flow (`Targets/Core.lean`, `DiscretePluckerFlow`)

This target elaborates in this package and was checked end-to-end. **All nine
theorems are now proved and the file is s o r r y-free** (toolchain-verified;
axioms `propext, Classical.choice, Quot.sound` only via `Mathlib`).

### 3.1 Do the adjacent-link derivatives genuinely yield the recurrence? — Yes [true]

- `lagrangian mu q next = ½(next−q)² − ½·mu·q²`.
- `lagrangian_hasDerivAt_right`: `∂/∂next L(prev,·) = q − prev` at `next=q`
  (right-link variation). **[true]**
- `lagrangian_hasDerivAt_left`: `∂/∂q L(·,next) = q − next − mu·q` at the middle
  slot. **[true]** (Recomputed: `(next−q)(−1) − mu·q = q − next − mu q`.)
- `euler_lagrange_eq_adjacent_variations`: the residual
  `(q−prev)+(q−next)−mu·q` **equals the sum of the two adjacent-link derivatives**
  `(q−prev) + (q−next−mu·q)`. **[true]** — this is the honest link between the
  derivative lemmas and the residual.
- `euler_lagrange_iff_recurrence`: residual `= 0 ⟺ next = (2−mu)q − prev`.
  **[true]**
- `step_satisfies_euler_lagrange`: `step` realizes exactly that recurrence.
  **[true]**

So the recurrence is genuinely the discrete Euler–Lagrange equation of the stated
one-link Lagrangian, obtained from the two adjacent links. **No gap.**

### 3.2 Is the first integral nontrivial? — Yes, but conditionally definite [true]/[narrow]

- `firstIntegral mu x = x₁² + x₂² − (2−mu)·x₁·x₂` is exactly conserved by `step`
  (`first_integral_conserved`, recomputed with `k = 2−mu`). **[true]**
- **Nontriviality:** it is a genuine non-constant quadratic invariant, confirmed
  by `wrong_sign_control` (a wrong-sign/off-shell state gives a different value:
  `1057/625 ≠ 1`). **[true]**
- `rational_plucker_flow_control`: `mu=4/25`, `(0,1) ↦ (1,46/25)`, residual `0`,
  first integral `1` before and after. **[true]** (Recomputed: `2−4/25 = 46/25`.)

**[narrow] caveat:** the quadratic form `x₁²+x₂²−k·x₁x₂` is **positive definite
iff `|k| < 2`, i.e. `0 < mu < 4`**. The landed target proves *conservation* but
**not** positive-definiteness; the invariant is only a *definite Lyapunov
function* on that parameter window.

### 3.3 Does positivity/stability need an additional theorem? — Yes [open]

The recurrence has characteristic polynomial `λ² − (2−mu)λ + 1 = 0` with root
product `1`; orbits are bounded (stable/elliptic) **iff** `|2−mu| ≤ 2`, i.e.
`0 ≤ mu ≤ 4`, which is exactly when `firstIntegral` is positive
(semi)definite. For `mu = 4/25` the flow is stable; outside `[0,4]` it is
hyperbolic and orbits grow. **Conservation alone does not give stability** — a
separate **positive-definiteness/boundedness theorem** is required and is not
present. This is the concrete gap of §3 and feeds §7.

**Bottom line §3.** The variational derivation and the first integral are correct
and now machine-checked; the missing rung is a positivity/stability theorem
(positive-definite first integral `⟹` bounded orbits on `0 < mu < 4`).

---

## 4. Landed SL2 Hessian, oscillator group, and finite Gibbs response

Recorded as **[packaging]**: these three files import `PhysicsSM.*` and so do not
elaborate in the focused package; their guards (`#print a x i o ms` = `propext,
Classical.choice, Quot.sound`) are asserted in-file and are consistent with the
live 8,080-job guard. Mathematics recomputed below.

### 4.1 `PluckerHessianSL2Invariance` — dictionaries and truth

Opened dictionaries: `PhysicsSM.Spinor.PluckerMass`,
`PhysicsSM.Spinor.PluckerMassCovariance`,
`PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary`,
`PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass`,
`PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian`.

- `massSq_sl2_invariant`, `action_sl2_invariant`, `action_hessian_sl2_invariant`:
  from `spinorWedge_sl2_invariant` (`wedge(Aψ,Aφ) = det A · wedge(ψ,φ)`), so
  `massSq = normSq(wedge)` is invariant when `det A = 1`. **[true]**
- `rational_boost_hessian_control`: `det rationalBoost = (5/4)²−(3/4)² = 1`; Hessian
  stays `4/25`. **[true]**
- `nonunimodular_dilation_control`: `dilation2 = 2·I`, `det = 4`, `massSq` scales by
  `|det|² = 16`, `16·(4/25) = 64/25 ≠ 4/25`. **[true]** — det-one is genuinely
  load-bearing.

### 4.2 `PluckerOscillatorGroup` — dictionaries and truth

Opened: `PluckerMass`, `PositiveHodgePhysicalMass`, `PluckerActionHessian`.

- `step_determinant_one` (`c²+s²=1 ⟹ det = 1`), `step_inverse` (negate `s`),
  `step_composition` (angle addition), `vector_energy_conserved`
  (`x₁² + m²x₀²` invariant), and `group_hessian_energy_conserved` tying `m² = massSq`
  to the action Hessian `4/25`. All recomputed **[true]**.
- `rational_reversible_control`: `(m,c,s) = (2/5,3/5,4/5)`, `det = 1`, inverse
  exact. **[true]**
- **[narrow]:** this is an **abelian one-frequency** rotation group (see §2.2); do
  not present it as multi-axis / Route-B dynamics, and note the flow is *supplied*,
  not derived from the quartet EOM (that derivation is now the `DiscretePluckerFlow`
  target of §3).

### 4.3 `FiniteGibbsResponse` — dictionaries and truth

Opened: `PluckerMass`, `CanonicalGramTurnDictionary`, `PluckerActionHessian`.

- `partition_pos`, `probability_nonnegative`, `probability_sum_one`: standard,
  correct. **[true]**
- `log_partition_hasDerivAt`: `d log Z/dβ = −meanEnergy`. **[true]**
- `plucker_two_level_partition`: `Z = 1 + exp(−β·massSq)`. **[true]**
- `rational_plucker_gibbs_control`: `massSq(edge0, edge1(2/5)) = 4/25`,
  `Z = 1 + exp(−β·4/25) > 0`. **[true]** At `β = 0`: `Z = 2`, `p = 1/2`, mean
  `E = 2/25` — consistent with the matrices.
- **[narrow]:** only the **first** derivative is landed; the fluctuation/variance
  (second-derivative) positivity is *not* proved (see §7).

---

## 5. The four over-claim checks for every source and target

Checks applied to each declaration set:
**C1 fidelity** (Lean statement = caption/matrix claim);
**C2 non-vacuity** (no empty hypotheses; witnesses/controls genuinely nonzero);
**C3 hypothesis exposure** (all load-bearing/"supplied-not-derived" assumptions
displayed);
**C4 footprint** (s o r r y-free; axioms ⊆ `{propext, Classical.choice, Quot.sound}`;
guards present).

| Unit | C1 fidelity | C2 non-vacuity | C3 hypotheses exposed | C4 footprint |
|---|---|---|---|---|
| `ExplicitSixChannelCoin` | pass — "explicit unitary coin, three decoupled axis blocks, `B²` not scalar" matches statements | pass — controls: nonidentity, `4i/5` mixing, `24i/25` square offdiag | pass — coin coefficients *supplied*, stated | pass (asserted guards; **[packaging]** locally) |
| `ConcreteD4InvariantSector` | pass — "anisotropic rank-four invariant sector," not a Dirac sector | pass — `z+ ≠ 0`, `P z+ = 0` genuine anisotropy control | pass — projector coordinate-chosen, stated | pass (asserted guards; **[packaging]**) |
| `PluckerHessianSL2Invariance` | pass — invariance under `det=1`; `2I` breaks it | pass — boost `4/25`, dilation `64/25` real controls | pass — `det A = 1` explicit, load-bearing | pass (asserted guards; **[packaging]**) |
| `PluckerOscillatorGroup` | **[narrow]** "oscillator group" is abelian 1-freq; caption must not imply multi-axis | pass — rational reversible control | pass — `m²=massSq`, `c²+s²=1`, flow *supplied* stated | pass (asserted guards; **[packaging]**) |
| `FiniteGibbsResponse` | **[narrow]** "response" = first derivative only | pass — gap `4/25`, `Z>0`; unnormalized-weight negative control | pass — finite nonempty spectrum, β/energy dictionary supplied | pass (asserted guards; **[packaging]**) |
| `DiscretePluckerFlow` (target) | pass — variational recurrence + first integral exactly as captioned | pass — `wrong_sign_control` + rational control are genuine | **[narrow]** — positive-definiteness/stability window `0<mu<4` **not** stated | **pass — verified here: s o r r y-free, axioms `{propext, Classical.choice, Quot.sound}`** |

No unit fails a check outright. The only substantive over-claim *risks* are the
two `[narrow]` captions (oscillator "group"→abelian; Gibbs "response"→first-order)
and the un-stated stability window of the target flow.

---

## 6. Exact corrections to the completion, claim, and benchmark matrices

**MANUSCRIPT_CLAIM_MATRIX.md**

- **M6:** the concrete Dirac-block **no-go is not yet landed** in this package.
  Keep "`6 = 4 + 2`, not `6 = 4`" but change the falsifier/status to name the
  *pending* `axisBlockCoin_has_no_clifford_block` and its companion
  `axisBlockCoin_has_invariant_four_space`. When landing it, state `r ∈ ℂ` (or
  caption the positive-real slice honestly) per §1.3.
- **M16:** upgrade. "action-derived recurrence running" → the adjacent-link
  variational recurrence and its exact first integral **are now landed**
  (`DiscretePluckerFlow`, s o r r y-free). Add the still-open rung: positive-
  definiteness/stability on `0 < mu < 4` (§3.3). Continue to flag the oscillator
  flow as *supplied*, not the same object as the derived recurrence.
- **M17:** keep "response identity landed," but explicitly mark the
  **fluctuation/variance positivity** `d²/dβ² log Z = Var(E) ≥ 0` as *not yet
  proved* — it is the next rung, not a current claim.

**THEORY_COMPLETION_MATRIX.md**

- The Kinematics/positivity rows should not read the anisotropic rank-four sector
  as a `3+1` Clifford reduction; grade the Dirac-block reduction **K** (killed by
  the pending no-go) once landed, and grade Route B **B/O** with the exact next
  statement = successive-axis `ℂ⁴` coin+shift unitarity + continuum limit (§2.5),
  benchmark = a new successive-walk fixture, kill = failure of factor-ordering
  Hermiticity or of the Trotter limit.
- Add a Dynamics row for `DiscretePluckerFlow`: grade **H** (conditional on the
  supplied one-link Lagrangian), deliverable-met = variational recurrence + first
  integral, remaining = stability theorem.

**SIMULATION_BENCHMARKS.md**

- **S06:** accurate as "three decoupled axis blocks; full square non-scalar."
  Add the pending no-go as the kernel-level discharge; until landed, do not mark
  the "no isotropic Dirac coin" gate as closed.
- **S16:** add a V0/V1 fixture for the *derived* flow: `mu=4/25`,
  `(0,1) ↦ (1,46/25)`, first integral `= 1`, negative control = `wrong_sign_control`.
  Distinguish it from the supplied oscillator group fixture.
- **S17:** the "`d log Z/dβ = −mean E = −2/25`" fixture is correct; add a queued
  row for the variance/heat-capacity positivity (§7) with negative control =
  degenerate spectrum forcing `Var = 0`.

---

## 7. The single highest-value theorem after these targets

Candidates weighed: (a) **Gibbs variance positivity** `d²/dβ² log Z =
⟨E²⟩ − ⟨E⟩² ≥ 0`; (b) **walk-specific convergence** (Route B continuum
propagator); (c) **action-derived stability** (positive-definite first integral
`⟹` bounded orbits).

**Pick: (a) Gibbs variance / heat-capacity positivity.**

```lean
theorem log_partition_hasDeriv2_variance_nonneg
    (E : Fin n → ℝ) (beta : ℝ) :
    0 ≤ (∑ i, (E i)^2 * probability E beta i)
        - (∑ i, E i * probability E beta i)^2
-- and: this quantity = d²/dβ² log Z = Var_β(E) ≥ 0, with strict > 0 iff E nonconstant.
```

Rationale:

- **Genuinely new positivity**, not a restatement: the landed `FiniteGibbsResponse`
  stops at the first derivative; variance positivity is the honest thermodynamic
  extension (heat capacity `≥ 0`) and states a new fact.
- **Cheap and self-contained** (Mathlib-only shapes already exercised in the
  source), with a **concrete non-vacuous witness** (two-level gap `4/25` gives
  `Var = (4/25)²·p(1−p) > 0`) and a **clean negative control** (degenerate
  spectrum `⟹ Var = 0`), exactly matching the matrix discipline.
- It closes the "positivity needs an additional theorem" gap in the thermodynamic
  layer without over-reaching into unbuilt continuum machinery.

**Runner-up: (c) action-derived stability** — the immediate follow-up for the
Dynamics layer: prove `firstIntegral` is positive-definite for `0 < mu < 4` and
deduce bounded orbits (Lyapunov stability) of the just-landed
`DiscretePluckerFlow`. High value and feasible, but it is a standard
elliptic-recurrence fact rather than a new positivity theorem.

**(b) walk convergence is premature:** Route B has no spatial register, generator,
or Trotter limit yet (§2.5), so a convergence theorem is not close to the current
frontier and would require building several intermediate objects first.

---

### Appendix — local verification performed

- `Targets/Core.lean` (`DiscretePluckerFlow`): all nine theorems proved,
  file elaborates with no errors and **no `s o r r y`**; audited theorems depend only
  on `propext, Classical.choice, Quot.sound`.
- `Audit/Core.lean`: elaborates (`package_marker : True`).
- `Sources/*`: not elaborated locally (import `PhysicsSM.*`) — **[packaging]**;
  their arithmetic (block square `−7/25 ± 24i/25`, `24i/25` offdiag; det scalings
  `4/25 → 64/25`; `massSq(edge0,edge1(2/5)) = 4/25`; `Z=2, mean 2/25` at `β=0`)
  was recomputed by hand and matches the stated claims.
