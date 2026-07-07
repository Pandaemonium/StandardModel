import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Draft.NullEdge.GateI1.Q12Triality

/-!
# Q04 octonion sign-gauge reconciliation

This file reconciles the two independent sign conventions used in the project
for XOR/Fano octonion structure constants:

* `PhysicsSM.Algebra.Octonion.lookupSign`, the hard-coded
  `Fin 8 × Fin 8 -> Z` table in `Basic.lean`;
* `PhysicsSM.Draft.NullEdge.GateI1.Q12Triality.octSgn`, computed from the
  cochain `octF` on `Idx := Fin 3 -> ZMod 2`.

The Q04 audit observed that these two functions disagree on `18/64` ordered
basis pairs.  They are nonetheless equivalent up to a diagonal basis sign gauge:
there is a map `eps : Fin 8 -> Z` valued in `{+1, -1}` with

```
lookupSign i j = eps i * eps j * eps (i xor j) * octSgn (toIdx i) (toIdx j).
```

Such an `eps` corresponds to rescaling each basis vector `e_i` by `eps i`,
which leaves the octonion algebra isomorphic.  The octonion convention itself is
not modified here.

Provenance: Aristotle project
`ne-q04-octsgn-lookupsign-diagonal-gauge-proof-20260707`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q04OctSgnGauge

open PhysicsSM.Algebra.Octonion (lookupSign)
open PhysicsSM.Draft.NullEdge.GateI1.Q12Triality (Idx octSgn)

/-- Index map from the `Fin 8` decimal labels used by `lookupSign` to the
`Idx = Fin 3 -> ZMod 2` labels used by `octSgn`.  Bit `k`, with weight `2^k`,
of the decimal index becomes coordinate `k`, matching the 3-bit XOR labelling of
both files (`e001 -> 1`, `e010 -> 2`, `e100 -> 4`). -/
def toIdx (i : Fin 8) : Idx := fun k => ((i.val >>> k.val : ℕ) : ZMod 2)

/-- XOR of two `Fin 8` labels, i.e. the index of the basis product
`e_i * e_j`. -/
def xorIdx (i j : Fin 8) : Fin 8 :=
  ⟨i.val ^^^ j.val, by
    have hi := i.isLt
    have hj := j.isLt
    exact Nat.xor_lt_two_pow (n := 3) hi hj⟩

/-- The diagonal sign-gauge witness.  It flips basis vectors `e010`, `e011`,
and `e100`, decimal indices `2`, `3`, and `4`. -/
def eps : Fin 8 → ℤ := ![1, 1, -1, -1, -1, 1, 1, 1]

/-- `eps` takes values in `{+1, -1}`. -/
theorem eps_sq (i : Fin 8) : eps i * eps i = 1 := by
  fin_cases i <;> decide

/-- **Sign-gauge reconciliation.**  The `Basic.lookupSign` table equals the
`Q12Triality.octSgn` structure constant up to the diagonal basis sign gauge
`eps`. -/
theorem gauge_reconciliation :
    ∀ i j : Fin 8,
      lookupSign i j
        = eps i * eps j * eps (xorIdx i j) * octSgn (toIdx i) (toIdx j) := by
  decide

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q04OctSgnGauge.gauge_reconciliation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gauge_reconciliation

end PhysicsSM.Draft.NullEdge.GateI1.Q04OctSgnGauge
