import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup
import PhysicsSM.Spinor.SpinorTenfoldCliffordConj
import PhysicsSM.Spinor.SpinorTenfoldBasisOrbit
import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# Draft.Spin10StabilizerTransitivity

Formalizes the transitivity of the even Clifford group (`GSpin(10, ℂ)`) on Krasnov pairs
of pure spinors.

Status: Draft (s o r r y target for Aristotle)
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StabilizerTransitivity

open PhysicsSM.Spinor.SpinorTenfold

/-- Two pure spinors are orthogonal if their symmetrized gamma-bilinear vanishes. -/
def OrthogonalPureSpinors (ψ₁ ψ₂ : FockSpinor) : Prop :=
  gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0

/-
**Lemma S1 (Transitivity)** was intended to say that `evenCliffordGroup` acts
transitively on collinear pure-spinor pairs `(ψ₁, [ψ₂])` in the `d = 3`
stratum.

The originally requested statement is retained here verbatim, but commented out:
it is false, as proved by `not_evenCliffordGroup_transitive_on_krasnov_pairs`
below.  Its orthogonality condition includes the diagonal stratum.

theorem evenCliffordGroup_transitive_on_krasnov_pairs
    (ψ₁ ψ₂ φ₁ φ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (hφ₁ : IsPureSpinor φ₁) (hφ₂ : IsPureSpinor φ₂)
    (hψ_coll : OrthogonalPureSpinors ψ₁ ψ₂)
    (hφ_coll : OrthogonalPureSpinors φ₁ φ₂) :
    ∃ g : evenCliffordGroup, g.val.val ψ₁ = φ₁ ∧ ∃ c : ℂ, g.val.val ψ₂ = c • φ₂ := by
  -- No proof exists; see the kernel-checked counterexample below.
-/

/-- Two nonzero spinors determine distinct projective points.  This is the
minimal missing condition in the original S1 statement: it excludes the
`d = 5` diagonal stratum from the orthogonality locus. -/
def ProjectivelyDistinct (ψ₁ ψ₂ : FockSpinor) : Prop :=
  ¬ ∃ c : ℂ, ψ₂ = c • ψ₁

/-- A pair admits the intended standard normal form.  Establishing this from
purity, orthogonality, and `ProjectivelyDistinct` is precisely the missing
Witt-extension/orbit-classification lemma; the currently landed basis-orbit
machinery proves only the special case of even wedge monomials. -/
def StandardizablePair (ψ₁ ψ₂ : FockSpinor) : Prop :=
  ∃ g : evenCliffordGroup, g.val.val ψ₁ = vacuumSpinor ∧
    ∃ c : ℂ, c ≠ 0 ∧ g.val.val ψ₂ = c • weakSpinor

/-
**Corrected S1, conditional on the exact missing normal-form lemma.**
Once both genuine pairs have the standard normal form, group composition gives
transitivity, with the first spinor marked and the second projective.
-/
theorem evenCliffordGroup_transitive_on_standardizable_krasnov_pairs
    (ψ₁ ψ₂ φ₁ φ₂ : FockSpinor)
    (hψ : StandardizablePair ψ₁ ψ₂)
    (hφ : StandardizablePair φ₁ φ₂) :
    ∃ g : evenCliffordGroup, g.val.val ψ₁ = φ₁ ∧
      ∃ c : ℂ, g.val.val ψ₂ = c • φ₂ := by
  obtain ⟨a, ha1, ca, ha2⟩ := hψ
  obtain ⟨b, hb1, cb, hb2⟩ := hφ
  use ⟨b⁻¹ * a, by
    exact Subgroup.mul_mem _ ( Subgroup.inv_mem _ b.2 ) a.2⟩
  generalize_proofs at *;
  have h_inv : (b⁻¹ : (Module.End ℂ FockSpinor)ˣ).val (b.val.val φ₁) = φ₁ ∧ (b⁻¹ : (Module.End ℂ FockSpinor)ˣ).val (b.val.val φ₂) = φ₂ := by
    have h_inv : ∀ x : FockSpinor, (b⁻¹ : (Module.End ℂ FockSpinor)ˣ).val (b.val.val x) = x := by
      intro x; exact (by
      convert congr_arg ( fun f : Module.End ℂ FockSpinor => f x ) ( show ( b⁻¹ : ( Module.End ℂ FockSpinor ) ˣ ).val * ( b : ( Module.End ℂ FockSpinor ) ˣ ).val = 1 from by simp +decide ) using 1);
    exact ⟨ h_inv φ₁, h_inv φ₂ ⟩;
  simp_all +decide [ Units.val_mul, Module.End.mul_apply ];
  exact ⟨ ca / cb, by rw [ ← h_inv.2, smul_smul, div_mul_cancel₀ _ hb2.1 ] ⟩

/-!
## Audit note (Lane B): the transitivity statement above is FALSE as formalized

The hypothesis `OrthogonalPureSpinors ψ₁ ψ₂` only records that the *vector*
gamma-bilinear `ψ₁ Γ^a ψ₂` vanishes. By Chevalley this is equivalent to
`dim (N₁ ∩ N₂) ≥ 3`, i.e. it captures **both** the collinear `d = 3` stratum
and the diagonal `d = 5` stratum (`[ψ₁] = [ψ₂]`, where `N₁ = N₂`). A pure spinor
`ψ` always satisfies `gammaBilinear ψ ψ = 0` (its purity quadric), so the
degenerate pair `(ψ, ψ)` satisfies `OrthogonalPureSpinors`. The research notes
(`Sources/Spin10_stabilizer.txt`, "Message 2", tightening point 1) explicitly
flag that `d = 5` "is the diagonal, not an orbit of distinct projective points";
the formal statement is missing the hypothesis that each pair is projectively
distinct (which, together with orthogonality, pins `d = 3`).

Concretely: the even Clifford group cannot map the *degenerate* pair
`(vacuumSpinor, vacuumSpinor)` to the *genuine* `d = 3` pair
`(vacuumSpinor, weakSpinor)`, because any `g` sending `ψ₁ ↦ φ₁` and `ψ₂ ↦ c • φ₂`
with `ψ₁ = ψ₂` forces `φ₁ = c • φ₂`, i.e. `vacuumSpinor = c • weakSpinor`, which
is impossible for distinct basis monomials. This gives a kernel-checked refutation.

The intended (plausibly true) statement restricts to genuine `d = 3` pairs, e.g.
by adding `(¬ ∃ c, ψ₂ = c • ψ₁)` and `(¬ ∃ c, φ₂ = c • φ₁)`.
-/

/-- **Kernel-checked negative (Lane B audit)**: the transitivity statement
`evenCliffordGroup_transitive_on_krasnov_pairs`, taken literally, is false. Its
hypotheses admit the degenerate diagonal pair `(ψ, ψ)`, which no group element
can carry to a projectively-distinct pair. Witnesses: `ψ₁ = ψ₂ = vacuumSpinor`
and `(φ₁, φ₂) = (vacuumSpinor, weakSpinor)`. -/
theorem not_evenCliffordGroup_transitive_on_krasnov_pairs :
    ¬ (∀ (ψ₁ ψ₂ φ₁ φ₂ : FockSpinor)
        (_hψ₁ : IsPureSpinor ψ₁) (_hψ₂ : IsPureSpinor ψ₂)
        (_hφ₁ : IsPureSpinor φ₁) (_hφ₂ : IsPureSpinor φ₂)
        (_hψ_coll : OrthogonalPureSpinors ψ₁ ψ₂)
        (_hφ_coll : OrthogonalPureSpinors φ₁ φ₂),
        ∃ g : evenCliffordGroup,
          g.val.val ψ₁ = φ₁ ∧ ∃ c : ℂ, g.val.val ψ₂ = c • φ₂) := by
  intro H
  have hψ_coll : OrthogonalPureSpinors vacuumSpinor vacuumSpinor := by
    unfold OrthogonalPureSpinors
    rw [isPureSpinor_vacuumSpinor.quadric]
    simp
  have hφ_coll : OrthogonalPureSpinors vacuumSpinor weakSpinor := by
    unfold OrthogonalPureSpinors
    rw [gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum]
    simp
  obtain ⟨g, hg1, c, hg2⟩ :=
    H vacuumSpinor vacuumSpinor vacuumSpinor weakSpinor
      isPureSpinor_vacuumSpinor isPureSpinor_vacuumSpinor
      isPureSpinor_vacuumSpinor isPureSpinor_weakSpinor hψ_coll hφ_coll
  -- `g` fixes `vacuumSpinor` (hg1) yet also sends it to `c • weakSpinor` (hg2),
  -- forcing `vacuumSpinor = c • weakSpinor`.
  have hcoll : vacuumSpinor = c • weakSpinor := hg1.symm.trans hg2
  have hvac : vacuumSpinor (∅ : Finset (Fin 5)) = 1 := by
    simp [vacuumSpinor, basisSpinor]
  have hweak : weakSpinor (∅ : Finset (Fin 5)) = 0 := by
    rw [weakSpinor, basisSpinor, if_neg (by decide)]
  have hpt := congrFun hcoll ∅
  rw [hvac, Pi.smul_apply, hweak, smul_zero] at hpt
  -- `hpt : (1 : ℂ) = 0`.
  exact one_ne_zero hpt

end PhysicsSM.Draft.Spin10StabilizerTransitivity

end
