import PhysicsSM.Algebra.Jordan.StabilizerDerivation
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Jordan.DVTAction

/-!
# Algebra.Jordan.DVTStabilizerPrelude

Lie-algebraic stabilizer prelude for the Baez / Dubois-Violette / Todorov
route to the Standard Model gauge group via the exceptional Jordan algebra.

The DVT approach studies stabilizers of the standard pair of subalgebras
`A = h_2(O)` and `B = h_3(C)` inside `h_3(O)`. At the Lie algebra level, the
derivation stabilizers of these subalgebras are the infinitesimal versions of
the corresponding stabilizer subgroups.

This module formalizes a conservative prelude:
- the common derivation stabilizer `Stab(A) ∩ Stab(B)`,
- its containment in the stabilizer of `A ∩ B`,
- closure under zero, addition, negation, and commutator,
- DVT-facing re-exports of the trace-form splitting.

Claim boundary: this module does not prove `Aut(h_3(O)) ≃ F4`,
`Stab(A) ≃ Spin(9)`, or the final compact Lie group theorem
`S(U(2) x U(3))`.

Sources:
- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Michel Dubois-Violette and Ivan Todorov, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", Int. J. Mod. Phys. A 33(20), 1850118, 2018.
- Yokota, "Exceptional Lie Groups", arXiv:0902.0431.

Provenance: integrated from Aristotle job
`bceacd0d-e4bf-4121-ac4b-2f57c465d985`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Algebra.Jordan.StabilizerDerivation

/-! ## Common derivation stabilizer of A and B -/

/--
The common derivation stabilizer of the standard `h_2(O)` block `A` and the
standard `h_3(C)` block `B`.
-/
def standardAAndB_derivationStabilizer : Set H3ODerivation :=
  standardA_derivationStabilizer ∩ standardB_derivationStabilizer

/-- Membership in the common stabilizer means membership in both stabilizers. -/
theorem mem_standardAAndB_iff (D : H3ODerivation) :
    D ∈ standardAAndB_derivationStabilizer ↔
      D ∈ standardA_derivationStabilizer ∧ D ∈ standardB_derivationStabilizer :=
  Iff.rfl

/-! ## Stabilizing A and B implies stabilizing A ∩ B -/

/-- A derivation stabilizing both standard blocks also stabilizes their intersection. -/
theorem stabilizes_A_and_B_implies_stabilizes_intersection
    {D : H3ODerivation}
    (hA : D ∈ standardA_derivationStabilizer)
    (hB : D ∈ standardB_derivationStabilizer) :
    D ∈ standardAInterB_derivationStabilizer :=
  inter_stabilizer_subset_standardAInterB ⟨hA, hB⟩

/-- The common stabilizer is contained in the intersection stabilizer. -/
theorem standardAAndB_subset_standardAInterB :
    standardAAndB_derivationStabilizer ⊆ standardAInterB_derivationStabilizer :=
  inter_stabilizer_subset_standardAInterB

/-! ## Closure properties of the common stabilizer -/

/-- The zero derivation lies in the common stabilizer. -/
theorem zero_mem_standardAAndB_derivationStabilizer :
    (0 : H3ODerivation) ∈ standardAAndB_derivationStabilizer :=
  ⟨zero_mem_standardA_derivationStabilizer,
   zero_mem_standardB_derivationStabilizer⟩

/-- The common stabilizer is closed under addition. -/
theorem add_mem_standardAAndB_derivationStabilizer
    {D1 D2 : H3ODerivation}
    (h1 : D1 ∈ standardAAndB_derivationStabilizer)
    (h2 : D2 ∈ standardAAndB_derivationStabilizer) :
    D1 + D2 ∈ standardAAndB_derivationStabilizer :=
  ⟨add_mem_standardA_derivationStabilizer h1.1 h2.1,
   add_mem_standardB_derivationStabilizer h1.2 h2.2⟩

/-- The common stabilizer is closed under negation. -/
theorem neg_mem_standardAAndB_derivationStabilizer
    {D : H3ODerivation}
    (h : D ∈ standardAAndB_derivationStabilizer) :
    -D ∈ standardAAndB_derivationStabilizer :=
  ⟨neg_mem_standardA_derivationStabilizer h.1,
   neg_mem_standardB_derivationStabilizer h.2⟩

/-- The common stabilizer is closed under the commutator bracket. -/
theorem standardAAndB_derivationStabilizer_commutator_mem
    {D1 D2 : H3ODerivation}
    (h1 : D1 ∈ standardAAndB_derivationStabilizer)
    (h2 : D2 ∈ standardAAndB_derivationStabilizer) :
    commutator D1 D2 ∈ standardAAndB_derivationStabilizer :=
  ⟨commutator_mem_standardA_derivationStabilizer h1.1 h2.1,
   commutator_mem_standardB_derivationStabilizer h1.2 h2.2⟩

/-! ## Trace-form splitting compatibility -/

/-- The `h_3(C)` summand and its trace-form orthogonal complement are orthogonal. -/
theorem standardB_complement_traceForm_zero
    {b c : H3O} (hb : InStandardB b) (hc : InComplementOfB c) :
    traceForm b c = 0 :=
  traceForm_orthogonal hb hc

/-- Every element decomposes as its `h_3(C)` part plus its complement part. -/
theorem h3o_standardB_plus_complement (a : H3O) :
    a = toH3CPart a + toComplementPart a :=
  decomp_sum a

/-! ## Common stabilizer as a bundled Lie-subalgebra-like record -/

/--
A lightweight record witnessing that a set of derivations is closed under the
basic operations expected of a Lie subalgebra.
-/
structure DerivationLieSubalgebra where
  /-- The carrier set of derivations. -/
  carrier : Set H3ODerivation
  /-- The zero derivation is in the carrier. -/
  zero_mem : (0 : H3ODerivation) ∈ carrier
  /-- The carrier is closed under addition. -/
  add_mem : ∀ {D1 D2 : H3ODerivation}, D1 ∈ carrier → D2 ∈ carrier →
    D1 + D2 ∈ carrier
  /-- The carrier is closed under negation. -/
  neg_mem : ∀ {D : H3ODerivation}, D ∈ carrier → -D ∈ carrier
  /-- The carrier is closed under the commutator bracket. -/
  comm_mem : ∀ {D1 D2 : H3ODerivation}, D1 ∈ carrier → D2 ∈ carrier →
    commutator D1 D2 ∈ carrier

/-- The `h_2(O)` derivation stabilizer as a Lie-subalgebra-like record. -/
def standardA_lieSubalgebra : DerivationLieSubalgebra where
  carrier := standardA_derivationStabilizer
  zero_mem := zero_mem_standardA_derivationStabilizer
  add_mem := add_mem_standardA_derivationStabilizer
  neg_mem := neg_mem_standardA_derivationStabilizer
  comm_mem := commutator_mem_standardA_derivationStabilizer

/-- The `h_3(C)` derivation stabilizer as a Lie-subalgebra-like record. -/
def standardB_lieSubalgebra : DerivationLieSubalgebra where
  carrier := standardB_derivationStabilizer
  zero_mem := zero_mem_standardB_derivationStabilizer
  add_mem := add_mem_standardB_derivationStabilizer
  neg_mem := neg_mem_standardB_derivationStabilizer
  comm_mem := commutator_mem_standardB_derivationStabilizer

/-- The `h_2(C)` derivation stabilizer as a Lie-subalgebra-like record. -/
def standardAInterB_lieSubalgebra : DerivationLieSubalgebra where
  carrier := standardAInterB_derivationStabilizer
  zero_mem := zero_mem_standardAInterB_derivationStabilizer
  add_mem := add_mem_standardAInterB_derivationStabilizer
  neg_mem := neg_mem_standardAInterB_derivationStabilizer
  comm_mem := commutator_mem_standardAInterB_derivationStabilizer

/-- The common derivation stabilizer of `A` and `B` as a bundled record. -/
def standardAAndB_lieSubalgebra : DerivationLieSubalgebra where
  carrier := standardAAndB_derivationStabilizer
  zero_mem := zero_mem_standardAAndB_derivationStabilizer
  add_mem := add_mem_standardAAndB_derivationStabilizer
  neg_mem := neg_mem_standardAAndB_derivationStabilizer
  comm_mem := standardAAndB_derivationStabilizer_commutator_mem

/-- The common stabilizer record maps into the intersection stabilizer record. -/
theorem standardAAndB_lieSubalgebra_subset_standardAInterB :
    standardAAndB_lieSubalgebra.carrier ⊆
      standardAInterB_lieSubalgebra.carrier :=
  standardAAndB_subset_standardAInterB

end PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
