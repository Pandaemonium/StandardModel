import Mathlib
import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-!
# A non-hollow localized boundary-transport index: definition, ladder, and verdict

This module answers the strategy/construction request in `TASK.md`: design the
smallest mathematically correct boundary-transport invariant for the
open-boundary anomalous-Floquet 3+1 route, connect the bare reflecting shift to a
*zero* index, and honestly locate where a *nonzero* index must come from.

## The object we deliberately reject

The naive global finite trace `Tr(U⋆ P U − P)` (`P` a cut projector, `U` a finite
Floquet unitary) vanishes identically by cyclicity of the trace:
`Tr(U⋆ P U) = Tr(P U U⋆) = Tr(P)`.  The permutation-level shadow of this identity
is that a bijection of a finite set preserves the size of the complement of any
subset, so the number of orbits *entering* a region equals the number *leaving*
it.  We prove this shadow directly (`crossingsIn_eq_crossingsOut`,
`netFlow_eq_zero`); it is the exact reason a finite trace/flow index cannot be the
nonzero invariant.

## What we deliver

* `netFlow σ S` — the honest finite boundary-transport index: (orbits crossing
  into `S` in one period) − (orbits crossing out).  This is the correct *finite*
  object; it is proof-ready and Mathlib-only.
* `netFlow_eq_zero` — **the finite permutation no-go**: for *every* permutation
  of a finite state space and *every* cut, `netFlow = 0`. This subsumes the requested
  "bare reflecting shift ⟶ zero index" control as the special case
  `bareReflectingShift_netFlow_eq_zero`.
* Anti-vacuity + local-flow witnesses (`bareReflectingShift_ne_one`,
  `crossingsIn_pos`, `crossingsOut_pos`): the reflecting shift is a genuinely
  nontrivial permutation, and across a real cut it *does* have orbits crossing
  both ways — so the zero index is an exact cancellation of nonzero opposite
  currents, not an artifact of trivial dynamics.

## The verdict (see `BOUNDARY_TRANSPORT_INDEX_VERDICT.md` for the full write-up)

A **scoped no-go** for the finite index, plus a **sharply named missing-API**
requirement for the nonzero side:

1. Object choice: neither the global finite trace nor this finite permutation
   flow can be the
   nonzero invariant — both are `0` by `netFlow_eq_zero`.  The nonzero chiral
   boundary index must be the **half-space Fredholm / GNVW flow index** of the
   period map on an infinite (half-line) lattice.
2. That index requires infinite-volume operator API that Mathlib does not have.
   The exact missing declarations are listed in the verdict file and in the
   commented `BridgeLadder` section below.
3. Dimensional audit: a 1D finite reflecting orbit (`State N = Bool × Fin (N+1)`)
   is one transverse-momentum fiber of the 2D boundary of a 3D bulk, not the whole
   boundary; the full 2D boundary index is the sum of fiberwise 1D flows over the
   transverse torus `T²`.  Stated precisely below.

No new assumptions or trust-expanding finite evaluation.
-/

namespace PhysicsSM.Draft.NullEdge.BoundaryTransportIndex

open Finset
open PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-! ## The finite boundary-transport index -/

section FiniteIndex

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Orbits crossing **into** the region `S` in one application of `σ`: states
outside `S` whose image lands in `S`. -/
def crossingsIn (σ : Equiv.Perm V) (S : Finset V) : ℕ :=
  (univ.filter (fun x => x ∉ S ∧ σ x ∈ S)).card

/-- Orbits crossing **out of** the region `S`: states in `S` whose image leaves. -/
def crossingsOut (σ : Equiv.Perm V) (S : Finset V) : ℕ :=
  (univ.filter (fun x => x ∈ S ∧ σ x ∉ S)).card

/-- The finite net boundary-transport index across the cut `S` over one period. -/
def netFlow (σ : Equiv.Perm V) (S : Finset V) : ℤ :=
  (crossingsIn σ S : ℤ) - (crossingsOut σ S : ℤ)

/-- **Conservation / cyclicity shadow.** A bijection of a finite set moves as many
orbits into any region as out of it. This is the finite reason the naive
`Tr(U⋆ P U − P)` invariant is hollow. -/
theorem crossingsIn_eq_crossingsOut (σ : Equiv.Perm V) (S : Finset V) :
    crossingsIn σ S = crossingsOut σ S := by
  unfold crossingsIn crossingsOut
  have hpre : (univ.filter (fun x => σ x ∈ S)).card = S.card := by
    rw [← Finset.card_image_of_injective (univ.filter (fun x => σ x ∈ S)) σ.injective]
    congr 1
    ext y
    simp only [mem_image, mem_filter, mem_univ, true_and]
    constructor
    · rintro ⟨x, hx, rfl⟩; exact hx
    · intro hy; exact ⟨σ.symm y, by simp [hy], by simp⟩
  have hS : (univ.filter (fun x => x ∈ S)).card = S.card := by
    rw [Finset.filter_mem_eq_inter]; simp
  have h1 : (univ.filter (fun x => σ x ∈ S)).card
      = (univ.filter (fun x => σ x ∈ S ∧ x ∈ S)).card
        + (univ.filter (fun x => σ x ∈ S ∧ x ∉ S)).card := by
    rw [← Finset.filter_filter, ← Finset.filter_filter]
    rw [Finset.card_filter_add_card_filter_not]
  have h2 : (univ.filter (fun x => x ∈ S)).card
      = (univ.filter (fun x => x ∈ S ∧ σ x ∈ S)).card
        + (univ.filter (fun x => x ∈ S ∧ σ x ∉ S)).card := by
    rw [← Finset.filter_filter, ← Finset.filter_filter]
    rw [Finset.card_filter_add_card_filter_not]
  have e1 : (univ.filter (fun x => σ x ∈ S ∧ x ∈ S)).card
      = (univ.filter (fun x => x ∈ S ∧ σ x ∈ S)).card := by
    congr 1; ext x; simp [and_comm]
  have e2 : (univ.filter (fun x => σ x ∈ S ∧ x ∉ S)).card
      = (univ.filter (fun x => x ∉ S ∧ σ x ∈ S)).card := by
    congr 1; ext x; simp [and_comm]
  omega

/-- **The finite permutation no-go.** Every permutation of a finite state space
has zero net boundary transport across every cut. This theorem does not identify
an arbitrary finite-dimensional quantum unitary with a permutation. -/
theorem netFlow_eq_zero (σ : Equiv.Perm V) (S : Finset V) : netFlow σ S = 0 := by
  unfold netFlow
  rw [crossingsIn_eq_crossingsOut]
  ring

end FiniteIndex

/-! ## Bare reflecting shift: the transport-zero control -/

/-- **Control (bare ⟶ 0).** The bare open-boundary reflecting shift has zero net
chiral transport across every cut. This is the required transport-zero anchor. -/
theorem bareReflectingShift_netFlow_eq_zero (N : Nat) (S : Finset (State N)) :
    netFlow (stepEquiv N) S = 0 :=
  netFlow_eq_zero (stepEquiv N) S

/-! ## Anti-vacuity and local-flow witnesses

The zero index above must not be vacuous: it is a genuine cancellation of nonzero
opposite currents, and the reflecting shift is a genuinely nontrivial permutation.
-/

/-- The reflecting shift is a nontrivial permutation whenever there is interior
room (`N ≥ 1`): the left endpoint right-mover actually advances. -/
theorem bareReflectingShift_ne_one {N : Nat} (hN : 1 ≤ N) : stepEquiv N ≠ 1 := by
  intro h
  have hx : (stepEquiv N) (true, ⟨0, by omega⟩) = (true, ⟨0, by omega⟩) := by
    rw [h]; rfl
  have hstep : (stepEquiv N) (true, (⟨0, by omega⟩ : Fin (N + 1)))
      = (true, ⟨0 + 1, by omega⟩) :=
    step_right_interior (N := N) ⟨0, by omega⟩ (by simpa using hN)
  rw [hstep] at hx
  simp only [Prod.mk.injEq, Fin.mk.injEq] at hx
  omega

/-- The "right region": all states strictly to the right of the left endpoint. -/
def cutRight (N : Nat) : Finset (State N) :=
  univ.filter (fun s => 1 ≤ s.2.val)

/-- **Local-flow witness (into the region).** For `N ≥ 1` the left-endpoint
right-mover `(true, 0)` genuinely crosses *into* the right region, so the inbound
current is nonzero. -/
theorem crossingsIn_pos {N : Nat} (hN : 1 ≤ N) :
    0 < crossingsIn (stepEquiv N) (cutRight N) := by
  apply Finset.card_pos.mpr
  refine ⟨(true, ⟨0, by omega⟩), ?_⟩
  simp only [mem_filter, mem_univ, true_and, cutRight]
  have hstep : (stepEquiv N) (true, (⟨0, by omega⟩ : Fin (N + 1)))
      = (true, ⟨0 + 1, by omega⟩) :=
    step_right_interior (N := N) ⟨0, by omega⟩ (by simpa using hN)
  exact ⟨by simp, by rw [hstep]⟩

/-- **Local-flow witness (out of the region).** For `N ≥ 1` the left-mover at
site `1`, `(false, 1)`, genuinely crosses *out of* the right region, so the
outbound current is nonzero. Together with `crossingsIn_pos` this shows the zero
index of `bareReflectingShift_netFlow_eq_zero` is an exact cancellation of two
nonzero opposite currents. -/
theorem crossingsOut_pos {N : Nat} (hN : 1 ≤ N) :
    0 < crossingsOut (stepEquiv N) (cutRight N) := by
  apply Finset.card_pos.mpr
  refine ⟨(false, ⟨1, by omega⟩), ?_⟩
  simp only [mem_filter, mem_univ, true_and, cutRight]
  have hstep : (stepEquiv N) (false, (⟨1, by omega⟩ : Fin (N + 1)))
      = (false, ⟨1 - 1, by omega⟩) :=
    step_left_interior (N := N) ⟨1, by omega⟩ (by simp)
  exact ⟨by simp, by simp [hstep]⟩

/-! ## Dimensional correction: 1D fiber vs. 2D boundary of a 3D bulk

`State N = Bool × Fin (N+1)` is a `1+1`-dimensional edge with a `0`-dimensional
cut. Its transport invariant `netFlow` is a single integer: a `1D` GNVW flow.

The physical target is the `2`-dimensional spatial boundary of a `3`-dimensional
Floquet bulk. A chiral surface state there is a `2D` object whose transport
invariant is a *momentum-resolved family* of `1D` flows, one per transverse
quasimomentum `k ∈ T²`. Hence a single 1D finite reflecting orbit **cannot** model
the full 2D boundary; it models one transverse-momentum fiber. The correct
boundary index is

    boundaryIndex(U) = ∑_{k ∈ T²} netFlow_∞(U(k))            (⋆)

a sum/integral of fiberwise *infinite-volume* flows over the transverse torus.
`netFlow` here is the honest finite proxy for a single fiber's flow, and `(⋆)` is
the dimensional correction.  See `BOUNDARY_TRANSPORT_INDEX_VERDICT.md`.
-/

/-! ## `BridgeLadder`: the smallest missing-API theorem for the nonzero rung

`netFlow_eq_zero` proves the nonzero rung is **unreachable by this finite
permutation index**. A nonzero anomalous witness therefore requires a
infinite/half-space construction, whose defining API is absent from Mathlib
(confirmed: only TODO comments mention Fredholm operators; no GNVW/QCA theory).

The smallest bridge theorem, stated in prose because its API is absent:

  Let `H = lp (fun _ : ℕ => ℂ) 2` be the half-line Hilbert space, `U : H →L[ℂ] H`
  a unitary that is *finite-range* (there is `R` with `⟪δ_i, U δ_j⟫ = 0` for
  `|i−j| > R`), and `P : H →L[ℂ] H` the orthogonal projection onto `span {δ_i}`.
  Then `P.comp (U.comp P)` restricted to `range P` is Fredholm, and

      boundaryFlowIndex U := Fredholm.index (P U P |_ range P)  ∈ ℤ

  is a well-defined chiral transport index with:
    * `boundaryFlowIndex U = 0` when `U` preserves `range P` (reflecting bulk), and
    * `boundaryFlowIndex (rightShift) = -1` (or `+1` for the left shift),
  and it agrees with the GNVW flow of the two-sided extension.

The exact missing Mathlib declarations required to state and prove this bridge:

  * `Fredholm` predicate on `E →L[𝕜] F` (finite-dim kernel and cokernel,
    closed range) — Mathlib has none (only a TODO in
    `Mathlib/Analysis/Normed/Operator/Banach.lean`).
  * `Fredholm.index : (E →L[𝕜] F) → ℤ` and its stability/composition lemmas
    (`Fredholm.index_add_compact`, `Fredholm.index_comp`).
  * The essential-codimension / GNVW flow index for locality-preserving unitaries
    on `lp (fun _ : ℤ => V) 2`, i.e. a Kitaev/GNVW `flowIndex` with
    `flowIndex_shift`, `flowIndex_mul`, `flowIndex_locality_invariance`.
  * `analyticIndex = -essentialCodim` compatibility linking `P U P` to `flowIndex`.

Until those land, the nonzero rung is a *scoped no-go at the finite level* with a
*named missing hypothesis*: the infinite-volume Fredholm/GNVW flow index.
-/

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.BoundaryTransportIndex.netFlow_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms netFlow_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.BoundaryTransportIndex.crossingsIn_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossingsIn_pos

end PhysicsSM.Draft.NullEdge.BoundaryTransportIndex
