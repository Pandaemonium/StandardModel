import PhysicsSM.Coding.HammingE8E8

/-!
# Aristotle integration: structural E8 x E8 direct-sum facts

This draft wrapper records the result of Aristotle job
`6b24bf9e-8c20-4fb4-a6d7-f0f84d22c18a` from 2026-05-15.

During integration, the useful proofs were promoted into the source module
`PhysicsSM.Coding.HammingE8E8` and its helper
`PhysicsSM.Coding.HammingE8E8Helpers`.  The wrapper below keeps the job's
original theorem names available while avoiding a second copy of the proof
scripts.

What was integrated:

* `hammingWeight_directSum16`: a proof by reindexing `Fin 16` as two copies of
  `Fin 8`;
* `binaryDot16_split`: the analogous dot-product split;
* `hamming16E8E8_selfDual`: direct-sum self-duality from the self-duality of
  `extendedHamming8`;
* `hamming16_minimal_vectors_card`: a 480-count proof by the product
  decomposition `240 + 240`, avoiding a direct 16-dimensional enumeration.

Trust note: the splitting and self-duality proofs are ordinary tactic proofs.
The 480 theorem is structural at the 16-dimensional level but still depends on
finite 8-dimensional shell certificates through
`PhysicsSM.Coding.HammingE8E8Helpers`.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-- Job-D wrapper for the integrated Hamming-weight split. -/
theorem hammingWeight_directSum16_structural (v : BinaryVector 16) :
    hammingWeight v =
      hammingWeight (projLeft16 v) + hammingWeight (projRight16 v) :=
  hammingWeight_directSum16 v

/-- Job-D wrapper for the integrated binary-dot split. -/
theorem binaryDot16_split_structural (v w : BinaryVector 16) :
    binaryDot v w =
      binaryDot (projLeft16 v) (projLeft16 w) +
      binaryDot (projRight16 v) (projRight16 w) :=
  binaryDot16_split v w

/-- Job-D wrapper for the integrated self-duality theorem. -/
theorem hamming16E8E8_selfDual_structural : IsSelfDual hamming16E8E8 :=
  hamming16E8E8_selfDual

/-- Job-D wrapper for the integrated 480 minimal-vector count. -/
theorem hamming16_minimal_vectors_card_structural :
    (Finset.univ.filter (fun fg : (Fin 8 -> Fin 5) × (Fin 8 -> Fin 5) =>
      let v1 := fun i => coordVals5 (fg.1 i)
      let v2 := fun i => coordVals5 (fg.2 i)
      sqNorm v1 + sqNorm v2 = 4 /\
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v1) = 0 /\
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v2) = 0)).card = 480 :=
  hamming16_minimal_vectors_card

end PhysicsSM.Coding
