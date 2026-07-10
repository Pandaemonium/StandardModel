# Goal I — The verified hadron (one carrier, one theorem chain)

## Context (blind to the wider repo; seeds are in `seeds/`, Mathlib only)

A finite "null-edge" program has landed several parts of a confining finite
system. The goal is ONE finite carrier — fermions on `Cl(4) (x) C^3` (spin part
`Fin 4`, color part `Fin 3`, real Krein metric) with its own closure background
and a color-Gauss constraint — on which a single CHAINED theorem holds: the
lightest physical excitation is a **color-singlet bound state below the
two-constituent threshold**, with its mass budget decomposed. This is a
machine-verified toy hadron; it is NOT a physical pion/rho prediction and makes
no continuum claim.

Seed files (`seeds/`; clean-room port the definitions you need into
`RequestProject/Main.lean` — do not assume importability):

- `seeds/ConfinementPositivity.lean` (namespace `ConfinementB`): the confinement
  dichotomy on a MINIMAL `2x3` witness `Mfull = etaKrein (x) Gcolor`
  (`etaKrein = diag(1,-1)`, `Gcolor` the `3x3` hollow all-ones color form).
  `colored_negDef`: colored vectors (`x0+x1+x2=0`) are negative-definite;
  `singlet_posDef`: singlets (`x0=x1=x2`) are positive; `criterion` packages the
  dichotomy. **Rung 1 lifts this from the 2x3 toy to the true 12-dim
  `Cl(4) (x) C^3`.**
- `seeds/InteractingTwoBody.lean` (namespace `...InteractingTwoBody`): the `3x3`
  two-body Hamiltonian `H2 d kappa = freeH2 d + interaction kappa`, with
  `boundEnergy`, `pairThreshold`, `discr` (discriminant, `discr_nonneg`).
- `seeds/CarrierClosurePlane.lean` (namespace `...CarrierClosurePlane`):
  `carrierK` (the closure curvature `3x3`), `carrierH2`, and the fact the carrier
  binds unconditionally (closure curvature is in the binding plane).
- `seeds/CarrierMassBudget.lean` (namespace `...MassBudget`): `signed_budget_sum_one`
  and `witness_budget_sum_one` — the channel shares `b_A + b_C + b_T = 1`.
- `seeds/FockMassGap.lean`: the many-body/Fock spectral-gap scaffolding.

## Targets (a chain; land the cheapest killable rung FIRST)

1. **Rung 1 — confinement dichotomy on the 12-dim carrier.** Define the explicit
   `Cl(4) (x) C^3` carrier form (spin `Fin 4` with its real Krein metric
   `eta4 = diag(1,1,-1,-1)` (x) `Gcolor` on `Fin 3`, or the correct Cl(4) Krein
   form) and prove the dichotomy ON THIS 12-dim object: color-nonsinglet
   sub-sectors are negative-definite, the color-singlet sector is positive-definite.
   **MANDATORY non-degeneracy fixture:** the singlet and colored sectors must each
   be pinned `dim > 0` in the theorem statement, and you must exhibit an EXPLICIT
   nonzero singlet vector on which the form is `> 0` and an explicit nonzero
   colored vector on which it is `< 0` (else the dichotomy is vacuous).
2. **Rung 2 — the singlet two-particle sector.** Construct the two-particle
   color-singlet Fock sector and its Hamiltonian (compose `InteractingTwoBody`
   with the singlet projection).
3. **Rung 3 — below-threshold bound ground state.** Prove the singlet sector's
   ground energy is strictly below the two-constituent threshold
   (`boundEnergy < pairThreshold`) for an explicit rational `(d, kappa)` witness
   with `kappa != 0`.
4. **Rung 4 — a positive many-body gap** above the bound state (exact eigenvalue
   ordering; blocks are small so spectra are rational/algebraic).
5. **Rung 5 — the channel budget of the bound eigenvector** is exactly rational
   with **`b_C < 0`** and shares summing to `1` (binding realized as negative
   closure share — the Ji-shaped statement). Reuse a 3-4-5 rational holonomy so
   the budget is exactly rational.

## Kills (a kill is a publishable result)

- A colored two-particle state BELOW the singlet one (dynamical deconfinement).
- The many-body gap closing.
- `b_C >= 0` on the bound state (binding NOT closure-driven).
- The 12-dim dichotomy failing to hold where the 2x3 toy predicted it (the lift
  breaks) — a sharp negative about the toy's faithfulness.

## Constraints (hard)

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`. Mathlib only.
Footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on EVERY headline theorem.
Deliver `RequestProject/Main.lean` (namespace e.g. `Goal1Hadron`) +
`ARISTOTLE_SUMMARY.md`: which rungs landed, the explicit non-degeneracy witnesses
(the singlet-positive and colored-negative vectors, the `(d,kappa)` bound witness),
the bound-state budget with its `b_C < 0` value, and an honest scope note. If you
can only land rungs 1-3, that is a real result — do not force 4-5.
