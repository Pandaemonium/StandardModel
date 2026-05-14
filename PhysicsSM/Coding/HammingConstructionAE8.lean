import PhysicsSM.Coding.HammingSelfDual
import PhysicsSM.Coding.ConstructionALatticeProperties
import PhysicsSM.Coding.E8Scaled
import PhysicsSM.Coding.E8Basis
import PhysicsSM.Coding.E8BasisSpanning
import PhysicsSM.Coding.E8ShortVectors
import PhysicsSM.Coding.E8HalfIntegerBridge
import PhysicsSM.Algebra.Octonion.E8RootCompleteness
import PhysicsSM.Algebra.Octonion.E8WeylBasic

/-!
# Publication package: Hamming Construction A and E8

This module collects the kernel-checked endpoints of the current
Hamming-code-to-E8 formalization behind short, citation-friendly theorem
names. It intentionally proves no new mathematics; it is an index layer for
the paper and for downstream bridge files.

Conventions:

* `hammingConstructionALattice` / `e8IntLattice` is the unscaled integer
  Construction A lattice in `Fin 8 -> Int`.
* `sqNorm = 4` is the unscaled short-vector convention.
* `scaledSqNorm = 2` is the conventional `1 / sqrt 2` E8 root convention.
* The finite enumeration theorems inherited here use `native_decide`, so a
  publication should acknowledge Lean's `trustCompiler` axiom for those facts.
-/

namespace PhysicsSM.Coding.HammingConstructionAE8

/-! ## Code-theoretic input -/

/-- The extended Hamming code is Type II: self-dual and doubly even. -/
theorem code_is_typeII : IsTypeII extendedHamming8 :=
  PhysicsSM.Coding.extendedHamming8_typeII

/-! ## Lattice basis and determinant package -/

/-- The displayed integer basis spans the full Hamming Construction A lattice. -/
theorem basis_spans (z : Fin 8 -> Int) (hz : z ∈ hammingConstructionALattice) :
    z ∈ Submodule.span Int (Set.range e8CodeBasisInt) :=
  PhysicsSM.Coding.e8CodeBasisInt_spans_hammingConstructionALattice z hz

/-- The span of the displayed integer basis is contained in the lattice. -/
theorem basis_span_subset :
    ∀ z, z ∈ Submodule.span Int (Set.range e8CodeBasisInt) ->
      z ∈ hammingConstructionALattice :=
  PhysicsSM.Coding.e8CodeBasisInt_span_subset

/-- The unscaled Gram determinant is `16 ^ 2`. -/
theorem gram_det_sixteen_sq : e8CodeBasisGram.det = 16 ^ 2 :=
  PhysicsSM.Coding.e8CodeBasisGram_det_eq_sixteen_sq

/-- After the `1 / sqrt 2` scaling, the Gram determinant is `1`. -/
theorem scaled_gram_det_one :
    (e8CodeBasisGram.det : Rat) / (2 ^ 8 : Rat) = 1 :=
  PhysicsSM.Coding.e8CodeBasis_scaled_gram_det

/-- Every lattice vector has unscaled squared norm divisible by four. -/
theorem sqNorm_divisible_by_four
    (z : Fin 8 -> Int) (hz : z ∈ hammingConstructionALattice) :
    (4 : Int) ∣ sqNorm z :=
  PhysicsSM.Coding.hammingConstructionALattice_sqNorm_dvd_four z hz

/-! ## Minimum norm and kissing number package -/

/-- The scaled minimum nonzero squared norm is exactly `2`. -/
theorem scaled_minimum_norm_two :
    (∀ z : Fin 8 -> Int, z ∈ e8IntLattice -> z ≠ 0 -> (2 : Real) ≤ scaledSqNorm z) ∧
    (∃ z : Fin 8 -> Int, z ∈ e8IntLattice ∧ z ≠ 0 ∧ scaledSqNorm z = 2) :=
  PhysicsSM.Coding.scaledE8_minSqNorm_two

/-- The explicit short-vector list has length `240`. -/
theorem short_vector_count_240 :
    shortHammingE8VectorList.length = 240 :=
  PhysicsSM.Coding.shortHammingE8Vector_count_eq_240

/-- Every short vector in the integer lattice appears in the explicit list. -/
theorem short_vector_list_complete (z : Fin 8 -> Int)
    (hz : isShortHammingE8Vector z) :
    z ∈ shortHammingE8VectorList :=
  PhysicsSM.Coding.shortHammingE8VectorList_complete z hz

/-- Every vector in the explicit list has unscaled squared norm `4`. -/
theorem short_vector_list_sqNorm (z : Fin 8 -> Int)
    (hz : z ∈ shortHammingE8VectorList) : sqNorm z = 4 :=
  PhysicsSM.Coding.shortHammingE8VectorList_sqNorm z hz

/-! ## Half-integer and octonionic root-system bridges -/

/-- The Hadamard bridge relates the Construction A model to the half-integer E8 model. -/
theorem hadamard_to_half_integer (z : Fin 8 -> Int) (hz : z ∈ e8IntLattice) :
    Matrix.mulVec hadamard8 z ∈ halfIntE8Doubled :=
  PhysicsSM.Coding.hadamard8_maps_constructionA_to_halfIntE8 z hz

/-- The two normalized models have matching minimum-norm data. -/
theorem scaled_model_matches_half_integer_model :
    ((sqNorm (0 : Fin 8 -> Int) : Rat) / 2 = 0) ∧
    ((sqNorm (0 : Fin 8 -> Int) : Rat) / 4 = 0) ∧
    (∃ z : Fin 8 -> Int, z ∈ e8IntLattice ∧ z ≠ 0 ∧ (sqNorm z : Rat) / 2 = 2) ∧
    (∃ y : Fin 8 -> Int, y ∈ halfIntE8Doubled ∧ y ≠ 0 ∧ (sqNorm y : Rat) / 4 = 2) ∧
    (∀ z : Fin 8 -> Int, z ∈ e8IntLattice -> z ≠ 0 -> (2 : Rat) ≤ (sqNorm z : Rat) / 2) ∧
    (∀ y : Fin 8 -> Int, y ∈ halfIntE8Doubled -> y ≠ 0 -> (2 : Rat) ≤ (sqNorm y : Rat) / 4) :=
  PhysicsSM.Coding.scaledE8_eq_halfIntegerE8

/-- The octonionic doubled-coordinate root list is complete for `IsE8RootD`. -/
theorem octonion_root_list_complete (v : Fin 8 -> Int)
    (hv : PhysicsSM.Algebra.Octonion.E8Root.IsE8RootD v) :
    v ∈ PhysicsSM.Algebra.Octonion.E8Root.rootList :=
  PhysicsSM.Algebra.Octonion.E8Root.rootList_complete_arbitrary v hv

/-- The octonionic doubled-coordinate root list is closed under Weyl reflections. -/
theorem octonion_root_reflection_closed :
    PhysicsSM.Algebra.Octonion.E8Root.rootList.Forall (fun r =>
      PhysicsSM.Algebra.Octonion.E8Root.rootList.Forall (fun v =>
        PhysicsSM.Algebra.Octonion.E8Root.reflectD r v ∈
          PhysicsSM.Algebra.Octonion.E8Root.rootList)) :=
  PhysicsSM.Algebra.Octonion.E8Root.reflectD_mem_rootList

end PhysicsSM.Coding.HammingConstructionAE8
