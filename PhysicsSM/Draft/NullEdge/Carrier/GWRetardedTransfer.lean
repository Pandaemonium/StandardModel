import Mathlib

/-!
# Ginsparg–Wilson structure of inverted-by-involution transfer maps

An **involution that conjugates a transfer map to its inverse yields the
Ginsparg–Wilson relation with `R = 1/2`, exactly**, together with Lüscher's
exact deformed symmetry in one-step form.

Physics reading (kept in prose): the grading `G` is chirality composed with the
spatial reflection that reverses edge orientation; *retardation* of the transfer
makes the hypotheses `G² = 1` and `G V G = V⁻¹` hold.  The abstract lemma is the
one-step transfer form of the Ginsparg–Wilson relation (Ginsparg–Wilson, Phys.
Rev. D **25** (1982) 2649); the companion involution/symmetry identities are the
one-step form of Lüscher's exact lattice chiral symmetry (Lüscher, Phys. Lett. B
**428** (1998) 342).

## Contents

* `gw_of_involution_inverts` (GW-1): in any ring, if `G * G = 1` and
  `G * V * G = Vinv` with `Vinv` a two-sided inverse of `V`, then for the
  (unscaled) Dirac operator `D := 1 - V`,
  `G * D + D * G = D * G * D`.
  Absorbing the `1/eps` scaling, this is the Ginsparg–Wilson relation
  `{G, D} = D G D` (i.e. `{γ₅, D} = D γ₅ D`), the `R = 1/2` case.
* `deformed_involution`: `Ghat := G * V` is itself an involution, `Ghat² = 1`.
* `deformed_symmetry`: the exact one-step deformed (Lüscher) symmetry
  `D * Ghat = -(G * D)`.
* `gamma5_hermiticity`: in a star ring, if `V` is unitary (`star V * V = 1`),
  then `star D = G * D * G` (γ₅-hermiticity of `D`).
* `checkerboard_verification` (GW-2): an explicit, kernel-decidable 8×8 witness
  on `Fin 4 × Fin 2` (4 spatial sites on a ring × 2 chirality components) showing
  the grading `G` conjugates the transfer to its inverse, `G T G = T⁻¹`, for the
  **symmetric (palindromic / midpoint) ordering** `T = S · Cm · S`.  See the
  convention note at the concrete section for why the one-sided ordering
  `T = Cm · S` cannot satisfy an exact GW conjugation.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.GWTransfer

/-! ## GW-1: the abstract one-step transfer lemma -/

section Abstract

variable {A : Type*} [Ring A]

/-- **Key inversion identity.**  If `G * G = 1`, `Vinv * V = 1` and
`G * V * G = Vinv`, then the involution `G` conjugates `V` back through itself:
`V * G * V = G`.  (From `G * V * G = Vinv` one gets `V * G = G * Vinv`, whence
`V * G * V = G * Vinv * V = G`.) -/
theorem key_VGV (G V Vinv : A) (hGG : G * G = 1) (hVl : Vinv * V = 1)
    (hconj : G * V * G = Vinv) : V * G * V = G := by
  have hVG : V * G = G * Vinv := by
    have h := congrArg (fun z => G * z) hconj
    simp only [← mul_assoc, hGG, one_mul] at h
    exact h
  calc V * G * V = G * Vinv * V := by rw [hVG]
    _ = G * (Vinv * V) := by rw [mul_assoc]
    _ = G := by rw [hVl, mul_one]

/-- **GW-1 (Ginsparg–Wilson relation, `R = 1/2`).**  Let `G` be an involution
(`G * G = 1`) that conjugates the transfer/propagator `V` to its inverse
(`G * V * G = Vinv`, with `Vinv` a two-sided inverse of `V`).  Then the unscaled
Dirac operator `D := 1 - V` obeys the Ginsparg–Wilson relation in one-step
transfer form,
`G * D + D * G = D * G * D`,
i.e. `{G, D} = D G D`.  Restoring the lattice scale `D = (1 - V)/eps` reproduces
`{γ₅, D} = eps · D γ₅ D`, the `R = 1/2` Ginsparg–Wilson relation. -/
theorem gw_of_involution_inverts (G V Vinv : A) (hGG : G * G = 1) (hVl : Vinv * V = 1)
    (hconj : G * V * G = Vinv) :
    G * (1 - V) + (1 - V) * G = (1 - V) * G * (1 - V) := by
  have hk : V * G * V = G := key_VGV G V Vinv hGG hVl hconj
  have expand : (1 - V) * G * (1 - V)
      = G * (1 - V) + (1 - V) * G - (G - V * G * V) := by noncomm_ring
  rw [expand, hk]; simp

/-- **Deformed involution (Lüscher).**  The deformed grading `Ghat := G * V`
is again an involution: `Ghat * Ghat = 1`.  (Indeed
`(G V)(G V) = (G V G) V = Vinv V = 1`.) -/
theorem deformed_involution (G V Vinv : A) (hVl : Vinv * V = 1)
    (hconj : G * V * G = Vinv) : (G * V) * (G * V) = 1 := by
  have h : (G * V) * (G * V) = (G * V * G) * V := by noncomm_ring
  rw [h, hconj, hVl]

/-- **Exact one-step deformed symmetry (Lüscher).**  With `Ghat := G * V` and
`D := 1 - V`, the exact deformed chiral symmetry holds with *no* correction
terms: `D * Ghat = -(G * D)`.  (Both sides equal `Ghat - G = G*V - G`:
`D * Ghat = (1 - V) G V = G V - V G V = G V - G` using `V G V = G`, while
`-(G * D) = -(G - G V) = G V - G`.) -/
theorem deformed_symmetry (G V Vinv : A) (hGG : G * G = 1) (hVl : Vinv * V = 1)
    (hconj : G * V * G = Vinv) : (1 - V) * (G * V) = -(G * (1 - V)) := by
  have hk : V * G * V = G := key_VGV G V Vinv hGG hVl hconj
  have expand : (1 - V) * (G * V) = -(G * (1 - V)) + (G - V * G * V) := by noncomm_ring
  rw [expand, hk]; simp

end Abstract

/-! ## γ₅-hermiticity in a star ring -/

section Star

variable {A : Type*} [Ring A] [StarRing A]

/-- **γ₅-hermiticity of the GW Dirac operator.**  In a star ring, if `V` is
unitary (`star V * V = 1`, with `V * Vinv = 1`) and `G * V * G = Vinv` with `G`
an involution (`G * G = 1`), then `D := 1 - V` is γ₅-hermitian:
`star D = G * D * G`.

The physical case carries additionally `star G = G` (`G` a fundamental symmetry,
`γ₅ = γ₅†`), but that hypothesis turned out to be UNNECESSARY for this purely
algebraic identity, which follows from unitarity of `V` alone:
`star V = Vinv = G V G`, hence
`star (1 - V) = 1 - Vinv = G G - G V G = G (1 - V) G`. The theorem is stated in
the stronger hypothesis-free form; the physical situation is an instance. -/
theorem gamma5_hermiticity (G V Vinv : A) (hGG : G * G = 1)
    (hunit : star V * V = 1) (hVr : V * Vinv = 1) (hconj : G * V * G = Vinv) :
    star (1 - V) = G * (1 - V) * G := by
  have hstarV : star V = Vinv := by
    calc star V = star V * (V * Vinv) := by rw [hVr, mul_one]
      _ = (star V * V) * Vinv := by rw [mul_assoc]
      _ = Vinv := by rw [hunit, one_mul]
  have hRHS : G * (1 - V) * G = 1 - Vinv := by
    have h : G * (1 - V) * G = G * G - G * V * G := by noncomm_ring
    rw [h, hGG, hconj]
  rw [hRHS, star_sub, star_one, hstarV]

end Star

/-! ## GW-2: explicit 8×8 checkerboard verification

We work on the 8-dimensional space `V8 := Fin 4 × Fin 2`: 4 spatial sites on a
periodic ring times 2 chirality (right/left mover) components, over `ℝ` with two
formal parameters `c = cos θ`, `s = sin θ`.

**Convention note (important).**  The naive *one-sided* transfer `T = Cm · S`
can **never** satisfy an exact GW conjugation `G T G = T⁻¹`: conjugation by an
involution is an algebra automorphism and *preserves* operator order, whereas
inversion *reverses* it, `T⁻¹ = S⁻¹ Cm⁻¹ ≠ Cm⁻¹ S⁻¹`.  The physical midpoint
(checkerboard) transfer `T = S^{1/2} Cm S^{1/2}` is *palindromic*, and the
palindrome is what makes the identity exact.  On the integer lattice the exact
half-shift is unavailable, so we use the honest full-shift palindrome
`T := S · Cm · S`, whose inverse `T⁻¹ = S⁻¹ · Cm⁻¹ · S⁻¹` is again a palindrome
and is reproduced *exactly* by the conjugation.  This is the correct structural
statement of the midpoint convention on the integer ring.

The grading is `Gr = P · Z`, where `P` is the spatial reflection `x ↦ -x` and `Z`
is `σ_z` at each site (chirality = ±1).  The two building blocks are:

* `Gr * S * Gr = S⁻¹` (reflection reverses the shift direction);
* `Gr * Cm * Gr = Cm⁻¹` (`σ_z` conjugation sends the rotation angle `θ ↦ -θ`).

Neither uses `c² + s² = 1`; the Pythagorean identity is needed only to certify
that the explicit `T⁻¹` really is the inverse (`T * T⁻¹ = 1`). -/

open Matrix

/-- Carrier of the concrete model: 4 spatial sites × 2 chirality components. -/
abbrev V8 := Fin 4 × Fin 2

/-- Spatial shift by `+1` on the ring `Fin 4`. -/
def rot1 : Fin 4 → Fin 4 := ![1, 2, 3, 0]
/-- Spatial shift by `-1` on the ring `Fin 4`. -/
def rotm1 : Fin 4 → Fin 4 := ![3, 0, 1, 2]
/-- Spatial reflection `x ↦ -x` on the ring `Fin 4`. -/
def refl4 : Fin 4 → Fin 4 := ![0, 3, 2, 1]

/-- The grading `Gr = P · Z`: spatial reflection composed with `σ_z` at each
site (an explicit 8×8 signed permutation matrix). -/
def gradeMat : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.1 = refl4 j.1 then (if i.2 = j.2 then (if j.2 = 0 then (1 : ℝ) else -1) else 0) else 0

/-- The shift `S`: right movers (`chirality 0`) shift by `+1`, left movers
(`chirality 1`) shift by `-1`.  An explicit 8×8 permutation matrix. -/
def shiftMat : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.2 = j.2 then (if i.1 = (if j.2 = 0 then rot1 j.1 else rotm1 j.1) then (1 : ℝ) else 0) else 0

/-- The inverse shift `S⁻¹`: right movers shift by `-1`, left movers by `+1`. -/
def shiftInvMat : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.2 = j.2 then (if i.1 = (if j.2 = 0 then rotm1 j.1 else rot1 j.1) then (1 : ℝ) else 0) else 0

/-- The corner rotation `Cm`: block-diagonal `[[c, -s], [s, c]]` mixing the two
chirality components at each spatial site. -/
def rotMat (c s : ℝ) : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.1 = j.1 then (if i.2 = j.2 then c else (if i.2 = 0 then -s else s)) else 0

/-- The inverse rotation `Cm⁻¹`: the corner rotation with `θ ↦ -θ`
(`[[c, s], [-s, c]]`). -/
def rotInvMat (c s : ℝ) : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.1 = j.1 then (if i.2 = j.2 then c else (if i.2 = 0 then s else -s)) else 0

/-- The symmetric (palindromic / midpoint) checkerboard transfer `T = S · Cm · S`. -/
def transferMat (c s : ℝ) : Matrix V8 V8 ℝ := shiftMat * rotMat c s * shiftMat

/-- The explicit inverse transfer `T⁻¹ = S⁻¹ · Cm⁻¹ · S⁻¹`. -/
def transferInvMat (c s : ℝ) : Matrix V8 V8 ℝ := shiftInvMat * rotInvMat c s * shiftInvMat

/-- `Gr` is an involution: `Gr * Gr = 1`. -/
theorem gradeMat_involutive : gradeMat * gradeMat = (1 : Matrix V8 V8 ℝ) := by
  ext i j
  obtain ⟨⟨x, hx⟩, c⟩ := i
  obtain ⟨⟨y, hy⟩, d⟩ := j
  fin_cases c <;> fin_cases d <;>
    (interval_cases x <;> interval_cases y <;>
      simp [gradeMat, Matrix.mul_apply, refl4, Fintype.sum_prod_type])

/-- Reflection reverses the shift: `Gr * S = S⁻¹ * Gr`. -/
theorem gradeMat_shift_comm : gradeMat * shiftMat = shiftInvMat * gradeMat := by
  ext i j
  obtain ⟨⟨x, hx⟩, c⟩ := i
  obtain ⟨⟨y, hy⟩, d⟩ := j
  fin_cases c <;> fin_cases d <;>
    (interval_cases x <;> interval_cases y <;>
      simp [gradeMat, shiftMat, shiftInvMat, Matrix.mul_apply, refl4, rot1, rotm1,
        Fintype.sum_prod_type])

/-- `σ_z` conjugation flips the rotation angle: `Gr * Cm = Cm⁻¹ * Gr`. -/
theorem gradeMat_rot_comm (c s : ℝ) :
    gradeMat * rotMat c s = rotInvMat c s * gradeMat := by
  ext i j
  obtain ⟨⟨x, hx⟩, cc⟩ := i
  obtain ⟨⟨y, hy⟩, d⟩ := j
  fin_cases cc <;> fin_cases d <;>
    (interval_cases x <;> interval_cases y <;>
      simp [gradeMat, rotMat, rotInvMat, Matrix.mul_apply, refl4, Fintype.sum_prod_type])

/-- `Gr` conjugates the shift to its inverse: `Gr * S * Gr = S⁻¹`. -/
theorem gradeMat_conj_shift : gradeMat * shiftMat * gradeMat = shiftInvMat := by
  rw [gradeMat_shift_comm, mul_assoc, gradeMat_involutive, mul_one]

/-- `Gr` conjugates the rotation to its inverse: `Gr * Cm * Gr = Cm⁻¹`. -/
theorem gradeMat_conj_rot (c s : ℝ) :
    gradeMat * rotMat c s * gradeMat = rotInvMat c s := by
  rw [gradeMat_rot_comm, mul_assoc, gradeMat_involutive, mul_one]

/-- Conjugation of a triple product by an involution `g` (`g * g = 1`). -/
theorem conj_triple {A : Type*} [Ring A] (g a b d : A) (hg : g * g = 1) :
    g * (a * b * d) * g = (g * a * g) * (g * b * g) * (g * d * g) := by
  have h : (g * a * g) * (g * b * g) * (g * d * g)
      = g * a * (g * g) * b * (g * g) * d * g := by noncomm_ring
  rw [h, hg]; noncomm_ring

/-- **GW-2 (checkerboard kill-check, exact).**  On the explicit 8×8 model the
grading `Gr` conjugates the symmetric (palindromic / midpoint) transfer
`T = S · Cm · S` to its inverse `T⁻¹ = S⁻¹ · Cm⁻¹ · S⁻¹`:
`Gr * T * Gr = T⁻¹`.  This is the exact one-step Ginsparg–Wilson conjugation
identity in the honest midpoint convention; no `c² + s² = 1` is needed. -/
theorem checkerboard_verification (c s : ℝ) :
    gradeMat * transferMat c s * gradeMat = transferInvMat c s := by
  rw [transferMat, transferInvMat,
      conj_triple gradeMat shiftMat (rotMat c s) shiftMat gradeMat_involutive,
      gradeMat_conj_shift, gradeMat_conj_rot]

/-- The shift is a genuine permutation: `S * S⁻¹ = 1`. -/
theorem shift_mul_inv : shiftMat * shiftInvMat = (1 : Matrix V8 V8 ℝ) := by
  ext i j
  obtain ⟨⟨x, hx⟩, c⟩ := i
  obtain ⟨⟨y, hy⟩, d⟩ := j
  fin_cases c <;> fin_cases d <;>
    (interval_cases x <;> interval_cases y <;>
      simp [shiftMat, shiftInvMat, Matrix.mul_apply, rot1, rotm1,
        Fintype.sum_prod_type])

/-- The rotation is invertible with the stated inverse when `c² + s² = 1`. -/
theorem rot_mul_inv (c s : ℝ) (hpyth : c ^ 2 + s ^ 2 = 1) :
    rotMat c s * rotInvMat c s = (1 : Matrix V8 V8 ℝ) := by
  ext i j
  obtain ⟨⟨x, hx⟩, cc⟩ := i
  obtain ⟨⟨y, hy⟩, d⟩ := j
  fin_cases cc <;> fin_cases d <;>
    (interval_cases x <;> interval_cases y <;>
      simp [rotMat, rotInvMat, Matrix.mul_apply, Fintype.sum_prod_type] <;>
      nlinarith [hpyth])

/-- **The explicit `transferInvMat` really is the inverse** of `transferMat`
(right inverse), provided `c² + s² = 1`.  Hence `Gr T Gr = T⁻¹` above is a bona
fide GW conjugation-to-inverse identity. -/
theorem transfer_mul_inv (c s : ℝ) (hpyth : c ^ 2 + s ^ 2 = 1) :
    transferMat c s * transferInvMat c s = (1 : Matrix V8 V8 ℝ) := by
  have hS := shift_mul_inv
  have hR := rot_mul_inv c s hpyth
  calc transferMat c s * transferInvMat c s
      = shiftMat * rotMat c s * (shiftMat * shiftInvMat) * rotInvMat c s * shiftInvMat := by
        simp only [transferMat, transferInvMat]; noncomm_ring
    _ = shiftMat * (rotMat c s * rotInvMat c s) * shiftInvMat := by
        rw [hS]; noncomm_ring
    _ = shiftMat * shiftInvMat := by rw [hR]; noncomm_ring
    _ = 1 := hS

end PhysicsSM.Draft.NullEdge.Carrier.GWTransfer
