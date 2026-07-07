import Mathlib

/-!
# G2-parity core for the Q12 chirality-solder audit

This module formalizes the kernel-checkable core of the Q12 G2-parity lemma.
The model is the eight-dimensional real module with XOR/Fano labels
`Idx = Fin 3 -> ZMod 2` and a sign-convention-dependent multiplication

`e_a * e_b = sigma a b * e_(a + b)`.

For each character index `c`, the diagonal map
`phi c : e_a |-> chi c a * e_a` is multiplicative for every structure-constant
function `sigma`.  Strand parity is the special character `c = ![1, 1, 1]`.

Claim boundary: this proves the algebraic G2-parity core only.  It does not
prove triality-intertwiner equivariance, the ladder-basis convention bridge, or
constraint equivariance on the physical quotient; those are separate Q12 gates.

Provenance: Aristotle project
`0a6239d5-15b0-4fe6-b560-6a002d61354f`
(`ne-q12-g2-parity-chirality-solder-audit-20260707`), clean-room
formalization of `AgentTasks/fable_parallel/Q12_answer.md` section 1a.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.G2Parity

open Finset

/-- Index set of the XOR/Fano basis. -/
abbrev Idx := Fin 3 -> ZMod 2

/-- The `F_2`-bilinear pairing `<a,c> = sum_i a_i c_i`. -/
def ip (a c : Idx) : ZMod 2 := ∑ i, a i * c i

/-- The additive character `chi_c(a) = (-1) ^ <a,c>`. -/
def chi (c a : Idx) : ℝ := (-1 : ℝ) ^ (ip a c).val

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

lemma chi_zero (a : Idx) : chi 0 a = 1 := by
  simp [chi, ip]

lemma chi_sq (c a : Idx) : chi c a * chi c a = 1 := by
  simp only [chi, ← pow_add, ← two_mul, pow_mul]
  norm_num

lemma chi_eq_pm (c a : Idx) : chi c a = 1 ∨ chi c a = -1 := by
  simp only [chi]
  rcases Nat.even_or_odd (ip a c).val with h | h
  · exact Or.inl h.neg_one_pow
  · exact Or.inr h.neg_one_pow

/-- The `+1` eigenset of `phi_c` on basis vectors is `{a | <a,c> = 0}`. -/
lemma chi_eq_one_iff (c a : Idx) : chi c a = 1 ↔ ip a c = 0 := by
  constructor
  · intro h
    by_contra hc
    have hval : (ip a c).val = 1 := by
      have := ZMod.val_lt (ip a c)
      interval_cases hv : (ip a c).val
      · exact absurd (by simpa [ZMod.val_eq_zero] using hv) hc
      · rfl
    simp only [chi, hval] at h
    norm_num at h
  · intro h
    simp [chi, h]

/-! ## G2-parity algebra core -/

/-- Diagonal characters are multiplicative for every XOR/Fano sign convention.

This is the algebra-automorphism core of the Q12 G2-parity mechanism. -/
theorem phi_omul (sigma : Idx -> Idx -> ℝ) (c : Idx) (x y : Idx -> ℝ) :
    phi c (omul sigma x y) = omul sigma (phi c x) (phi c y) := by
  funext k
  simp only [phi, omul, Finset.mul_sum]
  refine Finset.sum_congr rfl (fun a _ => Finset.sum_congr rfl (fun b _ => ?_))
  by_cases h : a + b = k
  · subst h
    simp only [if_true]
    rw [chi_add_pt]
    ring
  · simp only [h, if_false, mul_zero]

/-- The diagonal character as a real-linear endomorphism. -/
def phiL (c : Idx) : (Idx -> ℝ) →ₗ[ℝ] (Idx -> ℝ) where
  toFun := phi c
  map_add' x y := by
    funext a
    simp [phi, mul_add]
  map_smul' r x := by
    funext a
    simp [phi]
    ring

@[simp] lemma phiL_apply (c : Idx) (x : Idx -> ℝ) : phiL c x = phi c x := rfl

/-- Linear-map form of the automorphism property. -/
theorem phiL_omul (sigma : Idx -> Idx -> ℝ) (c : Idx) (x y : Idx -> ℝ) :
    phiL c (omul sigma x y) = omul sigma (phiL c x) (phiL c y) := by
  simpa using phi_omul sigma c x y

/-- The zero character gives the identity map. -/
theorem phiL_zero : phiL (0 : Idx) = LinearMap.id := by
  ext x a
  simp [phiL, phi, chi_zero]

/-- Every diagonal character is an involution. -/
theorem phiL_selfInverse (c : Idx) : (phiL c).comp (phiL c) = LinearMap.id := by
  ext x a
  simp only [phiL, phi, LinearMap.comp_apply, LinearMap.coe_mk, AddHom.coe_mk,
    LinearMap.id_apply]
  rw [← mul_assoc, chi_sq, one_mul]

/-- The character maps compose according to XOR of character indices. -/
theorem phiL_comp (c d : Idx) : (phiL c).comp (phiL d) = phiL (c + d) := by
  ext x a
  simp only [phiL, phi, LinearMap.comp_apply, LinearMap.coe_mk, AddHom.coe_mk]
  rw [← mul_assoc, ← chi_add_par]

/-! ## Strand-parity balance -/

/-- The `+1` eigenset of strand parity has cardinality `4`. -/
theorem parity_fixed_card :
    (Finset.univ.filter (fun a : Idx => ip a ![1, 1, 1] = 0)).card = 4 := by
  decide

/-- The `-1` eigenset of strand parity has cardinality `4`. -/
theorem parity_odd_card :
    (Finset.univ.filter (fun a : Idx => ip a ![1, 1, 1] = 1)).card = 4 := by
  decide

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.G2Parity.phi_omul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phi_omul

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.G2Parity.phiL_omul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phiL_omul

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.G2Parity.phiL_comp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phiL_comp

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.G2Parity.parity_fixed_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parity_fixed_card

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.G2Parity.parity_odd_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parity_odd_card

end PhysicsSM.Draft.NullEdge.GateI1.G2Parity
