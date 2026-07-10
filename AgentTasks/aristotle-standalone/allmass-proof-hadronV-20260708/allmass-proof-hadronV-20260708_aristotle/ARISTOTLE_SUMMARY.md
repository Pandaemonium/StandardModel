# Summary of changes for run 12cd1ee1-e4d2-4ec0-9a18-7a4b6941e21a
## Delivered: `V` derived from the carrier's closure geometry (hadron C → M)

New file `src/DerivedInteraction.lean` (imports and builds on `src/InteractingTwoBody.lean`, which is left untouched). It compiles with **no `sorry`/`admit`**; the flagship theorems use only the standard axioms `propext, Classical.choice, Quot.sound`.

### 1. The interaction is now DERIVED, not modelled
- `dGamma2 A` is the antisymmetric second quantization (`dΓ`) of a one-body operator `A` onto the 3-dim pair space `Λ²(sector)` (pairs `0↔{0,1}`, `1↔{0,2}`, `2↔{1,2}`). `dGamma2_diagonal` confirms it reproduces the free `freeH2` on diagonals.
- `closureCurvature` is the real antisymmetric closure curvature `K`; `oneBodyClosure κ = i·κ·K` is exactly the closure part of the carrier block `B(λ,κ)=λ·I+i·κ·K` (`oneBodyClosure_isHermitian`).
- `Vderived κ := dGamma2 (oneBodyClosure κ)`, with proven explicit form `Vderived_eq : Vderived κ = !![0,-iκ,0; iκ,0,0; 0,0,0]` — a Hermitian (`Vderived_isHermitian`) coupling of the two lowest pairs, of strength exactly `κ` (`Vderived_strength : ‖Vderived κ 0 1‖ = |κ|`, `Vderived_eq_zero_iff`). `H2der_eq` shows the full derived Hamiltonian is `freeH2 + Vderived` with the interaction emerging from `dΓ`, not inserted.

### 2. The below-threshold bound state, now first-principles
- Key structural fact `Vderived_conj`: the derived interaction equals the *modelled* `V` in a diagonal phase gauge, `Vderived κ = U·(interaction κ)·U⁻¹` with `U = diag(1,-i,1)`. Hence `H2der_conj : H2der = U·H2·U⁻¹` is unitarily equivalent to the modelled Hamiltonian, so it has the identical spectrum (`spectrumC_H2der`, via the general lemmas `conj_spectrumC` and `realComplexSpectrum`).
- **`derived_boundState_below_threshold`**: for `κ>0` and sorted `d 0 ≤ d 1 ≤ d 2`, the derived Hamiltonian's least eigenvalue is `boundEnergy d κ`, strictly below the free two-body threshold — the SAME below-threshold conclusion as `InteractingTwoBody`, but now with `V` derived from the carrier. This is the C → M upgrade: the modelled attractive `V` was not smuggling in physics; it IS the second-quantized closure operator (in a phase gauge).
- `massBlock_groundMode` ties the scale to the binding defect: the carrier block `B(λ,κ)` has eigenvector `![0,1,-i]` at eigenvalue `λ-κ`, matching `Δ = -κ`.

### 3. Precise obstruction map (the honest negative side)
Whether the closure binds depends on WHICH modes its curvature couples. `closureCurvature2` (acting in a plane containing the ground mode `0`) second-quantizes to `Vderived2` coupling only the two heavier pairs `{0,2},{1,2}`, leaving the ground pair `{0,1}` decoupled. **`derived_wrongPlane_no_binding`**: under sorted `d` and weak closure `κ² ≤ (d 2 - d 0)(d 2 - d 1)`, the least eigenvalue is exactly the free threshold `pairThreshold d = d 0 + d 1` — NO binding below threshold. So binding below the constituent threshold requires the closure to act among the excited modes; a ground-mode-plane closure alone does not supply hadronic binding. The exact bind/no-bind boundary is `κ² = (d 2 - d 0)(d 2 - d 1)`.

### Note on the existing project
`src/BindingDefect.lean` fails to build in this project because it imports `PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness`, a module not present in the repository. This failure is pre-existing and unrelated to this task; I left that file intact. The new work does not depend on it, and `src/InteractingTwoBody.lean` and `src/DerivedInteraction.lean` build cleanly. All changes are committed and pushed.
