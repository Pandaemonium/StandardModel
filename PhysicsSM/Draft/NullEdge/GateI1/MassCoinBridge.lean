import Mathlib

/-!
# Gate I1 extension: the mass-coin / Pluecker-wedge bridge and the walk coherence suite

Harvested from Aristotle job f983a254 (package
`AgentTasks/aristotle-standalone/p1-bridge-coherence-20260703`); all 12
statements were authored in-repo, hand-verified, and proved by Aristotle with
NO statement changed.  This is the **no-double-counting bridge** of the
origin-of-mass program (P1 manuscript, layer 2/4): it proves that the two mass
stories - geometric (Pluecker wedge / determinant of the soldered momentum)
and dynamical (chirality-flip coin amplitude) - are the SAME scalar in the
minimal 1+1D model, with no limits taken:

* `onshell_wedge_normSq_eq_coin_sq`: the squared Pluecker wedge of the
  canonical two-null split of the on-shell momentum `(E, k)`,
  `E = sqrt(k^2 + mu^2)`, is EXACTLY `mu^2` - coupling mass = geometric mass;
* `twoNull_resolution` / `rankOne_det_eq_zero` / `wedge_normSq_eq_det_solder`:
  the 1+1D two-null resolution and its wedge/determinant identity;
* `diracH_mulVec_eigvec` / `diracEigvec_chirality_coherence` /
  `coherence_bundle_bridge`: the Dirac eigenvector's chirality coherence is
  `mu/E` exactly, matching the normalized bundle mixedness
  `4 det P / (Tr P)^2`;
* `walkStep_trace_dispersion` / `walkStep_det_one` / `walkStep_mulVec_eigvec` /
  `walk_coherence_identity` / `walkEigvec_coherence_abs`: the discrete
  null-step (checkerboard) walk's dispersion `cos(wa) = cos(ka) cos(mua)`,
  explicit eigenvector, and EXACT finite-step chirality coherence
  `|sin(mua)| / sin(wa)` (continuum reading `m/E`).

Everything is exact finite 2x2 complex linear algebra and real trigonometry.
Interpretation-free reading (Round 8 discipline): statements are about
explicit 2x2 matrices and spinors; the physics reading (mass, chirality,
momentum) enters only through the soldering convention documented in
`GateI1.Core` and the P1 manuscript.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity** (the P1/P2 bridge layer).
Prerequisites: Mathlib only.  Successors: 3+1D generalization; connection to
the position-space checkerboard stack (GateD); the P2 manuscript.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateI1
namespace MassCoinBridge

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

/-
A single rank-one bispinor has zero determinant: one null edge is
massless.
-/
theorem rankOne_det_eq_zero (psi : CSpinor) : (rankOne psi).det = 0 := by
  simp [rankOne, Matrix.vecMulVec, Matrix.det_fin_two];
  ring

/-! ## 2. The canonical two-null resolution of a 1+1D momentum -/

/-
Every future momentum `(wp + wm, wp - wm)` is the sum of a right-moving
and a left-moving null bispinor with energies `wp, wm >= 0`.
-/
theorem twoNull_resolution (wp wm : ℝ) (hwp : 0 ≤ wp) (hwm : 0 ≤ wm) :
    rankOne (psiR wp) + rankOne (psiL wm) = solder (wp + wm) (wp - wm) := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ rankOne, psiR, psiL, solder, sigmaZ ] <;> ring;
  · norm_cast ; norm_num [ mul_comm, hwp, hwm ];
  · norm_cast ; norm_num [ mul_comm, hwp, hwm ]

/-
The squared Pluecker wedge of the two null constituents equals the
determinant (invariant mass square) of the soldered total momentum.
-/
theorem wedge_normSq_eq_det_solder (wp wm : ℝ) (hwp : 0 ≤ wp) (hwm : 0 ≤ wm) :
    ((Complex.normSq (spinorWedge (psiR wp) (psiL wm)) : ℝ) : ℂ)
      = (solder (wp + wm) (wp - wm)).det := by
  unfold spinorWedge psiR psiL solder;
  simp +decide [ Matrix.det_fin_two, sigmaZ ] ; ring;
  norm_cast ; rw [ Real.sq_sqrt hwp, Real.sq_sqrt hwm ]

/-! ## 3. THE BRIDGE: on-shell, the coin amplitude IS the wedge -/

/-
**No-double-counting bridge.**  For the on-shell momentum `(E, k)` with
`E = sqrt(k^2 + mu^2)`, the canonical two-null split has energies
`(E + k)/2` and `(E - k)/2`, and the squared Pluecker wedge of its two null
constituents is EXACTLY `mu^2` - the square of the chirality-flip (Yukawa /
mass-coin) amplitude.  Geometric mass and coupling mass are one scalar.
-/
theorem onshell_wedge_normSq_eq_coin_sq (k mu : ℝ) :
    Complex.normSq
        (spinorWedge (psiR ((Real.sqrt (k ^ 2 + mu ^ 2) + k) / 2))
          (psiL ((Real.sqrt (k ^ 2 + mu ^ 2) - k) / 2)))
      = mu ^ 2 := by
  unfold psiR psiL spinorWedge;
  norm_num;
  rw [ Real.mul_self_sqrt, Real.mul_self_sqrt ] <;> nlinarith [ Real.sqrt_nonneg ( k ^ 2 + mu ^ 2 ), Real.mul_self_sqrt ( by positivity : 0 ≤ k ^ 2 + mu ^ 2 ) ]

/-! ## 4. The Dirac Hamiltonian side: coherence = mu / E -/

/-- The 1+1D Dirac Hamiltonian `H(k) = k sigma_z + mu sigma_x`. -/
def diracH (k mu : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (k : ℂ) • sigmaZ + (mu : ℂ) • sigmaX

/-- Explicit positive-energy eigenvector `(mu, E - k)`. -/
def diracEigvec (k mu : ℝ) : CSpinor :=
  ![(mu : ℂ), ((Real.sqrt (k ^ 2 + mu ^ 2) - k : ℝ) : ℂ)]

/-
`H v = E v` for the explicit eigenvector.
-/
theorem diracH_mulVec_eigvec (k mu : ℝ) :
    (diracH k mu) *ᵥ (diracEigvec k mu)
      = ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ) • (diracEigvec k mu) := by
  unfold diracH diracEigvec;
  norm_num [ ← List.ofFn_inj, Matrix.vecMulVec ];
  norm_num [ Matrix.mulVec, dotProduct, sigmaX, sigmaZ ] ; ring;
  norm_cast ; rw [ Real.sq_sqrt <| by positivity ] ; ring;
  norm_num

/-
**Chirality coherence is `mu / E`, exactly** (cleared of denominators):
`<v, sigma_x v> * E = mu * <v, v>` for the on-shell eigenvector.
-/
theorem diracEigvec_chirality_coherence (k mu : ℝ) :
    (star (diracEigvec k mu) ⬝ᵥ (sigmaX *ᵥ diracEigvec k mu))
        * ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ)
      = (mu : ℂ) * (star (diracEigvec k mu) ⬝ᵥ diracEigvec k mu) := by
  unfold diracEigvec sigmaX ;
  simp +decide [ dotProduct, Matrix.mulVec ];
  norm_cast; ring; rw [ Real.sq_sqrt <| by positivity ] ; ring;

/-
The same ratio is the normalized bundle mixedness: for the on-shell
soldered momentum, `4 det P * E^2 = mu^2 * (trace P)^2`, i.e.
`(mu/E)^2 = 4 det P / (trace P)^2`.
-/
theorem coherence_bundle_bridge (k mu : ℝ) :
    4 * (solder (Real.sqrt (k ^ 2 + mu ^ 2)) k).det
        * ((Real.sqrt (k ^ 2 + mu ^ 2) : ℝ) : ℂ) ^ 2
      = ((mu : ℝ) : ℂ) ^ 2 * ((solder (Real.sqrt (k ^ 2 + mu ^ 2)) k).trace) ^ 2 := by
  unfold solder;
  norm_num [ Matrix.det_fin_two, Matrix.trace_fin_two, sigmaZ ] ; ring;
  norm_cast; rw [ show ( Real.sqrt ( k ^ 2 + mu ^ 2 ) ) ^ 4 = ( Real.sqrt ( k ^ 2 + mu ^ 2 ) ^ 2 ) ^ 2 by ring, Real.sq_sqrt <| by positivity ] ; ring;

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

/-
**Checkerboard dispersion, trace form**: `Tr U = 2 cos(ka) cos(mu a)`,
i.e. `cos(omega a) = cos(ka) cos(mu a)` for the unitary walk step.
-/
theorem walkStep_trace_dispersion (k mu a : ℝ) :
    (walkStep k mu a).trace
      = ((2 * Real.cos (k * a) * Real.cos (mu * a) : ℝ) : ℂ) := by
  unfold walkStep;
  unfold zRot xRot; norm_num [ Matrix.trace ] ; ring;
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos ] ; ring;
  norm_num

/-
The walk step has unit determinant.
-/
theorem walkStep_det_one (k mu a : ℝ) : (walkStep k mu a).det = 1 := by
  unfold walkStep zRot xRot; norm_num [ Complex.exp_re, Complex.exp_im, Matrix.det_fin_two ] ; ring;
  norm_cast ; norm_num [ Complex.sin_sq, Complex.cos_sq ] ; ring;
  rw [ ← Complex.exp_add, neg_add_cancel, Complex.exp_zero ]

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

/-
`U v = lam v` for the explicit walk eigenvector and eigenvalue.
-/
theorem walkStep_mulVec_eigvec (k mu a : ℝ) :
    (walkStep k mu a) *ᵥ (walkEigvec k mu a)
      = (walkEigval k mu a) • (walkEigvec k mu a) := by
  ext i; fin_cases i <;> simp [walkStep, zRot, xRot, walkEigvec, walkEigval] <;> ring!;
  · rw [ ← Complex.exp_nat_mul ] ; ring;
    rw [ show ( - ( Complex.I * k * a * 2 ) : ℂ ) = - ( Complex.I * k * a ) + - ( Complex.I * k * a ) by ring, Complex.exp_add ] ; norm_num [ Complex.cos, Complex.sin ] ; ring;
    norm_num [ pow_three, ← Complex.exp_nat_mul, ← Complex.exp_add ] ; ring;
  · unfold sinOmega; norm_num [ Complex.ext_iff, pow_two, Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring;
    exact ⟨ trivial, by rw [ Real.sq_sqrt ( by nlinarith [ Real.cos_sq_le_one ( k * a ), Real.cos_sq_le_one ( a * mu ) ] ) ] ; rw [ Real.sin_sq, Real.sin_sq ] ; ring ⟩

/-
The core real coherence identity behind the walk eigenstate:
`2 s d = sin^2(mu a) + d^2` for `d = s - sin(ka) cos(mu a)`, `s = sinOmega`.
Equivalent to `s^2 = sin^2(ka) cos^2(mu a) + sin^2(mu a)`.
-/
theorem walk_coherence_identity (k mu a : ℝ) :
    2 * sinOmega k mu a * (sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a))
      = Real.sin (mu * a) ^ 2
        + (sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a)) ^ 2 := by
  unfold sinOmega; nlinarith [ Real.sin_sq_add_cos_sq ( k * a ), Real.sin_sq_add_cos_sq ( mu * a ), Real.sqrt_nonneg ( 1 - ( Real.cos ( k * a ) * Real.cos ( mu * a ) ) ^ 2 ), Real.mul_self_sqrt ( show 0 <= 1 - ( Real.cos ( k * a ) * Real.cos ( mu * a ) ) ^ 2 by nlinarith [ Real.cos_sq_le_one ( k * a ), Real.cos_sq_le_one ( mu * a ) ] ) ] ;

/-
**Exact finite-`a` chirality coherence of the walk eigenstate**:
`2 |v_0| |v_1| * sin(omega a) = |sin(mu a)| * ||v||^2`, i.e. the z-chirality
coherence of the eigenvector is `|sin(mu a)| / sin(omega a)` - the discrete
`m / E`, exact at every step size.
-/
theorem walkEigvec_coherence_abs (k mu a : ℝ) :
    2 * ‖walkEigvec k mu a 0‖ * ‖walkEigvec k mu a 1‖
        * sinOmega k mu a
      = |Real.sin (mu * a)|
        * (‖walkEigvec k mu a 0‖ ^ 2 + ‖walkEigvec k mu a 1‖ ^ 2) := by
  -- Substitute the norms of the components into the goal.
  have h_norms : ‖walkEigvec k mu a 0‖ = |Real.sin (mu * a)| ∧ ‖walkEigvec k mu a 1‖ = sinOmega k mu a - Real.sin (k * a) * Real.cos (mu * a) := by
    unfold walkEigvec;
    norm_num [ Complex.norm_def, Complex.normSq, Complex.exp_re, Complex.exp_im, Complex.sin, Complex.cos ];
    rw [ Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs ] ; ring ; norm_num;
    unfold sinOmega; ring_nf; norm_num;
    exact Real.le_sqrt_of_sq_le ( by nlinarith [ sq_nonneg ( Real.sin ( a * k ) * Real.cos ( a * mu ) ), Real.sin_sq_add_cos_sq ( a * k ), Real.sin_sq_add_cos_sq ( a * mu ) ] );
  grind +suggestions

end MassCoinBridge
end GateI1
end NullEdge
end Draft
end PhysicsSM
