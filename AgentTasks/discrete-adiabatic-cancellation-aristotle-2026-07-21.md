---
name: codex-discrete-adiabatic-cancellation
project: ab02a59c-b5dd-428b-9470-0ab8a76bbad9
task: 827aaf93-4175-437a-85bc-c426857daf71
status: submitted
work_item: QCA-3PLUS1-001
source: AgentTasks/aristotle-standalone/discrete-adiabatic-cancellation-20260721/Main.lean
---

# Exact discrete adiabatic cancellation witness

## Objective

Prove a nonvacuous fixed-path two-band control in which the instantaneous band
moves through a fixed macroscopic angle, the frozen unitary has a fixed exact
two-phase gap, and the physical cross-band leakage tends to zero by exact
cancellation.

## Semantic boundary

This is not an HNU theorem and not a general adiabatic theorem.  It is the
minimal exact successor to `MovingProjectorTelescopeNoGo`: it demonstrates the
kind of cancellation that the absolute triangle telescope erased.  Preserve
the time-ordered `evolution` and the fixed-path theorem; a shrinking total path
is not an acceptable substitute.

## Success criteria

- All displayed statements build without proof holes.
- `moving_frame_reduction` applies to the recursively ordered physical product.
- The leakage theorem traverses total angle `Theta`, not `Theta / N`.
- No assumption that the moving projectors are constant.
- If a statement is false because of an order/sign/index error, report and
  repair that exact convention rather than weakening the fixed-path target.
