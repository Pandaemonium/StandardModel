/-
# Chiral-symmetry forcing of protected transfer eigenvalues (T1)

DRAFT (kernel-clean; no `s o r r y`). The K6 target of the overnight
all-mass run (2026-07-08), redirected by the determinant-parity probe
`Scripts/oracle/p1_zeromode_symmetry_invariant.py`.

## What the probe decided (numeric oracle; guides this statement)

The protected unit eigenvalue of the decorated-cycle transfer `W` is NOT
forced by cyclic symmetry - abstract winding-1 symmetric data is UNPINNED
(min|ev - 1| ~ 0.2-0.45), and equivariant-but-unpinned cases are common.
It is forced by a CHIRAL symmetry: an involution `Gamma` (`Gamma^2 = 1`)
with `Gamma W Gamma = W^dagger`. Numerically this `Gamma` is the
orientation-swap, i.e. the edge-orientation-reversal grading - the SAME
grading that gives the exact Ginsparg-Wilson structure
(`GWRetardedTransfer.lean`). It is present exactly for the even-V
half-winding (alternating-phase) decoration and there pins BOTH `+1` and
`-1` in `spec(W)` for every hop amplitude `|t|` (probe: V = 4, 6, 8).

## What this module proves (the honest kernel core)

For a unitary `W` carrying such a chiral involution:

* `chiral_det_conj`: `det W` is real (`conj (det W) = det W`);
* `chiral_det_sq_one`: `(det W)^2 = 1`;
* `chiral_det_eq_pm_one`: hence `det W = 1` or `det W = -1`.

Since `det W = (-1)^{mult(-1)}` up to conjugate-pair factors, the sign of
`det W` fixes the PARITY of the `-1`-eigenvalue multiplicity - the honest
core of the determinant-parity mechanism (SevenChallenges memo finding 8).

CORRECTION (Fable call-02, 2026-07-08): the full `|t|`-independent DOUBLE
pinning (both `+-1` present at even dimension) is NOT forced by a global
winding invariant - Fable measured the global Asboth-Obuse-type index to
VANISH for the half-winding decoration (`tr Gamma = 0`, `tr(Gamma W) = 0`,
`nu_0 = nu_pi = 0`), while `mult(+1) = mult(-1) = 2`. The correct mechanism
is an EQUIVARIANT REFLECTION-SECTORED index: `W` commutes with a reflection
`R` (leg-reversal composed with orientation swap, `R^2 = 1`, `[R, Gamma]
= 0`), and the two `R`-sectors carry OPPOSITE chiral indices `(+1,+1)` and
`(-1,-1)` that cancel globally but each pin one `+-1` mode. The sector
index is `nu = +- (1/4) tr(Gamma R)`, a Lefschetz fixed-point count (`=
#fixed legs`) that does NOT involve `W` - which is why the pinning is
`|t|`-independent. Full analysis and the `M`-target sectored-pinning
theorem: Fable call-02 log + the run's C4 note; the abstract engine here
(`det = +-1`) stands.

## Claim boundary

Finite matrix algebra, no spectral theorem. `det = +-1` is proved; the
eigenvalue-multiplicity reading is stated in prose, not in a theorem.
No continuum, no physical-mode claim beyond the finite determinant fact.

## Provenance

Mechanism identified by the overnight K6 probe (2026-07-08); the chiral
`Gamma U Gamma = U^dagger` structure and its `0/pi`-mode consequences are
standard for chiral-symmetric quantum walks (Asboth-Obuse 2013,
arXiv:1303.1199, in the paper graph) - [import]/[comp]. The edge-reversal
identification is this program's (`GWRetardedTransfer.lean`) - [orig].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A **chiral involution** for `W`: a self-inverse `Gamma` conjugating `W`
to its adjoint. For unitary `W` (`Wᴴ * W = 1`) this says `Gamma` conjugates
`W` to `W⁻¹` - the reciprocal-pairing (chiral) symmetry. -/
structure ChiralInvolution (W Gamma : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  chiral : Gamma * W * Gamma = Wᴴ

/-- Under a chiral involution, `det Gamma` squares to one. -/
theorem chiral_detGamma_sq {W Gamma : Matrix n n ℂ}
    (h : ChiralInvolution W Gamma) : Gamma.det * Gamma.det = 1 := by
  rw [← Matrix.det_mul, h.invol, Matrix.det_one]

/-- **`det W` is real** under a chiral involution: `conj (det W) = det W`.
(Taking `det` of `Gamma W Gamma = Wᴴ` and using `det Gamma ^2 = 1`.) -/
theorem chiral_det_conj {W Gamma : Matrix n n ℂ}
    (h : ChiralInvolution W Gamma) :
    (starRingEnd ℂ) W.det = W.det := by
  have hdet : Gamma.det * W.det * Gamma.det = (Wᴴ).det := by
    rw [← Matrix.det_mul, ← Matrix.det_mul, h.chiral]
  rw [Matrix.det_conjTranspose] at hdet
  -- LHS = det W * (det Gamma)^2 = det W
  have hcomm : Gamma.det * W.det * Gamma.det
      = W.det * (Gamma.det * Gamma.det) := by ring
  rw [hcomm, chiral_detGamma_sq h, mul_one] at hdet
  exact hdet.symm

/-- Under a chiral involution with `W` unitary, `(det W)^2 = 1`. -/
theorem chiral_det_sq_one {W Gamma : Matrix n n ℂ}
    (h : ChiralInvolution W Gamma) (hU : Wᴴ * W = 1) :
    W.det * W.det = 1 := by
  -- |det W|^2 = 1 from unitarity, and det W real from the chiral symmetry
  have hmod : (starRingEnd ℂ) W.det * W.det = 1 := by
    have : (Wᴴ * W).det = 1 := by rw [hU, Matrix.det_one]
    rwa [Matrix.det_mul, Matrix.det_conjTranspose] at this
  rw [chiral_det_conj h] at hmod
  exact hmod

/-- **The chiral determinant dichotomy (T1 core).** A unitary `W` carrying
a chiral involution has `det W = 1` or `det W = -1`. The sign fixes the
parity of the `-1`-eigenvalue multiplicity: the honest kernel core of the
determinant-parity forcing of protected `+-1` transfer modes. -/
theorem chiral_det_eq_pm_one {W Gamma : Matrix n n ℂ}
    (h : ChiralInvolution W Gamma) (hU : Wᴴ * W = 1) :
    W.det = 1 ∨ W.det = -1 := by
  have hsq : W.det * W.det = 1 := chiral_det_sq_one h hU
  have : (W.det - 1) * (W.det + 1) = 0 := by
    have : (W.det - 1) * (W.det + 1) = W.det * W.det - 1 := by ring
    rw [this, hsq, sub_self]
  rcases mul_eq_zero.mp this with h1 | h2
  · exact Or.inl (by linear_combination h1)
  · exact Or.inr (by linear_combination h2)

end PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity
