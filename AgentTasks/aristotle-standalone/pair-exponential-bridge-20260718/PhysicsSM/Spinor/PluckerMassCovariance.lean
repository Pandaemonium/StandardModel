import PhysicsSM.Spinor.PluckerObstruction

/-!
# Spinor.PluckerMassCovariance

SL(2,C)-covariance wrapper for the Pluecker mass obstruction (job B9).

This module proves the covariance/invariance behaviour of the finite Pluecker
mass and the canonical obstruction `B_Pl` under the natural action of
`GL(2,C)`/`SL(2,C)` on visible Weyl spinors,

```text
psi ↦ A · psi   (A : Matrix (Fin 2) (Fin 2) ℂ acting by mulVec).
```

The decisive finite facts are:

* the spinor wedge is a relative invariant of weight `det A`:
  `wedge (A·psi) (A·phi) = det A · wedge psi phi`;
* hence the obstruction scales by `|det A|^2 = normSq (det A)`;
* and on the special linear group `det A = 1` the obstruction — and the whole
  determinant mass — is **invariant**.

Strength and gap.  `SL(2,C)` is the double cover of the connected Lorentz
group `SO^+(1,3)`, so invariance under the full `SL(2,C)` congruence on the
visible spinors is exactly proper-orthochronous Lorentz invariance of the
determinant mass.  We prove the algebraic `SL(2,C)` statement in full; we do
*not* construct the `SL(2,C) → SO^+(1,3)` covering map here (that map is the
only remaining gap between this algebraic covariance and a stated Lorentz
representation theorem).

## Convention & provenance banner (machine-checkable)

This module sits on the **trusted** `PhysicsSM.Spinor` surface.  The project
integration invariant requires every trusted theorem to declare its metric,
spinor, normalization, and frame conventions; the entries below are the
machine-checkable convention record, each tied to a concrete declaration.  The
mass/spinor conventions are inherited unchanged from `PhysicsSM.Spinor.PluckerMass`
and `PhysicsSM.Spinor.PluckerObstruction` and match `docs/CONVENTIONS.md`
(status: Locked).

* **Metric / signature.** Mostly-minus Lorentzian `(+,-,-,-)`; `SL(2,C)` is the
  double cover of the proper-orthochronous Lorentz group `SO^+(1,3)`.
* **Spinor convention.** Visible Weyl spinor `CSpinor = (Fin 2 -> ℂ)`; null
  bispinor `rankOneHermitian psi = vecMulVec psi (star psi) = psi psi^†`.
* **Determinant / mass normalization.** Determinant convention: the mass scalar
  is `det (finBundleMomentum psi)` and `B_Pl = Re (det ·)`; consistent with the
  base modules.  No trace-pairing or observer normalization is used here.
* **SL(2,C) action convention.** The frame action is **left `mulVec`**:
  `actSpinor A psi = A.mulVec psi`.  On the bispinor it is the congruence
  `rankOneHermitian (A · psi) = A * rankOneHermitian psi * Aᴴ` and
  `finBundleMomentum (A · psi) = A * finBundleMomentum psi * Aᴴ` (see
  `rankOneHermitian_actSpinor`, `finBundleMomentum_actSpinor`).  Consequences:
  the wedge is a relative invariant of weight `det A`
  (`spinorWedge_actSpinor`), `B_Pl` and the determinant mass scale by
  `Complex.normSq A.det = |det A|^2`
  (`bundleObstruction_actSpinor`, `finBundleMomentum_det_actSpinor`), and on
  `SL(2,C)` (`det A = 1`) the wedge, `B_Pl`, the determinant mass, and the
  massless locus are all **invariant** (`*_sl2_invariant`,
  `pairwiseWedgeZero_sl2_iff`).
* **Relation to older / draft Plücker files.** This trusted module is the
  promotion of the kernel-clean SL(2,C)-covariance draft previously held in
  `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets` (where the action was named
  `spinorAction`).  Manuscripts and crosswalks should cite the trusted action
  name `actSpinor` and this module, not the draft.  The twistor-chart matching
  layer (planned `PhysicsSM.Spinor.TwistorPluckerMass` / draft
  `TwistorPluckerMatch`) is a *separate* module and is **not** imported or
  relied on here.

Status: trusted, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Spinor.PluckerMassCovariance

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Spinor.PluckerObstruction

/-! ## The linear action on visible spinors -/

/-- The `GL(2,C)`/`SL(2,C)` action on a visible Weyl spinor by `mulVec`. -/
def actSpinor (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : CSpinor) : CSpinor :=
  A.mulVec psi

/-! ## Relative invariance of the wedge -/

/--
The spinor wedge is a relative invariant of weight `det A`:
`wedge (A·psi) (A·phi) = det A · wedge psi phi`.
-/
theorem spinorWedge_actSpinor (A : Matrix (Fin 2) (Fin 2) ℂ) (psi phi : CSpinor) :
    spinorWedge (actSpinor A psi) (actSpinor A phi) = A.det * spinorWedge psi phi := by
  simp only [actSpinor, spinorWedge, Matrix.mulVec, dotProduct,
    Fin.sum_univ_two, Matrix.det_fin_two]
  ring

/-- On `SL(2,C)` (`det A = 1`) the spinor wedge is invariant. -/
theorem spinorWedge_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1) (psi phi : CSpinor) :
    spinorWedge (actSpinor A psi) (actSpinor A phi) = spinorWedge psi phi := by
  rw [spinorWedge_actSpinor, hA, one_mul]

/-! ## Covariance of the two-edge obstruction -/

/-- The two-edge obstruction scales by `normSq (det A) = |det A|^2`. -/
theorem twoEdgeObstruction_actSpinor
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi phi : CSpinor) :
    twoEdgeObstruction (actSpinor A psi, actSpinor A phi)
      = Complex.normSq A.det * twoEdgeObstruction (psi, phi) := by
  simp only [twoEdgeObstruction]
  rw [spinorWedge_actSpinor, Complex.normSq_mul]

/-- On `SL(2,C)` the two-edge obstruction `B_Pl` is invariant. -/
theorem twoEdgeObstruction_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1) (psi phi : CSpinor) :
    twoEdgeObstruction (actSpinor A psi, actSpinor A phi)
      = twoEdgeObstruction (psi, phi) := by
  rw [twoEdgeObstruction_actSpinor, hA]
  simp

/-! ## Covariance of the finite-bundle obstruction and determinant mass -/

/-- A single rank-one Hermitian transforms by congruence: `A (psi psi^†) A^†`. -/
theorem rankOneHermitian_actSpinor
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : CSpinor) :
    rankOneHermitian (actSpinor A psi)
      = A * rankOneHermitian psi * Aᴴ := by
  ext i j
  simp only [actSpinor, rankOneHermitian, Matrix.vecMulVec_apply,
    Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.mulVec,
    dotProduct, Pi.star_apply, Fin.sum_univ_two, star_add, star_mul']
  ring

/-- The finite-bundle momentum transforms by `SL(2,C)`/`GL(2,C)` congruence. -/
theorem finBundleMomentum_actSpinor
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin n → CSpinor) :
    finBundleMomentum (fun i => actSpinor A (psi i))
      = A * finBundleMomentum psi * Aᴴ := by
  simp only [finBundleMomentum, rankOneHermitian_actSpinor]
  rw [Matrix.mul_sum, Finset.sum_mul]

/-- The determinant mass scales by `|det A|^2 = normSq (det A)`. -/
theorem finBundleMomentum_det_actSpinor
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin n → CSpinor) :
    (finBundleMomentum (fun i => actSpinor A (psi i))).det
      = (Complex.normSq A.det : ℂ) * (finBundleMomentum psi).det := by
  rw [finBundleMomentum_actSpinor, Matrix.det_mul, Matrix.det_mul,
    Matrix.det_conjTranspose]
  have hconj : A.det * star A.det = (Complex.normSq A.det : ℂ) := by
    rw [show star A.det = (starRingEnd ℂ) A.det from rfl, Complex.mul_conj]
  rw [mul_comm A.det (finBundleMomentum psi).det, mul_assoc, hconj]
  ring

/-- The finite-bundle obstruction `B_Pl` scales by `normSq (det A)`. -/
theorem bundleObstruction_actSpinor
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin n → CSpinor) :
    bundleObstruction (fun i => actSpinor A (psi i))
      = Complex.normSq A.det * bundleObstruction psi := by
  rw [bundleObstruction_eq_det_re, bundleObstruction_eq_det_re,
    finBundleMomentum_det_actSpinor]
  rw [Complex.mul_re]
  have him : ((finBundleMomentum psi).det).im = 0 := fin_bundle_det_im_eq_zero psi
  simp [Complex.ofReal_re, Complex.ofReal_im, him]

/-- On `SL(2,C)` the finite-bundle determinant mass is invariant. -/
theorem finBundleMomentum_det_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (psi : Fin n → CSpinor) :
    (finBundleMomentum (fun i => actSpinor A (psi i))).det
      = (finBundleMomentum psi).det := by
  rw [finBundleMomentum_det_actSpinor, hA]
  simp

/-- On `SL(2,C)` the finite-bundle obstruction `B_Pl` is invariant. -/
theorem bundleObstruction_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (psi : Fin n → CSpinor) :
    bundleObstruction (fun i => actSpinor A (psi i)) = bundleObstruction psi := by
  rw [bundleObstruction_actSpinor, hA]
  simp

/-! ## Covariance of the massless locus -/

/--
The massless (zero-spread) locus is preserved under any linear action: if all
pairwise wedges vanish, they still vanish after acting by `A`.
-/
theorem pairwiseWedgeZero_actSpinor
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin n → CSpinor)
    (h : PairwiseWedgeZero psi) :
    PairwiseWedgeZero (fun i => actSpinor A (psi i)) := by
  intro i j
  rw [spinorWedge_actSpinor, h i j, mul_zero]

/--
On `SL(2,C)` masslessness is an *invariant* of the configuration: the
transformed configuration is massless iff the original is.
-/
theorem pairwiseWedgeZero_sl2_iff
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (psi : Fin n → CSpinor) :
    PairwiseWedgeZero (fun i => actSpinor A (psi i)) ↔ PairwiseWedgeZero psi := by
  constructor
  · intro h i j
    have := h i j
    rw [spinorWedge_sl2_invariant A hA] at this
    exact this
  · exact pairwiseWedgeZero_actSpinor A psi

end PhysicsSM.Spinor.PluckerMassCovariance

end
