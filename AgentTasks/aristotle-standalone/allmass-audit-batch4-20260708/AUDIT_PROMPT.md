# Adversarial over-claim audit — all-mass landed results, batch 4

AUDIT job (no proof). `src/` has three verbatim Lean files from a finite
mathematical-physics program (mass = obstruction to null transport), all
kernel-checked + axiom-pinned. The kernel guarantees the proofs, NOT that the
statements/docstrings are the intended mathematics. For EACH theorem: name it,
quote the statement, classify (vacuity / hollow telescoping / docstring-outruns-
kernel / false shape), verdict CLEAN/MINOR/LOAD-BEARING, and the exact mismatch +
remedy for anything not CLEAN.

- `DerivedInteraction.lean` — claims the hadron interaction `V` is DERIVED from the
  carrier closure geometry (`Vderived = dΓ(iκK)`), binds below threshold
  (`derived_boundState_below_threshold`), and that binding needs the closure among
  excited modes (`derived_wrongPlane_no_binding`). Probe HARD: (a) is `Vderived`
  genuinely the second-quantized closure operator, or a matrix that happens to
  equal the modelled `V`? Is `dGamma2` the honest antisymmetric second
  quantization? (b) Is `Vderived_conj` (= modelled `V` up to phase gauge) doing
  real work or hiding that it's the same hand-drawn `V`? (c) Is
  `derived_wrongPlane_no_binding` a genuine geometric no-go or a contrived
  alternative? Is "C→M for the interaction" earned, or is the closure→`V` map
  itself a modelling choice (which curvature `K`, which modes) dressed as derived?
- `CarrierGradedBudget.lean` — claims the graded-budget hypothesis is DISCHARGED on
  the real carrier (`carrier_graded_budget`, budget from `carrier_krein_square`).
  Probe: is the budget genuinely supplied by the kernel-checked carrier square, or
  is `carrier_krein_square` itself re-stated with assumptions that beg the question?
  Is "the channels ARE the graded pieces of the carrier's Dirac square" earned?
- `InteractingTwoBody.lean` — the base bound-state theorem (re-audit briefly for
  context; batch-3 didn't cover it).

Output: per-file per-theorem table; THE single most load-bearing over-claim (if
any) with exact remedy; else say all clean + what you verified. One correct
load-bearing finding beats ten generic cautions.
