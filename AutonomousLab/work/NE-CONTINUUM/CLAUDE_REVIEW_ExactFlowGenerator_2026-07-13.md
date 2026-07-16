# Claude cross-family review: ExactFlowGenerator (Aristotle c2da9ae1)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle job c2da9ae1)
- Work item: `CONT-FOURIER-001`
- Source: returned `ExactFlowGenerator.lean` (82 lines), sha256 cb37ad9f... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Declarations and audit

### `fibreGenerator kx ky kz m := (-I) * H kx ky kz m`

The fixed skew-Hermitian fibre generator `-iH`. Definition only.

### `exactFlow_hasDerivAt` (all `t`)

`HasDerivAt (fun s => exactFlow kx ky kz m s) (exactFlow kx ky kz m t * fibreGenerator kx ky kz m) t`.

- **Scalar algebra:** the `key` lemma proves `exactFlow s = exp (s * fibreGenerator)`
  by rewriting `exactFlow`/`fibreGenerator` and reconciling `s * ((-I)*H)` with
  the live definition's `(-(s:C)) * (I*H)` via `smul_smul`, `smul_assoc`,
  `Complex.real_smul`, `ring`. This is exactly the `exp(s*(-iH))` identification.
- **Derivative orientation:** RIGHT multiplication `exactFlow t * fibreGenerator`,
  produced by Mathlib's `hasDerivAt_exp_smul_const (K := R)`. Well-defined
  because `exactFlow t = exp(t * gen)` commutes with `gen`, so right = left.
- Genuine content (not hollow): the flow is genuinely identified with a
  one-parameter matrix exponential before the standard derivative lemma applies.

### `momMult_apply_hasDerivAt_zero` (at `t = 0`)

`HasDerivAt (fun t => momMult m t k v) (toEuclideanCLM (fibreGenerator (k0 k1 k2) m) v) 0`.

- **CLM composition:** builds `lin : Mat4 ->L[C] Spinor`, `M |-> toEuclideanCLM M v`,
  restricts scalars to R, and chain-rules `(L.hasFDerivAt).comp_hasDerivAt 0`
  with `exactFlow_hasDerivAt` at `t=0`. Then `exactFlow 0 = 1`, `one_mul`
  collapse `L (1 * fibreGenerator)` to `toEuclideanCLM (fibreGenerator) v`.
- Correctly a POINTWISE statement: fixed momentum `k`, fixed spinor `v`, and
  `t = 0` only. Real-time derivative uses `restrictScalars R` (R-linearity), not
  a hidden complex-analytic assumption.

### `fibreGenerator_rest_four` (nonzero control)

`fibreGenerator 0 0 0 4 = (-4*I) * beta`. Confirms the rest generator carries the
nonzero mass coefficient (`H 0 0 0 4 = 4*beta`), so the target is not the
derivative of a constant identity family. Genuine non-degeneracy control.

## Overclaim tests

- Vacuity: none (`fibreGenerator_rest_four` nonzero; genuine derivative identity).
- Hollow telescoping: none (flow-as-exponential identification is real content).
- Docstring overreach: none -- the docstring is conservative, explicitly
  disclaiming an unbounded L2 generator, domain choice, Fourier transport, and
  the position-space Dirac PDE. If anything it under-claims.
- False shape: none -- `HasDerivAt` of a matrix-exponential flow with a
  right-multiplication generator is the correct shape.
- Hidden assumptions: none beyond standard Mathlib (`hasDerivAt_exp_smul_const`,
  `toEuclideanCLM`, `restrictScalars`).
- Statement immutability: statements match the intended pointwise finite-dim
  real-time derivative; not weakened.

## Independent verification

- `lake env lean` on a clean-path copy (the returned file lives under a deeply
  nested `aristotle-output/.../project-files.tar/...` path; copied out per the
  standing replay-verify lesson): exit 0, no errors/warnings/sorry.
- `#print axioms` on all three theorems: `[propext, Classical.choice,
  Quot.sound]` only -- no `sorryAx`, no `Lean.ofReduceBool`/`trustCompiler`.
- At bank time, add the standard `#guard_msgs (whitespace := lax) in
  #print axioms ...` block for each theorem (the returned file has none yet).

## Narrowest defensible claim

At a single fixed momentum fibre, the exact finite-dimensional (4x4 complex)
Dirac matrix flow `exactFlow(s)` is real-time differentiable for every `t`, with
derivative `exactFlow(t) * fibreGenerator` (right multiplication by the fixed
skew-Hermitian generator `-iH`); and at `t = 0` the induced spinor-valued map
`t |-> momMult(t) v` is differentiable with derivative
`toEuclideanCLM(fibreGenerator) v`. The generator is nonzero (carries the mass
at rest). No full-`L2` generator, domain, Fourier transport, position-space PDE,
Stone theorem, continuum, or Lorentz claim is made.
