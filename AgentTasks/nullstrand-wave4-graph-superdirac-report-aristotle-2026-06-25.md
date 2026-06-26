# Summary of changes for run 85a7618f-2a9c-44c5-8857-5f7c3594a6ea
Completed the wave 4 finite graph super-Dirac spike on `PhysicsSM/NullStrand/Graph/Support.lean`.

What was done
- Extended the trusted `PhysicsSM.NullStrand.Graph` module in place, keeping the original `SupportedOn` and `support_square_subset_relComp` (GRAPH-002) verbatim with their provenance, and adding fully proven, kernel-checked finite linear-algebra facts:
  - `relComp` / `relPow` (relational composition and its n-step closure).
  - `support_mul_subset_relComp`, `mul_supportedOn_relComp`, `one_supportedOn_relPow_zero`, and `support_pow_subset_relPow` — the auditable generalization of GRAPH-002 to arbitrary powers: support of `D^n` lies in the n-step relational closure (support spreads exactly one relational step per factor).
  - A concrete smallest "super-Dirac" operator `gradedOdd φ ψ` on the graded space `L ⊕ R`, with `crossChirality`/`sameChirality` relations and the key result `gradedOdd_sq_supportedOn_sameChirality`: the square is chirality-preserving (carries no chirality-changing entry), derived from the generic graph-support machinery. The diagonal blocks of the square are identified as `ψ·φ` and `φ·ψ` (`gradedOdd_sq_leftBlock`/`gradedOdd_sq_rightBlock`).

Separation of proven vs. speculative
- The file's docstrings (and a completion report) clearly separate the proven finite graph support/decomposition facts from the speculative super-Dirac physics interpretation. The identification of the diagonal blocks with a graph Laplacian + causal-diamond curvature defect + Higgs/Yukawa mass, Krein/Lorentzian self-adjointness, and the full covariant `D_{U,Φ}` are deliberately NOT asserted as theorems. A no-go/well-posedness note explains that the flagship `superDirac_sq_eq_laplacian_plus_curvature_plus_higgs` is not yet a well-posed single trusted theorem (it presupposes unfixed metric and named-operator definitions), and records the recommended next handoff.

Verification
- The file elaborates with zero errors/warnings and is `sorry`-free; `#print axioms` on the new theorems shows only `propext`, `Classical.choice`, `Quot.sound`. No axioms or escape hatches were introduced.

Build constraints
- A full `lake build` is not possible because `lakefile.toml` requires the un-vendored `SpherePacking` dependency. Since `Support.lean` imports only Mathlib, it was checked with `lean` against the vendored package oleans. The `SpherePacking` require block was momentarily disabled to allow the proving environment to run, then restored verbatim; the only net repository changes are the modified `PhysicsSM/NullStrand/Graph/Support.lean` and the new `AgentTasks/aristotle-output/nullstrand-wave4-graph-superdirac-completion-report.md`.
