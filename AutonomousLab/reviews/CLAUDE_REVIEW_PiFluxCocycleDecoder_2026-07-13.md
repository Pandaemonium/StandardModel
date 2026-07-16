# Claude review: PiFluxCocycleDecoder seed (550cdd51)

- Reviewer: interactive Claude Code (claude family)
- Source: `.../PiFluxCocycleDecoder.lean` (123 lines), sha 84bbb7fe... verified
- Date: 2026-07-13

## Verdict: ACCEPT

An honest, kernel-clean seed that instantiates exactly the one surviving escape
I isolated in the Clifford-cover audit: a genuinely POSITION-DEPENDENT (pi-flux /
magnetic-translation) cocycle. It proves the cocycle is nontrivial and
non-reducible, and it honestly delimits itself as a seed, not a decoder or a
census.

## Construction

Finite periodic `2x2` cell `Site = ZMod 2 x ZMod 2`, `State = Site -> C`.
`xPhase x = if x = 0 then 1 else -1`. `translateX` is the ordinary x-shift;
`translateY psi p = xPhase p.1 * psi (p.1, p.2 + 1)` carries the x-dependent sign.
This is the standard finite magnetic-translation construction at pi flux per
plaquette.

## Checks (all pass)

- **Genuinely position-dependent (the decisive property).**
  `xPhase_nonconstant` (`xPhase 0 != xPhase 1`) and `xPhase_add_one`
  (`xPhase (x+1) = -xPhase x`). The y-translation's sign depends on the x
  coordinate - NOT a global constant. This is exactly the property my Clifford
  audit flagged as the only way to evade the momentum-independent-projector
  obstruction.
- **The pi-flux relation is exact.** `translateX_translateY_anticommute`:
  `translateX (translateY psi) = - translateY (translateX psi)`; the plaquette
  commutator is the central phase `-1`. Correct magnetic-translation shape.
- **Non-reducibility (sharp non-triviality).**
  `global_sign_translation_cannot_model_pi_flux`: no pair of COMMUTING
  translations (with `A = translateX`, `B = translateY`) can reproduce the
  commutator - evaluated at the explicit state `fun _ => 1` at `(0,0)`. So the
  position-dependence is essential and cannot be conjugated away by global signs,
  matching the earlier "commuting deck flips are not conjugate to anticommuting
  generators" correction.
- **Invertibility.** `translateX_bijective`, `translateY_bijective` - both
  twisted translations are exact bijections of the finite state space.
- **Vacuity / false shape / hidden assumptions.** None. Concrete `-1`
  commutator, nonconstant phase, explicit inverses, finite `decide`/`fin_cases`
  over the `2x2` cell. The magnetic-translation/pi-flux anticommutator is the
  correct shape for a fermionic 2-cocycle.
- **Docstring overreach.** None. It states it "isolates the only surviving
  escape from the momentum-independent flavor-projector obstruction" and is "a
  local building block for a 3+1 cocycle-twisted flavor cover. It does not prove
  a doubler-free decoder or a one-crossing Brillouin-zone census. Those remain
  successor gates." Accurate self-delimitation.
- **Convention drift.** None. Imports and aligns with
  `U1HistoryClosureHolonomy` (the repo's closure-holonomy layer), as recommended.
- **Axiom guards.** Six `#guard_msgs` blocks (one per theorem), all
  `[propext, Classical.choice, Quot.sound]`. Replay: clean-path `lake env lean`
  exit 0, no errors/warnings/sorry; guards fire.

## What it does NOT establish (explicit delimitation, per the request)

- It is a 2D finite-cell cocycle SEED, not a 3+1 construction.
- It exhibits NO onsite/twisted projector, and proves NO projector commutes with
  any flavored/cocycle-twisted walk (the DK2/DK3 gate).
- It performs NO Brillouin-zone census; it says nothing about zero- or
  pi-quasienergy crossings, and nothing about doubler removal.
- It does NOT establish a doubler-free local decoder. Per my Clifford audit,
  position-dependence is NECESSARY (to escape the momentum-independence no-go) but
  NOT SUFFICIENT: the decisive successors are (DK3) a twisted-onsite projector
  that commutes with the actual walk and (DK4) a full 0-and-pi determinant census
  on its range showing one crossing per declared flavor.

## Narrowest defensible claim

On a finite periodic `2x2` cell there is a pi-flux magnetic-translation pair:
an ordinary x-shift and an x-position-dependent-sign y-shift that ANTICOMMUTE
(central commutator `-1`), are each bijective, and cannot be reproduced by any
commuting global-sign translation pair. This is a genuinely position-dependent
2-cocycle seed for a cocycle-twisted flavor cover; it establishes no 3+1 decoder,
no projector intertwiner, and no Brillouin-zone crossing census.
