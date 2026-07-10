# Live-repository reconciliation

The audit's semantic findings are controlling, while all three target statuses
have advanced. `DiscretePluckerFlowRotation` is landed with the mathematically
necessary circle-normalization hypothesis and an exact counterexample to the
original false statement. `FiniteGibbsVariance` now includes the strict
zero-variance rigidity equivalences. `SuccessiveAxisPositionWalk` is landed and
instantiated with the actual normalized Clifford factors, but the audit is
correct that its supplied tetrahedral velocity table is not yet connected by a
per-axis eigenbasis theorem to `alpha1`, `alpha2`, and `alpha3`; it must not yet
be captioned as a spatial Dirac tangent theorem. Full-window flow stability is
also landed. S21 is now occupied by a disclosed fixed-momentum `3+1` free-Dirac
split-step reproduction. S20 is being re-tiered from V2 to algebraic
self-consistency, and a new independent finite-difference fluctuation-response
benchmark will take S22.

# POST_COMPLEX_SPATIAL_AUDIT_12

Adversarial semantic + methods audit after the complex-scalar simultaneous-coin
no-go and `FiniteGibbsVariance` landed, S20 (Schottky) became the project's
second V2, and the three active targets (`SuccessiveAxisPositionWalk`,
`ActionFlowRotation`, `GibbsVarianceRigidity`) went into flight.

Ground rules honoured: **no source file was edited.** All eleven
`Sources/*.lean` are `s o r r y`-free in this snapshot; all six `Targets/*.lean`
carry the expected `s o r r y` stubs (`ActionFlowRotation` 6, `AxisCoinNoGo` 4,
`Core` 8, `FiniteGibbsVariance` 6, `GibbsVarianceRigidity` 4,
`SuccessiveAxisPositionWalk` 6). `Sources/*` import `PhysicsSM.*` modules absent
from this focused package; per standing instruction their non-elaboration here is
**[packaging]**, never a live build failure. The `Audit` library
(`Audit/Core.lean`) is the only default lake target and builds a trivial marker;
absence of `PhysicsSM` is a packaging fact.

Verdict tags: **[true]** recomputed correct · **[narrow]** correct but weaker
than the caption suggests · **[hollow]** technically true but does not carry the
physics the surrounding text implies · **[tautology]** a numeric "reproduction"
that compares a closed form to itself · **[open]** claimed-next, not landed ·
**[packaging]** import gap only · **[error]** a genuine status/arithmetic mistake
in a supplied report.

Independent numeric checks were run in exact/`binary64` arithmetic and are
harness checks, not Lean proofs.

---

## 1. `AxisCoinComplexCliffordNoGo`: proof-shape + semantic audit

**Object.** `axisBlockCoin = B ⊕ B ⊕ B`, `B = [[3/5, 4i/5],[4i/5, 3/5]]` (6×6,
`Coin`). `Msq r := axisBlockCoin*axisBlockCoin − r•1`. Recomputed:
`B² = [[−7/25, 24i/25],[24i/25, −7/25]]`, eigenvalues `−7/25 ± 24i/25`
(non-real, distinct); consistent with `Msq_mulVec_row{0,2,4}`, which read the
row of `Msq r` on the even coordinates as `((−7/25)−r)·v(2k) + (i·24/25)·v(2k+1)`.

### 1.1 Declaration table

| Declaration | Content | Verdict |
|---|---|---|
| `Msq_mulVec_row0/2/4` | row `2k` of `Msq r` = `((−7/25)−r)v(2k)+(i·24/25)v(2k+1)` | [true] — the `linear_combination … I_sq` closes the `I²=−1` bookkeeping |
| `proj3` | linear map `v ↦ (v0,v2,v4)` onto even coords | [true] |
| `axis_coin_sq_minus_complex_kernel_finrank_le_three` | `finrank ℂ ker(Msq r).mulVecLin ≤ 3`, every `r:ℂ` | **[true]; load-bearing** |
| `complex_square_kernel_nonzero` | at `r = −7/25 + 24i/25`, `∃ v≠0`, `Msq r ·ᵥ v = 0` | **[true]; the non-vacuity control** |
| `axisBlockCoin_has_no_complex_clifford_block` | no injective 4-D invariant `inc`/`H` with `H²=r•1`, any `r:ℂ` | **[true]; flagship** |

### 1.2 Is the finrank proof sound, and does it actually reduce the rank?

**Yes, and by a cleaner route than Audit 11 proposed.** Audit 11 §4 suggested a
block-diagonal argument ("`rank(B²−zI) ≥ 1` per block ⇒ `ker ≤ 1` per block, sum
≤ 3"). The **landed** proof does something different and equally valid: it shows
`proj3` (projection to coordinates `0,2,4`) is **injective on**
`ker(Msq r).mulVecLin`. Concretely, if `v0=v2=v4=0` then the three even rows
collapse to `(i·24/25)·v1 = 0`, `(i·24/25)·v3 = 0`, `(i·24/25)·v5 = 0`, and since
`i·24/25 ≠ 0` (`hc`) the odd coordinates also vanish, so `v=0`. Injectivity into
`Fin 3 → ℂ` gives `finrank ker ≤ finrank (Fin 3 → ℂ) = 3` via
`LinearMap.finrank_le_finrank_of_injective`. This is correct, and it never
invokes non-realness of `B²`'s eigenvalues — the only algebraic input is
`i·24/25 ≠ 0`, i.e. the off-diagonal coupling of `B²`. **Recomputed [true].**

The discharge of the no-go is the textbook one: for the hypothesised `(inc,H,r)`,
`U²(inc v) = inc(H²v) = inc(r•v) = r•(inc v)`, so `range inc ⊆ ker(Msq r)`;
`inc` injective on `ℂ⁴` gives `finrank (range inc) = 4`; then `4 ≤ 3` via the
lemma — contradiction. The `codRestrict`/`finrank_le_finrank_of_injective`
plumbing is exactly right.

### 1.3 Does the nonzero-kernel control actually prevent a false invertibility reading?

**Yes — decisively.** The danger with any `finrank ker ≤ 3` statement is that it
is *vacuously* satisfiable by an invertible operator (`ker = 0`, `finrank 0 ≤ 3`):
a reader could misread it as "`U²−rI` is always injective," which is **false over
ℂ** (it must fail at the eigenvalue squares). `complex_square_kernel_nonzero`
exhibits the explicit witness `r = −7/25 + 24i/25` with kernel vector
`v = (1,1,0,0,0,0)`: I recomputed `(B²−rI)(1,1)ᵀ = ((−7/25 − r)+24i/25,
24i/25+(−7/25−r))ᵀ = (0,0)ᵀ`, so `v ≠ 0` lies in the kernel. Hence at that `r`
the operator is genuinely **non-injective**, the bound `≤ 3` is attained by a
**positive-dimensional** kernel, and the theorem is a true **rank obstruction**
(`4 > 3`), not a disguised invertibility claim. The companion real-scalar helper
`axis_coin_sq_minus_real_injective` (`U²−rI` injective for *real* `r`) is [true]
precisely because `B²`'s eigenvalues are non-real — and its non-extension to
complex `r` is exactly why the finrank argument is required. The two controls
therefore delimit the truth sharply: injective for real `r`, non-injective at the
complex eigenvalue squares, kernel never large enough to host a 4-D block.

### 1.4 May the manuscript now mark the simultaneous architecture killed?

**Yes, for the scalar-square Dirac-block reading of this coin, over all complex
scalars — with three caption obligations.**

1. **Scope: coin-specific.** The kill is about `axisBlockCoin = B⊕B⊕B`, not about
   arbitrary quantum-walk coins. State it as "the selected simultaneous
   six-channel coin a d m i ts no injectively embedded 4-D invariant restriction
   whose square is any complex scalar," never "no Dirac walk exists."
2. **Physical relevance is genuine.** A Clifford/Dirac generator squares to a
   scalar (`H_sq`: `H² = (‖k‖²+m²)•1`); the "the six-channel coin *is* the Dirac
   α/β set" hypothesis is exactly a scalar square, and it is now killed over **all
   of ℂ** — closing the `r=−1` (γ-matrix-like) and non-real loopholes a referee
   would raise, which the positive-real corollary alone leaves open.
3. **Non-vacuity guard must travel with it.** `ConcreteD4InvariantSector` /
   `anisotropic_four_sector_witness` show a real rank-4 invariant sector *does*
   exist: the kill is about the **square**, not the absence of subspaces. Do not
   drop this pairing.

With those three, the simultaneous `B⊕B⊕B` architecture is correctly marked
**killed as a scalar-square Dirac host**, and Route B (the separate
shared-four-component successive-axis walk) remains the live continuation. The
positive-real no-go `axisBlockCoin_has_no_positive_clifford_block` is now a
strict corollary and should be captioned as such.

**Footprint.** In-file `#print a x i o ms` guards pin
`axisBlockCoin_has_no_complex_clifford_block` and
`complex_square_kernel_nonzero` to `{propext, Classical.choice, Quot.sound}`.
`s o r r y`-free in snapshot; PhysicsSM import is **[packaging]**.

---

## 2. `FiniteGibbsVariance` and S20: theorem-backed response vs. self-comparison

### 2.1 `Sources/FiniteGibbsVariance.lean` — declaration audit

| Declaration | Content | Verdict |
|---|---|---|
| `weight/partition/probability/meanEnergy/meanSquareEnergy/variance` | standard finite canonical-ensemble defs, `NeZero n` | [true]; **definitionally identical** to `FiniteGibbsResponse` (see `partition_eq_response`, `probability_eq_response` proved by `rfl`) |
| `probability_sum_one` | `∑ p = 1` | [true] |
| `variance_centered_identity` | `Var = ∑ p·(E−⟨E⟩)²` | [true] |
| `variance_nonnegative` | `0 ≤ Var` | [true] — genuine sum of nonneg centered squares |
| `meanEnergy_hasDerivAt` | `HasDerivAt (⟨E⟩) (−Var) β` | **[true]; the real physics content** — `d⟨E⟩/dβ = −Var(E)`, the fluctuation–dissipation identity |
| `meanEnergy_eq_response` | quotient and normalized-sum means agree | [true] |
| `twoLevelEnergy`, `rational_two_level_variance_control` | `Var(twoLevel(4/25))@0 = 4/625 > 0` | [true] |
| `degenerate_spectrum_zero_control` | constant spectrum ⇒ `Var = 0` | [true]; genuine negative control |
| `rational_plucker_variance_control` | the `4/25` gap is a real Plücker invariant (`massSq edge0 (edge1 2/5)`), `Var = 4/625 > 0` | **[true]; dictionary is load-bearing** — the gap is not a free constant |

**Verdict: this is a genuine, theorem-backed finite fluctuation response.** The
key deliverable `meanEnergy_hasDerivAt` is an exact derivative identity
(`−Var`), not a self-comparison; it is bridged by `rfl` to the landed
`FiniteGibbsResponse` API (`log_partition_hasDerivAt` gives `d log Z/dβ = −⟨E⟩`),
so the pair `d log Z/dβ = −⟨E⟩`, `d⟨E⟩/dβ = −Var` is a real two-step response
chain over one shared ensemble. The `4/25`→`4/625` numbers are anchored to an
actual spinor Plücker invariant, and `degenerate_spectrum_zero_control` is a real
falsifier. No over-claim in the source.

### 2.2 S20 (Schottky V2) — **[tautology]** in its headline check

S20 (`Scripts/null_information_lab.py::s20_two_level_schottky_curve`) computes a
"simulated" heat capacity `C_sim(x) = β²·Var` with `β = x/gap`,
`Var = gap²·p(1−p)`, and compares it to the "analytic" Schottky curve
`C_ana(x) = x²eˣ/(1+eˣ)²` on a 6001-point grid, passing at
`max curve error < 1e-14`.

**The gap cancels identically.** `C_sim = (x/gap)²·gap²·p(1−p) = x²·p(1−p)`, and
with `p = 1/(eˣ+1)`, `p(1−p) = eˣ/(eˣ+1)²`, so `C_sim(x) = x²eˣ/(1+eˣ)² =
C_ana(x)` **for every gap**. I verified numerically: with `gap ∈ {4/25, 1,
7.3}`, `C_sim(2.4)` is bitwise-identical to `C_ana(2.4) = 0.4392287945…`, and the
grid max error is `2.78e-16` — pure `binary64` rounding between two spellings of
the same closed form. So `normalized_gibbs_curve_matches_schottky_formula` is a
**self-comparison**: it confirms `x²p(1−p) = x²eˣ/(1+eˣ)²`, an algebraic
identity, and reproduces **nothing external**. The peak (`x*≈2.399`, `C≈0.4392`)
is a property of that one fixed function, not a physics recovery.

**What is and is not V2 in S20:**
- **[tautology]** the curve-match at `<1e-14` (same closed form both sides; gap
  cancels).
- **[hollow as a "curve reproduction"]** the peak location/height — a property of
  the universal function, independent of the Plücker gap.
- **[true, theorem-backed, but not exercised numerically]** the physics content
  `C = β²Var` and `d⟨E⟩/dβ = −Var` lives in `meanEnergy_hasDerivAt`. **S20 never
  numerically tests the derivative** — it plugs closed forms in. So the Lean
  anchor is legitimate but S20 does not *confront* it.
- **[true]** the gap-dependent fixture `Var(0)=4/625` and the degenerate/wrong-sign
  controls are genuine (these do use the gap).

**Recommendation (methods):** re-caption S20 as "algebraic self-consistency of
the two-level Gibbs closed forms + a nondegeneracy fixture," not a V2
*reproduction of accepted physics*. A genuine V2 must (i) use a spectrum where
the gap does **not** cancel (≥3 levels, or unequal degeneracies), and (ii)
compute `Var` by a **finite-difference of ⟨E⟩ in β** and confront it against the
theorem `meanEnergy_hasDerivAt` (numerically independent of the closed-form
`Var`). See §9.

---

## 3. Adversarial review of the three active targets

### 3.1 `SuccessiveAxisPositionWalk` — **[hollow]; too general; sign table unrelated to `alpha1,alpha2,alpha3,beta`**

This is the target the brief flags, and the flag is correct.

- `velocity : Axis → Internal → Bool` is an **arbitrary** sign table.
- `sourcePosition/conditionalShift` permute the `Fin 3 → ZMod L` register per
  channel; `pointwiseCoin U` applies an **arbitrary** unitary `U` at each site;
  `successiveWalk velocity Ux Uy Uz Um` chains three axis factors and one mass
  coin.
- **Main:** `successiveWalk_preserves_norm` — the walk preserves `inner ψ ψ` when
  `Ux,Uy,Uz,Um` are all unitary.

**Findings.**
1. **Too general / hollow.** `successiveWalk_preserves_norm` is norm preservation
   for *any* product of (a) a position permutation and (b) a pointwise unitary.
   It holds for **every** `velocity` and **every** unitary quadruple. It uses
   nothing about the Dirac/Clifford structure — the coins are opaque unitaries.
   This is exactly a "hollow spatial unitarity theorem whose arbitrary velocity
   table never recovers the project Dirac symbol." True, but it carries no
   physics beyond "permutation ∘ unitary is an isometry."
2. **Sign table unrelated to the landed generators.** `tetraVelocity` is a
   hand-built `3×4` Bool table (axis0 `TTFF`, axis1 `TFTF`, axis2 `TFFT`). Each
   row has two `T`/two `F`, matching the `(+1,+1,−1,−1)` eigen-signature of a
   trace-zero involution — but there is **no basis change** in the module. The
   conditional shift is applied in the *standard* internal basis, where
   `alpha1,alpha2,alpha3` are **off-diagonal** (recomputed: `α₁` is anti-diagonal,
   `(α₁)₀₀ = 0`, `(α₁)₀₃ = 1`; `α₂` likewise; `α₃` off-diagonal). A diagonal
   `±1` sign table can never equal an off-diagonal generator. So `tetraVelocity`
   is **disconnected** from `alpha1,alpha2,alpha3`.
   - Sharper: the *one* row that does match a generator's diagonal signs is
     `tetraVelocity 0 = TTFF`, which is the eigen-signature of the **diagonal**
     `beta = diag(1,1,−1,−1)` — but it is assigned to **spatial axis 0**, not the
     mass factor. The table is thus **doubly** misassigned.
3. **No tangent theorem.** There is no declaration relating `successiveWalk`'s
   generator to `−iH`. The module never touches `H`, `alpha_i`, `beta`, or
   `normalizedFactor`. It is not a continuation of `SuccessiveAxisDiracWalk`; it
   is a parallel, generic norm-preservation lemma.
4. **Controls are fine but off-target.** `tetrahedral_shift_nontrivial` (shift
   is non-identity on `L=5`) and `lossy_delete_origin_control` (deleting a site
   breaks the norm) are honest nondegeneracy/negative controls — but they
   certify *motion* and *isometry*, not *Dirac* content.

**Verdict:** land it if desired as a generic "finite position-register QW is
unitary" lemma, **but do not caption it as a spatial Dirac walk.** To earn the
Dirac reading it must import `alpha_i/beta` and prove the §4 diagonalization
bridge. Absent that, S06's "position walk running" must be captioned "generic
norm preservation running; sign-table↔Clifford dictionary open."

### 3.2 `ActionFlowRotation` — **[true] shape; watch the `pluckerSine` irrational and the injectivity hypothesis**

Conjugates the landed `mu=4/25` recurrence `step mu x = (x.2,(2−mu)x.2−x.1)` to a
rotation. `phaseCoordinates c s x = (x.2, (c·x.2 − x.1)/s)`, `rotation c s`
Euclidean, with `2−mu = 2c` (trace) and `c²+s²=1` (unit circle). The chain
`phaseCoordinates_injective` (needs `s≠0`), `phaseCoordinates_intertwines_step`
(needs `2−mu=2c`, `s≠0`), `rotation_energy_conserved` (needs `c²+s²=1`),
`iterated_phase_energy_conserved`, and the capstone
`rational_plucker_flow_conjugate_to_rotation` are internally consistent.

**Findings.**
1. **Numbers are the correct branch.** `2 − 4/25 = 46/25 = 2·(23/25)` so
   `pluckerCosine = 23/25` [true]; then `s² = 1 − (23/25)² = (625−529)/625 =
   96/625`, `s = √96/25 = 4√6/25 = pluckerSine` [true], `≠ 0`. `wrong_cosine_control`
   (`c = 3/5` fails the trace) is a genuine control. `plucker_phase_controls` is
   the right conjunction.
2. **Not vacuous, not tautological.** `firstIntegral` is a genuine non-constant
   quadratic invariant (already landed in `DiscretePluckerVariationalFlow`); the
   rotation picture is the eigenbasis diagonalization of a `|trace|<2`
   (elliptic) map. Honest.
3. **One caution:** `pluckerSine = 4√6/25` is **irrational**, so all downstream
   fixtures are real (not exact-rational) — fine, but the benchmark for this
   target cannot be "exact rational"; it must be `<ε` numeric or symbolic
   `Real.sqrt` manipulation. `phaseCoordinates_injective` is the only genuinely
   nontrivial obligation (it needs the `/s` inverse); the rest are `ring`/`nlinarith`.
4. **Scope caption:** this conjugacy is for the **`ℝ²` action-derived recurrence
   (M19)**, i.e. the *elliptic* regime `|2−mu|<2` ⇔ `0<mu<4`. It is a rotation
   only inside the stability window; at `mu∉(0,4)` there is no real `(c,s)` on the
   unit circle. Caption "conjugate to a unit-circle rotation **on the
   positive-definite window**," matching the §1.3 stability window of Audit 11.

**Verdict:** [true] and non-hollow, a real strengthening of the M19 stability
result (rotation ⇒ eternal boundedness on the full `0<mu<4`, which also answers
Audit 11's "extend `0<mu≤2` to `0<mu<4`" runner-up **for this 2-D map**). Land as
stated.

### 3.3 `GibbsVarianceRigidity` — **[true] shape; genuine rigidity, guard the iff direction**

Restates the landed `FiniteGibbsVariance` defs and adds four obligations:
`probability_positive` (`0 < p_i`), `variance_eq_zero_iff_constant`
(`Var=0 ↔ ∃c ∀i, E i = c`), `variance_pos_iff_nonconstant`
(`0<Var ↔ ∃ i j, E i ≠ E j`), and `rational_two_level_rigidity_control`.

**Findings.**
1. **Mathematically true.** With strictly positive Boltzmann weights,
   `Var = ∑ p_i(E_i−⟨E⟩)² = 0` iff every term vanishes iff `E_i = ⟨E⟩` for all
   `i` iff `E` is constant. The `←` direction reuses `degenerate_spectrum_zero_control`;
   the `→` direction needs `probability_positive` (a zero-weight would break it),
   which is why that lemma is a prerequisite. Logically clean.
2. **Non-vacuous, real content.** This upgrades `variance_nonnegative` (an
   inequality) to a **rigidity dichotomy**: strict positivity ⇔ spectral
   nondegeneracy. That is exactly the "fluctuation ⇔ nonconstant spectrum"
   statement the thermodynamics row wants, and it is not implied by the landed
   inequality alone. `rational_two_level_rigidity_control` witnesses the positive
   side with the real `4/25` spectrum.
3. **Caption caveat:** it is *rigidity of the fluctuation*, not thermodynamic
   irreversibility, no time arrow, no thermodynamic limit — keep those disclaimers
   from M17.

**Verdict:** [true], the most physically substantive of the three targets. Land.

---

## 4. The smallest Lean theorem tying the sign table to the Clifford generators and forcing tangent `−iH`

The missing arrow is a **per-axis diagonalization** identity: the Bool velocity
table, *read in a per-axis eigenbasis `U j`*, must reconstruct `alpha_(j+1)`.
This single new hypothesis is what a hollow position walk lacks; everything else
follows from the landed `linear_split_entry_hasDerivAt` machinery.

```lean
namespace RouteBSpatialTangent
open Matrix Complex
open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk   -- alpha1..3, beta, H, Mat4

/-- The ±1 velocity sign carried through the conditional shift on axis `j`,
    channel `a`, as a complex scalar (`true ↦ -1`, `false ↦ +1`). -/
def sgn (velocity : Fin 3 → Fin 4 → Bool) (j : Fin 3) (a : Fin 4) : ℂ :=
  if velocity j a then -1 else 1

/-- The three spatial Clifford generators, indexed to match the axes. -/
def cliff : Fin 3 → Mat4
  | 0 => alpha1 | 1 => alpha2 | 2 => alpha3

/-- The ONLY new content: on each axis the velocity sign table, conjugated by a
    unitary per-axis basis `U j`, equals the Clifford generator.  This is the
    exact bridge from the Bool sign table to `alpha1,alpha2,alpha3`.  It is
    satisfiable (each `alpha_i` is a trace-0 involution with signature (2,2), and
    each `velocity j` row has two `true` / two `false`), and it FAILS for the
    identity basis, which is why the current `tetraVelocity` walk is hollow. -/
structure CliffordDiag (velocity : Fin 3 → Fin 4 → Bool) where
  U     : Fin 3 → Mat4
  hUnit : ∀ j, (U j)ᴴ * U j = 1 ∧ U j * (U j)ᴴ = 1
  hDiag : ∀ j, U j * Matrix.diagonal (sgn velocity j) * (U j)ᴴ = cliff j

/-- Momentum-space symbol of one conditional-shift axis factor at wavenumber `k`:
    the shift is diagonal `exp(-i·sgn·k)` in the eigenbasis `U j`. -/
noncomputable def axisSymbol (velocity : Fin 3 → Fin 4 → Bool)
    (d : CliffordDiag velocity) (j : Fin 3) (k : ℂ) : Mat4 :=
  d.U j * Matrix.diagonal (fun a => Complex.exp (-(sgn velocity j a) * I * k)) * (d.U j)ᴴ

/-- SMALLEST TANGENT LEMMA (per axis): the axis-factor symbol has derivative
    `-i·alpha_(j)` at `k = 0`.  Proof: `d/dk|₀ exp(-σ i k) = -σ i`, and
    `U·diag(-σ i)·Uᴴ = -i·(U·diag σ·Uᴴ) = -i·cliff j` by `hDiag`. -/
theorem axisSymbol_hasDerivAt (velocity) (d : CliffordDiag velocity) (j : Fin 3)
    (p q : Fin 4) :
    HasDerivAt (fun k : ℂ => axisSymbol velocity d j k p q)
      (((-I) • cliff j) p q) 0

/-- Full 3+1 spatial-step symbol along `x,y,z` then mass (coin = the landed
    `normalizedFactor`-style mass factor, diagonal `beta`). -/
noncomputable def stepSymbol (velocity) (d : CliffordDiag velocity)
    (kx ky kz m eps : ℂ) : Mat4 :=
  axisSymbol velocity d 0 (eps*kx) * axisSymbol velocity d 1 (eps*ky) *
    axisSymbol velocity d 2 (eps*kz) *
    ((1 : Mat4) - (I * eps * m) • beta)

/-- MAIN (smallest end statement): the tangent of the full spatial step is
    exactly `-iH`.  Product rule over the three `axisSymbol_hasDerivAt` factors
    and the mass factor, at `eps = 0` (each factor is `1`), reusing the argument
    already carried by `linear_split_entry_hasDerivAt`. -/
theorem stepSymbol_hasDerivAt (velocity) (d : CliffordDiag velocity)
    (kx ky kz m : ℂ) (i j : Fin 4) :
    HasDerivAt (fun eps : ℂ => stepSymbol velocity d kx ky kz m eps i j)
      (((-I) • H kx ky kz m) i j) 0
end RouteBSpatialTangent
```

- **Why this is the minimal connection.** The *only* new obligation is
  `hDiag : U j · diagonal(sgn velocity j) · Uⱼᴴ = alpha_(j)`. Once `hDiag` holds,
  `axisSymbol_hasDerivAt` is a one-line consequence of `Complex.exp` derivatives,
  and `stepSymbol_hasDerivAt` is the product-rule assembly that
  `linear_split_entry_hasDerivAt` already performs entrywise for `linearSplit`.
- **Why `tetraVelocity` fails it.** With `U j = 1`, `hDiag` demands
  `diagonal(sgn) = alpha_j`; but `alpha1,alpha2,alpha3` are off-diagonal, so no
  Bool table can satisfy it in the identity basis. The theorem therefore forces
  `SuccessiveAxisPositionWalk` to (i) add the per-axis basis change `U j` and (ii)
  prove `hDiag` — precisely the physics content it currently omits.
- **Consistency with the landed symbol.** For real `(kx,ky,kz,m)`, `H` matches
  the project symbol by `real_symbol_matches_project`, and `−iH` is anti-Hermitian
  (from `generators_hermitian`), so the generated flow is unitary — consistent
  with `successive_step_unitary`.

---

## 5. The next quantitative compact-momentum `3+1` convergence theorem

The `3+1` lift of S18 (`FixedMomentumManyStepContinuum`) and of Audit 11 §7 (one
axis + mass), now over a compact momentum box with the **full** Dirac symbol.

```lean
open Matrix Complex
open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk   -- alpha1..3, beta, H

/-- Exact one-parameter Clifford factor `exp(-(I·c·ε) • g)` (unitary for real
    `c`, `g†=g`, `g²=1`).  Factor order below is x,y,z,mass = successiveStep. -/
noncomputable def cliffFactor (c ε : ℂ) (g : Mat4) : Mat4 :=
  Matrix.exp (-(I * c * ε) • g)

/-- First-order (Lie–Trotter) fiber step of size `ε`, order x,y,z,mass. -/
noncomputable def walkSymbol3p1 (kx ky kz m ε : ℂ) : Mat4 :=
  cliffFactor kx ε alpha1 * cliffFactor ky ε alpha2 *
    cliffFactor kz ε alpha3 * cliffFactor m ε beta

/-- Exact 3+1 Dirac fiber evolution to time `T`:
    `exp(-(I·T) • H) = cos(ωT)·1 - i·(sin(ωT)/ω)·H`, `ω = √(|k|²+m²)`. -/
noncomputable def diracEvol3p1 (kx ky kz m T : ℝ) : Mat4 :=
  Matrix.exp (-((T : ℂ) * I) • H kx ky kz m)

/-- MAIN quantitative bound: uniform over the box `|k_·| ≤ K`, `|m| ≤ M`, the
    n-step first-order fiber walk is within `Dbox·T²/n` of exact Dirac
    evolution, in the 4×4 fiber operator norm; rate O(1/n). -/
theorem walkSymbol3p1_fixedTime_bound
    (K M T : ℝ) (hK : 0 ≤ K) (hM : 0 ≤ M) (hT : 0 ≤ T) :
    ∃ Dbox : ℝ, 0 ≤ Dbox ∧
      ∀ kx ky kz m : ℝ, |kx| ≤ K → |ky| ≤ K → |kz| ≤ K → |m| ≤ M →
        ∀ n : ℕ, 0 < n →
          ‖ (walkSymbol3p1 (kx*T/n) (ky*T/n) (kz*T/n) (m*T/n) 1) ^ n
              - diracEvol3p1 kx ky kz m T ‖ ≤ Dbox * T ^ 2 / n

theorem walkSymbol3p1_fixedTime_tendsto
    (K M T kx ky kz m : ℝ) (hkx : |kx| ≤ K) (hky : |ky| ≤ K)
    (hkz : |kz| ≤ K) (hm : |m| ≤ M) :
    Filter.Tendsto
      (fun n => ‖ (walkSymbol3p1 (kx*T/n) (ky*T/n) (kz*T/n) (m*T/n) 1) ^ n
                  - diracEvol3p1 kx ky kz m T ‖)
      Filter.atTop (nhds 0)
```

Precise specification requested:

- **Factor order.** `x, y, z, mass` (α₁·α₂·α₃·β), identical to `successiveStep`.
  First-order Lie–Trotter. A **Strang** symmetrization (`½ mass, x, y, z, ½ mass`,
  or palindromic order) upgrades the rate to `O(1/n²)` and should be a *separate*
  stronger rung — do **not** claim `O(1/n²)` for the unsymmetrized product above.
- **Norm.** The 4×4 fiber operator norm; equivalently Frobenius up to a fixed
  finite-dimensional constant (dim = 4), matching S18's use of Frobenius.
- **Rate.** `O(1/n)` at fixed `T`; `Dbox(K,M)` **uniform** on `|k_·|≤K`, `|m|≤M`
  (the box-uniform upgrade of the pointwise S18 constant, mirroring
  `BoundedMomentumManyStepContinuum`). Leading constant governed by
  `½·Σ_{i<j}‖[G_i,G_j]‖` commutator content; since the generators **anticommute**
  (`[α₁,α₂] = 2α₁α₂ ≠ 0` — recomputed `(α₁α₂)₀₀ = I ≠ −I = (α₂α₁)₀₀`), the
  first-order error is **genuinely nonzero**, so `n·error → const > 0`.
- **Witness (nondegenerate).** `(kx,ky,kz,m) = (1,2,2,3)`: `ω² = 1+4+4+9 = 18`,
  reusing `nondegenerate_1223_control` (`H(1,2,2,3)² = 18•1`, `H ≠ 0`), with the
  unit-normalized real factor `(3/5,4/5)` (`(3/5)²+(4/5)²=1`) giving genuine,
  non-identity steps; and a numeric fixture, e.g. `(k,m)=(3/5,4/5,·)`, `T=1`,
  showing `n·error` bounded and `→` a positive constant while `error → 0`.
- **Wrong-order / phase control (two distinct falsifiers).**
  1. **Phase falsifier (the S18 lift):** reverse the imaginary phase on the mass
     factor (`+I·m·ε` instead of `−I·m·ε`); the product then converges to
     `exp(−iH′)` with `H′ = kx α₁+ky α₂+kz α₃−m β ≠ H`, so `‖walk^n − diracEvol‖ →
     ‖exp(−iH′T)−exp(−iHT)‖ > 0` and the `Dbox·T²/n` bound is violated for large
     `n`. State as `¬ (bound holds for the phase-reversed step)`.
  2. **Order/commutator falsifier (guards against over-claiming `O(1/n²)`):**
     because the generators do not commute, the **unsymmetrized** product is only
     first-order — exhibit that `n·error → c ≠ 0` (not `n²·error → const`), so any
     claim that the naive `x,y,z,mass` product is second-order accurate is false.
     A companion `[α₁,α₂] ≠ 0` control (`alpha1*alpha2 ≠ alpha2*alpha1`) certifies
     the commutator that forces the residual.

Position-space/`ℓ²`, PDE, and the graph-derived local net remain explicitly open
beyond this fixed-momentum, compact-`k`, first-order rung.

---

## 6. Four over-claim checks + nondegeneracy gate on every new flagship

Checks: **C1 fidelity** (Lean = caption) · **C2 non-vacuity** · **C3 hypothesis
exposure** · **C4 footprint** (`s o r r y`-free; axioms ⊆ `{propext,
Classical.choice, Quot.sound}`; guards) · **ND** (positive witness *and* a
genuinely failing control).

| Flagship | C1 | C2 | C3 | C4 | ND |
|---|---|---|---|---|---|
| `AxisCoinComplexCliffordNoGo` (`…no_complex_clifford_block`) | pass — `finrank ker ≤ 3` ⇒ no 4-D scalar-square block, all `r:ℂ` | pass — `complex_square_kernel_nonzero` gives a genuine nonzero kernel at `−7/25+24i/25`; `ConcreteD4InvariantSector` gives a real 4-D sector | pass — coin fixed; "no-go is coin-specific / does not touch Route B" disclosed | in-file `#print a x i o ms` guards `{propext,Classical.choice,Quot.sound}`; `s o r r y`-free; PhysicsSM **[packaging]** | **pass** — nonzero eigenkernel (positive) + `4>3` obstruction (fails to embed) |
| `AxisCoinPositiveCliffordNoGo` (corollary) | pass — now a strict corollary of the complex form | pass — `anisotropic_four_sector_witness` | pass — captioned "positive scalar is the physically decisive slice" (§7) | guards; `s o r r y`-free; **[packaging]** | **pass** |
| `FiniteGibbsVariance` (`meanEnergy_hasDerivAt`, `rational_plucker_variance_control`) | pass — `d⟨E⟩/dβ = −Var`; bridged by `rfl` to `FiniteGibbsResponse` | pass — `Var(4/25)@0 = 4/625 > 0` from a real Plücker pair; degenerate control | pass — finite nonempty ensemble, supplied Gibbs form; "no thermodynamic limit/irreversibility" disclosed | guards `{propext,Classical.choice,Quot.sound}`; `s o r r y`-free; **[packaging]** | **pass** — positive `4/625` + `degenerate_spectrum_zero_control` |
| S20 (Schottky V2, harness) | **[tautology]** — headline curve-match is a self-comparison (§2.2) | partial — gap-dependent fixture `Var(0)=4/625` + degenerate control are real; the *curve* is gap-independent | **needs fix** — caption implies external reproduction; disclose the gap cancellation | numeric harness; anchors legit but derivative not exercised | **fail as V2** — the "peak" is a universal-function property, not a physics recovery; re-tier (§9) |
| Target `SuccessiveAxisPositionWalk` (in flight) | **[hollow]** — true norm preservation, but not a Dirac walk (§3.1) | pass (motion + isometry controls) — but no Dirac witness | **needs fix** — no `alpha_i`/`H`/tangent; sign table disconnected | **`s o r r y` stub** — not landed | pending — needs §4 bridge |
| Target `ActionFlowRotation` (in flight) | pass (as stated), window caption needed | pass — `firstIntegral` nontrivial; `wrong_cosine_control` | pass — needs "elliptic window `0<mu<4`" caption | **`s o r r y` stub** | pending |
| Target `GibbsVarianceRigidity` (in flight) | pass (as stated) | pass — `4/25` positive; degenerate `←` | pass | **`s o r r y` stub** | pending |

**Substantive items:** (i) S20 fails the ND gate *as a V2* — its flagship check is
a tautology; re-tier/re-caption. (ii) `SuccessiveAxisPositionWalk` is hollow until
the §4 bridge lands. The two landed source flagships
(`AxisCoinComplexCliffordNoGo`, `FiniteGibbsVariance`) pass all five.

---

## 7. Exact corrections to the three matrices and stale items in Audit 11

### THEORY_COMPLETION_MATRIX.md
1. **Kinematics and causal support row.** The complex-scalar no-go is now
   **landed** (`axisBlockCoin_has_no_complex_clifford_block`, with
   `complex_square_kernel_nonzero` non-vacuity), not "running." Update to grade
   `K` for the simultaneous-coin scalar-square Dirac interpretation (killed over
   all `Complex`), keep Route B `H/B`, and set the next Route-B deliverable to the
   **§4 sign-table↔Clifford tangent bridge** and the one after to the **§5
   compact-momentum 3+1 bound**. Correct the current phrasing "position walk
   running" to "generic position-register norm preservation running; **Clifford
   sign/basis dictionary open** (the landed target proves isometry, not `−iH`)."
2. **Thermodynamics row.** `FiniteGibbsVariance` is **landed**; add the
   fluctuation identity `d⟨E⟩/dβ = −Var` and `Var ≥ 0` as `D`. Add that
   `GibbsVarianceRigidity` (rigidity dichotomy) is **in flight** as the next rung.
   Flag S20 as an **algebraic self-consistency**, not a physics reproduction
   (§2.2), so it does not inflate the row's "V2 reproduction" status.

### MANUSCRIPT_CLAIM_MATRIX.md
3. **M6 status.** Change "no-go running" → "**complex-scalar no-go landed**
   (`AxisCoinComplexCliffordNoGo`); positive-real form is now a corollary." Keep
   Route B internal-only; mark the position walk as "generic norm preservation
   (hollow re: Dirac); §4 tangent bridge is the open arrow." Retain the Audit-11
   correction that the physically decisive square is **positive** (`H² =
   +(‖k‖²+m²)I`), not negative.
4. **M17 status.** Add `FiniteGibbsVariance` fluctuation response as **landed**
   (`meanEnergy_hasDerivAt`, `variance_nonnegative`,
   `rational_plucker_variance_control`). Re-caption S20: the Schottky *curve
   match* is a **self-comparison** (gap cancels); the theorem-backed content is
   the derivative identity, which S20 does **not** numerically exercise. The
   genuine rigidity claim (`Var=0 ⇔ constant spectrum`) is `GibbsVarianceRigidity`,
   in flight.

### SIMULATION_BENCHMARKS.md
5. **S20 row.** Correct the pass metric: `normalized_gibbs_curve_matches_schottky_formula`
   is a **tautology** — with `C = β²Var`, `β = x/gap`, `Var = gap²p(1−p)`, the gap
   cancels and `C_sim(x) ≡ x²eˣ/(1+eˣ)² ≡ C_ana(x)` for **every** gap (recomputed:
   grid max error `2.78e-16`, pure rounding). Re-tier S20 from "V2 reproduction"
   to "V0 algebraic self-consistency + `Var(0)=4/625` fixture," or replace it with
   a **non-tautological** finite-difference fluctuation test (§9). Keep the
   degenerate/wrong-sign controls; they are genuine.
6. **S06 row.** Update "position walk running" → the position walk proves **generic
   norm preservation only**; the Dirac/`−iH` identification is **open** pending the
   §4 bridge. The complex-scalar kill and internal Route B are correctly LANDED.

### Stale / corrected items carried from Audit 11 (still controlling)
7. Audit 11's §3 flagship table lists `Targets/AxisCoinNoGo` and
   `Targets/FiniteGibbsVariance` as "`s o r r y` stub — not landed (in flight)."
   **Stale:** the corresponding **sources** (`AxisCoinComplexCliffordNoGo`,
   `AxisCoinPositiveCliffordNoGo`, `FiniteGibbsVariance`) are now landed and
   `s o r r y`-free. The `Targets/*` files remain `s o r r y` staging copies (Mathlib-only
   reformulations) and should not be confused with the landed sources — record
   both facts explicitly so a reader does not read the target stubs as "unlanded."
8. Audit 11's recommended kernel-finrank *architecture* (block-diagonal
   `rank(B²−zI)≥1` per block) is **superseded** by the actually-landed proof
   (`proj3` injective on the kernel via the `i·24/25 ≠ 0` coupling). Both are
   correct; the landed one is the record. Update the §4 recommendation to cite the
   `proj3` route.
9. Audit 11's confirmed **[error]** items remain valid and should propagate to
   Audit 12: (a) Audit 10 §1.3 "Dirac needs `H²=−k²I`" is false (`H²=+(‖k‖²+m²)I`,
   `α²=β²=+I`); (b) GS-04 §2/§5 benchmark-ID clash (Schottky/dispersion mislabeled
   S18/S19; live S18 = Dirac propagator, S19 = variational flow; new V2s = S20/S21).
   Note S20 is now *taken* by the (tautological) Schottky harness, so the genuine
   next V2 must be **S21**.

---

## 8. Whole-theory verdict: which arrows compose, which dictionaries still block a full theory

**Arrows that now genuinely compose (checked finite theorems, no hidden `s o r r y`):**

- **Selected primitive directions → mass invariant → finite action → stable flow
  → rotation picture.** `D4NullRaySpinorFactorization` →
  `massSq`/`PluckerActionHessian` → `DiscretePluckerVariationalFlow` (exact
  Euler–Lagrange recurrence) → `DiscretePluckerFlowStability` (pos-def first
  integral, iterate bound) → (in flight) `ActionFlowRotation` (exact conjugacy to a
  unit-circle rotation on `0<mu<4`). This is a real end-to-end **dynamics** chain
  for the selected `mu=4/25`; the open arrow is *primitive selection of the
  action*, not any internal gap.
- **Finite ensemble response chain.** `FiniteGibbsResponse`
  (`d log Z/dβ = −⟨E⟩`) → `FiniteGibbsVariance` (`d⟨E⟩/dβ = −Var`, `Var≥0`) →
  (in flight) `GibbsVarianceRigidity` (`Var=0 ⇔ constant spectrum`). Genuine,
  theorem-backed, shared ensemble. Open arrows: coarse-graining, irreversibility,
  thermodynamic limit.
- **Simultaneous-coin obstruction is closed.** D4 shell/coin/sector →
  `anisotropic_four_sector_witness` (real 4-D sector exists) →
  `AxisCoinComplexCliffordNoGo` (no complex-scalar-square 4-D block). The "is the
  six-channel coin the Dirac set?" question is **definitively answered: no**, over
  all `ℂ`. This is a clean **K** (killed route) with a non-vacuity guard.
- **Internal Route B algebra.** `SuccessiveAxisDiracWalk`: exact unitary
  `successiveStep`, `linearSplit` tangent `−iH`, `H²=(‖k‖²+m²)I`,
  `real_symbol_matches_project`. Internally complete on ℂ⁴.

**Dictionaries that still block "full theory" (candidate architecture only):**

1. **Sign-table ↔ Clifford (the decisive spatial gap).** Route B has **no**
   spatial realization: `SuccessiveAxisPositionWalk` proves isometry with an
   arbitrary velocity table disconnected from `alpha_i`. Until the §4 bridge
   (`U j · diag(sgn) · Uⱼᴴ = alpha_j`) lands, there is **no arrow** from the
   internal `−iH` algebra to a spacetime walk. This is the single missing link in
   the Kinematics row.
2. **Exact-step vs. `−iH` tangent are different families.** `successiveStep`
   (8-parameter, exact unitary) and `linearSplit` (1-parameter, tangent `−iH`)
   coincide only to first order; the exact spatial propagator ↔ `exp(−iHt)`
   dictionary is the §5 quantitative bound, still open in `3+1`.
3. **Continuum / PDE / local-net.** No position-space `ℓ²`, PDE, or graph-derived
   local net; only fixed-/bounded-momentum fiber limits (S18 in `1+1`; §5 is the
   proposed `3+1` rung).
4. **Primitive selection dictionaries.** The action, the coin coefficients, the
   time axis, and the spinor decorations are all *supplied*, not derived from
   primitive null data — every dynamics/mass arrow starts one node downstream of
   the primitive ontology.
5. **Thermo self-comparison.** The only thermodynamic V2 (S20) is a tautology
   (§2.2); the theory has **no** genuine numerical confrontation of the
   fluctuation identity yet.

**Verdict:** the project is a **coherent candidate architecture with two genuine
end-to-end finite chains** (dynamics; ensemble response) and **one clean killed
route** (simultaneous scalar-square Dirac coin), but it is **not yet a full
theory**: the sign-table↔Clifford spatial dictionary (§4) and the `3+1`
continuum bound (§5) are the two arrows whose absence keeps "3+1 Dirac emerges
from a null walk" a *claim with a named gap* rather than a theorem. The manuscript
should say exactly this.

---

## 9. Highest-value proof and highest-value V2 after the active targets return

**Single highest-value proof — the §4 sign-table↔Clifford tangent bridge**
(`CliffordDiag.hDiag` + `axisSymbol_hasDerivAt` + `stepSymbol_hasDerivAt`). It
converts the hollow `SuccessiveAxisPositionWalk` into a genuine spatial Dirac
walk whose tangent is `−iH`, closing the one arrow blocking the entire Kinematics
row (§8 gap 1). It reuses the landed `linear_split_entry_hasDerivAt` machinery, so
the only real obligation is exhibiting the per-axis unitary `U j` and proving the
diagonalization for the project's `alpha1,alpha2,alpha3`; the payoff (a genuine
finite spacetime Dirac step) is the highest in the corpus.

**Single highest-value V2 — a non-tautological fluctuation-response test (new ID
S21).** Do **not** repeat Schottky (S20 is a self-comparison) and do **not** do
`1+1` dispersion (redundant with S18). Instead confront the theorem
`meanEnergy_hasDerivAt` directly on a spectrum where the gap does **not** cancel:
- **Spectrum:** a nondegenerate ≥3-level fixture (e.g. `E=(0, 4/25, 9/25)`, both
  Plücker scales), so `C = β²Var` is genuinely spectrum-dependent.
- **Observable:** compare `Var(β)` computed two independent ways — (i) the
  centered-square formula, and (ii) a **finite-difference of `⟨E⟩` in `β`**,
  `−(⟨E⟩(β+h)−⟨E⟩(β−h))/2h` — over a `β` grid.
- **Pass metric:** the two agree to `O(h²)` (Richardson-extrapolated `< 1e-10`);
  this actually *exercises* `d⟨E⟩/dβ = −Var`, unlike S20.
- **Controls:** degenerate spectrum ⇒ both `= 0` (no anomaly);
  reversed-sign response ⇒ finite-difference disagrees in sign.
- **Anchor:** `FiniteGibbsVariance.meanEnergy_hasDerivAt`,
  `variance_nonnegative`, and the in-flight `GibbsVarianceRigidity`.
This is the first thermodynamic benchmark that confronts a theorem rather than an
identity, and it is cheap (reuses the landed ensemble API).

Runner-up V2 (pipeline): once §5 lands, the **`3+1` compact-momentum free-Dirac
propagator** (also S21-class) — the first genuinely `3+1` numerical confrontation,
non-redundant with the `1+1` S18.

---

## Consolidated defect ledger for Audit 12

1. **[tautology] S20 Schottky V2** — headline curve-match compares `x²p(1−p)` to
   `x²eˣ/(1+eˣ)²`; the `4/25` gap cancels identically (grid error `2.78e-16`,
   rounding only). Re-tier to V0 self-consistency or replace with the §9 finite-
   difference test. The theorem `meanEnergy_hasDerivAt` is real but untested by S20.
2. **[hollow] `SuccessiveAxisPositionWalk`** — `successiveWalk_preserves_norm` is
   norm preservation for any velocity table and any unitary coins; `tetraVelocity`
   is disconnected from `alpha1,alpha2,alpha3` (they are off-diagonal; a diagonal
   sign table cannot equal them, and axis-0's `TTFF` actually matches `beta`, the
   mass, misassigned to a spatial axis). Needs the §4 bridge.
3. **[true, land] `ActionFlowRotation`** — correct rotation conjugacy of the
   `mu=4/25` recurrence (`c=23/25`, `s=4√6/25`); caption "elliptic window
   `0<mu<4`," note irrational `s` forbids an exact-rational benchmark.
4. **[true, land] `GibbsVarianceRigidity`** — genuine `Var=0 ⇔ constant spectrum`
   dichotomy; guard the `→` direction on `probability_positive`.
5. **[true] `AxisCoinComplexCliffordNoGo`** — finrank-`≤3` proof via `proj3`
   injectivity is sound; `complex_square_kernel_nonzero` genuinely prevents a
   false invertibility reading; simultaneous scalar-square Dirac coin **killed
   over all ℂ** (coin-specific, non-vacuity guard required).
6. **[stale] Audit 11 §3 table** — `Targets/AxisCoinNoGo` and
   `Targets/FiniteGibbsVariance` "not landed" is stale at the *source* level
   (sources landed, `s o r r y`-free); the `Targets/*` copies remain staging stubs.
7. **[carried errors]** Audit 10 §1.3 negative-mass-shell claim (false;
   `H²=+(‖k‖²+m²)I`); GS-04 benchmark-ID clash (Schottky/dispersion must be
   S20/S21; S20 now taken by the tautological Schottky harness, so genuine next
   V2 = **S21**).
8. **[packaging]** All `Sources/*` import absent `PhysicsSM.*`; recorded as
   packaging, not a build failure. The `Audit` default target builds a trivial
   marker.
