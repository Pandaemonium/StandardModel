# Aristotle audit/proof-design job: Q8 exponential clustering bridge

You are acting as a Lean/math formalization strategist for the Q8
strong-coupling exponential-clustering lane of a finite Yang-Mills draft
formalization.  Please audit the statement surface and return a concrete next
proof package plan.  A small Lean patch is welcome if you see an immediate
improvement, but the primary deliverable is an exact verdict and lemma DAG.

Formatting: ASCII only, LF line endings.  In prose, spell Lean escape-hatch
tokens with spaces (`s o r r y`, `a x i o m`, `a d m i t`, `o p a q u e`).

## Project context

This is Q8 of a four-day Yang-Mills / mass-gap run.  The KP lane currently has:

- Q6 `PolymerKPCriterion.lean`: finite `PolymerSystem` and `KPCondition`.
- Q6 `PolymerKPConclusion.lean`: ordered clusters, `ClusterCoeffData`,
  concrete `spanningTreeCount` / `ursellSum`, and named theorem targets
  `kp_cluster_summable`, `kp_convergence_bound`, and `kp_tail_bound`.
- Q7 `StrongCouplingPolymerMap.lean`: finite plaquette-polymer map layer with
  support-indexed labels, conservative overlap-or-touch incompatibility, and Z2
  weight identities.  It does not prove a volume-uniform KP theorem.

The hard Q6 metric tail theorem is not proved yet.  Therefore Q8 must not claim
unconditional exponential clustering.  The current Q8 file intentionally proves
only the final abstract bridge from an explicit tail bound plus an
observable-to-cluster comparison to exponential clustering.

## Target file

`PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean`

Target command:

```bash
lake env lean PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean
```

## Current Lean surface

The new file defines:

```lean
structure LocalObservableData (Gamma Obs : Type*) where
  anchor : Obs -> Gamma
  separation : Obs -> Obs -> Real
  separation_nonneg : forall A B, 0 <= separation A B
  connectedCorr : Obs -> Obs -> Complex
  prefactor : Obs -> Obs -> Real
  prefactor_nonneg : forall A B, 0 <= prefactor A B

def tailContribution
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) : Real :=
  tsum (fun X : {X : Cluster M.toPolymerSystem //
      X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
    |D.coeff X.1| * X.1.absWeight M.toPolymerSystem)

def HasExponentialClustering
    (L : LocalObservableData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) : Prop :=
  forall A B : Obs,
    ‖L.connectedCorr A B‖ <=
      amplitude A B * Real.exp (-(m * L.separation A B))

theorem hasExponentialClustering_of_tailContribution_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableData Gamma Obs)
    (m : Real)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          tailContribution M hdec D (L.anchor A) (L.separation A B)) :
    HasExponentialClustering L
      (fun A B => L.prefactor A B * M.energy (L.anchor A)) m
```

This theorem is kernel-checked from explicit hypotheses.  Its dependency
footprint is the standard `[propext, Classical.choice, Quot.sound]`, and it
does not depend on the parked Q6 proof bodies because `hTail` is explicit.

## Questions

1. Verdict: is this the right Q8 statement-freeze surface, or should the
   observable bridge use a different API?
2. Should `LocalObservableData.anchor : Obs -> Gamma` be generalized to a
   finite support `Obs -> Finset Gamma`, with the tail measured from every
   support polymer?  If yes, propose the exact Lean signature and the first
   bridge theorem.
3. Is the `tailContribution` subtype exactly aligned with
   `PolymerKPConclusion.Cluster.ReachesFrom`, or should Q8 use a two-support
   separation predicate instead of one anchor plus one separation number?
4. What should the next proof package be?
   - Prove a support-set version of the bridge?
   - Prove `hTail` from `kp_tail_bound` after Q6 closes?
   - Formalize a concrete plaquette-local observable bridge from Q7?
5. List any semantic risks or overclaims.  In particular, confirm that this
   file does not claim a physical transfer matrix, infinite volume, or
   unconditional mass gap.
6. If you recommend changes, return an edited
   `ExponentialClustering.lean` and explain each changed statement.

## Success criteria

- Keep the target file buildable.
- No new executable proof placeholders.
- No new `a x i o m`, `o p a q u e`, or u n s a f e code.
- Keep Q8 conditional unless the required Q6/Q7 hypotheses are explicit.
- Return a concise `ARISTOTLE_SUMMARY.md` with verdict, recommended API,
  next theorem names, and blockers.

This is a finite draft GateYM statement-layer job, not a continuum mass-gap
claim.
