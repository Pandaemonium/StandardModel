import Mathlib

/-!
# Q12 T5-T8: triality intertwiners and convention bridge

This module is the finite algebra/operator core for Q12 audit gates T5-T8.
It works on the XOR/Fano index set `Idx = Fin 3 -> ZMod 2`.

The results are deliberately finite:

* a concrete octonion sign cochain is certified by exhaustive finite checks;
* diagonal parity characters form triality triples and commute with cyclic
  triality monodromy on `O^3`;
* diagonal grading bridges are reduced to explicit conjugation by a permutation
  matrix, with trace/signature as a necessary kill condition.
* a genuine non-diagonal order-3 signed-permutation triality-style triple is
  proved for the `octSgn` product, together with an anti-relabelling certificate
  showing its first component is not any diagonal character.

Claim boundary: this proves finite algebra and operator gates only. It does not
prove chirality on a physical quotient, anomaly cancellation, or any physical
chirality theorem.

Provenance: `AgentTasks/fable_parallel/Q12_answer.md`; Aristotle project
`85a73a6d`, task `c416d2b3`; Aristotle project `381cc4cf`, task `b4a8948e`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q12Triality

open Finset

/-! ## Shared XOR/Fano model -/

/-- Index set of the XOR/Fano basis. -/
abbrev Idx := Fin 3 -> ZMod 2

/-- The `F_2`-bilinear pairing `<a,c> = sum_i a_i c_i`. -/
def ip (a c : Idx) : ZMod 2 :=
  ∑ i, a i * c i

/-- The additive character `chi_c(a) = (-1) ^ <a,c>`. -/
def chi (c a : Idx) : ℝ :=
  (-1 : ℝ) ^ (ip a c).val

/-- XOR-graded multiplication with arbitrary real structure constants. -/
def omul (sigma : Idx -> Idx -> ℝ) (x y : Idx -> ℝ) : Idx -> ℝ :=
  fun k => ∑ a : Idx, ∑ b : Idx, (if a + b = k then sigma a b * x a * y b else 0)

/-- The diagonal character map `phi_c(e_a) = chi_c(a) e_a`. -/
def phi (c : Idx) (x : Idx -> ℝ) : Idx -> ℝ :=
  fun a => chi c a * x a

/-! ## Character identities -/

lemma ip_add_left (a b c : Idx) : ip (a + b) c = ip a c + ip b c := by
  simp only [ip, ← Finset.sum_add_distrib, Pi.add_apply]
  congr 1
  ext i
  ring

lemma ip_add_right (a c d : Idx) : ip a (c + d) = ip a c + ip a d := by
  simp only [ip, ← Finset.sum_add_distrib, Pi.add_apply]
  congr 1
  ext i
  ring

/-- `chi_c` is a character in the basis argument. -/
lemma chi_add_pt (c a b : Idx) : chi c (a + b) = chi c a * chi c b := by
  simp only [chi, ip_add_left]
  rw [ZMod.val_add, ← neg_one_pow_eq_pow_mod_two, pow_add]

/-- `chi` is additive in the character index. -/
lemma chi_add_par (c d a : Idx) : chi (c + d) a = chi c a * chi d a := by
  simp only [chi, ip_add_right]
  rw [ZMod.val_add, ← neg_one_pow_eq_pow_mod_two, pow_add]

lemma chi_sq (c a : Idx) : chi c a * chi c a = 1 := by
  simp only [chi, ← pow_add, ← two_mul, pow_mul]
  norm_num

/-! ## T5 base: a concrete octonion sign convention -/

/--
An octonion cochain over `(ZMod 2)^3`: an upper-triangular form plus the
Fano triple term.
-/
def octF (a b : Idx) : ZMod 2 :=
  (∑ i, ∑ j, (if j.val <= i.val then a i * b j else 0)) +
    a 0 * a 1 * b 2 + a 0 * a 2 * b 1 + a 1 * a 2 * b 0

/-- The plus-or-minus-one octonion structure constant. -/
def octSgn (a b : Idx) : ℤ :=
  (-1 : ℤ) ^ (octF a b).val

/-- The `i`-th imaginary basis label. -/
def ebas (i : Fin 3) : Idx :=
  fun j => if j = i then 1 else 0

/-- Basis multiplication as `(index, sign)`. -/
def bmul (a b : Idx) : Idx × ℤ :=
  (a + b, octSgn a b)

/--
Signed associator on a basis triple. The two bracketings share the XOR index,
so only the accumulated signs can differ.
-/
def assocSign (a b c : Idx) : ℤ × ℤ :=
  ((bmul a b).2 * (bmul (bmul a b).1 c).2,
    (bmul b c).2 * (bmul a (bmul b c).1).2)

/-- Imaginary units square to `-1`. -/
theorem octSgn_unit_sq : ∀ i : Fin 3, octSgn (ebas i) (ebas i) = -1 := by
  decide

/-- The zero basis label is a left unit for the sign cochain. -/
theorem octSgn_id_left : ∀ a : Idx, octSgn 0 a = 1 := by
  decide

/-- The zero basis label is a right unit for the sign cochain. -/
theorem octSgn_id_right : ∀ a : Idx, octSgn a 0 = 1 := by
  decide

/-- Distinct imaginary units anticommute. -/
theorem octSgn_anticomm :
    ∀ i j : Fin 3, i ≠ j -> octSgn (ebas i) (ebas j) = -octSgn (ebas j) (ebas i) := by
  decide

/--
The associator is alternating on basis vectors: it vanishes whenever two basis
arguments coincide.
-/
theorem octSgn_alternative :
    ∀ a b : Idx,
      (assocSign a a b).1 = (assocSign a a b).2 ∧
      (assocSign a b a).1 = (assocSign a b a).2 ∧
      (assocSign b a a).1 = (assocSign b a a).2 := by
  decide

/-- A witnessed non-associative triple. -/
theorem octSgn_nonassoc :
    (assocSign (ebas 0) (ebas 1) (ebas 2)).1 ≠
      (assocSign (ebas 0) (ebas 1) (ebas 2)).2 := by
  decide

/-! ## T5-T7: triality intertwiners and G2-equivariance -/

/--
`(g1,g2,g3)` is a triality triple for the product `omul sigma` when
`g3 (x * y) = (g1 x) * (g2 y)` for all `x,y`.
-/
def TrialityTriple (sigma : Idx -> Idx -> ℝ)
    (g1 g2 g3 : (Idx -> ℝ) -> (Idx -> ℝ)) : Prop :=
  ∀ x y, g3 (omul sigma x y) = omul sigma (g1 x) (g2 y)

/-- The diagonal parity `phi c` gives a triality triple for every `sigma`. -/
theorem parity_triple (sigma : Idx -> Idx -> ℝ) (c : Idx) :
    TrialityTriple sigma (phi c) (phi c) (phi c) := by
  intro x y
  funext k
  simp only [phi, omul, Finset.mul_sum]
  refine Finset.sum_congr rfl (fun a _ => Finset.sum_congr rfl (fun b _ => ?_))
  by_cases h : a + b = k
  · subst h
    simp only [if_true]
    rw [chi_add_pt]
    ring
  · simp only [h, if_false, mul_zero]

/-- `phi_c` is an involution as a function. -/
lemma phi_involutive (c : Idx) (x : Idx -> ℝ) : phi c (phi c x) = x := by
  funext a
  simp only [phi]
  rw [← mul_assoc, chi_sq, one_mul]

/-- Local automorphism form of `parity_triple`. -/
lemma phi_omul_local (sigma : Idx -> Idx -> ℝ) (c : Idx) (x y : Idx -> ℝ) :
    phi c (omul sigma x y) = omul sigma (phi c x) (phi c y) :=
  parity_triple sigma c x y

/--
Conjugating a triality triple by a diagonal sign-flip automorphism yields
another triality triple.
-/
theorem trialityTriple_conj (sigma : Idx -> Idx -> ℝ) (c : Idx)
    {g1 g2 g3 : (Idx -> ℝ) -> (Idx -> ℝ)} (h : TrialityTriple sigma g1 g2 g3) :
    TrialityTriple sigma (fun x => phi c (g1 (phi c x)))
      (fun x => phi c (g2 (phi c x))) (fun x => phi c (g3 (phi c x))) := by
  intro x y
  calc
    phi c (g3 (phi c (omul sigma x y)))
        = phi c (g3 (omul sigma (phi c x) (phi c y))) := by
          rw [phi_omul_local]
    _ = phi c (omul sigma (g1 (phi c x)) (g2 (phi c y))) := by
          rw [h]
    _ = omul sigma (phi c (g1 (phi c x))) (phi c (g2 (phi c y))) := by
          rw [phi_omul_local]

/-! ## Diagonal characters as a commuting group of intertwiners -/

/-- The intertwiner group law: `phi_c o phi_d = phi_(c+d)`. -/
theorem phi_comp (c d : Idx) (x : Idx -> ℝ) : phi c (phi d x) = phi (c + d) x := by
  funext a
  simp only [phi]
  rw [← mul_assoc, ← chi_add_par]

/-- Diagonal intertwiners/parities commute. -/
theorem phi_comm (c d : Idx) (x : Idx -> ℝ) : phi c (phi d x) = phi d (phi c x) := by
  rw [phi_comp, phi_comp, add_comm]

/-! ## Parity commutes with cyclic monodromy on `O^3` -/

/-- Cyclic-shift-with-intertwiner monodromy on `O^3`. -/
def tauMon (cI : Idx) (v : Fin 3 -> (Idx -> ℝ)) : Fin 3 -> (Idx -> ℝ) :=
  fun i => phi cI (v (i - 1))

/-- Diagonal parity on `O^3`. -/
def Pdiag (cP : Idx) (v : Fin 3 -> (Idx -> ℝ)) : Fin 3 -> (Idx -> ℝ) :=
  fun i => phi cP (v i)

/-- The diagonal parity commutes with cyclic-shift-with-intertwiner monodromy. -/
theorem parity_commutes_tau (cI cP : Idx) (v : Fin 3 -> (Idx -> ℝ)) :
    Pdiag cP (tauMon cI v) = tauMon cI (Pdiag cP v) := by
  funext i
  simp only [Pdiag, tauMon]
  exact phi_comm cP cI (v (i - 1))

/-! ## T8: the convention bridge `(-1)^F_c = B phi B^-1` -/

open Matrix

/-- Diagonal grading operator from a sign vector. -/
def Ddiag (s : Idx -> ℂ) : Matrix Idx Idx ℂ :=
  Matrix.diagonal s

/-- Integer strand-parity sign. -/
def xorSignZ : Idx -> ℤ :=
  fun a => (-1 : ℤ) ^ (ip a ![1, 1, 1]).val

/-- XOR/Fano strand-parity sign vector. -/
def xorSign : Idx -> ℂ :=
  fun a => (xorSignZ a : ℂ)

/-- The complex XOR sign is the cast of the strand character. -/
lemma xorSign_eq_chi (a : Idx) : xorSign a = (chi ![1, 1, 1] a : ℂ) := by
  simp only [xorSign, xorSignZ, chi]
  push_cast
  ring

/-- The integer strand parity is balanced. -/
lemma xorSignZ_sum : ∑ a : Idx, xorSignZ a = 0 := by
  decide

/-- The XOR strand parity is balanced: trace zero, signature `(4,4)`. -/
theorem xor_parity_balanced : ∑ a : Idx, xorSign a = 0 := by
  simp only [xorSign, ← Int.cast_sum, xorSignZ_sum, Int.cast_zero]

/-- Permutation-matrix conjugation sends `Ddiag s` to `Ddiag (s o sigma)`. -/
theorem Ddiag_conj_perm (sigma : Equiv.Perm Idx) (s : Idx -> ℂ) :
    (sigma.toPEquiv.toMatrix) * Ddiag s * (sigma⁻¹.toPEquiv.toMatrix) =
      Ddiag (fun i => s (sigma i)) := by
  rw [Ddiag, Ddiag, PEquiv.toMatrix_toPEquiv_mul, PEquiv.mul_toMatrix_toPEquiv]
  ext i j
  simp only [Matrix.submatrix_apply, Matrix.diagonal_apply, id_eq, Equiv.Perm.inv_def,
    Equiv.symm_symm]
  by_cases h : i = j
  · subst h
    simp
  · rw [if_neg h, if_neg fun hc => h (sigma.injective hc)]

/--
If the ladder sign pattern is a permutation reordering of the XOR pattern, then
the permutation matrix realizes the grading bridge.
-/
theorem bridge_via_perm (sigma : Equiv.Perm Idx) (sXor sLad : Idx -> ℂ)
    (h : sLad = fun i => sXor (sigma i)) :
    Ddiag sLad =
      (sigma.toPEquiv.toMatrix) * Ddiag sXor * (sigma⁻¹.toPEquiv.toMatrix) := by
  rw [Ddiag_conj_perm, h]

/--
Trace obstruction for a grading bridge. Any invertible bridge forces the two
sign patterns to have equal trace.
-/
theorem bridge_trace_necessary (B : (Matrix Idx Idx ℂ)ˣ) (sXor sLad : Idx -> ℂ)
    (h : Ddiag sLad = (B : Matrix Idx Idx ℂ) * Ddiag sXor *
          ((B⁻¹ : (Matrix Idx Idx ℂ)ˣ) : Matrix Idx Idx ℂ)) :
    ∑ a : Idx, sLad a = ∑ a : Idx, sXor a := by
  have ht : (Ddiag sLad).trace = (Ddiag sXor).trace := by
    rw [h, Matrix.trace_units_conj]
  simpa only [Ddiag, Matrix.trace_diagonal] using ht

/-- A concrete unbalanced ladder parity: the all-`+1` grading. -/
def sLadUnbalanced : Idx -> ℂ :=
  fun _ => 1

/-- No bridge conjugates the balanced XOR parity to the all-`+1` grading. -/
theorem bridge_kill_of_unbalanced :
    ¬ ∃ B : (Matrix Idx Idx ℂ)ˣ,
        Ddiag sLadUnbalanced =
          (B : Matrix Idx Idx ℂ) * Ddiag xorSign *
            ((B⁻¹ : (Matrix Idx Idx ℂ)ˣ) : Matrix Idx Idx ℂ) := by
  rintro ⟨B, hB⟩
  have h := bridge_trace_necessary B xorSign sLadUnbalanced hB
  rw [xor_parity_balanced] at h
  simp only [sLadUnbalanced, Finset.sum_const, nsmul_eq_mul, mul_one] at h
  have hcard : (Finset.univ : Finset Idx).card = 8 := by
    decide
  rw [hcard] at h
  norm_num at h

/-! ## A genuine non-diagonal order-3 triality triple over the octSgn product

The diagonal parity results above (`parity_triple`, `phi_comp`, ...) only
produce triples `(phi c, phi c, phi c)` whose three components are equal and
are involutions (`phi_involutive`). They are the `(ZMod 2)^3` diagonal
characters, not genuine triality: genuine octonion/Spin(8) triality cyclically
relates three distinct order-3 operators.

Here we exhibit and prove such a genuine triple for the `octSgn` product itself.
The three components `gmap tri1 tc1`, `gmap tri2 tc2`, `gmap tri3 tc3` are
signed permutations whose permutation parts are pairwise distinct,
non-identity, and of order 3, and the triple satisfies the triality
intertwining `g3 (x * y) = (g1 x) * (g2 y)` for the real octonion structure
constants `octSgnR = (octSgn : Z -> R)`. Because every diagonal character
`phi c` is an involution while each `gmap tri_i tc_i` has order 3, this triple
is provably not a relabelling of a diagonal character (`gmap_tri1_ne_phi`).

The witness data was found by an exhaustive finite search over affine-monomial
triples; the two closing finite conditions (`tri_hidx`, `tri_hsgn_int`) are
certified by `decide`.
-/

/-- Real-valued octonion structure constant, `octSgnR a b = (octSgn a b : R)`. -/
def octSgnR (a b : Idx) : ℝ := (octSgn a b : ℝ)

/-- A monomial signed-permutation operator: `gmap e c x a = c a * x (e a)`. -/
def gmap (e : Idx ≃ Idx) (c : Idx -> ℝ) (x : Idx -> ℝ) : Idx -> ℝ :=
  fun a => c a * x (e a)

/-
General criterion for a triple of monomial operators to be a triality triple.

If the permutation parts `e1`, `e2`, `e3` are grading-compatible
(`e1 a + e2 b = e3 (a + b)`) and the signs satisfy the cocycle condition
`c3 (a + b) * sigma (e1 a) (e2 b) = sigma a b * c1 a * c2 b`, then
`(gmap e1 c1, gmap e2 c2, gmap e3 c3)` is a triality triple for `sigma`.
-/
theorem monomial_triality (sigma : Idx -> Idx -> ℝ) (e1 e2 e3 : Idx ≃ Idx)
    (c1 c2 c3 : Idx -> ℝ)
    (hidx : ∀ a b, e1 a + e2 b = e3 (a + b))
    (hsgn : ∀ a b, c3 (a + b) * sigma (e1 a) (e2 b) = sigma a b * c1 a * c2 b) :
    TrialityTriple sigma (gmap e1 c1) (gmap e2 c2) (gmap e3 c3) := by
  intro x y
  ext k
  simp only [gmap, omul]
  rw [Finset.mul_sum _ _ _, ← Equiv.sum_comp e1]
  refine Finset.sum_congr rfl (fun a _ => ?_)
  rw [Finset.mul_sum _ _ _, ← Equiv.sum_comp e2]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  by_cases hk : a + b = k
  · subst hk
    rw [hidx a b, if_pos rfl, if_pos rfl]
    linear_combination (x (e1 a) * y (e2 b)) * hsgn a b
  · rw [if_neg hk, hidx a b, if_neg (fun hc => hk (e3.injective hc)), mul_zero]

/-! ### The concrete witness data -/

/-- Encode `n : Nat` bits as an element of `Idx = Fin 3 -> ZMod 2`. -/
def mkIdx (n : ℕ) : Idx := fun i => if (n >>> i.val) % 2 == 1 then 1 else 0

/-- Decode an element of `Idx` to a number in `0..7`. -/
def idxNo (a : Idx) : ℕ :=
  (if a 0 = 1 then 1 else 0) + (if a 1 = 1 then 2 else 0) + (if a 2 = 1 then 4 else 0)

/-- Build a map `Idx -> Idx` from a length-8 permutation table. -/
def fromArr (arr : Array ℕ) (a : Idx) : Idx := mkIdx (arr[idxNo a]!)

/-- The first permutation part, an order-3 affine map of `Idx`. -/
def tri1 : Idx ≃ Idx :=
  ⟨fromArr #[6, 7, 0, 1, 4, 5, 2, 3], fromArr #[2, 3, 6, 7, 4, 5, 0, 1],
    by decide, by decide⟩

/-- The second permutation part. -/
def tri2 : Idx ≃ Idx :=
  ⟨fromArr #[2, 3, 4, 5, 0, 1, 6, 7], fromArr #[4, 5, 0, 1, 2, 3, 6, 7],
    by decide, by decide⟩

/-- The third permutation part. -/
def tri3 : Idx ≃ Idx :=
  ⟨fromArr #[4, 5, 2, 3, 6, 7, 0, 1], fromArr #[6, 7, 2, 3, 0, 1, 4, 5],
    by decide, by decide⟩

/-- Integer sign of the first component. -/
def cc1 : Idx -> ℤ := fun a => (#[1, -1, 1, 1, 1, 1, 1, -1] : Array ℤ)[idxNo a]!

/-- Integer sign of the second component. -/
def cc2 : Idx -> ℤ := fun a => (#[1, -1, -1, 1, -1, -1, 1, 1] : Array ℤ)[idxNo a]!

/-- Integer sign of the third component. -/
def cc3 : Idx -> ℤ := fun a => (#[1, 1, 1, 1, -1, 1, -1, 1] : Array ℤ)[idxNo a]!

/-- Real sign of the first component. -/
def tc1 : Idx -> ℝ := fun a => (cc1 a : ℝ)

/-- Real sign of the second component. -/
def tc2 : Idx -> ℝ := fun a => (cc2 a : ℝ)

/-- Real sign of the third component. -/
def tc3 : Idx -> ℝ := fun a => (cc3 a : ℝ)

/-! ### The finite closing conditions -/

/-- Grading compatibility of the permutation parts, checked by finite enumeration. -/
theorem tri_hidx : ∀ a b : Idx, tri1 a + tri2 b = tri3 (a + b) := by
  decide

/-- The sign cocycle condition, integer form, checked by finite enumeration. -/
theorem tri_hsgn_int :
    ∀ a b : Idx,
      cc3 (a + b) * octSgn (tri1 a) (tri2 b) = octSgn a b * cc1 a * cc2 b := by
  decide

/-- The sign cocycle condition over `R`. -/
theorem tri_hsgn :
    ∀ a b : Idx,
      tc3 (a + b) * octSgnR (tri1 a) (tri2 b) = octSgnR a b * tc1 a * tc2 b := by
  intro a b
  have h := tri_hsgn_int a b
  simp only [octSgnR, tc1, tc2, tc3]
  exact_mod_cast h

/-! ### The genuine triality triple -/

/-- Genuine non-diagonal order-3 triality triple for the `octSgn` product. -/
theorem genuine_triality_triple :
    TrialityTriple octSgnR (gmap tri1 tc1) (gmap tri2 tc2) (gmap tri3 tc3) :=
  monomial_triality octSgnR tri1 tri2 tri3 tc1 tc2 tc3 tri_hidx tri_hsgn

/-! ### Genuineness: non-diagonal, pairwise distinct, order 3 -/

/-- The three permutation parts are non-identity and pairwise distinct. -/
theorem tri_perm_nondiag :
    (⇑tri1 ≠ id) ∧ (⇑tri2 ≠ id) ∧ (⇑tri3 ≠ id) ∧
      (⇑tri1 ≠ ⇑tri2) ∧ (⇑tri2 ≠ ⇑tri3) ∧ (⇑tri1 ≠ ⇑tri3) := by
  decide

/-- Each permutation part has order 3: its cube is the identity. -/
theorem tri_perm_cube :
    (∀ a, tri1 (tri1 (tri1 a)) = a) ∧
      (∀ a, tri2 (tri2 (tri2 a)) = a) ∧
      (∀ a, tri3 (tri3 (tri3 a)) = a) := by
  decide

/-- The signs multiply to `1` around each order-3 orbit, integer form. -/
theorem tri_sign_orbit_int :
    (∀ a, cc1 a * cc1 (tri1 a) * cc1 (tri1 (tri1 a)) = 1) ∧
      (∀ a, cc2 a * cc2 (tri2 a) * cc2 (tri2 (tri2 a)) = 1) ∧
      (∀ a, cc3 a * cc3 (tri3 a) * cc3 (tri3 (tri3 a)) = 1) := by
  decide

/-- The first operator has order dividing 3: its cube is the identity map. -/
theorem gmap_tri1_cube (x : Idx -> ℝ) :
    gmap tri1 tc1 (gmap tri1 tc1 (gmap tri1 tc1 x)) = x := by
  funext a
  simp only [gmap]
  rw [tri_perm_cube.1 a]
  have h : tc1 a * tc1 (tri1 a) * tc1 (tri1 (tri1 a)) = 1 := by
    simp only [tc1]
    exact_mod_cast tri_sign_orbit_int.1 a
  linear_combination (x a) * h

/-- The second operator cubes to the identity. -/
theorem gmap_tri2_cube (x : Idx -> ℝ) :
    gmap tri2 tc2 (gmap tri2 tc2 (gmap tri2 tc2 x)) = x := by
  funext a
  simp only [gmap]
  rw [tri_perm_cube.2.1 a]
  have h : tc2 a * tc2 (tri2 a) * tc2 (tri2 (tri2 a)) = 1 := by
    simp only [tc2]
    exact_mod_cast tri_sign_orbit_int.2.1 a
  linear_combination (x a) * h

/-- The third operator cubes to the identity. -/
theorem gmap_tri3_cube (x : Idx -> ℝ) :
    gmap tri3 tc3 (gmap tri3 tc3 (gmap tri3 tc3 x)) = x := by
  funext a
  simp only [gmap]
  rw [tri_perm_cube.2.2 a]
  have h : tc3 a * tc3 (tri3 a) * tc3 (tri3 (tri3 a)) = 1 := by
    simp only [tc3]
    exact_mod_cast tri_sign_orbit_int.2.2 a
  linear_combination (x a) * h

/-- The square of the first operator is not the identity, witnessed by the
indicator of `mkIdx 0`. -/
theorem gmap_tri1_sq_ne_id :
    gmap tri1 tc1 (gmap tri1 tc1 (fun a => if a = mkIdx 0 then (1 : ℝ) else 0))
      ≠ (fun a => if a = mkIdx 0 then (1 : ℝ) else 0) := by
  intro h
  have hcontra := congr_fun h (mkIdx 0)
  simp +decide [gmap, tc1] at hcontra

/-- Genuineness / anti-relabelling: the first triality component is not any
diagonal character `phi c`. -/
theorem gmap_tri1_ne_phi (c : Idx) : gmap tri1 tc1 ≠ phi c := by
  intro h
  apply gmap_tri1_sq_ne_id
  rw [h]
  exact phi_involutive c _

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.octSgn_alternative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms octSgn_alternative

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.parity_triple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parity_triple

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.trialityTriple_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trialityTriple_conj

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.parity_commutes_tau' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parity_commutes_tau

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.bridge_trace_necessary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bridge_trace_necessary

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.bridge_kill_of_unbalanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bridge_kill_of_unbalanced

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.genuine_triality_triple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms genuine_triality_triple

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.gmap_tri1_ne_phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gmap_tri1_ne_phi

end PhysicsSM.Draft.NullEdge.GateI1.Q12Triality
