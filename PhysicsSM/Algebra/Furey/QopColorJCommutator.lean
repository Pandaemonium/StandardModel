import Mathlib
import PhysicsSM.Algebra.Furey.ColorJRepresentation

/-!
# Algebra.Furey.QopColorJCommutator

This module promotes the `EqOnJ`-level charge-conservation theorems to
literal endomorphism equalities on the minimal left ideal `J`.

## Contents

- `Q_op_mem_J`: the electric-charge operator `Q_op` preserves `J`.
- `Q_op_JEnd`: the induced ℂ-linear endomorphism of `J`.
- `qopJ_commutes_*`: `Q_op` commutes with every color generator on `J`.

Source: Furey, arXiv:1806.00612.
Provenance: clean-room formalization building on kernel-checked operator
tables in `OperatorAlgebra.lean`, `OperatorRepresentations.lean`,
`ColorRepresentation.lean`, and `ColorJRepresentation.lean`.
-/

namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators

/-!
## Q_op preserves J
-/

/-- The electric-charge operator `Q_op` maps elements of `J` back into `J`.
Each basis state is an eigenvector of `Q_op`, so `Q_op` maps the span to itself. -/
theorem Q_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : Q_op x ∈ J := by
  have hmem : ∀ i : Fin 8, Q_op (basisState i) ∈ J := by
    intro i; fin_cases i <;> dsimp [basisState] <;>
      simp only [Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu]
    · exact J.smul_mem _ omega_mem_J
    · exact J.smul_mem _ v1_mem_J
    · exact J.smul_mem _ v2_mem_J
    · exact J.smul_mem _ v3_mem_J
    · exact J.smul_mem _ v4_mem_J
    · exact J.smul_mem _ v5_mem_J
    · exact J.smul_mem _ v6_mem_J
    · simp [J.zero_mem]
  change x ∈ Submodule.span Complex (Set.range basisState) at hx
  refine Submodule.span_induction (p := fun x _ => Q_op x ∈ J) ?_ ?_ ?_ ?_ hx
  · rintro y ⟨i, rfl⟩; exact hmem i
  · simp [J.zero_mem]
  · intro a b _ _ ha hb; rw [Q_op.map_add]; exact J.add_mem ha hb
  · intro c a _ ha; rw [Q_op.map_smul]; exact J.smul_mem c ha

/-!
## The induced endomorphism on J
-/

/-- The induced ℂ-linear endomorphism of `J` for the electric-charge operator. -/
noncomputable def Q_op_JEnd : J →ₗ[ℂ] J :=
  Q_op.restrict (fun _ hx => Q_op_mem_J hx)

set_option maxHeartbeats 400000 in
-- Needed to check definitional equality through `LinearMap.restrict`.
@[simp] theorem Q_op_JEnd_apply (x : J) :
    (Q_op_JEnd x).val = Q_op x.val := rfl

/-!
## Q_op commutes with color generators on J

Each proof lifts the existing `EqOnJ (opComm Q_op T_op) 0` theorem
(or proves the analogous statement directly for diagonal generators)
to a genuine equality `opCommJ Q_op_JEnd c.toJEnd = 0` of endomorphisms of `J`.
-/

set_option maxHeartbeats 800000 in
-- Needed to unfold opCommJ, Q_op_JEnd, toJEnd, opComm through the restrict/toEnd chain.
/-- Helper to lift charge conservation from `EqOnJ` to `opCommJ` on `J`. -/
private theorem qopJ_commutes_of_EqOnJ
    (c : ColorGen)
    (h : EqOnJ (opComm Q_op c.toEnd) 0) :
    opCommJ Q_op_JEnd c.toJEnd = 0 := by
  apply LinearMap.ext; intro ⟨x, hx⟩
  apply Subtype.ext
  simp only [opCommJ, LinearMap.sub_apply, LinearMap.comp_apply,
    LinearMap.zero_apply, ZeroMemClass.coe_zero]
  have := h x hx
  simp only [opComm, LinearMap.sub_apply, LinearMap.comp_apply,
    LinearMap.zero_apply] at this
  exact this

theorem qopJ_commutes_E12 :
    opCommJ Q_op_JEnd ColorGen.E12.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E12 charge_conservation_T12

theorem qopJ_commutes_E21 :
    opCommJ Q_op_JEnd ColorGen.E21.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E21 charge_conservation_T21

theorem qopJ_commutes_E13 :
    opCommJ Q_op_JEnd ColorGen.E13.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E13 charge_conservation_T13

theorem qopJ_commutes_E31 :
    opCommJ Q_op_JEnd ColorGen.E31.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E31 charge_conservation_T31

theorem qopJ_commutes_E23 :
    opCommJ Q_op_JEnd ColorGen.E23.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E23 charge_conservation_T23

theorem qopJ_commutes_E32 :
    opCommJ Q_op_JEnd ColorGen.E32.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.E32 charge_conservation_T32

/-!
## Diagonal generators: Q_op commutes with H12 and H23 on J

There are no existing `charge_conservation_H*` theorems, so we prove these
directly. Both `Q_op` and `H12_op`/`H23_op` act as scalars on each basis
state, so they commute by commutativity of scalar multiplication.
-/

set_option maxHeartbeats 400000 in
-- Needed for unfolding opComm and simp over all 8 basis states.
theorem charge_conservation_H12 :
    EqOnJ (opComm Q_op H12_op) 0 := by
  apply EqOnJ_of_basis
  intro i; fin_cases i <;> simp +decide [opComm, basisState,
    Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu,
    H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
    H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu]

set_option maxHeartbeats 400000 in
-- Needed for unfolding opComm and simp over all 8 basis states.
theorem charge_conservation_H23 :
    EqOnJ (opComm Q_op H23_op) 0 := by
  apply EqOnJ_of_basis
  intro i; fin_cases i <;> simp +decide [opComm, basisState,
    Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu,
    H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
    H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu]

theorem qopJ_commutes_H12 :
    opCommJ Q_op_JEnd ColorGen.H12.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.H12 charge_conservation_H12

theorem qopJ_commutes_H23 :
    opCommJ Q_op_JEnd ColorGen.H23.toJEnd = 0 :=
  qopJ_commutes_of_EqOnJ ColorGen.H23 charge_conservation_H23

/-- `Q_op` commutes with every color generator on `J`. -/
theorem qopJ_commutes_color (c : ColorGen) :
    opCommJ Q_op_JEnd c.toJEnd = 0 := by
  cases c
  · exact qopJ_commutes_E12
  · exact qopJ_commutes_E21
  · exact qopJ_commutes_E13
  · exact qopJ_commutes_E31
  · exact qopJ_commutes_E23
  · exact qopJ_commutes_E32
  · exact qopJ_commutes_H12
  · exact qopJ_commutes_H23

end PhysicsSM.Algebra.Furey.MinimalLeftIdeal
