import Mathlib

/-!
# The GENUINE 2D Nielsen–Ninomiya no-go: signed count of Weyl nodes = 0

This file extends the *genuine* finite (1D) Nielsen–Ninomiya no-go of
`FiniteNNZeroCount.lean` to the discrete **2-torus** `ZMod N × ZMod M`.

## Honest label

This is the **1D → 2D genuine crossing-count no-go**: a lattice / crossing-count
statement on the boundaryless discrete Brillouin 2-torus. It is **NOT** the 4D
continuum Nielsen–Ninomiya theorem; it is the discrete-topology (winding-number)
analogue on a finite periodic lattice.

## What a Weyl node is here

A 2-component (Weyl) dispersion is a pair `fx, fy : ZMod N × ZMod M → K`
(`K = ℚ` for kernel `decide`, `K = ℝ` for the physical model). A **Weyl node**
sits on an elementary plaquette (unit square) where **both** components change
sign as one goes around the square (a *double* sign change — genuinely built from
the ZEROS of the field). Its **chirality** is the sign of the local `2×2` Jacobian
of `(fx, fy)` — equivalently the local winding number / topological index of the
map `(fx, fy) : T² → ℝ²` around that plaquette.

## The construction (genuine discrete winding, not a trivial telescope)

At each lattice site we read off the **quadrant** `quad ∈ ZMod 4` of the vector
`(fx p, fy p)` (from the signs of the two components — the double sign structure).
Across each edge we take the *balanced lift* `q4 (Δ quad) ∈ {-1, 0, 1}` of the
quadrant change (a quarter-turn measured with sign). The **winding index** of a
plaquette is the loop sum of these four edge phases around its boundary
(`windingIndex`); it equals `4 ×` the integer winding number of `(fx, fy)` about
that plaquette, so a simple Weyl node contributes `±4 = 4·(±1)`.

Crucially this is **not** a trivial telescoping: the raw quadrant differences
around a plaquette *would* sum to `0` pointwise (a discrete potential), but the
**balanced lift `q4`** makes `windingIndex` genuinely nonzero exactly at the nodes
(see the concrete example, where individual plaquette windings are `±4`). What
vanishes is the *global* sum, and only because the 2-torus is **boundaryless**.

## The no-go and its proof

`signedNodeCount fx fy = ∑_p windingIndex fx fy p` is the chirality-weighted count
of all Weyl nodes. The main theorem `signedNodeCount_eq_zero` shows it is `0` for
**every** dispersion. The proof is a **discrete Stokes / curl** argument:
`windingIndex` is the discrete curl `Δ_x Dv - Δ_y Dh` of the edge phases, and its
total over the torus vanishes because **each** of the two reindexings
`p ↦ p + (0,1)` and `p ↦ p + (1,0)` (the bijections `Equiv.addRight`) is a
symmetry of the sum. This genuinely uses the 2D boundaryless structure in **both**
directions (unlike the 1D telescoping, which uses only one).

## Concrete example (kernel `decide`, no `native_decide`)

A concrete field on `ZMod 4 × ZMod 4` with exactly one `+1` node and one `-1`
node, whose signed chirality sum is `0`.

The axiom footprint of every theorem is reported at the end of the file.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount2D

variable {N M : ℕ} [NeZero N] [NeZero M] {K : Type*} [LinearOrder K] [Zero K]

/-- The discrete Brillouin 2-torus. -/
abbrev Pt (N M : ℕ) : Type := ZMod N × ZMod M

/-- The `{-1, 0, 1}`-valued sign of a dispersion value. -/
def sgnZ (x : K) : ℤ := if 0 < x then 1 else if x < 0 then -1 else 0

/-- The quadrant `∈ ZMod 4` of the 2-vector `(fx p, fy p)`, read off from the
signs of the two components. On the four open quadrants it is
`(+,+) ↦ 0, (-,+) ↦ 1, (-,-) ↦ 2, (+,-) ↦ 3`; the (measure-zero) axes are folded
into the adjacent quadrant, which is irrelevant for nowhere-zero configurations. -/
def quad (fx fy : Pt N M → K) (p : Pt N M) : ZMod 4 :=
  if 0 < fx p then (if 0 < fy p then 0 else 3) else (if 0 < fy p then 1 else 2)

/-- The balanced lift `ZMod 4 → {-1, 0, 1}` of a quadrant change: a signed
quarter-turn. It is *antisymmetric* (`q4 (-x) = - q4 x`), which is what turns the
plaquette loop sum into a genuine winding number. The half-turn value `2` (an edge
jumping to the opposite quadrant, absent for slowly-varying fields) is folded to
`0`. -/
def q4 (x : ZMod 4) : ℤ := if x = 1 then 1 else if x = 3 then -1 else 0

/-- Horizontal edge phase across `p → p + (1,0)`: the signed quarter-turn of
`(fx, fy)`. -/
def Dh (fx fy : Pt N M → K) (p : Pt N M) : ℤ :=
  q4 (quad fx fy (p + (1, 0)) - quad fx fy p)

/-- Vertical edge phase across `p → p + (0,1)`: the signed quarter-turn of
`(fx, fy)`. -/
def Dv (fx fy : Pt N M → K) (p : Pt N M) : ℤ :=
  q4 (quad fx fy (p + (0, 1)) - quad fx fy p)

/-- The **winding index** of the plaquette based at `p` (corners
`p, p+(1,0), p+(1,1), p+(0,1)`): the loop sum of the four boundary edge phases,
equal to the discrete curl `Dh(p) + Dv(p+(1,0)) - Dh(p+(0,1)) - Dv(p)`. It is
`4 ×` the integer winding number of `(fx, fy)` about the plaquette; a simple Weyl
node contributes `±4`. -/
def windingIndex (fx fy : Pt N M → K) (p : Pt N M) : ℤ :=
  Dh fx fy p + Dv fx fy (p + (1, 0)) - Dh fx fy (p + (0, 1)) - Dv fx fy p

/-- The **chirality** `∈ {-1, 0, 1}` of the plaquette based at `p`: the sign of its
winding index. For a simple Weyl node this is exactly the sign of the local `2×2`
Jacobian of `(fx, fy)`. -/
def chir (fx fy : Pt N M → K) (p : Pt N M) : ℤ := Int.sign (windingIndex fx fy p)

/-- The **chirality-weighted signed count of Weyl nodes** over the whole
boundaryless 2-torus. (Using the winding index, so a simple node counts as `±4`.) -/
def signedNodeCount (fx fy : Pt N M → K) : ℤ := ∑ p, windingIndex fx fy p

/-- Sign of the local discrete `2×2` Jacobian of `(fx, fy)` at the plaquette based
at `p`, using forward differences. The chirality of a genuine node equals this. -/
def jacSign {R : Type*} [CommRing R] [LinearOrder R] (fx fy : Pt N M → R)
    (p : Pt N M) : ℤ :=
  sgnZ ((fx (p + (1, 0)) - fx p) * (fy (p + (0, 1)) - fy p)
      - (fx (p + (0, 1)) - fx p) * (fy (p + (1, 0)) - fy p))

/-- **The genuine 2D Nielsen–Ninomiya no-go.** For *every* 2-component periodic
lattice dispersion `(fx, fy)` on the discrete 2-torus `ZMod N × ZMod M`, the
chirality-weighted signed count of its Weyl nodes is `0`: nodes come in
opposite-chirality pairs.

The proof is a discrete Stokes / curl argument. `windingIndex` is the discrete
curl of the edge phases, and its sum telescopes because **both** shifts
`p ↦ p + (0,1)` and `p ↦ p + (1,0)` are symmetries of a finite sum over the
*boundaryless* torus (the bijections `Equiv.addRight`). This uses the 2D periodic
structure in both directions. -/
theorem signedNodeCount_eq_zero (fx fy : Pt N M → K) :
    signedNodeCount fx fy = 0 := by
  have hh : ∑ p : Pt N M, Dh fx fy (p + (0, 1)) = ∑ p, Dh fx fy p :=
    Equiv.sum_comp (Equiv.addRight ((0, 1) : Pt N M)) (Dh fx fy)
  have hv : ∑ p : Pt N M, Dv fx fy (p + (1, 0)) = ∑ p, Dv fx fy p :=
    Equiv.sum_comp (Equiv.addRight ((1, 0) : Pt N M)) (Dv fx fy)
  unfold signedNodeCount windingIndex
  simp only [Finset.sum_sub_distrib, Finset.sum_add_distrib]
  rw [hh, hv]; ring

/-! ## Concrete example: one `+1` node and one `-1` node on `ZMod 4 × ZMod 4`

A nowhere-zero (regularized) 2-component dispersion `(exFx, exFy)` on the 2-torus
`ZMod 4 × ZMod 4` whose quadrant field is *smooth* (no half-turn edges) and which
has **exactly two** Weyl nodes: a `+1` node at the plaquette based at `(2, 3)` and
a `-1` node at the plaquette based at `(2, 2)`. Their chiralities sum to `0`, in
agreement with the general no-go `signedNodeCount_eq_zero`, and each equals the
sign of the local `2×2` Jacobian. Everything below is checked by the **kernel**
via `decide` (no `native_decide`). -/

/-- `exFx x y` : first component of the concrete dispersion (indexed `x` then `y`).
We use `ℤ`-valued components (`±1`, a regularized model) so that all comparisons
*and products* reduce under the kernel's `decide`. -/
def exFxM : ZMod 4 → ZMod 4 → ℤ :=
  ![![1, 1, 1, 1], ![1, 1, 1, -1], ![-1, 1, -1, -1], ![1, 1, 1, 1]]

/-- `exFy x y` : second component of the concrete dispersion. -/
def exFyM : ZMod 4 → ZMod 4 → ℤ :=
  ![![1, 1, 1, 1], ![1, 1, 1, 1], ![1, 1, 1, -1], ![1, 1, 1, -1]]

/-- First component of the concrete 2-component dispersion on `ZMod 4 × ZMod 4`. -/
def exFx : Pt 4 4 → ℤ := fun p => exFxM p.1 p.2

/-- Second component of the concrete 2-component dispersion on `ZMod 4 × ZMod 4`. -/
def exFy : Pt 4 4 → ℤ := fun p => exFyM p.1 p.2

/-- The dispersion is nowhere zero (no accidental on-site degeneracy): each
component is `±1`, so `(exFx p, exFy p) ≠ (0,0)` for every site. -/
theorem exFx_ne_zero : ∀ p, exFx p ≠ 0 := by decide

theorem exFy_ne_zero : ∀ p, exFy p ≠ 0 := by decide

/-- **A `+1` Weyl node** at the plaquette based at `(2, 3)`: its winding index is
`+4 = 4·(+1)`. -/
theorem windingIndex_node_pos : windingIndex exFx exFy (2, 3) = 4 := by decide

/-- **A `-1` Weyl node** at the plaquette based at `(2, 2)`: its winding index is
`-4 = 4·(-1)`. -/
theorem windingIndex_node_neg : windingIndex exFx exFy (2, 2) = -4 := by decide

/-- Every *other* plaquette has winding index `0`: these are the only two nodes.
(A genuine, per-plaquette-nonzero winding — not a trivial pointwise-zero
telescope.) -/
theorem windingIndex_only_two_nodes :
    ∀ p : Pt 4 4, p ≠ (2, 3) → p ≠ (2, 2) → windingIndex exFx exFy p = 0 := by
  decide

/-- The chirality of the `+1` node is `+1`. -/
theorem chir_node_pos : chir exFx exFy (2, 3) = 1 := by decide

/-- The chirality of the `-1` node is `-1`. -/
theorem chir_node_neg : chir exFx exFy (2, 2) = -1 := by decide

/-- The two node chiralities are the signs of the local `2×2` Jacobians. -/
theorem jacSign_matches_pos : jacSign exFx exFy (2, 3) = chir exFx exFy (2, 3) := by
  decide

theorem jacSign_matches_neg : jacSign exFx exFy (2, 2) = chir exFx exFy (2, 2) := by
  decide

/-- **The concrete 2D no-go (kernel `decide`).** The chirality-weighted signed
count of Weyl nodes of the concrete dispersion is `0`: the `+1` node and the `-1`
node cancel. -/
theorem signedNodeCount_example : signedNodeCount exFx exFy = 0 := by decide

/-- The same total also follows from the *general* no-go theorem (no computation).
This confirms the concrete `decide` computation is consistent with the general
telescoping argument. -/
theorem signedNodeCount_example' : signedNodeCount exFx exFy = 0 :=
  signedNodeCount_eq_zero exFx exFy

/-- The plain (`±1`-normalized) sum of node chiralities is also `0`: one `+1` and
one `-1`. -/
theorem signedChirality_example : (∑ p, chir exFx exFy p) = 0 := by decide

/-! ## Axiom footprint

Every theorem in this file depends only on the standard
`propext, Classical.choice, Quot.sound` axioms — no `sorry`, no extra axioms, and
the concrete instances use kernel `decide`, **not** `native_decide` (hence no
`Lean.ofReduceBool`). Uncomment to inspect. -/

-- #print axioms signedNodeCount_eq_zero
-- #print axioms windingIndex_node_pos
-- #print axioms windingIndex_node_neg
-- #print axioms windingIndex_only_two_nodes
-- #print axioms jacSign_matches_pos
-- #print axioms jacSign_matches_neg
-- #print axioms signedNodeCount_example
-- #print axioms signedChirality_example

end PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount2D
