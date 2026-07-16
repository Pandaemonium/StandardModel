import PhysicsSM.Draft.NullEdge.FiniteGibbsInequality

/-!
# Finite classical data processing for relative entropy

For a nonnegative column-stochastic kernel `T : n -> m -> Real`, this module
proves that finite relative entropy cannot increase under the push-forward

```text
(T p) i = sum_j T i j p j.
```

The stochastic convention is important: `T i j` is the probability of output
`i` given input `j`, so each input column satisfies `sum_i T i j = 1`. The
theorem assumes `p` is nonnegative and `q` is strictly positive. It includes an
identity-channel equality control and an explicit many-to-one channel on which
the inequality is strict.

This is a generic finite information-theory theorem. It does not identify a
physical gravitational coarse-graining channel or derive a gravitational
response law.

Provenance: clean-room integration of Aristotle project
`74503dba-277a-4579-8e76-4c03b481c6b1`, task
`6cbd1e62-dde4-4f47-a8d2-4e959fb328ec`. The submitted target statement was
returned unchanged and independently replayed under the repository toolchain
on 2026-07-12. The proof uses Mathlib's convexity theorem for `x log x`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteClassicalDPI

open scoped BigOperators

variable {m n : Type*} [Fintype m] [Fintype n]

/-- Finite relative entropy with Mathlib's convention `Real.log 0 = 0`. -/
def relEntropy (p q : m -> Real) : Real :=
  ∑ j, p j * Real.log (p j / q j)

/-- Push a finite weight vector through a kernel. -/
def pushforward (T : n -> m -> Real) (p : m -> Real) : n -> Real :=
  fun i => ∑ j, T i j * p j

/-- Finite log-sum inequality. The support condition prevents a positive
numerator from being paired with a zero denominator. -/
lemma log_sum_ineq {iota : Type*} [Fintype iota] (a b : iota -> Real)
    (ha : ∀ j, 0 <= a j) (hb : ∀ j, 0 <= b j)
    (hab : ∀ j, b j = 0 -> a j = 0) (hbpos : 0 < ∑ j, b j) :
    (∑ j, a j) * Real.log ((∑ j, a j) / (∑ j, b j)) <=
      ∑ j, a j * Real.log (a j / b j) := by
  set S : Real := ∑ j, b j
  have hconvex :
      (S⁻¹ * ∑ j, b j * (a j / b j)) *
          Real.log (S⁻¹ * ∑ j, b j * (a j / b j)) <=
        S⁻¹ * ∑ j, b j * ((a j / b j) * Real.log (a j / b j)) := by
    have hxlogx : ConvexOn Real (Set.Ici 0)
        (fun x : Real => x * Real.log x) :=
      Real.convexOn_mul_log
    have hjensen :
        (∑ j, (b j / S) * (a j / b j)) *
            Real.log (∑ j, (b j / S) * (a j / b j)) <=
          ∑ j, (b j / S) *
            ((a j / b j) * Real.log (a j / b j)) := by
      convert hxlogx.map_sum_le _ _ _
      · exact fun j _ => div_nonneg (hb j) hbpos.le
      · rw [← Finset.sum_div, div_self hbpos.ne']
      · exact fun j _ => div_nonneg (ha j) (hb j)
    simpa only [div_eq_inv_mul, mul_assoc, mul_comm, mul_left_comm,
      Finset.mul_sum] using hjensen
  convert mul_le_mul_of_nonneg_left hconvex hbpos.le using 1
  · field_simp
    exact congrArg₂ _
      (Finset.sum_congr rfl fun i _ => by
        by_cases hi : b i = 0 <;>
          simp +decide [hi, hab i, mul_div_cancel_left₀])
      (congrArg _ (by
        congr
        ext i
        by_cases hi : b i = 0 <;>
          simp +decide [hi, hab i, mul_div_cancel_left₀]))
  · simp +decide [← mul_assoc, hbpos.ne']
    exact Finset.sum_congr rfl fun j _ => by
      by_cases hj : b j = 0 <;>
        simp +decide [hj, mul_div_cancel₀, hab j]

omit [Fintype n] in
/-- Per-output-coordinate log-sum inequality used by data processing. -/
lemma dpi_coord (T : n -> m -> Real) (p q : m -> Real)
    (hT : ∀ i j, 0 <= T i j) (hp : ∀ j, 0 <= p j)
    (hq : ∀ j, 0 < q j) (i : n) :
    pushforward T p i * Real.log (pushforward T p i / pushforward T q i) <=
      ∑ j, T i j * p j * Real.log (p j / q j) := by
  by_cases hzero : ∑ j : m, T i j * q j = 0
  · simp_all +decide [Finset.sum_eq_zero_iff_of_nonneg]
    simp_all +decide [ne_of_gt, pushforward]
  · convert log_sum_ineq
      (fun j => T i j * p j) (fun j => T i j * q j)
      (fun j => mul_nonneg (hT i j) (hp j))
      (fun j => mul_nonneg (hT i j) (le_of_lt (hq j)))
      (fun j hj => ?_)
      (lt_of_le_of_ne
        (Finset.sum_nonneg fun j _ =>
          mul_nonneg (hT i j) (le_of_lt (hq j)))
        (Ne.symm hzero)) using 1
    · grind +qlia
    · grind

/-- Classical data-processing inequality for finite probability vectors and a
column-stochastic kernel. The normalization hypotheses expose the intended
probability-distribution reading, although the inequality proof itself only
uses positivity and column stochasticity. -/
theorem relEntropy_dpi (T : n -> m -> Real) (p q : m -> Real)
    (hT : ∀ i j, 0 <= T i j) (hTcolumn : ∀ j, ∑ i, T i j = 1)
    (hp : ∀ j, 0 <= p j) (hq : ∀ j, 0 < q j)
    (_hpsum : ∑ j, p j = 1) (_hqsum : ∑ j, q j = 1) :
    relEntropy (pushforward T p) (pushforward T q) <= relEntropy p q := by
  calc
    relEntropy (pushforward T p) (pushforward T q) =
        ∑ i, pushforward T p i *
          Real.log (pushforward T p i / pushforward T q i) := rfl
    _ <= ∑ i, ∑ j, T i j * p j * Real.log (p j / q j) :=
      Finset.sum_le_sum (fun i _ => dpi_coord T p q hT hp hq i)
    _ = ∑ j, ∑ i, T i j * p j * Real.log (p j / q j) :=
      Finset.sum_comm
    _ = ∑ j, (∑ i, T i j) *
        (p j * Real.log (p j / q j)) := by
      refine Finset.sum_congr rfl (fun j _ => ?_)
      rw [Finset.sum_mul]
      exact Finset.sum_congr rfl (fun i _ => by ring)
    _ = ∑ j, p j * Real.log (p j / q j) := by
      refine Finset.sum_congr rfl (fun j _ => ?_)
      rw [hTcolumn j, one_mul]
    _ = relEntropy p q := rfl

/-- The identity channel on two points. -/
def identityTwo (i j : Fin 2) : Real := if i = j then 1 else 0

/-- The identity channel leaves every two-point vector unchanged. -/
theorem pushforward_identityTwo (p : Fin 2 -> Real) :
    pushforward identityTwo p = p := by
  funext i
  fin_cases i <;> simp [pushforward, identityTwo]

/-- Equality boundary control: identity processing preserves relative entropy. -/
theorem identityTwo_relEntropy_eq (p q : Fin 2 -> Real) :
    relEntropy (pushforward identityTwo p) (pushforward identityTwo q) =
      relEntropy p q := by
  rw [pushforward_identityTwo, pushforward_identityTwo]

/-- Collapse both inputs onto the sole output. This kernel is column
stochastic, not injective. -/
def collapseTwoToOne (_ : Fin 1) (_ : Fin 2) : Real := 1

/-- Point mass on the first of two inputs. -/
def pointMassTwo : Fin 2 -> Real := fun i => if i = 0 then 1 else 0

/-- Uniform two-input distribution. -/
def uniformTwo : Fin 2 -> Real := fun _ => 1 / 2

/-- Nondegenerate strictness control: the collapse channel erases the positive
relative entropy distinguishing a point mass from the uniform distribution. -/
theorem collapseTwoToOne_strict :
    relEntropy (pushforward collapseTwoToOne pointMassTwo)
        (pushforward collapseTwoToOne uniformTwo) = 0 ∧
      0 < relEntropy pointMassTwo uniformTwo := by
  constructor
  · norm_num [relEntropy, pushforward, collapseTwoToOne, pointMassTwo,
      uniformTwo, Fin.sum_univ_two]
  · simpa [relEntropy, pointMassTwo, uniformTwo,
      FiniteGibbsInequality.relEntropy,
      FiniteGibbsInequality.pointMassTwo,
      FiniteGibbsInequality.uniformTwo] using
      FiniteGibbsInequality.pointMass_uniform_relEntropy_pos

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteClassicalDPI.relEntropy_dpi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relEntropy_dpi

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteClassicalDPI.identityTwo_relEntropy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityTwo_relEntropy_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteClassicalDPI.collapseTwoToOne_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms collapseTwoToOne_strict

end PhysicsSM.Draft.NullEdge.FiniteClassicalDPI
