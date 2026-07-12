import PhysicsSM.Draft.NullEdge.CommutatorRegulator

/-!
# Pi-periodicity of exact phase commutator regulators

A simultaneous sign flip of the cosine/sine pair multiplies a phase step by
the central scalar `-1`.  Each commutator angle appears twice, so those signs
cancel.  Thus affine offsets do not make a pure integer-frequency commutator
act on cubic `0/pi` corners: its value there equals its value at the origin.

Provenance: internal construction, with all proof bodies completed by Aristotle
project `a87b13d6-3344-49fb-adeb-a0f52f4fae31` on 2026-07-11.
-/

namespace PhysicsSM.Draft.NullEdge.CommutatorPiPeriodicity

open CommutatorRegulator

theorem phaseStep_flip_pair (c s : Real) (A : M4) :
    phaseStep (-c) (-s) A = -(phaseStep c s A) := by
  simp only [phaseStep, Complex.ofReal_neg, mul_neg, neg_smul]
  module

theorem regulator_flip_first_pair
    (cp sp cq sq : Real) (A G : M4) :
    regulator (-cp) (-sp) cq sq A G = regulator cp sp cq sq A G := by
  unfold regulator
  rw [neg_neg, phaseStep_flip_pair cp sp A,
    show phaseStep (-cp) sp A = -(phaseStep cp (-sp) A) by
      have := phaseStep_flip_pair cp (-sp) A; simpa using this]
  simp only [Matrix.neg_mul, Matrix.mul_neg, neg_neg]

theorem regulator_flip_second_pair
    (cp sp cq sq : Real) (A G : M4) :
    regulator cp sp (-cq) (-sq) A G = regulator cp sp cq sq A G := by
  unfold regulator
  rw [neg_neg, phaseStep_flip_pair cq sq G,
    show phaseStep (-cq) sq G = -(phaseStep cq (-sq) G) by
      have := phaseStep_flip_pair cq (-sq) G; simpa using this]
  simp only [Matrix.mul_neg, Matrix.neg_mul, neg_neg]

theorem regulator_flip_both_pairs
    (cp sp cq sq : Real) (A G : M4) :
    regulator (-cp) (-sp) (-cq) (-sq) A G =
      regulator cp sp cq sq A G := by
  rw [regulator_flip_first_pair, regulator_flip_second_pair]

def cornerSign (b : Bool) : Real := if b then -1 else 1

/-- Abstract algebraic form of affine-corner invisibility: each corner changes
an offset angle pair only by a common sign. -/
theorem regulator_corner_sign_invariant
    (bp bq : Bool) (cp sp cq sq : Real) (A G : M4) :
    regulator (cornerSign bp * cp) (cornerSign bp * sp)
        (cornerSign bq * cq) (cornerSign bq * sq) A G =
      regulator cp sp cq sq A G := by
  cases bp <;> cases bq <;>
    simp only [cornerSign, Bool.false_eq_true, if_true, if_false,
      neg_one_mul, one_mul, regulator_flip_first_pair,
      regulator_flip_second_pair]

/-- Negative control: a single phase step does see the sign flip; cancellation
is specific to the commutator architecture. -/
theorem phaseStep_flip_pair_ne_same :
    phaseStep (-1) 0 (1 : M4) ≠ phaseStep 1 0 (1 : M4) := by
  intro h
  have := congr_fun (congr_fun h 0) 0
  norm_num [phaseStep] at this

end PhysicsSM.Draft.NullEdge.CommutatorPiPeriodicity
