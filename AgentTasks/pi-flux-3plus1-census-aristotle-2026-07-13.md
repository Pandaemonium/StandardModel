# Aristotle strategy/construction job: pi-flux 3+1 crossing census

- Work item: `NE-3PLUS1-PIFLUX-001`
- Role: Visionary / Builder / Assassin
- Priority: lateral 3+1 architecture
- Date: 2026-07-13
- Status: successor harvested, semantically narrowed, replayed, and integrated

## Objective

Starting from the exact two-dimensional magnetic-translation seed, construct
the smallest three-dimensional cocycle-twisted finite-depth walk worth testing
as a strict local 3+1 Dirac architecture.  The decisive output is not merely a
projector or an origin tangent: it is an exact reduced-Brillouin-zone census of
both zero and pi quasienergy crossings.

## Required starting points

- `PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochSplitDeterminants.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean`
- `PhysicsSM/Draft/NullEdge/CliffordCoverDecoder.lean`
- `PhysicsSM/Draft/NullEdge/FlavorCoverChargeObstruction.lean`
- Aristotle-returned seed `PiFluxCocycleDecoder.lean`
- `AutonomousLab/work/NE-3PLUS1/CODEX_FLAVOR_COVER_OCTONION_ROUTE_2026-07-13.md`
- semantic context pack
  `AgentTasks/context-packs/pi-flux-3plus1-census-20260713-092006.md`

## Required construction ladder

1. Define three exact unitary magnetic translations on the smallest periodic
   cell supporting a nontrivial central cocycle.  State every pairwise
   commutator and prove the translations bijective/unitary.
2. Couple the translations to a finite internal Clifford register through a
   finite-depth local circuit.  Every primitive substep must have a finite
   causal cone; distinguish primitive locality from one-period effective
   range.
3. Compute the exact Bloch/Floquet symbol on the reduced Brillouin zone and
   prove the first-order origin tangent has the intended 3+1 Dirac rank and
   normalization.
4. Derive determinant or eigenvalue criteria for both `U(q) - I` and
   `U(q) + I`.  Classify every zero and pi crossing, including boundary and
   symmetry-related points.
5. Return one of: an exact one-species candidate; a scoped no-go for this
   cocycle/cell/register; or a sharpened missing hypothesis with the smallest
   next theorem.

## Mandatory adversarial checks

- A momentum-independent onsite projector is not a decoder.
- A second species at pi quasienergy is still doubling.
- Sampled momenta are not a full-zone census.
- Folding the Brillouin zone does not remove a species unless the physical
  quotient and observable algebra are defined and proved.
- Record chirality/topological charge at every crossing.
- Record broken lattice symmetries and every relevant counterterm they permit.
- Do not infer particle labels, color, hypercharge, chirality, or generations
  from the eight-sheet cardinality.
- Do not add trust-expanding declarations or weaken the Dirac tangent.

## Required output

Return a concise architecture memo, explicit matrices/Laurent words, a
proof-ready Lean target with tractable finite lemmas completed, and an honest
construction/no-go/missing-hypothesis verdict.  Produce the formulas before
attempting a broad repository build.

## Submission metadata

```yaml
aristotle:
  project_id: cdcc00ba-0380-49ea-8a9a-7f6d8a6a349c
  task_id: null
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/afpl-pi-flux-3plus1-census-20260713-project
  output_dir: AgentTasks/aristotle-output/cdcc00ba-0380-49ea-8a9a-7f6d8a6a349c
  status: integrated
```

## 2026-07-13 harvest and semantic audit

The returned `PiFlux3Plus1Census.lean` passed direct replay and proves a useful
finite-cell obstruction: two anticommuting involutive magnetic translations in
the commutant of an operator force every nonzero eigenspace to contain a
linearly independent partner.  The zero and pi specializations are immediate
and nonvacuous.

Independent Claude review found three prose overreaches in the returned file:
the Lean development contains no infinite lattice or Brillouin zone; it does
not classify the commutant as a displayed tensor factor; and nonscalarity of
`PL` alone does not rule out a rank-one projector.  The integrated revision at
`PhysicsSM/Draft/NullEdge/PiFlux3Plus1Census.lean` removes those claims and
attributes invariant-projector doubling to the spectral theorem itself.

The same Aristotle project was continued on the next escape test:
gauge-covariant intertwiners between projective translation representations,
followed by an explicit symmetry-breaking finite decoder and complete zero/pi
eigenspace census.  An apparent partner moved between sectors is not success.

## 2026-07-13 successor harvest

The continued project returned `GaugeTwistedMagneticDecoder.lean` with no proof
holes or trust-expanding finite-evaluation shortcut. Direct replay under the
pinned repository toolchain passed. The exact finite result is a `1 + 3`
eigenspace census on the smallest magnetic cell: the gauge-dressed abelian
symmetry permits a one-dimensional `+1` eigenspace, while retaining the second
naked anticommuting translation forces every eigenspace to double.

The Aristotle prose called the `+1` eigenline a Weyl crossing. That reading was
rejected during integration. The live module now states explicitly that it has
no momentum-dependent family, linear dispersion, local topological charge,
Brillouin-zone census, or 3+1 construction. It is an exact algebraic escape
control for the anomalous-Floquet route, not the final 3+1 theorem.

- Aristotle project: `cdcc00ba-0380-49ea-8a9a-7f6d8a6a349c`
- Reviewed source: `GaugeTwistedMagneticDecoder.lean`
- Integrated file: `PhysicsSM/Draft/NullEdge/GaugeTwistedMagneticDecoder.lean`
- Verification: direct `lake env lean` replay passed; the broader guard build
  was attempted but exceeded the five-minute command timeout without emitting
  a Lean error and must be rerun before any flagship claim.
