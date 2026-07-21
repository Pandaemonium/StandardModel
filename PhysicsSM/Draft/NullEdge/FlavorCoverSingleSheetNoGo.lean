import PhysicsSM.Draft.NullEdge.CliffordCoverDecoder

/-!
# Bare single-sheet projection is not invariant under flavor-cover translation

The `Z2^3` flavor cover used to reorganize the eight `3+1` lattice aliases has
spatial translations that flip flavor bits.  This module proves the resulting
minimal obstruction: projection onto any one fixed bare flavor sheet fails to
commute with every flavor-axis deck flip.

The theorem is intentionally scoped.  It rules out selecting one flavor by a
static bare-sheet projector while retaining the published deck translations.
It does not rule out a spacetime-parity-correlated code subspace, a
cocycle-twisted decoder, an interaction-selected superselection sector, or a
different Floquet architecture.  Each such escape owes its own intertwining
and full-spectrum theorem.

Provenance: clean-room finite consequence of the flavor-shift architecture in
Bakircioglu, Arnault, and Arrighi, "Fermion Doubling in Quantum Cellular
Automata," arXiv:2505.07900v3, especially Sections 4.2 and 6.2.  It reuses the
repository's exact `Z2^3` deck action from `CliffordCoverDecoder.lean`.
Claim grade `M`, `[comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FlavorCoverSingleSheetNoGo

open PhysicsSM.Draft.NullEdge.CliffordCoverDecoder

/-- Delta state supported on one bare flavor sheet. -/
def basisState (f : Flavor) : State :=
  fun x => if x = f then 1 else 0

/-- Pointwise projection onto one bare flavor sheet. -/
def sheetProjector (f : Flavor) (psi : State) : State :=
  fun x => if x = f then psi x else 0

/-- A flavor-axis generator is nonzero. -/
theorem singleton_ne_zero (j : Fin 3) :
    PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j ≠ 0 := by
  intro h
  have hj := congrFun h j
  simp [PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton] at hj

/-- Flipping one flavor bit always leaves the original bare sheet. -/
theorem add_singleton_ne (f : Flavor) (j : Fin 3) :
    f + PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j ≠ f := by
  intro h
  have h' : f + PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j =
      f + 0 := by simpa using h
  exact singleton_ne_zero j (add_left_cancel h')

/-- Two flips of the same flavor bit return to the starting sheet. -/
theorem add_singleton_add_singleton (f : Flavor) (j : Fin 3) :
    f + PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j +
      PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j = f := by
  rw [add_assoc, CliffordCoverDecoder.singleton_add_self, add_zero]

/-- A fixed bare-sheet projector does not commute with a flavor-axis deck
translation.  The proof separates the two compositions on the explicit delta
state supported at `f`, evaluated at the shifted sheet. -/
theorem sheetProjector_not_deckInvariant (f : Flavor) (j : Fin 3) :
    (fun psi => sheetProjector f (deckFlip j psi)) ≠
      (fun psi => deckFlip j (sheetProjector f psi)) := by
  intro h
  have hv := congrFun (congrFun h (basisState f))
    (f + PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.singleton j)
  rw [sheetProjector, if_neg (add_singleton_ne f j), deckFlip,
    sheetProjector, add_singleton_add_singleton, if_pos rfl,
    basisState, if_pos rfl] at hv
  norm_num at hv

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverSingleSheetNoGo.singleton_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms singleton_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverSingleSheetNoGo.sheetProjector_not_deckInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sheetProjector_not_deckInvariant

end PhysicsSM.Draft.NullEdge.FlavorCoverSingleSheetNoGo
