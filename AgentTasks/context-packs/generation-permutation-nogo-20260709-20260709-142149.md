# Aristotle semantic context pack

Generated: 2026-07-09T14:21:56
Query: `finite duplicated family modules permutation symmetry no-go canonical generation structure KM CP rank fixing`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `EXECUTION_PLAN.md` [Milestone 9 — Multi-generational unification and Dixon algebra]

Score: `0.787`

```text
ve anomaly-sum invariance across family-equivalent sectors.
5. Prove adjoining family-equivalent copies does not change the finite `Z6`
   kernel data already formalized in the gauge modules.
6. Instantiate the generic theorem for the existing Furey-Hughes
   `TrialityRole`/`TrialityTriple` linear permutation API.

**Claim boundary**: This would be a mathematical naturality theorem about
finite algebraic Standard Model tables. It would not claim that triality or
`S3` is the physical origin of generations.

---
```

### 2. `PhysicsSM/StandardModel/FamilyAnomalyPermutation.lean` [FamilyAnomalyPermutationPackage]

Score: `0.781`

```text
structure FamilyAnomalyPermutationPackage where
  anomaly_free_perm :
    ∀ {xs ys : List ChiralMultiplet},
      xs.Perm ys →
      LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs →
      LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys

/-- Construction of the family anomaly permutation package. -/
```

### 3. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [New synthesis: rank-2 / rank-3 Jordan split]

Score: `0.773`

```text
## New synthesis: rank-2 / rank-3 Jordan split

The generation feedback is useful because it tells us where not to look.
The visible Plucker/celestial mass layer is generation-blind: it sees a
bundle's visible null directions and their determinant mass, not whether the
fermion is first, second, or third generation. Generation labels should
therefore live in the internal label and Yukawa/flip-amplitude layer.

The algebraic refinement is:

```text
visible layer:
  H_2(C), the Jordan algebra of 2 x 2 complex Hermitian matrices
  determinant = Lorentzian norm
  rank-one idempotents = CP^1 celestial null directions

internal layer:
  H_3(O), the Albert algebra of 3 x 3 Hermitian octonionic matrices
  candidate home for family/generation labels and internal mixing data
```

This is a structural hypothesis, not a spectrum theorem. It may explain why
three is the right internal count if the Albert algebra is the correct
internal arena, but it does not yet determine charged-lepton/quark mass ratios
or CKM/PMNS mixing angles.

Lean foothold: the Albert side is already substantially trusted in the repo
through `PhysicsSM.Algebra.Jordan.H3O`, `H3OJordan`, trace-form modules, and
projective-geometry/stabilizer infrastructure. The next task is therefore not
to formalize the exceptional Jordan algebra from scratch, but to build a narrow
interface from that trusted substrate to generation labels, allowed internal
transitions, and reduced visible spectra.

**2026-06-21 Zotero/Neo4j additions.** Added Boyle `3ABEUB3K`
(`2006.16265`), Dubois-Violette-Todorov `SVNGPAFK` (`1806.09450`), and
Dubois-Violette-Todorov `FVH3WAAV` (`1808.08110`), tagged
`jordan-generations` and `albert-algebra`.

Barnum-Graydon-Wilce (`1606.09331`) gives the disciplined version of the
"tensorial autonomy" claim.
```

### 4. `PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean`

Score: `0.772`

```text
import Mathlib

set_option linter.style.longLine false
set_option linter.style.whitespace false

/-!
# Generation-blindness core

Standalone finite algebra for the claim that the visible Plucker mass
functional is blind to internal generation relabeling.

The theorem is deliberately narrow: if the visible spinor family is only
reindexed by a permutation of the hidden/generation labels, the pairwise
Plucker mass is unchanged.  This supports the program's claim that generations
must live in hidden Gram/Yukawa data rather than in the visible rank-two null
geometry itself.
-/
```

### 5. `EXECUTION_PLAN.md` [Milestone 9 — Multi-generational unification and Dixon algebra]

Score: `0.769`

```text
### Milestone 9 — Multi-generational unification and Dixon algebra
**Goal**: Formalize the Dixon Algebra
`R tensor C tensor H tensor O` and connect it to the three-generation and
exceptional-Jordan directions once the `h_3(O)` layer is stable.

**Motivation**: Move from one generation to three and compare the Furey,
Dixon, Krasnov, and Baez-Schwahn routes to Standard Model structure.

**Strategy**: Reuse the Cayley-Dickson and `h_3(O)` infrastructure. Do not
start a large Dixon formalization until Milestones 2, 6, and the trusted parts
of Milestone 8 are stable enough to avoid duplicating algebra.

**2026-05-31 update**: The strongest publication-shaped path is not a direct
formalization of a single three-generation paper. It is an abstract
family-symmetry naturality theorem that can later be instantiated for
Furey-Hughes triality and compared with Gresnigt/Gourlay `S3` models.

**New Lean targets**:

| File | Content |
|------|---------|
| `PhysicsSM/StandardModel/FamilySymmetry.lean` | Finite family action on indexed generation sectors |
| `PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean` | Eigenvalue and anomaly-sum transport under family-equivalent sectors |
| `PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean` | Furey-Hughes triality instantiation using `TrialityTriple` permutations |

**First theorem ladder**:

1. Package finite sector tables abstractly: family index, state type, charge
   operators, and finite anomaly polynomials.
2. Define when a family action commutes with a gauge/charge operator.
3. Prove eigenvalue transport across a family orbit.
4. Prove anomaly-sum invariance across family-equivalent sectors.
5. Prove adjoining family-equivalent copies does not change the finite `Z6`
   kernel data already formalized in the gauge modules.
6. Insta
```

### 6. `AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md` [6. Warning list — overclaims to avoid]

Score: `0.767`

```text
## 6. Warning list — overclaims to avoid

The audit and skeleton deliberately stop short of physics they do **not** earn:

- **No Yukawa values.** Nothing here fixes any coupling magnitude; legality is a
  yes/no on block *structure*, never a number.
- **No mixing angles.** No CKM/PMNS content; generation indices are not even
  resolved (the skeleton is one-generation/representation-level).
- **No generation-number derivation.** The number of families is an input
  (`physicalList15/16`), not a theorem.
- **No Gate C release.** Gate C requires `LiftNonOrigin ∧ OriginWeylPure` plus the
  ghost/Krein/gauge/counterterm clauses (`NullEdgeRegulatorLegalGateCRelease`);
  none of that is touched here. Legality of a *block* is necessary, not
  sufficient.
- **`WeakSinglet`/`ColorSinglet` are parity surrogates**, not full tensor-product
  representation theory; they are sound for the binary doublet/singlet,
  triplet/singlet bookkeeping used, and should not be read as a Clebsch–Gordan
  decomposition.
- **`ν_R` is a flag.** The Majorana branch and the seesaw are stated as
  *conditional* on the `J_F` real structure and its KO-dimension signs, which are
  not discharged here. We do **not** claim that `M_R` is canonical, nor that
  neutrinos are Majorana.
- **Finite / no continuum.** Everything is finite linear algebra and labelled
  bookkeeping on `L ⊕ R`; no continuum Dirac operator, spectral action, or
  quantum-measure claim is made.

---
```

### 7. `EXECUTION_PLAN.md` [Candidate new result]

Score: `0.767`

```text
### Candidate new result

The most promising new theorem family is:

```text
Family-symmetry naturality for algebraic Standard Model tables.
```

Informal statement:

```text
Let a finite family group act by linear equivalences on a direct sum of
generation sectors. If the action commutes with the color, weak-isospin,
hypercharge, and electric-charge operators, then every sector in a family orbit
has the same gauge quantum numbers. Consequently, all polynomial anomaly sums
computed from those charges are constant on the orbit, and the finite Z6 kernel
of the Standard Model covering map is unchanged by adjoining family copies.
```

Why this is new enough to be interesting:

- Furey-Hughes use triality as a three-generation mechanism.
- Gresnigt/Gourlay use `S3`-style family symmetry in Clifford/sedenion models.
- The common naturality theorem appears to be a reusable algebraic fact rather
  than a statement specific to either paper.
- It is Lean-friendly: finite groups, linear equivalences, commuting operators,
  charge eigenvalue tables, and finite anomaly sums.

Proposed Lean landing zones:

- `PhysicsSM/StandardModel/FamilySymmetry.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean`
- `PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean`

First theorem package:

1. Define a generic `FamilyAction` on a finite index type of sectors.
2. Define what it means for an operator/table entry to be invariant under the
   family action.
3. Prove eigenvalue transport across family-equivalent sectors.
4. Prove finite anomaly sums are unchanged by replacing a generation by a
   family-equivalent generation.
5. Instantiate the abstract theorem for the existing Furey-Hughes
   `TrialityTriple` permutation API.

Claim boundary: this theorem would not prove that any particu
```

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md` [Gate F: prediction, spectral action, moduli rank, and constraints]

Score: `0.766`

```text
## Gate F: prediction, spectral action, moduli rank, and constraints

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| F1 | Next | Prediction | Turn moduli ledger into a ranked list of possible codimension constraints. | Chooses the first real prediction target. | `AgentTasks/null-edge-codimension-candidate-ranking.md` |
| F2 | Future | Prediction | Spectral-action parameter-count and redundancy audit. | Tests whether the finite data merely reparametrize EFT. | `AgentTasks/null-edge-spectral-action-parameter-audit.md` |
| F3 | Future | Prediction | Candidate coupling relation from finite spectral action. | First route to a structural relation among `g_1`, `g_2`, `g_3`, and `lambda`. | `AgentTasks/null-edge-coupling-relation-candidate.md` |
| F4 | Future | Proof | Formal parameter-count lemma for simplified finite model versus EFT target. | Kernel-checks the first moduli-rank toy version. | `PhysicsSM/Draft/FiniteEFTParameterCount.lean` |
| F5 | Future | Strategy | Yukawa texture/rank constraint search. | Looks for the most plausible non-numerical mass prediction. | `AgentTasks/null-edge-yukawa-texture-constraint-search.md` |
| F6 | Future | Strategy | Generation-number constraint search. | Tests whether finite geometry can force or explain three generations. | `AgentTasks/null-edge-generation-number-strategy.md` |
| F7 | Future | Proof | Forbidden Pauli counterterm theorem in simplified finite square. | A structural prediction candidate independent of exact masses. | `PhysicsSM/Draft/ForbiddenPauliCounterterm.lean` |
| F8 | Future | Audit | Lorentz-dispersion correction estimate and experimental-bound triage. | If branch structure survives, checks whether deviations are constrained. | `AgentTasks/null-edge-dispe
```

## Scoped paper hits

### 1. One generation of standard model Weyl representations as a single copy of $\mathbb{R}\otimes\mathbb{C}\otimes\mathbb{H}\otimes\mathbb{O}$

Score: `0.753`
Zotero key: `6VI58VGH`
arXiv: `2209.13016`
DOI: `10.1016/j.physletb.2022.136959`
URL: http://arxiv.org/abs/2209.13016

Abstract:

Peering in from the outside, $\mathbb{A} := \mathbb{R}\otimes\mathbb{C}\otimes\mathbb{H}\otimes\mathbb{O}$ looks to be an ideal mathematical structure for particle physics. It is 32 $\mathbb{C}$-dimensional: exactly the size of one full generation of fermions. Furthermore, as alluded to earlier in arXiv:1806.00612, it supplies a richer algebraic structure, which can be used, for example, to replace SU(5) with the SU(3)$\times$SU(2)$\times$U(1) / $\mathbb{Z}_6$ symmetry of the standard model. However, this line of research has been weighted down by a difficulty known as the fermion doubling problem. That is, a satisfactory description of SL(2,$\mathbb{C}$) symmetries has so far only been achieved by taking two copies of the algebra, instead of one. Arguably, this doubling of states betrays much of $\mathbb{A}$'s original appeal. In this article, we solve the fermion doubling problem in the context of $\mathbb{A}$. Furthermore, we give an explicit description of the standard model symmetries, $g_{sm}$, its gauge bosons, Higgs, and a generation of fermions, each in the compact language of this 32 $\mathbb{C}$-dimensional algebra. Most importantly, we seek out the subalgebra of $g_{sm}$ that is invariant under the complex conjugate - and find that it is given by $su(3)_C \oplus u(1)_{EM}$. Could this new result provide a clue as to why the standard model symmetries break in the way that they do?

### 2. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.741`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.736`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Hierarchies without symmetries from extra dimensions

Score: `0.732`
Zotero key: `M9KJ7UCN`
arXiv: `hep-ph/9903417`
DOI: `10.1103/PhysRevD.61.033005`
URL: https://doi.org/10.1103/physrevd.61.033005

### 5. The Standard Model, The Exceptional Jordan Algebra, and Triality

Score: `0.729`
Zotero key: `3ABEUB3K`
arXiv: `2006.16265`
DOI: `10.48550/arXiv.2006.16265`
URL: http://arxiv.org/abs/2006.16265v2

Abstract:

Relates the complexified exceptional Jordan algebra to the Standard Model, left-right extension, Spin(10), and a geometric interpretation in which three generations are related to SO(8) triality.
