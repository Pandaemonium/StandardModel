# Aristotle strategy/red-team job: C1 symbol-level GW release semantic audit

You are an adversarial SEMANTIC reviewer of Lean statements, NOT a prover. The
kernel already checked these proofs; decide whether the kernel-checked
STATEMENTS mean the intended mathematics, and where they could mislead. Do NOT
attempt a Lean build (these files depend on Mathlib and the wider project).
Read the attached verbatim source and return a written report.

## Standalone context (assume you are blind to the repo and chat)

This is the Gate C1 lane of a lattice chiral-fermion program: an overlap
construction on an exotic lattice (four future null directions arranged
tetrahedrally, rank-4 Brillouin torus). The Hermitian sign kernel is
`H = gamma5 * K` where `K = a^{-1}(i Q + m)` is the Wilson/Dirac symbol, `Q` the
tetrahedral Euclidean slash (`Q^2 = qExact . I` by the Clifford/Gram identity),
and `m = mWilson` a scalar Wilson mass. The "first Wilson band" is
`0 < rho < 2 r`.

A result was landed tonight and is claimed to be the CHIRAL RELEASE (the overlap
/ Ginsparg-Wilson construction) at the momentum-symbol level. The claimed key
simplification: because `H(k)^2 = coeff(k) . I` is a SCALAR multiple of the
identity (Euclidean-Clifford scalar square), the sign function is elementary -
`eps(k) = coeff(k)^{-1/2} H(k)` is an explicit self-adjoint involution, with no
functional calculus. Then the overlap Dirac symbol `Dov = 1 + gamma5 . eps`
satisfies the Ginsparg-Wilson relation.

The claim is deliberately scoped as: SYMBOL-LEVEL (per-momentum k), FREE
(no gauge background), REGULATOR-LEVEL (a property of the fixed tetrahedral
regulator, not Lorentz-invariant or continuum), NOT the operator-level release,
NOT a gauge index theorem.

## Deliverable

Return a report named `GateC1_GWRelease_SemanticAudit.md` answering:

1. IS IT REALLY THE CHIRAL RELEASE? Does `symbol_ginsparg_wilson` (with
   `signSymbol` as `eps`) faithfully express the overlap/Ginsparg-Wilson chiral
   release at the symbol level? Is `eps = coeff^{-1/2} H` genuinely the SIGN of
   `H` (i.e. `eps = H (H^2)^{-1/2}`), or merely SOME involution? Check that
   `H^2 = coeff . I` with `coeff > 0` makes `coeff^{-1/2} H` equal to the
   spectral sign of the self-adjoint `H`, not a weaker object.
2. HYPOTHESIS HONESTY. Audit every hypothesis of `H_symbol_sq`, `signSymbol_sq`,
   `symbol_ginsparg_wilson` (`star gamma5 * gamma5 = 1`, `star gamma5 = gamma5`,
   `{gamma5, Q} = 0`, `0 < sqCoeff`). Are they the correct, minimal chiral-Wilson
   relations? Is anything silently assumed (e.g. that `gamma5` is a genuine
   chirality, that `Q` is the real kinetic slash, that `coeff` is the gap
   coefficient)? Is `H_symbol_hermitian` (self-adjointness) actually needed and
   correctly used to get `H^2 = coeff . I`?
3. VACUITY / TRIVIALITY. Could any statement be vacuous or trivially true for
   the wrong reasons (e.g. if `Spin` could be empty, if `coeff` could be forced
   in a degenerate way, if `Dov` reduces to something trivial)? Is the GW
   relation `gamma5 Dov + Dov gamma5 = Dov gamma5 Dov` the correct normalized
   form?
4. OVER-READ GUARDS. List the ways a reader could over-claim this: as an
   operator-level release, as a gauge/index result, as a continuum/Lorentz
   statement, as a no-doubling theorem, as a nonzero chiral index. For each,
   the one sentence that keeps it honest.
5. NEXT RUNG. The claimed successor is packaging these per-momentum symbols to
   an OPERATOR-level release via the block diagonalization. Is that the right
   next step, and what exactly does it need (inverse Fourier / round-trip;
   operator `sign(Hfree)` from the varying `coeff(k)`)? Sharpest Lean-ready
   statement of the operator-level GW relation.

## Attached verbatim source

- TetraSymbolOverlapGW.lean (the release under review)
- OverlapGinspargWilson.lean (the abstract GW algebra it instantiates)
- TetraSymbolHermitian.lean (symbol Hermiticity / self-adjointness)
- TetraScalarWilsonSymbol.lean (H, K, K_star_mul, the gap)
- TetraQMatrixSquareExact.lean (Q, Q_square_exact - the Clifford scalar square)

## Rules

- ASCII only; spaced forms `s o r r y` / `a d m i t` for Lean placeholder tokens
  in prose.
- The proofs are kernel-checked; do NOT re-verify them. Audit the STATEMENTS.
- Be adversarial: a real semantic mismatch, a hypothesis that does not mean what
  it should, or an over-claim risk is the valuable output. In particular,
  scrutinize the claim that "H^2 = scalar makes the sign elementary" - is that a
  genuine chiral-release shortcut or a sleight of hand?
