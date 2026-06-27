import Mathlib
import PhysicsSM.Draft.NullEdgeFlavoredChirality

/-!
# The actual flat tetrahedral Clifford symbol and its per-branch kernel chirality (C21)

This module supplies the operator-level data that Gate C had isolated as the
single remaining blocker `OperatorForcesAlignment` in
`PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` (C19) and
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §25.3, §26.3.

C19 proved Gate C is conditionally released **iff** the actual flat tetrahedral
null-edge Clifford symbol `c(p(q))` assigns a single spacetime-chirality
eigenvalue `g5 a` to the zero mode on each high-momentum null branch `a`.  Here we
*build that operator* and *compute the kernel/chirality honestly*.

## Conventions (locked, `docs/CONVENTIONS.md`)

* Mostly-minus Lorentzian signature `g = diag(+,-,-,-)`; null momenta satisfy
  `mink p = 0` (`PhysicsSM.Draft.TetrahedralNullBranch.mink`).
* Weyl / chiral gamma basis on the spinor space `Fin 2 ⊕ Fin 2` (right-handed
  `inl`, left-handed `inr`):
  `γ⁰ = [[0,I],[I,0]]`, `γⁱ = [[0,σⁱ],[-σⁱ,0]]`, `γ₅ = [[I,0],[0,-I]]`.
  These satisfy `{γᵘ,γᵛ} = 2 ηᵘᵛ` with `η = diag(+,-,-,-)`.
* The Clifford symbol of a covector `p : Fin 4 → ℂ` is `c(p) = Σ_μ p_μ γ^μ`,
  with `c(p)² = (mink p) • 1`.  This reuses the spacetime symbol covector
  `pCov` and the Minkowski square `mink` from
  `PhysicsSM.Draft.TetrahedralNullBranch`, whose `pSq_mink_eq_qform` identifies
  `mink (pCov u) = qform u`.

## What is proved here

1. **The gamma matrices and Clifford algebra**: `clifford_relation`
   (`{γᵘ,γᵛ} = 2 ηᵘᵛ • 1`) and the block form `cliffordSymbol_fromBlocks`.
2. **The symbol square**: `cliffordSymbol_sq : c(p) * c(p) = (mink p) • 1`.
3. **Branch nilpotency**: on each of the four high-momentum null branches the
   symbol squares to zero (`branch_cliffordSymbol_sq_zero`) but is itself nonzero
   (`branch_cliffordSymbol_ne_zero`).
4. **The actual per-branch kernel and its chirality (the corrected result)**:
   for every nonzero null covector the kernel of `c(p)` contains **both** a
   right-handed (`γ₅ = +1`) and a left-handed (`γ₅ = -1`) zero mode
   (`null_kernel_chirality_plus`, `null_kernel_chirality_minus`), and these are
   linearly independent.  Hence the **full Dirac symbol kernel is two
   dimensional with vanishing chirality trace**, *not* a one-dimensional
   eigenspace with a single sign `g5 a`.

## Honest verdict (Gate C remains PENDING; corrected, not forced)

The caution in the C21 job is realized: the actual symbol's per-branch kernel is
**two-dimensional and chirality-balanced** (one `+1` and one `-1` mode), exactly
mirroring `naive_index_zero`.  Therefore the C19 hypothesis
`OperatorForcesAlignment bc := bc = g5` is **not** discharged by the full
operator: the operator does *not* assign a single chirality `g5 a` to branch `a`.
A single-sign branch chirality `g5 a` only emerges after an extra
energy/Krein/Weyl projection that selects one of the two kernel modes per branch
(`no_full_symbol_single_chirality`).  That projection is the precise remaining
Gate C obligation, restated below as `OperatorForcesAlignmentAfterProjection`.

This is reported as a **corrected theorem** + blocker, not a forced release:
per the Gate C rule, the signs are *not* forced by the bare operator data.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeActualCliffordSymbol

open Matrix
open PhysicsSM.Draft.TetrahedralNullBranch
open PhysicsSM.Draft.NullEdgeFlavoredChirality

/-! ## Spinor space and the Weyl gamma matrices -/

/-- Spinor index: `Fin 2 ⊕ Fin 2`, right-handed (`inl`) ⊕ left-handed (`inr`). -/
abbrev Spin := Fin 2 ⊕ Fin 2

/-- 4×4 complex matrices on the spinor space. -/
abbrev CMat4 := Matrix Spin Spin ℂ

/-- Pauli matrix `σ¹`. -/
def pauli1 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
/-- Pauli matrix `σ²`. -/
def pauli2 : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
/-- Pauli matrix `σ³`. -/
def pauli3 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `γ⁰ = [[0,I],[I,0]]`. -/
def gamma0 : CMat4 := Matrix.fromBlocks 0 1 1 0
/-- `γ¹ = [[0,σ¹],[-σ¹,0]]`. -/
def gamma1 : CMat4 := Matrix.fromBlocks 0 pauli1 (-pauli1) 0
/-- `γ² = [[0,σ²],[-σ²,0]]`. -/
def gamma2 : CMat4 := Matrix.fromBlocks 0 pauli2 (-pauli2) 0
/-- `γ³ = [[0,σ³],[-σ³,0]]`. -/
def gamma3 : CMat4 := Matrix.fromBlocks 0 pauli3 (-pauli3) 0
/-- Spacetime chirality `γ₅ = [[I,0],[0,-I]]` (eigenvalue `+1` on right-handed
`inl`, `-1` on left-handed `inr`). -/
def gamma5 : CMat4 := Matrix.fromBlocks 1 0 0 (-1)

/-- The gamma matrices indexed by the spacetime index `Fin 4`. -/
def gamma : Fin 4 → CMat4 := ![gamma0, gamma1, gamma2, gamma3]

/-- The mostly-minus Minkowski metric `η = diag(+,-,-,-)`. -/
def eta (μ ν : Fin 4) : ℂ := if μ = ν then (if μ = 0 then 1 else -1) else 0

/-! ## The Clifford symbol and its blocks -/

/-- Upper-right Weyl block of the symbol: `A(p) = p₀ I + pⁱσⁱ`. -/
def blockA (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 + p 3, p 1 - Complex.I * p 2; p 1 + Complex.I * p 2, p 0 - p 3]

/-- Lower-left Weyl block of the symbol: `B(p) = p₀ I - pⁱσⁱ`. -/
def blockB (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 - p 3, -(p 1) + Complex.I * p 2; -(p 1) - Complex.I * p 2, p 0 + p 3]

/-- The flat tetrahedral Clifford symbol `c(p) = Σ_μ p_μ γ^μ` in block form
`[[0, A(p)],[B(p), 0]]`. -/
def cliffordSymbol (p : Fin 4 → ℂ) : CMat4 :=
  Matrix.fromBlocks 0 (blockA p) (blockB p) 0

/-! ## The Clifford algebra of the gamma matrices -/

/-
**Clifford relation** `{γᵘ,γᵛ} = 2 ηᵘᵛ • 1` with mostly-minus `η`.
-/
theorem clifford_relation (μ ν : Fin 4) :
    gamma μ * gamma ν + gamma ν * gamma μ = (2 * eta μ ν) • (1 : CMat4) := by
  fin_cases μ <;> fin_cases ν <;> simp +decide [ gamma, eta, gamma0, gamma1, gamma2, gamma3, pauli1, pauli2, pauli3, Matrix.fromBlocks_multiply, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply ];
  all_goals ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.fromBlocks ] <;> ring_nf ;

/-
The symbol `c(p)` equals `Σ_μ p_μ γ^μ`.
-/
theorem cliffordSymbol_eq_sum (p : Fin 4 → ℂ) :
    cliffordSymbol p = ∑ μ, p μ • gamma μ := by
  unfold cliffordSymbol;
  unfold blockA blockB gamma;
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Fin.sum_univ_succ, gamma0, gamma1, gamma2, gamma3 ];
  all_goals unfold pauli1 pauli2 pauli3; norm_num;
  all_goals ring;

/-! ## Block products and determinants -/

theorem blockA_mul_blockB (p : Fin 4 → ℂ) :
    blockA p * blockB p = (mink p) • 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ blockA, blockB, Matrix.mul_apply ] <;> ring; all_goals unfold mink; norm_num; ring;

theorem blockB_mul_blockA (p : Fin 4 → ℂ) :
    blockB p * blockA p = (mink p) • 1 := by
  convert blockA_mul_blockB p using 1;
  unfold blockA blockB; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] <;> ring;

theorem blockA_det (p : Fin 4 → ℂ) : (blockA p).det = mink p := by
  unfold mink; unfold blockA; norm_num [ Fin.sum_univ_succ ] ; ring;
  norm_num ; ring

theorem blockB_det (p : Fin 4 → ℂ) : (blockB p).det = mink p := by
  unfold blockB mink; norm_num [ Fin.sum_univ_four ] ; ring;
  norm_num ; ring

/-
`A(p) = 0` forces `p = 0`.
-/
theorem blockA_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockA p ≠ 0 := by
  intro H;
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  simp_all +decide [ blockA ];
  exact hp ( by ext i; fin_cases i <;> norm_num <;> norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith! )

/-
`B(p) = 0` forces `p = 0`.
-/
theorem blockB_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockB p ≠ 0 := by
  contrapose! hp;
  ext i; fin_cases i <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ] ;
  · simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
    unfold blockB at hp; norm_num at hp; norm_num [ Complex.ext_iff ] at *; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff ] ;
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] ;
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] ;
    grind

/-! ## The symbol square `c(p)² = (mink p) • 1` -/

/-
**Symbol square.**  `c(p) * c(p) = (mink p) • 1`.  In the massless flat
Clifford setting this is the statement that `det c(p) = 0 ⇔ mink p = 0`, i.e. the
determinant branch condition is exactly `p² = 0`.
-/
theorem cliffordSymbol_sq (p : Fin 4 → ℂ) :
    cliffordSymbol p * cliffordSymbol p = (mink p) • (1 : CMat4) := by
  unfold cliffordSymbol;
  rw [ fromBlocks_multiply ] ; simp +decide [ blockA_mul_blockB, blockB_mul_blockA ] ;
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply ]

/-
`c(p) ≠ 0` whenever the covector is nonzero.
-/
theorem cliffordSymbol_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) :
    cliffordSymbol p ≠ 0 := by
  intro h;
  apply blockA_ne_zero p hp;
  convert congr_arg ( fun m : CMat4 => m.submatrix ( fun i => Sum.inl i ) ( fun j => Sum.inr j ) ) h using 1

/-! ## The per-branch kernel and its chirality (generic null covector) -/

/-
On any null covector the symbol is nilpotent: `c(p)² = 0`.
-/
theorem cliffordSymbol_sq_zero (p : Fin 4 → ℂ) (h : mink p = 0) :
    cliffordSymbol p * cliffordSymbol p = 0 := by
  rw [cliffordSymbol_sq, h, zero_smul]

/-
**Right-handed kernel mode.**  For a null covector there is a nonzero
`γ₅ = +1` (right-handed) zero mode of the symbol.  (Only nullity `mink p = 0`,
equivalently `det = 0`, is needed; the physically relevant branches additionally
have `p ≠ 0`, recorded separately in `branch_cliffordSymbol_ne_zero`.)
-/
theorem null_kernel_chirality_plus (p : Fin 4 → ℂ) (h : mink p = 0) :
    ∃ v : Spin → ℂ, v ≠ 0 ∧ cliffordSymbol p *ᵥ v = 0 ∧ gamma5 *ᵥ v = v := by
  -- Since `(blockB p).det = mink p = 0` (by `blockB_det` and `h`), `Matrix.exists_mulVec_eq_zero_iff` gives `x : Fin 2 → ℂ` with `x ≠ 0` and `blockB p *ᵥ x = 0`.
  obtain ⟨x, hx_ne_zero, hx_zero⟩ : ∃ x : Fin 2 → ℂ, x ≠ 0 ∧ blockB p *ᵥ x = 0 := by
    have h_det : Matrix.det (blockB p) = 0 := by
      rw [ ← h, blockB_det ];
    convert Matrix.exists_mulVec_eq_zero_iff.mpr h_det;
  refine' ⟨ Sum.elim x 0, _, _, _ ⟩ <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  · simp_all +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_succ, cliffordSymbol ];
  · simp +decide [ gamma5, Matrix.mulVec ];
    simp +decide [ Matrix.mulVec, dotProduct ]

/-
**Left-handed kernel mode.**  For a null covector there is a nonzero
`γ₅ = -1` (left-handed) zero mode of the symbol.  (Only nullity `mink p = 0` is
needed.)
-/
theorem null_kernel_chirality_minus (p : Fin 4 → ℂ) (h : mink p = 0) :
    ∃ v : Spin → ℂ, v ≠ 0 ∧ cliffordSymbol p *ᵥ v = 0 ∧ gamma5 *ᵥ v = -v := by
  -- Since `(blockA p).det = mink p = 0` (by `blockA_det` and `h`), `Matrix.exists_mulVec_eq_zero_iff` gives `y : Fin 2 → ℂ` with `y ≠ 0` and `blockA p *ᵥ y = 0`.
  obtain ⟨y, hy_ne_zero, hy_zero⟩ : ∃ y : Fin 2 → ℂ, y ≠ 0 ∧ blockA p *ᵥ y = 0 := by
    convert Matrix.exists_mulVec_eq_zero_iff.mpr _;
    exacts [ by infer_instance, by infer_instance, by rw [ blockA_det, h ] ];
  refine' ⟨ Sum.elim 0 y, _, _, _ ⟩ <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  · simp_all +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_succ ];
    unfold cliffordSymbol; aesop;
  · simp +decide [ gamma5, Matrix.mulVec ];
    simp +decide [ Matrix.mulVec, dotProduct ]

/-
**The corrected kernel-chirality statement.**  For every nonzero null
covector the symbol kernel contains both a `γ₅ = +1` and a `γ₅ = -1` zero mode,
and they are linearly independent.  Hence the full Dirac symbol kernel is at
least two-dimensional and chirality-balanced: the operator does **not** select a
single chirality sign per branch.
-/
theorem null_kernel_both_chiralities (p : Fin 4 → ℂ) (h : mink p = 0) :
    ∃ vplus vminus : Spin → ℂ,
      (vplus ≠ 0 ∧ cliffordSymbol p *ᵥ vplus = 0 ∧ gamma5 *ᵥ vplus = vplus) ∧
      (vminus ≠ 0 ∧ cliffordSymbol p *ᵥ vminus = 0 ∧ gamma5 *ᵥ vminus = -vminus) ∧
      LinearIndependent ℂ ![vplus, vminus] := by
  obtain ⟨vplus, hvplus⟩ := null_kernel_chirality_plus p h
  obtain ⟨vminus, hvminus⟩ := null_kernel_chirality_minus p h
  use vplus, vminus
  simp [hvplus, hvminus];
  refine' Fintype.linearIndependent_iff.2 _;
  intro g hg; have := congr_arg ( fun x => gamma5.mulVec x ) hg; norm_num [ hvplus.2.2, hvminus.2.2, Matrix.mulVec_add, Matrix.mulVec_smul ] at this;
  simp_all +decide [ funext_iff, Fin.forall_fin_two ];
  grind

/-! ## Specialization to the four high-momentum null branches -/

/-- The spacetime symbol covector of branch `a` (the `{0,π}^4` corner whose
unique non-`π` edge is at position `a`). -/
def branchP (a : Fin 4) : Fin 4 → ℂ := pCov (cornerU (tasteCorner a))

/-
Each branch covector is null.
-/
theorem branchP_mink_zero (a : Fin 4) : mink (branchP a) = 0 := by
  rw [ branchP, pSq_mink_eq_qform ];
  exact ( tasteCorner_high_momentum_null a ).1

/-
Each branch covector is nonzero.
-/
theorem branchP_ne_zero (a : Fin 4) : branchP a ≠ 0 := by
  convert threePi_pCov_ne_zero ( tasteCorner a ) ( tasteCorner_count a ) using 1

/-
On each high-momentum null branch the symbol squares to zero.
-/
theorem branch_cliffordSymbol_sq_zero (a : Fin 4) :
    cliffordSymbol (branchP a) * cliffordSymbol (branchP a) = 0 := by
  -- Since `branchP a` is null, we can apply the previously established theorem `cliffordSymbol_sq_zero`.
  rw [cliffordSymbol_sq_zero (branchP a) (branchP_mink_zero a)]

/-
On each high-momentum null branch the symbol is nonzero (genuine determinant
branch, not a trivial point).
-/
theorem branch_cliffordSymbol_ne_zero (a : Fin 4) :
    cliffordSymbol (branchP a) ≠ 0 := by
  -- Apply the theorem that states the Clifford symbol is non-zero for any non-zero vector.
  apply cliffordSymbol_ne_zero; exact branchP_ne_zero a

/-- **Actual per-branch kernel chirality (the C21 computation).**  On each of the
four high-momentum null branches the actual Clifford symbol has a kernel
containing both a right-handed (`γ₅ = +1`) and a left-handed (`γ₅ = -1`) zero
mode, linearly independent.  The branch kernel is therefore two-dimensional and
chirality-balanced. -/
theorem branchKernel_chirality_sign (a : Fin 4) :
    ∃ vplus vminus : Spin → ℂ,
      (vplus ≠ 0 ∧ cliffordSymbol (branchP a) *ᵥ vplus = 0 ∧ gamma5 *ᵥ vplus = vplus) ∧
      (vminus ≠ 0 ∧ cliffordSymbol (branchP a) *ᵥ vminus = 0 ∧
        gamma5 *ᵥ vminus = -vminus) ∧
      LinearIndependent ℂ ![vplus, vminus] :=
  null_kernel_both_chiralities (branchP a) (branchP_mink_zero a)

/-! ## Corrected Gate C verdict: the bare operator does not force a single sign -/

/-- The C19 release hypothesis transcribed at operator level: a *single*
chirality sign `ε a ∈ {±1}` is assigned to each branch by the bare symbol means
the whole branch kernel is a `γ₅`-eigenspace with that one eigenvalue.  We phrase
this as: every nonzero zero mode `v` of `c(branchP a)` is a `γ₅`-eigenvector with
eigenvalue `ε a`. -/
def BareOperatorAssignsSingleSign (ε : Fin 4 → ℂ) : Prop :=
  ∀ a, ∀ v : Spin → ℂ, v ≠ 0 → cliffordSymbol (branchP a) *ᵥ v = 0 →
    gamma5 *ᵥ v = (ε a) • v

/-
**Corrected verdict / blocker.**  No single-sign assignment is forced by the
bare operator: for *every* candidate sign vector `ε`, the bare symbol fails to
make the whole branch kernel a single-chirality eigenspace, because each branch
kernel contains zero modes of *both* chiralities.  In particular the C19
hypothesis `OperatorForcesAlignment bc := bc = g5` is not discharged by the full
operator data.
-/
theorem no_full_symbol_single_chirality :
    ¬ ∃ ε : Fin 4 → ℂ, BareOperatorAssignsSingleSign ε := by
  push_neg;
  intro ε hε
  obtain ⟨vplus, vminus, hvplus, hvminus, hv⟩ := branchKernel_chirality_sign 0;
  have := hε 0 vplus hvplus.1 hvplus.2.1; have := hε 0 vminus hvminus.1 hvminus.2.1; simp_all +decide [ funext_iff, Fin.forall_fin_succ ] ;
  grind +splitImp

/-- The remaining Gate C obligation, corrected: a chirality-selecting projector
`P a` (the energy/Krein/Weyl projection of §25.3 step 4–5) must cut each
two-dimensional branch kernel down to a one-dimensional subspace on which `γ₅`
acts by `g5 a`.  This is the precise data the bare operator does **not** supply
(`no_full_symbol_single_chirality`) and that a future module must add. -/
def OperatorForcesAlignmentAfterProjection
    (P : Fin 4 → (Spin → ℂ) → (Spin → ℂ)) : Prop :=
  ∀ a, ∀ v : Spin → ℂ, v ≠ 0 → cliffordSymbol (branchP a) *ᵥ v = 0 →
    P a v ≠ 0 → gamma5 *ᵥ (P a v) = ((g5 a : ℂ)) • (P a v)

end PhysicsSM.Draft.NullEdgeActualCliffordSymbol
