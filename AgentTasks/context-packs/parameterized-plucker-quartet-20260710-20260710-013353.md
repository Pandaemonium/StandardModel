# Aristotle semantic context pack

Generated: 2026-07-10T01:34:28
Query: `parameterized nondegenerate Hodge quartet class cost equals Pluecker mass squared family`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [complexAbsSq_spinorWedge_comm]

Score: `0.809`

```text
theorem complexAbsSq_spinorWedge_comm (psi phi : CSpinor) :
    complexAbsSq (spinorWedge psi phi) =
      complexAbsSq (spinorWedge phi psi) := by
  simp only [complexAbsSq, spinorWedge, map_sub, map_mul]
  ring

/--
The canonical visible pairwise Pluecker mass is invariant under any permutation
of the hidden/generation index set.
-/
```

### 2. `PhysicsSM/Spinor/PluckerMass.lean` [finPairwisePluckerMassReal]

Score: `0.804`

```text
def finPairwisePluckerMassReal {n : Nat} (psi : Fin n -> CSpinor) : ℝ :=
  ∑ p ∈ finPairIndexSet n,
    Complex.normSq (spinorWedge (psi p.1) (psi p.2))

/-- The complex-valued Pluecker mass is the coercion of the real-valued one. -/
```

### 3. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [to]

Score: `0.801`

```text
theorem to the canonical trusted Pluecker definitions in
`PhysicsSM.Spinor.PluckerMass`.

The mathematical claim is deliberately narrow: relabeling the finite visible
spinor family by a permutation does not change the visible pairwise Pluecker
mass. This does not assert anything about nonorthogonal hidden Gram data.
-/
```

### 4. `PhysicsSM/Draft/NullEdgePluckerCelestialBridge.lean` [wedge_normSq_eq_energy_dot_defect]

Score: `0.796`

```text
theorem wedge_normSq_eq_energy_dot_defect (psi phi : CSpinor) :
    Complex.normSq (spinorWedge psi phi)
      = (spinorEnergy psi * spinorEnergy phi - dot (blochVector psi) (blochVector phi)) / 2 := by
  unfold spinorWedge spinorEnergy blochVector dot;
  norm_num [ Complex.normSq, Fin.sum_univ_succ ] ; ring

/-
Bundle bridge: the real pairwise Pluecker mass equals the celestial
moment-map mass square `(E^2 - |C|^2) / 4`.
-/
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Trusted Pluecker mass layer]

Score: `0.796`

```text
### Trusted Pluecker mass layer

`PhysicsSM.Spinor.PluckerMass` proves the finite determinant identity that
turns the null-edge mass slogan into algebra:

- two-edge mass is the squared wedge;
- finite bundle mass is the sum of all pairwise squared wedges;
- the real Pluecker mass functional is nonnegative;
- zero mass is equivalent to a common spinor direction.

This module is trusted and kernel-clean. It should be treated as a central anchor
for future twistor, momentum-bundle, and publication work.
```

### 6. `PhysicsSM/Draft/NullEdgeGenerationBlindnessPort.lean` [finPairwisePluckerMass_perm]

Score: `0.794`

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

### 7. `Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` [Executive advance]

Score: `0.793`

```text
## Executive advance

The next layer of the program should not merely prove the finite Pluecker
identity.  It should prove that the identity is the Lorentz/spinor-helicity
mass functional and that it is invariant under the correct spinor symmetries.

The highest-value theorem cluster is now:

1. full finite Pluecker mass by Cauchy-Binet;
2. positivity/equality: mass zero iff every Pluecker coordinate vanishes;
3. projective collinearity, with zero-spinor edge cases handled explicitly;
4. the two-spinor Lagrange identity
   `|<psi,phi>|^2 + |psi wedge phi|^2 = |psi|^2 |phi|^2`;
5. `SL(2,C)` covariance of the wedge and invariance of the mass functional;
6. two-twistor or massive spinor-helicity chart matching;
7. non-Abelian causal-diamond gauge covariance, with class functions giving
   true gauge invariants.

This turns the slogan

```text
mass is Pluecker spread of null edges
```

into a robust theorem package:

```text
mass is the invariant, nonnegative, pairwise Fubini-Study spread of a finite
bundle of visible null spinors.
```
```

### 8. `PhysicsSM/Draft/NullEdgeCoreAristotle.lean` [chainBoundary_comp_self_eq_zero]

Score: `0.792`

```text
theorem chainBoundary_comp_self_eq_zero {V : Type*} (c : Chain V) :
    chainBoundary (chainBoundary c) = 0 := by
  convert chainBoundary_sum c.support ( fun s => c s • simplexBoundary s ) using 1;
  exact Eq.symm ( Finset.sum_eq_zero fun x hx => by rw [ chainBoundary_zsmul, chainBoundary_simplexBoundary_eq_zero, smul_zero ] )

/-! ## Target D: three-edge Pluecker mass -/

/-- The Hermitian momentum matrix of a three-edge visible bundle. -/
```

## Scoped paper hits

### 1. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.740`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 2. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.734`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 3. Connections on non-abelian Gerbes and their Holonomy

Score: `0.724`
URL: http://arxiv.org/abs/0808.1923

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.715`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.715`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728
