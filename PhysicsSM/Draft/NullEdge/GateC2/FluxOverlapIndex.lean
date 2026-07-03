import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexIntegrality

/-!
# Gate C2: a genuine nonzero-flux finite overlap index (the pi-flux triangle)

This module exhibits the SMALLEST genuinely-fluxed finite lattice gauge model
whose overlap chiral index is a nonzero integer, and proves it kernel-checked.
It instantiates the abstract gauge-overlap interface (`GaugeOverlapInterface`,
`OverlapIndexIntegrality`) with an EXPLICIT gapped Hermitian gauge-hopping
operator, so the "exhibit a gauge H_U with nonzero index" frontier item of Gate
C2 is now realized by a concrete witness rather than left open.

It uses the repo's own `overlapIndex` / `overlapIndex_eq` (from `OverlapIndexToy`)
and `SignCertificate` / `certifiedSign_unique` (from `OverlapSignCertificate`);
the concrete construction below was proved by Aristotle (job f3296d38) against a
copied stand-in prelude and here is rewired onto the trusted repo definitions.

## What is built here

* A TRIANGLE (the smallest Wilson loop / 3-cycle) with Z2 / pi-flux: three
  directed link variables `u01 = u12 = 1`, `u20 = -1`, whose loop holonomy is
  `u01 * u12 * u20 = -1`.  `plaquette_gauge_invariant` proves the holonomy is
  invariant under arbitrary site-phase gauge transforms, so this `-1` is a
  GENUINE gauge-invariant flux, not a gauge artifact.

* The Hermitian hopping operator `Mtri` carrying those link phases.  With pi-flux
  its spectrum is `{1, 1, -2}` (rational -- a special feature of the odd cycle
  with pi-flux), so `Mtri` is gapped (`Mtri_invertible`) and its sign is a
  RATIONAL matrix, avoiding surds entirely.

* Its certified sign `epsTri = (2/3) Mtri + (1/3) 1`.  `signCert_Mtri` proves the
  finite positivity certificate, so by `certifiedSign_unique`,
  `epsTri = sign(Mtri)` -- it is THE sign, not a constructed signature defect.

* A 2-component spin doubling (`Fin 3 x Fin 2`) hosting the traceless chirality
  `gamma5U = 1 (x) sigma3`.  The gauge operator is `HU = Mtri (x) 1`, its
  certified sign is `epsU = epsTri (x) 1`, and the OVERLAP INDEX is `-1`
  (`overlapIndex_flux`), a nonzero integer (`flux_is_nonzero_integer_witness`).

* Zero-flux comparison: with all links `+1` the spectrum is `{2, -1, -1}`, the
  certified sign has trace `-1`, and the overlap index is `+1`
  (`overlapIndex_noflux`).  Inserting one unit of pi-flux flips the index by `-2`
  (`flux_shifts_index`): the gauge-invariant holonomy demonstrably reaches the
  index.

## Honest scope

This is a genuine gauge index (certified sign of an explicit gapped operator, and
it changes with the holonomy).  Because an odd 3-cycle carries a nonzero index at
EVERY flux (a parity feature of odd loops), the sharp flux-driven statement is the
`Delta = -2` jump of the index under pi-flux insertion.  For an even plaquette
(2x2 / 4-cycle), pi-flux gaps the operator with a balanced spectrum `+-sqrt 2` and
the index collapses to `0`; a nonzero index on an even lattice needs a genuine 2D
Wilson-Dirac operator on a torus carrying net flux `2 pi` -- the documented next
size up.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity** (concrete nonzero-flux overlap index witness).
Prerequisites: `OverlapIndexToy`, `OverlapSignCertificate`,
`OverlapIndexIntegrality`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace FluxOverlapIndex

open Matrix
open scoped ComplexOrder Kronecker
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

/-! ## Genuine gauge flux: the holonomy is gauge-invariant

For directed link variables around a loop of length `k` in a commutative group,
the plaquette holonomy `∏ u i` is invariant under any site-phase gauge transform
`u i ↦ g i · u i · (g (i+1))⁻¹`.  Specialized to the triangle this shows the
`-1` π-flux cannot be gauged away. -/

/-
**Gauge invariance of the triangle holonomy.**  Under a site-phase gauge
transform `u₀₁ ↦ g₀ u₀₁ g₁⁻¹`, `u₁₂ ↦ g₁ u₁₂ g₂⁻¹`, `u₂₀ ↦ g₂ u₂₀ g₀⁻¹`, the
loop product is unchanged.  Hence the π-flux value `-1` is genuine.
-/
theorem plaquette_gauge_invariant (u₀₁ u₁₂ u₂₀ : ℂˣ) (g₀ g₁ g₂ : ℂˣ) :
    (g₀ * u₀₁ * g₁⁻¹) * (g₁ * u₁₂ * g₂⁻¹) * (g₂ * u₂₀ * g₀⁻¹)
      = u₀₁ * u₁₂ * u₂₀ := by
  simp +decide [ mul_assoc, mul_comm, mul_left_comm ]

/-! ## The triangle hopping operator (base space `Fin 3`) -/

/-- π-flux triangle hopping matrix: links `u₀₁ = u₁₂ = 1`, `u₂₀ = -1`
(holonomy `-1`).  Hermitian, spectrum `{1, 1, -2}`. -/
def Mtri : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, -1; 1, 0, 1; -1, 1, 0]

/-- zero-flux triangle hopping matrix: all links `+1` (holonomy `+1`).
Hermitian, spectrum `{2, -1, -1}`. -/
def Mtri0 : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 1; 1, 0, 1; 1, 1, 0]

/-- The rational certified sign of `Mtri`: `(2/3)·Mtri + (1/3)·1`. -/
def epsTri : Matrix (Fin 3) (Fin 3) ℂ := (2/3 : ℂ) • Mtri + (1/3 : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The rational certified sign of `Mtri0`: `(2/3)·Mtri0 - (1/3)·1`. -/
def epsTri0 : Matrix (Fin 3) (Fin 3) ℂ := (2/3 : ℂ) • Mtri0 - (1/3 : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The frustration vector `(1, -1, 1)` (kernel direction of `Mtri + 2`). -/
def colV : Matrix (Fin 3) (Fin 1) ℂ := !![1; -1; 1]

/-- The vector `(1, 1, 1)` (kernel direction of `Mtri0 - 2`). -/
def colW : Matrix (Fin 3) (Fin 1) ℂ := !![1; 1; 1]

theorem Mtri_herm : Mtri.IsHermitian := by
  ext i j;
  fin_cases i <;> fin_cases j <;> norm_num [ Mtri ]

theorem Mtri_sq : Mtri * Mtri = (2 : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) - Mtri := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Mtri ] ;

/-- Explicit inverse of `Mtri`: `(1/2)·(Mtri + 1)` (from `Mtri² + Mtri = 2`). -/
def MtriInv : Matrix (Fin 3) (Fin 3) ℂ := (1/2 : ℂ) • (Mtri + 1)

theorem MtriInv_mul : MtriInv * Mtri = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Mtri, MtriInv, Matrix.mul_apply, Fin.sum_univ_three ] ;
  all_goals repeat erw [ Matrix.cons_val_succ' ] ; norm_num;
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] ;

theorem Mtri_mul_Inv : Mtri * MtriInv = 1 := by
  convert ( mul_eq_one_comm.mp ( show MtriInv * Mtri = 1 from MtriInv_mul ) ) using 1

noncomputable instance Mtri_invertible : Invertible Mtri where
  invOf := MtriInv
  invOf_mul_self := MtriInv_mul
  mul_invOf_self := Mtri_mul_Inv

theorem epsTri_sq : epsTri * epsTri = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ epsTri, Mtri, Matrix.mul_apply, Fin.sum_univ_succ ] ; ring;
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] ;

theorem epsTri_comm : epsTri * Mtri = Mtri * epsTri := by
  unfold epsTri;
  -- Since matrix multiplication is associative and scalar multiplication commutes with matrix multiplication, we can rearrange the terms.
  simp [mul_add, add_mul, smul_mul_assoc, mul_smul_comm]

/-
The key positivity identity: `epsTri * Mtri = 1 + (1/3)·(v vᴴ) = |Mtri|`.
-/
theorem epsTri_mul_Mtri : epsTri * Mtri = 1 + (1/3 : ℂ) • (colV * colVᴴ) := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ epsTri, Mtri, colV, Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply ] ;
  all_goals simp +decide [ Matrix.vecMul, Matrix.mul_apply, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero, Fin.sum_univ_succ, Fin.sum_univ_zero ] at *;
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] at *;

theorem Mtri_trace : Mtri.trace = 0 := by
  unfold Mtri; norm_num [ Fin.sum_univ_succ, Matrix.trace ] ;

theorem epsTri_trace : epsTri.trace = 1 := by
  unfold epsTri; norm_num [ Matrix.trace ] ;
  norm_num [ Fin.sum_univ_succ, Mtri ]

/-
**Certified sign of the π-flux triangle.**
-/
theorem signCert_Mtri : SignCertificate Mtri epsTri := by
  constructor;
  · exact epsTri_sq;
  · grind +suggestions;
  · rw [ epsTri_mul_Mtri ];
    refine' Matrix.PosSemidef.add ( Matrix.PosSemidef.one ) _;
    convert Matrix.PosSemidef.smul ( Matrix.posSemidef_self_mul_conjTranspose colV ) ( show ( 0 : ℂ ) ≤ 1 / 3 by norm_num [ Complex.le_def ] ) using 1

/-- Any certified sign of `Mtri` is `epsTri`, so `epsTri = sign(Mtri)`. -/
theorem signCert_Mtri_unique (eps : Matrix (Fin 3) (Fin 3) ℂ)
    (hc : SignCertificate Mtri eps) : eps = epsTri :=
  certifiedSign_unique Mtri eps epsTri Mtri_herm hc signCert_Mtri

/-! ### zero-flux triangle certificate -/

theorem Mtri0_herm : Mtri0.IsHermitian := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Mtri0 ]

theorem Mtri0_sq : Mtri0 * Mtri0 = Mtri0 + (2 : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring;
  all_goals norm_num [ Mtri0 ] ;
  all_goals repeat erw [ Matrix.cons_val_succ' ] ; norm_num;

def Mtri0Inv : Matrix (Fin 3) (Fin 3) ℂ := (1/2 : ℂ) • (Mtri0 - 1)

theorem Mtri0Inv_mul : Mtri0Inv * Mtri0 = 1 := by
  unfold Mtri0Inv; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Mtri0, Matrix.mul_apply, Fin.sum_univ_succ ] ;
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] ;

theorem Mtri0_mul_Inv : Mtri0 * Mtri0Inv = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, Mtri0, Mtri0Inv ] ;
  · norm_num [ Fin.ext_iff, Matrix.one_apply ];
  · norm_num [ Fin.ext_iff, Matrix.one_apply ];
  · norm_num [ Fin.ext_iff, Matrix.one_apply ];
  · norm_num [ Fin.ext_iff, Matrix.one_apply ];
  · norm_num [ Matrix.one_apply ]

noncomputable instance Mtri0_invertible : Invertible Mtri0 where
  invOf := Mtri0Inv
  invOf_mul_self := Mtri0Inv_mul
  mul_invOf_self := Mtri0_mul_Inv

theorem epsTri0_sq : epsTri0 * epsTri0 = 1 := by
  unfold epsTri0;
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, Mtri0 ] ;
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] ;

theorem epsTri0_comm : epsTri0 * Mtri0 = Mtri0 * epsTri0 := by
  unfold epsTri0;
  simp +decide [ mul_sub, sub_mul, mul_smul_comm, smul_mul_assoc, mul_assoc ]

theorem epsTri0_mul_Mtri0 : epsTri0 * Mtri0 = 1 + (1/3 : ℂ) • (colW * colWᴴ) := by
  norm_num [ Mtri0, epsTri0, colW ];
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ];
  all_goals norm_num [ Matrix.vecMul, dotProduct ];
  all_goals norm_num [ Fin.ext_iff, Matrix.one_apply ] ;

theorem epsTri0_trace : epsTri0.trace = -1 := by
  unfold epsTri0; norm_num [ Matrix.trace ] ; ring;
  norm_num [ Fin.sum_univ_succ, Mtri0 ]

theorem signCert_Mtri0 : SignCertificate Mtri0 epsTri0 := by
  refine' ⟨ epsTri0_sq, epsTri0_comm, _ ⟩;
  convert Matrix.PosSemidef.add ( Matrix.PosSemidef.one ) ( Matrix.PosSemidef.smul ( Matrix.posSemidef_self_mul_conjTranspose colW ) ( show ( 0 : ℝ ) ≤ 1 / 3 by norm_num ) ) using 1 ; norm_num [ epsTri0_mul_Mtri0 ];
  ext i j; norm_num [ Complex.ext_iff, Matrix.mul_apply ] ;

/-! ## Spin doubling: the full gauge operator on `Fin 3 × Fin 2` -/

/-- Chirality `σ₃` on the 2-component spin. -/
def sigma3 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Traceless lattice chirality `γ₅ = 1 ⊗ σ₃`. -/
def gamma5U : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  (1 : Matrix (Fin 3) (Fin 3) ℂ) ⊗ₖ sigma3

/-- Gauge hopping operator `HU = Mtri ⊗ 1` (π-flux). -/
def HU : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  Mtri ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- Certified sign `epsU = epsTri ⊗ 1`. -/
def epsU : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  epsTri ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- zero-flux gauge hopping operator `HU0 = Mtri0 ⊗ 1`. -/
def HU0 : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  Mtri0 ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- Certified sign `epsU0 = epsTri0 ⊗ 1`. -/
def epsU0 : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  epsTri0 ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

theorem sigma3_sq : sigma3 * sigma3 = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sigma3 ]

theorem sigma3_trace : sigma3.trace = 0 := by
  norm_num [ sigma3, Matrix.trace ]

theorem gamma5U_sq : gamma5U * gamma5U = 1 := by
  convert congr_arg₂ ( fun x y => x ⊗ₖ y ) ( one_mul ( 1 : Matrix ( Fin 3 ) ( Fin 3 ) ℂ ) ) ( sigma3_sq ) using 1;
  · convert rfl;
    convert Matrix.mul_kronecker_mul _ _ _ _ using 1;
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide

theorem gamma5U_trace : gamma5U.trace = 0 := by
  convert Matrix.trace_kronecker ( 1 : Matrix ( Fin 3 ) ( Fin 3 ) ℂ ) sigma3;
  norm_num [ sigma3_trace ]

theorem HU_herm : HU.IsHermitian := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; norm_num [ HU, Mtri ] ; ring;
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;> norm_num [ Matrix.one_apply ]

/-- Inverse of `HU`: `MtriInv ⊗ 1`. -/
def HUInv : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  MtriInv ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

theorem HUInv_mul : HUInv * HU = 1 := by
  convert congr_arg ( fun x : Matrix ( Fin 3 ) ( Fin 3 ) ℂ => x ⊗ₖ ( 1 : Matrix ( Fin 2 ) ( Fin 2 ) ℂ ) ) ( show MtriInv * Mtri = 1 from MtriInv_mul ) using 1;
  · ext i j;
    simp +decide [ HUInv, HU, Matrix.mul_apply, kroneckerMap_apply ];
    simp +decide [ Matrix.one_apply, Finset.sum_mul ];
    split_ifs <;> simp_all +decide [ Finset.sum_ite ];
    fin_cases j <;> rfl;
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide

theorem HU_mul_Inv : HU * HUInv = 1 := by
  convert congr_arg ( fun x : Matrix ( Fin 3 ) ( Fin 3 ) ℂ => x ⊗ₖ ( 1 : Matrix ( Fin 2 ) ( Fin 2 ) ℂ ) ) ( show Mtri * MtriInv = 1 from Mtri_mul_Inv ) using 1;
  · unfold HU HUInv;
    rw [ ← Matrix.mul_kronecker_mul ];
    grind;
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide

noncomputable instance HU_invertible : Invertible HU where
  invOf := HUInv
  invOf_mul_self := HUInv_mul
  mul_invOf_self := HU_mul_Inv

/-
**Certified sign of the full π-flux gauge operator.**
-/
theorem signCert_HU : SignCertificate HU epsU := by
  -- Positivity identity: `epsU * HU = 1 + (1/3)·(C Cᴴ)` with `C = colV ⊗ 1`.
  have hpos : epsU * HU
      = 1 + (1/3 : ℂ) • ((colV ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ))
          * (colV ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ))ᴴ) := by
    rw [epsU, HU, ← Matrix.mul_kronecker_mul, mul_one, epsTri_mul_Mtri,
      Matrix.add_kronecker, Matrix.one_kronecker_one, Matrix.smul_kronecker,
      Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul,
      Matrix.conjTranspose_one, mul_one]
  refine ⟨?_, ?_, ?_⟩
  · -- involution
    rw [epsU, ← Matrix.mul_kronecker_mul, epsTri_sq, one_mul, Matrix.one_kronecker_one]
  · -- commutation
    rw [epsU, HU, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
      epsTri_comm, one_mul]
  · -- positivity
    rw [hpos]
    exact Matrix.PosSemidef.add Matrix.PosSemidef.one
      ((Matrix.posSemidef_self_mul_conjTranspose
        (colV ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ))).smul
        (show (0 : ℂ) ≤ 1 / 3 by norm_num [Complex.le_def]))

theorem signCert_HU_unique (eps : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ)
    (hc : SignCertificate HU eps) : eps = epsU :=
  certifiedSign_unique HU eps epsU HU_herm hc signCert_HU

theorem epsU_trace : epsU.trace = 2 := by
  convert Matrix.trace_kronecker ( epsTri : Matrix ( Fin 3 ) ( Fin 3 ) ℂ ) ( 1 : Matrix ( Fin 2 ) ( Fin 2 ) ℂ ) using 1;
  norm_num [ epsTri_trace, Matrix.trace_one ]

theorem epsU0_trace : epsU0.trace = -2 := by
  convert congr_arg₂ ( · * · ) ( epsTri0_trace : Matrix.trace epsTri0 = -1 ) ( show Matrix.trace ( 1 : Matrix ( Fin 2 ) ( Fin 2 ) ℂ ) = 2 by norm_num [ Matrix.trace ] ) using 1;
  · convert Matrix.trace_kronecker _ _;
  · norm_num

/-! ## The overlap index -/

/-- **Nonzero flux index.**  The overlap index of the π-flux gauge model is `-1`:
the trace of the *certified* `sign(HU)` against the traceless chirality `γ₅`. -/
theorem overlapIndex_flux : overlapIndex gamma5U epsU = -1 := by
  rw [overlapIndex_eq gamma5U epsU gamma5U_sq, gamma5U_trace, epsU_trace]; ring

/-- The zero-flux overlap index is `+1`. -/
theorem overlapIndex_noflux : overlapIndex gamma5U epsU0 = 1 := by
  rw [overlapIndex_eq gamma5U epsU0 gamma5U_sq, gamma5U_trace, epsU0_trace]; ring

/-- **The π-flux insertion shifts the overlap index by `-2`.**  Since the chirality
is traceless, the index equals `-(1/2)·Tr sign(H)`; the gauge-invariant holonomy
flip from `+1` to `-1` changes the certified signature and hence the index. -/
theorem flux_shifts_index : overlapIndex gamma5U epsU - overlapIndex gamma5U epsU0 = -2 := by
  rw [overlapIndex_flux, overlapIndex_noflux]; ring

/-- The flux index is genuinely nonzero. -/
theorem overlapIndex_flux_ne_zero : overlapIndex gamma5U epsU ≠ 0 := by
  rw [overlapIndex_flux]; norm_num

/-! ## Integration with the abstract gauge-overlap interface -/

/-- **The abstract gauge-overlap interface has a concrete nonzero witness.**  The
pi-flux triangle's overlap index is a nonzero integer: it satisfies the repo's
general integrality theorem (`OverlapIndexIntegrality.overlapIndex_isInteger`,
from `gamma5U * gamma5U = 1` and the certified-sign involution `epsU * epsU = 1`)
AND is provably nonzero (`overlapIndex_flux_ne_zero`, value `-1`).  So the Gate C2
frontier "exhibit a gauge operator whose overlap index is a nonzero integer" is
met by an explicit gapped Hermitian gauge-hopping operator. -/
theorem flux_is_nonzero_integer_witness :
    (∃ k : ℤ, overlapIndex gamma5U epsU = (k : ℂ)) ∧ overlapIndex gamma5U epsU ≠ 0 :=
  ⟨OverlapIndexIntegrality.overlapIndex_isInteger gamma5U epsU gamma5U_sq
      signCert_HU.involution,
    overlapIndex_flux_ne_zero⟩

end FluxOverlapIndex
end GateC2
end NullEdge
end Draft
end PhysicsSM
