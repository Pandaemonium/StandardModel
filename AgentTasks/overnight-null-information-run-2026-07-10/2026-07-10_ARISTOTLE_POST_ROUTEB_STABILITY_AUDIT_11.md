# Live-repository reconciliation

The audit's semantic findings are retained, while several target statuses have
already advanced. `AxisCoinPositiveCliffordNoGo` and the stronger
`AxisCoinComplexCliffordNoGo` are now both landed; the latter proves the exact
kernel-finrank bound recommended in section 4 and includes a nonzero complex
eigenkernel control. `FiniteGibbsVariance` is also landed, and S20 now reproduces
the equal-degeneracy Schottky curve under a disclosed imported analytic target.
The completion and claim matrices have been updated for flow stability. A
finite three-axis position-register/conditional-shift theorem is now in flight
as Aristotle job `624c8719`; its sign-table/Clifford dictionary and quantitative
continuum limit remain separate obligations. The audit's correction of Audit
10's mass-shell sign and its exact-versus-first-order warning for Route B remain
controlling.

# POST_ROUTEB_STABILITY_AUDIT_11

Adversarial semantic + methods audit after the Route-B internal walk, the
action-derived Plücker flow, and its stability theorem landed, and after S18
became the project's first V2 benchmark. Prepared as the input to Audit 12 / the
07:00 hard audit.

Ground rules honoured: **no source file was edited**. Five `Sources/*.lean` and
both `Targets/*.lean` no-go/variance files were read in full; the three live
flagship modules and S18 were recomputed independently. `Sources/*` import
`PhysicsSM.*` modules that are **absent from this focused package**; per standing
instruction their non-elaboration here is recorded as **[packaging]**, never as a
live build failure, and their mathematics is audited from the text plus
independent recomputation. `FixedMomentumManyStepContinuum` (the S18 Lean anchor)
is likewise **not in this snapshot** — [packaging].

Verdict tags: **[true]** recomputed correct · **[narrow]** correct but weaker
than the caption suggests · **[open]** claimed-next, not landed · **[packaging]**
import gap only · **[error]** a genuine arithmetic/status mistake in a supplied
report.

Independent numeric checks in this audit were run in exact/`binary64` arithmetic
and are reproduced inline; they are harness checks, not Lean proofs.

---

## 1. Declaration-by-declaration semantic audit of the three live modules

### 1.1 `SuccessiveAxisDiracWalk` (Route B, internal ℂ⁴)

Namespace `PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk`. `Mat4 = Matrix (Fin
4) (Fin 4) ℂ`.

| Declaration | Content | Verdict |
|---|---|---|
| `alpha1..3, beta` | explicit 4×4 Dirac α/β in the Weyl-like layout used by the project symbol | [true] |
| `generators_hermitian` | `αᵢ† = αᵢ`, `β† = β` | [true] — recomputed; all four are real-symmetric/Hermitian |
| `generators_square_one` | `αᵢ² = β² = 1` | **[true]; load-bearing for §4** — every Clifford generator squares to **+I** (a *positive* scalar) |
| `normalizedFactor a b g = a•1 − (I·b)•g` | one exact unitary factor on the circle `a²+b²=1` | [true] |
| `normalized_factor_unitary` | if `g†=g`, `g²=1`, `a²+b²=1` then `normalizedFactor` unitary | [true] |
| `successiveStep` | ordered product `f(α1)·f(α2)·f(α3)·f(β)` | **factor order x,y,z,mass; [true]** |
| `successive_step_unitary` | ordered product unitary given the four circle constraints | [true] — but a product of unitaries being unitary is *cheap*; the substance is the exactness of each factor, not the closure |
| `linearFactor eps coeff g = 1 − (I·eps·coeff)•g`; `linearSplit` | the **one-parameter** linear family (distinct object from `successiveStep`) | [true] |
| `linear_split_at_zero` | `linearSplit … 0 = 1` | [true] |
| `linear_split_entry_hasDerivAt` | `d/dε\|₀ (linearSplit)ᵢⱼ = (−I)·H(k,m)ᵢⱼ` | **derivative orientation −iH [true]** (Schrödinger `U=e^{−iHt}`) |
| `H_sq` | `H(kx,ky,kz,m)² = (kx²+ky²+kz²+m²)•1` | **[true]; positive scalar** = relativistic mass shell `E²=p²+m²` |
| `nondegenerate_1223_control` | `H(1,2,2,3)² = 18•1`, `H(1,2,2,3)≠0`, `successiveStep(3/5,4/5,…)` unitary | [true] (`1+4+4+9=18`, `(3/5)²+(4/5)²=1`) — genuine nondegeneracy gate |
| `real_symbol_matches_project` | `H(real) = Clifford3Plus1WalkSymbol.H` by `rfl` | **dictionary [true]** (definitional) |

**Derivative orientation.** The tangent generator is `−iH`, the standard
Schrödinger/Dirac sign. Hermiticity of `H(real k,m)` follows from
`generators_hermitian`, so `−iH` is anti-Hermitian and the flow it generates is
unitary — consistent with `successive_step_unitary`.

**Exact vs first-order — the one semantic subtlety to caption.** `successiveStep`
(exact unitarity) and `linearSplit` (the `−iH` derivative) are **two different
objects**. `successiveStep` carries **eight independent real parameters**
(`a,b` per factor) and therefore has *no single-parameter derivative*;
`linearSplit` is the genuine one-parameter family whose ε-derivative at 0 is
`−iH`. They agree only to **first order** (`a≈1, b≈ε·coeff`). The module never
claims the exact 8-parameter step has generator `−iH`; the caption is honest, but
Audit 12 should keep the distinction explicit: *exact unitarity* and *the `−iH`
tangent* are proved for **different** families that coincide at O(ε).

**Hermiticity / factor order / Clifford scalar.** All Hermitian; order
x,y,z,mass; `H²=(|k|²+m²)I` is a **positive** real scalar. This last fact is
decisive for §4 and contradicts a statement in Audit 10 (§4 below).

**Missing (correctly disclosed):** no position register, no conditional shift, no
lattice spacing, no product-limit/propagator convergence. Those are §6–§7.

### 1.2 `DiscretePluckerVariationalFlow`

Namespace `…Carrier.DiscretePluckerVariationalFlow`; `State = ℝ×ℝ`.

- `lagrangian mu q next = ½(next−q)² − ½·mu·q²` — one-link kinetic-minus-stiffness.
- `lagrangian_hasDerivAt_right`: `∂/∂next = (q−prev)` at `next=q`. **[true]**
- `lagrangian_hasDerivAt_left`: `∂/∂q = q−next−mu·q`. **[true]** (`−(next−q) − mu q`).
- `euler_lagrange_eq_adjacent_variations`: residual `(q−prev)+(q−next)−mu·q =
  (q−prev)+(q−next−mu·q)` — **honest link** from the two adjacent-link
  derivatives to the residual. **[true]**
- `euler_lagrange_iff_recurrence`: residual `=0 ⇔ next=(2−mu)q−prev`. **[true]**
- `step mu x = (x.2,(2−mu)x.2−x.1)`; `step_satisfies_euler_lagrange`. **[true]**
- `firstIntegral mu x = x.1²+x.2²−(2−mu)x.1x.2`; `first_integral_conserved`
  exact (`ring`). **[true]** — genuine non-constant quadratic invariant.
- `rational_plucker_flow_control`: `mu=4/25`, `(0,1)↦(1,46/25)` (`2−4/25=46/25`),
  residual 0, invariant `1↦1`. **[true]**
- `wrong_sign_control`: `firstIntegral(4/25,(1,54/25)) = 1057/625 ≠ 1`.
  **[true]; genuine negative control** (`1+(54/25)²−(46/25)(54/25) = 1+432/625`).
- `spinor_variational_flow_conserved`: stiffness `mu=massSq ψ φ`; conservation
  **and** `massSq = action(q+e₂)+action(q−e₂)−2·action(q)` (`action_positive_hessian`).
  **dictionary [true]** — the stiffness is literally the discrete second
  difference (Hessian) of the finite action.
- `rational_plucker_variational_control`: `massSq edge0 (edge1 (2/5)) = 4/25`;
  **witness [true]**, so `4/25` is realized by a genuine spinor pair, not inserted.

**Orientation/factor order:** the derivative signs are the ones that make the
sum of the two adjacent-link variations equal the residual; recurrence and
first integral are exact (no first-order truncation). No Hermiticity notion here
(real 2-D symplectic map, `det (step-Jacobian)=1`, trace `2−mu`).

### 1.3 `DiscretePluckerFlowStability`

Namespace `…Carrier.DiscretePluckerFlowStability`, reusing the live flow defs.

- `first_integral_decomposition`: `firstIntegral mu x = (mu/4)(x₁+x₂)² +
  ((4−mu)/4)(x₁−x₂)²`. **[true]** (expands to `x₁²+x₂²+(mu−2)x₁x₂`).
- `first_integral_nonnegative`: `0≤mu≤4 ⇒ 0≤firstIntegral`. **[true]** (both weights ≥0).
- `first_integral_zero_iff`: `0<mu<4 ⇒ (firstIntegral=0 ⇔ x=0)`. **positive
  definiteness [true]**.
- `iterate_first_integral_conserved`: invariant under `(step mu)^[n]`. **[true]**.
- `coordinate_bound`: `mu≤2 ⇒ (mu/2)(x₁²+x₂²) ≤ firstIntegral`. **[true]** —
  the gap is `((2−mu)/2)(x₁−x₂)² ≥ 0`, which needs `mu≤2` (not `mu≥0`).
- `all_iterates_bounded`: `0<mu≤2 ⇒ 0<mu/2 ∧ (mu/2)(‖iterate‖²) ≤ firstIntegral`.
  **uniform iterate bound [true]**.
- `spinor_all_iterates_bounded`: same with `mu=massSq ψ φ`, `0<massSq`,
  `massSq≤2`. **[true]** — the stability window is displayed in the hypotheses,
  not hidden in prose.
- `rational_stability_control`: `firstIntegral(4/25,(0,1))=1`,
  `(4/25)/2·1 = 2/25 ≤ 1`, and `firstIntegral 5 (1,−1) = −1 < 0`. **[true]**.
- `rational_plucker_stability_control`: `massSq=4/25`, in window, all iterates
  from `(0,1)` bounded by 1, and the `mu=5` indefinite control. **[true]**.

**Stability-window semantics — the one gap Audit 12 should carry.** Boundedness
of orbits actually holds on the **full** positive-definite window `0<mu<4`
(char-poly `λ²−(2−mu)λ+1`, `|2−mu|<2`; the invariant is a positive-definite
ellipse). The **landed uniform iterate bound covers only `0<mu≤2`**, because
`coordinate_bound` uses `(2−mu)≥0`. For `2<mu<4` orbits are still bounded but the
`(mu/2)`-coefficient bound degrades; a different (eigenbasis / `((4−mu)/4)`-based)
bound is needed. This is **not an error** (captions say `0<mu≤2`), but the
uniform-bound window is **conservative** relative to the true stability window
`0<mu<4`. Cheap follow-up in §7 runner-up.

**Every supplied dictionary in the three modules.**
1. `real_symbol_matches_project` : split-step tangent `H(real)` **=** project
   `Clifford3Plus1WalkSymbol.H` (definitional `rfl`).
2. `spinor_variational_flow_conserved` : recurrence stiffness `mu` **=** `massSq
   ψ φ` **=** finite-action discrete Hessian (`action_positive_hessian`).
3. `rational_plucker_variational_control` / `rational_plucker_stability_control`
   : `massSq edge0 (edge1 (2/5))` **=** `4/25` — the numeric fixture is a
   genuine Plücker invariant of a concrete edge pair, not a free constant.
All three dictionaries are recomputed correct and are load-bearing.

---

## 2. Independent check of S18 (`FixedMomentumManyStepContinuum`)

Harness: `Scripts/null_information_lab.py::s18_free_dirac_propagator`, `k=3/5`,
`m=4/5`, `t=1`, `c=ħ=1`, binary64 2×2 complex matrices.

**Analytic reference — [true].** `H = kσ_z + mσ_x = [[k,m],[m,−k]]`, `ω=√(k²+m²)`.
The imported `exact` matrix is exactly
`exp(−iHt) = cos(ωt)·I − i·(sin(ωt)/ω)·H`, i.e.
`[[cosωt − i(sinωt/ω)k, −i(sinωt/ω)m],[−i(sinωt/ω)m, cosωt + i(sinωt/ω)k]]`.
Recomputed identical to the harness. The step is
`walk = shift(kε)·coin(mε)` with `shift=exp(−ikεσ_z)`, `coin=exp(−imεσ_x)`
(`mass_phase=−1`) — a **first-order Lie–Trotter split** of `exp(−iεH)`.

**Error metric — [true].** Frobenius norm of `walk^n − exact`; a legitimate 2×2
operator-difference norm.

**Displayed `1/n` bound — recomputed.** Independent run:

```
n        :   8       16      32      64      128     256     512
error    : 0.07147 0.03571 0.01785 0.008925 0.004463 0.002231 0.001116
n·error  : 0.5718  0.5714  0.5712  0.5712   0.5712   0.5712   0.5712
D t²/n   : 5.55    2.78    1.39    0.694    0.347    0.173    0.0867
```

- **Convergence is genuinely `O(1/n)`**: `n·error → 0.5712` constant. This is the
  correct first-order Trotter rate; the true leading constant is ≈0.571,
  dominated by `½‖[σ_z,σ_x]‖`-type commutator content.
- **Monotone** (each halving): pass. **Final** `error(512)=0.001116 < 0.003`,
  `error(8)/error(512)=64.1 > 50`: pass. **Wrong mass phase** → `1.904`
  (`>0.5`, `>100×` correct): control fails as documented. All [true].
- The harness constant `D(k,m)≈44.4` makes `D t²/n` a **valid but very loose**
  upper bound (44.4 vs the true 0.571); the `bound_ok` check passes trivially.

**Where the `D(k,m)t²/n` bound actually lives — the precise answer requested.**

- The **shape** `error ≤ D(k,m)·t²/n` (fixed-time operator-norm, first-order
  splitting) is the standard Trotter estimate and is **attributed to a landed
  Lean theorem** `FixedMomentumManyStepContinuum.fixed_time_many_step_bound`,
  with convergence `…fixed_time_many_step_tendsto` and unitarity
  `…walk_mem_unitary`. **These declarations are NOT in this snapshot —
  [packaging].** Their correctness cannot be, and is not, asserted here beyond
  the packaging fact; Audit 12 with `PhysicsSM` in scope must confirm the Lean
  `D(k,m)` matches the claimed shape.
- The **specific constant** used by the Python (`ckm`, `dkm`) is a **harness
  reconstruction**, not necessarily the Lean constant. The harness only
  **numerically checks** `error ≤ dkm·t²/n` at `n=8..512`.
- The **monotonicity** and **`error(512)<0.003`** gates are **purely numerical
  harness checks**, not Lean theorems.
- The **analytic target `exp(−iHt)` is imported** (a closed-form 2×2 exponential),
  not derived from a PDE/infinite-volume propagator.

**S18 verdict:** an honest **V2 reproduction** of accepted 1+1 fixed-momentum
free-Dirac propagation. Precisely: *convergence + the `t²/n` bound = Lean
(imported anchor, [packaging] here); monotonicity + final-error = numerics;
analytic target = imported closed form.* Not a prediction, not a
position-space/PDE/`3+1` result — exactly as the manifest states.

---

## 3. Four over-claim checks + nondegeneracy gate on every new flagship

Checks: **C1 fidelity** (Lean = caption) · **C2 non-vacuity** (witnesses
genuinely nonzero) · **C3 hypothesis exposure** (all "supplied-not-derived"
assumptions displayed) · **C4 footprint** (`s o r r y`-free; axioms ⊆ `{propext,
Classical.choice, Quot.sound}`; guards) · **ND nondegeneracy gate** (positive
witness *and* a control that genuinely fails).

| Flagship | C1 | C2 | C3 | C4 | ND |
|---|---|---|---|---|---|
| `SuccessiveAxisDiracWalk` | pass — unitary + `−iH` tangent + `H²=(‖k‖²+m²)I`, all as captioned | pass — `H(1,2,2,3)≠0`, `18I`, real `(3/5,4/5)` unitary witness | pass — factors/coeffs supplied; exactness-vs-first-order distinct objects (§1.1) | in-file guards `{propext,Classical.choice,Quot.sound}`; **[packaging]** locally | **pass** — `nondegenerate_1223_control` (nonzero `H`, unitary witness) |
| `DiscretePluckerVariationalFlow` | pass — variational recurrence + first integral | pass — `4/25` from real edge pair; `wrong_sign_control` = `1057/625` | pass — one-link Lagrangian + time step **selected**; stiffness = action Hessian shown | in-file guards; **[packaging]** locally | **pass** — witness `(0,1)↦(1,46/25)`, control `1057/625≠1` |
| `DiscretePluckerFlowStability` | **[narrow]** — proves boundedness on `0<mu≤2`, though pos-def holds on `0<mu<4` (§1.3) | pass — `4/25` in window; `mu=5`, `firstIntegral=−1<0` control | pass — window `0<mu≤2` displayed in hypotheses | in-file guards; **[packaging]** locally | **pass** — `mu=5` indefinite control genuinely fails |
| S18 `FixedMomentumManyStepContinuum` | pass — V2 reproduction, correctly captioned | pass — real `O(1/n)`, ratio 64:1; wrong-phase 1.904 control | pass — imported target + conventions disclosed | **[packaging]** — Lean anchor not in snapshot; numeric gates are numeric | **pass** — wrong-mass-phase control fails hard |
| Target `AxisCoinNoGo` (in flight) | pass (as stated) | pass — companion invariant-4-space witness + `z+` anisotropy | pass | **`s o r r y` stub — not landed** (in flight) | pending |
| Target `FiniteGibbsVariance` (in flight) | pass (as stated) | pass — `Var=4/625>0`; degenerate `Var=0` control | pass | **`s o r r y` stub — not landed** (in flight) | pending |

No landed flagship fails a check. The only substantive item is the
`DiscretePluckerFlowStability` **[narrow]** caption on the uniform-bound window.
The two in-flight targets are, correctly, `s o r r y` stubs and must not be counted
as landed until C4 is met.

---

## 4. The two simultaneous-coin no-gos: manuscript sufficiency, truth, kernel proof

`axisBlockCoin = B⊕B⊕B` with `B = [[3/5,4i/5],[4i/5,3/5]]`. Recomputed:
`B` unitary, eigenpairs `(1,±1) ↦ 3/5 ± 4i/5` (each eigenvalue of the 6×6 coin
with **multiplicity 3**); `B² = [[−7/25,24i/25],[24i/25,−7/25]]`, eigenvalues
`−7/25 ± 24i/25` (non-real, distinct). Matches `axis_block_square_control`.

**(a) Positive-real no-go — enough for the manuscript?** The target
`axisBlockCoin_has_no_positive_clifford_block` denies a 4-D injectively-embedded
invariant restriction `H` with `H²=r•1`, `r∈ℝ`, `0<r`.

**Verdict: sufficient *only if* captioned honestly, and it is in fact the
physically decisive slice.** A genuine Clifford/Dirac generator squares to a
**positive** scalar: the project's own `generators_square_one` gives `αᵢ²=β²=+I`
and `H_sq` gives `H²=(‖k‖²+m²)I>0` (mass shell `E²=p²+m²`). So the naive "the
six-channel coin *is* the Dirac α/β set" hypothesis is exactly a **positive**
Clifford square, and the positive-real no-go kills it. However, as a `¬∃`, adding
`r∈ℝ ∧ 0<r` **weakens** the statement (rules out fewer objects); it leaves the
`r=−1` (`U²=−I`, γ-matrix-like) and non-real cases open. For the manuscript the
positive-real version suffices to motivate Route B **provided** it is captioned
"no *positive* Clifford square" and paired with the non-vacuity witness
(`ConcreteD4InvariantSector`: a real rank-4 invariant sector *does* exist, so the
kill is about the square, not the subspace). It should **not** be read as "no
Clifford block of any kind."

> **[error] recorded against Audit 10 §1.3.** Audit 10 claims "a genuine 3+1
> Dirac step needs `H²=−k²·I` (a *negative* real scalar, the mass-shell) … the
> positive-real `0<r` slice is not the physically decisive one." This is wrong:
> the Dirac symbol and its generators square to **+**(‖k‖²+m²)`I` (see `H_sq`,
> `generators_square_one`). The positive-real slice **is** the physically
> decisive one for a Clifford generator; the complex/negative extension is a
> *mathematical* strengthening (it additionally rules out `r=−1` and non-real
> `r`), not a physical correction. Audit 12 should propagate this.

**(b) Complex-scalar no-go — true as stated?** Statement: no 4-D injective
`inc` with `U∘inc=inc∘H` and `H²=z•1` for **any** `z∈ℂ`.

**Verdict: TRUE, and strictly stronger than (a).** Each eigenspace `E±` of `U`
has dimension 3. Any `inc` injective on ℂ⁴ gives a 4-D invariant `range(inc)`; it
cannot sit inside a single 3-D `E±`, so `H` carries **both** eigenvalues `3/5±4i/5`,
whose squares `−7/25±24i/25` **differ**, so `H²` has ≥2 eigenvalues and is never
scalar. Equivalently: no two eigenvalues of `U` sum to 0 (`2λ+=6/5+8i/5≠0`,
`2λ−≠0`, `λ++λ−=6/5≠0`), so `±√z` are never both eigenvalues. (Note the helper
`axis_coin_sq_minus_real_injective` — `U²−rI` injective for all *real* `r` — is
[true] because the eigenvalues of `U²` are non-real; but it does **not** extend
to complex `z`, which is exactly why the finrank argument is required for (b).)

**Shortest architecture for the kernel-finrank lemma (b).** One load-bearing
lemma, then a two-line contradiction:

```
-- U := axisBlockCoin.  U² is block-diagonal B²⊕B²⊕B².
lemma ker_sq_minus_scalar_finrank_le_three (z : ℂ) :
    finrank ℂ (LinearMap.ker (mulVecLin (U*U) - z • LinearMap.id)) ≤ 3
```
Proof of the lemma: `U*U = B²⊕B²⊕B²`, so the kernel is the direct sum over the
three blocks of `ker(B² − zI)`. Because `B²` is **non-scalar** (distinct
eigenvalues `−7/25±24i/25`, equivalently `axis_block_coin_sq_ne_scalar`),
`B²−zI ≠ 0` for every `z`, hence `rank(B²−zI) ≥ 1` and `finrank ker(B²−zI) ≤ 1`
per block. Sum ≤ 3. ∎

Discharge of the no-go from the lemma: given `inc`, `H`, `z` with the hypotheses,
for every `v`: `(U²)(inc v) = inc(H² v) = inc(z•v) = z•(inc v)`, so
`range(inc) ⊆ ker(U²−z•id)`; `inc` injective ⇒ `finrank range(inc)=4`; then
`4 ≤ finrank ker(U²−z•id) ≤ 3` — contradiction. ∎

This is the minimal path: the entire complex case reduces to the single algebraic
input "`B²` is not a scalar" (already a landed block fact) plus per-block
`rank ≥ 1 ⇒ ker ≤ 1`. **Recommendation:** land the **complex-scalar** version as
the flagship no-go (it closes the `r=−1` loophole a referee will ask about) with
the positive-real statement as an immediate corollary, and keep
`ConcreteD4InvariantSector` beside it as the non-vacuity guard.

---

## 5. Exact corrections to the three matrices

### THEORY_COMPLETION_MATRIX.md
1. **Dynamics and action row.** Status "positive stability running" is **stale**:
   `DiscretePluckerFlowStability` is **landed** — weighted-square decomposition,
   nonneg on `0≤mu≤4`, positive-definite on `0<mu<4`, and a **uniform iterate
   bound on `0<mu≤2`** (witness `4/25`, control `mu=5`). Update grade to `D/H`
   and set the remaining rung to "extend the uniform bound from `0<mu≤2` to the
   full positive-definite window `0<mu<4`; primitive action selection /
   interactions open."
2. **Kinematics and causal support row.** Keep Route B as internal-only. The
   deliverable "finish the simultaneous-coin no-go" is now two named targets;
   record both, and mark the intended landing as the **complex-scalar** form
   (positive-real as corollary) per §4. Add the §6 spatial-shift statement as the
   exact next Route-B deliverable and the §7 rate as the one after.
3. **Empirical-prediction / composition-landings note.** The count "fourteen
   families PASS: thirteen at V0/V1 plus a disclosed V2" is now **numerically
   correct** (S01,S02,S03,S05,S06,S07,S08,S12,S13,S15,S16,S17,**S19** = 13 V0/V1;
   **S18** = the single V2), but the sentence predates S18/S19 by timestamp;
   re-date it and cite S18 as the V2 and S19 as the 13th V0/V1.

### MANUSCRIPT_CLAIM_MATRIX.md
4. **M19 status** "…chain landed; **stability running**" → "**stability
   landed** (`DiscretePluckerFlowStability`): pos-def first integral on `0<mu<4`,
   uniform iterate bound on `0<mu≤2`; remaining rung = close the `2<mu<4`
   uniform-bound gap." Add explicitly that the uniform-bound window (`0<mu≤2`) is
   narrower than the boundedness window (`0<mu<4`).
5. **M16 status** "action-derived recurrence running" is **stale** — the
   action-derived recurrence is **landed** (that is exactly M19). Change to
   "action-derived recurrence landed (M19); the oscillator group remains a
   *supplied*, distinct (abelian, single-frequency) object."
6. **M6 status** — keep "internal Route B landed; no-go running", but name the
   **complex-scalar** no-go as the target (positive-real as corollary) and note
   the physically decisive square is **positive** (§4), correcting any
   "negative mass-shell" phrasing inherited from Audit 10.
7. **Missing row.** There is no `M18` and no dedicated stability row. Either
   add an `M18` for `DiscretePluckerFlowStability` or fold its content into M19;
   do not leave stability unrepresented while it is landed.

### SIMULATION_BENCHMARKS.md
8. **S18 row** is accurate; tighten the pass metric to record that the
   `D(k,m)t²/n` bound is a **Lean anchor ([packaging] here)** while the
   monotonicity and `error<0.003` gates are **numerical**, and that the target
   `exp(−iHt)` is **imported**. Optionally note the empirical rate constant
   `n·error → 0.571`.
9. **S19 row** — update status to reference the now-landed
   `DiscretePluckerFlowStability`: "finite variational evolution/conservation
   **and** finite Lyapunov stability landed; primitive action selection open."
10. **New empirical V2 rows are unassigned.** The Schottky and dispersion V2s
    (§8) must take **new IDs (S20, S21)** — see the Grand-Strategy error below.

### Grand Strategy 04 (status error to record)
> **[error] GS-04 §2/§5 benchmark numbering.** GS-04 labels the Schottky
> specific-heat V2 as **"S18"** (lines ~249, 508) and the checkerboard-dispersion
> V2 as **"S19"** (line ~537). In the live simulator **S18 = fixed-momentum
> free-Dirac propagator** and **S19 = action-derived variational flow**; both IDs
> are taken. The Schottky and dispersion reproductions are unlanded and must be
> assigned **S20 / S21**. GS-04's own top reconciliation already flags the
> isolated `9/25` as a typo (correct value `4/25`); this benchmark-ID clash is a
> second status error. (`variance(twoLevel 4/25)@β=0 = 4/625` is [true] and is
> the anchor for the **Schottky** V2, not for S18.)

---

## 6. Exact theorem: finite position register + conditional shifts for Route B

Add a **finite periodic position register** `Fin L` (`L ≥ 2`) tensored with the
internal `ℂ⁴`, a **unitary cyclic shift**, and a **chirality-conditional** shift
built from the sign blocks of `β`. Factor-ordering convention: **coin first, then
shift**, `W = S ∘ (1_pos ⊗ C)`, matching the `U=e^{−iHt}` orientation of §1.

```lean
open Matrix
namespace RouteBSpatialWalk
variable (L : ℕ)

/-- Unitary cyclic shift on the position register `Fin L` (a permutation). -/
def cyc (dir : Bool) : Matrix (Fin L) (Fin L) ℂ :=
  fun i j => if (if dir then i = j + 1 else j = i + 1) then 1 else 0

/-- Chirality projectors from the ±1 eigenblocks of `beta` (upper/lower pair). -/
def Pup  : Matrix (Fin 4) (Fin 4) ℂ := !![1,0,0,0; 0,1,0,0; 0,0,0,0; 0,0,0,0]
def Pdn  : Matrix (Fin 4) (Fin 4) ℂ := !![0,0,0,0; 0,0,0,0; 0,0,1,0; 0,0,0,1]

/-- Conditional shift: `+` on the upper chirality, `−` on the lower one. -/
noncomputable def condShift : Matrix (Fin L × Fin 4) (Fin L × Fin 4) ℂ :=
  Matrix.kroneckerMap (·*·) (cyc L true)  Pup
    + Matrix.kroneckerMap (·*·) (cyc L false) Pdn

/-- One space+coin step (coin then shift), coin = the landed mass factor. -/
noncomputable def spatialWalk (bm am : ℝ) : Matrix (Fin L × Fin 4) (Fin L × Fin 4) ℂ :=
  condShift L *
    Matrix.kroneckerMap (·*·) (1 : Matrix (Fin L) (Fin L) ℂ)
      (SuccessiveAxisDiracWalk.normalizedFactor am bm SuccessiveAxisDiracWalk.beta)

/-- MAIN: the space+coin successive walk is exactly unitary (finite, exact). -/
theorem spatialWalk_unitary (bm am : ℝ) (hL : 2 ≤ L) (h : am^2 + bm^2 = 1) :
    (spatialWalk L bm am)ᴴ * (spatialWalk L bm am) = 1 ∧
      (spatialWalk L bm am) * (spatialWalk L bm am)ᴴ = 1

/-- NONZERO WITNESS: the walk genuinely transports — starting localized at
    (site 0, upper chirality) it puts nonzero amplitude at the *neighbouring*
    site 1, so `W ≠ 1_pos ⊗ C`. -/
theorem spatialWalk_transports :
    (spatialWalk 3 (4/5) (3/5)) (⟨1,by decide⟩, ⟨0,by decide⟩)
                                (⟨0,by decide⟩, ⟨0,by decide⟩) ≠ 0

/-- NEGATIVE CONTROL: replacing the unitary cyclic shift by the non-injective
    "collapse to site 0" shift breaks unitarity — motion must be by a bijection. -/
def collapse : Matrix (Fin L) (Fin L) ℂ := fun i _ => if i = 0 then 1 else 0
theorem collapse_walk_not_unitary (hL : 2 ≤ L) :
    ¬ ((Matrix.kroneckerMap (·*·) (collapse L) (Pup) *
        Matrix.kroneckerMap (·*·) (1 : Matrix (Fin L) (Fin L) ℂ)
          (SuccessiveAxisDiracWalk.normalizedFactor (3/5) (4/5)
            SuccessiveAxisDiracWalk.beta))ᴴ *
       (…) = 1)
end RouteBSpatialWalk
```

- **Factor-ordering convention (explicit):** `W = S·(1⊗C)` (coin acts first).
  With `S = exp(−i·shift-generator)` and `C` the internal factor, the first-order
  generator is `−i(H_kinetic ⊕ H_mass)` in the §1 orientation; the ordering is
  Trotter-first-order, to be symmetrized (Strang) before any `O(ε²)` claim.
- **Nonzero witness:** `spatialWalk_transports` — genuine displacement to site 1.
- **Negative control:** `collapse_walk_not_unitary` — a non-bijective shift
  destroys unitarity, proving the position dynamics must be by a permutation.

This is the minimal exact statement that turns Route B from an internal-space
algebra into a genuine finite spacetime walk (still one axis + mass; the full
`x,y,z` conditional-shift product with anticommuting internal factors is the next
increment and demands the symmetrized ordering of Audit 10 §2.4).

## 7. Quantitative convergence theorem after the spatial walk

Work fiberwise in momentum on a **compact** domain; norm = fiber operator norm.

```lean
/-- For every |k| ≤ K and every n, the n-step fixed-momentum spatial walk is
    within `Dbox(K,m)·T²/n` of the exact 1+1 Dirac evolution, in fiber operator
    norm, and the bound → 0.  (K compact; explicit rate 1/n.) -/
theorem spatialWalk_fixedTime_bound
    (K m T : ℝ) (hK : 0 ≤ K) (hT : 0 ≤ T) :
    ∃ Dbox : ℝ, 0 ≤ Dbox ∧
      ∀ (k : ℝ), |k| ≤ K → ∀ n : ℕ, 0 < n →
        ‖ (walkSymbol (k/n) (m/n)) ^ n
            - Complex.exp (-(T:ℂ) * Complex.I) • diracEvol k m T ‖ ≤ Dbox * T^2 / n

theorem spatialWalk_fixedTime_tendsto (K m T : ℝ) (k : ℝ) (hk : |k| ≤ K) :
    Filter.Tendsto
      (fun n => ‖ (walkSymbol (k/n) (m/n))^n - diracEvol k m T ‖)
      Filter.atTop (nhds 0)
```

- **Explicit norm:** the `2×2` (per momentum fiber) operator norm; equivalently
  Frobenius, since it is a fixed finite dimension.
- **Compact momentum domain:** `|k| ≤ K`; the constant `Dbox(K,m)` is **uniform**
  over that box (this is the box-uniform upgrade of the pointwise S18 bound,
  mirroring `BoundedMomentumManyStepContinuum`).
- **Rate:** `O(1/n)` at fixed `T` (first-order Trotter), consistent with the
  measured `n·error → 0.571` at `(k,m)=(3/5,4/5)`.
- **Falsifier:** the S18 control lifted — reversing the imaginary mass phase
  makes `walkSymbol` converge to `exp(−iH')` with `H'≠kσ_z+mσ_x`, so the bound is
  violated for large `n`; equivalently, any `(k,n)` in the box with
  `error > Dbox·T²/n`, or `n·error` not bounded, kills it.

Position-space/`ℓ²`, PDE, and `3+1` limits remain explicitly open beyond this
fixed-momentum, compact-`k`, first-order rung.

## 8. The single highest-value empirical V2 after S18

Candidates (both are GS-04 proposals, now needing new IDs): **Schottky
two-level specific heat**, **1+1 checkerboard dispersion**, or another.

**Pick: Schottky two-level specific heat / fluctuation-response — new ID S20.**

- **Why over dispersion:** the checkerboard dispersion `cos(ωa)=cos(ka)cos(ma)`
  is kinematically the **same** `H=kσ_z+mσ_x` content that S18 already reproduces
  (its eigenphases are `±ω(k)`), so it is largely redundant with the landed V2.
  Schottky is an **independent thermodynamic** confrontation that reuses the
  already-landed `FiniteGibbsResponse` plus the in-flight `FiniteGibbsVariance`,
  and exhibits a *named* accepted-physics feature (the Schottky anomaly) absent
  from anything landed. Highest marginal value, lowest new machinery.
- **Accepted-physics reference (self-generated analytic, no dataset, no fit):**
  `⟨E⟩ = Δ/(1+e^{βΔ})`, `Var(E)=Δ²e^{βΔ}/(1+e^{βΔ})²`,
  `C(β)=β²·Var(E)=β²Δ²e^{βΔ}/(1+e^{βΔ})²`. Independently confirmed peak
  **C ≈ 0.4392 at βΔ ≈ 2.399**, `C(0)=0`.
- **Lean/source anchor:** `FiniteGibbsResponse.log_partition_hasDerivAt`
  (`d log Z/dβ=−⟨E⟩`) + `FiniteGibbsVariance.meanEnergy_hasDerivAt`
  (`d⟨E⟩/dβ=−Var`) + `rational_two_level_variance_control` (`Var(4/25)@β=0=4/625`).
  *Prerequisite:* the `FiniteGibbsVariance` stub must land first (§3, still
  `s o r r y`).
- **Observable:** heat capacity `C(β)` (and `⟨E⟩`, `Var`) on a `β` grid, gap
  `Δ=4/25`.
- **Units:** `Δ`, `β⁻¹` in dimensionless action units (`k_B=1`); `C` dimensionless;
  exact/rational at fixtures (`β=0`: `⟨E⟩=2/25`, `Var=4/625`, `C=0`).
- **Error metric:** max absolute deviation of the simulated `C(β)` grid from the
  analytic curve (`=0` at rational fixtures, `<10⁻¹⁰` on the grid) **plus**
  anomaly-peak location within grid spacing.
- **Negative control:** degenerate spectrum (`degenerate_spectrum_zero_control`)
  ⇒ `Var=C=0` for all `β` — no anomaly.
- **Falsifier:** simulated `C≠β²Var`, wrong peak location, or `C<0` anywhere
  (would contradict `variance_nonnegative`).

**Runner-up (dynamics layer):** the `0<mu≤2 → 0<mu<4` uniform-bound extension of
§1.3 — cheap, closes the one open rung on the stability flagship — but it is a
Lean strengthening, not an empirical V2.

---

## Consolidated defect ledger for Audit 12 / 07:00 hard audit

1. **[error] Audit 10 §1.3** "Dirac needs `H²=−k²I` (negative real)": false —
   `H²=+(‖k‖²+m²)I` and `αᵢ²=β²=+I`; positive-real is the decisive slice (§4).
2. **[error] Grand Strategy 04 §2/§5** benchmark IDs: Schottky mislabeled "S18",
   dispersion "S19"; live S18/S19 are the Dirac propagator / variational flow;
   new V2s must be S20/S21 (§5, §8).
3. **[narrow] `DiscretePluckerFlowStability`**: uniform iterate bound landed only
   on `0<mu≤2`, though positive-definiteness/boundedness holds on `0<mu<4`; caption
   honest but window conservative (§1.3, §5, §7 runner-up).
4. **[stale] MANUSCRIPT_CLAIM_MATRIX M16 & M19 / THEORY_COMPLETION_MATRIX Dynamics**:
   action-derived recurrence and stability are **landed**, not "running"; no
   stability row exists (§5).
5. **[semantic] `SuccessiveAxisDiracWalk`**: exact unitarity (8-param
   `successiveStep`) and the `−iH` tangent (1-param `linearSplit`) are proved for
   **different families** coinciding only to first order — keep captioned (§1.1).
6. **[packaging] S18**: the `D(k,m)t²/n` bound + convergence are Lean anchors
   **absent from this snapshot**; monotonicity/`<0.003` are numerics; target
   `exp(−iHt)` is imported. Independent rate `n·error→0.571` (§2).
7. **Recommended flagship no-go = complex-scalar** (positive-real as corollary),
   discharged by the one-line finrank lemma "`ker(U²−zI) ≤ 3 < 4` because `B²` is
   non-scalar" (§4).
