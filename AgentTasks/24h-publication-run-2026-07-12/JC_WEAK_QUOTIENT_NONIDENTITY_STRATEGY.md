# Design: smallest honest nonidentity descent to the weak quotient

**Scope / build status.** This is a strategy/design deliverable. The four
source files in this snapshot
(`SpinorTenfoldCliffordGroup.lean`, `SpinorTenfoldColorAxis.lean`,
`SpinorTenfoldSO10Action.lean`, `SpinorTenfoldWeakQuotientDescent.lean`)
`import PhysicsSM.Spinor.SpinorTenfold{CAR,Purity,GammaSymm,WeakQuotient}`,
but **those trusted dependency modules are not present in this snapshot**
(no source, no compiled `*.olean`). Consequently none of the four files, and
nothing built on top of them, can be elaborated in this checkout. Every Lean
fragment below is written against the *verbatim* API of the four files and is
intended to typecheck **inside the full `PhysicsSM` tree**; it is not claimed to
compile against those absent modules in this snapshot.

**Realized, buildable formalization.** Rather than depend on the absent modules,
the design has been fully carried out self-contained over Mathlib alone in
`SpinorTenfoldWeakQuotientNonidentity.lean` (namespace `SpinorTenfoldCoord`): the
coordinate model `V10`, form `B10`, `so(10)` action `soAd`, first annihilator
`N1`, color axis, and weak quotient `N1 / color ≅ ℂ²` are reconstructed, and the
main theorem plus both controls are proved `sorry`-free (axioms:
`propext, Classical.choice, Quot.sound`). That file **builds**; the four original
files do not (they import the absent `PhysicsSM` core). Verified declarations:
`weakE34_ne_id`, `weakQuotient_soAd_e3f4_descends_nontrivially`,
`E34_preserves_color`, `E34_mapsTo_N1`, `soAd_e3e4_not_preserves_N1`,
`soAd_e0f3_not_preserves_color`.

No `Spin(10)`, `SU(2)_L`, or intrinsic stabilizer object is introduced: none is
present in the four files, and the task forbids inventing them. The only
symmetry generator used is the **already-formalized `so(10)` vector-representation
action** `soAd` from `SpinorTenfoldSO10Action`. Nontriviality is certified by an
explicit moved vector, **never** by a dimension count. Lemmas discharged through
the coordinate characterizations are explicitly labelled *coordinate-only*.

---

## 1. Verbatim API actually available (the only things we may use)

### 1.1 From `SpinorTenfoldSO10Action.lean`
```
def soAd (v w u : V10) : V10 := B10 w u • v - B10 v u • w        -- so(10) vector action
@[simp] theorem soAd_zero (v w : V10) : soAd v w 0 = 0
theorem B10_sub_left  (u v w : V10) : B10 (u - v) w = B10 u w - B10 v w
theorem B10_sub_right (u v w : V10) : B10 u (v - w) = B10 u v - B10 u w
theorem B10_soAd_skew (v w u u' : V10) : B10 (soAd v w u) u' + B10 u (soAd v w u') = 0
theorem rho_intertwine (v w u : V10) (ψ) :
    rho v w (cliffordAction u ψ) - cliffordAction u (rho v w ψ) = cliffordAction (soAd v w u) ψ
theorem rho_bracket (v w v' w' : V10) (ψ) :        -- so(10) Lie bracket (spinor side)
    rho v w (rho v' w' ψ) - rho v' w' (rho v w ψ) = …
theorem chevalleyPairing_rho_skew (v w : V10) (ψ φ) :
    chevalleyPairing (rho v w ψ) φ + chevalleyPairing ψ (rho v w φ) = 0
```
Also used (from the trusted CAR/GammaSymm layer, referenced in this file):
`B10`, `B10_comm`, `B10_smul_left`, `B10_smul_right`, `B10_zero_right`.
Note: `B10_add_left`/`B10_add_right` are **not** referenced in the four files —
see §5.

### 1.2 From `SpinorTenfoldColorAxis.lean`
```
theorem Q10_eq_zero_of_mem_annihilator {ψ} (hψ : ψ ≠ 0) {v} (hv : v ∈ annihilator ψ) : Q10 v = 0
def IsColorAxisVector (v : V10) : Prop := v.1 = 0 ∧ v.2 ⟨3,_⟩ = 0 ∧ v.2 ⟨4,_⟩ = 0
theorem mem_annihilator_weakSpinor_iff (v : V10) : v ∈ annihilator weakSpinor ↔ IsWeakSpinorAnnihilatorVector v
theorem mem_colorAxis_iff (v : V10) : v ∈ annihilator vacuumSpinor ⊓ annihilator weakSpinor ↔ IsColorAxisVector v
abbrev colorAxisSubmodule : Submodule Complex V10 := annihilator vacuumSpinor ⊓ annihilator weakSpinor
theorem finrank_colorAxis : Module.finrank Complex colorAxisSubmodule = 3
theorem finrank_annihilator_vacuumSpinor : Module.finrank Complex (annihilator vacuumSpinor) = 5
```
Plus the vacuum characterization used throughout ColorAxis (defined in the
trusted `Purity`/`CAR` layer):
```
theorem mem_annihilator_vacuumSpinor_iff (v : V10) : v ∈ annihilator vacuumSpinor ↔ v.1 = 0
```

### 1.3 From `SpinorTenfoldWeakQuotientDescent.lean` (imports `…WeakQuotient`)
Opaque objects from the unseen `SpinorTenfoldWeakQuotient` module:
`VacuumAnnihilator` (the `ℂ⁵` first annihilator, i.e. `↥(annihilator vacuumSpinor)`),
`colorAxisInVacuum : Submodule Complex VacuumAnnihilator` (the color `ℂ³` inside it),
`weakQuotient := VacuumAnnihilator ⧸ colorAxisInVacuum`,
`weakQuotientLinearEquivC2 : weakQuotient ≃ₗ[Complex] (Fin 2 → Complex)`.

The descent API (fully proved in this file):
```
def weakQuotientDescend (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum) : weakQuotient →ₗ[Complex] weakQuotient
theorem weakQuotientDescend_id
theorem weakQuotientDescend_comp
theorem weakQuotientDescend_eq_id_iff  (…): weakQuotientDescend f hcolor = id ↔ ∀ x, f x - x ∈ colorAxisInVacuum
theorem weakQuotientDescend_ne_id_of_exists (…) (hmove : ∃ x, f x - x ∉ colorAxisInVacuum) : weakQuotientDescend f hcolor ≠ id
def weakCoordinateAction (…): (Fin 2 → Complex) →ₗ[Complex] (Fin 2 → Complex)
theorem weakCoordinateAction_intertwines
```

### 1.4 Coordinate conventions (from the CliffordGroup docstring, verbatim)
`V10 = W ⊕ W*` with `v = (v.1, v.2) : (Fin 5 → ℂ) × (Fin 5 → ℂ)`,
`Q10 v = Σᵢ v.1 i * v.2 i`, `B10 v w = Σᵢ (v.1 i * w.2 i + v.2 i * w.1 i)`.
Write `e_i := ((fun j => if j = i then 1 else 0), 0)` (creation) and
`f_i := (0, (fun j => if j = i then 1 else 0))` (annihilation). Then
- `annihilator vacuumSpinor = {v | v.1 = 0} = ⟨f₀,…,f₄⟩` (`= VacuumAnnihilator`, dim 5),
- `colorAxisSubmodule = {v | v.1 = 0 ∧ v.2 3 = 0 ∧ v.2 4 = 0} = ⟨f₀,f₁,f₂⟩` (dim 3),
- `weakQuotient ≅ ⟨f₃,f₄⟩ ≅ ℂ²`.

---

## 2. The chosen symmetry family (honest, nonidentity)

The only symmetry with a formalized **vector-representation** action on `V10`
is `soAd`. We use the parabolic (annihilator-preserving) `e ∧ f` generators.
For `v w : V10` and `u ∈ VacuumAnnihilator` (so `u.1 = 0`):

```
soAd v w u = B10 w u • v − B10 v u • w,   with (for u.1 = 0)   B10 x u = Σᵢ x.1 i * u.2 i.
```

**Preservation criterion (proved coordinate-only).** For `w` with `w.1 = 0`
(i.e. `w ∈ annihilator vacuumSpinor`):
`B10 w u = Σᵢ w.1 i u.2 i = 0`, so `soAd v w u = − B10 v u • w`. Hence
`(soAd v w u).1 = − B10 v u • w.1 = 0`, i.e. **`soAd v w` maps
`annihilator vacuumSpinor` into itself for every `v`, whenever `w.1 = 0`.**
This is exactly the parabolic/Levi statement "the isotropic 5-plane `N₁` is
stabilized", but proved by coordinates, not by an intrinsic stabilizer object.

### 2.1 Nonidentity preservation **witness**: `E₃₄ := soAd e₃ f₄`
Take `v = e₃`, `w = f₄` (note `w.1 = 0`, so `N₁` is preserved). For `u.1 = 0`:
`B10 f₄ u = 0` and `B10 e₃ u = u.2 3`, so
```
soAd e₃ f₄ u = − (u.2 3) • f₄ = (0, − u.2 3 • δ₄).       (†)
```
Action on the annihilation basis: `f₃ ↦ −f₄`, and `f₀,f₁,f₂,f₄ ↦ 0`.

- **Preserves `N₁`** (`VacuumAnnihilator`): image `.1 = 0`.
  *Coordinate-only*, via `mem_annihilator_vacuumSpinor_iff`.
- **Preserves the color axis**: if `u ∈ colorAxisSubmodule` then `u.2 3 = 0`,
  so by (†) the image is `0 ∈ colorAxisSubmodule`.
  *Coordinate-only*, via `mem_colorAxis_iff`.
- **Nonidentity on the quotient**: `E₃₄(f₃) − f₃ = −f₄ − f₃`, whose underlying
  vector has `.2 3 = −1 ≠ 0`, hence `∉ colorAxisSubmodule`. Fed to
  `weakQuotientDescend_ne_id_of_exists`, this is an **explicit moved vector**;
  no dimension count is used.

`E₃₄` is the raising generator of the `sl(2)` acting on `⟨f₃,f₄⟩`.

---

## 3. Composition with `weakQuotientDescend` (the target theorem)

Smallest honest statement (names as they appear in the scaffold), assuming the
`soAdLinear` + restriction API of §5:

```
/-- The so(10) generator `soAd e₃ f₄`, restricted to the first annihilator,
    preserves the color axis and descends to a NONIDENTITY operator on the
    weak quotient. (Coordinate-only preservation; explicit-witness
    nontriviality.) -/
theorem weakQuotient_soAd_e3f4_descends_nontrivially :
    ∃ (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
      (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum),
      weakQuotientDescend f hcolor ≠ LinearMap.id
```
Proof shape: instantiate `f := (soAdLinear e₃ f₄).restrict hN₁` (needs §5),
supply `hcolor` from the color coordinate check, and close nontriviality with
`weakQuotientDescend_ne_id_of_exists` on `x = ⟦f₃⟧`.

The two-coordinate realization is then `weakCoordinateAction f hcolor :
(Fin 2 → Complex) →ₗ (Fin 2 → Complex)`, intertwined by
`weakCoordinateAction_intertwines`; in the `⟨f₃,f₄⟩` basis it is the nilpotent
`![![0,0],![−1,0]]` (a **coordinate-only** matrix reading).

---

## 4. Mixing / non-preservation **control**

To show the two hypotheses of `weakQuotientDescend` are genuine (not vacuous),
give generators that fail them; both are *coordinate-only*.

- **Breaks first-annihilator preservation** — `soAd e₃ e₄` (a creation∧creation
  generator, `w = e₄` with `w.1 ≠ 0`). For `u.1 = 0`:
  `soAd e₃ e₄ u = u.2 4 • e₃ − u.2 3 • e₄`. On `u = f₄`: image `= e₃`, whose
  `.1 ≠ 0`, so `e₃ ∉ annihilator vacuumSpinor`. Hence `soAd e₃ e₄` does **not**
  restrict to `VacuumAnnihilator →ₗ VacuumAnnihilator` at all — the input to
  `weakQuotientDescend` cannot even be formed.
- **Preserves `N₁` but breaks the color axis** — `soAd e₀ f₃` (`w = f₃`, so
  `N₁` is preserved). For `u.1 = 0`: `soAd e₀ f₃ u = − u.2 0 • f₃`, i.e.
  `f₀ ↦ −f₃`. Since `f₀ ∈ colorAxisSubmodule` but `−f₃ ∉ colorAxisSubmodule`,
  the hypothesis `hcolor` **fails**. This is the crucial control: color
  preservation is a real side condition, exactly matching the design intent of
  `weakQuotientDescend` (it makes the color invariance explicit rather than
  inferring an action from the quotient dimension).

Scaffold witnesses (coordinate-only):
```
theorem soAd_e3e4_not_preserves_N1 : soAd e₃ e₄ f₄ ∉ annihilator vacuumSpinor
theorem soAd_e0f3_not_preserves_color :
    f₀ ∈ colorAxisSubmodule ∧ soAd e₀ f₃ f₀ ∉ colorAxisSubmodule
```

---

## 5. Smallest missing API (the blockers)

The four files expose `soAd` only as a bare curried function `V10 → V10 → V10 →
V10`; there is no `LinearMap` packaging and no submodule restriction. To feed
`weakQuotientDescend` you need, in increasing order of "unseen-ness":

1. **`soAdLinear (v w : V10) : V10 →ₗ[Complex] V10`** with `toFun := soAd v w`.
   `map_smul'` uses `B10_smul_right` (available). `map_add'` needs
   **`B10_add_right : B10 u (v + w) = B10 u v + B10 u w`**, which is *not*
   referenced anywhere in the four files (only `B10_sub_right` is). Either it
   exists in the trusted `GammaSymm`/`CAR` layer, or it is a one-line addition
   (it is the additive analogue of the proved `B10_sub_right`). This is the
   single most likely "missing lemma".

2. **Restriction to the annihilator.**
   `soAd_mapsTo_vacuumAnnihilator : w.1 = 0 → ∀ u ∈ annihilator vacuumSpinor,
   soAd v w u ∈ annihilator vacuumSpinor` (coordinate-only, §2), then
   `f := (soAdLinear v w).restrict (…) : VacuumAnnihilator →ₗ VacuumAnnihilator`
   via `LinearMap.restrict`. This requires `VacuumAnnihilator` to be defeq to
   `↥(annihilator vacuumSpinor)` — true by the `finrank_annihilator_vacuumSpinor`
   phrasing, but it is an assumption about the unseen `WeakQuotient` module.

3. **Bridge to `colorAxisInVacuum` (most likely hard blocker).**
   `colorAxisInVacuum` lives inside `VacuumAnnihilator`, and its membership
   predicate is defined in the unseen `SpinorTenfoldWeakQuotient` module. To
   discharge `hcolor` you need a characterization
   **`mem_colorAxisInVacuum_iff : x ∈ colorAxisInVacuum ↔ (↑x : V10) ∈
   colorAxisSubmodule`** (equivalently `↔ IsColorAxisVector ↑x`). If this bridge
   is already in `WeakQuotient`, `hcolor` reduces to `mem_colorAxis_iff` and is
   coordinate-only. If it is absent, it is the smallest missing API that blocks
   the whole composition, and should be added there.

Summary of the minimal additions: `B10_add_right` (probably), `soAdLinear`,
`soAd_mapsTo_vacuumAnnihilator`, and `mem_colorAxisInVacuum_iff`.

---

## 6. Later condition to identify the quotient action with the fundamental SU(2)

The descent above yields, at most, a family of `ℂ`-linear operators on
`weakQuotient ≅ ℂ²`. Identifying it with the **fundamental (doublet) rep of
`SU(2)_L`** is *not* achieved by any theorem in the four files and must not be
asserted. The following are the concrete, still-missing conditions.

Coordinate generators (all with `w` in the annihilator, so `N₁`- and, except as
noted, color-preserving; each is a §2 restriction):
- `E := soAd e₃ f₄`   (`f₃ ↦ −f₄`)   raising;
- `F := soAd e₄ f₃`   (`f₄ ↦ −f₃`)   lowering;
- `H := soAd e₃ f₃ − soAd e₄ f₄`   (`f₃ ↦ −f₃`, `f₄ ↦ +f₄`)   Cartan.

Conditions required, in order:

1. **Bracket closure to `sl(2,ℂ)` (coordinate-only until intrinsic).** Show the
   descended `Ê, F̂, Ĥ` satisfy `[Ĥ,Ê]=2Ê`, `[Ĥ,F̂]=−2F̂`, `[Ê,F̂]=Ĥ` on
   `weakQuotient`. Engine: `rho_bracket` / `B10_soAd_skew` give the `so(10)`
   bracket on `soAd`; push it through the functor `weakQuotientDescend` using
   `weakQuotientDescend_comp` (composition) and linearity to obtain commutators
   of descended maps, then match structure constants. Purely coordinate content
   in the `⟨f₃,f₄⟩` basis.

2. **Weight normalization (coordinate-only).** `Ĥ = diag(−1, +1)` on
   `⟨f₃,f₄⟩`, i.e. the two weights are `±1` (doublet weights `±½`), certifying
   the *standard* 2-dimensional rep rather than an arbitrary `gl(2,ℂ)` action.

3. **Compact real form `su(2)` (missing structure).** The descended algebra is
   a priori a complex `sl(2,ℂ) ⊂ gl(2,ℂ)`; `SU(2)_L` is the compact real form.
   This needs a positive-definite Hermitian form on `weakQuotient` w.r.t. which
   the physical generators are skew-Hermitian. The only invariance currently
   formalized is `chevalleyPairing_rho_skew` (infinitesimal invariance of the
   Chevalley pairing) and the promised main anti-involution mentioned in the
   `CliffordGroup` docstring; a Hermitian (not bilinear) inner product and the
   spinor-norm-1 cut to `Spin`/`SU` are **not** formalized. This is the genuine
   analytic/real-structure gap.

4. **Intrinsic stabilizer (must not be invented).** All of the above is
   coordinate-only *until* there is an actual theorem that the stabilizer of the
   marked pure-spinor pair `(vacuumSpinor, weakSpinor)` has reductive part
   containing this `SU(2)` factor acting on `weakQuotient` — i.e. a genuine
   Lemma-S2-style stabilizer result. No such object exists in the four files
   (the descent module's own docstring states it does *not* prove the
   stabilizer preserves the submodules). Producing that theorem, plus (3), is
   what would upgrade "a nonidentity linear family on `ℂ²`" to "the fundamental
   `SU(2)_L` representation".

**Bottom line.** With the §5 API added, the smallest honest, non-vacuous result
is §3: an explicit `so(10)` generator (`soAd e₃ f₄`) that provably (by
coordinates) preserves the first annihilator and the color axis and descends to
a nonidentity operator on the weak quotient, with an explicit moved vector and
an explicit non-preserving control. Everything beyond that toward `SU(2)_L` is
listed in §6 and is not yet available.
