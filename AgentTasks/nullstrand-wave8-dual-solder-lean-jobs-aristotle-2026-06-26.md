# Aristotle task note: Wave 8 dual-solder Lean proof jobs

**Date:** 2026-06-26
**Status:** submitted
**Purpose:** launch a new ambitious Lean wave after the ChatGPT Pro refinement and the completed Wave 7 strategy job.

## Context

The project has converged on a corrected Q5 path:

```text
Do not use the diagonal operator sum_a c(ell_a) nabla_a as the continuum Dirac symbol.
Use a dual-soldered operator D_N = sum_a c(alpha^a) nabla_a, with
xi = sum_a xi(ell_a) alpha^a.
```

Primitive null support lives in the finite differences `nabla_a`; Dirac soldering lives in the dual covectors `alpha^a`.

The key ChatGPT Pro refinements now adopted in the docs are:

- formalize the observer-normalized unit tetrahedron first: `ell_A = (1, n_A)`, `n_A = s_A / sqrt(3)`;
- use the inverse Gram `G^{-1}_AA = -1/2`, `G^{-1}_AB = 1/4` for that unit convention;
- define `alpha^A = (1/4) dt + (3/4) n_A . dx` and prove `alpha^A(ell_B) = delta^A_B`;
- if using scaled vectors `L_A = (sqrt(3), s_A)`, scale dual covectors too: `beta^A = alpha^A / sqrt(3)`;
- for `D = i D_N + Gamma_s Phi`, require `[Gamma_s, Phi] = 0` for `+Phi^2`; `Phi` may be odd only under a separate internal grading `chi_E`;
- decide whether `Box_null` denotes the kinetic mass-shell operator or the analytic d'Alembertian;
- audit `T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b` as physical frame transport vs contamination.

Wave 7 strategy project `ac66ea2e-0c47-458a-b5cc-b5def90c3c20` reportedly produced trusted starter modules `PhysicsSM/NullStrand/DualSolder/Core.lean` and `PhysicsSM/NullStrand/DualSolder/Square.lean`, but those may not yet be integrated into the live tree seen by this package. If they are absent, recreate the needed foundations cleanly. If they are present, extend them. Do not introduce proof holes or fake assumptions into trusted Lean.

## Job A: tetrahedral NullSolderFrame and normalization audit

**Ambition:** produce the canonical explicit dual-solder frame for the unit observer-normalized tetrahedron, with a documented bridge to the scaled square-root-free witness.

Target modules:

```text
PhysicsSM/NullStrand/DualSolder/Core.lean
PhysicsSM/NullStrand/DualSolder/Tetrahedron.lean
```

Requested trusted declarations, names may be adjusted to repo style:

```lean
unitTetNull : Fin 4 -> Minkowski4
unitTetNull_isNull : forall A, IsNull (unitTetNull A)
restObserver_dot_unitTetNull : forall A, minkowskiInner restObserver (unitTetNull A) = 1
unitTetGram_apply : ... -- diag 0, offdiag 4/3
unitTetGramInv_apply : ... -- diag -1/2, offdiag 1/4
unitTetAlpha : Fin 4 -> Covector4
unitTetAlpha_apply_ell : forall A B, unitTetAlpha A (unitTetNull B) = if A = B then 1 else 0
unitTet_dual_reconstruction : forall xi, sum A, xi (unitTetNull A) • unitTetAlpha A = xi
unitTetFrame : NullSolderFrame
scaledTet_dual_rescale_warning : ... -- optional theorem/docstring showing alpha vs beta scaling
```

Important semantic review target: no silent mixing of `ell_A = (1,n_A)` and `L_A = (sqrt(3),s_A)`. If square roots are too cumbersome, keep the exact rational Gram proof and add a docstring-proved bridge, but do not claim the wrong alpha/ell pairing.

## Job B: dual-solder commutator and kinetic quadratic form

**Ambition:** prove the finite algebraic commutator identity and the exact quadratic-form reconstruction that makes Pluecker/Gram spread a kinetic symbol invariant, not a second mass term.

Target modules:

```text
PhysicsSM/NullStrand/DualSolder/Symbol.lean
PhysicsSM/NullStrand/DualSolder/Kinetic.lean
```

Requested declarations:

```lean
supportedShift_commutator_mul : ...
dualSolder_commutator_exact : ...
dualSolder_affine_symbol_eq_clifford : ... -- finite/affine version, not continuum asymptotic if analytic API absent
dualSymbol_reconstructs_covector : forall (F : NullSolderFrame) xi, sum a, xi (F.ell a) • F.alpha a = xi
dualSymbol_quadratic_form : ... -- squared dual-soldered symbol gives Lorentzian quadratic form
plueckerKinetic_not_zeroOrder_doc : ... -- theorem or docstring contract, no physical overclaim
```

Keep continuum asymptotics in comments or task notes unless a fully finite affine theorem is available. Prefer exact finite identities.

## Job C: graded super-Dirac square with sign and grading guardrails

**Ambition:** prove the main finite ring/matrix identity for `D = i D_N + Gamma_s Phi`, building on the square decomposition.

Target modules:

```text
PhysicsSM/NullStrand/DualSolder/Square.lean
PhysicsSM/NullStrand/DualSolder/Graded.lean
```

Requested declarations:

```lean
square_decomposition_quarter -- wrapper over a Q or C algebra
DN_anticommutes_Gamma_of_components : ...
DN_comm_Phi_eq_sum_component_comm : ... -- needs [C_a, Phi]=0
superDirac_graded_square :
  (I • D_N + Gamma_s * Phi)^2 =
    -Box_null - C_diamond - T_frame + Phi^2
    - I • Gamma_s * sum a, C_a * comm (nabla a) Phi
```

Hard requirements:

- `Gamma_s^2 = 1` explicit.
- `{Gamma_s, C_a} = 0` explicit or derived.
- `[Gamma_s, nabla_a] = 0` explicit or derived.
- `[Gamma_s, Phi] = 0` explicit.
- `[C_a, Phi] = 0` explicit or derived.
- Keep `chi_E` as a separate optional internal grading; do not use it to prove the `+Phi^2` sign unless the theorem explicitly says what is happening.
- Add comments warning that `Phi` anticommuting with `Gamma_s` flips the sign.

## Job D: finite Krein API and retarded/advanced doubled operator

**Ambition:** give the graph operator a finite Lorentzian audit layer without claiming continuum spectral theory.

Target modules:

```text
PhysicsSM/NullStrand/DualSolder/Krein.lean
PhysicsSM/NullStrand/DualSolder/Doubled.lean
```

Requested declarations:

```lean
kreinAdjoint (J A) := J * A.conjTranspose * J
kreinAdjoint_involutive
kreinAdjoint_mul
IsJSelfAdjoint
blockKreinAdjoint
retardedAdvancedDouble
retardedAdvancedDouble_isJSelfAdjoint
retardedAdvancedDouble_sq_blockDiag
```

Hypotheses should include `J = J.conjTranspose` and `J * J = 1`. For the doubled operator, use `D_- = D_+^sharp` and `J_double = diag J J`. Clearly state that this is finite `J`-self-adjointness, not Hilbert self-adjointness and not continuum essential self-adjointness.

## Job E: spectral mass-shell matching and Schur-complement local dilation

**Ambition:** formalize two exact finite linear-algebra mechanisms that are downstream of the super-Dirac square.

Target modules:

```text
PhysicsSM/NullStrand/DualSolder/SpectralMatching.lean
PhysicsSM/NullStrand/DualSolder/SchurComplement.lean
```

Requested declarations:

```lean
kernel_tensorDifference_eq_matchingEigenspaces -- self-adjoint/diagonal matrix version
massShellMultiplicity_eq_sum_matchingMultiplicities
schurComplement_def
blockSystem_iff_schurComplement_of_invertible_hidden
localDilation_effectiveOperator_eq_schurComplement
```

Use a finite-dimensional self-adjoint/diagonalizable setting for the spectral theorem. If the full spectral-eigenspace theorem is too large, prove a diagonal-matrix version first. For Schur complement, assume `D_hid` invertible; pseudoinverse cases are out of scope.

## Job F: finite Markov SLLN route and stopped-node proxy

**Ambition:** build the probability/analysis side only as far as current Lean infrastructure can honestly support.

Target modules:

```text
PhysicsSM/NullStrand/Ergodic/FiniteMarkovPoisson.lean
PhysicsSM/NullStrand/Continuum/NodeBesselProxy.lean
```

Requested declarations:

```lean
finiteMarkov_poissonEquation_telescope_discrete -- discrete-time first
finiteMarkov_additive_average_telescope_bound -- algebraic bounded endpoint form
finiteCTMC_poissonEquation_charter -- doc/handoff if continuous martingales are not feasible
besselDimension_nodeThreshold_integralProxy -- real-analysis proxy for delta >= 2
nodeInaccessibility_besselCriterion_charter -- doc/handoff, not a fake SDE theorem
```

Do not fake continuous-time martingale or SDE infrastructure. If Mathlib support is insufficient, produce a rigorous draft/charter note plus exact finite/discrete/proxy lemmas.

## Submission metadata

```yaml
wave: 8
kind: lean_proof_wave
focus: dual_soldered_super_dirac_and_downstream_finite_mechanisms
jobs:
  A: 98ed0198-8f76-4d92-88e2-29cfb1e44d90
  B: 1e5aec30-6fe2-42df-a51d-10591c375234
  C: 5c813e27-8a2a-4e41-934c-4cdb2e7c6c4e
  D: f9d4c8f3-56dd-4d72-b07c-66d7804e0d41
  E: 2a7819c8-ebc3-414c-b9ba-63b903d677d1
  F: 1bc30afc-7100-40b3-85bd-16af1fcd3b47
```

## Cancellation and sharpened resubmission (2026-06-26)

Jobs B-F ran for ~8 hours `IN_PROGRESS` without returning: the package is the
full 679-module `PhysicsSM` repo, so Aristotle spent the whole budget on the
project build before proof search (the failure mode `docs/ARISTOTLE.md` warns
about). Job A (`98ed0198`) reached `IDLE` and is pending harvest (not resubmitted).

Cancelled the five running tasks with `aristotle cancel --project-id <id>`
(B `1e5aec30`, C `5c813e27`, D `f9d4c8f3`, E `2a7819c8`, F `1bc30afc`).

Resubmitted B-F from the same package with sharpened prompts (in
`scratchpad/w8_preamble.txt` + `w8_job{B..F}.txt`). The sharpening:

- **Skip the full build.** Each module must import ONLY `Mathlib` (copy any tiny
  project def in with provenance), and be verified with `lake env lean <file>`
  only -- never a project `lake build`. The targets are Mathlib-only finite
  algebra, so the full build is unnecessary; this is the fix for the 8h stall.
- **Self-contained.** `PhysicsSM/NullStrand/DualSolder/` does not exist in the
  tree or the package, so each job creates its own minimal `NullSolderFrame`
  inline rather than depending on a sibling module.
- **Literature anchors** (from open-questions section 6.14): the operator is the
  Lorentzian Borici-Creutz / 4D-hyperdiamond minimally-doubled Dirac operator
  (Creutz 0712.1201, Borici 0812.0092); the diagonal trace obstruction is a known
  lattice fact; Krein/index anchors Post 0708.3707 + van den Dungen 1505.01939;
  Job F anchors Georgii-Tumulka math/0312294 + Berndl et al quant-ph/9503013.
- **Determinant-level no-doubling guardrail** (section 6.13.7): Job C records that
  the honest no-doubling claim is `det(i D_+(q) + Gamma_s Phi) = 0`, not the
  coefficient-zero condition; the Brillouin point `q=(pi,pi,pi,0)` has nonzero
  coefficients but `p(q)^2 = 0`.
- **Grading/sign guardrails** kept explicit (`[Gamma_s, Phi] = 0` for `+Phi^2`;
  `chi_E` separate; sign-flip warning).

```yaml
resubmitted:
  A: 98ed0198-8f76-4d92-88e2-29cfb1e44d90   # not resubmitted; IDLE, pending harvest
  B: d2a1a6ca-156a-4d77-8b0d-70547ab69cfc
  C: a7b32f6c-d3db-46c7-828c-9d6549f5b383
  D: ad178148-e88a-4e89-89aa-0f80686443e0
  E: 78a4806c-40a9-4a19-aa45-bdb653592faa
  F: c1ef613e-e6a3-4c0f-afb3-efe1a32f8ef7
  status: submitted
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave8-dual-solder-lean-20260626-project
```

## Integration into live tree (2026-06-26)

The five sharpened resubmissions all reached `IDLE` in ~1 hour (vs the 8h stall) --
the skip-build + Mathlib-only sharpening worked. Each returned exactly one new
self-contained Mathlib-only module. All five were integrated into the trusted
tree:

| job | project | new module |
|---|---|---|
| B | d2a1a6ca | `PhysicsSM/NullStrand/DualSolder/DualSolderSymbolKinetic.lean` |
| C | a7b32f6c | `PhysicsSM/NullStrand/DualSolder/GradedSuperDiracSquare.lean` |
| D | ad178148 | `PhysicsSM/NullStrand/DualSolder/FiniteKreinDoubled.lean` |
| E | 78a4806c | `PhysicsSM/NullStrand/DualSolder/SpectralSchur.lean` |
| F | c1ef613e | `PhysicsSM/NullStrand/FiniteMarkovPoissonRoute.lean` |

Headline declarations: `NullSolderFrame` + `dualSymbol_reconstructs_covector` +
`dualSolder_commutator_exact` (B); `square_decomposition_quarter` +
`superDirac_graded_square` with all five grading hypotheses load-bearing +
`mass_sign_flip` guardrail + determinant-level no-doubling caveat in the
docstring (C); `kreinAdjoint`/`kreinAdjoint_involutive`/`IsJSelfAdjoint`/
`retardedAdvancedDouble*` (D); `kernel_tensorDifference_eq_matchingEigenspaces` +
`massShellMultiplicity_eq_sum_matchingMultiplicities` + `schurComplement` (E);
`finiteMarkov_poissonEquation_telescope_discrete` +
`besselDimension_nodeThreshold_integralProxy` (F).

Verification:
- All five wired into `PhysicsSM/NullStrand.lean`; `lake build PhysicsSM.NullStrand`
  exit 0 (8085 jobs).
- `#print axioms` on the headline theorem of each module: only
  `propext, Classical.choice, Quot.sound`.
- Placeholder/escape-hatch scan clean (no executable `sorry`/`admit`/`axiom`/
  `opaque`/`unsafe`/`native_decide`).
- `pre-commit run --files <the five modules + aggregator>` passes.

Cleanups applied on integration (proof bodies unchanged):
- `GradedSuperDiracSquare.lean`: top namespace `NullStrand.DualSolder` ->
  `PhysicsSM.NullStrand.DualSolder` (match siblings + AGENTS.md); inner concrete
  section `Tetrahedron` -> `GradedTetrahedron` to avoid a `dualPair` name clash
  with Job B's `Tetrahedron` section.
- `DualSolderSymbolKinetic.lean`: prose "reconstruction axiom" -> "reconstruction
  property"; dropped an unused `simp` argument.
- `FiniteMarkovPoissonRoute.lean`: underscored three context hypotheses
  (`_hstoch`/`_hinv`/`_hc`) on the telescope theorem that the algebraic identity
  does not consume (kept as documented stochastic/invariant context).

Status: B-F INTEGRATED + build-green. Job A (`98ed0198`, the tetrahedral
`NullSolderFrame`/normalization audit) remains IDLE and un-harvested -- note that
Job B already shipped a `NullSolderFrame` + tetrahedral frame, so harvest A only
to recover anything additional (e.g. the scaled-witness bridge) and dedup against
`DualSolderSymbolKinetic.lean`.
