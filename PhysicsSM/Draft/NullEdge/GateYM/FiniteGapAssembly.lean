import PhysicsSM.Draft.NullEdge.GateYM.CyclicityPrereq
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorZ2

/-!
# Gate YM4/Q9: finite gap assembly hypothesis package

This draft module packages the honest inputs that a later finite strong-coupling
gap assembly must expose:

* the Q9 local-algebra cyclicity prerequisite on the candidate sector;
* sector preservation and vacuum membership, already bundled in that
  prerequisite;
* the strict ordered spectral parameters for the local/glueball excitation
  inside the trivial-flux sector;
* an optional successor witness package tying those parameters to actual
  eigenvector equations for a sector-preserving transfer endomorphism.

It deliberately proves only the elementary consequence already supported by
`TransferGapDefinition`: strict spectral separation gives a positive value of
the named `FluxSectorZ2.localGlueballGap`.  It constructs no transfer matrix,
Hamiltonian, Wilson slab kernel, infinite-volume state, or physical mass-gap
theorem.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: finite hypothesis packaging / Q9 doorstep.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FiniteGapAssembly

open CyclicityPrereq

variable {H : Type*} [AddCommGroup H] [Module ℂ H]

/-- The finite algebraic package needed before a Q9 gap assembly can honestly
talk about the local/glueball gap.

The `cyclicity` field is the named local-algebra cyclicity prerequisite.  The
two real numbers are named spectral parameters that a later assembly must
instantiate from an actual transfer spectrum; this base package alone does not
prove they are eigenvalues of an operator on the sector. -/
structure FiniteGapPrereq (H : Type*) [AddCommGroup H] [Module ℂ H] where
  /-- The exposed Q9 cyclicity/sector-preservation package. -/
  cyclicity : LocalCyclicityPrereq H
  /-- Named leading spectral parameter for the selected vacuum/trivial-flux
  sector; a later witness must prove it is an actual eigenvalue. -/
  lambda0 : ℝ
  /-- Named first local/glueball spectral parameter in the same sector; a
  later witness must prove it is an actual eigenvalue. -/
  lambdaLocal : ℝ
  /-- Positivity of the leading eigenvalue. -/
  lambda0_pos : 0 < lambda0
  /-- Positivity of the first local/glueball eigenvalue. -/
  lambdaLocal_pos : 0 < lambdaLocal
  /-- Strict local/glueball spectral separation from the vacuum. -/
  lambdaLocal_lt_lambda0 : lambdaLocal < lambda0

namespace FiniteGapPrereq

/-- The local operator algebra from the bundled Q9 cyclicity package. -/
abbrev localAlgebra (P : FiniteGapPrereq H) :
    Subalgebra ℂ (Module.End ℂ H) :=
  P.cyclicity.localAlgebra

/-- The vacuum vector from the bundled Q9 cyclicity package. -/
abbrev vacuum (P : FiniteGapPrereq H) : H :=
  P.cyclicity.vacuum

/-- The candidate local/trivial-flux sector from the bundled Q9 cyclicity
package. -/
abbrev sector (P : FiniteGapPrereq H) : Submodule ℂ H :=
  P.cyclicity.sector

/-- The named finite local/glueball gap associated to the spectral data in a
Q9 prerequisite package. -/
def localGap (P : FiniteGapPrereq H) : ℝ :=
  FluxSectorZ2.localGlueballGap P.lambda0 P.lambdaLocal

/-- The local/glueball spectral ratio in the selected sector. -/
def localSpectralRatio (P : FiniteGapPrereq H) : ℝ :=
  P.lambdaLocal / P.lambda0

/-- The packaged local gap is exactly the D12 finite spectral-ratio convention
with the local/glueball eigenvalue, not the winding-flux gap. -/
theorem localGap_eq_finiteMassGap (P : FiniteGapPrereq H) :
    P.localGap =
      TransferGapDefinition.finiteMassGap P.lambda0 P.lambdaLocal := by
  simpa [localGap] using
    FluxSectorZ2.localGlueballGap_eq_finiteMassGap P.lambda0 P.lambdaLocal

/-- The packaged local gap is the negative logarithm of the named local
spectral ratio. -/
theorem localGap_eq_neg_log_localSpectralRatio (P : FiniteGapPrereq H) :
    P.localGap = -Real.log P.localSpectralRatio := by
  rw [localGap_eq_finiteMassGap]
  rfl

/-- The local/glueball spectral ratio is positive under the packaged
eigenvalue hypotheses. -/
theorem localSpectralRatio_pos (P : FiniteGapPrereq H) :
    0 < P.localSpectralRatio := by
  exact div_pos P.lambdaLocal_pos P.lambda0_pos

/-- The local/glueball spectral ratio is strictly below one under the packaged
strict spectral separation hypothesis. -/
theorem localSpectralRatio_lt_one (P : FiniteGapPrereq H) :
    P.localSpectralRatio < 1 := by
  unfold localSpectralRatio
  have hratio :
      P.lambdaLocal / P.lambda0 < P.lambda0 / P.lambda0 :=
    div_lt_div_of_pos_right P.lambdaLocal_lt_lambda0 P.lambda0_pos
  simpa [div_self P.lambda0_pos.ne'] using hratio

/-- The packaged spectral ratio lies in the open interval `(0, 1)`. -/
theorem localSpectralRatio_mem_Ioo (P : FiniteGapPrereq H) :
    P.localSpectralRatio ∈ Set.Ioo (0 : ℝ) 1 :=
  ⟨P.localSpectralRatio_pos, P.localSpectralRatio_lt_one⟩

/-- Exponentiating the negative packaged gap recovers the local/glueball
spectral ratio. -/
theorem exp_neg_localGap_eq_localSpectralRatio (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) = P.localSpectralRatio := by
  rw [localGap_eq_neg_log_localSpectralRatio]
  rw [neg_neg, Real.exp_log P.localSpectralRatio_pos]

/-- The contraction factor `exp (-gap)` is positive. -/
theorem exp_neg_localGap_pos (P : FiniteGapPrereq H) :
    0 < Real.exp (-P.localGap) := by
  rw [exp_neg_localGap_eq_localSpectralRatio]
  exact P.localSpectralRatio_pos

/-- The contraction factor `exp (-gap)` is strictly below one. -/
theorem exp_neg_localGap_lt_one (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) < 1 := by
  rw [exp_neg_localGap_eq_localSpectralRatio]
  exact P.localSpectralRatio_lt_one

/-- The contraction factor `exp (-gap)` lies in the open interval `(0, 1)`. -/
theorem exp_neg_localGap_mem_Ioo (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) ∈ Set.Ioo (0 : ℝ) 1 :=
  ⟨P.exp_neg_localGap_pos, P.exp_neg_localGap_lt_one⟩

/-- The contraction factor `exp (-gap)` is nonzero. -/
theorem exp_neg_localGap_ne_zero (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) ≠ 0 :=
  ne_of_gt P.exp_neg_localGap_pos

/-- The contraction factor `exp (-gap)` is not one. -/
theorem exp_neg_localGap_ne_one (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) ≠ 1 :=
  ne_of_lt P.exp_neg_localGap_lt_one

/-- Direct eigenvalue-ratio form of the contraction-factor identity. -/
theorem exp_neg_localGap_eq_lambdaLocal_div_lambda0 (P : FiniteGapPrereq H) :
    Real.exp (-P.localGap) = P.lambdaLocal / P.lambda0 := by
  rw [exp_neg_localGap_eq_localSpectralRatio]
  rfl

/-- Multiplicative recovery of the local eigenvalue from the vacuum eigenvalue
and the contraction factor. -/
theorem lambda0_mul_exp_neg_localGap_eq_lambdaLocal (P : FiniteGapPrereq H) :
    P.lambda0 * Real.exp (-P.localGap) = P.lambdaLocal := by
  rw [exp_neg_localGap_eq_lambdaLocal_div_lambda0]
  field_simp [P.lambda0_pos.ne']

/-- Exponentiating the packaged gap gives the inverse local/glueball spectral
ratio. -/
theorem exp_localGap_eq_inv_localSpectralRatio (P : FiniteGapPrereq H) :
    Real.exp P.localGap = (P.localSpectralRatio)⁻¹ := by
  rw [localGap_eq_neg_log_localSpectralRatio]
  rw [Real.exp_neg, Real.exp_log P.localSpectralRatio_pos]

/-- The exponential of the packaged local/glueball gap is the vacuum/local
eigenvalue ratio. -/
theorem exp_localGap_eq_lambda0_div_lambdaLocal (P : FiniteGapPrereq H) :
    Real.exp P.localGap = P.lambda0 / P.lambdaLocal := by
  rw [exp_localGap_eq_inv_localSpectralRatio]
  unfold localSpectralRatio
  field_simp [P.lambda0_pos.ne', P.lambdaLocal_pos.ne']

/-- The vacuum/local inverse spectral ratio is positive. -/
theorem lambda0_div_lambdaLocal_pos (P : FiniteGapPrereq H) :
    0 < P.lambda0 / P.lambdaLocal := by
  exact div_pos P.lambda0_pos P.lambdaLocal_pos

/-- The strict ordered-eigenvalue hypothesis makes the vacuum/local inverse
spectral ratio strictly greater than one. -/
theorem one_lt_lambda0_div_lambdaLocal (P : FiniteGapPrereq H) :
    1 < P.lambda0 / P.lambdaLocal := by
  have hratio :
      P.lambdaLocal / P.lambdaLocal < P.lambda0 / P.lambdaLocal :=
    div_lt_div_of_pos_right P.lambdaLocal_lt_lambda0 P.lambdaLocal_pos
  simpa [div_self P.lambdaLocal_pos.ne'] using hratio

/-- The packaged local/glueball gap is the logarithm of the inverse
vacuum/local spectral ratio. -/
theorem localGap_eq_log_lambda0_div_lambdaLocal (P : FiniteGapPrereq H) :
    P.localGap = Real.log (P.lambda0 / P.lambdaLocal) := by
  have hlog := congrArg Real.log (exp_localGap_eq_lambda0_div_lambdaLocal P)
  simpa [Real.log_exp] using hlog

/-- Equivalently, the logarithm of the inverse eigenvalue ratio is the packaged
local/glueball gap. -/
theorem log_lambda0_div_lambdaLocal_eq_localGap (P : FiniteGapPrereq H) :
    Real.log (P.lambda0 / P.lambdaLocal) = P.localGap :=
  (localGap_eq_log_lambda0_div_lambdaLocal P).symm

/-- The negative packaged gap is the logarithm of the local spectral ratio. -/
theorem neg_localGap_eq_log_localSpectralRatio (P : FiniteGapPrereq H) :
    -P.localGap = Real.log P.localSpectralRatio := by
  rw [localGap_eq_neg_log_localSpectralRatio]
  ring

/-- The local spectral-ratio logarithm is strictly negative. -/
theorem log_localSpectralRatio_lt_zero (P : FiniteGapPrereq H) :
    Real.log P.localSpectralRatio < 0 := by
  exact (Real.log_neg_iff P.localSpectralRatio_pos).2
    P.localSpectralRatio_lt_one

/-- The local/glueball spectral ratio is nonzero. -/
theorem localSpectralRatio_ne_zero (P : FiniteGapPrereq H) :
    P.localSpectralRatio ≠ 0 :=
  ne_of_gt P.localSpectralRatio_pos

/-- The strict spectral separation hypothesis keeps the local/glueball
spectral ratio away from one. -/
theorem localSpectralRatio_ne_one (P : FiniteGapPrereq H) :
    P.localSpectralRatio ≠ 1 :=
  ne_of_lt P.localSpectralRatio_lt_one

/-- The vacuum/local inverse spectral ratio is nonzero. -/
theorem lambda0_div_lambdaLocal_ne_zero (P : FiniteGapPrereq H) :
    P.lambda0 / P.lambdaLocal ≠ 0 :=
  ne_of_gt P.lambda0_div_lambdaLocal_pos

/-- The strict spectral separation hypothesis keeps the inverse spectral ratio
away from one. -/
theorem lambda0_div_lambdaLocal_ne_one (P : FiniteGapPrereq H) :
    P.lambda0 / P.lambdaLocal ≠ 1 :=
  ne_of_gt P.one_lt_lambda0_div_lambdaLocal

/-- The local and vacuum eigenvalue slots are not equal in the local/vacuum
order. -/
theorem lambdaLocal_ne_lambda0 (P : FiniteGapPrereq H) :
    P.lambdaLocal ≠ P.lambda0 :=
  ne_of_lt P.lambdaLocal_lt_lambda0

/-- The vacuum and local eigenvalue slots are not equal in the vacuum/local
order. -/
theorem lambda0_ne_lambdaLocal (P : FiniteGapPrereq H) :
    P.lambda0 ≠ P.lambdaLocal :=
  ne_of_gt P.lambdaLocal_lt_lambda0

/-- The exponential rate attached to the packaged gap is positive. -/
theorem exp_localGap_pos (P : FiniteGapPrereq H) :
    0 < Real.exp P.localGap :=
  Real.exp_pos _

/-- A positive packaged gap exponentiates to a rate strictly greater than one. -/
theorem one_lt_exp_localGap (P : FiniteGapPrereq H) :
    1 < Real.exp P.localGap := by
  have hgap : 0 < P.localGap := by
    simpa [localGap] using
      FluxSectorZ2.localGlueballGap_pos
        P.lambda0_pos P.lambdaLocal_pos P.lambdaLocal_lt_lambda0
  exact Real.one_lt_exp_iff.mpr hgap

/-- Multiplicative, division-free form of the inverse-ratio identity. -/
theorem localSpectralRatio_mul_exp_localGap_eq_one (P : FiniteGapPrereq H) :
    P.localSpectralRatio * Real.exp P.localGap = 1 := by
  rw [exp_localGap_eq_inv_localSpectralRatio]
  field_simp [P.localSpectralRatio_pos.ne']

/-- Multiplicative recovery of the vacuum eigenvalue from the local eigenvalue
and the packaged gap rate. -/
theorem lambdaLocal_mul_exp_localGap_eq_lambda0 (P : FiniteGapPrereq H) :
    P.lambdaLocal * Real.exp P.localGap = P.lambda0 := by
  rw [exp_localGap_eq_lambda0_div_lambdaLocal]
  field_simp [P.lambdaLocal_pos.ne']

/-- The bundled Q9 prerequisite still exposes vacuum membership in the chosen
sector. -/
theorem vacuum_mem_sector (P : FiniteGapPrereq H) :
    P.vacuum ∈ P.sector :=
  P.cyclicity.vacuum_mem

/-- The bundled Q9 prerequisite exposes preservation of the chosen sector by
the local operator algebra. -/
theorem local_preserves_sector (P : FiniteGapPrereq H) :
    PreservesSubmodule P.localAlgebra P.sector :=
  P.cyclicity.local_preserves_sector

/-- The easy cyclicity inclusion extracted from the bundled prerequisite. -/
theorem cyclicSubmodule_le_sector (P : FiniteGapPrereq H) :
    cyclicSubmodule P.localAlgebra P.vacuum ≤ P.sector :=
  cyclicSubmodule_le_sector_of_prereq P.cyclicity

/-- The hard cyclicity inclusion extracted from the bundled prerequisite. -/
theorem sector_le_cyclicSubmodule (P : FiniteGapPrereq H) :
    P.sector ≤ cyclicSubmodule P.localAlgebra P.vacuum :=
  sector_le_cyclicSubmodule_of_prereq P.cyclicity

/-- The bundled Q9 prerequisite gives exact local-algebra cyclicity on the
candidate sector. -/
theorem localAlgebraCyclicInSector (P : FiniteGapPrereq H) :
    LocalAlgebraCyclicInSector P.localAlgebra P.vacuum P.sector :=
  P.cyclicity.cyclic

/-- Strict spectral separation in the packaged hypotheses gives a nonnegative
local/glueball gap. -/
theorem localGap_nonneg (P : FiniteGapPrereq H) : 0 ≤ P.localGap :=
  by
    simpa [localGap] using
      FluxSectorZ2.localGlueballGap_nonneg
        P.lambda0_pos P.lambdaLocal_pos P.lambdaLocal_lt_lambda0.le

/-- Strict spectral separation in the packaged hypotheses gives a positive
local/glueball gap, using only the finite spectral-ratio definition. -/
theorem localGap_pos (P : FiniteGapPrereq H) : 0 < P.localGap :=
  by
    simpa [localGap] using
      FluxSectorZ2.localGlueballGap_pos
        P.lambda0_pos P.lambdaLocal_pos P.lambdaLocal_lt_lambda0

/-- The packaged local/glueball gap is nonzero. -/
theorem localGap_ne_zero (P : FiniteGapPrereq H) :
    P.localGap ≠ 0 :=
  ne_of_gt P.localGap_pos

end FiniteGapPrereq

/-- Successor package closing the semantic gap between named spectral
parameters and an actual finite transfer operator.

This is still only a finite hypothesis package: the `transfer` field is an
input endomorphism, not a constructed Wilson slab kernel.  The point is that
any later use of `lambda0` and `lambdaLocal` as eigenvalues can pass through
explicit sector membership and eigenvector equations instead of relying on
docstring intent. -/
structure FiniteGapSpectralWitness (H : Type*) [AddCommGroup H] [Module ℂ H] where
  /-- The underlying cyclicity and ordered-parameter prerequisite. -/
  prereq : FiniteGapPrereq H
  /-- Candidate finite transfer endomorphism on the ambient space. -/
  transfer : Module.End ℂ H
  /-- The candidate transfer endomorphism preserves the selected sector. -/
  transfer_preserves_sector :
    ∀ v : H, v ∈ prereq.sector → transfer v ∈ prereq.sector
  /-- The packaged vacuum is nonzero. -/
  vacuum_ne_zero : prereq.vacuum ≠ 0
  /-- The vacuum satisfies the eigenvector equation for `lambda0`. -/
  vacuum_eigen :
    transfer prereq.vacuum = (prereq.lambda0 : ℂ) • prereq.vacuum
  /-- A named local/glueball excitation vector. -/
  localExcitation : H
  /-- The local/glueball excitation lies in the selected sector. -/
  localExcitation_mem_sector : localExcitation ∈ prereq.sector
  /-- The local/glueball excitation is nonzero. -/
  localExcitation_ne_zero : localExcitation ≠ 0
  /-- The local/glueball excitation is not the packaged vacuum vector. -/
  localExcitation_ne_vacuum : localExcitation ≠ prereq.vacuum
  /-- The local/glueball excitation satisfies the eigenvector equation for
  `lambdaLocal`. -/
  localExcitation_eigen :
    transfer localExcitation = (prereq.lambdaLocal : ℂ) • localExcitation

namespace FiniteGapSpectralWitness

/-- The local operator algebra from the underlying prerequisite. -/
abbrev localAlgebra (W : FiniteGapSpectralWitness H) :
    Subalgebra ℂ (Module.End ℂ H) :=
  W.prereq.localAlgebra

/-- The vacuum vector from the underlying prerequisite. -/
abbrev vacuum (W : FiniteGapSpectralWitness H) : H :=
  W.prereq.vacuum

/-- The selected sector from the underlying prerequisite. -/
abbrev sector (W : FiniteGapSpectralWitness H) : Submodule ℂ H :=
  W.prereq.sector

/-- The packaged finite local/glueball gap from the underlying prerequisite. -/
abbrev localGap (W : FiniteGapSpectralWitness H) : ℝ :=
  W.prereq.localGap

/-- The transfer image of the vacuum remains in the selected sector. -/
theorem transfer_vacuum_mem_sector (W : FiniteGapSpectralWitness H) :
    W.transfer W.vacuum ∈ W.sector :=
  W.transfer_preserves_sector W.vacuum W.prereq.vacuum_mem_sector

/-- The transfer image of the local/glueball excitation remains in the
selected sector. -/
theorem transfer_localExcitation_mem_sector (W : FiniteGapSpectralWitness H) :
    W.transfer W.localExcitation ∈ W.sector :=
  W.transfer_preserves_sector
    W.localExcitation W.localExcitation_mem_sector

/-- The witness exposes the vacuum eigenvector equation for the packaged
leading spectral parameter. -/
theorem vacuum_eigen_eq (W : FiniteGapSpectralWitness H) :
    W.transfer W.vacuum = (W.prereq.lambda0 : ℂ) • W.vacuum :=
  W.vacuum_eigen

/-- The witness exposes the local/glueball eigenvector equation for the
packaged local spectral parameter. -/
theorem localExcitation_eigen_eq (W : FiniteGapSpectralWitness H) :
    W.transfer W.localExcitation =
      (W.prereq.lambdaLocal : ℂ) • W.localExcitation :=
  W.localExcitation_eigen

/-- The strict ordered spectral parameters in the underlying prerequisite
still give a positive packaged local/glueball gap. -/
theorem localGap_pos (W : FiniteGapSpectralWitness H) :
    0 < W.localGap :=
  W.prereq.localGap_pos

/-- The witness inherits the contraction-factor identity from the underlying
finite spectral-ratio package. -/
theorem exp_neg_localGap_eq_lambdaLocal_div_lambda0
    (W : FiniteGapSpectralWitness H) :
    Real.exp (-W.localGap) = W.prereq.lambdaLocal / W.prereq.lambda0 :=
  W.prereq.exp_neg_localGap_eq_lambdaLocal_div_lambda0

end FiniteGapSpectralWitness

end FiniteGapAssembly
end GateYM
end NullEdge
end Draft
end PhysicsSM
