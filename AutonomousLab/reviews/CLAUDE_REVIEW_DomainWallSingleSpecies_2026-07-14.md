# Claude review: DomainWallWeyl/ChargeCount (single-species count, refill harvest)

- Reviewer: interactive Claude (claude family), Skeptic, solo mode
- Source: Aristotle job `9eb52ec3`, `DomainWallWeyl/ChargeCount.lean` (324) + the
  `Core.lean` ladder. Date: 2026-07-14

## Verdict: APPROVE (draft-trust)

Independently built (2-file scratch, Core+ChargeCount, retargeted import): `lake
build` EXITCODE=0 (Core 17s + ChargeCount 15s). 0 real sorry/native/axiom (1 hit =
guard prose); guards pass -> standard-three `[propext, Classical.choice,
Quot.sound]`.

## What it proves (exact, finite static linear algebra)

- `finite_wall_single_species`: for the 3-site chiral chain with grading
  `Gamma=diag(1,-1,1)`, `finrank chiralKerPlus = 1`, `finrank chiralKerMinus = 0`,
  net chiral charge `= 1`. A SINGLE unpaired chiral zero mode with the mirror
  sector provably empty (`chiralKerMinus = bot`). Boundary mode `w=(2,0,-1)`,
  chirality `+1`.
- Control `balanced_ring_mirror_pair`: a balanced 4-site ring has
  `finrank +/- = 1,1`, net `0` - an explicit MIRROR PAIR. Proves the single-species
  result is a genuine sublattice-imbalance (INDEX) effect, not a vacuous empty
  kernel.
- Core ladder: exact 1D kernel, uniform gap `sqrt 5` (`complement_gap` via the
  `Mchain^2 = 5I - w w^T` certificate), and `weyl_restriction` - the boundary
  sector is EXACTLY the Weyl symbol `k.sigma` (`Hfull = Mchain (x) I2 + I3 (x)
  k.sigma`), chirality det `= 1`.

## Over-claim audit - exemplary

- Vacuity: none - explicit nonzero witnesses, connected matrices
  (`Mchain_no_zero_row` blocks the disconnected-zero-row cheat), the ring control
  makes the imbalance bite.
- False shape: none - `finite_wall_single_species` is an exact finrank count;
  `weyl_restriction` genuinely intertwines the boundary sector with `k.sigma`.
- Docstring-outruns-kernel: none - explicit "What is NOT claimed": no bulk-edge
  thermodynamic limit, no continuum Dirac/Weyl operator, no unitary discrete-time
  (quantum-walk) dynamics, no gauge coupling, no 3-space locality, no SM anomaly.

## Program fit + boundary

A genuine POSITIVE finite result: a static domain-wall CAN host a single unpaired
chiral species (net charge +1, mirror empty) via sublattice imbalance, with the
boundary carrying the Weyl symbol `k.sigma`. This is the STATIC domain-wall cousin
of the anomalous-Floquet route - it demonstrates the index MECHANISM in a finite
setting. It is NOT the HNU Floquet walk (Gate 1, running on da29672d), NOT
dynamical, NOT continuum. Manuscript may state it as a finite static single-species
index result; may NOT conflate it with the HNU realization or a unitary walk.

## Bottom line

APPROVE (draft-trust). Independently rebuilt, standard-three, exemplary scope. A
clean finite static single-chiral-species index result (dim ker+ - dim ker- = 1,
mirror empty) with a genuine mirror-pair control and the boundary = k.sigma Weyl
symbol. Supporting evidence for the finite-single-Weyl mechanism, distinct from the
HNU Floquet Gate-1. Landing: reconcile the Core submodule refactor with any live
domain-wall module.
