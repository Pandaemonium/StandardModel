# Grand strategy 7 — the strict `3+1` successor

Aristotle, 2026-07-12. Grand-strategy pass for the B-lane after the corrected
charge theorem, the exact live census, the affine phase-commutator no-go, and
the reciprocal conditional-shift survivor. Discipline: **KERNEL** = a named
declaration in `PhysicsSM/Draft/NullEdge/*.lean` that I read directly; **AUDIT**
= exact CAS re-derivation in `RECIPROCAL_FAMILY_SIGN_AUDIT_REPORT.md`; **VERIFY**
= imported literature fact not yet kernel-encoded; everything else is strategy.
No Lean code was written or edited for this report.

---

## 0. Executive summary

The corrected results have collapsed the problem into a single, sharp fork with
a precisely located crux.

* **The globally-chiral class is (almost) closed.** With a constant Hermitian
  `Ξ = -i α₁α₂α₃` commuting with the whole step, each Weyl sector is a `2×2`
  determinant-locked block, the two sector charges cancel
  (`CubicWeylSectorCharge.liveDiracSectorCharges_cancel`), and one nonzero
  sector crossing forces a partner (`ChargeBalanceForcesPartner`). The only
  missing rung is the source-pending strong-triviality input A3 (VERIFY). This
  is objective **(B)** and it is nearly a discrete-time Nielsen–Ninomiya for a
  *named* architecture.
* **The escape is exactly one codimension wide.** Any single-cone strict-local
  candidate must have `U_perp = (U - ΞUΞ)/2 ≠ 0` with **vanishing constant and
  linear jets** (`ChiralityMixingNecessity.diracFirstJet_perp_eq_zero`,
  `QuadraticChiralityRegulator.regulator_hasFDerivAt_zero`): chirality mixing
  that begins at **quadratic** order and leaves the Dirac first jet intact.
* **Pure-phase regulators cannot enter that door.** Integer-frequency phase
  commutators are invisible on the cubic 2-torsion corners and unchanged by
  affine offsets (`CommutatorCornerInvisibility`, `CommutatorPiPeriodicity`).
  The corners are exactly where the free doublers live
  (`FullBlochZeroClassification`: crossings ⇔ all three `cos qⱼ = 0`). So the
  escape **requires a noncentral, `z`-dependent conditional shift**, not phases.
* **The only corner-visible primitive found so far is killed in its naive
  embedding — but for a reason that names the fix.** The reciprocal
  conditional-shift `S(z) = K(z)K(z⁻¹)` is unitary, `det = 1`, quadratically
  flat at `z=1`, and *noncentral at `z=-1`* (`ReciprocalConditionalShiftRegulator`).
  The audit proves its naive **chirality-register** embedding forces a second
  zero-quasienergy root, but the mechanism is entirely `det U_± = -1` at the
  body center (condition **(R)** `det U_+·det U_- ≡ 1` fails). **The escape
  therefore lives precisely where the reciprocal word is `Ξ`-odd yet the two
  sectors carry reciprocal determinants.**

**Recommendation.** Run three tracks in parallel, ranked below: **(P1)** the
chirality-*coupled* reciprocal walk as the flagship shot at objective (A);
**(P5)** the phase-word + global-chirality bounded-family no-go as the
near-ready objective (B) paper; **(P4)** the exactly-unitary minimally-doubled
walk as the guaranteed-true hedge ("one is impossible in this class, two is
achievable and minimal"). P2 and P3 are structured fallbacks for P1.

---

## 1. The corrected problem, stated against the live objects

Target: a Laurent-finite `U : T³ → U(d)` (translation invariant, exactly
unitary, `d < ∞`) with **exactly one** `±1`-quasienergy crossing on the whole
zone (the origin), carrying an involutory unit-speed Dirac tangent
`F₀(n) = Σ nⱼ αⱼ`, `F₀² = I`.

The live baseline is the ordered range-one word
```
splitStep qx qy qz θ = factor qx α₁ · factor qy α₂ · factor qz α₃ · factor θ β,
factor x A = cos x · I − i sin x · A            (FullBlochSplitDeterminants)
```
with `α₁,α₂,α₃,β` the standard Dirac matrices. Established facts I will build on:

| Fact | Declaration | Content |
|---|---|---|
| exact unitary, `det=1` per factor | `det_factor_alphaⱼ`, `M_det` | each factor is `SU`-type; whole word `det=1` |
| crossing set | `FullBlochZeroClassification.live_det_sub_one_eq_zero_iff` / `_add_one_` | `det(U∓I)=0` ⇔ `algebraZero/Pi = 0`; SOS factorization `algebraZero_factor` |
| corners are 2-torsion | same | crossings ⇔ `cos qx=cos qy=cos qz=0` (the eight half-zone corners) + body center |
| full Dirac tangent is neutral | `DiracLocalChargeNeutrality.massBlend*` | `massBlend c s F β` interpolates `F₀ → β` through involutions; no nonzero class-A charge from the tangent alone |
| global chirality boundary | `FullBlochGlobalChirality.splitStep_commutes_iff_sin_theta_zero` | `[Ξ,U]=0 ⇔ sin θ = 0` |
| massless block split | `massless_splitStep_commutes_plusProjector` | `plusProjector` commutes with the massless step at every `q` |
| sector charge API | `SU2LocalCrossingCharge.localCrossingCharge` | `= sign(det J₃)`; `weylPlus=+1`, `weylMinus=-1`, cancel |
| live sector charges | `CubicWeylSectorCharge.liveDiracSectorCharges_cancel` | live `4×4` tangent restricts to `σ` and `-σ`, charges `+1,-1` |
| live census | `LiveMasslessWeylCensusBridge`, `LiveWeylJacobian.det_weylJacobian` | `det J = u₀·(cos²qy − sin²qy)`; 16 nodes nondegenerate, signed sums cancel per sector |
| escape resource | `ChiralityMixingNecessity.diracFirstJet_perp_eq_zero`, `perpPart_one_eq_zero` | `U_perp` has zero constant and linear jet when the tangent commutes with `Ξ` |
| quadratic escape exists | `QuadraticChiralityRegulator.explicit_nonzero_chirality_mixing` | `q(k)R`, `q=Σkⱼ²`, zero fderiv at `0`, nonzero on an axis |
| phase words blind on corners | `CommutatorCornerInvisibility.regulator_corner_trivial`, `product_corner_trivial`; `CommutatorPiPeriodicity.regulator_corner_sign_invariant` | integer-frequency phase commutators + affine offsets = origin at every corner |
| conditional shift survivor | `ReciprocalConditionalShiftRegulator` | `S(z)=K(z)K(z⁻¹)`, unitary on circle, `det=1`, `S(z)-1=(z-1)²Q(z)`, `S(-1)∓I` both nondegenerate, `D(-1)` noncentral |
| charge balance hinge | `ChargeBalanceForcesPartner.exists_second_nondegenerate_of_total_charge_zero` | total 0 + one nonzero ⇒ distinct nondegenerate partner |
| Laurent unit rigidity | `LaurentUnitResource.qca_det_is_unique_monomial`, `two_term_not_isUnit` | a `1`-variable Laurent QCA determinant is a single monomial |

**The crux (one sentence).** A single-cone strict walk needs an operator that
is simultaneously (i) noncentral on the cubic 2-torsion corners (to gap the
doublers pure phases cannot touch), (ii) `Ξ`-odd starting at quadratic order (to
leave the control class while preserving the Dirac first jet), and (iii)
determinant-paired `det U_+·det U_- ≡ 1` along origin-avoiding paths (to keep
`det(U−I)` real so no intermediate-value root is forced). Reciprocal shifts give
(i)+(ii singly); the naive embedding fails (iii). **The whole program is the
search for one word that has all three.**

---

## 2. Five explicit architectures (exact formulas)

Notation: band Pauli `ρ_{x,y,z}`, chirality Pauli `τ_{x,y,z}` on `ℂ² ⊗ ℂ²`,
`Ξ = τ_z`. `z_j = e^{iqⱼ}`, `c_j = cos qⱼ = (z_j+z_j⁻¹)/2`,
`s_j = sin qⱼ = (z_j−z_j⁻¹)/2i`. `D(z) = diag(z,1)`. The `3-4-5` coin is
`C = !![3/5,4/5;-4/5,3/5]` (as in the kernel). `Sword(z_x,z_y,z_z) =
S(z_x)S(z_y)S(z_z)` with `S` the reciprocal word.

### P1 — Chirality-COUPLED reciprocal conditional-shift walk (`d = 4`) — FLAGSHIP

Put the chirality mixing *inside* the coin so that the reciprocal word is
`Ξ`-odd, instead of block-diagonal in chirality (which stays in the control
class). Fix a coin that couples band and chirality:
```
C̃ = cos φ · I₄ + i sin φ · (ρ_x ⊗ τ_x),     (3-4-5 values cos φ = 3/5, sin φ = 4/5)
K̃(z) = D̃(z) · C̃ · D̃(z⁻¹) · C̃⁻¹,   D̃(z) = diag(z,1)_band ⊗ I₂ = ((1+ρ_z)/2)·z + (1−ρ_z)/2,
S̃(z) = K̃(z) · K̃(z⁻¹),
U₁(q) = ( S̃(z_x) S̃(z_y) S̃(z_z) ) · splitStep(qx,qy,qz, 0).
```
* Laurent-finite: `D̃` has entries `{z,1}`, `C̃` is constant, so `K̃, S̃` are
  Laurent with poles only at `z=0` (off the circle). Range two per axis after
  the `K(z)K(z⁻¹)` doubling. `det S̃ = 1` (as for the `2×2` word;
  `det D̃(z)·det D̃(z⁻¹) = 1`).
* Symmetry / roots (predicted): because `C̃` mixes `ρ,τ`, `S̃` is genuinely
  `Ξ`-odd — this is the honest fix to the audit's F-D register bug. `S̃(1)=I`
  and `S̃(z)-I = (z-1)²Q̃(z)` (commutator flatness survives the coupling), so the
  **Dirac first jet is intact** and `U_perp` begins at quadratic order —
  exactly the `ChiralityMixingNecessity` resource. The real coin gives the
  particle-hole relation `U₁(−q) = \overline{U₁(q)}` (reality of the `3-4-5`
  entries), which is the natural route to condition **(R)**. **Risk point:** the
  mixed-sign body centers `(±π/2,±π/2,∓π/2)`, where the audit found
  `det U_± = −1`; the coupling must gap these without violating (R). This is the
  single number the construction lives or dies on and must be a torus
  certificate, not a fixture.

### P2 — Determinant-paired double-band reciprocal walk (`d = 8`) — (R) by construction

Enforce (R) structurally by running the reciprocal word forward in one
chirality sector and *inverse* in the other, tied by an off-diagonal flip:
```
U₂(q) = exp(i χ · τ_x ⊗ ρ_y) · [ Sword(z) ⊗ P_+  +  Sword(z)⁻¹ ⊗ P_- ] · splitStep(q,0)⊗I₂,
```
with a small constant chirality-flip generator `τ_x⊗ρ_y` giving quadratic-order
mixing. Then `det U_+ · det U_- = det Sword · det Sword⁻¹ = 1` **identically**,
so `det(U₂−I) ∈ ℝ` on every path (F-B closed by construction) and the reciprocal
sign obstruction of the audit **cannot fire**. Cost: internal dim `8` (band ⊗
chirality ⊗ replica). Highest chance of a *certifiable* unique cone; weakest on
"smallest". Range two per axis.

### P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure

Add a Cayley-unitarized Wilson term that vanishes quadratically at the origin
and grows to the corners:
```
W(q) = r · Σ_j (1 − c_j) · β,                    (Hermitian, Ξ-odd via β)
U₃(q) = (I − i W(q))(I + i W(q))⁻¹ · splitStep(q,0)   [Cayley] 
     or  U₃(q) = splitStep(qx,qy,qz, θ_W(q))  with cos θ_W = f(Σ(1−c_j)).
```
* Laurent-finite in the *symbol* sense: `1 − c_j = 1 − (z_j+z_j⁻¹)/2` is
  Laurent; the Cayley transform is a finite Laurent *unit* iff the denominator
  is a Laurent unit (needs `det(I + iW)` a monomial — check via
  `LaurentUnitResource.qca_det_is_unique_monomial`; if not, use the
  mass-angle form `θ_W(q)`, which is manifestly Laurent per factor but makes the
  Wilson profile a bounded-range trigonometric mass).
* Symmetry / roots: retains the **full cubic point group** (`W` is symmetric in
  `c_j`); particle-hole is broken by `W` — which is exactly permitted, since P3
  deliberately leaves the global-chiral class. Predicted root set: **unique cone
  at the origin, all seven doublers gapped** (textbook Wilson). Lowest novelty
  (it is the Wilson mechanism), but a strict-local *exactly unitary discrete-time*
  Wilson walk with a **kernel-certified** unique cone is still a clean, true,
  citable theorem and the safest positive result.

### P4 — Minimally-doubled (Karsten–Wilczek) unitary walk (`d = 4`) — the honest minimum

Do not try for one cone; achieve exactly **two**, related by a valley symmetry,
and package as a flavor doublet:
```
U₄(q) = factor qx α₁ · factor qy α₂ · factor qz α₃ · factor(θ_KW(q)) β,
θ_KW(q) chosen so that cos θ_KW = ζ·(cos qx + cos qy + cos qz − 1),   |ζ| tuned so the mass
vanishes at exactly q = 0 and one axis corner, and is nonzero at all others.
```
* Laurent-finite range one; retains a single-axis `C₄` symmetry and the
  valley-exchange symmetry mapping the two surviving cones.
* Predicted root set: **exactly two** zero-quasienergy cones (origin + one
  corner), everything else gapped. This is the sharp, provable "you cannot get
  one on the hypercubic strict-local involutory class, two is the minimum"
  statement — the cleanest guaranteed-true theorem in the batch.

### P5 — The bounded-family no-go (objective B) — near-ready

Class `𝒞`: symbols of the form `(onsite coin) · (per-axis range-one Dirac
factor) · (integer-frequency phase-commutator word)` with a constant `Ξ`
commuting with the whole symbol (global chirality). Claim: **no member of `𝒞`
has a unique `±1` cone.** Assembled entirely from kernel pieces plus one VERIFY
input:
```
global chirality (A2)  +  full-Dirac neutrality (A0)  +  sector charge cancellation (A1)
  +  charge-balance hinge (A4)  +  corner invisibility + π-periodicity (phase words are
     origin at every corner)  +  A3 [VERIFY: strict-Laurent K¹ strong triviality per sector]
  ⇒  every phase-regulated globally-chiral strict word retains a corner doubler.
```
This is a genuine *discrete-time Nielsen–Ninomiya for a named architecture*. The
only non-kernel dependency is A3 (Read/BHS strong triviality of
`K¹(T³)`), which must be full-text verified and never encoded as an axiom.

---

## 3. Which architectures are finite Laurent polynomials

| Arch. | Laurent-finite? | Determinant | Range | Encodable torus certificate |
|---|---|---|---|---|
| P1 | Yes (`D̃` entries `{z,1}`, poles at `z=0` off circle) | `det = 1` monomial | 2/axis | Yes — `z_j=c_j+is_j`, `c_j²+s_j²=1`, SOS on `det(U₁∓I)` real part |
| P2 | Yes (same, replicated) | `det = 1` | 2/axis | Yes — (R) is definitional, real det is automatic |
| P3 | Symbol Laurent; Cayley finite **iff** `det(I+iW)` monomial (check `qca_det_is_unique_monomial`), else use `θ_W` form | monomial | 2/axis | Yes — cubic-symmetric SOS, mirrors `algebraZero_factor` |
| P4 | Yes, range one | `det = 1` | 1/axis | Yes — two-cone root count by SOS + `decide` on the corner list |
| P5 | (no-go; symbols are the `𝒞` family, all Laurent) | n/a | n/a | Certificate = the charge/corner algebra, not a root exclusion |

The torus certificate mechanism for all constructive cases is the **same one
already used in the repo**: substitute `z_j = c_j + i s_j` with `c_j²+s_j²=1`,
reduce `det(U∓I)` to a real polynomial (this needs `det U = 1`, true for
P1/P2/P4 by monomial determinant; for P3 by construction), and discharge
"no root except the origin" by a sum-of-squares / Positivstellensatz identity of
exactly the shape of `FullBlochZeroClassification.algebraZero_factor` together
with `sfactor_nonneg`/`kfactor_pos`. The origin is saturated away by dividing by
the intended `(1 − c_x c_y c_z …)` factor before the SOS step.

---

## 4. Dependency-ordered Lean theorem ladder

Rungs are grouped: **L0** shared primitives, **L1–L4** per flagship P1 (with P2
as the (R)-hardened variant), **L5** the P5 no-go, **L6** P3/P4 hedges. Each
constructive rung names its nondegenerate witness and its exact torus
certificate. All of L0–L4 rungs 0–4 are finite exact algebra; the analytic
rungs are flagged.

**L0 — shared primitives (exact, immediate).**
1. `coupledCoin_unitary`, `coupledCoin_det_one` for `C̃ = cosφ I + i sinφ (ρ_x⊗τ_x)`
   — mirror `coin_unitary`, `coin_conjTranspose`.
2. `Kt_unitary (z) (hz) (hcircle)`, `Kt_det_one` — copy the four-factor pattern
   of `shiftCoinCommutator_unitary` / `reciprocalRegulator_det`.
3. `St_unitary`, `St_det_one`, `St_one : S̃ 1 = 1`,
   `St_sub_one_factor : S̃ z − 1 = (z−1)² • Q̃ z` — copy
   `reciprocalRegulator_sub_one_factor` (this is the **quadratic-flatness
   witness**, the load-bearing "correct first jet" fact).
4. `St_Xi_odd : Ξ * S̃ z + S̃ z * Ξ = (z−1)² • (Ξ-odd remainder)` — the honest
   replacement for the false "block-diagonal reciprocal is an escape"; proves
   `U_perp ≠ 0` at quadratic order (feeds `ChiralityMixingNecessity`).

**L1 — first-jet correctness (exact + one fderiv).**
5. `U1_unitary : IsUnitary (U₁ q)` from L0.2–0.3 and `splitStep` unitarity.
6. `U1_origin : U₁ 0 = 1`; `U1_dirac_first_jet : fderiv U₁ 0 = Σ nⱼ αⱼ` — reuse
   `LiveWeylJacobian.hasFDerivAt_weylVector` scaffolding; the `S̃` factor
   contributes zero linear jet by rung 3 (its `(z−1)²`).
   **Nondegenerate witness:** `U1_tangent_involutory : (Σ nⱼαⱼ)² = 1` via
   `Clifford3Plus1WalkSymbol.alpha_sq` + `alpha_pairwise_anticommute`.

**L2 — corner action (exact fixtures; the point pure phases cannot reach).**
7. `U1_corner_noncentral : ∀ w, U₁(corner) ≠ w • 1` — the analogue of
   `conditionalShift_neg_one_noncentral`, proving P1 does what
   `CommutatorCornerInvisibility.regulator_corner_trivial` forbids for phase
   words.
8. `U1_corner_gapped : det(U₁(corner) ∓ I) ≠ 0` at each of the seven non-origin
   corners — the exact analogue of
   `ReciprocalConditionalShiftRegulator.neg_one_has_no_zero_or_pi_crossing`,
   evaluated on the coupled `4×4` word. **These seven exact rational
   determinants are the decisive fixtures.**

**L3 — the paired-determinant / reality guard (the audit's F-B, as a typed
obligation).**
9. `U1_det_one : det (U₁ q) = 1` (monomial determinant, `LaurentUnitResource`
   style) ⇒ `unitary_det_sub_one_real : det(U₁ q − I) ∈ ℝ` (copy audit rung 3.7
   `IsUnitary V → det V = 1 → (det (V−1)).im = 0`).
   *For P2 this rung is definitional (R by construction) and should be proved
   first there, then transported.*

**L4 — the exact torus certificate (the capstone; SOS, no analysis needed for
existence-of-roots exclusion once det is real).**
10. `algebraZero_U1_factor`, `algebraPi_U1_factor` — SOS/Positivstellensatz
    decomposition of `det(U₁∓I)` in `(c_x,s_x,…)` with `c²+s²=1`, of the exact
    shape of `algebraZero_factor`.
11. `U1_unique_zero_crossing : det(U₁ q − I) = 0 ↔ q = 0` and
    `U1_no_pi_crossing : det(U₁ q + I) ≠ 0 ∀ q` — discharged from rung 10 by
    `nlinarith`/`polyrith` on the SOS terms plus `sfactor_nonneg`-style
    nonnegativity, saturating the origin factor away.
    **This is the exact torus root certificate.** If it fails at the body
    centers (the predicted risk), rung 11 becomes the *disproof* that pushes to
    P2.
12. `U1_single_cone` : the intended cone is unique, involutory, unit-speed —
    the objective (A) theorem, composed from rungs 6, 8, 11.

**L5 — the bounded-family no-go P5 (objective B).**
13. `phaseWord_corner_eq_origin` — package
    `CommutatorCornerInvisibility.product_corner_trivial` +
    `CommutatorPiPeriodicity.regulator_corner_sign_invariant` into: every
    integer-frequency phase-commutator word equals its origin value at all eight
    corners.
14. `globalChiral_sector_charges_cancel` — `CubicWeylSectorCharge.liveDirac
    SectorCharges_cancel` + `FullBlochGlobalChirality.massless_splitStep
    _commutes_plusProjector` give total sector charge `0`.
15. `A3_sector_strong_triviality` **[VERIFY hypothesis binder, never an axiom]**
    — each sector has zero strong `3`-winding; stated as an explicit hypothesis
    `(hK1 : ...)`.
16. `boundedFamily_nogo : ∀ U ∈ 𝒞, hK1 → ¬ UniqueCone U` — compose 13+14+15 with
    `ChargeBalanceForcesPartner.exists_second_nondegenerate_of_total_charge_zero`.
    **Nondegenerate control:** `ChargeBalanceForcesPartner.singleton_nonzero
    _charge_sum_ne_zero` (a lone charge cannot balance).

**L6 — hedges.**
17. P4: `U4_two_cones : det(U₄ q − I) = 0 ↔ q ∈ {0, corner₀}` with a valley
    symmetry `U₄(σq) = V U₄(q) V⁻¹`; corner list closed by `decide`. Guaranteed
    true; the "minimum is two" theorem.
18. P3: `U3_unique_cone` via cubic-symmetric SOS (rung-10 style) — needs the
    Cayley Laurent-unit check `det(I+iW)` monomial (`qca_det_is_unique_monomial`)
    or the `θ_W` reformulation.

---

## 5. Ranking

Ranked by **expected scientific payoff × proof feasibility** (product), with the
reasoning explicit.

| Rank | Track | Payoff | Feasibility | Rationale |
|---|---|---|---|---|
| **1** | **P5 no-go (obj. B)** | High | High (bar A3) | A discrete-time Nielsen–Ninomiya for a named class; ~all rungs are kernel already. Single gate: full-text A3. Ship first. |
| **2** | **P1 flagship (obj. A)** | Very high | Medium | The only route to the "one cone" prize; every rung has a live template; dies-or-wins on the seven corner determinants + body-center SOS (rungs 8, 11). |
| **3** | **P4 minimal-doubling** | Medium-high | High | Guaranteed-true "the minimum is two" theorem; a clean honest result even if P1 fails; sharpens the physics message. |
| **4** | **P2 (R)-hardened** | High | Medium-low | Best shot at a *certified* single cone (reality automatic), but `d=8` weakens "smallest"; run only if P1's (R) guard (rung 9/11) fails. |
| **5** | **P3 Wilson** | Medium | Medium | Physics-standard; value is "exactly unitary discrete-time" + kernel certificate; Laurent-unit Cayley check is the friction. Fallback constructive win. |

**Verdict on A vs B.** Pursue **both**: B (P5) is the near-certain paper and
should be frozen first; A (P1) is the high-variance prize and is genuinely open
— the fence does **not** exclude quadratic chirality mixing, and P1 is the first
architecture that satisfies all three crux conditions by design rather than by
accident. If P1's torus certificate (rung 11) returns a body-center root,
escalate to P2 (which removes the failure mode structurally) before concluding
anything; only a P2 failure would justify upgrading P5 to a *universal* no-go
claim, and even then only for the reciprocal/phase escape class.

---

## 6. Manuscript claim actions (promote / demote / reframe)

**Promote.**
* `B-full-Bloch-global-chirality` (delta row 28; `splitStep_commutes_iff_sin
  _theta_zero`). Kernel-sharp iff, with `plusProjector` block-invariance and a
  quarter-turn control. Promote to a **headline** "global chirality boundary"
  theorem — it is the exact dividing line between the control and escape classes.
* `B-massless-full-Bloch-crossing-classification` (row 31) + `B-live-Weyl
  -derivative-census-bridge` (row 30). Together they are a **complete massless
  crossing classification with live-Jacobian charges** (`det J = u₀(cos²qy −
  sin²qy)`, 16 nondegenerate nodes, sector-cancelling sums). Promote to a
  standalone "exact discrete census" result.
* `CommutatorCornerInvisibility` + `CommutatorPiPeriodicity`. Reframe-and-promote
  as a **positive structural no-go**: "no integer-frequency phase-commutator
  word, with any affine offset, acts on the cubic 2-torsion corners." This is a
  crisp, self-contained lemma and the backbone of the P5 no-go.

**Demote.**
* `B-strict-Laurent-chiral-doubling` (row 37). Marked "expected" and resting on
  the imported Read/`K¹` strong-triviality result (A3, VERIFY). **Demote from any
  manuscript no-go sentence to an explicitly source-pending hypothesis**; it may
  only enter as a typed binder (ladder rung 15), never as an assertion or axiom.
* The reciprocal **"family-level oracle kill."** The audit (F-A/F-B/F-C) shows it
  is a *conditional* sign obstruction, not a no-go: the Dirac blocks `U_±` are
  undefined in the source, and the argument needs the unstated reality condition
  (R) `det U_+·det U_- ≡ 1` and an *origin-avoiding* path. **Demote from "kill"
  to "conditional obstruction on the naive chirality-register embedding, gated on
  (R) and explicit `U_±`."** The gate matrix already flags it oracle-grade; the
  manuscript prose must match.

**Reframe.**
* `B-reciprocal-conditional-shift-primitive` (row 35). Reframe from "first
  concrete **survivor** / escape" to "the first **corner-visible,
  quadratically-flat** primitive; its naive chirality-register embedding is
  killed by a conditional sign obstruction, and the open construction is the
  **chirality-coupled** (`Ξ`-odd) embedding P1." This keeps the true kernel
  content (unitary, `det=1`, `(z−1)²` flatness, noncentral at `z=−1`) and states
  the honest status.
* The corrected `B-full-Dirac-neutrality` (row 22). Ensure every manuscript
  instance uses the **sector-resolved** charge only; the superseded
  "nonzero full-Dirac class-A charge" must remain retracted (it is provably a
  null-homotopy through `massBlend`). Add the register-convention fix (audit F-D:
  `S_word` on the band, `diag(U_±)` grading chirality) as a one-line convention
  statement wherever the reciprocal embedding appears.

**Net effect on the gate matrix (Paper B row).** The decisive 24-hour gate
should read: *"(i) freeze the P5 phase-word/global-chiral no-go pending A3
full-text; (ii) build P1 and attempt its exact torus certificate (rungs 8, 11);
(iii) land P4 as the minimal-doubling floor."* The kill condition stands: any
unsplit nonzero Dirac charge is false shape, `4×4` body centers carry both signs,
and the reciprocal embedding's isolation remains conditional on (R) + explicit
`U_±` until P1/P2's live blocks and origin-avoiding real path are formalized.

---

## 7. What is deliberately *not* proposed

* No continuum analysis — every rung above is finite algebra on Laurent symbols;
  the continuum machinery (Papers A/D) enters only after a single-cone symbol
  exists.
* No new axioms — A3 enters only as a typed hypothesis binder; the strong
  triviality import is VERIFY, never `axiom`.
* No reliance on action-based Nielsen–Ninomiya — the discrete-time statement is
  independent (Paper A scope row); we inherit its topology heuristic, not its
  proof.
