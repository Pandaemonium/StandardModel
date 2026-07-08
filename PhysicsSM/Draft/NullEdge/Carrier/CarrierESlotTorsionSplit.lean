import PhysicsSM.Draft.NullEdge.Carrier.CarrierESlot

/-!
# E-slot torsion / soldering split

This module records the finite algebraic boundary between the carrier E-slot
defect in `CarrierESlot.lean` and a teleparallel/torsion reading of that defect.
It is pure finite noncommutative-ring algebra: no continuum limit, no
positivity, no spectrum, and no field-equation content.

The soldering-gradient E-slot is the contraction of the frame commutator

`D(e, f) = nabla_e * gamma_f - gamma_f * nabla_e`.

The commutator field is not hypothesis-free antisymmetric in `(e, f)`.  We
therefore split it into an antisymmetric torsion-like channel and a symmetric
soldering-difference channel:

* `eslotTorsion e f = D(e, f) - D(f, e)`,
* `eslotSolder e f = D(e, f) + D(f, e)`.

The characteristic-free identity below proves that the doubled E-slot is the
sum of these two contracted channels.  A pure-torsion interpretation therefore
requires the extra hypothesis that the symmetric soldering-difference
contraction vanishes.  The final theorem gives a concrete `2 x 2` matrix
witness showing that this extra hypothesis is not automatic.

Draft scope: the witness is closed by kernel-checked `decide` over integer
matrices, not by `n a t i v e _ d e c i d e`.  This is a finite algebraic
prototype only; geometric teleparallel language remains gated on a later
finite soldering-field/torsion-form definition with matching transformation
law.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {B E : Type*} [Ring B] [Fintype E]

/-- The frame commutator field
`D(e, f) = nabla e * gamma f - gamma f * nabla e`. -/
def eslotFrameComm (gamma nabla : E -> B) (e f : E) : B :=
  nabla e * gamma f - gamma f * nabla e

/-- Contract a two-index field against the soldering data. -/
def eslotContract (gamma nabla : E -> B) (K : E -> E -> B) : B :=
  ∑ e, ∑ f, gamma e * K e f * nabla f

/-- The banked E-slot defect, presented as the contraction of the frame
commutator field. -/
def eslotDefect (gamma nabla : E -> B) : B :=
  eslotContract gamma nabla (eslotFrameComm gamma nabla)

/-- `eslotDefect` unfolds to the E-term in `weitzenbock_master_varying`. -/
theorem eslotDefect_eq_weitzenbock_E (gamma nabla : E -> B) :
    (∑ e, ∑ f, gamma e * (nabla e * gamma f - gamma f * nabla e) * nabla f)
      = eslotDefect gamma nabla := rfl

/-- The torsion-like antisymmetric channel:
`T(e, f) = D(e, f) - D(f, e)`. -/
def eslotTorsion (gamma nabla : E -> B) (e f : E) : B :=
  eslotFrameComm gamma nabla e f - eslotFrameComm gamma nabla f e

/-- The symmetric soldering-difference channel:
`S(e, f) = D(e, f) + D(f, e)`. -/
def eslotSolder (gamma nabla : E -> B) (e f : E) : B :=
  eslotFrameComm gamma nabla e f + eslotFrameComm gamma nabla f e

/-- The E-slot torsion/soldering split:
`2 * E = contract(T) + contract(S)`. -/
theorem eslot_torsion_solder_split (gamma nabla : E -> B) :
    (2 : Nat) • eslotDefect gamma nabla
      = eslotContract gamma nabla (eslotTorsion gamma nabla)
        + eslotContract gamma nabla (eslotSolder gamma nabla) := by
  simp only [eslotDefect, eslotContract, eslotTorsion, eslotSolder]
  rw [← Finset.sum_add_distrib, Finset.smul_sum]
  apply Finset.sum_congr rfl
  intro e _
  rw [← Finset.sum_add_distrib, Finset.smul_sum]
  apply Finset.sum_congr rfl
  intro f _
  rw [two_smul]
  noncomm_ring

/-- A pure-torsion identification of the full E-slot holds exactly when the
symmetric soldering-difference contraction vanishes. -/
theorem eslot_torsion_contract_eq_two_smul_defect_iff (gamma nabla : E -> B) :
    eslotContract gamma nabla (eslotTorsion gamma nabla)
        = (2 : Nat) • eslotDefect gamma nabla
      ↔ eslotContract gamma nabla (eslotSolder gamma nabla) = 0 := by
  rw [eslot_torsion_solder_split, eq_comm]
  exact add_eq_left

/-- The obstruction is non-vacuous: over a single edge and `2 x 2` integer
matrices, the antisymmetric torsion contraction does not equal the doubled
E-slot. -/
theorem eslot_not_pure_torsion_witness :
    ∃ (gamma nabla : Fin 1 -> Matrix (Fin 2) (Fin 2) Int),
      eslotContract gamma nabla (eslotTorsion gamma nabla)
        ≠ (2 : Nat) • eslotDefect gamma nabla := by
  refine ⟨![!![0, 1; 0, 0]], ![!![0, 0; 1, 0]], ?_⟩
  simp only [eslotContract, eslotTorsion, eslotDefect, eslotFrameComm,
    Fin.sum_univ_one, Matrix.cons_val_zero]
  decide

end PhysicsSM.Draft.NullEdge.Carrier
