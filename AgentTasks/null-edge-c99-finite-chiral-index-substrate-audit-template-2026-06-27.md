# C99 audit template: finite chiral-index substrate

Date: 2026-06-27.

Use this when Aristotle project `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`
returns.

## Purpose

C99 should harden C98's toy guardrail:

```text
interface shape alone does not imply nonzero chiral index
```

by replacing arbitrary user-supplied plus/minus counts with an index computed
from finite substrate data.

## Current source anchors

- Luscher, `arXiv:hep-lat/9802011`: exact lattice chiral symmetry and the
  Ginsparg-Wilson relation.
- Neuberger / overlap Dirac index literature: finite-volume overlap index
  motivates a gamma5-like grading and an operator-dependent index.
- Golterman-Shamir, `arXiv:2311.12790`: propagator zeros can poison lattice
  chiral-gauge interpretations.
- Golterman-Shamir, `arXiv:2505.20436`: mirror/vectorlike and symmetric-mass
  generation constraints remain hard release hazards.

## Accept as strong C99 if all hold

- Defines a finite substrate richer than C98's arbitrary `plusCount` /
  `minusCount` fields.
- Carries an explicit grading or chirality involution `Gamma`, distinct from the
  operator `D`.
- States or proves the grading law, ideally:

  ```text
  Gamma^2 = 1
  ```

- Derives plus/minus sectors from the grading, not by fiat.
- Defines a finite operator `D` and relates the counted zero modes or kernel
  data to `D`.
- States a grading/operator compatibility law, either the strict chiral case:

  ```text
  Gamma D + D Gamma = 0
  ```

  or an explicit Ginsparg-Wilson-style deformation such as:

  ```text
  Gamma D + D Gamma = D Gamma D
  ```

- Makes `ker(D)` on plus/minus sectors a real restricted-kernel construction,
  not an ad hoc intersection or arbitrary count.
- Includes finite-dimensional / finite-state witnesses in Lean, such as
  `FiniteDimensional`, `Fintype`, or an explicit `Fin n` model.
- Defines an index from substrate data, ideally:

  ```text
  index(D) = dim ker(D on Gamma=+1) - dim ker(D on Gamma=-1)
  ```

- Provides an explicit zero-index model.
- Provides an explicit nonzero-index model.
- Proves the C98-style non-implication:

  ```text
  interface shape does not imply nonzero index
  ```

- States clearly that this is not C1 release, not ghost-zero safety, and not
  regulator-removal stability.

## Accept as useful fallback if all hold

- Uses a finite branch/state table rather than finite linear algebra.
- Counts are derived from actual finite states and predicates, not arbitrary
  count fields.
- Has a grading/chirality predicate or involution that determines the signs.
- Provides explicit zero-index and nonzero-index examples.
- Avoids release-facing names like unqualified `ChiralIndexWitness`.

This fallback is weaker than a real operator substrate but still improves on
C98.

## Reject or downgrade if any hold

- Reintroduces arbitrary `plusCount` / `minusCount` fields without deriving them
  from substrate data.
- Uses a Boolean `hasInterfaceShape` tag as the only interface notion.
- Defines plus/minus sectors by fiat with no grading/involution.
- Defines a grading but gives no compatibility relation between `Gamma` and `D`.
- Defines `Gamma` as a renamed free sign index with no operator content.
- Produces the nonzero-index example only by hand-setting `Gamma` so that
  `ker D` lands in the desired sign, with no operator mechanism.
- Gives zero-index and nonzero-index examples that do not share one common
  substrate datatype/framework.
- Claims or implies C1 release.
- Imports C97's Boolean `GaugeData` scaffold as evidence for physical Wilson
  release.
- Uses generic release-facing terms such as unqualified `ChiralIndexWitness`.
- Provides only existential predicates with no explicit countermodel/witness.
- Uses `native_decide` to establish an index value in anything intended as
  trusted code. Draft use must be explicitly labelled draft-only.

## Required provenance / convention note

C99 should state which convention it formalizes:

- strict finite chiral anticommutation;
- finite GW-style relation;
- or a toy finite analogue.

It must also keep this substrate grading distinct from:

- spacetime chirality `Gamma_s`;
- internal Furey grading `chi_E`;
- cochain/form degree.

It should explicitly disclaim the continuum Atiyah-Singer theorem unless such a
theorem is actually formalized.

## Follow-up decisions

If strong C99 succeeds:

- Integrate the module.
- Ask Claude to review it with source attached.
- Prepare the next C1 index-witness job that tries to connect C99 substrate data
  to the C93 overlap/GW interface once C93 returns.

If fallback C99 succeeds:

- Integrate as planning infrastructure.
- Ask Aristotle for C99b: upgrade branch-table substrate to explicit grading
  operator or finite linear substrate.

If C99 fails or is too toy-like:

- Submit C99-v2 with explicit grading-involution requirement and a smaller
  target, possibly a hand-coded finite `Fin n` branch model before full linear
  algebra.

## Non-goals

Do not use C99 alone to claim:

- Gate C1 release.
- absence of ghost zeros.
- regulator removal stability.
- anomaly cancellation.
- physical anti-vectorialization.

C99 is only the finite index-substrate layer.
