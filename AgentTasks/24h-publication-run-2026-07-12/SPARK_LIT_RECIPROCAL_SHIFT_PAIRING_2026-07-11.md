# Literature pass: reciprocal conditional shifts and strict 3+1 successors

Date: 2026-07-11 20:12 PDT.  Owner: Codex direct fallback after two Spark
workers failed at their context boundary.  Sources below are primary papers or
publisher-hosted full text.

## Ranked findings

1. **Conditional shifts are a complete one-dimensional construction
   language, not an ad hoc repair.**  Cedzich, Geib, and Werner prove in
   Theorem 2.1 that a one-dimensional unitary is banded exactly when it can be
   written, on every uniformly bounded cell structure, as a finite product of
   local coins and powers of one fixed conditional shift.  Lemma 2.2 gives the
   equivalent generalized-shift factorization.  This directly supports
   treating `D(z)=diag(z,1)` plus coins as the correct exact-local primitive
   vocabulary, and it suggests a Lean-facing normal-form theorem for any 1D
   restriction of a proposed 3D walk.  It does **not** imply that a separable
   product of three such restrictions can isolate one 3D Weyl cone.
   [arXiv:2102.12951](https://arxiv.org/abs/2102.12951),
   [open full text, Theorem 2.1 and Lemma 2.2](https://link.springer.com/article/10.1007/s11005-022-01578-3).

2. **The closest current 3+1 construction confirms our diagnosed resource
   boundary.**  Gupta and Short construct a broad local unitary family by
   allowing nonzero stationary amplitude, removing conventional doublers and
   pseudo-doublers for suitable parameters.  Their Section III.2 and
   Discussion nevertheless retain two extraneous low-energy solutions and
   explicitly attribute the residue to assembling the 3D walk by combining
   one-dimensional walks; they propose a more general higher-dimensional
   construction as the next route.  This is unusually direct external support
   for searching nonseparable substeps, enlarged cells, or memory registers
   rather than another separable onsite coin.  Their numerical statement about
   absence of additional roots is not a substitute for our exact torus
   certificate.
   [arXiv:2601.15885v2](https://arxiv.org/html/2601.15885v2), especially
   Sections III.2 and IV.

3. **Causality plus unitarity legitimizes finite-depth local circuit and
   ancillary-cell escape architectures.**  Arrighi, Nesme, and Werner prove
   that a causal unitary on a graph is locally implementable and apply the
   representation to arbitrary-dimensional QCA.  This does not promise a
   four-component one-cell solution; rather, it says that a valid causal
   survivor may naturally appear as a layered circuit on enlarged local cells.
   That makes "extra directional memory" a principled construction resource,
   not an admission of nonlocality.
   [arXiv:0711.3975](https://arxiv.org/abs/0711.3975).

4. **The one-dimensional index/factorization literature separates delay from
   local mixing.**  Gross, Nesme, Vogts, and Werner prove that the quantum-walk
   index is integer-valued, additive under composition, represented by shifts,
   and that trivial-index walks are partitioned unitaries.  Our reciprocal word
   has determinant one and no net delay, so its scientific value is the exact
   higher-order local mixing it supplies, not a hidden index.  This reinforces
   the need for an explicit 3D root or charge argument after embedding.
   [arXiv:0910.3675v2](https://arxiv.org/abs/0910.3675v2).

5. **Quadratic dispersion is a known de-doubling resource, but current twisted
   walks do not close our stricter gate.**  Jolly and Di Molfetta construct
   twisted walks whose continuum limit contains a dispersion term and analyze
   its regularizing effect on doubling.  The paper is useful as a comparison
   for the zero-first-jet/nonzero-second-jet mechanism; it does not provide the
   exact finite-Laurent, all-zone, single-cone certificate required here.
   [arXiv:2212.13859v3](https://arxiv.org/abs/2212.13859v3).

## Immediate theorem consequences

- Keep the reciprocal conditional-shift primitive and prove its exact Laurent
  coefficient range.  This is now queued as `ReciprocalLaurentRange`.
- Treat separability itself as a candidate resource lower bound.  The strongest
  next no-go should cover products of axiswise two-band protocols with a fixed
  four-component onsite mixer, not all causal QCAs.
- The constructive search should move to a layered, nonseparable block circuit
  with an explicit direction-memory register.  The localizability theorem says
  such a circuit remains a legitimate strict QCA.
- Any borrowed claim from the 2026 Gupta-Short family must distinguish their
  elimination of conventional doublers/pseudo-doublers from the two residual
  low-energy solutions they explicitly retain.

## Negative result of the search

No primary source found in this pass supplies an exact four-component,
finite-range, all-Brillouin-zone proof of one isolated 3D Dirac/Weyl cone while
also retaining the desired continuum tangent.  The literature therefore
sharpens rather than closes our gate: conditional shifts are universal local
building blocks, but nonseparable higher-dimensional architecture and exact
root certification remain the missing content.
