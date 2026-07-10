# Summary of changes for run bab2d28f-178f-4400-8b26-0992fd219d90
## Delivered: `carrier_graded_budget` — the graded-budget hypothesis discharged on the carrier

Added `src/CarrierGradedBudget.lean` (builds with `lake env lean`, no `sorry`, axioms only `[propext, Classical.choice, Quot.sound]`, verified by an in-file `#print axioms` guard). The three original files (`src/EquivariantGradedIndex.lean`, `src/CarrierSquareAssembly.lean`, `src/CarrierKreinSquare.lean`) are left byte-for-byte intact.

### The bridge (design + exact types)
The two formalisms were joined via the observation that `Matrix n n ℂ` is **simultaneously** (i) an instance of the abstract carrier algebra — with `R := ℂ`, `B := Matrix n n ℂ` it is a `Ring`, a `ℂ`-`Algebra`, a `StarRing` (with `star = ᴴ`) and a `StarModule ℂ` — and (ii) the concrete home of the graded supertrace `sdim(A) = (Γ·g·A).trace`. So the bridge is literally the instantiation `R := ℂ, B := Matrix n n ℂ`: the generically-proven carrier budget *is* the matrix identity that `graded_budget_decomposition` needs as its hypothesis.

- Route (a) (restating the graded index inside an abstract ring `B`) is **essentially obstructed**: a general ring has no trace, so the graded supertrace is not even definable there. Reported in the module docstring.
- Route (b) (specialize the carrier budget to matrices) is what is implemented.

### The discharged theorem
`carrier_graded_budget`: for the carrier `D = D0 + Γφ` built from concrete matrices satisfying the carrier hypotheses (Clifford relation, soldering commutation, chirality relations, covariant constancy, all-plus adjoint table), the graded supertrace of the carrier's **own** mass form `4·(D^# D)` equals the graded-supertrace sum over the four kernel-defined channels `Q_A^#, Q_C^#, Q_T = φ², E_#` — with **no free budget hypothesis**. The budget is supplied internally by the carrier's Krein square. Semantically: the four channels ARE the graded pieces of the carrier's Dirac square, a theorem about the carrier rather than an assumed input.

### Obstruction report (packaging, not mathematical)
`carrier_krein_square` / `carrier_square_assembly` cannot be imported here because they depend on a `PhysicsSM.Draft.NullEdge.Carrier.*` brick library (`WeitzenbockMasterPair`, `CarrierPotentialTurn`, …) absent from this project's import graph (`unknown module prefix 'PhysicsSM'`), so both files fail to elaborate in isolation. This is a dependency-packaging obstruction, not a mathematical one; the minimal unblocking change is to make that brick library an actual dependency. Absent it, the file reconstructs, self-containedly and faithfully, exactly the bricks the Krein square needs — `solderedNC`, `weitzenbock_master_pair` (Weitzenböck pair master; the redundant `hcommN` hypothesis was dropped as the proof does not need it), `potential_sq`, and `carrier_krein_square` itself — then performs the specialize-to-matrices bridge. All reconstructed pieces are fully proved and kernel-checked.

All work is committed and pushed.
