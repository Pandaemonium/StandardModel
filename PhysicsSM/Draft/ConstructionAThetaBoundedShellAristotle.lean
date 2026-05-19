import PhysicsSM.Coding.ConstructionAThetaConvolution

/-!
# Bounded enumerators for the first Construction A theta shells

`PhysicsSM.Coding.ConstructionAThetaConvolution` proves a clean unbounded
Construction A shell formula using the set

```lean
constructionAShellSet s = {z | z in e8IntLattice and sqNorm z = s}
```

The older coefficient files use bounded finite enumerators:

* `shellCountRange5 s`, for coordinates in `{-2, -1, 0, 1, 2}`;
* `shellCountRange7 s`, for coordinates in `{-3, -2, -1, 0, 1, 2, 3}`.

This file proves that the unbounded shell set has the same cardinality as
those bounded enumerators for the first few theta coefficients.  The key
mathematical point is simple but important for the formal API:

* if `sqNorm z <= 8`, every coordinate of `z` lies in `{-2, -1, 0, 1, 2}`;
* if `sqNorm z <= 12`, every coordinate of `z` lies in
  `{-3, -2, -1, 0, 1, 2, 3}`.

Therefore the bounded enumerators are not approximations for these small
shells; they are exact finite presentations of the unbounded Construction A
shells.  This lets the general convolution theorem feed back into the earlier
coefficient-level theta files.

Provenance: Aristotle job `fabe95d3-e213-4533-b479-13db27092d76`,
2026-05-15.  The returned proof locally copied `constructionAShellSet`; the
integrated version below reuses the canonical definition from
`PhysicsSM.Coding.ConstructionAThetaConvolution`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false
set_option linter.flexible false

namespace PhysicsSM.Coding

/-! ## Round-trip and injectivity helpers

The bounded shell enumerators are indexed by finite coordinate alphabets
`Fin 5` and `Fin 7`.  To compare them with an unbounded integer vector, we use
the existing decoders `intToFin5` and `intToFin7`, plus injectivity of the
coordinate-value tables.
-/

/-- `intToFin5` is a left-inverse of `coordVals5`. -/
lemma intToFin5_coordVals5 (k : Fin 5) :
    intToFin5 (coordVals5 k) = k := by
  native_decide +revert

/-- The coordinate table `{-2, -1, 0, 1, 2}` has no repeated entries. -/
lemma coordVals5_injective : Function.Injective coordVals5 := by
  native_decide

/-- `intToFin7` is a left-inverse of `coordVals7`. -/
lemma intToFin7_coordVals7 (k : Fin 7) :
    intToFin7 (coordVals7 k) = k := by
  native_decide +revert

/-- The coordinate table `{-3, -2, -1, 0, 1, 2, 3}` has no repeated entries. -/
lemma coordVals7_injective : Function.Injective coordVals7 := by
  native_decide

/--
Pointwise injectivity of `coordVals5` lifts to injectivity of the map from a
finite-coordinate encoding to its integer vector.
-/
lemma coordVals5_comp_injective :
    Function.Injective (fun f : Fin 8 -> Fin 5 => fun i => coordVals5 (f i)) :=
  fun _ _ h => funext fun i => coordVals5_injective (congr_fun h i)

/--
Pointwise injectivity of `coordVals7` lifts to injectivity of the map from a
finite-coordinate encoding to its integer vector.
-/
lemma coordVals7_comp_injective :
    Function.Injective (fun f : Fin 8 -> Fin 7 => fun i => coordVals7 (f i)) :=
  fun _ _ h => funext fun i => coordVals7_injective (congr_fun h i)

/-! ## Set equality: unbounded shells as images of bounded finsets

For `s <= 8`, the unbounded shell set equals the image of the bounded
`shellCountRange5` finset under the `coordVals5` embedding.

* Soundness: if `f` is in the filtered finset, then `coordVals5 ∘ f` has the
  right squared norm and satisfies the Hamming parity-check condition, hence
  lies in `constructionAShellSet`.
* Completeness: if `z` lies in `constructionAShellSet s` and `s <= 8`, then
  the coordinate-bound theorem implies `|z i| <= 2`, so `z` is recovered from
  the bounded encoding `fun i => intToFin5 (z i)`.
-/

lemma constructionAShellSet_eq_image5 (s : Nat) (hs : s <= 8) :
    constructionAShellSet s =
      (fun f : Fin 8 -> Fin 5 => fun i => coordVals5 (f i)) ''
        ↑(Finset.univ.filter (fun f : Fin 8 -> Fin 5 =>
          let v := fun i => coordVals5 (f i)
          sqNorm v = (s : Int) ∧
          Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v) = 0)) := by
  ext z
  simp [constructionAShellSet, mem_e8IntLattice_iff_parityCheck]
  constructor
  · intro hz
    use fun i => intToFin5 (z i)
    have h_eq : (fun i => coordVals5 (intToFin5 (z i))) = z := by
      exact vector_eq_coordVals5_of_sqNorm_le_eight z (by linarith)
    aesop
  · aesop

/--
For `s <= 12`, the analogous presentation uses the larger coordinate table
`coordVals7`.  This covers the third nontrivial theta coefficient, where
coordinates with absolute value `3` can occur.
-/
lemma constructionAShellSet_eq_image7 (s : Nat) (hs : s <= 12) :
    constructionAShellSet s =
      (fun f : Fin 8 -> Fin 7 => fun i => coordVals7 (f i)) ''
        ↑(Finset.univ.filter (fun f : Fin 8 -> Fin 7 =>
          let v := fun i => coordVals7 (f i)
          sqNorm v = (s : Int) ∧
          Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v) = 0)) := by
  apply Set.ext
  intro z
  simp [constructionAShellSet]
  constructor
  · intro hz
    obtain ⟨hz_mem, hz_sq⟩ := hz
    have hz_abs : ∀ i, |z i| <= 3 := by
      exact fun i => coord_abs_le_three_of_sqNorm_le_twelve z (hz_sq ▸ mod_cast hs) i
    use fun i => intToFin7 (z i)
    exact ⟨
      ⟨by
        rw [← hz_sq, vector_eq_coordVals7_of_sqNorm_le_twelve z (by linarith)]
       ,
       by
        simpa [vector_eq_coordVals7_of_sqNorm_le_twelve z (by linarith)]
          using (mem_e8IntLattice_iff_parityCheck z).1 hz_mem⟩,
      vector_eq_coordVals7_of_sqNorm_le_twelve z (by linarith)⟩
  · rintro ⟨x, hx, rfl⟩
    exact ⟨(mem_e8IntLattice_iff_parityCheck _).2 hx.2, hx.1⟩

/-! ## Primary shell-cardinality bridges -/

/-- The unbounded zero shell agrees with the existing range-5 enumerator. -/
theorem constructionAShellSet_ncard_eq_shellCountRange5_zero :
    Set.ncard (constructionAShellSet 0) = shellCountRange5 0 := by
  rw [constructionAShellSet_eq_image5 0 (by norm_num),
      Set.ncard_image_of_injective _ coordVals5_comp_injective,
      Set.ncard_coe_finset]
  rfl

/-- The unbounded norm-4 shell agrees with the existing range-5 enumerator. -/
theorem constructionAShellSet_ncard_eq_shellCountRange5_four :
    Set.ncard (constructionAShellSet 4) = shellCountRange5 4 := by
  rw [constructionAShellSet_eq_image5 4 (by norm_num),
      Set.ncard_image_of_injective _ coordVals5_comp_injective,
      Set.ncard_coe_finset]
  rfl

/-- The unbounded norm-8 shell agrees with the existing range-5 enumerator. -/
theorem constructionAShellSet_ncard_eq_shellCountRange5_eight :
    Set.ncard (constructionAShellSet 8) = shellCountRange5 8 := by
  rw [constructionAShellSet_eq_image5 8 (by norm_num),
      Set.ncard_image_of_injective _ coordVals5_comp_injective,
      Set.ncard_coe_finset]
  rfl

/-- The unbounded norm-12 shell agrees with the existing range-7 enumerator. -/
theorem constructionAShellSet_ncard_eq_shellCountRange7_twelve :
    Set.ncard (constructionAShellSet 12) = shellCountRange7 12 := by
  rw [constructionAShellSet_eq_image7 12 (by norm_num),
      Set.ncard_image_of_injective _ coordVals7_comp_injective,
      Set.ncard_coe_finset]
  rfl

/--
Example downstream bridge: the `q^1` theta coefficient can be obtained from
the new general convolution theorem once the norm-4 shell is identified with
the bounded range-5 enumerator.
-/
theorem theta1_from_general_convolution :
    shellCountRange5 4 =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 4 +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 4 +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 4 := by
  rw [constructionAShellSet_ncard_eq_shellCountRange5_four.symm]
  exact constructionAShellCount_eq_weight_distribution_convolution 4

end PhysicsSM.Coding
