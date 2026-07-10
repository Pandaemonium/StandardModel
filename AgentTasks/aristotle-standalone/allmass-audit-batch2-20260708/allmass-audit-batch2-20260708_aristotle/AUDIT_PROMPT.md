# Adversarial over-claim audit — all-mass landed results, batch 2

AUDIT job (no proof required). `src/` has four verbatim Lean files from a finite
mathematical-physics program (mass = obstruction to null transport), all
kernel-checked + axiom-pinned `[propext, Classical.choice, Quot.sound]`. The
kernel guarantees the proofs; it does NOT guarantee the statements are the intended
mathematics. Find where, if anywhere, a statement/docstring claims more than it
proves. For EACH theorem: name it, quote the Lean statement, classify against the
four modes (vacuity, hollow telescoping, docstring-outruns-kernel, false shape),
verdict CLEAN / MINOR / LOAD-BEARING, and for anything not CLEAN the precise
mismatch + exact remedy.

Files:
- `CliffordAssembly.lean` — claims the hand-typed T2 Krein form `HAC`/`Jmet` EQUAL
  the Cl(4) Kronecker assembly `J(Q_A+Q_C)`/`Js⊗I3`. Probe: is the Kronecker
  reindex (`finProdFinEquiv` row-major) the *physically intended* tensor order, or
  could a different order also match by coincidence? Is `K` the intended closure
  curvature?
- `BindingDefect.lean` — claims `Δ_block(λ,κ) = −κ` is a "binding energy",
  off-diagonal, closure-controlled. Probe: is `blockGroundMass λ 0 = λ` genuinely
  the free/kinematic `det P` baseline, or an unrelated quantity that happens to
  equal `λ`? Is calling `Δ` a "binding energy" earned, or is it just "least
  eigenvalue minus λ"?
- `S1CCPhysicalSectorWitness.lean` — claims the §6 closure form `J Q_C` is
  *balanced* (inertia (2,2,0)) on the physical sector `V'/N`, converting a MEMO
  step to kernel. Probe HARD: is `V'/N` the genuine Gauss-constraint physical
  sector, or a convenient coordinate choice? Is `balanced_on_physical_sector`
  about the actual induced form, or a submatrix that isn't the true compression?
  Is the "(2,2,0)" the real inertia or a weaker fact dressed up?
- `EquivariantGradedIndex.lean` — claims a "graded budget decomposition" /
  "unification is decomposition" and McKean–Singer cancellation. Probe: is
  `graded_budget_decomposition` a genuine equivariant index identity, or trace
  linearity renamed? Does "index" appear anywhere the kernel earns it, or is it
  all supertrace algebra (which is fine, but must not be called a topological
  index)?

Output: a per-file per-theorem table; then THE single most load-bearing over-claim
across all four (if any) with its exact remedy; else say all clean and what you
verified. One correct load-bearing finding beats ten generic cautions.
