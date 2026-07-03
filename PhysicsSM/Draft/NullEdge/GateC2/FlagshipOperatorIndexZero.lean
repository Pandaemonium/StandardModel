import PhysicsSM.Draft.NullEdge.GateC2.FlagshipOperatorIndex
import PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexDensity

/-!
# Gate C2: the free tetrahedral chiral OPERATOR index is exactly ZERO

This Draft module computes the VALUE of the flagship operator overlap index.
`FlagshipOperatorIndex.flagship_operatorIndex_isInteger` proved the index of the
free tetrahedral chiral operator is an integer; here we pin it to `0`
(`flagship_operatorIndex_eq_zero`), for traceless chirality throughout the first
Wilson band - the OPERATOR-level free-index-zero benchmark, the exact-value
companion of the symbol-level `TetraFreeIndexZero.tetraFreeOverlapIndex_eq_zero`.

## Mechanism (trace = sum of the kernel diagonal)

The endomorphism trace of the bundled operator sign is the site-sum of the
spin-traces of its position-space kernel diagonal,

    Tr signHfreeL = sum_x Tr_spin K(x, x)          (`trace_signHfreeL`),

proved with the product basis (`Pi.basis` of `Pi.basisFun`) and the kernel
representation `TetraFreeIndexDensity.signHfree_apply_eq_kernel_sum`.  Each
diagonal block has zero spin-trace (`signKernel_diag` + per-momentum
`trace_signSymbol_eq_zero`), so `Tr signHfreeL = 0`.  Similarly
`Tr Gamma5opL = card . Tr gamma5 = 0` for traceless chirality
(`trace_Gamma5opL`).  Hence the operator index `(1/2)(Tr Gamma5opL -
Tr signHfreeL) = 0`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (free operator index value; regulator-level,
no gauge).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace FlagshipOperatorIndexZero

open PhysicsSM.Draft.NullEdge.GateC1.TetraFiniteTorusEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol
open PhysicsSM.Draft.NullEdge.GateC1.TetraQMatrixSquareExact
open PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
open PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator
open PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorOverlapGW
open PhysicsSM.Draft.NullEdge.GateC2.FlagshipOperatorIndex
open PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexDensity
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEndIntegrality

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The endomorphism trace of an operator given by field-kernel action, computed
in the product basis: the trace is the site-sum of the spin-traces of the kernel
diagonal blocks.  Stated for `signHfreeL` via its kernel representation. -/
theorem trace_signHfreeL (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) :
    LinearMap.trace ℂ (SiteN N → Spin → ℂ) (signHfreeL N gamma5 D a r rho)
      = ∑ x : SiteN N, (signKernel N gamma5 D a r rho x x).trace := by
  classical
  set b : Module.Basis ((_ : SiteN N) × Spin) ℂ (SiteN N → Spin → ℂ) :=
    Pi.basis (fun _ : SiteN N => Pi.basisFun ℂ Spin) with hb
  rw [LinearMap.trace_eq_matrix_trace ℂ b]
  rw [Matrix.trace]
  rw [show (Finset.univ : Finset ((_ : SiteN N) × Spin))
      = Finset.univ.sigma fun _ => Finset.univ from (Finset.univ_sigma_univ).symm,
    Finset.sum_sigma]
  apply Finset.sum_congr rfl
  intro x _
  -- Reduce each diagonal entry of the matrix of the operator to a kernel entry.
  have hentry : ∀ s : Spin,
      (LinearMap.toMatrix b b (signHfreeL N gamma5 D a r rho)) ⟨x, s⟩ ⟨x, s⟩
        = signKernel N gamma5 D a r rho x x s s := by
    intro s
    rw [LinearMap.toMatrix_apply, hb, Pi.basis_repr, Pi.basis_apply,
      Pi.basisFun_repr, Pi.basisFun_apply]
    -- The operator applied to the delta field, evaluated at (x, s).
    show signHfree N gamma5 D a r rho (Pi.single x (Pi.single s 1)) x s
      = signKernel N gamma5 D a r rho x x s s
    rw [signHfree_apply_eq_kernel_sum]
    rw [Finset.sum_apply]
    rw [Finset.sum_eq_single x
      (fun y _ hyx => by
        rw [Pi.single_eq_of_ne hyx, Matrix.mulVec_zero]; rfl)
      (fun hx => absurd (Finset.mem_univ x) hx)]
    rw [Pi.single_eq_same, Matrix.mulVec_single_one]
    rfl
  simp only [Matrix.diag_apply, hentry]
  rfl

/-- The endomorphism trace of the bundled chirality is `card . Tr gamma5`. -/
theorem trace_Gamma5opL (gamma5 : Matrix Spin Spin ℂ) :
    LinearMap.trace ℂ (SiteN N → Spin → ℂ) (Gamma5opL N gamma5)
      = (Fintype.card (SiteN N) : ℂ) * gamma5.trace := by
  classical
  set b : Module.Basis ((_ : SiteN N) × Spin) ℂ (SiteN N → Spin → ℂ) :=
    Pi.basis (fun _ : SiteN N => Pi.basisFun ℂ Spin) with hb
  rw [LinearMap.trace_eq_matrix_trace ℂ b]
  rw [Matrix.trace]
  rw [show (Finset.univ : Finset ((_ : SiteN N) × Spin))
      = Finset.univ.sigma fun _ => Finset.univ from (Finset.univ_sigma_univ).symm,
    Finset.sum_sigma]
  have hentry : ∀ (x : SiteN N) (s : Spin),
      (LinearMap.toMatrix b b (Gamma5opL N gamma5)) ⟨x, s⟩ ⟨x, s⟩
        = gamma5 s s := by
    intro x s
    rw [LinearMap.toMatrix_apply, hb, Pi.basis_repr, Pi.basis_apply,
      Pi.basisFun_repr, Pi.basisFun_apply]
    show matrixFieldAction N gamma5 (Pi.single x (Pi.single s 1)) x s = gamma5 s s
    unfold matrixFieldAction
    rw [Pi.single_eq_same, Matrix.mulVec_single_one]
    rfl
  have : ∀ x : SiteN N, ∑ s : Spin,
      (LinearMap.toMatrix b b (Gamma5opL N gamma5)).diag ⟨x, s⟩ = gamma5.trace := by
    intro x
    simp only [Matrix.diag_apply, hentry]
    rfl
  rw [Finset.sum_congr rfl (fun x _ => this x), Finset.sum_const,
    Finset.card_univ, nsmul_eq_mul]

/-- Each kernel diagonal block has zero spin-trace (traceless chirality). -/
theorem trace_signKernel_diag_eq_zero (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hg5tr : gamma5.trace = 0) (x : SiteN N) :
    (signKernel N gamma5 D a r rho x x).trace = 0 := by
  rw [signKernel_diag, Matrix.trace_smul, Matrix.trace_sum,
    Finset.sum_eq_zero (fun m _ =>
      trace_signSymbol_eq_zero gamma5 D a r rho (kOfMom N m) (hanti m) hg5tr),
    smul_zero]

/-- **The free tetrahedral chiral OPERATOR index is exactly ZERO** (traceless
chirality, first Wilson band).  The exact-value companion of
`flagship_operatorIndex_isInteger`: the free operator carries no topology.  This
is the operator-level free benchmark that a genuine gauge background (the open C2
frontier) must defeat. -/
theorem flagship_operatorIndex_eq_zero (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hg5tr : gamma5.trace = 0) :
    overlapIndexEnd (Gamma5opL N gamma5) (signHfreeL N gamma5 D a r rho) = 0 := by
  unfold overlapIndexEnd
  rw [trace_Gamma5opL, trace_signHfreeL,
    Finset.sum_eq_zero (fun x _ =>
      trace_signKernel_diag_eq_zero N gamma5 D a r rho hanti hg5tr x),
    hg5tr]
  ring

end FlagshipOperatorIndexZero
end GateC2
end NullEdge
end Draft
end PhysicsSM
