/-
# Null-Edge Gate C: interface-shape does not imply a chiral index witness

This is a tiny, self-contained finite model establishing a guardrail for the
null-edge Gate C program (C93/C94 overlap / Ginsparg-Wilson / domain-wall
interfaces):

> An algebraic *interface shape* by itself can be satisfied by trivial or
> zero-index models. A genuine C1 (physical chiral release) must additionally
> require a *nonzero chiral / index witness*.

We model a candidate by a toy record carrying enough information to distinguish
"form" (does it have the interface shape?) from "content" (does it carry a
nonzero net chirality / index?). We then prove:

* `interface_shape_not_index_witness` — a concrete interface-shaped *zero-index*
  countermodel (form without content);
* `interface_shape_with_index_witness` — a concrete interface-shaped *nonzero
  index* witness (non-vacuity: the shape *can* coexist with a real witness);
* `zero_index_blocks_chiral_witness` — the reusable guardrail consumed by
  C93/C94: a zero index can never supply a chiral index witness.

The file is intentionally independent of the full null-edge operator and uses
only finite/decidable data.
-/

namespace PhysicsSM.Draft.NullEdgeChiralIndexWitnessGuardrail

/-- A toy candidate interface.  `hasInterfaceShape` records whether the candidate
satisfies the algebraic overlap / Ginsparg-Wilson / domain-wall *interface shape*.
`plusCount` and `minusCount` record the number of positive- and negative-chirality
zero modes, so their difference is the toy "index". -/
structure InterfaceToy where
  hasInterfaceShape : Bool
  plusCount : Nat
  minusCount : Nat
deriving DecidableEq, Repr

/-- The candidate satisfies the algebraic interface shape.  Crucially this
predicate refers *only* to `hasInterfaceShape`; it says nothing about the
index counts, so it cannot smuggle in a nonzero index. -/
def InterfaceShape (T : InterfaceToy) : Prop := T.hasInterfaceShape = true

/-- Toy-level nonzero net chirality: the number of positive- and negative-chirality
modes differ.

The `Toy` prefix is intentional. This predicate is a planning guardrail, not the eventual
C1 chiral-index witness for a concrete null-edge/overlap/domain-wall operator. -/
def ToyChiralIndexNonzero (T : InterfaceToy) : Prop := T.plusCount ≠ T.minusCount

/-- The candidate has zero net index: equally many positive- and
negative-chirality modes (the vectorlike / zero-operator trap). -/
def ZeroIndex (T : InterfaceToy) : Prop := T.plusCount = T.minusCount

instance (T : InterfaceToy) : Decidable (InterfaceShape T) := by
  unfold InterfaceShape; infer_instance
instance (T : InterfaceToy) : Decidable (ToyChiralIndexNonzero T) := by
  unfold ToyChiralIndexNonzero; infer_instance
instance (T : InterfaceToy) : Decidable (ZeroIndex T) := by
  unfold ZeroIndex; infer_instance

/-! ## Concrete countermodel: interface shape without index witness -/

/-- Interface-shaped, but vectorlike: one `+` mode and one `-` mode, net index `0`. -/
def zeroIndexToy : InterfaceToy :=
  { hasInterfaceShape := true, plusCount := 1, minusCount := 1 }

/-- Interface-shaped *and* carrying a genuine index witness: one `+` mode,
no `-` modes, net index `1`. -/
def witnessToy : InterfaceToy :=
  { hasInterfaceShape := true, plusCount := 1, minusCount := 0 }

/-! ## Required guardrail theorems -/

/-- **Form is not content.**  There is a candidate with the interface shape that
nonetheless has *no* chiral index witness: the concrete vectorlike `zeroIndexToy`. -/
theorem interface_shape_not_index_witness :
    ∃ T : InterfaceToy, InterfaceShape T ∧ ¬ ToyChiralIndexNonzero T := by
  exact ⟨zeroIndexToy, by decide, by decide⟩

/-- **Non-vacuity.**  The interface shape is compatible with a genuine index
witness: the concrete `witnessToy` has both. -/
theorem interface_shape_with_index_witness :
    ∃ T : InterfaceToy, InterfaceShape T ∧ ToyChiralIndexNonzero T := by
  exact ⟨witnessToy, by decide, by decide⟩

/-- **Reusable guardrail for C93/C94.**  A zero net index can never provide a
chiral index witness.  Consumers should therefore treat overlap / Ginsparg-Wilson
/ domain-wall interface shape as C1 release *only* when paired with a candidate
for which `ZeroIndex` fails (equivalently, `ChiralIndexWitness` holds). -/
theorem zero_index_blocks_chiral_witness (T : InterfaceToy) :
    ZeroIndex T → ¬ ToyChiralIndexNonzero T := by
  intro h hw
  exact hw h

/-- Convenience corollary: the headline non-implication, packaged as the failure
of the universal "shape ⇒ witness" statement.  This is what protects against the
zero-operator / vectorlike-interface trap. -/
theorem shape_does_not_imply_witness :
    ¬ (∀ T : InterfaceToy, InterfaceShape T → ToyChiralIndexNonzero T) := by
  intro h
  exact (h zeroIndexToy (by decide)) (by decide)

end PhysicsSM.Draft.NullEdgeChiralIndexWitnessGuardrail
