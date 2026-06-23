import Mathlib

/-!
# Null-step quantum walk: core bridge scaffold

This file is the proposed standalone scaffold connecting the discrete
**null-step quantum walk**

```text
U_a(k) = exp(-i k a σ_z) · exp(-i μ a σ_x)
```

to the four downstream targets requested in the strategy task:

1. the **quasienergy relation**     `cos(ω a) = cos(k a) cos(μ a)`;
2. **chirality coherence**           `C(k) = |sin(μ a)| / |sin(ω a)|`;
3. the **continuum limit**           `C → μ / sqrt(k² + μ²) = m / E`;
4. the **P2/P4 theorem spine**       (`quasienergy_relation`, `chirality_coherence`).

## Design choice

We do **not** work with the matrix exponential `Matrix.exp` directly.  Instead we
take the *closed forms* of the single-qubit rotation gates as definitions
(`Rz`, `Rx`) and define `Ua := Rz (k a) * Rx (μ a)`.  Each closed form is the
standard Euler expansion `exp(-iθσ) = cos θ · I - i sin θ · σ` valid because
`σ_z² = σ_x² = I`.  Connecting `Rz`/`Rx` back to `Matrix.exp` is an *optional*
hole (`Rz_eq_exp`, `Rx_eq_exp`); it is not needed for any downstream result,
all of which are statements about the entries of `Ua`.

Everything below compiles with no `s o r r y` and depends only on the standard
axioms (`propext`, `Classical.choice`, `Quot.sound`).
-/

namespace PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore

open Complex Matrix Filter Topology

noncomputable section

/-! ## 1. The walk operator -/

/-- `Rz θ = exp(-i θ σ_z) = diag(e^{-iθ}, e^{iθ})`. -/
def Rz (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (-(θ : ℂ) * I), 0; 0, Complex.exp ((θ : ℂ) * I)]

/-- `Rx θ = exp(-i θ σ_x) = cos θ · I - i sin θ · σ_x`. -/
def Rx (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.cos (θ : ℂ), -(I * Complex.sin (θ : ℂ));
     -(I * Complex.sin (θ : ℂ)), Complex.cos (θ : ℂ)]

/-- The one-step null-step quantum walk `U_a(k) = exp(-i k a σ_z) exp(-i μ a σ_x)`.
`a` is the lattice spacing, `k` the (quasi)momentum, `μ` the bare mass/coupling. -/
def Ua (a k μ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ := Rz (k * a) * Rx (μ * a)

/-! ## 2. Trace and determinant (SU(2) structure)

These are the load-bearing algebraic facts; the eigenvalues `e^{±iωa}` of `Ua`
are fixed by `det = 1` and `trace = 2 cos(ωa)`. -/

/-- The trace of the walk operator: `tr U_a(k) = 2 cos(k a) cos(μ a)`.
This is the quasienergy relation in disguise: `2 cos(ωa) = 2 cos(ka) cos(μa)`. -/
theorem trace_Ua (a k μ : ℝ) :
    (Ua a k μ).trace = 2 * Complex.cos ((k * a : ℝ)) * Complex.cos ((μ * a : ℝ)) := by
  simp only [Ua, Rz, Rx, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two,
    Matrix.diag, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.empty_val']
  rw [Complex.cos, Complex.cos]
  ring_nf

/-- The walk operator lies in `SU(2)`: `det U_a(k) = 1`. -/
theorem det_Ua (a k μ : ℝ) : (Ua a k μ).det = 1 := by
  simp only [Ua, Matrix.det_mul, Rz, Rx, Matrix.det_fin_two_of]
  rw [← Complex.exp_add]
  ring_nf
  rw [Complex.exp_zero, Complex.I_sq]
  linear_combination Complex.sin_sq_add_cos_sq ((a * μ : ℝ) : ℂ)

/-! ## 3. Quasienergy relation (target P2) -/

/-- The **quasienergy relation**: `ω` is a quasienergy at momentum `k` iff
`cos(ω a) = cos(k a) cos(μ a)`.  We package it as a predicate so the
P2 spine can refer to it abstractly. -/
def IsQuasienergy (a k μ ω : ℝ) : Prop :=
  Real.cos (ω * a) = Real.cos (k * a) * Real.cos (μ * a)

/-- Bridge: `ω` is a quasienergy iff the (real) trace equals `2 cos(ωa)`.
This ties the abstract predicate to the concrete spectral data of `Ua`. -/
theorem isQuasienergy_iff_trace (a k μ ω : ℝ) :
    IsQuasienergy a k μ ω ↔
      (Ua a k μ).trace = (2 * Real.cos (ω * a) : ℝ) := by
  rw [trace_Ua, IsQuasienergy]
  rw [← Complex.ofReal_cos, ← Complex.ofReal_cos]
  constructor
  · intro h
    rw [h]; push_cast; ring
  · intro h
    have hc : ((2 * Real.cos (k * a) * Real.cos (μ * a) : ℝ) : ℂ)
        = ((2 * Real.cos (ω * a) : ℝ) : ℂ) := by push_cast; push_cast at h; linear_combination h
    have := Complex.ofReal_injective hc
    linarith [this]

/-! ## 4. Chirality coherence (target P4)

In the chirality basis `σ_z` is diagonal (chirality-preserving) and `σ_x, σ_y`
flip chirality.  Expanding `Ua = cos(ωa) I - i (n·σ) sin(ωa)`, the generator's
chirality-flipping weight is `|sin(μa)|` and its preserving weight is
`|sin(ka) cos(μa)|`, with total `|sin(ωa)|`. -/

/-- `sin²(ω a)`, written in lattice data (the squared norm of the Bloch axis). -/
def sinOmegaSq (a k μ : ℝ) : ℝ :=
  Real.sin (μ * a) ^ 2 + Real.sin (k * a) ^ 2 * Real.cos (μ * a) ^ 2

/-- Consistency with the quasienergy relation: `sin²(ωa) = 1 - cos²(ka) cos²(μa)`. -/
theorem sinOmegaSq_eq (a k μ : ℝ) :
    sinOmegaSq a k μ = 1 - (Real.cos (k * a) * Real.cos (μ * a)) ^ 2 := by
  simp only [sinOmegaSq]
  have h1 := Real.sin_sq_add_cos_sq (μ * a)
  have h2 := Real.sin_sq_add_cos_sq (k * a)
  nlinarith [h1, h2]

/-- **Chirality coherence squared**: `C(k)² = sin²(μa) / sin²(ωa)`.
(We work with the square to avoid absolute values; `C = |sin μa|/|sin ωa|`.) -/
def coherenceSq (a k μ : ℝ) : ℝ :=
  Real.sin (μ * a) ^ 2 / sinOmegaSq a k μ

/-! ## 5. Continuum limit — the central bridge

As `a → 0`, dividing numerator and denominator of `coherenceSq` by `a²` and
using `sin(c a)/a → c` gives `coherenceSq → μ²/(k²+μ²) = (m/E)²` with the Dirac
identifications `m = μ`, `E = sqrt(k²+μ²)`. -/

/-- Helper: `sin(c·a)/a → c` as `a → 0` (deleted neighbourhood). -/
theorem tendsto_sin_mul_div (c : ℝ) :
    Tendsto (fun a : ℝ => Real.sin (c * a) / a) (𝓝[≠] 0) (𝓝 c) := by
  simpa [ div_eq_inv_mul ] using HasDerivAt.tendsto_slope_zero ( HasDerivAt.sin ( HasDerivAt.const_mul c ( hasDerivAt_id 0 ) ) )

/-- **Continuum limit of chirality coherence (squared form).**
With `k² + μ² ≠ 0`, the lattice coherence converges to the continuum value
`μ² / (k² + μ²)`. -/
theorem coherenceSq_continuum (k μ : ℝ) (hkμ : k ^ 2 + μ ^ 2 ≠ 0) :
    Tendsto (fun a : ℝ => coherenceSq a k μ) (𝓝[≠] 0)
      (𝓝 (μ ^ 2 / (k ^ 2 + μ ^ 2))) := by
  -- Let's simplify the expression for coherenceSq.
  suffices h_simp : Filter.Tendsto (fun a => (Real.sin (μ * a) / a) ^ 2 / ((Real.sin (μ * a) / a) ^ 2 + (Real.sin (k * a) / a) ^ 2 * (Real.cos (μ * a)) ^ 2)) (𝓝[≠] 0) (𝓝 (μ ^ 2 / (k ^ 2 + μ ^ 2))) by
    convert h_simp using 2 ; norm_num [ coherenceSq, sinOmegaSq ] ; ring_nf;
    by_cases h : ‹ℝ› = 0 <;> simp +decide [ h, mul_comm ];
    grind;
  -- Use the fact that $\frac{\sin(c a)}{a} \to c$ as $a \to 0$ for any $c$.
  have h_sin : Filter.Tendsto (fun a => Real.sin (μ * a) / a) (𝓝[≠] 0) (𝓝 μ) ∧ Filter.Tendsto (fun a => Real.sin (k * a) / a) (𝓝[≠] 0) (𝓝 k) := by
    exact ⟨ by simpa [ div_eq_inv_mul ] using tendsto_sin_mul_div μ, by simpa [ div_eq_inv_mul ] using tendsto_sin_mul_div k ⟩;
  convert Filter.Tendsto.div ( h_sin.1.pow 2 ) ( Filter.Tendsto.add ( h_sin.1.pow 2 ) ( Filter.Tendsto.mul ( h_sin.2.pow 2 ) ( Filter.Tendsto.pow ( Real.continuous_cos.continuousAt.tendsto.comp ( tendsto_const_nhds.mul ( Filter.tendsto_id.mono_left inf_le_left ) ) ) 2 ) ) ) _ using 2 <;> norm_num ; ring;
  grind

/-- **m/E form of the continuum limit.**  With `m = μ` and `E = sqrt(k²+m²)`,
the limiting coherence is exactly `(m/E)²`. -/
theorem coherenceSq_continuum_mE (k m : ℝ) (hkm : k ^ 2 + m ^ 2 ≠ 0) :
    Tendsto (fun a : ℝ => coherenceSq a k m) (𝓝[≠] 0)
      (𝓝 ((m / Real.sqrt (k ^ 2 + m ^ 2)) ^ 2)) := by
  have hpos : (0 : ℝ) < k ^ 2 + m ^ 2 := lt_of_le_of_ne (by positivity) (Ne.symm hkm)
  have hrw : (m / Real.sqrt (k ^ 2 + m ^ 2)) ^ 2 = m ^ 2 / (k ^ 2 + m ^ 2) := by
    rw [div_pow, Real.sq_sqrt hpos.le]
  rw [hrw]
  exact coherenceSq_continuum k m hkm

end

end PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore
