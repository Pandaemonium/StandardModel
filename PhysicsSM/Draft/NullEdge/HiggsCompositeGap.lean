import Mathlib

/-!
# A finite composite-Higgs seed: gap equation, criticality, and derived
# scalar stiffness

The null-information program's standing exception is the Higgs self-mass: the
turn field is the agent of fermion mass, not a beneficiary, and its own mass
parameter is an input.  The composite route removes the exception by making
the scalar a CONDENSED fermion pair: the order parameter `sigma` is the
left-right pair coherence, and the scalar stiffness (the Higgs mass
parameter) is an OUTPUT of the fermion sector's condensation dynamics.

This package proves the exact one-mode mean-field core.  For a single fermion
mode of momentum `k > 0` with quasiparticle energy `E(k,sigma) =
sqrt(k^2 + sigma^2)` and quartic coupling `G > 0`, the mean-field free energy
is

  `F(G,k,sigma) = sigma^2/(4G) - E(k,sigma)`.

## Targets

1. `hasDerivAt_F` — the exact first derivative:
   `F' = sigma/(2G) - sigma/E(k,sigma)` (well-defined since `k > 0` keeps the
   square-root argument positive).
2. `gap_equation` — a nonzero stationary point exists iff the quasiparticle
   energy locks to the coupling: for `sigma /= 0`, `F' = 0 <-> E = 2G`.
3. `condensation_iff_supercritical` — a nonzero condensate
   `sigma* = sqrt(4G^2 - k^2)` exists iff `2G > k`; and in the subcritical
   regime `2G < k` the derivative is strictly positive for every
   `sigma > 0` (the symmetric vacuum is the only stationary point — the
   negative control).
4. `radial_curvature` — at the condensed stationary point the second
   derivative is exactly
   `F'' = sigma*^2 / E^3 = (4G^2 - k^2)/(8G^3) > 0`:
   the scalar (radial/Higgs) stiffness is DERIVED from the fermion
   condensation, vanishing exactly at criticality `2G = k`.
5. `witness_345` — the exact witness at `k = 3`, `G = 5/2`: condensate
   `sigma* = 4`, quasiparticle energy `E = 5` (the 3-4-5 shell yet again),
   and radial stiffness exactly `16/125`.

## Honest scope and provenance

This is the finite mean-field seed, exact and free of regularization
ambiguity.  The continuum NJL ratio `m_sigma^2/m_f^2` is known to be
regularization-scheme dependent (Willey, PRD 48 (1993) 2877), so no
`m_sigma = 2 m_dyn` claim is made here: the fluctuation (RPA) pole is a
separate, future target.  Clean-room formalization; NJL mean-field shape
consulted conceptually from the standard literature (Nambu-Jona-Lasinio;
composite-Higgs precedent: Bardeen-Hill-Lindner-type RG treatments), no code
or text imported.  Do not weaken the statements.  Helper lemmas welcome.
Run `lake env lean HiggsCompositeGap/FiniteGapEquation.lean` first; avoid a
full lake build until the holes are closed.
Recovered from Aristotle project `658c188e-8e14-49cd-9c90-f6996a60374f`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.HiggsCompositeGap

/-- Quasiparticle energy of the single fermion mode. -/
noncomputable def E (k σ : ℝ) : ℝ := Real.sqrt (k ^ 2 + σ ^ 2)

/-- Mean-field free energy: condensate cost minus fermion energy. -/
noncomputable def F (G k σ : ℝ) : ℝ := σ ^ 2 / (4 * G) - E k σ

/-- The exact first derivative of the free energy in the order parameter. -/
noncomputable def Fp (G k σ : ℝ) : ℝ := σ / (2 * G) - σ / E k σ

/-- Target 1: the free energy has the displayed exact derivative. -/
theorem hasDerivAt_F (G k σ : ℝ) (hk : 0 < k) :
    HasDerivAt (F G k) (Fp G k σ) σ := by
  have harg_ne : k ^ 2 + σ ^ 2 ≠ 0 := by positivity
  have hpow : HasDerivAt (fun x : ℝ => x ^ 2) (2 * σ) σ := by
    simpa using hasDerivAt_pow 2 σ
  have hsq : HasDerivAt (fun x : ℝ => k ^ 2 + x ^ 2) (2 * σ) σ := hpow.const_add (k ^ 2)
  have hsqrt : HasDerivAt (fun x : ℝ => Real.sqrt (k ^ 2 + x ^ 2))
      ((2 * σ) / (2 * Real.sqrt (k ^ 2 + σ ^ 2))) σ := hsq.sqrt harg_ne
  have h1 : HasDerivAt (fun x : ℝ => x ^ 2 / (4 * G)) (2 * σ / (4 * G)) σ :=
    hpow.div_const (4 * G)
  convert h1.sub hsqrt using 1
  unfold Fp E
  rw [show (4:ℝ) * G = 2 * (2 * G) by ring, mul_div_mul_left _ _ (two_ne_zero),
    mul_div_mul_left _ _ (two_ne_zero)]

/-- Target 2: the gap equation.  A nonzero order parameter is stationary iff
the quasiparticle energy locks to twice the coupling. -/
theorem gap_equation (G k σ : ℝ) (hG : 0 < G) (hk : 0 < k) (hσ : σ ≠ 0) :
    Fp G k σ = 0 ↔ E k σ = 2 * G := by
  have hE : 0 < E k σ := Real.sqrt_pos.mpr (by positivity)
  unfold Fp
  rw [sub_eq_zero, div_eq_div_iff (by positivity) hE.ne']
  constructor
  · intro h
    have := mul_left_cancel₀ hσ (by linarith [h] : σ * E k σ = σ * (2 * G))
    linarith
  · intro h; rw [h]

/-- Target 3a: supercriticality produces the condensate.  For `2G > k` the
explicit nonzero order parameter `sqrt(4G^2 - k^2)` satisfies the gap
equation. -/
theorem condensation_of_supercritical (G k : ℝ) (hG : 0 < G) (hk : 0 < k)
    (hsc : k < 2 * G) :
    0 < Real.sqrt (4 * G ^ 2 - k ^ 2) ∧
      Fp G k (Real.sqrt (4 * G ^ 2 - k ^ 2)) = 0 := by
  have hpos : 0 < Real.sqrt (4 * G ^ 2 - k ^ 2) := Real.sqrt_pos.mpr (by nlinarith)
  refine ⟨hpos, ?_⟩
  rw [gap_equation G k _ hG hk hpos.ne', E,
    Real.sq_sqrt (by nlinarith : (0:ℝ) ≤ 4 * G ^ 2 - k ^ 2),
    show k ^ 2 + (4 * G ^ 2 - k ^ 2) = (2 * G) ^ 2 by ring]
  exact Real.sqrt_sq (by positivity)

/-- Target 3b (negative control): subcriticality forbids condensation.  For
`2G < k` the derivative is strictly positive at every positive order
parameter, so the symmetric vacuum is the only stationary point. -/
theorem no_condensation_of_subcritical (G k σ : ℝ) (hG : 0 < G)
    (hsc : 2 * G < k) (hσ : 0 < σ) :
    0 < Fp G k σ := by
  -- We need to show that $σ / (2G) - σ / E k σ > 0$.
  suffices h_pos : σ / (2 * G) > σ / E k σ by
    exact sub_pos_of_lt h_pos;
  gcongr;
  exact hsc.trans_le ( Real.le_sqrt_of_sq_le ( by nlinarith ) )

/-- Target 4: the derived scalar stiffness.  At the condensed stationary
point the second derivative of the free energy is exactly
`(4G^2 - k^2)/(8G^3)`, strictly positive above criticality and vanishing
exactly at `2G = k`. -/
theorem radial_curvature (G k : ℝ) (hG : 0 < G) (hk : 0 < k)
    (hsc : k < 2 * G) :
    HasDerivAt (Fp G k) ((4 * G ^ 2 - k ^ 2) / (8 * G ^ 3))
      (Real.sqrt (4 * G ^ 2 - k ^ 2)) ∧
      0 < (4 * G ^ 2 - k ^ 2) / (8 * G ^ 3) := by
  set s := Real.sqrt (4 * G ^ 2 - k ^ 2) with hsdef
  have harg : (0:ℝ) ≤ 4 * G ^ 2 - k ^ 2 := by nlinarith
  have hs2 : s ^ 2 = 4 * G ^ 2 - k ^ 2 := Real.sq_sqrt harg
  have hEs : E k s = 2 * G := by
    unfold E
    rw [hs2, show k ^ 2 + (4 * G ^ 2 - k ^ 2) = (2 * G) ^ 2 by ring]
    exact Real.sqrt_sq (by positivity)
  have hEpos : 0 < E k s := by rw [hEs]; linarith
  refine ⟨?_, div_pos (by nlinarith) (by positivity)⟩
  have hpow : HasDerivAt (fun σ : ℝ => σ ^ 2) (2 * s) s := by
    simpa using hasDerivAt_pow 2 s
  have hsq : HasDerivAt (fun σ : ℝ => k ^ 2 + σ ^ 2) (2 * s) s := hpow.const_add (k ^ 2)
  have harg_ne : k ^ 2 + s ^ 2 ≠ 0 := by rw [hs2]; nlinarith
  have hsqrt : HasDerivAt (fun σ : ℝ => Real.sqrt (k ^ 2 + σ ^ 2))
      ((2 * s) / (2 * Real.sqrt (k ^ 2 + s ^ 2))) s := hsq.sqrt harg_ne
  have h1 : HasDerivAt (fun σ : ℝ => σ / (2 * G)) (1 / (2 * G)) s :=
    (hasDerivAt_id s).div_const (2 * G)
  have h2 : HasDerivAt (fun σ : ℝ => σ / E k σ)
      ((1 * E k s - s * ((2 * s) / (2 * Real.sqrt (k ^ 2 + s ^ 2)))) / (E k s) ^ 2) s :=
    (hasDerivAt_id s).div hsqrt hEpos.ne'
  convert h1.sub h2 using 1
  rw [hEs, show Real.sqrt (k ^ 2 + s ^ 2) = 2 * G from hEs]
  field_simp
  nlinarith [hs2, hG.ne']

/-- Target 5: the exact 3-4-5 witness.  At `k = 3`, `G = 5/2`: the condensate
is `4`, the quasiparticle energy is `5`, and the derived scalar stiffness is
exactly `16/125`. -/
theorem witness_345 :
    Real.sqrt (4 * (5 / 2 : ℝ) ^ 2 - 3 ^ 2) = 4 ∧
    E 3 4 = 5 ∧
    Fp (5 / 2) 3 4 = 0 ∧
    (4 * (5 / 2 : ℝ) ^ 2 - 3 ^ 2) / (8 * (5 / 2) ^ 3) = 16 / 125 := by
  refine ⟨?_, ?_, ?_, by norm_num⟩
  · rw [show (4 * (5 / 2 : ℝ) ^ 2 - 3 ^ 2) = 4 ^ 2 by norm_num]
    exact Real.sqrt_sq (by norm_num)
  · rw [E, show ((3 : ℝ) ^ 2 + 4 ^ 2) = 5 ^ 2 by norm_num]
    exact Real.sqrt_sq (by norm_num)
  · have hE : E 3 4 = 5 := by
      rw [E, show ((3 : ℝ) ^ 2 + 4 ^ 2) = 5 ^ 2 by norm_num]
      exact Real.sqrt_sq (by norm_num)
    rw [Fp, hE]; norm_num

end PhysicsSM.Draft.NullEdge.HiggsCompositeGap

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCompositeGap.gap_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HiggsCompositeGap.gap_equation

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCompositeGap.radial_curvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HiggsCompositeGap.radial_curvature

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCompositeGap.no_condensation_of_subcritical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HiggsCompositeGap.no_condensation_of_subcritical

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCompositeGap.witness_345' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HiggsCompositeGap.witness_345
