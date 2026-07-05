import PhysicsSM.Draft.NullEdge.GateYM.CyclicityPrereq
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorZ2

/-!
# Gate YM4/Q9: finite gap assembly hypothesis package

This draft module packages the honest inputs that a later finite strong-coupling
gap assembly must expose:

* the Q9 local-algebra cyclicity prerequisite on the candidate sector;
* sector preservation and vacuum membership, already bundled in that
  prerequisite;
* the strict ordered-eigenvalue data for the local/glueball excitation inside
  the trivial-flux sector.

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

The `cyclicity` field is the named local-algebra cyclicity prerequisite, while
the two real numbers are the leading vacuum-sector transfer eigenvalue and the
first local/glueball eigenvalue after all sector restrictions have already been
made. -/
structure FiniteGapPrereq (H : Type*) [AddCommGroup H] [Module ℂ H] where
  /-- The exposed Q9 cyclicity/sector-preservation package. -/
  cyclicity : LocalCyclicityPrereq H
  /-- Leading eigenvalue in the selected vacuum/trivial-flux sector. -/
  lambda0 : ℝ
  /-- First local/glueball eigenvalue in the same sector. -/
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

end FiniteGapPrereq

end FiniteGapAssembly
end GateYM
end NullEdge
end Draft
end PhysicsSM
