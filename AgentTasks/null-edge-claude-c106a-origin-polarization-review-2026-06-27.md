# Claude adversarial review packet: C106a origin polarization

Date: 2026-06-27
Project: Null-edge / Gate C1
Subject: C106a `OriginPolarizationEscapeHatch`

## Context

Gate C1 is still open. The bare retarded symbol `D_+` has a balanced origin
kernel and scalar Wilson lifting can support C0 species health but cannot select
one physical Weyl line at the origin.

Latest strategy:

```text
C1 first requires a native, gauge-safe origin polarizer, or a no-go theorem
showing that the native origin algebra cannot contain one.
```

The first finite theorem target is C106a:

```text
If K0 has chirality Gamma0 and a balance symmetry J satisfying
J Gamma0 J^-1 = -Gamma0, then any origin selector P0 commuting with J has
zero chiral index Tr(Gamma0 P0).
```

If this is right, then any C1 origin selector with nonzero target index must
escape the balance commutant.

## Exact Lean source under review

The wrapper call attaches:

```text
AgentTasks/aristotle-standalone/c106a-origin-polarization-20260627/C106aOriginPolarization/OriginPolarizationEscapeHatch.lean
```

## Intended reading

The standalone target is a finite-matrix proxy for the null-edge origin fiber:

```text
Gamma0 = chirality operator on K0
J = balance involution, with J^2 = 1 and J Gamma0 J = -Gamma0
P0 = candidate origin projector/selector
ChiralIndex Gamma0 P0 = trace(Gamma0 * P0)
```

The first theorem intentionally does not require `P0` to be a projector; the
trace argument only needs commutation with `J`. That is acceptable if the proof
is otherwise aligned.

## Questions for Claude

Please attack the statement and strategy.

1. Is the finite theorem mathematically correct as stated over complex matrices?
2. Does `hflip : J * Gamma0 * J = -Gamma0` plus `hJ2 : J * J = 1` correctly
   represent `J Gamma0 J^-1 = -Gamma0`, or should the theorem be stated with an
   explicit inverse instead?
3. Does the proof need stronger hypotheses, such as finite dimensionality,
   invertibility, projector/idempotent, self-adjointness, or commutation on the
   other side?
4. Is the corollary direction semantically aligned with the Gate C1 claim:
   nonzero origin index requires escaping the balance commutant?
5. What would be the most dangerous overclaim if we later cite this theorem in
   the Gate C narrative?
6. Should the next theorem be C106b native-origin-commutant no-go, or should we
   first strengthen C106a to a functional-calculus/spectral-projector statement?

## Requested output

Return:

```text
Verdict:
- sound / needs adjustment / false / too weak

Statement issues:
- ...

Gate C interpretation risks:
- ...

Best next theorem:
- ...
```
