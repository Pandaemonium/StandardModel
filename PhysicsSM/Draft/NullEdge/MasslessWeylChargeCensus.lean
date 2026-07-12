import Mathlib

/-!
# Exact massless Weyl zero/pi charge census

This module is the self-contained arithmetic core of the ordered massless Weyl
census. It depends on `Mathlib` only and will be connected to the live restricted
Bloch symbol by `LiveWeylJacobian`; it does not itself prove that the displayed
sixteen points are the complete crossing set. It proves:

* the genuine real `3×3` Jacobian `Jm` of the ordered massless positive-Weyl
  Pauli vector `(u1,u2,u3)` with `U(q)=e^{-iqxσ1}e^{-iqyσ2}e^{-iqzσ3}`;
* the closed determinant identity `det Jm = u0 · (cos²qy − sin²qy)`;
* the **exact** value `det Jm = ±1` at all sixteen crossings; and
* the two separate sector sums, proving the zero (`U=+I`) and π (`U=-I`) sectors
  each have vanishing total local charge.

Because every determinant here is exactly `±1`, the local crossing charge
`sign(det Jm)` coincides with `det Jm` itself at each node, so the sum of the
real determinants below **is** the signed-charge census sum.

The census is over a *principal-torus representative*: cube corners use
`qj ∈ {0, π}` and body centers use `qj ∈ {±π/2}`; the corner count of eight
relies on the periodic identification `π ≡ −π` (see the audit report).

Provenance: independently recomputed and proved by Aristotle hostile audit
project `9abaa7c3-b32f-4e04-831d-850c06cffb1a`, task
`656cb806-ac71-4ef4-8edd-b1051c7969b2`. The audit packet omitted the live
repository dependency tree, so its packaging-failure diagnosis does not apply
to this integrated module.
-/

namespace PhysicsSM.Draft.NullEdge.MasslessWeylChargeCensus

open Matrix Real

/-- Zeroth Pauli coefficient `u0(q)` of the ordered massless Weyl step. -/
noncomputable def u0 (qx qy qz : ℝ) : ℝ :=
  cos qx * cos qy * cos qz - sin qx * sin qy * sin qz

/-- The genuine real `3×3` Jacobian of the Pauli vector `(u1,u2,u3)`, where
`u1 = sx cy cz + cx sy sz`, `u2 = cx sy cz − sx cy sz`, `u3 = cx cy sz + sx sy cz`.
Entry `(i,j)` is `∂u_{i+1}/∂q_j`. -/
noncomputable def Jm (qx qy qz : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![ cos qx*cos qy*cos qz - sin qx*sin qy*sin qz,
      -(sin qx*sin qy*cos qz) + cos qx*cos qy*sin qz,
      -(sin qx*cos qy*sin qz) + cos qx*sin qy*cos qz;
      -(sin qx*sin qy*cos qz) - cos qx*cos qy*sin qz,
      cos qx*cos qy*cos qz + sin qx*sin qy*sin qz,
      -(sin qx*cos qy*cos qz) - cos qx*sin qy*sin qz;
      -(sin qx*cos qy*sin qz) + cos qx*sin qy*cos qz,
      sin qx*cos qy*cos qz - cos qx*sin qy*sin qz,
      cos qx*cos qy*cos qz - sin qx*sin qy*sin qz ]

/-- Closed determinant identity: `det Jm = u0 · (cos²qy − sin²qy)`.  This is *not*
a free polynomial identity; it holds only modulo the three Pythagorean relations,
so the two off-axis (`x`,`z`) relations are substituted explicitly. -/
theorem detJm_eq (qx qy qz : ℝ) :
    (Jm qx qy qz).det = u0 qx qy qz * (cos qy ^ 2 - sin qy ^ 2) := by
  have hx : sin qx ^ 2 = 1 - cos qx ^ 2 := by rw [Real.sin_sq]
  have hz : sin qz ^ 2 = 1 - cos qz ^ 2 := by rw [Real.sin_sq]
  simp only [Jm, u0, Matrix.det_fin_three, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.head_fin_const, Matrix.cons_val_fin_one,
    Matrix.of_apply, Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  ring_nf
  rw [show sin qx ^ 3 = sin qx * sin qx ^ 2 by ring,
      show sin qz ^ 3 = sin qz * sin qz ^ 2 by ring, hx, hz]
  ring

/-! ## The sixteen exact determinant values -/

-- Zero sector (U = +I): four cube corners, `det = +1`.
theorem det_c0 : (Jm 0 0 0).det = 1 := by simp [Jm, Matrix.det_fin_three]
theorem det_c1 : (Jm 0 π π).det = 1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]
theorem det_c2 : (Jm π 0 π).det = 1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]
theorem det_c3 : (Jm π π 0).det = 1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]

-- Zero sector (U = +I): four body centers, `det = -1`.
theorem det_b0 : (Jm (π/2) (π/2) (-(π/2))).det = -1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_b1 : (Jm (π/2) (-(π/2)) (π/2)).det = -1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_b2 : (Jm (-(π/2)) (π/2) (π/2)).det = -1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_b3 : (Jm (-(π/2)) (-(π/2)) (-(π/2))).det = -1 := by
  simp [Jm, Matrix.det_fin_three]

-- π sector (U = -I): four cube corners, `det = -1`.
theorem det_p0 : (Jm 0 0 π).det = -1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]
theorem det_p1 : (Jm 0 π 0).det = -1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]
theorem det_p2 : (Jm π 0 0).det = -1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]
theorem det_p3 : (Jm π π π).det = -1 := by
  simp [Jm, Matrix.det_fin_three, Real.cos_pi, Real.sin_pi]

-- π sector (U = -I): four body centers, `det = +1`.
theorem det_q0 : (Jm (π/2) (π/2) (π/2)).det = 1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_q1 : (Jm (π/2) (-(π/2)) (-(π/2))).det = 1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_q2 : (Jm (-(π/2)) (π/2) (-(π/2))).det = 1 := by
  simp [Jm, Matrix.det_fin_three]
theorem det_q3 : (Jm (-(π/2)) (-(π/2)) (π/2)).det = 1 := by
  simp [Jm, Matrix.det_fin_three]

/-! ## The two separate sector census sums (each vanishes) -/

/-- Zero sector (`U = +I`): four `+1` corners and four `−1` body centers cancel. -/
theorem zero_sector_charge_sum :
    (Jm 0 0 0).det + (Jm 0 π π).det + (Jm π 0 π).det + (Jm π π 0).det
      + (Jm (π/2) (π/2) (-(π/2))).det + (Jm (π/2) (-(π/2)) (π/2)).det
      + (Jm (-(π/2)) (π/2) (π/2)).det + (Jm (-(π/2)) (-(π/2)) (-(π/2))).det = 0 := by
  rw [det_c0, det_c1, det_c2, det_c3, det_b0, det_b1, det_b2, det_b3]; ring

/-- π sector (`U = -I`): four `−1` corners and four `+1` body centers cancel. -/
theorem pi_sector_charge_sum :
    (Jm 0 0 π).det + (Jm 0 π 0).det + (Jm π 0 0).det + (Jm π π π).det
      + (Jm (π/2) (π/2) (π/2)).det + (Jm (π/2) (-(π/2)) (-(π/2))).det
      + (Jm (-(π/2)) (π/2) (-(π/2))).det + (Jm (-(π/2)) (-(π/2)) (π/2)).det = 0 := by
  rw [det_p0, det_p1, det_p2, det_p3, det_q0, det_q1, det_q2, det_q3]; ring

/-- Sanity: the grand total over all sixteen crossings is also zero (this weaker
statement would hold even if the sectors did *not* separately cancel, so it is
**not** a substitute for the two sector theorems above). -/
theorem total_charge_sum :
    ((Jm 0 0 0).det + (Jm 0 π π).det + (Jm π 0 π).det + (Jm π π 0).det
      + (Jm (π/2) (π/2) (-(π/2))).det + (Jm (π/2) (-(π/2)) (π/2)).det
      + (Jm (-(π/2)) (π/2) (π/2)).det + (Jm (-(π/2)) (-(π/2)) (-(π/2))).det)
    + ((Jm 0 0 π).det + (Jm 0 π 0).det + (Jm π 0 0).det + (Jm π π π).det
      + (Jm (π/2) (π/2) (π/2)).det + (Jm (π/2) (-(π/2)) (-(π/2))).det
      + (Jm (-(π/2)) (π/2) (-(π/2))).det + (Jm (-(π/2)) (-(π/2)) (π/2)).det) = 0 := by
  rw [zero_sector_charge_sum, pi_sector_charge_sum]; ring

end PhysicsSM.Draft.NullEdge.MasslessWeylChargeCensus
