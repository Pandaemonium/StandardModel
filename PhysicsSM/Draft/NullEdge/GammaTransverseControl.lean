import PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift

/-!
# Gamma-coupled transverse control

This finite control replaces a commuting transverse-plus-tangential sum by an
anticommuting Clifford coupling.  The intended result is an exact square and a
full complement gap, followed by an honest chirality audit: the kernel sector
is expected to carry a paired four-component massless Dirac symbol rather than
one isolated Weyl species.

## Honesty boundary

Everything below is a statement about one fixed finite Hamiltonian matrix.  It
is **not** a discrete-time evolution, **not** a primitive-null walk, **not** a
periodic Brillouin-zone construction, and **not** an anomaly-inflow theorem.
The complement gap is an exact *quadratic* (Cayley-type) identity
`M * M = 5 • 1 - w wᵀ`, from which `M²` acts as `5` on the orthogonal complement
of `w`.  We deliberately do **not** upgrade this to a spectral theorem
diagonalising `M` (whose spectrum is `{0, √5, -√5}`); the quadratic identity is
all we assert.  The chirality audit produces two opposite-orientation Weyl
sectors certified by determinant signs `+1` and `-1`; their net chirality
vanishes, so gamma coupling does **not** isolate a single Weyl species.

Provenance: clean-room Aristotle formalization from project
`87e8d4f4-0f1b-452e-bd9a-54b1f103f86e`, task
`44b31d80-248d-4999-a5c4-bcac86efb384`, independently replayed and
semantically approved by interactive Claude/Opus. The transverse chain and
zero mode are reused from `FiniteTransverseWeylLift`.
-/

namespace PhysicsSM.Draft.NullEdge.GammaTransverseControl

open Matrix
open FiniteTransverseWeylLift

noncomputable section

abbrev TSite := Fin 3
abbrev Qubit := Fin 2
abbrev Spin4 := Qubit × Qubit

abbrev M : Matrix TSite TSite Complex := Mc
abbrev w : TSite -> Complex := wc

def sx : Matrix Qubit Qubit Complex := !![0, 1; 1, 0]
def sy : Matrix Qubit Qubit Complex := !![0, -Complex.I; Complex.I, 0]
def sz : Matrix Qubit Qubit Complex := !![1, 0; 0, -1]

def gamma1 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sx
def gamma2 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sy
def gamma3 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sz
def gamma4 : Matrix Spin4 Spin4 Complex :=
  kroneckerMap (fun a b => a * b) sz (1 : Matrix Qubit Qubit Complex)

def tangent (kx ky kz : Real) : Matrix Spin4 Spin4 Complex :=
  (kx : Complex) • gamma1 + (ky : Complex) • gamma2 + (kz : Complex) • gamma3

def H (kx ky kz : Real) :
    Matrix (TSite × Spin4) (TSite × Spin4) Complex :=
  kroneckerMap (fun a b => a * b) M gamma4 +
    kroneckerMap (fun a b => a * b) (1 : Matrix TSite TSite Complex)
      (tangent kx ky kz)

def embed (e : Spin4 -> Complex) : TSite × Spin4 -> Complex :=
  fun p => w p.1 * e p.2

/-! ## Step 1 : the transverse kernel witness -/

theorem M_mulVec_w : M *ᵥ w = 0 := by
  exact Mc_mulVec_wc

/--
The complement of `w` is nontrivial: there is a nonzero transverse vector
orthogonal to `w`.  This makes the complement-gap statements nonvacuous.
-/
theorem exists_nonzero_complement :
    ∃ v : TSite -> Complex, v ≠ 0 ∧ w ⬝ᵥ v = 0 := by
  refine' ⟨ fun i => if i = 0 then -1 else if i = 1 then 2 else -2, _, _ ⟩ <;> simp +decide [ funext_iff, Fin.forall_fin_succ, dotProduct ];
  simp +decide [ Fin.sum_univ_three, wc ]

/-! ## Step 2 : the exact Clifford relations -/

theorem gamma_sq (a : Fin 4) :
    ![gamma1, gamma2, gamma3, gamma4] a * ![gamma1, gamma2, gamma3, gamma4] a = 1 := by
  fin_cases a <;> norm_num [ gamma1, gamma2, gamma3, gamma4 ];
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, kroneckerMap ];
    all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, sx ] ;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ];
    all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, sx, sy ] ;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, kroneckerMap ] ;
    all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, sx, sz ] ;
  · unfold kroneckerMap; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply ] ;
    all_goals simp +decide [ Fin.sum_univ_succ, Matrix.one_apply, sz ] ;
    all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ] ;

theorem sx_mul_sy_anticomm : sx * sy + sy * sx = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [sx, sy]

theorem sx_mul_sz_anticomm : sx * sz + sz * sx = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [sx, sz]

theorem sy_mul_sz_anticomm : sy * sz + sz * sy = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [sy, sz]

theorem gamma12_anticomm : gamma1 * gamma2 + gamma2 * gamma1 = 0 := by
  rw [gamma1, gamma2, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    ← Matrix.kronecker_add, sx_mul_sy_anticomm, Matrix.kronecker_zero]

theorem gamma13_anticomm : gamma1 * gamma3 + gamma3 * gamma1 = 0 := by
  rw [gamma1, gamma3, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    ← Matrix.kronecker_add, sx_mul_sz_anticomm, Matrix.kronecker_zero]

theorem gamma23_anticomm : gamma2 * gamma3 + gamma3 * gamma2 = 0 := by
  rw [gamma2, gamma3, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    ← Matrix.kronecker_add, sy_mul_sz_anticomm, Matrix.kronecker_zero]

theorem gamma14_anticomm : gamma1 * gamma4 + gamma4 * gamma1 = 0 := by
  rw [gamma1, gamma4, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    Matrix.one_mul, Matrix.mul_one, ← Matrix.add_kronecker, sx_mul_sz_anticomm,
    Matrix.zero_kronecker]

theorem gamma24_anticomm : gamma2 * gamma4 + gamma4 * gamma2 = 0 := by
  rw [gamma2, gamma4, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    Matrix.one_mul, Matrix.mul_one, ← Matrix.add_kronecker, sx_mul_sz_anticomm,
    Matrix.zero_kronecker]

theorem gamma34_anticomm : gamma3 * gamma4 + gamma4 * gamma3 = 0 := by
  rw [gamma3, gamma4, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    Matrix.one_mul, Matrix.mul_one, ← Matrix.add_kronecker, sx_mul_sz_anticomm,
    Matrix.zero_kronecker]

theorem gamma_anticommute (a b : Fin 4) (hab : a != b) :
    ![gamma1, gamma2, gamma3, gamma4] a * ![gamma1, gamma2, gamma3, gamma4] b +
      ![gamma1, gamma2, gamma3, gamma4] b * ![gamma1, gamma2, gamma3, gamma4] a = 0 := by
  -- The 16 index pairs are handled by defeq (`![…] ⟨0,_⟩` reduces to `gamma1`, etc.):
  -- diagonal pairs contradict `hab`, off-diagonal pairs are the paired anticommutators.
  fin_cases a <;> fin_cases b <;>
    first
      | exact absurd hab (by decide)
      | exact gamma12_anticomm
      | exact gamma13_anticomm
      | exact gamma23_anticomm
      | exact gamma14_anticomm
      | exact gamma24_anticomm
      | exact gamma34_anticomm
      | (rw [add_comm]; exact gamma12_anticomm)
      | (rw [add_comm]; exact gamma13_anticomm)
      | (rw [add_comm]; exact gamma23_anticomm)
      | (rw [add_comm]; exact gamma14_anticomm)
      | (rw [add_comm]; exact gamma24_anticomm)
      | (rw [add_comm]; exact gamma34_anticomm)

/--
The tangential symbol squares exactly to the isotropic mass term: this is
the Clifford collapse of all cross terms.
-/
theorem tangent_sq (kx ky kz : Real) :
    tangent kx ky kz * tangent kx ky kz =
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 : Real) : Complex) • (1 : Matrix Spin4 Spin4 Complex) := by
  ext i j;
  simp +decide [ tangent, gamma1, gamma2, gamma3, gamma4, kroneckerMap, Matrix.mul_apply ];
  simp +decide [ sx, sy, sz, Fin.sum_univ_succ ];
  erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, Matrix.one_apply ] ; ring;
  rcases i with ⟨ i₁, i₂ ⟩ ; rcases j with ⟨ j₁, j₂ ⟩ ; fin_cases i₁ <;> fin_cases i₂ <;> fin_cases j₁ <;> fin_cases j₂ <;> simp +decide <;> ring_nf <;> norm_num [ Complex.ext_iff, sq ] ;

/--
The Clifford generator `gamma4` anticommutes with the whole tangential
symbol, so the transverse and tangential blocks share no cross term.
-/
theorem gamma4_tangent_anticommute (kx ky kz : Real) :
    gamma4 * tangent kx ky kz + tangent kx ky kz * gamma4 = 0 := by
  unfold tangent gamma4 gamma1 gamma2 gamma3;
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring;
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;> simp +decide [ sz, sx, sy ];
  all_goals erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, Matrix.one_apply ] ;; all_goals ring

/-! ## Step 3 : the exact square -/

/-
Exact Clifford square: transverse and tangential cross terms vanish.
-/
theorem H_sq (kx ky kz : Real) :
    H kx ky kz * H kx ky kz =
      kroneckerMap (fun a b => a * b) (M * M)
        (1 : Matrix Spin4 Spin4 Complex) +
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 : Real) : Complex) •
        (1 : Matrix (TSite × Spin4) (TSite × Spin4) Complex) := by
  unfold H;
  rw [ add_mul, mul_add, mul_add ];
  rw [ ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul ];
  simp +decide [ ← add_assoc, ← Matrix.add_kronecker, ← Matrix.smul_kronecker, gamma_sq, tangent_sq, gamma4_tangent_anticommute ];
  rw [ show gamma4 * tangent kx ky kz = -tangent kx ky kz * gamma4 by
        convert eq_neg_of_add_eq_zero_left ( gamma4_tangent_anticommute kx ky kz ) using 1;
        rw [ neg_mul ] ] ; norm_num [ Matrix.mul_assoc, Matrix.mul_smul, Matrix.smul_mul ] ; ring;
  ext i j ; norm_num [ kroneckerMap ] ; ring;
  simp +decide [ Matrix.one_apply, Prod.ext_iff ];
  rw [ show gamma4 * gamma4 = 1 by exact gamma_sq 3 ] ; aesop

/-! ## Step 4 : the honest complement-gap identity

The strongest exact statement about the transverse block is the quadratic
identity `M * M = 5 • 1 - w wᵀ`.  It yields `M² = 5` on the complement of `w`
(`complement_gap`), and combined with `H_sq` gives the full mass gap
`H² = (5 + k²)` on that complement (`H_sq_complement_gap`).  This is a quadratic
identity, not a spectral diagonalisation. -/

/--
Exact quadratic (Cayley-type) identity for the transverse block.
-/
theorem M_sq_structure :
    M * M = (5 : Complex) • (1 : Matrix TSite TSite Complex) - Matrix.vecMulVec w w := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, Fin.sum_univ_three ] <;> ring;
  all_goals norm_num [ Mc, wc, vecMulVec ] ;
  all_goals repeat erw [ Matrix.cons_val_succ' ] ; norm_num;

/--
On the orthogonal complement of `w`, the transverse square is exactly `5`.
-/
theorem complement_gap (v : TSite -> Complex) (hv : w ⬝ᵥ v = 0) :
    M *ᵥ (M *ᵥ v) = (5 : Complex) • v := by
  have h_vecMulVec : (Matrix.vecMulVec w w) *ᵥ v = 0 := by
    ext i; simp_all +decide [ Matrix.mulVec, dotProduct, vecMulVec ] ;
    simp_all +decide [ mul_assoc, ← Finset.mul_sum _ _ _ ];
  convert congr_arg ( fun x => ( 5 : ℂ ) • v - x ) h_vecMulVec using 1;
  · convert congr_arg ( fun x => x *ᵥ v ) ( M_sq_structure ) using 1;
    · exact Matrix.mulVec_mulVec v M M
    · simp +decide [ Matrix.sub_mulVec, Matrix.smul_eq_diagonal_mul ];
  · norm_num

/-
Full transverse-complement mass gap for the gamma-coupled Hamiltonian: on
the sector built from a transverse vector orthogonal to `w`, `H²` acts as the
strictly positive scalar `5 + k²`.  Contrast with the massless kernel sector
below (`kernel_restriction`).
-/
theorem H_sq_complement_gap (kx ky kz : Real)
    (v : TSite -> Complex) (e : Spin4 -> Complex) (hv : w ⬝ᵥ v = 0) :
    (H kx ky kz * H kx ky kz) *ᵥ (fun p => v p.1 * e p.2)
      = ((5 + (kx ^ 2 + ky ^ 2 + kz ^ 2) : Real) : Complex) • (fun p => v p.1 * e p.2) := by
  ext ⟨ i, j ⟩;
  rw [ H_sq ];
  -- By definition of matrix multiplication and the properties of the Kronecker product, we can simplify the expression.
  have h_simp : (M * M) *ᵥ v = (5 : ℂ) • v := by
    rw [← Matrix.mulVec_mulVec]; exact complement_gap v hv
  simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
  simp_all +decide [ Matrix.one_apply, Finset.sum_add_distrib, add_mul, mul_assoc, Finset.mul_sum _ _ _ ];
  erw [ Finset.sum_product ] ; simp_all +decide [ ← mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul ]

/-! ## Step 5 : the kernel restriction -/

/-
The transverse kernel sector carries the massless four-component tangent
symbol exactly.
-/
theorem kernel_restriction (kx ky kz : Real) (e : Spin4 -> Complex) :
    H kx ky kz *ᵥ embed e = embed (tangent kx ky kz *ᵥ e) := by
  ext t; simp [H, embed];
  obtain ⟨t₁, t₂⟩ := t;
  simp +decide [ Matrix.mulVec, dotProduct, Fintype.sum_prod_type, Finset.sum_mul _ _ _, Finset.mul_sum, mul_assoc, mul_left_comm, Finset.sum_add_distrib, Matrix.add_mulVec, Matrix.mulVec_add, Matrix.kroneckerMap_apply ];
  simp +decide [ Matrix.one_apply, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, embed ];
  fin_cases t₁ <;>
    norm_num [FiniteTransverseWeylLift.Mc, FiniteTransverseWeylLift.wc,
      Fin.sum_univ_succ] ;

/-! ## Step 6 : chirality audit of the kernel tangent

The tangent symbol factorises as `tangent = chir * weyl` with

* `chir = sx ⊗ 1` a chirality operator (`chir² = 1`),
* `weyl = 1 ⊗ (k·σ)` two copies of the single Weyl symbol `k·σ`.

`chir` commutes with `weyl`, so the two chirality projectors split `tangent`
into two decoupled sectors on which it acts as `+weyl` and `-weyl`.  The two
effective Weyl symbols `+(k·σ)` and `-(k·σ)` have opposite chirality, certified
by the determinant sign of the momentum → d-vector Jacobian: `+1` versus `-1`.
Their net chirality is `+1 + (-1) = 0`, so gamma coupling does **not** isolate a
single Weyl species. -/

/-- The `k·σ` Weyl symbol on one two-component sector. -/
def kdotsigma (kx ky kz : Real) : Matrix Qubit Qubit Complex :=
  (kx : Complex) • sx + (ky : Complex) • sy + (kz : Complex) • sz

/-- Chirality operator `sx ⊗ 1`. -/
def chir : Matrix Spin4 Spin4 Complex :=
  kroneckerMap (fun a b => a * b) sx (1 : Matrix Qubit Qubit Complex)

/-- Two copies of the Weyl symbol, `1 ⊗ (k·σ)`. -/
def weyl (kx ky kz : Real) : Matrix Spin4 Spin4 Complex :=
  kroneckerMap (fun a b => a * b) (1 : Matrix Qubit Qubit Complex) (kdotsigma kx ky kz)

/-- Chirality projector onto the `chir = +1` sector. -/
def Pplus : Matrix Spin4 Spin4 Complex :=
  (1 / 2 : Complex) • ((1 : Matrix Spin4 Spin4 Complex) + chir)

/-- Chirality projector onto the `chir = -1` sector. -/
def Pminus : Matrix Spin4 Spin4 Complex :=
  (1 / 2 : Complex) • ((1 : Matrix Spin4 Spin4 Complex) - chir)

theorem chir_sq : chir * chir = 1 := by
  ext i j ; unfold chir ; norm_num [ Matrix.mul_apply ] ; ring;
  fin_cases i <;> fin_cases j <;> simp +decide [ sx ];
  all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ, Matrix.one_apply ] ;

theorem weyl_sq (kx ky kz : Real) :
    weyl kx ky kz * weyl kx ky kz =
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 : Real) : Complex) • (1 : Matrix Spin4 Spin4 Complex) := by
  unfold weyl;
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; norm_num [ Matrix.mul_apply, Matrix.smul_apply ] ; ring;
  simp_all +decide [ kdotsigma, Matrix.one_apply ];
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;> simp +decide [ Fin.sum_univ_succ, sx, sy, sz ] <;> ring;
  all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ] ; ring;
  · norm_num ; ring;
  · norm_num;
  · norm_num ; ring;
  · norm_num

theorem chir_weyl_comm (kx ky kz : Real) :
    chir * weyl kx ky kz = weyl kx ky kz * chir := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; fin_cases i <;> fin_cases k <;> simp +decide [ Matrix.mul_apply, chir, sz, sx, sy, weyl, kdotsigma ];
  · fin_cases j <;> fin_cases l <;> simp +decide [ Fin.sum_univ_succ, Matrix.one_apply ]; all_goals erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ];
  · fin_cases j <;> fin_cases l <;> simp +decide [ Matrix.one_apply ];
    · erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ];
    · erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ];
    · erw [ Finset.sum_product, Finset.sum_product ] ; norm_num [ Fin.sum_univ_succ ];
    · erw [ Finset.sum_product, Finset.sum_product ] ; norm_num [ Fin.sum_univ_succ ];
  · fin_cases j <;> fin_cases l <;> simp +decide [ Matrix.one_apply ]; all_goals erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ];
  · erw [ Finset.sum_eq_single ( 1, 0 ), Finset.sum_eq_single ( 1, 1 ) ] <;> simp +decide [ Finset.sum_ite ]

/--
Exact factorisation of the tangent symbol into chirality times Weyl block.
-/
theorem tangent_factor (kx ky kz : Real) :
    tangent kx ky kz = chir * weyl kx ky kz := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; norm_num [ Matrix.mul_apply, Matrix.smul_apply, tangent, chir, weyl, kdotsigma, sx, sy, sz, gamma1, gamma2, gamma3 ] ; ring;
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;> norm_num [ Fin.sum_univ_succ, Matrix.one_apply ] <;> ring!;
  all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ] ;

/-
On the `+` chirality sector the tangent acts as `+weyl`.
-/
theorem tangent_on_plus (kx ky kz : Real) :
    tangent kx ky kz * Pplus = weyl kx ky kz * Pplus := by
  unfold Pplus tangent;
  convert congr_arg ( fun x : Matrix Spin4 Spin4 Complex => x * ( 1 / 2 : ℂ ) • ( 1 + chir ) ) ( tangent_factor kx ky kz ) using 1;
  simp +decide [ ← mul_assoc, ← smul_mul_assoc, ← mul_smul_comm, chir_weyl_comm ];
  simp +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, chir_sq ];
  exact add_comm _ _

/-
On the `-` chirality sector the tangent acts as `-weyl`: opposite chirality.
-/
theorem tangent_on_minus (kx ky kz : Real) :
    tangent kx ky kz * Pminus = -(weyl kx ky kz * Pminus) := by
  have hcM : chir * Pminus = -Pminus := by
    unfold Pminus;
    simp +decide [ mul_sub, sub_mul, mul_assoc, mul_left_comm, chir_sq ];
    rw [ ← smul_neg, neg_sub ];
  convert congr_arg ( fun x => weyl kx ky kz * x ) hcM using 1;
  · convert congr_arg ( fun x => x * Pminus ) ( tangent_factor kx ky kz ) using 1;
    simp +decide only [← mul_assoc, ← chir_weyl_comm];
  · rw [ Matrix.mul_neg ]

/-! ### Determinant-sign witnesses

`dcoeff P S = ½ tr(P S)` extracts the coefficient of a Pauli `P` in a symbol
`S`; against the orthonormal Paulis it returns the d-vector.  For the `+` sector
symbol `k·σ` the d-vector is `+k`, for the `-` sector symbol `-(k·σ)` it is
`-k`, so the momentum → d-vector Jacobians are `+1` and `-1` (as `3×3` real
matrices), with determinants `+1` and `-1`. -/

/-- Coefficient extraction of a two-component symbol against a Pauli. -/
def dcoeff (P S : Matrix Qubit Qubit Complex) : Complex := (1 / 2 : Complex) * (P * S).trace

/-- The three Pauli generators. -/
def paulis : Fin 3 -> Matrix Qubit Qubit Complex := ![sx, sy, sz]

/-- Momentum coordinates as a real vector. -/
def kvec (kx ky kz : Real) : Fin 3 -> Real := ![kx, ky, kz]

/--
The d-vector of the `+` sector Weyl symbol is exactly `+k`.
-/
theorem dvec_plus (kx ky kz : Real) (i : Fin 3) :
    dcoeff (paulis i) (kdotsigma kx ky kz) = ((kvec kx ky kz i : Real) : Complex) := by
  fin_cases i <;> simp +decide [ dcoeff, paulis, kdotsigma, kvec, sx, sy, sz, Matrix.trace, Matrix.mul_apply, Matrix.add_apply, Matrix.smul_apply, Fin.sum_univ_two, Matrix.diag ] <;> ring_nf;
  norm_num

/--
The d-vector of the `-` sector Weyl symbol is exactly `-k`.
-/
theorem dvec_minus (kx ky kz : Real) (i : Fin 3) :
    dcoeff (paulis i) (-(kdotsigma kx ky kz)) = -(((kvec kx ky kz i : Real) : Complex)) := by
  fin_cases i <;> simp +decide [ dcoeff, paulis, kdotsigma, kvec, sx, sy, sz, Matrix.trace, Matrix.mul_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.neg_apply, Fin.sum_univ_two, Matrix.diag ] <;> ring_nf;
  norm_num

/-- Momentum → d-vector Jacobian of the `+` sector, `Jac[i,j] = ½ tr(σᵢ σⱼ)`. -/
def JacPlus : Matrix (Fin 3) (Fin 3) Real :=
  Matrix.of fun i j => (dcoeff (paulis i) (paulis j)).re

/-- Momentum → d-vector Jacobian of the `-` sector. -/
def JacMinus : Matrix (Fin 3) (Fin 3) Real :=
  Matrix.of fun i j => (dcoeff (paulis i) (-(paulis j))).re

theorem JacPlus_eq_one : JacPlus = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ JacPlus, dcoeff, paulis, sx, sy, sz, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag, Matrix.one_apply, Complex.ext_iff ] ;
  · norm_num;
  · norm_num;
  · norm_num

theorem JacMinus_eq_negOne : JacMinus = -1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ JacMinus, dcoeff, paulis, sx, sy, sz, Matrix.trace, Matrix.mul_apply, Matrix.neg_apply, Fin.sum_univ_two, Matrix.diag, Matrix.one_apply, Matrix.neg_apply, Complex.ext_iff ] ; norm_num;
  · norm_num;
  · norm_num

/-
Chirality witness of the `+` sector: `det = +1`.
-/
theorem det_JacPlus : JacPlus.det = 1 := by
  rw [ JacPlus_eq_one, Matrix.det_one ]

/-
Chirality witness of the `-` sector: `det = -1`.
-/
theorem det_JacMinus : JacMinus.det = -1 := by
  rw [JacMinus_eq_negOne]; norm_num [Matrix.det_neg]

/-
The two kernel Weyl sectors carry opposite chirality: their d-vector
Jacobian determinants have opposite sign (product `-1 < 0`) and sum to `0`.
Hence the gamma-coupled kernel tangent is a *paired* massless Dirac symbol, not
a single isolated Weyl species.
-/
theorem chirality_paired_not_isolated :
    JacPlus.det = 1 ∧ JacMinus.det = -1 ∧
      JacPlus.det * JacMinus.det < 0 ∧ JacPlus.det + JacMinus.det = 0 := by
  norm_num [ det_JacPlus, det_JacMinus ]

end

/-! ## Standard-axiom guards

Every principal result of this development is `s o r r y`-free and depends only on
the standard Lean/Mathlib axioms `propext`, `Classical.choice`, and `Quot.sound`.
The guarded commands below make that auditable at build time. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.gamma_anticommute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gamma_anticommute

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.H_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_sq

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.M_sq_structure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms M_sq_structure

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.H_sq_complement_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_sq_complement_gap

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.kernel_restriction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kernel_restriction

/-- info: 'PhysicsSM.Draft.NullEdge.GammaTransverseControl.chirality_paired_not_isolated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_paired_not_isolated

end PhysicsSM.Draft.NullEdge.GammaTransverseControl
