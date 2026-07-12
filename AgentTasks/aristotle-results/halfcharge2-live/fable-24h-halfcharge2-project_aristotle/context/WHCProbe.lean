import Mathlib
noncomputable section
namespace ProbeNS
open Matrix
set_option maxHeartbeats 40000000
def W : Matrix (Fin 16) (Fin 16) Complex :=
  !![0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I;
    0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5);
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0;
    (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

def v0 : Fin 16 → Complex :=
  ![32, 24*Complex.I, 40, 60*Complex.I, 68, 126*Complex.I, 130, 255*Complex.I,
    257, 126*Complex.I, 130, 60*Complex.I, 68, 24*Complex.I, 40, 0]

theorem Wd_v0 : Wᴴ.mulVec v0 = v0 := by
  funext i
  fin_cases i <;>
    simp only [Matrix.conjTranspose_apply, W, v0, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ] <;>
    norm_num [Complex.ext_iff]
end ProbeNS
