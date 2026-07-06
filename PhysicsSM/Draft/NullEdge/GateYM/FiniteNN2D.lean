import Mathlib

/-!
# The finite (2D) Nielsen–Ninomiya TOPOLOGICAL SKELETON on the discrete Brillouin 2-torus

This file extends the **honest, kernel-checked, finite** 1D topological skeleton of
`FiniteNielsenNinomiya.lean` to the *two-dimensional* discrete Brillouin torus
`ZMod N × ZMod M`.  As in the 1D file, it deliberately does **not** claim the full
continuum Nielsen–Ninomiya theorem: it develops only the boundaryless
*ingredient* — the total sum of a discrete divergence/curl density over the closed
2-torus vanishes.

## What is proved (sorry-free, no `axiom`, no `native_decide`)

* `sum_dx_telescope`, `sum_dy_telescope` : each discrete partial-difference,
  summed over the whole boundaryless 2-torus, telescopes to `0` (the two coordinate
  directions of `ZMod N × ZMod M` are each boundaryless cyclic groups).
* `discreteDiv` : the discrete divergence
  `div F (p,q) = (Fx(p+1,q) − Fx(p,q)) + (Fy(p,q+1) − Fy(p,q))` of a lattice vector
  field `F = (Fx, Fy)`.
* `signed_sum_div_telescope` : **the 2D analogue of `signed_sum_telescope`** — the
  total sum of the discrete divergence over the closed torus `ZMod N × ZMod M` is
  `0`.  This is the "sum of a boundaryless signed density vanishes" statement.
* `discreteCurl`, `signed_sum_curl_telescope` : the same boundaryless fact for the
  discrete curl `curl F (p,q) = (Fy(p+1,q) − Fy(p,q)) − (Fx(p,q+1) − Fx(p,q))`.
* `signedNodeCount2D_eq_zero` : a **concrete `N = M = 4` example** (kernel `decide`),
  the 2D naive dispersion `s(p,q) = (sin(2πp/4), sin(2πq/4))` with four Brillouin-zone
  nodes `(0,0),(0,2),(2,0),(2,2)`, whose product chiralities are `+1,−1,−1,+1`, so the
  chirality-weighted node count is exactly `0`.
* `odd_signedDiv_impossible` : the vacuous necessity corollary (an odd total
  divergence is impossible on the boundaryless torus).

## Honesty note — what is NOT proved

As with the 1D file, this is the finite lattice **TOPOLOGICAL SKELETON**:

* `signed_sum_div_telescope` / `signed_sum_curl_telescope` take a **free** lattice
  field `F : ZMod N × ZMod M → ℤ` (two components).  They are **not** tied to any
  chiral-symmetry / `γ5` structure; the "chirality/curl branch" reading is the
  intended interpretation, not part of the proof.  They are the honest boundaryless
  content — "the sum of a globally consistent signed density over a torus without
  boundary is `0`" — **not** a proof that a genuine chirally symmetric 2D Dirac
  symbol must have zero signed count.
* `signedNodeCount2D` is built from the **stipulated** hand-written vector
  `naiveSin4 = ![0,1,0,-1]` in each direction and product chiralities; the node set
  and the `0` count are honestly *computed* from it, but the link "a genuine 2D naive
  dispersion ⟹ these four doublers with these chiralities" is stipulated, not derived.
* The genuine 2D **necessity** statement — signed count DEFINED from a chirally
  symmetric Dirac symbol `D : ZMod N × ZMod M → Matrix (Fin 2) (Fin 2) ℂ` with an
  explicit `ChiralSym (D k)` hypothesis, shown to vanish — is the separate follow-up
  theorem and is **out of scope** of this finite skeleton.

## Relation to the continuum theorem (informal)

The continuum Nielsen–Ninomiya no-go says the sum of the chiralities (local degrees)
of the isolated zeros of a chirally symmetric lattice Dirac operator on `Tᵈ` vanishes,
because the sum of local degrees over a closed manifold without boundary is a boundary
term and hence `0`.  `signed_sum_div_telescope` is the finite 2D avatar: the "total
degree" is the sum of a discrete divergence density of a globally consistent branch,
forced to `0` by the absence of a boundary.  The higher-dimensional degree machinery
is not developed here.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.FiniteNN2D

open BigOperators
open scoped Real

/-! ## 1. Boundaryless telescoping on the discrete 2-torus `ZMod N × ZMod M` -/

/-- **Telescoping in the first (x) direction.**  For any `ℤ`-valued lattice field
`Fx : ZMod N × ZMod M → ℤ`, the discrete `x`-difference summed over the whole
boundaryless 2-torus is `0`. -/
theorem sum_dx_telescope {N M : ℕ} [NeZero N] [NeZero M] (Fx : ZMod N × ZMod M → ℤ) :
    ∑ c : ZMod N × ZMod M, (Fx (c.1 + 1, c.2) - Fx c) = 0 := by
  rw [Finset.sum_sub_distrib]
  have hshift : (∑ c : ZMod N × ZMod M, Fx (c.1 + 1, c.2)) = ∑ c : ZMod N × ZMod M, Fx c := by
    apply Fintype.sum_equiv (Equiv.prodCongr (Equiv.addRight (1 : ZMod N)) (Equiv.refl (ZMod M)))
    intro c; rfl
  rw [hshift, sub_self]

/-- **Telescoping in the second (y) direction.**  For any `ℤ`-valued lattice field
`Fy : ZMod N × ZMod M → ℤ`, the discrete `y`-difference summed over the whole
boundaryless 2-torus is `0`. -/
theorem sum_dy_telescope {N M : ℕ} [NeZero N] [NeZero M] (Fy : ZMod N × ZMod M → ℤ) :
    ∑ c : ZMod N × ZMod M, (Fy (c.1, c.2 + 1) - Fy c) = 0 := by
  rw [Finset.sum_sub_distrib]
  have hshift : (∑ c : ZMod N × ZMod M, Fy (c.1, c.2 + 1)) = ∑ c : ZMod N × ZMod M, Fy c := by
    apply Fintype.sum_equiv (Equiv.prodCongr (Equiv.refl (ZMod N)) (Equiv.addRight (1 : ZMod M)))
    intro c; rfl
  rw [hshift, sub_self]

/-- The discrete **divergence** of a lattice vector field `(Fx, Fy)` at a site
`(p, q)` of the 2-torus:
`div (p,q) = (Fx(p+1,q) − Fx(p,q)) + (Fy(p,q+1) − Fy(p,q))`. -/
def discreteDiv {N M : ℕ} (Fx Fy : ZMod N × ZMod M → ℤ) (c : ZMod N × ZMod M) : ℤ :=
  (Fx (c.1 + 1, c.2) - Fx c) + (Fy (c.1, c.2 + 1) - Fy c)

/-- **2D boundaryless telescoping (the analogue of `signed_sum_telescope`).**  For
*any* pair of `ℤ`-valued lattice fields `Fx, Fy : ZMod N × ZMod M → ℤ`, the total
discrete divergence over the closed torus `ZMod N × ZMod M` is `0`.

CAVEAT: `Fx, Fy` are FREE parameters — this is not tied to any `ChiralSym`/`γ5`
structure. It is the honest 2D topological SKELETON of "sum of a boundaryless signed
density = 0", not a proof of it for an actual chirally symmetric 2D Dirac symbol. -/
theorem signed_sum_div_telescope {N M : ℕ} [NeZero N] [NeZero M]
    (Fx Fy : ZMod N × ZMod M → ℤ) :
    ∑ c : ZMod N × ZMod M, discreteDiv Fx Fy c = 0 := by
  unfold discreteDiv
  rw [Finset.sum_add_distrib, sum_dx_telescope, sum_dy_telescope, add_zero]

/-- The discrete **curl** of a lattice vector field `(Fx, Fy)` at a site `(p, q)`:
`curl (p,q) = (Fy(p+1,q) − Fy(p,q)) − (Fx(p,q+1) − Fx(p,q))`. -/
def discreteCurl {N M : ℕ} (Fx Fy : ZMod N × ZMod M → ℤ) (c : ZMod N × ZMod M) : ℤ :=
  (Fy (c.1 + 1, c.2) - Fy c) - (Fx (c.1, c.2 + 1) - Fx c)

/-- **2D boundaryless telescoping, curl form.**  The total discrete curl over the
closed torus `ZMod N × ZMod M` is `0` (same boundaryless cancellation). -/
theorem signed_sum_curl_telescope {N M : ℕ} [NeZero N] [NeZero M]
    (Fx Fy : ZMod N × ZMod M → ℤ) :
    ∑ c : ZMod N × ZMod M, discreteCurl Fx Fy c = 0 := by
  unfold discreteCurl
  rw [Finset.sum_sub_distrib, sum_dx_telescope, sum_dy_telescope, sub_zero]

/-- **Necessity corollary (VACUOUS skeleton).**  Since the total discrete divergence
is `0` for every field, an *odd* total divergence is impossible on the boundaryless
2-torus. As in 1D, this carries NO chiral-symmetry hypothesis; the "necessity"
reading is prose only. -/
theorem odd_signedDiv_impossible {N M : ℕ} [NeZero N] [NeZero M]
    (Fx Fy : ZMod N × ZMod M → ℤ)
    (hodd : Odd (∑ c : ZMod N × ZMod M, discreteDiv Fx Fy c)) : False := by
  rw [signed_sum_div_telescope] at hodd
  simp at hodd

/-! ## 2. A concrete `N = M = 4` example (fully computed by kernel `decide`) -/

/-- Integer sign function. -/
def sgnZ (q : ℤ) : ℤ := if 0 < q then 1 else if q < 0 then -1 else 0

/-- The 1D naive real dispersion `sin(2π p/4) = ![0,1,0,-1]` on the `N = 4` torus
(the stand-in used in the 1D file), reused here for each coordinate direction. -/
def naiveSin4 : ZMod 4 → ℤ := ![0, 1, 0, -1]

/-- 1D chirality of a node at `p`: the sign of the central difference
`s(p+1) − s(p−1)`. -/
def chi1 (p : ZMod 4) : ℤ := sgnZ (naiveSin4 (p + 1) - naiveSin4 (p - 1))

/-- A site `(p, q)` of the `4 × 4` Brillouin torus is a **node** of the 2D naive
dispersion `s(p,q) = (sin(2πp/4), sin(2πq/4))` iff both coordinate dispersions
vanish. -/
def isNode2D (c : ZMod 4 × ZMod 4) : Prop := naiveSin4 c.1 = 0 ∧ naiveSin4 c.2 = 0

instance : DecidablePred isNode2D := fun c => by unfold isNode2D; infer_instance

/-- The **product chirality** of a 2D node: the product of the two coordinate
chiralities (the 2D local degree factorizes for a separable dispersion). -/
def chi2D (c : ZMod 4 × ZMod 4) : ℤ := chi1 c.1 * chi1 c.2

/-- The chirality-weighted node count over the whole `4 × 4` Brillouin torus. -/
def signedNodeCount2D : ℤ :=
  ∑ c : ZMod 4 × ZMod 4, if isNode2D c then chi2D c else 0

/-- The four nodes of the 2D naive dispersion are exactly the Brillouin-zone corners
`{(0,0), (0,2), (2,0), (2,2)}`: the physical node at the origin and its three
doublers. -/
theorem nodes2D :
    (Finset.univ.filter fun c : ZMod 4 × ZMod 4 => isNode2D c)
      = {(0, 0), (0, 2), (2, 0), (2, 2)} := by decide

/-- The origin/corner coordinate chiralities: `+1` at `p = 0`, `−1` at `p = 2`. -/
theorem chi1_zero : chi1 0 = 1 := by decide
theorem chi1_two : chi1 2 = -1 := by decide

/-- The four node chiralities: `+1` at `(0,0)`, `−1` at `(0,2)` and `(2,0)`, `+1` at
`(2,2)` — two `+` nodes and two `−` nodes. -/
theorem chi2D_nodes :
    chi2D (0, 0) = 1 ∧ chi2D (0, 2) = -1 ∧ chi2D (2, 0) = -1 ∧ chi2D (2, 2) = 1 := by decide

/-- **Computed `N = M = 4` example (kernel `decide`).**  For the 2D naive dispersion
`s(p,q) = (sin(2πp/4), sin(2πq/4))` with the four Brillouin-zone doublers
`(0,0),(0,2),(2,0),(2,2)` of product chiralities `+1,−1,−1,+1`, the chirality-weighted
node count is exactly `0` — two `+` nodes cancel two `−` nodes.

CAVEAT: `naiveSin4` is STIPULATED, not derived from a genuine dispersion, so read this
as a computed EXAMPLE of the `+`/`−` doubler cancellation, not a proof that a chirally
symmetric 2D symbol must have signed count `0`. -/
theorem signedNodeCount2D_eq_zero : signedNodeCount2D = 0 := by decide

/-! ## 3. The concrete example is an instance of the boundaryless skeleton

Any signed density that is a discrete divergence sums to `0` by
`signed_sum_div_telescope`.  The example below exhibits a nontrivial field whose
divergence realizes a `+`/`−` node pair, whose signed sum is `0` both abstractly (from
boundarylessness) and concretely (`decide`). -/

/-- A concrete lattice field on the `2 × 2` torus supporting a `+`/`−` divergence pair. -/
def exFx : ZMod 2 × ZMod 2 → ℤ := fun c => if c = (0, 0) then 1 else 0
/-- The trivial second component of the concrete field. -/
def exFy : ZMod 2 × ZMod 2 → ℤ := fun _ => 0

/-- The divergence of the concrete field has a `+1` node and a `−1` node (a `+`/`−`
pair) and vanishes elsewhere; its total over the boundaryless `2 × 2` torus is `0`
by direct kernel computation. -/
theorem ex_div_sum_eq_zero :
    ∑ c : ZMod 2 × ZMod 2, discreteDiv exFx exFy c = 0 := by decide

/-- …and the same fact follows abstractly from boundarylessness, with no computation. -/
theorem ex_div_sum_eq_zero' :
    ∑ c : ZMod 2 × ZMod 2, discreteDiv exFx exFy c = 0 :=
  signed_sum_div_telescope exFx exFy

/-! ## 4. Axiom footprint

Every theorem in this file — the boundaryless skeleton theorems *and* the `decide`-
computed examples — depends only on the standard Lean/Mathlib axioms `propext`,
`Classical.choice`, `Quot.sound`.  In particular the kernel `decide` reductions here do
NOT introduce `Lean.ofReduceBool`.  No `sorry`, no `native_decide`, and no user `axiom`
are used.  Uncomment to audit: -/

-- #print axioms signed_sum_div_telescope
-- #print axioms signed_sum_curl_telescope
-- #print axioms odd_signedDiv_impossible
-- #print axioms signedNodeCount2D_eq_zero
-- #print axioms ex_div_sum_eq_zero

end PhysicsSM.Draft.NullEdge.GateYM.FiniteNN2D
