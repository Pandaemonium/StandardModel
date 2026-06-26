# Aristotle semantic context pack

Generated: 2026-06-25T16:17:39
Query: `Fock Bell direction marginal equivariance deprecated total mass preservation duplicate names realPos unification finite cutoff`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [visiblePluckerMass_generationBlind]

Score: `0.753`

```text
theorem visiblePluckerMass_generationBlind {n : Nat}
    (psi phi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n))
    (h : phi = fun i => psi (e i)) :
    finPairwisePluckerMass phi = finPairwisePluckerMass psi := by
  rw [h]
  exact finPairwisePluckerMass_perm psi e

end PhysicsSM.Draft.NullEdgeGenerationBlindnessPort

end
```

### 2. `PhysicsSM/Draft/NullEdgeP9BoundarySource.lean` [boundaryExact_source_eq_zero]

Score: `0.749`

```text
theorem boundaryExact_source_eq_zero
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (boundarySource D a) test = 0 := by
  rw [boundarySource_pairing_eq_boundary_potential_pairing]
  unfold BulkClosed at hclosed
  rw [hclosed]
  simp [dot]

/--
Ward-style name for the same finite conservation identity.

Boundary-generated defect/source bookkeeping has zero response against every
bulk test whose adjoint divergence vanishes. This is the exact finite theorem
the P9 plan calls `eventConservation_kills_defect_source`.
-/
```

### 3. `PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean` [visiblePluckerMass_generationBlind]

Score: `0.749`

```text
theorem visiblePluckerMass_generationBlind {n : Nat}
    (psi phi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n))
    (h : phi = fun i => psi (e i)) :
    finPairwisePluckerMass phi = finPairwisePluckerMass psi := by
  rw [ h, finPairwisePluckerMass_perm ]

end NullEdgeGenerationBlindnessCore

end
```

### 4. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [finPairwisePluckerMass_perm]

Score: `0.747`

```text
theorem finPairwisePluckerMass_perm {n : Nat}
    (psi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n)) :
    finPairwisePluckerMass (fun i => psi (e i)) =
      finPairwisePluckerMass psi := by
  rw [← fin_bundle_plucker_mass_identity, ← fin_bundle_plucker_mass_identity]
  congr 1
  unfold finBundleMomentum
  exact Equiv.sum_comp e (fun i => rankOneHermitian (psi i))

/--
Generation-blindness wrapper for the canonical trusted Pluecker mass.
-/
```

### 5. `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean` [FureyRealizesOneGenerationPackage]

Score: `0.746`

```text
/--
**Main theorem**: the Furey one-generation realization package is satisfied.

Every field is proved by delegation to an already kernel-checked theorem
from the bridge modules. No new coordinate computation is performed.
-/
```

## Scoped paper hits

No paper hits returned.
