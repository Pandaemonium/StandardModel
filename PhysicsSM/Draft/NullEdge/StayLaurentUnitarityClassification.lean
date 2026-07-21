import Mathlib

/-!
# Exact classification of a range-one stay/shift walk

For the translation-invariant one-axis symbol

`U(z) = z Gplus + Gzero + z^-1 Gminus`,

this module proves that exact two-sided unitarity at every unit-circle phase is
equivalent to ten finite Laurent-coefficient identities.  The onsite term
`Gzero` is therefore a controlled algebraic resource: when it vanishes, the
forward and backward ranges are forced to be orthogonal in both multiplication
orders.

The coefficient extraction uses five explicit circle phases.  It assumes no
continuity or analyticity.  The result is a one-axis classification input for
the `3+1` walk program; it does not itself construct a `3+1` walk, establish a
Dirac continuum limit, or remove all quasienergy aliases.

Provenance: theorem statements prepared in
`AgentTasks/aristotle-standalone/stay-laurent-unitarity-20260719`; proofs
completed by Aristotle project `c8f5634c-c200-443f-82b3-25d8a4e6dd37`, task
`6643e246-860e-413d-a07b-425b001bea52`, and independently rebuilt under the
repository's pinned Lean toolchain on 2026-07-19.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StayLaurentUnitarityClassification

variable {n : Type*} [Fintype n] [DecidableEq n]

abbrev Mat (n : Type*) := Matrix n n Complex

/-- Exact two-sided matrix unitarity. -/
def IsUnitary (U : Mat n) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

/-- Algebraic unit-circle predicate in the form used by coefficient expansion. -/
def OnCircle (z : Complex) : Prop :=
  z ≠ 0 ∧ starRingEnd Complex z = z⁻¹

/-- Range-one forward/stay/backward Laurent symbol. -/
def symbol (Gplus Gzero Gminus : Mat n) (z : Complex) : Mat n :=
  z • Gplus + Gzero + z⁻¹ • Gminus

/-- The ten Laurent-coefficient identities obtained from `Uᴴ U = 1` and
`U Uᴴ = 1`. -/
structure Certificate (Gplus Gzero Gminus : Mat n) : Prop where
  left_const :
    Gplus.conjTranspose * Gplus + Gzero.conjTranspose * Gzero +
      Gminus.conjTranspose * Gminus = 1
  left_plus_one :
    Gzero.conjTranspose * Gplus + Gminus.conjTranspose * Gzero = 0
  left_minus_one :
    Gplus.conjTranspose * Gzero + Gzero.conjTranspose * Gminus = 0
  left_plus_two : Gminus.conjTranspose * Gplus = 0
  left_minus_two : Gplus.conjTranspose * Gminus = 0
  right_const :
    Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
      Gminus * Gminus.conjTranspose = 1
  right_plus_one :
    Gplus * Gzero.conjTranspose + Gzero * Gminus.conjTranspose = 0
  right_minus_one :
    Gzero * Gplus.conjTranspose + Gminus * Gzero.conjTranspose = 0
  right_plus_two : Gplus * Gminus.conjTranspose = 0
  right_minus_two : Gminus * Gplus.conjTranspose = 0

/-- A coefficient certificate is sufficient for exact unitarity at every
unit-circle phase. -/
theorem unitary_of_certificate (Gplus Gzero Gminus : Mat n)
    (h : Certificate Gplus Gzero Gminus) :
    ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z) := by
  intro z hz
  obtain ⟨h_left, h_right⟩ := h
  constructor <;> simp_all +decide [symbol, OnCircle]
  · simp_all +decide [add_mul, mul_add, smul_smul]
    simp_all +decide [← eq_sub_iff_add_eq', ← add_assoc]
    abel1
  · simp_all +decide [Matrix.mul_add, Matrix.add_mul]
    simp_all +decide [add_eq_zero_iff_eq_neg]
    grind

/-- A Laurent polynomial of degree at most two which vanishes on the unit
circle has all five coefficients zero.  Five explicit phases suffice. -/
lemma scalar_laurent_coefficients (a b c d e : Complex)
    (h : ∀ z, OnCircle z →
      z ^ 2 * a + z * b + c + z⁻¹ * d + (z⁻¹) ^ 2 * e = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 := by
  have h_eq : ∀ z : ℂ,
      z = 1 ∨ z = -1 ∨ z = Complex.I ∨ z = -Complex.I ∨
        z = (3 + 4 * Complex.I) / 5 →
      z ^ 2 * a + z * b + c + z⁻¹ * d + z⁻¹ ^ 2 * e = 0 := by
    intro z hz
    apply h z
    rcases hz with (rfl | rfl | rfl | rfl | rfl) <;>
      norm_num [Complex.ext_iff, OnCircle]
    norm_num [Complex.normSq, Complex.div_re, Complex.div_im]
  norm_num [Complex.ext_iff, sq] at *
  have h1 := h_eq ⟨1, 0⟩
  have h2 := h_eq ⟨-1, 0⟩
  have h3 := h_eq ⟨0, 1⟩
  have h4 := h_eq ⟨0, -1⟩
  have h5 := h_eq ⟨3 / 5, 4 / 5⟩
  norm_num at *
  exact ⟨⟨by linarith, by linarith⟩,
    ⟨by linarith, by linarith⟩,
    ⟨by linarith, by linarith⟩,
    ⟨by linarith, by linarith⟩,
    by linarith, by linarith⟩

/- Exact unitarity at every unit-circle phase determines all ten Laurent
coefficients. -/
set_option maxHeartbeats 800000 in
theorem certificate_of_unitary_on_circle (Gplus Gzero Gminus : Mat n)
    (h : ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z)) :
    Certificate Gplus Gzero Gminus := by
  obtain ⟨h_left, h_right⟩ :
      (∀ i j, (Gplus.conjTranspose * Gplus + Gzero.conjTranspose * Gzero +
        Gminus.conjTranspose * Gminus - 1) i j = 0) ∧
      (∀ i j, (Gzero.conjTranspose * Gplus +
        Gminus.conjTranspose * Gzero) i j = 0) ∧
      (∀ i j, (Gplus.conjTranspose * Gzero +
        Gzero.conjTranspose * Gminus) i j = 0) ∧
      (∀ i j, (Gminus.conjTranspose * Gplus) i j = 0) ∧
      (∀ i j, (Gplus.conjTranspose * Gminus) i j = 0) := by
    have h_coeff : ∀ i j, ∀ z : ℂ, OnCircle z →
        z ^ 2 * (Gminus.conjTranspose * Gplus) i j +
          z * (Gzero.conjTranspose * Gplus +
            Gminus.conjTranspose * Gzero) i j +
          (Gplus.conjTranspose * Gplus + Gzero.conjTranspose * Gzero +
            Gminus.conjTranspose * Gminus - 1) i j +
          z⁻¹ * (Gplus.conjTranspose * Gzero +
            Gzero.conjTranspose * Gminus) i j +
          (z⁻¹) ^ 2 * (Gplus.conjTranspose * Gminus) i j = 0 := by
      intro i j z hz
      have h_expand :
          (z • Gplus + Gzero + z⁻¹ • Gminus).conjTranspose *
            (z • Gplus + Gzero + z⁻¹ • Gminus) = 1 := by
        exact (h z hz).1
      convert sub_eq_zero.mpr (congr_fun (congr_fun h_expand i) j) using 1 <;>
        simp +decide [Matrix.mul_apply, Finset.sum_add_distrib, add_mul,
          mul_add, sq, mul_assoc, mul_left_comm, hz.2]
      simp +decide [mul_assoc, Finset.mul_sum _ _ _, hz.1]
      ring
    have h_coeff_zero : ∀ i j,
        (Gminus.conjTranspose * Gplus) i j = 0 ∧
        (Gzero.conjTranspose * Gplus +
          Gminus.conjTranspose * Gzero) i j = 0 ∧
        (Gplus.conjTranspose * Gplus + Gzero.conjTranspose * Gzero +
          Gminus.conjTranspose * Gminus - 1) i j = 0 ∧
        (Gplus.conjTranspose * Gzero +
          Gzero.conjTranspose * Gminus) i j = 0 ∧
        (Gplus.conjTranspose * Gminus) i j = 0 := by
      intro i j
      apply scalar_laurent_coefficients
      exact h_coeff i j
    exact ⟨fun i j => (h_coeff_zero i j).2.2.1,
      fun i j => (h_coeff_zero i j).2.1,
      fun i j => (h_coeff_zero i j).2.2.2.1,
      fun i j => (h_coeff_zero i j).1,
      fun i j => (h_coeff_zero i j).2.2.2.2⟩
  obtain ⟨h_left, h_right⟩ :
      (∀ i j, (Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
        Gminus * Gminus.conjTranspose - 1) i j = 0) ∧
      (∀ i j, (Gplus * Gzero.conjTranspose +
        Gzero * Gminus.conjTranspose) i j = 0) ∧
      (∀ i j, (Gzero * Gplus.conjTranspose +
        Gminus * Gzero.conjTranspose) i j = 0) ∧
      (∀ i j, (Gplus * Gminus.conjTranspose) i j = 0) ∧
      (∀ i j, (Gminus * Gplus.conjTranspose) i j = 0) := by
    have h_right : ∀ z, OnCircle z →
        symbol Gplus Gzero Gminus z *
          (symbol Gplus Gzero Gminus z).conjTranspose = 1 := by
      exact fun z hz => (h z hz).2
    have h_right : ∀ i j, ∀ z, OnCircle z →
        z ^ 2 * (Gplus * Gminus.conjTranspose) i j +
          z * (Gplus * Gzero.conjTranspose +
            Gzero * Gminus.conjTranspose) i j +
          (Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
            Gminus * Gminus.conjTranspose - 1) i j +
          z⁻¹ * (Gzero * Gplus.conjTranspose +
            Gminus * Gzero.conjTranspose) i j +
          (z⁻¹) ^ 2 * (Gminus * Gplus.conjTranspose) i j = 0 := by
      intro i j z hz
      have h_expand :
          symbol Gplus Gzero Gminus z *
              (symbol Gplus Gzero Gminus z).conjTranspose =
            z ^ 2 • (Gplus * Gminus.conjTranspose) +
            z • (Gplus * Gzero.conjTranspose +
              Gzero * Gminus.conjTranspose) +
            (Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
              Gminus * Gminus.conjTranspose) +
            z⁻¹ • (Gzero * Gplus.conjTranspose +
              Gminus * Gzero.conjTranspose) +
            (z⁻¹) ^ 2 • (Gminus * Gplus.conjTranspose) := by
        unfold symbol
        simp +decide [Matrix.mul_add, Matrix.add_mul, hz.2] <;> ring
        simp +decide [sq, hz.1] <;> abel_nf
        simp +decide [smul_smul] <;> abel_nf
      replace h_expand := congr_fun (congr_fun h_expand i) j
      simp_all +decide [Matrix.mul_apply, Matrix.add_apply, Matrix.sub_apply]
      replace h_right := congr_fun (congr_fun (h_right z hz) i) j
      simp_all +decide [Matrix.mul_apply, Matrix.one_apply]
      linear_combination' h_right
    have h_right : ∀ i j,
        (Gplus * Gminus.conjTranspose) i j = 0 ∧
        (Gplus * Gzero.conjTranspose +
          Gzero * Gminus.conjTranspose) i j = 0 ∧
        (Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
          Gminus * Gminus.conjTranspose - 1) i j = 0 ∧
        (Gzero * Gplus.conjTranspose +
          Gminus * Gzero.conjTranspose) i j = 0 ∧
        (Gminus * Gplus.conjTranspose) i j = 0 := by
      intro i j
      apply scalar_laurent_coefficients
      exact h_right i j
    exact ⟨fun i j => (h_right i j).2.2.1,
      fun i j => (h_right i j).2.1,
      fun i j => (h_right i j).2.2.2.1,
      fun i j => (h_right i j).1,
      fun i j => (h_right i j).2.2.2.2⟩
  constructor
  all_goals ext i j
  all_goals simp_all +decide [sub_eq_iff_eq_add]

/-- Exact classification: the ten coefficient identities are necessary and
sufficient for unitary circle symbols. -/
theorem certificate_iff_unitary_on_circle (Gplus Gzero Gminus : Mat n) :
    Certificate Gplus Gzero Gminus ↔
      ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z) := by
  exact ⟨unitary_of_certificate Gplus Gzero Gminus,
    certificate_of_unitary_on_circle Gplus Gzero Gminus⟩

/-- If the onsite amplitude vanishes, the certificate forces the forward and
backward ranges to be orthogonal in both multiplication orders. -/
theorem noStay_forces_shift_orthogonality
    (Gplus Gminus : Mat n) (h : Certificate Gplus 0 Gminus) :
    Gminus.conjTranspose * Gplus = 0 ∧
      Gplus.conjTranspose * Gminus = 0 ∧
      Gplus * Gminus.conjTranspose = 0 ∧
      Gminus * Gplus.conjTranspose = 0 := by
  exact ⟨h.left_plus_two, h.left_minus_two,
    h.right_plus_two, h.right_minus_two⟩

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.StayLaurentUnitarityClassification.certificate_iff_unitary_on_circle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms certificate_iff_unitary_on_circle

end PhysicsSM.Draft.NullEdge.StayLaurentUnitarityClassification
