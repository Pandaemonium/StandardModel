import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Real-space realization core for the exact HNU endpoint

The supplied sibling module `HNUExactCore` contains the exact momentum-space
endpoint `endpoint : (Fin 3 → ℝ) → M2`, built from the corrected substep symbols
`Uplus`/`Uminus`.  This file builds the *finite real-space* apparatus that
realizes those symbols as genuine local microscopic updates:

* a finite periodic site register with a two-component spin register,
* exact discrete Fourier characters,
* an abstract spin-projector-conditioned nearest-neighbor shift `condShift`,
* its exact unitarity (inner-product preservation), strict range-one locality,
  and its exact Fourier symbol `c • P + Q` on every mode.

The concrete substep/endpoint bridge is assembled in
`PhysicsSM.Draft.NullEdge.HNURealSpaceBridge`.

## Lattice convention (recorded prominently)

Axes `1` and `2` carry `L` sites; axis `3` carries `2 * L` sites.  The doubled
axis-3 lattice is what makes each axis-3 substep an honest **nearest-neighbor**
lattice shift whose Fourier phase is the *half-step* `k₃/2` appearing in
`endpoint`. Every translated branch moves by exactly one lattice site, but the
complementary projector sector remains stationary. See
`PhysicsSM.Draft.NullEdge.HNURealSpaceBridge` for the primitive-null audit.

Provenance: clean-room formalization returned by Aristotle job
`da29672d-5b8a-4e65-bac0-4d3d154dda57`, composed against the exact HNU endpoint
already present in this repository.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore

namespace PhysicsSM.Draft.NullEdge.HNURealSpace

noncomputable section

/-! ## Site and state registers -/

/-- A finite periodic three-dimensional site register.  Axes 1,2 have `L` sites;
axis 3 has `2 * L` sites (finer spacing to realize the axis-3 half-step as a
nearest-neighbor shift). -/
abbrev Site (L : Nat) := Fin L × Fin L × Fin (2 * L)

/-- A microscopic state: a two-component (spin) amplitude at every site. -/
abbrev State (L : Nat) := Site L → (Fin 2 → ℂ)

/-! ## Abstract conditioned-shift operator and its Fourier symbol

We develop the general theory over an arbitrary position type `Pos`, so that
unitarity, locality and the symbol identity are proved once and reused. -/

variable {Pos : Type*}

/-- The spin (two-component) Hermitian inner product `⟪u,v⟫ = Σ_a conj(uₐ) vₐ`. -/
def sinner (u v : Fin 2 → ℂ) : ℂ := ∑ a, (starRingEnd ℂ) (u a) * v a

/-- The full state inner product `Σ_x ⟪ψ x, φ x⟫`. -/
def gInner [Fintype Pos] (ψ φ : Pos → (Fin 2 → ℂ)) : ℂ := ∑ x, sinner (ψ x) (φ x)

/-- The projector-conditioned shift: the `P`-sector is displaced by the site
permutation `σ`, the complementary `Q`-sector is held fixed.  With
`P = Pplus s`, `Q = Pminus s` and `σ` a nearest-neighbor shift this is exactly a
spin-conditioned nearest-neighbor hop. -/
def condShift (P Q : M2) (σ : Pos ≃ Pos) (ψ : Pos → (Fin 2 → ℂ)) :
    Pos → (Fin 2 → ℂ) :=
  fun x => P *ᵥ ψ (σ x) + Q *ᵥ ψ x

/-- A plane wave: a fixed spin amplitude `v` modulated by a character `ch`. -/
def planeWave (ch : Pos → ℂ) (v : Fin 2 → ℂ) : Pos → (Fin 2 → ℂ) :=
  fun x => ch x • v

/-! ### Exact Fourier symbol (item 3, abstract form) -/

/-- **Exact symbol.**  If the site permutation `σ` scales the character by a
constant phase `c` (`ch (σ x) = c · ch x`), then on that mode `condShift P Q σ`
acts by the exact `2×2` symbol `c • P + Q`. -/
theorem condShift_planeWave (P Q : M2) (σ : Pos ≃ Pos) (ch : Pos → ℂ) (c : ℂ)
    (v : Fin 2 → ℂ) (hσ : ∀ x, ch (σ x) = c * ch x) :
    condShift P Q σ (planeWave ch v) = planeWave ch ((c • P + Q) *ᵥ v) := by
  funext x
  simp only [condShift, planeWave, hσ x]
  rw [mulVec_smul, mulVec_smul, add_mulVec, smul_mulVec]
  module

/-! ### Strict range-one locality (item 2) -/

/-- **Locality.**  The output at site `x` depends only on the input at `x` and at
its single shifted neighbor `σ x`; nothing else. -/
theorem condShift_local (P Q : M2) (σ : Pos ≃ Pos) {ψ φ : Pos → (Fin 2 → ℂ)}
    {x : Pos} (h1 : ψ (σ x) = φ (σ x)) (h2 : ψ x = φ x) :
    condShift P Q σ ψ x = condShift P Q σ φ x := by
  simp only [condShift, h1, h2]

/-! ### Bilinearity and adjoint facts for `sinner` -/

lemma sinner_add_left (a b c : Fin 2 → ℂ) :
    sinner (a + b) c = sinner a c + sinner b c := by
  unfold sinner; simp [Finset.sum_add_distrib, add_mul, map_add]

lemma sinner_add_right (a b c : Fin 2 → ℂ) :
    sinner a (b + c) = sinner a b + sinner a c := by
  unfold sinner; simp [Finset.sum_add_distrib, mul_add]

/-- Adjoint move: `⟪M *ᵥ u, w⟫ = ⟪u, Mᴴ *ᵥ w⟫`. -/
lemma sinner_mulVec (M : M2) (u w : Fin 2 → ℂ) :
    sinner (M *ᵥ u) w = sinner u (Mᴴ *ᵥ w) := by
  unfold sinner
  simp only [mulVec, dotProduct, conjTranspose_apply, map_sum, map_mul, Finset.sum_mul,
    Finset.mul_sum]
  rw [Finset.sum_comm]
  congr 1; ext b; congr 1; ext a
  simp [RCLike.star_def]; ring

/-! ### Exact unitarity (item 2, abstract form) -/

/-- **Unitarity.**  For complementary orthogonal Hermitian projectors `P, Q`
(`Pᴴ=P`, `Qᴴ=Q`, `P²=P`, `Q²=Q`, `PQ=QP=0`, `P+Q=1`) and any site permutation
`σ`, the conditioned shift preserves the state inner product. -/
theorem condShift_gInner [Fintype Pos] (P Q : M2) (σ : Pos ≃ Pos)
    (hP : Pᴴ = P) (hQ : Qᴴ = Q) (hP2 : P * P = P) (hQ2 : Q * Q = Q)
    (hPQ : P * Q = 0) (hQP : Q * P = 0) (hsum : P + Q = 1)
    (ψ φ : Pos → (Fin 2 → ℂ)) :
    gInner (condShift P Q σ ψ) (condShift P Q σ φ) = gInner ψ φ := by
  unfold gInner condShift
  have expand : ∀ x, sinner (P *ᵥ ψ (σ x) + Q *ᵥ ψ x) (P *ᵥ φ (σ x) + Q *ᵥ φ x)
      = sinner (ψ (σ x)) (P *ᵥ φ (σ x)) + sinner (ψ x) (Q *ᵥ φ x) := by
    intro x
    rw [sinner_add_left, sinner_add_right, sinner_add_right]
    rw [sinner_mulVec P (ψ (σ x)), sinner_mulVec P (ψ (σ x)), sinner_mulVec Q (ψ x),
        sinner_mulVec Q (ψ x)]
    rw [hP, hQ, mulVec_mulVec, mulVec_mulVec, mulVec_mulVec, mulVec_mulVec,
        hP2, hQ2, hPQ, hQP]
    simp [sinner]
  simp_rw [expand]
  rw [Finset.sum_add_distrib, Equiv.sum_comp σ (fun x => sinner (ψ x) (P *ᵥ φ x)),
      ← Finset.sum_add_distrib]
  congr 1; ext x
  rw [← sinner_add_right, ← add_mulVec, hsum, one_mulVec]

/-! ## Discrete Fourier characters -/

/-- A single-coordinate discrete character factor `exp(2πi a b / N)`. -/
def cphase (N : ℕ) (a b : Fin N) : ℂ :=
  Complex.exp (2 * ↑Real.pi * I * ((a.val * b.val : ℕ) : ℝ) / N)

/-- The mod-`N` periodicity of the exponent (`exp(2πi a (j%N)/N) = exp(2πi a j/N)`). -/
theorem cphase_periodic (a j N : ℕ) (hN : (N : ℝ) ≠ 0) :
    Complex.exp (2 * ↑Real.pi * I * ((a * (j % N) : ℕ) : ℝ) / N)
    = Complex.exp (2 * ↑Real.pi * I * ((a * j : ℕ) : ℝ) / N) := by
  have hid : (a * j : ℕ) = a * (j % N) + N * (a * (j / N)) := by
    conv_lhs => rw [← Nat.mod_add_div j N]
    ring
  have hNc : ((N : ℕ) : ℂ) ≠ 0 := by
    have : (N : ℝ) ≠ 0 := hN; exact_mod_cast this
  rw [hid]
  push_cast
  rw [show (2 * (↑Real.pi : ℂ) * I * (↑a * ↑(j % N) + ↑N * (↑a * ↑(j / N))) / ↑N)
        = 2 * (↑Real.pi : ℂ) * I * (↑a * ↑(j % N)) / ↑N
          + ((a * (j / N) : ℕ) : ℂ) * (2 * ↑Real.pi * I) from by
        push_cast; field_simp]
  rw [Complex.exp_add, Complex.exp_nat_mul_two_pi_mul_I, mul_one]

/-- The character factor is an additive homomorphism in its second argument. -/
theorem cphase_add_right (N : ℕ) [NeZero N] (a b c : Fin N) :
    cphase N a (b + c) = cphase N a b * cphase N a c := by
  have hN : (N : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne N)
  unfold cphase
  rw [← Complex.exp_add, Fin.val_add]
  rw [cphase_periodic a.val (b.val + c.val) N hN]
  congr 1
  push_cast [Nat.mul_add]
  ring

/-- Nonvanishing of the character factor. -/
lemma cphase_ne_zero (N : ℕ) (a b : Fin N) : cphase N a b ≠ 0 := by
  unfold cphase; exact Complex.exp_ne_zero _

/-- Value of the unit-step character factor as a clean exponential (`1 < N`),
with the exponent packaged as a coerced real to match the momentum dictionary. -/
theorem cphase_one (N : ℕ) [NeZero N] (a : Fin N) (hN : 1 < N) :
    cphase N a 1 = Complex.exp (I * ((2 * Real.pi * a.val / N : ℝ) : ℂ)) := by
  unfold cphase
  have h1 : ((1 : Fin N).val : ℕ) = 1 := by
    rw [Fin.val_one']; exact Nat.mod_eq_of_lt hN
  rw [h1]
  congr 1
  push_cast
  ring

/-! ## The three-dimensional character and nearest-neighbor shifts -/

variable {L : ℕ}

/-- The exact discrete Fourier character on the `L × L × 2L` site register. -/
def char (k x : Site L) : ℂ :=
  cphase L k.1 x.1 * cphase L k.2.1 x.2.1 * cphase (2 * L) k.2.2 x.2.2

/-- Nearest-neighbor `+1` shift along axis 1. -/
def shPlus1 [NeZero L] : Site L ≃ Site L :=
  (Equiv.addRight (1 : Fin L)).prodCongr (Equiv.refl _)

/-- Nearest-neighbor `+1` shift along axis 2. -/
def shPlus2 [NeZero L] : Site L ≃ Site L :=
  (Equiv.refl _).prodCongr ((Equiv.addRight (1 : Fin L)).prodCongr (Equiv.refl _))

/-- Nearest-neighbor `+1` shift along axis 3 (on the finer `2L` lattice). -/
def shPlus3 [NeZero L] : Site L ≃ Site L :=
  (Equiv.refl _).prodCongr ((Equiv.refl _).prodCongr (Equiv.addRight (1 : Fin (2 * L))))

/-- Nearest-neighbor `-1` shift along axis 1. -/
def shMinus1 [NeZero L] : Site L ≃ Site L := shPlus1.symm
/-- Nearest-neighbor `-1` shift along axis 2. -/
def shMinus2 [NeZero L] : Site L ≃ Site L := shPlus2.symm
/-- Nearest-neighbor `-1` shift along axis 3. -/
def shMinus3 [NeZero L] : Site L ≃ Site L := shPlus3.symm

/-! ### Nearest-neighbor locality of the shifts (item 2)

Each shift moves exactly one coordinate by one site and leaves the other two
coordinates untouched. -/

lemma shPlus1_coords [NeZero L] (x : Site L) :
    (shPlus1 x).1 = x.1 + 1 ∧ (shPlus1 x).2.1 = x.2.1 ∧ (shPlus1 x).2.2 = x.2.2 := by
  simp [shPlus1]

lemma shPlus2_coords [NeZero L] (x : Site L) :
    (shPlus2 x).1 = x.1 ∧ (shPlus2 x).2.1 = x.2.1 + 1 ∧ (shPlus2 x).2.2 = x.2.2 := by
  simp [shPlus2]

lemma shPlus3_coords [NeZero L] (x : Site L) :
    (shPlus3 x).1 = x.1 ∧ (shPlus3 x).2.1 = x.2.1 ∧ (shPlus3 x).2.2 = x.2.2 + 1 := by
  simp [shPlus3]

/-! ### Character transformation under the shifts (item 3 inputs) -/

lemma char_shPlus1 [NeZero L] (k x : Site L) :
    char k (shPlus1 x) = cphase L k.1 1 * char k x := by
  obtain ⟨h1, h2, h3⟩ := shPlus1_coords x
  unfold char
  rw [h1, h2, h3, cphase_add_right]
  ring

lemma char_shPlus2 [NeZero L] (k x : Site L) :
    char k (shPlus2 x) = cphase L k.2.1 1 * char k x := by
  obtain ⟨h1, h2, h3⟩ := shPlus2_coords x
  unfold char
  rw [h1, h2, h3, cphase_add_right]
  ring

lemma char_shPlus3 [NeZero L] (k x : Site L) :
    char k (shPlus3 x) = cphase (2 * L) k.2.2 1 * char k x := by
  obtain ⟨h1, h2, h3⟩ := shPlus3_coords x
  unfold char
  rw [h1, h2, h3, cphase_add_right]
  ring

lemma char_shMinus1 [NeZero L] (k x : Site L) :
    char k (shMinus1 x) = (cphase L k.1 1)⁻¹ * char k x := by
  have h := char_shPlus1 k (shMinus1 x)
  rw [shMinus1, Equiv.apply_symm_apply] at h
  rw [shMinus1, h]
  field_simp [cphase_ne_zero]

lemma char_shMinus2 [NeZero L] (k x : Site L) :
    char k (shMinus2 x) = (cphase L k.2.1 1)⁻¹ * char k x := by
  have h := char_shPlus2 k (shMinus2 x)
  rw [shMinus2, Equiv.apply_symm_apply] at h
  rw [shMinus2, h]
  field_simp [cphase_ne_zero]

lemma char_shMinus3 [NeZero L] (k x : Site L) :
    char k (shMinus3 x) = (cphase (2 * L) k.2.2 1)⁻¹ * char k x := by
  have h := char_shPlus3 k (shMinus3 x)
  rw [shMinus3, Equiv.apply_symm_apply] at h
  rw [shMinus3, h]
  field_simp [cphase_ne_zero]

end

end PhysicsSM.Draft.NullEdge.HNURealSpace
