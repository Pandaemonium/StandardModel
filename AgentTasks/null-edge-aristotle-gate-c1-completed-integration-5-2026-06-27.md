# Gate C1 Aristotle completed integration: C142, C143, C146, C147, C153

Date: 2026-06-27
Status: Summary integrated into Gate C1 docs; standalone Aristotle artifacts are not yet promoted into trusted repo Lean.

## Executive result

This completed batch turns several previous "physics handoff" items into clear theorem interfaces, and one important analytic handoff is now closed outright.

The biggest update is `C146`: the sign-continuity estimate needed by the homotopy/import route is now machine-checked using continuous functional calculus under a uniform spectral gap. This strengthens `C130` and `C142`: a gapped homotopy to a known overlap/domain-wall kernel is now a much cleaner import route.

The other results provide the remaining audit interfaces:

1. `C142`: a formal homotopy/import contract for transferring GW branch-selection algebra, index/anomaly class, projector rank/chirality data, and locality from a reference overlap/domain-wall sign kernel to the null-edge sign kernel.
2. `C143`: a non-ultralocal path-sum oddness survival certificate in the user's preferred combinatorial/path-integral style.
3. `C147`: an anomaly/index import contract, including a finite Standard Model anomaly audit and explicit failure guards.
4. `C153`: a docs-ready propagator-zero ghost rule plus finite formal backbone linking acceptable mirror removal to inverse gaps and Schur-Feshbach invertibility.

Plain-English takeaway: the project is now much less dependent on vague "import physics later" language. The import route, locality/path-sum route, anomaly/index checklist, and no-ghost rule all have concrete theorem interfaces.

## Integrated results

### C142: homotopy/import interface contract

Project: `baadc86f-c5f0-4f5d-9fdc-a7a39fae489e`
Task: `aeacd582-3e49-494a-ac21-bd49c50b5462`

Delivered a fully machine-checked Lean interface for import mode. The central theorem says: if a reference overlap/domain-wall sign kernel and the null-edge sign kernel are connected by a gauge-covariant, gap-preserving homotopy, then the null-edge kernel inherits the GW branch-selection algebra, index/anomaly class, projector rank/chirality data, and locality transfer.

The job separates finite algebra, spectral-gap/homotopy, locality, and anomaly-line assumptions. It also provides a go/no-go decision rule: import mode is licensed exactly when such a homotopy exists; otherwise native mode must satisfy the full new-regulator obligation stack.

Use in Gate C1: this is now the main interface theorem for reference-model-first development.

### C143: path-sum oddness survival certificate

Project: `34b67708-565a-40c8-9618-422f8a36514f`
Task: `e8fc59ac-f287-406a-8c8c-5e5c4d510168`

Delivered a standalone Lean certificate for non-ultralocal path-sum oddness survival. The certificate packages shell contributions, shell counts, amplitude bounds, summability, a finite cutoff, and a strict domination condition saying the finite odd partial sum dominates the whole tail.

The core theorem proves that the limiting path-sum has nonzero `Odd_J`. A bridge theorem says the same applies to `sign(H)` if the sign operator is represented as the limit of Neumann/resolvent approximants matching those path sums.

Failure modes are also formalized: equality at the boundary can cancel the odd contribution, and conditional convergence without absolute/dominated summability does not give a usable tail bound.

Use in Gate C1: controlled nonlocality can now be expressed in combinatorial path-sum terms rather than strict ultralocality.

### C146: sign-continuity under uniform spectral gap

Project: `c14a7279-e454-4896-a2d6-8bcf922076d1`
Task: `56e16947-faf7-44a1-aca7-93e4cd45845a`

Closed the analytic handoff from C130. The operator sign is defined as `cfc Real.sign H`; for a self-adjoint path with spectrum uniformly bounded away from zero, the sign operator is norm-continuous. The theorem is proved in a general unital C-star algebra setting, so finite Hermitian matrices are included as a special case.

The proof uses Mathlib's continuous functional calculus on a fixed compact spectral window avoiding zero. A counterexample shows the uniform-gap hypothesis is essential: when the gap closes, sign continuity can fail.

Use in Gate C1: the gapped homotopy/import route is now significantly stronger. The sign-continuity piece no longer needs to remain a prose-only analytic assumption.

### C147: anomaly/index import contract

Project: `0dfe5fee-ac33-4ea6-9732-7d7945f3ce32`
Task: `71c5086c-7a16-441b-b38b-e3b129dd2429`

Delivered a Lean interface and checklist for importing anomaly/index behavior. The central structure says that under a gapped, gauge-covariant, local, continuum-compatible homotopy to a reference overlap/domain-wall regulator, the null-edge finite chiral index equals the reference index.

The job separates finite trace/index data, homotopy index inheritance, gauge covariance, locality/admissibility, continuum limit, and determinant-line/anomaly matching. It also includes a finite Standard Model anomaly audit for one generation and records failure guards: gap closure, non-gauge-covariant homotopy, nonlocality beyond admissible control, and ghost-zero mirror removal.

Use in Gate C1: anomaly/index accounting should be a certificate stack, not an informal afterthought.

### C153: propagator-zero ghost rule

Project: `8db82bfa-9769-4579-9ade-c0b8cd5c998c`
Task: `de295aed-e0c0-463d-93b2-4172d283b934`

Delivered a docs-ready ghost-rule section and formal finite backbone. The prose audit translates Golterman-Shamir/Poppitz-Shang warnings into Gate C1 language: bad branches must be lifted by inverse-propagator gaps or overlap/domain-wall projection, never by zeros in the propagator.

The Lean backbone defines an acceptable `InverseGap`, proves it gives trivial kernel/invertibility/bounded propagator behavior, proves a propagator zero admits no inverse propagator, and links the acceptable no-ghost audit to Schur-Feshbach invertibility.

Use in Gate C1: every candidate operator must pass the no-propagator-zero audit. C139/C153 together give the finite acceptable route: heavy-block invertibility and a valid Schur complement.

## Updated Gate C1 status after this batch

The reference-model-first route is now:

```text
finite gauge-safe odd seed
  -> gapped sign kernel
  -> sign-continuity under uniform gap
  -> gap-preserving homotopy to reference overlap/domain-wall
  -> inherited GW/projector/index/anomaly/locality data
```

The non-ultralocal native route is now:

```text
finite odd partial path contribution
  + shell-count/amplitude summability
  + strict finite-piece > tail domination
  -> nonzero limiting Odd_J
```

The no-ghost audit is now:

```text
acceptable: inverse-propagator gap / heavy-block invertibility / overlap-domain-wall projection
unacceptable: removing a gauge-charged branch by a propagator zero
```

## Remaining blockers

1. `C138` sign-transfer theorem is still running; it should generalize the successful finite witness.
2. `C144`, `C145`, `C148`, `C149`, `C150`, `C151`, and `C152` are still pending/running and should settle SM gauge internality, trusted promotion, branch-line lifting, reference homotopy, flavored-mass translation, locality comparison, and domain-wall import details.
3. The C147 anomaly/index contract still carries physical imports for determinant-line/anomaly matching and continuum compatibility.
4. Standalone Aristotle Lean artifacts remain unpromoted into trusted repo Lean.
