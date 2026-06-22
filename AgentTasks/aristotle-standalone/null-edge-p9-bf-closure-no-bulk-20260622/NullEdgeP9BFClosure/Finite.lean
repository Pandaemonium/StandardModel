import Mathlib

/-!
# Finite BF-closure / no-bulk-divergence toy model

This focused P9 target isolates the algebraic statement usually summarized as
"the boundary of a boundary is zero."  It is meant as a finite precursor to a
`DiamondSourceVisibility` API, not as a standalone cosmology theorem.

Given two incidence matrices

```text
D0 : vertex/boundary cells -> edge cells
D1 : edge cells            -> face/source cells
```

and the chain-complex condition `D1 . D0 = 0`, the source obtained by applying
both boundary maps is identically zero. Consequently it has zero pairing against
any finite bulk test.
-/

noncomputable section

namespace NullEdgeP9BFClosure

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite Euclidean pairing on `Fin n` cochains. -/
def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

/-- Pair a finite source with a finite bulk test observable. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

/-- Boundary-generated source or cochain induced by an incidence matrix. -/
def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

/--
Matrix composition condition for two finite incidence maps.

The order is chosen so `ChainComplex D0 D1` means applying `D0` and then `D1`
gives zero.
-/
def ChainComplex {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real) : Prop :=
  forall x z, Finset.univ.sum (fun y => D0 x y * D1 y z) = 0

/-- Applying two successive boundary maps is zero under the chain-complex law. -/
theorem boundarySource_comp_eq_zero_of_chainComplex
    {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real)
    (hcomplex : ChainComplex D0 D1) (a : Cochain v) :
    boundarySource D1 (boundarySource D0 a) = 0 := by
  sorry

/--
The corresponding twice-boundary source is invisible to every finite bulk test.
-/
theorem sourcePairing_boundarySource_comp_eq_zero_of_chainComplex
    {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real)
    (hcomplex : ChainComplex D0 D1) (a : Cochain v) (test : Cochain f) :
    sourcePairing (boundarySource D1 (boundarySource D0 a)) test = 0 := by
  sorry

/-- Adding a twice-boundary source does not change any finite bulk pairing. -/
theorem sourcePairing_eq_of_add_boundarySource_comp
    {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real)
    (hcomplex : ChainComplex D0 D1)
    (source : Cochain f) (a : Cochain v) (test : Cochain f) :
    sourcePairing (fun i => source i + boundarySource D1 (boundarySource D0 a) i)
        test =
      sourcePairing source test := by
  sorry

end NullEdgeP9BFClosure
