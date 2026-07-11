import Mathlib
import PhysicsSM.Draft.NullEdge.ChiralFlipMode

/-!
# Sign-wall Plücker defect: the Route-A design package (Paper C, pillar 3)

Companion Lean statements for `DEFECT_MODE_DESIGN.md`.  This file states the
design of the sign-wall walk `W(z)`, the determinant law, the localization
witness, the trap check, and the controls, as **typechecking Lean 4
statements** ready for a follow-up proof job (holes allowed; the decisive
facts and the concrete witnesses are proved outright by `decide`).

The headline design finding (proved / verified below) is a **kill report for
Route A as literally planned**:

* In the *chiral* (palindromic) form `W = S · C · S` the determinant
  factorises as `det W = det C · (det S)^2`, and for any **value-derived**
  rotation coin `C` this is identically `+1`, for **every** boundary
  condition and **every** wall count (`signWalk_det_eq_one`).  The
  determinant is structurally blind to the wall.
* The included edge-reversal grading `Γ` is a `ChiralInvolution` for `W(z)`
  **iff the coin field is reflection-symmetric** (`signWalk_chiral_of_sym`);
  a lone interior wall breaks reflection symmetry, so admissible walls come
  in mirror pairs — an *even* count — consistent with the K6 `det = +1`
  finding.
* `det W(z) = -1` is reachable only by inserting a genuine `det = -1`
  (reflection / `σ_x`) coin **by hand** at the wall (`assignedWall_*`
  below): that is *hand-supplied branch data*, which the pillar-1
  derived-vs-assigned discipline forbids.  So Route A is either
  determinant-trivial (derived) or off-discipline (assigned).

The genuine protected `±1` mode is therefore a **boundary / domain-wall
(Jackiw–Rebbi–SSH) phenomenon**, read by the reflection-sectored index
(Route B), *not* by the global determinant.  The abstract flip-mode engine
(`ChiralFlipModeSeed`) still fires **per reflection sector** or on the open
chain; the exact single-site localized mode is exhibited on the assigned
witness (`assignedWall_flip_mode`).

All matrices act on the register `Car L = ZMod L × Fin 2`
(spatial site × chirality).  Over `ℝ`/`ℂ` the chiral condition
`Γ W Γ = Wᴴ` reads with the conjugate transpose; the concrete witnesses are
stated over `ℚ` (where `ᴴ = ᵀ`) so that they discharge by `decide`.

Provenance: pillar-3 design and Route-A determinant kill by Aristotle
project `b407e2d5` (design job); Route-B holes closed and composed with the
flip-mode engine by Aristotle project `935b009b-7731-49c2-8cff-85c7afe73eda`
(run `7f42a1b4`); statements per the composed-job specification, engine file
unmodified; integrated with local kernel re-check.  The concrete derived
one-wall sector instantiation (explicit isometries, per-sector determinants
`-1`) is the remaining C-gate rung and is NOT claimed here.  Documented
`native_decide` uses (K6 control and Assigned witnesses) are draft-trust per
repo policy; the general theorems and Route-B composition are kernel-clean.
-/

open Matrix Complex

noncomputable section

/-! ## 0.  Chiral involution (reproduced from the project core) -/

/-- A **chiral involution** for `W`: a self-inverse `G` conjugating `W` to
its adjoint.  For unitary `W` this is the reciprocal-pairing (chiral)
symmetry `G W G = W⁻¹`.  (Same structure as
`ChiralZeroModeParity.ChiralInvolution` / `PhysicsSM.Draft.NullEdge.ChiralFlipMode.ChiralInvolution`.) -/
structure ChiralInvolution {m : Type*} [Fintype m] [DecidableEq m]
    (W G : Matrix m m ℂ) : Prop where
  invol : G * G = 1
  chiral : G * W * G = Wᴴ

namespace SignWallDefect

/-! ## 1.  The walk `W(z)` (general, site-dependent, exactly unitary)

Register: `Car L = ZMod L × Fin 2` (ring of `L` sites × 2 chirality
channels).  Factor ordering is the **symmetric / palindromic** transfer
`W = S · C(z) · S`, the *only* ordering that admits an exact chiral
conjugation to the inverse with the edge-reversal grading
(see `GWRetardedTransfer`).  The coin `C(z)` is a per-site rotation whose
angle is a fixed function of the field **value** `z p` — no branch data. -/

variable {L : ℕ} [NeZero L]

/-- Carrier: spatial site on the ring `ZMod L`, times a 2-valued chirality. -/
abbrev Car (L : ℕ) := ZMod L × Fin 2

/-- Spatial reflection `p ↦ -p` on the ring. -/
def reflZ (p : ZMod L) : ZMod L := -p

/-- The **edge-reversal grading** `Γ = P · σ_z`: spatial reflection composed
with `σ_z` on the chirality index (an explicit signed permutation).  This is
the `ZMod L` generalisation of `GWRetardedTransfer.gradeMat`. -/
def gradeM : Matrix (Car L) (Car L) ℂ := Matrix.of fun i j =>
  if i.1 = reflZ j.1 then (if i.2 = j.2 then (if j.2 = 0 then (1 : ℂ) else -1) else 0) else 0

/-- The **conditional shift** `S`: chirality `0` hops `+1`, chirality `1`
hops `-1` (a permutation, hence exactly unitary). -/
def shiftM : Matrix (Car L) (Car L) ℂ := Matrix.of fun i j =>
  if i.2 = j.2 then (if i.1 = (if j.2 = 0 then j.1 + 1 else j.1 - 1) then (1 : ℂ) else 0) else 0

/-- The **rotation coin** `C(a)`: per-site `SO(2)` block `[[cos, -sin],
[sin, cos]]` at angle `a p`.  A rotation always has determinant `+1`. -/
def coinM (a : ZMod L → ℝ) : Matrix (Car L) (Car L) ℂ := Matrix.of fun i j =>
  if i.1 = j.1 then
    (if i.2 = j.2 then (Real.cos (a i.1) : ℂ)
     else (if i.2 = 0 then (-(Real.sin (a i.1)) : ℂ) else (Real.sin (a i.1) : ℂ))) else 0

/-- The coin **angle derived from the field values only** (no supplied branch
data): `a p = arg (z p)`.  For a real field the argument is `0` or `π`,
so the coin is `R(0) = 1` or `R(π) = -1` — always determinant `+1`. -/
def coinAngle (z : ZMod L → ℂ) : ZMod L → ℝ := fun p => Complex.arg (z p)

/-- **The sign-wall walk** `W(z) = S · C(z) · S`. -/
def signWalk (z : ZMod L → ℂ) : Matrix (Car L) (Car L) ℂ :=
  shiftM * coinM (coinAngle z) * shiftM

/-! ## 2.  (a) Chirality, and (b) the determinant kill law -/

/-
**(a) Edge-reversal chirality.**  When the derived coin field is
reflection-symmetric (`a (-p) = a p`, i.e. walls come in mirror pairs) the
grading `Γ` is a chiral involution for `W(z)`.  (Verified over `ℚ`; a lone
interior wall breaks this hypothesis — see the discussion in the memo.)
-/
theorem signWalk_chiral_of_sym (z : ZMod L → ℂ)
    (hsym : ∀ p, coinAngle z (-p) = coinAngle z p) :
    ChiralInvolution (signWalk z) gradeM := by
  constructor;
  · ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; simp +decide [ gradeM, Matrix.mul_apply ];
    rw [ Finset.sum_eq_single ( reflZ k, l ) ] <;> simp +decide [ Matrix.one_apply ];
    · unfold reflZ; aesop;
    · grind;
  · -- We now verify the chirality condition `Γ * W * Γ = Wᴴ`.
    -- Write out the matrices `W = S C S` and expand the triple product.
    ext ⟨x,c⟩ ⟨y,d⟩;
    simp [signWalk, gradeM, shiftM, coinM, reflZ, Matrix.mul_apply, Fintype.sum_prod_type, Matrix.conjTranspose_apply];
    fin_cases c <;> fin_cases d <;> simp +decide [ Finset.sum_ite ];
    · split_ifs <;> simp_all +decide [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos ];
      norm_num [ Complex.normSq, Complex.div_re, Complex.div_im, Complex.exp_re, Complex.exp_im ] ; ring_nf;
      rw [ show -1 - x = - ( 1 + x ) by ring, hsym ];
    · split_ifs <;> simp_all +decide [ Complex.ext_iff, Complex.sin_ofReal_re, Complex.sin_ofReal_im ];
      rw [ ← hsym ] ; ring;
    · split_ifs <;> simp_all +decide [ Complex.ext_iff ];
      rw [ show -x + 1 = - ( x - 1 ) by ring, hsym ];
    · split_ifs <;> simp_all +decide [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos ];
      norm_num [ Complex.normSq, Complex.div_re, Complex.div_im, Complex.exp_re, Complex.exp_im ] ; ring;
      rw [ show 1 - x = - ( -1 + x ) by ring, hsym ]

/-- **Determinant factorisation.**  The palindromic ordering makes the shift
appear squared: `det W = det C · (det S)^2`.  This is the algebraic root of
the determinant kill. -/
theorem signWalk_det_factor (z : ZMod L → ℂ) :
    (signWalk z).det = (coinM (coinAngle z)).det * (shiftM (L := L)).det ^ 2 := by
  unfold signWalk
  rw [Matrix.det_mul, Matrix.det_mul]; ring

/-
The rotation coin has determinant `1` (product of `cos² + sin² = 1`
blocks).
-/
theorem coinM_det_eq_one (a : ZMod L → ℝ) : (coinM a).det = 1 := by
  -- The matrix `coinM a` is diagonal with `2x2` rotation blocks on the diagonal.
  have h_coin_diag : ∀ p : ZMod L, ∀ i j : Fin 2, coinM a (p, i) (p, j) = !![Complex.cos (a p), -Complex.sin (a p); Complex.sin (a p), Complex.cos (a p)] i j := by
    simp +decide [ Fin.forall_fin_two, coinM ];
  -- The determinant of a block diagonal matrix is the product of the determinants of the diagonal blocks.
  have h_det_block_diag : ∀ (b : ZMod L → Matrix (Fin 2) (Fin 2) ℂ), (Matrix.det (Matrix.of (fun i j : ZMod L × Fin 2 => if i.1 = j.1 then b i.1 i.2 j.2 else 0))) = ∏ p : ZMod L, Matrix.det (b p) := by
    intro b;
    erw [ ← Matrix.det_reindex_self ( Equiv.prodComm _ _ ) ];
    convert Matrix.det_blockDiagonal _;
  convert h_det_block_diag ( fun p => !![Complex.cos ( a p ), -Complex.sin ( a p ); Complex.sin ( a p ), Complex.cos ( a p ) ] ) using 1;
  · congr ; ext i j ; by_cases hij : i.1 = j.1 <;> simp +decide;
    · convert h_coin_diag i.1 i.2 j.2 using 1;
      · grind;
      · cases i.2 ; cases j.2 ; aesop;
    · unfold coinM; aesop;
  · norm_num [ ← sq, Real.cos_sq' ]

/-
The conditional shift is a permutation matrix, so `det S = ±1` and hence
`(det S)^2 = 1`.
-/
theorem shiftM_det_sq_eq_one : (shiftM (L := L)).det ^ 2 = 1 := by
  -- Since shiftM is a permutation matrix, it's orthogonal. Therefore, its transpose is its inverse.
  have h_orthogonal : (shiftM : Matrix (Car L) (Car L) ℂ).transpose * shiftM = 1 := by
    ext ⟨i, j⟩ ⟨k, l⟩; simp +decide [ shiftM, Matrix.mul_apply ] ;
    fin_cases j <;> fin_cases l <;> simp +decide [ Matrix.one_apply ];
    · rw [ Finset.sum_eq_single ( k + 1, 0 ) ] <;> aesop;
    · rw [ Finset.sum_eq_zero ] ; aesop;
    · exact Finset.sum_eq_zero fun x hx => by aesop;
    · rw [ Finset.sum_eq_single ( k - 1, 1 ) ] <;> aesop;
  apply_fun Matrix.det at h_orthogonal ; simp_all +decide [ sq ]

/-- **(b) The determinant kill law.**  For **every** field `z` and **every**
boundary condition the value-derived sign-wall walk has `det W(z) = +1`.
The determinant is blind to the wall count: Route A's determinant carries no
wall-parity information.  (Follows from the three lemmas above.) -/
theorem signWalk_det_eq_one (z : ZMod L → ℂ) : (signWalk z).det = 1 := by
  rw [signWalk_det_factor, coinM_det_eq_one, shiftM_det_sq_eq_one, one_mul]

/-- **(b′) No forced flip mode from the determinant.**  Because `det W = +1`,
the flip-mode engine (`PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_det_neg_one_forces_flip_mode`,
which needs `det = -1`) does **not** apply globally: there is no
determinant-forced `-1` eigenvector.  Stated as the honest negative: the
`det = -1` hypothesis is never met by a derived sign-wall walk. -/
theorem signWalk_det_ne_neg_one (z : ZMod L → ℂ) : (signWalk z).det ≠ -1 := by
  rw [signWalk_det_eq_one]; norm_num

/-! ## 3.  (d) trap check: `W(z)` consumes `z` only through its values -/

/-- **Derived-vs-assigned trap check.**  `W(z)` factors through the values
`fun p => z p`: two fields with identical values give identical walks.  No
hand-supplied branch/link data enters, so the pillar-1 derivation theorems
(which produce `z` from a primitive spinor pair) compose with `signWalk`. -/
theorem signWalk_value_only (z w : ZMod L → ℂ) (h : ∀ p, z p = w p) :
    signWalk z = signWalk w := by
  have : z = w := funext h; rw [this]

/-! ## 4.  (e) Zero-wall control (constant field), concrete on `L = 4` over `ℚ`

Everything below is over `ℚ`, where the chiral condition reads `Γ W Γ = Wᵀ`,
so the statements discharge by `decide`.  These mirror the general `ℂ`
definitions on the K6 four-site register. -/

namespace Concrete

abbrev V8 := Fin 4 × Fin 2

/-- Right/left conditional shifts on `Fin 4` (the periodic-ring shift). -/
def rot1 : Fin 4 → Fin 4 := ![1, 2, 3, 0]
def rotm1 : Fin 4 → Fin 4 := ![3, 0, 1, 2]

def shiftQ : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.2 = j.2 then (if i.1 = (if j.2 = 0 then rot1 j.1 else rotm1 j.1) then (1 : ℚ) else 0) else 0

def refl4 : Fin 4 → Fin 4 := ![0, 3, 2, 1]

def gradeQ : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = refl4 j.1 then (if i.2 = j.2 then (if j.2 = 0 then (1 : ℚ) else -1) else 0) else 0

/-- Constant `3-4-5` rotation coin at every site (the **zero-wall control**
field: constant `z`, no sign change). -/
def coinQ (c s : Fin 4 → ℚ) : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = j.1 then (if i.2 = j.2 then c i.1 else (if i.2 = 0 then - s i.1 else s i.1)) else 0

def walkQ (c s : Fin 4 → ℚ) : Matrix V8 V8 ℚ := shiftQ * coinQ c s * shiftQ

/-- The `3-4-5` constant coin. -/
def c345 : Fin 4 → ℚ := fun _ => 4 / 5
def s345 : Fin 4 → ℚ := fun _ => 3 / 5

/-- **(e) Control — exact unitarity.**  The zero-wall walk is exactly
unitary. -/
theorem control_unitary : (walkQ c345 s345)ᵀ * walkQ c345 s345 = 1 := by
  native_decide

/-- **(e) Control — grade is an involution.** -/
theorem control_grade_involution : gradeQ * gradeQ = 1 := by
  native_decide

/-- **(e) Control — exact edge-reversal chirality** `Γ W Γ = Wᵀ`
(the `ℚ` reading of `Γ W Γ = Wᴴ`). -/
theorem control_chiral : gradeQ * walkQ c345 s345 * gradeQ = (walkQ c345 s345)ᵀ := by
  native_decide

/-
**(e) Control — no forced flip mode.**  The determinant of the control
walk is `+1` (factorisation `det = det C · (det S)²`), so no `-1` mode is
forced.  (Determinant left as a hole; `decide` on an `8×8` Leibniz
determinant is infeasible, but the general `signWalk_det_eq_one` route
applies.)
-/
theorem control_det_eq_one : (walkQ c345 s345).det = 1 := by
  convert congr_arg Matrix.det control_unitary using 1;
  · norm_num [ walkQ ];
    unfold shiftQ coinQ; norm_num [ Matrix.det_apply' ] ;
    rw [ show ( ∑ x : Equiv.Perm ( Fin 4 × Fin 2 ), ( Equiv.Perm.sign x : ℚ ) * ∏ x_1 : Fin 4 × Fin 2, if ( x x_1 ).2 = x_1.2 then if ( x x_1 ).1 = if x_1.2 = 0 then rot1 x_1.1 else rotm1 x_1.1 then 1 else 0 else 0 ) = 1 by native_decide ] ; ring;
    rw [ show ( ∑ x : Equiv.Perm ( Fin 4 × Fin 2 ), ( Equiv.Perm.sign x : ℚ ) * ∏ x_1 : Fin 4 × Fin 2, if ( x x_1 ).1 = x_1.1 then if ( x x_1 ).2 = x_1.2 then c345 ( x x_1 ).1 else if ( x x_1 ).2 = 0 then -s345 ( x x_1 ).1 else s345 ( x x_1 ).1 else 0 ) = 1 by native_decide ] ; norm_num;
  · norm_num [ Matrix.det_one ]

end Concrete

/-! ## 5.  (c)/(d) The localized flip mode: the ASSIGNED wall witness

To obtain `det = -1` and an exact localized mode one must insert a genuine
`det = -1` reflection (`σ_x`) coin **at the wall site** — *hand-supplied*
data that the derived construction does not produce (a real field gives a
rotation coin, `det = +1`).  This witness therefore lives **outside** the
derived-vs-assigned discipline; it is included to exhibit exactly what the
protected mode looks like.

Three sites `Fin 3 × Fin 2` (open cell): bulk sites `0,2` carry a `3-4-5`
rotation, the wall site `1` carries `σ_x`.  Grading: `σ_z` on bulk sites,
`σ_x` on the wall site (site-dependent grading — the `[R,Γ]=0` sectoring of
Route B in miniature). -/

namespace Assigned

abbrev V6 := Fin 3 × Fin 2

/-- Walk: `σ_x` at the wall site `1` (determinant `-1`), `3-4-5` rotation at
bulk sites `0,2`. -/
def Wc : Matrix V6 V6 ℚ := Matrix.of fun i j =>
  if i.1 = j.1 then
    (if i.1 = 1 then (if i.2 = j.2 then 0 else 1)
     else (if i.2 = j.2 then 4 / 5 else (if i.2 = 0 then -3 / 5 else 3 / 5)))
  else 0

/-- Grading: `σ_x` at the wall site `1`, `σ_z` at bulk sites `0,2`. -/
def Gc : Matrix V6 V6 ℚ := Matrix.of fun i j =>
  if i.1 = j.1 then
    (if i.1 = 1 then (if i.2 = j.2 then 0 else 1)
     else (if i.2 = j.2 then (if i.2 = 0 then 1 else -1) else 0))
  else 0

/-- The wall grading is an involution. -/
theorem assignedWall_grade_involution : Gc * Gc = 1 := by native_decide

/-- **Exact edge chirality** `Γ W Γ = Wᵀ` for the assigned wall walk. -/
theorem assignedWall_chiral : Gc * Wc * Gc = Wcᵀ := by native_decide

/-- **Exact unitarity** of the assigned wall walk. -/
theorem assignedWall_unitary : Wcᵀ * Wc = 1 := by native_decide

/-- The exact `-1` eigenvector, supported on the single wall site. -/
def vflip : V6 → ℚ := fun p => if p = (1, 0) then 1 else if p = (1, 1) then -1 else 0

/-- The exact `+1` partner eigenvector, also supported on the wall site. -/
def vfix : V6 → ℚ := fun p => if p = (1, 0) then 1 else if p = (1, 1) then 1 else 0

/-- **(c)/(d) Protected flip mode, exactly localized at the wall.**  The
assigned wall walk has an exact `-1` eigenvector supported on the single
wall site (amplitude profile `(1,-1)` there, `0` elsewhere). -/
theorem assignedWall_flip_mode :
    Wc.mulVec vflip = -vflip ∧ (vflip ≠ 0) := by
  refine ⟨?_, ?_⟩
  · native_decide
  · native_decide

/-- **(c)/(d) Partner `+1` mode, exactly localized at the wall.** -/
theorem assignedWall_fixed_mode :
    Wc.mulVec vfix = vfix ∧ (vfix ≠ 0) := by
  refine ⟨?_, ?_⟩
  · native_decide
  · native_decide

/-- **The assigned wall carries `det = -1`.**  `det W = det(R) · det(σ_x) ·
det(R) = 1 · (-1) · 1 = -1`: the single hand-inserted reflection coin flips
the determinant.  Proved by compiled evaluation of the `6×6` determinant. -/
theorem assignedWall_det_eq_neg_one : Wc.det = -1 := by
  native_decide

end Assigned

/-! ## 6.  Route B (reflection-sectored index) — statements to prove

The genuine invariant.  `W` commutes with a reflection `R` (leg-reversal),
`R² = 1`, `[R, Γ] = 0`.  The register splits into `R = ±1` sectors; `Γ`
and `W` preserve each sector, so `(W, Γ)` restricts to a chiral involution
per sector.  The **per-sector** determinant can be `-1` (forcing a mode in
that sector by the flip engine) while the **global** determinant stays `+1`,
respecting the K6 even-wall finding.  The sector index
`ν = ±(1/4) tr(Γ R)` is a Lefschetz fixed-point count (independent of the
hop amplitude). -/

namespace RouteB

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- A **reflection sectoring** compatible with the chiral involution. -/
structure Sectoring (W G R : Matrix m m ℂ) : Prop where
  chi   : ChiralInvolution W G
  unit  : Wᴴ * W = 1
  rinv  : R * R = 1
  rW    : R * W = W * R
  rG    : R * G = G * R

/-- **B0 (global determinant unchanged).**  Under a reflection sectoring the
global determinant is still `±1` (the landed core), and — for the derived
walk — `+1`; the reflection carries the extra information. -/
theorem routeB_global_det_pm_one {W G R : Matrix m m ℂ}
    (h : Sectoring W G R) : W.det = 1 ∨ W.det = -1 := by
  -- Convert to the engine's chiral-involution structure and use its
  -- determinant-parity theorem `det W = (-1) ^ (mult of the root -1)`.
  have hci : PhysicsSM.Draft.NullEdge.ChiralFlipMode.ChiralInvolution W G :=
    ⟨h.chi.invol, h.chi.chiral⟩
  have hdet :=
    PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_unitary_det_eq_neg_one_pow hci h.unit
  rcases Nat.even_or_odd (W.charpoly.roots.count (-1)) with he | ho
  · exact Or.inl (by rw [hdet, he.neg_one_pow])
  · exact Or.inr (by rw [hdet, ho.neg_one_pow])

/-- **Sector chiral-unitary reduction.**  Given an isometry `B` (`Bᴴ * B = 1`)
whose columns are mapped into themselves by `W` and `G` via the conjugated
operators `Wplus`, `Gplus` (`W * B = B * Wplus`, `G * B = B * Gplus`), the
conjugated pair `(Wplus, Gplus)` is itself a chiral-unitary pair on the
smaller index type.  This is the honest sector-restriction step: `Wplus` is
literally `Bᴴ * W * B` (the compression of `W` to the sector spanned by `B`),
not a placeholder. -/
theorem sector_chiral_unitary {k : ℕ}
    {W G : Matrix m m ℂ} {B : Matrix m (Fin k) ℂ}
    {Wplus Gplus : Matrix (Fin k) (Fin k) ℂ}
    (hci : ChiralInvolution W G) (hU : Wᴴ * W = 1)
    (hBiso : Bᴴ * B = 1)
    (hWB : W * B = B * Wplus) (hGB : G * B = B * Gplus) :
    PhysicsSM.Draft.NullEdge.ChiralFlipMode.ChiralInvolution Wplus Gplus ∧
      Wplusᴴ * Wplus = 1 := by
  have hWplus_eq : Bᴴ * W * B = Wplus := by
    rw [Matrix.mul_assoc, hWB, ← Matrix.mul_assoc, hBiso, Matrix.one_mul]
  have hGplus_eq : Bᴴ * G * B = Gplus := by
    rw [Matrix.mul_assoc, hGB, ← Matrix.mul_assoc, hBiso, Matrix.one_mul]
  have hPW : B * Bᴴ * (W * B) = W * B := by
    rw [hWB, ← Matrix.mul_assoc, Matrix.mul_assoc B Bᴴ B, hBiso, Matrix.mul_one]
  have hPG : B * Bᴴ * (G * B) = G * B := by
    rw [hGB, ← Matrix.mul_assoc, Matrix.mul_assoc B Bᴴ B, hBiso, Matrix.mul_one]
  have hWplusH : Wplusᴴ = Bᴴ * Wᴴ * B := by
    rw [← hWplus_eq]
    simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      Matrix.mul_assoc]
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · -- `Gplus * Gplus = 1`
    rw [← hGplus_eq]
    rw [show (Bᴴ*G*B) * (Bᴴ*G*B) = Bᴴ * G * (B*Bᴴ*(G*B)) from by
          simp only [Matrix.mul_assoc], hPG]
    rw [show Bᴴ * G * (G*B) = Bᴴ * (G*G) * B from by simp only [Matrix.mul_assoc],
        hci.invol, Matrix.mul_one, hBiso]
  · -- `Gplus * Wplus * Gplus = Wplusᴴ`
    rw [hWplusH, ← hGplus_eq, ← hWplus_eq]
    rw [show (Bᴴ*G*B) * (Bᴴ*W*B) * (Bᴴ*G*B) = Bᴴ * G * (B*Bᴴ*(W*B)) * (Bᴴ*G*B)
          from by simp only [Matrix.mul_assoc], hPW]
    rw [show Bᴴ * G * (W*B) * (Bᴴ*G*B) = Bᴴ * G * W * (B*Bᴴ*(G*B)) from by
          simp only [Matrix.mul_assoc], hPG]
    rw [show Bᴴ * G * W * (G*B) = Bᴴ * (G*W*G) * B from by
          simp only [Matrix.mul_assoc], hci.chiral]
  · -- `Wplus` is unitary
    rw [hWplusH, ← hWplus_eq]
    rw [show (Bᴴ*Wᴴ*B) * (Bᴴ*W*B) = Bᴴ * Wᴴ * (B*Bᴴ*(W*B)) from by
          simp only [Matrix.mul_assoc], hPW]
    rw [show Bᴴ * Wᴴ * (W*B) = Bᴴ * (Wᴴ*W) * B from by simp only [Matrix.mul_assoc],
        hU, Matrix.mul_one, hBiso]

/-- **B1 (per-sector flip mode), honest explicit-isometry form.**  Let `B` be
an isometry (`Bᴴ * B = 1`) whose columns lie in the `R = +1` eigenspace
(`R * B = B`) and are invariant under `W` and `G` through the conjugated
sector operators (`W * B = B * Wplus`, `G * B = B * Gplus`).  If the
compressed sector operator `Wplus` has determinant `-1`, then `W` has an
exact `-1` eigenvector `v` living in the `R = +1` sector (`R v = v`), i.e. a
protected reflection-even flip mode.

The determinant hypothesis `Wplus.det = -1` is about the honestly
compressed/conjugated operator `Wplus = Bᴴ W B`, never about the existence of
a mode, so it is not a disguised restatement of the conclusion. -/
theorem routeB_sector_flip_mode {k : ℕ} {W G R : Matrix m m ℂ}
    (h : Sectoring W G R)
    {B : Matrix m (Fin k) ℂ} {Wplus Gplus : Matrix (Fin k) (Fin k) ℂ}
    (hBiso : Bᴴ * B = 1) (hRB : R * B = B)
    (hWB : W * B = B * Wplus) (hGB : G * B = B * Gplus)
    (hdet : Wplus.det = -1) :
    ∃ v : m → ℂ, v ≠ 0 ∧ W.mulVec v = -v ∧ R.mulVec v = v := by
  -- The conjugated pair is chiral-unitary on the sector index.
  obtain ⟨hpci, hpU⟩ := sector_chiral_unitary h.chi h.unit hBiso hWB hGB
  -- Fire the engine inside the sector: `det Wplus = -1` forces a flip mode.
  obtain ⟨w, hw_ne, hw⟩ :=
    PhysicsSM.Draft.NullEdge.ChiralFlipMode.chiral_det_neg_one_forces_flip_mode
      hpci hpU hdet
  -- Lift it through the isometry: `v = B w`.
  refine ⟨B.mulVec w, ?_, ?_, ?_⟩
  · -- `v ≠ 0` because `Bᴴ (B w) = w ≠ 0`.
    have hbw : Bᴴ.mulVec (B.mulVec w) = w := by
      rw [Matrix.mulVec_mulVec, hBiso, Matrix.one_mulVec]
    intro hv0
    apply hw_ne
    rw [← hbw, hv0, Matrix.mulVec_zero]
  · -- `W v = -v`.
    rw [Matrix.mulVec_mulVec, hWB, ← Matrix.mulVec_mulVec, hw, Matrix.mulVec_neg]
  · -- `R v = v` (the mode is reflection-even).
    rw [Matrix.mulVec_mulVec, hRB]

/-! ### Non-vacuity witness for the abstract Route-B theorem

A minimal *reflection-sectored* instance showing the hypotheses of
`routeB_sector_flip_mode` are honestly inhabited (not vacuous) and the engine
fires.  The 2-dimensional register: walk `W = -I`, grading `G = I`, reflection
`R = σ_z = diag(1,-1)`.  The `R = +1` sector is the 1-dimensional span of the
first basis vector, carried by the isometry `B = (1,0)ᵀ`; the honestly
compressed sector operator is `Wplus = Bᴴ W B = (-1)` with `det Wplus = -1`.
Route B then produces an exact reflection-even `-1` mode inside the sector. -/
namespace Witness

/-- Witness walk `W = -I`. -/
def Wm : Matrix (Fin 2) (Fin 2) ℂ := !![-1, 0; 0, -1]
/-- Witness reflection `R = σ_z = diag(1,-1)`. -/
def Rm : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]
/-- Isometry onto the `R = +1` sector (first basis vector). -/
def Bm : Matrix (Fin 2) (Fin 1) ℂ := !![1; 0]
/-- Compressed sector operator `Wplus = Bᴴ W B = (-1)`. -/
def Wp : Matrix (Fin 1) (Fin 1) ℂ := !![-1]

theorem sectoring : Sectoring Wm (1 : Matrix (Fin 2) (Fin 2) ℂ) Rm := by
  refine ⟨⟨?_, ?_⟩, ?_, ?_, ?_, ?_⟩
  · simp
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Wm, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Wm, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Rm, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Rm, Wm, Matrix.mul_apply, Fin.sum_univ_two]
  · simp

theorem hBiso : Bmᴴ * Bm = 1 := by
  ext i j; fin_cases i; fin_cases j
  simp [Bm, Matrix.mul_apply, Fin.sum_univ_two]

theorem hRB : Rm * Bm = Bm := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Rm, Bm, Matrix.mul_apply, Fin.sum_univ_two]

theorem hWB : Wm * Bm = Bm * Wp := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Wm, Bm, Wp, Matrix.mul_apply, Fin.sum_univ_two]

theorem hGB : (1 : Matrix (Fin 2) (Fin 2) ℂ) * Bm = Bm * (1 : Matrix (Fin 1) (Fin 1) ℂ) := by
  simp

theorem hdet : Wp.det = -1 := by simp [Wp]

/-- **Route B fires on the witness.**  Applying the abstract
`routeB_sector_flip_mode` to the concrete reflection sectoring yields an exact
reflection-even `-1` eigenvector of `W = -I` in the `R = +1` sector — the
hypotheses are genuinely satisfiable and the composed theorem is non-vacuous. -/
theorem witness_flip_mode :
    ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ Wm.mulVec v = -v ∧ Rm.mulVec v = v :=
  routeB_sector_flip_mode sectoring hBiso hRB hWB hGB hdet

end Witness

end RouteB

end SignWallDefect
