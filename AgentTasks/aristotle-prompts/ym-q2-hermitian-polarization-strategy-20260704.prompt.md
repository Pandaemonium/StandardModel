# Aristotle strategy job: Hermitian-from-real-quadratic-form for RP-KER's Q2 bridge lemma

You are acting as a Lean/Mathlib research strategist, not a prover. Do NOT
attempt a full Lean build. You MAY search Mathlib source and write short
test snippets to check whether a lemma exists, but the deliverable is a
written report plus (if you find or can prove it cheaply) a short Lean
lemma, not a full project proof.

Formatting: ASCII only, LF line endings. Spaced escape-hatch tokens in
prose (`s o r r y`, `a x i o m`).

## Standalone context

We have a Lean 4 project (Mathlib, toolchain v4.28.0) with a finite
reflection-positivity kernel theorem already proved:

```lean
variable {A C : Type} [Fintype A] [Fintype C]

def reflectionForm (W : A -> C -> A -> Complex) (f : A -> C -> Complex) :
    Complex :=
  Finset.sum Finset.univ (fun c : C => Finset.sum Finset.univ (fun b : A =>
    Finset.sum Finset.univ (fun a : A =>
      (starRingEnd Complex) (f b c) * W a c b * f a c)))

def IsReflectionPositive (W : A -> C -> A -> Complex) : Prop :=
  forall f : A -> C -> Complex, 0 <= reflectionForm W f
```

(`0 <= z` for `z : Complex` is the `ComplexOrder` order: `z.im = 0` and
`0 <= z.re`.)

We want to build a finite-dimensional Hilbert space and a positive
self-adjoint "transfer operator" out of `IsReflectionPositive W` alone,
by the following route: let `I := C x A`, and let `rpBlockMatrix W :
Matrix I I Complex` be the block-diagonal (in the `C` factor) matrix with
`(rpBlockMatrix W) (c, b) (c, a) = W a c b` when the two `C`-components
agree, and `0` when they differ. Currying identifies a vector `x : I ->
Complex` with a function `f : A -> C -> Complex` (via `x (c, a) = f a
c`), and one checks that `reflectionForm W f` equals the standard
`Matrix.dotProduct`/`Matrix.mulVec` quadratic form `star x ⬝ᵥ
(rpBlockMatrix W *ᵥ x)` under this identification.

We want the theorem:

```lean
theorem rpBlockMatrix_posSemidef_of_reflectionPositive
    (W : A -> C -> A -> Complex) (hW : IsReflectionPositive W) :
    (rpBlockMatrix W).PosSemidef := ...
```

## The exact difficulty (why this is not routine)

We checked the pinned Mathlib source directly (not semantic search):
`Matrix.PosSemidef` is DEFINED as `M.IsHermitian /\ (forall x, 0 <= star x
⬝ᵥ (M *ᵥ x))`, and the constructor
`Matrix.PosSemidef.of_dotProduct_mulVec_nonneg` REQUIRES `M.IsHermitian`
as a SEPARATE hypothesis - it does not derive Hermitian-ness from the
quadratic form condition alone. `IsReflectionPositive W` as defined above
gives us ONLY "the quadratic form is real and nonnegative for every
vector" - it does NOT separately assume any symmetry of `W`. So proving
`(rpBlockMatrix W).IsHermitian` from `IsReflectionPositive W` needs a
genuine POLARIZATION argument: for a general complex matrix `M`, if `star
x ⬝ᵥ (M *ᵥ x)` is REAL for every vector `x` (not just nonnegative - just
real is enough for this direction), then `M` must be Hermitian. This is
classical (the antisymmetric/skew-Hermitian part of `M` contributes a
purely imaginary quadratic form via polarization, so requiring realness
for every vector forces that part to vanish), but we could not confirm by
grep whether Mathlib has this EXACT fact (real-diagonal-quadratic-form
implies-Hermitian) for matrices, only adjacent machinery:
`LinearMap.IsSymmetric.inner_map_polarization` and a comment mentioning "a
complex version without the symmetric assumption" in
`Mathlib/Analysis/InnerProductSpace/Symmetric.lean`.

## Questions

1. Super-stretch primary deliverable: does Mathlib (this pinned version,
   or a close relative you can identify precisely) already have the fact
   "for a matrix (or sesquilinear form, or linear operator on a finite-
   dimensional or general inner product space) over `Complex`, if `star x
   ⬝ᵥ (M *ᵥ x)` (or the corresponding inner-product quadratic form) is
   REAL for every `x`, then `M` is Hermitian (or the operator is
   self-adjoint/symmetric)"? Search by name pattern and by content
   (`IsHermitian`, `IsSymmetric`, `IsSelfAdjoint` combined with `real`,
   `polarization`, `conj`, `im`). If you find it, give the exact
   statement, file, and the one-line adaptation needed to apply it to
   `Matrix (I) (I) Complex` with `I := C x A`.
2. If it does NOT exist under any name: return a complete, Lean-ready
   proof of the general fact
   `theorem posSemidef_of_forall_dotProduct_real_nonneg {n : Type} [Fintype n]
   [DecidableEq n] (M : Matrix n n Complex)
   (hreal : forall x : n -> Complex, (star x ⬝ᵥ (M *ᵥ x)).im = 0)
   (hnonneg : forall x : n -> Complex, 0 <= (star x ⬝ᵥ (M *ᵥ x)).re) :
   M.PosSemidef`
   via the polarization identity: express `star x ⬝ᵥ (M *ᵥ x + M *ᵥ y)`-type
   combinations (or the standard 4-term polarization using `x`, `y`, `x +
   y`, `x + i*y`) to isolate `M i j` in terms of the diagonal quadratic
   form values, and derive `M = Mᴴ` entrywise. Give the full Lean proof,
   not just a sketch, in Mathlib-idiomatic tactic style.
3. Fallback if 2 is too large for this call: return the three highest-
   leverage partial results in priority order - e.g., (a) the exact
   4-vector polarization identity stated as a standalone algebraic lemma
   over `Complex` first (no matrices), (b) the specialization to
   `Matrix.dotProduct`/`Matrix.mulVec`, (c) a fully worked hand-proof in
   prose precise enough for a human to transcribe if the Lean tactic
   proof itself stalls.
4. Falsity/sanity check: verify with a tiny concrete example (`n = 2` or
   `n = 3` over `Fin n`) that the claim is actually TRUE as stated (a
   real-valued-diagonal-quadratic-form matrix that is NOT Hermitian would
   refute it) - if you find any subtlety (for example needing `x` to
   range over a spanning/dense set, or an issue with the `Fintype`
   versus general Hilbert space setting), state it explicitly and give
   the corrected statement.
5. Given your answer to 1-4, assess: is
   `rpBlockMatrix_posSemidef_of_reflectionPositive` (the version
   specialized to the block-diagonal-in-`C` matrix built from `W`) a
   direct corollary of the general fact, or does the block-diagonal
   structure introduce any additional subtlety (for example, does
   `IsReflectionPositive`'s quantification over ALL `f : A -> C ->
   Complex` correctly correspond to quantification over ALL vectors of
   `I -> Complex` under the currying identification - check this
   translation carefully, it is exactly the kind of step where an index
   error could silently produce a false statement)?

## Output format

1. Verdict: Mathlib has this fact / needs a new proof / the claim is
   subtly false as stated (with the corrected version).
2. The exact Lean statement and file location if found in Mathlib.
3. A complete Lean-ready proof if not found (or the three-part fallback).
4. The sanity-check result from question 4.
5. The block-diagonal specialization assessment from question 5.
6. Recommended next step for the parent project: is this ready to drop
   into `TransferHilbert.lean` directly, or does it need one more design
   round first?

## Guardrails

Do not weaken the target statement to make it easier - if the exact
statement as given is false, say so explicitly with the counterexample
and give the corrected strongest true version, do not silently substitute
a weaker claim. Claim labels: this is pure Mathlib-adjacent linear
algebra, "finite identity" scope, nothing physics-related to conflate.
