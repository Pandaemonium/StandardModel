import Mathlib

/-!
# Q08 `L-Q8-4`: the L=4, N=2 two-particle checkerboard determinant identity

This module formalizes the smallest explicit instance of the Q08 path-sum
program (Section 3, ladder entry `L-Q8-4` of the Q08 answer): the two-particle
amplitude on the 1+1 checkerboard is the determinant of the matrix of
one-particle amplitudes, and for the minimal `L = 4`, `N = 2` instance this
determinant is an explicit identity over rational polynomials (indeed over any
commutative ring, with the turn amplitude `m` treated as a formal variable).

## Model (exactly as pre-registered in the Q08 answer)

`V = R^L ⊗ R^2` with `L = 4` sites (`Fin 4`) and a 2-valued chirality
(`Fin 2`, with `0 = right-mover`, `1 = left-mover`), open boundaries.  The
one-step transfer operator is
`T = (right-shift on right-movers) ⊕ (left-shift on left-movers) + m · (flip)`.
`N = 2` time steps, so the propagator is `T * T` (the matrix `T^2`).

## What is proved (finite algebra, kernel-checked)

* `kParticle_amplitude_eq_det` — the general **T-P2** identity: for any
  endomorphism `A`, readout functionals `g` and injected states `f`, the
  `k`-particle amplitude (the pairing of exterior powers, i.e. the action of the
  exterior functor `Λ^k`) equals `det (fun i j => g j (A (f i)))`.  This is the
  exact statement "second-quantized `k`-particle amplitudes are determinants of
  one-particle amplitudes."
* `T_decomp`, `T_sq_word_expansion` — the **T-P1** word expansion: `T` splits as
  a straight-move part plus `m ·` a turn part, and `T^2` expands into the four
  length-2 words `SS + m·(ST + TS) + m²·TT`, each word weighted by
  `m^(#turns)`.
* `checkerboard_twoParticle_amplitude_eq_det` — T-P2 instantiated at the concrete
  checkerboard propagator: the exterior two-particle amplitude equals the
  explicit `2×2` determinant of `T^2` entries.
* `col1_support`, `col2_support`, `col_supports_disjoint`,
  `checkerboard_no_crossing` — the finite **LGV / Pauli** shadow: the two
  injected right-movers propagate into *disjoint* sets of output configurations,
  so in every two-particle amplitude at most one of the two path families
  (direct vs. crossing) is nonzero — crossing families never contribute.
* `checkerboard_straight_amplitude` — the headline value: the two right-movers
  injected at sites `0, 1` pass straight through to sites `2, 3` with
  two-particle amplitude `1`.
* `checkerboard_amplitude_ratQ` — the same identity read literally in `ℚ[m]`
  (`R = Polynomial ℚ`, `m = X`).

## Claim boundary

This is finite algebra only.  It does *not* prove positivity of any
Gupta–Bleuler quotient, the general LGV involution theorem `T-P3`, or the
exterior quotient flagship `L-Q8-5`.  The crossing-cancellation content is, for
this minimal instance, vacuous by disjointness of the two output supports; that
is recorded honestly as `col_supports_disjoint` / `checkerboard_no_crossing`
rather than dressed up as a nontrivial cancellation.

Provenance: clean-room finite formalization of `Q08_answer.md`, Section 3
("Smallest checkable instance") and ladder target `L-Q8-4`.
-/

open scoped BigOperators
open exteriorPower

namespace PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle

variable {R : Type*} [CommRing R]

/-! ## General T-P2: `k`-particle amplitudes are determinants -/

/-- **T-P2 (general).** For an endomorphism `A` of a module `M`, readout
functionals `g : Fin n → M*` and injected states `f : Fin n → M`, the
`n`-particle amplitude — the pairing of `Λ^n(g)` against `Λ^n(A)` applied to
`Λ^n(f)` — equals the determinant of the matrix of one-particle amplitudes
`g j (A (f i))`.  This is functoriality of the exterior power together with the
exterior/dual pairing being a determinant. -/
theorem kParticle_amplitude_eq_det {M : Type*} [AddCommGroup M] [Module R M]
    {n : ℕ} (A : M →ₗ[R] M) (g : Fin n → Module.Dual R M) (f : Fin n → M) :
    (pairingDual R M n) (ιMulti R n g) (map n A (ιMulti R n f))
      = (Matrix.of fun i j => (g j) (A (f i))).det := by
  rw [map_apply_ιMulti, pairingDual_ιMulti_ιMulti]
  rfl

/-! ## The concrete L=4 checkerboard transfer operator -/

/-- One-particle configuration space: `L = 4` sites times a 2-valued chirality
(`0 = right-mover`, `1 = left-mover`). -/
abbrev Idx := Fin 4 × Fin 2

/-- The straight-move part of the transfer operator: right-movers shift right by
one site, left-movers shift left by one site.  Open boundaries are automatic —
a right-mover at site `3` (resp. left-mover at site `0`) has no target and falls
off. -/
def shiftOp : Matrix Idx Idx R := Matrix.of fun tgt src =>
  (if src.2 = 0 ∧ tgt.2 = 0 ∧ tgt.1.val = src.1.val + 1 then 1 else 0) +
  (if src.2 = 1 ∧ tgt.2 = 1 ∧ src.1.val = tgt.1.val + 1 then 1 else 0)

/-- The turn part of the transfer operator: flip chirality in place. -/
def flipOp : Matrix Idx Idx R := Matrix.of fun tgt src =>
  if tgt.1 = src.1 ∧ tgt.2 ≠ src.2 then 1 else 0

/-- The one-step checkerboard transfer operator with turn amplitude `m`:
`T = (right-shift on right-movers) ⊕ (left-shift on left-movers) + m · (flip)`. -/
def T (m : R) : Matrix Idx Idx R := Matrix.of fun tgt src =>
  (if src.2 = 0 ∧ tgt.2 = 0 ∧ tgt.1.val = src.1.val + 1 then 1 else 0) +
  (if src.2 = 1 ∧ tgt.2 = 1 ∧ src.1.val = tgt.1.val + 1 then 1 else 0) +
  (if tgt.1 = src.1 ∧ tgt.2 ≠ src.2 then m else 0)

/-! ## T-P1: word expansion of the transfer operator -/

/-- The transfer operator splits into its straight part and `m ·` its turn
part. -/
theorem T_decomp (m : R) : T m = shiftOp + m • flipOp := by
  ext tgt src
  simp only [T, shiftOp, flipOp, Matrix.of_apply, Matrix.add_apply, Matrix.smul_apply,
    smul_eq_mul, mul_ite, mul_one, mul_zero]

/-- **T-P1 (word expansion at `N = 2`).**  The two-step propagator expands into
the four length-2 words in `{straight, turn}`, each weighted by `m^(#turns)`:
`T^2 = SS + m·(ST + TS) + m²·TT`. -/
theorem T_sq_word_expansion (m : R) :
    T m * T m = shiftOp * shiftOp + m • (shiftOp * flipOp) + m • (flipOp * shiftOp)
      + (m * m) • (flipOp * flipOp) := by
  rw [T_decomp, Matrix.add_mul, Matrix.mul_add, Matrix.mul_add]
  simp only [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  abel

/-! ## The two output supports and the finite LGV / Pauli shadow -/

/-- The propagator column for a right-mover injected at site `0`: after two
steps it lands only on `(0,0)` (turn–turn), `(1,1)` (straight–turn), or `(2,0)`
(straight–straight). -/
theorem col1_support (m : R) (tgt : Idx) (h : (T m * T m) tgt (0, 0) ≠ 0) :
    tgt = (0, 0) ∨ tgt = (1, 1) ∨ tgt = (2, 0) := by
  fin_cases tgt <;>
    simp_all [Matrix.mul_apply, T, Matrix.of_apply, Fintype.sum_prod_type,
      Fin.sum_univ_four, Fin.sum_univ_two]

/-- The propagator column for a right-mover injected at site `1`: after two
steps it lands only on `(1,0)`, `(0,1)`, `(2,1)`, or `(3,0)`. -/
theorem col2_support (m : R) (tgt : Idx) (h : (T m * T m) tgt (1, 0) ≠ 0) :
    tgt = (1, 0) ∨ tgt = (0, 1) ∨ tgt = (2, 1) ∨ tgt = (3, 0) := by
  fin_cases tgt <;>
    simp_all [Matrix.mul_apply, T, Matrix.of_apply, Fintype.sum_prod_type,
      Fin.sum_univ_four, Fin.sum_univ_two]

/-- The two injected right-movers propagate into **disjoint** output supports:
for every output configuration, at least one of the two propagator columns
vanishes there. -/
theorem col_supports_disjoint (m : R) (tgt : Idx) :
    (T m * T m) tgt (0, 0) = 0 ∨ (T m * T m) tgt (1, 0) = 0 := by
  fin_cases tgt <;>
    simp [Matrix.mul_apply, T, Matrix.of_apply, Fintype.sum_prod_type,
      Fin.sum_univ_four, Fin.sum_univ_two]

/-! ## T-P2 at the concrete propagator, and the two-particle amplitude -/

/-- **T-P2 (concrete).**  The exterior two-particle amplitude for the L=4, N=2
checkerboard — two right-movers injected at sites `0, 1`, read out at
`a1, a2` — equals the explicit `2×2` determinant of the propagator entries. -/
theorem checkerboard_twoParticle_amplitude_eq_det (m : R) (a1 a2 : Idx) :
    (pairingDual R (Idx → R) 2)
        (ιMulti R 2 ![(LinearMap.proj a1 : (Idx → R) →ₗ[R] R), LinearMap.proj a2])
        (map 2 ((T m * T m).mulVecLin)
          (ιMulti R 2 ![Pi.single (0, 0) 1, Pi.single (1, 0) 1]))
      = (T m * T m) a1 (0, 0) * (T m * T m) a2 (1, 0)
        - (T m * T m) a1 (1, 0) * (T m * T m) a2 (0, 0) := by
  rw [kParticle_amplitude_eq_det, Matrix.det_fin_two]
  simp [Matrix.mulVec_single]
  ring

/-- The two-particle amplitude as a bare `2×2` determinant of one-particle
amplitudes (`det [⟨out_i, T^2 in_j⟩]`), with `in = (site 0 right, site 1 right)`
and outputs `a1, a2`. -/
def twoAmp (m : R) (a1 a2 : Idx) : R :=
  (T m * T m) a1 (0, 0) * (T m * T m) a2 (1, 0)
    - (T m * T m) a1 (1, 0) * (T m * T m) a2 (0, 0)

theorem twoAmp_eq_amplitude (m : R) (a1 a2 : Idx) :
    twoAmp m a1 a2 =
      (pairingDual R (Idx → R) 2)
        (ιMulti R 2 ![(LinearMap.proj a1 : (Idx → R) →ₗ[R] R), LinearMap.proj a2])
        (map 2 ((T m * T m).mulVecLin)
          (ιMulti R 2 ![Pi.single (0, 0) 1, Pi.single (1, 0) 1])) := by
  rw [checkerboard_twoParticle_amplitude_eq_det]; rfl

/-- **Finite LGV / Pauli.**  In every two-particle amplitude, at most one of the
two path families contributes: the crossing family
`⟨a1, T^2 in_2⟩·⟨a2, T^2 in_1⟩` and the direct family
`⟨a1, T^2 in_1⟩·⟨a2, T^2 in_2⟩` are never both nonzero, because the two output
supports are disjoint.  (Here the reduction to vertex-disjoint families is
vacuous: no crossing configuration exists at all.) -/
theorem checkerboard_no_crossing (m : R) (a1 a2 : Idx) :
    (T m * T m) a1 (1, 0) * (T m * T m) a2 (0, 0) = 0
      ∨ (T m * T m) a1 (0, 0) * (T m * T m) a2 (1, 0) = 0 := by
  rcases col_supports_disjoint m a1 with h | h
  · exact Or.inr (by rw [h]; ring)
  · exact Or.inl (by rw [h]; ring)

/-- Headline value: the two right-movers injected at sites `0, 1` propagate
straight through to sites `2, 3` with two-particle amplitude `1` — the
vertex-disjoint straight–straight family. -/
theorem checkerboard_straight_amplitude (m : R) :
    twoAmp m (2, 0) (3, 0) = 1 := by
  simp [twoAmp, Matrix.mul_apply, T, Matrix.of_apply, Fintype.sum_prod_type,
    Fin.sum_univ_four, Fin.sum_univ_two]

/-! ## The identity read literally over `ℚ[m]` -/

/-- The straight-through two-particle amplitude read literally in `ℚ[m]`
(`m = X`). -/
theorem checkerboard_amplitude_ratQ :
    twoAmp (Polynomial.X : Polynomial ℚ) (2, 0) (3, 0) = 1 :=
  checkerboard_straight_amplitude _

/-- A turn–turn diagonal propagator entry read literally in `ℚ[m]`: a
right-mover injected at site `0` returns to `(0,0)` after two turns with
amplitude `m^2 = X^2`. -/
theorem checkerboard_return_ratQ :
    (T Polynomial.X * T Polynomial.X : Matrix Idx Idx (Polynomial ℚ)) (0, 0) (0, 0)
      = Polynomial.X ^ 2 := by
  simp [Matrix.mul_apply, T, Fintype.sum_prod_type, Fin.sum_univ_two]
  ring

end PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle
