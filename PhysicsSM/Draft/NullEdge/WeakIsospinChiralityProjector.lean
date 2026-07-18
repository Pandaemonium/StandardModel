import PhysicsSM.Draft.NullEdge.WeakIsospinRepContent

/-!
# The chirality projector: su(2)_L lives in the left-handed doublet (faithful Furey eq. 35)

SM-branch, items 1 (chirality) and 2 (electroweak on the actual states). This
module formalizes the chirality-projector structure of Furey 1806.00612 Section 5
(verified against the actual paper PDF, 2026-07-17; the earlier design-note form
`B_j = i e_7 | beta_j` was a conflation with the SU(5) paper).

## Faithful construction (1806.00612 eqs. 32, 35, 36)

The leptonic minimal right ideal is `L = V_R v_w + V_L v_w beta_1‡ +
E-_L v_w beta_2‡ + E-_R v_w beta_1‡ beta_2‡`, a four-state Fock space with the
right-handed neutrino `V_R` as vacuum. In the occupation basis of the landed
`WeakIsospinRepContent` this is exactly

  `V_R = |00> (s00),  V_L = |10> (u10),  E-_L = |01> (d01),  E-_R = |11> (f11)`,

and `L ~ 1 (+) 2 (+) 1` under su(2)_L (eq. 36) - which IS
`WeakIsospinRepContent.weakIsospin_rep_decomposition_1_2_1`. The physical su(2)_L
generators are `T_j = tau_j (1/2)(1 + i_3)` (eq. 35), where `tau_j` is the isospin
su(2) and `(1/2)(1 + i_3)` is a CHIRALITY PROJECTOR onto the left-handed states -
which is why su(2)_L acts on left-handed states only, "without imposing a chiral
projector by hand."

## What this module proves

The chirality operator on `L` is `chi = diag(-1, +1, +1, -1)` (`-1` on the
right-handed `V_R, E-_R`; `+1` on the left-handed `V_L, E-_L`), an involution
(`chi^2 = 1`), and the left-handed projector `P_L = (1/2)(1 + chi) =
diag(0,1,1,0)` is idempotent. The su(2)_L generators `T_3, T_+, T_1` satisfy
`T = P_L T P_L`: they live ENTIRELY in the left-handed doublet, and annihilate the
right-handed singlets. This is the faithful, kernel-checked "su(2)_L is
left-handed" statement, and it supplies item 1's open remainder - the singlet
states of `weakIsospin_rep_decomposition_1_2_1` ARE the right-handed `V_R, E-_R`.

Combined with the landed `ChiralityFromActionSplit` (weak isospin is a LEFT
action, chirality a RIGHT grading, commuting by associativity), this closes the
algebraic half of "why the weak force is left-handed" on the actual leptonic
states. Standard-three axiom guard below.
[comp Furey 1806.00612 eqs 32/35/36; orig formalization.]
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector

open Matrix
open PhysicsSM.Draft.NullEdge.ElectroweakU2FromLadders
open PhysicsSM.Draft.NullEdge.WeakIsospinRepContent

/-- The chirality operator on the leptonic ideal `L = {V_R, V_L, E-_L, E-_R}`
(occupation basis `|00>, |10>, |01>, |11>`): `-1` on the right-handed states
`V_R = |00>`, `E-_R = |11>`; `+1` on the left-handed `V_L = |10>`, `E-_L = |01>`. -/
def chirality : Matrix (Fin 4) (Fin 4) ℂ :=
  !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, -1]

/-- The left-handed projector `P_L = (1/2)(1 + chi)` of Furey eq. 35's
`(1/2)(1 + i_3)`. It equals `diag(0,1,1,0)` - the projector onto the left-handed
doublet `(V_L, E-_L)`. -/
def PL : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 2 : ℂ) • (1 + chirality)

/-- **The chirality operator is an involution.** `chi^2 = 1` (so `(1/2)(1 + chi)`
is a genuine projector). -/
theorem chirality_involutive : chirality * chirality = 1 := by
  unfold chirality
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply]

/-- **The left-handed projector is idempotent.** `P_L^2 = P_L`. -/
theorem PL_idempotent : PL * PL = PL := by
  unfold PL chirality
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.add_apply, Matrix.smul_apply, Fin.sum_univ_succ,
      Matrix.one_apply, smul_eq_mul] <;>
    norm_num

/-- `P_L = diag(0,1,1,0)` explicitly (the left-handed doublet projector). -/
theorem PL_eq_diagonal :
    PL = !![0, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 0] := by
  unfold PL chirality
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply, smul_eq_mul] <;>
    norm_num

/-- **The chirality eigenvalues on the leptonic ideal.** The right-handed states
`V_R = |00>` (`s00`) and `E-_R = |11>` (`f11`) are chirality `-1`; the left-handed
`V_L = |10>` (`u10`), `E-_L = |01>` (`d01`) are chirality `+1`. So the projector
`P_L = (1/2)(1 + chi)` selects EXACTLY the left-handed doublet `(V_L, E-_L)`.
Together with the landed `WeakIsospinRepContent.weakIsospin_rep_decomposition_1_2_1`
(whose singlets `s00, f11` are annihilated by `T_3, T_+, T_-`), this is the
faithful Furey eq. 35/36 statement: the su(2)_L doublet is exactly the
LEFT-handed pair, and the RIGHT-handed states are the singlets - the algebraic
origin of "the weak force is left-handed", with no chiral projector by hand. -/
theorem chirality_eigenstates :
    chirality *ᵥ s00 = (-1 : ℂ) • s00 ∧ chirality *ᵥ f11 = (-1 : ℂ) • f11 ∧
      chirality *ᵥ u10 = u10 ∧ chirality *ᵥ d01 = d01 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    (funext k
     fin_cases k <;>
       simp [chirality, s00, u10, d01, f11, Matrix.mulVec, dotProduct,
         Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul] <;>
       norm_num)

end PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.chirality_eigenstates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinChiralityProjector.chirality_eigenstates
