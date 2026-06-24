# Aristotle audit job: P7 proper-time / recoverability theorem strategy

This is a no-code strategy/audit job. Do not build Lean, do not edit Lean files,
and do not try to prove the whole program. We want a theorem-selection report
for the next P7/P1/P4 proof batch.

## Physics context

Program lane / paper: P7 observer channels and relative-entropy
recoverability, serving P1 origin of mass and P4 null-step dynamics.

Four-layer status:

- finite identity: Plucker mass, observer-conditioned determinant, concurrence,
  Bloch mixedness, and several small channel monotonicity facts are
  kernel-checked;
- naturality: the resolution observer and kinematic observer are named but the
  strongest recoverability/equality conditions are not yet formalized;
- dynamics: not proved; the desired next step is a proper-time/purity rate law;
- physical interpretation: proper time is being treated as observer-visible
  mixedness of a celestial qubit, not as a completed Higgs/Yukawa dynamics
  theorem.

Recent finite results:

1. `PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet` proves that
   determinant mass does not determine off-diagonal coherence, positive-effect
   readout, or two-outcome readout in a trace-one real symmetric density proxy.
2. `PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge` proves the scalar bridge:
   squared proper-time ratio equals twice visible linear entropy, and unital
   Bloch-radius contractions monotonically increase the proper-time-square.
3. `PhysicsSM.Draft.NullEdgeObserverChannelCore` already banks determinant
   invariance under `SL(2,C)` congruence, scalar kinematic filtering, a
   two-label Gram determinant factor, unital visible-channel monotonicity, and a
   toy hidden-channel counterexample.
4. `PhysicsSM.Draft.NullEdgeP7KLDataProcessing` contains a finite KL
   data-processing theorem, but the equality/recovery case is not yet banked.
5. The P9 exact-recovery lane now has a robust classical observer-channel
   scaffold: exact stochastic recovery preserves observable gaps, composes, and
   excludes fully erased separated pairs.

Why this matters physically: the program needs to move from "mass ratio is a
static determinant/mixedness identity" to a sharper finite observer-channel
statement. The ideal next theorem should say what kind of channel makes
proper-time/mixedness monotone, when information loss is reversible, or how
coherence/dephasing changes the observable mass ratio.

What would weaken or falsify the interpretation:

- If the proper-time/purity bridge is only a scalar rewrite with no channel
  content, it should not be advertised as dynamics.
- If recoverability equality requires strong support or invertibility
  hypotheses, those must be stated before any physics claim.
- If determinant mass and recoverability deficit cannot be separated by a small
  finite witness, the observer-channel story loses operational bite.
- If a proposed theorem only restates unital Bloch contraction already banked,
  prefer a harder theorem target or a clear demotion.

## Audit request

Please give an adversarial but constructive theorem-selection report.

Return exactly these sections:

1. **Top theorem to submit next.** Give one finite Lean-style theorem statement
   that would most reduce ambiguity in P7/P1/P4. Include definitions needed,
   expected proof method, likely imports, and whether it is proof job,
   counterexample job, or strategy job.
2. **Second and third choices.** Same format, but shorter.
3. **Recoverability/equality audit.** Is the next P7 job more likely to be a
   finite KL equality characterization, an exact-recovery gap theorem, or a
   concrete same-det/different-deficit witness? Explain the support assumptions
   and failure modes.
4. **Proper-time dynamics audit.** What is the smallest finite theorem that
   would move from static `properTimeRatioSq = 2 * linearEntropy` toward a
   rate law without overclaiming dynamics?
5. **Suggested next steps.** List the next 3 Codex actions after reading your
   report.

## Completion report

End with:

- what was planned:
- useful counterexamples/construction blockers found:
- suggested next high-value theorem or fallback lane:
- suggested literature or convention check:
- highest-risk remaining gap:
