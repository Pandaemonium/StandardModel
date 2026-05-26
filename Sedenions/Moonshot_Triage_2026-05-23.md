# Moonshot Triage - 2026-05-23

This note records which Aristotle-returned sedenion moonshot results are useful
as research evidence but should not be integrated directly into the live Lean
tree yet.

The guiding rule is simple: negative or dead-end finite classifications are
valuable for steering the project, but long-running `native_decide` modules
should not become part of the default draft package unless they support the
main mathematical story.

## Archived But Not Integrated

The following jobs returned sorry-free Lean modules and passed targeted
`lake env lean` checks against the live checkout. They are intentionally left
as archived Aristotle outputs for now.

| Job | Aristotle ID | Returned module | Triage |
| --- | --- | --- | --- |
| M6 | `e95c9a61-ce01-48f3-b05c-ea5066feeb72` | `COGDynamics.lean` | Useful discrete-dynamics certificate, but not central enough to import by default. |
| N3 | `5f9aa81f-2ac7-4939-b95f-eae61d2ed792` | `Z4KerdockRefinementMoonshot.lean` | Useful negative result: the sign system is too free for a nontrivial Kerdock-style lift. |
| N4 | `eb44bb5f-4b80-4a78-b62a-eb452469d219` | `QuantumCodeExtractionMoonshot.lean` | Useful negative result: the natural code family does not yield a nontrivial CSS code. |
| N5 | `bad19390-88b1-4208-b2b7-01eb4392a2f7` | `BarnesWallLatticeConstructionMoonshot.lean` | Important negative result: single-level Construction A from `C_ZD` or `RM(2,4)` does not give `BW16` by index. |
| N6 | `57a5bceb-a551-4184-9220-71ec8f403909` | `FlavorChargeYukawaMoonshot.lean` | Useful toy classification: the finite geometry forces democratic couplings, not hierarchy. |

Local extracted paths, when present, are under:

```text
AgentTasks/aristotle-output/<job-id>-extracted/
```

## Positive Results

Two completed jobs returned positive, central results.  The Fano-complement
generation cluster has been cleaned and integrated.  The affine symmetry
classification remains a heavy certificate pending cleanup.

| Job | Aristotle ID | Returned module | Result |
| --- | --- | --- | --- |
| N1 | `234f49d7-4495-4257-8419-8f2fe4fa628b` | `FanoComplementGeneration.lean` | Integrated clean draft module proving the `42 = 7 * 3 * 2` sector/matching picture and an induced full `S3` action on the three matchings. |
| N2 | `054fca4d-e5ed-401e-9ad4-b237b310c2c7` | `AffineSymmetryClassificationMoonshot.lean` | Classifies affine preservers: 336 for the 42 zero-product supports and 2688 for `C_ZD`. |

Cleanup notes:

- N1 has been refactored to reuse the existing `GenerationCancellationGeometry`,
  `PSL27FlavorGeometry`, and `GL32Action` modules.  The cleaned module is
  imported by `PhysicsSMDraft.lean`.
- N2 avoids `import Mathlib`, but it is a heavy finite enumeration with large
  heartbeat budgets.  Its results are valuable, but the publication-facing path
  should extract a compact theorem cluster and keep the exhaustive certificate
  behind a clear draft boundary.  Cleanup job
  `a492ee01-669d-4eef-ae90-ed37fe3ceea1` was submitted on 2026-05-24.

## What We Learned

### Fano-Complement Generation Geometry

The positive N1 result gives the cleanest finite generation story so far.  The
42 zero-product plaquettes split as:

```text
42 = 7 Fano-complement sectors * 3 perfect matchings * 2 edges per matching.
```

For a canonical sector, the six zero-product plaquettes are the six edges of a
complete graph on the four complement vertices.  Those six edges have exactly
three perfect matchings.  The `GL(3,2)` stabilizer of the sector has order 24,
acts on the three matchings, and induces all six permutations of them.  This is
a precise finite `S3` candidate; it is not yet the physical `S3` from the
Clifford-algebra literature.

### Affine Symmetry Classification

The positive N2 result says the visible `GL(3,2)` action is almost the full
affine symmetry of the zero-product supports.  The affine preservers of the 42
zero-product supports have cardinality 336, decomposing as the 168 lifted
`GL(3,2)` maps together with the partner swap by translation through coordinate
8.  The code `C_ZD` has a larger affine symmetry group of cardinality 2688, so
the code symmetry is eight times larger than the zero-product-support
symmetry.

### Quantum Codes

The natural code family around `C_ZD`, `C_ZD^perp`, `RM(1,4)`, and the
shortened `RM(1,4)` does not produce a nontrivial CSS code. The most important
point is conceptual: the plaquettes remain best understood as stabilizer
states or state-like finite objects, not as stabilizer check systems.

This should prevent overclaiming in the quantum-information line. Future work
should only revisit quantum codes if it introduces genuinely new data, such as
a symplectic Pauli labeling, a non-CSS construction, or a quotient/puncturing
operation with a clear physical interpretation.

### ZMod 4 / Kerdock

The `ZMod 4` refinement attempt is informative mostly because it fails in a
clean way. For the zero-product supports, the sign freedom is too large: the
finite constraints do not single out a rigid Kerdock-like structure. The
support-level Arf-type invariant remains useful, but it appears to reduce to
the already-known binary support obstruction.

Future work should focus on canonical signs, gauge classes, or external
structures that restrict signs further, rather than expecting the raw
sedenion zero-product supports to determine a Kerdock code by themselves.

### Barnes-Wall

The Barnes-Wall lattice construction attempt closed an important tempting
shortcut.  Construction A from `C_ZD` has index `128`, while the standard
target index for a naive `BW16` comparison is `16`.  The full `RM(2,4)`
Construction A attempt also misses the target, with index `32`.

The same job records useful finite diagnostics: `C_ZD` gives an even
Construction A lattice with minimum squared norm `4`, and a simple
Construction D first-shell proxy gives `2240` vectors, strictly below the
Barnes-Wall kissing number `4320`.  These are good guardrails, but they are not
the desired lattice construction.

Future Barnes-Wall work should therefore use a genuine multilevel
Construction D model, an explicit `ZMod 4`/Kerdock-type lift, or a direct
comparison with a maintained `BW16` model.  Do not keep retrying the
single-level Construction A path from `C_ZD`.

### Discrete Dynamics

The COG-style transition-system model is a nice finite certificate: local
moves generated by zero-product supports have reachable component `C_ZD`, and
conserved quantities are governed by the dual code. This is good conceptual
evidence for a cancellation-dynamics story, but it is not yet a central paper
result.

If this path is revived, the next productive step is a short hand-written
structural proof of the coset/conservation statements, not importing the full
finite enumeration module.

### Flavor and Yukawa Toys

The finite flavor toy model did not produce hierarchy. Instead, the symmetry
forces democratic couplings: every distinct nonzero pair participates
uniformly. This is a useful negative result because it says the raw
zero-divisor geometry alone is too symmetric to model flavor structure.

Future flavor work should therefore look for symmetry-breaking data, sector
choices, boundary conditions, or a more faithful implementation of the
Clifford-algebra `S_3` action from the physics literature.

## Productive Paths Forward

The next work should prioritize structural and positive targets:

- clean and integrate the affine symmetry classification as a clearly marked
  finite certificate, with the 336/2688 cardinality results easy to cite;
- treat the Barnes-Wall route as a genuine multilevel Construction D or
  explicit-lattice comparison problem, not as a single-level Construction A
  problem from `C_ZD`;
- extract small structural lemmas from the archived negative modules only
  when they become necessary for a paper argument.

## Integration Policy

Do not import the archived modules into `PhysicsSMDraft.lean` unless a later
task explicitly revives that line. If a result from one of these jobs is cited
in prose, cite the Aristotle job ID and summarize it as an archived finite
certificate rather than as part of the maintained Lean package.
