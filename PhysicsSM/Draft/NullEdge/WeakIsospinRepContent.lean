import PhysicsSM.Draft.NullEdge.ElectroweakU2FromLadders

/-!
# su(2)_L representation content of the weak-ladder Fock space: 1 (+) 2 (+) 1

SM-branch foundation, item 1 remainder (which states are weak-isospin singlets
vs. doublets), 2026-07-17. The landed electroweak brick
`ElectroweakU2FromLadders` builds `su(2)_L` from two weak ladder modes on a
4-dimensional Fock space with basis `|00>, |10>, |01>, |11>` (empty, mode-1,
mode-2, full). This module computes the explicit `su(2)_L` ACTION on that basis
and shows the space decomposes as

  `1 (+) 2 (+) 1`

under weak isospin: the empty state `|00>` and the full state `|11>` are
annihilated by `T_3`, `T_+`, and `T_-` (they are `su(2)_L` SINGLETS), while the
two singly-occupied states `|10>, |01>` form the DOUBLET - `T_3` eigenvalues
`+1, -1`, with `T_+` raising `|01> -> |10>` (`d -> u`) and `T_-` lowering
`|10> -> |01>`.

This is the algebraic structure behind chirality (item 1): the model contains
BOTH `su(2)_L` singlets and a doublet, exactly as the Standard Model places some
fermion states in weak doublets and others in singlets. It is the isospin/rep
content, kernel-checked on the concrete ladder model; it does NOT by itself fix
which physical particles occupy the singlet vs. doublet slots (that requires the
full R(x)C(x)H(x)O state-particle identification, still open - see the item-1
remainder in `Sources/Null_Edge_Ten_Ambitious_Goals_Status_2026-07-17.md`).

Companion to `WeakIsospinTwoModeSU2Aristotle` (the su(2)_L algebra) and
`ElectroweakU2FromLadders` (the U(2) and SM charges). Self-contained
finite-matrix proofs; standard-three axiom guards below.
[comp Furey 1806.00612; orig formalization].
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WeakIsospinRepContent

open Matrix
open PhysicsSM.Draft.NullEdge.ElectroweakU2FromLadders

/-- Weak-isospin lowering operator `T_- = B_2^dagger B_1` (the adjoint of the
`T_+ = B_1^dagger B_2` defined in `ElectroweakU2FromLadders`). -/
def TMinus : Matrix (Fin 4) (Fin 4) ℂ := B2ᴴ * B1

/-! ### The four Fock basis states -/

/-- The empty Fock state `|00>`. -/
def s00 : Fin 4 → ℂ := ![1, 0, 0, 0]
/-- The mode-1 state `|10>` (identified with the up-type doublet member). -/
def u10 : Fin 4 → ℂ := ![0, 1, 0, 0]
/-- The mode-2 state `|01>` (identified with the down-type doublet member). -/
def d01 : Fin 4 → ℂ := ![0, 0, 1, 0]
/-- The full Fock state `|11>`. -/
def f11 : Fin 4 → ℂ := ![0, 0, 0, 1]

/-- Shared simp set + tactic for the finite mulVec computations. -/
macro "mulVec_compute" : tactic =>
  `(tactic|
    (funext k
     fin_cases k <;>
       simp [TMinus, T3, TPlus, B1, B2, s00, u10, d01, f11, Matrix.mulVec,
         dotProduct, Matrix.mul_apply, Matrix.sub_apply,
         Matrix.conjTranspose_apply, Fin.sum_univ_four] <;>
       norm_num))

/-! ### Singlet: the empty Fock state `|00>` -/

/-- `T_3 |00> = 0`. -/
theorem T3_s00 : T3 *ᵥ s00 = 0 := by mulVec_compute
/-- `T_+ |00> = 0`. -/
theorem TPlus_s00 : TPlus *ᵥ s00 = 0 := by mulVec_compute
/-- `T_- |00> = 0`. -/
theorem TMinus_s00 : TMinus *ᵥ s00 = 0 := by mulVec_compute

/-! ### Singlet: the full Fock state `|11>` -/

/-- `T_3 |11> = 0`. -/
theorem T3_f11 : T3 *ᵥ f11 = 0 := by mulVec_compute
/-- `T_+ |11> = 0`. -/
theorem TPlus_f11 : TPlus *ᵥ f11 = 0 := by mulVec_compute
/-- `T_- |11> = 0`. -/
theorem TMinus_f11 : TMinus *ᵥ f11 = 0 := by mulVec_compute

/-! ### Doublet: the singly-occupied states `|10>` (top) and `|01>` (bottom) -/

/-- `T_3 |10> = +|10>` (isospin up). -/
theorem T3_u10 : T3 *ᵥ u10 = u10 := by mulVec_compute
/-- `T_+ |10> = 0` (top of the doublet). -/
theorem TPlus_u10 : TPlus *ᵥ u10 = 0 := by mulVec_compute
/-- `T_- |10> = |01>` (lowering `u -> d`). -/
theorem TMinus_u10 : TMinus *ᵥ u10 = d01 := by mulVec_compute

/-- `T_3 |01> = -|01>` (isospin down). -/
theorem T3_d01 : T3 *ᵥ d01 = -d01 := by mulVec_compute
/-- `T_+ |01> = |10>` (raising `d -> u`). -/
theorem TPlus_d01 : TPlus *ᵥ d01 = u10 := by mulVec_compute
/-- `T_- |01> = 0` (bottom of the doublet). -/
theorem TMinus_d01 : TMinus *ᵥ d01 = 0 := by mulVec_compute

/-! ### The su(2)_L Casimir: spin `j = 0` (singlet) vs `j = 1/2` (doublet)

The quadratic Casimir of the physical (spin-normalized) generators
`J_i = T_i / 2` is `J^2 = J_1^2 + J_2^2 + J_3^2 = (1/4)(T_1^2 + T_2^2 + T_3^2)`.
Its eigenvalue is `j (j+1)`: `0` on a singlet (`j = 0`), `3/4` on a doublet
(`j = 1/2`). Computing it pins the spin quantum numbers, not merely which states
are annihilated. -/

/-- Weak-isospin `T_2 = i (B_2^dagger B_1 - B_1^dagger B_2) = i (T_- - T_+)`. -/
def T2 : Matrix (Fin 4) (Fin 4) ℂ := Complex.I • (TMinus - TPlus)

/-- The quadratic su(2)_L Casimir of the spin-normalized generators
`J_i = T_i/2`: `J^2 = (1/4)(T_1^2 + T_2^2 + T_3^2)`. -/
def casimir : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 4 : ℂ) • (T1 * T1 + T2 * T2 + T3 * T3)

/-- **The Casimir is `diag(0, 3/4, 3/4, 0)`.** The empty and full Fock states
carry `j(j+1) = 0` (spin `j = 0`, singlet); the two singly-occupied states carry
`j(j+1) = 3/4` (spin `j = 1/2`, doublet). -/
theorem casimir_eq_diagonal :
    casimir = !![0, 0, 0, 0; 0, 3 / 4, 0, 0; 0, 0, 3 / 4, 0; 0, 0, 0, 0] := by
  unfold casimir T1 T2 T3 TPlus TMinus B1 B2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply,
      Matrix.conjTranspose_apply, Fin.sum_univ_four, smul_eq_mul, Complex.ext_iff,
      Complex.I_sq] <;>
    norm_num

/-- **The Casimir eigenvalues (spin content).** `J^2 |00> = 0`, `J^2 |11> = 0`
(singlets, `j = 0`); `J^2 |10> = (3/4)|10>`, `J^2 |01> = (3/4)|01>` (the doublet,
`j = 1/2`). -/
theorem casimir_spin_content :
    casimir *ᵥ s00 = 0 ∧ casimir *ᵥ f11 = 0 ∧
      casimir *ᵥ u10 = (3 / 4 : ℂ) • u10 ∧
        casimir *ᵥ d01 = (3 / 4 : ℂ) • d01 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    (funext k
     rw [casimir_eq_diagonal]
     fin_cases k <;>
       simp [s00, u10, d01, f11, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
         Matrix.smul_apply, smul_eq_mul] <;>
       norm_num)

/-! ### Payoff: the doublet states are electric-charge eigenstates (SM charges)

Combining the isospin rep content with the landed Gell-Mann-Nishijima charge
operator `Qop` (`ElectroweakU2FromLadders`), the identified doublet states carry
EXACTLY the Standard-Model electric charges. The `T_3 = +1` state is the
up-type/neutral member, the `T_3 = -1` state the down-type/charged member. -/

/-- **Lepton doublet charges (Y = -1).** `Q|10> = 0` (neutrino, `T_3 = +1`) and
`Q|01> = -|01>` (electron, `T_3 = -1`): the doublet states are charge
eigenstates with the SM lepton charges. -/
theorem lepton_doublet_charge_eigenstates :
    Qop (-1) *ᵥ u10 = 0 ∧ Qop (-1) *ᵥ d01 = (-1 : ℂ) • d01 := by
  constructor <;>
    (funext k
     rw [QLepton_eq_diagonal]
     fin_cases k <;>
       simp [u10, d01, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
         Matrix.smul_apply, smul_eq_mul, Pi.zero_apply] <;>
       norm_num)

/-- **Quark doublet charges (Y = 1/3).** `Q|10> = (2/3)|10>` (up, `T_3 = +1`) and
`Q|01> = -(1/3)|01>` (down, `T_3 = -1`): the doublet states are charge
eigenstates with the SM quark charges. -/
theorem quark_doublet_charge_eigenstates :
    Qop (1 / 3) *ᵥ u10 = (2 / 3 : ℂ) • u10 ∧
      Qop (1 / 3) *ᵥ d01 = (-1 / 3 : ℂ) • d01 := by
  constructor <;>
    (funext k
     rw [QQuark_eq_diagonal]
     fin_cases k <;>
       simp [u10, d01, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
         Matrix.smul_apply, smul_eq_mul] <;>
       norm_num)

/-! ### The decomposition certificate -/

/-- **The su(2)_L representation content is `1 (+) 2 (+) 1`.** The empty (`|00>`)
and full (`|11>`) Fock states are `su(2)_L` singlets (annihilated by `T_3`, `T_+`,
`T_-`); the two singly-occupied states form the doublet, with `T_3` eigenvalues
`+1, -1` and `T_+` raising `|01> -> |10>`. This is the isospin structure that
distinguishes weak singlets from weak doublets - the algebraic backbone of
chirality (item 1) on the concrete ladder model. -/
theorem weakIsospin_rep_decomposition_1_2_1 :
    -- two singlets (killed by all of T_3, T_+, T_-):
    (T3 *ᵥ s00 = 0 ∧ TPlus *ᵥ s00 = 0 ∧ TMinus *ᵥ s00 = 0) ∧
      (T3 *ᵥ f11 = 0 ∧ TPlus *ᵥ f11 = 0 ∧ TMinus *ᵥ f11 = 0) ∧
      -- one doublet (T_3 eigenvalues +/-1, linked by the ladders):
      (T3 *ᵥ u10 = u10 ∧ T3 *ᵥ d01 = -d01 ∧
        TPlus *ᵥ d01 = u10 ∧ TMinus *ᵥ u10 = d01 ∧
        TPlus *ᵥ u10 = 0 ∧ TMinus *ᵥ d01 = 0) :=
  ⟨⟨T3_s00, TPlus_s00, TMinus_s00⟩, ⟨T3_f11, TPlus_f11, TMinus_f11⟩,
    T3_u10, T3_d01, TPlus_d01, TMinus_u10, TPlus_u10, TMinus_d01⟩

end PhysicsSM.Draft.NullEdge.WeakIsospinRepContent

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.weakIsospin_rep_decomposition_1_2_1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.weakIsospin_rep_decomposition_1_2_1

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.casimir_spin_content' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.casimir_spin_content

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.lepton_doublet_charge_eigenstates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.lepton_doublet_charge_eigenstates

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.quark_doublet_charge_eigenstates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinRepContent.quark_doublet_charge_eigenstates

end
