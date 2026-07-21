import PhysicsSM.Draft.NullEdge.RingHolonomyAllN

/-!
# Ring-holonomy classification: holonomy is a COMPLETE gauge invariant

Target statements for the Aristotle job `ring-holonomy-classification-20260719`.

Context.  The landed chain proves: gauge transformations preserve holonomy
(`holonomy_gauge_invariant`), gauge-related fields give unitarily conjugate
Hamiltonians (`HRing_gauge_conjugacy`), and different holonomy REAL PARTS
give non-conjugate Hamiltonians at every `n > 2` (`RingHolonomyAllN`).
This module states the CONVERSE half: equal holonomy forces gauge
equivalence - so holonomy is a complete invariant of unit-link ring fields
up to gauge, and the spectral discriminator chain closes into a
classification statement.

Route: on a ring, fix the gauge site-by-site - define
`g 0 = 1`, `g (k+1) = g k * u k / v k` walking around; the closure
constraint at the last link is exactly `holonomy u = holonomy v`.
Unit-modulus of `g` follows from unit links.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.RingHolonomyClassification

open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN

/-- **Completeness of the holonomy invariant.**  Unit-link fields with
equal holonomy are gauge-equivalent (with a unit-modulus gauge). -/
theorem exists_gauge_of_holonomy_eq (n : ℕ) [NeZero n]
    (u v : ZMod n → ℂ) (hu : UnitLinks n u) (hv : UnitLinks n v)
    (h : holonomy n u = holonomy n v) :
    ∃ g : ZMod n → ℂ, (∀ k, ‖g k‖ = 1) ∧ gaugedLinks n g u = v := by
  -- Define the gauge field $g$ recursively.
  have hg.rec : ∃ g : ZMod n → ℂ, g (0 : ZMod n) = 1 ∧ (∀ k : ZMod n, g (k + 1) = g k * u k / v k) ∧ (∀ k : ZMod n, ‖g k‖ = 1) := by
    refine' ⟨ fun k => ∏ i ∈ Finset.range ( k.val ), u i / v i, _, _, _ ⟩ <;> norm_num;
    · intro k;
      by_cases hk : k.val = n - 1;
      · cases n <;> simp_all +decide [ ZMod.val_add ];
        simp_all +decide [ ZMod.val ];
        unfold holonomy at h;
        simp_all +decide [ Finset.prod_range, ZMod, Fin.prod_univ_castSucc ];
        rw [ show k = Fin.last _ from by { exact Fin.ext hk } ];
        rw [ eq_div_iff ];
        · rw [ div_mul_eq_mul_div, eq_div_iff ] <;> norm_num [ h ];
          · ring;
          · exact Finset.prod_ne_zero_iff.mpr fun i _ => by specialize hv ( Fin.castSucc i ) ; aesop;
        · exact fun h' => by simpa [ h' ] using hv ( Fin.last _ ) ;
      · rw [ show ( k + 1 : ZMod n ).val = k.val + 1 from ?_ ];
        · simp +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, Finset.prod_range_succ ];
        · rcases n with ( _ | _ | n ) <;> simp_all +decide [ ZMod.val_add ];
          · fin_cases k ; contradiction;
          · simp +decide [ ZMod.val ];
            exact Nat.le_of_lt_succ ( lt_of_le_of_ne ( Nat.le_of_lt_succ k.val_lt ) hk );
    · intro k; rw [ div_eq_iff ] <;> simp_all +decide [ Complex.normSq, Complex.norm_def ] ;
      · simp_all +decide [ Complex.ext_iff, UnitLinks ];
      · simp_all +decide [ Complex.ext_iff, UnitLinks ];
  obtain ⟨ g, hg₀, hg₁, hg₂ ⟩ := hg.rec; use g; simp_all +decide [ funext_iff, gaugedLinks ] ;
  intro k; have := hu k; have := hv k; simp_all +decide [ Complex.ext_iff, div_eq_mul_inv ] ;
  simp_all +decide [ Complex.normSq, Complex.norm_def ];
  grind +ring

/-- **Classification corollary.**  For unit-link fields, equal holonomy
gives unitarily conjugate ring Hamiltonians (composing completeness with
the landed gauge conjugacy). -/
theorem unitarily_conjugate_of_holonomy_eq (n : ℕ) [NeZero n]
    (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (h : holonomy n u = holonomy n v) :
    ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  convert exists_gauge_of_holonomy_eq n u v hu hv h using 1;
  constructor <;> rintro ⟨ W, hW ⟩;
  · convert exists_gauge_of_holonomy_eq n u v hu hv h using 1;
  · refine' ⟨ Matrix.diagonal W, _, _ ⟩ <;> simp_all +decide [ Matrix.mem_unitaryGroup_iff ];
    · ext i j ; by_cases hi : i = j <;> simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
      · simp +decide [ hi, Matrix.one_apply ];
      · exact Or.inr ( if_neg ( Ne.symm hi ) );
    · convert HRing_gauge_conjugacy n hn W u _ |> Eq.symm using 1;
      · ext i j ; by_cases hi : i = j <;> aesop;
      · rw [ hW.2 ];
      · simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ]

end PhysicsSM.Draft.NullEdge.RingHolonomyClassification
