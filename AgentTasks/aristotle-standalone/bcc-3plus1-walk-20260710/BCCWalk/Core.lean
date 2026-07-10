import Mathlib

open Matrix Complex

namespace BCCWalk

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1;
     0, 0, 1, 0;
     0, 1, 0, 0;
     1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I;
     0, 0, I, 0;
     0, -I, 0, 0;
     I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0;
     0, 0, 0, -1;
     1, 0, 0, 0;
     0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

def alpha : Fin 3 → Mat4
  | 0 => alpha1
  | 1 => alpha2
  | 2 => alpha3

def H (kx ky kz m : ℝ) : Mat4 :=
  (kx : ℂ) • alpha1 + (ky : ℂ) • alpha2 +
    (kz : ℂ) • alpha3 + (m : ℂ) • beta

theorem alpha_sq (j : Fin 3) : alpha j * alpha j = 1 := by
  sorry

theorem alpha_pairwise_anticommute (i j : Fin 3) (hij : i ≠ j) :
    alpha i * alpha j + alpha j * alpha i = 0 := by
  sorry

theorem beta_sq : beta * beta = 1 := by
  sorry

theorem alpha_beta_anticommute (j : Fin 3) :
    alpha j * beta + beta * alpha j = 0 := by
  sorry

theorem H_sq (kx ky kz m : ℝ) :
    H kx ky kz m * H kx ky kz m =
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 + m ^ 2 : ℝ) : ℂ) • (1 : Mat4) := by
  sorry

theorem component_velocity_spectrum (j : Fin 3) (v : ℝ) :
    (((v : ℂ) • (1 : Mat4) - alpha j).det = 0) ↔ v = 1 ∨ v = -1 := by
  sorry

theorem nondegenerate_1223_witness :
    H 1 2 2 3 * H 1 2 2 3 = (18 : ℂ) • (1 : Mat4) ∧
      H 1 2 2 3 ≠ 0 := by
  sorry

end BCCWalk
