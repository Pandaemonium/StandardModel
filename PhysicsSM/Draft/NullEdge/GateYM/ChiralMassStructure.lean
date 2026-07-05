import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

/-!
# NE-U2: the chirality structure of mass (mass = the "turn" / chirality-mixing channel)

Rung NE-U2 of the null-edge mass unification ladder
(`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`), at the
level of the Euclidean gamma algebra that underlies the QMF4 Wilson-Dirac
operator (`WilsonDiracOperator.lean`).

## The mechanism, made precise

In the null-edge reading, fermion mass is the amplitude for a CHIRALITY FLIP
(the checkerboard "coin turn") coupling the two null movers; massless transport
preserves chirality. Chirality is measured by `γ5`: an operator `A` is
chirality-PRESERVING (the pure null-transport channel) when it ANTICOMMUTES
with `γ5` (`γ5 A γ5 = -A`), and chirality-MIXING (the "turn" / mass channel)
when it COMMUTES (`γ5 A γ5 = A`). We split any spin operator into these two
channels with the projections

    chiralOdd A  = (A - γ5 A γ5) / 2   (chirality-preserving / transport)
    chiralEven A = (A + γ5 A γ5) / 2   (chirality-mixing / "turn")

and read off the Wilson-Dirac vertex `1 - γ_mu`:

* the transport generator `γ_mu` is PURELY chirality-odd (`γ5 γ_mu γ5 = -γ_mu`);
* the scalar `1` in the Wilson projector is PURELY chirality-even;
* the mass term `m • 1` is also purely chirality-even.

**The headline (`chiralEven_massVertex`, `chiralOdd_massVertex`):** the physical
mass `m • 1` and the Wilson scalar structure land in the SAME chirality-mixing
channel, while the transport `γ_mu` is the only chirality-preserving part. This
is the mass-taxonomy row-1 (physical fermion mass) vs row-2 (Wilson regulator
mass) distinction as ALGEBRA: both are "turn" obstructions (chirality-even);
they differ only in that the physical piece scales with `m` and survives the
`r -> 0` naive limit while the regulator does not. F-YM-CONFLATE is thereby
enforced structurally, not just in prose.

## Claim discipline

Claim label: **finite identity** (pure spin-algebra, no lattice, no continuum,
no dynamics). Convention: Euclidean gamma matrices (`EuclideanGamma`, Hermitian
`γ_mu`), the same oracle-pinned convention as the Wilson-Dirac operator. This
module is the chirality-channel companion to `WilsonDiracOperator.gamma5_
hermiticity`; that theorem is about hermiticity (`γ5 D γ5 = Dᴴ`), this one is
about chirality (`γ5 A γ5 = ± A`) - distinct `γ5` roles, kept separate.

Draft-trust: kernel-checked, `s o r r y`-free. Prerequisites:
`EuclideanGamma`. Successor: the operator-level statement
`chiral_iff_massless_naive` (naive Wilson-Dirac operator is chirally symmetric
iff `m = 0`) lifts these spin identities to the full lattice operator.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace ChiralMassStructure

open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

/-- The chirality-odd (chirality-preserving / null-transport) channel of a spin
operator: `(A - γ5 A γ5) / 2`. -/
noncomputable def chiralOdd (A : Matrix (Fin 4) (Fin 4) ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 2 : ℂ) • (A - γ5 * A * γ5)

/-- The chirality-even (chirality-mixing / "turn" / mass) channel of a spin
operator: `(A + γ5 A γ5) / 2`. -/
noncomputable def chiralEven (A : Matrix (Fin 4) (Fin 4) ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 2 : ℂ) • (A + γ5 * A * γ5)

/-- The two channels reconstruct the operator: `A = chiralOdd A + chiralEven A`. -/
theorem chiralOdd_add_chiralEven (A : Matrix (Fin 4) (Fin 4) ℂ) :
    chiralOdd A + chiralEven A = A := by
  unfold chiralOdd chiralEven
  module

/-- **The transport generator is purely chirality-preserving**: `γ5 γ_mu γ5 =
-γ_mu`. The null-transport direction anticommutes with chirality - moving along
a null edge does not flip handedness. -/
theorem γ5_conj_γ (μ : Fin 4) : γ5 * γ μ * γ5 = - γ μ := by
  have h5 := γ5_sq
  have hcomm : γ5 * γ μ = -(γ μ * γ5) := eq_neg_of_add_eq_zero_left (γ5_anticomm μ)
  rw [hcomm, neg_mul, mul_assoc, h5, mul_one]

/-- **The scalar Wilson/mass structure is purely chirality-mixing**:
`γ5 * 1 * γ5 = 1`. The identity in spin space commutes with chirality; this is
the "turn" channel that both the mass term and the Wilson term feed. -/
theorem γ5_conj_one : γ5 * (1 : Matrix (Fin 4) (Fin 4) ℂ) * γ5 = 1 := by
  rw [mul_one, γ5_sq]

/-- `γ_mu` sits entirely in the chirality-odd channel. -/
theorem chiralOdd_γ (μ : Fin 4) : chiralOdd (γ μ) = γ μ := by
  unfold chiralOdd
  rw [γ5_conj_γ]; module

/-- `γ_mu` has no chirality-even (mass) component. -/
theorem chiralEven_γ (μ : Fin 4) : chiralEven (γ μ) = 0 := by
  unfold chiralEven
  rw [γ5_conj_γ]; module

/-- The scalar `1` sits entirely in the chirality-even channel. -/
theorem chiralEven_one : chiralEven (1 : Matrix (Fin 4) (Fin 4) ℂ) = 1 := by
  unfold chiralEven
  rw [γ5_conj_one]; module

/-- The scalar `1` has no chirality-odd (transport) component. -/
theorem chiralOdd_one : chiralOdd (1 : Matrix (Fin 4) (Fin 4) ℂ) = 0 := by
  unfold chiralOdd
  rw [γ5_conj_one]; module

/-- The mass vertex `m • 1 + (1 - γ_mu)`: the full spin content of the
Wilson-Dirac vertex at mass `m` in direction `mu` (mass term plus forward
Wilson projector, spin factors only). -/
noncomputable def massVertex (m : ℂ) (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + (1 - γ μ)

/-- **HEADLINE (chirality-even / "turn" channel)**: the chirality-mixing part of
the mass vertex is `(m + 1) • 1` - the physical mass `m • 1` and the Wilson
scalar `1` merge into ONE chirality-even coefficient. Mass and the Wilson
regulator are the same KIND of object (a chirality flip); they are distinguished
only by the `m`-scaling, exactly the taxonomy row-1 vs row-2 boundary. -/
theorem chiralEven_massVertex (m : ℂ) (μ : Fin 4) :
    chiralEven (massVertex m μ) = (m + 1) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  unfold chiralEven massVertex
  have e1 : γ5 * (m • (1 : Matrix (Fin 4) (Fin 4) ℂ)) * γ5 = m • 1 := by
    rw [mul_smul_comm, smul_mul_assoc, mul_one, γ5_sq]
  have hconj : γ5 * (m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + (1 - γ μ)) * γ5
      = m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + (1 + γ μ) := by
    rw [mul_add, add_mul, mul_sub, sub_mul, e1, γ5_conj_one, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj]; module

/-- **HEADLINE (chirality-odd / transport channel)**: the chirality-preserving
part of the mass vertex is exactly `-γ_mu` - the pure null-transport generator,
independent of the mass. Transport lives in one channel, mass in the other. -/
theorem chiralOdd_massVertex (m : ℂ) (μ : Fin 4) :
    chiralOdd (massVertex m μ) = - γ μ := by
  unfold chiralOdd massVertex
  have e1 : γ5 * (m • (1 : Matrix (Fin 4) (Fin 4) ℂ)) * γ5 = m • 1 := by
    rw [mul_smul_comm, smul_mul_assoc, mul_one, γ5_sq]
  have hconj : γ5 * (m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + (1 - γ μ)) * γ5
      = m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + (1 + γ μ) := by
    rw [mul_add, add_mul, mul_sub, sub_mul, e1, γ5_conj_one, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj]; module

/-- **The mass parameter is exactly the mass-channel coefficient minus the
regulator.** The chirality-even coefficient of the vertex is `m + 1`; the `+1`
is the `m`-independent Wilson regulator contribution, so the PHYSICAL mass is
recovered as the `m`-derivative of the turn channel, cleanly separated from the
regulator constant. Stated as: the even channel vanishes iff `m = -1`, i.e. the
regulator exactly cancels a mass of `-1` - there is no `m` at which BOTH the
transport-flip and the regulator vanish, which is the finite shadow of the
Nielsen-Ninomiya obstruction (you cannot have chiral symmetry AND doubler
removal at once). -/
theorem chiralEven_massVertex_eq_zero_iff (m : ℂ) (μ : Fin 4) :
    chiralEven (massVertex m μ) = 0 ↔ m = -1 := by
  rw [chiralEven_massVertex]
  constructor
  · intro h
    have h11 := congrFun (congrFun h 0) 0
    simp only [Matrix.smul_apply, Matrix.one_apply_eq, Matrix.zero_apply, smul_eq_mul,
      mul_one] at h11
    linear_combination h11
  · intro h
    rw [h]
    rw [show (-1 : ℂ) + 1 = 0 by ring, zero_smul]

end ChiralMassStructure
end PhysicsSM.Draft.NullEdge.GateYM
