import Mathlib

/-!
# Gate YM1: torus even-cover combinatorics, first core

This draft module starts PKG-YM1-B from the overnight YM run
(`AgentTasks/overnight-ym-run-2026-07-03/`), following the statement freeze
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`, section 4.

The target theorem 2' for the Z2 two-dimensional torus reduces the surviving
plaquette monomials to plaquette subsets whose boundary is zero. On a connected
dual torus this means the indicator is locally constant, hence the subset is
either empty or all plaquettes. This file proves the first kernel-checked
finite-combinatorics core of that reduction: local constancy along the two
coordinate directions on a finite rectangular grid forces a subset of
plaquettes to be empty or universal.

Convention/provenance notes:
* This is the combinatorial core behind the oracle-pinned Z2 torus formula
  (oracle v0.2, section [1], 36/36 checks in the overnight preflight).
* The theorem is stated after the even-incidence condition has already been
  converted into adjacent-equality conditions on plaquette membership. The
  boundary/cosh-expansion bookkeeping belongs in the next T2 module layer.

The file also closes the last item its own `ratio_sameBoundary_zeroBoundary_
weights` docstring flagged as remaining: identifying a rectangular loop's
inside set with area `A`. `rectInside`/`rectInside_card`/`ratio_rectInside`
give a concrete non-wrapping (contractible) rectangular loop and show its
inside-set cardinality is literally `dx * dy`, so `ratio_rectInside` is
theorem 2''s displayed formula `<W> = (t^A + t^{P-A}) / (1 + t^P)` with `A`
now a genuine geometric area rather than an abstract `Finset` parameter. This
is still the pure finite-combinatorics/cover-expansion layer: it does not
define a Wilson action, partition function, or lattice ensemble connecting
this ratio to an actual expectation value - that assembly belongs to a
successor module bridging to `LatticeEnsemble`/`PlaquetteEnsemble`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (dual-connectivity core plus the exact Z2
torus cover-expansion ratio for a genuine rectangular loop).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TorusEvenCover

/-- The Z2 membership bit of a plaquette subset. -/
def memBit {α : Type*} (S : Finset α) [DecidablePred (· ∈ S)] (a : α) : Bool :=
  decide (a ∈ S)

/-- Boundary bit across a horizontal dual edge: the XOR of the two adjacent
plaquette membership bits. Zero means the two plaquettes have equal
membership. -/
def xBoundaryBit {Lx Ly : ℕ} (S : Finset (Fin Lx × Fin Ly))
    {i : ℕ} (hi : i + 1 < Lx) (j : Fin Ly) : Bool :=
  memBit S ((⟨i + 1, hi⟩ : Fin Lx), j) ^^
    memBit S ((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j)

/-- Boundary bit across a vertical dual edge: the XOR of the two adjacent
plaquette membership bits. Zero means the two plaquettes have equal
membership. -/
def yBoundaryBit {Lx Ly : ℕ} (S : Finset (Fin Lx × Fin Ly))
    (i : Fin Lx) {j : ℕ} (hj : j + 1 < Ly) : Bool :=
  memBit S (i, (⟨j + 1, hj⟩ : Fin Ly)) ^^
    memBit S (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly))

/-- Z2 symmetric difference of finite sets: membership is flipped exactly on
points that belong to one input set but not the other. -/
def z2SymmDiff {α : Type*} [DecidableEq α] (S A : Finset α) : Finset α :=
  (S \ A) ∪ (A \ S)

/-- Zero Z2 boundary in both coordinate directions. This is the plaquette-set
form of "every dual edge sees even incidence." -/
def ZeroBoundary {Lx Ly : ℕ} (S : Finset (Fin Lx × Fin Ly)) : Prop :=
  (∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly, xBoundaryBit S hi j = false) ∧
    (∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly), yBoundaryBit S i hj = false)

/-- Two plaquette subsets have the same Z2 boundary bits in both coordinate
directions. -/
def SameBoundary {Lx Ly : ℕ}
    (S A : Finset (Fin Lx × Fin Ly)) : Prop :=
  (∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly,
      xBoundaryBit S hi j = xBoundaryBit A hi j) ∧
    (∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly),
      yBoundaryBit S i hj = yBoundaryBit A i hj)

/-!
`ZeroBoundary` and `SameBoundary` deliberately mention only the non-wrapping
nearest-neighbor dual edges. On a rectangular grid those edges already make the
dual graph connected, so the wraparound torus-edge constraints are redundant
for the classification theorems below. The lemmas
`mem_iff_origin_of_zeroBoundary` and `mem_iff_mem_of_zeroBoundary` make that
redundancy kernel-checked instead of leaving it as prose.
-/

/-- A zero horizontal boundary bit is exactly equality of membership across
that adjacent plaquette pair. -/
theorem mem_iff_of_xBoundaryBit_eq_false {Lx Ly : ℕ}
    (S : Finset (Fin Lx × Fin Ly)) {i : ℕ} (hi : i + 1 < Lx) (j : Fin Ly)
    (hzero : xBoundaryBit S hi j = false) :
    ((⟨i + 1, hi⟩, j) ∈ S ↔
      ((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) ∈ S) := by
  unfold xBoundaryBit memBit at hzero
  by_cases hleft : ((⟨i + 1, hi⟩, j) : Fin Lx × Fin Ly) ∈ S <;>
    by_cases hright : (((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j)
      : Fin Lx × Fin Ly) ∈ S <;>
    simp [hleft, hright] at hzero ⊢

/-- A zero vertical boundary bit is exactly equality of membership across
that adjacent plaquette pair. -/
theorem mem_iff_of_yBoundaryBit_eq_false {Lx Ly : ℕ}
    (S : Finset (Fin Lx × Fin Ly)) (i : Fin Lx) {j : ℕ} (hj : j + 1 < Ly)
    (hzero : yBoundaryBit S i hj = false) :
    ((i, ⟨j + 1, hj⟩) ∈ S ↔
      (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ S) := by
  unfold yBoundaryBit memBit at hzero
  by_cases hup : (i, (⟨j + 1, hj⟩ : Fin Ly)) ∈ S <;>
    by_cases hdown : (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ S <;>
    simp [hup, hdown] at hzero ⊢

/-- If two plaquette subsets have the same horizontal boundary bit across one
dual edge, their symmetric difference has zero horizontal boundary there. -/
theorem xBoundaryBit_symmDiff_eq_false_of_eq {Lx Ly : ℕ}
    (S A : Finset (Fin Lx × Fin Ly)) {i : ℕ} (hi : i + 1 < Lx) (j : Fin Ly)
    (h : xBoundaryBit S hi j = xBoundaryBit A hi j) :
    xBoundaryBit (z2SymmDiff S A) hi j = false := by
  unfold xBoundaryBit memBit at h ⊢
  unfold z2SymmDiff
  by_cases hs1 : ((⟨i + 1, hi⟩, j) : Fin Lx × Fin Ly) ∈ S <;>
    by_cases hs0 : (((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) :
      Fin Lx × Fin Ly) ∈ S <;>
    by_cases ha1 : ((⟨i + 1, hi⟩, j) : Fin Lx × Fin Ly) ∈ A <;>
    by_cases ha0 : (((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) :
      Fin Lx × Fin Ly) ∈ A <;>
    simp [hs1, hs0, ha1, ha0] at h ⊢

/-- If two plaquette subsets have the same vertical boundary bit across one
dual edge, their symmetric difference has zero vertical boundary there. -/
theorem yBoundaryBit_symmDiff_eq_false_of_eq {Lx Ly : ℕ}
    (S A : Finset (Fin Lx × Fin Ly)) (i : Fin Lx) {j : ℕ} (hj : j + 1 < Ly)
    (h : yBoundaryBit S i hj = yBoundaryBit A i hj) :
    yBoundaryBit (z2SymmDiff S A) i hj = false := by
  unfold yBoundaryBit memBit at h ⊢
  unfold z2SymmDiff
  by_cases hs1 : (i, (⟨j + 1, hj⟩ : Fin Ly)) ∈ S <;>
    by_cases hs0 : (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ S <;>
    by_cases ha1 : (i, (⟨j + 1, hj⟩ : Fin Ly)) ∈ A <;>
    by_cases ha0 : (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ A <;>
    simp [hs1, hs0, ha1, ha0] at h ⊢

/-- If the Z2 symmetric difference of two finite sets is empty, the sets are
equal. -/
theorem eq_of_z2SymmDiff_eq_empty {α : Type*} [DecidableEq α]
    {S A : Finset α} (hD : z2SymmDiff S A = ∅) : S = A := by
  ext p
  have hp : p ∉ z2SymmDiff S A := by
    simp [hD]
  unfold z2SymmDiff at hp
  by_cases hs : p ∈ S <;> by_cases ha : p ∈ A <;> simp [hs, ha] at hp ⊢

/-- If the Z2 symmetric difference of two finite sets is universal, the first
set is the complement of the second. -/
theorem eq_compl_of_z2SymmDiff_eq_univ {α : Type*} [Fintype α] [DecidableEq α]
    {S A : Finset α} (hD : z2SymmDiff S A = Finset.univ) :
    S = Finset.univ \ A := by
  ext p
  have hp : p ∈ z2SymmDiff S A := by
    simp [hD]
  unfold z2SymmDiff at hp
  by_cases hs : p ∈ S <;> by_cases ha : p ∈ A <;> simp [hs, ha] at hp ⊢

/-- If a subset of an `Lx` by `Ly` plaquette grid has the same membership
across every horizontal and vertical nearest-neighbor pair, then membership at
any plaquette is equivalent to membership at the origin.

This is the connected-dual-graph step in the even-cover proof. The wraparound
torus edges are not needed for the conclusion once the non-wrapping adjacent
equalities are available; the later physics layer derives those adjacent
equalities from even incidence of each link. -/
theorem mem_iff_origin_of_adjacent {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly))
    (hx : ∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly,
      ((⟨i + 1, hi⟩, j) ∈ S ↔
        ((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) ∈ S))
    (hy : ∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly),
      ((i, ⟨j + 1, hj⟩) ∈ S ↔
        (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ S))
    (i : Fin Lx) (j : Fin Ly) :
    ((i, j) ∈ S ↔ ((⟨0, hLx⟩ : Fin Lx), (⟨0, hLy⟩ : Fin Ly)) ∈ S) := by
  have hx_to_zero : ∀ (i : Fin Lx) (j : Fin Ly),
      ((i, j) ∈ S ↔ ((⟨0, hLx⟩ : Fin Lx), j) ∈ S) := by
    intro i j
    have h :
        ∀ (n : ℕ) (hn : n < Lx),
          (((⟨n, hn⟩ : Fin Lx), j) ∈ S ↔
            ((⟨0, hLx⟩ : Fin Lx), j) ∈ S) := by
      intro n
      induction n with
      | zero =>
          intro hn
          have hfin : (⟨0, hn⟩ : Fin Lx) = ⟨0, hLx⟩ := by
            ext
            rfl
          simp [hfin]
      | succ n ih =>
          intro hn
          have hprev : n < Lx := Nat.lt_of_succ_lt hn
          exact (hx hn j).trans (ih hprev)
    simpa using h i.val i.isLt
  have hy_to_zero : ∀ (i : Fin Lx) (j : Fin Ly),
      ((i, j) ∈ S ↔ (i, (⟨0, hLy⟩ : Fin Ly)) ∈ S) := by
    intro i j
    have h :
        ∀ (n : ℕ) (hn : n < Ly),
          ((i, (⟨n, hn⟩ : Fin Ly)) ∈ S ↔
            (i, (⟨0, hLy⟩ : Fin Ly)) ∈ S) := by
      intro n
      induction n with
      | zero =>
          intro hn
          have hfin : (⟨0, hn⟩ : Fin Ly) = ⟨0, hLy⟩ := by
            ext
            rfl
          simp [hfin]
      | succ n ih =>
          intro hn
          have hprev : n < Ly := Nat.lt_of_succ_lt hn
          exact (hy i hn).trans (ih hprev)
    simpa using h j.val j.isLt
  exact (hx_to_zero i j).trans (hy_to_zero (⟨0, hLx⟩ : Fin Lx) j)

/-- A locally constant plaquette subset of a finite connected rectangular grid
is either empty or the whole grid.

In the Z2 torus expansion this is the "zero boundary even cover" conclusion:
after even incidence is translated into adjacent equality on the connected dual
grid, only the empty cover and the full plaquette cover survive. -/
theorem eq_empty_or_univ_of_adjacent {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly))
    (hx : ∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly,
      ((⟨i + 1, hi⟩, j) ∈ S ↔
        ((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) ∈ S))
    (hy : ∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly),
      ((i, ⟨j + 1, hj⟩) ∈ S ↔
        (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ S)) :
    S = ∅ ∨ S = Finset.univ := by
  let origin : Fin Lx × Fin Ly := (⟨0, hLx⟩, ⟨0, hLy⟩)
  by_cases horigin : origin ∈ S
  · right
    ext p
    constructor
    · intro _
      simp
    · intro _
      exact (mem_iff_origin_of_adjacent hLx hLy S hx hy p.1 p.2).mpr horigin
  · left
    ext p
    constructor
    · intro hp
      exact False.elim (horigin ((mem_iff_origin_of_adjacent hLx hLy S hx hy p.1 p.2).mp hp))
    · intro hp
      simp at hp

/-- Zero Z2 boundary bits in both coordinate directions force a plaquette
subset to be empty or universal.

This is the first Lean-facing form of the even-cover lemma used in theorem 2':
the later expansion layer has to show that "every link is covered evenly" gives
`xBoundaryBit = false` and `yBoundaryBit = false` for each neighboring dual
pair. -/
theorem eq_empty_or_univ_of_zero_boundary_bits {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly))
    (hxzero : ∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly,
      xBoundaryBit S hi j = false)
    (hyzero : ∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly),
      yBoundaryBit S i hj = false) :
    S = ∅ ∨ S = Finset.univ :=
  eq_empty_or_univ_of_adjacent hLx hLy S
    (fun hi j => mem_iff_of_xBoundaryBit_eq_false S hi j (hxzero hi j))
    (fun i {j} hj => mem_iff_of_yBoundaryBit_eq_false S i (j := j) hj (hyzero i hj))

/-- Zero boundary makes plaquette membership globally equivalent to membership
at the origin. In particular, any additional wraparound dual-edge constraint is
automatically satisfied once the non-wrapping adjacent constraints hold. -/
theorem mem_iff_origin_of_zeroBoundary {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly)) (hzero : ZeroBoundary S)
    (i : Fin Lx) (j : Fin Ly) :
    ((i, j) ∈ S ↔ ((⟨0, hLx⟩ : Fin Lx), (⟨0, hLy⟩ : Fin Ly)) ∈ S) :=
  mem_iff_origin_of_adjacent hLx hLy S
    (fun hi j => mem_iff_of_xBoundaryBit_eq_false S hi j (hzero.1 hi j))
    (fun i {j} hj => mem_iff_of_yBoundaryBit_eq_false S i (j := j) hj (hzero.2 i hj))
    i j

/-- Zero-boundary plaquette membership is globally constant. This is the
explicit kernel-checked form of the statement that the non-wrapping dual edges
already connect the plaquette grid. -/
theorem mem_iff_mem_of_zeroBoundary {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly)) (hzero : ZeroBoundary S)
    (p q : Fin Lx × Fin Ly) :
    (p ∈ S ↔ q ∈ S) := by
  exact (mem_iff_origin_of_zeroBoundary hLx hLy S hzero p.1 p.2).trans
    (mem_iff_origin_of_zeroBoundary hLx hLy S hzero q.1 q.2).symm

/-- If two plaquette subsets have the same boundary, their Z2 symmetric
difference has zero boundary. -/
theorem zeroBoundary_z2SymmDiff_of_sameBoundary {Lx Ly : ℕ}
    (S A : Finset (Fin Lx × Fin Ly)) (h : SameBoundary S A) :
    ZeroBoundary (z2SymmDiff S A) :=
  ⟨fun hi j => xBoundaryBit_symmDiff_eq_false_of_eq S A hi j (h.1 hi j),
    fun i {j} hj => yBoundaryBit_symmDiff_eq_false_of_eq S A i (j := j) hj (h.2 i hj)⟩

/-- The empty plaquette subset has zero boundary. -/
theorem zeroBoundary_empty {Lx Ly : ℕ} :
    ZeroBoundary (∅ : Finset (Fin Lx × Fin Ly)) := by
  constructor
  · intro i hi j
    simp [xBoundaryBit, memBit]
  · intro i j hj
    simp [yBoundaryBit, memBit]

/-- The universal plaquette subset has zero boundary. -/
theorem zeroBoundary_univ {Lx Ly : ℕ} :
    ZeroBoundary (Finset.univ : Finset (Fin Lx × Fin Ly)) := by
  constructor
  · intro i hi j
    simp [xBoundaryBit, memBit]
  · intro i j hj
    simp [yBoundaryBit, memBit]

/-- Zero boundary is equivalent to being one of the two vacuum covers: empty
or universal. -/
theorem zeroBoundary_iff_eq_empty_or_univ {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S : Finset (Fin Lx × Fin Ly)) :
    ZeroBoundary S ↔ S = ∅ ∨ S = Finset.univ := by
  constructor
  · intro hzero
    exact eq_empty_or_univ_of_zero_boundary_bits hLx hLy S hzero.1 hzero.2
  · intro h
    rcases h with rfl | rfl
    · exact zeroBoundary_empty
    · exact zeroBoundary_univ

/-- If two plaquette subsets have the same Z2 boundary bits in both coordinate
directions, then they differ by either nothing or the full plaquette grid.

For theorem 2', take `A` to be the chosen "inside" plaquette set bounded by the
contractible loop. Then any other plaquette subset with the same boundary is
either `A` itself or its complement, the algebraic source of the two terms
`t^A` and `t^(P-A)` in the exact torus Wilson-loop expectation. -/
theorem eq_or_compl_of_same_boundary_bits {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S A : Finset (Fin Lx × Fin Ly))
    (hx : ∀ {i : ℕ} (hi : i + 1 < Lx), ∀ j : Fin Ly,
      xBoundaryBit S hi j = xBoundaryBit A hi j)
    (hy : ∀ i : Fin Lx, ∀ {j : ℕ} (hj : j + 1 < Ly),
      yBoundaryBit S i hj = yBoundaryBit A i hj) :
    S = A ∨ S = Finset.univ \ A := by
  have hD := eq_empty_or_univ_of_zero_boundary_bits hLx hLy (z2SymmDiff S A)
    (zeroBoundary_z2SymmDiff_of_sameBoundary S A ⟨hx, hy⟩).1
    (zeroBoundary_z2SymmDiff_of_sameBoundary S A ⟨hx, hy⟩).2
  rcases hD with hD | hD
  · exact Or.inl (eq_of_z2SymmDiff_eq_empty hD)
  · exact Or.inr (eq_compl_of_z2SymmDiff_eq_univ hD)

/-- Predicate-form wrapper for `eq_or_compl_of_same_boundary_bits`. -/
theorem eq_or_compl_of_sameBoundary {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (S A : Finset (Fin Lx × Fin Ly)) (h : SameBoundary S A) :
    S = A ∨ S = Finset.univ \ A :=
  eq_or_compl_of_same_boundary_bits hLx hLy S A h.1 h.2

/-- Every set has the same boundary as itself. -/
theorem sameBoundary_self {Lx Ly : ℕ} (A : Finset (Fin Lx × Fin Ly)) :
    SameBoundary A A :=
  ⟨fun _hi _j => rfl, fun _i {_j} _hj => rfl⟩

/-- Complementing a plaquette subset preserves every Z2 horizontal boundary
bit: both endpoint membership bits are flipped, so their XOR is unchanged. -/
theorem xBoundaryBit_compl {Lx Ly : ℕ}
    (A : Finset (Fin Lx × Fin Ly)) {i : ℕ} (hi : i + 1 < Lx) (j : Fin Ly) :
    xBoundaryBit (Finset.univ \ A) hi j = xBoundaryBit A hi j := by
  unfold xBoundaryBit memBit
  by_cases hleft : ((⟨i + 1, hi⟩, j) : Fin Lx × Fin Ly) ∈ A <;>
    by_cases hright : (((⟨i, Nat.lt_of_succ_lt hi⟩ : Fin Lx), j) :
      Fin Lx × Fin Ly) ∈ A <;>
    simp [hleft, hright]

/-- Complementing a plaquette subset preserves every Z2 vertical boundary
bit. -/
theorem yBoundaryBit_compl {Lx Ly : ℕ}
    (A : Finset (Fin Lx × Fin Ly)) (i : Fin Lx) {j : ℕ} (hj : j + 1 < Ly) :
    yBoundaryBit (Finset.univ \ A) i hj = yBoundaryBit A i hj := by
  unfold yBoundaryBit memBit
  by_cases hup : (i, (⟨j + 1, hj⟩ : Fin Ly)) ∈ A <;>
    by_cases hdown : (i, (⟨j, Nat.lt_of_succ_lt hj⟩ : Fin Ly)) ∈ A <;>
    simp [hup, hdown]

/-- The complement of a plaquette subset has the same Z2 boundary as the
subset itself. -/
theorem sameBoundary_compl {Lx Ly : ℕ} (A : Finset (Fin Lx × Fin Ly)) :
    SameBoundary (Finset.univ \ A) A :=
  ⟨fun hi j => xBoundaryBit_compl A hi j,
    fun i {j} hj => yBoundaryBit_compl A i (j := j) hj⟩

/-- The finite set of zero-boundary plaquette covers. Classical decidability is
isolated here so the enumerative theorem statements stay readable. -/
noncomputable def zeroBoundaryCovers (Lx Ly : ℕ) :
    Finset (Finset (Fin Lx × Fin Ly)) := by
  classical
  exact Finset.univ.powerset.filter
    (fun S : Finset (Fin Lx × Fin Ly) => ZeroBoundary S)

/-- The finite set of zero-boundary plaquette covers is exactly `{empty,
universal}`. This is the enumerative form used by the Z2 torus partition
function. -/
theorem zeroBoundaryCovers_eq {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly) :
    zeroBoundaryCovers Lx Ly
      = ({∅, (Finset.univ : Finset (Fin Lx × Fin Ly))} :
        Finset (Finset (Fin Lx × Fin Ly))) := by
  classical
  unfold zeroBoundaryCovers
  ext S
  simp [zeroBoundary_iff_eq_empty_or_univ hLx hLy S]

/-- Zero-boundary Z2 plaquette-cover weights sum to the two surviving torus
terms: the empty cover and the full cover.

This is the exact finite-combinatorics core of
`Z / (2^E cosh(beta)^P) = 1 + t^P`, with `P = Lx * Ly` represented as the
cardinality of the plaquette grid. -/
theorem sum_zeroBoundary_weights {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly) (t : ℝ) :
    (zeroBoundaryCovers Lx Ly).sum (fun S => t ^ S.card)
      = 1 + t ^ Fintype.card (Fin Lx × Fin Ly) := by
  classical
  rw [zeroBoundaryCovers_eq hLx hLy]
  have hne : (∅ : Finset (Fin Lx × Fin Ly)) ≠ Finset.univ := by
    intro h
    have horigin : ((⟨0, hLx⟩ : Fin Lx), (⟨0, hLy⟩ : Fin Ly)) ∈
        (Finset.univ : Finset (Fin Lx × Fin Ly)) := by
      simp
    rw [← h] at horigin
    simp at horigin
  simp [hne]

/-- The finite set of plaquette covers with the same boundary as `A`. -/
noncomputable def sameBoundaryCovers {Lx Ly : ℕ}
    (A : Finset (Fin Lx × Fin Ly)) :
    Finset (Finset (Fin Lx × Fin Ly)) := by
  classical
  exact Finset.univ.powerset.filter
    (fun S : Finset (Fin Lx × Fin Ly) => SameBoundary S A)

/-- Covers with the same Z2 boundary as `A` are exactly `A` and its complement.
This is the enumerative "inside or outside" statement behind the Wilson-loop
numerator in theorem 2'. -/
theorem sameBoundaryCovers_eq {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (A : Finset (Fin Lx × Fin Ly)) :
    sameBoundaryCovers A
      = ({A, (Finset.univ \ A : Finset (Fin Lx × Fin Ly))} :
        Finset (Finset (Fin Lx × Fin Ly))) := by
  classical
  unfold sameBoundaryCovers
  ext S
  constructor
  · intro hS
    have hsame : SameBoundary S A := (Finset.mem_filter.mp hS).2
    rcases eq_or_compl_of_sameBoundary hLx hLy S A hsame with rfl | rfl <;> simp
  · intro hS
    have hpair : S = A ∨ S = Finset.univ \ A := by
      simpa using hS
    rcases hpair with rfl | rfl
    · simp [sameBoundary_self]
    · simp [sameBoundary_compl]

/-- On a nonempty finite universe, a set cannot equal its complement. -/
theorem ne_univ_sdiff_self {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (A : Finset (Fin Lx × Fin Ly)) :
    A ≠ Finset.univ \ A := by
  intro h
  let origin : Fin Lx × Fin Ly := (⟨0, hLx⟩, ⟨0, hLy⟩)
  by_cases horigin : origin ∈ A
  · have hnot : origin ∉ Finset.univ \ A := by
      simp [horigin]
    have hin : origin ∈ Finset.univ \ A := by
      rwa [← h]
    exact hnot hin
  · have hcomp : origin ∈ Finset.univ \ A := by
      simp [horigin]
    have hinA : origin ∈ A := by
      rwa [h]
    exact horigin hinA

/-- Same-boundary Z2 plaquette-cover weights sum to the two Wilson-loop
numerator terms: the chosen inside set and its outside complement. -/
theorem sum_sameBoundary_weights {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (A : Finset (Fin Lx × Fin Ly)) (t : ℝ) :
    (sameBoundaryCovers A).sum (fun S => t ^ S.card)
      = t ^ A.card + t ^ (Finset.univ \ A).card := by
  classical
  rw [sameBoundaryCovers_eq hLx hLy A]
  have hne : A ≠ Finset.univ \ A := ne_univ_sdiff_self hLx hLy A
  simp [hne]

/-- Cardinality of a finite-set complement relative to `univ`. -/
theorem card_univ_sdiff {α : Type*} [Fintype α] [DecidableEq α]
    (A : Finset α) :
    (Finset.univ \ A).card = Fintype.card α - A.card := by
  rw [Finset.card_sdiff]
  simp

/-- Ratio form of the Z2 torus cover combinatorics. This is the exact
finite-cover contribution to the contractible Wilson-loop expectation:
the numerator has the chosen inside cover and its complement, and the
denominator has the empty and full vacuum covers.

The remaining theorem 2' assembly work is to connect this cover expansion to
the lattice-gauge partition function prefactors and to identify a rectangular
loop's inside set with area `A`. -/
theorem ratio_sameBoundary_zeroBoundary_weights {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (A : Finset (Fin Lx × Fin Ly)) (t : ℝ) :
    ((sameBoundaryCovers A).sum (fun S => t ^ S.card)) /
        ((zeroBoundaryCovers Lx Ly).sum (fun S => t ^ S.card))
      =
      (t ^ A.card + t ^ (Fintype.card (Fin Lx × Fin Ly) - A.card)) /
        (1 + t ^ Fintype.card (Fin Lx × Fin Ly)) := by
  rw [sum_sameBoundary_weights hLx hLy A t,
    sum_zeroBoundary_weights hLx hLy t, card_univ_sdiff A]

/-- The `Fin L`-indices whose value lies in a half-open range `[i0, i0+d)`. -/
def finRange (L : ℕ) (i0 d : ℕ) : Finset (Fin L) :=
  Finset.univ.filter (fun i => i.val ∈ Finset.Ico i0 (i0 + d))

/-- `finRange` has exactly `d` elements once the range fits inside `Fin L`.
Proved by exhibiting the cardinality-preserving bijection with `Finset.Ico i0
(i0+d) : Finset ℕ` given by `Fin.val` (injective automatically; surjective
onto that range since every `n < i0+d <= L` lifts to a genuine `Fin L`). -/
theorem finRange_card (L : ℕ) (i0 d : ℕ) (h : i0 + d ≤ L) :
    (finRange L i0 d).card = d := by
  classical
  have hcard : (finRange L i0 d).card = (Finset.Ico i0 (i0 + d)).card := by
    apply Finset.card_bij (fun (i : Fin L) (_ : i ∈ finRange L i0 d) => i.val)
    · intro i hi
      simpa [finRange] using hi
    · intro i1 _ i2 _ heq
      exact Fin.ext heq
    · intro n hn
      refine ⟨⟨n, lt_of_lt_of_le (Finset.mem_Ico.mp hn).2 h⟩, ?_, rfl⟩
      simpa [finRange] using hn
  rw [hcard, Nat.card_Ico]
  omega

/-- The plaquette-inside set of a non-wrapping (contractible) rectangular
Wilson loop anchored at `(i0, j0)` with width `dx` and height `dy`: exactly
the plaquettes whose coordinates fall in the half-open box
`[i0, i0+dx) x [j0, j0+dy)`. Non-wrapping (no `mod Lx`/`mod Ly` reduction) is
exactly the "contractible loop" case theorem 2' addresses; a wrapping loop is
a different, topologically nontrivial configuration not claimed here. -/
def rectInside (Lx Ly : ℕ) (i0 dx j0 dy : ℕ) : Finset (Fin Lx × Fin Ly) :=
  finRange Lx i0 dx ×ˢ finRange Ly j0 dy

/-- The plaquette-inside set of a non-wrapping rectangular loop of width `dx`
and height `dy` has exactly `dx * dy` plaquettes - the "area `A`" identified
with the loop's inside region that `ratio_sameBoundary_zeroBoundary_weights`
needs. This closes the "identify a rectangular loop's inside set with area
`A`" gap left open by that theorem's docstring. -/
theorem rectInside_card (Lx Ly : ℕ) (i0 dx j0 dy : ℕ)
    (hx : i0 + dx ≤ Lx) (hy : j0 + dy ≤ Ly) :
    (rectInside Lx Ly i0 dx j0 dy).card = dx * dy := by
  rw [rectInside, Finset.card_product, finRange_card Lx i0 dx hx, finRange_card Ly j0 dy hy]

/-- Theorem 2' fully assembled for a genuine non-wrapping rectangular loop:
the Z2 torus cover-expansion ratio, with the loop's inside region concretely
identified as `rectInside` and its area as the literal product `dx * dy`,
matching the freeze's displayed formula
`<W> = (t^A + t^(P-A)) / (1 + t^P)` verbatim once `A := dx * dy`. -/
theorem ratio_rectInside {Lx Ly : ℕ}
    (hLx : 0 < Lx) (hLy : 0 < Ly) (i0 dx j0 dy : ℕ)
    (hx : i0 + dx ≤ Lx) (hy : j0 + dy ≤ Ly) (t : ℝ) :
    ((sameBoundaryCovers (rectInside Lx Ly i0 dx j0 dy)).sum (fun S => t ^ S.card)) /
        ((zeroBoundaryCovers Lx Ly).sum (fun S => t ^ S.card))
      =
      (t ^ (dx * dy) + t ^ (Fintype.card (Fin Lx × Fin Ly) - dx * dy)) /
        (1 + t ^ Fintype.card (Fin Lx × Fin Ly)) := by
  rw [ratio_sameBoundary_zeroBoundary_weights hLx hLy (rectInside Lx Ly i0 dx j0 dy) t,
    rectInside_card Lx Ly i0 dx j0 dy hx hy]

end TorusEvenCover
end GateYM
end NullEdge
end Draft
end PhysicsSM
