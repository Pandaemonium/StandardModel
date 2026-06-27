import PhysicsSM.Coding.HammingSelfDual
import PhysicsSM.Coding.E8ThetaSeries

/-!
# Helper lemmas for the Hamming E8 x E8 direct sum

This file contains the proof ingredients used by
`PhysicsSM.Coding.HammingE8E8`.  It deliberately does **not** import
`HammingE8E8.lean`; this keeps the helper proofs independent of the frontier
theorems they are meant to close.

The first two lemmas are ordinary finite-sum reindexing facts:

* `hammingWeight_split16` rewrites the Hamming weight on `Fin 16` as the sum
  of the Hamming weights on the first and last eight coordinates.
* `binaryDot_split16` performs the same reindexing for the binary dot product.

The final helper, `hamming16_480_structural`, proves the 480 minimal-vector
count for the product shell.  It avoids a direct 16-dimensional enumeration:
the proof splits the shell into the two cases `(norm 4, norm 0)` and
`(norm 0, norm 4)`, using the already-established E8 minimum-norm bound to
exclude the case where both factors are nonzero.  The remaining 8-dimensional
factor counts still use small finite certificates, so this helper inherits the
same `n a t i v e _ d e c i d e` trust boundary as the existing E8 shell-count files.

Provenance: Aristotle job `6b24bf9e-8c20-4fb4-a6d7-f0f84d22c18a`,
2026-05-15.  The comments in this file were expanded during integration.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.unusedSimpArgs false

namespace PhysicsSM.Coding

/-! ## Projection definitions

The definitions below are private copies of the projections from
`HammingE8E8.lean`.  They are definitionally equal to the public projections,
but keeping private copies here avoids an import cycle. -/

/-- Project a 16-bit binary vector onto its left 8 coordinates. -/
private def projLeft16' (v : BinaryVector 16) : BinaryVector 8 :=
  fun i => v ⟨i.val, by omega⟩

/-- Project a 16-bit binary vector onto its right 8 coordinates. -/
private def projRight16' (v : BinaryVector 16) : BinaryVector 8 :=
  fun i => v ⟨8 + i.val, by omega⟩

/-- `projLeft16'` agrees with composing with `Fin.castAdd`. -/
private theorem projLeft16'_eq (v : BinaryVector 16) :
    projLeft16' v = v ∘ Fin.castAdd 8 := rfl

/-- `projRight16'` agrees with composing with `Fin.natAdd`. -/
private theorem projRight16'_eq (v : BinaryVector 16) :
    projRight16' v = v ∘ Fin.natAdd 8 := rfl

/-! ## Hamming weight splitting -/

/-- The Hamming weight of a 16-bit vector equals the sum of the weights of
its two 8-bit halves.

This is just the standard decomposition of `Fin 16` as the first eight
coordinates plus the last eight coordinates.  The proof expands
`hammingWeight` as a sum of indicator functions and then uses
`Fin.sum_univ_add` to reindex the sum. -/
theorem hammingWeight_split16 (v : BinaryVector 16) :
    hammingWeight v =
      hammingWeight (projLeft16' v) + hammingWeight (projRight16' v) := by
  simp only [hammingWeight, projLeft16', projRight16', Finset.card_eq_sum_ones, Finset.sum_filter]
  exact @Fin.sum_univ_add ℕ _ 8 8 (fun i => if v i ≠ 0 then 1 else 0)

/-! ## Binary dot product splitting -/

/-- The binary dot product of 16-bit vectors splits into the dot products of
their two 8-bit halves.

As above, the proof is a pure `Fin.sum_univ_add` reindexing.  No finite
truth-table computation is involved. -/
theorem binaryDot_split16 (v w : BinaryVector 16) :
    binaryDot v w =
      binaryDot (projLeft16' v) (projLeft16' w) +
      binaryDot (projRight16' v) (projRight16' w) := by
  simp only [binaryDot, projLeft16', projRight16']
  exact @Fin.sum_univ_add (ZMod 2) _ 8 8 (fun i => v i * w i)

/-! ## 480 minimal vectors structural decomposition -/

/-- Helper: the number of shell-4 vectors in one E8 factor (as Fin 5 encoding). -/
private def e8Shell4Count : ℕ :=
  (Finset.univ.filter (fun f : Fin 8 → Fin 5 =>
    sqNorm (fun i => coordVals5 (f i)) = 4 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (f i))) = 0)).card

/-- Helper: the number of zero-norm vectors in one E8 factor (as Fin 5 encoding). -/
private def e8Shell0Count : ℕ :=
  (Finset.univ.filter (fun f : Fin 8 → Fin 5 =>
    sqNorm (fun i => coordVals5 (f i)) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (f i))) = 0)).card

theorem e8Shell4Count_eq : e8Shell4Count = 240 := by
  native_decide +revert

theorem e8Shell0Count_eq : e8Shell0Count = 1 := by
  native_decide +revert

set_option linter.flexible false in
/-- The 480 theorem using product decomposition.

The filtered finset in the statement describes pairs of bounded E8 factor
coordinates whose squared norms add to `4` and whose mod-2 residues lie in the
extended Hamming code.  The proof splits this set into the disjoint union of:

* first factor in the norm-4 shell and second factor zero;
* first factor zero and second factor in the norm-4 shell.

The minimum-norm lemma `e8IntLattice_sqNorm_ge_four` excludes any mixed
nonzero possibility with both factors contributing positive norm. -/
theorem hamming16_480_structural :
    (Finset.univ.filter (fun fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) =>
      let v1 := fun i => coordVals5 (fg.1 i)
      let v2 := fun i => coordVals5 (fg.2 i)
      sqNorm v1 + sqNorm v2 = 4 ∧
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v1) = 0 ∧
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v2) = 0)).card = 480 := by
  -- Let's simplify the set description by separating the conditions.
  set S := {fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) |
    sqNorm (fun i => coordVals5 (fg.1 i)) = 4 ∧
    sqNorm (fun i => coordVals5 (fg.2 i)) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.1 i))) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.2 i))) = 0} with hS_def;
  -- Let's calculate the cardinality of the set S.
  have hS_card : S.ncard = 240 := by
    rw [ show S = ( Finset.filter ( fun fg : ( Fin 8 → Fin 5 ) × ( Fin 8 → Fin 5 ) => ( sqNorm fun i => coordVals5 ( fg.1 i ) ) = 4 ∧ ( sqNorm fun i => coordVals5 ( fg.2 i ) ) = 0 ∧ extendedHamming8ParityCheck.mulVec ( reduceModTwo fun i => coordVals5 ( fg.1 i ) ) = 0 ∧ extendedHamming8ParityCheck.mulVec ( reduceModTwo fun i => coordVals5 ( fg.2 i ) ) = 0 ) ( Finset.univ : Finset ( ( Fin 8 → Fin 5 ) × ( Fin 8 → Fin 5 ) ) ) ) from ?_ ];
    · rw [ Set.ncard_coe_finset ];
      rw [ show ( Finset.filter ( fun fg : ( Fin 8 → Fin 5 ) × ( Fin 8 → Fin 5 ) => ( sqNorm fun i => coordVals5 ( fg.1 i ) ) = 4 ∧ ( sqNorm fun i => coordVals5 ( fg.2 i ) ) = 0 ∧ extendedHamming8ParityCheck.mulVec ( reduceModTwo fun i => coordVals5 ( fg.1 i ) ) = 0 ∧ extendedHamming8ParityCheck.mulVec ( reduceModTwo fun i => coordVals5 ( fg.2 i ) ) = 0 ) ( Finset.univ : Finset ( ( Fin 8 → Fin 5 ) × ( Fin 8 → Fin 5 ) ) ) ) = Finset.image ( fun f : Fin 8 → Fin 5 => ( f, fun _ => 2 ) ) ( Finset.filter ( fun f : Fin 8 → Fin 5 => ( sqNorm fun i => coordVals5 ( f i ) ) = 4 ∧ extendedHamming8ParityCheck.mulVec ( reduceModTwo fun i => coordVals5 ( f i ) ) = 0 ) ( Finset.univ : Finset ( Fin 8 → Fin 5 ) ) ) from ?_ ];
      · native_decide +revert;
      · ext ⟨f, g⟩; simp [hS_def];
        constructor <;> intro h <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
        · have h_g_zero : ∀ i, coordVals5 (g i) = 0 := by
            exact fun i => by simpa [ sqNorm ] using Finset.sum_eq_zero_iff_of_nonneg ( fun _ _ => sq_nonneg _ ) |>.1 h.2.1 i;
          have h_g_zero : ∀ i, g i = 2 := by
            intro i; specialize h_g_zero i; fin_cases i <;> simp +decide at h_g_zero ⊢;
            all_goals rcases g_1 : g _ with ( _ | _ | _ | _ | _ | _ ) <;> simp +decide [ g_1 ] at h_g_zero ⊢;
            all_goals omega;
          simp +decide [ h_g_zero ];
        · rw [ show g = fun _ => 2 from funext fun i => by fin_cases i <;> tauto ] ; native_decide;
    · aesop;
  -- Let's calculate the cardinality of the set of pairs where the first component has squared norm 0 and the second component has squared norm 4.
  have hS_card_rev : (Set.ncard {fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) |
    sqNorm (fun i => coordVals5 (fg.1 i)) = 0 ∧
    sqNorm (fun i => coordVals5 (fg.2 i)) = 4 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.1 i))) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.2 i))) = 0}) = 240 := by
      rw [ ← hS_card ];
      fapply Set.ncard_congr;
      · use fun a ha => ( a.2, a.1 );
      · aesop;
      · lia;
      · exact fun b hb => ⟨ ( b.2, b.1 ), ⟨ hb.2.1, hb.1, hb.2.2.2, hb.2.2.1 ⟩, rfl ⟩;
  have h_union : {fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) |
    sqNorm (fun i => coordVals5 (fg.1 i)) + sqNorm (fun i => coordVals5 (fg.2 i)) = 4 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.1 i))) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.2 i))) = 0} = S ∪ {fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) |
    sqNorm (fun i => coordVals5 (fg.1 i)) = 0 ∧
    sqNorm (fun i => coordVals5 (fg.2 i)) = 4 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.1 i))) = 0 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo (fun i => coordVals5 (fg.2 i))) = 0} := by
      ext fg;
      constructor <;> intro hfg <;> simp_all +decide [ add_comm ];
      · have h_sqNorm_ge_four : ∀ (z : Fin 8 → ℤ), Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 → z ≠ 0 → 4 ≤ sqNorm z := by
          intros z hz hz_ne_zero
          apply e8IntLattice_sqNorm_ge_four z (by
          exact mem_e8IntLattice_iff_parityCheck z |>.2 hz) hz_ne_zero;
        by_cases h1 : (fun i => coordVals5 (fg.1 i)) = 0 <;> by_cases h2 : (fun i => coordVals5 (fg.2 i)) = 0 <;> simp_all +decide;
        · exact eq_of_sub_eq_zero ( by { have := hfg.1; norm_num [ sqNorm ] at *; linarith } );
        · exact eq_of_sub_eq_zero ( by rw [ show sqNorm 0 = 0 from by rfl ] at hfg; linarith );
        · linarith [ h_sqNorm_ge_four _ hfg.2.1 h1, h_sqNorm_ge_four _ hfg.2.2 h2 ];
      · grind;
  rw [ ← Set.ncard_coe_finset ] ; norm_num [ h_union, hS_card, hS_card_rev ] ;
  rw [ @Set.ncard_union_eq ];
  · grind;
  · exact Set.disjoint_left.mpr fun x hx₁ hx₂ => by linarith [ hx₁.1, hx₁.2.1, hx₂.1, hx₂.2.1 ] ;
  · exact Set.finite_of_ncard_pos ( by linarith );
  · exact Set.toFinite _

end PhysicsSM.Coding
