# Aristotle semantic context pack

Generated: 2026-06-27T07:41:03
Query: `Gate C RegulatorLegal OriginWeylPure irrelevant Wilson regulator chirality balanced origin Gamma_s T taste involution Krein overlap sign trap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` [PermittedChiralityFlip]

Score: `0.751`

```text
def PermittedChiralityFlip
    (left right : PhysicalMultiplet) : Prop :=
  exists H : HiggsInsertion,
    CandidateGaugeLegal
      { left := left, right := right, higgs := H }

/--
The finite candidate-level legality predicate picks out exactly the physical
one-generation Yukawa channels, after forgetting which Higgs marker was used.
-/
```

### 2. `PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean` [candidateGaugeLegal_iff_exists_yukawaFlip]

Score: `0.751`

```text
theorem candidateGaugeLegal_iff_exists_yukawaFlip (c : CandidateYukawaVertex) :
    CandidateGaugeLegal c <-> exists v : YukawaFlip, c = candidateOfYukawaFlip v := by
  constructor
  · rintro ⟨h1, h2, h3, h4⟩
    rcases c with ⟨l, r, h⟩
    cases l <;> cases r <;> cases h <;>
      simp_all +decide [CandidateYukawaVertex.ChiralityLegal,
        CandidateYukawaVertex.WeakLegal, CandidateYukawaVertex.ColorNeutral]
    all_goals
      unfold CandidateYukawaVertex.hyperchargeDefect at h4
      norm_num [multipletHypercharge, higgsHypercharge] at h4
    · exact ⟨YukawaFlip.upQuark, rfl⟩
    · exact ⟨YukawaFlip.downQuark, rfl⟩
    · exact ⟨YukawaFlip.chargedLepton, rfl⟩
    · exact ⟨YukawaFlip.neutrino, rfl⟩
  · rintro ⟨v, rfl⟩
    exact physicalYukawaFlip_gaugeLegal v

/-- The scalar Yukawa flip operator is odd for chirality. -/
```

### 3. `PhysicsSM/StandardModel/YukawaGauge.lean` [candidateOfYukawaFlip_gaugeLegal]

Score: `0.749`

```text
theorem candidateOfYukawaFlip_gaugeLegal (v : YukawaFlip) :
    CandidateGaugeLegal (candidateOfYukawaFlip v) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact ⟨leftMultiplet_chirality_left v, rightMultiplet_chirality_right v⟩
  · exact weakYukawaPattern_all v
  · exact colorNeutralPattern_all v
  · dsimp [CandidateYukawaVertex.hyperchargeDefect, candidateOfYukawaFlip]
    rw [higgsInsertion_hypercharge_matches]
    exact YukawaFlip.hyperchargeDefect_eq_zero v

/--
Finite classifier: the Standard-Model-like candidate legality predicate picks
out exactly the four one-generation Yukawa flip channels.
-/
```

### 4. `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md` [4. Yukawa legality classifier]

Score: `0.747`

```text
### 4. Yukawa legality classifier

Prove:

```lean
candidateOfYukawaFlip_gaugeLegal
candidateGaugeLegal_iff_exists_yukawaFlip
```

Mathematical intent:

- The finite Standard-Model-like legality predicates pick out exactly the
  four one-generation Yukawa flip channels.

Likely proof route:

- Case split on `CandidateYukawaVertex.left`,
  `CandidateYukawaVertex.right`, and `CandidateYukawaVertex.higgs`.
- Use exact rational arithmetic via `norm_num`.
- Use existing declarations:
  `gaugeLegalPattern_all`, `higgsInsertion_hypercharge_matches`,
  `weakYukawaPattern_all`, `colorNeutralPattern_all`, and
  `YukawaFlip.hyperchargeDefect_eq_zero`.
```

### 5. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [candidateOfYukawaFlip_gaugeLegal]

Score: `0.747`

```text
theorem candidateOfYukawaFlip_gaugeLegal (v : YukawaFlip) :
    CandidateGaugeLegal (candidateOfYukawaFlip v) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact ⟨leftMultiplet_chirality_left v, rightMultiplet_chirality_right v⟩
  · exact weakYukawaPattern_all v
  · exact colorNeutralPattern_all v
  · dsimp [CandidateYukawaVertex.hyperchargeDefect, candidateOfYukawaFlip]
    rw [higgsInsertion_hypercharge_matches]
    exact YukawaFlip.hyperchargeDefect_eq_zero v

/-
Finite classifier: the Standard-Model-like candidate legality predicate picks
out exactly the four one-generation Yukawa flip channels.
-/
```

### 6. `AgentTasks/null-edge-physics-bridge-aristotle-2026-06-21.md` [3. Higgs/Yukawa permission for chirality flips]

Score: `0.745`

```text
### 3. Higgs/Yukawa permission for chirality flips

```lean
permittedChiralityFlip_iff_yukawa_channel
```

Guidance:

- Use `candidateGaugeLegal_iff_exists_yukawaFlip`.
- Forward direction: unpack the Higgs insertion witness, apply the classifier,
  and read off the left/right multiplets.
- Reverse direction: use the candidate associated to the Yukawa flip and the
  existing `candidateOfYukawaFlip_gaugeLegal`.
```

### 7. `PhysicsSM/StandardModel/YukawaGauge.lean` [candidateGaugeLegal_iff_exists_yukawaFlip]

Score: `0.744`

```text
theorem candidateGaugeLegal_iff_exists_yukawaFlip
    (c : CandidateYukawaVertex) :
    CandidateGaugeLegal c ↔
      ∃ v : YukawaFlip, c = candidateOfYukawaFlip v := by
  constructor
  · intro hc
    rcases hc with ⟨hcChirality, hcWeak, hcColor, hcHyper⟩
    obtain ⟨hL, hR⟩ := hcChirality
    rcases c with ⟨left, right, higgsIns⟩
    cases left <;> cases right <;> cases higgsIns <;>
      simp_all [CandidateYukawaVertex.WeakLegal,
        CandidateYukawaVertex.ColorNeutral,
        CandidateYukawaVertex.hyperchargeDefect,
        weakPatternOfMultiplet, colorPatternOfMultiplet,
        HiggsInsertion.weakPattern, HiggsInsertion.hypercharge,
        PhysicalMultiplet.chirality, PhysicalMultiplet.hypercharge]
    all_goals try norm_num at hcHyper
    all_goals first
      | exact ⟨YukawaFlip.upQuark, rfl⟩
      | exact ⟨YukawaFlip.downQuark, rfl⟩
      | exact ⟨YukawaFlip.chargedLepton, rfl⟩
      | exact ⟨YukawaFlip.neutrino, rfl⟩
  · rintro ⟨v, rfl⟩
    exact candidateOfYukawaFlip_gaugeLegal v

end PhysicsSM.StandardModel.YukawaGauge
```

### 8. `PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean` [ElectroweakLegalPattern]

Score: `0.743`

```text
def ElectroweakLegalPattern (v : YukawaFlip) : Prop :=
  WeakYukawaPattern v ∧ YukawaFlip.hyperchargeDefect v = 0

/-- Full finite gauge-bookkeeping legality used by this draft file. -/
```

## Scoped paper hits

### 1. Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation

Score: `0.724`
Zotero key: `N68MN4ET`
arXiv: `hep-lat/9802011`
DOI: `10.1016/S0370-2693(98)00423-7`
URL: https://www.zotero.org/19894138/items/N68MN4ET

Abstract:

It is shown that the Ginsparg-Wilson relation implies an exact symmetry of the fermion action, which may be regarded as a lattice form of an infinitesimal chiral rotation. Using this result it is straightforward to construct lattice Yukawa models with unbroken flavour and chiral symmetries and no doubling of the fermion spectrum. A contradiction with the Nielsen-Ninomiya theorem is avoided, because the chiral symmetry is realized in a different way than has been assumed when proving the theorem.

### 2. Spin-taste representation of minimally doubled fermions from first principles: Karsten-Wilczek fermions

Score: `0.715`
Zotero key: `4JTFIC6C`
arXiv: `2502.16500`
DOI: `10.1103/PhysRevD.112.014509`
URL: http://arxiv.org/abs/2502.16500

Abstract:

Minimally doubled fermions realize one pair of Dirac fermions on the lattice. Similarities to Kogut-Susskind fermions exist, namely, spin and taste degrees of freedom become intertwined, and a peculiar non-singlet chiral symmetry and ultralocality are maintained. However, charge conjugation, some space-time reflection symmetries and isotropy are broken by the cutoff. We address the most simple variant, Karsten-Wilczek fermions, in its parallel and in its perpendicular version. We derive the correct spin-taste representation from first principles. We explain the counterterms in the spin-taste framework, and derive generic constraints on the parametric form and cutoff effects from the KW determinant and hadronic correlation functions. We derive how and why non-perturbative tuning schemes for the counterterms work, and obtain analytic, assumption-free, non-perturbative predictions for taste-symmetry breaking and other hadronic properties from first principles. In particular, we identify the origin and nature of two different types of taste-symmetry breaking cutoff effects.

### 3. Lattice Regularization of Reduced Kähler-Dirac Fermions and Connections to Chiral Fermions

Score: `0.703`
Zotero key: `VIQMFAXZ`
arXiv: `2311.02487`
DOI: `10.21468/SciPostPhys.16.4.108`
URL: http://arxiv.org/abs/2311.02487

Abstract:

We show how a path integral for reduced Kähler-Dirac fermions suffers from a phase ambiguity associated with the fermion measure that is an analog of the measure problem seen for chiral fermions. However, unlike the case of chiral symmetry, a doubler free lattice action exists which is invariant under the corresponding onsite symmetry. This allows for a clear diagnosis and solution to the problem using mirror fermions resulting in a unique gauge invariant measure. By introducing an appropriate set of Yukawa interactions which are consistent with 't Hooft anomaly cancellation we conjecture the mirrors can be decoupled from low energy physics. Moreover, the minimal such Kähler-Dirac mirror model yields a light sector which corresponds, in the flat space continuum limit, to the Pati-Salam GUT model.

### 4. Spin on a 4D Feynman Checkerboard

Score: `0.698`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 5. An invitation to higher gauge theory

Score: `0.697`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9
