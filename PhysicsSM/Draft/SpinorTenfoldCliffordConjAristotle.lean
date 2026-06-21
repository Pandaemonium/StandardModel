import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup

/-!
# Draft.SpinorTenfoldCliffordConjAristotle

Aristotle handoff: the structure theory of the even Clifford group on the
Fock model - conjugation is twisted reflection, the vector image is stable
under conjugation, chirality is preserved, and `gammaEnd` is injective.

## Mathematical intent

These are the structural facts that make `evenCliffordGroup`
(`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup`) deserve the name
`GSpin(10, ℂ)`: conjugation by a single anisotropic Clifford unit acts on
the vector image `gammaEnd '' V10` as the twisted reflection
`reflectTwist`, which preserves `B10`/`Q10`; hence conjugation by any even
group element preserves the vector image and the quadratic form. Together
with injectivity of `gammaEnd` this is exactly what is needed (in a later
wave) to *define* the vector representation
`evenCliffordGroup → O(V10, B10)` and push the basis-orbit transitivity of
`PhysicsSM.Draft.SpinorTenfoldBasisOrbitAristotle` to the full group-level
Lemma S1 of `Sources/Spin10_stabilizer.txt`.

## Proof guidance

- `gammaUnit_conj_gammaEnd`: from the trusted anticommutator
  (`gammaEnd_mul_anticomm`), `gammaEnd v * gammaEnd u
  = B10 v u • 1 - gammaEnd u * gammaEnd v`; multiply on the right by
  `gammaEnd v` and use the square relation (`gammaEnd_mul_self`) to get
  `gammaEnd v * gammaEnd u * gammaEnd v
  = B10 v u • gammaEnd v - Q10 v • gammaEnd u
  = gammaEnd (B10 v u • v - Q10 v • u)` (by `gammaEnd_add`/`gammaEnd_smul`);
  then divide by `Q10 v` (the unit inverse is `(Q10 v)⁻¹ • gammaEnd v`,
  `gammaUnit_inv_val`) and match `reflectTwist` (use `B10_comm`;
  `field_simp` with `hv` helps).
- `B10_reflectTwist`/`Q10_reflectTwist`/`reflectTwist_reflectTwist`:
  pure bilinear-form algebra from `B10_add_left/right`, `B10_smul_left/right`,
  `B10_self` (`B10 v v = 2 * Q10 v`), `B10_comm`, `Q10_add`, `Q10_smul`;
  `field_simp [hv]` then `ring` should close each after expanding.
  Note `reflectTwist v u = (B10 u v / Q10 v) • v - u` and subtraction on
  `V10` is componentwise.
- `gammaEnd_injective`: evaluate on the vacuum monomial `basisSpinor ∅`
  (only the creation half survives: `contract_basisSpinor_of_not_mem`,
  `wedge_basisSpinor_of_not_mem`, and `opSign i {i} = 1`) to recover the
  first component, and on the full monomial `basisSpinor Finset.univ`
  (only the annihilation half survives) to recover the second.
- `evenCliffordGroup_preservesChirality` and
  `evenCliffordGroup_conj_exists`: `Subgroup.closure_induction` with a
  *symmetric* invariant (the statement packages `g` and `g⁻¹` together
  precisely so that the inverse step of the induction is a swap). For the
  generator case of chirality: each `gammaEnd` flips chirality
  (`IsEvenSpinor.cliffordAction`, `IsOddSpinor.cliffordAction`), so a pair
  product preserves it, and the inverse of a pair product is the scaled
  reversed pair product (`gammaUnit_inv_val`; scalars preserve chirality by
  `IsEvenSpinor.smul`/`IsOddSpinor.smul`). For the generator case of
  conjugation stability: apply `gammaUnit_conj_gammaEnd` twice
  (`(a * b) * x * (a * b)⁻¹ = a * (b * x * b⁻¹) * a⁻¹` after `mul_assoc`
  and `Units.val_mul`); for the inverse direction use the involution:
  conjugating `gammaEnd (reflectTwist v u)` by `gammaUnit v` returns
  `gammaEnd u` (`reflectTwist_reflectTwist`), which inverts the relation.

Do not change any definition or sign convention of
`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup` or the trusted Fock/CAR
layer. Helper lemmas are welcome. The final state should contain no
placeholder proof commands, no new assumptions, and no forbidden declarations.

This draft file now contains kernel-checked proofs of the submitted targets.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldCliffordConj

open PhysicsSM.Spinor.SpinorTenfold

/-! ## Target 1: `gammaEnd` is injective

Needed (later) to extract the vector representation of the even Clifford
group from the conjugation action. -/

theorem gammaEnd_injective : Function.Injective gammaEnd := by
  intro v w h_eq
  have h_v1 : v.1 = w.1 := by
    ext i;
    replace h_eq := congr_arg ( fun f => f ( basisSpinor ∅ ) ) h_eq ; simp_all +decide [ Finset.sum_ite ] ;
    replace h_eq := congr_fun h_eq { i } ; simp_all +decide [ cliffordAction, wedge, contract ] ;
    simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', opSign, basisSpinor ]
  have h_v2 : v.2 = w.2 := by
    ext i;
    replace h_eq := congr_arg ( fun f => f ( basisSpinor Finset.univ ) ( Finset.univ.erase i ) ) h_eq ; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq' ];
    unfold cliffordAction at h_eq; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_left_comm, mul_comm ] ;
    unfold contract at h_eq; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_left_comm, mul_comm ] ;
    exact h_eq.resolve_right ( by unfold opSign; norm_num [ belowCount ] )
  exact Prod.ext h_v1 h_v2

/-! ## Target 2: conjugation by a Clifford unit is the twisted reflection -/

/-
Conjugating the Clifford operator of `u` by the Clifford unit of an
anisotropic `v` gives the Clifford operator of the twisted reflection:
`gamma_v gamma_u gamma_v⁻¹ = gamma_{reflectTwist v u}`.
-/
theorem gammaUnit_conj_gammaEnd (v u : V10) (hv : Q10 v ≠ 0) :
    (gammaUnit v hv : Module.End ℂ FockSpinor) * gammaEnd u
        * (((gammaUnit v hv)⁻¹ : (Module.End ℂ FockSpinor)ˣ) :
            Module.End ℂ FockSpinor)
      = gammaEnd (reflectTwist v u) := by
  unfold reflectTwist;
  -- From gammaEnd_mul_anticomm and gammaEnd_mul_self:
  have h_comm : gammaEnd v * gammaEnd u * gammaEnd v = B10 v u • gammaEnd v - Q10 v • gammaEnd u := by
    have h1 : gammaEnd v * gammaEnd u = B10 v u • 1 - gammaEnd u * gammaEnd v := by
      exact eq_sub_of_add_eq ( gammaEnd_mul_anticomm v u );
    rw [ h1, sub_mul, smul_mul_assoc, mul_assoc ];
    simp +decide [ gammaEnd_mul_self ];
  -- Use the fact that gammaEnd is linear to rewrite the right-hand side.
  have h_linear : gammaEnd ((B10 u v / Q10 v) • v - u) = (B10 u v / Q10 v) • gammaEnd v - gammaEnd u := by
    ext; simp [gammaEnd];
    unfold cliffordAction; simp +decide [ mul_add, add_mul, mul_sub, sub_mul, Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
    simpa only [ mul_assoc, Finset.mul_sum _ _ _ ] using by ring;
  convert congr_arg ( fun x => ( Q10 v ) ⁻¹ • x ) h_comm using 1;
  · simp +decide [ gammaUnit_val, gammaUnit_inv_val, smul_mul_assoc, mul_smul_comm ];
  · simp_all +decide [ div_eq_inv_mul, smul_smul, mul_sub ];
    simp +decide [ B10_comm, smul_sub, smul_smul, hv ]

/-! ## Targets 3-5: the twisted reflection is a `B10`-isometry involution -/

/-
The twisted reflection preserves the bilinear form.
-/
theorem B10_reflectTwist (v : V10) (hv : Q10 v ≠ 0) (u w : V10) :
    B10 (reflectTwist v u) (reflectTwist v w) = B10 u w := by
  unfold reflectTwist;
  simp +decide [ B10_add_left, B10_add_right, B10_smul_left, B10_smul_right, B10_comm, B10_self, sub_eq_add_neg ] ; ring;
  unfold B10; norm_num [ Finset.sum_add_distrib, mul_comm ] ; ring;
  grind +extAll

/-
The twisted reflection preserves the quadratic form.
-/
theorem Q10_reflectTwist (v : V10) (hv : Q10 v ≠ 0) (u : V10) :
    Q10 (reflectTwist v u) = Q10 u := by
  unfold reflectTwist;
  rw [ sub_eq_add_neg, Q10_add ];
  simp +decide [ Q10_smul, B10_smul_left, B10_smul_right, B10_comm ];
  rw [ show Q10 ( -u ) = Q10 u by
        unfold Q10; simp +decide [ mul_comm ] ;, show B10 v ( -u ) = -B10 v u by
                                          unfold B10; simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm ] ;
                                          ring ] ; ring;
  grind

/-
The twisted reflection is an involution.
-/
theorem reflectTwist_reflectTwist (v : V10) (hv : Q10 v ≠ 0) (u : V10) :
    reflectTwist v (reflectTwist v u) = u := by
  unfold reflectTwist;
  simp +decide [ B10_add_right, B10_smul_right, B10_self, B10_comm, hv, sub_eq_add_neg, add_assoc, add_left_comm, add_comm ];
  simp +decide [ B10, hv, mul_assoc, mul_comm, mul_left_comm, div_eq_mul_inv ];
  simp +decide [ Finset.sum_add_distrib, Finset.sum_neg_distrib, two_mul, add_smul, neg_smul, smul_add, smul_neg, neg_add, add_assoc, add_left_comm, add_comm ]

/-! ## Helper lemmas for the closure induction -/

/-- `gammaEnd v` carries even spinors to odd spinors. -/
theorem gammaEnd_isOdd_of_isEven {psi : FockSpinor} (h : IsEvenSpinor psi)
    (v : V10) : IsOddSpinor (gammaEnd v psi) := by
  simpa using h.cliffordAction v

/-- `gammaEnd v` carries odd spinors to even spinors. -/
theorem gammaEnd_isEven_of_isOdd {psi : FockSpinor} (h : IsOddSpinor psi)
    (v : V10) : IsEvenSpinor (gammaEnd v psi) := by
  simpa using h.cliffordAction v

/-- The identity endomorphism preserves chirality. -/
theorem preservesChirality_one :
    PreservesChirality (1 : Module.End ℂ FockSpinor) :=
  ⟨fun _ h => h, fun _ h => h⟩

/-- A composition of chirality-preserving endomorphisms preserves chirality.
Note multiplication in `Module.End` is composition: `(f * g) psi = f (g psi)`. -/
theorem preservesChirality_mul {f g : Module.End ℂ FockSpinor}
    (hf : PreservesChirality f) (hg : PreservesChirality g) :
    PreservesChirality (f * g) :=
  ⟨fun psi h => hf.1 _ (hg.1 _ h), fun psi h => hf.2 _ (hg.2 _ h)⟩

/-- Scaling preserves chirality. -/
theorem preservesChirality_smul {f : Module.End ℂ FockSpinor}
    (hf : PreservesChirality f) (c : ℂ) : PreservesChirality (c • f) :=
  ⟨fun psi h => by
      have := (hf.1 psi h).smul c
      simpa using this,
   fun psi h => by
      have := (hf.2 psi h).smul c
      simpa using this⟩

/-- The Clifford operator of a single vector, as an endomorphism, sends even
to odd and odd to even, so a product of two of them preserves chirality. -/
theorem preservesChirality_gammaEnd_mul (v w : V10) :
    PreservesChirality (gammaEnd v * gammaEnd w) :=
  ⟨fun psi h => by
      have : (gammaEnd v * gammaEnd w) psi = gammaEnd v (gammaEnd w psi) := rfl
      rw [this]
      exact gammaEnd_isEven_of_isOdd (gammaEnd_isOdd_of_isEven h w) v,
   fun psi h => by
      have : (gammaEnd v * gammaEnd w) psi = gammaEnd v (gammaEnd w psi) := rfl
      rw [this]
      exact gammaEnd_isOdd_of_isEven (gammaEnd_isEven_of_isOdd h w) v⟩

/-! ## Target 6: the even Clifford group preserves chirality

The statement packages `g` and `g⁻¹` together so that
`Subgroup.closure_induction` can swap them in the inverse step. -/

theorem evenCliffordGroup_preservesChirality (g : (Module.End ℂ FockSpinor)ˣ)
    (hg : g ∈ evenCliffordGroup) :
    PreservesChirality (g : Module.End ℂ FockSpinor)
      ∧ PreservesChirality
          ((g⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor) := by
  refine' Subgroup.closure_induction ( fun x hx => _ ) _ ( fun x y hx hy => _ ) ( fun x hx => _ ) hg;
  · obtain ⟨ v, w, hv, hw, rfl ⟩ := hx; simp_all +decide [ Units.mul_inv_eq_iff_eq_mul ] ;
    exact ⟨ preservesChirality_gammaEnd_mul v w, preservesChirality_smul ( preservesChirality_smul ( preservesChirality_gammaEnd_mul w v ) _ ) _ ⟩;
  · exact ⟨ preservesChirality_one, by simpa using preservesChirality_one ⟩;
  · simp +zetaDelta at *;
    exact fun hx₁ hx₂ hy₁ hy₂ => ⟨ preservesChirality_mul hx₁ hy₁, preservesChirality_mul hy₂ hx₂ ⟩;
  · aesop

/-- Conjugation by the *inverse* Clifford unit is the same twisted reflection:
`gamma_v⁻¹ gamma_u gamma_v = gamma_{reflectTwist v u}`. Follows from
`gammaUnit_conj_gammaEnd` and the involution `reflectTwist_reflectTwist`. -/
theorem gammaUnit_inv_conj_gammaEnd (v u : V10) (hv : Q10 v ≠ 0) :
    (((gammaUnit v hv)⁻¹ : (Module.End ℂ FockSpinor)ˣ) :
        Module.End ℂ FockSpinor) * gammaEnd u
        * (gammaUnit v hv : Module.End ℂ FockSpinor)
      = gammaEnd (reflectTwist v u) := by
  have hconj := gammaUnit_conj_gammaEnd v (reflectTwist v u) hv
  rw [reflectTwist_reflectTwist v hv u] at hconj
  -- hconj : gammaUnit v * gammaEnd (reflectTwist v u) * (gammaUnit v)⁻¹ = gammaEnd u
  have hinv : (((gammaUnit v hv)⁻¹ : (Module.End ℂ FockSpinor)ˣ) :
        Module.End ℂ FockSpinor) * (gammaUnit v hv : Module.End ℂ FockSpinor) = 1 := by
    simpa using (gammaUnit v hv).inv_mul
  rw [← hconj]
  simp only [← mul_assoc]
  rw [hinv, one_mul, mul_assoc, hinv, mul_one]

/-! ## Target 7: conjugation stability of the vector image

Conjugation by any even-group element carries the Clifford operator of a
vector to the Clifford operator of a vector of the same `Q10`-length. This
is the seed of the vector representation `evenCliffordGroup → SO(10, ℂ)`.
The statement again packages `g` and `g⁻¹` for the closure induction. -/

theorem evenCliffordGroup_conj_exists (g : (Module.End ℂ FockSpinor)ˣ)
    (hg : g ∈ evenCliffordGroup) (u : V10) :
    (∃ u' : V10,
        (g : Module.End ℂ FockSpinor) * gammaEnd u
            * ((g⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor)
          = gammaEnd u' ∧ Q10 u' = Q10 u)
      ∧ (∃ u'' : V10,
          ((g⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor)
              * gammaEnd u * (g : Module.End ℂ FockSpinor)
            = gammaEnd u'' ∧ Q10 u'' = Q10 u) := by
  revert g u;
  refine' fun g hg u => Subgroup.closure_induction ( fun g hg => _ ) _ _ _ hg u;
  · obtain ⟨ v, w, hv, hw, rfl ⟩ := hg;
    intro x
    constructor;
    · refine' ⟨ reflectTwist v ( reflectTwist w x ), _, _ ⟩ <;> simp_all +decide [ gammaUnit_conj_gammaEnd, gammaUnit_inv_conj_gammaEnd ];
      · convert gammaUnit_conj_gammaEnd v ( reflectTwist w x ) hv using 1;
        rw [ ← gammaUnit_conj_gammaEnd w x hw ] ; simp +decide [ gammaUnit_val, gammaUnit_inv_val ] ;
        simp +decide only [mul_assoc];
      · rw [ Q10_reflectTwist v hv, Q10_reflectTwist w hw ];
    · refine' ⟨ reflectTwist w ( reflectTwist v x ), _, _ ⟩;
      · simp +decide [ gammaUnit_inv_conj_gammaEnd, mul_assoc ];
        convert gammaUnit_inv_conj_gammaEnd w ( reflectTwist v x ) hw using 1;
        simp +decide [ ← mul_assoc, ← gammaUnit_conj_gammaEnd v x hv ];
      · rw [ Q10_reflectTwist w hw, Q10_reflectTwist v hv ];
  · exact fun x => ⟨ ⟨ x, by simp +decide ⟩, ⟨ x, by simp +decide ⟩ ⟩;
  · intro x y hx hy hx' hy' u;
    obtain ⟨ u₁, hu₁ ⟩ := hy' u |>.1
    obtain ⟨ u₂, hu₂ ⟩ := hx' u₁ |>.1
    obtain ⟨ u₃, hu₃ ⟩ := hx' u |>.2
    obtain ⟨ u₄, hu₄ ⟩ := hy' u₃ |>.2;
    simp_all +decide [ mul_assoc, Units.val_mul ];
    grind +revert;
  · intro x hx ih u; specialize ih u; aesop;

end PhysicsSM.Draft.SpinorTenfoldCliffordConj

end
