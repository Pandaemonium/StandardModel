# Sedenions Research Workspace

This folder collects the new sedenion zero-divisor research program.  The
central idea is to treat sedenion zero divisors as a structured finite geometry
rather than as accidental algebraic pathology.

## Core Thesis

```text
Sedenion zero divisors generate a signed affine-plane geometry in F_2^4.
The unsigned support geometry appears to be a doubly shortened RM(2,4) code.
The signed Cayley-Dickson cocycle may supply the missing quadratic / Z_4
refinement that connects to stabilizer, Barnes-Wall, Clifford, and Kerdock
structures.
```

## Files

- `SedenionZeroDivisors_ResearchProposal.md`
  - high-level proposal and priority order.
- `Literature_Map.md`
  - references and what each source supports.
- `CayleyDickson_Convention.md`
  - recursive basis, sign, and orientation convention for this branch.
- `SignedAffinePlaquettes.md`
  - core theorem targets for zero divisors as signed affine 2-planes.
- `ReedMuller_BarnesWall_Bridge.md`
  - code/lattice bridge and Barnes-Wall guardrails.
- `Stabilizer_QuantumInfo_Program.md`
  - stabilizer-state, Clifford, and magic-state tests.
- `S3_Generation_Physics_Program.md`
  - physics-facing `S_3` generation-symmetry tests.
- `PSL_Kerdock_Cocycle_Program.md`
  - signed `GL(3,2)`, `PSL(2,7)`, and `Z_4`/Kerdock questions.
- `DiscretePhysics_COG_Program.md`
  - finite cancellation dynamics and COG-style toy models.
- `Computational_Roadmap.md`
  - concrete script and reproducibility plan.
- `Research_Status_2026-05-23.md`
  - current finite-computation findings and Aristotle wave priorities.
- `Physics_Moonshot_Directions_2026-05-23.md`
  - next physics-facing theorem targets after the first two Aristotle waves.
- `Moonshot_Triage_2026-05-23.md`
  - archived negative moonshot results and why they are not imported by default.
- `../Scripts/sedenions/explore_zero_divisor_geometry.py`
  - deterministic finite exploration script for the first theorem targets.

## Current Status

This is a proposal workspace.  No file in `Sedenions/` should be cited as a
verified theorem.  A first reproducible Python computation now supports the
initial finite claims:

```text
python Scripts/sedenions/explore_zero_divisor_geometry.py

signed zero-product supports = 42
all same-strut mixed affine supports = 63
C_ZD = { c in RM(2,4) : c_0 = c_8 = 0 }
dim C_ZD = 9
W_CZD(y) = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12
```

Both the 42 signed zero-product supports and the broader 63 same-strut mixed
affine supports span the same shortened RM(2,4) subcode.  This is still an
oracle computation, not a Lean proof.

Draft Lean results from the first Aristotle wave now live under:

```text
PhysicsSM/Draft/Sedenions/
```

These files are imported by `PhysicsSMDraft.lean`, not by the trusted root.
They are useful, sorry-free finite theorem clusters, but remain draft-facing
while the convention, structural proof strategy, and publication story mature.

A second Aristotle wave has added five physics-facing draft modules:

```text
StabilizerMagicMoonshot.lean
GenerationCancellationGeometry.lean
PSL27FlavorGeometry.lean
AnomalyCancellationAnalogue.lean
BarnesWallFirstShell.lean
FanoComplementGeneration.lean
```

The headline correction is important: in the current finite support model, the
naive order-three `psi` action does not generate magic from stabilizer
plaquettes.  Instead, it maps the 42 four-point zero-product plaquettes into
seven partner-closed eight-point supports.  This is a useful negative result
and a cleaner target for the next generation-symmetry analysis.

The next research targets are tracked in
`Physics_Moonshot_Directions_2026-05-23.md`.  The most concrete one asks
whether each `psi`-coarsened sector contains the three perfect matchings of a
four-point Fano complement, giving a finite toy model for generation labels.
This target is now proved in the cleaned draft module
`PhysicsSM/Draft/Sedenions/FanoComplementGeneration.lean`: the 42
zero-product plaquettes split as 7 sectors times 3 perfect matchings times 2
edges, and the sector stabilizer induces the full finite `S3` action on the
three matchings.

Some later moonshot jobs returned useful negative certificates rather than
productive package material.  Those are recorded in
`Moonshot_Triage_2026-05-23.md` and intentionally left as archived Aristotle
outputs instead of imported Lean modules.

## Overclaim Guardrails

- Do not say sedenion zero divisors construct `Lambda_16` until an explicit
  lattice construction is given and proved isometric to Barnes-Wall.
- Do not say `C_ZD` is a stabilizer code until a symplectic Pauli check
  system and code parameters `[[n,k,d]]` are computed.
- Do not say the sedenion `S_3` generation symmetry preserves zero-divisor
  geometry until its action is computed on supports and signs.
