# Aristotle semantic context pack

Generated: 2026-07-10T01:50:34
Query: `Krein positive sector pairing preserving linear equivalence Lorentz boost invariance`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-aristotle-integration-round-2026-06-23.md` [Lorentz boost identities]

Score: `0.793`

```text
### Lorentz boost identities

Project: `b21afb44-63d3-45f1-932e-022e701c03b4`

New module:

```text
PhysicsSM.Draft.NullEdgeLorentzBoost
```

Main declarations:

- `boost_preserves_mink`
- `boost_compose`

Value: a small convention anchor for 1+1-dimensional rapidity boosts and
Minkowski-signature bookkeeping.
```

### 2. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/AgentTasks/null-edge-k2-krein-positive-release-criterion-note.md` [The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`]

Score: `0.792`

```text
### The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
Since C22 already proves the modeled branch Krein pattern is `(+,−,+,−)` (so not all branches are Krein-positive), the criterion is built around a **physical-sector projection**, not a blanket positivity claim:

- `sectorProj sel` — projector onto the branches retained by a selector; `KreinPositiveSector P := kreinJ * P = P` (the modeled Krein metric restricts to `+1`, i.e. positive-definite, on the range of `P`).
- `kreinJ_Pbranch`: the Krein metric acts on branch `a` by its signature `branchKreinSig a`.
- **General sufficient condition** `sectorProj_kreinPositive`: any sector whose retained branches all have Krein signature `+1` is Krein-positive.
- **Canonical physical sector** `physSel`/`Pphys = Pbranch 0 + Pbranch 2`: retains exactly the Krein-positive branches. Proved idempotent, symmetric, rank 2; `Pphys_kreinPositive` and `Pphys_krein_form` (`Pphys·J·Pphys = Pphys`).
- **Species splitting made explicit**: `retained_dirac_pair` shows the retained pair `{0,2}` is one left-chiral + one right-chiral mode, both Krein-positive (a healthy Dirac pair); `discarded_krein_negative`/`discarded_ghost_pair` show the projected-out pair `{1,3}` is *exactly* the Krein-negative ghost sector — the negative branches are explicitly excluded, not hidden.
- **The deliverable release theorem** `physical_sector_releases`: the physical sector satisfies the sector-restricted predicate `ReleasesKreinPositiveOnSector` (aligned chirality and Krein-positive on every retained branch), with `releasesOnSector_imp_kreinPositive` bridging to the matrix-level positivity.
- **Sharpness**: `Pnull_krein_indefinite` (full sector is indefinite), `releasesKreinPositive_iff_full` (C22's `ReleasesKreinPositive` is exactly the u
```

### 3. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md` [(B) Retarded/advanced Krein spectral double — `ProjCtx.kreinDouble`]

Score: `0.789`

```text
### (B) Retarded/advanced Krein spectral double — `ProjCtx.kreinDouble`

The Krein construction doubles the state space into a retarded ⊕ advanced
(`R ⊕ A`) pair carrying an **indefinite** Krein metric. Here both orientations
are allowed, but they must enter **paired** (equal retarded/advanced
multiplicity), so the doubled object is metric-compatible and the R/A halves are
genuine conjugates.

* Transformation law required: **covariance** of each half (the Krein metric is
  built from the unitary fibre structure, which covariance preserves).
* `AdmissibleIn kreinDouble a shifts` :=
  `#{retarded} = #{advanced}` (counts of `dir` over `shifts`).

> **Krein ≠ ghost-safety.** Covariance preserves the *indefinite* metric; it does
> **not** prove the physical (gauge-invariant on-shell) subspace is Krein-positive.
> That is exactly the C22 / C47 obligation (`KreinPositivePhysicalSector`,
> `kreinArtifact` vs `fatalGhostZero`).
```

### 4. `AgentTasks/model-calls/claude/2026-06-24-round-007-adversarial-next-job.md` [This is almost certainly false as stated.]

Score: `0.786`

```text
### This is almost certainly false as stated.

Conjugation **preserves eigenvalues**. The eigenvalues of `H_h(p,m)` are `±√(p²+m²) = ±E`. The eigenvalues of `H_h(p',m)` are `±E' = ±√(p'²+m²)`. A genuine Lorentz boost changes `p` *and* `E`, with `E'≠E` whenever the boost is nontrivial. So `U H U^{-1} = H(p',m)` with `p'≠p` and `m` fixed forces `E'=E`, which forces `p'=±p`. That collapses the claim to a parity/sign flip, not a boost.

This is the classic confusion between

- **Active Lorentz transform** of a Hamiltonian in a *fixed* representation: `U H U^†` with `U` non-unitary (Hermitian boost), and the result is *not* of the form `H(p',m)` because `H` is not a Lorentz scalar — it's a time component of something.
- **Mass-shell preservation** as a *spectral* statement: `det(H − λI) = λ² − (p²+m²)`, and Lorentz invariance lives in the *characteristic polynomial under the boost of p*, not in matrix conjugation.

So B has a fundamental conceptual flaw before any Lean code is written. Sending it to Aristotle will either:
(a) burn budget proving a false statement (Aristotle fails, you learn nothing new), or
(b) succeed by smuggling in a trivial `U_k = I` or `U_k = ±I` or by redefining `H` mid-proof.
```

### 5. `Sources/nrqg-round8-adversarial-synthesis.md` [Attack 1.2 — "You are double-dipping on Lorentz invariance."]

Score: `0.780`

```text
## Attack 1.2 — "You are double-dipping on Lorentz invariance."

*The node bootstrap (Weinberg soft theorems, BCFW four-particle consistency) and Guido–Longo both require exact Poincaré covariance and S-matrix analyticity. Elsewhere the program insists Lorentz invariance is only statistical, per-sample broken. You invoke exact-Lorentz theorems while denying exact Lorentz. Pick one.*

**Verdict: lands — and forces the round's most important constructive synthesis.** The resolution is not a patch; it is a reorganization of the entire tower into **two columns meeting at a fixed point**:

- **Column A (substrate, upward):** the graph axioms — null edges, node fibers, growth measure, statistical Lorentz invariance. Substrate-level claims may only use substrate-safe mathematics (finite operators, counting, discrete Hodge, correlation matrices).
- **Column B (fixed point, downward):** the exact-symmetry theorems — CDP, node bootstrap, Guido–Longo, spin-statistics, Weinberg–Witten dodges, c/F/a monotones — which are **consistency conditions on the infrared fixed point** the substrate must flow to, not laws of the substrate.

The tower's real claim, restated cleanly: *the substrate ensemble must possess an RG fixed point satisfying Column B, and Column B is restrictive enough to force the Standard Model + GR shape of that fixed point.* All imported exact-Lorentz results move to Column B and get the grade **T|FP** — theorem, conditional on reaching the fixed point. This single move resolves Attack 1.2, correctly re-grades Levels 1, 3.5, and the spin-statistics fill, and makes the program's central open problem explicit: **the Measure Problem** — exhibit a growth measure whose fixed point exists and satisfies Column B. Everything else in the program is either finite mathematics (C
```

### 6. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Wave 14 partial update: selector theorem]

Score: `0.778`

```text
### Wave 14 partial update: selector theorem

`NullEdgeCanonicalSpeciesSelector` proves that the physical retained sector is
canonical relative to locked Krein-sign data: the retained pair is the unique
maximal Krein-positive branch sector. It also proves a no-go for absolute
canonicity from chirality/taste/energy/grading alone. Future Gate C statements
should therefore use the structural phrase "maximal Krein-positive sector" and
future Gate F statements should not treat the literal branch labels as predicted.
```

### 7. `Sources/A_null-strand_Bohm–Bell_theory.md` [K_B^{U_A\Psi}K_A^\Psi]

Score: `0.771`

```text
## K_B^{U_A\Psi}K_A^\Psi

K_A^{U_B\Psi}K_B^\Psi
]

and compute it for a Bell pair.

[
\boxed{
\texttt{comptonLockedDirectionCorrelation}
}
]

For the homogeneous regulated process, prove

[
\langle\omega(s)\cdot\omega(0)\rangle
=====================================

e^{-2mc^2s/\hbar}.
]

The Bell-pair synchronization calculation is probably the most informative physics test. The covariant null-moment and flux theorems are the cleanest mathematical publication targets.
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [34.7 Wave 14 partial result: canonical selector status]

Score: `0.769`

```text
### 34.7 Wave 14 partial result: canonical selector status

C65 has now clarified the physical branch selector. The retained branch pair
`{0,2}` is canonical once the Krein-sign data are locked: it is the unique
maximal Krein-positive sector in the modeled branch data. This means the safe
publication phrasing is structural, not label-dependent: "retain the maximal
Krein-positive pair" rather than "retain branches 0 and 2" unless the branch
labeling and Krein convention have already been fixed.

The no-go part is equally important. Chirality, taste/orientation, energy sign,
and internal grading alone do not force the selector. A permutation can preserve
those data while moving the literal retained pair. Thus Gate C gets a cleaner
selector clause, while Gate F prediction language remains conservative: the
Krein lock is an input convention/structure unless future work derives it from a
more primitive physical principle.
```

## Scoped paper hits

### 1. Lorentz signature and twisted spectral triples

Score: `0.744`
Zotero key: `TBBD2TB4`
arXiv: `1710.04965`
DOI: `10.1007/JHEP03(2018)089`
URL: https://www.zotero.org/19894138/items/TBBD2TB4

Abstract:

We show how twisting the spectral triple of the Standard Model of elementary particles naturally yields the Krein space associated with the Lorentzian signature of spacetime. We discuss the associated spectral action, both for fermions and bosons. What emerges is a tight link between twist and Wick rotation.

### 2. Discreteness without symmetry breaking: A Theorem

Score: `0.739`
Zotero key: `HG5ZI36W`
arXiv: `gr-qc/0605006`
DOI: `10.1142/S0217732309031958`
URL: https://www.zotero.org/19894138/items/HG5ZI36W

Abstract:

This paper concerns sprinklings into Minkowski space (Poisson processes). It proves that there exists no equivariant measurable map from sprinklings to spacetime directions (even locally). Therefore, if a discrete structure is associated to a sprinkling in an intrinsic manner, then the structure will not pick out a preferred frame, locally or globally. This implies that the discreteness of a sprinkled causal set will not give rise to ``Lorentz breaking'' effects like modified dispersion relations. Another consequence is that there is no way to associate a finite-valency graph to a sprinkling consistently with Lorentz invariance.

### 3. Temporal Lorentzian Spectral Triples

Score: `0.737`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.733`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.730`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011
