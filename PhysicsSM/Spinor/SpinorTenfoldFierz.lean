import Mathlib
import PhysicsSM.Algebra.Jordan.CayleyPlaneD5Chart
import PhysicsSM.Spinor.SpinorTenfoldGammaSymm
import PhysicsSM.Spinor.SpinorTenfoldFierzKernel

/-!
# Spinor.SpinorTenfoldFierz

The ten-dimensional Fierz identity in the concrete `Spin(10)` Fock model,
and the resulting unconditional affine-chart theorem for the Cayley-plane
`D₅` chart.

## Mathematical context

The headline theorems:

- `fierz_clifford` : for every positive-chirality spinor `ψ`,
  `q(ψ, ψ) · ψ = 0` — the identity that makes `D = 10` super-Yang-Mills
  supersymmetric (the `Γ^a_{(αβ} Γ_{a γ)δ} = 0` identity of dimensions
  3, 4, 6, 10).
- `sharpMap_graph_eq_zero_of_even` : the unconditional Proposition 1(b) of
  the research notes — the affine chart `ψ ↦ (1, ψ, q(ψ, ψ))` lands in the
  rank-one locus of the `D₅`-graded exceptional Jordan algebra. "The SUSY
  identity *is* the affine chart of the Cayley plane."

## Proof architecture

By trilinearity (`cliffordAction_gammaBilinear_tri`) the Fierz identity
reduces to the symmetrized identity on the `16³` even wedge-monomial triples;
an abstract symmetrization lemma (`triple_diag_eq_zero`, char-0) collapses the
diagonal cubic sum to that symmetrization. The basis-level identity is
transported from the integer mirror, where `gBasisZ_symm` (kernel `decide`,
trusted) collapses the six terms to twice the three-term cyclic combination
`fierzZ_three`, proved in `PhysicsSM.Spinor.SpinorTenfoldFierzKernel` by the
single-monomial closed form `termData_eq` plus a finite kernel `decide` on the
`(coeff, target)` data. No `native_decide` is used anywhere in the dependency
tree: `#print axioms fierz_clifford` lists only `propext`, `Classical.choice`,
`Quot.sound` (audited in `Scripts/check_axioms_spin10.lean`).

## Provenance

Proofs produced by the Aristotle proof agent in two stages: multilinear
reduction and main theorems (job `198550bc-ef58-4789-bda2-b7361cc6c3f7`, task
`AgentTasks/spin10-fierz-cayley-chart-aristotle-2026-06-09.md`), and the
kernel-clean enumeration replacing the original `native_decide` (job
`93e29d35-37f8-4c3c-bad7-02b5fca82612`, task
`AgentTasks/spin10-fierz-kernel-decide-aristotle-2026-06-10.md`); reviewed for
semantic alignment and promoted from the retired draft
`PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean`. The identity is
independently verified by `Scripts/oracle/validate_spinor_tenfold.py`.

Status: trusted — no `sorry`, no `axiom` (in particular no `native_decide`).
-/

namespace PhysicsSM.Spinor.SpinorTenfold

open PhysicsSM.Algebra.Jordan.CayleyPlaneD5
open Finset

/-- Basis-level symmetrized Fierz identity over even subsets, stated with the
cheap closed form `gBasisZ`.

Kernel-clean proof: by symmetry of `gBasisZ` (`gBasisZ_symm`) the six terms
collapse to twice the three-term cyclic combination `fierzZ_three`, which is
established in `PhysicsSM.Spinor.SpinorTenfoldFierzKernel` by a closed-form
single-monomial reduction (`termData_eq`) followed by a finite kernel `decide`
on the cheap `(coeff, target)` data (no `native_decide`). -/
theorem fierzZ_symmetrized :
    ∀ S T U : Finset (Fin 5), S.card % 2 = 0 → T.card % 2 = 0 → U.card % 2 = 0 →
      cliffordActionZ (gBasisZ S T) (basisZ U)
        + cliffordActionZ (gBasisZ S U) (basisZ T)
        + cliffordActionZ (gBasisZ T S) (basisZ U)
        + cliffordActionZ (gBasisZ T U) (basisZ S)
        + cliffordActionZ (gBasisZ U S) (basisZ T)
        + cliffordActionZ (gBasisZ U T) (basisZ S) = 0 := by
  intro S T U hS hT hU
  rw [gBasisZ_symm T S, gBasisZ_symm U S, gBasisZ_symm U T]
  have h := fierzZ_three S T U hS hT hU
  have key :
      cliffordActionZ (gBasisZ S T) (basisZ U)
        + cliffordActionZ (gBasisZ S U) (basisZ T)
        + cliffordActionZ (gBasisZ S T) (basisZ U)
        + cliffordActionZ (gBasisZ T U) (basisZ S)
        + cliffordActionZ (gBasisZ S U) (basisZ T)
        + cliffordActionZ (gBasisZ T U) (basisZ S)
      = (cliffordActionZ (gBasisZ S T) (basisZ U)
          + cliffordActionZ (gBasisZ S U) (basisZ T)
          + cliffordActionZ (gBasisZ T U) (basisZ S))
        + (cliffordActionZ (gBasisZ S T) (basisZ U)
          + cliffordActionZ (gBasisZ S U) (basisZ T)
          + cliffordActionZ (gBasisZ T U) (basisZ S)) := by abel
  rw [key, h, add_zero]

noncomputable section

/-! ## Transport of the basis-level Fierz identity to `ℂ` -/

/-- Each basis Fierz term equals the cast of its integer counterpart. -/
theorem F_cast (S T U : Finset (Fin 5)) :
    cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor T)) (basisSpinor U)
      = castS (cliffordActionZ (gBasisZ S T) (basisZ U)) := by
  rw [gBasisZ_eq S T, cliffordActionZ_cast, gammaBilinearZ_cast, castS_basisZ,
    castS_basisZ, castS_basisZ]

/-- Basis-level symmetrized Fierz identity over even subsets, in `ℂ`. -/
theorem fierz_basis_symmetrized (S T U : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) (hU : U.card % 2 = 0) :
    cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor T)) (basisSpinor U)
      + cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor U)) (basisSpinor T)
      + cliffordAction (gammaBilinear (basisSpinor T) (basisSpinor S)) (basisSpinor U)
      + cliffordAction (gammaBilinear (basisSpinor T) (basisSpinor U)) (basisSpinor S)
      + cliffordAction (gammaBilinear (basisSpinor U) (basisSpinor S)) (basisSpinor T)
      + cliffordAction (gammaBilinear (basisSpinor U) (basisSpinor T)) (basisSpinor S) = 0 := by
  rw [F_cast, F_cast, F_cast, F_cast, F_cast, F_cast,
    ← castS_add, ← castS_add, ← castS_add, ← castS_add, ← castS_add,
    fierzZ_symmetrized S T U hS hT hU, castS_zero]

/-! ## The cubic expansion of the Fierz expression -/

/-- The cubic (trilinear) expansion of the Fierz expression in the basis. -/
theorem cliffordAction_gammaBilinear_tri (a b c : FockSpinor) :
    cliffordAction (gammaBilinear a b) c
      = ∑ S : Finset (Fin 5), ∑ T : Finset (Fin 5), ∑ U : Finset (Fin 5),
          (a S * b T * c U) •
            cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor T)) (basisSpinor U) := by
  rw [gammaBilinear_expand a b, cliffordAction_sum_vec]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [cliffordAction_sum_vec]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [cliffordAction_smul_vec]
  conv_lhs => rw [spinor_eq_sum_basis c]
  rw [cliffordAction_sum_spinor, Finset.smul_sum]
  refine Finset.sum_congr rfl fun U _ => ?_
  rw [cliffordAction_smul_spinor, smul_smul]

/-- The cubic expansion of the Fierz expression in the basis. -/
theorem cliffordAction_gammaBilinear_expand (ψ : FockSpinor) :
    cliffordAction (gammaBilinear ψ ψ) ψ
      = ∑ S : Finset (Fin 5), ∑ T : Finset (Fin 5), ∑ U : Finset (Fin 5),
          (ψ S * ψ T * ψ U) •
            cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor T)) (basisSpinor U) :=
  cliffordAction_gammaBilinear_tri ψ ψ ψ

/-! ## The abstract symmetrization lemma -/

/-- If a triple-indexed family `F` over a finite type, weighted by a symmetric
product `c a * c b * c d`, has vanishing full symmetrization for every triple,
then the diagonal triple sum vanishes. -/
theorem triple_diag_eq_zero {ι : Type*} [Fintype ι] {M : Type*}
    [AddCommGroup M] [Module ℂ M] (c : ι → ℂ) (F : ι → ι → ι → M)
    (hsym : ∀ a b d : ι, (c a * c b * c d) •
        (F a b d + F a d b + F b a d + F b d a + F d a b + F d b a) = 0) :
    ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d = 0 := by
  -- Reindex each of the six orderings of `F` to the canonical diagonal sum.
  have h_zero : ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a d b
      = ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d :=
    Finset.sum_congr rfl fun _ _ =>
      Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by module)
  have h_zero' : ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F b a d
      = ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d :=
    Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by module)
  have h_zero'' : ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F b d a
      = ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d := by
    rw [Finset.sum_comm]
    exact Finset.sum_congr rfl fun _ _ =>
      Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by module)
  have h_zero''' : ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F d a b
      = ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d := by
    convert h_zero'' using 1
    rw [Finset.sum_comm]
    exact Finset.sum_congr rfl fun _ _ =>
      Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by module)
  have h_zero'''' : ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F d b a
      = ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d := by
    convert h_zero'' using 1
    exact Finset.sum_congr rfl fun _ _ =>
      Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by module)
  have h_final : (6 : ℂ) • (∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d) = 0 := by
    have h_expand : ∑ a, ∑ b, ∑ d, (c a * c b * c d) •
          (F a b d + F a d b + F b a d + F b d a + F d a b + F d b a)
        = (6 : ℂ) • (∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d) := by
      simp only [smul_add, Finset.sum_add_distrib, h_zero, h_zero', h_zero'',
        h_zero''', h_zero'''']
      module
    rw [← h_expand]
    exact Finset.sum_eq_zero fun a _ =>
      Finset.sum_eq_zero fun b _ =>
        Finset.sum_eq_zero fun d _ => hsym a b d
  have h6 : (6 : ℂ) ≠ 0 := by norm_num
  calc ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d
      = (6 : ℂ)⁻¹ • ((6 : ℂ) • ∑ a, ∑ b, ∑ d, (c a * c b * c d) • F a b d) :=
        (inv_smul_smul₀ h6 _).symm
    _ = (6 : ℂ)⁻¹ • 0 := by rw [h_final]
    _ = 0 := smul_zero _

/-! ## Main theorems -/

/-- **The ten-dimensional Fierz identity** in the Fock model: for every
positive-chirality spinor, `q(ψ, ψ) · ψ = 0`. -/
theorem fierz_clifford
    {psi : FockSpinor} (hpsi : IsEvenSpinor psi) :
    cliffordAction (gammaBilinear psi psi) psi = 0 := by
  rw [cliffordAction_gammaBilinear_expand]
  apply triple_diag_eq_zero
    (c := psi)
    (F := fun S T U =>
      cliffordAction (gammaBilinear (basisSpinor S) (basisSpinor T)) (basisSpinor U))
  intro a b d
  by_cases ha : a.card % 2 = 0
  · by_cases hb : b.card % 2 = 0
    · by_cases hd : d.card % 2 = 0
      · rw [fierz_basis_symmetrized a b d ha hb hd, smul_zero]
      · have : psi d = 0 := hpsi d (by omega)
        rw [this]; simp
    · have : psi b = 0 := hpsi b (by omega)
      rw [this]; simp
  · have : psi a = 0 := hpsi a (by omega)
    rw [this]; simp

/-- The vector `q(psi, psi)` is isotropic for every even spinor. -/
theorem Q10_gammaBilinear_self_eq_zero
    {psi : FockSpinor} (hpsi : IsEvenSpinor psi) :
    Q10 (gammaBilinear psi psi) = 0 :=
  Q10_gammaBilinear_eq_zero_of_clifford (fierz_clifford hpsi)

/-- **Unconditional Proposition 1(b)**: every positive-chirality spinor maps
to a rank-one point `(1, ψ, q(ψ, ψ))` in the `D₅` chart — the affine chart of
the complex Cayley plane is the graph of the gamma-bilinear square, and the
`D = 10` SUSY identity is exactly the equation defining that chart. -/
theorem sharpMap_graph_eq_zero_of_even
    {psi : FockSpinor} (hpsi : IsEvenSpinor psi) :
    sharpMap ((1 : Complex), psi, gammaBilinear psi psi) = 0 :=
  sharpMap_graph_eq_zero (fierz_clifford hpsi)

end

end PhysicsSM.Spinor.SpinorTenfold
