import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup
import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# Draft.SpinorTenfoldBasisOrbitAristotle

Aristotle handoff: mode-flip action on basis spinors and **marked
transitivity** of the even Clifford group on the even wedge-monomial basis
- the normal-form core of Lemma S1 (orbit transitivity) of
`Sources/Spin10_stabilizer.txt`.

## Mathematical intent

The hyperbolic mode-flip unit `flipUnit i` (the Clifford operator of
`e_i + f_i`, `Q10 = 1`) toggles the occupation of mode `i` on a basis
spinor, with the fermionic sign `opSign i T`:

  `gammaEnd (flipVec i) (basisSpinor T) = opSign i T • basisSpinor (flipSet i T)`.

A *product of two* flips lies in `evenCliffordGroup` and toggles two modes,
staying inside one chirality. Since any two even subsets of `{0,...,4}` are
connected by toggling pairs of indices, the even Clifford group acts
transitively on even basis spinors up to a nonzero scalar - and using
`scalarUnit` (every nonzero scalar is in the group) the scalar can be fixed
to `1`: **marked** transitivity, not merely projective. The anchor
corollary carries the marked vacuum to the weak spinor - the two components
of the Krasnov-pair normal form whose common annihilator is the trusted
color axis.

## Proof guidance

- `cliffordAction_flipVec`: unfold `cliffordAction`; both index sums
  collapse at `j = i` (`flipVec` is an indicator pair;
  `Finset.sum_ite_eq'` or `Finset.sum_eq_single i`).
- `gammaEnd_flipVec_basisSpinor`: case on `i ∈ T`. For `i ∉ T`:
  `wedge_basisSpinor_of_not_mem` gives `opSign i (insert i T)` and
  `contract_basisSpinor_of_not_mem` kills the other half; then
  `belowCount i (insert i T) = belowCount i T` because
  `(insert i T).erase i = T` (`Finset.erase_insert`) and `belowCount`
  ignores `i` itself (`belowCount_erase`). For `i ∈ T`: dually with
  `contract_basisSpinor_of_mem` / `wedge_basisSpinor_of_mem` and
  `belowCount_erase`.
- `exists_evenCliffordGroup_smul_basisSpinor`: two workable routes.
  (a) Strong induction on `(symmDiff S T).card` (which is even, `0`, `2`,
  or `4`): if `S = T` take `g = 1`; otherwise pick `i ≠ j` in the symmetric
  difference and apply `flipUnit i * flipUnit j`
  (`flipUnit_mul_flipUnit_mem`, `flipUnit_mul_flipUnit_basisSpinor`), which
  reduces the symmetric difference by two; compose witnesses with `mul_mem`
  and track the accumulated nonzero scalar.
  (b) Concrete enumeration: show every even `S` reaches `basisSpinor ∅` by
  an explicit product of at most two double-flips (there are only 16 even
  subsets; each is `∅`, a pair, or a 4-set, handled by one or two
  double-flips with explicit indices), then route `S → ∅ → T` through the
  group operations (`mul_mem`, `inv_mem`) and invert the scalar.
  Route (a) is cleaner; route (b) is fully mechanical.
- The marked refinement and the vacuum-to-weak anchor are already derived
  below from the up-to-scalar statement via `scalarUnit`; only the three
  `sorry`s above them are open.

Do not change any definition or sign convention of
`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup` or the trusted Fock layer.
Helper lemmas are welcome (e.g. sign bookkeeping for double flips,
`flipSet` cardinality facts). Plain kernel `decide` on `Finset (Fin 5)`
bookkeeping is fine. No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and
**no `native_decide`** in the final state.

This is draft code: the statements below contain documented `sorry`s and
must not be imported from trusted code until the holes are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldBasisOrbit

open PhysicsSM.Spinor.SpinorTenfold

/-! ## Target 1: the Clifford action of a mode-flip vector -/

/-- The Clifford action of `flipVec i` is creation plus annihilation at the
single index `i`. -/
theorem cliffordAction_flipVec (i : Fin 5) (psi : FockSpinor) :
    cliffordAction (flipVec i) psi = wedge i psi + contract i psi := by
  sorry

/-! ## Target 2: mode flips toggle basis spinors with the fermionic sign -/

/-- A mode flip toggles the occupation of mode `i` on a wedge monomial,
with the uniform fermionic sign `opSign i T` (the sign does not depend on
whether `i` is being created or annihilated, because `belowCount` ignores
`i` itself). -/
theorem gammaEnd_flipVec_basisSpinor (i : Fin 5) (T : Finset (Fin 5)) :
    gammaEnd (flipVec i) (basisSpinor T)
      = opSign i T • basisSpinor (flipSet i T) := by
  sorry

/-- A double flip toggles two modes; multiplication in `Module.End` is
composition, so `flipUnit j` acts first. -/
theorem flipUnit_mul_flipUnit_basisSpinor (i j : Fin 5) (T : Finset (Fin 5)) :
    ((flipUnit i * flipUnit j : (Module.End ℂ FockSpinor)ˣ) :
        Module.End ℂ FockSpinor) (basisSpinor T)
      = (opSign j T * opSign i (flipSet j T))
          • basisSpinor (flipSet i (flipSet j T)) := by
  sorry

/-! ## Target 3: transitivity on even basis spinors, up to a scalar -/

/-- **Up-to-scalar orbit transitivity** on the even basis: for any two
even-cardinality subsets, some even-Clifford-group element carries
`basisSpinor S` to a nonzero multiple of `basisSpinor T`. -/
theorem exists_evenCliffordGroup_smul_basisSpinor (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    ∃ g ∈ evenCliffordGroup, ∃ c : ℂ, c ≠ 0 ∧
      (g : Module.End ℂ FockSpinor) (basisSpinor S) = c • basisSpinor T := by
  sorry

/-! ## Derived: marked transitivity (complete modulo the targets above) -/

/-- **Marked transitivity** on the even basis: the scalar can be fixed to
`1` using `scalarUnit`. This is the normal-form core of Lemma S1. -/
theorem exists_evenCliffordGroup_basisSpinor (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) (basisSpinor S) = basisSpinor T := by
  obtain ⟨g, hg, c, hc, hgc⟩ :=
    exists_evenCliffordGroup_smul_basisSpinor S T hS hT
  refine ⟨scalarUnit c⁻¹ (inv_ne_zero hc) * g,
    mul_mem (scalarUnit_mem _ _) hg, ?_⟩
  rw [Units.val_mul, Module.End.mul_apply, hgc, map_smul, scalarUnit_val]
  simp [smul_smul, mul_inv_cancel₀ hc]

/-- **Anchor**: some even-Clifford-group element carries the marked vacuum
exactly to the weak spinor - the two members of the witness Krasnov pair
whose common annihilator is the trusted color axis
(`PhysicsSM.Spinor.SpinorTenfoldColorAxis`). -/
theorem exists_evenCliffordGroup_vacuum_weak :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) vacuumSpinor = weakSpinor := by
  have h := exists_evenCliffordGroup_basisSpinor ∅ ({3, 4} : Finset (Fin 5))
    (by decide) (by decide)
  simpa [vacuumSpinor, weakSpinor] using h

end PhysicsSM.Draft.SpinorTenfoldBasisOrbit

end
