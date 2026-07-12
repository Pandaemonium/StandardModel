# Aristotle grand strategy 9 report: exact census and continuum composition

Review-only pass. No project file was edited and no broad build was run. The
exact algebraic claims in §1–§2 were reproduced in a scratch computer-algebra
session against the pinned symbol coefficients read from
`StationaryAmplitudeWeylTangent.lean`; every such check is marked **[CAS]** and
is reproducible with `Scripts/oracle/analyze_stationary_amplitude_weyl.py`
extended by one lex Gröbner call. All module, theorem, and definition names in
backticks were read from the live sources listed in the contract.

Sources read in full: `GOAL_PROMPT_CODEX.md`, `RUN_PLAN.md`,
`PAPER_GATE_MATRIX.md`, `MANUSCRIPT_CLAIM_DELTA.md`, `GRAND_STRATEGY8_REPORT.md`,
`B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`,
`B_STATIONARY_AMPLITUDE_WEYL_ORACLE_2026-07-11.md`,
`Scripts/oracle/analyze_stationary_amplitude_weyl.py`,
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`,
`StationaryAmplitudeWeylAlias.lean`,
`StationaryAmplitudeWeylExactOffCornerAlias.lean`,
`ChangingMomentumCellIsometry.lean`, `ChangingMomentumCellSampling.lean`,
`ChangingMomentumL2Density.lean`, `ChangingMomentumBoxExhaustion.lean`, and the
point-sampler no-go target `AgentTasks/aristotle-targets/
codex_24h_d_point_sampler_l2_nogo.lean`.

This report preserves every standing scope correction carried by
`GRAND_STRATEGY8_REPORT.md` §0 (C1 full-Dirac neutrality, C2 global-`Xi`
load-bearing, C3 Laurent strong-triviality imported-T/VERIFY, C4 body centres
not naively partitionable, C5 endpoint signs are not roots, C6 no eigenvector
sector deletion). Nothing below overrides them.

---

## 0. One governing structural fact (exact)

For each axis `factor` the axis symbol is exactly `SU(2)`: the determinant of
`stationaryWalk zj Pj Qj` on the unit circle is `9/25·(c²+s²)+16/25 = 1`
(oracle memo; `weylStep_unitary` gives torus unitarity). Writing each axis
element in the Pauli basis with `zj = cj + i sj`, `cj²+sj²=1` **[CAS]**:

```
Ux = (9cx+16)/25 · I + i[ (3/5) sx · σx + (12cx−12)/25 · σy ]
Uy = (9cy+16)/25 · I + i[ (12−12cy)/25 · σx + (3/5) sy · σy ]
Uz = (9cz+16)/25 · I + i[ (12−12cz)/25 · σy + (3/5) sz · σz ]
```

Note each axis already carries **two** Pauli directions, not one: the isotropic
`(3/5)·σ` statement in `x_gammaMoment`/`y_gammaMoment`/`z_gammaMoment` is the
*first Laurent moment* `γ₊−γ₋ = P+Q−1`, **not** the full axis symbol. The
ordered product `weylStep = Ux·Uy·Uz` is therefore a single `SU(2)` element
`u0·I + i(wx σx + wy σy + wz σz)` with `u0²+wx²+wy²+wz² = 1` identically, and
all four coefficients are real rational trigonometric polynomials (imaginary
parts identically zero, as the oracle records).

Because the object is `SU(2)`, the entire crossing problem collapses to the
vanishing of the **Pauli vector** `w = (wx, wy, wz)`:

- `weylStep = +I` (zero quasienergy) ⇔ `w = 0` ∧ `u0 = +1`;
- `weylStep = −I` (π quasienergy)  ⇔ `w = 0` ∧ `u0 = −1`.

On `SU(2)`, `w = 0` already forces `u0 = ±1`; the sign of `u0` then partitions
the crossing set into zero- vs π-quasienergy. This is the exact reduction the
census must be built on, and it is the honest replacement for "another root."

---

## 1. Exact stationary-root census: the completeness route

### 1.1 Reduction to one real polynomial system

The full census is the real variety

```
V = { (cj,sj)_{j=x,y,z} : cj²+sj²=1,  wx = wy = wz = 0 }
```

on the compact 3-torus, split by `sign(u0)`. Three vector equations plus three
circle constraints, six real unknowns. Do **not** attack the raw `2×2` matrix
equation `weylStep = ±I` (four complex entries): the `SU(2)` reduction above
removes the redundant scalar equation and the unitarity relation for free.

### 1.2 Rational (Cayley/half-angle) chart to make it algebraic

Substitute `tj = tan(qj/2)`, i.e. `cj = (1−tj²)/(1+tj²)`, `sj = 2tj/(1+tj²)`,
`tj ∈ ℝ`. Clearing the common denominator `(1+tx²)(1+ty²)(1+tz²)` turns the
three trigonometric equations into three **integer polynomials**

```
Wx, Wy, Wz ∈ ℤ[tx,ty,tz],   total degrees 6, 5, 6   [CAS].
```

The chart misses exactly the points where some `qj = π` (`tj = ∞`); those are a
finite, separately-checkable boundary set (see §1.5). Every solution with all
`qj ≠ π` is an affine common zero of `{Wx,Wy,Wz}`.

### 1.3 Completeness by a lex Gröbner basis (the certificate)

Compute the reduced Gröbner basis of `I = (Wx,Wy,Wz)` under lex order
`tz > ty > tx` **[CAS]**. It has four elements in **shape-lemma (triangular)
form**:

- `g₁`: **linear in `tz`** — determines `tz` as a ℚ-rational function of
  `(tx,ty)`;
- `g₂, g₃ ∈ ℚ[tx,ty]`, with `g₃` factoring as
  `(tx²+1)² · ( D₁₄(tx)·tx + κ·ty )`, `κ ∈ ℚ`, `deg D₁₄ = 14` — determines `ty`
  as a ℚ-rational function of `tx` on the non-extraneous component;
- `g₄ ∈ ℚ[tx]`, the **elimination polynomial**, which factors completely over
  ℚ as

```
g₄(tx) = tx · (4tx+5) · (tx²+1)²
         · (64tx²−45tx+100)
         · (35tx⁵+100tx⁴+250tx³+56tx²+35tx+100)          ← irreducible quintic
         · (196tx⁶−315tx⁵+3000tx⁴−2250tx³+5700tx²−315tx+1600)   [CAS]
```

Total degree 19. Because `I` is zero-dimensional and the basis is triangular,
`tx` determines `ty` determines `tz`: the count and location of real torus
crossings is read directly off `g₄`.

### 1.4 Real-root bookkeeping and isolation of extraneous roots

Root-by-root, keeping only **real** `tj` (physical unit-circle phases) **[CAS]**:

| factor of `g₄` | degree | real roots | status |
| --- | --- | --- | --- |
| `tx` | 1 | `tx=0` | **origin** `(1,1,1)` = `weylStep_one` |
| `4tx+5` | 1 | `tx=−5/4` | **9-40-41** `x`-phase = `exact_offCorner_alias` |
| `(tx²+1)²` | 4 | none (`tx=±i`) | **extraneous**: exactly the Cayley poles `zj∈{0,∞}` introduced by clearing `(1+tj²)`; discard |
| `64tx²−45tx+100` | 2 | none (disc `−23575<0`) | complex off-circle crossing; excluded by reality |
| **quintic** | 5 | **exactly one**, `ρ≈−0.83081` | **fully off-axis root** |
| sextic | 6 | none | complex off-circle crossings; excluded by reality |

Hence in the affine chart there are exactly **three** real crossings:
`tx ∈ {0, −5/4, ρ}`. The mechanism that "isolates the extraneous complex
roots" is therefore fully explicit and rational:

1. the double factor `(tx²+1)²` is precisely the denominator artefact of the
   Cayley transform (`zj = 0` or `zj = ∞`), removed by requiring `tj` finite
   real;
2. the quadratic and sextic factors have **negative real content** (no real
   roots) — they are genuine crossings of the *complexified* symbol where
   `|zj| ≠ 1`, removed by the unit-circle (reality) constraint `cj²+sj²=1`.

Only after discarding (1) and (2) does the census become the physical set.

### 1.5 The corner at infinity

The chart-boundary case `qj = π` (`tj=∞`) is checked separately and finitely.
The only crossing there is the corner `(−1,1,−1)` (`corner_alias`), i.e.
`q/π = (−1,0,−1)`, at which all three axes sit at a chart pole; it is not seen
by `g₄` and must be added by hand. Concretely, re-run the same lex elimination
in the complementary chart `sj/(1+cj)` (or homogenize `Wx,Wy,Wz` and inspect
the hyperplane at infinity) to certify that `(−1,1,−1)` is the unique boundary
solution.

### 1.6 The exact certificate for the fully off-axis root

The remaining oracle candidate `q/π ≈ (−0.441334, −0.522326, +0.624904)` is
**not** a Gaussian rational and has **no closed radical form**. Its exact
certificate is:

- `tx = ρ`, the unique real root of the irreducible quintic
  `P(t) = 35t⁵+100t⁴+250t³+56t²+35t+100 ∈ ℤ[t]` (`tan(qx/2)=ρ≈−0.830808`,
  reproducing `qx/π≈−0.441334` **[CAS]**);
- `ty`, `tz` given by the ℚ-rational shape-lemma maps from `g₃` (linear in `ty`)
  and `g₁` (linear in `tz`) evaluated at `tx=ρ`;
- the Galois group of `P` over ℚ is `S₅` (order 120, generated by a 5-cycle and
  a transposition), so `P` is **not solvable by radicals** **[CAS]**.

So the honest statement is: the fourth crossing is an isolated algebraic point
of degree 5 with `S₅` Galois group; the correct Lean encoding is *not* a closed
form but the pair (irreducible minimal polynomial `P`, rational shape maps
`ty(tx),tz(tx)`), with `u0=+1` verified at `tx=ρ`.

### 1.7 Verdict: complete zero/π census

- **Zero-quasienergy (`weylStep=+I`) crossings: exactly four** — origin,
  `(−1,1,−1)` corner, the `9-40-41` conjugate configuration
  `((−9∓40i)/41, ·, 1)`, and the degree-5 off-axis point. All have `u0=+1`,
  verified exactly at the three rational configurations and numerically at
  `ρ` **[CAS]**.
- **π-quasienergy (`weylStep=−I`) crossings: none.** The vector variety `w=0`
  *is* the four-point set above, and `u0=+1` at every one of them, so
  `u0=−1` is never met. (State this as its own lemma: `u0−1` vanishes on `V`,
  equivalently `u0=+1` on the finite `V`.)

The manuscript sentence should read: **the ordered stationary-amplitude Weyl
symbol has exactly four identity crossings and no π crossings**, three of them
rational/Gaussian-rational and one an `S₅`-degree-5 algebraic point.

---

## 2. Minimal-doubling verdict

### 2.1 What count is physically meaningful

The physically meaningful invariant is **not** "number of solutions of
`w=0`" but the **signed low-energy fermion content**: at each *isolated,
non-degenerate* crossing where the `SU(2)` symbol passes through `±I`, expand
`weylStep` to first order in `δq` and read the local Weyl Hamiltonian
`H_loc = v·(δq)ᵃ σᵃ` (velocity/vielbein matrix `∂wᵃ/∂qᵇ` at the crossing). The
count that can appear in a manuscript is the pair

```
(#zero-quasienergy cones, #π-quasienergy cones) = (4, 0),
```

each cone tagged by (a) quasienergy 0 vs π and (b) the **sign of
det(∂wᵃ/∂qᵇ)** at that crossing (the local handedness). The Nielsen–Ninomiya
constraint that the handedness signs sum to zero over the whole torus is the
consistency check to display; four zero-energy cones with signs summing to zero
is the expected doubled-Weyl fingerprint.

### 2.2 Zero versus π and Jacobian signs — what to compute, and the trap

For each of the four crossings compute the `3×3` real Jacobian `J = ∂(wx,wy,wz)
/∂(qx,qy,qz)` and record `sign det J` and full rank (non-degeneracy). This
gives the chirality *labels*. Two guards, both binding:

- **A finite/local Jacobian sign is a handedness label, not a Chern number.**
  Do **not** infer a topological charge (Chern/winding) from a single crossing's
  `sign det J`. The Chern charge is a global Berry-curvature integral; the
  Jacobian sign is only its local linearization and coincides with the charge
  **only** for an isolated, non-degenerate, gap-closing cone. State the sign as
  "local handedness of the linearized cone," never as "topological charge."
  (This is the exact §5 audit item and mirrors C5: local/endpoint sign data are
  not a global invariant on their own.)
- **The `S₅` off-axis crossing may be non-generic.** Before assigning it a
  handedness, verify `det J ≠ 0` at `tx=ρ` (full-rank cone) rather than a
  higher-order touching (which would be a semimetallic quadratic band-touch,
  not a Weyl point). If `det J = 0` there, the honest object is a non-Weyl
  band-touch and must be reported as such.

### 2.3 The doubling verdict itself

This construction **does not** achieve minimal (single-cone) doubling: the
kernel-landed `exists_distinct_identity_alias` and `exact_offCorner_alias`
already prove there is more than one identity crossing, and §1 sharpens this to
**exactly four zero cones, zero π cones**. The publishable statement is a
**sharp doubling count** ("the isotropic stationary-amplitude Weyl symbol
carries exactly four zero-quasienergy cones and no π cone"), *not* a minimal- or
unique-cone claim. The kill condition for the count theorem: if the off-axis
Jacobian is rank-deficient, the "four cones" phrasing is false-shape and must
be demoted to "three Weyl cones plus one higher-order band touch."

---

## 3. Cell-average `L2` repair: smallest exact Lean theorem ladder

Assuming the point-sampler no-go lands (the target
`ChangingMomentumPointSamplerNoGo` proves `pointSpike` is AE-zero yet
center-samples to `1`, `sampleFinite_not_ae_invariant`, and gives the
`cellAverage` definition with `cellAverage_congr_ae`, `cellAverage_pointSpike_
zero`, `cellAverage_const_one`), the minimal exact sequence that carries the
normalized finite-cell average from a single cell to the live-multiplier
composition is the following eight rungs. Each is a standalone target; each
names its base module. `cellAverage h k f := (vol(cell))⁻¹ • ∫_{cell} f`.

1. **AE invariance** (already in the no-go target): `cellAverage_congr_ae` —
   `f =ᵐ g ⇒ cellAverage h k f = cellAverage h k g`. This is the whole point:
   `cellAverage` descends to `L²` classes; `sampleFinite` does not.
2. **Linearity**: `cellAverage h k (a•f + g) = a • cellAverage h k f +
   cellAverage h k g`, from `integral_smul`/`integral_add` on the fixed
   finite-measure cell (needs `IntegrableOn f (momentumCell h k)`).
3. **Constant normalization** (already in target): `cellAverage_const_one`
   plus `cellAverage h k (fun _ => c) = c`. Fixes the `h^{-3/2}` /volume
   normalization exactly and is the nonvacuous witness.
4. **`L2` contraction (one cell, Cauchy–Schwarz/Jensen)**:
   `‖cellAverage h k f‖² ≤ (vol cell)⁻¹ · ∫_{cell} ‖f‖²`. This is the
   load-bearing analytic inequality; it makes the cell-average *projection*
   `Pf := Σ_k cellPacket h k (cellAverage h k f)` a bounded operator with
   `∫‖Pf‖² ≤ ∫‖f‖²` (contraction), using disjointness
   (`momentumCell_disjoint`) and the exact isometry `embedFinite_isometry`.
5. **Wrong-scaling control**: reuse
   `ChangingMomentumCellIsometry.integral_norm_sq_rawCellPacket` (omitting
   `h^{-3/2}` gives the exact wrong factor `h³`) and, for the projection,
   `cellAverage` with the *raw* (unnormalized) packet violating rung 3. Keeps
   normalization load-bearing.
6. **Dense-core convergence (compact-support Lipschitz)**: for the projection
   `P_n` built from `cellAverage (h n) (s n)`, prove `∫‖P_n f − f‖² → 0` for a
   fixed compact-support Lipschitz `f` under `h n → 0`, cover, and bounded
   volume — the cell-average analogue of the landed
   `sampleFinite_tendsto_sq_error_zero`. The pointwise error bound reuses
   `mem_momentumCell_norm_error` (radius `h/2`) and Jensen on the cell.
7. **Arbitrary-`L2` three-epsilon extension**: for `hf : MemLp f 2 volume`,
   `∫‖P_n f − f‖² → 0`. Route (standard): approximate `f` by compact-support
   smooth/Lipschitz `g` via
   `ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_
   approx`; bound `‖P_n f − f‖₂ ≤ ‖P_n(f−g)‖₂ + ‖P_n g − g‖₂ + ‖g−f‖₂`; the
   first and third are `≤ ε` by the rung-4 contraction and density, the middle
   `→0` by rung 6. This is where AE-invariance (rung 1) is essential — the
   estimate is on `L²` classes, which the point sampler cannot support.
8. **Live-multiplier composition**: compose the cell-average projection with
   the landed scaled live split-vs-Dirac bound (`ScaledChangingMomentumWalk`)
   and the exact `h^{-3/2}` embedding `embedFinite_isometry`, giving
   `∫‖P_n(U_n^live c) − (evolved f)‖² → 0` on the exhausting box
   (`ChangingMomentumBoxExhaustion.momentumBox_exhausts`, `N h_N → ∞`). This is
   the D-R3 headline rung; keep the two-limit hypotheses (`h_N→0` **and**
   `N h_N→∞`) explicit and the Fourier-isometry-to-Dirac-flow identification as
   the single remaining load-bearing step.

Rungs 1–5 are small and should be one package; 6–7 a second; 8 depends on both
plus the separately-tracked Fourier/PDE identification and should not be
submitted before 6–7 typecheck.

---

## 4. Ranked six-job publication plan (Papers A/B/D/F)

Ranking = (acceptance leverage) × (tractability given landed prerequisites).
Each job: one-sentence manuscript consequence + explicit kill condition.

**J1 — B: exact four-cone stationary-amplitude census (§1).** *Highest ROI.*
Prove `weyl_zero_census` = the four-point set and `weyl_pi_census = ∅` via the
lex-Gröbner shape lemma of §1.3, with the extraneous `(tx²+1)²`/no-real-root
factors discarded and the corner added from the boundary chart.
*Consequence:* upgrades Paper B/A-prime from "not unique-cone" to "**exactly
four zero cones, no π cone**," a quantitative theorem with a number in it.
*Kill:* if the boundary-chart step reveals an extra `qj=π` solution, the count
is wrong — recount before stating four.

**J2 — B: minimal-doubling Jacobian labelling (§2).** Compute `sign det J` and
full rank at the four crossings; state `(4,0)` with handedness signs summing to
zero. *Consequence:* a sharp doubling fingerprint with displayed local
handedness. *Kill:* off-axis `det J = 0` ⇒ demote to "three cones + one
band-touch"; and never call any sign a Chern number.

**J3 — D: cell-average `L2` repair, rungs 1–5 (§3).** Land AE invariance,
linearity, constant normalization, one-cell contraction, wrong-scaling control.
*Consequence:* replaces the AE-ill-defined point sampler by a bounded
`L²`-projection — closes the named Paper D "point evaluation is not
AE-invariant" gate. *Kill:* if the one-cell Cauchy–Schwarz constant is not
`(vol)⁻¹` the contraction fails; check the normalization first.

**J4 — D: cell-average dense-core + arbitrary-`L2` convergence, rungs 6–7
(§3).** *Consequence:* strong squared-`L²(ℝ³)` convergence of the cell-average
projection for *arbitrary* `L²` momentum data, not just the Lipschitz core.
*Kill:* if the three-epsilon middle term needs a Sobolev class stronger than
compact-support Lipschitz, publish the dense-core theorem and mark arbitrary-`L²`
residual.

**J5 — F: positive-decomposition moduli no-uniqueness (compose landed pieces).**
Compose `ChannelRefinementTorsor`, `ChannelKreinSectorSignature` (4,2),
`ChannelPositiveComplementDisk`, `ChannelPositiveSectorModuli`,
`ChannelSolderDegreeNoGo`, `ChannelTraceSelectorNoGo` into
`posDecomp_moduli_nontrivial` + `posDecomp_no_invariant_selector`.
*Consequence:* Paper F capstone — positive decompositions form a nontrivial
moduli with **no** Krein-invariant selector. *Kill:* if some intrinsic selector
does single one out, that uniqueness is the theorem instead (evidence favours
no-uniqueness).

**J6 — A/A-prime: split the `3+1` no-go suite into A-prime and promote the
phase-defect distinguisher.** Editorial+claim job gated on J1: move the
stationary-amplitude count into the A-prime obstruction letter and promote the
kernel-landed `PlueckerPhaseDefectSpectrum` `(H²−(m²+t²))² = t²‖Δ‖²`
equal-modulus result to a named "Pluecker mass ≠ scalar mass" headline.
*Consequence:* A stays freeze-grade specialist; A-prime gains a self-contained
quantitative count. *Kill:* if A-prime lacks an independent one-sentence
consequence after the split, merge back into A (gate-matrix rule).

Ordering rationale: J1 is a single `2×2`/`SU(2)` elimination with three landed
witnesses (`weylStep_one`, `corner_alias`, `exact_offCorner_alias`) and is the
one job that changes a headline number; J3/J4 close a *named* D gate with
standard Mathlib density (`memLp_exists_compact_global_lipschitz_eLpNorm_approx`
already landed); J5 is pure composition of landed F pieces; J2 and J6 are
short follow-ons to J1.

---

## 5. Adversarial audit: sentences/gates that still confuse a weaker fact with the physical conclusion

Each item is a specific over-reach pattern to hunt and fix in prose and gates.

1. **"Isotropic Weyl tangent" read as full symbol (local tangent → global
   symbol).** `x/y/z_gammaMoment` prove the *first Laurent moment* is `(3/5)σ`;
   the full axis symbol carries a second Pauli direction (§0). Any sentence
   implying the symbol *is* `(3/5)σ·q`, or that the isotropic first moment
   controls the Brillouin zone, is false — `nonconstant_control` and the four-
   crossing census (§1) are the refutation. Fix: "isotropic **first moment**,"
   never "isotropic symbol."

2. **"Not unique-cone" quietly upgraded to a count.** Until J1 lands, only
   `exists_distinct_identity_alias` (≥2 crossings) is proved. Do not write
   "four cones" as landed; write "≥ two exact identity crossings; the exact
   count is a stated open elimination" (this report supplies the route, not a
   kernel proof).

3. **Jacobian sign → Chern/topological charge (§2.2).** Any clause reading a
   crossing's `sign det J` as a topological charge, winding, or Chern number is
   false-shape. It is a local handedness label only. This is the single most
   dangerous over-reach in the B lane and mirrors C5.

4. **Oracle root treated as proved (numerics → theorem).** The off-axis
   `q/π≈(−0.441,−0.522,+0.625)` is, in the *current* kernel state, an oracle
   candidate only; the manuscript must say "numerically located; exact
   certificate is the irreducible `S₅` quintic of §1.6," not "exact root," until
   J1 lands it.

5. **Point sampler described as an `L²` operator (pointwise sampler → bounded
   operator).** Any D-lane sentence that treats `sampleFinite`/center sampling
   as acting on `L²` data is false: `sampleFinite_not_ae_invariant` (target)
   shows it does not descend to AE classes. Only `cellAverage` does. Fix all
   "sampling on `L²`" to "cell-average projection on `L²`."

6. **`Z2^3` cover read as physical flavour mixing (finite relabelling → SM
   families).** Per `B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`, the eight-sheet
   deck action on this successive-axis symbol is the scalar sign character `±1`
   (`splitStep(qx+π,·) = −splitStep`), **not** internal-register conjugation.
   Any sentence claiming the cover produces genuine flavour mixing, derives the
   family count, or removes doublers is false for this symbol; it is a
   relabelling/reinterpretation, not alias removal.

7. **"Changing-lattice ℝ³ theorem" claimed from fixed-torus/dense-core rungs
   (partial limit → full continuum).** Landed pieces are the exact `h^{-3/2}`
   cell isometry (`embedFinite_isometry`, fixed structure), the compact-support
   Lipschitz sampler bound, and box exhaustion — separately. The full
   changing-lattice ℝ³ Dirac-flow theorem requires *both* `h_N→0` and
   `N h_N→∞` **and** the Fourier-isometry-to-Dirac-propagator identification,
   none of which is landed. Do not relabel the dense-core sampler or the
   fixed-torus `L²` transport as the ℝ³ theorem (RUN_PLAN D instruction).

8. **Full-Dirac charge / sector sum at massive angle (C1/C2).** Any nonzero
   unsplit class-A charge on the four-component Dirac tangent is false-shape
   (`DiracLocalChargeNeutrality`); a sector charge sum is meaningful only under
   `[U(k),Xi]=0 ∀k`, i.e. `sin θ=0`. Guard both.

9. **C3 Laurent strong-winding encoded as a premise.** The
   `K1(C[z^±])` change-of-rings claim stays imported-T/VERIFY and must never be a
   Lean assumption or a "derived" verb.

10. **Body-centre `{±π/2}³` folded into the corner census (C4).** Each `4×4`
    body centre is a `(+1,−1)` pair; the `2×2` stationary-amplitude census of §1
    is a *different* orbit and must not be conflated with the `4×4` body-centre
    branch assignment.

---

## 6. Two immediately launchable focused Aristotle packages

Both seed on files that already typecheck (per the in-file `#print axioms`
guards), carry one nonzero witness and one negative control, and prohibit
weakening. Neither pulls in the `4×4` `FullBloch*` modules (C4 trap) or any C3
assumption.

### PKG-B-census-zero (Paper B; feeds J1/J6)

*Imports.* `import Mathlib` +
`PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent`,
`StationaryAmplitudeWeylAlias`, `StationaryAmplitudeWeylExactOffCornerAlias`.
Work only in the `2×2` `weylStep` symbol.

*Declarations (statement targets; bodies `by sorry` for the subagent).*
```lean
open PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

/-- Pauli-vector reduction: on the torus `weylStep = I ↔ its σ-vector = 0 ∧ u0 = 1`. -/
theorem weylStep_eq_one_iff_pauliVector_zero (zx zy zz : Complex)
    (hx : starRingEnd Complex zx * zx = 1)
    (hy : starRingEnd Complex zy * zy = 1)
    (hz : starRingEnd Complex zz * zz = 1) :
    weylStep zx zy zz = 1 ↔
      (weylStep zx zy zz) 0 1 = 0 ∧ (weylStep zx zy zz) 1 0 = 0
        ∧ (weylStep zx zy zz) 0 0 = 1 := by sorry

/-- No π-quasienergy crossing exists. -/
theorem weylStep_ne_negOne (zx zy zz : Complex)
    (hx : starRingEnd Complex zx * zx = 1)
    (hy : starRingEnd Complex zy * zy = 1)
    (hz : starRingEnd Complex zz * zz = 1) :
    weylStep zx zy zz ≠ -1 := by sorry
```
*Nonzero witnesses.* `weylStep_one` (origin), `corner_alias` `(−1,1,−1)`,
`exact_offCorner_alias` (`9-40-41`) are three exact members of the zero set.
*Negative controls.* `nonconstant_control` (`weylStep I 1 1 ≠ 1`) and
`wrongOrientation_not_alias` (`weylStep phaseX phaseX 1 ≠ 1`) keep the symbol
demonstrably nonconstant and the conjugate pairing load-bearing.
*Prohibit weakening.* Keep the three unit-circle hypotheses
`starRingEnd ℂ z * z = 1`; without them the statement is about the complexified
off-circle symbol (the sextic/quadratic roots) and the census is false.
*Scope note.* The full four-point completeness (`weyl_zero_census` as a
`Finset` equality) is the harder second job; land the two lemmas above first,
then attempt completeness using the §1.3 shape lemma as the informal proof (the
elimination polynomial factorization is the certificate; the corner is added
from the boundary chart).

### PKG-D-cellaverage-core (Paper D; feeds J3)

*Imports.* seed directly on the point-sampler no-go target file
`AgentTasks/aristotle-targets/codex_24h_d_point_sampler_l2_nogo.lean`
(namespace `ChangingMomentumPointSamplerNoGo`), which already imports
`ChangingMomentumL2Density` (hence `ChangingMomentumCellIsometry`,
`ChangingMomentumCellSampling`). First discharge the file's existing `sorry`s
(`pointSpike_ae_zero`, `sampleFinite_pointSpike_center`,
`sampleFinite_zero_center`, `sampleFinite_not_ae_invariant`,
`cellAverage_congr_ae`, `cellAverage_pointSpike_zero`, `cellAverage_const_one`),
then add rungs 2, 4, 5 of §3:

```lean
open ChangingMomentumCellIsometry ChangingMomentumCellSampling

/-- Rung 2: cell averaging is linear on integrable data. -/
theorem cellAverage_add {h : Real} (hh : 0 < h) (k : Mode3)
    {f g : Momentum3 → Complex}
    (hf : IntegrableOn f (momentumCell h k)) (hg : IntegrableOn g (momentumCell h k)) :
    cellAverage h k (f + g) = cellAverage h k f + cellAverage h k g := by sorry

/-- Rung 4: one-cell L² contraction (Cauchy–Schwarz / Jensen). -/
theorem cellAverage_sq_le {h : Real} (hh : 0 < h) (k : Mode3)
    {f : Momentum3 → Complex} (hf : IntegrableOn (fun x => ‖f x‖^2) (momentumCell h k)) :
    ‖cellAverage h k f‖ ^ 2
      ≤ (volume (momentumCell h k)).toReal⁻¹ * ∫ x in momentumCell h k, ‖f x‖ ^ 2 := by sorry
```
*Nonzero witness.* `cellAverage_const_one` (`cellAverage h k 1 = 1`) — the
normalization is exact and nonvacuous for `0 < h`.
*Negative controls.* (i) `sampleFinite_not_ae_invariant` — the point sampler is
*not* AE-invariant, so it cannot replace `cellAverage`; (ii)
`integral_norm_sq_rawCellPacket` — omitting `h^{-3/2}` gives the exact wrong
factor `h³`, so the normalization in `cellAverage` is load-bearing.
*Prohibit weakening.* Keep `0 < h` (rung 3/4 divide by `vol = h³`); keep the
AE-invariance rung (`cellAverage_congr_ae`) as the reason the operator descends
to `L²` — the entire repair is vacuous without it.

*Stall rule.* For PKG-B-census, land the two `∀`-lemmas and the three witnesses
before attempting the `Finset` completeness tail; for PKG-D, land rungs 1–3
(mostly the target's own `sorry`s) before the analytic rung-4 contraction.

---

## 7. One-line status for the gate matrix

- **B:** exact route to a *complete* four-cone / zero-π census now in hand
  (§1), certificate = lex-Gröbner shape lemma + irreducible `S₅` quintic;
  demote "not unique-cone" to the sharp count only after J1 lands. Doubling
  verdict: **(4,0)**, not minimal.
- **D:** point-sampler no-go + `cellAverage` repair ladder fully specified
  (§3); rungs 1–5 are immediately launchable (PKG-D-cellaverage-core).
- **A/A-prime:** ready to split the `3+1` count into A-prime and promote the
  phase-defect distinguisher once J1 gives the number (J6).
- **F:** no-uniqueness capstone is pure composition of landed pieces (J5).
