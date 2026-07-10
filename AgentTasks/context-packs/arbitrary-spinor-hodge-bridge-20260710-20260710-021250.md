# Aristotle semantic context pack

Generated: 2026-07-10T02:12:55
Query: `arbitrary complex spinor pair Pluecker norm squared selects positive Hodge decoder nondegenerate quartet exact class`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeBargmannPhasePort.lean` [bargmannTripleTrace_rankOne]

Score: `0.845`

```text
theorem bargmannTripleTrace_rankOne
    (psi phi chi : CSpinor) :
    trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) =
      spinorInner psi phi * spinorInner phi chi * spinorInner chi psi := by
  unfold rankOneProjector
  unfold rankOneKetBra
  unfold trace2 spinorInner
  simp +decide [Matrix.mul_apply, vecMulVec]
  ring

/--
Normalized two-spinor corollary: for unit spinors, the Pluecker squared modulus
is the complement of the squared Hermitian overlap.
-/
```

### 2. `PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean` [bargmannTripleTrace_rankOne]

Score: `0.836`

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

### 3. `Sources/Null_Edge_Attachment_Extraction_2026-06-21.md` [1. Spin-factor mass positivity over division algebras]

Score: `0.831`

```text
### 1. Spin-factor mass positivity over division algebras

The attachment gives a compact argument for:

```text
For K = R, C, H, O and P = sum_i psi_i psi_i^dagger in h_2(K),
det(P) >= 0.
```

Writing

```text
P = [[A, X], [conj X, B]]
```

one has `det(P) = A * B - |X|^2`, with

```text
A = sum_i |x_i^1|^2
B = sum_i |x_i^2|^2
X = sum_i x_i^1 * conj(x_i^2).
```

Triangle inequality, norm multiplicativity, and real Cauchy-Schwarz give
`|X|^2 <= A * B`. This does not use associativity. It is therefore a good
formal theorem target for the spin-factor/Jordan layer.

**Why this is useful.** The trusted complex Pluecker theorem remains the
visible 3+1-dimensional keystone. This spin-factor theorem would support the
larger Baez-Huerta 3,4,6,10-dimensional story without reviving the retired
"octonionic equality gap" claim.

**Likely Lean path.**

- Start concretely with `PhysicsSM.Algebra.Jordan.H2O`, since `det`, `trace`,
  and `normSq` already exist.
- State a coordinate-level rank-one sum theorem for `H2O` first.
- Later abstract over a normed-composition-algebra interface if the project
  develops one.
```

### 4. `PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean` [chiralDiracSlash_sq_eq_norm]

Score: `0.825`

```text
theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p • (1 : Matrix ChiralIdx ChiralIdx Complex) :=
  NullEdgeDiracSlashCore.chiralDiracSlash_sq_eq_norm p

/-- Trusted Pluecker determinant theorem, restated in this bridge namespace. -/
```

### 5. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 1 — Mass as a Plucker spread of null spinors]

Score: `0.823`

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

**Positive-Grassmannian / positroid classification angle.** The `2 x n`
spinor matrix defines a point of `Gr(2,n)` through its Pluecker coordinates.
For the complex null-edge program, the robust finite structure is first the
vanishing/sign/phase pattern of the minors; strict positivity only applies
after a real ordered or phase-gauge-fixed restriction. The useful scattering
analogy is therefore stratification, not immediate amplituhedra:

```text
vanishing minors       -> collinear / factorization / boundary degenerations
posit
```

### 6. `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean` [spinor_inner_wedge_lagrange_identity]

Score: `0.822`

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

### 7. `PhysicsSM/Spinor/PluckerMass.lean` [rankOneHermitian]

Score: `0.820`

```text
def rankOneHermitian (psi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec psi (star psi)

/-- The spinor wedge / Pluecker coordinate of two complex two-spinors. -/
```

### 8. `PhysicsSM/Draft/NullEdgeCoreAristotle.lean` [rankOneHermitian]

Score: `0.819`

```text
def rankOneHermitian (psi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec psi (star psi)

/-- The spinor wedge / Pluecker coordinate of two complex 2-spinors. -/
```

## Scoped paper hits

### 1. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.741`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.

### 2. The Octonions

Score: `0.734`
Zotero key: `WRIM6ZI7`
arXiv: `math/0105155`
URL: http://arxiv.org/abs/math/0105155

Abstract:

The octonions are the largest of the four normed division algebras. While somewhat neglected due to their nonassociativity, they stand at the crossroads of many interesting fields of mathematics. Here we describe them and their relation to Clifford algebras and spinors, Bott periodicity, projective and Lorentzian geometry, Jordan algebras, and the exceptional Lie groups. We also touch upon their applications in quantum logic, special relativity and supersymmetry.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.732`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.732`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 5. Tri-partitions and Bases of an Ordered Complex

Score: `0.729`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x
