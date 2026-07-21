# Aristotle semantic context pack

Generated: 2026-07-21T04:42:45
Query: `finite complex symmetric matrix Autonne Takagi factorization unitary congruence nonnegative singular values Majorana physical masses`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-unified-mass-proof-chain.md` [T7. Majorana / Takagi / seesaw stress-test theorem]

Score: `0.830`

```text
## T7. Majorana / Takagi / seesaw stress-test theorem

- Informal: a Majorana mass matrix is complex symmetric (Takagi factorization,
  not chirality-flip); squared masses still come from `M^dagger M`. Seesaw:
  with `M_seesaw = [[0, m_D],[m_D^T, M_R]]` and `M_R` large/invertible, the
  Schur complement gives `M_light ~ -m_D M_R^{-1} m_D^T`.
- Formal shape: two lemmas --
  `theorem takagi_majorana (M : ... ) (hsym : M = M^T) : exists U unitary, ...`
  and
  `theorem seesaw_schur (m_D M_R) (hinv : IsUnit M_R) :`
  `lightBlock = - m_D * M_R^{-1} * m_D^T` (as the Schur complement of the block
  matrix).
- Hypotheses: complex symmetric `M` (Takagi); invertible `M_R` (seesaw).
- Difficulty: medium (Takagi factorization may need building; Schur complement
  is more standard).
- Dependencies: T6 (positive spectra), appendix of P1.5.
- Failure modes: calling Majorana mass a "chirality-flip gap" (it is a
  charge-conjugation/self-pairing obstruction); overclaiming a neutrino model.
- Type: stress test / future model selection (Rec, explicitly not a result
  about real neutrinos).
- Aristotle: **Lean proof job** for the Schur-complement part (L, medium);
  Takagi may need an **audit/strategy** scoping first. Lower priority.
```

### 2. `AgentTasks/null-edge-specificity-audit.md` [F. Neutrino / seesaw appendix (T7)]

Score: `0.813`

```text
### F. Neutrino / seesaw appendix (T7)

Takagi factorization of a complex-symmetric Majorana matrix and the Schur
complement `M_light ~ -m_D M_R^{-1} m_D^T` are standard linear algebra. Squared
masses still come from `M^dagger M`, so any null compatibility is inherited from
target A and is not intrinsic. The plan treats neutrinos as a "stress test, not
evidence" (17.8) and warns against implying sterile neutrinos or a Dirac-vs-
Majorana choice. Standard reconstruction; null-independent.
```

### 3. `AgentTasks/aristotle-wave8-20260626/b6-b9-plucker-obstruction-covariance/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

### 4. `AgentTasks/aristotle-wave8-20260626/f13-forbidden-counterterm-codimension/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

### 5. `AgentTasks/aristotle-wave8-20260626/h1-h3-internal-spectrum-anomaly-inheritance/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

### 6. `AgentTasks/aristotle-wave8-20260626/c16-gamma-f-flavored-chirality-index/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

### 7. `AgentTasks/aristotle-wave8-20260626/a1-gate-a-super-dirac-square-closeout/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

### 8. `AgentTasks/aristotle-wave7-20260626/wave8-master-strategy-after-literature/Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md` [16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened]

Score: `0.799`

```text
### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.
```

## Scoped paper hits

### 1. Quantum Many-Body Lattice C-R-T Symmetry: Fractionalization, Anomaly, and Symmetric Mass Generation

Score: `0.754`
Zotero key: `9FFS4GFC`
arXiv: `2412.19691`
URL: http://arxiv.org/abs/2412.19691

Abstract:

Charge conjugation (C), mirror reflection (R), and time reversal (T) symmetries, along with internal symmetries, are essential for massless Majorana and Dirac fermions. These symmetries are sufficient to rule out potential fermion bilinear mass terms, thereby establishing a gapless free fermion fixed point phase, pivotal for symmetric mass generation (SMG) transition. In this work, we systematically study the anomaly of C-R-T-internal symmetry in all spacetime dimensions by analyzing the projective representation (i.e. the fractionalization) of the C-R-T-internal symmetry group in the quantum many-body Hilbert space on the lattice. By discovering the fermion-flavor-number-dependent C-R-T-internal symmetry's anomaly structure, we demonstrate an alternative way to derive the minimal flavor number for SMG, which shows consistency with known results from Kahler-Dirac fermion or cobordism classification. Our findings reveal that, in general spatial dimensions, either 8 copies of staggered Majorana fermions or 4 copies of staggered Dirac fermions admit SMG.

### 2. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.746`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 3. An analysis of completely-positive trace-preserving maps on M2

Score: `0.738`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.732`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Locality properties of Neuberger's lattice Dirac operator

Score: `0.732`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010
