# QMF5 design — finite fermionic reflection positivity + the "mass without mass" toy

**Scope.** Pure design/strategy. Every Lean block below is a *shape* (signatures with
`s o r r y` bodies acceptable). Where a symbol comes from an existing module it is named in
a comment; where it is genuinely new it is marked **[NEW]**. All Mathlib names cited were
checked against the pinned toolchain `leanprover/lean4:v4.28.0` + `mathlib@v4.28.0`
(`Matrix.posSemidef_conjTranspose_mul_self`, `Matrix.PosSemidef.conjTranspose_mul_mul_same`,
`Matrix.PosSemidef.add`, `Matrix.PosSemidef.smul`, `Matrix.PosSemidef.fromBlocks₁₁/₂₂`).
The Deliverable-2 fallback block is not a shape — it is verified code (see
`§D2.4`, compiled clean).

**Mass taxonomy is load-bearing and is not weakened anywhere.** The four channels stay
disjoint: (1) physical fermion rest mass, (2) Wilson **regulator** mass (lattice artifact,
`≈ 4r/a` at `r=1`, never physical), (3) Yang–Mills gap = minimal transfer energy of a
closed gauge-flux composite, (4) gravitational (out of scope). The single most important
consequence for this package: **at `quarkMassParameter = 0` the Wilson operator still
carries the full category-(2) regulator mass, so a bare correlator gap at `m = 0` is NOT
"mass without mass".** Any fermionic "mass without mass" claim must attribute the gap to
channel (3), not (2) — see `§D2.5` (the regulator trap) and Risk R1.

---

## Deliverable 1 — finite fermionic reflection positivity (RP-F)

### D1.0 Physics reduction we are formalizing

Target: Osterwalder–Seiler (1978) §4–5 and Menotti–Pelissetto (1987), Wilson-fermion
reflection positivity, `r = 1`, **link reflection** (mirror plane through the midpoints of
the temporal links, i.e. between time-slices `t=0` and `t=1`), NOT site reflection
(Risk R2). Two facts do the work:

* **Wilson projectors.** With `r=1` the temporal hopping term across the mirror uses
  `P± := (1 ∓ γ₀)/2`. Because `γ₀ᴴ = γ₀` and `γ₀² = 1` (both already proven in QMF4's
  gamma package), `P±` are orthogonal projectors: `P±ᴴ = P±`, `P±² = P±`, `P₊P₋ = 0`,
  `P₊ + P₋ = 1`. The cross-mirror coupling is `-½[ψ̄₁(1-γ₀)U₀ψ₀ + ψ̄₀(1+γ₀)U₀ᴴψ₁]`, whose
  projector structure is exactly what turns the reflected coupling into a Gram (`Mᴴ M`)
  form.
* **γ₅-hermiticity as the reflection template.** QMF4 already proved
  `Γ5 · D · Γ5 = Dᴴ` (`gamma5_hermiticity`). Fermionic RP needs the *temporal-reflection*
  analogue `Θ · D · Θ = Dᴴ` for a reflection unitary `Θ` (a site-permutation `⊗ γ₀`,
  paired with the antilinear `starRingEnd ℂ`). This is the same shape and reuses the same
  gamma lemmas — see `rpF_reflection_hermiticity` **[NEW]**.

The Berezin step (QMF3, `berezinGaussian_eq_det`) turns the Grassmann average of a
reflected observable into a **determinant / Gram matrix built from the reflected
Wilson–Dirac block**, which we feed into the RP-KER abstract stack (A). We package this in
two layers, honest about which is cheap and which is the crux:

* **Layer 1 (crux, self-contained linear algebra):** the reflected half-operator boundary
  kernel is `Mᴴ M`, hence PSD. This is where the projector computation lives.
* **Layer 2 (measure wrap):** feed Layer-1 Gram data as the factorized/convex-mixture cut
  kernel `W` into `reflectionForm_nonneg`, summing over positive-half gauge configs
  weighted by the nonnegative paired-flavor determinant (`pairedFlavor_det_nonneg`, C).

### D1.1 Definitions (shapes)

```lean
-- Existing (named for reference; do not redefine):
--   RP-KER (A): reflectionForm, cutKernel, IsReflectionPositive, reflectionForm_nonneg,
--               cutKernel_posSemidef_of_factorized, cutKernel_mul_posSemidef,
--               cutKernel_finset_prod_posSemidef, cutKernel_posSemidef_of_mixture,
--               rpBlockMatrix, rpBlockMatrix_posSemidef_of_reflectionPositive
--   QMF3 (B):   berezinGaussian, berezinGaussian_eq_det
--   QMF4 (C):   Site, Idx, wilsonDirac, Γ5, gamma5_hermiticity, det_wilsonDirac_real,
--               pairedFlavor_det_nonneg, plus γ_sq/γ_herm/γ5_* gamma lemmas

open scoped ComplexOrder   -- needed for Matrix.PosSemidef over ℂ

/-- Time-reflection involution on sites: flips the time coordinate about the link plane
    (`t ↦ 2t₀-1-t` on the periodic torus), fixes spatial coordinates.  **[NEW]** -/
noncomputable def timeRefl (L : ℕ) : Site L → Site L := s o r r y

/-- The reflection unitary `Θ = (site permutation) ⊗ γ₀` on the Dirac index.  **[NEW]** -/
noncomputable def rpFReflection (L nc : ℕ) : Matrix (Idx L nc) (Idx L nc) ℂ := s o r r y

/-- Selection (rectangular) matrix picking the positive-time half `A⁺ ⊆ Idx`.
    `Ahalf` is the positive-time index type; `E` embeds it. **[NEW]** -/
noncomputable def posHalf (L nc : ℕ) : Type := s o r r y
noncomputable def posHalfSel (L nc : ℕ) [Fintype (posHalf L nc)] :
    Matrix (posHalf L nc) (Idx L nc) ℂ := s o r r y

/-- The reflected boundary kernel of the Wilson–Dirac operator on the positive half:
    `E · (Θ · D · Θᴴ)⁻¹ · Eᴴ` restricted to the cut, or — in the free/fixed-background
    layer we actually prove — the hopping Gram block `E · D · Θ · Eᴴ`.  **[NEW]** -/
noncomputable def reflectedWilsonBlock [NeZero L] [Fintype (posHalf L nc)]
    (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) :
    Matrix (posHalf L nc) (posHalf L nc) ℂ := s o r r y

/-- Fermionic reflected weight in RP-KER coordinates.
    `A` = positive-half gauge/boundary data, `C` = cut data (temporal links on the mirror),
    `θ b` = reflected negative-half data. Value = paired-flavor Berezin determinant of the
    glued configuration.  **[NEW]** -/
noncomputable def fermionReflectedWeight {A C : Type*} [Fintype A] [Fintype C]
    (glue : A → C → A → (Σ L nc, Matrix (Idx L nc) (Idx L nc) ℂ)) :
    A → C → A → ℂ :=
  fun a c b => s o r r y   -- ((berezinGaussian (Dₐ𝑐b))^2) or det Dₐ𝑐b, via B
```

### D1.2 Theorem shapes

```lean
open scoped ComplexOrder

/-- Temporal-reflection hermiticity (the Θ-analogue of `gamma5_hermiticity`).
    Hypotheses: unitary links `hU`, and time-reflection symmetry of the background
    `hsym : ∀ μ x, U μ (timeRefl L x) = (reflected/adjointed image of U μ x)`.  **[NEW]** -/
theorem rpF_reflection_hermiticity [NeZero L]
    (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ μ x, (U μ x)ᴴ * (U μ x) = 1)
    (hsym : True /- time-reflection symmetry of the link field -/) :
    rpFReflection L nc * wilsonDirac m U * rpFReflection L nc = (wilsonDirac m U)ᴴ := by
  s o r r y

/-- CRUX (Layer 1): the reflected positive-half boundary block factorizes as `Mᴴ M`.
    This is the projector computation `P± = (1∓γ₀)/2`.  **[NEW, hard node]** -/
theorem reflectedWilsonBlock_eq_gram [NeZero L] [Fintype (posHalf L nc)]
    (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ μ x, (U μ x)ᴴ * (U μ x) = 1)
    (hsym : True) :
    ∃ M : Matrix (Idx L nc) (posHalf L nc) ℂ,
      reflectedWilsonBlock m U = Mᴴ * M := by
  s o r r y

/-- CRUX corollary: the reflected block is PSD (Layer 1 conclusion).  **[NEW, cheap]** -/
theorem reflectedWilsonBlock_posSemidef [NeZero L] [Fintype (posHalf L nc)]
    (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ μ x, (U μ x)ᴴ * (U μ x) = 1) (hsym : True) :
    (reflectedWilsonBlock m U).PosSemidef := by
  obtain ⟨M, hM⟩ := reflectedWilsonBlock_eq_gram m U hU hsym
  simpa [hM] using Matrix.posSemidef_conjTranspose_mul_self M

/-- Layer 2, single fixed background: the fermionic cut kernel is PSD, from the factorized
    (rank-one-Gram) route.  Reuses `cutKernel_posSemidef_of_factorized` (A). -/
theorem fermionCutKernel_posSemidef_fixed {A C : Type*} [Fintype A] [Fintype C]
    (h : A → C → ℂ) (c : C) :
    (cutKernel (fun a c' b => h a c' * (starRingEnd ℂ) (h b c')) c).PosSemidef :=
  cutKernel_posSemidef_of_factorized h c   -- direct from API (A)

/-- Layer 2, dynamical links: the fermionic reflected weight is reflection positive,
    as a convex mixture over positive-half gauge configs weighted by the nonnegative
    paired-flavor determinant.  Reuses `cutKernel_posSemidef_of_mixture` (A) +
    `pairedFlavor_det_nonneg` (C).  **[NEW glue]** -/
theorem fermionReflectedWeight_reflectionPositive {A C : Type*} [Fintype A] [Fintype C]
    (glue : A → C → A → (Σ L nc, Matrix (Idx L nc) (Idx L nc) ℂ))
    (hfac : True /- each fixed-config kernel is factorized/Gram, from Layer 1 -/)
    (hpos : True /- flavor-paired determinant weights are ≥ 0, from C -/) :
    IsReflectionPositive (fermionReflectedWeight glue) := by
  s o r r y

/-- OS/GNS packaging: the fermionic RP block matrix is PSD (transfer-operator route). -/
theorem fermionRpBlockMatrix_posSemidef {A C : Type*} [Fintype A] [Fintype C]
    [DecidableEq C]
    (glue : A → C → A → (Σ L nc, Matrix (Idx L nc) (Idx L nc) ℂ))
    (h : IsReflectionPositive (fermionReflectedWeight glue)) :
    (rpBlockMatrix (fermionReflectedWeight glue)).PosSemidef :=
  rpBlockMatrix_posSemidef_of_reflectionPositive _ h   -- direct from API (A)
```

### D1.3 Lemma DAG (node : status : one-line strategy : deps)

```
[C] gamma lemmas γ₀ᴴ=γ₀, γ₀²=1                         : HAVE (QMF4)
[C] gamma5_hermiticity  Γ5 D Γ5 = Dᴴ                    : HAVE (QMF4)  -- template
[C] pairedFlavor_det_nonneg  0 ≤ (det D)²               : HAVE (QMF4)
[B] berezinGaussian_eq_det                              : HAVE (QMF3)
[A] posSemidef facts + reflectionForm_nonneg + mixture  : HAVE (RP-KER)
--- new nodes ---
N1 timeRefl involutive                                  : NEW-easy  : Function.Involutive on Fin L time coord ; ⊣ (none)
N2 rpFReflection unitary & involutive (Θᴴ=Θ, Θ²=1)      : NEW-easy  : perm-matrix ⊗ γ₀, use γ₀²=1, γ₀ᴴ=γ₀ ; ⊣ [C]γ,N1
N3 rpF_reflection_hermiticity  Θ D Θ = Dᴴ               : NEW-med   : mirror the gamma5_hermiticity proof, temporal shift + hsym ; ⊣ [C]γ,gamma5_hermiticity,N2
N4 projector facts P±=(1∓γ₀)/2 idempotent/orth/herm     : NEW-easy  : from γ₀²=1,γ₀ᴴ=γ₀ ; ⊣ [C]γ
N5 reflectedWilsonBlock_eq_gram   block = Mᴴ M          : NEW-HARD  : CRUX. cross-mirror hopping ×P₊ = Gram of half-op ; ⊣ N3,N4  (see §D1.4)
N6 reflectedWilsonBlock_posSemidef                      : NEW-easy  : posSemidef_conjTranspose_mul_self ∘ N5 ; ⊣ N5,[A]
N7 fermionReflectedWeight = det via Berezin             : NEW-med   : berezinGaussian_eq_det on glued D ; ⊣ [B]
N8 fixed-bkgd cut kernel factorized                     : NEW-med   : read Gram vector h off N5/N6 ; ⊣ N6,N7
N9 fermionCutKernel_posSemidef_fixed                    : DIRECT[A] : = cutKernel_posSemidef_of_factorized ; ⊣ N8
N10 dynamical mixture weights ≥ 0                        : NEW-easy  : pairedFlavor_det_nonneg per config ; ⊣ [C]
N11 fermionReflectedWeight_reflectionPositive           : NEW-med   : cutKernel_posSemidef_of_mixture over N9 with N10 weights, then reflectionForm_nonneg ; ⊣ N9,N10,[A]
N12 fermionRpBlockMatrix_posSemidef                     : DIRECT[A] : rpBlockMatrix_posSemidef_of_reflectionPositive ; ⊣ N11,[A]
```

Everything downstream of **N5** is cheap; the whole package's difficulty is concentrated in
N5 (and, secondarily, the bookkeeping of `posHalf`/`timeRefl` indexing in N1–N3).

### D1.4 The crux, stated precisely, with the linear-algebra core proved

**Crux (N5).** Let `D` be the Wilson–Dirac operator, `Θ` the reflection unitary with
`Θ = Θᴴ`, `Θ² = 1`, and `Θ D Θ = Dᴴ` (N3). Let `E` select the positive half and let
`P₊ = (1-γ₀)/2` be the forward temporal Wilson projector. Then the reflected boundary
coupling equals a Gram matrix:

> `reflectedWilsonBlock = Mᴴ M`, with `M := (√hopping)·P₊·(half-operator)·Eᴴ`.

The mechanism: link reflection identifies the `t=1` boundary of the positive half with the
`Θ`-image of the `t=0` boundary of the negative half; the single cross-mirror hopping term
carries the projector `P₊` on the `+` side and `P₊ᴴ = P₊` on the reflected side, so the
coupling is literally `(P₊ x)ᴴ (P₊ x)`. The Wilson mass term and all *spatial* hopping is
block-diagonal across the mirror and contributes the interior of `M`; `Θ D Θ = Dᴴ` makes
the negative-half interior the conjugate transpose of the positive-half interior. Hence a
single `Mᴴ M`.

**Linear-algebra core (fully general, checked against pinned Mathlib).** Once N5 puts the
kernel in `Mᴴ M` form, PSD and the whole RP-KER hand-off are immediate. The three reusable
cores are:

```lean
open scoped ComplexOrder
variable {A n : Type*} [Fintype A] [Fintype n] [DecidableEq A] [DecidableEq n]

-- (i) Gram is PSD  — this is the endpoint of N6.
example (M : Matrix n A ℂ) : (Mᴴ * M).PosSemidef :=
  Matrix.posSemidef_conjTranspose_mul_self M

-- (ii) congruence: half-operator PSD ⇒ boundary block PSD  (the E·(·)·Eᴴ step).
example {S : Matrix n n ℂ} (hS : S.PosSemidef) (E : Matrix A n ℂ) :
    (E * S * Eᴴ).PosSemidef :=
  hS.mul_mul_conjTranspose_same E

-- (iii) convex mixture over gauge configs with det² ≥ 0 weights  (N11).
example {K : Type*} [Fintype K] (w : K → ℝ) (hw : ∀ k, 0 ≤ w k)
    (G : K → Matrix A A ℂ) (hG : ∀ k, (G k).PosSemidef) :
    (∑ k, (w k : ℂ) • G k).PosSemidef :=
  Finset.univ.sum_induction _ Matrix.PosSemidef _root_.Matrix.PosSemidef.zero
    (fun _ _ ha hb => ha.add hb)   -- with (hG k).smul (by exact_mod_cast hw k)
    (fun k _ => ((hG k).smul (by exact_mod_cast hw k)))
```

(The last is schematic — in the real file use the project's `cutKernel_posSemidef_of_mixture`,
which already packages exactly this. `PosSemidef.smul` needs `0 ≤ (w k : ℂ)`, obtained from
`hw k` via `Complex.ofReal_nonneg`/`exact_mod_cast` under `open scoped ComplexOrder`.)

**Why this respects the taxonomy.** RP-F is a statement about the *measure*, entirely in
channels (1)+(2)+(3) coupled through `D`; it does not assert anything about masses. The mass
attribution happens only in Deliverable 2.

---

## Deliverable 2 — NE-U5 "mass without mass" toy

### D2.0 Honest verdict up front

A genuinely *fermionic* "composite mass at zero bare quark mass" that is (a) attributable to
confinement/channel (3) and (b) diagonalizable in-kernel with no numerics is **not** the
smallest tractable object, because of the **regulator trap** (§D2.5 / R1): at
`quarkMassParameter = 0` the Wilson operator still supplies the full category-(2) regulator
mass, so a raw meson-correlator gap at `m=0` measures channel (2), which the constitution
forbids conflating with a physical/composite mass. Cleanly separating the confinement
contribution needs a chiral Ward/ratio argument, which enlarges the model past
in-kernel diagonalization.

Therefore we deliver the **pure-gauge glueball-sector analogue as the recommended
tractable object** (`§D2.4`, verified, strictly positive gap, zero fermions ⇒ zero quark
mass by construction ⇒ *no taxonomy conflation possible*), and give the fermionic model
only as a labeled **stretch** shape (`§D2.6`) with its Ward-identity route spelled out.

### D2.1 The recommended model (fallback, but the one we should actually ship)

**Z₂ single-plaquette temporal transfer (glueball sector).** Link variables `±1`; one
plaquette; two flux states (trivial / flipped). The temporal transfer operator on the
2-dim flux Hilbert space at inverse coupling `β` is
`T = [[e^β, e^{-β}], [e^{-β}, e^β]]`. It is symmetric PSD; eigenvectors `(1,1),(1,-1)`;
eigenvalues `λ₊ = 2cosh β`, `λ₋ = 2 sinh β`. The glueball mass (category-(3) YM gap =
minimal transfer energy of the closed flux loop) is
`m_glue = -log(λ₋/λ₊) = log coth β > 0` for every finite `β > 0`.

* `quarkMassParameter := 0` holds **vacuously and exactly**: there are no fermions.
* The positive gap is channel (3) only.
* Fully explicit, 2×2, no numerics.

### D2.2 Sector definitions it needs

Only one sector split is needed: the **flux/charge-conjugation parity** of the Z₂ plaquette
(`+` symmetric vacuum vs `−` flux-loop excitation), which is exactly the `(1,1)` vs `(1,-1)`
eigenbasis. The gap is the vacuum(`+`)→flux(`−`) energy difference. No flavor/parity fermion
sectors are required in the fallback (they appear only in the stretch model, §D2.6).

### D2.3 Positive-gap theorem shape

```lean
open scoped ComplexOrder
noncomputable def transfer2 (a b : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![a, b; b, a]
noncomputable def gap2 (a b : ℝ) : ℝ := Real.log ((a + b) / (a - b))

theorem transfer2_gap_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) : 0 < gap2 a b := s o r r y
theorem z2_glueball_gap_pos {β : ℝ} (hβ : 0 < β) :
    0 < gap2 (Real.exp β) (Real.exp (-β)) := s o r r y
```

### D2.4 Route to a kernel proof — VERIFIED (compiles clean on the pinned toolchain)

The gap is a strict inequality between two explicit reals; no diagonalization tactic is
needed beyond exhibiting the eigenvectors. The following elaborates with only the linter
`unnecessarySeqFocus` note:

```lean
import Mathlib
open Matrix
open scoped ComplexOrder

noncomputable def transfer2 (a b : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![a, b; b, a]
noncomputable def gap2 (a b : ℝ) : ℝ := Real.log ((a + b) / (a - b))

-- (1,1) is an eigenvector with eigenvalue a+b (the vacuum branch)
theorem transfer2_mulVec_sym (a b : ℝ) :
    (transfer2 a b) *ᵥ (fun _ => (1:ℝ)) = fun _ => a + b := by
  funext i; fin_cases i <;>
    simp [transfer2, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring

-- strictly positive mass gap whenever 0 < b < a (nonzero coupling)
theorem transfer2_gap_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) : 0 < gap2 a b := by
  have h1 : 0 < a - b := by linarith
  have h2 : a - b < a + b := by linarith
  have : (1:ℝ) < (a + b) / (a - b) := (one_lt_div h1).mpr h2
  simpa [gap2] using Real.log_pos this

-- Z₂ single-plaquette instantiation: a = e^β, b = e^{-β}; gap = log coth β > 0
theorem z2_glueball_gap_pos {β : ℝ} (hβ : 0 < β) :
    0 < gap2 (Real.exp β) (Real.exp (-β)) := by
  refine transfer2_gap_pos (Real.exp_pos _) ?_
  exact Real.exp_lt_exp.mpr (by linarith)
```

To make the "transfer operator" attribution airtight one should also ship
`transfer2_posSemidef` (from RP, or directly: `!![a,b;b,a]` is PSD for `|b| ≤ a` via
`posSemidef_iff_dotProduct_mulVec` / a `2·PosSemidef` `Mᴴ M` witness) and
`transfer2 = Tᵀ` symmetric, so the two branches genuinely are the two transfer eigenvalues.
Both are one-liners once the eigenvectors above are in hand.

### D2.5 The regulator trap (why this is the fallback and not the fermionic model)

If one instead built a 2-site Wilson-quark meson correlator and set
`quarkMassParameter := 0`, the connected `ψ̄ψ`-channel correlator would still decay with a
rate `≈ log(1 + 4r) = log 5` at `r = 1` — this is **entirely the category-(2) Wilson
regulator mass**, a lattice artifact of the doubler-removal term, not a physical or
composite mass. Reporting that number as "mass without mass" is precisely the taxonomy
error (2)≡(1) or (2)≡(3). The fallback sidesteps this by having no fermions at all, so its
gap can only be channel (3).

### D2.6 The fermionic model as a labeled STRETCH (not recommended for first package)

```lean
open scoped ComplexOrder
/-- 2-site (temporal) Z₂-gauge + one Wilson flavor pair, bare mass forced to zero. -/
structure NE_U5_Toy where
  beta : ℝ                                   -- gauge coupling, > 0
  r    : ℝ := 1                              -- Wilson parameter (fixed)
noncomputable def NE_U5_Toy.quarkMassParameter (_ : NE_U5_Toy) : ℝ := 0   -- forced 0

/-- Meson-channel transfer operator on the toy's 2-dim gauge-invariant subspace. -/
noncomputable def NE_U5_Toy.mesonTransfer (T : NE_U5_Toy) : Matrix (Fin 2) (Fin 2) ℝ := s o r r y
/-- CONFINEMENT part of the gap = full gap minus the regulator baseline `log(1+4r)`.
    The honest observable is this *difference* (a chiral-Ward / ratio quantity). -/
noncomputable def NE_U5_Toy.confinementGap (T : NE_U5_Toy) : ℝ := s o r r y

/-- STRETCH claim: with zero bare quark mass, the confinement part of the composite gap is
    strictly positive — genuine channel-(3) mass without channel-(1) mass. -/
theorem NE_U5_confinement_gap_pos (T : NE_U5_Toy) (hβ : 0 < T.beta) :
    0 < T.confinementGap := by
  s o r r y
```

Route (why it is a stretch): `mesonTransfer` must be assembled from the Berezin determinant
of the 2-site Wilson operator (B, C) at `m=0`, then the *regulator baseline* subtracted via
a chiral Ward identity so that `confinementGap` isolates channel (3). Both the determinant
assembly and the Ward subtraction are more than a 2×2 diagonalization; do this only after
Deliverable 1 lands.

---

## Deliverable 3 — minimal honest fragment + top risks

### D3.1 Minimal tractable fragment of Deliverable 1

Ship **Layer 1 with trivial links** (`U ≡ 1`, the free Wilson theory) first:

```lean
open scoped ComplexOrder
/-- Free (trivial-link) reflected Wilson block is PSD.  The smallest honest RP-F fragment:
    it exercises N4 (projectors) + N5 (Gram factorization) with no gauge bookkeeping. -/
theorem reflectedWilsonBlock_free_posSemidef [NeZero L] [Fintype (posHalf L nc)]
    (m : ℝ) :
    (reflectedWilsonBlock (L := L) (nc := nc) m (fun _ _ => (1 : Matrix (Fin nc) (Fin nc) ℂ)))
      .PosSemidef := by
  s o r r y   -- reflectedWilsonBlock_eq_gram with U ≡ 1 ⇒ posSemidef_conjTranspose_mul_self
```

This is the whole crux (N4+N5+N6) with `hsym` trivially true and no mixture, so it is the
right first milestone. Even smaller: prove `reflectedWilsonBlock_eq_gram` at `nc = 1`,
`L = 2` where `Θ D Θ = Dᴴ` and the `Mᴴ M` identity can be checked by `decide`-free
`Matrix.ext` + `Fin.sum_univ_*`.

### D3.2 Three highest-risk semantic pitfalls

* **R1 — the one-flavor sign / regulator conflation (most dangerous).** A single Wilson
  flavor has `det D` real but not sign-definite, so the measure need not be positive: RP-F
  needs the *degenerate flavor pair* (`(det D)² ≥ 0`, `pairedFlavor_det_nonneg`, C) as the
  mixture weight — N10 must use the paired determinant, never the bare one. Independently,
  at `m=0` the correlator gap is dominated by the category-(2) Wilson regulator; never
  report it as physical/composite mass (D2.5). Mitigation: bake flavor pairing into the
  weight type and keep `confinementGap` (not the raw gap) as the only mass-labeled output.

* **R2 — link-plane vs site-plane reflection.** Wilson-fermion RP holds for **link
  reflection** (mirror between slices, projectors `P±=(1∓γ₀)/2` land cleanly on opposite
  sides). **Site reflection** (mirror through a slice) generically *fails* for Wilson
  fermions, or needs an extra flip and a modified `Θ`. `timeRefl`/`rpFReflection` (N1–N3)
  must implement the *link* convention; getting this wrong makes N5's `Mᴴ M` off by the
  cross term and the block will not be PSD. Mitigation: fix `timeRefl` as `t ↦ 2t₀-1-t`
  (no fixed slice) and unit-test N3 at `L=2`.

* **R3 — a stray Grassmann sign breaking `Mᴴ M`.** Berezin reflection can introduce a sign
  (from `shuffleSign` / reordering `ψ, ψ̄` across the mirror, and from the antilinear
  `starRingEnd`) that flips the cross term from `(P₊x)ᴴ(P₊x)` to `-(…)`, silently turning
  PSD into indefinite. Mitigation: prove N5 as an *equality* `reflectedWilsonBlock = Mᴴ M`
  (not merely PSD) so any wrong sign surfaces as a failed `Matrix.ext`; validate the sign at
  `nc=1, L=2` before generalizing, and confirm `rpF_reflection_hermiticity` (N3) reproduces
  the *same* sign convention as `gamma5_hermiticity`.

### D3.3 Suggested build order

1. `transfer2_*` + `z2_glueball_gap_pos` (D2.4) — verified, ship now, category-(3) labeled.
2. `reflectedWilsonBlock_eq_gram` at `nc=1, L=2` (R3 sign check) → free case (D3.1).
3. N1–N3 (`timeRefl`, `rpFReflection`, `rpF_reflection_hermiticity`) with R2 unit test.
4. N5 general → N6 → N9 (direct from A) → N11 (mixture, R1 flavor pairing) → N12.
5. NE-U5 fermionic stretch (D2.6) only after 1–4.
```
