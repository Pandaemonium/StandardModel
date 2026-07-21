# Aristotle semantic context pack

Generated: 2026-07-21T03:01:58
Query: `Majorana neutrino complex symmetric mass matrix Takagi singular values physical nonnegative masses mixed pseudo-Dirac two-state branch`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-specificity-audit.md` [F. Neutrino / seesaw appendix (T7)]

Score: `0.853`

```text
### F. Neutrino / seesaw appendix (T7)

Takagi factorization of a complex-symmetric Majorana matrix and the Schur
complement `M_light ~ -m_D M_R^{-1} m_D^T` are standard linear algebra. Squared
masses still come from `M^dagger M`, so any null compatibility is inherited from
target A and is not intrinsic. The plan treats neutrinos as a "stress test, not
evidence" (17.8) and warns against implying sterile neutrinos or a Dirac-vs-
Majorana choice. Standard reconstruction; null-independent.
```

### 2. `AgentTasks/null-edge-unified-mass-proof-chain.md` [T7. Majorana / Takagi / seesaw stress-test theorem]

Score: `0.849`

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

### 3. `PhysicsSM/Draft/NullEdge/KMNeutrinoFamilyAnomalyCapstone.lean` [km_neutrino_family_anomaly_capstone]

Score: `0.845`

```text
ajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta v) = v))) ∧
      ((∀ mD MR lp ln : ℝ,
        0 < mD → 0 < MR →
        lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
        0 < lp ∧ ln < 0 ∧ lp * (-ln) = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 100 → ln < 0 →
        100 < lp ∧ -ln < (1 : ℝ) ^ 2 / 100) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 1 → ln < 0 →
        -ln < (1 : ℝ) ^ 2 / 1)) ∧
      ((∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      |(star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re|
        ≤ (star (Bᴴ *ᵥ v) ⬝ᵥ (Bᴴ *ᵥ v)).re /
          PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
    (∀ {nv nh : Type} [Fintype nv] [Dec
```

### 4. `PhysicsSM/Draft/NullEdge/KMNeutrinoFamilyAnomalyCapstone.lean` [neutrino_mass_packet]

Score: `0.833`

```text
theorem neutrino_mass_packet :
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
      (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, NeutrinoDira
```

### 5. `AgentTasks/overnight-allmass-run-2026-07-09/jobs/neutrino-seesaw.md` [Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)]

Score: `0.831`

```text
## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Extends the landed Dirac/Majorana structure (NeutrinoDiracMajorana): the SEESAW mechanism is the
reason a neutrino with a heavy Majorana partner is light. A `2x2` neutrino mass matrix mixes a light
active state (no bare Majorana mass) with a heavy sterile partner (large Majorana mass `M_R`) through
a Dirac mass `m_D`. The light eigenvalue is suppressed to `~ m_D^2 / M_R` -- the heavier the partner,
the lighter the neutrino. Prove the finite, rational version WITHOUT square roots (via Vieta:
product/trace of eigenvalues), so it is fully kernel-checked.
```

### 6. `PhysicsSM/Draft/NullEdge/AllMassGrandMeshCapstone.lean` [cpFamilyNeutrinoStmt]

Score: `0.831`

```text
a NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD *ᵥ NeutrinoDiracMajorana.psiP
            = NeutrinoDiracMajorana.psiDPartner ∧
            NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
              NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q
                = NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv
              = NeutrinoDiracMajorana.psiInv ∧
            NeutrinoDiracMajorana.MM *ᵥ NeutrinoDiracMajorana.psiInv ≠ 0 ∧
              NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q
                ≠ NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
          ∀ (w : Fin 4 → ℂ),
            NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta w) = w)) ∧
      (∀ (mD MR lp ln : ℝ), 0 < mD → 0 < MR → lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
          0 < lp ∧ ln < 0 ∧ lp * -ln = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 100 → ln < 0 →
          100 < lp ∧ -ln < 1 ^ 2 / 100) ∧
      (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 1 → ln < 0 → -ln < 1 ^ 2 / 1) ∧
      (∀ {nv : Type} {nh : Type} [Fintype nv] [Fintype nh] [DecidableEq nh] [Nonempty nh]
          (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ) (hM : M.PosDef)
          (x : nv → ℂ), A *ᵥ x = 0 →
          |(star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x).re| ≤
            (star (Bᴴ *ᵥ x) ⬝ᵥ Bᴴ *ᵥ x).re
              / PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
      (∀ {nv : Type} {nh : Type} [Fintype nv] [Fintype nh] [DecidableEq nh]
          (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ),
          M.PosDef → ∀ (x : nv → ℂ), A *ᵥ x = 0 →
          (star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x
```

### 7. `PhysicsSM/Draft/NullEdge/NeutrinoMassMechanismCapstone.lean` [neutrino_mass_mechanism_verdict]

Score: `0.828`

```text
theorem neutrino_mass_mechanism_verdict :
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
      (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, N
```

### 8. `PhysicsSM/Draft/NullEdge/NeutrinoMassMechanismCapstone.lean` [dirac_majorana_branch_capstone]

Score: `0.827`

```text
theorem dirac_majorana_branch_capstone :
    (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
      (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
        (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
      ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
            NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
          NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
            NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        (∀ v : Fin 4 → ℂ, Neu
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.762`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Quantum Many-Body Lattice C-R-T Symmetry: Fractionalization, Anomaly, and Symmetric Mass Generation

Score: `0.755`
Zotero key: `9FFS4GFC`
arXiv: `2412.19691`
URL: http://arxiv.org/abs/2412.19691

Abstract:

Charge conjugation (C), mirror reflection (R), and time reversal (T) symmetries, along with internal symmetries, are essential for massless Majorana and Dirac fermions. These symmetries are sufficient to rule out potential fermion bilinear mass terms, thereby establishing a gapless free fermion fixed point phase, pivotal for symmetric mass generation (SMG) transition. In this work, we systematically study the anomaly of C-R-T-internal symmetry in all spacetime dimensions by analyzing the projective representation (i.e. the fractionalization) of the C-R-T-internal symmetry group in the quantum many-body Hilbert space on the lattice. By discovering the fermion-flavor-number-dependent C-R-T-internal symmetry's anomaly structure, we demonstrate an alternative way to derive the minimal flavor number for SMG, which shows consistency with known results from Kahler-Dirac fermion or cobordism classification. Our findings reveal that, in general spatial dimensions, either 8 copies of staggered Majorana fermions or 4 copies of staggered Dirac fermions admit SMG.

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.753`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Hierarchy of quark masses, Cabibbo angles and CP violation

Score: `0.747`
Zotero key: `AKMVETAK`
DOI: `10.1016/0550-3213(79)90316-X`
URL: https://doi.org/10.1016/0550-3213(79)90316-x

### 5. Locality properties of Neuberger's lattice Dirac operator

Score: `0.746`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010
