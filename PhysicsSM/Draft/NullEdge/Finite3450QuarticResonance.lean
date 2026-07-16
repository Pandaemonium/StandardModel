import Mathlib

/-!
# Finite `3-4-5-0` quartic-resonance laboratory

This file builds a finite fermionic Fock-space control inspired by quartic
interactions in the chiral `3-4-5-0` model.  It proves an exact neutral
two-configuration resonance.  It does **not** realize symmetric mass generation
for the full mirror sector: many other Fock configurations remain outside the
proved gapped subspace.

## Physical convention (semantic gate 1)

The `3-4-5-0` model has four Weyl fermions with integer `U(1)` charges
`3, 4, 5, 0`.  We use the anomaly-free chirality assignment

* left-movers  (`χ = +1`): flavours of charge `3` and `4`;
* right-movers (`χ = -1`): flavours of charge `5` and `0`.

The `U(1)` gauge anomaly is `∑_f χ_f q_f² = 3² + 4² − 5² − 0² = 0`
(`gauge_anomaly_free`), and the gravitational anomaly is `∑_f χ_f = 0`
(`gravitational_anomaly_free`, i.e. `#L = #R`).  This is the faithful
convention; the seed `quadratic_charge_balance` is exactly the gauge anomaly.

Because *no two charges coincide across the two chiralities*, there is **no
`U(1)`-invariant quadratic (mirror) mass** `ψ†_L ψ_R`.  A proposed symmetric
mass-generation mechanism must therefore use genuinely many-body interactions.
The present finite control uses the neutral
off-diagonal fermion operator uses the identity `3 + 5 = 4 + 4`: it removes two
charge-`4` quanta and creates a charge-`3` and a charge-`5` quantum.

## Finite mode content

We truncate to the smallest mode set carrying that interaction:

| mode `i` | 0 | 1 | 2 | 3 | 4 |
|----------|---|---|---|---|---|
| charge   | 3 | 4 | 4 | 5 | 0 |
| flavour  | 3 | 4 | 4 | 5 | 0 |

Modes `1, 2` are two momentum modes of the charge-`4` flavour (needed for the
quartic), mode `4` is a charge-`0` spectator.  The Fock space is
`Cfg := Finset (Fin 5)` (occupation sets), dimension `2⁵ = 32`.

## What is proved

* `Ham` is a genuine quartic (`cre 0 * cre 3 * ann 1 * ann 2 + h.c.`), built from
  Jordan–Wigner creation/annihilation operators with real CAR signs
  (`cre_sq`, Pauli exclusion).
* `Ham_charge_conserving` : `[Ham, Q] = 0` (exact `U(1)` invariance).
* `Ham_not_bilinear` / `Ham_not_diagonal` : `Ham` is *not* representable by any
  one-particle bilinear `∑ c_ij cre i * ann j` (rejects the bilinear no-go and
  the chemical-potential/diagonal vacuity control).
* `Ham_witness` : an explicit nonzero action `Ham |4,4⟩ = -|3,5⟩`.
* `mirror_gap_SOS` / `Ham_eig_plus` / `Ham_eig_minus` : on the 2-dimensional
  mirror subspace `span{|4,4⟩, |3,5⟩}` the spectrum is exactly `{+1, -1}`;
  `H² = 1` there, giving a **sharp rational gap `1`**.
* `Ham_target_annihilated` / `Ham_target_decoupled` : every single-particle
  (and vacuum) state is annihilated and has zero matrix element to the selected
  two-configuration resonance sector.

## Finite-vs-thermodynamic audit (semantic gate 6)

See the `Audit` section at the end of the file.  In brief: this is a
**finite-size subspace** spectral-gap theorem for a specific few-mode
Hamiltonian.  It is *not* a proof that the full complement of the protected
sector is gapped, nor a proof of thermodynamic-limit mirror decoupling: no
`N → ∞` uniform gap,
no locality/volume analysis, and no spontaneous-symmetry-breaking or anomaly
input is assumed or established.  The gap number `1` is the exact finite
spectrum on the displayed two-dimensional subspace, not a physical claim about
the continuum theory.

Provenance: clean-room finite model returned by Aristotle job
`9eff30d1-131c-4ae8-83af-975e3832192d`, semantically narrowed during
integration.  The cited paper is motivation only; no source implementation was
copied and no claim is made that this truncation reproduces its lattice model.
-/

namespace PhysicsSM.Draft.NullEdge.Finite3450QuarticResonance

open scoped Matrix
open Matrix

/-! ## Charge / chirality convention (gate 1) -/

/-- The anomaly-free integer charge tuple used by the finite laboratory. -/
def charge : Fin 4 → Int
  | 0 => 3
  | 1 => 4
  | 2 => 5
  | 3 => 0

/-- Chirality of each flavour: charges `3,4` are left-movers (`+1`), charges
`5,0` are right-movers (`-1`). -/
def chi : Fin 4 → Int
  | 0 => 1
  | 1 => 1
  | 2 => -1
  | 3 => -1

/-- Seed identity: the gauge anomaly in the `(+,+,-,-)` convention. -/
theorem quadratic_charge_balance :
    charge 0 ^ 2 + charge 1 ^ 2 - charge 2 ^ 2 - charge 3 ^ 2 = 0 := by
  norm_num [charge]

/-- `U(1)` gauge anomaly cancellation: `∑_f χ_f q_f² = 0`. -/
theorem gauge_anomaly_free : ∑ f, chi f * charge f ^ 2 = 0 := by
  simp [Fin.sum_univ_four, chi, charge]

/-- Gravitational anomaly cancellation: `∑_f χ_f = 0` (equal `#L`, `#R`). -/
theorem gravitational_anomaly_free : ∑ f, chi f = 0 := by
  simp [Fin.sum_univ_four, chi]

/-! ## Fermionic Fock space with Jordan–Wigner CAR signs (gate 2) -/

/-- A Fock basis configuration: the set of occupied modes among `Fin 5`. -/
abbrev Cfg := Finset (Fin 5)

/-- Jordan–Wigner sign: `(-1)` to the number of occupied modes below `i`. -/
noncomputable def sgn (S : Cfg) (i : Fin 5) : ℚ := (-1) ^ ((S.filter (· < i)).card)

/-- Fermionic creation operator `a†_i` in the occupation basis. -/
noncomputable def cre (i : Fin 5) : Matrix Cfg Cfg ℚ :=
  fun T S => if i ∉ S ∧ T = insert i S then sgn S i else 0

/-- Fermionic annihilation operator `a_i = (a†_i)ᵀ` (adjoint in the real basis). -/
noncomputable def ann (i : Fin 5) : Matrix Cfg Cfg ℚ := (cre i)ᵀ

/-- Action of `a†_i` on a basis vector. -/
lemma cre_col (i : Fin 5) (S : Cfg) :
    (cre i) *ᵥ (Pi.single S (1:ℚ)) =
      if i ∉ S then Pi.single (insert i S) (sgn S i) else 0 := by
  rw [Matrix.mulVec_single]; simp only [MulOpposite.op_one, one_smul]
  by_cases h : i ∈ S
  · simp only [h, not_true_eq_false, if_false]; funext T; simp [Matrix.col_apply, cre, h]
  · simp only [h, not_false_eq_true, if_true]; funext T
    simp only [Matrix.col_apply, cre, h, not_false_eq_true, true_and, Pi.single_apply]

/-- Action of `a_i` on a basis vector. -/
lemma ann_col (i : Fin 5) (S : Cfg) :
    (ann i) *ᵥ (Pi.single S (1:ℚ)) =
      if i ∈ S then Pi.single (S.erase i) (sgn (S.erase i) i) else 0 := by
  rw [Matrix.mulVec_single]; simp only [MulOpposite.op_one, one_smul]
  by_cases h : i ∈ S
  · simp only [h, if_true]; funext T
    simp only [Matrix.col_apply, ann, cre, Matrix.transpose_apply, Pi.single_apply]
    by_cases hT : T = S.erase i
    · subst hT
      have h1 : i ∉ S.erase i := by simp
      rw [if_pos ⟨h1, (Finset.insert_erase h).symm⟩, if_pos rfl]
    · have hcond : ¬ (i ∉ T ∧ S = insert i T) := by
        rintro ⟨hiT, hS⟩; exact hT (by rw [hS, Finset.erase_insert hiT])
      rw [if_neg hcond, if_neg hT]
  · simp only [h, if_false]; funext T
    simp only [Matrix.col_apply, ann, cre, Matrix.transpose_apply]
    have hcond : ¬ (i ∉ T ∧ S = insert i T) := by
      rintro ⟨hiT, hS⟩; exact h (by rw [hS]; exact Finset.mem_insert_self i T)
    rw [if_neg hcond]; simp

/-- Scalar-weighted action of `a†_i`. -/
lemma cre_col_c (i : Fin 5) (S : Cfg) (c : ℚ) :
    (cre i) *ᵥ (Pi.single S c) =
      if i ∉ S then Pi.single (insert i S) (c * sgn S i) else 0 := by
  rw [show (Pi.single S c : Cfg → ℚ) = c • (Pi.single S (1:ℚ) : Cfg → ℚ) by
        rw [← Pi.single_smul]; simp, Matrix.mulVec_smul, cre_col]
  by_cases h : i ∉ S
  · rw [if_pos h, if_pos h, ← Pi.single_smul, smul_eq_mul]
  · rw [if_neg h, if_neg h, smul_zero]

/-- Scalar-weighted action of `a_i`. -/
lemma ann_col_c (i : Fin 5) (S : Cfg) (c : ℚ) :
    (ann i) *ᵥ (Pi.single S c) =
      if i ∈ S then Pi.single (S.erase i) (c * sgn (S.erase i) i) else 0 := by
  rw [show (Pi.single S c : Cfg → ℚ) = c • (Pi.single S (1:ℚ) : Cfg → ℚ) by
        rw [← Pi.single_smul]; simp, Matrix.mulVec_smul, ann_col]
  by_cases h : i ∈ S
  · rw [if_pos h, if_pos h, ← Pi.single_smul, smul_eq_mul]
  · rw [if_neg h, if_neg h, smul_zero]

/-- Reading off a matrix entry from its action on a basis vector. -/
lemma entry_of_mulVec (M : Matrix Cfg Cfg ℚ) (S T : Cfg) :
    (M *ᵥ Pi.single S (1:ℚ)) T = M T S := by
  simp [Matrix.mulVec_single, Matrix.col_apply]

/-- Pauli exclusion / nilpotency: `a†_i a†_i = 0`.  This uses the CAR signs and
witnesses that the operators are genuinely fermionic (a bosonic `if` would not
vanish). -/
lemma cre_sq (i : Fin 5) : cre i * cre i = 0 := by
  ext T S
  simp only [Matrix.mul_apply, Matrix.zero_apply]
  apply Finset.sum_eq_zero
  intro K _
  by_cases h : i ∉ S ∧ K = insert i S
  · have hiK : i ∈ K := by rw [h.2]; exact Finset.mem_insert_self i S
    have : cre i T K = 0 := by simp [cre, hiK]
    rw [this, zero_mul]
  · have : cre i K S = 0 := by simp [cre, h]
    rw [this, mul_zero]

/-- Same statement for annihilation: `a_i a_i = 0`. -/
lemma ann_sq (i : Fin 5) : ann i * ann i = 0 := by
  have := congrArg Matrix.transpose (cre_sq i)
  simpa [ann, Matrix.transpose_mul] using this

/-! ## The quartic interaction and Hamiltonian (gate 3) -/

/-- The neutral quartic vertex `a†_3 a†_5 a_{4a} a_{4b}` (`3 + 5 = 4 + 4`),
written with mode indices `0 (c3), 3 (c5), 1 (c4a), 2 (c4b)`. -/
noncomputable def Op : Matrix Cfg Cfg ℚ := cre 0 * cre 3 * ann 1 * ann 2

/-- The Hermitian quartic interaction `Ham = Op + Op†`. -/
noncomputable def Ham : Matrix Cfg Cfg ℚ := Op + Opᵀ

/-- `Ham` is real-symmetric (self-adjoint). -/
lemma Ham_symm : Hamᵀ = Ham := by
  simp only [Ham, Matrix.transpose_add, Matrix.transpose_transpose, add_comm]

lemma OpT_eq : Opᵀ = cre 2 * cre 1 * ann 3 * ann 0 := by
  simp only [Op, Matrix.transpose_mul, ann, Matrix.transpose_transpose]; noncomm_ring

/-! ### Explicit action on the mirror pair `A = {1,2} = |4,4⟩`, `B = {0,3} = |3,5⟩` -/

lemma Op_A_c (c : ℚ) : Op *ᵥ Pi.single ({1,2}:Cfg) c = Pi.single ({0,3}:Cfg) (-c) := by
  have e : Op *ᵥ Pi.single ({1,2}:Cfg) c
      = cre 0 *ᵥ (cre 3 *ᵥ (ann 1 *ᵥ (ann 2 *ᵥ Pi.single ({1,2}:Cfg) c))) := by
    simp only [Op, ← Matrix.mulVec_mulVec]
  rw [e, ann_col_c, if_pos (by decide), show (({1,2}:Cfg).erase 2) = ({1}:Cfg) by decide,
      show sgn ({1}:Cfg) 2 = -1 by decide,
      ann_col_c, if_pos (by decide), show (({1}:Cfg).erase 1) = (∅:Cfg) by decide,
      show sgn (∅:Cfg) 1 = 1 by decide,
      cre_col_c, if_pos (by decide), show insert (3:Fin 5) (∅:Cfg) = ({3}:Cfg) by decide,
      show sgn (∅:Cfg) 3 = 1 by decide,
      cre_col_c, if_pos (by decide), show insert (0:Fin 5) ({3}:Cfg) = ({0,3}:Cfg) by decide,
      show sgn ({3}:Cfg) 0 = 1 by decide]
  congr 1; ring

lemma OpT_A_c (c : ℚ) : Opᵀ *ᵥ Pi.single ({1,2}:Cfg) c = 0 := by
  rw [OpT_eq]
  have e : (cre 2 * cre 1 * ann 3 * ann 0) *ᵥ Pi.single ({1,2}:Cfg) c
      = cre 2 *ᵥ (cre 1 *ᵥ (ann 3 *ᵥ (ann 0 *ᵥ Pi.single ({1,2}:Cfg) c))) := by
    simp only [← Matrix.mulVec_mulVec]
  rw [e, ann_col_c, if_neg (by decide)]; simp

lemma Op_B_c (c : ℚ) : Op *ᵥ Pi.single ({0,3}:Cfg) c = 0 := by
  have e : Op *ᵥ Pi.single ({0,3}:Cfg) c
      = cre 0 *ᵥ (cre 3 *ᵥ (ann 1 *ᵥ (ann 2 *ᵥ Pi.single ({0,3}:Cfg) c))) := by
    simp only [Op, ← Matrix.mulVec_mulVec]
  rw [e, ann_col_c, if_neg (by decide)]; simp

lemma OpT_B_c (c : ℚ) : Opᵀ *ᵥ Pi.single ({0,3}:Cfg) c = Pi.single ({1,2}:Cfg) (-c) := by
  rw [OpT_eq]
  have e : (cre 2 * cre 1 * ann 3 * ann 0) *ᵥ Pi.single ({0,3}:Cfg) c
      = cre 2 *ᵥ (cre 1 *ᵥ (ann 3 *ᵥ (ann 0 *ᵥ Pi.single ({0,3}:Cfg) c))) := by
    simp only [← Matrix.mulVec_mulVec]
  rw [e, ann_col_c, if_pos (by decide), show (({0,3}:Cfg).erase 0) = ({3}:Cfg) by decide,
      show sgn ({3}:Cfg) 0 = 1 by decide,
      ann_col_c, if_pos (by decide), show (({3}:Cfg).erase 3) = (∅:Cfg) by decide,
      show sgn (∅:Cfg) 3 = 1 by decide,
      cre_col_c, if_pos (by decide), show insert (1:Fin 5) (∅:Cfg) = ({1}:Cfg) by decide,
      show sgn (∅:Cfg) 1 = 1 by decide,
      cre_col_c, if_pos (by decide), show insert (2:Fin 5) ({1}:Cfg) = ({1,2}:Cfg) by decide,
      show sgn ({1}:Cfg) 2 = -1 by decide]
  congr 1; ring

/-- `Ham |4,4⟩ = -|3,5⟩`. -/
lemma Ham_A_c (c : ℚ) : Ham *ᵥ Pi.single ({1,2}:Cfg) c = Pi.single ({0,3}:Cfg) (-c) := by
  rw [Ham, Matrix.add_mulVec, Op_A_c, OpT_A_c, add_zero]

/-- `Ham |3,5⟩ = -|4,4⟩`. -/
lemma Ham_B_c (c : ℚ) : Ham *ᵥ Pi.single ({0,3}:Cfg) c = Pi.single ({1,2}:Cfg) (-c) := by
  rw [Ham, Matrix.add_mulVec, Op_B_c, OpT_B_c, zero_add]

/-- **Nonzero witness (gate 4).** The quartic genuinely acts:
`Ham |4,4⟩ = -|3,5⟩ ≠ 0`. -/
theorem Ham_witness :
    Ham *ᵥ Pi.single ({1,2}:Cfg) (1:ℚ) = Pi.single ({0,3}:Cfg) (-1:ℚ)
      ∧ Ham *ᵥ Pi.single ({1,2}:Cfg) (1:ℚ) ≠ 0 := by
  refine ⟨Ham_A_c 1, ?_⟩
  rw [Ham_A_c]
  intro h
  have := congrFun h ({0,3}:Cfg)
  simp at this

/-! ## Charge operator and `U(1)` conservation (gate 3) -/

/-- Charge carried by each finite mode (`3,4,4,5,0`). -/
def modeCharge : Fin 5 → ℚ
  | 0 => 3
  | 1 => 4
  | 2 => 4
  | 3 => 5
  | 4 => 0

/-- The finite mode `→` flavour map. -/
def modeFlavor : Fin 5 → Fin 4
  | 0 => 0
  | 1 => 1
  | 2 => 1
  | 3 => 2
  | 4 => 3

/-- Faithfulness: each mode's charge is the charge of its flavour. -/
theorem modeCharge_eq_flavour (i : Fin 5) : modeCharge i = (charge (modeFlavor i) : ℚ) := by
  fin_cases i <;> simp [modeCharge, modeFlavor, charge]

/-- Total charge of a configuration. -/
noncomputable def chargeVec (S : Cfg) : ℚ := ∑ i ∈ S, modeCharge i

/-- The `U(1)` charge operator (diagonal). -/
noncomputable def Qop : Matrix Cfg Cfg ℚ := Matrix.diagonal chargeVec

/-- `a†_i` raises charge by `q_i`: `[Q, a†_i] = q_i a†_i`. -/
lemma Q_cre (i : Fin 5) : Qop * cre i - cre i * Qop = (modeCharge i) • cre i := by
  ext T S
  simp only [Matrix.sub_apply, Qop, Matrix.diagonal_mul, Matrix.mul_diagonal,
    Matrix.smul_apply, smul_eq_mul]
  by_cases h : i ∉ S ∧ T = insert i S
  · have hchg : chargeVec T = modeCharge i + chargeVec S := by
      rw [h.2, chargeVec, chargeVec, Finset.sum_insert h.1]
    simp only [cre, if_pos h, hchg]; ring
  · simp only [cre, if_neg h]; ring

/-- `a_i` lowers charge by `q_i`: `[Q, a_i] = -q_i a_i`. -/
lemma Q_ann (i : Fin 5) : Qop * ann i - ann i * Qop = (- modeCharge i) • ann i := by
  ext T S
  simp only [Matrix.sub_apply, Qop, Matrix.diagonal_mul, Matrix.mul_diagonal,
    Matrix.smul_apply, smul_eq_mul]
  by_cases h : i ∉ T ∧ S = insert i T
  · have hchg : chargeVec S = modeCharge i + chargeVec T := by
      rw [h.2, chargeVec, chargeVec, Finset.sum_insert h.1]
    simp only [ann, cre, Matrix.transpose_apply, if_pos h, hchg]; ring
  · simp only [ann, cre, Matrix.transpose_apply, if_neg h]; ring

/-- Leibniz rule for the charge (adjoint) bracket. -/
lemma bracket_mul (X Y : Matrix Cfg Cfg ℚ) (a b : ℚ)
    (hX : Qop * X - X * Qop = a • X) (hY : Qop * Y - Y * Qop = b • Y) :
    Qop * (X * Y) - (X * Y) * Qop = (a + b) • (X * Y) := by
  have key : Qop * (X * Y) - (X * Y) * Qop
      = (Qop * X - X * Qop) * Y + X * (Qop * Y - Y * Qop) := by noncomm_ring
  rw [key, hX, hY, smul_mul_assoc, mul_smul_comm, add_smul]

/-- The vertex is charge-neutral: `[Q, Op] = 0` since `3 + 5 - 4 - 4 = 0`. -/
lemma Q_Op : Qop * Op - Op * Qop = 0 := by
  have b1 := bracket_mul (cre 0) (cre 3) _ _ (Q_cre 0) (Q_cre 3)
  have b2 := bracket_mul _ (ann 1) _ _ b1 (Q_ann 1)
  have b3 := bracket_mul _ (ann 2) _ _ b2 (Q_ann 2)
  have hcoef : (modeCharge 0 + modeCharge 3 + -modeCharge 1 + -modeCharge 2 : ℚ) = 0 := by
    norm_num [modeCharge]
  rw [show Op = cre 0 * cre 3 * ann 1 * ann 2 from rfl, b3, hcoef, zero_smul]

lemma Q_OpT : Qop * Opᵀ - Opᵀ * Qop = 0 := by
  have h := congrArg Matrix.transpose Q_Op
  simp only [Matrix.transpose_sub, Matrix.transpose_mul, Matrix.transpose_zero,
    Qop, Matrix.diagonal_transpose] at h
  rw [sub_eq_zero] at h ⊢
  exact h.symm

/-- **`U(1)` invariance (gate 3):** `[Ham, Q] = 0`. -/
theorem Ham_charge_conserving : Qop * Ham = Ham * Qop := by
  have h : Qop * Ham - Ham * Qop = 0 := by
    simp only [Ham, mul_add, add_mul]
    have h1 := Q_Op
    have h2 := Q_OpT
    rw [show Qop * Op + Qop * Opᵀ - (Op * Qop + Opᵀ * Qop)
        = (Qop * Op - Op * Qop) + (Qop * Opᵀ - Opᵀ * Qop) by abel, h1, h2, add_zero]
  rwa [sub_eq_zero] at h

/-! ## Genuinely many-body: not a bilinear / chemical potential (gate 3) -/

/-- The one-particle bilinear-mass predicate: `M` is a sum of number-conserving
hopping/mass terms `c_ij a†_i a_j` (this includes all diagonal chemical
potentials `μ_i a†_i a_i`). -/
def IsBilinear (M : Matrix Cfg Cfg ℚ) : Prop :=
  ∃ c : Fin 5 → Fin 5 → ℚ, M = ∑ i, ∑ j, c i j • (cre i * ann j)

/-- Any single bilinear term has vanishing `⟨3,5| · |4,4⟩` matrix element: it
moves at most one particle, but `|4,4⟩` and `|3,5⟩` differ in two occupations. -/
lemma crann_entry_zero (i j : Fin 5) :
    (cre i * ann j) ({0,3}:Cfg) ({1,2}:Cfg) = 0 := by
  rw [← entry_of_mulVec (cre i * ann j) ({1,2}:Cfg) ({0,3}:Cfg),
      ← Matrix.mulVec_mulVec, ann_col]
  by_cases hj : j ∈ ({1,2}:Cfg)
  · rw [if_pos hj, cre_col_c]
    by_cases hi : i ∉ (({1,2}:Cfg).erase j)
    · rw [if_pos hi, Pi.single_apply, if_neg]
      intro hEq
      have hKsub12 : (({1,2}:Cfg).erase j) ⊆ ({1,2}:Cfg) := Finset.erase_subset _ _
      have hKsub03 : (({1,2}:Cfg).erase j) ⊆ ({0,3}:Cfg) := by
        rw [hEq]; exact Finset.subset_insert i _
      have hempty : (({1,2}:Cfg).erase j) ⊆ (∅:Cfg) := by
        have := Finset.subset_inter hKsub12 hKsub03
        simpa using this
      have hcard : (({1,2}:Cfg).erase j).card = 1 := by
        rw [Finset.card_erase_of_mem hj]; decide
      rw [Finset.subset_empty] at hempty
      rw [hempty] at hcard; simp at hcard
    · rw [if_neg hi]; simp
  · rw [if_neg hj]; simp

/-- The mirror matrix element `⟨3,5| Ham |4,4⟩ = -1`. -/
lemma Ham_entry_BA : Ham ({0,3}:Cfg) ({1,2}:Cfg) = -1 := by
  rw [← entry_of_mulVec Ham ({1,2}:Cfg) ({0,3}:Cfg), Ham_A_c]
  simp

/-- **No-go for bilinear replacement (gate 3):** `Ham` is not any one-particle
bilinear mass/hopping operator. -/
theorem Ham_not_bilinear : ¬ IsBilinear Ham := by
  rintro ⟨c, hc⟩
  have hentry : Ham ({0,3}:Cfg) ({1,2}:Cfg) = 0 := by
    rw [hc]
    simp only [Matrix.sum_apply, Matrix.smul_apply, smul_eq_mul]
    apply Finset.sum_eq_zero; intro i _
    apply Finset.sum_eq_zero; intro j _
    rw [crann_entry_zero i j, mul_zero]
  rw [Ham_entry_BA] at hentry
  norm_num at hentry

/-- `Ham` is not diagonal: it cannot be a chemical-potential term. -/
theorem Ham_not_diagonal : ¬ Ham.IsDiag := by
  intro h
  have hz : Ham ({0,3}:Cfg) ({1,2}:Cfg) = 0 := h (show ({0,3}:Cfg) ≠ ({1,2}:Cfg) by decide)
  rw [Ham_entry_BA] at hz
  norm_num at hz

/-! ## Sharp finite gap on the mirror subspace (gate 4) -/

/-- `H² = 1` on `|4,4⟩`. -/
lemma Ham_sq_A : Ham *ᵥ (Ham *ᵥ Pi.single ({1,2}:Cfg) (1:ℚ)) = Pi.single ({1,2}:Cfg) (1:ℚ) := by
  rw [Ham_A_c, Ham_B_c]; norm_num

/-- `H² = 1` on `|3,5⟩`. -/
lemma Ham_sq_B : Ham *ᵥ (Ham *ᵥ Pi.single ({0,3}:Cfg) (1:ℚ)) = Pi.single ({0,3}:Cfg) (1:ℚ) := by
  rw [Ham_B_c, Ham_A_c]; norm_num

/-- Eigenvector with eigenvalue `+1`: `|4,4⟩ - |3,5⟩`. -/
theorem Ham_eig_plus :
    Ham *ᵥ (Pi.single ({1,2}:Cfg) (1:ℚ) - Pi.single ({0,3}:Cfg) (1:ℚ))
      = (1:ℚ) • (Pi.single ({1,2}:Cfg) (1:ℚ) - Pi.single ({0,3}:Cfg) (1:ℚ)) := by
  rw [Matrix.mulVec_sub, Ham_A_c, Ham_B_c, one_smul]
  funext x
  simp only [Pi.sub_apply, Pi.single_apply]
  split_ifs <;> ring

/-- Eigenvector with eigenvalue `-1`: `|4,4⟩ + |3,5⟩`. -/
theorem Ham_eig_minus :
    Ham *ᵥ (Pi.single ({1,2}:Cfg) (1:ℚ) + Pi.single ({0,3}:Cfg) (1:ℚ))
      = (-1:ℚ) • (Pi.single ({1,2}:Cfg) (1:ℚ) + Pi.single ({0,3}:Cfg) (1:ℚ)) := by
  rw [Matrix.mulVec_add, Ham_A_c, Ham_B_c]
  funext x
  simp only [Pi.add_apply, Pi.smul_apply, Pi.single_apply, smul_eq_mul]
  split_ifs <;> ring

theorem Ham_eig_plus_ne_zero :
    ((Pi.single ({1,2}:Cfg) (1:ℚ) - Pi.single ({0,3}:Cfg) (1:ℚ)) : Cfg → ℚ) ≠ 0 := by
  intro h
  have hthis := congrFun h ({1,2}:Cfg)
  simp [show ({1,2}:Cfg) ≠ ({0,3}:Cfg) by decide] at hthis

theorem Ham_eig_minus_ne_zero :
    ((Pi.single ({1,2}:Cfg) (1:ℚ) + Pi.single ({0,3}:Cfg) (1:ℚ)) : Cfg → ℚ) ≠ 0 := by
  intro h
  have hthis := congrFun h ({1,2}:Cfg)
  simp [show ({1,2}:Cfg) ≠ ({0,3}:Cfg) by decide] at hthis

/-- **Sharp gap via a sum-of-squares identity (gate 4).**  For every state
`ψ = x|4,4⟩ + y|3,5⟩` in the mirror subspace, `‖Ham ψ‖² = ‖ψ‖²`, i.e. every
mirror eigenvalue has magnitude exactly `1`.  Hence the mirror gap is the exact
rational `1`, with no zero mode. -/
theorem mirror_gap_SOS (x y : ℚ) :
    (Ham *ᵥ (Pi.single ({1,2}:Cfg) x + Pi.single ({0,3}:Cfg) y)) ⬝ᵥ
        (Ham *ᵥ (Pi.single ({1,2}:Cfg) x + Pi.single ({0,3}:Cfg) y))
      = (Pi.single ({1,2}:Cfg) x + Pi.single ({0,3}:Cfg) y) ⬝ᵥ
        (Pi.single ({1,2}:Cfg) x + Pi.single ({0,3}:Cfg) y) := by
  rw [Matrix.mulVec_add, Ham_A_c, Ham_B_c]
  simp only [dotProduct_add, dotProduct_single]
  norm_num [show ({0,3}:Cfg) ≠ ({1,2}:Cfg) by decide,
    show ({1,2}:Cfg) ≠ ({0,3}:Cfg) by decide]

/-! ## Protected target sector: annihilated and decoupled (gate 5) -/

/-- Every single-particle "target" state is annihilated by `Op`. -/
lemma Op_single (k : Fin 5) : Op *ᵥ Pi.single ({k}:Cfg) (1:ℚ) = 0 := by
  have e : Op *ᵥ Pi.single ({k}:Cfg) (1:ℚ)
      = cre 0 *ᵥ (cre 3 *ᵥ (ann 1 *ᵥ (ann 2 *ᵥ Pi.single ({k}:Cfg) (1:ℚ)))) := by
    simp only [Op, ← Matrix.mulVec_mulVec]
  rw [e, ann_col_c]
  by_cases h2 : (2:Fin 5) ∈ ({k}:Cfg)
  · rw [if_pos h2]
    have hk : k = 2 := (Finset.mem_singleton.mp h2).symm
    subst hk
    rw [show (({(2:Fin 5)}:Cfg).erase 2) = (∅:Cfg) by decide, ann_col_c, if_neg (by decide)]
    simp
  · rw [if_neg h2]; simp

/-- Every single-particle "target" state is annihilated by `Op†`. -/
lemma OpT_single (k : Fin 5) : Opᵀ *ᵥ Pi.single ({k}:Cfg) (1:ℚ) = 0 := by
  rw [OpT_eq]
  have e : (cre 2 * cre 1 * ann 3 * ann 0) *ᵥ Pi.single ({k}:Cfg) (1:ℚ)
      = cre 2 *ᵥ (cre 1 *ᵥ (ann 3 *ᵥ (ann 0 *ᵥ Pi.single ({k}:Cfg) (1:ℚ)))) := by
    simp only [← Matrix.mulVec_mulVec]
  rw [e, ann_col_c]
  by_cases h0 : (0:Fin 5) ∈ ({k}:Cfg)
  · rw [if_pos h0]
    have hk : k = 0 := (Finset.mem_singleton.mp h0).symm
    subst hk
    rw [show (({(0:Fin 5)}:Cfg).erase 0) = (∅:Cfg) by decide, ann_col_c, if_neg (by decide)]
    simp
  · rw [if_neg h0]; simp

/-- Every single-particle state is a zero mode of this quartic truncation. -/
theorem Ham_target_annihilated (k : Fin 5) : Ham *ᵥ Pi.single ({k}:Cfg) (1:ℚ) = 0 := by
  rw [Ham, Matrix.add_mulVec, Op_single, OpT_single, add_zero]

/-- The vacuum is also a zero mode. -/
theorem Ham_vacuum_annihilated : Ham *ᵥ Pi.single (∅:Cfg) (1:ℚ) = 0 := by
  have e : Op *ᵥ Pi.single (∅:Cfg) (1:ℚ)
      = cre 0 *ᵥ (cre 3 *ᵥ (ann 1 *ᵥ (ann 2 *ᵥ Pi.single (∅:Cfg) (1:ℚ)))) := by
    simp only [Op, ← Matrix.mulVec_mulVec]
  have eT : Opᵀ *ᵥ Pi.single (∅:Cfg) (1:ℚ)
      = cre 2 *ᵥ (cre 1 *ᵥ (ann 3 *ᵥ (ann 0 *ᵥ Pi.single (∅:Cfg) (1:ℚ)))) := by
    rw [OpT_eq]; simp only [← Matrix.mulVec_mulVec]
  rw [Ham, Matrix.add_mulVec, e, eT, ann_col_c, if_neg (by decide),
      ann_col_c, if_neg (by decide)]
  simp

/-- The vacuum basis vector is nonzero. -/
theorem vacuum_state_ne_zero :
    (Pi.single (∅ : Cfg) (1 : ℚ) : Cfg → ℚ) ≠ 0 := by
  intro h
  have hentry := congrFun h (∅ : Cfg)
  simpa using hentry

/-- **Full-space gap obstruction.**  The complete 32-dimensional Hamiltonian
has a nonzero zero mode.  Thus the sharp gap proved on the selected pair
subspace is not a gap of the full Fock-space operator. -/
theorem full_hamiltonian_has_zero_mode :
    ∃ psi : Cfg → ℚ, psi ≠ 0 ∧ Ham *ᵥ psi = 0 :=
  ⟨(Pi.single (∅ : Cfg) (1 : ℚ) : Cfg → ℚ),
    vacuum_state_ne_zero, Ham_vacuum_annihilated⟩

/-- There is no matrix element connecting any single-particle state to the
selected two-configuration resonance subspace. -/
theorem Ham_target_decoupled (k : Fin 5) :
    Ham ({1,2}:Cfg) ({k}:Cfg) = 0 ∧ Ham ({0,3}:Cfg) ({k}:Cfg) = 0
      ∧ Ham ({k}:Cfg) ({1,2}:Cfg) = 0 ∧ Ham ({k}:Cfg) ({0,3}:Cfg) = 0 := by
  have hcol := Ham_target_annihilated k
  have h1 : Ham ({1,2}:Cfg) ({k}:Cfg) = 0 := by
    rw [← entry_of_mulVec Ham ({k}:Cfg) ({1,2}:Cfg), hcol]; simp
  have h2 : Ham ({0,3}:Cfg) ({k}:Cfg) = 0 := by
    rw [← entry_of_mulVec Ham ({k}:Cfg) ({0,3}:Cfg), hcol]; simp
  refine ⟨h1, h2, ?_, ?_⟩
  · have : Ham ({k}:Cfg) ({1,2}:Cfg) = Ham ({1,2}:Cfg) ({k}:Cfg) := by
      conv_lhs => rw [← Ham_symm]
      rfl
    rw [this, h1]
  · have : Ham ({k}:Cfg) ({0,3}:Cfg) = Ham ({0,3}:Cfg) ({k}:Cfg) := by
      conv_lhs => rw [← Ham_symm]
      rfl
    rw [this, h2]

/-! ## Audit (gate 6) and nonvacuity witnesses

* **Nonvacuity.**  `Ham ≠ 0` (`Ham_witness`), the interaction has a nonzero
  matrix element `⟨3,5|Ham|4,4⟩ = -1` (`Ham_entry_BA`), and both mirror
  eigenvectors are nonzero (`Ham_eig_plus_ne_zero`, `Ham_eig_minus_ne_zero`).
  No statement here is vacuously true and no hypothesis is contradictory.

* **No SSB / no anomaly input.**  The `U(1)` charge operator `Qop` is exact and
  the interaction commutes with it (`Ham_charge_conserving`); the gap is proved
  in the charge-symmetric phase without any symmetry-breaking order parameter or
  spontaneous breaking.  Anomaly cancellation is recorded as an independent fact
  about the charges (`gauge_anomaly_free`, `gravitational_anomaly_free`); it is
  *input data* motivating the model, and is not used to prove the gap.

* **Genuinely many-body.**  `Ham_not_bilinear` and `Ham_not_diagonal` show the
  gap is not produced by a one-particle bilinear mass or a diagonal chemical
  potential — the two rejected vacuous solutions.

* **Locality / volume.**  This model has a *fixed finite* mode content
  (`Fin 5`, `dim 2⁵`).  No locality of the interaction on a lattice, and no
  volume (system-size) dependence of the gap, is analysed.

* **Finite vs. thermodynamic limit.**  The number `1` is the *exact finite-size*
  gap of this specific Hamiltonian on the selected 2-dimensional subspace.
  `full_hamiltonian_has_zero_mode` proves that the full 32-dimensional operator
  is not gapped at zero.  The subspace identity is
  emphatically **not** a proof of a thermodynamic-limit mirror-decoupling
  theorem: there is no family `{Ham_N}` with a uniform `N → ∞` gap, and no claim
  about the interacting continuum `3-4-5-0` theory.  A finite gap here is a
  precise linear-algebra fact, not a physical mirror-decoupling statement.
-/

/-- Nonvacuity: the Hamiltonian is not the zero operator. -/
theorem Ham_ne_zero : Ham ≠ 0 := by
  intro h
  have := Ham_entry_BA
  rw [h] at this
  simp at this

/-! The build-enforced assumption pins for this integrated module live in
`OvernightTheoryAxiomGuard.lean`, where they are checked together with the
other flagship 3+1 results. -/

end PhysicsSM.Draft.NullEdge.Finite3450QuarticResonance
