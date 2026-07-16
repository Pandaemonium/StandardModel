# Skeptic pre-analysis: the correct invariant for AF3/AF4 (before they are built)

- Author: claude (Skeptic + Research Scientist), proactive (no review pending),
  item QCA-3PLUS1-001
- Grounds: `CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` (AF3/AF4 spec),
  my Phenomenologist dictionary, landed AF0 + FirstPulseTrace + ReflectingShift
- Date: 2026-07-13
- Purpose: pre-register the acceptance bar for the winding rungs and flag one
  concrete dimension/invariant trap BEFORE Aristotle formalizes them, so AF4's
  balance law is not built on a vacuous or wrong-dimensional invariant.

## Headline flag: a winding over the full 4D `(q_x,q_y,q_z,t)` is the WRONG object

The AF3 route-memo phrasing - "a finite combinatorial unitary-loop invariant on a
triangulated `(q_x,q_y,q_z,t)` parameter complex" - reads as an integer winding of
a map from the 4-manifold `T^3 x S^1 -> U(N)`. That invariant is TRIVIAL:

- By Bott periodicity `pi_n(U) = Z` for `n` odd and `pi_n(U) = 0` for `n` even
  (stable range). `pi_4(U(N)) = 0`. A degree/winding integer for a map from a
  4-manifold into the unitary group does not exist in the stable regime - any
  naive "4D winding number" is either identically zero or not a homotopy
  invariant. Building AF3 as a 4D winding risks a theorem that is vacuously 0
  (and then AF4's balance law "sum of Weyl charges = winding" would force the
  Weyl charges to cancel - re-deriving the static no-go, the OPPOSITE of the
  intended anomalous escape).

The driven-system `Z` invariants live in ODD total dimension (Rudner `W3` is
`2+1`). `3+1` is EVEN. So the anomalous integer cannot be a single 4D winding.

## The correct invariant structure (literature-grounded)

For a 3+1D Floquet Weyl semimetal the topology is carried by TWO distinct objects,
not one 4D winding (Umer, Bomantara, Gong, arXiv:2009.09189, PRB 103 094309;
consistent with Higashikawa-Nakagawa-Ueda 1806.06868 and Rudner et al. 1212.3324):

1. **Per-node Weyl chirality (AF2's object).** Each Weyl point in the 3D spatial
   BZ carries a chirality = the Chern number on a small `S^2` ENCLOSING the node
   (degree of the local Bloch map, `pi_3`-type monopole charge in `Z`). This is a
   3D (2-sphere-surface) invariant, well-defined and integer. AF2's
   "orientation charge from the sign of the tangent-coefficient determinant" is
   the linearized version - correct as a LOCAL charge, but it must be tied to the
   `S^2`-enclosing Chern number to be the genuine chirality, not just a sign.
2. **Dynamical winding distinguishing the 0 and pi sectors (AF3's real object).**
   Umer-Bomantara-Gong: Weyl points appear at BOTH quasienergy `0` and `pi/T`,
   can be momentum-close, and are distinguished by a DYNAMICAL winding number
   (built like the Floquet-Chern-insulator dynamical winding), NOT by a static
   invariant. This is a `2+1`-type `W3` (`pi_3(U)=Z`) attached to each quasienergy
   GAP, evaluated on the appropriate 3-dimensional slice (a spatial 2-torus times
   the period, or the gap's return map), NOT the full 4-manifold.

So AF3 must build a `pi_3`-type (3-dimensional-domain) winding per quasienergy
gap, and AF4's balance must read (per sector):

  net Weyl chirality in the `0` sector  and  net Weyl chirality in the `pi` sector
  are separately fixed by the two dynamical gap windings,

with the anomaly showing up as a NONZERO net chirality in a sector compensated by
the gap winding - NOT as a single 4D integer.

## Acceptance bar I will hold AF2/AF3/AF4 to (pre-registered)

- **AF2 (Weyl charge):** ACCEPT only if the local orientation charge is identified
  with (or provably equals) the `S^2`-enclosing Chern/monopole charge, with the
  Pauli/Dirac and momentum-orientation conventions displayed. A bare
  `sign det(tangent)` without the enclosing-surface tie-in is a proxy, not the
  chirality - I will flag it as scope-limited (a local sign witness), not the
  Weyl charge.
- **AF3 (winding):** ACCEPT only if the invariant is a `pi_3`-type
  (3-dimensional-domain) winding per quasienergy gap. REJECT / REVISE any "winding
  over `(q_x,q_y,q_z,t)`" that is really a 4-manifold degree - it is `pi_4(U)=0`
  and vacuous. The finite combinatorial version must triangulate a 3-dimensional
  parameter cycle, not a 4-cell, or must be a relative/gap invariant.
- **AF4 (balance):** ACCEPT only if BOTH the `0` and `pi` sectors are counted
  separately (Umer et al.: both host Weyl points, possibly momentum-close - a
  census trap identical to the `Strict3Plus1Frontier` 0-only error), and the
  balance relates per-sector net chirality to the per-gap dynamical winding. A
  single-integer "sum of charges = winding" that silently merges the sectors, or
  that uses the vacuous 4D winding, is the failure mode - I will REVISE it.

## Null-support gate (NS-1) restated with the corrected invariant

The decisive Null-Edge gate (AF5) is unchanged in spirit but sharper: can a
schedule of PRIMITIVE NULL shifts + on-site turns realize a nonzero per-gap
dynamical `pi_3` winding (not a 4D winding)? KILL if every primitive-null
factorization gives zero dynamical gap winding in both sectors. This is the
make-or-break; the corrected invariant just tells us WHICH integer to compute on
the null-factorized schedule.

## Provenance to add to the reference set

- Umer, Bomantara, Gong, arXiv:2009.09189, PRB 103 094309 (2021) - dynamical
  winding distinguishing 0 vs pi Floquet Weyl nodes; the AF3/AF4 invariant model.
  Recommend adding to Zotero/Neo4j alongside 1806.06868 / 2006.04204 / 1212.3324.
  Clean-room the invariant from its mathematical definition; do not copy code.

## One-line summary for codex

Do not build AF3 as a 4D `(q,t)` winding (that is `pi_4(U)=0`, vacuous, and would
make AF4 re-derive the static no-go); build it as a per-quasienergy-gap
`pi_3`-type dynamical winding with the 0 and pi sectors counted separately, and
tie AF2's sign to the `S^2`-enclosing chirality.
