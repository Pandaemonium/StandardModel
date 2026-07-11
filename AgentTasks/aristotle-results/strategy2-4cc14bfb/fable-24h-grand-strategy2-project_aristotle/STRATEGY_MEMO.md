# STRATEGY MEMO — Grand strategy 2 (Fable lanes, 24h run, review at T+2h)

**Mode:** REVIEW-ONLY. **Scope of this audit:** the four Lean sources under
`context/` (`CGGSVWZDictionary.lean`, `PinnedMirrorChart.lean`,
`PinnedSectorIndex.lean`, `ThetaFamilyProtection.lean`), read directly.

**Build caveat (read first).** All four files `import` landed engine modules
that are *not* in this packet
(`PhysicsSM.Draft.NullEdge.HalfPeriodInvariant`, `…ModeInvariantHalfWinding`,
`…PinnedMirrorChart` as an import, `…PinnedSectorDefs`). They therefore cannot
be compiled in this tree, and this memo audits *statements and proof scripts*,
not a green build. Two disclosure classes are visible and must be tracked
verbatim in prose:

- **Kernel-only (3 axioms):** `ThetaFamilyProtection.lean`, `CGGSVWZDictionary.lean`.
- **Draft-trust (+2 axioms `Lean.ofReduceBool`/`Lean.trustCompiler` via
  `native_decide`):** `PinnedMirrorChart.lean`, `PinnedSectorIndex.lean`.

---

## Executive ranking of remaining ~18h

| Rank | Target | Value | Effort | Verdict |
|------|--------|-------|--------|---------|
| 1 | **Q1(b′): kernel + all-θ generalization of the atlas / positional iff** using the symbolic machinery already in `ThetaFamilyProtection` | High | Low–Med (0.5–2h) | **DO NOW** |
| 2 | **Q2c fix: pin `Wth` to the landed `walkQ` fixture** (transport compatibility lemma) | High (credibility) | Low (0.5–1h) | **DO NOW** |
| 3 | **Q3 free-lift momentum block-diagonalization** small theorem (when E jobs land) | High | Med | Queue for E return |
| 4 | **Q1(a): general-L positional law** | Med–High | High/Research | **L=4 standalone; general-L future work**, gated |
| 5 | **Q1(c): freeze C prose** | — | — | Not yet; after Rank 1–2 |

Rationale below, per question.

---

## Q1. Paper C completion ordering

### Recommendation: (b′) first, then decide on (a); do **not** freeze (c) yet.

The single most cost-effective move is a *sharpened* version of (b): the
`ThetaFamilyProtection` file already contains, kernel-only and for **all** θ,
the *sufficiency* direction of the positional law
(`M13_selfadj_of`, `M02_selfadj_of`) and the combinatorial dispatch
(`two_wall_chart`). Two cheap wins remain that both **kernelize** a current
`native_decide` fixture **and** generalize it from the fixture angle to all θ:

**Target b1 — general kernel atlas (LOW effort, ~0.5h).**
Kernel + all-θ replacement of `PinnedMirrorChart.atlas_two_charts`
(currently `native_decide`, fixed ℚ angle). Exact statement shape:

```lean
theorem atlas_two_charts_family (theta : ℝ) (b : Fin 4 → Bool)
    (hb : HalfPeriodInvariant.wallCount b = 2) :
    (M13 theta b = (M13 theta b)ᵀ) ∨ (M02 theta b = (M02 theta b)ᵀ)
```
Proof is exactly the body of `modes_persist` minus the last engine step:
`two_wall_chart` ⟶ `M13_selfadj_of`/`M02_selfadj_of`. Kernel-only, all θ.
This strictly dominates the fixed-angle `native_decide` atlas.

**Target b2 — general symbolic positional *iff* (LOW–MED effort, ~1–2h).**
This is the item that "pays" most and is the honest generalization of the landed
`selfadj_iff_protected`. The `M13_selfadj_of` proof closes every off-diagonal by
`linear_combination ±sin θ · h` with `h : signB (b 0) + signB (b 2) = 0`. That
is strong evidence the *entire* antisymmetric part of `M13` is a scalar multiple
of `(signB (b 0) + signB (b 2)) · sin θ`. So the clean symbolic iff is within
reach:

```lean
-- the discriminating entry, in closed form (verify the exact coefficient first):
theorem M13_antisymm_entry (theta : ℝ) (b : Fin 4 → Bool) :
    (M13 theta b - (M13 theta b)ᵀ) 0 1
      = -(signB (b 0) + signB (b 2)) * Real.sin theta   -- COEFFICIENT TO CONFIRM

theorem M13_selfadj_iff (theta : ℝ) (b : Fin 4 → Bool) :
    M13 theta b = (M13 theta b)ᵀ
      ↔ (signB (b 0) + signB (b 2)) * Real.sin theta = 0
```
with the analogous `M02_selfadj_iff` on `signB (b 1) + signB (b 3)`. This is the
correct honest generalization of the fixture iff: at the fixture angle
(`sin θ ≠ 0`) it collapses to the pure positional criterion
`b 0 ≠ b 2`; and it *contains* the T5 negative controls as instances rather than
three hand-picked witnesses. **Gate:** confirm the exact scalar coefficient by a
one-line `#eval`/`simp` on the (0,1) entry before committing the `iff` name.
**Kill condition:** if the antisymmetric part is *not* uniformly a single scalar
multiple of `(signB b0+signB b2)·sinθ` across all entries (e.g. a second
independent trig monomial appears off the `sin`-line), abandon the global `iff`
and keep only `…_of` (sufficiency) + the three controls; do NOT ship a
symbolic `iff` you can only prove entrywise-by-luck.

**On the "16-field iff via Fin enumeration" phrasing in the question:** once b2
holds, you do *not* want a `Fin`-enumeration iff — the symbolic iff subsumes it
and is angle-general. A `decide`/enumeration iff would re-introduce either
`native_decide` (no axiom saving) or a per-angle fixture (no generalization).
So b2 is the version that pays; the enumeration version does not.

### (a) general-L positional law — L=4 standalone, general-L as future work.

**Recommended publishable unit:** L=4 now; general-L flagged future work.
Reason: the current formalization is L=4-native in three places that do not
generalize for free — the register `V8 = Fin 4 × Fin 2`, the explicit shift
permutations `![1,2,3,0]`/`![3,0,1,2]`, and above all the *decidable* dispatch
`two_wall_chart` (`revert…; decide` over the 16 fields). On a `2n`-ring the
dispatch is no longer a finite `decide`; it becomes a genuine combinatorial
lemma that must be proven for all `n`.

**Candidate general-L statement shape (the crux to settle first):**
```lean
-- 2n-ring dispatch (the gate for the whole general-L program):
theorem twowall_dispatch (n : ℕ) (b : Fin (2*n) → Bool)
    (hb : wallCount b = 2) : ∃ i : Fin (2*n), b i ≠ b (i + n)
-- "some antipodal (opposite-site) pair is anti-aligned" → the site-axis through
-- that pair certifies the fixed-leg compression.
```
Then the modes theorem generalizes as: *for every two-wall field on the 2n-ring
there is a site-axis reflection whose fixed-leg compression is a traceless
self-adjoint involution, hence the complete walk carries ±1 modes for all θ.*

**Gate (do this before any general-L investment, ~0.5h):** verify
`twowall_dispatch` by `decide` sweeps at `n = 2, 3, 4, 5` first. A two-wall field
on a `2n`-ring is a single `+`-arc against a single `−`-arc; the antipodal pair
straddling a wall is anti-aligned, so the lemma is very plausibly true — but the
*positional* refinement (lone flip must sit on the fixed site of the certifying
chart, mirroring the L=4 "protected vs blind singleton" split) is the part most
likely to change shape with `n` and must be re-derived, not assumed.
**Kill condition:** if the small-`n` sweep exhibits a two-wall field with **no**
anti-aligned antipodal pair, or if "which chart certifies" stops being a clean
function of the flip position, general-L is not a quick extension — freeze at
L=4 and record the obstruction.

**Effort estimate:** general-L is a multi-hour-to-multi-day parametric
re-engineering (parametric register, shift, coin, compression engine, and a real
inductive/combinatorial dispatch). Not an 18h target alongside everything else;
L=4 standalone is the correct publishable cut.

### (c) freeze C prose — not yet.

Freeze only *after* Rank 1–2 land, because b2 changes what the paper can honestly
claim (a symbolic angle-general iff vs. a fixture iff + three controls) and Q2c
closes a genuine referee hole. Freezing now would lock in the weaker/riskier
phrasings flagged in Q2.

---

## Q2. Over-claim risks a hostile referee would find

### Q2a. `two_wall_chart` dispatch — **the decide bridge is correct; one framing caveat.**

`two_wall_chart : wallCount b = 2 → b 0 ≠ b 2 ∨ b 1 ≠ b 3`, proved
`revert hb; revert b; decide`, is **sound and the right bridge**. Manual check of
the 12 two-wall fields confirms the disjunction: every singleton is anti-aligned
on the axis *not* carrying its lone flip, every block is anti-aligned on both
axes. `decide` enumerates all 16 `Fin 4 → Bool` and verifies the implication;
it consumes whatever the *landed* `HalfPeriodInvariant.wallCount` definition is,
so the bridge is exactly as trustworthy as that landed def (which
`CGGSVWZDictionary.protectedField_compat` independently ties to the local copy —
good).

**Caveat to state, not a bug:** `…selfadj_of` gives *sufficiency* only
(`b i ≠ b j` ⇒ chart certifies). `modes_persist` needs nothing more, so it is
honest. But do **not** let prose upgrade this to "the chart certifies *iff*"
on the strength of `two_wall_chart` — the iff is what Q1-b2 must supply
symbolically (currently only the fixture `selfadj_iff_protected` and three T5
witnesses cover the converse). Referee target sentence: any "certified exactly
when" phrasing about the θ-family before b2 lands.

### Q2b. CGGSVWZ `rot` convention — **impossibility is direction-independent; the "CGGSVWZ index" identification is a modeling assumption.**

`rot b = fun i => b (i+1)`. Two honest observations:

1. **Direction (i+1 vs i−1) is immaterial to the theorem.**
   `no_periodic_index_reproduces_discriminator` only uses
   `hI : ∀ b, I (rot b) = I b`. Since `rot` has order 4, invariance under `rot`
   is invariance under the whole ℤ/4 that the periodic-extension translation
   induces on the fundamental domain; the inverse shift is `rot³`. So whether the
   walk's split-step shifts "left" or "right", `rot` (or its inverse) is *a*
   generator, and the impossibility is unaffected. No soundness issue from a
   direction mismatch.

2. **The real content is narrow, and the "CGGSVWZ" label is prose, not proof.**
   The theorem quantifies over *all* functions invariant under `rot`, so its
   mathematical core is exactly `protectedField_rot_ne` — "the discriminator is
   not rotation-invariant." That the CGGSVWZ bulk/relative/gentleness indices
   *are* rotation-invariant (`wallCount_rot` is proven; the general claim "every
   CGGSVWZ index factors through the run structure" is asserted in the docstring)
   is a **modeling assumption**, not a Lean theorem about the actual CGGSVWZ
   construction. **Referee-honest phrasing:** "our discriminator is strictly
   finer than any translation-invariant index of the periodic extension (and, by
   the standard fact that CGGSVWZ indices are translation invariant, than every
   CGGSVWZ index)." Do not phrase it as "we proved no CGGSVWZ index reproduces
   the certificate" without the parenthetical, or a referee will note that no
   CGGSVWZ index object is ever constructed in Lean.

3. **Oracle constants are not load-bearing (good).** `bulkWindingPair`,
   `relativeIndexAcrossWall`, `indexGroupName` are oracle-transcribed and, as the
   provenance states, the impossibility does not depend on them. Keep them
   explicitly flagged "source re-verification pending"; the rot-direction sign
   convention *only* matters for the sign of these winding constants, which are
   already quarantined. `relativeIndexAcrossWall_eq = (0,-4)` is a `decide` over
   the transcribed table, i.e. it verifies arithmetic *of the transcription*, not
   the physics — say so.

4. **Trivial-corollary flag:** `gentleness_index_blind` instantiates the
   impossibility at `siPlus`, which is **defined as the constant `0`**
   (`def siPlus (_b) : ℤ := 0`), *not* the trace index actually computed in
   `PinnedSectorIndex`. So this corollary proves only "a constant function cannot
   equal the discriminator" — mathematically trivial and adding nothing over the
   main theorem. It is honest (the sector index really is 0 on the certified
   family, per `PinnedSectorIndex`), but a referee will notice the corollary
   does not *use* that computation. Either wire `siPlus` to the real
   `PinnedSectorIndex` trace and prove its rot-invariance, or downgrade the
   corollary's prose to "a fortiori, the (vanishing) gentleness index is blind."

### Q2c. `Wth_eq_Wexp` / the ℝ-vs-ℚ transport — **the honest pin is present within the file, but the pin to the *landed* fixture is MISSING. Highest-value fix.**

- `Wth_eq_Wexp` honestly pins the product `S·C(θ,b)·S` to a single explicit
  `8×8` matrix `Wexp`. Good — it prevents silent forking of the walk *inside this
  file*, exactly as claimed.

- **The gap:** `Wth`, `shiftR`, `coinR` are re-defined over ℝ in this file and
  are only *asserted* (docstring: "transporting the context `shiftQ`", "the
  context `coinQ … over ℝ`") to be the ℝ-analogues of the landed ℚ walk `walkQ`.
  There is **no lemma** connecting `Wth θ₀ b` to the landed fixture walk at the
  fixture angle θ₀. Because the landed protection results and the fixtures are
  stated for `walkQ` (over ℚ), a hostile referee asks: *"you proved protection
  for your matrix `Wth`; how do I know `Wth` is the same operator whose
  fixed-angle protection you already published?"* The answer is currently
  eyeball-only.

- **Fix (Rank 2, ~0.5–1h).** Add the transport-compatibility lemma. The fixture
  coin uses rational `cos θ₀, sin θ₀` (e.g. a `(3/5, 4/5)`-type Pythagorean
  pair — confirm the fixture's values), so a literal equation is provable via
  `ratCast`/`Matrix.map`:
  ```lean
  -- with c0 s0 : ℚ the fixture's rational cosine/sine and θ₀ the angle with
  -- Real.cos θ₀ = (c0 : ℝ), Real.sin θ₀ = (s0 : ℝ):
  theorem Wth_eq_landed (b : Fin 4 → Bool) :
      Wth θ₀ b = (walkQ c0 (fun x => signB' (b x) * s0) b).map (Rat.cast) -- shape
  ```
  Even a weaker `shiftR = shiftQ.map Rat.cast` plus `coinR θ₀ b = (coinQ …).map
  Rat.cast` at the fixture angle would close the hole. **This is the single
  additional theorem that most raises the θ-family module's credibility**:
  without it the "generalizes the landed fixture" claim is unproven; with it the
  θ-family result provably *contains* the landed one at θ₀.

- **Non-issues (state as clean):** `modes_persist` correctly needs no `sin θ ≠ 0`
  (`M13_selfadj_of` holds for all θ including the massless point), so the modes
  persist even at `sin θ = 0`; the `sin θ ≠ 0` scoping applies *only* to the T5
  negative controls, and `control_blind_massless` (T6) honestly documents that.
  The `IC13`/`IC02` → engine chain and the `toCR` transport lemmas
  (`toCR_mul`, `toCR_conjTranspose`, `toCR_injective`, …) are sound; the
  traceless-involution ⇒ both ±1 eigenspaces reasoning is discharged by the
  landed engine (`involutive_compression_fixed_mode`/`_flip_mode`) and is fine.

### Additional over-claim flags found (beyond the three asked)

- **`PinnedMirrorChart` / `PinnedSectorIndex` are fixed-angle ℚ + `native_decide`
  (+2 axioms).** Every "for every field" there is a 16-field (or 4-block)
  enumeration *at the fixture angle*, not an all-θ statement. Prose must not
  present `atlas_two_charts`, `charts_complementary`, `block_involution`,
  `nu13_singleton_all_zero`, `nu02_blind_all_zero`, `nuBlock_all_zero` as
  angle-general — they are the θ-family file's job (Rank 1 upgrades the atlas;
  the sector-index vanishing is not yet generalized).
- **`CGGSVWZDictionary` compat is partial.** Only `protectedField_compat` proves
  local≡landed. `wallCount`, `loneAt`, `fixedSingleton` are asserted
  "byte-faithful" but not individually proven equal. Since the impossibility is
  stated purely on the local `protectedField` (which *is* proven equal), this is
  self-consistent; but "byte-faithful re-declaration" is an eyeball claim for the
  helper defs — either add three one-line `decide` compat lemmas or soften the
  wording.

---

## Q3. E lane end-game (when pairgen + boundstate return)

**Strongest honest E-paper claim assembly:**

1. **Generator layer (pairgen).** The pair-kick generator satisfies the exact
   closed form `K³ = |z|² K`, a circle group law, and the half-pulse
   identification — i.e. `K` generates a one-parameter (circle) family with an
   exactly solvable minimal polynomial. Honest claim: *the pair-kick is an
   exactly integrable single-generator family*, with the half-pulse a named group
   element.
2. **Spectrum layer (boundstate).** The interacting two-particle spectrum on the
   28×28 fixture is *exactly* characterized by the charpoly factorization, whose
   nontrivial content is the shifted-level cubic
   `3125 w³ − 2300 w² − 6156 w − 1440`, `w = 2 cos 2ε`. Honest claim:
   *exact interacting levels on the fixture, in closed algebraic form.*
3. **Boundary/kill layer (already landed).** The composition kill
   `[H_free, K] ≠ 0` (no exponential splitting) plus within-layer disjoint
   commutation bounds the assembly: **you may claim an exact spectral/fixture
   result, but NOT a dynamical factorization** of the interacting evolution.
   State this limit explicitly — it is what keeps the paper honest.

**The one additional small theorem to add (endorsed — it is the right one):**
*momentum block-diagonalization of the FREE two-particle lift.* Statement shape:
the free two-particle walk commutes with total quasimomentum, hence
block-diagonalizes into per-total-momentum sectors; identify each **low-degree
factor of the interacting charpoly** with the free level(s) of a specific
momentum sector. This is the highest-credibility add because it *explains WHICH*
free levels the low-degree factors are, rather than exhibiting an opaque
factorization — turning a computed polynomial into a structural statement.

```lean
-- shape:
theorem free_lift_momentum_block (K : totalMomentumSector) :
    (Hfree_twoParticle).restrict (block K) = ⊕ per-K blocks
-- + an identification lemma:
theorem lowdegree_factor_is_free_level :
    (charpoly_interacting).factor_of_degree d = charpoly_of (free block K₀)
```

**Second-order credibility add (cheap, do if time):** verify the 28×28 charpoly
factorization by an *independent kernel computation* — assert the polynomial
identity `det(xI − M) = (…)·(3125w³ − 2300w² − 6156w − 1440)` over ℚ/ℤ and
discharge with `decide`/`native_decide` on the explicit integer matrix, so the
cubic is not oracle-only. **Gate:** the matrix must have exact rational entries.
**Kill condition:** if entries are irrational in ε (before the `w = 2cos2ε`
substitution), do the identity in the polynomial ring `ℚ[w]` after substitution
instead.

---

## Q4. Paper A freeze checklist — 5 highest-risk sentence types

*Note: Paper A source was not in this packet (only the four Paper-C modules).
Paper A is the inherited positional-law + full-walk-protection result, and it
shares infrastructure with the audited files. The five items below are the
highest-risk sentence patterns to re-audit, derived from concrete risks visible
in the shared machinery; map each to Paper A's actual sentences before freeze.*

1. **Universality overreach on `native_decide` fixtures.** Any sentence saying
   "for every field / for all coins / universally" that is actually backed by a
   *fixed-angle* `native_decide` enumeration (the `PinnedMirrorChart` /
   `PinnedSectorIndex` pattern). Re-audit that each "for every" is either
   genuinely angle-general (θ-family, kernel) or explicitly scoped "at the
   fixture coin." Attach the +2-axiom (`ofReduceBool`/`trustCompiler`) draft-trust
   disclosure wherever a `native_decide` result is quoted.

2. **One-directional "iff"/"exactly when" claims.** Any positional-law sentence
   phrased as "self-adjoint / certified **iff** anti-aligned" whose Lean support
   is only the `…_of` sufficiency direction plus a few witnesses. Until Q1-b2
   lands the symbolic iff, downgrade to "sufficient" or cite the fixture iff
   explicitly.

3. **Transport-faithfulness sentences.** Any claim that the ℝ/ℂ θ-family walk
   "is" the landed ℚ walk, or that a result "generalizes the fixture," before the
   Q2c `Wth_eq_landed` compatibility lemma exists. This is the load-bearing
   identification and is currently eyeball-only.

4. **"No index reproduces / strictly finer" universality.** The CGGSVWZ-style
   negative must be stated over *translation-invariant indices of the periodic
   extension* (what is proven), with the step to "every CGGSVWZ index" flagged as
   the standard translation-invariance fact — not as a Lean theorem about a
   constructed CGGSVWZ index (Q2b). Re-audit any Paper A sentence importing this
   phrasing.

5. **Splitting-law / asymptotic constants.** The R-breaking splitting law with
   leading constants `sin θ · λ(θ)^sep`, `λ = (1−sin)/cos`, is explicitly
   "oracle-grade, deliberately NOT dressed as a theorem." Any Paper A sentence
   that states these constants must carry the "numerically/oracle-established,
   not formally proven" qualifier; do not let a freeze silently promote them to
   theorem status.

**Freeze gate:** Paper A is submission-frozen only when each of the five sentence
types above is either (i) matched to a kernel/α-general Lean theorem, or (ii)
carries the correct scope/disclosure qualifier. **Kill condition for freeze:**
any surviving unqualified "for every θ / universally / iff / no CGGSVWZ index /
exact constant" sentence whose only support is a fixed-angle `native_decide`, a
one-directional `…_of`, an unproven transport, or an oracle constant.

---

## One-line gates & kill conditions (consolidated)

- **b1 (kernel atlas):** gate = reuse `two_wall_chart`+`…_selfadj_of`; kill = none (trivial). **Ship.**
- **b2 (symbolic iff):** gate = confirm antisymm entry `= ±(signB b0+signB b2)·sinθ`; kill = second independent trig monomial off-line ⇒ keep `…_of` + controls only.
- **Q2c pin:** gate = fixture uses rational cos/sin; kill = irrational fixture angle ⇒ prove weaker `map Rat.cast` component equalities.
- **general-L:** gate = `twowall_dispatch` `decide`-sweep `n=2..5`; kill = counterexample field or position-dependent chart ⇒ freeze at L=4.
- **E free-lift:** gate = rational matrix entries for kernel charpoly check; kill = irrational-in-ε ⇒ work in `ℚ[w]` post-substitution.
