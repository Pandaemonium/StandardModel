import Mathlib
import PhysicsSM.Draft.NullEdgeSuperDiracSignAudit
import PhysicsSM.Draft.NullEdgeSuperDiracBlockCore
import PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein

/-!
# Gate A super-Dirac square/sign bridge

This file is the **Gate A closeout bridge** (job A1, Wave 8): the single
kernel-facing theorem package that must land before any finite-square theorem is
promoted.  It ties together three pieces that until now lived in separate draft
files:

* the abstract sign dichotomy `(Γ_s Φ)² = ±Φ²`
  (`PhysicsSM__Draft__NullEdgeSuperDiracSignAudit`,
  `SuperDirac.graded_square_comm` / `SuperDirac.graded_square_anticomm`);
* the fact that the off-diagonal internal mass block `Φ_H` is **odd** under the
  internal chirality grading `χ_E`
  (`PhysicsSM__Draft__NullEdgeSuperDiracBlockCore`,
  `NullEdgeSuperDiracCore.chirality_anticommutes_offDiagonal`);
* the finite product-grading layer
  (`PhysicsSM__Draft__NullEdgeSuperDiracProductGradingKrein`).

## The safe sign convention, made explicit

The locked convention keeps the **spacetime chirality** `Γ_s` strictly distinct
from the **internal chirality** `χ_E`.  The internal mass block `Φ_H` is:

* `χ_E`-**odd**:    `{χ_E, Φ_H} = 0`   (it is an off-diagonal block on `L ⊕ R`);
* `Γ_s`-**even**:   `[Γ_s, Φ_H] = 0`   (it is internal, so it commutes with the
  distinct spacetime chirality that appears in `D = i D_N + Γ_s Φ_H`).

Because the mass term in `D` pairs `Φ_H` with the grading it **commutes** with,
the super-Dirac square carries the physical `+Φ_H²` mass block.  The sign trap is
exactly the conflation `Γ_s := χ_E`: pairing `Φ_H` with the grading it is **odd**
under flips the mass term to the tachyonic `-Φ_H²`.

## Main results

* `super_dirac_sign_bridge` — abstract two-grading package: with distinct
  gradings `Gs` (commuting) and `Xe` (anticommuting), `(Gs Φ)² = +Φ²` while
  `(Xe Φ)² = -Φ²`.
* `super_dirac_square_sum_safe` — the full finite-sum square `+Φ²`
  (`SuperDirac.super_dirac_square_sum`) repackaged with the explicit
  "`Φ` is `Xe`-odd but `Gs`-even" hypotheses, plus the wrong-convention
  `-Φ²` companion.
* `productGrading_concrete_bridge` — a concrete realisation on `Deg × Chir`:
  the **degree** grading plays `Γ_s` (commutes with any internal block) and the
  **chirality** grading plays `χ_E` (anticommutes), and they are genuinely
  distinct matrices.  Instantiated by `massBlock_bridge` on an explicit nonzero
  internal mass block where `+Φ² = 1` and `-Φ² = -1`.

Everything is finite ring / matrix algebra; no continuum claim is made.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace SuperDiracSignBridge

open scoped Matrix
open PhysicsSM.Draft.SuperDirac
open PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein

/-! ## 1. Abstract two-grading bridge -/

section Abstract

variable {A : Type*} [Ring A]

/--
**Safe-convention super-Dirac sign bridge (abstract).**

Let `Gs` be the spacetime chirality and `Xe` the internal chirality, both
squaring to `1`.  Suppose the internal mass block `Ph = Φ_H` is

* `Gs`-even:  `[Gs, Ph] = 0` (`hGsPh`), and
* `Xe`-odd:   `{Xe, Ph} = 0` (`hXePh`).

Then the mass square computed with the grading `Φ` **commutes** with is the
physical `+Ph²`, while the mass square computed with the grading `Φ` is **odd**
under is the tachyonic `-Ph²`.  The safe convention is precisely the choice to
pair `Ph` with `Gs` (the commuting grading), which is legitimate exactly because
`Gs ≠ Xe`.
-/
theorem super_dirac_sign_bridge
    (Gs Xe Ph : A)
    (hGs2 : Gs * Gs = 1) (hXe2 : Xe * Xe = 1)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hXePh : Xe * Ph = -(Ph * Xe)) :
    (Gs * Ph) * (Gs * Ph) = Ph * Ph ∧
      (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) :=
  ⟨graded_square_comm Gs Ph hGs2 hGsPh,
   graded_square_anticomm Xe Ph hXe2 hXePh⟩

end Abstract

/-! ## 2. Full finite-sum square under the safe convention -/

section FiniteSum

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A]

/--
**Safe-convention finite-sum super-Dirac square.**

The full `+Φ²` finite-sum square `SuperDirac.super_dirac_square_sum`, repackaged
so the grading hypotheses are stated as the safe convention: `Φ_H` is `Xe`-odd
(internal chirality `χ_E`) but `Gs`-even (spacetime chirality `Γ_s`), and the
two gradings are paired correctly.  The `Xe`-odd hypothesis is carried only to
make the convention explicit and to feed `super_dirac_sign_bridge`; it is the
`Gs`-even hypothesis `hGsPh` that the square itself uses.
-/
theorem super_dirac_square_sum_safe
    (Im Gs Xe Ph : A) (C nab : ι → A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hXe2 : Xe * Xe = 1)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hXePh : Xe * Ph = -(Ph * Xe))
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
        = -(dNsum C nab * dNsum C nab) + Ph * Ph
          - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a))
      ∧ (Gs * Ph) * (Gs * Ph) = Ph * Ph
      ∧ (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) :=
  ⟨super_dirac_square_sum Im Gs Ph C nab hImc hIm2 hGs2 hGsC hGsNb hGsPh hCPh,
   graded_square_comm Gs Ph hGs2 hGsPh,
   graded_square_anticomm Xe Ph hXe2 hXePh⟩

end FiniteSum

/-! ## 3. Concrete realisation on `Deg × Chir`

The product-grading layer supplies the two genuinely distinct gradings:

* `gammaS` — the **degree** grading, playing the spacetime chirality `Γ_s`.  An
  internal block (degree-preserving, chirality-flipping) **commutes** with it.
* `chiE` — the **chirality** grading, playing the internal chirality `χ_E`.  An
  internal block **anticommutes** with it.
-/

section Concrete

open Matrix Complex

/-- Spacetime chirality `Γ_s` realised as the simplicial **degree** grading. -/
def gammaS : Matrix (Deg × Chir) (Deg × Chir) Complex :=
  grading (fun x => degSign x.1)

/-- Internal chirality `χ_E` realised as the **chirality** grading. -/
def chiE : Matrix (Deg × Chir) (Deg × Chir) Complex :=
  grading (fun x => chirSign x.2)

/-- An operator is even for `sign` if it has no entries between distinct signs. -/
def EvenForSign (sign : (Deg × Chir) → Complex)
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) : Prop :=
  ∀ i j, sign i ≠ sign j → D i j = 0

/--
A diagonal grading whose sign squares to `1` squares to the identity.
-/
theorem grading_mul_self
    (sign : (Deg × Chir) → Complex) (hSq : ∀ x, sign x * sign x = 1) :
    grading sign * grading sign = 1 := by
  unfold grading; ext i j; by_cases hi : i = j <;> simp +decide [hi]
  · rw [Matrix.mul_apply]; aesop
  · rw [Matrix.mul_apply]
    apply Finset.sum_eq_zero
    intros
    aesop

/--
A diagonal grading commutes with any operator that is even for its sign.
-/
theorem grading_commutes_of_evenForSign
    (sign : (Deg × Chir) → Complex)
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex)
    (hEven : EvenForSign sign D) :
    grading sign * D = D * grading sign := by
  ext i j;
  by_cases hij : sign i = sign j;
  · simp_all +decide [ Matrix.mul_apply, grading ];
    ring;
  · simp_all +decide [ Matrix.mul_apply, grading ];
    rw [ hEven i j hij, MulZeroClass.mul_zero, MulZeroClass.zero_mul ]

/--
`gammaS² = 1`.
-/
theorem gammaS_sq : gammaS * gammaS = 1 := by
  convert grading_mul_self _ _;
  exact fun x => by cases x.1 <;> simp +decide [ degSign ] ;

/--
`chiE² = 1`.
-/
theorem chiE_sq : chiE * chiE = 1 := by
  exact grading_mul_self _ fun x => by cases x.2 <;> simp +decide [ chirSign ] ;

/--
An internal block is even for the degree sign (it preserves degree).
-/
theorem internalBlock_evenForDegSign
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) (hD : InternalBlock D) :
    EvenForSign (fun x => degSign x.1) D := by
  intro i j hij;
  cases i ; cases j ; aesop

/--
An internal block is odd for the chirality sign (it flips chirality).
-/
theorem internalBlock_oddForChirSign
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) (hD : InternalBlock D) :
    OddForSign (fun x => chirSign x.2) D := by
  intro i j hij; specialize hD i j; simp_all +decide [ chirSign ] ;
  cases i2 : i.2 <;> cases j2 : j.2 <;> simp_all +decide; all_goals norm_num at hij

/--
The spacetime/degree grading **commutes** with any internal mass block.
-/
theorem gammaS_commutes_internalBlock
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) (hD : InternalBlock D) :
    gammaS * D = D * gammaS := by
  apply grading_commutes_of_evenForSign; exact internalBlock_evenForDegSign D hD;

/--
The internal chirality grading **anticommutes** with any internal mass block.
-/
theorem chiE_anticommutes_internalBlock
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) (hD : InternalBlock D) :
    chiE * D + D * chiE = 0 := by
  apply grading_anticommutes_of_oddForSign
  · exact fun i => by cases i.2 <;> simp +decide [chirSign]
  · exact internalBlock_oddForChirSign D hD

/--
The two gradings are genuinely distinct matrices.
-/
theorem gammaS_ne_chiE : gammaS ≠ chiE := by
  intro h; have := congr_fun ( congr_fun h ( Deg.even, Chir.right ) ) ( Deg.even, Chir.right ) ; norm_num [ gammaS, chiE, grading, degSign, chirSign ] at this;

/--
**Concrete super-Dirac sign bridge on `Deg × Chir`.**

For any internal mass block `D` (degree-preserving, chirality-flipping):

* pairing `D` with the **degree** grading `gammaS` (which commutes with it)
  gives the physical `+D²`;
* pairing `D` with the **chirality** grading `chiE` (which it is odd under)
  gives the tachyonic `-D²`;
* and `gammaS ≠ chiE`, so the two gradings cannot be conflated.

This is the concrete face of the safe sign convention: the positive mass block
is realisable precisely because the spacetime chirality is distinct from, and
commutes with, the internal mass block.
-/
theorem productGrading_concrete_bridge
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex) (hD : InternalBlock D) :
    (gammaS * D) * (gammaS * D) = D * D ∧
      (chiE * D) * (chiE * D) = -(D * D) ∧
      gammaS ≠ chiE := by
  refine' ⟨ _, _, gammaS_ne_chiE ⟩;
  · -- By commutation, we can rearrange the terms: $(\gamma_S D)(\gamma_S D) = \gamma_S (\gamma_S D) D = (\gamma_S \gamma_S) (D D) = D D$.
    have h_comm : gammaS * D * (gammaS * D) = gammaS * (gammaS * D) * D := by
      simp +decide only [gammaS_commutes_internalBlock D hD, ← mul_assoc];
      simp +decide only [mul_assoc];
      rw [ gammaS_commutes_internalBlock D hD ];
    simp_all +decide [ ← mul_assoc, gammaS_sq ];
  · have h_anticomm : chiE * D = -(D * chiE) := by
      exact eq_neg_of_add_eq_zero_left ( chiE_anticommutes_internalBlock D hD );
    simp_all +decide [ ← mul_assoc ];
    simp_all +decide [ mul_assoc, chiE_sq ]

/-! ### Explicit nonzero witness -/

/-- An explicit internal mass block: degree-preserving, chirality-flipping. -/
def massBlock : Matrix (Deg × Chir) (Deg × Chir) Complex :=
  fun i j => if i.1 = j.1 ∧ i.2 ≠ j.2 then 1 else 0

theorem massBlock_internalBlock : InternalBlock massBlock := by
  -- By definition of massBlock, if i.1 != j.1 or i.2 = j.2, then massBlock i j = 0.
  intro i j hij
  simp only [massBlock]
  grind +qlia

/--
The explicit mass block squares to the identity: `Φ_H² = 1 ≠ 0`.
-/
theorem massBlock_sq : massBlock * massBlock = 1 := by
  ext i j
  obtain ⟨d1, c1⟩ := i
  obtain ⟨d2, c2⟩ := j
  cases d1 <;> cases d2 <;> cases c1 <;> cases c2 <;>
    simp [massBlock, Matrix.mul_apply, Fintype.sum_prod_type] <;>
    norm_cast

/--
**Non-vacuous instantiation.**  On the explicit internal mass block `massBlock`
(with `massBlock² = 1`), the safe pairing gives `+1` and the conflated pairing
gives `-1`: the sign flip is genuine, not `0 = -0`.
-/
theorem massBlock_bridge :
    (gammaS * massBlock) * (gammaS * massBlock) = 1 ∧
      (chiE * massBlock) * (chiE * massBlock) = -1 ∧
      gammaS ≠ chiE := by
  obtain ⟨h1, h2, h3⟩ := productGrading_concrete_bridge massBlock massBlock_internalBlock
  exact ⟨by rw [h1, massBlock_sq], by rw [h2, massBlock_sq], h3⟩

end Concrete

end SuperDiracSignBridge
end Draft
end PhysicsSM

end
