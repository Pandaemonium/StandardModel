import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount
import PhysicsSM.Draft.NullEdge.GateYM.OverlapIndex

/-!
# Exact crossing-count ↔ overlap-index identity

This file connects the two attached developments at **finite grade**:

* `FiniteNNZeroCount.lean` — the genuine signed zero-crossing count
  `signedZeroCount f = ∑_p (sgn f(p+1) − sgn f p)` of a real 1D lattice symbol
  `f : ZMod N → K`, together with `signedZeroCount_eq_zero` and the evenness of
  the unsigned crossing count.
* `OverlapIndex.lean` — the finite matrix-grade overlap / Ginsparg–Wilson index
  `indexTr G D = ½ Tr(G D)` (the physical `½ Tr(γ₅ D)` expression).

## What is proved

Given a real symbol `f : ZMod N → K`, form its **sign operator**: the diagonal
complex `N × N` matrix `signOp f` whose entries are the honest signs
`sgn(f p) ∈ {−1,0,1}` (transported through a fixed `Fin N ≃ ZMod N`). Then:

* `signOp_isHermitian` : `signOp f` is Hermitian (its diagonal is real), and
  `signOp_involution` : it is an involution exactly when `f` is nowhere zero — so
  `(1, signOp f)` is a legitimate `(γ₅, chirality)` pair in the overlap framework.
* `trace_signOp` : `Tr (signOp f) = ∑_p sgn(f p)`.
* **`signedZeroCount_eq_two_indexTr_diff`** (the exact identity): with `γ₅ = 1`,
  $$ \mathrm{signedZeroCount}\ f \;=\; 2\bigl(\mathrm{indexTr}\,1\,(\mathrm{signOp}\,(\text{shift}\,f)) - \mathrm{indexTr}\,1\,(\mathrm{signOp}\,f)\bigr). $$
  The signed crossing count of `f` **equals** twice the difference of the overlap
  (half-trace) indices of the shifted and unshifted sign operators. This is an
  exact equality in `ℂ`, strengthening the informal "trace-difference" reading of
  `OverlapIndex.lean` to a precise crossing-count ↔ index statement.
* **`signedZeroCount_eq_zero_via_index`** / **`indexTr_diff_eq_zero`** : both sides
  are `0` by the periodicity (boundarylessness) of the loop `ZMod N` — the finite
  Nielsen–Ninomiya balance, now read off the index side.
* `numCrossings_even` / `single_crossing_impossible` : re-exported for nowhere-zero
  symbols — the unsigned crossing count is even, so a lone Weyl node is impossible.

## Honest scope

The identity `signedZeroCount_eq_two_indexTr_diff` is a **pure trace / telescoping
identity**: it holds for every `f` and uses only `Tr(1·M) = Tr(M)` and the
reindexing bijection `p ↦ p+1` on `ZMod N`. It does **not** invoke the
Ginsparg–Wilson relation (the sign operator does not satisfy GW with `γ₅ = 1`);
GW is what makes `OverlapIndex.indexTr` *integer-valued*, and is orthogonal to the
crossing-count bookkeeping proved here. All labels below are chosen to reflect
this exactly. No `sorry`, no `axiom`, no `native_decide`; the axiom footprint is
reported at the end.
-/

open Matrix
open PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount
open PhysicsSM.Draft.NullEdge.GateYM.OverlapIndex

namespace PhysicsSM.Draft.NullEdge.GateYM.NNIndexExact

variable {N : ℕ} [NeZero N] {K : Type*} [LinearOrder K] [Zero K]

/-- A fixed bijection `Fin N ≃ ZMod N` (any bijection works; the trace formulas
below are independent of the choice). It lets us view a symbol indexed by the
discrete Brillouin torus `ZMod N` as a matrix indexed by `Fin N`, so the
`OverlapIndex` machinery (stated for `Matrix (Fin n) (Fin n) ℂ`) applies. -/
noncomputable def toFin (N : ℕ) [NeZero N] : Fin N ≃ ZMod N :=
  (finCongr (ZMod.card N).symm).trans (Fintype.equivFin (ZMod N)).symm

/-- The **sign operator** of a real symbol `f`: the diagonal complex `N × N`
matrix with entries the honest signs `sgn(f p) ∈ {−1,0,1}`. This is the finite
"sign of the dispersion" whose overlap index we compare across a shift. -/
noncomputable def signOp (f : ZMod N → K) : Matrix (Fin N) (Fin N) ℂ :=
  Matrix.diagonal (fun i => ((sSeq f (toFin N i) : ℤ) : ℂ))

/-- The one-step lattice shift of a symbol, `(shift f) p = f (p+1)`. -/
def shift (f : ZMod N → K) : ZMod N → K := fun p => f (p + 1)

omit [NeZero N] in
@[simp] theorem sSeq_shift (f : ZMod N → K) (p : ZMod N) :
    sSeq (shift f) p = sSeq f (p + 1) := rfl

/-- The sign operator is Hermitian: it is diagonal with real (integer) entries. -/
theorem signOp_isHermitian (f : ZMod N → K) : (signOp f).IsHermitian := by
  unfold signOp
  apply Matrix.isHermitian_diagonal_iff.2
  intro i
  exact (Complex.im_eq_zero_iff_isSelfAdjoint _).mp rfl

/-- If `f` is nowhere zero then every sign is `±1`, so its sign operator is an
involution: `signOp f * signOp f = 1`. Hence `(γ₅ = 1, signOp f)` is a genuine
Hermitian-involution pair in the overlap / Ginsparg–Wilson framework. -/
theorem signOp_involution {f : ZMod N → K} (hf : NowhereZero f) :
    signOp f * signOp f = 1 := by
  unfold signOp
  rw [Matrix.diagonal_mul_diagonal]
  rw [← Matrix.diagonal_one]
  apply congrArg
  funext i
  rcases sSeq_eq_one_or_neg_one hf (toFin N i) with h | h <;>
    simp [h]

/-- **The trace of the sign operator is the total sign** `∑_p sgn(f p)`. -/
theorem trace_signOp (f : ZMod N → K) :
    (signOp f).trace = ((∑ p, sSeq f p : ℤ) : ℂ) := by
  unfold signOp
  rw [Matrix.trace_diagonal]
  push_cast
  exact Equiv.sum_comp (toFin N) (fun p => ((sSeq f p : ℤ) : ℂ))

/-- **The exact crossing-count ↔ overlap-index identity.**

For every real symbol `f`, the signed zero-crossing count equals *twice* the
difference of the overlap (half-trace) indices of the shifted and unshifted sign
operators, taken with trivial chirality `γ₅ = 1`:

`signedZeroCount f = 2 (indexTr 1 (signOp (shift f)) − indexTr 1 (signOp f))`.

Since `indexTr 1 M = ½ Tr M`, the right-hand side is `Tr(signOp(shift f)) −
Tr(signOp f) = ∑_p sgn f(p+1) − ∑_p sgn f p`, which is exactly the telescoped
signed crossing count. This is a pure trace identity (no Ginsparg–Wilson relation
is used). -/
theorem signedZeroCount_eq_two_indexTr_diff (f : ZMod N → K) :
    ((signedZeroCount f : ℤ) : ℂ) =
      2 * (indexTr (1 : Matrix (Fin N) (Fin N) ℂ) (signOp (shift f))
            - indexTr (1 : Matrix (Fin N) (Fin N) ℂ) (signOp f)) := by
  unfold indexTr signedZeroCount crossSign
  rw [Matrix.one_mul, Matrix.one_mul, trace_signOp, trace_signOp]
  simp only [sSeq_shift]
  push_cast
  rw [Finset.sum_sub_distrib]
  ring

/-- **The overlap-index difference vanishes.** Both sides of the exact identity are
`0`: the difference of the shifted/unshifted sign-operator indices is zero because
the loop `ZMod N` is boundaryless. This is the finite Nielsen–Ninomiya balance read
off the index side. -/
theorem indexTr_diff_eq_zero (f : ZMod N → K) :
    indexTr (1 : Matrix (Fin N) (Fin N) ℂ) (signOp (shift f))
      - indexTr (1 : Matrix (Fin N) (Fin N) ℂ) (signOp f) = 0 := by
  have h := signedZeroCount_eq_two_indexTr_diff f
  rw [signedZeroCount_eq_zero] at h
  push_cast at h
  rcases mul_eq_zero.mp h.symm with h2 | h2
  · norm_num at h2
  · exact h2

/-- **The signed crossing count is zero, via the index side.** Combining the exact
identity with `indexTr_diff_eq_zero` reproduces `signedZeroCount f = 0` — the
genuine 1D no-go, now derived through the overlap index. -/
theorem signedZeroCount_eq_zero_via_index (f : ZMod N → K) :
    ((signedZeroCount f : ℤ) : ℂ) = 0 := by
  rw [signedZeroCount_eq_two_indexTr_diff f, indexTr_diff_eq_zero f, mul_zero]

/-! ## Unsigned crossing count is even (re-exported)

A lone Weyl node is impossible: for a nowhere-zero symbol the unsigned crossing
count is even, so it cannot equal `1`. These re-export the genuine statements from
`FiniteNNZeroCount.lean`. -/

/-- The unsigned number of sign crossings of a nowhere-zero symbol is **even**. -/
theorem numCrossings_even {f : ZMod N → K} (hf : NowhereZero f) :
    Even (numCrossings f) :=
  PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount.numCrossings_even hf

/-- **A lone Weyl node is impossible**: the crossing count is never exactly `1`. -/
theorem single_crossing_impossible {f : ZMod N → K} (hf : NowhereZero f) :
    numCrossings f ≠ 1 :=
  PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount.single_crossing_impossible hf

/-! ## Concrete instances on `ZMod 4`

`regDisp4 = ![1, 2, -1, -2]` is a nowhere-zero (regularized) dispersion. -/

/-- The exact identity, instantiated on the concrete nowhere-zero dispersion. -/
theorem signedZeroCount_eq_two_indexTr_diff_regDisp4 :
    ((signedZeroCount regDisp4 : ℤ) : ℂ) =
      2 * (indexTr (1 : Matrix (Fin 4) (Fin 4) ℂ) (signOp (shift regDisp4))
            - indexTr (1 : Matrix (Fin 4) (Fin 4) ℂ) (signOp regDisp4)) :=
  signedZeroCount_eq_two_indexTr_diff regDisp4

/-- The sign operator of the concrete example is an involution. -/
theorem signOp_involution_regDisp4 : signOp regDisp4 * signOp regDisp4 = 1 :=
  signOp_involution nowhereZero_regDisp4

/-! ## Axiom footprint

Every result below depends only on the standard `propext, Classical.choice,
Quot.sound` axioms (no `sorry`, no extra `axiom`, no `native_decide`). Uncomment to
inspect. -/

-- #print axioms signedZeroCount_eq_two_indexTr_diff
-- #print axioms indexTr_diff_eq_zero
-- #print axioms signedZeroCount_eq_zero_via_index
-- #print axioms trace_signOp
-- #print axioms signOp_isHermitian
-- #print axioms signOp_involution
-- #print axioms numCrossings_even
-- #print axioms single_crossing_impossible

end PhysicsSM.Draft.NullEdge.GateYM.NNIndexExact
