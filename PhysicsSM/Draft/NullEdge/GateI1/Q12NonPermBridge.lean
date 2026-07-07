import PhysicsSM.Draft.NullEdge.GateI1.Q12Triality

/-!
# Q12 C8: the non-permutation Furey bridge gate

The T8 gate in `Q12Triality` reduced the grading "convention bridge" to
conjugation by a permutation matrix (`bridge_via_perm`). The Q12/C8 audit flags
that this is too weak: the genuine bridge between the XOR/strand-parity grading
and a translation-parity grading is a non-permutation complex change of basis,
namely the Walsh-Hadamard transform on `(ZMod 2)^3`.

This module makes that finite statement precise. Working on the XOR/Fano index
set `Idx = Fin 3 -> ZMod 2` reused from `Q12Triality`:

* `Tmat v` is the translation-by-`v` permutation matrix `e_a |-> e_(a+v)`.
* `Had` is the Walsh-Hadamard matrix `Had c a = chi_c(a)`.
* `Had_mul_Had` proves `Had * Had = 8 • 1`, hence `Had` is invertible with
  `Had^{-1} = 8^{-1} • Had`.
* `Had_mul_Tmat` intertwines translation by `v` with the diagonal grading whose
  eigenvalues are `chi_c(v)`.
* `furey_bridge` realizes `Ddiag xorSign` as the Hadamard conjugate of
  `Tmat ![1,1,1]`.

Separating permutation from non-permutation bridges:

* `conj_perm_apply` / `permBridge_forces_diagonal` show that any permutation
  conjugate of a matrix `M` is diagonal only if `M` itself is diagonal.
* `Tmat_not_diagonal` and `no_perm_bridge` show that no permutation matrix
  conjugates a nontrivial translation grading to a diagonal grading.
* `perm_bridge_insufficient` packages the separation: a non-permutation
  Hadamard bridge exists, but no permutation bridge exists.

Supporting gates:

* `bridge_trace_eq` proves trace preservation under an invertible bridge.
* `bridge_involution_descent` proves involution descent under an invertible
  bridge.

Claim boundary: this is finite matrix algebra over `C` on an 8-element index
set. It certifies that the C8 bridge must be non-permutation and exhibits the
concrete Hadamard witness; it does not prove per-sector anomaly cancellation,
an equivariant McKean-Singer theorem, or any physical chirality statement.

Provenance: `AgentTasks/fable_parallel/Q12_answer.md`; Aristotle project
`1b3c2203`, task `3ea6a392`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge

open Finset Matrix
open PhysicsSM.Draft.NullEdge.GateI1.Q12Triality

/-! ## General structural bridge lemmas -/

section General

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Entrywise formula for a permutation-matrix conjugation. -/
theorem conj_perm_apply (sigma : Equiv.Perm n) (M : Matrix n n ℂ) (i j : n) :
    ((sigma.toPEquiv.toMatrix * M * sigma⁻¹.toPEquiv.toMatrix : Matrix n n ℂ)) i j =
      M (sigma i) (sigma j) := by
  rw [PEquiv.toMatrix_toPEquiv_mul, PEquiv.mul_toMatrix_toPEquiv]
  simp only [Matrix.submatrix_apply, id_eq, Equiv.Perm.inv_def, Equiv.symm_symm]

/--
If a permutation conjugate of `M` is diagonal, then `M` is diagonal.
This is the core obstruction: permutation bridges cannot turn a genuinely
off-diagonal grading operator into a diagonal one.
-/
theorem permBridge_forces_diagonal {D M : Matrix n n ℂ}
    (hD : ∀ i j, i ≠ j -> D i j = 0) (sigma : Equiv.Perm n)
    (h : D = sigma.toPEquiv.toMatrix * M * sigma⁻¹.toPEquiv.toMatrix) :
    ∀ i j, i ≠ j -> M i j = 0 := by
  intro i j hij
  have key := conj_perm_apply sigma M (sigma⁻¹ i) (sigma⁻¹ j)
  have hsigi : sigma (sigma⁻¹ i) = i := Equiv.apply_symm_apply sigma i
  have hsigj : sigma (sigma⁻¹ j) = j := Equiv.apply_symm_apply sigma j
  rw [hsigi, hsigj, ← h] at key
  have hne : sigma⁻¹ i ≠ sigma⁻¹ j := fun hc => hij ((sigma⁻¹).injective hc)
  rw [hD (sigma⁻¹ i) (sigma⁻¹ j) hne] at key
  exact key.symm

/-- Any invertible bridge preserves the trace. -/
theorem bridge_trace_eq (B : (Matrix n n ℂ)ˣ) (G D : Matrix n n ℂ)
    (h : D = (B : Matrix n n ℂ) * G * ((B⁻¹ : (Matrix n n ℂ)ˣ) : Matrix n n ℂ)) :
    D.trace = G.trace := by
  rw [h, Matrix.trace_units_conj]

/-- Involution descent: a grading involution conjugated by any invertible bridge
is again an involution. -/
theorem bridge_involution_descent (B : (Matrix n n ℂ)ˣ) (G D : Matrix n n ℂ)
    (hG : G * G = 1)
    (h : D = (B : Matrix n n ℂ) * G * ((B⁻¹ : (Matrix n n ℂ)ˣ) : Matrix n n ℂ)) :
    D * D = 1 := by
  set Bv : Matrix n n ℂ := (B : Matrix n n ℂ) with hBv
  set Bi : Matrix n n ℂ := ((B⁻¹ : (Matrix n n ℂ)ˣ) : Matrix n n ℂ) with hBi
  subst h
  have h1 : Bi * Bv = 1 := by
    rw [hBi, hBv, ← Units.val_mul, inv_mul_cancel, Units.val_one]
  have h2 : Bv * Bi = 1 := by
    rw [hBi, hBv, ← Units.val_mul, mul_inv_cancel, Units.val_one]
  simp only [mul_assoc]
  rw [← mul_assoc Bi Bv (G * Bi), h1, one_mul, ← mul_assoc G G Bi, hG, one_mul, h2]

end General

/-! ## The translation permutation and the Walsh-Hadamard bridge on `Idx` -/

/-- Translation-by-`v` permutation matrix: `e_a |-> e_(a+v)`. -/
def Tmat (v : Idx) : Matrix Idx Idx ℂ :=
  Matrix.of fun i j => if i = j + v then 1 else 0

/-- The Walsh-Hadamard matrix `Had c a = chi_c(a)`: the Furey change of basis. -/
noncomputable def Had : Matrix Idx Idx ℂ :=
  Matrix.of fun c a => (chi c a : ℂ)

/-- The character `chi` is symmetric in its two `(ZMod 2)^3` arguments. -/
theorem chi_symm (c a : Idx) : chi c a = chi a c := by
  have hip : ip a c = ip c a := by
    simp only [ip]
    exact Finset.sum_congr rfl (fun i _ => mul_comm (a i) (c i))
  simp only [chi, hip]

/-- Finite character orthogonality on `(ZMod 2)^3`. -/
theorem chi_sum_orthogonality (e : Idx) :
    (∑ a : Idx, (chi e a : ℂ)) = if e = 0 then (8 : ℂ) else 0 := by
  by_cases he : e = 0
  · subst he
    simp only [if_true]
    have h1 : ∀ a : Idx, (chi 0 a : ℂ) = 1 := by
      intro a
      have : ip a 0 = 0 := by simp [ip]
      simp [chi, this]
    simp only [h1, Finset.sum_const, Finset.card_univ]
    norm_num
  · simp only [he, if_false]
    obtain ⟨i, hi⟩ : ∃ i, e i ≠ 0 := by
      by_contra hc
      push_neg at hc
      exact he (funext hc)
    have hei : e i = 1 := by
      have h2 : ∀ x : ZMod 2, x ≠ 0 -> x = 1 := by decide
      exact h2 _ hi
    set w : Idx := Pi.single i (1 : ZMod 2) with hw
    have hchiw : (chi e w : ℂ) = -1 := by
      have hip : ip w e = 1 := by
        simp only [ip, hw]
        rw [Finset.sum_eq_single i]
        · simp [hei]
        · intro b _ hb
          simp [Pi.single_eq_of_ne hb]
        · intro h
          exact absurd (Finset.mem_univ i) h
      simp [chi, hip, ZMod.val_one]
    have hbij := Equiv.sum_comp (Equiv.addRight w) (fun a => (chi e a : ℂ))
    simp only [Equiv.coe_addRight] at hbij
    have hstep : ∀ a : Idx, (chi e (a + w) : ℂ) = (chi e a : ℂ) * (-1) := by
      intro a
      rw [chi_add_pt]
      push_cast
      rw [hchiw]
    have hS : (∑ a : Idx, (chi e a : ℂ)) = (∑ a : Idx, (chi e a : ℂ)) * (-1) := by
      calc
        (∑ a : Idx, (chi e a : ℂ))
            = ∑ a : Idx, (chi e (a + w) : ℂ) := hbij.symm
        _ = ∑ a : Idx, (chi e a : ℂ) * (-1) := by simp only [hstep]
        _ = (∑ a : Idx, (chi e a : ℂ)) * (-1) := by rw [Finset.sum_mul]
    linear_combination (1 / 2 : ℂ) * hS

/-- `Had * Had = 8 • 1`: the Hadamard matrix is a scalar multiple of an
involution, hence invertible. -/
theorem Had_mul_Had : Had * Had = (8 : ℂ) • (1 : Matrix Idx Idx ℂ) := by
  ext c d
  rw [Matrix.mul_apply]
  simp only [Had, Matrix.of_apply]
  have hstep : ∀ a : Idx, (chi c a : ℂ) * (chi a d : ℂ) = (chi (c + d) a : ℂ) := by
    intro a
    rw [chi_symm a d, chi_add_par]
    push_cast
    ring
  rw [Finset.sum_congr rfl (fun a _ => hstep a), chi_sum_orthogonality]
  rw [Matrix.smul_apply, Matrix.one_apply, smul_eq_mul]
  by_cases h : c = d
  · subst h
    simp [CharTwo.add_self_eq_zero]
  · have hcd : c + d ≠ 0 := by
      intro hc
      exact h (by rw [eq_neg_iff_add_eq_zero.mpr hc, CharTwo.neg_eq])
    rw [if_neg hcd, if_neg h, mul_zero]

/-- The nonsingular inverse of the Hadamard matrix. -/
theorem Had_inv : Had⁻¹ = (8⁻¹ : ℂ) • Had := by
  apply Matrix.inv_eq_right_inv
  rw [Matrix.mul_smul, Had_mul_Had, smul_smul]
  norm_num

/-- The Hadamard matrix packaged as a unit. -/
noncomputable def Hadu : (Matrix Idx Idx ℂ)ˣ where
  val := Had
  inv := (8⁻¹ : ℂ) • Had
  val_inv := by
    rw [Matrix.mul_smul, Had_mul_Had, smul_smul]
    norm_num
  inv_val := by
    rw [Matrix.smul_mul, Had_mul_Had, smul_smul]
    norm_num

@[simp]
theorem Hadu_val : (Hadu : Matrix Idx Idx ℂ) = Had := rfl

theorem Hadu_inv_val :
    ((Hadu⁻¹ : (Matrix Idx Idx ℂ)ˣ) : Matrix Idx Idx ℂ) = Had⁻¹ := by
  rw [Matrix.coe_units_inv, Hadu_val]

/-- The intertwining identity: the Hadamard transform sends translation-by-`v`
to the diagonal grading with eigenvalues `chi_c(v)`. -/
theorem Had_mul_Tmat (v : Idx) :
    Had * Tmat v = Ddiag (fun c => (chi c v : ℂ)) * Had := by
  ext c a
  rw [Matrix.mul_apply, Matrix.mul_apply]
  simp only [Had, Tmat, Ddiag, Matrix.of_apply, Matrix.diagonal_apply]
  rw [Finset.sum_eq_single (a + v), Finset.sum_eq_single c]
  · simp only [if_true, mul_one]
    rw [chi_add_pt]
    push_cast
    ring
  · intro b _ hb
    simp [Ne.symm hb]
  · intro h
    exact absurd (Finset.mem_univ c) h
  · intro b _ hb
    simp [hb]
  · intro h
    exact absurd (Finset.mem_univ (a + v)) h

/-- The `chi` eigenvalue of translation-by `![1,1,1]` is the XOR strand parity. -/
theorem chi_v_eq_xorSign (c : Idx) : (chi c ![1, 1, 1] : ℂ) = xorSign c := by
  rw [xorSign_eq_chi]
  have hip : ip ![1, 1, 1] c = ip c ![1, 1, 1] := by
    simp only [ip]
    exact Finset.sum_congr rfl (fun i _ => mul_comm _ _)
  simp only [chi, hip]

/-- The Furey bridge: the XOR/strand-parity grading is the Hadamard conjugate
of the translation-parity permutation `Tmat ![1,1,1]`. This realizes the C8
grading bridge as a concrete non-permutation complex change of basis. -/
theorem furey_bridge :
    Ddiag xorSign = Had * Tmat ![1, 1, 1] * Had⁻¹ := by
  have hb : Had * Tmat ![1, 1, 1] = Ddiag xorSign * Had := by
    rw [Had_mul_Tmat,
      show (fun c => (chi c ![1, 1, 1] : ℂ)) = xorSign from funext chi_v_eq_xorSign]
  have hinv : Had * Had⁻¹ = 1 := by
    rw [Had_inv, Matrix.mul_smul, Had_mul_Had, smul_smul]
    norm_num
  rw [hb, mul_assoc, hinv, mul_one]

/-! ## Separation: permutation bridges are insufficient -/

/-- A nontrivial translation matrix is not diagonal. -/
theorem Tmat_not_diagonal {v : Idx} (hv : v ≠ 0) :
    ∃ i j, i ≠ j ∧ Tmat v i j ≠ 0 := by
  refine ⟨v, 0, hv, ?_⟩
  simp [Tmat]

/-- No permutation matrix conjugates a nontrivial translation grading to a
diagonal grading. -/
theorem no_perm_bridge {v : Idx} (hv : v ≠ 0) (s : Idx -> ℂ) :
    ¬ ∃ sigma : Equiv.Perm Idx,
        Ddiag s = sigma.toPEquiv.toMatrix * Tmat v * sigma⁻¹.toPEquiv.toMatrix := by
  rintro ⟨sigma, h⟩
  obtain ⟨i, j, hij, hne⟩ := Tmat_not_diagonal hv
  refine hne (permBridge_forces_diagonal ?_ sigma h i j hij)
  intro a b hab
  simp only [Ddiag]
  exact Matrix.diagonal_apply_ne s hab

/--
Separation of bridge classes. For the C8 grading bridge there is a genuine
non-permutation Hadamard bridge, yet no permutation bridge exists. Hence the
T8 `bridge_via_perm` reduction is strictly insufficient.
-/
theorem perm_bridge_insufficient :
    (∃ B : (Matrix Idx Idx ℂ)ˣ,
        Ddiag xorSign =
          (B : Matrix Idx Idx ℂ) * Tmat ![1, 1, 1] *
            ((B⁻¹ : (Matrix Idx Idx ℂ)ˣ) : Matrix Idx Idx ℂ)) ∧
    (¬ ∃ sigma : Equiv.Perm Idx,
        Ddiag xorSign =
          sigma.toPEquiv.toMatrix * Tmat ![1, 1, 1] * sigma⁻¹.toPEquiv.toMatrix) := by
  refine ⟨⟨Hadu, ?_⟩, ?_⟩
  · rw [Hadu_val, Hadu_inv_val]
    exact furey_bridge
  · have hv : (![1, 1, 1] : Idx) ≠ 0 := by decide
    exact no_perm_bridge hv xorSign

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge.furey_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms furey_bridge

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge.perm_bridge_insufficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms perm_bridge_insufficient

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge.bridge_involution_descent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bridge_involution_descent

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge.no_perm_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_perm_bridge

end PhysicsSM.Draft.NullEdge.GateI1.Q12NonPermBridge
