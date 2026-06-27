import Mathlib

/-!
# C60: Species-splitting lift of the exact high-branch nodal curves

Aristotle Gate C Route B deliverable, attacking the extended-nodal-curve problem
exposed by C43/C44.

## Background (C43/C44, see `NullEdgeSpectralGraphNodalSet`)

C43/C44 proved that each high branch lies on an *exact* determinant-zero curve:
for each branch `a`, the line

```text
q_a = 0,   q_b = π + t   (b ≠ a)
```

has `p(q)² = qform u = 0` for **all** real `t`, where `uₐ(q) = exp(i qₐ) − 1`
and `qform u = −¾ · Σ uₐ² + ¼ · (Σ uₐ)²`.  The `t = 0` endpoint is the three-`π`
high corner and the `t = π` endpoint is the origin `u = 0`.  So the high branches
are *not* isolated determinant zeros; they are endpoints of one-parameter nodal
curves that all pass through the origin.

Consequently bare minimally-doubled *species-count* language is unsafe: a
**branch-control / species-splitting term** is needed.  Working plan §29.5
proposes the linear taste function

```text
T_lin(q) = ½ Σ_a s_a cos qₐ        (with Σ_a s_a = 0),
```

specialising to `T_lin(q) = ½(cos q₁ + cos q₂ − cos q₃ − cos q₄)` for the
literature sign pattern `s = g5 = (+,+,−,−)`.

## What is proved here

* `Tlin_corner` (**branch corner values**): for a traceless sign vector `s`
  (`Σ_a s_a = 0`), `T_lin` on the high corner `q^(a)` (`q_a = 0`, `q_b = π`)
  equals the branch sign: `T_lin(q^(a)) = s_a`.
* `Tlin_branchLine` (**values along the exact branch line**): for traceless `s`,
  along branch `a`'s exact nodal line `T_lin = s_a · (1 + cos t)/2`.
* `Tlin_origin` (**origin unlifted**): at the origin endpoint `t = π`,
  `T_lin = 0`.  The splitting leaves the origin null point untouched.
* `branchLine_qform_zero` (**bare degeneracy persists**): the *scalar*
  determinant zero `qform u = 0` holds on the whole branch line for every `t`
  (the C43/C44 result, reproved self-contained here).  The species-splitting
  term does **not** remove the scalar determinant zero; it is a separate
  modeled mass channel.
* `Msplit_branchLine` / `Msplit_high_corner_ne_zero` / `Msplit_origin_zero` /
  `Msplit_branchLine_zero_iff` (**the lift theorem**): the modeled
  species-splitting term `M_split(q) = r · T_lin(q)` evaluated on branch `a`'s
  line is `r · s_a · (1 + cos t)/2`.  For nonzero coefficient `r` and nonzero
  branch sign `s_a`, this is **nonzero at the high corner** `t = 0` (value
  `r · s_a`) and **vanishes on the line exactly at `cos t = −1`**, i.e. only at
  the origin endpoint `t ≡ π`.  Hence `M_split` gaps the entire high nodal line
  away from the origin while leaving the origin null point unlifted.
* `g5_traceless`, `g5_split_lifts_high_branch`: the literature pattern
  `g5 = (+,+,−,−)` is traceless and realises the lift for every branch with
  any nonzero `r`.

## What is and is not claimed (explicit scope)

* **What is lifted:** the *modeled species/taste mass channel* `M_split = r·T_lin`
  is shown to be nonzero along the high nodal line away from the origin.  This is
  a branch-taste degeneracy-splitting statement at the level of the modeled
  scalar mass term `T_lin`.
* **What is NOT lifted / NOT claimed:** the bare *scalar determinant zero*
  `qform u = 0` is unchanged on the line (`branchLine_qform_zero`); this is a
  separate channel.  We make **no claim of physical ghost safety**, propagator
  positivity, or Krein/causality control — those require the cost-ledger audit
  of working plan §29.6 (the cosine taste term uses both forward and backward
  shifts) and are out of scope.

## Moduli verdict (carried over from C45/C46,
`NullEdgeSymmetryForcedSpeciesSplit`)

The coefficient `r` remains a free real modulus: any nonzero `r` realises the
lift, and no value is symmetry-distinguished.  Therefore this module is a
**reconstruction / branch-control** result, **not a magnitude prediction**.
Gate F prediction language at the level of `r` stays off.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine

open Finset Complex

/-! ## The nodal-curve machinery (self-contained reconstruction of C43/C44) -/

/-- The retarded phase vector `uₐ(q) = exp(i qₐ) − 1`. -/
def phaseU (q : Fin 4 → ℝ) (a : Fin 4) : ℂ :=
  Complex.exp (Complex.I * (q a : ℂ)) - 1

/-- The scalar Lorentzian symbol square `p(q)² = qform u =
`−¾ · Σ uₐ² + ¼ · (Σ uₐ)²`. -/
def qform (u : Fin 4 → ℂ) : ℂ :=
  (-3/4) * (∑ a, (u a) ^ 2) + (1/4) * (∑ a, u a) ^ 2

/-- The branch line for branch `a`: `qₐ = 0` and `q_b = π + t` for `b ≠ a`. -/
def branchLinePhase (a : Fin 4) (t : ℝ) (b : Fin 4) : ℝ :=
  if b = a then 0 else Real.pi + t

/-- The retarded phase vector along branch `a`'s line. -/
def branchLineU (a : Fin 4) (t : ℝ) : Fin 4 → ℂ := phaseU (branchLinePhase a t)

/-- The high corner for branch `a`: `qₐ = 0`, `q_b = π` for `b ≠ a`
(the `t = 0` point of the branch line). -/
def cornerPhase (a : Fin 4) (b : Fin 4) : ℝ := if b = a then 0 else Real.pi

/-! ## Tracelessness and the linear taste function `T_lin` -/

/-- A sign vector is *traceless* if `Σ_a s_a = 0` (the signature `(2,2)` /
flavored-index condition). -/
def Traceless (s : Fin 4 → ℝ) : Prop := ∑ a, s a = 0

/-- The linear taste function `T_lin(q) = ½ Σ_a s_a cos qₐ`. -/
def Tlin (s : Fin 4 → ℝ) (q : Fin 4 → ℝ) : ℝ :=
  (1/2) * ∑ a, s a * Real.cos (q a)

/-- The modeled species-splitting mass term `M_split(q) = r · T_lin(q)`. -/
def Msplit (r : ℝ) (s : Fin 4 → ℝ) (q : Fin 4 → ℝ) : ℝ := r * Tlin s q

/-- The literature target taste pattern `g5 = (+,+,−,−)`. -/
def g5 : Fin 4 → ℝ := ![1, 1, -1, -1]

/-! ## The bare scalar degeneracy persists on the whole branch line -/

/-- Component values on the branch line: `0` at the distinguished edge `a`, and
`exp(i(π+t)) − 1` on the other three edges. -/
theorem branchLineU_apply (a : Fin 4) (t : ℝ) (b : Fin 4) :
    branchLineU a t b =
      if b = a then 0 else (Complex.exp (Complex.I * ((Real.pi + t : ℝ) : ℂ)) - 1) := by
  unfold branchLineU phaseU branchLinePhase
  split_ifs with h
  · simp
  · rfl

/-
**Bare scalar determinant zero (C43/C44, reproved).**  For each high branch
`a`, the exact line `qₐ = 0`, `q_b = π + t` (`b ≠ a`) has `p(q)² = qform u = 0`
for **all** real `t`.  The species-splitting term does *not* touch this scalar
channel.
-/
theorem branchLine_qform_zero (a : Fin 4) (t : ℝ) : qform (branchLineU a t) = 0 := by
  unfold qform branchLineU;
  fin_cases a <;> simp +decide [ Fin.sum_univ_four, phaseU, branchLinePhase ] <;> ring

/-! ## Values of `T_lin` on the branch corners and along the exact lines -/

/-
**Branch corner values.**  For a traceless sign vector `s`, the taste
function on the high corner `q^(a)` (`q_a = 0`, `q_b = π`) equals the branch
sign: `T_lin(q^(a)) = s_a`.
-/
theorem Tlin_corner (s : Fin 4 → ℝ) (hs : Traceless s) (a : Fin 4) :
    Tlin s (cornerPhase a) = s a := by
  fin_cases a <;> simp +decide [ Fin.sum_univ_four, Tlin, cornerPhase ];
  · unfold Traceless at hs; norm_num [ Fin.sum_univ_four ] at hs; linarith;
  · unfold Traceless at hs; norm_num [ Fin.sum_univ_four ] at hs; linarith!;
  · unfold Traceless at hs; norm_num [ Fin.sum_univ_four ] at hs; linarith!;
  · unfold Traceless at hs; norm_num [ Fin.sum_univ_four ] at hs; linarith!;

/-
**Values along the exact branch line.**  For traceless `s`, along branch
`a`'s nodal line `T_lin = s_a · (1 + cos t)/2`.
-/
theorem Tlin_branchLine (s : Fin 4 → ℝ) (hs : Traceless s) (a : Fin 4) (t : ℝ) :
    Tlin s (branchLinePhase a t) = s a * (1 + Real.cos t) / 2 := by
  fin_cases a <;> simp +decide;
  · unfold Tlin branchLinePhase; simp +decide [ Fin.sum_univ_four ] ; ring;
    unfold Traceless at hs; rw [ show s 0 = - ( s 1 + s 2 + s 3 ) by linarith! [ hs, Fin.sum_univ_four s ] ] ; norm_num [ Real.cos_add ] ; ring;
  · unfold Tlin branchLinePhase;
    simp +decide [ Fin.sum_univ_four, Real.cos_add ] ; ring;
    unfold Traceless at hs; rw [ Fin.sum_univ_four ] at hs; linear_combination -hs * Real.cos t / 2;
  · unfold Tlin branchLinePhase; simp +decide [ Fin.sum_univ_four ] ; ring;
    simp_all +decide [ Real.cos_add, Traceless ];
    rw [ Fin.sum_univ_four ] at hs ; linear_combination' hs * -Real.cos t * 2⁻¹;
  · unfold Tlin branchLinePhase;
    simp_all +decide [ Fin.sum_univ_four, Traceless ];
    rw [ Real.cos_add ] ; norm_num ; rw [ ← eq_sub_iff_add_eq' ] at hs ; rw [ hs ] ; ring;

/-
**Origin unlifted.**  At the origin endpoint `t = π` of branch `a`'s line,
`T_lin = 0`: the splitting leaves the origin null point untouched.
-/
theorem Tlin_origin (s : Fin 4 → ℝ) (hs : Traceless s) (a : Fin 4) :
    Tlin s (branchLinePhase a Real.pi) = 0 := by
  rw [ Tlin_branchLine s hs a Real.pi ] ; norm_num

/-! ## The lift theorem for the modeled species-splitting term `M_split = r·T_lin` -/

/-
**`M_split` along the branch line.**  `M_split(q) = r · s_a · (1 + cos t)/2`
on branch `a`'s exact nodal line.
-/
theorem Msplit_branchLine (r : ℝ) (s : Fin 4 → ℝ) (hs : Traceless s) (a : Fin 4) (t : ℝ) :
    Msplit r s (branchLinePhase a t) = r * s a * (1 + Real.cos t) / 2 := by
  convert congr_arg ( fun x => r * x ) ( Tlin_branchLine s hs a t ) using 1 ; ring

/-
**The high corner is gapped.**  For nonzero coefficient `r` and nonzero
branch sign `s_a`, the modeled splitting at the high corner (`t = 0`) is nonzero,
with value `r · s_a`.  The high-momentum null branch is lifted.
-/
theorem Msplit_high_corner_ne_zero (r : ℝ) (s : Fin 4 → ℝ) (hs : Traceless s)
    (a : Fin 4) (hr : r ≠ 0) (hsa : s a ≠ 0) :
    Msplit r s (branchLinePhase a 0) = r * s a ∧ Msplit r s (branchLinePhase a 0) ≠ 0 := by
  unfold Msplit;
  rw [ Tlin_branchLine ] <;> norm_num [ hr, hsa ];
  assumption

/-
**The origin stays at zero.**  `M_split` vanishes at the origin endpoint
`t = π` for every coefficient `r`.
-/
theorem Msplit_origin_zero (r : ℝ) (s : Fin 4 → ℝ) (hs : Traceless s) (a : Fin 4) :
    Msplit r s (branchLinePhase a Real.pi) = 0 := by
  exact mul_eq_zero_of_right _ ( Tlin_origin s hs a )

/-
**The lift gaps the whole line away from the origin.**  For nonzero `r` and
nonzero branch sign `s_a`, the only zeros of `M_split` along branch `a`'s exact
nodal line are the points with `cos t = −1`, i.e. exactly the origin endpoint
`t ≡ π`.  Everywhere else on the line (in particular at the high corner) the
modeled species-splitting term is nonzero.
-/
theorem Msplit_branchLine_zero_iff (r : ℝ) (s : Fin 4 → ℝ) (hs : Traceless s)
    (a : Fin 4) (hr : r ≠ 0) (hsa : s a ≠ 0) (t : ℝ) :
    Msplit r s (branchLinePhase a t) = 0 ↔ Real.cos t = -1 := by
  rw [ Msplit_branchLine r s hs a t ] ; norm_num [ hr, hsa ];
  constructor <;> intro h <;> linarith

/-! ## The literature pattern `g5 = (+,+,−,−)` realises the lift -/

/-
The literature sign pattern `g5 = (+,+,−,−)` is traceless.
-/
theorem g5_traceless : Traceless g5 := by
  unfold Traceless g5; norm_num [ Fin.sum_univ_succ ] ;

/-
**`g5` realises the lift for every branch.**  For any nonzero coefficient
`r`, the splitting `M_split = r · T_lin` with the `(+,+,−,−)` pattern lifts every
high branch (`t = 0` corner nonzero) while leaving the origin (`t = π`) at zero,
and the only zeros on each branch line are at `cos t = −1` (the origin).
-/
theorem g5_split_lifts_high_branch (r : ℝ) (hr : r ≠ 0) (a : Fin 4) :
    Msplit r g5 (branchLinePhase a 0) ≠ 0 ∧
      Msplit r g5 (branchLinePhase a Real.pi) = 0 ∧
      (∀ t : ℝ, Msplit r g5 (branchLinePhase a t) = 0 ↔ Real.cos t = -1) := by
  refine' ⟨ _, _, _ ⟩;
  · convert Msplit_high_corner_ne_zero r g5 g5_traceless a hr _ |>.2 using 1;
    fin_cases a <;> norm_num [ g5 ];
  · convert Msplit_origin_zero r g5 g5_traceless a;
  · convert Msplit_branchLine_zero_iff r g5 g5_traceless a hr _ using 2;
    fin_cases a <;> norm_num [ g5 ]

/-! ## Summary -/

/-- **C60 species-splitting lift summary.**  For every high branch `a` and any
traceless sign vector `s` with nonzero branch sign `s_a` and any nonzero
coefficient `r`:

* the bare scalar determinant zero persists on the whole branch line
  (`branchLine_qform_zero`);
* the linear taste function reproduces the branch signs at the corners
  (`Tlin_corner`) and equals `s_a (1 + cos t)/2` along the line
  (`Tlin_branchLine`);
* the modeled species-splitting term `M_split = r·T_lin` gaps the high corner
  (`t = 0`, value `r·s_a ≠ 0`) and vanishes on the line only at `cos t = −1`
  (the origin endpoint `t ≡ π`), so it lifts the entire high nodal line away from
  the origin while leaving the origin null point untouched.

This is a modeled branch-taste-channel lift, **not** a claim of ghost safety,
and the coefficient `r` remains a free modulus (reconstruction, not a magnitude
prediction). -/
theorem species_split_lift_summary (r : ℝ) (s : Fin 4 → ℝ) (hs : Traceless s)
    (a : Fin 4) (hr : r ≠ 0) (hsa : s a ≠ 0) :
    (∀ t : ℝ, qform (branchLineU a t) = 0) ∧
    Tlin s (cornerPhase a) = s a ∧
    (∀ t : ℝ, Msplit r s (branchLinePhase a t) = r * s a * (1 + Real.cos t) / 2) ∧
    Msplit r s (branchLinePhase a 0) ≠ 0 ∧
    Msplit r s (branchLinePhase a Real.pi) = 0 ∧
    (∀ t : ℝ, Msplit r s (branchLinePhase a t) = 0 ↔ Real.cos t = -1) :=
  ⟨branchLine_qform_zero a, Tlin_corner s hs a,
    fun t => Msplit_branchLine r s hs a t,
    (Msplit_high_corner_ne_zero r s hs a hr hsa).2,
    Msplit_origin_zero r s hs a,
    Msplit_branchLine_zero_iff r s hs a hr hsa⟩

end PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine
