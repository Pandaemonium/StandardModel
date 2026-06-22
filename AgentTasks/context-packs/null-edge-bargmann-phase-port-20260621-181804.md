# Aristotle semantic context pack

Generated: 2026-06-21T18:18:12
Query: `Bargmann phase port canonical PluckerMass spinorInner rankOneKetBra rankOneHermitian Lagrange identity normalized Plucker overlap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean` [normalized_plucker_eq_one_sub_overlap]

Score: `0.889`

```text
theorem normalized_plucker_eq_one_sub_overlap
    (psi phi : CSpinor)
    (hpsi : spinorNormSq psi = 1)
    (hphi : spinorNormSq phi = 1) :
    complexAbsSq (spinorWedge psi phi) =
      1 - complexAbsSq (spinorInner psi phi) := by
  have h := plucker_lagrange_identity psi phi
  rw [hpsi, hphi] at h
  linear_combination h

end PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore

end
```

### 2. `AgentTasks/null-edge-plucker-bargmann-phase-core-aristotle-2026-06-21.md` [Integration]

Score: `0.879`

```text
## Integration

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean
```

The module proves the two-spinor Lagrange identity, ket-bra trace and product
laws, rank-one projector multiplication, the Bargmann/Pancharatnam triple
trace, and the normalized Plucker/overlap complement identity.

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean
lake build PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean PhysicsSMDraft.lean
```
```

### 3. `PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean` [keeps]

Score: `0.867`

```text
import Mathlib

/-!
# Draft.NullEdgePluckerBargmannPhaseCore

Finite algebra for the complex phase companion to the Pluecker mass theorem.

The real Pluecker theorem keeps `|psi wedge phi|^2`.  This draft module
retains nearby first-order phase data: the two-spinor Lagrange identity, the
rank-one ket-bra contraction law, and the finite Bargmann/Pancharatnam triple
trace for spinor projectors.

Provenance: integrated from the focused Aristotle job
`null-edge-plucker-bargmann-phase-core-20260621`.
-/
```

### 4. `AgentTasks/null-edge-plucker-bargmann-phase-core-aristotle-2026-06-21.md` [Why this matters]

Score: `0.853`

```text
## Why this matters

The trusted Plucker mass theorem keeps the squared modulus of the wedge.  The
Dirac/operator critique says that squared invariants lose first-order data.
This target formalizes the nearby complex phase algebra: the Lagrange identity
relates Plucker spread to Hermitian overlap, while the Bargmann triple trace is
the finite Pancharatnam/Berry phase carrier for three spinor directions.
```

### 5. `PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean` [bargmannTripleTrace_rankOne]

Score: `0.839`

```text
theorem bargmannTripleTrace_rankOne
    (psi phi chi : CSpinor) :
    trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) =
      spinorInner psi phi * spinorInner phi chi * spinorInner chi psi := by
  unfold trace2 rankOneProjector rankOneKetBra spinorInner
  simp +decide [Fin.sum_univ_two, Matrix.mul_apply, Matrix.vecMulVec]
  ring!

/--
Normalized two-spinor corollary: for unit spinors, the Pluecker squared modulus
is the complement of the squared Hermitian overlap.  This is the finite
Fubini-Study/chordal-distance bridge used by the null-edge program.
-/
```

### 6. `AgentTasks/null-edge-plucker-bargmann-phase-core-aristotle-2026-06-21.md` [Theorem targets]

Score: `0.831`

```text
## Theorem targets

```lean
plucker_lagrange_identity
trace_rankOneKetBra
rankOneKetBra_mul
rankOneProjector_mul
bargmannTripleTrace_rankOne
normalized_plucker_eq_one_sub_overlap
```
```

### 7. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 1 — Mass as a Plucker spread of null spinors]

Score: `0.830`

```text
tyRankOneAristotle`:
- `complex_plucker_mass_identity` : `det (∑ i, ψ i • (ψ i)ᴴ) = ∑ i j, ‖ψ i ∧ ψ j‖²` (i<j),
- `complex_plucker_mass_nonneg`,
- `complex_plucker_mass_eq_zero_iff_collinear`.
Then a matching lemma to the two-twistor mass invariant (`twistor_mass_eq_plucker`),
scoped to the spinor chart only — no full Penrose transform.

**Status update, 2026-06-21.** `PhysicsSM.Spinor.PluckerMass` now promotes the
finite determinant identity, the real-valued nonnegativity wrapper, and the
mass-zero/common-direction criterion to a trusted kernel-clean module. The
remaining Pillar 1 work is the celestial-moment wrapper and the
twistor-incidence interpretation layer. The hidden-channel update adds one more
finite theorem cluster: coherent alternatives have zero determinant mass,
decohered alternatives have Plucker mass, and partial hidden coherence scales that
mass by the hidden Gram determinant `1 - |k|^2`. The next theorem names are:

- `rankOneHermitian_eq_weighted_spinProjector`;
- `fin_bundle_det_eq_bloch_minkowski_norm`;
- `finPairwisePluckerMassReal_eq_weighted_angular_variance`;
- `mass_zero_iff_bloch_dipole_saturates`.
- `visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily`;
- `partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker`.

**Falsification.** Failure of the determinant identity, failure of the
Bloch/angular-variance rewrite, or mismatch with the physical invariant-mass
convention `m^2 = det P`.

---
```

### 8. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [spinor_inner_wedge_lagrange_identity]

Score: `0.825`

```text
theorem spinor_inner_wedge_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
      complexAbsSq (spinorWedge psi phi) =
    spinorNormSq psi * spinorNormSq phi := by
  unfold spinorInner spinorWedge spinorNormSq complexAbsSq
  simp only [map_add, map_mul, map_sub, Complex.conj_conj]
  ring

/--
For unit spinors, the squared Pluecker wedge is the complement of squared
Hermitian overlap.  This is the finite algebraic form of Fubini-Study angular
spread for the null-edge mass contribution.
-/
```

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.713`
URL: http://arxiv.org/abs/0808.1923

### 2. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.703`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 3. Spin on a 4D Feynman Checkerboard

Score: `0.694`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 4. Gauged twistor formulation of a massive spinning particle in four dimensions

Score: `0.691`
Zotero key: `arxiv:1512.07740`
arXiv: `1512.07740`
DOI: `10.1103/PhysRevD.93.045016`
URL: http://arxiv.org/abs/1512.07740

Abstract:

Gauged generalized Shirafuji action for a massive spinning particle with local U(1) and SU(2) symmetries, constraints, and Penrose transform to massive spinor fields.
