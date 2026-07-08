# Aristotle round 4: dynamics groundwork (2026-07-08)

Submitted after harvesting round-3 (T2 linchpin + F4 Witten + F3-partition all
LANDED, M). Round 4 develops the program's DYNAMICS (user request), borrowing
PhysLean's variational/Hamiltonian design clean-room
(`docs/PHYSLEAN.md`, `DYNAMICS_GROUNDWORK.md`).

## Jobs

- **D1 finite carrier action + EOM** (`allmass-dynamics-d1-20260708-project`):
  project fd6efc55 - **CANCELLED (redundant).** Codex/parallel work already
  landed `Carrier/FiniteCarrierAction.lean` covering the finite carrier action
  and its EOM (`multiplierStationary_iff_eom`, field/multiplier variation). No
  need to duplicate; if the Dirichlet-action formulation is wanted later it can
  be added cleanly.
- **D-conservation** (`allmass-dynamics-cons-20260708-project`): unitary
  evolution `U t = exp(-i t T)` on a definite sector conserves norm and energy
  (`<U psi, T U psi> = <psi, T psi>`) - the kernel version of
  carrier_dynamics_harness.py's conservation checks. Complements
  FiniteCarrierAction (action+EOM done; evolution+conservation is the next
  piece). **project_id: 5cb0e51b-8b78-404b-9d6f-6aadd2587739**.

## Status log

- 2026-07-08: D1 cancelled (FiniteCarrierAction already covers it);
  D-conservation submitted (5cb0e51b).
