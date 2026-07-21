import PhysicsSM.Draft.NullEdge.CompositionWeakCAR

/-!
# The su(2)_L layer and the Fig-4 automatic-chirality theorem (item-2 endgame)

**Status: DRAFT.** Furey 1806.00612 eq. 35: `T_j = tau_j (1/2)(1 + i i_3)` - the
su(2)_L generators are the isospin `tau`'s COMPOSED with the `H`-side chirality
projector `P_L = (1/2)(1 + i i_3)` (right multiplication, complex `i`). On the composition-
operator realization this yields the paper's Fig-4 claim as a THEOREM: the
`T_j` annihilate every right-handed state identically - no chiral projector
imposed by hand - because `P_L` kills `z` with `z i_3 = -z` by pure algebra.

Contents:
1. `hatTau1`, `hatTau2` (eq 29) as composition operators + their mode-plane
   action (algebraic from the landed atoms: on the basis `(v, nu)` they are
   the Pauli matrices `sigma_1`, `sigma_2`; `hatTau3 = -sigma_3` landed).
2. `PL` = right multiplication by `(1/2)(1 + i i_3)` (COMPLEX `i` - kernel
   lesson: without it the square is `i_3/2`, not a projector): idempotent,
   kills right-handed states (`i (z i_3) = -z`), fixes left-handed ones.
3. `T_j := co hatTau_j ∘ PL` and **the Fig-4 theorem**: `i (z i_3) = -z`
   implies `T_j z = 0` for all three `j` - GLOBAL.

Successors: eq-36 rep content (adjoint action on the ideal operators),
`T_+ = TPlusEnd` closure (representation bridge to the Jbar module).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionSU2

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 1000000

/-! ## The remaining isospin generators (eq 29) as composition operators -/

/-- `tau_1 = omega + omega‡` as a composition operator. -/
def hatTau1 (z : ComplexOctonion) : ComplexOctonion :=
  hatOmega z + hatOmegaDag z

/-- `tau_2 = i omega - i omega‡` as a composition operator. -/
def hatTau2 (z : ComplexOctonion) : ComplexOctonion :=
  Complex.I • hatOmega z + (-(Complex.I • hatOmegaDag z))

/-! ## Mode-plane action (algebraic from the landed atoms) -/

/-- `hatTau1 v = nu` (sigma_1 action, lower leg). -/
theorem hatTau1_on_vIdem : hatTau1 vIdem = nuState := by
  unfold hatTau1
  rw [hatOmegaDag_on_vIdem, ← nuState_eq_hatOmega_vIdem, add_zero]

/-- `hatTau1 nu = v` (sigma_1 action, upper leg; uses `hatOmega^2 = 0` and the
lowering atom). -/
theorem hatTau1_on_nuState : hatTau1 nuState = vIdem := by
  unfold hatTau1
  rw [hatOmegaDag_on_nuState, nuState_eq_hatOmega_vIdem, hatOmega_sq_zero,
    zero_add]

/-- `hatTau2 v = i nu` (sigma_2 action, lower leg). -/
theorem hatTau2_on_vIdem : hatTau2 vIdem = Complex.I • nuState := by
  unfold hatTau2
  rw [hatOmegaDag_on_vIdem, ← nuState_eq_hatOmega_vIdem, smul_zero, neg_zero,
    add_zero]

/-- `hatTau2 nu = -i v` (sigma_2 action, upper leg). -/
theorem hatTau2_on_nuState : hatTau2 nuState = -(Complex.I • vIdem) := by
  unfold hatTau2
  rw [hatOmegaDag_on_nuState, nuState_eq_hatOmega_vIdem, hatOmega_sq_zero,
    smul_zero, zero_add]

/-! ## The su(2) bracket relations on the mode plane

`[tau_i, tau_j] = -2i tau_k` (cyclic) on the basis `(v, nu)` - the Pauli
structure `(sigma_1, sigma_2, -sigma_3)` in kernel form; all algebraic from
the landed action atoms plus smul-linearity. -/

/-- `hatTau1` commutes with complex scalars (algebraic). -/
theorem hatTau1_smul (c : ℂ) (x : ComplexOctonion) :
    hatTau1 (c • x) = c • hatTau1 x := by
  unfold hatTau1
  rw [hatOmega_smul, hatOmegaDag_smul, smul_add]

/-- `hatTau2` commutes with complex scalars (algebraic). -/
theorem hatTau2_smul (c : ℂ) (x : ComplexOctonion) :
    hatTau2 (c • x) = c • hatTau2 x := by
  unfold hatTau2
  rw [hatOmega_smul, hatOmegaDag_smul]
  match_scalars <;> ring

/-- **`[tau_1, tau_2] = -2i tau_3` on the lower leg.** -/
theorem tau12_bracket_on_vIdem :
    hatTau1 (hatTau2 vIdem) - hatTau2 (hatTau1 vIdem)
      = (-(2 * Complex.I)) • hatTau3 vIdem := by
  rw [hatTau2_on_vIdem, hatTau1_on_vIdem, hatTau1_smul, hatTau1_on_nuState,
    hatTau2_on_nuState, hatTau3_on_vIdem]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

/-- **`[tau_1, tau_2] = -2i tau_3` on the upper leg.** -/
theorem tau12_bracket_on_nuState :
    hatTau1 (hatTau2 nuState) - hatTau2 (hatTau1 nuState)
      = (-(2 * Complex.I)) • hatTau3 nuState := by
  rw [hatTau2_on_nuState, hatTau1_on_nuState, hatTau2_on_vIdem,
    hatTau3_on_nuState]
  rw [show hatTau1 (-(Complex.I • vIdem)) = -(Complex.I • hatTau1 vIdem) from by
    rw [show (-(Complex.I • vIdem)) = ((-Complex.I : ℂ) • vIdem) from by
          match_scalars <;> ring,
      hatTau1_smul]
    match_scalars <;> ring]
  rw [hatTau1_on_vIdem]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

/-- **`[tau_2, tau_3] = -2i tau_1` on the lower leg.** -/
theorem tau23_bracket_on_vIdem :
    hatTau2 (hatTau3 vIdem) - hatTau3 (hatTau2 vIdem)
      = (-(2 * Complex.I)) • hatTau1 vIdem := by
  rw [hatTau3_on_vIdem, hatTau2_on_vIdem, hatTau3_smul, hatTau3_on_nuState]
  rw [show hatTau2 (-vIdem) = -(hatTau2 vIdem) from by
    rw [show (-vIdem : ComplexOctonion) = ((-1 : ℂ) • vIdem) from by
          match_scalars <;> ring,
      hatTau2_smul]
    match_scalars <;> ring]
  rw [hatTau2_on_vIdem, hatTau1_on_vIdem]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

/-- **`[tau_3, tau_1] = -2i tau_2` on the lower leg.** -/
theorem tau31_bracket_on_vIdem :
    hatTau3 (hatTau1 vIdem) - hatTau1 (hatTau3 vIdem)
      = (-(2 * Complex.I)) • hatTau2 vIdem := by
  rw [hatTau1_on_vIdem, hatTau3_on_nuState, hatTau3_on_vIdem]
  rw [show hatTau1 (-vIdem) = -(hatTau1 vIdem) from by
    rw [show (-vIdem : ComplexOctonion) = ((-1 : ℂ) • vIdem) from by
          match_scalars <;> ring,
      hatTau1_smul]
    match_scalars <;> ring]
  rw [hatTau1_on_vIdem, hatTau2_on_vIdem]
  match_scalars <;> (ring_nf; try simp [Complex.I_sq])

/-! ## The `H`-side chirality projector `P_L = (1/2)(1 + i i_3)` (right mult)

CONVENTION (kernel-corrected): eq 35's projector is `(1/2)(1 + i i_3)` with the
COMPLEX `i` - the quaternion unit alone gives `((1+i_3)/2)^2 = i_3/2` (NOT
idempotent, since `i_3^2 = -1`); with the central complex `i`,
`(i i_3)^2 = i^2 i_3^2 = +1` and the projector is genuine. This matches the
paper's `gamma^5` = right multiplication by `-i i_3` (p. 4): `P_L = (1/2)(1 -
gamma^5)`. Handedness labels are pinned by the computation, not assumed. -/

/-- Right multiplication by the `H`-unit `i_3`. -/
def R3 (d : Dixon) : Dixon := d * i3

/-! Local `ComplexOctonion` unit lemmas (private copies elsewhere). -/
@[local simp] private theorem cmo3 (x : ComplexOctonion) : x * 1 = x := by
  ext <;> simp
@[local simp] private theorem cmz3 (x : ComplexOctonion) : x * 0 = 0 := by
  ext <;> simp

/-- The slot form of `R3` (kernel; signs read off the Hamilton table). -/
theorem R3_slots (d : Dixon) : R3 d = ⟨-d.x3, d.x2, -d.x1, d.x0⟩ := by
  unfold R3
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [i3, mul]

/-- `R3` squares to minus the identity (`i_3^2 = -1`). -/
theorem R3_R3 (d : Dixon) : R3 (R3 d) = -d := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- `R3` is additive. -/
theorem R3_add (a b : Dixon) : R3 (a + b) = R3 a + R3 b := by
  rw [R3_slots, R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp <;> abel

/-- `R3` commutes with the complex scalars. -/
theorem R3_smul (c : ℂ) (a : Dixon) : R3 (c • a) = c • R3 a := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- The chirality projector `P_L z = (1/2)(z + i (z i_3))` (eq 35's
`(1/2)(1 + i i_3)`, right multiplication, complex `i` central). -/
def PL (d : Dixon) : Dixon := (1 / 2 : ℂ) • (d + Complex.I • R3 d)

/-- `P_L` is idempotent - BECAUSE of the complex `i`: `(i i_3)^2 = +1`. -/
theorem PL_idempotent (d : Dixon) : PL (PL d) = PL d := by
  unfold PL
  rw [R3_smul, R3_add, R3_smul, R3_R3]
  match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num

/-- **Right-handed states are killed by `P_L`**: if `i (z i_3) = -z` then
`P_L z = 0`. -/
theorem PL_kills_RH (d : Dixon) (h : Complex.I • R3 d = -d) : PL d = 0 := by
  unfold PL
  rw [h, add_neg_cancel, smul_zero]

/-- Left-handed states are fixed by `P_L`: if `i (z i_3) = z` then
`P_L z = z`. -/
theorem PL_fixes_LH (d : Dixon) (h : Complex.I • R3 d = d) : PL d = d := by
  unfold PL
  rw [h]
  match_scalars <;> ring

/-! ## The su(2)_L generators (eq 35) and the Fig-4 theorem -/

/-- `T_1 = tau_1 (1/2)(1 + i_3)` (eq 35). -/
def T1 (d : Dixon) : Dixon := co hatTau1 (PL d)
/-- `T_2 = tau_2 (1/2)(1 + i_3)`. -/
def T2 (d : Dixon) : Dixon := co hatTau2 (PL d)
/-- `T_3 = tau_3 (1/2)(1 + i_3)`. -/
def T3 (d : Dixon) : Dixon := co hatTau3 (PL d)

/-- `co g 0 = 0` for maps sending `0` to `0`. -/
theorem co_zero (g : ComplexOctonion → ComplexOctonion) (hg : g 0 = 0) :
    co g (0 : Dixon) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, zero_x0, zero_x1, zero_x2, zero_x3,
      hg]

/-- `hatTau1 0 = 0`. -/
theorem hatTau1_zero : hatTau1 0 = 0 := by
  unfold hatTau1
  rw [hatOmega_zero, hatOmegaDag_zero, add_zero]

/-- `hatTau2 0 = 0`. -/
theorem hatTau2_zero : hatTau2 0 = 0 := by
  unfold hatTau2
  rw [hatOmega_zero, hatOmegaDag_zero]
  simp

/-- `hatTau3 0 = 0`. -/
theorem hatTau3_zero : hatTau3 0 = 0 := by
  unfold hatTau3
  rw [hatOmegaDag_zero, hatOmega_zero, hatOmegaDag_zero]
  simp

/-- **THE FIG-4 THEOREM (`T_1` case): su(2)_L annihilates right-handed states
automatically.** For any Dixon state with `z i_3 = -z` (right-handed),
`T_1 z = 0` - no chiral projector imposed by hand (Furey 1806.00612 Fig. 4:
"the SU(2) symmetries ... act automatically on lepton states of only a single
chirality"). Right-handed = `i (z i_3) = -z`, i.e. the `gamma^5 = +1`
eigenspace in the pinned convention. -/
theorem T1_kills_RH (d : Dixon) (h : Complex.I • R3 d = -d) : T1 d = 0 := by
  unfold T1
  rw [PL_kills_RH d h]
  exact co_zero _ hatTau1_zero

/-- **Fig-4, `T_2` case.** -/
theorem T2_kills_RH (d : Dixon) (h : Complex.I • R3 d = -d) : T2 d = 0 := by
  unfold T2
  rw [PL_kills_RH d h]
  exact co_zero _ hatTau2_zero

/-- **Fig-4, `T_3` case.** -/
theorem T3_kills_RH (d : Dixon) (h : Complex.I • R3 d = -d) : T3 d = 0 := by
  unfold T3
  rw [PL_kills_RH d h]
  exact co_zero _ hatTau3_zero

end PhysicsSM.Draft.NullEdge.CompositionSU2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2.T1_kills_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2.T1_kills_RH

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2.hatTau1_on_nuState' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2.hatTau1_on_nuState
