# Job: forward-cone four-vectors have positive-semidefinite Pauli representatives
# (closes kinematic completeness of the null-edge mass representation)

Mathlib-only, self-contained. This is the ONE analytic input that upgrades a landed
conditional coverage theorem to unconditional. A kernel refutation is a first-class
result but the statement is a standard true fact.

## Context (do not need to reprove; stated for intent)
A landed module proves: (a) a 2x2 complex matrix is a null-edge bundle momentum
`sum_i psi_i psi_i^dagger` iff it is positive semidefinite; (b) the explicit Pauli map
`hermOfVec p` below has soldered vector `p` and determinant equal to the Minkowski square.
The missing piece is that a future-pointing, non-spacelike four-vector has a POSITIVE
SEMIDEFINITE Pauli representative. Then every forward-cone vector is a null-edge bundle.

## Definitions (use exactly these)
```
open scoped ComplexOrder
open Matrix Complex

abbrev Vec4 := Fin 4 -> Real

/-- Minkowski square, signature (+,-,-,-). -/
def minkowskiSq (p : Vec4) : Real := (p 0)^2 - (p 1)^2 - (p 2)^2 - (p 3)^2

/-- Pauli/Hermitian representative of a four-vector. -/
def hermOfVec (p : Vec4) : Matrix (Fin 2) (Fin 2) Complex :=
  !![((p 0 + p 3 : Real) : Complex), ((p 1 : Real) : Complex) - ((p 2 : Real) : Complex) * I;
     ((p 1 : Real) : Complex) + ((p 2 : Real) : Complex) * I, ((p 0 - p 3 : Real) : Complex)]

/-- The forward (future, non-spacelike) cone. -/
def ForwardCone (p : Vec4) : Prop := 0 <= p 0 /\ 0 <= minkowskiSq p
```

## Targets

1. **`hermOfVec_isHermitian (p : Vec4) : (hermOfVec p).IsHermitian`** - entrywise; the
   diagonal is real and the off-diagonal entries are conjugate. (Elementary; included so
   the PSD proof can use it.)

2. **THE MAIN THEOREM**
   `forwardCone_posSemidef (p : Vec4) (hp : ForwardCone p) : (hermOfVec p).PosSemidef`.
   Route suggestion: `Matrix.PosSemidef` is `IsHermitian` plus nonnegativity of the
   quadratic form `star x dotProduct (hermOfVec p) mulVec x` for all `x : Fin 2 -> Complex`.
   Writing `x = ![a, b]`, the real part of the form is
   `(p0+p3)|a|^2 + (p0-p3)|b|^2 + 2 Re((p1 - i p2) * conj a * b)`.
   Nonnegativity from `ForwardCone`: `p0 >= 0` and `p0^2 >= p1^2+p2^2+p3^2` give
   `p0+p3 >= 0`, `p0-p3 >= 0`, and by AM-GM plus Cauchy-Schwarz
   `(p0+p3)|a|^2 + (p0-p3)|b|^2 >= 2 sqrt((p0+p3)(p0-p3)) |a||b|
     = 2 sqrt(p0^2-p3^2) |a||b| >= 2 sqrt(p1^2+p2^2) |a||b| >= -2 Re((p1 - i p2) conj a b)`.
   If the eigen/AM-GM route is heavy, an equivalent and often cleaner Lean route is to
   exhibit `hermOfVec p` as a explicit sum of two rank-one PSD matrices (a Cholesky-type
   square root) using `Matrix.posSemidef_iff_eq_sum_vecMulVec` in reverse, or to invoke a
   2x2 positive-semidefinite criterion (nonnegative diagonal entries and nonnegative
   determinant) if one exists in Mathlib. Use whichever is most robust; the determinant is
   `minkowskiSq p >= 0` and the diagonal entries are `p0 +- p3 >= 0`.

3. **The packaged corollary**
   `forwardCone_hermOfVec_det (p : Vec4) : (hermOfVec p).det = ((minkowskiSq p : Real) : Complex)`
   (include the determinant computation so the package is self-contained), and then the
   headline consequence, stated in whatever minimal form you can prove:
   `exists_sum_rankOne_of_forwardCone (p : Vec4) (hp : ForwardCone p) :
      exists (n : Nat) (psi : Fin n -> (Fin 2 -> Complex)),
        hermOfVec p = sum i, Matrix.vecMulVec (psi i) (star (psi i))`.
   This is `forwardCone_posSemidef` composed with
   `Matrix.posSemidef_iff_eq_sum_vecMulVec`.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]); report `#print axioms`
  for each main theorem.
- If a 2x2 PSD criterion is not available and the quadratic-form route is heavy, land
  `hermOfVec_isHermitian` and `forwardCone_hermOfVec_det` plus a precise report of exactly
  which inequality lemma is missing, and prove the quadratic-form nonnegativity for the
  concrete rational sub-case `p = (2,1,0,0)` as a sanity witness. Partial is acceptable;
  the main theorem is the prize.
