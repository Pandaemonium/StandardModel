import Mathlib

/-!
# The Ginsparg-Wilson relation: exact lattice chiral symmetry

This file formalizes, at **finite matrix grade**, the algebraic core of the
Ginsparg-Wilson (GW) mechanism for exact chiral symmetry on the lattice
(Lüscher, hep-lat/9802011).

We work with complex `n × n` matrices `D : Matrix (Fin n) (Fin n) ℂ` (the lattice
Dirac operator) and a Hermitian involution `γ₅` (`gamma5 * gamma5 = 1`).

## Honest label / scope

This is a **finite matrix identity capturing the GW mechanism**, *not* a full
lattice field theory.  The genuine content is that chiral symmetry is
**deformed** (`γ₅ ↦ γ₅(1 - D)`), *not broken*: this is the exact "price of the
turn" that the Nielsen-Ninomiya theorem forces on any lattice regularization.

## Main statements

* `GinspargWilson g D` : the GW relation `γ₅ D + D γ₅ = D γ₅ D` (lattice spacing `a = 1`).
* `gamma5Hat_sq` : `γ̂₅ := γ₅(1 - D)` is an involution, `γ̂₅ * γ̂₅ = 1`, given GW.
* `deformed_anticomm` : the deformed anticommutation `D γ̂₅ + γ₅ D = 0`, which is
  exactly the invariance of the massless action `ψ̄ D ψ` under `δψ = γ̂₅ ψ`,
  `δψ̄ = ψ̄ γ₅`.
* `overlap_ginspargWilson` : the overlap construction `D = 1 + γ₅ V`, with `V` a
  sign operator (`V * V = 1`), satisfies the GW relation.
-/

-- The user-requested namespace ends in `GinspargWilson` and the relation is also
-- named `GinspargWilson`; silence the (harmless) duplicated-namespace linter.
set_option linter.dupNamespace false

namespace PhysicsSM.Draft.NullEdge.GateYM.GinspargWilson

open Matrix

variable {n : ℕ}

/-- The **Ginsparg-Wilson relation** (lattice spacing `a = 1`):
`γ₅ D + D γ₅ = D γ₅ D`.  A lattice Dirac operator `D` satisfying this keeps an
exact *deformed* chiral symmetry. -/
def GinspargWilson (g D : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  g * D + D * g = D * g * D

/-- The **modified chirality** operator `γ̂₅ := γ₅ (1 - D)` (Lüscher). -/
noncomputable def gamma5Hat (g D : Matrix (Fin n) (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ :=
  g * (1 - D)

/-
**Exact modified chiral symmetry, part 1 (involution).**
If `γ₅` is an involution and `D` satisfies the Ginsparg-Wilson relation, then the
modified chirality `γ̂₅ = γ₅(1 - D)` is again an involution: `γ̂₅ * γ̂₅ = 1`.

The identity proved is `(γ₅(1-D)) * (γ₅(1-D)) = 1`, using
`γ₅² = 1` and `D + γ₅ D γ₅ = γ₅ D γ₅ D` (the GW relation multiplied by `γ₅`).
-/
theorem gamma5Hat_sq {g D : Matrix (Fin n) (Fin n) ℂ}
    (hg : g * g = 1) (hGW : GinspargWilson g D) :
    gamma5Hat g D * gamma5Hat g D = 1 := by
  unfold gamma5Hat;
  simp_all +decide [ mul_sub, sub_mul, ← mul_assoc ];
  unfold GinspargWilson at hGW; simp_all +decide [ mul_assoc, sub_eq_iff_eq_add ] ;
  simp_all +decide [ ← eq_sub_iff_add_eq' ];
  simp +decide [ mul_sub, ← mul_assoc, hg ];
  abel1

/-
**Exact modified chiral symmetry, part 2 (deformed anticommutation).**
If `D` satisfies the Ginsparg-Wilson relation, then
`D γ̂₅ + γ₅ D = 0` where `γ̂₅ = γ₅(1 - D)`.

This is precisely the statement that the massless action `ψ̄ D ψ` is invariant
under the deformed chiral rotation `δψ = γ̂₅ ψ`, `δψ̄ = ψ̄ γ₅`: the variation is
`ψ̄ (γ₅ D + D γ̂₅) ψ = 0`.  Note this direction needs only the GW relation, not
`γ₅² = 1`.
-/
theorem deformed_anticomm {g D : Matrix (Fin n) (Fin n) ℂ}
    (hGW : GinspargWilson g D) :
    D * gamma5Hat g D + g * D = 0 := by
  unfold gamma5Hat;
  simp_all +decide [ mul_sub, ← mul_assoc ];
  rw [ sub_add_eq_add_sub, sub_eq_zero ];
  rw [ ← hGW, add_comm ]

/-
**The overlap construction yields a GW operator.**
For a Hermitian sign operator `V` (`V * V = 1`, the sign of the Wilson-Dirac
operator) and a Hermitian involution `γ₅` (`γ₅ * γ₅ = 1`), the overlap Dirac
operator `D = 1 + γ₅ V` satisfies the Ginsparg-Wilson relation.

The Hermiticity hypothesis `hV` on `V` is included because it is part of the
physical overlap construction, but it turns out to be unnecessary for the GW
identity itself, which follows purely from `γ₅² = 1` and `V² = 1`.
-/
theorem overlap_ginspargWilson {g V : Matrix (Fin n) (Fin n) ℂ}
    (hg : g * g = 1) (hV : V * V = 1) (_hVherm : V.IsHermitian) :
    GinspargWilson g (1 + g * V) := by
  simp_all +decide [ GinspargWilson, mul_add, add_mul, mul_assoc ];
  simp_all +decide [ ← mul_assoc, add_comm, add_left_comm, add_assoc ]

end PhysicsSM.Draft.NullEdge.GateYM.GinspargWilson
