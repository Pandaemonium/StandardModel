# Aristotle semantic context pack

Generated: 2026-07-04T18:09:28
Query: `YM1 rectangular boundary expectation area law RectBoundaryExpectation tree gauge lasso independent plaquette theorem semantic audit`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeYukawaFlip.lean` [ClaimBoundary]

Score: `0.766`

```text
structure ClaimBoundary where
  only_hypercharge_checked : True
  no_su2_tensor_contraction : True
  no_mass_generation_dynamics : True

/-- The claim boundary for this draft theorem package is explicit. -/
```

### 2. `PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean` [ClaimBoundary]

Score: `0.765`

```text
structure ClaimBoundary where
  /-- The Jbar sector covers only left-handed doublets (Q_L and L_L). -/
  doublets_only :
    fureyDoubletTable.length = 2
  /-- The Jbar sector accounts for 8 of 15 Weyl states. -/
  weyl_coverage :
    quarkDoublet_colorDim * quarkDoublet_weakDim +
    leptonDoublet_colorDim * leptonDoublet_weakDim = 8
  /-- The remaining 7 Weyl states are right-handed singlets not derived
      from the Furey algebra. -/
  missing_singlet_count :
    PhysicalMultiplet.weylCount .u_R +
    PhysicalMultiplet.weylCount .d_R +
    PhysicalMultiplet.weylCount .e_R = 7
  /-- The right-handed sector open boundary is inherited from the
      electroweak bridge. -/
  right_handed_open : FureyRightHandedSectorOpen

/-- The claim boundary is satisfied. -/
```

### 3. `AgentTasks/null-edge-gate-c-release-audit-dependency-matrix-2026-06-27.md` [Claim boundary]

Score: `0.759`

```text
## Claim boundary

This matrix supports planning only. It does not assert a physical chiral branch release, anomaly cancellation, locality theorem, or Standard Model spectrum theorem.
```

### 4. `AgentTasks/furey-colorgen-induced-j-representation-aristotle-2026-05-30.md` [Claim boundary]

Score: `0.759`

```text
## Claim boundary

This file packages the finite color representation on `J`. It should not claim
the full Standard Model gauge group or a Lie group integration theorem.
```

### 5. `Sources/Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md` [Claim boundaries]

Score: `0.756`

```text
## Claim boundaries

- The current Lean file proves finite algebraic/combinatorial facts, not a
  continuum theory.
- The Pluecker mass identities do not by themselves prove a Dirac continuum
  limit.
- The Higgs target proves representation legality, not mass generation
  dynamics.
- The twistor target should be treated as a convention-checked chart theorem
  until full twistor geometry is formalized.
- The causal-diamond group theorems prove finite gauge-invariant defects, not
  a continuum Stokes theorem.
- The gravity route remains a research direction; near-term Lean targets
  should be finite observables and claim-boundary markers.
```

### 6. `Sources/Formalizing E8xE8 Anomaly Cancellation.md` [**Formalizing the ![][image1] Gauge Lattice and Anomaly Cancellation in Lean 4**]

Score: `0.755`

```text
# **Formalizing the ![][image1] Gauge Lattice and Anomaly Cancellation in Lean 4**
```

### 7. `AgentTasks/furey-qop-color-j-commutator-aristotle-2026-05-31.md` [Claim boundary]

Score: `0.751`

```text
## Claim boundary

This is charge conservation for the finite color representation on `J`.
It does not derive weak isospin, hypercharge, the full Standard Model gauge
group, or a Lie group integration theorem.
```

### 8. `AgentTasks/null-edge-grand-strategy-v3-output.md` [8. Audit: is P9 stronger, weaker, or just cleaner?]

Score: `0.751`

```text
out the gaps that keep P9 Aspirational:
* the `Bivector := Fin 3 → ℝ` carrier is a **toy `su(2)_L` stand-in** with no
  linear-simplicity (EPRL vs degenerate vs `II±`) sector tracking;
* the SJ reference is **pre-area-law / pre-truncation**;
* the model actually used has **no homology gap** demonstrated
  (`IsBoundaryExact` vs `IsBFClosed` are stated distinct, but a *closed-not-exact*
  witness is not yet built - and that gap is exactly where the physics lives);
* `recoverabilityGap controls sourceVisibility` is still only a **conjecture**;
* the **everpresent-Λ amplitude tension** has no new suppression mechanism.

So P9's *leverage* (highest-risk, highest-reward cosmology branch) is unchanged,
but its *floor* rose: the finite skeleton is now clean, checked, and correctly
separated, which is precisely what lets the next agent build the homology-gap and
recoverability layers without re-deriving the separation each time. The right
status label remains **Aspirational**, now with a trustworthy finite spine
underneath it.

---
```

## Scoped paper hits

### 1. An invitation to higher gauge theory

Score: `0.723`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 2. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.717`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 3. Exactly massless quarks on the lattice

Score: `0.715`
Zotero key: `9H7HA39S`
arXiv: `hep-lat/9707022`
URL: https://arxiv.org/abs/hep-lat/9707022

### 4. Local d'Alembertian for causal sets

Score: `0.714`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 5. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.714`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1
