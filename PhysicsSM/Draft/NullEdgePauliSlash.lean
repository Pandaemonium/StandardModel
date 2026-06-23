import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic

/-!
# Pauli slash square: the Clifford / mass-shell relation

The 2x2 Pauli matrices satisfy the Euclidean Clifford relation, so the spatial
"slash" `p . sigma = sum_i p_i sigma_i` squares to `|p|^2` times the identity.
This is the kernel-checked Clifford anchor for the Dirac-slash / mass-shell cores
on the P2 Yukawa operator line.

```text
(sum_i p_i sigma_i)^2 = (p0^2 + p1^2 + p2^2) I.
```

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgePauliSlash

open Matrix Complex BigOperators

/-- The three Pauli matrices. -/
def sigma : Fin 3 -> Matrix (Fin 2) (Fin 2) Complex
  | 0 => !![0, 1; 1, 0]
  | 1 => !![0, -I; I, 0]
  | 2 => !![1, 0; 0, -1]

/-- Spatial Pauli slash `p . sigma`. -/
def slash (p : Fin 3 -> Real) : Matrix (Fin 2) (Fin 2) Complex :=
  Finset.univ.sum fun i => (p i : Complex) • sigma i

/-
Two distinct Pauli matrices anticommute.
-/
theorem pauli_anticomm (i j : Fin 3) (hij : i ≠ j) :
    sigma i * sigma j + sigma j * sigma i = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all +decide [sigma] <;>
    (ext a b; fin_cases a <;> fin_cases b <;> rfl)

/-
The Pauli slash squares to the squared momentum times the identity.
-/
theorem pauli_slash_sq (p : Fin 3 -> Real) :
    slash p * slash p =
      ((p 0 ^ 2 + p 1 ^ 2 + p 2 ^ 2 : Real) : Complex) • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  unfold slash sigma
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [Fin.sum_univ_three, Matrix.mul_apply] <;>
    ring_nf <;> norm_num <;> ring

end PhysicsSM.Draft.NullEdgePauliSlash
