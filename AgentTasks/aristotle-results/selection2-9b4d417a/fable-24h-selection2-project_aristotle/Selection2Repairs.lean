import Mathlib

/-!
# Selection2: audit-driven kernel repairs (hostile2 F5/F7/F9/F10)

Context files carry the landed modules whose scope these targets
complete.  Conventions are identical to the context files (definitions
are copied locally, VERBATIM; we do not import the context lib).

T1 (F5, scalar-gauge collapse): with `famH` and the selection
constraints as in `PairKickSelection` but the gauge replaced by the
SCALAR common phase `Dscalar u = !![u,0;0,u]`, the three constraints
force `famH C A B z = 0` for every `z`.  This makes the CHIRALITY of the
gauge action load-bearing: under a scalar gauge conjugation is trivial,
so equivariance says `H (u z) = H z` for all unimodular `u`; with
linearity in `(z, conj z)` and `H 0 = 0` this kills `A`, `B` and `C`.

T2 (F7, the missing equivariance control): the family
`Hviol z = (z + conj z) • !![0,1;1,0]` is Hermitian for all `z` and
vanishes at `z = 0`, yet VIOLATES the chiral equivariance (witness
`u = I`, `z = 1`).

T3 (F9, full same-site no-go): any Hermitian `H` supported on the four
same-site pair indices `{0,13,22,27}` that anticommutes with `G2`
vanishes (the Gaussian-integer twin + `toComplex` transport pattern of
the context module; `G2` is `-1` on all four same-site indices).

T4 (F10, exact G2 census): `G2` has EXACTLY four `(-1)`-fixed basis
states, at indices `{0,13,22,27}`, and for every pair index `p`,
`G2 e_p = ±e_(partner p)` where `partner` is the explicit component-flip
involution (flip both components of the two sites); moreover `q` with
`G2 e_p = ±e_q` is unique and equals `partner p`, and `partner p = p`
iff `p` is one of the four same-site indices.

All kernel-only (the ZZ[i] twin + `decide` pattern makes `native_decide`
unnecessary).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Selection2Repairs

open Matrix

/-! ## Definitions copied VERBATIM from the context files. -/

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-- The block gauge action of the site-local chiral phase. -/
def Dphase (u : ℂ) : M2 := !![u, 0; 0, 1]

/-- A datum-reading family: constant + linear response. -/
def famH (C A B : M2) (z : ℂ) : M2 := C + z • A + (starRingEnd ℂ z) • B

abbrev M8 := Matrix (Fin 8) (Fin 8) ℂ
abbrev M28 := Matrix (Fin 28) (Fin 28) ℂ

/-- Site-diagonal sigma_y chiral grading (symmetric time frame). -/
def G1 : M8 := Matrix.of fun i j =>
  if i.1 / 2 = j.1 / 2 then
    (if i.1 % 2 = 0 ∧ j.1 % 2 = 1 then -Complex.I
     else if i.1 % 2 = 1 ∧ j.1 % 2 = 0 then Complex.I else 0)
  else 0

def pairFst : Fin 28 → Fin 8 :=
  ![0,0,0,0,0,0,0, 1,1,1,1,1,1, 2,2,2,2,2, 3,3,3,3, 4,4,4, 5,5, 6]
def pairSnd : Fin 28 → Fin 8 :=
  ![1,2,3,4,5,6,7, 2,3,4,5,6,7, 3,4,5,6,7, 4,5,6,7, 5,6,7, 6,7, 7]

/-- Determinant-minor pair lift. -/
def minorLift (A : M8) : M28 := Matrix.of fun r c =>
  A (pairFst r) (pairFst c) * A (pairSnd r) (pairSnd c)
    - A (pairFst r) (pairSnd c) * A (pairSnd r) (pairFst c)

def G2 : M28 := minorLift G1

/-! ## Gaussian-integer bridge (copied VERBATIM from the context module). -/

abbrev Z8 := Matrix (Fin 8) (Fin 8) GaussianInt
abbrev Z28 := Matrix (Fin 28) (Fin 28) GaussianInt

def G1g : Z8 := Matrix.of fun i j =>
  if i.1 / 2 = j.1 / 2 then
    (if i.1 % 2 = 0 ∧ j.1 % 2 = 1 then -⟨0,1⟩
     else if i.1 % 2 = 1 ∧ j.1 % 2 = 0 then (⟨0,1⟩ : GaussianInt) else 0)
  else 0

def minorLiftg (A : Z8) : Z28 := Matrix.of fun r c =>
  A (pairFst r) (pairFst c) * A (pairSnd r) (pairSnd c)
    - A (pairFst r) (pairSnd c) * A (pairSnd r) (pairFst c)

def G2g : Z28 := minorLiftg G1g

/-- The Gaussian-integer to complex ring homomorphism. -/
noncomputable def phi : GaussianInt →+* ℂ := GaussianInt.toComplex

lemma G1_eq : G1 = G1g.map phi := by
  ext i j
  simp only [G1, G1g, Matrix.map_apply, Matrix.of_apply]
  split_ifs <;> simp [phi, GaussianInt.toComplex_def]

lemma minorLift_map (A : Z8) : minorLift (A.map phi) = (minorLiftg A).map phi := by
  ext r c
  simp [minorLift, minorLiftg, Matrix.map_apply, map_sub, map_mul]

lemma G2_eq : G2 = G2g.map phi := by
  unfold G2 G2g; rw [G1_eq, minorLift_map]

lemma map_neg' (M : Z28) : (-M).map phi = -(M.map phi) := by
  ext i j; simp [Matrix.map_apply, Matrix.neg_apply, map_neg]

/-! ## T1: scalar-gauge collapse. -/

/-- The block gauge action of the SCALAR common phase `diag(u,u)`. -/
def Dscalar (u : ℂ) : M2 := !![u, 0; 0, u]

/-- T1 (F5): under the scalar gauge `Dscalar u = diag(u,u)`, the three
selection constraints force the whole family to vanish.  (The full
three-constraint set of `PairKickSelection` is stated for faithfulness;
the collapse in fact needs only equivariance + vanishing -- the
Hermiticity hypothesis `hherm` is unused.) -/
theorem scalar_gauge_collapse (C A B : M2)
    (hequi : ∀ u z : ℂ, ‖u‖ = 1 →
      famH C A B (u * z) = Dscalar u * famH C A B z * (Dscalar u)ᴴ)
    (hherm : ∀ z : ℂ, (famH C A B z)ᴴ = famH C A B z)
    (hzero : famH C A B 0 = 0) :
    ∀ z : ℂ, famH C A B z = 0 := by
  have hC : C = 0 := by simpa [famH] using hzero
  subst hC
  have hI := hequi Complex.I 1 (by simp)
  have hm := hequi (-1) 1 (by simp)
  simp only [famH, Dscalar] at hI hm
  rw [← Matrix.ext_iff] at hI hm
  simp only [Fin.forall_fin_two, Matrix.add_apply, Matrix.smul_apply, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.conjTranspose_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_zero, Matrix.cons_val_one, smul_eq_mul,
    Matrix.zero_apply] at hI hm
  have hA : A = 0 := by
    rw [← Matrix.ext_iff]; simp only [Fin.forall_fin_two, Matrix.zero_apply]
    norm_num [Complex.ext_iff] at hI hm ⊢; constructor <;> constructor <;> grind
  have hB : B = 0 := by
    rw [← Matrix.ext_iff]; simp only [Fin.forall_fin_two, Matrix.zero_apply]
    norm_num [Complex.ext_iff] at hI hm ⊢; constructor <;> constructor <;> grind
  intro z
  simp [famH, hA, hB]

/-! ## T2: the equivariance-violating control. -/

/-- The Hermitian, vanishing, but NOT chirally equivariant family. -/
def Hviol (z : ℂ) : M2 := (z + starRingEnd ℂ z) • !![0, 1; 1, 0]

/-- T2 (F7): `Hviol` is Hermitian for every `z` and vanishes at `z = 0`,
yet violates the chiral equivariance (witnessed by `u = I`, `z = 1`). -/
theorem equivariance_violating_control :
    (∀ z : ℂ, (Hviol z)ᴴ = Hviol z)
      ∧ (Hviol 0 = 0)
      ∧ (∃ u z : ℂ, ‖u‖ = 1 ∧
          Hviol (u * z) ≠ Dphase u * Hviol z * (Dphase u)ᴴ) := by
  refine ⟨?_, ?_, ?_⟩
  · intro z
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Hviol, Matrix.conjTranspose_apply] <;> ring
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Hviol]
  · refine ⟨Complex.I, 1, by simp, ?_⟩
    intro h
    have := congrFun (congrFun h 0) 1
    simp [Hviol, Dphase, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.conjTranspose_apply] at this

/-! ## T3: the full same-site no-go. -/

lemma G2g_row0 : ∀ k : Fin 28, G2g 0 k = if k = 0 then -1 else 0 := by decide
lemma G2g_row13 : ∀ k : Fin 28, G2g 13 k = if k = 13 then -1 else 0 := by decide
lemma G2g_row22 : ∀ k : Fin 28, G2g 22 k = if k = 22 then -1 else 0 := by decide
lemma G2g_row27 : ∀ k : Fin 28, G2g 27 k = if k = 27 then -1 else 0 := by decide
lemma G2g_col0 : ∀ k : Fin 28, G2g k 0 = if k = 0 then -1 else 0 := by decide
lemma G2g_col13 : ∀ k : Fin 28, G2g k 13 = if k = 13 then -1 else 0 := by decide
lemma G2g_col22 : ∀ k : Fin 28, G2g k 22 = if k = 22 then -1 else 0 := by decide
lemma G2g_col27 : ∀ k : Fin 28, G2g k 27 = if k = 27 then -1 else 0 := by decide

lemma G2_rowSame (i : Fin 28) (hi : i = 0 ∨ i = 13 ∨ i = 22 ∨ i = 27) (k : Fin 28) :
    G2 i k = if k = i then -1 else 0 := by
  have h : G2 i k = phi (G2g i k) := by rw [G2_eq]; rfl
  rw [h]
  rcases hi with rfl | rfl | rfl | rfl
  · rw [G2g_row0 k]; split_ifs <;> simp [phi]
  · rw [G2g_row13 k]; split_ifs <;> simp [phi]
  · rw [G2g_row22 k]; split_ifs <;> simp [phi]
  · rw [G2g_row27 k]; split_ifs <;> simp [phi]

lemma G2_colSame (j : Fin 28) (hj : j = 0 ∨ j = 13 ∨ j = 22 ∨ j = 27) (k : Fin 28) :
    G2 k j = if k = j then -1 else 0 := by
  have h : G2 k j = phi (G2g k j) := by rw [G2_eq]; rfl
  rw [h]
  rcases hj with rfl | rfl | rfl | rfl
  · rw [G2g_col0 k]; split_ifs <;> simp [phi]
  · rw [G2g_col13 k]; split_ifs <;> simp [phi]
  · rw [G2g_col22 k]; split_ifs <;> simp [phi]
  · rw [G2g_col27 k]; split_ifs <;> simp [phi]

/-- T3 (F9): no chirality-odd generator lives on the full same-site pair
block `{0,13,22,27}` (pairs (0,1),(2,3),(4,5),(6,7)). -/
theorem no_odd_generator_on_full_samesite_block (H : M28)
    (hsupp : ∀ r c, H r c ≠ 0 →
      (r = 0 ∨ r = 13 ∨ r = 22 ∨ r = 27) ∧ (c = 0 ∨ c = 13 ∨ c = 22 ∨ c = 27))
    (hodd : G2 * H = -(H * G2)) :
    H = 0 := by
  ext i j
  by_cases hij : (i = 0 ∨ i = 13 ∨ i = 22 ∨ i = 27) ∧ (j = 0 ∨ j = 13 ∨ j = 22 ∨ j = 27)
  · obtain ⟨hi, hj⟩ := hij
    have key := congrFun (congrFun hodd i) j
    rw [Matrix.mul_apply, Matrix.neg_apply, Matrix.mul_apply] at key
    have lhs : (∑ k, G2 i k * H k j) = -(H i j) := by
      rw [Finset.sum_eq_single i]
      · rw [G2_rowSame i hi i]; simp
      · intro k _ hk; rw [G2_rowSame i hi k]; simp [hk]
      · simp
    have rhs : (∑ k, H i k * G2 k j) = -(H i j) := by
      rw [Finset.sum_eq_single j]
      · rw [G2_colSame j hj j]; simp
      · intro k _ hk; rw [G2_colSame j hj k]; simp [hk]
      · simp
    rw [lhs, rhs] at key
    simp only [Matrix.zero_apply]
    linear_combination (-1/2 : ℂ) * key
  · simp only [Matrix.zero_apply]
    by_contra h
    exact hij (hsupp i j h)

/-! ## T4: the exact G2 census. -/

/-- The component-flip partner involution (flip both components of the
two sites; explicit table, verified against the integer twin below). -/
def partner : Fin 28 → Fin 28 :=
  ![0,8,7,10,9,12,11, 2,1,4,3,6,5, 13,19,18,21,20, 15,14,17,16, 22,26,25, 24,23, 27]

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma census_partner_g :
    ∀ p : Fin 28,
      (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single (partner p) 1)
        ∨ (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single (partner p) 1)) := by
  decide

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma census_fixed_g :
    ∀ p : Fin 28,
      (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single p 1))
        ↔ (p = 0 ∨ p = 13 ∨ p = 22 ∨ p = 27) := by
  decide

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma census_unique_g :
    ∀ p q : Fin 28,
      ((G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single q 1)
        ∨ (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single q 1)))
      → q = partner p := by
  decide

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma partner_fixed_g :
    ∀ p : Fin 28, partner p = p ↔ (p = 0 ∨ p = 13 ∨ p = 22 ∨ p = 27) := by
  decide

/-- Bridge: transport a `G2g`-image equation to `G2` over `ℂ`. -/
lemma G2_mulVec_single (p : Fin 28) :
    G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = fun i => phi ((G2g *ᵥ (Pi.single p 1)) i) := by
  have singleC : (Pi.single p 1 : Fin 28 → ℂ)
      = fun i => phi ((Pi.single p 1 : Fin 28 → GaussianInt) i) := by
    funext i; simp only [Pi.single_apply]; split_ifs <;> simp [phi]
  rw [G2_eq, singleC]
  ext i; simp only [Matrix.mulVec, dotProduct, Matrix.map_apply, map_sum, map_mul]

lemma phi_inj : Function.Injective phi := GaussianInt.toComplex_injective

lemma funphi_inj {a b : Fin 28 → GaussianInt}
    (h : (fun i => phi (a i)) = (fun i => phi (b i))) : a = b := by
  funext i; exact phi_inj (congrFun h i)

lemma phi_single (q : Fin 28) :
    (Pi.single q 1 : Fin 28 → ℂ) = fun i => phi ((Pi.single q 1 : Fin 28 → GaussianInt) i) := by
  funext i; simp only [Pi.single_apply]; split_ifs <;> simp [phi]

lemma phi_neg_single (q : Fin 28) :
    (-(Pi.single q 1) : Fin 28 → ℂ)
      = fun i => phi ((-(Pi.single q 1) : Fin 28 → GaussianInt) i) := by
  funext i; simp only [Pi.neg_apply, Pi.single_apply, map_neg]; split_ifs <;> simp [phi]

lemma transfer_pos {p q : Fin 28}
    (h : G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single q 1) :
    G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single q 1 := by
  rw [G2_mulVec_single p, phi_single q, h]

lemma transfer_neg {p q : Fin 28}
    (h : G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single q 1)) :
    G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single q 1) := by
  rw [G2_mulVec_single p, phi_neg_single q, h]

lemma transfer_pos_rev {p q : Fin 28}
    (h : G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single q 1) :
    G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single q 1 := by
  apply funphi_inj
  rw [← G2_mulVec_single p, h, phi_single q]

lemma transfer_neg_rev {p q : Fin 28}
    (h : G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single q 1)) :
    G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single q 1) := by
  apply funphi_inj
  rw [← G2_mulVec_single p, h, phi_neg_single q]

/-- T4 (F10): the exact `(-1)`-fixed census and the explicit
component-flip partner map for the twelve two-cycles. -/
theorem G2_census_exact :
    -- exactly four `(-1)`-fixed states, at indices `{0,13,22,27}`
    (∀ p : Fin 28, (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single p 1))
        ↔ (p = 0 ∨ p = 13 ∨ p = 22 ∨ p = 27))
      -- every state maps to `±` its component-flip partner
      ∧ (∀ p : Fin 28,
          (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single (partner p) 1)
            ∨ (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single (partner p) 1)))
      -- and that partner is the UNIQUE target
      ∧ (∀ p q : Fin 28,
          ((G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single q 1)
            ∨ (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single q 1)))
          → q = partner p)
      -- the partner is a self-map exactly on the four same-site indices
      ∧ (∀ p : Fin 28, partner p = p ↔ (p = 0 ∨ p = 13 ∨ p = 22 ∨ p = 27)) := by
  refine ⟨?_, ?_, ?_, partner_fixed_g⟩
  · intro p
    rw [← census_fixed_g p]
    exact ⟨transfer_neg_rev, transfer_neg⟩
  · intro p
    rcases census_partner_g p with h | h
    · exact Or.inl (transfer_pos h)
    · exact Or.inr (transfer_neg h)
  · intro p q hpq
    apply census_unique_g p q
    rcases hpq with h | h
    · exact Or.inl (transfer_pos_rev h)
    · exact Or.inr (transfer_neg_rev h)

end PhysicsSM.Draft.NullEdge.Selection2Repairs
