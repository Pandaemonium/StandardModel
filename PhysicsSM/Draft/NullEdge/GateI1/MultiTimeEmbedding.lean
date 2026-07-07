import Mathlib

/-!
# Q10 multi-time embedding obstruction

This module discharges the next formalization step in the Q10
signature-selection audit: it lifts the fixed `(2,2)` frustrated null triple of
`SignatureSelection.lean` into an arbitrary diagonal quadratic space whose
signature contains at least two positive and two negative directions.

The model is coordinate-level and finite: a signature is a sign vector
`s : Fin n -> R` with entries witnessed as `+1,+1,-1,-1` on four distinct
coordinates, and the bilinear form is

`sigDot s x y = sum_k s k * (x k * y k)`.

Main statements:

* `sigDot_coord4`: placing the split `(2,2)` witness values on the four chosen
  coordinates reproduces the split bilinear form exactly.
* `multitime_frustrated_triple`: any such multi-time signature contains three
  null vectors with pairings `(+,+,-)`.
* `multitime_no_retarded_coloring`: consequently no two-color
  retarded/advanced sign assignment can satisfy the three pair constraints.

Claim boundary: this is a finite diagonal-signature obstruction.  It proves that
stable order rejects multi-time signatures once the diagonal `+,+,-,-` witness
is available.  It does not prove a general Sylvester-inertia reduction, and it
does not select dimension; dimension remains a separate chirality/scalar-amplitude
reconstruction problem.

Provenance: `AgentTasks/fable_parallel/Q10_answer.md`; Aristotle project
`825853b9`, task `f5f1c0dd`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding

open scoped BigOperators

variable {n : ℕ}

/-- The diagonal bilinear form attached to a sign vector. -/
def sigDot (s x y : Fin n -> ℝ) : ℝ :=
  ∑ k, s k * (x k * y k)

/-- The associated quadratic form. -/
def sigQ (s x : Fin n -> ℝ) : ℝ :=
  sigDot s x x

/-- Place four scalar values on four coordinates, zero elsewhere. -/
def coord4 (i0 i1 j0 j1 : Fin n) (v0 v1 v2 v3 : ℝ) : Fin n -> ℝ :=
  fun k =>
    if k = i0 then v0 else
      if k = i1 then v1 else
        if k = j0 then v2 else
          if k = j1 then v3 else 0

/--
Embedding workhorse.  If `i0, i1, j0, j1` are pairwise distinct with signature
`+,+,-,-`, then the diagonal form applied to two `coord4` vectors reproduces the
split `(2,2)` bilinear form.
-/
theorem sigDot_coord4 (s : Fin n -> ℝ)
    (i0 i1 j0 j1 : Fin n)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hs0 : s i0 = 1) (hs1 : s i1 = 1) (hs2 : s j0 = -1) (hs3 : s j1 = -1)
    (a0 a1 a2 a3 b0 b1 b2 b3 : ℝ) :
    sigDot s (coord4 i0 i1 j0 j1 a0 a1 a2 a3)
      (coord4 i0 i1 j0 j1 b0 b1 b2 b3) =
        a0 * b0 + a1 * b1 - a2 * b2 - a3 * b3 := by
  unfold coord4
  unfold sigDot
  simp +decide [*, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq']
  ring_nf
  grind

/--
Any signature with two positive and two negative diagonal directions, witnessed
by four distinct indices, carries a frustrated null triple.
-/
theorem multitime_frustrated_triple (s : Fin n -> ℝ)
    (i0 i1 j0 j1 : Fin n)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hs0 : s i0 = 1) (hs1 : s i1 = 1) (hs2 : s j0 = -1) (hs3 : s j1 = -1) :
    ∃ a b c : Fin n -> ℝ,
      sigQ s a = 0 ∧ sigQ s b = 0 ∧ sigQ s c = 0 ∧
      0 < sigDot s a b ∧ 0 < sigDot s b c ∧ sigDot s a c < 0 := by
  refine ⟨coord4 i0 i1 j0 j1 1 0 1 0,
    coord4 i0 i1 j0 j1 3 4 0 5,
    coord4 i0 i1 j0 j1 0 1 1 0, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp only [sigQ,
      sigDot_coord4 s i0 i1 j0 j1 h01 h02 h03 h12 h13 h23 hs0 hs1 hs2 hs3] <;>
    norm_num

/--
Sign-consistency for a two-coloring: same colors require nonnegative pairing,
and different colors require nonpositive pairing.
-/
def signColorOK (ca cb : Bool) (pairing : ℝ) : Prop :=
  if ca = cb then 0 ≤ pairing else pairing ≤ 0

/--
The three constraints of the frustrated triple cannot be met by any
two-coloring in a multi-time signature.
-/
theorem multitime_no_retarded_coloring (s : Fin n -> ℝ)
    (i0 i1 j0 j1 : Fin n)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hs0 : s i0 = 1) (hs1 : s i1 = 1) (hs2 : s j0 = -1) (hs3 : s j1 = -1) :
    ∃ a b c : Fin n -> ℝ,
      sigQ s a = 0 ∧ sigQ s b = 0 ∧ sigQ s c = 0 ∧
      ∀ ca cb cc : Bool,
        ¬ (signColorOK ca cb (sigDot s a b) ∧
           signColorOK cb cc (sigDot s b c) ∧
           signColorOK ca cc (sigDot s a c)) := by
  obtain ⟨a, b, c, ha, hb, hc, hab, hbc, hac⟩ :=
    multitime_frustrated_triple s i0 i1 j0 j1 h01 h02 h03 h12 h13 h23
      hs0 hs1 hs2 hs3
  refine ⟨a, b, c, ha, hb, hc, ?_⟩
  rintro ca cb cc ⟨habOK, hbcOK, hacOK⟩
  have e1 : ca = cb := by
    by_contra hne
    have : sigDot s a b ≤ 0 := by
      simpa [signColorOK, hne] using habOK
    linarith
  have e2 : cb = cc := by
    by_contra hne
    have : sigDot s b c ≤ 0 := by
      simpa [signColorOK, hne] using hbcOK
    linarith
  have e3 : ca = cc := e1.trans e2
  have : 0 ≤ sigDot s a c := by
    simpa [signColorOK, e3] using hacOK
  linarith

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding.sigDot_coord4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sigDot_coord4

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding.multitime_frustrated_triple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multitime_frustrated_triple

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding.multitime_no_retarded_coloring' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multitime_no_retarded_coloring

end PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding
