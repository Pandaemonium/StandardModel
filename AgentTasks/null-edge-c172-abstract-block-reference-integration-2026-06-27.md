# C172 — Abstract block-reference `GateC1_NU` instantiation model

Formalization: `RequestProject/C172AbstractBlockReference.lean`
(namespace `GateC1.AbstractBlock`). Builds clean, no proof placeholders, axioms limited to
`propext, Classical.choice, Quot.sound`.

## Executive verdict

The cheapest reference that can instantiate the C159 reference-import interface
is a **finite-sector, block-diagonal scalar model**: one real inverse-propagator
mass per sector, one designated light sector, a heavy complement, and a single
gap `γ > 0`. With this model we can already *prove* the finite spectral part of
the import contract — one-light-sector content and a true bad-sector
inverse-propagator gap — purely from the C154 sector-signature match and a
uniformly gapped straight-line homotopy. Everything physical beyond the finite
spectrum (anomaly/index, locality/control, determinant-line, SM gauge
internality) stays as an explicit external certificate. The abstract model is a
*scaffold*, not a physical claim, and is engineered so a direct
flavored-overlap / domain-wall reference drops in unchanged once C167–C171
mature.

## Abstract block-reference data / API

- `BlockReference S`: `light`, `refMass : S → ℝ`, `gap`, with `gap_pos`,
  `light_is_light` (`|refMass light| < gap`) and `heavy_gapped`
  (`∀ s ≠ light, gap ≤ |refMass s|`). The last two encode **exactly one** light
  sector: `light` is the unique sector with `|mass| < gap`.
- `NullEdge S`: `neMass : S → ℝ`, the per-sector mass of the level-resolving
  point-split/Adams `W_branch`.
- `homotopyMass ne R t s = (1-t)·neMass s + t·refMass s`: straight-line homotopy.
- Predicates: `SignatureMatch` (C154 GO test, `0 < neMass·refMass` on bad
  sectors), `NullEdgeBadGap` (`gap ≤ |neMass|` on bad sectors — a true inverse
  gap, not a propagator zero), `NullEdgeLight`, `OneLightSector`,
  `UniformlyGapped`.

## Transfer theorem

- `segment_abs_ge`: the geometric core — a segment between two same-sign reals of
  magnitude `≥ γ` never approaches `0` closer than `γ` (opposite signs would
  force a zero crossing). This is the C154 no-zero-crossing fact.
- `uniformlyGapped_of_match`: `SignatureMatch ∧ NullEdgeBadGap ⟹ UniformlyGapped`.
- `badGap_of_uniformlyGapped`: `UniformlyGapped ⟹ NullEdgeBadGap` (t=0 endpoint).
- `transfer`: `SignatureMatch ∧ NullEdgeBadGap ∧ NullEdgeLight ⟹`
  `OneLightSector ∧ NullEdgeBadGap ∧ UniformlyGapped`.

## `GateC1_NU` assembly and claim boundary

`GateC1_NU ne R AnomalyIndex LocalityControl DeterminantLine SMInternality` is a
`Prop` structure whose first two fields (`oneLight`, `badInverseGap`) are
discharged by the transfer, while the last four are **external Prop
certificates** carried unproved. `assemble_GateC1_NU` builds it from the finite
spectral inputs plus the four supplied certificates.

Claim-boundary checklist (NOT proved by this model):

- [ ] **Anomaly / index** — `AnomalyIndex` (C171 import). Not from GW algebra.
- [ ] **Locality / control** — `LocalityControl` (C156 path-shell or admissible
      staggered/overlap locality). Not from a sign function alone.
- [ ] **Determinant-line / ghost-zero** — `DeterminantLine`. Not hidden.
- [ ] **SM gauge internality** — `SMInternality` (C165 `SMActsInternally`).
- [ ] **Physicality** — the abstract block reference is not physical by itself.
- [ ] **C163 multiplet obstruction** — not bypassed; one light sector is an
      *assumed* level-resolving input (`NullEdgeLight` + `NullEdgeBadGap`),
      never derived from corner parity.
- [x] Bad-sector removal is a true inverse-propagator gap `gap ≤ |mass|`, not a
      propagator zero.

## Migration path to direct reference import (C167–C171)

`BlockReference` is the import interface; a direct flavored-overlap or
domain-wall reference is simply another `BlockReference S`.

- `SameBadSigns Rabs Rdir`: shared `light` and matching bad-sector signs.
- `signatureMatch_migrate`: a null-edge match against the abstract reference
  transports to any direct reference with the same bad-sector signs.
- `transfer_migrate`: the full spectral transfer carries to the direct
  reference. The swap once C167–C171 mature is: replace `Rabs` by `Rdir`, supply
  `SameBadSigns`, and reuse the existing certificates — spectral conclusions are
  unchanged. The four external certificates are then upgraded from abstract
  placeholders to their direct flavored-overlap / domain-wall imports.
