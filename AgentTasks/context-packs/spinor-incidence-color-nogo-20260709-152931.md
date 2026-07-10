# Aristotle semantic context pack

Generated: 2026-07-09T15:29:38
Query: `spinor incidence SL2 wedge determinant mass invariance color triplet dimension no go internal charge factor`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-spinor-geometry-aristotle-2026-06-21.md` [Why this target]

Score: `0.812`

```text
## Why this target

The finite Pluecker identity says determinant mass is the sum of squared
pairwise spinor wedges.  The next physics-facing layer is to prove that this
quantity is the projective spinor angular spread and is invariant under the
proper spinor frame changes.

The key upgrades are:

- the two-spinor Lagrange identity;
- covariance of the spinor wedge under `GL(2,C)`;
- invariance of the finite Pluecker mass under determinant-one spinor changes;
- chart-level matching with the two-twistor/massive spinor-helicity mass.
```

### 2. `AgentTasks/context-packs/null-edge-generation-blindness-port-20260621-175331.md` [Why this target]

Score: `0.809`

```text
## Why this target

The finite Pluecker identity says determinant mass is the sum of squared
pairwise spinor wedges.  The next physics-facing layer is to prove that this
quantity is the projective spinor angular spread and is invariant under the
proper spinor frame changes.

The key upgrades are:

- the two-spinor Lagrange identity;
- covariance of the spinor wedge under `GL(2,C)`;
- invariance of the finite Pluecker mass under determinant-one spinor changes;
- chart-level matching with the two-twistor/massive spinor-helicity mass.
```
```

### 3. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [spinorAction]

Score: `0.809`

```text
def spinorAction (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : CSpinor) : CSpinor :=
  A.mulVec psi

/--
The spinor wedge is a determinant-relative invariant for the defining
`GL(2,C)` action.
-/
```

### 4. `Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` [Proof F: two-twistor and massive spinor-helicity matching]

Score: `0.807`

```text
## Proof F: two-twistor and massive spinor-helicity matching

In massive spinor-helicity notation, a real massive momentum can be written
as a sum of two null spinor outer products:

```text
P_{A A'} = lambda_A^1 conjugate(lambda_{A'}^1)
         + lambda_A^2 conjugate(lambda_{A'}^2).
```

The determinant is therefore

```text
det(P) = |lambda^1 wedge lambda^2|^2.
```

This is exactly the two-edge Pluecker mass identity already proved in Lean.

The little-group `SU(2)` acts on the pair index:

```text
lambda^I |-> lambda^J U_J^I.
```

The wedge of the two columns changes by `det(U)`, which is `1` for `SU(2)`.
Thus the two-edge Pluecker mass is little-group invariant.

Two-twistor models add incidence data, but their spinor momentum chart has the
same algebraic core.  The first trusted theorem should not claim full twistor
geometry.  It should state the chart-level equivalence:

```text
two-twistor massive momentum determinant
  =
two-null-spinor Pluecker mass.
```

Recommended Lean scope:

```lean
structure SpinorChartTwoTwistor where
  left : CSpinor
  right : CSpinor

def twoTwistorChartMomentum (Z : SpinorChartTwoTwistor) :=
  rankOneHermitian Z.left + rankOneHermitian Z.right

theorem two_twistor_chart_mass_eq_plucker
    (Z : SpinorChartTwoTwistor) :
    (twoTwistorChartMomentum Z).det =
      complexAbsSq (spinorWedge Z.left Z.right)
```

This theorem is mostly repackaging, but the repackaging matters: it is the
formal bridge from null-edge bundles to the twistor and massive-amplitudes
literature.
```

### 5. `PhysicsSM/Draft/TwistorPluckerMass.lean` [two_twistor_mass_invariant_eq_plucker]

Score: `0.806`

```text
theorem two_twistor_mass_invariant_eq_plucker
    (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W =
      complexAbsSq (spinorWedge Z.pi W.pi) := rfl

/--
The determinant mass of the visible two-twistor momentum equals the squared
infinity-twistor spinor pairing.
-/
```

### 6. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [two_twistor_mass_invariant_eq_plucker]

Score: `0.806`

```text
theorem two_twistor_mass_invariant_eq_plucker
    (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W =
      complexAbsSq (spinorWedge Z.pi W.pi) := rfl

/--
The determinant mass of the visible two-twistor momentum equals the squared
infinity-twistor spinor pairing.
-/
```

### 7. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [finBundleMomentum_det_sl2_invariant]

Score: `0.804`

```text
theorem finBundleMomentum_det_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A.det = 1) (psi : Fin n -> CSpinor) :
    (finBundleMomentum (fun i => spinorAction A (psi i))).det =
      (finBundleMomentum psi).det := by
  calc
    (finBundleMomentum (fun i => spinorAction A (psi i))).det
        = finPairwisePluckerMass (fun i => spinorAction A (psi i)) :=
          fin_bundle_plucker_mass_identity _
    _ = finPairwisePluckerMass psi :=
          finPairwisePluckerMass_sl2_invariant A hA psi
    _ = (finBundleMomentum psi).det :=
          (fin_bundle_plucker_mass_identity psi).symm

/-! ## Narrow two-twistor chart matching -/

/--
The spinor-momentum part of a two-twistor chart.  Incidence data is
intentionally omitted here; the target is only the mass identity in the spinor
chart.
-/
```

### 8. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [finPairwisePluckerMass_sl2_invariant]

Score: `0.802`

```text
theorem finPairwisePluckerMass_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A.det = 1) (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass (fun i => spinorAction A (psi i)) =
      finPairwisePluckerMass psi := by
  refine Finset.sum_congr rfl fun p _ => ?_
  rw [spinorWedge_spinorAction, hA, one_mul]

/--
The determinant mass of a finite visible null-spinor bundle is invariant under
determinant-one spinor changes of frame.
-/
```

## Scoped paper hits

### 1. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.780`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.

### 2. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.764`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 3. Two-twistor particle models and free massive higher spin fields

Score: `0.759`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.752`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. From Twistor-Particle Models to Massive Amplitudes

Score: `0.746`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087
