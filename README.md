# StandardModel: machine-verified mathematics for the origin of mass

A Lean 4 formalization project (pinned toolchain `leanprover/lean4:v4.28.0`,
Mathlib-based) with one flagship research program and a family of supporting
formalization assets. The rule that organizes everything: **the Lean kernel is
the source of truth** - a result counts only when the intended statement is
correctly represented, kernel-checked, axiom-audited, and its conventions are
documented.

## The flagship: the null-edge origin-of-mass program

The physical thesis under formalization: matter is trapped, mutually
disagreeing light - invariant mass is the obstruction to coherent null
transport, and whatever the topology of a finite complex protects stays
massless. The program is built in honest layers:

- **Kinematic layer (trusted).** The finite Plucker-mass theorem: for null
  spinors `psi_1..psi_n` and `P = sum psi_i psi_i^dagger`,
  `det P = sum_{i<j} |psi_i wedge psi_j|^2` - mass squared is total pairwise
  null-direction disagreement, zero iff all directions collinear
  (`PhysicsSM.Spinor.PluckerMass`, trusted namespace). Manuscript: P1 draft in
  `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`.
- **Carrier layer (draft, guard-pinned).** A finite null-edge Dirac operator
  `D = sum_e c(alpha_e) nabla_e + Gamma phi` with kernel-checked discrete
  Weitzenboeck decomposition `4 D^#D = Q_A^# + Q_C^# + 4 Q_T + 4 E_#` (an
  algebraic identity for an arbitrary `StarRing` involution `#`; the genuine
  indefinite/Krein reading is pinned separately, see the `kappa = 2` witness
  below) separating the aperture (kinematic), closure (gauge), turn
  (Higgs-shaped), and soldering-gradient (gravity-shaped) mass channels; the
  abstract total-square identity `Q_A = Q(sum alpha)` (its concrete
  identification with the trusted `det P` kinematic mass is still an open crux,
  see below); a
  certified Pontryagin `kappa = 2` fundamental symmetry with strictly positive
  flat-sector Krein mass form; and the finite McKean-Singer index-protection
  family (masslessness of the chiral surplus is topological - immune to every
  potential and transport). All under `PhysicsSM/Draft/NullEdge/Carrier/` with
  build-enforced axiom pins in `CarrierAxiomGuard.lean`.
- **Open cruxes (tracked, not claimed).** Physical-sector (off-flat) Krein
  positivity; the concrete `Q_A`-to-`det P` (trusted kinematic mass)
  identification; the all-slots-active glue witness; beyond-leading closure
  positivity; every continuum statement.

## Supporting formalization assets

- **CodeLatticeE8** (publication artifact): from the extended binary Hamming
  `[8,4,4]` code through Construction A to E8 - the 240 short vectors, root
  bridge, Cartan data, Weyl closure, theta-series checks, and the SPL-facing
  `Theta_E8 = E4` chain (`CodeLatticeE8.lean`; standalone wrapper in
  `CodeLatticeE8Standalone/`).
- **Octonion core**: kernel-checked XOR-basis octonion model (Moufang,
  alternativity, norm multiplicativity), triality-conjugation criterion, and
  the Furey program layer (Cl(6) ladder operators, minimal left ideal, charge
  arithmetic).
- **Lattice gauge theory**: strong-coupling Wilson-loop area law
  (kernel-checked at concrete-lattice level) and transfer-gap machinery under
  the GateYM lane, guard-pinned in
  `PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean`.
- **Chirality substrate**: Ginsparg-Wilson / overlap chirality and a chiral
  index calculus (GateC1/GateC2 lanes).

## Trust model

Three levels, never blurred:

1. **Trusted** (`PhysicsSM` outside `Draft/`): compiles with no `s o r r y`,
   no new axioms, no native evaluation; axiom footprint
   `[propext, Classical.choice, Quot.sound]`.
2. **Draft** (`PhysicsSM/Draft/`): kernel-clean results staged for promotion;
   flagship draft theorems carry build-enforced `#print axioms` guard blocks -
   a flagship without a guard block is not "landed".
3. **Prose**: manuscripts and analyses use an explicit claim calculus
   (`T`/`T|H`/`M`/`C` with originality tags); interpretation never rides in a
   theorem statement.

## Build quickstart

```powershell
lake build                 # full project (pinned toolchain v4.28.0)
lake build CodeLatticeE8   # the E8 publication artifact
lake env lean PhysicsSM/Path/To/File.lean   # fast single-file check
```

Windows note: after a cache wipe, build ProofWidgets JS once
(`cd .lake/packages/proofwidgets && lake build widgetJsAll`). The standalone
reviewer build for E8 lives in `CodeLatticeE8Standalone/`. Full build,
verification, and hygiene commands: `docs/BUILD.md`.

## Where to start reading

The master document map is **`docs/DOCUMENT_MAP.md`** - every important
document, categorized, with one-line descriptions and status tags. The
five-document shortlist:

1. This README.
2. `AGENTS.md` - the working contract (humans and AI agents alike).
3. `NULL_EDGE_RESULTS.md` - the results map of the flagship program, by trust
   level.
4. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` - the first
   paper.
5. `AgentTasks/twoday-carrier-run-2026-07-07/SYNTHESIS_BEYOND_MASS.md` - where
   the program is going next.

## For AI agents

`AGENTS.md` (mirrored by `CLAUDE.md`) is the always-on contract: trusted-vs-
draft rules, forbidden tokens, octonion and physics conventions, Aristotle
policy, MCP tooling, provenance and text-hygiene rules. Read it before
touching Lean.

## Publications

`Sources/Null_Edge_Causal_Graph_Publication_Plan.md` (stable topic IDs
P1-P12), `Sources/Null_Edge_Publication_Outlines_2026-07-07.md` (five
Letter-caliber outlines, P13+), the P1 manuscript draft, and the
Hamming/E8 manuscript (`Sources/Hamming_ConstructionA_E8_Manuscript_*.md`).
