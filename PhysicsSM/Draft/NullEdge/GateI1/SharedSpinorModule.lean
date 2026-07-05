import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Algebra.Octonion.ComplexOctonion

/-!
# Bridge B1(ii): the shared spinor module (two commuting structures)

A first formalization of bridge B1(ii) of the octonion / null-edge unification
(`AgentTasks/octonion-nulledge-unification-thesis.md`): the "one spinor, two
structures" thesis, made precise as a tensor-product module carrying two
COMMUTING actions.

The unification's central structural claim (thesis section 1) is the
**spacetime (x) internal factorization**: the physical spinor is
`(internal ideal) (x) (spacetime Weyl spinor)`, with the internal
division-algebra structure (charges, `Cl(6)` on the complex-octonion ideal)
acting on the internal factor and the spacetime structure (mass/propagation,
the Pauli/soldering on the Weyl factor) acting on the spacetime factor. Because
the two act on DIFFERENT tensor factors, they commute - the two structures are
independent, exactly as "spacetime (x) internal" requires.

Here:

- `SharedSpinorModule := ComplexOctonion (x)[ℂ] CSpinor` - the shared module,
  internal complex-octonion factor tensor spacetime Weyl (`CSpinor = Fin 2 → ℂ`)
  factor;
- `internal_spacetime_commute` - ANY internal endomorphism (lifted to the
  octonion factor) commutes with ANY spacetime endomorphism (lifted to the Weyl
  factor). Instantiating `internal` with a `Cl(6)` ladder operator and
  `spacetime` with a Pauli/soldering operator gives the physical statement:
  the charge structure and the mass structure act independently on the one
  spinor.

## Claim discipline

Claim label: **finite identity / program synthesis**. This formalizes the
STRUCTURAL factorization (two commuting tensor-factor actions); it is NOT the
full physical identification of the specific `Cl(6)` and spacetime Clifford
representations, nor the compatibility of the charges with the null-edge mass
dynamics - those remain the deeper open part of B1. The commutativity is the
honest content of "spacetime (x) internal", not more. Draft-trust,
kernel-checked, `s o r r y`-free. Prerequisites: `GateI1.Core` (`CSpinor`),
`Octonion.ComplexOctonion`.
-/

open scoped TensorProduct

namespace PhysicsSM.Draft.NullEdge.GateI1.SharedSpinorModule

open PhysicsSM.Draft.NullEdge.GateI1

/-- The internal complex-octonion module (the charge/ideal factor). -/
abbrev Internal := PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion

/-- The spacetime Weyl-spinor module (the mass/propagation factor);
`CSpinor = Fin 2 → ℂ`. -/
abbrev Spacetime := CSpinor

/-- **The shared spinor module**: internal (complex-octonion ideal) factor
tensor spacetime (Weyl spinor) factor, over `ℂ`. -/
noncomputable abbrev SharedSpinorModule := Internal ⊗[ℂ] Spacetime

/-- Lift an internal endomorphism (e.g. a `Cl(6)` ladder operator) to the shared
module, acting on the internal factor only. -/
noncomputable def internalAction (f : Module.End ℂ Internal) :
    Module.End ℂ SharedSpinorModule :=
  f.rTensor Spacetime

/-- Lift a spacetime endomorphism (e.g. a Pauli/soldering operator) to the shared
module, acting on the spacetime factor only. -/
noncomputable def spacetimeAction (g : Module.End ℂ Spacetime) :
    Module.End ℂ SharedSpinorModule :=
  g.lTensor Internal

/-- **B1(ii): the two structures commute.** The internal (charge) structure and
the spacetime (mass) structure act independently on the shared spinor module:
lifted to different tensor factors, they commute. This is the "one spinor, two
commuting structures" thesis - `spacetime (x) internal` - made precise.
Instantiate `internal` with a `Cl(6)` ladder operator and `spacetime` with a
Pauli/soldering operator for the physical reading. -/
theorem internal_spacetime_commute
    (internal : Module.End ℂ Internal) (spacetime : Module.End ℂ Spacetime) :
    internalAction internal ∘ₗ spacetimeAction spacetime
      = spacetimeAction spacetime ∘ₗ internalAction internal := by
  ext m n
  simp [internalAction, spacetimeAction, LinearMap.rTensor, LinearMap.lTensor,
    TensorProduct.map_tmul]

end PhysicsSM.Draft.NullEdge.GateI1.SharedSpinorModule
