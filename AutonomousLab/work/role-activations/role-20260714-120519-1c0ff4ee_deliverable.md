# Educator brief - "A one-handed edge, and how to make its mirror reappear" (DomainWallWeyl)

- Model/role: claude / Educator (solo mode)
- Result: `9eb52ec3` DomainWallWeyl (refill harvest, reviewed APPROVE 2026-07-14).
- Contract: one result, accessible explanation + evidence-grade map + visual plan
  + analogy boundaries + formal anchors.

## 1. The idea in plain language

Take a short chain of sites where a particle can only hop between neighbours, and
give it a "domain wall" - a spot where the hopping pattern flips. It is a
long-known fact that such a wall can trap a special state right at its edge: a
zero-energy mode that sits on the boundary and decays into the bulk.

The subtle question our result answers exactly: does that trapped mode come ALONE,
or with a mirror twin of opposite "handedness" (chirality)? Nature usually insists
on pairs (the fermion-doubling rule). Here, on the smallest honest 3-site wall, we
prove the trapped mode is a SINGLE unpaired left-hander: there is exactly one
zero-mode, its chirality is `+1`, and the opposite-chirality space is provably
EMPTY. The net "handedness charge" is `1 - 0 = 1`, not zero.

Why does it dodge the pairing rule? Because the wall has an odd number of sites,
its two sublattices (odd vs even sites) are IMBALANCED, and a zero-mode has to live
on the bigger sublattice. That imbalance is a counting (index) effect - it forces a
lone survivor.

The honest control that proves this is not a trick: take instead a balanced ring
(even sites, equal sublattices). Now the SAME construction gives TWO zero-modes,
one of each handedness - a mirror pair, net charge `0`. So rebalancing the
sublattices makes the mirror reappear. The single hander was earned by the
imbalance, not smuggled in.

## 2. Why it matters (one sentence)

A single "handed" edge mode with no mirror is exactly the kind of object the whole
flagship is chasing (a single Weyl fermion) - and here we see the *mechanism*
(sublattice imbalance / index) that can produce one, in a fully finite,
kernel-checked toy.

## 3. Evidence-grade map

| Claim (as heard) | Proved statement | Grade |
| --- | --- | --- |
| "single unpaired hander" | `finite_wall_single_species`: `dim ker+ =1, dim ker- =0, net =1` | M (kernel) |
| "the mirror is empty" | `chiralKerMinus = bot` | M |
| "rebalancing brings the mirror back" | `balanced_ring_mirror_pair`: `dim +/- =1,1, net =0` | M (control) |
| "the edge carries the Weyl symbol" | `weyl_restriction`: boundary sector `= k.sigma` | M |
| "there's a real gap above it" | `complement_gap`: `H^2 = 5` on `v _|_ w` | M |

All guard-pinned to the standard three axioms; independently rebuilt (EXIT=0).

## 4. Visual plan (one figure)

- Panel A: a 3-bead chain with a flipped bond (the wall); a glowing bead at the
  left edge labelled "single +1 mode", weight halving into the bulk (ratio 1/2).
- Panel B: same chain, a "handedness meter" reading `+1` and a greyed-out empty
  slot for the `-1` partner ("mirror sector = empty").
- Panel C: a 4-bead RING (balanced); now TWO glowing modes, one `+1` one `-1`, the
  meter reading net `0` ("rebalance -> mirror pair returns").
- Researcher overlay: label the sublattice grading `Gamma = diag(1,-1,1)` and the
  net charge as `Tr` over the zero-energy space = the finite index.

## 5. Analogy boundaries (where the story stops)

- This is a FINITE, STATIC linear-algebra fact about zero-modes of one fixed
  Hermitian matrix. It is NOT a dynamical (quantum-walk/Floquet) statement, NOT a
  continuum Dirac/Weyl operator, NOT a thermodynamic bulk-edge correspondence, NOT
  gauge-coupled, and NOT the HNU walk. The module says all of this explicitly.
- "Single Weyl" here means the boundary SECTOR carries the `k.sigma` symbol with a
  single unpaired chiral zero-mode - a finite index effect, not a physical
  particle.
- It is a *cousin* of the anomalous-Floquet route, not a substitute for the Gate-1
  half-space HNU determination (still running) - that one tests the SIGNED single
  mode of the actual driven walk.

## 6. Formal anchors

`DomainWallWeyl.finite_wall_single_species`, `.balanced_ring_mirror_pair`,
`.weyl_restriction`, `.complement_gap`, grading `Gamma3_sq`/`chiral_symmetry`.
Provenance: Aristotle job `9eb52ec3`; review
`AutonomousLab/reviews/CLAUDE_REVIEW_DomainWallSingleSpecies_2026-07-14.md`.

## 7. Open-question label

A verified finite STATIC index toy showing a single unpaired chiral edge mode via
sublattice imbalance, with the mirror provably restorable by rebalancing. Whether
the *driven, unitary* HNU boundary wears the same lone mode - with a quiet interior
- is the live Gate-1 question, not settled here.
