import Mathlib

/-!
# Q06 R1: the determinant-level Wilson-term symbol identity

This module records the compiler-trust-free Lean part of the Q06 rung **R1**:
the momentum-space checkerboard transfer *symbol* and the exact identity that its
Hermitian part is the hidden Wilson term.  It sits next to
`GWConjecture.lean` (carrier-level conjugation, palindrome/nonabelian boundary)
and `GWRetardedTransfer.lean` (abstract GW-1 lemma and the explicit `8×8`
checkerboard GW-2 witness).

## Setup (Q06 answer, Section 1 R1)

Work on `ℓ²(ℤ, ℂ²)` with chirality components `ψ = (ψ₊, ψ₋)`, retarded (one-sided
per chirality) null shifts `S`, corner rotation `C = exp(i θ σ_x)`, midpoint
(palindromic) convention `T = S^{1/2} C S^{1/2}`.  Its Fourier symbol is

    T̂(k) = [[ c·e^{-ik},  i·s ],
            [ i·s,        c·e^{+ik} ]],   c = cos θ,  s = sin θ.

## Contents

* `transferSymbol_det` — **the determinant-level fact**: `det T̂(k) = 1`
  (this is exactly `c² + s² = 1`, i.e. the palindromic transfer is `SU(2)`-valued
  fiberwise).
* `transferSymbol_unitary` — `T̂(k) · T̂(k)ᴴ = 1`: the conjugate transpose is the
  fiberwise inverse.
* `transferSymbol_trace` — `tr T̂(k) = 2 c cos k`.
* `transferSymbol_hermitianPart` — **the Wilson-term core**:
  `T̂(k) + T̂(k)ᴴ = (2 c cos k)·1`, i.e. `Herm(T̂) = c cos k · 1`.  Combined with
  `det = 1` this is the Cayley–Hamilton statement `T̂ + T̂⁻¹ = (tr T̂)·1`.
* `wilson_term` — **R1, the exact identity**: for `D̂ := ε⁻¹·(1 - T̂)`,
  `D̂ + D̂ᴴ = (2 (1 - c cos k)/ε)·1`, i.e. `Herm(D̂) = (1 - cos θ cos k)/ε · 1`.
  This is the hidden Wilson scalar for the displayed retarded/palindromic
  symbol; no general carrier-dynamics derivation is claimed here.
* `wilson_scalar_nonneg` — the Wilson scalar `1 - c cos k ≥ 0` (positivity),
  and `wilson_scalar_zoneEdge` — it equals `1 + c` at the zone edge `k = π`
  (≈ `2` for small `θ`).
* `gw_symbol` — the **symbol-level Ginsparg–Wilson conjugation** respecting the
  palindromic/nonabelian boundary of `GWConjecture.lean`:
  `σ_z · T̂(-k) · σ_z = T̂(k)ᴴ = T̂(k)⁻¹`, where `k ↦ -k` is the momentum-space
  edge-orientation reversal `Γ_r`.

All identities are exact finite `2×2` algebra over `ℂ`.  The determinant/unitary
facts use `c² + s² = 1`; the trace/Hermitian-part identities do not.

Provenance: Q06 Wilson-symbol Aristotle project `ed700b2a`; ladder rung R1 of
`Q06_answer.md`, integrated in the two-day carrier run.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol

open Matrix Complex

/-- The momentum-space checkerboard transfer symbol
`T̂(k) = [[c e^{-ik}, i s],[i s, c e^{+ik}]]` with `c = cos θ`, `s = sin θ`. -/
noncomputable def transferSymbol (c s k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![ (c : ℂ) * Complex.exp (-(Complex.I * k)), Complex.I * s;
      Complex.I * s,                             (c : ℂ) * Complex.exp (Complex.I * k) ]

/-- `σ_z = diag(1, -1)`, the chirality grading used by `Γ_r`. -/
def sigZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-
**Determinant-level fact.** `det T̂(k) = 1` when `c² + s² = 1`: the
palindromic transfer symbol is fiberwise `SU(2)`.
-/
theorem transferSymbol_det (c s k : ℝ) (hpyth : c ^ 2 + s ^ 2 = 1) :
    (transferSymbol c s k).det = 1 := by
  unfold transferSymbol; norm_num [ Complex.ext_iff, pow_two ] ; ring_nf;
  norm_num [ Complex.exp_re, Complex.exp_im ] ; ring_nf;
  rw [ ← mul_add, Real.cos_sq_add_sin_sq ] ; linarith

/-
The conjugate transpose is the fiberwise inverse: `T̂(k) · T̂(k)ᴴ = 1`.
-/
theorem transferSymbol_unitary (c s k : ℝ) (hpyth : c ^ 2 + s ^ 2 = 1) :
    transferSymbol c s k * (transferSymbol c s k)ᴴ = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ transferSymbol, Complex.ext_iff ] <;> ring_nf;
  · norm_num [ Matrix.vecMul, Complex.exp_re, Complex.exp_im ];
    norm_num [ vecHead, vecTail, Complex.exp_re, Complex.exp_im ] ; ring_nf;
    exact ⟨ by rw [ Real.cos_sq' ] ; linarith, trivial ⟩;
  · norm_num [ Matrix.vecMul, Complex.exp_re, Complex.exp_im ] ; ring_nf;
    norm_num [ vecHead, vecTail, Complex.exp_re, Complex.exp_im ] ; ring_nf ; norm_num [ hpyth ] ;
  · norm_num [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] ; ring_nf ; norm_num [ Complex.exp_re, Complex.exp_im, hpyth ];
  · simp +decide [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] ; ring_nf ; norm_num [ Complex.exp_re, Complex.exp_im ] ;
    rw [ Real.sin_sq, Real.cos_sq ] ; ring_nf ; nlinarith

/-
The trace of the transfer symbol: `tr T̂(k) = 2 c cos k`.
-/
theorem transferSymbol_trace (c s k : ℝ) :
    (transferSymbol c s k).trace = (2 * c * Real.cos k : ℝ) := by
  simp [ transferSymbol, Matrix.trace_fin_two, Complex.cos ];
  ring_nf

/-
**Wilson-term core (Hermitian part of the transfer).**
`T̂(k) + T̂(k)ᴴ = (2 c cos k)·1`, hence `Herm(T̂) = c cos k · 1`.  Together with
`det T̂ = 1` this is the Cayley–Hamilton identity `T̂ + T̂⁻¹ = (tr T̂)·1`.
-/
theorem transferSymbol_hermitianPart (c s k : ℝ) :
    transferSymbol c s k + (transferSymbol c s k)ᴴ
      = ((2 * c * Real.cos k : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im, Complex.exp_re, Complex.exp_im ] <;> ring_nf;
  · unfold transferSymbol; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos ] ; ring_nf;
  · unfold transferSymbol; norm_num [ Complex.ext_iff ] ;
  · unfold transferSymbol; norm_num [ Complex.ext_iff ] ;
  · unfold transferSymbol; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring_nf;

/-
**R1 — the exact Wilson-term identity for this symbol.**  For the unscaled Dirac
operator symbol `D̂ := ε⁻¹·(1 - T̂)`, the Hermitian part is the exact Wilson term:
`D̂ + D̂ᴴ = (2 (1 - c cos k)/ε)·1`, i.e. `Herm(D̂) = (1 - cos θ cos k)/ε · 1`.
-/
theorem wilson_term (c s k ε : ℝ) :
    (fun D : Matrix (Fin 2) (Fin 2) ℂ => D + Dᴴ)
        ((ε⁻¹ : ℝ) • (1 - transferSymbol c s k))
      = ((2 * (1 - c * Real.cos k) / ε : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Complex.ext_iff, div_eq_mul_inv ] <;> ring_nf!;
  · unfold transferSymbol; norm_num [ Complex.exp_re, Complex.exp_im ] ;
    norm_cast ; ring_nf;
  · unfold transferSymbol; norm_num;
  · unfold transferSymbol; norm_num;
  · unfold transferSymbol; norm_num [ Complex.exp_re, Complex.exp_im ] ; ring_nf;
    norm_cast

/-
**Positivity of the Wilson scalar.** `1 - c cos k ≥ 0` for `c² + s² = 1`.
-/
theorem wilson_scalar_nonneg (c s k : ℝ) (hpyth : c ^ 2 + s ^ 2 = 1) :
    0 ≤ 1 - c * Real.cos k := by
  nlinarith [ sq_nonneg ( c * Real.sin k - s * Real.cos k ), Real.sin_sq_add_cos_sq k ]

/-
**Zone-edge value.** At the Brillouin-zone edge `k = π` the Wilson scalar is
`1 - c cos π = 1 + c` (≈ `2` for small `θ`, the doubler-lifting mass).
-/
theorem wilson_scalar_zoneEdge (c : ℝ) :
    1 - c * Real.cos Real.pi = 1 + c := by
  norm_num

/-
**Symbol-level Ginsparg–Wilson conjugation.**  The chirality grading `σ_z`
together with the momentum-space edge-orientation reversal `k ↦ -k` (the Fourier
avatar of the spatial reflection `Γ_r`) conjugates the transfer symbol to its
conjugate transpose: `σ_z · T̂(-k) · σ_z = T̂(k)ᴴ`.  With `transferSymbol_unitary`
this is the exact GW conjugation `Γ_r T Γ_r = T⁻¹` at symbol level, respecting the
palindromic convention of `GWConjecture.lean`.
-/
theorem gw_symbol (c s k : ℝ) :
    sigZ * transferSymbol c s (-k) * sigZ = (transferSymbol c s k)ᴴ := by
  -- Let's compute the conjugate transpose of the transfer symbol.
  simp [sigZ, transferSymbol];
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ]

end PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol
