import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Exact HNU endpoint winding integral

This file states the published `T^3 -> SU(2) ~= S^3` coordinate formula and its
normalized three-dimensional winding integral.  Unlike a local Weyl-Jacobian
certificate, the final theorem is the actual global endpoint invariant used in
the Higashikawa-Nakagawa-Ueda single-Weyl construction.

The proof has four independently useful rungs:

1. identify the exact matrix endpoint with the published four real coordinates;
2. prove those coordinates lie on the unit three-sphere;
3. prove the cube boundary is sent to the south pole;
4. evaluate the normalized oriented-volume integral as `1`.

Provenance: S. Higashikawa, M. Nakagawa, and M. Ueda, "Floquet chiral magnetic
effect", Phys. Rev. Lett. 123, 066403 (2019), arXiv:1806.06868, Supplemental
Material section "Nontriviality of U(k) as a map from T^3 to SU(2)", equations
for `u_1,...,u_4` and the winding integral.  Formula transcribed from the
official arXiv source archive.  No external code is copied.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUWindingIntegral

open HNUExactCore

noncomputable section

set_option maxHeartbeats 0

/-- The four real coordinates `(u1,u2,u3,u4)` of the exact HNU endpoint. -/
def hnuCoord (k : Fin 3 -> Real) : Fin 4 -> Real :=
  ![-Real.sin (k 0) * Real.cos (k 1 / 2) ^ 2 * Real.cos (k 2 / 2) ^ 2,
    -(Real.cos (k 0 / 2) ^ 2 * Real.sin (k 1) * Real.cos (k 2 / 2)) +
      (1 / 2 : Real) * Real.sin (k 0) * Real.cos (k 1 / 2) ^ 2 * Real.sin (k 2),
    -((1 / 2 : Real) * Real.sin (k 0) * Real.sin (k 1) * Real.cos (k 2 / 2)) -
      Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 * Real.sin (k 2),
    2 * Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 *
      Real.cos (k 2 / 2) ^ 2 - 1]

/-- Convert four sphere coordinates to the corresponding `SU(2)` matrix. -/
def coordMatrix (u : Fin 4 -> Real) : M2 :=
  (u 3 : Complex) • (1 : M2) + I •
    ((u 0 : Complex) • HNUExactCore.σ1 +
      (u 1 : Complex) • HNUExactCore.σ2 +
      (u 2 : Complex) • HNUExactCore.σ3)

/-- The source's coordinate formula is exactly the live depth-eight endpoint. -/
theorem endpoint_eq_coordMatrix (k : Fin 3 -> Real) :
    endpoint k = coordMatrix (hnuCoord k) := by
  ext i j
  unfold endpoint coordMatrix hnuCoord
  fin_cases i <;> fin_cases j
  · simp +decide [Matrix.mul_apply, Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3]
    norm_num [← Complex.exp_add, Complex.cos, Complex.sin]
    ring
    norm_num [mul_assoc, ← Complex.exp_nat_mul, ← Complex.exp_add]
    ring
  · simp +decide [Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3]
    ring
    norm_num [Complex.exp_re, Complex.exp_im, pow_two, Matrix.mul_apply]
    ring
    norm_num [Complex.sin, Complex.cos, ← Complex.exp_add]
    ring
    norm_num [← Complex.exp_nat_mul, ← Complex.exp_add]
    ring
    norm_num [mul_assoc, ← Complex.exp_add]
    ring
  · simp +decide [Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3]
    norm_num [Matrix.mul_apply, Complex.exp_re, Complex.exp_im,
      Real.cos, Real.sin]
    ring
    norm_num [Complex.sin, Complex.cos, ← Complex.exp_add]
    ring
    norm_num [sq, mul_assoc, ← Complex.exp_add]
    ring
  · simp +decide [Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3] at *
    simp +decide [Matrix.mul_apply, Fin.sum_univ_succ] at *
    simp +decide [Matrix.one_apply, Complex.cos, Complex.sin,
      Complex.exp_neg] at *
    ring_nf at *
    norm_num [← Complex.exp_nat_mul, ← Complex.exp_neg, ← Complex.exp_add]
    ring_nf at *
    norm_num [mul_assoc, ← Complex.exp_add]
    ring

/-- The four published coordinate functions land on the unit three-sphere. -/
theorem hnuCoord_sphere (k : Fin 3 -> Real) :
    Finset.univ.sum (fun i : Fin 4 => hnuCoord k i ^ 2) = 1 := by
  norm_num [Fin.sum_univ_succ, hnuCoord]
  have hsin0 : Real.sin (k 0) =
      2 * Real.sin (k 0 / 2) * Real.cos (k 0 / 2) := by
    calc
      Real.sin (k 0) = Real.sin (2 * (k 0 / 2)) := by
        congr 1
        ring
      _ = 2 * Real.sin (k 0 / 2) * Real.cos (k 0 / 2) := Real.sin_two_mul _
  have hsin1 : Real.sin (k 1) =
      2 * Real.sin (k 1 / 2) * Real.cos (k 1 / 2) := by
    calc
      Real.sin (k 1) = Real.sin (2 * (k 1 / 2)) := by
        congr 1
        ring
      _ = 2 * Real.sin (k 1 / 2) * Real.cos (k 1 / 2) := Real.sin_two_mul _
  have hsin2 : Real.sin (k 2) =
      2 * Real.sin (k 2 / 2) * Real.cos (k 2 / 2) := by
    calc
      Real.sin (k 2) = Real.sin (2 * (k 2 / 2)) := by
        congr 1
        ring
      _ = 2 * Real.sin (k 2 / 2) * Real.cos (k 2 / 2) := Real.sin_two_mul _
  have hcos0 : Real.cos (k 0 * (1 / 2 : Real)) ^ 2 =
      1 - Real.sin (k 0 * (1 / 2 : Real)) ^ 2 := by
    nlinarith [Real.sin_sq_add_cos_sq (k 0 * (1 / 2 : Real))]
  have hcos1 : Real.cos (k 1 * (1 / 2 : Real)) ^ 2 =
      1 - Real.sin (k 1 * (1 / 2 : Real)) ^ 2 := by
    nlinarith [Real.sin_sq_add_cos_sq (k 1 * (1 / 2 : Real))]
  have hcos2 : Real.cos (k 2 * (1 / 2 : Real)) ^ 2 =
      1 - Real.sin (k 2 * (1 / 2 : Real)) ^ 2 := by
    nlinarith [Real.sin_sq_add_cos_sq (k 2 * (1 / 2 : Real))]
  have hcos0_four : Real.cos (k 0 * (1 / 2 : Real)) ^ 4 =
      (1 - Real.sin (k 0 * (1 / 2 : Real)) ^ 2) ^ 2 := by
    rw [show Real.cos (k 0 * (1 / 2 : Real)) ^ 4 =
      (Real.cos (k 0 * (1 / 2 : Real)) ^ 2) ^ 2 by ring, hcos0]
  have hcos1_four : Real.cos (k 1 * (1 / 2 : Real)) ^ 4 =
      (1 - Real.sin (k 1 * (1 / 2 : Real)) ^ 2) ^ 2 := by
    rw [show Real.cos (k 1 * (1 / 2 : Real)) ^ 4 =
      (Real.cos (k 1 * (1 / 2 : Real)) ^ 2) ^ 2 by ring, hcos1]
  have hcos2_four : Real.cos (k 2 * (1 / 2 : Real)) ^ 4 =
      (1 - Real.sin (k 2 * (1 / 2 : Real)) ^ 2) ^ 2 := by
    rw [show Real.cos (k 2 * (1 / 2 : Real)) ^ 4 =
      (Real.cos (k 2 * (1 / 2 : Real)) ^ 2) ^ 2 by ring, hcos2]
  rw [hsin0, hsin1, hsin2]
  ring_nf
  rw [hcos0, hcos1, hcos2, hcos0_four, hcos1_four, hcos2_four]
  ring

/-- If any momentum coordinate is on a cube face, the coordinate map is the
south pole `(0,0,0,-1)`. -/
theorem hnuCoord_boundary (k : Fin 3 -> Real)
    (hface : ∃ i, k i = Real.pi ∨ k i = -Real.pi) :
    hnuCoord k = ![0, 0, 0, -1] := by
  obtain ⟨i, hi⟩ := hface
  fin_cases i <;> simp_all +decide [hnuCoord]
  · rcases hi with (hi | hi) <;> norm_num [hi, neg_div]
  · cases hi <;> simp_all +decide [Real.sin_pi, Real.cos_pi, neg_div]
  · rcases hi with (hi | hi) <;> norm_num [hi, neg_div]

/-- Partial derivative in the first momentum coordinate. -/
def partial0 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun x : Real => hnuCoord ![x, k 1, k 2]) (k 0)

/-- Partial derivative in the second momentum coordinate. -/
def partial1 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun y : Real => hnuCoord ![k 0, y, k 2]) (k 1)

/-- Partial derivative in the third momentum coordinate. -/
def partial2 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun z : Real => hnuCoord ![k 0, k 1, z]) (k 2)

/-- Matrix whose columns are `u`, `partial_1 u`, `partial_2 u`, and
`partial_3 u`.  Its determinant is the oriented `S^3` volume density. -/
def orientedFrame (k : Fin 3 -> Real) : Matrix (Fin 4) (Fin 4) Real :=
  fun i => ![hnuCoord k i, partial0 k i, partial1 k i, partial2 k i]

/-- The oriented `S^3` volume density of the endpoint coordinates. -/
def windingDensity (k : Fin 3 -> Real) : Real := (orientedFrame k).det

/-- The exact nested integral over the Brillouin cube. -/
def windingIntegral : Real :=
  intervalIntegral (fun x : Real =>
    intervalIntegral (fun y : Real =>
      intervalIntegral (fun z : Real => windingDensity ![x, y, z])
        (-Real.pi) Real.pi MeasureTheory.volume)
      (-Real.pi) Real.pi MeasureTheory.volume)
    (-Real.pi) Real.pi MeasureTheory.volume

/-- The normalized HNU three-dimensional endpoint winding. -/
def windingNumber : Real := (1 / (2 * Real.pi ^ 2)) * windingIntegral

/-- Exact analytic density obtained from the four published coordinates. -/
lemma windingDensity_formula (x y z : Real) :
    windingDensity ![x, y, z] =
      Real.cos (x / 2) ^ 2 * Real.cos (y / 2) ^ 4 * Real.cos (z / 2) ^ 3 := by
  unfold windingDensity orientedFrame
  unfold partial0 partial1 partial2 hnuCoord
  simp +decide [Fin.sum_univ_succ, Matrix.det_succ_row_zero] at *
  rw [deriv_pi, deriv_pi, deriv_pi] <;> norm_num [Fin.forall_fin_succ]
  simp +decide [Fin.succAbove] at *
  norm_num [Real.differentiableAt_sin, Real.differentiableAt_cos]
  ring
  rw [show x = 2 * (x / 2) by ring, show y = 2 * (y / 2) by ring,
    show z = 2 * (z / 2) by ring, Real.sin_two_mul, Real.sin_two_mul,
    Real.sin_two_mul]
  ring
  rw [show Real.sin (x * (1 / 2)) ^ 4 = (Real.sin (x * (1 / 2)) ^ 2) ^ 2 by ring,
    show Real.sin (y * (1 / 2)) ^ 3 =
      Real.sin (y * (1 / 2)) * Real.sin (y * (1 / 2)) ^ 2 by ring,
    show Real.sin (z * (1 / 2)) ^ 3 =
      Real.sin (z * (1 / 2)) * Real.sin (z * (1 / 2)) ^ 2 by ring,
    Real.sin_sq, Real.sin_sq, Real.sin_sq]
  ring
  rw [show x = 2 * (x / 2) by ring, show y = 2 * (y / 2) by ring,
    show z = 2 * (z / 2) by ring, Real.cos_two_mul, Real.cos_two_mul,
    Real.cos_two_mul]
  ring

/-- The first separated factor in the global integral. -/
lemma integral_cos_half_sq :
    intervalIntegral (fun x : Real => Real.cos (x / 2) ^ 2)
      (-Real.pi) Real.pi MeasureTheory.volume = Real.pi := by
  rw [intervalIntegral.integral_comp_div (fun x => Real.cos x ^ 2)] <;>
    norm_num
  norm_num [neg_div]
  ring

/-- The second separated factor in the global integral. -/
lemma integral_cos_half_fourth :
    intervalIntegral (fun y : Real => Real.cos (y / 2) ^ 4)
      (-Real.pi) Real.pi MeasureTheory.volume = 3 * Real.pi / 4 := by
  rw [intervalIntegral.integral_comp_div (fun x => Real.cos x ^ 4)] <;>
    norm_num
  erw [integral_cos_pow]
  norm_num [neg_div]
  ring

/-- The third separated factor in the global integral. -/
lemma integral_cos_half_cube :
    intervalIntegral (fun z : Real => Real.cos (z / 2) ^ 3)
      (-Real.pi) Real.pi MeasureTheory.volume = 8 / 3 := by
  rw [intervalIntegral.integral_comp_div (fun x => Real.cos x ^ 3)] <;>
    norm_num
  norm_num [neg_div]

/-- **Published global invariant.**  The exact HNU endpoint has winding one. -/
theorem windingNumber_eq_one : windingNumber = 1 := by
  unfold windingNumber windingIntegral
  have h_integral :
      ∫ x in (-Real.pi)..Real.pi,
          ∫ y in (-Real.pi)..Real.pi,
            ∫ z in (-Real.pi)..Real.pi, windingDensity ![x, y, z] =
      ∫ x in (-Real.pi)..Real.pi,
          ∫ y in (-Real.pi)..Real.pi,
            Real.cos (x / 2) ^ 2 * Real.cos (y / 2) ^ 4 * (8 / 3) := by
    simp [windingDensity_formula]
    exact Or.inl integral_cos_half_cube
  rw [h_integral]
  norm_num [integral_cos_half_sq, integral_cos_half_fourth,
    integral_cos_half_cube]
  ring_nf
  norm_num [Real.pi_ne_zero]

end

end PhysicsSM.Draft.NullEdge.HNUWindingIntegral

/-!
## Build-enforced assumption guards

The four requested targets and the analytic density rung are checked against
Lean's standard quotient/extensionality/choice assumptions. Any future change in
their assumption dependencies makes this module fail to build.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWindingIntegral.endpoint_eq_coordMatrix' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms PhysicsSM.Draft.NullEdge.HNUWindingIntegral.endpoint_eq_coordMatrix

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWindingIntegral.hnuCoord_sphere' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PhysicsSM.Draft.NullEdge.HNUWindingIntegral.hnuCoord_sphere

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWindingIntegral.hnuCoord_boundary' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms PhysicsSM.Draft.NullEdge.HNUWindingIntegral.hnuCoord_boundary

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWindingIntegral.windingDensity_formula' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms PhysicsSM.Draft.NullEdge.HNUWindingIntegral.windingDensity_formula

/-- info: 'PhysicsSM.Draft.NullEdge.HNUWindingIntegral.windingNumber_eq_one' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms PhysicsSM.Draft.NullEdge.HNUWindingIntegral.windingNumber_eq_one
