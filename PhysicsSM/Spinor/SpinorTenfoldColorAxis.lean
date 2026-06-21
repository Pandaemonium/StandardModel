import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldPurity
import PhysicsSM.Spinor.SpinorTenfoldCAR

/-!
# Spinor.SpinorTenfoldColorAxis

The color axis of the normal-form Krasnov pair: the common annihilator of
`(vacuumSpinor, weakSpinor)` is a 3-dimensional complex subspace — the
color `ℂ³`.

## Mathematical context

For the concrete `d = 3` Krasnov pair of `PhysicsSM.Spinor.SpinorTenfoldPurity`
(`ψ₁ = 1`, `ψ₂ = e₃ ∧ e₄`), the associated maximal isotropic subspaces are

- `N₁ = annihilator vacuumSpinor = ⟨f₀, f₁, f₂, f₃, f₄⟩` (dimension 5),
- `N₂ = annihilator weakSpinor = ⟨e₃, e₄, f₀, f₁, f₂⟩`,
- `N₁ ∩ N₂ = ⟨f₀, f₁, f₂⟩ ≅ ℂ³` (dimension 3).

In the research notes this is "the axis of the pencil is color `ℂ³`": the line
on the spinor tenfold through the two marked pure spinors is classified by the
isotropic 3-plane `N₁ ∩ N₂`, on which the Standard Model stabilizer acts by
its color factor. The matching hypercharge bookkeeping is in
`PhysicsSM.StandardModel.SpinorFockHypercharge` (indices `{0,1,2}` are the
color directions).

This module also records that annihilators of nonzero spinors are isotropic
for `Q10` (a corollary of the Clifford relation of
`PhysicsSM.Spinor.SpinorTenfoldCAR`), so `N₁` really is *maximal* isotropic:
an isotropic subspace of dimension 5 in a 10-dimensional quadratic space.

## Provenance

The annihilator characterizations and the `ℂ³` linear equivalence were proved
by the Aristotle proof agent (job `88884ecb-60f8-41fb-8be0-8977a7da86c9`, task
`AgentTasks/spin10-color-axis-aristotle-2026-06-09.md`) and reviewed for
semantic alignment; the result was a x i o m-clean and is integrated verbatim from
the handoff file `PhysicsSM/Draft/SpinorTenfoldColorAxisAristotle.lean` (now
retired). The isotropy corollary, the vacuum-annihilator dimension count, and
the `finrank` corollaries were added during integration.

Status: trusted — no `s o r r y`, no `a x i o m` (in particular no `n a t i v e _ d e c i d e`).
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

/-! ## Isotropy of annihilators

The Clifford relation forces every annihilator vector of a nonzero spinor to
be `Q10`-null: `0 = v · (v · ψ) = Q10 v • ψ`. -/

/-- The annihilator of a nonzero spinor is isotropic for `Q10`. -/
theorem Q10_eq_zero_of_mem_annihilator {ψ : FockSpinor} (hψ : ψ ≠ 0)
    {v : V10} (hv : v ∈ annihilator ψ) : Q10 v = 0 := by
  have h := cliffordAction_cliffordAction_self v ψ
  rw [mem_annihilator.mp hv, cliffordAction_zero_spinor] at h
  rcases smul_eq_zero.mp h.symm with h' | h'
  · exact h'
  · exact absurd h' hψ

/-! ## Coordinate characterizations of the witness annihilators -/

/-- The expected coordinate predicate for the annihilator of `weakSpinor`.
It is the span of `e_3`, `e_4`, `f_0`, `f_1`, `f_2`. -/
def IsWeakSpinorAnnihilatorVector (v : V10) : Prop :=
  (∀ i : Fin 5, (i : Nat) < 3 → v.1 i = 0)
    ∧ v.2 ⟨3, by decide⟩ = 0
    ∧ v.2 ⟨4, by decide⟩ = 0

/-- The expected coordinate predicate for the color axis
`N_vacuum ∩ N_weak = span(f_0, f_1, f_2)`. -/
def IsColorAxisVector (v : V10) : Prop :=
  v.1 = 0
    ∧ v.2 ⟨3, by decide⟩ = 0
    ∧ v.2 ⟨4, by decide⟩ = 0

/-- Coordinate characterization of the annihilator of the second marked
spinor `weakSpinor = e_3 ∧ e_4`. -/
theorem mem_annihilator_weakSpinor_iff (v : V10) :
    v ∈ annihilator weakSpinor ↔ IsWeakSpinorAnnihilatorVector v := by
  constructor <;> intro h <;> simp_all +decide [ annihilator, IsWeakSpinorAnnihilatorVector ];
  · have := congr_fun h { 0, 3, 4 } ; ( have := congr_fun h { 1, 3, 4 } ; ( have := congr_fun h { 2, 3, 4 } ; ( have := congr_fun h { 3 } ; ( have := congr_fun h { 4 } ; simp_all +decide [ Fin.sum_univ_succ, cliffordAction ] ; ) ) ) );
    simp_all +decide [ Fin.forall_fin_succ, wedge, contract, weakSpinor ];
    simp_all +decide [ Finset.card, opSign, basisSpinor ];
  · ext S; simp [cliffordAction, h];
    simp_all +decide [ Fin.sum_univ_five, wedge, contract, weakSpinor ];
    fin_cases S <;> simp +decide [ *, basisSpinor ]

/-- Coordinate characterization of the common annihilator: the color axis. -/
theorem mem_colorAxis_iff (v : V10) :
    v ∈ annihilator vacuumSpinor ⊓ annihilator weakSpinor
      ↔ IsColorAxisVector v := by
  constructor <;> intro h <;> simp_all +decide [ mem_annihilator_vacuumSpinor_iff, mem_annihilator_weakSpinor_iff, IsColorAxisVector, IsWeakSpinorAnnihilatorVector ]

/-! ## The color axis is `ℂ³` -/

/-- The common annihilator of the marked pure-spinor pair: the **color axis**
of the Krasnov configuration. -/
abbrev colorAxisSubmodule : Submodule Complex V10 :=
  annihilator vacuumSpinor ⊓ annihilator weakSpinor

/-- The underlying vector built from a `ℂ³` coordinate triple: the second
(annihilation) component supported on the color indices `{0,1,2}`. -/
def colorAxisInvFun (c : Fin 3 → Complex) : V10 :=
  (0, fun i => if h : (i : Nat) < 3 then c ⟨i, h⟩ else 0)

theorem colorAxisInvFun_mem (c : Fin 3 → Complex) :
    colorAxisInvFun c ∈ colorAxisSubmodule := by
  constructor;
  · exact mem_annihilator_vacuumSpinor_iff _ |>.2 rfl;
  · exact mem_annihilator_weakSpinor_iff _ |>.2 ⟨ by tauto, by tauto, by tauto ⟩

theorem colorAxisInvFun_add (c d : Fin 3 → Complex) :
    colorAxisInvFun (c + d) = colorAxisInvFun c + colorAxisInvFun d := by
  -- Both components agree: use `funext` on `i` and split on `(i : Nat) < 3`.
  simp [colorAxisInvFun, Prod.ext_iff, Pi.add_apply];
  ext i; aesop;

theorem colorAxisInvFun_smul (a : Complex) (c : Fin 3 → Complex) :
    colorAxisInvFun (a • c) = a • colorAxisInvFun c := by
  unfold colorAxisInvFun; ext i; simp +decide [ mul_comm ] ;
  fin_cases i <;> simp +decide [ Pi.smul_apply ]

/-- Forward map: read off the three color coordinates `v.2 0, v.2 1, v.2 2`. -/
def colorAxisToC3 : colorAxisSubmodule →ₗ[Complex] (Fin 3 → Complex) where
  toFun v := fun j => (v : V10).2 ⟨j, by omega⟩
  map_add' x y := rfl
  map_smul' a x := rfl

/-- Inverse map: build the color-axis vector from a `ℂ³` triple. -/
def colorAxisFromC3 : (Fin 3 → Complex) →ₗ[Complex] colorAxisSubmodule where
  toFun c := ⟨colorAxisInvFun c, colorAxisInvFun_mem c⟩
  map_add' c d := Subtype.ext (colorAxisInvFun_add c d)
  map_smul' a c := Subtype.ext (colorAxisInvFun_smul a c)

theorem colorAxis_left_inv (v : colorAxisSubmodule) :
    colorAxisFromC3 (colorAxisToC3 v) = v := by
  refine Subtype.ext (Prod.ext ?_ ?_)
  · convert mem_annihilator_vacuumSpinor_iff _ |>.mp v.2.1 |> Eq.symm using 1
  · ext i
    simp only [colorAxisFromC3, colorAxisToC3, LinearMap.coe_mk, AddHom.coe_mk]
    fin_cases i <;> simp +decide [colorAxisInvFun]
    · exact Eq.symm (mem_colorAxis_iff _ |>.1 v.2 |>.2.1)
    · exact Eq.symm (mem_annihilator_weakSpinor_iff _ |>.1 v.2.2 |>.2.2)

theorem colorAxis_right_inv (c : Fin 3 → Complex) :
    colorAxisToC3 (colorAxisFromC3 c) = c := by
  ext j; simp [colorAxisToC3, colorAxisFromC3, colorAxisInvFun]

/-- **The color axis is `ℂ³`**: the common annihilator of the marked
pure-spinor pair is linearly equivalent to `ℂ³`. This is the formal version of
"the axis of the pure-spinor pencil is color `ℂ³`". -/
noncomputable def colorAxisLinearEquivC3 :
    colorAxisSubmodule ≃ₗ[Complex] ((Fin 3) → Complex) :=
  LinearEquiv.ofLinear colorAxisToC3 colorAxisFromC3
    (LinearMap.ext colorAxis_right_inv) (LinearMap.ext colorAxis_left_inv)

/-- The color axis has complex dimension 3: the `d = 3` of the Standard Model
stratum of the orbit trichotomy. -/
theorem finrank_colorAxis : Module.finrank Complex colorAxisSubmodule = 3 := by
  rw [colorAxisLinearEquivC3.finrank_eq, Module.finrank_fin_fun]

/-! ## The vacuum annihilator is maximal isotropic -/

/-- Forward map: read off the annihilation-half coordinates of a vacuum
annihilator vector. -/
def vacuumAnnihilatorToC5 : annihilator vacuumSpinor →ₗ[Complex] (Fin 5 → Complex) where
  toFun v := (v : V10).2
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Inverse map: the annihilation half embeds in the vacuum annihilator. -/
def vacuumAnnihilatorFromC5 : (Fin 5 → Complex) →ₗ[Complex] annihilator vacuumSpinor where
  toFun b := ⟨((0 : Fin 5 → Complex), b), (mem_annihilator_vacuumSpinor_iff _).mpr rfl⟩
  map_add' c d := Subtype.ext (by simp [Prod.ext_iff])
  map_smul' a c := Subtype.ext (by simp [Prod.ext_iff])

theorem vacuumAnnihilator_left_inv (v : annihilator vacuumSpinor) :
    vacuumAnnihilatorFromC5 (vacuumAnnihilatorToC5 v) = v :=
  Subtype.ext (Prod.ext ((mem_annihilator_vacuumSpinor_iff _).mp v.2).symm rfl)

/-- The vacuum annihilator `N₁ = ⟨f₀, …, f₄⟩` is linearly equivalent to `ℂ⁵`. -/
noncomputable def vacuumAnnihilatorLinearEquivC5 :
    annihilator vacuumSpinor ≃ₗ[Complex] (Fin 5 → Complex) :=
  LinearEquiv.ofLinear vacuumAnnihilatorToC5 vacuumAnnihilatorFromC5
    (LinearMap.ext fun _ => rfl) (LinearMap.ext vacuumAnnihilator_left_inv)

/-- `N₁` has complex dimension 5: together with
`Q10_eq_zero_of_mem_annihilator` it is a *maximal* isotropic subspace of the
10-dimensional quadratic space `(V10, Q10)`. -/
theorem finrank_annihilator_vacuumSpinor :
    Module.finrank Complex (annihilator vacuumSpinor) = 5 := by
  rw [vacuumAnnihilatorLinearEquivC5.finrank_eq, Module.finrank_fin_fun]

end PhysicsSM.Spinor.SpinorTenfold

end
