import Mathlib
import PhysicsSM.Gauge.StandardModelSubgroup
import PhysicsSM.Gauge.StandardModelGroup

/-!
# Gauge.StandardModelBlockHom

Homomorphism laws, identity and multiplication, for the concrete block-matrix
maps `su4Block`, `slideMap`, and `coveringMap`.

## Mathematical context

The covering homomorphism `U(1) x SU(2) x SU(3) -> SU(2) x SU(4)` is:
`(alpha, g, h) |-> (g, block_diag(alpha * h, alpha^(-3)))`.

This file proves that each of the concrete building blocks preserves the
identity and is multiplicative:

- `su4Block 1 1 = 1`
- `su4Block (alpha * beta) (h1 * h2) =
  su4Block alpha h1 * su4Block beta h2`
- `slideMap 1 1 1 = (1, 1)` and its multiplication law
- `coveringMap 1 1 1 = (1, 1)` and its multiplication law

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Provenance: integrated from Aristotle job
`6a49742e-22f2-45b0-8432-686b89df56f4`, with local review and provenance
cleanup.

Claim boundary: concrete matrix identities only; no quotient isomorphism,
Lie-group topology, or `Spin(9)` centralizer claims.
-/

namespace PhysicsSM.Gauge.BlockEmbeddings

open Complex Matrix

/-! ## su4Block identity and multiplication -/

/-- The SU(4) block map sends the identity inputs to the identity matrix. -/
theorem su4Block_one :
    su4Block 1 (1 : Matrix (Fin 3) (Fin 3) Complex) = 1 := by
  simp [su4Block]

/--
The SU(4) block map is multiplicative:
`su4Block (alpha * beta) (h1 * h2) = su4Block alpha h1 * su4Block beta h2`.
-/
theorem su4Block_mul
    (alpha beta : Complex)
    (h1 h2 : Matrix (Fin 3) (Fin 3) Complex) :
    su4Block (alpha * beta) (h1 * h2) =
      su4Block alpha h1 * su4Block beta h2 := by
  unfold su4Block
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-! ## slideMap identity and multiplication -/

/-- The slide map sends identity inputs to the identity pair. -/
theorem slideMap_one :
    slideMap 1
      (1 : Matrix (Fin 2) (Fin 2) Complex)
      (1 : Matrix (Fin 3) (Fin 3) Complex) =
    (1, 1) := by
  exact Prod.ext rfl su4Block_one

/-- The slide map is multiplicative componentwise. -/
theorem slideMap_mul
    (alpha beta : Complex)
    (g1 g2 : Matrix (Fin 2) (Fin 2) Complex)
    (h1 h2 : Matrix (Fin 3) (Fin 3) Complex) :
    slideMap (alpha * beta) (g1 * g2) (h1 * h2) =
      let p := slideMap alpha g1 h1
      let q := slideMap beta g2 h2
      (p.1 * q.1, p.2 * q.2) := by
  convert su4Block_mul alpha beta h1 h2 using 1
  unfold slideMap
  aesop

end PhysicsSM.Gauge.BlockEmbeddings

/-! ## coveringMap identity and multiplication -/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-- The covering map sends identity inputs to the identity pair. -/
theorem coveringMap_one :
    coveringMap 1
      (1 : Matrix (Fin 2) (Fin 2) Complex)
      (1 : Matrix (Fin 3) (Fin 3) Complex) =
    (1, 1) := by
  unfold coveringMap
  aesop

/-- The covering map is multiplicative componentwise. -/
theorem coveringMap_mul
    (alpha beta : Complex)
    (g1 g2 : Matrix (Fin 2) (Fin 2) Complex)
    (h1 h2 : Matrix (Fin 3) (Fin 3) Complex) :
    coveringMap (alpha * beta) (g1 * g2) (h1 * h2) =
      let p := coveringMap alpha g1 h1
      let q := coveringMap beta g2 h2
      (p.1 * q.1, p.2 * q.2) := by
  unfold coveringMap
  simp +decide [mul_pow, mul_comm, smul_smul]

end PhysicsSM.Gauge.StandardModelSubgroup
