# Aristotle semantic context pack

Generated: 2026-07-20T09:11:33
Query: `Z2 cubed regular flavor cover deck translations Fourier character states common eigenspaces commuting rank-one projectors single sheet obstruction quantum cellular automata`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AutonomousLab/work/NE-3PLUS1/CODEX_3PLUS1_CODE_SUBSPACE_ROUTE_2026-07-13.md` [Algebraic ingredient: a projective Clifford cover]

Score: `0.807`

```text
## Algebraic ingredient: a projective Clifford cover

Use the eight states of a three-bit cover as the basis of
`Lambda*(C^3)`. Bare bit flips commute. Jordan-Wigner-signed flips anticommute
and realize the left Clifford action. This signed action is not a basis change
of the bare cover: conjugation preserves commutators. It is a genuinely
projective deck action, equivalently a fermionic two-cocycle or pi closure
holonomy.

The corrected onsite projector is not rank two and is not primitive. Let
`c_j` be the three left signed flips, `r_j` the commuting right signed flips,
and `Gamma` the parity/mass grading. An even right bivector

    B = i r_0 r_1

can satisfy `B^2 = 1` and commute with every `c_j` and with `Gamma`. Hence

    P = (1 + B) / 2

is the candidate rank-four nonprimitive projector. The immediate finite target
is to prove idempotence, Hermiticity, nontriviality, rank four, and all four
commutation relations. This is only an onsite algebraic decoder. It does not
yet remove a Brillouin-zone copy.

Draft handoff:
`AgentTasks/aristotle-standalone/clifford-cover-projector-20260713/CliffordCoverProjector.lean`.
```

### 2. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_3PLUS1_CODE_SUBSPACE_ROUTE_2026-07-13.md` [Algebraic ingredient: a projective Clifford cover]

Score: `0.807`

```text
## Algebraic ingredient: a projective Clifford cover

Use the eight states of a three-bit cover as the basis of
`Lambda*(C^3)`. Bare bit flips commute. Jordan-Wigner-signed flips anticommute
and realize the left Clifford action. This signed action is not a basis change
of the bare cover: conjugation preserves commutators. It is a genuinely
projective deck action, equivalently a fermionic two-cocycle or pi closure
holonomy.

The corrected onsite projector is not rank two and is not primitive. Let
`c_j` be the three left signed flips, `r_j` the commuting right signed flips,
and `Gamma` the parity/mass grading. An even right bivector

    B = i r_0 r_1

can satisfy `B^2 = 1` and commute with every `c_j` and with `Gamma`. Hence

    P = (1 + B) / 2

is the candidate rank-four nonprimitive projector. The immediate finite target
is to prove idempotence, Hermiticity, nontriviality, rank four, and all four
commutation relations. This is only an onsite algebraic decoder. It does not
yet remove a Brillouin-zone copy.

Draft handoff:
`AgentTasks/aristotle-standalone/clifford-cover-projector-20260713/CliffordCoverProjector.lean`.
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/ARISTOTLE_B_Z2CUBED_FLAVOUR_COVER_STRATEGY.md` [Aristotle strategy: exact `Z2^3` flavour-cover successor]

Score: `0.807`

```text
# Aristotle strategy: exact `Z2^3` flavour-cover successor

Design the smallest exact Lean theorem program for the eight-sheeted
Brillouin-zone covering route described by Bakircioglu, Arnault, and Arrighi,
specialized to the repository's `3+1` QCA conventions.  This is a focused
strategy job.  Do not edit files and do not run a broad build.  Return
`B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`.
```

### 4. `PhysicsSM/Draft/NullEdge/FlavorCoverChargeObstruction.lean`

Score: `0.804`

```text
import Mathlib

/-!
# Flavor-cover charge obstruction

This module records a cheap representation-theoretic kill test for the proposed
eight-cover route to a strict local `3+1` null-edge walk.

The flavored-QCA cover is indexed by the regular additive action of
`(ZMod 2)^3`.  A scalar charge that commutes with every naked deck translation
must therefore be constant.  The explicit `6 + 2` hypercharge-shaped labeling
below is not constant, so it cannot be an invariant of the bare regular deck
action.

This does not rule out the wider route.  It requires additional structure:
gauge-twisted translation, a decoded/quotient charge, or physical breaking of
the full deck symmetry.

Provenance: clean-room formalization of the regular-cover argument motivated by
Bakircioglu, Arnault, and Arrighi, "Fermion Doubling in Quantum Cellular
Automata", arXiv:2505.07900.  The `6 + 2` multiplicities follow the conventional
one-generation left-handed quark/lepton doublet count used in
`PhysicsSM.StandardModel.OneGenerationTable`.

Status: draft theorem module.  All proofs are kernel checked; no external
evaluator is used.
-/
```

### 5. `PhysicsSM/Draft/NullEdge/Z2CubedFlavourCorner.lean`

Score: `0.802`

```text
import Mathlib

/-!
# Exact `Z2^3` corner-flavour census

This module folds the eight `{0, pi}^3` corner labels to one reduced-zone
representative and records the lost corner coordinate as a `Z2^3` flavour.
The result is deliberately a relabelling theorem: it does not remove any
crossing or derive a physical family count.

The full translation-symbol intertwiner belongs in a successor module.  Here
the finite census is isolated from matrix and trigonometric details, with a
too-coarse diagonal `Z2` negative control.

Provenance: clean-room formalization of the finite covering strategy discussed
in Bakircioglu, Arnault, and Arrighi (arXiv:2505.07900), specialized following
Aristotle strategy task `88a4d101-3cd4-43b1-ba8f-068a5707ee14`.  No external
code was copied.
-/
```

### 6. `AgentTasks/24h-publication-run-2026-07-12/MANUSCRIPT_CLAIM_DELTA.md` [Manuscript claim delta]

Score: `0.800`

```text
32 jobs); focused audit `2511852a` agrees on truth and scope |
| D-finite-cell-average-projection-controls | Replacing center values by normalized cell averages gives a finite piecewise-constant projection invariant under AE equality. On each selected cell it equals that cell's average and reproduces the constant-one field; the unnormalized mesh-two integral is exactly eight rather than one. | M/orig-comp | `ChangingMomentumCellProjection.projectFinite_congr_ae`, `projectFinite_eq_average`, `projectFinite_const_one_on_cell`, `rawCellIntegral_const_one`, `rawCellIntegral_two_control` | positive mesh for disjoint-cell and normalization statements; finite selected cell set | selected singleton cell at its center reproduces one | exact `8 != 1` wrong-scaling control; no `L2` contraction, strong refinement limit, or live multiplier composition yet | clean-room local composition after Aristotle no-go/audit; direct Lean PASS; targeted build PASS (2,740 jobs); aggregate guard build PASS (8,332 jobs); contraction successor `9ffa5c89` active |
| B-Z2-cubed-scalar-cover-intertwiner | A pi translation on any one momentum axis negates the live successive-axis split step. Pullback along the eight-sheet `Z2^3` cover is exactly multiplication by the flavour parity character; even sheets preserve the zero determinant and odd sheets exchange zero with pi. | M/import-comp | `Z2CubedFlavourIntertwine.factor_pi_shift`, `splitStep_pi_shift_axis0/1/2`, `splitStep_cover_intertwines`, `cover_det_alias`, `deck_nonidentity_witness`, `wrongCover_halfperiod_not_scalar`; Bakircioglu-Arnault-Arrighi arXiv:2505.07900 | live massless `4x4` successive-axis symbol; pi deck translations; fixed eight-label cover | one-axis pi shift sends origin identity to minus identity and changes the zero determinant fr
```

### 7. `AgentTasks/24h-publication-run-2026-07-12/ARISTOTLE_B_Z2CUBED_FLAVOUR_INTERTWINE.md` [Aristotle: exact `Z2^3` scalar cover intertwiner]

Score: `0.798`

```text
# Aristotle: exact `Z2^3` scalar cover intertwiner

Fill all eight proof holes in
`codex_24h_b_z2cubed_flavour_intertwine.lean` without changing any statement.
The theorem package diagnoses the eight-sheet cover of the live successive-axis
`3+1` symbol.  Preserve the scalar-parity intertwiner, determinant zero/pi
swap, nonidentity deck witness, and half-period negative control.

Success means an exact cover census with no claim that aliases are removed.
Failure should identify a false statement or the smallest missing matrix/trig
lemma; do not weaken the physics contract silently.

```yaml
aristotle:
  project_id: fddb28cc-3bb4-4cb3-a5e3-8b504fc91f29
  task_id: 15a4a58a-92f0-4fbf-87f6-4f0c373c49cc
  target_file: AgentTasks/aristotle-targets/codex_24h_b_z2cubed_flavour_intertwine.lean
  expected_module: PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-z2cubed-flavour-intertwine-20260712-project
  output_dir: AgentTasks/aristotle-output/fddb28cc-3bb4-4cb3-a5e3-8b504fc91f29
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested 2026-07-12 00:52 PDT. Aristotle preserved and proved all eight
statements. Integrated as
`PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine`; direct Lean and targeted
build pass. The scalar parity theorem and determinant zero/pi exchange are
exact diagnostics: the eight-sheet cover relabels all multiplicity and supplies
no internal flavour dynamics.
```

### 8. `AgentTasks/24h-publication-run-2026-07-12/B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md` [Package 1 — `Z2CubedFlavourCorner.lean` (finite census)]

Score: `0.796`

```text
### Package 1 — `Z2CubedFlavourCorner.lean` (finite census)

```lean
import Mathlib

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

abbrev PhaseCorner : Type := Fin 3 → ZMod 2
abbrev Flavour : Type := Fin 3 → ZMod 2
abbrev ReducedRep : Type := PUnit
def cover : ReducedRep → Flavour → PhaseCorner := fun _ f => f
def deck (g : Flavour) : PhaseCorner → PhaseCorner := fun c => g + c
def chi (f : Flavour) : ℤ := (-1) ^ (f 0 + f 1 + f 2).val

theorem card_corner : Fintype.card PhaseCorner = 8 := by decide
theorem cover_bijective : Function.Bijective (cover PUnit.unit) := by sorry
theorem corner_unique_rep_and_flavour (c : PhaseCorner) :
    ∃! f : Flavour, cover PUnit.unit f = c := by sorry
theorem deck_regular (c : PhaseCorner) : Function.Bijective (deck · c) := by sorry
theorem wrongCover_diagonal_not_surjective :
    ¬ Function.Surjective (fun g : ZMod 2 => (fun _ => g : PhaseCorner)) := by sorry

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner
```

All bodies are `by decide` (the `∃!` via `Fintype.existsUnique_iff` or from
`deck_regular`). Imports: `import Mathlib` only.
```

## Scoped paper hits

### 1. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.780`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1

### 2. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.776`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1

### 3. The Thirring quantum cellular automaton

Score: `0.761`
Zotero key: `RWB4DTXH`
arXiv: `1711.03920`
DOI: `10.1103/PhysRevA.97.032132`
URL: http://arxiv.org/abs/1711.03920

Abstract:

We analytically diagonalize a discrete-time on-site interacting fermionic cellular automaton in the two-particle sector. Important features of the solutions sensibly differ from those of analogous Hamiltonian models. In particular, we found a wider variety of scattering processes, we have bound states for every value of the total momentum, and there exist bound states also in the free case, where the coupling constant is null.

### 4. Index theory of one dimensional quantum walks and cellular automata

Score: `0.749`
Zotero key: `6MZT3FBH`
arXiv: `0910.3675`
DOI: `10.1007/s00220-012-1423-1`
URL: http://arxiv.org/abs/0910.3675

Abstract:

If a one-dimensional quantum lattice system is subject to one step of a reversible discrete-time dynamics, it is intuitive that as much "quantum information" as moves into any given block of cells from the left, has to exit that block to the right. For two types of such systems - namely quantum walks and cellular automata - we make this intuition precise by defining an index, a quantity that measures the "net flow of quantum information" through the system. The index supplies a complete characterization of two properties of the discrete dynamics. First, two systems S_1, S_2 can be pieced together, in the sense that there is a system S which locally acts like S_1 in one region and like S_2 in some other region, if and only if S_1 and S_2 have the same index. Second, the index labels connected components of such systems: equality of the index is necessary and sufficient for the existence of a continuous deformation of S_1 into S_2. In the case of quantum walks, the index is integer-valued, whereas for cellular automata, it takes values in the group of positive rationals. In both cases, the map S -> ind S is a group homomorphism if composition of the discrete dynamics is taken as the group law of the quantum systems. Systems with trivial index are precisely those which can be realized by partitioned unitaries, and the prototypes of systems with non-trivial index are shifts.

### 5. From quantum cellular automata to quantum lattice gases

Score: `0.745`
Zotero key: `65IM39PT`
arXiv: `quant-ph/9604003`
DOI: `10.1007/BF02199356`
URL: https://www.zotero.org/19894138/items/65IM39PT

Abstract:

A natural architecture for nanoscale quantum computation is that of a quantum cellular automaton. Motivated by this observation, in this paper we begin an investigation of exactly unitary cellular automata. After proving that there can be no nontrivial, homogeneous, local, unitary, scalar cellular automaton in one dimension, we weaken the homogeneity condition and show that there are nontrivial, exactly unitary, partitioning cellular automata. We find a one parameter family of evolution rules which are best interpreted as those for a one particle quantum automaton. This model is naturally reformulated as a two component cellular automaton which we demonstrate to limit to the Dirac equation. We describe two generalizations of this automaton, the second of which, to multiple interacting particles, is the correct definition of a quantum lattice gas.

### 6. Density cubes and higher-order interference theories

Score: `0.743`
Zotero key: `TXAKJHQ8`
arXiv: `1308.2822`
DOI: `10.1088/1367-2630/16/2/023028`
URL: https://www.zotero.org/19894138/items/TXAKJHQ8

Abstract:

Can quantum theory be seen as a special case of a more general probabilistic theory, similarly as classical theory is a special case of the quantum one? We study here the class of generalized probabilistic theories defined by the order of interference they exhibit as proposed by Sorkin. A simple operational argument shows that the theories require higher-order tensors as a representation of physical states. For the third-order interference we derive an explicit theory of "density cubes" and show that quantum theory, i.e. theory of density matrices, is naturally embedded in it. We derive the genuine non-quantum class of states and non-trivial dynamics for the case of three-level system and show how one can construct the states of higher dimensions. Additionally to genuine third-order interference, the density cubes are shown to violate the Leggett-Garg inequality beyond the quantum Tsirelson bound for temporal correlations.
