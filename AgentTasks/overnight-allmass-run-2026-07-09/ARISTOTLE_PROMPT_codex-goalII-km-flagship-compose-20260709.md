# codex-goalII-km-flagship-compose-20260709

You are Aristotle working in the `PhysicsSM` Lean project.

## Goal

Create and prove a new module:

```text
PhysicsSM/Draft/NullEdge/KMFlagship.lean
```

This is the Goal II flagship composition step. It should compose the landed
finite KM modules:

- `PhysicsSM.Draft.NullEdge.KMPhaseCounting`
- `PhysicsSM.Draft.NullEdge.FiniteKMCP`
- `PhysicsSM.Draft.NullEdge.IncidenceCorank`

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/KMFlagship.lean
```

## Intended theorem pieces

Please prove as many of these as cleanly possible, adding small helper lemmas
if useful:

1. A theorem identifying the arithmetic CP count with the incidence corank:

```lean
theorem physicalPhases_eq_incidence_corank
    (K : Type*) [Field K] (N : Nat) (hN : 1 <= N) :
    FiniteKM.physicalPhases N =
      Module.finrank K (IncidenceCorank.Edge N -> K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K N))
```

2. A theorem that the general corank is exactly the standard physical phase
count:

```lean
theorem incidence_corank_eq_physical_count
    (K : Type*) [Field K] (N : Nat) (hN : 1 <= N) :
    Module.finrank K (IncidenceCorank.Edge N -> K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K N))
      = FiniteKM.physicalPhases N
```

3. Sharp low-N fixtures:

```lean
theorem no_physical_phase_two :
    FiniteKM.physicalPhases 2 = 0

theorem exactly_one_physical_phase_three :
    FiniteKM.physicalPhases 3 = 1

theorem incidence_corank_two_zero (K : Type*) [Field K] :
    Module.finrank K (IncidenceCorank.Edge 2 -> K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K 2)) = 0

theorem incidence_corank_three_one (K : Type*) [Field K] :
    Module.finrank K (IncidenceCorank.Edge 3 -> K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K 3)) = 1
```

4. A compositional Goal II summary theorem: N=2 has no physical phase and every
unitary 2x2 is rephasable to real; N=3 has exactly one physical phase and a
nonzero Jarlskog witness.

Use a proposition shaped like this if it typechecks naturally:

```lean
theorem goalII_lowN_summary :
    FiniteKM.physicalPhases 2 = 0
      /\ (forall V : Matrix (Fin 2) (Fin 2) Complex, V.conjTranspose * V = 1 ->
            exists dL dR : Fin 2 -> Complex,
              FiniteKM.IsPhase dL /\ FiniteKM.IsPhase dR /\
                forall i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
      /\ FiniteKM.physicalPhases 3 = 1
      /\ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
      /\ FiniteKM.jarlskog FiniteKM.Vwitness != 0
```

## Claim discipline

Do not claim a full global unitary normal form unless you prove it. This module
is allowed to say it closes the linearized incidence/corank phase-count theorem
and composes the low-N no-go/witness. If a target is malformed, return a
corrected theorem shape and explain why.

Add build-enforced `#guard_msgs ... #print axioms` pins for the headline
theorems. Do not introduce new global assumptions.
