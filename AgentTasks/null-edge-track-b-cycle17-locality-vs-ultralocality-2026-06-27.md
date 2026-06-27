# Track B cycle 17: locality is an explicit obstruction clause, not a background assumption

Date: 2026-06-27
Cycle: 17
Track: B - obstruction calculus / Gate C release audits

## Trigger

Cycle 17 literature search used the full-text chunk query:

```text
projected overlap branch classifier locality gauge covariance sign kernel chiral lattice
```

The strongest recurring warning was that Ginsparg-Wilson, overlap, and sign-function routes should not be treated as ultralocal finite-range mechanisms by default. They can be the correct chiral-fermion escape hatch, but locality has to be carried as an explicit theorem obligation or certified hypothesis.

## Program implication

Gate C should distinguish three different claims that are easy to blur:

1. finite-range or ultralocal release,
2. controlled quasi-local release,
3. merely formal spectral/projector selection.

The current null-edge C1 route should not silently promote item 3 to item 1. If a projected-overlap, sign-function, branch-involution, or domain-wall-like construction is proposed, it needs a locality certificate alongside the chirality, gap, anomaly, and Krein/spectral-health audits.

## Named failure mode

**Ultralocality overclaim failure.** A branch selector `Pi_phys(q)` or sign-function release is presented as if it were a finite-range local lattice operator, while the available construction only supplies a formal momentum-space projector or, at best, a quasi-local kernel with decay assumptions.

## Finite theorem target

Introduce a small draft API for release locality certificates:

```lean
structure LocalityCertificate (V I : Type) where
  kernel : I -> I -> V
  supportRadius : Option Nat
  decayEnvelope : Option (Nat -> Real)
```

Then require every proposed C1 release datum to carry one of:

1. `supportRadius = some R`, for a finite-range/ultralocal certificate,
2. a monotone decay envelope with explicit constants, for quasi-locality,
3. an explicit `none/none` marker proving that the construction is only formal and cannot yet be counted as a physical release.

A useful near-term no-go statement would be: a Gate C release record with no locality certificate cannot satisfy the physical-release audit, even if it has a formal chiral branch projector.

## Claim boundary

This note does not claim a Gate C solution. It only sharpens the release audit: locality is not background ambiance; it is one of the load-bearing beams.
