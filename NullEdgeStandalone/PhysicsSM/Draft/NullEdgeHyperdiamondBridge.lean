import PhysicsSM.Draft.NullEdgeHyperdiamondNoGo
import PhysicsSM.NullStrand.DualSolder.DualSolderSymbolKinetic

/-!
# Hyperdiamond bridge: dual-soldered frame to Gate C symbol

This module records the exact bridge content between two already-formalized
layers:

* the concrete dual-soldered tetrahedral frame in
  `PhysicsSM.NullStrand.DualSolder`;
* the Gate C high-momentum bare Clifford symbol in
  `PhysicsSM.Draft.NullEdgeActualCliffordSymbol` and
  `PhysicsSM.Draft.TetrahedralNullBranch`.

The bridge is intentionally limited. It proves an exact frame/convention
identity and a shared principal-symbol-square contract. It does not prove an
operator-level equivalence with Borici-Creutz or any named hyperdiamond
finite-difference operator, because no such operator is defined here. It also
does not add any physical release clause.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeHyperdiamondBridge

open Matrix
open Finset
open PhysicsSM.Draft.TetrahedralNullBranch
open PhysicsSM.Draft.NullEdgeActualCliffordSymbol
open PhysicsSM.Draft.NullEdgeFlavoredChirality
open PhysicsSM.Draft.NullEdgeHyperdiamondNoGo

/-! ## Exact frame crosswalk -/

/-- The Gate C tetrahedral dual frame is the complexification of the
dual-soldered tetrahedral frame, entry by entry. The two spellings differ only
by the identity `sqrt 3 / 4 = (3 / 4) / sqrt 3`. -/
theorem hyperdiamond_crosswalk_exact (a mu : Fin 4) :
    PhysicsSM.Draft.TetrahedralNullBranch.alpha a mu
      = ((PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha a mu : Real) : Complex) := by
  have h : (Real.sqrt 3 : Complex) * Real.sqrt 3 = 3 := by
    rw [<- Complex.ofReal_mul, Real.mul_self_sqrt (by norm_num)]
    norm_num
  have hne : (Real.sqrt 3 : Complex) ≠ 0 := by
    exact_mod_cast (Real.sqrt_pos.mpr (by norm_num : (0 : Real) < 3)).ne'
  simp [alpha, NullStrand.DualSolder.Tetrahedron.alpha]
  fin_cases a <;> fin_cases mu <;> simp +decide [sVec]
  all_goals rw [NullStrand.DualSolder.Tetrahedron.r3, eq_div_iff hne]
  all_goals first
    | linear_combination (1 / 4 : Complex) * h
    | linear_combination (-(1 / 4) : Complex) * h

/-! ## The dual-soldered covector as the Gate C covector -/

/-- The real dual-soldered tetrahedral covector with coefficients `lam`,
namely `sum_a lam a * alpha^a`. -/
def tetraCovector (lam : Fin 4 -> Real) (mu : Fin 4) : Real :=
  Finset.univ.sum fun a => lam a * PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha a mu

/-- For real coefficients, the Gate C symbol covector is exactly the
complexification of the dual-soldered tetrahedral covector. The same theorem
also records the concrete Gate C matrix symbol-square law. -/
theorem dualSolder_symbol_matches_gateC_symbol (lam : Fin 4 -> Real) :
    (forall mu, pCov (fun a => (lam a : Complex)) mu = ((tetraCovector lam mu : Real) : Complex)) /\
    cliffordSymbol (pCov (fun a => (lam a : Complex)))
        * cliffordSymbol (pCov (fun a => (lam a : Complex)))
      = (qform (fun a => (lam a : Complex))) • (1 : CMat4) := by
  refine ⟨fun mu => ?_, ?_⟩
  · simp only [pCov, tetraCovector, Complex.ofReal_sum]
    exact Finset.sum_congr rfl fun a _ => by
      rw [hyperdiamond_crosswalk_exact, Complex.ofReal_mul]
  · rw [cliffordSymbol_sq, pSq_mink_eq_qform]

/-! ## Shared principal-symbol-square law -/

/-- Gate C symbol square equals the kinetic quadratic form. This is the Gate C
matrix analogue of `NullSolderFrame.dualSymbol_sq`. -/
theorem gateC_symbol_sq_kinetic (u : Fin 4 -> Complex) :
    cliffordSymbol (pCov u) * cliffordSymbol (pCov u) = (qform u) • (1 : CMat4) := by
  rw [cliffordSymbol_sq, pSq_mink_eq_qform]

/-- Shared contract: the abstract dual-soldered symbol squares to `Q` of its
soldered covector, while the Gate C matrix symbol squares to the Minkowski
quadratic form of its soldered covector. -/
theorem dualSolder_and_gateC_share_square_law
    {V : Type*} [AddCommGroup V] [Module Real V]
    (F : PhysicsSM.NullStrand.DualSolder.NullSolderFrame V) (lam : Fin 4 -> Real)
    (u : Fin 4 -> Complex) :
    F.dualSymbol lam ^ 2 = (F.Q (F.dualCovector lam)) • (1 : CliffordAlgebra F.Q) /\
    cliffordSymbol (pCov u) * cliffordSymbol (pCov u) = (mink (pCov u)) • (1 : CMat4) :=
  ⟨F.dualSymbol_sq lam, cliffordSymbol_sq (pCov u)⟩

/-! ## Nielsen-Ninomiya represented-data ledger -/

/-- Represented finite lattice-fermion data only.

This theorem bundles the pieces that are actually backed by Lean theorems in
this standalone package: Brillouin-corner classification, Clifford
symbol-square law, balanced-kernel bare-symbol no-go, tetrahedral
biorthogonality, and tetrahedral resolution of identity.

It is not an instance of the Nielsen-Ninomiya theorem. Locality/finite range,
Hermiticity or Krein self-adjointness for this operator, exact chiral symmetry
as an operator identity, topological index/anomaly transport/continuum limit,
and gauge covariance are not represented here. -/
theorem nielsenNinomiya_assumption_ledger :
    (univ.filter fun s : Fin 4 -> Bool => cornerCount s = 0).card = 1 /\
    (univ.filter fun s : Fin 4 -> Bool => cornerCount s = 3).card = 4 /\
    (univ.filter fun s : Fin 4 -> Bool =>
      cornerCount s = 1 \/ cornerCount s = 2).card = 10 /\
    (univ.filter fun s : Fin 4 -> Bool => cornerCount s = 4).card = 1 /\
    (forall p : Fin 4 -> Complex, cliffordSymbol p * cliffordSymbol p = (mink p) • (1 : CMat4)) /\
    (Not (exists eps : Fin 4 -> Complex, BareOperatorAssignsSingleSign eps)) /\
    (forall A B : Fin 4,
      PhysicsSM.NullStrand.DualSolder.Tetrahedron.dualPair
          (PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha A)
          (PhysicsSM.NullStrand.DualSolder.Tetrahedron.ell B)
        = if A = B then 1 else 0) /\
    (forall mu nu : Fin 4,
      (Finset.univ.sum fun a => PhysicsSM.NullStrand.DualSolder.Tetrahedron.ell a mu
              * PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha a nu)
        = if mu = nu then 1 else 0) :=
  ⟨count_origin, count_highMomentumNull, count_spacelike, count_timelike,
    cliffordSymbol_sq, no_full_symbol_single_chirality,
    PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha_ell_delta,
    PhysicsSM.NullStrand.DualSolder.Tetrahedron.tetra_resolution_id⟩

/-! ## `chiralProj` structural audit -/

/-- `chiralProj` is an idempotent projector. This supports only the sufficiency
reading of `chiralProj_forces_alignment`: if this extra projector is supplied,
it selects one chirality sign. It is not physical projected-operator data,
because locality, gauge covariance, Krein sign, and operator-derived branch data
are not provided by the current definition. -/
theorem chiralProj_idempotent (a : Fin 4) (v : Spin -> Complex) :
    chiralProj a (chiralProj a v) = chiralProj a v := by
  rw [chiralProj_on_eigen a (chiralProj a v) ((g5 a : Real) : Complex) (gamma5_chiralProj a v)]
  have h : ((1 / 2 : Complex) * (1 + ((g5 a : Real) : Complex) * ((g5 a : Real) : Complex))) = 1 := by
    rw [g5_sq_one]
    ring
  rw [h, one_smul]

end PhysicsSM.Draft.NullEdgeHyperdiamondBridge
