# Claude adversarial review request: cycle 9 C97/C98 naming hardening

Date: 2026-06-27.

Please review the actual attached Lean sources after a small local hardening pass.

## Context

In the prior review of C97/C98 you classified both files as useful
planning-only guardrails, not physical C1 release evidence.

You flagged two naming hazards:

- C97 had `PostGaugeResiduePositive.toGoltermanShamirSafe_trivialBRST`, which
  produces `PostGaugeGoltermanShamirSafe d True` and might be misread as
  satisfying the canonical `BRSTSafe d` obligation.
- C98 used the release-flavored name `ChiralIndexWitness` for a toy predicate
  meaning only `plusCount != minusCount`.

## Local hardening done

- Renamed the C97 theorem to
  `PostGaugeResiduePositive.toGoltermanShamirSafe_vacuousBRST` and strengthened
  the docstring warning.
- Renamed C98's predicate to `ToyChiralIndexNonzero` and strengthened the
  docstring warning that it is not the eventual C1 witness.

## Review questions

1. Does this hardening adequately reduce the immediate naming hazard?
2. Did it introduce any new semantic hazard?
3. Should these files now be left as-is until C99 returns, or should another
   immediate hardening be done locally?
4. Is there any reason to launch another Aristotle job before C99/C93/C92/C89
   return?

Please answer with a short verdict and concrete next action.
