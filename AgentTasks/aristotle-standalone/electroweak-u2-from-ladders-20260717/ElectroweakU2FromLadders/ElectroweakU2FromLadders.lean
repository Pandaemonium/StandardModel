import Mathlib

/-!
# The electroweak U(2) = SU(2)_L x U(1)_Y from two weak ladder modes

SM-branch foundation S2b (electroweak U(2) extension of the su(2)_L brick),
2026-07-17. The weak number operator `N = B_1^dagger B_1 + B_2^dagger B_2` is a
`U(1)` COMMUTING with all of su(2)_L, so the two weak ladder modes carry
`U(2) = SU(2)_L x U(1)` (Furey arXiv:1806.00612). With physical weak isospin
`T_3^phys = T_3/2` and Gell-Mann-Nishijima `Q = T_3^phys + Y/2`, the ladder
doublet `|10>, |01>` reproduces the EXACT Standard-Model charges: lepton
doublet (Y=-1) -> Q(nu)=0, Q(e)=-1; quark doublet (Y=1/3) -> Q(u)=2/3,
Q(d)=-1/3. su(2)_L, the U(1) weak number, and the GMN arithmetic are DERIVED;
the hypercharge Y per multiplet is SUPPLIED. All values numerically verified.
[comp Furey 1806.00612; orig formalization].
-/

noncomputable section

namespace ElectroweakU2FromLadders

open Matrix

def B1 : Matrix (Fin 4) (Fin 4) ℂ := !![0, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 1; 0, 0, 0, 0]
def B2 : Matrix (Fin 4) (Fin 4) ℂ := !![0, 0, 1, 0; 0, 0, 0, -1; 0, 0, 0, 0; 0, 0, 0, 0]
def comm (X Y : Matrix (Fin 4) (Fin 4) ℂ) : Matrix (Fin 4) (Fin 4) ℂ := X * Y - Y * X

/-- Weak-isospin Cartan `T_3 = B_1^dagger B_1 - B_2^dagger B_2`. -/
def T3 : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B1 - B2ᴴ * B2
/-- Weak-isospin raising `T_+ = B_1^dagger B_2`. -/
def TPlus : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B2
/-- Furey `T_1 = B_1^dagger B_2 + B_2^dagger B_1`. -/
def T1 : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B2 + B2ᴴ * B1

/-- The `U(1)` weak number operator `N = B_1^dagger B_1 + B_2^dagger B_2`. -/
def Nop : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B1 + B2ᴴ * B2
/-- Physical weak isospin `T_3^phys = T_3 / 2`. -/
def T3phys : Matrix (Fin 4) (Fin 4) ℂ := (1 / 2 : ℂ) • T3
/-- Gell-Mann-Nishijima charge at hypercharge `Y`: `Q = T_3^phys + (Y/2) 1`. -/
def Qop (Y : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  T3phys + (Y / 2) • (1 : Matrix (Fin 4) (Fin 4) ℂ)

/-- **U(2): the weak number commutes with the raising generator.** `[N, T_+] = 0`. -/
theorem Nop_comm_TPlus : comm Nop TPlus = 0 := by
  unfold comm Nop TPlus B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]

/-- **U(2): the weak number commutes with `T_3`.** `[N, T_3] = 0`. -/
theorem Nop_comm_T3 : comm Nop T3 = 0 := by
  unfold comm Nop T3 B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]

/-- **U(2): the weak number commutes with `T_1`.** `[N, T_1] = 0`. -/
theorem Nop_comm_T1 : comm Nop T1 = 0 := by
  unfold comm Nop T1 B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]

/-- **The weak number is occupation.** `N = diag(0, 1, 1, 2)`. -/
theorem Nop_eq_diagonal :
    Nop = !![0, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 2] := by
  unfold Nop B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_succ]

/-- **Gell-Mann-Nishijima: the lepton doublet (Y = -1).** `Q = T_3^phys - 1/2`
is diagonal `(-1/2, 0, -1, -1/2)` (the doublet states `|10>=nu`, `|01>=e`
at indices 1,2 carry the SM charges): `Q(nu) = 0`, `Q(e) = -1`; the empty/full
Fock states have `Q = Y/2 = -1/2`. -/
theorem QLepton_eq_diagonal :
    Qop (-1) = !![-(1 / 2), 0, 0, 0; 0, 0, 0, 0; 0, 0, -1, 0; 0, 0, 0, -(1 / 2)] := by
  unfold Qop T3phys T3 B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply, Matrix.smul_apply, Matrix.sub_apply, Matrix.mul_apply,
      Matrix.conjTranspose_apply, Fin.sum_univ_succ, Matrix.one_apply, smul_eq_mul] <;>
    norm_num

/-- **Gell-Mann-Nishijima: the quark doublet (Y = 1/3).** `Q = T_3^phys + 1/6`
is diagonal `(1/6, 2/3, -1/3, 1/6)` (the doublet states `|10>=u`, `|01>=d`
at indices 1,2 carry the SM charges): `Q(u) = 2/3`, `Q(d) = -1/3`; the
empty/full Fock states have `Q = Y/2 = 1/6`. -/
theorem QQuark_eq_diagonal :
    Qop (1 / 3) = !![1 / 6, 0, 0, 0; 0, 2 / 3, 0, 0; 0, 0, -(1 / 3), 0; 0, 0, 0, 1 / 6] := by
  unfold Qop T3phys T3 B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply, Matrix.smul_apply, Matrix.sub_apply, Matrix.mul_apply,
      Matrix.conjTranspose_apply, Fin.sum_univ_succ, Matrix.one_apply, smul_eq_mul] <;>
    norm_num

end ElectroweakU2FromLadders

end
