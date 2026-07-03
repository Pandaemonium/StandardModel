import Mathlib

/-!
# P1/P2 bridge suite: the chirality-coupling amplitude IS the Pluecker wedge

PROOF TARGETS for Aristotle (complete every `sorry`; do NOT change any
statement). Self-contained, Mathlib only.

## Physics context (not needed for the proofs)

A research program represents four-momenta as Hermitian 2x2 matrices
(`det = m^2`, rank-one = null = massless) and has a kernel-checked theorem
that the determinant of a sum of rank-one spinor squares equals the total
pairwise squared "Pluecker wedge" of the spinors ("mass = disagreement of
null directions"). Separately, the standard Dirac/quantum-walk picture says
mass is the amplitude `mu` of the chirality-flip (sigma_x) coupling between
two null movers ("mass = flip rate"). This file is the BRIDGE that proves the
two mass stories give the SAME scalar in the minimal 1+1 dimensional model:

* the canonical two-null split of the on-shell momentum `(E, k)` with
  `E = sqrt(k^2 + mu^2)` has squared wedge exactly `mu^2`
  (`onshell_wedge_normSq_eq_coin_sq`);
* the Dirac Hamiltonian `H = k sigma_z + mu sigma_x` has the explicit
  eigenvector whose sigma_x (chirality) coherence is exactly `mu / E`
  (`diracEigvec_chirality_coherence`), matching the normalized bundle
  mixedness (`coherence_bundle_bridge`);
* the discrete-time null-step walk `U = zRot(k a) * xRot(mu a)` has the
  checkerboard dispersion `trace = 2 cos(ka) cos(mu a)`
  (`walkStep_trace_dispersion`), an explicit eigenvector
  (`walkStep_mulVec_eigvec`), and EXACT finite-a chirality coherence
  `|sin(mu a)| / sin(omega a)` (`walkEigvec_coherence_abs`), whose continuum
  reading is `mu / E`.

Everything is exact finite 2x2 linear algebra and real trigonometry - no
limits, no analysis beyond `Real.sqrt` and `Real.sin/cos`.

## Proof notes (verified by hand; use freely)

* `solder (wp + wm) (wp - wm)` is diagonal `diag(2 wp, 2 wm)`;
  `rankOne (psiR wp) = diag(2 wp, 0)` and `rankOne (psiL wm) = diag(0, 2 wm)`
  once `Real.sq_sqrt` (with `0 <= 2*w`) is applied. Entrywise `fin_cases` +
  `simp [Matrix.vecMulVec, ...]` + `norm_num` should close sections 1-2.
* `spinorWedge (psiR wp) (psiL wm) = sqrt(2 wp) * sqrt(2 wm)` (real), so its
  `normSq` is `4 wp wm`; the determinant of the diagonal solder is
  `(E + k)(E - k)`. For the on-shell case use
  `Real.sq_sqrt (by positivity : (0:R) <= k^2 + mu^2)` and
  `Real.sqrt_le/abs` facts: `|k| <= sqrt(k^2 + mu^2)`, so
  `(E + k)/2, (E - k)/2 >= 0`.
* Dirac eigenvector check (by hand): with `E = sqrt(k^2+mu^2)`,
  `v = (mu, E - k)`: `(k sz + mu sx) v = (k mu + mu (E - k), -k(E-k) + mu^2)
  = (mu E, E^2 - kE) = E v`, using `mu^2 = E^2 - k^2`.
* Coherence check: `<v, sx v> = 2 mu (E - k)` and `<v, v> = mu^2 + (E-k)^2
  = 2E(E - k)`, so `<v, sx v> * E = mu * <v, v>` exactly.
* Walk eigenvector check (by hand): write `al = k*a`, `be = mu*a`,
  `s = sinOmega = sqrt(1 - cos^2 al cos^2 be)`, `d = s - sin al * cos be`.
  With `v = (exp(-i al) sin be, d)` and `lam = cos al cos be - i s`:
  row 0 reduces to `exp(-i al) cos be - i d = cos al cos be - i s` (expand
  `exp(-i al) = cos al - i sin al`); row 1 reduces to
  `sin^2 be = d * (s + sin al cos be) = s^2 - sin^2 al cos^2 be`, which is
  `1 - cos^2 al cos^2 be - sin^2 al cos^2 be = 1 - cos^2 be`. Use
  `Complex.ext_iff`, `Complex.exp_re/im` or `Complex.exp` expansion via
  `Complex.exp_mul_I`, and `Real.sq_sqrt (by nlinarith : (0:R) <= 1 - _)`
  (note `(cos al * cos be)^2 <= 1` since each `|cos| <= 1`).
* Coherence identity: `2 s d = sin^2 be + d^2` is equivalent (by `ring`)
  to `s^2 = sin^2 al cos^2 be + sin^2 be`, i.e. `Real.sq_sqrt` plus
  `sin^2 + cos^2 = 1` twice.
* For `walkEigvec_coherence_abs`: `‖v 0‖ = |sin be|` (unit modulus of
  `exp(-i al)`: `Complex.norm_exp` and purely-imaginary exponent, e.g. via
  `Complex.norm_exp_ofReal_mul_I` or `norm_mul`), and `‖v 1‖ = |d| = d`
  (show `d >= 0` from `s^2 = sin^2 al cos^2 be + sin^2 be >= (sin al cos be)^2`
  hence `s >= sin al * cos be`), then reduce to the real identity above.

## Deliverables

No `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. Do not change any statement. If a
statement appears false, STOP and report (do not weaken it silently).
-/

noncomputable section

namespace P1Bridge

open Matrix

/-- A complex two-component (Weyl) spinor. -/
abbrev CSpinor := Fin 2 → ℂ

/-- Spinor Pluecker bracket (wedge): `psi_0 phi_1 - psi_1 phi_0`. -/
def spinorWedge (psi phi : CSpinor) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

/-- Rank-one Hermitian bispinor `psi psi^dagger`. -/
def rankOne (psi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec psi (star psi)

/-- Pauli matrix `sigma_x` (the chirality-flip / mass direction). -/
def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli matrix `sigma_z` (the chirality / transport direction). -/
def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- 1+1D soldered momentum `E * 1 + k * sigma_z`. -/
def solder (E k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (E : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) + (k : ℂ) • sigmaZ

/-- Right-moving null spinor of energy `w`. -/
def psiR (w : ℝ) : CSpinor := ![(Real.sqrt (2 * w) : ℂ), 0]

/-- Left-moving null spinor of energy `w`. -/
def psiL (w : ℝ) : CSpinor := ![0, (Real.sqrt (2 * w) : ℂ)]

/-! ## 1. Each constituent is null (massless) -/

/-- A single rank-one bispinor has zero determinant: one null edge is
massless. -/
theorem rankOne_det_eq_zero (psi : CSpinor) : (rankOne psi).det = 0 := by
  sorry

/-! ## 2. The canonical two-null resolution of a 1+1D momentum -/

/-- Every future momentum `(wp + wm, wp - wm)` is the sum of a right-moving
and a left-moving null bispinor with energies `wp, wm >= 0`. -/
theorem twoNull_resolution (wp wm : ℝ) (hwp : 0 ≤ wp) (hwm : 0 ≤ wm) :
    rankOne (psiR wp) + rankOne (psiL wm) = solder (wp + wm) (wp - wm) := by
  sorry

/-- The squared Pluecker wedge of the two null constituents equals the
determinant (invariant mass square) of the soldered total momentum. -/
theorem wedge_normSq_eq_det_solder (wp wm : ℝ) (hwp : 0 ≤ wp) (hwm : 0 ≤ wm) :
    ((Complex.normSq (spinorWedge (psiR wp) (psiL wm)) : ℝ) : ℂ)
      = (solder (wp + wm) (wp - wm)).det := by
  sorry

/-! ## 3. THE BRIDGE: on-shell, the coin amplitude IS the wedge -/

/-- **No-double-counting bridge.**  For the on-shell momentum `(E, k)` with
`E = sqrt(k^2 + mu^2)`, the canonical two-null split has energies
`(E + k)/2` and `(E - k)/2`, and the squared Pluecker wedge of its two null
constituents is EXACTLY `mu^2` - the square of the chirality-flip (Yukawa /
mass-coin) amplitude.  Geometric mass and coupling mass are one scalar. -/
theorem onshell_wedge_normSq_eq_coin_sq (k mu : ℝ) :
    Complex.normSq
        (spinorWedge (psiR ((Real.sqrt (k ^ 2 + mu ^ 2) + k) / 2))
          (psiL ((Real.sqrt (k ^ 2 + mu ^ 2) - k) / 2)))
      = mu ^ 2 := by
  sorry

/-! ## 4. The Dirac Hamiltonian side: coherence = mu / E -/

/-- The 1+1D Dirac Hamiltonian `H(k) = k sigma_z + mu sigma_x`. -/
def diracH (k mu : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (k : ℂ) • sigmaZ + (mu : ℂ) • sigmaX

/-- Explicit positive-energy eigenvector `(mu, E - k)`. -/
def diracEigvec (k mu : ℝ) : CSpinor :=
  ![(mu : ℂ), ((Real.sqrt (k ^ 2 + mu ^ 2) - k : ℝ) : ℂ)]

/-- `H v = E v` for the explicit eigenvector. -/
theorem diracH_mulVec_eigvec (k mu : ℝ) :
    (diracH k mu) *ᵥ (diracEigvec k mu)
      = ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ) • (diracEigvec k mu) := by
  sorry

/-- **Chirality coherence is `mu / E`, exactly** (cleared of denominators):
`<v, sigma_x v> * E = mu * <v, v>` for the on-shell eigenvector. -/
theorem diracEigvec_chirality_coherence (k mu : ℝ) :
    (star (diracEigvec k mu) ⬝ᵥ (sigmaX *ᵥ diracEigvec k mu))
        * ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ)
      = (mu : ℂ) * (star (diracEigvec k mu) ⬝ᵥ diracEigvec k mu) := by
  sorry

/-- The same ratio is the normalized bundle mixedness: for the on-shell
soldered momentum, `4 det P * E^2 = mu^2 * (trace P)^2`, i.e.
`(mu/E)^2 = 4 det P / (trace P)^2`. -/
theorem coherence_bundle_bridge (k mu : ℝ) :
    4 * (solder (Real.sqrt (k ^ 2 + mu ^ 2)) k).det
        * ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ) ^ 2
      = ((mu : ℝ) : ℂ) ^ 2 * ((solder (Real.sqrt (k ^ 2 + mu ^ 2)) k).trace) ^ 2 := by
  sorry

/-! ## 5. The discrete null-step walk: exact finite-a dispersion and coherence -/

/-- Diagonal (transport) rotation `exp(-i t sigma_z)`, written explicitly. -/
def zRot (t : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (-(t : ℂ) * Complex.I), 0; 0, Complex.exp ((t : ℂ) * Complex.I)]

/-- Chirality-flip (mass-coin) rotation `exp(-i t sigma_x)`, written
explicitly. -/
def xRot (t : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((Real.cos t : ℝ) : ℂ), -((Real.sin t : ℝ) : ℂ) * Complex.I;
     -((Real.sin t : ℝ) : ℂ) * Complex.I, ((Real.cos t : ℝ) : ℂ)]

/-- One step of the null-step (checkerboard) walk at momentum `k`, mass coin
`mu`, step `a`. -/
def walkStep (k mu a : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  zRot (k * a) * xRot (mu * a)

/-- `sin(omega a)` for the walk quasienergy `cos(omega a) = cos(ka) cos(mu a)`. -/
def sinOmega (k mu a : ℝ) : ℝ :=
  Real.sqrt (1 - (Real.cos (k * a) * Real.cos (mu * a)) ^ 2)

/-- **Checkerboard dispersion, trace form**: `Tr U = 2 cos(ka) cos(mu a)`,
i.e. `cos(omega a) = cos(ka) cos(mu a)` for the unitary walk step. -/
theorem walkStep_trace_dispersion (k mu a : ℝ) :
    (walkStep k mu a).trace
      = ((2 * Real.cos (k * a) * Real.cos (mu * a) : ℝ) : ℂ) := by
  sorry

/-- The walk step has unit determinant. -/
theorem walkStep_det_one (k mu a : ℝ) : (walkStep k mu a).det = 1 := by
  sorry

/-- Explicit walk eigenvector `(exp(-i ka) sin(mu a), s - sin(ka) cos(mu a))`
with `s = sinOmega`. -/
def walkEigvec (k mu a : ℝ) : CSpinor :=
  ![Complex.exp (-((k * a : ℝ) : ℂ) * Complex.I) * ((Real.sin (mu * a) : ℝ) : ℂ),
    ((sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a) : ℝ) : ℂ)]

/-- Explicit walk eigenvalue `cos(ka) cos(mu a) - i sin(omega a)` (unit
modulus). -/
def walkEigval (k mu a : ℝ) : ℂ :=
  ((Real.cos (k * a) * Real.cos (mu * a) : ℝ) : ℂ)
    - Complex.I * ((sinOmega k mu a : ℝ) : ℂ)

/-- `U v = lam v` for the explicit walk eigenvector and eigenvalue. -/
theorem walkStep_mulVec_eigvec (k mu a : ℝ) :
    (walkStep k mu a) *ᵥ (walkEigvec k mu a)
      = (walkEigval k mu a) • (walkEigvec k mu a) := by
  sorry

/-- The core real coherence identity behind the walk eigenstate:
`2 s d = sin^2(mu a) + d^2` for `d = s - sin(ka) cos(mu a)`, `s = sinOmega`.
Equivalent to `s^2 = sin^2(ka) cos^2(mu a) + sin^2(mu a)`. -/
theorem walk_coherence_identity (k mu a : ℝ) :
    2 * sinOmega k mu a * (sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a))
      = Real.sin (mu * a) ^ 2
        + (sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a)) ^ 2 := by
  sorry

/-- **Exact finite-`a` chirality coherence of the walk eigenstate**:
`2 |v_0| |v_1| * sin(omega a) = |sin(mu a)| * ||v||^2`, i.e. the z-chirality
coherence of the eigenvector is `|sin(mu a)| / sin(omega a)` - the discrete
`m / E`, exact at every step size. -/
theorem walkEigvec_coherence_abs (k mu a : ℝ) :
    2 * ‖walkEigvec k mu a 0‖ * ‖walkEigvec k mu a 1‖
        * sinOmega k mu a
      = |Real.sin (mu * a)|
        * (‖walkEigvec k mu a 0‖ ^ 2 + ‖walkEigvec k mu a 1‖ ^ 2) := by
  sorry

end P1Bridge
