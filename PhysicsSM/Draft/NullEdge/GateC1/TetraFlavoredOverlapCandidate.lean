import PhysicsSM.Draft.NullEdge.GateC1.TetraFlavoredOverlap

/-!
# Gate C1 explicit `W_branch` candidate and first finite branch-mass scan

This Draft module integrates the C277 Aristotle candidate against the production
`TetraFlavoredOverlap` and `TetraBranchWilsonSymbol` interfaces.

The candidate is a minimal directional-cosine flavored Wilson mass on
`Spin = Fin 4`:

```text
W_branch(k) = diag(mPhys(k), mMir(k), mMir(k), mMir(k))
            = mMir(k) I + (2 r cos(k_0) - 2 rho) E00.
```

It targets the non-origin branch `b* = (true,false,false,false)`.  At branch
corners the physical-component mass is

```text
branchMass(b) = 2 r d(b,b*) - rho.
```

Thus, in the first Wilson band `0 < rho < 2 r`, exactly the target branch is
negative and every other branch is positive.  This is a finite branch-mass
witness, not a full physical C1 release: gauge-covariant real-space realization,
locality of the sign function, Standard Model anomaly matching, and Krein/no-
ghost audits remain separate obligations.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFlavoredOverlapCandidate

open scoped BigOperators
open TetraFlavoredOverlap
open TetraBranchWilsonSymbol

/-- Chirality involution `gamma5 = diag(1,1,-1,-1)`. -/
def gamma5 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.diagonal (fun i => if i.val < 2 then 1 else -1)

/-- Balance involution `J = X tensor I` swapping `gamma5` partners `0<->2`,
`1<->3`. -/
def Jbalance : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of (fun i j => if (i.val + 2) % 4 = j.val then 1 else 0)

/-- Physical-component projector `E00 = diag(1,0,0,0)`. -/
def E00 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.diagonal (fun i => if i = 0 then 1 else 0)

/-- The target retained corner `b* = (true,false,false,false)`. -/
def candTarget : Branch := ![true, false, false, false]

/-- Standard Wilson radial `sum_A (1 - cos k_A)`. -/
def Rstd (k : Fin 4 -> ℝ) : ℝ :=
  ∑ A : Fin 4, (1 - Real.cos (k A))

/-- Reference-adapted radial `(1 + cos k_0) + sum_{A>=1} (1 - cos k_A)`. -/
def Rstar (k : Fin 4 -> ℝ) : ℝ :=
  (1 + Real.cos (k 0)) + (1 - Real.cos (k 1)) +
    (1 - Real.cos (k 2)) + (1 - Real.cos (k 3))

/-- Physical chiral mass `mPhys(k) = r * Rstar(k) - rho`. -/
def mPhys (r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  r * Rstar k - rho

/-- Mirror mass `mMir(k) = r * Rstd(k) + rho`. -/
def mMir (r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  r * Rstd k + rho

/-- Candidate flavored Wilson term
`W_branch(k) = diag(mPhys, mMir, mMir, mMir)`. -/
def Wcand (r rho : ℝ) (k : Fin 4 -> ℝ) : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.diagonal
    (fun i => if i = 0 then ((mPhys r rho k : ℝ) : ℂ)
      else ((mMir r rho k : ℝ) : ℂ))

/-- The candidate is Hermitian pointwise. -/
theorem Wcand_hermitian (r rho : ℝ) (k : Fin 4 -> ℝ) :
    star (Wcand r rho k) = Wcand r rho k := by
  unfold Wcand
  rw [Matrix.star_eq_conjTranspose, Matrix.diagonal_conjTranspose]
  congr 1
  funext i
  simp only [Pi.star_apply, RCLike.star_def, apply_ite (starRingEnd ℂ)]
  simp

/-- The candidate as production `BranchWilsonData`. -/
def BWcand (r rho : ℝ) : BranchWilsonData (Spin := Fin 4) :=
  { W := Wcand r rho
    W_hermitian := Wcand_hermitian r rho }

/-- Branch mass read off from the physical chiral component at the corner. -/
def branchMassCand (r rho : ℝ) : Branch -> ℝ :=
  fun b => mPhys r rho (branchMomentum b)

/-- Integer value of the physical spin-line chiral trace.  The theorem
`chiralTraceE00_cast` below ties this integer back to the matrix calculation
`(gamma5 * E00).trace = 1`. -/
def chiralTraceE00 : ℤ := 1

/-- Retained-branch chirality contribution for the finite scan.

The branch-mass scan only retains one branch; the spin-line contribution is the
checked chiral trace of the physical island projector `E00`, recorded by
`chiralTraceE00_cast`. -/
def chiralityCand : Branch -> ℤ :=
  fun _ => chiralTraceE00

/-- Hamming distance to the target corner. -/
def distToTarget (b : Branch) : ℕ :=
  ∑ A : Fin 4, (if b A = candTarget A then 0 else 1)

/-- At corners, `Rstar` is twice the Hamming distance to the target corner. -/
theorem Rstar_branchMomentum (b : Branch) :
    Rstar (branchMomentum b) = 2 * (distToTarget b : ℝ) := by
  simp only [Rstar, branchMomentum, distToTarget, candTarget, Fin.sum_univ_four,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.cons_val_three, Matrix.tail_cons]
  rcases b 0 with _ | _ <;> rcases b 1 with _ | _ <;> rcases b 2 with _ | _ <;>
    rcases b 3 with _ | _ <;> simp [Real.cos_pi, Real.cos_zero] <;> norm_num

/-- Corner branch mass equals `2 r d(b,b*) - rho`. -/
theorem branchMassCand_eq (r rho : ℝ) (b : Branch) :
    branchMassCand r rho b = 2 * r * (distToTarget b : ℝ) - rho := by
  unfold branchMassCand mPhys
  rw [Rstar_branchMomentum]
  ring

/-- Zero Hamming distance is equality with the target branch. -/
theorem distToTarget_eq_zero_iff (b : Branch) :
    distToTarget b = 0 <-> b = candTarget := by
  simp only [distToTarget, candTarget, Fin.sum_univ_four, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.cons_val_three, Matrix.tail_cons]
  constructor
  · intro h
    funext A
    fin_cases A <;>
      (rcases hb0 : b 0 with _ | _ <;> rcases hb1 : b 1 with _ | _ <;>
        rcases hb2 : b 2 with _ | _ <;> rcases hb3 : b 3 with _ | _ <;> simp_all)
  · intro h
    subst h
    decide

/-- Non-target branches have positive Hamming distance. -/
theorem distToTarget_pos_of_ne (b : Branch) (h : b ≠ candTarget) :
    1 ≤ distToTarget b :=
  Nat.one_le_iff_ne_zero.mpr (fun h0 => h ((distToTarget_eq_zero_iff b).mp h0))

/-- The standard Wilson radial is nonnegative. -/
theorem Rstd_nonneg (k : Fin 4 -> ℝ) : 0 ≤ Rstd k := by
  unfold Rstd
  apply Finset.sum_nonneg
  intro A _
  have := Real.cos_le_one (k A)
  linarith

/-- In the first Wilson band the candidate has exactly one negative branch mass:
the target corner. -/
theorem candWindow (r rho : ℝ) (hr : 0 < r) (hrho : 0 < rho)
    (hband : rho < 2 * r) :
    BranchMassWindow (branchMassCand r rho) candTarget := by
  constructor
  · rw [branchMassCand_eq]
    have : distToTarget candTarget = 0 :=
      (distToTarget_eq_zero_iff candTarget).mpr rfl
    rw [this]
    simp
    linarith
  · intro b hb
    rw [branchMassCand_eq]
    have hd : (1 : ℝ) ≤ (distToTarget b : ℝ) := by
      exact_mod_cast distToTarget_pos_of_ne b hb
    nlinarith

/-- The candidate branch-mass scan witness. -/
def candWitness (r rho : ℝ) (hr : 0 < r) (hrho : 0 < rho)
    (hband : rho < 2 * r) : BranchMassScanWitness :=
  { mass := branchMassCand r rho
    chirality := chiralityCand
    target := candTarget
    window := candWindow r rho hr hrho hband
    target_chirality_ne_zero := by simp [chiralityCand, chiralTraceE00] }

/-- The candidate flavored-Wilson search specification. -/
def candSpec (r rho : ℝ) (hr : 0 < r) (hrho : 0 < rho)
    (hband : rho < 2 * r) : FlavoredWilsonSearchSpec (Fin 4) :=
  { BW := BWcand r rho
    branchMass := branchMassCand r rho
    chirality := chiralityCand
    target := candTarget
    mass_window := candWindow r rho hr hrho hband
    target_chirality_ne_zero := by simp [chiralityCand, chiralTraceE00] }

/-- Concrete numeric instance at `r = rho = 1`. -/
def candWitness1 : BranchMassScanWitness :=
  candWitness 1 1 (by norm_num) (by norm_num) (by norm_num)

/-- The concrete witness has nonzero retained branch index. -/
theorem candWitness1_index_ne_zero :
    retainedIndex candWitness1.mass candWitness1.chirality ≠ 0 :=
  TetraFlavoredOverlap.retainedIndex_ne_zero
    candWitness1.window candWitness1.target_chirality_ne_zero

/-! ## Trap-escape and corner-gap audit facts -/

/-- `gamma5` is Hermitian. -/
theorem gamma5_hermitian : star gamma5 = gamma5 := by
  unfold gamma5
  rw [Matrix.star_eq_conjTranspose, Matrix.diagonal_conjTranspose]
  congr 1
  funext i
  simp only [Pi.star_apply, RCLike.star_def, apply_ite (starRingEnd ℂ)]
  simp

/-- `gamma5` is involutive. -/
theorem gamma5_sq : gamma5 * gamma5 = 1 := by
  unfold gamma5
  rw [Matrix.diagonal_mul_diagonal, <- Matrix.diagonal_one]
  congr 1
  funext i
  fin_cases i <;> norm_num

/-- `gamma5` is traceless on the finite block. -/
theorem gamma5_trace : gamma5.trace = 0 := by
  unfold gamma5
  rw [Matrix.trace_diagonal, Fin.sum_univ_four]
  norm_num

/-- The physical chiral island projector has chiral trace one. -/
theorem chiralIndex_E00 : (gamma5 * E00).trace = 1 := by
  unfold gamma5 E00
  rw [Matrix.diagonal_mul_diagonal, Matrix.trace_diagonal, Fin.sum_univ_four]
  simp

/-- The integer chirality used by the branch scan is the checked spin-island
trace. -/
theorem chiralTraceE00_cast :
    ((chiralTraceE00 : ℤ) : ℂ) = (gamma5 * E00).trace := by
  rw [chiralIndex_E00]
  norm_num [chiralTraceE00]

/-- Every branch entry in the finite mass scan uses the same physical spin-line
chiral trace; the mass window, not this function, selects the retained branch. -/
theorem chiralityCand_cast (b : Branch) :
    ((chiralityCand b : ℤ) : ℂ) = (gamma5 * E00).trace := by
  rw [chiralityCand, chiralTraceE00_cast]

/-- The candidate is genuinely non-scalar in the first band. -/
theorem Wcand_not_scalar (r rho : ℝ) (hr : 0 < r) (hrho : 0 < rho) :
    ¬ ∃ c : ℂ, Wcand r rho (branchMomentum candTarget) =
      c • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  rintro ⟨c, hc⟩
  have e0 := congrFun (congrFun hc 0) 0
  have e1 := congrFun (congrFun hc 1) 1
  simp [Wcand] at e0 e1
  have hmm : mPhys r rho (branchMomentum candTarget) =
      mMir r rho (branchMomentum candTarget) := by
    have : (mPhys r rho (branchMomentum candTarget) : ℂ) =
        (mMir r rho (branchMomentum candTarget) : ℂ) := by
      rw [e0, e1]
    exact_mod_cast this
  have hneg : mPhys r rho (branchMomentum candTarget) < 0 := by
    have he : mPhys r rho (branchMomentum candTarget) =
        2 * r * (distToTarget candTarget : ℝ) - rho := by
      unfold mPhys
      rw [Rstar_branchMomentum]
      ring
    rw [he, (distToTarget_eq_zero_iff candTarget).mpr rfl]
    simp
    linarith
  have hpos : 0 < mMir r rho (branchMomentum candTarget) := by
    unfold mMir
    nlinarith [Rstd_nonneg (branchMomentum candTarget)]
  linarith

/-- Mirror entries are gapped: `mMir(corner)^2 >= rho^2` at every corner. -/
theorem mMir_corner_sq_ge (r rho : ℝ) (hr : 0 ≤ r) (hrho : 0 < rho)
    (b : Branch) : rho ^ 2 ≤ (mMir r rho (branchMomentum b)) ^ 2 := by
  have h1 : rho ≤ mMir r rho (branchMomentum b) := by
    unfold mMir
    nlinarith [Rstd_nonneg (branchMomentum b)]
  nlinarith [h1, hrho]

/-- Off-target physical entries are gapped by `(2r-rho)^2`. -/
theorem mPhys_corner_offtarget_sq_ge (r rho : ℝ) (hr : 0 < r)
    (hband : rho < 2 * r) (b : Branch) (h : b ≠ candTarget) :
    (2 * r - rho) ^ 2 ≤ (mPhys r rho (branchMomentum b)) ^ 2 := by
  have he : mPhys r rho (branchMomentum b) =
      2 * r * (distToTarget b : ℝ) - rho := by
    unfold mPhys
    rw [Rstar_branchMomentum]
    ring
  have hd : (1 : ℝ) ≤ (distToTarget b : ℝ) := by
    exact_mod_cast distToTarget_pos_of_ne b h
  have hge : 2 * r - rho ≤ mPhys r rho (branchMomentum b) := by
    rw [he]
    nlinarith
  nlinarith [hge, hband]

end TetraFlavoredOverlapCandidate
end GateC1
end NullEdge
end Draft
end PhysicsSM
