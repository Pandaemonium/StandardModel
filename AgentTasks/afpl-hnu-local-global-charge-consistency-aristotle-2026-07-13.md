# Aristotle successor: HNU local/global charge consistency

```yaml
aristotle:
  project_id: c626cb61-f1db-49ff-aa41-a9d96e9152ad
  task_id: 9bf9df60-1e40-4ca9-b24b-bbfea744678d
  target_file: HNULocalGlobalChargeConsistency.lean
  expected_module: HNULocalGlobalChargeConsistency
  status: submitted
```

## Objective

Adversarially reconcile the exact local HNU infrared orientation `+1` with the
finite zero/pi census and the general charge-balance principle. The output must
prevent a local Jacobian sign from being advertised as an unconditional global
Brillouin-zone charge.

Return one of:

1. a nonvacuous theorem showing that a supplied global zero-sum charge ledger
   containing the HNU local `+1` contribution forces a distinct nonzero partner,
   with an explicit two-entry control ledger; or
2. a sharp missing-hypothesis theorem identifying the exact adapter absent
   between the HNU zero/pi spectral census and a global topological charge sum.

The task must distinguish local Jacobian orientation, enclosing-sphere degree,
quasienergy-zero/pi spectral points, and global Brillouin/Floquet charge. It may
not infer copy freedom, anomaly cancellation, a bulk-edge theorem, or continuum
PDE convergence.

## 2026-07-13 disposition and sharpened successor

Task `9bf9df60-1e40-4ca9-b24b-bbfea744678d` completed without producing the
requested new module. Its project payload repeated the already integrated HNU
infrared charge report, so no candidate was integrated from that task.

The conditional composition was instead landed directly as
`PhysicsSM/Draft/NullEdge/HNULocalChargeBalance.lean`. It proves that the exact
HNU Jacobian has finite local sign charge `+1`, and that any explicitly supplied
finite zero-total ledger containing it has a distinct nondegenerate partner.
The singleton control proves that the zero-total premise is load-bearing. The
module builds with standard-three axiom guards and awaits independent Claude
semantic review before promotion.

Successor task `e686ea99-0229-497c-ad7c-39fdba417a96` now targets the missing
global content: derive a complete zero-and-pi charge ledger from the exact HNU
endpoint/micromotion data, or formalize a sharp insufficiency theorem explaining
why endpoint census data cannot supply that premise. It must count both Floquet
gaps and may not smuggle in degree, Chern, or global zero-sum assumptions.
## 2026-07-13 global zero/pi successor harvest

Task `e686ea99-0229-497c-ad7c-39fdba417a96` returned
`HNUGlobalZeroPiChargeLedger.lean`.  The raw package used standalone import
names, so it was not replayable directly from the main repository.  Interactive
Claude independently retargeted those imports to the live modules, replayed the
candidate successfully, and returned `APPROVE-SUBSET` in
`AutonomousLab/reviews/CLAUDE_REVIEW_HNUGlobalZeroPiChargeLedger_2026-07-13.md`.

The approved result was ported through the live imports as
`PhysicsSM/Draft/NullEdge/HNUGlobalZeroPiChargeLedger.lean`; direct Lean replay
passes.  Its scientific content is bounded as follows:

- exact endpoint identities unconditionally populate both zero and pi crossing
  sectors;
- a distinct partner follows only under a displayed finite zero-total-charge
  premise;
- no function of the endpoint value alone can recover signed local Weyl
  orientation;
- the explicit two-node `+1` and `-1` ledger is a nonvacuity fixture, not a
  derived Brillouin-zone charge census.

The exact live-port review returned `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_HNUGlobalZeroPiChargeLedger_LIVE_2026-07-13.md`.
The reviewer confirmed an exact source-hash match to the reviewed port, direct
Lean replay, and the standard-three axiom footprint.  The module is now imported
by `PhysicsSMDraft.lean` and pinned in `OvernightTheoryAxiomGuard.lean`.

No unconditional global signed-charge theorem is claimed.  The next successor
must study the geometry of the full pi face: determine whether its tangent and
normal derivatives can support an isolated three-dimensional Weyl charge, or
prove a scoped rank/codimension obstruction.  Endpoint values alone are now
formally known to be insufficient.

Successor task `79dabb72-6ad9-43b9-b148-73303f47d5e0` was submitted on the
same project.  It targets an exact all-parameter constancy theorem along every
pi-face tangent, explicit independent tangent-kernel witnesses, and the scoped
conclusion that the endpoint pi sector is an extended nodal surface rather than
an isolated three-dimensional Weyl point.  Signed charge remains out of scope.
