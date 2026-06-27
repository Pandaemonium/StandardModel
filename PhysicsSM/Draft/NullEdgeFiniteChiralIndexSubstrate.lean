import Mathlib

/-!
# A finite operator-theoretic substrate for the chiral index guardrail (C99)

**Status: draft / planning infrastructure only. This is NOT a C1 release theorem.**

This module is an intermediate hardening of the C98 `InterfaceToy` guardrail.
C98 modelled the chiral/index witness with three *arbitrary user-supplied*
fields (a Boolean `hasInterfaceShape` tag and two unconstrained natural-number
counts `plusCount`, `minusCount`).  That is forgeable: the counts are not the
kernel of any operator.

Here we replace those arbitrary fields by a finite, operator-theoretic
substrate:

* the state space is the finite basis `Fin n`;
* a **grading** `chirality : Fin n → Bool` splits the basis into a `+` sector
  and a `-` sector;
* a **finite operator** `D : Matrix (Fin n) (Fin n) ℚ` is the data the index is
  computed from.

A basis state `i` is a *kernel state* iff `D` annihilates the basis vector
`e i`, i.e. column `i` of `D` is identically zero (`∀ j, D j i = 0`).  This is a
genuine, structural property of the finite operator `D`, decidable because `ℚ`
has decidable equality.  The chiral index is then

```
ChiralIndex d = (# of + kernel states) - (# of - kernel states)
```

with both counts **computed from the substrate `(D, chirality)`**, not handed in
as free fields.  This is the key upgrade over C98.

The `InterfaceShape` predicate is a *structural* predicate ("the substrate has
both a `+`-graded and a `-`-graded state"), not a bare Boolean tag.

## Non-goals

This file makes **no** claim about: C1 physical chiral release, ghost-zero
safety, regulator-removal stability, overlap / Ginsparg–Wilson release,
domain-wall release, or any relation to the actual null-edge operator.  It is a
finite substrate for the *index half* of C1 only, intended to be instantiated
later with the real C93/C94 operator interfaces.  It does not import or depend on
C97's `GaugeData` Wilson-release scaffold.

The counted kernel here is the kernel *restricted to the coordinate basis*
(states annihilated by `D`); a later upgrade can replace this by the full
`finrank (ker D ⊓ sector)` once the genuine operator interface is plugged in.
-/

namespace NullEdgeFiniteChiralIndexSubstrate

/-- A finite operator-theoretic chiral substrate.

* `n`         : dimension of the finite state space `Fin n`;
* `chirality` : the grading splitting the basis into the `+` (`true`) and `-`
  (`false`) sectors;
* `D`         : the finite operator whose basis kernel defines the index. -/
structure FiniteChiralData where
  /-- Dimension of the finite state space. -/
  n : ℕ
  /-- Grading / chirality splitting of the basis: `true = +`, `false = -`. -/
  chirality : Fin n → Bool
  /-- The finite operator the index is computed from. -/
  D : Matrix (Fin n) (Fin n) ℚ

/-- A basis state `i` is a *kernel state* of `D` iff `D` annihilates the basis
vector `e i`, i.e. column `i` of `D` is identically zero.  This is a structural
property of the operator `D`, not a free field. -/
def IsKernelState (d : FiniteChiralData) (i : Fin d.n) : Prop :=
  ∀ j, d.D j i = 0

instance (d : FiniteChiralData) (i : Fin d.n) : Decidable (IsKernelState d i) :=
  inferInstanceAs (Decidable (∀ j, d.D j i = 0))

/-- The `+`-graded kernel states, as a finite set derived from `(D, chirality)`. -/
def plusKernelStates (d : FiniteChiralData) : Finset (Fin d.n) :=
  Finset.univ.filter (fun i => d.chirality i = true ∧ IsKernelState d i)

/-- The `-`-graded kernel states, as a finite set derived from `(D, chirality)`. -/
def minusKernelStates (d : FiniteChiralData) : Finset (Fin d.n) :=
  Finset.univ.filter (fun i => d.chirality i = false ∧ IsKernelState d i)

/-- The chiral index: number of `+` kernel states minus number of `-` kernel
states.  Both counts are computed from the finite substrate. -/
def ChiralIndex (d : FiniteChiralData) : ℤ :=
  (plusKernelStates d).card - (minusKernelStates d).card

/-- The chiral index is nonzero. -/
def FiniteChiralIndexNonzero (d : FiniteChiralData) : Prop :=
  ChiralIndex d ≠ 0

/-- The chiral index vanishes. -/
def ZeroChiralIndex (d : FiniteChiralData) : Prop :=
  ChiralIndex d = 0

/-- Structural interface predicate: the substrate has both a `+`-graded state and
a `-`-graded state.  This is a property of `chirality`, not a Boolean tag. -/
def InterfaceShape (d : FiniteChiralData) : Prop :=
  (∃ i, d.chirality i = true) ∧ (∃ j, d.chirality j = false)

/-! ## Guardrail theorems -/

/-- A vanishing chiral index blocks a nonzero chiral index. -/
theorem zero_index_blocks_chiral_index_nonzero (d : FiniteChiralData) :
    ZeroChiralIndex d → ¬ FiniteChiralIndexNonzero d := by
  intro h hne
  exact hne h

/-- Concrete zero-index countermodel: a two-state substrate with one `+` and one
`-` state, both annihilated by `D = 0`.  It has interface shape yet index `0`. -/
def zeroIndexModel : FiniteChiralData where
  n := 2
  chirality := fun i => decide (i = 0)
  D := 0

/-- Concrete nonzero-index witness: a two-state substrate with one `+` and one
`-` state, where the `+` state is in the kernel of `D` but the `-` state is not,
giving index `1`. -/
def nonzeroIndexModel : FiniteChiralData where
  n := 2
  chirality := fun i => decide (i = 0)
  D := Matrix.of (fun i j => if i = 1 ∧ j = 1 then 1 else 0)

/-- There is a substrate with interface shape and zero chiral index. -/
theorem exists_interface_zero_index :
    ∃ d : FiniteChiralData, InterfaceShape d ∧ ZeroChiralIndex d := by
  refine ⟨zeroIndexModel, ?_, ?_⟩
  · unfold InterfaceShape zeroIndexModel; decide
  · unfold ZeroChiralIndex; native_decide

/-- There is a substrate with interface shape and nonzero chiral index. -/
theorem exists_interface_nonzero_index :
    ∃ d : FiniteChiralData, InterfaceShape d ∧ FiniteChiralIndexNonzero d := by
  refine ⟨nonzeroIndexModel, ?_, ?_⟩
  · unfold InterfaceShape nonzeroIndexModel; decide
  · unfold FiniteChiralIndexNonzero; native_decide

/-- Interface shape alone does **not** imply a nonzero chiral index: the index
half of a C1 witness is not forced by the existence of a chiral interface. -/
theorem interface_shape_does_not_imply_chiral_index_nonzero :
    ¬ (∀ d : FiniteChiralData, InterfaceShape d → FiniteChiralIndexNonzero d) := by
  intro h
  obtain ⟨d, hshape, hzero⟩ := exists_interface_zero_index
  exact (h d hshape) hzero

end NullEdgeFiniteChiralIndexSubstrate
