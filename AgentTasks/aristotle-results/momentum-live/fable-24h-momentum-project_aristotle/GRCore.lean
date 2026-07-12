import Mathlib

/-!
# Computable Gaussian-rational model (`GR`) and transfer machinery

This auxiliary file provides a *computable* model of the Gaussian rationals
`ℚ(i)` (the structure `GR`), together with a ring homomorphism `GR.toC : GR →+* ℂ`
that is injective.  All the explicit matrices appearing in
`PairMomentumBlocks.lean` have Gaussian-rational entries, so every matrix
identity over `ℂ` can be transferred to the corresponding identity over `GR`,
where it is decided by kernel-checked `native_decide` on materialised
(array-backed) matrices.

`native_decide` is used here (loudly disclosed) to discharge the finite
Gaussian-rational matrix identities; the transfer to `ℂ` is fully kernel-checked
via the injective ring homomorphism `GR.toC`.
-/

open Matrix

/-- Computable Gaussian rationals `ℚ(i)`. -/
structure GR where
  re : ℚ
  im : ℚ
deriving DecidableEq, Repr

namespace GR

@[ext] theorem ext' {a b : GR} (hr : a.re = b.re) (hi : a.im = b.im) : a = b := by
  cases a; cases b; simp_all

instance : Inhabited GR := ⟨0, 0⟩
instance : Zero GR := ⟨⟨0,0⟩⟩
instance : One GR := ⟨⟨1,0⟩⟩
instance : Add GR := ⟨fun a b => ⟨a.re+b.re, a.im+b.im⟩⟩
instance : Neg GR := ⟨fun a => ⟨-a.re, -a.im⟩⟩
instance : Sub GR := ⟨fun a b => ⟨a.re-b.re, a.im-b.im⟩⟩
instance : Mul GR := ⟨fun a b => ⟨a.re*b.re - a.im*b.im, a.re*b.im + a.im*b.re⟩⟩

@[simp] theorem zero_re : (0:GR).re = 0 := rfl
@[simp] theorem zero_im : (0:GR).im = 0 := rfl
@[simp] theorem one_re : (1:GR).re = 1 := rfl
@[simp] theorem one_im : (1:GR).im = 0 := rfl
@[simp] theorem add_re (a b : GR) : (a+b).re = a.re+b.re := rfl
@[simp] theorem add_im (a b : GR) : (a+b).im = a.im+b.im := rfl
@[simp] theorem neg_re (a : GR) : (-a).re = -a.re := rfl
@[simp] theorem neg_im (a : GR) : (-a).im = -a.im := rfl
@[simp] theorem sub_re (a b : GR) : (a-b).re = a.re-b.re := rfl
@[simp] theorem sub_im (a b : GR) : (a-b).im = a.im-b.im := rfl
@[simp] theorem mul_re (a b : GR) : (a*b).re = a.re*b.re - a.im*b.im := rfl
@[simp] theorem mul_im (a b : GR) : (a*b).im = a.re*b.im + a.im*b.re := rfl

instance : CommRing GR where
  add_assoc := by intros; ext <;> simp <;> ring
  zero_add := by intros; ext <;> simp
  add_zero := by intros; ext <;> simp
  add_comm := by intros; ext <;> simp <;> ring
  mul_assoc := by intros; ext <;> simp <;> ring
  one_mul := by intros; ext <;> simp
  mul_one := by intros; ext <;> simp
  left_distrib := by intros; ext <;> simp <;> ring
  right_distrib := by intros; ext <;> simp <;> ring
  mul_comm := by intros; ext <;> simp <;> ring
  neg_add_cancel := by intros; ext <;> simp
  sub_eq_add_neg := by intros; ext <;> simp <;> ring
  zero_mul := by intros; ext <;> simp
  mul_zero := by intros; ext <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec

/-- The injective ring homomorphism `GR → ℂ`, `⟨x,y⟩ ↦ x + y·i`. -/
noncomputable def toC : GR →+* ℂ where
  toFun z := (z.re : ℂ) + (z.im : ℂ) * Complex.I
  map_one' := by simp
  map_mul' a b := by
    simp only [mul_re, mul_im]
    push_cast
    ring_nf
    rw [Complex.I_sq]
    ring
  map_zero' := by simp
  map_add' a b := by simp only [add_re, add_im]; push_cast; ring

@[simp] theorem toC_apply (z : GR) : toC z = (z.re : ℂ) + (z.im : ℂ) * Complex.I := rfl

theorem toC_injective : Function.Injective toC := by
  intro a b h
  simp only [toC_apply] at h
  have hre := congrArg Complex.re h
  have him := congrArg Complex.im h
  simp at hre him
  ext <;> [exact_mod_cast hre; exact_mod_cast him]

end GR

/-! ## Explicit Gaussian-rational matrices (arithmetic definitions, fast to evaluate). -/

abbrev N8 := Matrix (Fin 8) (Fin 8) GR
abbrev N28 := Matrix (Fin 28) (Fin 28) GR

/-- Coin entry `4/5`. -/
def gA : GR := ⟨4/5, 0⟩
/-- Coin entry `-3i/5`. -/
def gB : GR := ⟨0, -3/5⟩
/-- Imaginary unit in `GR`. -/
def gI : GR := ⟨0, 1⟩

/-- Free one-particle step, explicit sparse arithmetic form (equals `S1 * C1`). -/
def U1g : N8 := Matrix.of fun i j =>
  let s := i.1/2; let c := i.1%2; let sj := j.1/2; let cj := j.1%2
  if c = 0 then (if sj = (s+3)%4 then (if cj=0 then gA else gB) else 0)
  else (if sj = (s+1)%4 then (if cj=0 then gB else gA) else 0)

/-- One-site translation. -/
def T1g : N8 := Matrix.of fun i j =>
  if i.1 % 2 = j.1 % 2 ∧ i.1 / 2 = (j.1 / 2 + 1) % 4 then (1 : GR) else 0

/-- Lexicographic pair enumeration (first index), arithmetic form of `pairFst`. -/
def pfN (k : ℕ) : ℕ :=
  if k ≤ 6 then 0 else if k ≤ 12 then 1 else if k ≤ 17 then 2
  else if k ≤ 21 then 3 else if k ≤ 24 then 4 else if k ≤ 26 then 5 else 6
/-- Lexicographic pair enumeration (second index), arithmetic form of `pairSnd`. -/
def psN (k : ℕ) : ℕ :=
  if k ≤ 6 then k+1 else if k ≤ 12 then k-5 else if k ≤ 17 then k-10
  else if k ≤ 21 then k-14 else if k ≤ 24 then k-17 else if k ≤ 26 then k-19 else k-20
def pf (r : Fin 28) : Fin 8 := ⟨pfN r.1 % 8, Nat.mod_lt _ (by norm_num)⟩
def ps (r : Fin 28) : Fin 8 := ⟨psN r.1 % 8, Nat.mod_lt _ (by norm_num)⟩

/-- Determinant-minor pair lift over `GR`. -/
def minorLiftG (A : N8) : N28 := Matrix.of fun r c =>
  A (pf r) (pf c) * A (ps r) (ps c) - A (pf r) (ps c) * A (ps r) (pf c)

def U2g : N28 := minorLiftG U1g
def T2g : N28 := minorLiftG T1g

/-- Momentum projectors over `GR`. -/
def Pg (K : Fin 4) : N28 :=
  (⟨1/4,0⟩ : GR) • (1 + gI^(((4 - K.1) * 1) % 4) • T2g
    + gI^(((4 - K.1) * 2) % 4) • T2g^2 + gI^(((4 - K.1) * 3) % 4) • T2g^3)

/-- Pair kick over `GR`. -/
def K2g : N28 := Matrix.of fun r c =>
  if r = 0 ∧ c = 0 then gA else if r = 0 ∧ c = 13 then gB
  else if r = 13 ∧ c = 0 then gB else if r = 13 ∧ c = 13 then gA
  else if r = c then 1 else 0

def Vg : N28 := U2g * K2g

/-- K=2 spectral projectors over `GR`. -/
def Rplus_g : N28 := (⟨1/128,0⟩:GR) • ((25 • U2g^2 + 14 • U2g + 25 • (1 : N28)) * (U2g + 1))
def Rminus_g : N28 := (⟨1/72,0⟩:GR) • ((25 • U2g^2 + 14 • U2g + 25 • (1 : N28)) * (1 - U2g))

/-! ## Materialisation: force a matrix into an `O(1)`-access array-backed matrix. -/

def toArr (M : N28) : Array (Array GR) :=
  (Array.finRange 28).map (fun i => (Array.finRange 28).map (fun j => M i j))
def ofArr (A : Array (Array GR)) : N28 := Matrix.of fun i j => (A[i.1]!)[j.1]!

theorem mkEq (M : N28) : ofArr (toArr M) = M := by
  refine Matrix.ext (fun i j => ?_)
  simp only [ofArr, toArr, Matrix.of_apply]
  have h1 : i.1 < ((Array.finRange 28).map
      (fun a => (Array.finRange 28).map (fun b => M a b))).size := by
    rw [Array.size_map, Array.size_finRange]; exact i.2
  rw [getElem!_pos ((Array.finRange 28).map
      (fun a => (Array.finRange 28).map (fun b => M a b))) i.1 h1,
    Array.getElem_map, Array.getElem_finRange]
  have h2 : j.1 < ((Array.finRange 28).map (fun b => M (⟨i.1, i.2⟩ : Fin 28) b)).size := by
    rw [Array.size_map, Array.size_finRange]; exact j.2
  simp only [Fin.cast_mk]
  rw [getElem!_pos _ j.1 h2, Array.getElem_map, Array.getElem_finRange]
  simp

/-! ## Materialised building blocks (array-backed, `O(1)` access) and their identities. -/

def U2m : N28 := ofArr (toArr U2g)
theorem U2m_eq : U2m = U2g := mkEq _
def T2m : N28 := ofArr (toArr T2g)
theorem T2m_eq : T2m = T2g := mkEq _
def U2sq : N28 := ofArr (toArr (U2m * U2m))
theorem U2sq_eq : U2sq = U2g ^ 2 := by
  rw [pow_two, show U2sq = U2m * U2m from mkEq _, U2m_eq]
def T2sq : N28 := ofArr (toArr (T2m * T2m))
theorem T2sq_eq : T2sq = T2g ^ 2 := by
  rw [pow_two, show T2sq = T2m * T2m from mkEq _, T2m_eq]
def T2cb : N28 := ofArr (toArr (T2sq * T2m))
theorem T2cb_eq : T2cb = T2g ^ 3 := by
  rw [show T2cb = T2sq * T2m from mkEq _, T2sq_eq, T2m_eq, ← pow_succ]
def T2q4 : N28 := ofArr (toArr (T2cb * T2m))
theorem T2q4_eq : T2q4 = T2g ^ 4 := by
  rw [show T2q4 = T2cb * T2m from mkEq _, T2cb_eq, T2m_eq, ← pow_succ]

def Pg0m : N28 := ofArr (toArr (Pg 0))
theorem Pg0m_eq : Pg0m = Pg 0 := mkEq _
def Pg1m : N28 := ofArr (toArr (Pg 1))
theorem Pg1m_eq : Pg1m = Pg 1 := mkEq _
def Pg2m : N28 := ofArr (toArr (Pg 2))
theorem Pg2m_eq : Pg2m = Pg 2 := mkEq _
def Pg3m : N28 := ofArr (toArr (Pg 3))
theorem Pg3m_eq : Pg3m = Pg 3 := mkEq _

def q2m : N28 := ofArr (toArr (25 • U2sq + 14 • U2m + 25 • (1 : N28)))
theorem q2m_eq : q2m = 25 • U2g ^ 2 + 14 • U2g + 25 • (1 : N28) := by
  rw [show q2m = 25 • U2sq + 14 • U2m + 25 • (1 : N28) from mkEq _, U2sq_eq, U2m_eq]

def Rmid : N28 := ofArr (toArr ((U2m - 1) * (U2m + 1)))
theorem Rmid_eq : Rmid = (U2g - 1) * (U2g + 1) := by
  rw [show Rmid = (U2m - 1) * (U2m + 1) from mkEq _, U2m_eq]

def Rplusm : N28 := ofArr (toArr Rplus_g)
theorem Rplusm_eq : Rplusm = Rplus_g := mkEq _
def Rminusm : N28 := ofArr (toArr Rminus_g)
theorem Rminusm_eq : Rminusm = Rminus_g := mkEq _
def RP2 : N28 := ofArr (toArr (Rplusm * Pg2m))
theorem RP2_eq : RP2 = Rplus_g * Pg 2 := by
  rw [show RP2 = Rplusm * Pg2m from mkEq _, Rplusm_eq, Pg2m_eq]
def Vgm : N28 := ofArr (toArr (U2m * K2g))
theorem Vgm_eq : Vgm = Vg := by
  rw [show Vgm = U2m * K2g from mkEq _, U2m_eq]; rfl

def egv : Fin 28 → GR := fun i => if i = 0 then 1 else 0

/-- Conjugation on `GR`. -/
def conjG (z : GR) : GR := ⟨z.re, -z.im⟩
