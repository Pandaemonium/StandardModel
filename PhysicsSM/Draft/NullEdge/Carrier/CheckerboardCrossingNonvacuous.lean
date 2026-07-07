import PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle

/-!
# Q08 `L-Q8-4+`: a *nonvacuous* two-particle crossing configuration on the L=4 checkerboard

This module is the sharpest finite successor to
`CheckerboardTwoParticle.lean` (ladder entry `L-Q8-4`).  That module proved the
two-particle determinant identity (T-P2) and recorded, honestly, that its
crossing cancellation is **vacuous**: the two right-movers injected at the
*adjacent* sites `0, 1` land in disjoint output supports
(`col_supports_disjoint`, `checkerboard_no_crossing`), so no crossing
configuration exists at all.

The reason for that vacuity is a parity obstruction, made precise here.  The 1+1
checkerboard is bipartite: a right-mover injected at site `s` can only reach
outputs whose site has a fixed parity relative to `s`.  Two right-movers at
sites of *opposite* parity (`0` and `1`) therefore never share an output — the
supports are disjoint for structural reasons, independent of the number of
steps.  To obtain a genuine crossing one must inject at sites of the **same**
parity.  The minimal such instance is already available at `L = 4`, `N = 2`:
two right-movers injected at sites `0` and `2`.

## What is proved (finite algebra, kernel-checked, over `ℚ[m]`)

Let `in₁ = (0,0)`, `in₂ = (2,0)` be the two same-parity right-mover injections,
and read out at `a₁ = (1,1)`, `a₂ = (2,0)`.  The four one-particle `T²`
amplitudes are

```
⟨a₁ | in₁⟩ = X       ⟨a₁ | in₂⟩ = X
⟨a₂ | in₁⟩ = 1       ⟨a₂ | in₂⟩ = X²
```

(`entry_a1_in1`, `entry_a1_in2`, `entry_a2_in1`, `entry_a2_in2`), so:

* `output_a1_in_both_supports` — the output `(1,1)` lies in **both** input
  supports (`⟨a₁|in₁⟩ ≠ 0` and `⟨a₁|in₂⟩ ≠ 0`).  This is the exact negation of
  the disjoint-support phenomenon of the minimal `L-Q8-4` case, so the crossing
  configuration is genuinely present.
* `crossing_family_nonzero` — the *crossing* family product
  `⟨a₁|in₂⟩·⟨a₂|in₁⟩ = X ≠ 0`, and the *direct* family product
  `⟨a₁|in₁⟩·⟨a₂|in₂⟩ = X³ ≠ 0`.  **Both** path families contribute; this is a
  nonvacuous crossing, unlike `checkerboard_no_crossing`.
* `twoParticle_amplitude_eq_det_general` — the general T-P2 determinant identity
  for *arbitrary* input columns `b₁, b₂` (dropping the hard-coded `(0,0),(1,0)`
  of `checkerboard_twoParticle_amplitude_eq_det`), so same-parity injections are
  formally covered.
* `twoAmpGen_nonvacuous` — the resulting two-particle amplitude is
  `X³ - X = det`, with the crossing term `-X` **surviving**.
* `naive_LGV_reduction_false` — the honest negative result: on this transfer
  model the two-particle amplitude is *not* equal to the direct (non-crossing)
  family alone (`X³ - X ≠ X³`).  The crossing contribution does **not** cancel.

## Claim boundary (IMPORTANT — corrects the naive T-P3 narrative)

This is finite algebra only.  The last theorem is a genuine obstruction, not a
success: it shows that the naive Lindström–Gessel–Viennot reduction "the signed
two-particle amplitude equals the unsigned sum over vertex-disjoint (non-crossing)
path families" is **false** for the checkerboard transfer operator as
pre-registered (turns are in-place chirality flips, i.e. vertical edges).  The
crossing pair here crosses at a *mid-edge* light-cone scattering point, not at a
shared lattice vertex, so the vertex-intersection LGV involution does not apply
and the `-X` term persists in the determinant.

This is exactly the `Q08_answer.md` V4 caution ("the crossing sign is the planar
shadow of the exterior algebra, not the origin of statistics") turned into a
kernel-checked statement.  A *true* nonvacuous LGV crossing-cancellation
theorem (T-P3 / `L-Q8-8`) therefore requires either (i) a corrected planar,
time-directed DAG in which crossing ⇔ shared vertex, together with the
swap-at-crossing involution, or (ii) a source/sink configuration certified
LGV-compatible; it is *not* a one-line specialization of the determinant
identity.  The robust, model-independent content remains T-P2 (the determinant
itself), carried by the functor `Λ`, not by crossing signs.

Provenance: Aristotle project `26fa682c` / task `8c183d8e`, a clean-room finite
formalization extending `Q08_answer.md`, Section 3 and ladder targets `L-Q8-4` /
`L-Q8-8` / T-P3.  Successor to `CheckerboardTwoParticle.lean`.
-/

open scoped BigOperators
open exteriorPower Polynomial

namespace PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle

variable {R : Type*} [CommRing R]

/-! ## T-P2 for arbitrary input columns

The concrete determinant identity of `checkerboard_twoParticle_amplitude_eq_det`
hard-codes the injections `(0,0), (1,0)`.  Here it is stated for arbitrary input
basis states `b₁, b₂`, so that same-parity injections (needed for a nonvacuous
crossing) are covered by the same theorem. -/

/-- **T-P2 (general inputs).**  For any two input basis states `b₁, b₂` and
readouts `a₁, a₂`, the exterior two-particle amplitude equals the `2×2`
determinant of the propagator entries. -/
theorem twoParticle_amplitude_eq_det_general (m : R) (b1 b2 a1 a2 : Idx) :
    (pairingDual R (Idx → R) 2)
        (ιMulti R 2 ![(LinearMap.proj a1 : (Idx → R) →ₗ[R] R), LinearMap.proj a2])
        (map 2 ((T m * T m).mulVecLin)
          (ιMulti R 2 ![Pi.single b1 1, Pi.single b2 1]))
      = (T m * T m) a1 b1 * (T m * T m) a2 b2
        - (T m * T m) a1 b2 * (T m * T m) a2 b1 := by
  rw [kParticle_amplitude_eq_det, Matrix.det_fin_two]
  simp [Matrix.mulVec_single]
  ring

/-- The two-particle (determinant) amplitude for arbitrary injections `b₁, b₂`
read out at `a₁, a₂`. -/
def twoAmpGen (m : R) (b1 b2 a1 a2 : Idx) : R :=
  (T m * T m) a1 b1 * (T m * T m) a2 b2
    - (T m * T m) a1 b2 * (T m * T m) a2 b1

theorem twoAmpGen_eq_amplitude (m : R) (b1 b2 a1 a2 : Idx) :
    twoAmpGen m b1 b2 a1 a2 =
      (pairingDual R (Idx → R) 2)
        (ιMulti R 2 ![(LinearMap.proj a1 : (Idx → R) →ₗ[R] R), LinearMap.proj a2])
        (map 2 ((T m * T m).mulVecLin)
          (ιMulti R 2 ![Pi.single b1 1, Pi.single b2 1])) := by
  rw [twoParticle_amplitude_eq_det_general]; rfl

/-! ## The four one-particle amplitudes of the minimal same-parity instance

Injections `in₁ = (0,0)`, `in₂ = (2,0)`; readouts `a₁ = (1,1)`, `a₂ = (2,0)`. -/

/-- `⟨(1,1) | in (0,0)⟩ = X`: straight then turn. -/
theorem entry_a1_in1 :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (0, 0) = X := by
  simp [Matrix.mul_apply, T, Fintype.sum_prod_type, Fin.sum_univ_four, Fin.sum_univ_two]

/-- `⟨(1,1) | in (2,0)⟩ = X`: turn then straight (as a left-mover). -/
theorem entry_a1_in2 :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (2, 0) = X := by
  simp [Matrix.mul_apply, T, Fintype.sum_prod_type, Fin.sum_univ_four, Fin.sum_univ_two]

/-- `⟨(2,0) | in (0,0)⟩ = 1`: straight then straight. -/
theorem entry_a2_in1 :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (2, 0) (0, 0) = 1 := by
  simp [Matrix.mul_apply, T, Fintype.sum_prod_type, Fin.sum_univ_four, Fin.sum_univ_two]

/-- `⟨(2,0) | in (2,0)⟩ = X²`: turn then turn. -/
theorem entry_a2_in2 :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (2, 0) (2, 0) = X ^ 2 := by
  simp [Matrix.mul_apply, T, Fintype.sum_prod_type, Fin.sum_univ_four, Fin.sum_univ_two]; ring

/-! ## Nonvacuity of the crossing configuration -/

/-- **Support overlap (negation of the `L-Q8-4` disjointness).**  The output
`(1,1)` lies in *both* input supports for same-parity injections `(0,0)` and
`(2,0)`.  Contrast `col_supports_disjoint`, which holds for the *opposite*-parity
injections `(0,0), (1,0)`. -/
theorem output_a1_in_both_supports :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (0, 0) ≠ 0
      ∧ (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (2, 0) ≠ 0 := by
  refine ⟨?_, ?_⟩ <;> simp [entry_a1_in1, entry_a1_in2, X_ne_zero]

/-- **Nonvacuous crossing.**  Both path families are individually nonzero: the
crossing family product `⟨a₁|in₂⟩·⟨a₂|in₁⟩ = X ≠ 0` and the direct family
product `⟨a₁|in₁⟩·⟨a₂|in₂⟩ = X³ ≠ 0`.  Compare `checkerboard_no_crossing`, where
one of the two products is forced to vanish. -/
theorem crossing_family_nonzero :
    (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (2, 0)
        * (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (2, 0) (0, 0) = X
      ∧ (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (0, 0)
        * (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (2, 0) (2, 0) = X ^ 3 := by
  refine ⟨?_, ?_⟩
  · rw [entry_a1_in2, entry_a2_in1, mul_one]
  · rw [entry_a1_in1, entry_a2_in2]; ring

/-! ## The two-particle amplitude and the LGV obstruction -/

/-- The two-particle amplitude of the minimal same-parity instance is
`X³ - X`: the direct family `X³` minus the (nonzero) crossing family `X`. -/
theorem twoAmpGen_nonvacuous :
    twoAmpGen (X : Polynomial ℚ) (0, 0) (2, 0) (1, 1) (2, 0) = X ^ 3 - X := by
  unfold twoAmpGen
  rw [entry_a1_in1, entry_a2_in2, entry_a1_in2, entry_a2_in1]
  ring

/-- **Kill condition for naive T-P3.**  On this transfer model the signed
two-particle amplitude is *not* equal to the direct (non-crossing) family alone:
`X³ - X ≠ X³`.  The crossing contribution `-X` does not cancel, so the naive
"amplitude = unsigned vertex-disjoint family sum" reading of LGV is **false**
here.  (The crossing path pair crosses at a mid-edge light-cone point, not at a
shared lattice vertex, so the vertex-intersection LGV involution does not
apply.) -/
theorem naive_LGV_reduction_false :
    twoAmpGen (X : Polynomial ℚ) (0, 0) (2, 0) (1, 1) (2, 0)
      ≠ (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (1, 1) (0, 0)
        * (T X * T X : Matrix Idx Idx (Polynomial ℚ)) (2, 0) (2, 0) := by
  rw [twoAmpGen_nonvacuous, entry_a1_in1, entry_a2_in2]
  -- goal: X ^ 3 - X ≠ X * X ^ 2
  intro h
  -- then X = 0 in ℚ[X], contradiction
  have hX : (X : Polynomial ℚ) = 0 := by ring_nf at h ⊢; linear_combination -h
  exact X_ne_zero hX

end PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle
