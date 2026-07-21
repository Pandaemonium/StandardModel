# Summary of changes for run d648ff0c-97bf-40d5-bce9-c7e4b93197f9
Completed the adversarial audit in `RequestProject/Main.lean`, with kernel-checked witnesses and no `sorry`, `admit`, `native_decide`, or new axioms.

Verdicts:

1. **PROSE-OUTRUNS-STATEMENT.** For every fixed unitary, conjugation is an isometry. This does not justify comparing two steps conjugated by different unitaries. The file proves the fixed orthogonal 2×2 real analogue and gives a varying-basis counterexample: with `A = diag(1,-1)`, `U₀ = I`, and `U₁` the coordinate swap, both `Uᵢ` are orthogonal, the original matrices have squared distance `0`, but their conjugates have squared distance `8`. Thus the prose needs “a fixed unitary independent of the step parameter,” or an additional estimate controlling variation of the unitary.

2. **PROSE-OUTRUNS-STATEMENT.** Nonaccumulation is valid for block-diagonal assembly under the relevant direct-sum norm, not for a general block matrix. The witness uses the 2×2 block operator `[[I,I],[I,I]]`: every block separately has squared operator constant `1`, while input `(e₀,e₀)` has squared norm `2` and output `(2e₀,2e₀)` has squared norm `8`. Hence the assembled operator has norm ratio `2` (squared ratio `4`), so off-diagonal blocks can accumulate.

3. **PROSE-OUTRUNS-STATEMENT unless the tail set is explicitly mass-independent.** Unitarity controls the integrand/norm but says nothing about a parameter-dependent integration domain. The finite Mathlib witness has an identity-unitary field of constant magnitude `1`, with tail set empty at one mass and `{0}` at another; the tail energies are respectively `0` and `1`. Therefore the statement must fix the tail set independently of mass, or separately prove uniform control for the mass-dependent sets.

4. **PROSE-OUTRUNS-STATEMENT.** A one-step constant alone does not determine later steps. The file exhibits `W 1 = id` but `W 2 x = x+1`, so one-step displacement is `0` while the two-step displacement at `0` is `1`. A propagation hypothesis is required—typically the action/group law, or direct control of every increment. The proved corrected skeleton assumes `W 0 = id`, `W (n+m) = W n ∘ W m`, and a one-step bound uniform in the starting point. Under that uniform formulation, unitarity/isometry is *not additionally required*. If the brick’s one-step estimate is available only at a distinguished initial state, then unitarity is what transports it to intermediate states and must also be supplied.

5. **PROSE-OUTRUNS-STATEMENT.** Reuse may be free in the numerical constant, but not in measurability. The witness uses a two-point domain with the trivial measurable structure and a discrete two-point codomain: a constant component is measurable, while the identity/varying component is not. Measurability therefore must be proved for each component, or obtained from a common measurable construction theorem that covers all components.

Axiom report for all principal audit theorems: only `propext`, `Classical.choice`, and `Quot.sound`. The file compiles successfully and has been committed and pushed.
