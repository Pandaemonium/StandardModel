import context.PairSpectrumFixture

/-!
# T3 (ℂ form): the T1 polynomial annihilates the physical matrix `V`

This module transports the integer Cayley–Hamilton annihilation `Vz_annihilated`
(checked by `native_decide` in `PairSpectrumFixture`) across the ring embedding
`GaussianInt.toComplex` to the physical rational-complex matrix `V`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairSpectrumFixture

/-- Bridge: the integer matrix `Vz` cast into `ℂ` is exactly `25 • V`. -/
private lemma toC_bridge :
    Vz.map GaussianInt.toComplex = (25 : ℂ) • V := by
  show Vz.map GaussianInt.toComplex
      = (25 : ℂ) • ((25⁻¹ : ℂ) • Vz.map GaussianInt.toComplex)
  rw [smul_smul]; norm_num

/-- Powers transport: `(Vzᵉ) ↦ 25ᵉ • Vᵉ` under the embedding. -/
private lemma map_pow_bridge (e : ℕ) :
    (Vz ^ e).map GaussianInt.toComplex = (25 : ℂ) ^ e • V ^ e := by
  have hmp : (Vz.map GaussianInt.toComplex) ^ e
      = (Vz ^ e).map GaussianInt.toComplex := by
    induction e with
    | zero => simp
    | succ k ih => rw [pow_succ, pow_succ, ih, ← Matrix.map_mul]
  rw [← hmp, toC_bridge, smul_pow]

/-- Coefficient transport: `((g c 0) • Vzᵉ) ↦ (c : ℂ) • (Vzᵉ).map`. -/
private lemma coef_map (c : ℤ) (e : ℕ) :
    ((g c 0) • Vz ^ e).map GaussianInt.toComplex
      = (c : ℂ) • (Vz ^ e).map GaussianInt.toComplex := by
  ext i j
  simp only [Matrix.map_apply, Matrix.smul_apply, smul_eq_mul, map_mul]
  congr 1
  simp [g, GaussianInt.toComplex_def']

/-- **T3 (`ℂ` form).** The explicit degree-`28` polynomial of T1 (integer
coefficients, leading coefficient `5^11`) annihilates the physical
rational-complex matrix `V`:  `P(V) = 0`. -/
theorem V_annihilated :
    (48828125:ℂ) • (V ^ 0) +
    (-70312500:ℂ) • (V ^ 1) +
    (-35937500:ℂ) • (V ^ 2) +
    (43312500:ℂ) • (V ^ 3) +
    (113734375:ℂ) • (V ^ 4) +
    (-79830000:ℂ) • (V ^ 5) +
    (-254465000:ℂ) • (V ^ 6) +
    (229590000:ℂ) • (V ^ 7) +
    (201373725:ℂ) • (V ^ 8) +
    (-45757764:ℂ) • (V ^ 9) +
    (-390430372:ℂ) • (V ^ 10) +
    (82918404:ℂ) • (V ^ 11) +
    (482590239:ℂ) • (V ^ 12) +
    (-159920640:ℂ) • (V ^ 13) +
    (-331387184:ℂ) • (V ^ 14) +
    (-159920640:ℂ) • (V ^ 15) +
    (482590239:ℂ) • (V ^ 16) +
    (82918404:ℂ) • (V ^ 17) +
    (-390430372:ℂ) • (V ^ 18) +
    (-45757764:ℂ) • (V ^ 19) +
    (201373725:ℂ) • (V ^ 20) +
    (229590000:ℂ) • (V ^ 21) +
    (-254465000:ℂ) • (V ^ 22) +
    (-79830000:ℂ) • (V ^ 23) +
    (113734375:ℂ) • (V ^ 24) +
    (43312500:ℂ) • (V ^ 25) +
    (-35937500:ℂ) • (V ^ 26) +
    (-70312500:ℂ) • (V ^ 27) +
    (48828125:ℂ) • (V ^ 28) = 0 := by
  have h25 : (25 : ℂ) ^ 28 ≠ 0 := pow_ne_zero _ (by norm_num)
  have hG : (25 : ℂ) ^ 28 •
      ((48828125:ℂ) • (V ^ 0) +
      (-70312500:ℂ) • (V ^ 1) +
      (-35937500:ℂ) • (V ^ 2) +
      (43312500:ℂ) • (V ^ 3) +
      (113734375:ℂ) • (V ^ 4) +
      (-79830000:ℂ) • (V ^ 5) +
      (-254465000:ℂ) • (V ^ 6) +
      (229590000:ℂ) • (V ^ 7) +
      (201373725:ℂ) • (V ^ 8) +
      (-45757764:ℂ) • (V ^ 9) +
      (-390430372:ℂ) • (V ^ 10) +
      (82918404:ℂ) • (V ^ 11) +
      (482590239:ℂ) • (V ^ 12) +
      (-159920640:ℂ) • (V ^ 13) +
      (-331387184:ℂ) • (V ^ 14) +
      (-159920640:ℂ) • (V ^ 15) +
      (482590239:ℂ) • (V ^ 16) +
      (82918404:ℂ) • (V ^ 17) +
      (-390430372:ℂ) • (V ^ 18) +
      (-45757764:ℂ) • (V ^ 19) +
      (201373725:ℂ) • (V ^ 20) +
      (229590000:ℂ) • (V ^ 21) +
      (-254465000:ℂ) • (V ^ 22) +
      (-79830000:ℂ) • (V ^ 23) +
      (113734375:ℂ) • (V ^ 24) +
      (43312500:ℂ) • (V ^ 25) +
      (-35937500:ℂ) • (V ^ 26) +
      (-70312500:ℂ) • (V ^ 27) +
      (48828125:ℂ) • (V ^ 28)) = 0 := by
    have h := congrArg (RingHom.mapMatrix GaussianInt.toComplex) Vz_annihilated
    rw [map_zero] at h
    rw [← h]
    simp only [map_add, RingHom.mapMatrix_apply, coef_map, map_pow_bridge,
      smul_add, smul_smul]
    push_cast
    ring_nf
  exact (smul_eq_zero.mp hG).resolve_left h25

end PhysicsSM.Draft.NullEdge.PairSpectrumFixture
