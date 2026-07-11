import PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature

/-!
# Rational disk of positive complements to the named even channels

The live even Krein-self-adjoint sector has signature
`(4,2)`. This module asks for a complete finite classification of positive
complement rays orthogonal to the three named even channels. The expected
moduli are the rational points of the open unit disk.

This is a carrier-specific realization of standard finite-dimensional Krein
geometry. It does not claim invention of positive Grassmannians, identify one
disk point as physical, or classify channel decompositions modulo the still-
open carrier/gauge equivalence relation.

Provenance: theorem design from the overnight publication run. Aristotle
project `ef95daca-28e5-4385-80f3-86b34163295b` supplied the first eleven proof
components; the final unique-normal-form proof and semantic audit were completed
locally against the live carrier. The locally guarded source is authoritative.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk

open CarrierRigidity.Concrete
open ChannelKreinMetricNoGo
open ChannelKreinSectorSignature

/-- Bilinear form in the exact six-coordinate normal form. -/
theorem normalForm_gram_bilinear
    (a d e g b f a' d' e' g' b' f' : ℚ) :
    kreinGram (normalForm a d e g b f)
        (normalForm a' d' e' g' b' f') =
      a * a' + d * d' + e * e' + g * g' - 2 * b * b' - 2 * f * f' := by
  simp only [kreinGram, kadj, normalForm, eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Fin.sum_univ_four, Matrix.transpose_apply,
    Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val]
  ring

/-- A four-coordinate candidate positive sector indexed by a disk point. -/
def tiltedPositive (u v m x e g : ℚ) : N :=
  normalForm (m + x) (m - x) e g (u * x) (v * x)

/-- Membership in the four-coordinate sector indexed by `(u,v)`. -/
def InTiltedSector (u v : ℚ) (X : N) : Prop :=
  ∃ m x e g : ℚ, X = tiltedPositive u v m x e g

/-- The positive complement direction indexed by `(u,v)`. -/
def diskVector (u v : ℚ) : N := normalForm 1 (-1) 0 0 u v

/-! ## Helper lemmas -/

/-- The three named even channels in six-coordinate normal form. -/
theorem apertureC_normalForm : apertureC = normalForm 0 0 4 10 0 0 := by
  rw [aperture_val]
  ext i j; fin_cases i <;> fin_cases j <;> simp [normalForm]

theorem closureC_normalForm : closureC = normalForm 0 0 4 8 0 0 := by
  rw [closure_val]
  ext i j; fin_cases i <;> fin_cases j <;> simp [normalForm]

theorem turnC_normalForm : turnC = normalForm 1 1 1 1 0 0 := by
  rw [turn_val]
  ext i j; fin_cases i <;> fin_cases j <;> simp [normalForm]

/-- Scalar multiples of `normalForm` are again `normalForm`. -/
theorem smul_normalForm (s a d e g b f : ℚ) :
    s • normalForm a d e g b f =
      normalForm (s * a) (s * d) (s * e) (s * g) (s * b) (s * f) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [normalForm]

/-- Scalar multiples of the disk direction. -/
theorem smul_diskVector (s u v : ℚ) :
    s • diskVector u v = normalForm s (-s) 0 0 (s * u) (s * v) := by
  rw [diskVector, smul_normalForm]
  ring_nf

theorem tiltedPositive_selfadjoint (u v m x e g : ℚ) :
    kadj (tiltedPositive u v m x e g) = tiltedPositive u v m x e g := by
  unfold tiltedPositive
  exact normalForm_selfadjoint _ _ _ _ _ _

theorem tiltedPositive_even (u v m x e g : ℚ) :
    Gam * tiltedPositive u v m x e g =
      tiltedPositive u v m x e g * Gam := by
  unfold tiltedPositive
  exact normalForm_even _ _ _ _ _ _

/-- Exact diagonalization of the metric on every tilted family. -/
theorem tiltedPositive_gram (u v m x e g : ℚ) :
    kreinGram (tiltedPositive u v m x e g)
        (tiltedPositive u v m x e g) =
      2 * m ^ 2 + e ^ 2 + g ^ 2 + 2 * (1 - u ^ 2 - v ^ 2) * x ^ 2 := by
  unfold tiltedPositive
  rw [normalForm_gram]
  ring

/-- Every rational point of the open disk gives a positive-definite family. -/
theorem tiltedPositive_strict {u v m x e g : ℚ}
    (hDisk : u ^ 2 + v ^ 2 < 1)
    (hnz : m ≠ 0 ∨ x ≠ 0 ∨ e ≠ 0 ∨ g ≠ 0) :
    0 < kreinGram (tiltedPositive u v m x e g)
      (tiltedPositive u v m x e g) := by
  rw [tiltedPositive_gram]
  have hpos : 0 < 1 - u ^ 2 - v ^ 2 := by linarith
  rcases hnz with h | h | h | h
  · have : 0 < m ^ 2 := by positivity
    nlinarith [sq_nonneg e, sq_nonneg g, sq_nonneg x, mul_nonneg (le_of_lt hpos) (sq_nonneg x)]
  · have : 0 < x ^ 2 := by positivity
    nlinarith [sq_nonneg m, sq_nonneg e, sq_nonneg g, mul_pos hpos this]
  · have : 0 < e ^ 2 := by positivity
    nlinarith [sq_nonneg m, sq_nonneg g, mul_nonneg (le_of_lt hpos) (sq_nonneg x)]
  · have : 0 < g ^ 2 := by positivity
    nlinarith [sq_nonneg m, sq_nonneg e, mul_nonneg (le_of_lt hpos) (sq_nonneg x)]

/-- Coordinates in a fixed tilted family are unique. -/
theorem tiltedPositive_coordinates_unique {u v m x e g m' x' e' g' : ℚ}
    (h : tiltedPositive u v m x e g = tiltedPositive u v m' x' e' g') :
    m = m' ∧ x = x' ∧ e = e' ∧ g = g' := by
  unfold tiltedPositive at h
  obtain ⟨h1, h2, h3, h4, _, _⟩ := normalForm_coordinates_unique h
  exact ⟨by linarith, by linarith, h3, h4⟩

/-- All three named even channels lie in every tilted family. -/
theorem named_channels_in_every_tiltedSector (u v : ℚ) :
    InTiltedSector u v apertureC ∧
      InTiltedSector u v closureC ∧
      InTiltedSector u v turnC := by
  refine ⟨⟨0, 0, 4, 10, ?_⟩, ⟨0, 0, 4, 8, ?_⟩, ⟨1, 0, 1, 1, ?_⟩⟩
  · rw [apertureC_normalForm, tiltedPositive]; ring_nf
  · rw [closureC_normalForm, tiltedPositive]; ring_nf
  · rw [turnC_normalForm, tiltedPositive]; ring_nf

/-- The indexed complement direction belongs to its tilted family. -/
theorem diskVector_mem_tiltedSector (u v : ℚ) :
    InTiltedSector u v (diskVector u v) := by
  refine ⟨0, 1, 0, 0, ?_⟩
  rw [diskVector, tiltedPositive]; ring_nf

/-- Distinct disk points give distinct represented positive families. -/
theorem tiltedSectors_distinct {u v u' v' : ℚ}
    (h : u ≠ u' ∨ v ≠ v') :
    ∃ X : N, InTiltedSector u v X ∧ ¬ InTiltedSector u' v' X := by
  refine ⟨diskVector u v, diskVector_mem_tiltedSector u v, ?_⟩
  rintro ⟨m, x, e, g, hEq⟩
  rw [diskVector, tiltedPositive] at hEq
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := normalForm_coordinates_unique hEq
  -- h1 : 1 = m + x, h2 : -1 = m - x, h5 : u = u' * x, h6 : v = v' * x
  have hx : x = 1 := by linarith
  rw [hx, mul_one] at h5 h6
  rcases h with hu | hv
  · exact hu (h5.symm ▸ rfl)
  · exact hv (h6.symm ▸ rfl)

/-- Positive vectors orthogonal to all three named channels have a unique
normalized rational disk coordinate and a unique nonzero scale. -/
theorem positive_named_orthogonal_normal_form
    (X : N) (hself : kadj X = X) (heven : Gam * X = X * Gam)
    (hA : kreinGram X apertureC = 0)
    (hC : kreinGram X closureC = 0)
    (hT : kreinGram X turnC = 0)
    (hpos : 0 < kreinGram X X) :
    ∃! q : (ℚ × ℚ) × ℚ,
      q.1.1 ^ 2 + q.1.2 ^ 2 < 1 ∧
      q.2 ≠ 0 ∧ X = q.2 • diskVector q.1.1 q.1.2 := by
  obtain ⟨a, d, e, g, b, f, hX⟩ :=
    even_selfadjoint_exists_normalForm X hself heven
  rw [hX, apertureC_normalForm, normalForm_gram_bilinear] at hA
  rw [hX, closureC_normalForm, normalForm_gram_bilinear] at hC
  rw [hX, turnC_normalForm, normalForm_gram_bilinear] at hT
  rw [hX, normalForm_gram] at hpos
  have he0 : e = 0 := by linarith
  have hg0 : g = 0 := by linarith
  have hd : d = -a := by linarith
  rw [he0, hg0, hd] at hpos
  ring_nf at hpos
  have ha : a ≠ 0 := by
    intro ha0
    subst a
    nlinarith [sq_nonneg b, sq_nonneg f]
  have ha2 : 0 < a ^ 2 := by positivity
  have hbf : b ^ 2 + f ^ 2 < a ^ 2 := by
    nlinarith [sq_nonneg b, sq_nonneg f]
  have hDisk : (b / a) ^ 2 + (f / a) ^ 2 < 1 := by
    rw [div_pow, div_pow, ← add_div]
    exact (div_lt_one ha2).2 hbf
  refine ⟨((b / a, f / a), a), ⟨hDisk, ha, ?_⟩, ?_⟩
  · rw [hX, he0, hg0, hd, smul_diskVector]
    congr 1 <;> field_simp
  · rintro ⟨⟨u, v⟩, s⟩ ⟨_, hs, hEq⟩
    rw [hX, he0, hg0, hd, smul_diskVector] at hEq
    rcases normalForm_coordinates_unique hEq with
      ⟨has, _, _, _, hbu, hfv⟩
    change a = s at has
    change b = s * u at hbu
    change f = s * v at hfv
    apply Prod.ext
    · apply Prod.ext
      · dsimp
        apply (eq_div_iff ha).2
        rw [has]
        simpa [mul_comm] using hbu.symm
      · dsimp
        apply (eq_div_iff ha).2
        rw [has]
        simpa [mul_comm] using hfv.symm
    · exact has.symm

/-- Interior nondegeneracy witness. -/
theorem interior_witness_positive :
    0 < kreinGram (diskVector (3 / 5) 0) (diskVector (3 / 5) 0) := by
  rw [diskVector, normalForm_gram]; norm_num

/-- Unit-circle boundary control: the complement becomes null. -/
theorem boundary_witness_null :
    kreinGram (diskVector (3 / 5) (4 / 5))
      (diskVector (3 / 5) (4 / 5)) = 0 := by
  rw [diskVector, normalForm_gram]; norm_num

/-! ## Build-enforced assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk.normalForm_gram_bilinear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalForm_gram_bilinear

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk.tiltedPositive_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tiltedPositive_strict

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk.tiltedSectors_distinct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tiltedSectors_distinct

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk.positive_named_orthogonal_normal_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_named_orthogonal_normal_form

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk.boundary_witness_null' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boundary_witness_null

end PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk
