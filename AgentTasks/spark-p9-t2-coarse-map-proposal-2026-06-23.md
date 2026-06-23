# Proposal: P9 T2 coarse-map stability/equivariance witness

## 1) Scientific motivation

The current `T1` witness (in `NullEdgeP9DiamondLocalSeparation`) already shows a local observer-channel readout can distinguish two causal relations that agree on global marginals.  `T2` is the missing falsification guard: the distinction must survive a **pre-specified coarse map** that will also be used in pilots (`Scripts/p9/pilot.py` and spectral/ Alexandrov coarse-channel experiments).  Otherwise the separation can be an artifact of a hand-tuned readout or block alignment.

## 2) Candidate finite Lean target designs (standalone package)

### Target A: pre-specified coarse map preserves `T1` separation

Create a small finite package that reuses the `relA/relB` witness and adds an explicit coarse map `c : Fin 6 -> Fin 3` (or `Fin 4`, depending on chosen coarse class).

Concrete theorem design:

- `coarseRel_diamond_localIntervalSignature_0_4_ne`
  - Define `R.coarse := fun x y => exists a b, c a = x /\ c b = y /\ R a b`.
  - Prove `localIntervalSignature (coarse relA) (c 0) (c 4) 1 != localIntervalSignature (coarse relB) (c 0) (c 4) 1`.
  - This gives the direct `T2` separation statement: coarse pre-processing does not erase the T1 diamond-local discriminator.

- Optional support lemma in same file:
  - `coarse_relA_relB_diamCard_eq` showing `diamondCard (coarse relA) (c 0) (c 4) = diamondCard (coarse relB) (c 0) (c 4)` and same global degree-family side conditions under `c`.

### Target B: equivariance/stability lemma for intrinsic symmetries of the coarse map

Formalize a finite symmetry/compatibility condition for `c` (partition-preserving equivalence):

- `coarseMap_equivariant_localIntervalSignature`
  - For any relation isomorphism/endpoint-relabelling `pi` with `c after pi = c`, show
    `localIntervalSignature (coarse (relComp relA pi) x y) = localIntervalSignature (coarse relA (c x) (c y))`.
  - Useful to show separation is tied to coarse geometry, not vertex labels.

## 3) Why these targets are stronger than cheap `iso-hist` and still feasible

- Stronger than cheap iso-hist:
  - Cheap witness uses marginals/joint summaries only; T1 adds local interval structure on a fixed diamond; T2 adds **stability under an explicit coarse map**.
  - This blocks vacuous "data-fitting" separations and directly addresses the pipeline concern already observed in block-offset pilot reports (offset-dependent separation/aliasing).
- Feasible:
  - Relations are still finite (`Fin 6`), so the heavy algebra is controlled by arithmetic on finite sets, not generic graph theory.
  - The target statements mirror existing `Core.lean` style (`decide`-friendly finite signatures), so a compact standalone Aristotle package is realistic.
  - Equivariance can be proven with explicit hypotheses (`c after pi = c`) and `simp`/`finset` rewriting.

## 4) Failure modes / overly artificial designs

- Coarse map is too hand-tuned for this one witness (reverse-engineered to force separation).
- Partition collapses the critical diamond structure, so separation disappears trivially (artifact, not stability).
- Map allows offset-dependent behavior (sensitive to indexing/scrambling) and thus fails an intrinsic-coarse-map interpretation.
- Equivariance statement is too strong (e.g., requiring full symmetry group) and excludes realistic coarse observables.
- Noise class is absent: if map is not combined with a geometry-agnostic external-noise class, T2 can be too close to T1 with cosmetic framing.

## 5) Recommended next Aristotle job

**Name**: `null-edge-p9-diamond-local-t2-coarse-map-stability-20260623`

**Recommended theorem list**:
1. `coarseRel_diamond_localIntervalSignature_0_4_ne`
2. `coarse_relA_relB_diamondSideConditions`
3. `coarseMap_equivariant_localIntervalSignature`
4. `coarseMap_stability_under_block_equiv`
5. (Optional) `coarse_localInterval_signature_eq_of_isomorphic_relabel`
