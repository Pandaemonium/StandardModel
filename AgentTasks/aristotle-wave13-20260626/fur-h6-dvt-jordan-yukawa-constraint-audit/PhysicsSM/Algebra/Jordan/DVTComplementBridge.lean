import Mathlib
import PhysicsSM.Algebra.Jordan.DVTAction
import PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear

/-!
# Algebra.Jordan.DVTComplementBridge

Bridge between the DVT complement scaffold (`H3OComplement` from `DVTAction`)
and the trusted complement subtype (`complementAddSubgroup` from
`H3OComplexMatrixLinear`), together with the matrix coordinate model
`Matrix (Fin 3) (Fin 3) ℂ`.

## Main declarations

- `inH3OComplement_iff_inComplementOfB` — the two complement predicates agree.
- `H3OComplement.toH3O_inComplementOfB` — the DVT scaffold embedding lands in
  the complement subgroup.
- `extractComplement_toH3O_of_inComplementOfB` — extracting and re-embedding
  a complement element is the identity.
- `h3oComplementAddEquivComplementSubgroup` — additive equivalence between
  the DVT scaffold and the complement subgroup.
- `h3oComplementEquivM3C` — equivalence between the DVT scaffold and `M₃(ℂ)`.

## Claim boundary

This is only a coordinate/model bridge. It does not claim the DVT stabilizer
theorem `(SU(3) × SU(3)) / ℤ₃` and does not prove Jordan-product preservation.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ## Predicate equivalence -/

/--
The two complement predicates agree: `InH3OComplement` (from the DVT
    scaffold) and `InComplementOfB` (from the trace-form complement) are
    definitionally equal.
-/
theorem inH3OComplement_iff_inComplementOfB
    (a : H3O.H3O) :
    InH3OComplement a ↔ H3O.InComplementOfB a := by
  unfold InH3OComplement InComplementOfB; aesop;

/-! ## Membership bridge lemmas -/

/--
The DVT scaffold embedding lands in the trace-form complement.
-/
theorem H3OComplement.toH3O_inComplementOfB
    (w : H3OComplement) :
    H3O.InComplementOfB w.toH3O := by
  convert H3OComplement.toH3O_inH3OComplement w using 1

/--
Helper: projecting a complement octonion to `ComplexTriple` and embedding
    back recovers the original.
-/
private theorem toComplexTriple_toOctonion_of_inComplement
    {o : Octonion} (ho : InChosenComplexComplement o) :
    o.toComplexTriple.toOctonion = o := by
  cases ho;
  cases o ; aesop

/--
Extracting the complement of a complement element and re-embedding
    recovers the original element.
-/
theorem extractComplement_toH3O_of_inComplementOfB
    {a : H3O.H3O} (ha : H3O.InComplementOfB a) :
    (extractComplement a).toH3O = a := by
  cases ha;
  rename_i h;
  cases h.2.2.1 ; cases h.2.2.2.1 ; cases h.2.2.2.2 ; aesop

/-! ## AddCommGroup instance on H3OComplement -/

instance : Sub H3OComplement :=
  ⟨fun a b => ⟨a.cx - b.cx, a.cy - b.cy, a.cz - b.cz⟩⟩

instance : AddCommGroup H3OComplement where
  add_assoc a b c := by ext <;> apply add_assoc
  zero_add a := by ext <;> apply zero_add
  add_zero a := by ext <;> apply add_zero
  nsmul := nsmulRec
  zsmul := zsmulRec
  add_comm a b := by ext <;> apply add_comm
  neg_add_cancel a := by ext <;> apply neg_add_cancel
  sub_eq_add_neg a b := by
    ext <;> simp [HSub.hSub, Sub.sub, HAdd.hAdd, Add.add, Neg.neg]

/-! ## Additive equivalence with complement subgroup -/

/-- The additive map from `H3OComplement` to the complement subgroup. -/
private def toComplementSubgroupFun (w : H3OComplement) :
    H3O.complementAddSubgroup :=
  ⟨w.toH3O, w.toH3O_inComplementOfB⟩

/-- The additive map from the complement subgroup to `H3OComplement`. -/
private def fromComplementSubgroupFun (a : H3O.complementAddSubgroup) :
    H3OComplement :=
  extractComplement a.val

private theorem toH3O_add (a b : H3OComplement) :
    (a + b).toH3O = a.toH3O + b.toH3O := by
  obtain ⟨a₁, a₂, a₃⟩ := a
  obtain ⟨b₁, b₂, b₃⟩ := b
  simp [H3OComplement.toH3O]
  congr <;> simp [ComplexTriple.toOctonion]
  all_goals congr <;> simp

/-- The additive equivalence between the DVT scaffold `H3OComplement` and
    the complement subgroup `complementAddSubgroup`. -/
noncomputable def h3oComplementAddEquivComplementSubgroup :
    H3OComplement ≃+ H3O.complementAddSubgroup where
  toFun := toComplementSubgroupFun
  invFun := fromComplementSubgroupFun
  left_inv w := H3OComplement.roundtrip w
  right_inv a := by
    ext1
    exact extractComplement_toH3O_of_inComplementOfB a.property
  map_add' a b := by
    apply Subtype.ext
    exact toH3O_add a b

/-! ## Equivalence with M₃(ℂ) -/

/-- The equivalence between the DVT scaffold `H3OComplement` and
    `Matrix (Fin 3) (Fin 3) ℂ`. -/
noncomputable def h3oComplementEquivM3C :
    H3OComplement ≃ Matrix (Fin 3) (Fin 3) ℂ :=
  (h3oComplementAddEquivComplementSubgroup.toEquiv).trans
    (H3O.complementLinearEquivM3C.toEquiv)

/-- The matrix equivalence sends `w` to the complement coordinates of its
    embedding. -/
theorem h3oComplementEquivM3C_apply
    (w : H3OComplement) :
    h3oComplementEquivM3C w = H3O.complementToM3C w.toH3O := by
  rfl

end PhysicsSM.Algebra.Jordan.DVTAction
