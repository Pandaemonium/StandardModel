# Aristotle grand strategy 8 report: publication-closing theorem portfolio

Review-only grand-strategy pass over the full Null-Edge project at the state
described by `RUN_PLAN.md`, `PAPER_GATE_MATRIX.md`, `MANUSCRIPT_CLAIM_DELTA.md`,
`MEMO_3PLUS1_ATTACK.md`, `D_R3_SHANNON_BRIDGE_PROGRAM.md`, the technical
manuscript `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`,
and the exact Lean sources under `PhysicsSM/Draft/NullEdge/`. No Lean or
manuscript file was edited; no build was run. All module and theorem names below
were read from the live sources.

Every recommendation names exact hypotheses, a nondegenerate witness, a negative
control, and a kill condition, per the contract.

---

## 0. Scope corrections that this report preserves (binding)

These are the standing corrections from the task note and `MEMO_3PLUS1_ATTACK.md`;
every recommendation below respects them and none silently overrides them.

- **C1. Full-Dirac neutrality.** The complete mass-admitting four-component
  Dirac tangent is class-A **neutral**. Never assign a nonzero unsplit class-A
  charge to the full Dirac point. Only globally split Weyl sectors carry
  opposite local Jacobian charges. The mass homotopy
  `Fs(n)=cos(pi s/2)F0(n)+sin(pi s/2)beta` is a pointwise unit-circle family of
  gapped involutions; calling it a null-homotopy is the standard topological
  reading, **not** a separately kernel-checked homotopy theorem
  (`DiracLocalChargeNeutrality`).
- **C2. Global chirality is load-bearing.** A sectorwise charge sum is globally
  meaningful only under `[U(k), Xi] = 0` for all `k`, with `Xi = -i a1 a2 a3`.
  Local chirality at the origin does not supply that global splitting. For the
  live ordered Bloch step, `[Xi, U] = 0` iff `sin(theta)=0` (massless only).
- **C3. Strict-Laurent strong-triviality is imported-T / VERIFY.** The
  `K1(C[z1^±,z2^±,z3^±])` change-of-rings claim (arXiv:1608.04696v3) supports
  the algebraic spine only; finite-rank stabilization, Floquet sign
  conventions, and composition with the charge theorem remain VERIFY. **Never
  encode it as a Lean assumption.**
- **C4. Body centers cannot be naively sector-partitioned.** Each `4x4` body
  center carries both a `+1` and a `-1` eigenvalue; branch assignment cannot be
  read off by partitioning the `4x4` roots.
- **C5. Endpoint sign data are not a root** without pathwise determinant
  reality along an explicit origin-avoiding path (the missing hypotheses that
  kept the reciprocal family a family-level oracle obstruction rather than a
  landed no-go).
- **C6. Route C is reshuffle-and-gap, not sector deletion.** The multiset
  statement ("four fewer `±1` modes matching the K=2 quartet") is exact; the
  eigenvector-level claim "the kick deletes the pi-sector modes" is FALSE and
  must never be written. The derived kick is chirality-**even**, so the composed
  step **vectorizes** the protected sector (net protected chirality `-4 -> 0`);
  this is the exact finite incarnation of the Golterman-Shamir/SMG worry, a
  sharp negative, not a construction.
- **C7. No overreach that has not landed:** no universal reciprocal no-go, no
  unique-cone `3+1` walk, no arbitrary-`L2` PDE limit, no observed mass
  spectrum. The manuscript's own "Open" verbs stay open.

---

## 1. Ranked top ten next attacks

Ranking key: **S** = scientific consequence, **T** = formal tractability,
**L** = publication leverage, each H/M/L.

1. **Stationary-amplitude Weyl symbol: complete torus root census / sharp
   minimal-doubling count.** (S:H T:H L:H) — Question 1. Converts
   `StationaryAmplitudeWeylAlias.exists_distinct_identity_alias` (one alias at
   `(-1,1,-1)`, two more numerically) into an exact enumeration of all
   `det(weylStep ∓ 1)=0` torus solutions. Single `2x2` block, exact Gaussian-
   rational Laurent algebra — the highest tractability-per-consequence item in
   the whole portfolio. Upgrades a no-go into a theorem with a number in it.
2. **Cell-sampler density extension to arbitrary complex `L2(R^3)`.** (S:M T:H
   L:H) — Question 3, first half. A 3-epsilon argument over the landed
   `ChangingMomentumCellSampling.sampleFinite_tendsto_sq_error_zero` compact-
   support Lipschitz core, using Mathlib density of compactly-supported
   Lipschitz/continuous functions in `L2`. Closes a named Paper D gate with
   standard Mathlib machinery.
3. **Phase-defect bound-state / scattering distinguisher.** (S:H T:M L:H) —
   Question 4. Promote the static two-site `PlueckerPhaseDefectSpectrum.gSq`
   defect `(H^2-(m^2+t^2))^2 = t^2|Δ|^2` into a domain-wall mid-gap bound state
   (or transmission phase) whose existence/energy depends on `arg Δ`, not on
   `|z|`. This is the single most decisive "Pluecker mass ≠ renamed scalar
   mass" statement because a scalar mass carries no phase datum at all.
4. **Determinant-paired enlarged-register `3+1` construction attempt.** (S:H
   T:L L:H) — Question 2. The highest-payoff, highest-risk item: an explicit
   8-component (paired-spectrum) ansatz with a reciprocal conditional shift
   supplying a `Xi`-odd quadratic jet, plus a B4 root-exclusion certificate.
   Either a genuine survivor (construction paper) or a sharp resource lower
   bound (no-go paper).
5. **Positive aperture-closure-turn decomposition moduli: first no-uniqueness
   theorem.** (S:M T:H L:M) — Question 5. Composes the landed
   `ChannelRefinementTorsor`, `ChannelKreinSectorSignature` (4,2),
   `ChannelPositiveComplementDisk`, and `ChannelPositiveSectorModuli` into an
   explicit statement that positive decompositions form a nontrivial moduli
   with no Krein-invariant selector. Paper F capstone.
6. **Full changing-lattice `R^3` inverse-Fourier Dirac-PDE composition.** (S:H
   T:M/L L:H) — Question 3, second half. Compose scaled live bulk bound →
   `ChangingMomentumCellIsometry` → `ChangingLatticePDECore.band_approx_tendsto_zero`
   → Mathlib `fourierTransformₗᵢ` → identified Dirac flow. The Paper D headline;
   depends on #2 and needs an explicit multiplier-to-propagator identification.
7. **A4 conditional chiral-doubling composition (finite, total-charge-zero as a
   displayed hypothesis).** (S:M T:H L:M) — memo M3. Kernel-check that zero
   total sector charge + one nonzero local sector charge + crossing uniqueness
   is contradictory, without importing C3. `ChargeBalanceForcesPartner` already
   supplies the hinge; this composes it with the live census.
8. **Branch-resolved completeness of the positive-Weyl crossing census.** (S:M
   T:M L:M) — the deliberately narrow remaining theorem in `MEMO` §4: prove the
   two displayed `U=±I` lists are the complete branch-resolved crossing sets of
   the positive `2x2` Weyl block modulo torus identification. Must respect C4.
9. **Route C: derivability of a `Xi`-odd (chirality-odd) pair kick from the
   Pluecker datum, or the exact vectorization no-go as the theorem.** (S:H T:M
   L:M) — the sharply posed C4 question. Given C6, the honest first landing is
   the finite SMG obstruction (protected-chirality index `-4 -> 0`) as a
   publishable sharp negative; a Γ-odd repair is the upside.
10. **Paper E: derive the pair kick from a finite Hermitian generator and
    compose free+interacting layers with an exact/Trotter law.** (S:H T:M L:M)
    — the remaining dynamics gate; `PlueckerPairGenerator` circle-group layer is
    landed, the interacting factorization is in flight. Keep the "interaction
    supplied, not derived" boundary explicit.

---

## 2. Lean-shaped pseudostatements for the top five

These are shape targets, not frozen statements; names in backticks are live
modules/definitions read from the sources.

### T1. Stationary-amplitude Weyl root census (Question 1)

Work in `StationaryAmplitudeWeylTangent` where
`weylStep (zx zy zz : Complex) : M2` is the ordered three-axis rational
projector product, exactly unitary on the torus and `= 1` at `(1,1,1)`, with
first Laurent moment `(3/5) • sigma`.

```
-- zero-quasienergy census
theorem weyl_zero_census (zx zy zz : Complex)
    (hx : zx * conj zx = 1) (hy : zy * conj zy = 1) (hz : zz * conj zz = 1) :
    (weylStep zx zy zz - 1).det = 0
      ↔ (zx, zy, zz) ∈ ({(1,1,1), (-1,1,-1), r₃, r₄} : Finset _)
-- pi-quasienergy census
theorem weyl_pi_census (zx zy zz : Complex)
    (hx : zx * conj zx = 1) (hy : zy * conj zy = 1) (hz : zz * conj zz = 1) :
    (weylStep zx zy zz + 1).det = 0 ↔ (zx, zy, zz) ∈ (Sπ : Finset _)
-- consequence: exact minimal-doubling count
theorem weyl_minimal_doubling_count :
    (zeroCrossings.card + piCrossings.card) = N            -- N an explicit numeral
```

Route: expand `det(weylStep ∓ 1)` as an explicit Laurent polynomial in
`zx,zy,zz`, substitute `zj = cj + i sj`, `cj²+sj²=1`, and discharge with a
resultant/Gröbner or `decide`-checked finite certificate (oracle discovers the
finite set `{r₃,r₄}` and `Sπ`; kernel decides). Witness:
`corner_alias` (already landed) is one member of `zeroCrossings`. Negative
control: `corner_phase_ne_origin` shows the set is strictly larger than the
origin. **Kill:** if a solution set is a positive-dimensional torus curve
(nodal line), the object is a nodal-line semimetal, not isolated crossings —
still publishable, but as a different theorem; state that branch explicitly.

### T2. Cell-sampler density extension to arbitrary `L2(R^3)` (Question 3a)

Build on `ChangingMomentumCellSampling.integral_sq_error_global_le` and
`sampleFinite_tendsto_sq_error_zero` (both landed for compact-support Lipschitz
`f` with `hLip`, `hcover`, `hvolume`).

```
theorem sampleFinite_tendsto_L2 (f : Momentum3 → Complex)
    (hf : MemLp f 2 volume)
    (h : ℕ → Real) (s : ℕ → Finset Mode3)
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hcover : TendstoCover s h f)             -- selected cells eventually cover essential support
    (hbound : UniformlyBoundedVolume s h) :
    Tendsto (fun n => ∫ x, ‖sampleFinite (h n) (s n) f x - f x‖ ^ 2)
      atTop (𝓝 0)
```

Route: (i) prove `sampleFinite (h) (s)` is a uniformly `L2`-bounded linear
operator (contraction on each cell union via disjointness + Jensen); (ii)
3-epsilon: approximate `f` by compact-support Lipschitz `g` (Mathlib density of
`C_c` / Lipschitz in `Lp`), apply the landed bound to `g`, control `f - g` by
operator boundedness plus the ambient `L2` distance. Witness: the landed
Lipschitz core is the nonvacuous base case (`sampleFinite_tendsto_sq_error_zero`
is nonvacuous for the `ScaledChangingMomentumWalk` schedule). Negative control:
without the `h_N^{-3/2}` normalization the cell isometry fails
(`ChangingMomentumCellIsometry` already records the wrong `h^3` scaling).
**Kill:** if `N h_N` stays bounded, the represented volume does not exhaust
`R^3` and convergence is only fixed-torus (D-R3 kill list).

### T3. Phase-defect bound-state distinguisher (Question 4)

Extend `PlueckerPhaseDefectSpectrum` (which proves
`(H^2-(m^2+t^2))^2 = t^2 ‖Δ‖^2 · 1`, `Δ = zR - (conj w)^2 zL`, with the
equal-modulus hypothesis load-bearing and `gSq = a - t‖Δ‖`) to a domain wall.

```
-- semi-infinite / three-block chain with a phase wall zL → zR at equal modulus m
theorem phase_wall_midgap_mode (m t : Real) (zL zR w : ℂ)
    (hmL : Complex.normSq zL = m^2) (hmR : Complex.normSq zR = m^2)
    (ht : 0 ≤ t) :
    (∃ boundState, isMidGap boundState ∧ energy boundState = E (arg Δ))
      ∧ ¬ (∃ scalarMass : Real, mimics scalarMass boundState)   -- no real scalar reproduces arg-dependence
  where Δ := zR - (conj w)^2 * zL
```

Witness: the exact zero-mode locus `t = |zL|`, `zR = -(conj w)^2 zL` (already
`gap_zero_iff`) is a genuine `arg Δ`-selected bound state. Negative control: the
already-formalized unequal-modulus counterexample refuting the identity, and
common-phase removability (`common_phase_conjugacy`) showing the observable is
the *relative* transported phase, not a global phase. **Kill:** if every
`arg Δ`-dependence is removable by a unitary conjugacy that also rescales `m`,
the phase is a reparametrization after all — publish the exact removal map as a
"no operational distinguisher at this order" result instead.

### T4. Determinant-paired enlarged-register `3+1` construction (Question 2)

The escape class (memo A5/B3): `U_perp = (U - Xi U Xi)/2 ≠ 0` with vanishing
constant and linear jets, exact unitarity, and an exact root-exclusion
certificate at both quasienergies. The naive coupled embedding is
kernel-killed (`CoupledReciprocalSliceNoGo.exists_additional_zero_crossing`),
so the defining new ingredient is an explicit paired-spectrum symmetry.

```
-- 8-component: two chirality copies with an explicit charge-conjugation C
def pairedWalk (r : Real) (zx zy zz : Complex) : Matrix (Fin 8) (Fin 8) ℂ := …
theorem pairedWalk_unitary       : ∀ on-torus, IsUnitary (pairedWalk r zx zy zz)
theorem pairedWalk_paired_spectrum (…) :
    C * pairedWalk r zx zy zz * C⁻¹ = (pairedWalk r zx zy zz)⁻¹   -- built-in spectral pairing
theorem pairedWalk_odd_jet_quadratic :
    constJet Uperp = 0 ∧ linJet Uperp = 0 ∧ quadJet Uperp ≠ 0
theorem pairedWalk_alias_free (…) :        -- the prize, with a B4 certificate
    ∀ zx zy zz on-torus, (pairedWalk … - 1).det = 0 ∨ (… + 1).det = 0
      → (zx, zy, zz) = (1,1,1)
```

Witness: `ReciprocalConditionalShiftRegulator` supplies a noncentral corner
action (`det S = 1`, quadratic zero at `z=1`, both corner gaps at `z=-1`);
`ReciprocalCoinFamily` classifies which `r` open the corner gap. Negative
control: the paired-spectrum hypothesis is exactly what the naive embedding
lost (memo "naive embedding kill"), so dropping `C` must reproduce a spurious
eigenvalue-one root. **Kill:** if every paired-spectrum enlarged register still
carries a residual crossing, land the bounded escape class as *empty* with its
minimum-resource statement (resource lower-bound paper). Respect C3 (no Laurent
strong-winding assumption) and C5 (root needs pathwise determinant reality).

### T5. Positive-decomposition moduli no-uniqueness (Question 5)

Compose the landed Paper F pieces into a finite moduli statement. The named
even channels `apertureC`, `closureC`, `turnC` have explicit normal forms; the
even Krein-self-adjoint sector has signature `(4,2)`
(`ChannelKreinSectorSignature`); positive complements are a rational open disk
(`ChannelPositiveComplementDisk`); an explicit rational Krein isometry (boost)
carries the diagonal positive family to a distinct one
(`ChannelPositiveSectorModuli.boosted_witness_not_diagonal`).

```
-- moduli of positive aperture-closure-turn decompositions with fixed total
def PosDecomp := { t : ChannelRefinement // FixedTotal t ∧ PositiveOnDerivedSector t }
theorem posDecomp_moduli_nontrivial :
    ∃ t₁ t₂ : PosDecomp, ¬ KreinEquiv t₁ t₂                    -- two inequivalent positive decompositions
theorem posDecomp_no_invariant_selector :
    ¬ ∃ sel : PosDecomp → NamedChannel,
        (∀ g : KreinIsometry, Equivariant sel g) ∧ Injective sel  -- no canonical choice
theorem posDecomp_equiv_control :
    KreinEquiv t₀ (boost • t₀)                                  -- the equivalence control
```

Witness: `boostedPositive` (a distinct positive four-frame with identical Gram),
plus the disk of positive complements as the continuous modulus. Negative
control: `ChannelSolderDegreeNoGo` (raw solder-letter degree is not an intrinsic
selector) and `ChannelTraceSelectorNoGo` show that the obvious selectors fail.
**Kill / promotion:** if some intrinsic selector *does* single out one
decomposition, that uniqueness is the theorem instead — but the standing
evidence (torsor + disk + boost witness) strongly favors no-uniqueness.

---

## 3. Recommended focused Aristotle package boundaries

Keep each package standalone, seed-typechecking, with one witness and one
negative control. Suggested boundaries (do not straddle):

- **PKG-B-census (T1).** Only `StationaryAmplitudeProjectorWalk`,
  `StationaryAmplitudeWeylTangent`, `StationaryAmplitudeWeylAlias`. Goal:
  `weyl_zero_census` and `weyl_pi_census` with the finite root set as an
  explicit `Finset`. Do **not** pull in the `4x4` `FullBloch*` modules — this is
  a `2x2` block problem and mixing the `4x4` census invites the C4 trap.
- **PKG-D-density (T2).** Only `ChangingMomentumCellSampling`,
  `ChangingMomentumCellIsometry`, plus Mathlib `Lp`/density. Goal:
  `sampleFinite_tendsto_L2`. Keep the live multiplier (`ScaledChangingMomentumWalk`)
  and the Fourier isometry (`fourierTransformₗᵢ`) **out** of this package; they
  belong to PKG-D-compose (T6/item 6).
- **PKG-D-compose (item 6).** Depends on PKG-D-density landing first. Only after
  T2 lands should the `ChangingLatticePDECore` → `fourierTransformₗᵢ` → Dirac
  flow chain be one package, with the explicit multiplier-to-propagator identity
  as the load-bearing lemma.
- **PKG-A-phasedefect (T3).** Only `PlueckerPhaseDefectSpectrum` plus a small
  chain builder. Goal: the domain-wall mid-gap mode and its `arg Δ` dependence.
  Keep the equal-modulus hypothesis explicit and load-bearing.
- **PKG-B-paired (T4).** Standalone construction file seeding on
  `ReciprocalConditionalShiftRegulator`, `ReciprocalCoinFamily`, `Xi`/`alpha`
  definitions. Split into two sub-jobs: (a) unitarity + paired-spectrum +
  quadratic odd jet; (b) the B4 root-exclusion certificate. Do **not** submit
  (b) before (a) typechecks; do not encode any C3 Laurent assumption.
- **PKG-F-moduli (T5).** `ChannelRefinementTorsor`, `ChannelKreinSectorSignature`,
  `ChannelPositiveComplementDisk`, `ChannelPositiveSectorModuli`,
  `ChannelSolderDegreeNoGo`, `ChannelTraceSelectorNoGo`. Goal: the three moduli
  theorems. This is composition of landed results; a good "strategy+compose"
  slot rather than a deep search.
- **PKG-B-A4 (item 7).** `ChargeBalanceForcesPartner` + live census. Small,
  finite, high-confidence; a good filler that closes the Route A logic without
  touching C3.

Apply the two-hour stall rule especially to PKG-B-paired (T4): preserve the
unitarity/jet prefix and stop the root-exclusion tail if it stalls, resubmitting
a smaller slice (e.g. one physical slice with an explicit certificate).

---

## 4. Anticipated false statements and convention traps

- **Full-Dirac charge (C1).** Any statement assigning a nonzero class-A charge
  to the four-component tangent is false-shape. Only split Weyl sectors carry
  charges. Guard with `DiracLocalChargeNeutrality`.
- **Sector charge without global `Xi` commutation (C2).** A sector charge sum is
  meaningless unless `[U(k),Xi]=0` for all `k`; for the live step this is exactly
  `sin(theta)=0`. Do not state a sector sum for a massive angle.
- **Body-center partition (C4).** Do not infer branch assignment by partitioning
  the `4x4` roots; each body center is a `(+1,-1)` pair. T8 (census completeness)
  must argue at the `2x2` positive-Weyl level.
- **Endpoint-sign "roots" (C5).** Opposite signs at two `x`-values give a root
  only with pathwise determinant reality on an origin-avoiding path. The
  reciprocal *family* obstruction is oracle-level precisely because this and the
  explicit-block hypotheses were missing.
- **Route C sector deletion (C6).** "The kick deletes the pi-sector modes" is
  false at eigenvector level (modes are momentum-hybridized). Only the multiset
  statement is exact. The composed kick is chirality-even and vectorizes.
- **Cell normalization (D-R3).** Omitting `h_N^{-3/2}` gives wrong `h_N^3`
  scaling and breaks the isometry; the live symbol must be evaluated at scaled
  `xi_N(k)=h_N k`, never at unscaled `k`, or it is a different evolution.
- **Two limits, not one (D-R3).** `h_N -> 0` alone gives a fixed torus;
  `N h_N -> infinity` alone does not densify. Both are required; state both.
- **Fourier sign/normalization.** Mathlib's `fourierTransformₗᵢ` convention must
  be fixed once and matched to the walk symbol; a sign flip silently produces
  the adjoint propagator.
- **Krein form ≠ identity (Paper F).** The Ward/Krein form-preservation
  condition is `Uᴴ G U = G`, not `Uᴴ G U = 1`
  (`WardAutomorphismQuotient` already corrected this false frozen condition).
  The signature-(4,2) Gram `a²+d²+e²+g²-2b²-2f²` must be used, not the Euclidean
  one.
- **`weylStep` at `z=0` (Paper B).** The onsite band carries `z z⁻¹`, which
  collapses to `0` at `z=0`; every unitarity/expansion statement needs
  `z ≠ 0` (documented in `StationaryAmplitudeProjectorWalk`). On-torus use
  `conj z = z⁻¹`.
- **Adjoint-phase family (Paper B).** `(forwardPhase z P)ᴴ = forwardPhase z⁻¹ P`
  under `conj z = z⁻¹`, *not* `backwardPhase`; the naive claim is false.
- **Prose verbs (manuscript-wide).** Keep "forced / derived / realized / open"
  distinct. The C3 Laurent strong-winding result is imported-T/VERIFY, never a
  premise; "topological reading" of the neutrality homotopy is not a kernel
  theorem.

---

## 5. One ambitious 6-hour composition

**Paper D physical-space Dirac limit on the compact-support dense core**
(items 2 + 6). Compose, in one guarded chain:

```
ScaledChangingMomentumWalk (uniform live split-vs-Dirac bound, landed)
  → sampleFinite_tendsto_L2                         (T2, new)
  → ChangingMomentumCellIsometry (h^{-3/2} exact isometry, landed)
  → ChangingLatticePDECore.band_approx_tendsto_zero (landed)
  → MeasureTheory.Lp.fourierTransformₗᵢ            (Mathlib)
  → position-space Dirac-flow identification         (new, load-bearing)
```

Deliverable: for compactly-supported Lipschitz complex `L2(R^3)` data on the
`h_N = 1/(N+1)`, cutoff `(N+1)^2`, radius `N+1` schedule, the changing-cell
interpolant of the live scaled `3+1` walk converges in `L2(R^3)` to the
position-space Dirac flow, with the limiting multiplier explicitly identified as
the Dirac propagator (not merely named `exact`). Witness: the explicit retained
`x`-face mode with represented physical momentum `N+1`. Negative control: the
D-R3 kill list (fixed `h`, bounded `N h`, missing normalization, unscaled
symbol). This is ambitious because the final multiplier-to-propagator identity
is the one step the manuscript still lists as open; it is *achievable* in 6 h
only because every upstream rung is already landed and only T2 + the
identification are new. **Kill:** if the identification requires a Sobolev class
strictly stronger than compact-support Lipschitz, publish the compact-support
dense-core PDE theorem and mark arbitrary-`L2` as the residual frontier.

## 6. One conservative 90-minute theorem

**T1 restricted to the zero-quasienergy census, or PKG-B-A4.** Either:

(a) `weyl_zero_census`: expand `det(weylStep − 1)` on the torus and prove its
zero set is exactly `{(1,1,1),(-1,1,-1)} ∪ {two explicit off-corner roots}` via
an exact rational certificate. Witness: `corner_alias` (landed). Control:
`corner_phase_ne_origin`. This is a single `2x2` determinant computation with a
finite decidable root check — high-confidence in 90 minutes and it already
sharpens the manuscript's stationary-amplitude sentence; or

(b) `ChargeBalanceForcesPartner`-based A4 finite implication (item 7): zero total
sector charge + one nonzero local charge + crossing uniqueness ⇒ contradiction,
with the two-sector witness and singleton control already present. Pure finite
algebra, no C3 dependence.

Prefer (a): it directly feeds T1 and the abstract edit in §7.

---

## 7. Question 6: manuscript claim to strengthen, cut, or split

**Primary recommendation — SPLIT the strict-`3+1` regulator material out of
Paper A's abstract into the A-prime obstruction letter.** The Paper A abstract
is a single mega-paragraph that currently packs the area/gap derivation, the
`3+1` alias/body-center no-go suite, the changing-lattice results, and the CAR
dynamics. The best next theorem for the `3+1` suite (T1: the stationary-
amplitude root census / minimal-doubling count) will change that story from a
list of no-gos ("no degree-one factor supports a stationary amplitude...") into
a **sharp minimal-doubling count** — a self-contained quantitative result that
deserves its own home in the A-prime obstruction letter (already "near-ready"
per the gate matrix). Keeping it in Paper A both dilutes the freeze-grade
specialist story and risks the abstract going stale the moment T1 lands.

**Secondary — STRENGTHEN the phase-defect sentence into a Paper A headline.**
The transported-relative-phase spectral consequence
(`(H^2-(m^2+t^2))^2 = t^2|Δ|^2`, equal-modulus load-bearing) is the paper's
cleanest "Pluecker ≠ scalar mass" evidence and is fully kernel-landed. It is
currently one clause deep in a long sentence. Given T3 (the bound-state upgrade)
is a high-leverage next theorem building directly on it, promote the
phase-defect result to a named operational-distinguisher headline now, with T3
flagged as the planned upgrade — without stating T3 as done.

**Tertiary — STRENGTHEN the charge-bookkeeping clause's trust label.** The
abstract still tags the symbol-to-Jacobian reduction as "an exact run record,
its central-node instance in kernel formalization." Per `MEMO` §4, the live
positive-Weyl Pauli decomposition, complete Fréchet derivative, and the
`LiveMasslessWeylCensusBridge`/`MasslessBlochCrossingClassification` identifications
are now kernel-landed; the reduction clause can be upgraded to kernel status
**while keeping the branch-resolved completeness (T8/item 8) explicitly open**.
Do not overstate: C4 means completeness is genuinely still open.

No claim should be *cut* outright — the scoping is otherwise honest and the
"forced/derived/realized/open" table is accurate.

---

## 8. Hard recommendation: where Codex should spend the next fleet slots

Codex owns Papers D, F, B (plus Lean guards and the Jordan-Clifford lane). With
~3-4 proof slots, 1 strategy, 1 audit, spend them as:

1. **Slot 1 (proof, highest ROI): PKG-B-census / T1.** Start with the
   90-minute conservative `weyl_zero_census` (§6a), then escalate to the full
   census and `weyl_minimal_doubling_count`. This is the single best
   consequence-per-effort item and it directly enables the Paper A/A-prime split
   (§7).
2. **Slot 2 (proof): PKG-D-density / T2.** Standard Mathlib density work with a
   landed nonvacuous base case; closes a named D gate and unblocks the 6-hour
   composition (§5).
3. **Slot 3 (proof/compose): PKG-F-moduli / T5.** Composition of already-landed
   Paper F pieces into the no-uniqueness theorem; low risk, packages Paper F's
   negative route (the run plan's P4 instruction to ship the negative
   classification first).
4. **Slot 4 (deep proof, accept risk): PKG-B-paired / T4**, split into the
   unitarity/jet sub-job first and the B4 certificate second. This is the
   portfolio's highest-payoff gamble; gate it behind the two-hour stall rule and
   fall back to the bounded-escape-class emptiness (resource lower bound) if the
   certificate stalls.
5. **Strategy slot:** keep the 90-minute grand-strategy cadence and pre-stage
   PKG-D-compose / item 6 so it launches the instant T2 lands.
6. **Audit slot:** a standing hostile audit on the C1-C7 traps (§0, §4),
   especially any prose that (a) assigns a full-Dirac charge, (b) states a
   sector sum at a massive angle, or (c) encodes the C3 Laurent claim as an
   assumption.

Fable's lanes (Paper C stability/index, Paper E dynamics, Furey-Baez) are
correctly separated; the one cross-lane dependency to watch is that T3
(phase-defect distinguisher) sits at the Paper A / Paper E boundary — coordinate
ownership before both fleets touch the phase-defect module.

Net: **T1 and T2 are the two must-do slots this cycle** (highest tractability ×
leverage, both with landed prerequisites); **T4 is the one worth a deep,
stall-gated gamble**; **T5 is the cheap Paper-F capstone to bank in parallel**.
