import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount
import PhysicsSM.Draft.NullEdge.GateYM.OverlapDirac

/-!
# Tying the two T-leg strands: signed zero-crossing count = overlap Dirac index

This file **ties** the two attached strands of the T-leg argument:

* `FiniteNNZeroCount` — the *genuine* 1D Nielsen–Ninomiya no-go: the signed
  zero-crossing count `signedZeroCount f` of a real periodic lattice symbol
  `f : ZMod N → K` is `0` for **every** `f` (boundarylessness of the Brillouin
  torus).
* `OverlapDirac` — the finite matrix-grade overlap / Ginsparg–Wilson operator
  `overlapD γ₅ V = 1 + γ₅ V` with deformed chirality `γ̂₅ = γ₅ (1 - D) = -V`.

## The tie

The topological quantity that Nielsen–Ninomiya forces to `0` on the boundaryless
torus is *the same one* the overlap operator's index (the trace of its deformed
chirality `γ̂₅`) computes. Concretely, from a real 1D symbol `f` we build the
diagonal **sign operator** `V = signMat f = diag(sgn (f p))` on the momentum
space `Fin N ≃ ZMod N` (for a nowhere-zero `f` this is a genuine Hermitian
involution, i.e. an admissible overlap sign matrix, and its overlap operator
`overlapD 1 V` satisfies the Ginsparg–Wilson relation — `signMat_ginspargWilson`).

The **overlap index** at matrix grade is `overlapIndex g5 V = -½ Tr γ̂₅ = ½ Tr V`
(`overlapIndex_eq_half_trace`). Its value on `V` and on the lattice-shifted copy
`V' = signMat (f(·+1))` are *equal* because the two matrices are related by the
momentum shift and the trace is shift invariant (`trace_signMat_shift_eq`) — this
is exactly boundarylessness/periodicity in operator form.

### The precise finite identity (strong form)

`signedZeroCount_eq_gamma5Hat_trace_diff` :
```
(signedZeroCount f : ℂ)
   = Matrix.trace (gamma5Hat 1 (signMat f)) - Matrix.trace (gamma5Hat 1 (signMatShift f))
```
i.e. the signed zero-crossing count **is** the difference of the overlap
operator's deformed-chirality traces (its indices) between the symbol and its
lattice-shifted copy. Equivalently, in index language
(`signedZeroCount_eq_overlapIndex_diff`):
```
(signedZeroCount f : ℂ) = 2 * (overlapIndex 1 (signMatShift f) - overlapIndex 1 (signMat f)).
```

### The vanishing (the tie proper)

Both sides vanish for the *same* reason — shift invariance of the trace on the
boundaryless torus (`signedZeroCount_eq_zero_via_overlap`):
```
(signedZeroCount f : ℂ) = 0.
```
This re-derives the Nielsen–Ninomiya no-go operator-theoretically: the winding
`signedZeroCount` is an integer topological invariant, it equals a difference of
overlap indices, and it is `0` because the momentum shift leaves the overlap
index unchanged.

All proofs are `sorry`/`axiom`/`native_decide`-free; the axiom footprint is
reported by the `#print axioms` calls at the end.
-/

open Matrix
open PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount
open PhysicsSM.Draft.NullEdge.GateYM.OverlapDirac

namespace PhysicsSM.Draft.NullEdge.GateYM.NNIndexTie

variable {N : ℕ} [NeZero N] {K : Type*} [LinearOrder K] [Zero K]

/-! ## Momentum space as `Fin N`

The overlap operators of `OverlapDirac` are indexed by `Fin n`. We realise the
discrete Brillouin torus `ZMod N` on `Fin N` via the canonical equivalence
`zEquiv`. -/

/-- The canonical equivalence `Fin N ≃ ZMod N` (momentum labels ↔ Brillouin
torus). -/
noncomputable def zEquiv (N : ℕ) [NeZero N] : Fin N ≃ ZMod N :=
  (Fintype.equivFinOfCardEq (ZMod.card N)).symm

/-! ## The sign operator built from a real symbol -/

/-- The diagonal **sign operator** `V = diag(sgn (f p))` of a real 1D symbol
`f : ZMod N → K`, indexed by momentum `Fin N`. This is the honest 1D avatar of
the "sign of a Hermitian operator" `V = A|A|⁻¹` appearing in the overlap
construction. -/
noncomputable def signMat (f : ZMod N → K) : Matrix (Fin N) (Fin N) ℂ :=
  Matrix.diagonal (fun i => (sSeq f (zEquiv N i) : ℂ))

/-- The lattice-**shifted** sign operator `diag(sgn (f (p+1)))`: the sign operator
of the momentum-shifted symbol. -/
noncomputable def signMatShift (f : ZMod N → K) : Matrix (Fin N) (Fin N) ℂ :=
  Matrix.diagonal (fun i => (sSeq f (zEquiv N i + 1) : ℂ))

/-- Trace of the sign operator is the spectral asymmetry `∑ sgn (f p)`. -/
theorem trace_signMat (f : ZMod N → K) :
    Matrix.trace (signMat f) = ∑ p : ZMod N, (sSeq f p : ℂ) := by
  rw [signMat, Matrix.trace_diagonal]
  exact Equiv.sum_comp (zEquiv N) (fun p => (sSeq f p : ℂ))

/-- Trace of the shifted sign operator is `∑ sgn (f (p+1))`. -/
theorem trace_signMatShift (f : ZMod N → K) :
    Matrix.trace (signMatShift f) = ∑ p : ZMod N, (sSeq f (p + 1) : ℂ) := by
  rw [signMatShift, Matrix.trace_diagonal]
  exact Equiv.sum_comp (zEquiv N) (fun p => (sSeq f (p + 1) : ℂ))

/-- **Boundarylessness in operator form.** The sign operator and its lattice-shift
have equal trace: the momentum shift `p ↦ p+1` is a bijection of the boundaryless
torus, and the trace is invariant under it. This is the operator avatar of the
periodicity used in the Nielsen–Ninomiya telescoping. -/
theorem trace_signMat_shift_eq (f : ZMod N → K) :
    Matrix.trace (signMatShift f) = Matrix.trace (signMat f) := by
  rw [trace_signMat, trace_signMatShift]
  exact Equiv.sum_comp (Equiv.addRight (1 : ZMod N)) (fun p => (sSeq f p : ℂ))

/-- The signed zero-crossing count, cast to `ℂ`, is the difference of the two sign
traces. This is the elementary bridge between the crossing count and the operator
traces. -/
theorem signedZeroCount_cast (f : ZMod N → K) :
    (signedZeroCount f : ℂ)
      = Matrix.trace (signMatShift f) - Matrix.trace (signMat f) := by
  rw [trace_signMat, trace_signMatShift, signedZeroCount]
  push_cast [crossSign]
  rw [Finset.sum_sub_distrib]

/-! ## The overlap index and the tie -/

omit [NeZero N] in
/-- Trace of the overlap operator's deformed chirality `γ̂₅ = γ₅ (1 - D)` is
`-Tr V`, using `γ̂₅ = -V` (`gamma5Hat_eq_neg`). Only the involution property
`γ₅² = 1` is needed. -/
theorem trace_gamma5Hat (g5 V : Matrix (Fin N) (Fin N) ℂ) (hg : g5 * g5 = 1) :
    Matrix.trace (gamma5Hat g5 V) = - Matrix.trace V := by
  rw [gamma5Hat_eq_neg g5 V hg, Matrix.trace_neg]

/-- The **overlap (Ginsparg–Wilson) index** at matrix grade: `-½ Tr γ̂₅`. This is
the topological quantity the overlap operator computes. -/
noncomputable def overlapIndex (g5 V : Matrix (Fin N) (Fin N) ℂ) : ℂ :=
  - Matrix.trace (gamma5Hat g5 V) / 2

omit [NeZero N] in
/-- The overlap index equals `½ Tr V` (equivalently `-½ Tr γ̂₅`). -/
theorem overlapIndex_eq_half_trace (g5 V : Matrix (Fin N) (Fin N) ℂ)
    (hg : g5 * g5 = 1) : overlapIndex g5 V = Matrix.trace V / 2 := by
  rw [overlapIndex, trace_gamma5Hat g5 V hg]
  ring

/-- **The precise finite identity (strong form).** The signed zero-crossing count
of a real 1D symbol `f` is the difference of the overlap operator's
deformed-chirality traces (its indices) between the symbol and its lattice-shifted
copy. Here `γ₅ = 1` is the trivial involution; the identity holds for any `γ₅`
with `γ₅² = 1`. -/
theorem signedZeroCount_eq_gamma5Hat_trace_diff (f : ZMod N → K) :
    (signedZeroCount f : ℂ)
      = Matrix.trace (gamma5Hat (1 : Matrix (Fin N) (Fin N) ℂ) (signMat f))
        - Matrix.trace (gamma5Hat (1 : Matrix (Fin N) (Fin N) ℂ) (signMatShift f)) := by
  rw [trace_gamma5Hat _ _ (one_mul _), trace_gamma5Hat _ _ (one_mul _),
      signedZeroCount_cast]
  ring

/-- **The tie in index language.** The signed zero-crossing count is twice the
difference of overlap indices between the shifted and unshifted sign operators. -/
theorem signedZeroCount_eq_overlapIndex_diff (f : ZMod N → K) :
    (signedZeroCount f : ℂ)
      = 2 * (overlapIndex (1 : Matrix (Fin N) (Fin N) ℂ) (signMatShift f)
            - overlapIndex (1 : Matrix (Fin N) (Fin N) ℂ) (signMat f)) := by
  rw [overlapIndex_eq_half_trace _ _ (one_mul _),
      overlapIndex_eq_half_trace _ _ (one_mul _), signedZeroCount_cast]
  ring

/-- **The vanishing (Nielsen–Ninomiya, operator form).** The signed zero-crossing
count is `0` because the two overlap indices agree — the momentum shift leaves the
overlap index unchanged on the boundaryless torus (`trace_signMat_shift_eq`). This
re-derives `signedZeroCount_eq_zero` from the overlap side. -/
theorem signedZeroCount_eq_zero_via_overlap (f : ZMod N → K) :
    (signedZeroCount f : ℂ) = 0 := by
  rw [signedZeroCount_cast, trace_signMat_shift_eq, sub_self]

/-- Consistency: the complex identity descends to the integer statement of
`FiniteNNZeroCount.signedZeroCount_eq_zero`. -/
theorem signedZeroCount_eq_zero_int (f : ZMod N → K) : signedZeroCount f = 0 := by
  have h := signedZeroCount_eq_zero_via_overlap f
  exact_mod_cast h

/-! ## `signMat` is a genuine overlap sign operator (nowhere-zero symbol)

For a nowhere-zero symbol `f` the sign operator `V = signMat f` is a genuine
Hermitian involution, hence an admissible overlap sign matrix, and its overlap
Dirac operator satisfies the Ginsparg–Wilson relation. This confirms the tie uses
`signMat f` in exactly the role `V` plays in `OverlapDirac`. -/

/-- For a nowhere-zero symbol, the sign operator squares to the identity
(`V² = 1`): a genuine sign involution. -/
theorem signMat_involution {f : ZMod N → K} (hf : NowhereZero f) :
    signMat f * signMat f = 1 := by
  rw [signMat, Matrix.diagonal_mul_diagonal]
  rw [show (fun i => (sSeq f (zEquiv N i) : ℂ) * (sSeq f (zEquiv N i) : ℂ))
        = (fun _ => (1 : ℂ)) from ?_]
  · exact Matrix.diagonal_one
  · funext i
    rcases sSeq_eq_one_or_neg_one hf (zEquiv N i) with h | h <;>
      rw [h] <;> norm_num

/-- The sign operator is Hermitian (`Vᴴ = V`): its entries are real. -/
theorem signMat_hermitian (f : ZMod N → K) : (signMat f)ᴴ = signMat f := by
  rw [signMat, Matrix.diagonal_conjTranspose]
  congr 1
  funext i
  simp

/-- **The overlap operator of a real dispersion satisfies Ginsparg–Wilson.** For a
nowhere-zero symbol `f`, the overlap Dirac operator `overlapD 1 (signMat f)` built
from its sign operator satisfies the Ginsparg–Wilson relation
`γ₅ D + D γ₅ = D γ₅ D` (with `γ₅ = 1`). -/
theorem signMat_ginspargWilson {f : ZMod N → K} (hf : NowhereZero f) :
    (1 : Matrix (Fin N) (Fin N) ℂ) * overlapD 1 (signMat f)
        + overlapD 1 (signMat f) * 1
      = overlapD 1 (signMat f) * 1 * overlapD 1 (signMat f) :=
  ginspargWilson 1 (signMat f) (one_mul 1) (signMat_involution hf)

/-! ## Honest labels: integrality and parity

The signed zero-crossing count (the winding) is a genuine integer topological
invariant, and it equals `0`. -/

/-- The winding is an integer (trivially — it is defined in `ℤ`) and is `0`; the
overlap-index difference computing it is therefore also `0`. -/
theorem winding_isInteger_and_zero (f : ZMod N → K) :
    signedZeroCount f = 0 ∧
      (2 * (overlapIndex (1 : Matrix (Fin N) (Fin N) ℂ) (signMatShift f)
            - overlapIndex (1 : Matrix (Fin N) (Fin N) ℂ) (signMat f))) = 0 := by
  refine ⟨signedZeroCount_eq_zero_int f, ?_⟩
  rw [← signedZeroCount_eq_overlapIndex_diff, signedZeroCount_eq_zero_int]
  norm_num

/-! ## Concrete `N = 4` instances

The naive lattice dispersion `sin(2πp/4) = ![0,1,0,-1]` (with two zeros) and the
regularized nowhere-zero dispersion `![1,2,-1,-2]`, both from `FiniteNNZeroCount`. -/

/-- The overlap-index tie for the naive `sin` dispersion: its signed zero count
(the winding) equals the overlap-index difference, and both are `0`. -/
theorem tie_naiveSin4 :
    (signedZeroCount naiveSin4 : ℂ)
      = 2 * (overlapIndex (1 : Matrix (Fin 4) (Fin 4) ℂ) (signMatShift naiveSin4)
            - overlapIndex (1 : Matrix (Fin 4) (Fin 4) ℂ) (signMat naiveSin4)) :=
  signedZeroCount_eq_overlapIndex_diff naiveSin4

/-- The winding of the naive `sin` dispersion vanishes (via the overlap side). -/
theorem winding_naiveSin4_zero : signedZeroCount naiveSin4 = 0 :=
  signedZeroCount_eq_zero_int naiveSin4

/-- The regularized nowhere-zero dispersion gives a genuine overlap sign
involution `V² = 1`. -/
theorem signMat_involution_regDisp4 :
    signMat regDisp4 * signMat regDisp4 = 1 :=
  signMat_involution nowhereZero_regDisp4

/-- and its overlap Dirac operator satisfies Ginsparg–Wilson. -/
theorem ginspargWilson_regDisp4 :
    (1 : Matrix (Fin 4) (Fin 4) ℂ) * overlapD 1 (signMat regDisp4)
        + overlapD 1 (signMat regDisp4) * 1
      = overlapD 1 (signMat regDisp4) * 1 * overlapD 1 (signMat regDisp4) :=
  signMat_ginspargWilson nowhereZero_regDisp4

/-! ## Axiom footprint

Every theorem depends only on the standard `propext, Classical.choice, Quot.sound`
axioms (no `sorry`, no extra axioms, no `native_decide`). -/

#print axioms signedZeroCount_eq_gamma5Hat_trace_diff
#print axioms signedZeroCount_eq_overlapIndex_diff
#print axioms signedZeroCount_eq_zero_via_overlap
#print axioms signMat_ginspargWilson
#print axioms winding_isInteger_and_zero
#print axioms tie_naiveSin4

end PhysicsSM.Draft.NullEdge.GateYM.NNIndexTie
