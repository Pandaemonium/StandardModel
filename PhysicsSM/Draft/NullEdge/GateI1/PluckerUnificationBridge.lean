import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Spinor.PluckerMass

/-!
# Bridge B0: null-edge Minkowski mass = octonion-lane spinor Plucker mass

The first kernel-checked stitch between the two programs of this repository (see
`AgentTasks/octonion-nulledge-unification-thesis.md`):

- the **null-edge** side (`GateI1/Core`): `minkHerm p : Herm2` with
  `det (minkHerm p) = minkowskiSq p` (I1.1 soldering); the mass is the
  Minkowski square of a real four-momentum;
- the **octonion/spinor** side (`Spinor.PluckerMass`, trusted): a two-null-edge
  momentum `twoEdgeMomentum psi phi = psi psi^dag + phi phi^dag` with
  `det (twoEdgeMomentum psi phi) = complexAbsSq (spinorWedge psi phi)`; the mass
  is the Plucker (wedge) obstruction of two complex Weyl spinors.

Both are Hermitian `2 x 2` blocks whose determinant IS the mass squared. This
module shows they are the SAME mass: every Hermitian `2 x 2` block is
`minkHerm p` for the real momentum `p = momentumOfHerm2 H` extracted from its
entries, so a two-null-edge SPINOR momentum has a well-defined null-edge
Minkowski mass, and that mass EQUALS the spinor Plucker mass.

`GateI1/Core` already names `Spinor.PluckerMass` as its source spinor-helicity
algebra; this module makes the identification an equation, and shows the two
programs' "massless iff collinear" characterizations coincide.

## Claim discipline

Claim label: **finite identity** (a determinant identity between two Hermitian
`2 x 2` parametrizations; no analysis, no continuum). Draft-trust,
kernel-checked, `s o r r y`-free. Prerequisites: `GateI1.Core` (null-edge) and
the trusted `Spinor.PluckerMass` (octonion/spinor side). This is bridge B0 of
the octonion/null-edge unification; B1 (shared Clifford module), B2
(chirality <-> conjugate ideal), B3 (confinement <-> color) remain.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace PluckerUnificationBridge

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Spinor

/-- The real four-momentum extracted from a Hermitian `2 x 2` block:
`p0 = (H00 + H11)/2`, `px = re H01`, `py = -im H01`, `pz = (H00 - H11)/2`. This
is the inverse of the Pauli soldering `minkHerm` on Hermitian matrices. -/
noncomputable def momentumOfHerm2 (H : Herm2) : Momentum4 :=
  ![((H 0 0).re + (H 1 1).re) / 2, (H 0 1).re, -(H 0 1).im, ((H 0 0).re - (H 1 1).re) / 2]

/-- **Soldering roundtrip**: on a Hermitian block, `minkHerm` recovers the block
from its extracted momentum (`minkHerm (momentumOfHerm2 H) = H`). Uses that a
Hermitian `2 x 2` has real diagonal and conjugate off-diagonal entries. -/
theorem minkHerm_momentumOfHerm2 (H : Herm2) (hH : H.IsHermitian) :
    minkHerm (momentumOfHerm2 H) = H := by
  have h00 : (H 0 0).im = 0 := by
    have h : (starRingEnd ℂ) (H 0 0) = H 0 0 := hH.apply 0 0
    rwa [Complex.conj_eq_iff_im] at h
  have h11 : (H 1 1).im = 0 := by
    have h : (starRingEnd ℂ) (H 1 1) = H 1 1 := hH.apply 1 1
    rwa [Complex.conj_eq_iff_im] at h
  have h10 : H 1 0 = (starRingEnd ℂ) (H 0 1) := (hH.apply 1 0).symm
  have h10re : (H 1 0).re = (H 0 1).re := by rw [h10]; simp
  have h10im : (H 1 0).im = -(H 0 1).im := by rw [h10]; simp
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [minkHerm, momentumOfHerm2, Complex.ext_iff, h00, h11, h10re, h10im] <;> ring

/-- The two-null-edge spinor momentum `psi psi^dag + phi phi^dag` is Hermitian. -/
theorem twoEdgeMomentum_isHermitian (psi phi : Fin 2 → ℂ) :
    (PluckerMass.twoEdgeMomentum psi phi).IsHermitian := by
  unfold Matrix.IsHermitian
  ext i j
  simp only [Matrix.conjTranspose_apply, PluckerMass.twoEdgeMomentum,
    PluckerMass.rankOneHermitian, Matrix.add_apply, Matrix.vecMulVec_apply,
    Pi.star_apply, star_add, star_mul', star_star]
  ring

/-- **BRIDGE B0 (headline)**: the null-edge Minkowski mass of a two-null-edge
spinor momentum EQUALS the octonion-lane spinor Plucker mass. The same mass, in
two languages: `minkowskiSq` of the soldered momentum on the null-edge side, and
`|spinorWedge|^2` on the octonion/spinor side. -/
theorem nullEdge_mass_eq_spinor_plucker (psi phi : Fin 2 → ℂ) :
    (minkowskiSq (momentumOfHerm2 (PluckerMass.twoEdgeMomentum psi phi)) : ℂ)
      = PluckerMass.complexAbsSq (PluckerMass.spinorWedge psi phi) := by
  rw [← det_minkHerm_eq_minkowskiSq,
    minkHerm_momentumOfHerm2 _ (twoEdgeMomentum_isHermitian psi phi),
    PluckerMass.two_edge_plucker_mass_identity]

/-- **BRIDGE B0 (masslessness)**: the two programs' masslessness criteria
coincide - the null-edge Minkowski mass vanishes exactly when the spinor Plucker
wedge vanishes (the octonion-lane collinearity condition). This identifies
NE-U1's "massless iff collinear" with `Spinor.PluckerMass`'s. -/
theorem nullEdge_massless_iff_wedge_zero (psi phi : Fin 2 → ℂ) :
    minkowskiSq (momentumOfHerm2 (PluckerMass.twoEdgeMomentum psi phi)) = 0
      ↔ PluckerMass.spinorWedge psi phi = 0 := by
  rw [← PluckerMass.complexAbsSq_eq_zero_iff, ← nullEdge_mass_eq_spinor_plucker]
  exact_mod_cast Iff.rfl

end PluckerUnificationBridge
end PhysicsSM.Draft.NullEdge.GateI1
