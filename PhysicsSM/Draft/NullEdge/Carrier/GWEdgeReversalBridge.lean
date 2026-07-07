import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.GWConjecture
import PhysicsSM.Draft.NullEdge.Carrier.GWRetardedTransfer

/-!
# Q06 bridge: decorated-edge reversal `→` carrier-level generator conjugation

This module records the *smallest honest bridge* from the landed symbol / word-order
theorems (`GWConjecture.lean`, `GWWilsonSymbol.lean`, `GWRetardedTransfer.lean`)
toward the carrier-level generator-conjugation hypothesis `G * x * G = x⁻¹`, and
the connection to *path-sum = transfer-power*.

## The question audited

The GW machinery in `GWRetardedTransfer.lean` takes the *conjugation hypothesis*
`G * V * G = V⁻¹` as an input hypothesis (GW-1, `gw_of_involution_inverts`).  The
open question is: how much of that hypothesis can be *derived* from the physically
primitive datum **decorated-edge reversal `U_reverse = U⁻¹`** (reversing an
oriented edge inverts its transport), and how does it interact with the fact that
a straight path's holonomy is a *transfer power* `U^n`?

## What is and is not derivable — the honest boundary

The two operations act oppositely on a word `L` of edge decorations:

* **Edge reversal** (the primitive `U_reverse = U⁻¹`) sends the holonomy to its
  genuine inverse, and it **reverses word order**:
  `(reverseEdges L).prod = (L.prod)⁻¹`  (`holonomy_reverseEdges`, rung **B1**).
* **Conjugation** by an involution `G` with `G x G = x⁻¹` inverts each letter but
  **preserves word order**:
  `G * L.prod * G = (L.map (·⁻¹)).prod`  (`conj_prod_forward`, rung **B2**).

Hence the conjugation hypothesis `G * L.prod * G = (L.prod)⁻¹` holds **iff** the
inverted word is invariant under reversal (`conj_inv_iff`, rung **B3**).  This is
the exact gap.  Three *honest* sufficient conditions close it — and no more:

* palindromic word (`GWConjecture.palindrome_conj_inv`);
* abelian carrier (`GWConjecture.abelian_conj_inv`);
* **homogeneous / transfer-power word** `L = replicate n x`, i.e. a straight path
  whose holonomy is a transfer power `x^n` (`conj_pow_inv`, rung **B4**).

Rung **B4** is the new content: it is a *nonabelian* case where conjugation does
invert, and it is exactly the "path-sum = transfer-power" regime.  Feeding it into
GW-1 gives the Ginsparg–Wilson relation for every transfer power from the single
generator hypothesis (`gw_relation_transfer_power`, rung **B5**).

**Kill condition (not derivable).**  A *general* one-sided / heterogeneous
retarded word is NOT inverted by conjugation: this is the explicit rational
`2×2` nonabelian counterexample `GWConjecture.nonabelian_oneSided_counterexample`.
So B4 cannot be extended to arbitrary words; "arbitrary one-sided retardation
gives inversion" is FALSE.

## Status ladder

* B1 `holonomy_reverseEdges`     — PROVED  (edge reversal = holonomy inverse)
* B2 `conj_prod_forward`         — PROVED  (reused; conjugation preserves order)
* B3 `conj_inv_iff`              — PROVED  (the exact gap as an iff)
* B4 `conj_pow_inv`              — PROVED  (transfer-power inversion, nonabelian ok)
* B5 `gw_relation_transfer_power`— PROVED  (GW-1 for every transfer power)
* KILL `nonabelian_oneSided_counterexample` — PROVED in `GWConjecture.lean`
  (arbitrary one-sided word is NOT inverted)

Everything here is compiler-trust-free carrier/group/ring algebra; no new assumptions.

Provenance: Q06 audit job `ne-q06-symbol-to-carrier-generator-conjugation-audit-20260707`,
building on `GWConjecture.lean`, `GWWilsonSymbol.lean`, `GWRetardedTransfer.lean`.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge

open PhysicsSM.Draft.NullEdge.Carrier

/-! ## Group carrier: edge reversal vs. conjugation -/

section GroupCarrier

variable {A : Type*} [Group A]

/-- **Decorated-edge reversal** of a path `L`: traverse the edges in reverse
order, inverting each edge's transport (`U_reverse = U⁻¹`).  This is the
path-level avatar of the primitive edge-orientation reversal. -/
def reverseEdges (L : List A) : List A := (L.map (·⁻¹)).reverse

/-- **B1 (edge reversal = holonomy inverse).**  Reversing every edge of a path
(inverting each decoration and reversing the order) sends the holonomy
`L.prod` to its genuine inverse.  This is the honest statement of the primitive
datum `U_reverse = U⁻¹` at the level of a whole path. -/
theorem holonomy_reverseEdges (L : List A) :
    (reverseEdges L).prod = (L.prod)⁻¹ := by
  rw [reverseEdges, ← List.prod_inv_reverse]

/-- **B2 (conjugation preserves word order).**  If `G` is an involution
conjugating each edge to its inverse, conjugating the holonomy produces the
inverted letters *in the same order* — NOT the reversed order that a genuine
inverse requires.  (Re-exported from `GWConjecture` for the ladder.) -/
theorem conj_prod_forward (G : A) (hG : G * G = 1) (L : List A)
    (hL : ∀ x ∈ L, G * x * G = x⁻¹) :
    G * L.prod * G = (L.map (·⁻¹)).prod :=
  GWConjecture.conj_prod_forward G hG L hL

/-- **B3 (the exact gap).**  Under the generator hypothesis, the conjugation
hypothesis `G * (holonomy) * G = (holonomy)⁻¹` holds **iff** the inverted word is
invariant under reversal, i.e. iff order-preserving conjugation happens to agree
with order-reversing inversion.  This isolates precisely what edge reversal
`U_reverse = U⁻¹` alone cannot supply. -/
theorem conj_inv_iff (G : A) (hG : G * G = 1) (L : List A)
    (hL : ∀ x ∈ L, G * x * G = x⁻¹) :
    G * L.prod * G = (L.prod)⁻¹ ↔
      (L.map (·⁻¹)).prod = (L.reverse.map (·⁻¹)).prod := by
  rw [conj_prod_forward G hG L hL, List.prod_inv_reverse, List.map_reverse]

/-- **B4 (transfer-power inversion — the honest nonabelian bridge).**  For a
homogeneous path (a straight edge repeated `n` times), whose holonomy is the
transfer power `x ^ n`, the single generator hypothesis `G * x * G = x⁻¹`
*already* forces conjugation to invert:
`G * x ^ n * G = (x ^ n)⁻¹`.
No palindrome or abelian assumption is needed — this is exactly the
"path-sum = transfer-power" regime, and it holds in any (possibly nonabelian)
group. -/
theorem conj_pow_inv (G x : A) (hG : G * G = 1) (hx : G * x * G = x⁻¹) (n : ℕ) :
    G * x ^ n * G = (x ^ n)⁻¹ := by
  have h := conj_prod_forward G hG (List.replicate n x)
    (by intro y hy; rw [List.eq_of_mem_replicate hy]; exact hx)
  simpa [List.prod_replicate, List.map_replicate, inv_pow] using h

end GroupCarrier

/-! ## Ring carrier: feeding B4 into the Ginsparg–Wilson relation

The physical carrier is a matrix algebra (a ring) whose invertible transports
form a group.  We restate the transfer-power inversion using explicit two-sided
inverse witnesses so it can be fed to GW-1 (`GWTransfer.gw_of_involution_inverts`),
which lives in a bare `Ring`. -/

section RingCarrier

variable {A : Type*} [Ring A]

/-- Power conjugation in a ring: an involution `G` (`G * G = 1`) that conjugates
`x` to a witness `xinv` conjugates every power `x ^ n` to `xinv ^ n`. -/
theorem ring_pow_conj (G x xinv : A) (hG : G * G = 1) (hx : G * x * G = xinv)
    (n : ℕ) : G * x ^ n * G = xinv ^ n := by
  induction n with
  | zero => simp [hG]
  | succ m ih =>
    have e : G * x ^ (m + 1) * G = (G * x ^ m * G) * (G * x * G) := by
      have h : (G * x ^ m * G) * (G * x * G) = G * x ^ m * (G * G) * x * G := by
        noncomm_ring
      rw [h, hG]; rw [pow_succ]; noncomm_ring
    rw [e, ih, hx, ← pow_succ]

/-- A left inverse witness for a power: if `xinv * x = 1` then
`xinv ^ n * x ^ n = 1`. -/
theorem pow_inv_left (x xinv : A) (h : xinv * x = 1) (n : ℕ) :
    xinv ^ n * x ^ n = 1 := by
  induction n with
  | zero => simp
  | succ m ih =>
    have e : xinv ^ (m + 1) * x ^ (m + 1) = xinv * (xinv ^ m * x ^ m) * x := by
      rw [pow_succ' xinv, pow_succ x]; noncomm_ring
    rw [e, ih, mul_one, h]

/-- A right inverse witness for a power: if `x * xinv = 1` then
`x ^ n * xinv ^ n = 1`. -/
theorem pow_inv_right (x xinv : A) (h : x * xinv = 1) (n : ℕ) :
    x ^ n * xinv ^ n = 1 := by
  induction n with
  | zero => simp
  | succ m ih =>
    have e : x ^ (m + 1) * xinv ^ (m + 1) = x * (x ^ m * xinv ^ m) * xinv := by
      rw [pow_succ' x, pow_succ xinv]; noncomm_ring
    rw [e, ih, mul_one, h]

/-- **B5 (Ginsparg–Wilson relation for every transfer power).**  Combining the
transfer-power inversion (B4, ring form `ring_pow_conj`) with GW-1
(`GWTransfer.gw_of_involution_inverts`): from the *single* generator datum — an
involution `G` conjugating a transport `x` (with two-sided inverse `xinv`) to
that inverse and back — the unscaled Dirac operator `D := 1 - x ^ n` built from
*any* transfer power obeys the exact one-step Ginsparg–Wilson relation
`G * D + D * G = D * G * D`.

This is the honest carrier-level payoff: the conjugation hypothesis of GW-1 is
*derived*, for the physically relevant straight-path (transfer-power) holonomies,
from edge reversal plus the single generator hypothesis. -/
theorem gw_relation_transfer_power (G x xinv : A) (hG : G * G = 1)
    (hxl : xinv * x = 1) (hx : G * x * G = xinv)
    (n : ℕ) :
    G * (1 - x ^ n) + (1 - x ^ n) * G = (1 - x ^ n) * G * (1 - x ^ n) :=
  GWTransfer.gw_of_involution_inverts G (x ^ n) (xinv ^ n) hG
    (pow_inv_left x xinv hxl n) (ring_pow_conj G x xinv hG hx n)

end RingCarrier

end PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge
