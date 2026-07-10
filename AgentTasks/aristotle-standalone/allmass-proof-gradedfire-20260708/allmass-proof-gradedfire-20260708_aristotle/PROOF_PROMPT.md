# Fire the graded-budget decomposition on the ACTUAL carrier (discharge the hypothesis)

PROOF + DESIGN job (a landed lemma is the goal; a precise obstruction report if it
resists). Context in `src/`.

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

`EquivariantGradedIndex.graded_budget_decomposition` shows that *any* four-channel
budget identity pushes through the graded supertrace `sdim_g(A) = tr(Γ g A)` by
linearity — but the budget enters as an *assumed hypothesis*, and (per an audit) the
"unification is decomposition" prose oversells until that hypothesis is discharged
on the real carrier. Separately, `CarrierSquareAssembly.carrier_square_assembly` /
`CarrierKreinSquare.carrier_krein_square` PROVE the actual budget
`4 D^#D = Q_A + Q_C + 4 Q_T + (4)E_#` in the *abstract* carrier setting
(`E → B`, a Clifford/module formalism). The two live in DIFFERENT formalisms
(concrete `Matrix (Fin n) (Fin n) ℂ` for the graded index vs the abstract carrier
algebra for the budget) — which is exactly the bridge to build.

## Target

1. **Bridge the formalisms.** Either (a) restate/prove `graded_budget_decomposition`
   in the abstract carrier setting where `carrier_square_assembly` lives (so its
   budget hypothesis can be discharged by that theorem), or (b) specialize
   `carrier_square_assembly` to the concrete matrix setting of the graded index.
   State the cleanest bridge and the exact types.
2. **Discharge the hypothesis — the real deliverable.** Land a theorem
   `carrier_graded_budget` : the graded supertrace of the carrier's *actual*
   `4 D^#D` equals the graded supertrace sum over the four kernel-defined channels
   `Q_A, Q_C, Q_T, E_#` — with NO free budget hypothesis (it is supplied by
   `carrier_square_assembly`). This makes "the four channels ARE the graded pieces
   of the carrier's Dirac square" a theorem about the carrier, not an assumed input.
3. **If the bridge is genuinely obstructed**, report the exact obstruction: which
   typeclass/setting mismatch blocks discharging the hypothesis, whether it is
   essential or just refactoring, and the minimal change (to either file) that
   would unblock it. A precise obstruction map is a valuable deliverable.

Deliver the discharged `carrier_graded_budget` if feasible; else the bridge design +
obstruction report. Keep both source files' existing content intact. Report semantic
alignment: the content is "the graded-supertrace decomposition holds of the carrier's
own budget, not a hypothetical one." Run `lake env lean`; commit + push.
Provenance: all-mass solo run 2026-07-08 [orig]; closes the call-08 organizing-theorem gap.
