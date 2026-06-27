# Taste-involution origin-polarization audit (Wave 19 / C83)

Date: 2026-06-27.

Task: `AgentTasks/null-edge-wave19-c83-taste-involution-origin-polarization-aristotle-2026-06-27.md`.
Kind: no-build strategy/audit (report-only).

Target question (verbatim):

```text
Find or refute a finite local Hermitian taste/branch involution T such that
G_f = Gamma_s T makes the intended origin tangent branch G_f-pure.
```

Context consumed:

- `AgentTasks/context-packs/gate-c-regulator-legality-20260627-074056.md`
- `AgentTasks/null-edge-wave19-regulator-legality-analysis-2026-06-27.md`
- `AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md`
- `AgentTasks/null-edge-overlap-locality-gap-audit.md`

Repo anchors re-checked against the live tree (every name below was read, not assumed):

- `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean` — C21 symbol facts:
  `null_kernel_chirality_plus`, `null_kernel_chirality_minus`,
  `null_kernel_both_chiralities`, `branchKernel_chirality_sign`,
  `BareOperatorAssignsSingleSign`, `no_full_symbol_single_chirality`,
  `OperatorForcesAlignmentAfterProjection`.
- `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean` — the actual `Γ_f = Γ_s · T`
  model: `GammaS`, `tasteT`, `GammaF`, `GammaF_eq_GammaS_mul_tasteT`,
  `naive_index_zero`, `flavored_index_eq_four`, `Pnull`.
- `PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean` — C77 abstract API:
  `BranchProjectorSystem`, `TasteSignSystem`, `tasteTau`, `tasteTau_sq`,
  `ModifiedChiralityData`, `gammaF_sq`, `FlavoredIndexReady`.
- `PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean` — point-split
  `P_a` content `(1 ± cos q_a)/2`, `cosFilter_*`, dressed projectors.
- `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean` — the Krein-orientation no-go
  (`krein_assignment_no_go`), used here as a structural precedent.

This is an audit, not a proof. No Gate C release is claimed. No claim of overlap
locality is made. The guardrails of the task are honored: T is not assumed to
exist, high-branch signs are not claimed to solve origin chirality, and the
report is adversarial about whether a taste involution can polarize the origin
without smuggling in a Weyl projector.

---

## 0. Verdict

```text
LIKELY-NEEDS-AUXILIARY-LAYER
```

A finite **local Hermitian taste/branch involution** — i.e. an involution that
is a function of the taste/branch index only (diagonal on the species factor,
scalar on the Dirac/spinor factor) — **cannot** make the C21 origin tangent
branch `G_f`-pure. The two origin kernel modes are distinguished by the **Dirac**
(spinor) factor `γ₅`, not by the taste factor, and they sit in the **same**
taste/branch corner (the all-zero corner). Any taste-only `T` therefore acts as a
single scalar `±1` on the entire origin kernel, so `G_f = Γ_s T` reduces to
`±Γ_s` there and stays exactly the C21-balanced `{+1, −1}` pair. To split the two
origin chiralities, `T` must act nontrivially **within one corner's spinor line**
— which is precisely a chirality/Weyl projector datum, i.e. the very object the
guardrail forbids smuggling in.

The taste involution is the correct and necessary object for the **doubler**
corners (it converts the mirror-cancelled naive index into a nonzero flavored
index, `naive_index_zero` vs `flavored_index_eq_four`), but the doubler mechanism
is structurally inapplicable at the origin. Polarizing the origin therefore
forces a **projected Weyl / domain-wall / overlap layer**: a mass (or spectral
flow / sign) that *gaps the origin mirror*, not a mere regrading by a Hermitian
involution.

The verdict is `LIKELY-NEEDS-AUXILIARY-LAYER` rather than a flat `REFUTED`
because the obstruction is proved at the level of *taste-only / branch-index*
involutions (the natural reading of "taste/branch involution"); a `T` that is
allowed to act on spinor lines can trivially polarize, but only by *being* the
Weyl projector, which collapses the question into the auxiliary layer it was
meant to avoid. Either way, no finite local taste involution does the job on its
own.

---

## 1. What must `T` do on the two-dimensional C21 origin/null kernel?

C21 (`null_kernel_both_chiralities`, specialized at the origin / any null
covector) gives the hard constraint:

> For every null covector `p` (including the origin tangent direction) the
> Clifford-symbol kernel contains a nonzero `γ₅ = +1` mode `v₊` and a nonzero
> `γ₅ = −1` mode `v₋`, **linearly independent**. The kernel is two-dimensional
> and chirality-balanced; `tr(γ₅ · P_kernel) = 0`.

"`G_f`-pure" means: after whatever projection retains the physical sector, the
retained origin sector is a **one-dimensional** space that is a single-eigenvalue
eigenspace of `G_f = Γ_s T` (a single Weyl component). So `T` is being asked to:

- (a) assign **opposite** `G_f` eigenvalues to `v₊` and `v₋` (so a projector can
  keep one and drop the other), **and**
- (b) do so in a way that, combined with the retained-sector projector, leaves a
  *single* chirality — i.e. genuinely removes the origin mirror rather than
  merely relabeling it.

Requirement (a) already pins down what `T` must achieve: since `Γ_s v₊ = +v₊` and
`Γ_s v₋ = −v₋`, for `G_f = Γ_s T` to give `v₊` and `v₋` **the same** sign (so they
are *not* split — the failure mode) `T` must act oppositely on them; for it to
*split* them the way `Γ_s` already does, `T` must act *equally* on them. In both
cases the decisive question is **how `T` acts on the pair `{v₊, v₋}` that lives in
one corner**. That is the whole game, and §2 shows a taste-only `T` has no freedom
there.

Note also requirement (b) is strictly stronger than (a): even a `T` that splits
the eigenvalues does not by itself *remove* a mode — an involution is a grading,
not a projector, and a grading retains both eigenspaces. Removing the origin
mirror is a gapping (mass / spectral-flow) operation, not a grading operation.
This is the structural reason the question cannot terminate inside the
"involution" layer (see §4).

---

## 2. Can `T` be a momentum/taste function only, or must it act on spinor/kernel lines?

**It must act on spinor/kernel lines. A momentum/taste-only `T` provably cannot
polarize the origin.**

The decisive structural fact is the *factorization of the gradings* recorded in
`NullEdgeFlavoredChirality.lean`:

```text
Γ_s   = γ₅ ⊗ I_taste      (acts on the Dirac factor only)
T     = I_Dirac ⊗ τ       (acts on the taste/species factor only)
Γ_f   = Γ_s · T = γ₅ ⊗ τ
```

`T` (taste/branch involution) is **diagonal on the taste factor and scalar on the
Dirac factor**. Now examine the two structurally different momentum regions:

- **At the doubler corners (where the taste mechanism works).** The four
  high-momentum null modes sit at four **different** taste corners `a = 0,1,2,3`,
  and they pair into two `γ₅ = +1` and two `γ₅ = −1` modes. Here `τ` has genuine
  freedom: it can assign opposite taste signs to the mirror pair, which is exactly
  why `tr(Γ_s P_null) = 0` (`naive_index_zero`) but `tr(Γ_f P_null) = 4`
  (`flavored_index_eq_four`). The taste factor *distinguishes* the modes because
  they live in *distinct* taste corners.

- **At the origin (where it must work for Gate C, and where it fails).** The two
  balanced origin kernel modes `v₊`, `v₋` are at the **same** point in momentum
  space (the all-zero corner) and hence in the **same** taste corner. They are
  distinguished *only* by the Dirac factor `γ₅`. A taste-only `T = I_Dirac ⊗ τ`
  evaluated at a single taste corner is a single scalar `τ(a₀) = ±1` times the
  identity on the Dirac line. Therefore on the origin kernel:

  ```text
  G_f|_origin = Γ_s · (τ(a₀)·I) = ±Γ_s,
  ```

  whose eigenvalues on `{v₊, v₋}` are `{±1, ∓1}` — **the same balanced ± pair as
  Γ_s, up to a global sign**. No taste-only involution can change this, because
  it has literally one bit of freedom (`τ(a₀)`) and that bit is a global sign, not
  a relative one.

This is the exact analogue, *at the origin*, of the doubler statement
`no_full_symbol_single_chirality` (C21): the bare operator data does not force a
single chirality, and a taste-only regrading does not add the missing relative
degree of freedom. To get a *relative* action on `v₊` vs `v₋` you must act on the
Dirac/spinor line — i.e. `T` must contain `γ₅`-type structure (a chirality/Weyl
projector or a γ-matrix). That is no longer a "taste/branch involution"; it is the
smuggled Weyl layer.

**Conclusion of §2:** `T` taste-only ⟹ origin stays balanced (no-go); `T`
polarizing ⟹ `T` acts on spinor lines and *is* a Weyl-type object. The two
options are mutually exclusive, and only the second can polarize.

---

## 3. Can point-split branch projectors `P_a` define such a `T` near the origin, given that `P_a(0)=0` for high branches?

**No.** This is the cleanest refutation and it is independent of the spinor/taste
argument of §2.

The point-split projectors are, in free-field form,
`P_a(q) ∝ (1 − cos q_a) · Π_a` (file
`NullEdgeGaugeCovariantBranchProjectors.lean`, content `(1 ± cos q_a)/2`, position
space `¼(2 − T_a − T_a^♯)`). Their defining feature — the whole reason they give a
*flavored* rather than a *scalar* mass — is that they **vanish at the origin**:

```text
P_a(0) ∝ (1 − cos 0) = 0      for each high-branch direction a.
```

Any `T` assembled from the high-branch `P_a` (e.g. `τ = Σ_a s_a Π_a` as in the
C77 `tasteTau`) therefore **degenerates at `q = 0`**: it carries *zero
chirality-selecting information at the origin*. Concretely:

- `τ(q) = Σ_a s_a P_a(q) → 0` as `q → 0` (each term is `O(q²)`), so `Γ_f = Γ_s τ`
  collapses to `0` (or, with the `Π_B` normalization, to a *constant* scalar on
  the origin block) — in neither case does it split `{v₊, v₋}`.
- This is precisely Pro's "irrelevant regulator" theorem in operator form: a
  mass/grading built from point-split projectors is `O(q²)` at the origin, so it
  leaves the origin **linearization** (the tangent Dirac cone) untouched. The
  origin tangent branch sees `D₊(q) + O(q²)`, whose chiral content is identical to
  `D₊`'s, which C21 says is balanced.

One could imagine adding an **origin** projector `P_0 ∝ ∏_a (1 + cos q_a)/2` that
is `1` at the origin. But `P_0` is still **scalar on the Dirac factor** — it
selects the origin *momentum* cell, not a chirality. It contributes another
taste-only bit and runs straight back into the §2 no-go. The point-split family
resolves the **four BZ-corner doublers**; by construction it says nothing
chirality-selecting at the origin. So `P_a` cannot define a polarizing `T` near
the origin.

---

## 4. Does a finite local `T` exist plausibly, or does this force a projected Weyl/domain-wall/overlap layer?

**It forces an auxiliary layer.** Two independent reasons, both adversarial.

1. **Grading vs. gapping (the structural reason).** An involution `T` (hence
   `G_f = Γ_s T`) is a `±1` grading. A grading *partitions* a space into two
   eigenspaces; it never *removes* one. C21 says the origin kernel is genuinely
   two-dimensional with both chiralities present. Making the origin "`G_f`-pure"
   in the physical sense — a single surviving Weyl mode — requires *deleting* the
   mirror mode, which is a **mass / spectral-flow / boundary** operation (it must
   lift the mirror off the kernel), not a regrading. No Hermitian involution gaps
   anything; only an (anti)commuting mass term, a domain-wall boundary, or an
   overlap sign operator does. This is exactly the C77 architecture: the index
   becomes nonzero only through `H(t) = γ₅ D(t)` **spectral flow** of a *flavored
   mass*, not through the involution alone.

2. **The relative-sign degree of freedom is unavailable to a taste involution
   (the counting reason, §2).** A taste-only Hermitian involution on the origin
   block has exactly one sign bit, which is global; polarization needs a *relative*
   bit between `v₊` and `v₋`, which only a spinor-line operator supplies. A finite
   local `T` carrying that relative bit is, by construction, a chirality/Weyl
   projector dressed as an involution — i.e. the auxiliary layer under a
   pseudonym.

This matches and reinforces the standing program facts:

- The Wave-19 analysis already records Pro's verdict that *internal grading alone
  cannot polarize external kinetic balance* when the kinetic operator factors as
  `D₊(q) ⊗ 1_E`; the present audit shows the **taste** grading is in the same
  boat at the origin (it is an internal-factor grading from the Dirac line's point
  of view).
- The Krein-lock no-go (`krein_assignment_no_go`,
  `NullEdgeKreinLockOrigin.lean`) is the precedent: a sign/orientation datum that
  *looks* like it should be derivable from existing structure is in fact a free
  external choice. The origin polarization is the chiral analogue — the missing
  datum is a Weyl/domain-wall/overlap **mass sign**, not a taste involution.

Hence: a finite local Hermitian taste/branch involution polarizing the origin
**does not plausibly exist**; the origin tangent branch requires a projected
Weyl / domain-wall / overlap layer (a mirror-gapping mass with the C77
Hermitian-spectral-flow / sign structure), exactly the layer the guardrails
warned against absorbing silently into `T`.

---

## 5. Smallest Lean theorem (or counterexample) to submit next

Submit a **finite no-go** that upgrades C21's `no_full_symbol_single_chirality`
from "the bare operator does not force a single sign" to "no **taste/branch
involution grading** forces a single sign on the origin kernel". This is finite,
`decide`-able on the existing `NullEdgeFlavoredChirality` model, and it is the
honest negative result that motivates the auxiliary layer.

Two concrete shapes, easiest first.

### 5a. Counterexample lemma on the existing toy model (recommended first)

In `NullEdgeFlavoredChirality.lean` the origin block is a single taste corner; a
taste-only involution there is `T = c · I` with `c ∈ {±1}`. State that `G_f = Γ_s T`
cannot be a single-eigenvalue grading of a two-chirality kernel:

```text
theorem origin_taste_involution_no_polarize
    (c : ℝ) (hc : c = 1 ∨ c = -1)
    (v₊ v₋ : Spin → ℂ)
    (hp : gamma5 *ᵥ v₊ = v₊) (hm : gamma5 *ᵥ v₋ = -v₋)
    (h₊ : v₊ ≠ 0) (h₋ : v₋ ≠ 0) :
    -- with T = c • I (a taste/branch-only involution on a single corner),
    -- G_f = Γ_s · T = c • Γ_s has eigenvalues +c on v₊ and -c on v₋:
    (gamma5 *ᵥ ((c:ℂ) • v₊) = (c:ℂ)   • v₊) ∧
    (gamma5 *ᵥ ((c:ℂ) • v₋) = (-c:ℂ)  • v₋) ∧
    -- hence it is NOT a single-eigenvalue grading: no ε with both modes ε-eigen.
    ¬ ∃ ε : ℂ, (G_f *ᵥ v₊ = ε • v₊ ∧ G_f *ᵥ v₋ = ε • v₋)
```

where `G_f := (c:ℂ) • gamma5` (the on-corner form of `Γ_s T`). The `¬∃ ε` clause
is the polarization-failure statement; it falls to `linear_independence of
{v₊,v₋}` + `c ≠ -c`. This is a faithful, non-vacuous negative theorem: it shows
the *grading* `G_f` keeps both chiralities, mirroring `naive_index_zero`.

### 5b. Abstract no-go in the C77 API (the reusable form)

In `NullEdgeFlavoredSpectralFlowAPI.lean`, add a predicate
`OriginPolarized (τ) : Prop` saying the origin block of `Γ_f = Γ_s τ` is a
one-dimensional single-eigenvalue space, and prove:

```text
theorem taste_only_not_originPolarized
    (S : BranchProjectorSystem A ι) (sgn : TasteSignSystem ι)
    -- τ acts as a scalar on the origin block (no branch projector supports the
    -- origin: each P_a annihilates the origin block, S.proj a ∘ Π₀ = 0):
    (hτ_origin : ∀ a, S.proj a * Π₀ = 0) :
    ¬ OriginPolarized (tasteTau S sgn)
```

with hypothesis `hτ_origin` being the formal transcription of `P_a(0)=0` (§3).
This is the clause that should sit *next to* `FlavoredIndexReady` and make
explicit, in the release API, that flavored-index-ready ⇏ origin-polarized — the
two are independent obligations, and only an added Weyl/domain-wall/overlap
datum can supply the second.

### Why a no-go, not a search for `T`

Per the guardrails, `T` is not assumed to exist; §§2–4 give an adversarial
structural argument that it does not (as a taste/branch involution). The most
valuable next Lean artifact is therefore the **kernel-checked negative theorem**
that closes the door on the taste-only route and names the missing auxiliary
layer, exactly as the Krein-lock module did for the orientation sign. A positive
`T` search would only "succeed" by importing a Weyl projector, which the no-go
makes visible as smuggling.

---

## Appendix: one-line status register

| Item | Status |
| --- | --- |
| C21 origin/null kernel 2-dim, `γ₅`-balanced (`null_kernel_both_chiralities`) | fixed fact |
| Taste-only `T` separates doubler corners (`flavored_index_eq_four`) | fixed fact |
| Taste-only `T` scalar on single origin corner ⟹ cannot split `{v₊,v₋}` | argued no-go (§2), Lean target 5a |
| Point-split `P_a(0)=0` ⟹ `T` from `P_a` is `O(q²)` at origin | fixed fact (§3), Lean target 5b |
| Grading vs gapping: involution cannot delete mirror mode | structural (§4) |
| Finite local taste involution polarizing origin | **does not plausibly exist** |
| Required object | projected Weyl / domain-wall / overlap mirror-gapping layer |
| Verdict | `LIKELY-NEEDS-AUXILIARY-LAYER` |
| No Gate C release claimed | honored |
