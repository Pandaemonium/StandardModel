import PhysicsSM.Spinor.PluckerMass

/-!
# Null-edge Pluecker / celestial moment bridge

Standalone Aristotle target for the T1 bridge from the trusted complex
Pluecker determinant theorem to the real celestial closure identity.

The target is purely finite algebra.  A complex two-spinor `psi` determines
an energy `|psi_0|^2 + |psi_1|^2` and an unnormalized Bloch vector.  The
desired theorem says the trusted determinant mass equals

```text
(E^2 - |C|^2) / 4,
```

where `E` is total bundle energy and `C` is the sum of Bloch vectors.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgePluckerCelestialBridge

open BigOperators Complex
open PhysicsSM.Spinor.PluckerMass

/-- A real three-vector in Bloch/celestial coordinates. -/
abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def dot (a b : Vec3) : Real :=
  Finset.univ.sum fun k : Fin 3 => a k * b k

/-- Squared Euclidean norm. -/
def normSq (a : Vec3) : Real := dot a a

/-- The trace/energy of the rank-one Hermitian matrix `psi psi^dagger`. -/
def spinorEnergy (psi : CSpinor) : Real :=
  Complex.normSq (psi 0) + Complex.normSq (psi 1)

/--
Unnormalized Bloch vector of a complex two-spinor.

For a normalized spinor this is the usual unit celestial direction; for an
arbitrary spinor its Euclidean norm is the spinor energy.
-/
def blochVector (psi : CSpinor) : Vec3 :=
  ![
    2 * (psi 0 * (starRingEnd Complex) (psi 1)).re,
    2 * (psi 0 * (starRingEnd Complex) (psi 1)).im,
    Complex.normSq (psi 0) - Complex.normSq (psi 1)
  ]

/-- Total visible null energy of a finite complex spinor bundle. -/
def bundleEnergy {n : Nat} (psi : Fin n -> CSpinor) : Real :=
  Finset.univ.sum fun i : Fin n => spinorEnergy (psi i)

/-- Closure / total spatial momentum vector of a finite spinor bundle. -/
def bundleClosure {n : Nat} (psi : Fin n -> CSpinor) : Vec3 :=
  fun k : Fin 3 => Finset.univ.sum fun i : Fin n => blochVector (psi i) k

/-- Moment-map mass square of a finite complex spinor bundle. -/
def bundleMomentMassSq {n : Nat} (psi : Fin n -> CSpinor) : Real :=
  (bundleEnergy psi ^ 2 - normSq (bundleClosure psi)) / 4

/-
A single spinor's Bloch vector has squared norm equal to energy squared.
-/
theorem bloch_normSq_eq_energy_sq (psi : CSpinor) :
    normSq (blochVector psi) = spinorEnergy psi ^ 2 := by
  unfold normSq spinorEnergy blochVector dot;
  norm_num [ Fin.sum_univ_succ ] ; ring;
  simpa only [ Complex.normSq_apply ] using by ring;

/-
Two-spinor bridge: the squared Pluecker bracket equals half the deficit between
the product of energies and the Bloch-vector dot product.
-/
theorem wedge_normSq_eq_energy_dot_defect (psi phi : CSpinor) :
    Complex.normSq (spinorWedge psi phi)
      = (spinorEnergy psi * spinorEnergy phi - dot (blochVector psi) (blochVector phi)) / 2 := by
  unfold spinorWedge spinorEnergy blochVector dot;
  norm_num [ Complex.normSq, Fin.sum_univ_succ ] ; ring

/-
Bundle bridge: the real pairwise Pluecker mass equals the celestial
moment-map mass square `(E^2 - |C|^2) / 4`.
-/
theorem finPairwisePluckerMassReal_eq_bundleMomentMassSq {n : Nat}
    (psi : Fin n -> CSpinor) :
    finPairwisePluckerMassReal psi = bundleMomentMassSq psi := by
  unfold finPairwisePluckerMassReal bundleMomentMassSq;
  -- By definition of $g$, we know that $g i i = 0$ for all $i$.
  have hg_diag : ∀ i : Fin n, (spinorEnergy (psi i) * spinorEnergy (psi i) - dot (blochVector (psi i)) (blochVector (psi i))) = 0 := by
    exact fun i => sub_eq_zero_of_eq <| by simpa [ ← sq ] using bloch_normSq_eq_energy_sq ( psi i ) ▸ rfl;
  have h_sum_g : ∑ i : Fin n, ∑ j : Fin n, (spinorEnergy (psi i) * spinorEnergy (psi j) - dot (blochVector (psi i)) (blochVector (psi j))) = 2 * ∑ p ∈ finPairIndexSet n, (spinorEnergy (psi p.1) * spinorEnergy (psi p.2) - dot (blochVector (psi p.1)) (blochVector (psi p.2))) := by
    have := @sum_pairs_offdiag;
    convert congr_arg Complex.re ( this ( fun i j => ( spinorEnergy ( psi i ) * spinorEnergy ( psi j ) - dot ( blochVector ( psi i ) ) ( blochVector ( psi j ) ) : ℂ ) ) ( fun i => by simpa [ Complex.ext_iff ] using hg_diag i ) ) using 1 <;> norm_num [ Complex.ext_iff, Finset.sum_add_distrib, two_mul ];
    simp +decide only [dot, mul_comm];
  convert congr_arg ( · / 4 ) h_sum_g.symm using 1;
  · rw [ Finset.mul_sum _ _ _ ];
    rw [ Finset.sum_div _ _ _ ] ; congr ; ext ; rw [ wedge_normSq_eq_energy_dot_defect ] ; ring;
  · unfold bundleEnergy normSq bundleClosure dot; simp +decide [ Finset.sum_sub_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_comm, sq ] ;
    exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm )

/--
Trusted determinant bridge: the real part of the determinant of the trusted
finite bundle momentum equals the celestial moment-map mass square.
-/
theorem finBundleMomentum_det_re_eq_bundleMomentMassSq {n : Nat}
    (psi : Fin n -> CSpinor) :
    ((finBundleMomentum psi).det).re = bundleMomentMassSq psi := by
  rw [fin_bundle_det_eq_ofReal_pluckerMassReal]
  exact finPairwisePluckerMassReal_eq_bundleMomentMassSq psi

end PhysicsSM.Draft.NullEdgePluckerCelestialBridge

end
