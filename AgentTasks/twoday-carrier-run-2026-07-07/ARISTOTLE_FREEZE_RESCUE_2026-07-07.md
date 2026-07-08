# Aristotle freeze rescue - 2026-07-07

Status: harvest / cancel / small-refill record.

User request: the Aristotle jobs appeared frozen.  Codex downloaded current
snapshots, inspected partial results, canceled the frozen tasks, landed the one
clean kernel-checking payload, and submitted a smaller three-job replacement
batch.

## Snapshot harvest

Fresh in-progress snapshots were downloaded for the 11 live `RUNNING` projects
reported by `aristotle list` at the start of this rescue pass.

Snapshot locations:

- Compact extracted/rooted review copies:
  `AgentTasks/aofr/<project-id>/snapshot.zip`
- First attempted long-path archive copies:
  `AgentTasks/aristotle-output/partial-audit-20260707-freeze-rescue/<project-id>/in-progress-snapshot.zip`

The repo integration helper was run in dry-run mode against `AgentTasks/aofr`.
It found one complete candidate and several partial or stale candidates.

## Harvested and canceled

| Project ID | Job | Harvest decision |
|---|---|---|
| `7f7c1ea6-a75d-429c-9ab9-3c447b5250c9` | P12 Koide/T-solder SUB-NAT | Landed `PhysicsSM/Draft/NullEdge/Carrier/KoideSubNatProbe.lean`; guard-pinned in `CarrierAxiomGuard.lean`; canceled old task. |
| `8d95b408-7e9e-43b6-8478-6bb9540545f8` | P03 nonabelian `Q_C` two-face | Partial `QCNonabelianTwoFace.lean` has three proof holes; archived and resubmitted as a focused proof job. |
| `4b4d1f1b-389d-4e90-ade3-36a9d1183869` | P02 Q11 exterior-power RC0 | Partial `Q11GroupAction.lean` has a useful Cauchy-Binet/functoriality sketch but still has a proof hole; archived and resubmitted as a focused strategy job. |
| `72b75f0d-99fb-4801-aa8f-86627690298c` | P01 Stage A positive quotient | Partial `KreinStageAPositiveQuotient.lean` contains many proof holes; not close enough to land. |
| `fbdbe43f-b8c4-4edc-9f28-d09bbdbf824c` | Q10 `d = 4` self-dual positive corner | Snapshot contained only stale guard/aggregator candidates; no landed result. |
| `f8aa05c8-26a4-42f3-810b-a09f8be41686` | Q08 exterior quotient follow-up | Snapshot contained only stale guard/aggregator candidates; no landed result. |
| `5ff9424e-bd0e-46ed-a90a-772fbafae72a` | Q12 E4 healing semantic audit | Snapshot would remove live E4 theorems; not integrated. |
| `6e37da00-9a2b-44d1-8298-58b1b25e79c3` | Q04 octonion left-action bridge | Snapshot contained stale or harmful deletions in unrelated files; not integrated. |
| `373f0283-593f-4394-a62a-90d83ae2f4ff` | Q01 Gauss positive quotient | Partial `CarrierGaussConstraintQuotient.lean` has proof holes and stale deletes; not integrated. |
| `4b462390-ee99-4a5c-9fb4-dc434e63316c` | Q09 screen/BW/Reeh witness | Snapshot contained stale copies only; not integrated. |
| `96058502-bcfd-4336-8008-5cb1ffa91ebe` | Q12 C8 / PSA sector bridge | Snapshot contained stale copies only; not integrated. |

All 11 projects were canceled with `aristotle cancel --project-id ...`.  A
subsequent `aristotle list --limit 20` showed them as `IDLE`.

## Landed result: P12 Koide / SUB-NAT exact gate

New Lean file:

- `PhysicsSM/Draft/NullEdge/Carrier/KoideSubNatProbe.lean`

New guarded theorems:

- `KoideSubNat.kappaB2_tet`
- `KoideSubNat.subNat_strict_fails`
- `KoideSubNat.subNat_projective`
- `KoideSubNat.subNat_outcome_table`

Claim boundary:

- exact rational bookkeeping only;
- B1 gives `kappa = 2`, B2 gives `kappa = 1`;
- strict subdivision naturality fails by the inserted pass-through zero mode;
- projective/genuine-corner and corner-count-renormalized subdivision
  naturality hold;
- no physical mass-value prediction is claimed.

Verification run:

- `lake env lean PhysicsSM/Draft/NullEdge/Carrier/KoideSubNatProbe.lean`
- `lake build PhysicsSM.Draft.NullEdge.Carrier.KoideSubNatProbe`
- `lake env lean PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean`

## Replacement small batch

| Project ID | Task ID | Job name | Type | Intent |
|---|---|---|---|---|
| `ef6a366f-e0a7-4230-b427-ec03f79d2608` | `c701fc30-b5ba-4426-8cd8-ab7ad4afa6ea` | `ne-rescue-p03-qc-twoface-krein-finish-20260707` | focused proof | Finish exactly the three holes in the Pauli two-face/Krein witness. |
| `91260b54-371f-4d73-9765-813461610244` | `a07bc66f-2378-4512-aa92-5b18e187cd87` | `ne-rescue-p02-q11-cauchybinet-minipack-20260707` | strategy/proof plan | Compare live and partial Q11 files; produce the next minimal Cauchy-Binet proof package. |
| `4f0e6c21-232d-492d-9850-c1ab97e5ff64` | `e31c239a-31a6-4279-b12f-017443171544` | `ne-rescue-p12-koide-subnat-semantic-audit-20260707` | semantic audit | Audit the new Koide/SUB-NAT landing for overclaim, vacuity, denominator issues, and stronger low-risk follow-up statements. |

Queue poll immediately after submission showed all three projects `RUNNING`.

## Remaining partials to reuse

- P03 partial is close and should be harvested first if `ef6a366f` returns.
- Q11 Cauchy-Binet partial is useful as a theorem-shape sketch, but the live
  file should not absorb it until the Cauchy-Binet core is kernel-clean.
- P01 Stage A needs a much narrower decomposition before another proof job.
  The broad adapted-basis theorem had too many simultaneous proof obligations.

## Replacement batch harvest

The three replacement projects were later downloaded through
`Scripts/aristotle/integrate_completed.py`.  The integration helper found no
automatic path candidates because the returned files were standalone payloads
and reports rather than path-matching patches, so Codex inspected each archive
manually.

| Project ID | Job | Return decision |
|---|---|---|
| `ef6a366f-e0a7-4230-b427-ec03f79d2608` | P03 nonabelian `Q_C` two-face proof finish | Landed as `PhysicsSM/Draft/NullEdge/GateYM/QCNonabelianTwoFace.lean`; added to `GateYM.lean`; guard-pinned in `SlabAxiomGuard.lean`. |
| `91260b54-371f-4d73-9765-813461610244` | Q11 Cauchy-Binet minipack strategy | Report harvested to `ARISTOTLE_Q11_CAUCHYBINET_RESCUE_PLAN_2026-07-07.md`; no Lean integrated yet. |
| `4f0e6c21-232d-492d-9850-c1ab97e5ff64` | P12 Koide/SUB-NAT semantic audit | Applied the low-risk strengthening that removes the unused nonzero hypotheses from `kappaB1_eq` and `kappaB2_eq`. |

P03 claim boundary:

- exact Pauli-type two-face witness over Gaussian rational entries;
- Hilbert-adjoint closure mass is an operator Gram and hence positive
  semidefinite;
- the same holonomy gives an exact Krein negative control, so Krein positivity
  is false in this witness;
- no continuum, ensemble, or physical mass-value claim is added.

Q11 claim boundary:

- functor-law route only;
- determinant cocycle / RC0 / unimodularity remain parked until separately
  kernel-checked.
