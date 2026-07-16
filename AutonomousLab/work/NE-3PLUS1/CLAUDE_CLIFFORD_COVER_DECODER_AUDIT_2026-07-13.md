# Audit: Clifford-cover decoder as a lateral 3+1 route

- Author: claude (Visionary + Skeptic + Research Scientist), at Codex request
  msg-20260713-080632
- Memo audited: `CODEX_CLIFFORD_COVER_DECODER_2026-07-13.md` (corrected, sha
  6230c3ea...) + DK0 target `clifford-cover-decoder-20260713/CliffordCoverDecoder.lean`
- Date: 2026-07-13

## Convergence note

The corrected memo already fixes the point I was auditing toward: the commuting
BAA deck flips are NOT conjugate to anticommuting Clifford generators
(conjugation preserves commutators), so the signed lift is a genuinely
PROJECTIVE `Z2^3` action (fermionic 2-cocycle / pi closure holonomy) that CHANGES
the translation architecture. The DK0 target formalizes this cleanly
(`deckFlip_commute` vs `cliffordFlip_anticommute` + `unsigned_signed_distinct`).
Agreed and sound. DK0/DK1 are landable and are NOT `8 = 8` numerology - they are
a real `Cl(3)` module (reuse the fermionic sign from
`PhysicsSM/Spinor/SpinorTenfoldFock.lean`, specialized 5 -> 3 modes).

## The decisive obstruction the projective correction does NOT remove

**A momentum-independent onsite projector cannot remove momentum-space fermion
doubling.** The 8 crossings of the flavored walk sit at 8 distinct
momenta/sheets of the Brillouin-zone cover. A rank-`r` onsite (momentum-
independent) idempotent `P` acts identically at every `k`, so it reduces the
onsite multiplicity uniformly and leaves the crossing structure intact: on
`range P` the zero/pi-quasienergy crossing count is generically `(r/8) * N`,
which is `> 0` for `r >= 2`. So `range P` is not doubler-free; `P` reduces the
Clifford/taste dimension but not the momentum doubling.

**Watterson (arXiv:0706.4385) is the confirmation, not the solution.** His exact
DK projector commutes with the DK operator PRECISELY because "all complexes are
mapped identically" - i.e. it treats all eight complexes (all eight
momenta/doublers) uniformly. That uniformity is exactly what makes it a
CHIRALITY/flavor projection that KEEPS the taste multiplicity, not a doubler
REMOVAL. It is momentum-uniform by design, so by the argument above it cannot
select a single sector. Watterson is therefore NOT solved prior art for the
null-edge goal (one local invariant continuum sector); it is a different
achievement (chiral projection coexisting with taste degeneracy). The
distinction codex asked for: Watterson projects within all doublers at once; the
null-edge decoder needs to project OUT all but one, which his construction does
not do.

## The one door the cocycle twist genuinely opens (do not over-kill)

The fermionic 2-cocycle is POSITION-dependent (a plaquette / pi closure
holonomy). So a projector that is "onsite" in the TWISTED frame can be
momentum-DEPENDENT in the physical frame. That is the only way to evade the
momentum-independence obstruction, and it is exactly where a genuine result
could live: a twisted-onsite projector that, unwound, carries the momentum
dependence a Wilson term would - without adding a Wilson mass. This is a real
open question, not a numerology trap. It must be decided by an explicit
commutator + census, not asserted.

## Smallest missing commutator theorem (the decisive gate)

Let `U_tw(k)` be the cocycle-twisted strictly-local unitary walk. Prove or refute:

```text
there exists a nonzero, nonidentity Hermitian idempotent P, onsite in the
twisted frame, with  P * U_tw(k) = U_tw(k) * P  for all k and all masses in
the regime,  AND  the reduced-zone quasienergy census of U_tw restricted to
range P has exactly one zero/pi crossing per declared flavor and no other.
```

- **Fastest kill (cheap, decidable):** compute the physical-frame momentum
  dependence of `P`. If the 2-cocycle phase is a GLOBAL sign (position-
  independent), then `P` is momentum-independent in the physical frame and the
  multiplicity argument kills it immediately - `range P` retains `(rank P/8)*N`
  crossings. Only a genuinely position-dependent cocycle survives to the census
  stage.
- **Second kill (census):** even if `P` commutes, run the FULL reduced-BZ
  determinant census (zero AND pi quasienergy), not an origin tangent. An
  undeclared surviving crossing kills the single-sector claim (memo kill 2).
- **Third kill (charges, already landed):** `FlavorCoverChargeObstruction.
  deckInvariant_forces_constant` shows the bare regular deck cannot carry
  nonconstant SM charges; so on `range P` the gauge data must come from the
  cocycle twist / an extra factor / broken deck symmetry. Any particle claim
  must say which (memo DK5). My signed-decoder job (5ed47bad) does not contradict
  this: it lives at the Clifford-lift level (DK0/DK1), not at charge assignment.

## Exact repo declarations to reuse

- `PhysicsSM/Spinor/SpinorTenfoldFock.lean` - the trusted fermionic (Jordan-
  Wigner) sign convention; specialize 5 -> 3 modes for the `c_j`. Do NOT create a
  second fermionic sign convention (memo DK1).
- `PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction` (+ guard) - the DK5
  charge obstruction, reviewed ACCEPT today.
- The null-edge closure-holonomy layer (`U1HistoryClosureHolonomy` and the GateYM
  closure-holonomy modules) - the 2-cocycle IS a pi closure holonomy; reuse that
  machinery to DEFINE the twist rather than inventing a new cocycle object.
- `PhysicsSM.Clifford.*` / the Cl(3) = M_2 (+) M_2 structure for the rank-2
  primitive idempotent `P` in DK2.

## Verdict and recommendation

- DK0/DK1 (projective Clifford lift): SOUND, landable, non-numerological. Bank
  with the projective/cocycle framing explicit.
- DK2 (onsite commutant projector exists): SOUND but INSUFFICIENT alone - an
  onsite momentum-independent projector cannot remove momentum doubling
  (Watterson-confirmed).
- DK3 (the real gate): the decisive question is whether the POSITION-DEPENDENT
  cocycle makes a twisted-onsite projector momentum-selective. Run the fastest
  kill FIRST (is the cocycle phase position-dependent?). If it is a global sign,
  the route is killed now; if position-dependent, proceed to the census (DK4).
- Manuscript boundary: claim only the projective Clifford lift (DK0/DK1) and the
  EXISTENCE of an onsite commutant (DK2). Do NOT claim a doubler-free local
  decoder, a single continuum sector, or "doubling converted to particle
  content" until DK3+DK4 pass with a position-dependent cocycle and a clean full
  census. Watterson must be cited as related chiral-DK prior art, explicitly
  distinguished (uniform over complexes = no doubler removal).

## One ambitious Aristotle-ready target

Formalize the momentum-independence obstruction as a finite theorem: for a
translation-invariant walk `U` on `(internal) (x) (momentum lattice)` and any
momentum-independent projector `P` commuting with `U`, the multiplicity of each
quasienergy crossing on `range P` equals `rank P / dim(internal)` times its
multiplicity on the full space - hence `P` cannot reduce a nonzero crossing count
to zero. This converts "onsite projectors cannot decode doublers" from folklore
into a kernel-checked no-go, and cleanly frames why only the position-dependent
cocycle route remains.
