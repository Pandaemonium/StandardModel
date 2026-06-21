import Mathlib
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.WeakIsospinDoublets

/-!
# Furey weak-isospin raising and lowering operators

This module defines the weak-isospin raising (`T⁺`) and lowering (`T⁻`)
operators on the finite `JbarWavefunction` space and proves that together
with `T3End` they satisfy the `su(2)` commutation relations of a spin-1/2
representation on the four electroweak doublets.

## Main declarations

- `TPlusEnd` — the weak-isospin raising operator.
- `TMinusEnd` — the weak-isospin lowering operator.
- `endComm` — commutator of two continuous linear endomorphisms.
- `T3_comm_TPlus` — `[T₃, T⁺] = T⁺`.
- `T3_comm_TMinus` — `[T₃, T⁻] = −T⁻`.
- `TPlus_comm_TMinus` — `[T⁺, T⁻] = 2 T₃`.
- `Y_comm_TPlus` — `[Y, T⁺] = 0`.
- `Y_comm_TMinus` — `[Y, T⁻] = 0`.
- `FureyWeakIsospinLadderPackage` / `fureyWeakIsospinLadderPackage`.

## Claim boundary

This is a table/operator theorem for the finite Jbar wavefunction model. It
does not derive these operators from Furey's octonionic ladder algebra, and it
does not prove the full Standard Model representation category.

## Status

Trusted module: no `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e`.
-/

namespace PhysicsSM.Algebra.Furey.WeakIsospinLadder

open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
open PhysicsSM.Algebra.Furey.T3OpJbar
open Complex

/-! ## Helper: source index for raising/lowering -/

/-- Source index for the raising operator T⁺. For each output index `s`,
    `tPlusSource s` gives the input index whose coefficient is copied,
    or `none` if the output is zero. -/
def tPlusSource (s : JbarState) : Option JbarState :=
  match s.val with
  | 0 => some ⟨7, by omega⟩  -- e → ν
  | 4 => some ⟨1, by omega⟩  -- d_r → u_r
  | 5 => some ⟨2, by omega⟩  -- d_g → u_g
  | 6 => some ⟨3, by omega⟩  -- d_b → u_b
  | _ => none

/-- Source index for the lowering operator T⁻. -/
def tMinusSource (s : JbarState) : Option JbarState :=
  match s.val with
  | 7 => some ⟨0, by omega⟩  -- ν → e
  | 1 => some ⟨4, by omega⟩  -- u_r → d_r
  | 2 => some ⟨5, by omega⟩  -- u_g → d_g
  | 3 => some ⟨6, by omega⟩  -- u_b → d_b
  | _ => none

/-! ## Raising operator T⁺ -/

/-- The linear map underlying T⁺. -/
noncomputable def tPlusLM : JbarWavefunction →ₗ[ℂ] JbarWavefunction where
  toFun := fun psi s =>
    match tPlusSource s with
    | some src => psi src
    | none => 0
  map_add' := fun x y => by ext s; simp [Pi.add_apply]; split <;> ring
  map_smul' := fun c x => by ext s; simp [Pi.smul_apply, smul_eq_mul]; split <;> ring

/-- The weak-isospin raising operator `T⁺` on `JbarWavefunction`. -/
noncomputable def TPlusEnd : JbarWavefunction →L[ℂ] JbarWavefunction where
  toLinearMap := tPlusLM
  cont := tPlusLM.continuous_of_finiteDimensional

/-! ## Lowering operator T⁻ -/

/-- The linear map underlying T⁻. -/
noncomputable def tMinusLM : JbarWavefunction →ₗ[ℂ] JbarWavefunction where
  toFun := fun psi s =>
    match tMinusSource s with
    | some src => psi src
    | none => 0
  map_add' := fun x y => by ext s; simp [Pi.add_apply]; split <;> ring
  map_smul' := fun c x => by ext s; simp [Pi.smul_apply, smul_eq_mul]; split <;> ring

/-- The weak-isospin lowering operator `T⁻` on `JbarWavefunction`. -/
noncomputable def TMinusEnd : JbarWavefunction →L[ℂ] JbarWavefunction where
  toLinearMap := tMinusLM
  cont := tMinusLM.continuous_of_finiteDimensional

/-! ## Apply lemmas -/

@[simp] theorem TPlusEnd_apply (psi : JbarWavefunction) (s : JbarState) :
    TPlusEnd psi s = match tPlusSource s with | some src => psi src | none => 0 :=
  rfl

@[simp] theorem TMinusEnd_apply (psi : JbarWavefunction) (s : JbarState) :
    TMinusEnd psi s = match tMinusSource s with | some src => psi src | none => 0 :=
  rfl

/-! ## Basis action theorems -/

theorem TPlusEnd_electron :
    TPlusEnd (JbarBasisState ⟨7, by omega⟩) = JbarBasisState ⟨0, by omega⟩ := by
  ext s; fin_cases s <;> simp +decide [ tPlusSource ] ;
  all_goals simp +decide [ JbarBasisState ] ;

theorem TMinusEnd_neutrino :
    TMinusEnd (JbarBasisState ⟨0, by omega⟩) = JbarBasisState ⟨7, by omega⟩ := by
  ext s; exact (by
  fin_cases s <;> rfl)

theorem TPlusEnd_dQuark (k : Fin 3) :
    TPlusEnd (JbarBasisState ⟨1 + k.val, by omega⟩) =
      JbarBasisState ⟨4 + k.val, by omega⟩ := by
  -- By definition of $TPlusEnd$, we know that $TPlusEnd (JbarBasisState ⟨1 + k.val, by omega⟩) = JbarBasisState ⟨4 + k.val, by omega⟩$.
  ext s; simp [TPlusEnd, JbarBasisState];
  fin_cases k <;> fin_cases s <;> rfl

theorem TMinusEnd_uQuark (k : Fin 3) :
    TMinusEnd (JbarBasisState ⟨4 + k.val, by omega⟩) =
      JbarBasisState ⟨1 + k.val, by omega⟩ := by
  -- By definition of JbarBasisState, we know that JbarBasisState ⟨4 + k, by omega⟩ is the function that is 1 at 4 + k and 0 elsewhere.
  have h_basis : ∀ s : JbarState, JbarBasisState ⟨4 + k, by omega⟩ s = if s = ⟨4 + k, by omega⟩ then 1 else 0 := by
    unfold JbarBasisState; aesop;
  ext s;
  fin_cases s <;> simp +decide [ TMinusEnd_apply, tMinusSource, JbarBasisState, h_basis ];
  all_goals fin_cases k <;> rfl;

/-! ## Annihilation theorems -/

theorem TPlusEnd_neutrino :
    TPlusEnd (JbarBasisState ⟨0, by omega⟩) = 0 := by
  ext s;
  fin_cases s <;> simp +decide [ tPlusSource, JbarBasisState, Pi.single_apply ]

theorem TPlusEnd_uQuark (k : Fin 3) :
    TPlusEnd (JbarBasisState ⟨4 + k.val, by omega⟩) = 0 := by
  -- By definition of TPlusEnd, we need to show that for any state s, TPlusEnd (JbarBasisState ⟨4 + k.val, by omega⟩) s = 0.
  ext s
  simp [TPlusEnd, JbarBasisState];
  fin_cases k <;> fin_cases s <;> rfl

theorem TMinusEnd_electron :
    TMinusEnd (JbarBasisState ⟨7, by omega⟩) = 0 := by
  ext s ; fin_cases s <;> rfl;

theorem TMinusEnd_dQuark (k : Fin 3) :
    TMinusEnd (JbarBasisState ⟨1 + k.val, by omega⟩) = 0 := by
  fin_cases k <;> ext s <;> fin_cases s <;> simp +decide [ TMinusEnd_apply, JbarBasisState, tMinusSource ]

/-! ## Commutator -/

/-- The commutator of two continuous linear endomorphisms. -/
noncomputable def endComm
    (A B : JbarWavefunction →L[ℂ] JbarWavefunction) :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  A.comp B - B.comp A

/-! ## su(2) commutation relations -/

theorem T3_comm_TPlus :
    endComm T3End TPlusEnd = TPlusEnd := by
  unfold endComm;
  unfold T3End;
  ext;
  rename_i s;
  fin_cases s <;> simp +decide [ tPlusSource, tMinusSource ];
  · unfold targetT3; norm_num;
    ring;
  · unfold targetT3; norm_num; ring;
  · unfold targetT3; norm_num; ring;
  · erw [ show targetT3 6 = 1 / 2 by rfl, show targetT3 3 = -1 / 2 by rfl ] ; norm_num ; ring

theorem T3_comm_TMinus :
    endComm T3End TMinusEnd = -TMinusEnd := by
  convert TPlusEnd_neutrino using 1;
  constructor <;> intro h <;> simp_all +decide [ endComm ];
  · convert TPlusEnd_neutrino using 1;
  · ext psi s;
    fin_cases s <;> simp +decide [ tMinusSource ];
    all_goals simp +decide [ T3End, TMinusEnd ];
    all_goals norm_cast;
    all_goals norm_num [ targetT3 ];
    all_goals unfold tMinusLM;
    all_goals ring!; all_goals exact?

theorem TPlus_comm_TMinus :
    endComm TPlusEnd TMinusEnd = (2 : ℂ) • T3End := by
  unfold endComm T3End;
  ext psi s;
  fin_cases s <;> simp +decide [ tPlusSource, tMinusSource ] <;> ring!;
  all_goals unfold targetT3; norm_num; ring;

/-! ## Hypercharge commutation -/

theorem Y_comm_TPlus :
    endComm targetYEnd TPlusEnd = 0 := by
  unfold endComm;
  ext psi s;
  cases s;
  rename_i k hk;
  interval_cases k <;> simp +decide [ tPlusSource, targetY ]; all_goals unfold physicalQ targetT3; norm_num;

theorem Y_comm_TMinus :
    endComm targetYEnd TMinusEnd = 0 := by
  ext psi s;
  fin_cases s <;> simp +decide [ Pi.single_apply ];
  all_goals unfold endComm; simp +decide [ Pi.single_apply, targetYEnd_apply, TMinusEnd_apply, tMinusSource ] ;
  · unfold targetY; ring;
    unfold physicalQ targetT3; norm_num; ring;
  · unfold targetY;
    unfold physicalQ targetT3; norm_num;
  · unfold targetY; norm_num;
    unfold physicalQ targetT3; norm_num;
  · unfold targetY; norm_num;
    unfold physicalQ targetT3; norm_num;

/-! ## Package -/

/-- Bundled package of weak-isospin ladder operator results. -/
structure FureyWeakIsospinLadderPackage where
  T3_comm_TPlus : endComm T3End TPlusEnd = TPlusEnd
  T3_comm_TMinus : endComm T3End TMinusEnd = -TMinusEnd
  TPlus_comm_TMinus : endComm TPlusEnd TMinusEnd = (2 : ℂ) • T3End
  Y_comm_TPlus : endComm targetYEnd TPlusEnd = 0
  Y_comm_TMinus : endComm targetYEnd TMinusEnd = 0

/-- The assembled weak-isospin ladder operator package. -/
noncomputable def fureyWeakIsospinLadderPackage :
    FureyWeakIsospinLadderPackage where
  T3_comm_TPlus := T3_comm_TPlus
  T3_comm_TMinus := T3_comm_TMinus
  TPlus_comm_TMinus := TPlus_comm_TMinus
  Y_comm_TPlus := Y_comm_TPlus
  Y_comm_TMinus := Y_comm_TMinus

end PhysicsSM.Algebra.Furey.WeakIsospinLadder
