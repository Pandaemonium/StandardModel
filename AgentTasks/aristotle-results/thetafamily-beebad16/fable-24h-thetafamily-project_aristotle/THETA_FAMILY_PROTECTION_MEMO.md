# θ-family involution protection — memo

**File:** `PhysicsSM/Draft/NullEdge/ThetaFamilyProtection.lean`
**Namespace:** `PhysicsSM.Draft.NullEdge.ThetaFamilyProtection`
**Axioms:** `propext`, `Classical.choice`, `Quot.sound` only (verified with
`#print axioms`). No `native_decide`, no `axiom`, no `@[implemented_by]`, no
`sorry`. The only `decide` used (`two_wall_chart`) is the *kernel* `decide`, so
it adds no axioms.

## Setup

The coin is parametrized by a real angle `θ`. For a sign pattern
`b : Fin 4 → Bool`:

* `signB b = if b then 1 else -1` (the `±1` sign);
* `shiftR : Matrix V8 V8 ℝ` — the conditional shift `S` (context `shiftQ`, over `ℝ`);
* `coinR θ b : Matrix V8 V8 ℝ` — the rotation coin with cosine field `cos θ` and
  sitewise **signed** sine field `x ↦ signB (b x) · sin θ` (context `coinQ`);
* `Wth θ b = shiftR · coinR θ b · shiftR` — **the θ-parametrized walk**
  `W(b,θ) = S·C·S`, exactly the context `walkQ (cos θ) (signed sin)` construction
  over `ℝ`;
* `Wexp θ b` — the explicit closed-form `8×8` matrix, with
  `Wth_eq_Wexp : Wth θ b = Wexp θ b` (the one required compatibility/closed-form
  bridge; the context `walkQ` is typed over `ℚ` so a literal `walkQ (cos θ) …`
  equation is ill-typed — the closed form pins the walk instead of forking it);
* `BfixR`, `Bfix0R` — isometries onto the reflection-fixed legs of chart `{1,3}`
  (sites `1,3`) and chart `{0,2}` (sites `0,2`) respectively (context `Bfix`,
  `Bfix0`);
* `M13 θ b = BfixRᵀ · Wth θ b · BfixR`, `M02 θ b = Bfix0Rᵀ · Wth θ b · Bfix0R`;
* `toCR` — the entrywise `ℝ → ℂ` transport (real analogue of the context `toC`);
  `Modes θ b` — the complete walk `toCR (Wth θ b)` over `ℂ` has a nonzero `+1`
  eigenvector and a nonzero `−1` eigenvector.

Every identity below reduces to `Real.sin_sq_add_cos_sq` and
`signB x * signB x = 1`; each control fails by an explicit `2·sin θ` entry. All
statements are quantified over **all** `θ : ℝ`.

## T1 — block involution family

* `block_involution_family (θ b) (h1 : signB (b 0)+signB (b 2)=0)
  (h2 : signB (b 1)+signB (b 3)=0) : Wth θ b = (Wth θ b)ᵀ ∧ Wth θ b * Wth θ b = 1`
* Four explicit block corollaries: `block_involution_ppmm`, `block_involution_mmpp`,
  `block_involution_pmmp`, `block_involution_mppm` (fields `++--`, `--++`, `+--+`,
  `-++-`).

## T2 — chart `{1,3}` involution family (protected singletons)

* `chart13_involution_family (θ b) (h : signB (b 0)+signB (b 2)=0) :
  M13 θ b = (M13 θ b)ᵀ ∧ M13 θ b * M13 θ b = 1 ∧ (M13 θ b).trace = 0 ∧
  Wth θ b * BfixR = BfixR * M13 θ b`
* Four explicit protected-singleton corollaries (lone flip on a `{0,2}`-fixed
  site 0 or 2): `chart13_singleton_m0` `[-,+,+,+]`, `chart13_singleton_p0`
  `[+,-,-,-]`, `chart13_singleton_m2` `[+,+,-,+]`, `chart13_singleton_p2`
  `[-,-,+,-]`.

## T3 — chart `{0,2}` involution family (blind singletons)

* `chart02_involution_family (θ b) (h : signB (b 1)+signB (b 3)=0) :
  M02 θ b = (M02 θ b)ᵀ ∧ M02 θ b * M02 θ b = 1 ∧ (M02 θ b).trace = 0 ∧
  Wth θ b * Bfix0R = Bfix0R * M02 θ b`
* Four explicit blind-singleton corollaries (lone flip on a `{1,3}`-fixed site
  1 or 3): `chart02_singleton_m1` `[+,-,+,+]`, `chart02_singleton_p1`
  `[-,+,-,-]`, `chart02_singleton_m3` `[+,+,+,-]`, `chart02_singleton_p3`
  `[-,-,-,+]`.

## T4 — headline: modes persist for the entire family `θ`

* `modes_persist (θ b) (hb : HalfPeriodInvariant.wallCount b = 2) : Modes θ b`

For every `θ : ℝ` and every two-wall field `b`, the complete walk `W(b,θ)` over
`ℂ` has a nonzero `+1` eigenvector and a nonzero `−1` eigenvector. The dispatch
lemma `two_wall_chart` (kernel `decide`) shows every two-wall field satisfies
`b 0 ≠ b 2 ∨ b 1 ≠ b 3`, i.e. is certified in chart `{1,3}` or chart `{0,2}`;
the landed `InvolutiveCompression` engine (`IC13`/`IC02`,
`involutive_compression_fixed_mode`/`_flip_mode`) then fires. The certified
modes persist for the whole coin/mass family — an exact identity family, no gap
or continuity hypothesis.

Supporting always-true structural lemmas (every `b`, every `θ`): `iso13`,
`iso02`, `intertwine13`, `intertwine02`, `Wth_orthogonal`, `M13_orthogonal`,
`M02_orthogonal`, `M13_trace`, `M02_trace`. Discriminating symbolic lemmas:
`M13_selfadj_of`, `M02_selfadj_of`, `Wth_symm_of` (the trig-identity content),
with `M13_involution_of`, `M02_involution_of`, `Wth_involution_of` derived from
self-adjointness + orthogonality.

## T5 — negative controls (exact `−2·sin θ` failure in the wrong chart)

* `control_blind_entry (θ) :
  (M13 θ ![true,true,true,false] − (M13 θ ![true,true,true,false])ᵀ) 0 1 = -2 * sin θ`
  (blind singleton `[+,+,+,-]` in the wrong chart `{1,3}`).
* `control_zero_entry (θ)` — zero-wall field `[+,+,+,+]`, same `−2·sin θ`.
* `control_four_entry (θ)` — four-wall field `[+,-,+,-]`, same `−2·sin θ`.
* Consequences (self-adjointness genuinely fails off the massless point):
  `control_blind_not_selfadj`, `control_zero_not_selfadj`, `control_four_not_selfadj`:
  `sin θ ≠ 0 → M13 θ b ≠ (M13 θ b)ᵀ`.

## T6 — massless boundary

* `control_blind_massless (θ) (h : sin θ = 0) :
  (M13 θ ![true,true,true,false] − (M13 θ ![true,true,true,false])ᵀ) 0 1 = 0`

At `sin θ = 0` the coin degenerates (`cos θ = ±1`, `W` a signed shift) and the
control entry `−2·sin θ` vanishes, so the chart-failure claims of T5 are exactly
scoped to the massive family `sin θ ≠ 0`.

## Kill condition

Every T1–T3 identity reduced to the Pythagorean identity
`Real.sin_sq_add_cos_sq` (together with `signB x * signB x = 1`). No residual
`θ`-term survived on any protected/block field; the only surviving `θ`-terms are
the intended `−2·sin θ` entries of the negative controls T5. The family claim
therefore holds symbolically, upgrading the fixture-only (`native_decide`)
landing to the entire coin/mass family.

## Build note

The delivered project did not build: the two context files import
`PhysicsSM.Draft.NullEdge.*` module paths that did not exist (the files live
under `context/`). This was fixed **without editing the context modules'
content**, by adding three one-line shim modules under
`PhysicsSM/Draft/NullEdge/` (each `import context.<Module>`) plus a matching
`lean_lib` entry in `lakefile.toml`.
