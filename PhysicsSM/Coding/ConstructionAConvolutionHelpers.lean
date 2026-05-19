import PhysicsSM.Coding.ConstructionAThetaWeightBridge

/-!
# One-dimensional helpers for the Construction A theta convolution

This file provides the one-dimensional lift counting lemmas used by
`PhysicsSM.Coding.ConstructionAThetaConvolution`.  The definitions
`evenLiftCoeff` and `oddLiftCoeff` live in
`PhysicsSM.Coding.ConstructionAThetaWeightBridge`; this module deliberately
does not make local copies of those coefficients.  Keeping a single public
definition matters because the convolution theorem is meant to extend the
existing theta-weight bridge rather than introduce a parallel API.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.refine false
set_option linter.style.whitespace false
set_option linter.unusedSimpArgs false
set_option linter.flexible false

namespace PhysicsSM.Coding

/-! ## One-dimensional lift sets -/

/-- The Finset of even integers with given square value. -/
noncomputable def evenLiftFinset (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter (fun z => z ^ 2 = (n : ℤ) ∧ (2 : ℤ) ∣ z)

/-- The Finset of odd integers with given square value. -/
noncomputable def oddLiftFinset (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter (fun z => z ^ 2 = (n : ℤ) ∧ ¬ (2 : ℤ) ∣ z)

/-- The Finset of integers with given square and ZMod 2 residue. -/
noncomputable def coordLiftFinset (ci : ZMod 2) (n : ℕ) : Finset ℤ :=
  (Finset.Icc (-(n : ℤ)) n).filter (fun z => z ^ 2 = (n : ℤ) ∧ (z : ZMod 2) = ci)

/-
`evenLiftFinset n` has cardinality `evenLiftCoeff n`.
-/
theorem evenLiftFinset_card (n : ℕ) :
    (evenLiftFinset n).card = evenLiftCoeff n := by
  unfold evenLiftFinset evenLiftCoeff;
  split_ifs <;> simp_all +decide [ ← Nat.dvd_iff_mod_eq_zero, ← even_iff_two_dvd, parity_simps ];
  split_ifs <;> simp_all +decide [ Finset.card_eq_two ];
  · refine' ⟨ ↑ ( Nat.sqrt n ), -↑ ( Nat.sqrt n ), _, _ ⟩ <;> norm_num;
    · grind;
    · ext;
      simp +zetaDelta at *;
      constructor <;> intro h;
      · exact eq_or_eq_neg_of_sq_eq_sq _ _ <| by nlinarith [ Nat.sqrt_le n ] ;
      · rcases h with ( rfl | rfl ) <;> norm_num [ *, parity_simps ];
        · exact ⟨ Nat.sqrt_le_self _, mod_cast by linarith ⟩;
        · exact ⟨ Nat.sqrt_le_self _, mod_cast by linarith ⟩;
  · intro x hx₁ hx₂ hx₃; replace hx₃ := congr_arg Int.natAbs hx₃; simp_all +decide [ Int.natAbs_pow ] ;
    subst hx₃; simp_all +decide [ parity_simps ] ;
    exact ‹x.natAbs * x.natAbs = x.natAbs ^ 2 → Odd x› ( by ring )

/-
`oddLiftFinset n` has cardinality `oddLiftCoeff n`.
-/
theorem oddLiftFinset_card (n : ℕ) :
    (oddLiftFinset n).card = oddLiftCoeff n := by
  unfold oddLiftFinset oddLiftCoeff;
  by_cases h : ∃ k : ℕ, k * k = n <;> simp_all +decide [ ← even_iff_two_dvd, parity_simps ];
  · rcases h with ⟨ k, rfl ⟩ ; norm_num [ Nat.sqrt_eq ] ;
    split_ifs <;> simp_all +decide [ ← sq, Nat.even_iff ];
    · rw [ Finset.card_eq_two ];
      refine' ⟨ k, -k, _, _ ⟩ <;> norm_num [ Finset.ext_iff ];
      · aesop;
      · exact fun a => ⟨ fun h => eq_or_eq_neg_of_sq_eq_sq _ _ h.2.1, by rintro ( rfl | rfl ) <;> exact ⟨ ⟨ by nlinarith, by nlinarith ⟩, by ring, by simpa [ parity_simps ] using Nat.odd_iff.mpr ‹k % 2 = 1› ⟩ ⟩;
    · intro x hx₁ hx₂ hx₃; replace hx₃ := congr_arg Int.natAbs hx₃; simp_all +decide [ Int.natAbs_pow, Nat.even_iff ] ;
      grind +splitImp;
  · exact fun x hx₁ hx₂ hx₃ => False.elim <| h ( Int.natAbs x ) <| by linarith [ abs_mul_abs_self x ] ;

/-
Lift coefficient for a general ZMod 2 value.
-/
theorem coordLiftFinset_card (ci : ZMod 2) (n : ℕ) :
    (coordLiftFinset ci n).card =
      if ci ≠ 0 then oddLiftCoeff n else evenLiftCoeff n := by
  fin_cases ci <;> simp +decide [ *, oddLiftFinset, evenLiftFinset ];
  · convert evenLiftFinset_card n using 2;
    ext; simp [coordLiftFinset, evenLiftFinset];
    intro _ _ _; erw [ ZMod.intCast_zmod_eq_zero_iff_dvd ] ;
    rfl;
  · convert oddLiftFinset_card n using 2;
    ext; simp [coordLiftFinset, oddLiftFinset];
    intro _ _ _; rcases Int.even_or_odd' ‹_› with ⟨ k, rfl | rfl ⟩ <;> norm_num [ Int.add_emod, Int.mul_emod ] ;
    · grind;
    · exact Or.inl rfl

end PhysicsSM.Coding
