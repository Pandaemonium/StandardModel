import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo

/-!
# Null microsteps with longer effective range: the symmetric depth-two hyperdiamond step

This module executes the second lateral route of the NE-3PLUS1 program
(`CODEX_FLAVOR_COVER_OCTONION_ROUTE_2026-07-13.md`, section "null microsteps,
longer effective hops").  The key conceptual distinction is:

```
primitive locality = nearest-neighbor null support at every substep
effective range     = the larger Laurent support of one complete period
```

Every substep here is either a **null conditional shift** `factor q g`
(with `g` a Hermitian involution, so `factor q g = e^{-iq} P₊ + e^{+iq} P₋`,
i.e. a lightlike unit shift of each chirality eigenspace) or the **onsite mass
coin** `factor (2θ) β`.  No primitive substep exceeds a nearest-neighbor hop.

The candidate is the palindromic (symmetric Strang) period

```
U(qx,qy,qz,θ) =
  factor qx α₁ · factor qy α₂ · factor qz α₃ · factor (2θ) β
                · factor qz α₃ · factor qy α₂ · factor qx α₁ .
```

Because each spatial axis appears **twice**, the complete-period symbol has
effective range two: along a single axis it is exactly `factor (2q) α₁`, whose
Laurent support is `{-2, +2}` — a genuine degree-two word `e^{±2iq}` that no
degree-one nearest-neighbor symbol `laurentStep A B C = e^{iq}A + B + e^{-iq}C`
can contain.  This is the exact escape from the range-one single-factor no-go
class proved in `StrictQCAMinimalArchitecture`.

## Ladder status (verdict recorded at end of file)

* **N0 (microcausality):** `period_mem_unitary` (exact all-momentum unitarity)
  and `period_x_slice` (depth-two causal cone: single-axis effective hop is
  exactly the range-two word `factor (2q) α₁`).
* **N1 (escape witness):** `laurentStep_degree_one_obstruction` +
  `period_x_slice_not_degree_one`: the complete-period symbol is provably **not**
  any degree-one nearest-neighbor Laurent symbol.  The degree-two coefficient is
  nonzero.
* **N2 (tangent gate):** open.  The candidate formula predicts the isotropic
  generator `-2i (kx α₁ + ky α₂ + kz α₃ + m β)`, but the derivative proof is
  intentionally not exported from this completed-rung module.
* **N3 (global census):** `census_origin_zero`, `census_origin_pi` inspect
  **both** `det(U−I)` and `det(U+I)` at the origin (a `+1` Dirac crossing, no
  `−1`/π crossing).  `period_x_edge` reduces the x zone edge to the pure mass
  coin, and `census_x_edge_massless_zero` exhibits a **massless** zone-edge
  crossing (a doubling signature that the range-doubling reintroduces at θ=0).
  The full torus classification of both determinants is left as the stated open
  target `N3_census_target` (see the closing comment).

Provenance: clean-room construction on the live project definitions
(`Compact3Plus1DiracRate.factor`, `StationaryAmplitudeNoGo.laurentStep`),
returned by Aristotle project `d2d33e0e-5e13-4079-855d-c3ee92441114`.
Lean 4.28.0.  No trust-expanding declarations.  Only the completed N0, N1,
and finite N3 controls are executable here; N2 remains a separate handoff.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.NullMicrostepHyperdiamond

open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo (laurentStep)

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- The complete symmetric depth-two hyperdiamond period.  Seven substeps: six
null conditional shifts (the three spatial axes, each applied twice) plus the
central onsite mass coin `factor (2θ) β`. -/
def period (qx qy qz theta : Real) : Mat4 :=
  factor qx alpha1 * factor qy alpha2 * factor qz alpha3 *
    factor (2 * theta) beta *
    factor qz alpha3 * factor qy alpha2 * factor qx alpha1

/-! ## Elementary factor identities -/

theorem factor_zero (g : Mat4) : factor 0 g = 1 := by
  simp [factor]

/-- Null-shift composition on a fixed Hermitian involution: two nearest-neighbor
lightlike shifts of the same chirality axis compose into a single shift of
double range. -/
theorem factor_add (a b : Real) (g : Mat4) (hg : g * g = 1) :
    factor a g * factor b g = factor (a + b) g := by
  simp only [factor, sub_mul, mul_sub, smul_mul_smul_comm, Matrix.one_mul,
    Matrix.mul_one, hg]
  rw [Real.cos_add, Real.sin_add]
  push_cast
  ring_nf
  rw [Complex.I_sq]
  ring_nf
  module

/-! ## N0 : exact all-momentum unitarity and the depth-two causal cone -/

/-- **N0 unitarity.**  The complete period is exactly unitary at every momentum
and mass angle, being an ordered product of unitary null shifts and an onsite
coin. -/
theorem period_mem_unitary (qx qy qz theta : Real) :
    period qx qy qz theta ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  obtain ⟨h1, h2, h3, hb, s1, s2, s3, sb⟩ := generators_hermitian_square_one
  have u1 := factor_mem_unitary qx alpha1 h1 s1
  have u2 := factor_mem_unitary qy alpha2 h2 s2
  have u3 := factor_mem_unitary qz alpha3 h3 s3
  have ub := factor_mem_unitary (2 * theta) beta hb sb
  unfold period
  exact Submonoid.mul_mem _ (Submonoid.mul_mem _ (Submonoid.mul_mem _
    (Submonoid.mul_mem _ (Submonoid.mul_mem _ (Submonoid.mul_mem _ u1 u2) u3) ub) u3) u2) u1

/-- **N0 causal cone.**  Along a single spatial axis the complete-period symbol
is exactly the range-two word `factor (2q) α₁ = e^{-2iq} P₊ + e^{+2iq} P₋`.  The
effective support is `{-2, +2}`: the depth-two circuit has an effective range of
exactly two lattice sites, and no more. -/
theorem period_x_slice (q : Real) : period q 0 0 0 = factor (2 * q) alpha1 := by
  obtain ⟨_, _, _, _, s1, _, _, _⟩ := generators_hermitian_square_one
  have h := factor_add q q alpha1 s1
  simp only [period, mul_zero, factor_zero, Matrix.mul_one]
  rw [h]; ring_nf

/-! ## N1 : escape from the degree-one nearest-neighbor class -/

/-- **Degree-one obstruction identity.**  Every nearest-neighbor Laurent symbol
`F(q) = e^{iq}A + B + e^{-iq}C` satisfies the linear four-point identity
`F(0) + F(π) = F(π/2) + F(-π/2)` (both sides equal `2B`).  This is the exact
signature that separates the degree-one class from any word with a degree-two
Fourier component. -/
theorem laurentStep_degree_one_obstruction (A B C : Mat4) :
    laurentStep A B C 0 + laurentStep A B C Real.pi
      = laurentStep A B C (Real.pi / 2) + laurentStep A B C (-(Real.pi / 2)) := by
  simp only [laurentStep]
  have e0 : Complex.exp (I * ((0 : Real) : ℂ)) = 1 := by norm_num
  have e0' : Complex.exp (-I * ((0 : Real) : ℂ)) = 1 := by norm_num
  have ep : Complex.exp (I * ((Real.pi : Real) : ℂ)) = -1 := by
    rw [mul_comm]; exact_mod_cast Complex.exp_pi_mul_I
  have ep' : Complex.exp (-I * ((Real.pi : Real) : ℂ)) = -1 := by
    rw [show -I * ((Real.pi : Real) : ℂ) = -((Real.pi : ℂ) * I) by ring,
      Complex.exp_neg, Complex.exp_pi_mul_I]; norm_num
  have eh : Complex.exp (I * ((Real.pi / 2 : Real) : ℂ)) = I := by
    rw [show I * ((Real.pi / 2 : Real) : ℂ) = ((Real.pi : ℂ) / 2) * I by push_cast; ring,
      Complex.exp_pi_div_two_mul_I]
  have eh' : Complex.exp (-I * ((Real.pi / 2 : Real) : ℂ)) = -I := by
    rw [show -I * ((Real.pi / 2 : Real) : ℂ) = -(((Real.pi : ℂ) / 2) * I) by push_cast; ring,
      Complex.exp_neg, Complex.exp_pi_div_two_mul_I]; simp
  have ehn : Complex.exp (I * ((-(Real.pi / 2) : Real) : ℂ)) = -I := by
    rw [show I * ((-(Real.pi / 2) : Real) : ℂ) = -(((Real.pi : ℂ) / 2) * I) by push_cast; ring,
      Complex.exp_neg, Complex.exp_pi_div_two_mul_I]; simp
  have ehn' : Complex.exp (-I * ((-(Real.pi / 2) : Real) : ℂ)) = I := by
    rw [show -I * ((-(Real.pi / 2) : Real) : ℂ) = ((Real.pi : ℂ) / 2) * I by push_cast; ring,
      Complex.exp_pi_div_two_mul_I]
  rw [e0, e0', ep, ep', eh, eh', ehn, ehn']
  module

theorem period_x0 : period 0 0 0 0 = 1 := by
  rw [period_x_slice]; norm_num [factor_zero]

theorem period_xpi : period Real.pi 0 0 0 = 1 := by
  rw [period_x_slice]
  simp [factor, Real.sin_two_pi, Real.cos_two_pi]

theorem period_xhalf : period (Real.pi / 2) 0 0 0 = -1 := by
  rw [period_x_slice]; norm_num [factor, mul_div_cancel₀]

theorem period_xneghalf : period (-(Real.pi / 2)) 0 0 0 = -1 := by
  rw [period_x_slice]
  have h : 2 * (-(Real.pi / 2)) = -Real.pi := by ring
  rw [h]; simp [factor]

/-- **N1 escape witness.**  The complete-period symbol restricted to the x axis
is *not* any degree-one nearest-neighbor Laurent symbol.  Hence the depth-two
null-microstep circuit genuinely leaves the range-one single-factor class of
`StrictQCAMinimalArchitecture`: its effective word carries a nonzero degree-two
Fourier component `e^{±2iq}`. -/
theorem period_x_slice_not_degree_one :
    ¬ ∃ A B C : Mat4, ∀ q : Real, period q 0 0 0 = laurentStep A B C q := by
  rintro ⟨A, B, C, h⟩
  have hob := laurentStep_degree_one_obstruction A B C
  rw [← h 0, ← h Real.pi, ← h (Real.pi / 2), ← h (-(Real.pi / 2))] at hob
  rw [period_x0, period_xpi, period_xhalf, period_xneghalf] at hob
  have hentry := congrFun (congrFun hob 0) 0
  simp [Matrix.add_apply, Matrix.neg_apply] at hentry
  norm_num at hentry

/-! ## N2 : the isotropic Dirac tangent (handoff)

The intended next theorem is

```text
HasDerivAt
  (fun t => period (kx*t) (ky*t) (kz*t) (m*t))
  ((-2*i) • H kx ky kz m) 0.
```

It should follow from the derivative of a scaled `factor` and the product rule
at seven identity-valued factors.  It is not used by the completed N0, N1, or
N3 controls below. -/

/-! ## N3 : both-determinant census controls -/

/-- **N3 origin, zero branch.**  `det(U(0)-I) = 0`: there is a `+1`-quasienergy
(zero-quasienergy) crossing at the origin — the intended Dirac point. -/
theorem census_origin_zero : (period 0 0 0 0 - 1).det = 0 := by
  rw [period_x0, sub_self]
  exact Matrix.det_zero inferInstance

/-- **N3 origin, π branch.**  `det(U(0)+I) = 16 ≠ 0`: there is **no**
`−1`-quasienergy (π) crossing at the origin.  Inspecting the π branch is
mandatory; the census is not zero-only. -/
theorem census_origin_pi : (period 0 0 0 0 + 1).det = 16 := by
  rw [period_x0]
  have h2 : (1 : Mat4) + 1 = (2 : ℂ) • (1 : Mat4) := by module
  rw [h2, Matrix.det_smul]
  norm_num

/-- x zone-edge reduction: at `qx = π`, `qy = qz = 0`, the two range-doubled
x-shifts collapse to `±1` and the period becomes the pure mass coin. -/
theorem period_x_edge (theta : Real) :
    period Real.pi 0 0 theta = factor (2 * theta) beta := by
  have hpi : factor Real.pi alpha1 = -1 := by
    simp [factor, Real.sin_pi, Real.cos_pi]
  simp only [period, factor_zero, Matrix.mul_one, hpi]
  rw [neg_one_mul, mul_neg_one, neg_neg]

/-- **N3 x zone edge, massless doubling signature.**  At zero mass the range
doubling reintroduces a zero-quasienergy crossing at the x zone edge
`(π, 0, 0)`: `det(U(π,0,0,0) − I) = 0`.  This records that the naive symmetric
depth-two candidate is *not* alias-free at θ = 0. -/
theorem census_x_edge_massless_zero : (period Real.pi 0 0 0 - 1).det = 0 := by
  rw [period_xpi, sub_self]
  exact Matrix.det_zero inferInstance

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullMicrostepHyperdiamond.period_mem_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms period_mem_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.NullMicrostepHyperdiamond.period_x_slice_not_degree_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms period_x_slice_not_degree_one

/-- info: 'PhysicsSM.Draft.NullEdge.NullMicrostepHyperdiamond.census_x_edge_massless_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms census_x_edge_massless_zero

end PhysicsSM.Draft.NullEdge.NullMicrostepHyperdiamond
