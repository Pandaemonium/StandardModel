# Aristotle C107: finite spectral-projector covariance seed

Date: 2026-06-27
Gate: C1_NU
Dependency class: Independent
Submission style: focused standalone Mathlib package

## Project context

The non-ultralocal Gate C1 plan now prioritizes controlled `GateC1_NU` over
declared-nonlocal fallback. The hard object is a canonical branch observable:

```text
B(U)
```

If `B` is gauge-covariant:

```text
B(U^g) = S(g) B(U) S(g)^{-1},
```

then a finite spectral or polynomial projector should also be gauge-covariant:

```text
p(B(U^g)) = S(g) p(B(U)) S(g)^{-1}.
```

Before formalizing full polynomial/Riesz calculus, this focused target asks for
the finite matrix core: conjugation preserves powers and idempotence.

## Target file

```text
AgentTasks/aristotle-standalone/c107-finite-spectral-projector-20260627/C107FiniteSpectralProjector/ConjugationPowers.lean
```

## What to prove

Primary theorem:

```lean
theorem conjugate_pow
    (S T B : Matrix n n Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (k : Nat) :
    (S * B * T) ^ k = S * (B ^ k) * T
```

Projector sanity theorem:

```lean
theorem conjugate_preserves_idempotent
    (S T P : Matrix n n Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (hP : P * P = P) :
    (S * P * T) * (S * P * T) = S * P * T
```

You may add helper lemmas. Please do not weaken the intended content: matrix
conjugation by an inverse pair preserves powers and projector/idempotent status.

## Proof sketch

For `conjugate_pow`, induct on `k`.

Base:

```text
(S B T)^0 = 1 = S T = S B^0 T.
```

Step:

```text
(S B T)^(k+1)
= (S B^k T)(S B T)
= S B^k (T S) B T
= S B^(k+1) T.
```

For idempotence:

```text
(S P T)(S P T)
= S P (T S) P T
= S P^2 T
= S P T.
```

## Deliverables

Return:

```text
1. The completed Lean file.
2. Whether theorem statements changed.
3. Helper lemmas added.
4. Remaining holes, if any.
5. Whether the narrow check passed:
   lake env lean C107FiniteSpectralProjector/ConjugationPowers.lean
```

## Claim boundary

This does not prove C1_NU and does not construct `B(U)`. It is only the finite
matrix covariance seed needed before polynomial spectral projectors and Riesz
projectors.
