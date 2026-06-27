# Summary of changes for run b75249bf-0655-4890-903e-2f5af6ca2a25
Delivered `PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean`, the FUR-H5 integration module assembling the finite null-edge/Furey almost-commutative product Dirac operator `D = i D_N ⊗ 1 + Γ_s ⊗ Φ_H` and reusing the Gate A square. The file builds cleanly (no `sorry`, no warnings) and every theorem depends only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.

Inspection findings (recorded in the file's docstring): of the six included context files, only `NullEdgeYukawaCheckerboard.lean` is self-contained on Mathlib. The other five (`NullEdgeFiniteLichnerowiczBridge`, `NullEdgeSuperDiracSignBridge`, `NullEdgeInternalSpectrum`, and the two `Algebra/Furey/*` files) import `PhysicsSM.*` modules that are not present in this project slice — including the upstream `NullEdgeSuperDiracSignAudit` that defines the abstract Gate A square (`CleanSquareHypotheses`, `super_dirac_square_sum`, `graded_square_*`), the tetrad postulate, the Furey octonion/ladder operators, and `StandardModel.AnomalyPackage`. Consequently those files (and a default project build) do not compile here. To make the deliverable a clean, self-contained artifact, the new module imports only Mathlib and mirrors the Gate A interface verbatim, re-deriving the abstract square (pure finite associative-ring algebra) under the identical `CleanSquareHypotheses`/`superDiracSquare` names; the docstring documents the exact upstream correspondence.

API designed and proved:
- `CleanSquareHypotheses`, `superDiracSquare` — the abstract Gate A finite super-Dirac square `(i D_N + Γ_s Φ)² = -D_N² + Φ² - i(Γ_s ∑_a C_a [∇_a,Φ])`.
- `graded_square_comm` / `graded_square_anticomm` — the abstract `±Φ²` sign lemmas.
- `FureyInternalData` — the internal Furey interface/placeholder (internal chirality `χ_E` with `χ_E²=1`, and a `χ_E`-odd mass block `Φ_H`); no construction of `Φ_H` is asserted, keeping the unproved `Φ_H` construction separate from the product architecture (task point 5).
- `AlmostCommutativeProduct` — the assembled product datum (external Clifford data + Furey internal data + the almost-commutative compatibility hypotheses `[Γ_s,Φ_H]=[C_a,Φ_H]=[∇_a,Φ_H]=0`), with `toCleanSquareHypotheses` exposing it as Gate A data.
- `product_square_eq_gateA` — the headline theorem (task point 4): once a Furey-compatible `Φ_H` satisfies the hypotheses, the product square is exactly the Gate A square specialised to the Furey internal `Φ_H`.
- `product_square_clean` — under the genuine product hypothesis `[∇_a,Φ_H]=0` the Lichnerowicz defect term vanishes, giving `D² = -D_N² + Φ_H²`.
- `product_sign_dichotomy` — the `(Γ_s Φ_H)² = +Φ_H²` / `(χ_E Φ_H)² = -Φ_H²` sign bridge for the Furey internal space.
- A concrete non-vacuity witness on `Matrix (Fin 2) (Fin 2) ℂ` (`Φ_H = σ_x`, `χ_E = σ_z`, trivial external data): `concreteWitness`, `concreteWitness_square` (`D² = 1`), and `concreteWitness_sign_flip` showing the sign flip is genuine (`+1` vs `-1`).

No existing files were modified; the broken upstream context files were left untouched.
