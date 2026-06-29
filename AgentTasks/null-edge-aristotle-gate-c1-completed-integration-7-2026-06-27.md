# Gate C1 Aristotle completed integration: C138

Date: 2026-06-27
Status: Summary integrated into Gate C1 docs; standalone Aristotle artifact is not yet promoted into trusted repo Lean.

## Executive result

C138 closes the general sign-transfer blocker in a useful, honest form.

The result is not "any nonzero odd seed survives the sign function." That is false. The theorem says that if the full gapped Hermitian kernel anticommutes with the balance involution `J`, then its sign is also purely `J`-odd. Equivalently, the kernel needs a genuine sign-straddling spectrum, not merely a small odd perturbation sitting inside a dominant positive even background.

This fits the finite seed story very well:

```text
J-odd branch-Pauli seed
  + anticommuting / sign-straddling kernel
  + spectral gap
  -> Odd_J(sign(H_ne)) != 0
```

It also gives a clear no-go warning:

```text
J-odd seed alone
  + dominant positive J-even background
  -> sign(H) can collapse to identity
  -> Odd_J(sign(H)) = 0
```

So Gate C1 now needs to prove that the actual null-edge kernel is in the first regime, not the second.

## Integrated result

### C138: J-odd sign-transfer theorem

Project: `a7152d81-c41e-44fa-94ec-3f811062877c`
Task: `a1dba6ed-1a30-46bc-ad75-0f83b9089aed`

Delivered a self-contained finite-matrix Lean development over complex matrices.

The main theorem is `oddJ_sign_of_anticomm`: if `H` is Hermitian, invertible, and anticommutes with the balance involution `J`, then `sign(H)` is itself purely `J`-odd and nonzero. This is the sign-transfer theorem Gate C1 needed.

The matching no-go is also important: if `H` is `J`-even, then `Odd_J(sign(H)) = 0`. This recovers the previous scalar/even-kernel no-go results.

The counterexample is decisive: a nonzero `J`-odd seed can still fail if a dominant positive `J`-even part pushes the full spectrum to one sign. In that case `sign(H) = 1`, so the odd sign charge vanishes.

The finite branch-Pauli seed is an instance of the positive theorem when the kernel genuinely anticommutes/sign-straddles. Thus the C136/C141/C145 finite seed is not accidental: its sign oddness is explained by a clean algebraic mechanism.

## Updated Gate C1 obligation

Replace the vague sign-transfer obligation with:

```text
Prove H_ne is gapped and either anticommutes with J, or has an equivalent
sign-straddling spectral decomposition strong enough to force
Odd_J(sign(H_ne)) != 0.
```

Do not accept:

```text
Odd_J(W_branch) != 0
```

by itself. C138 proves that is not enough.

## Remaining blockers after C138

1. C148 is still running and should connect finite origin data to stable branch-line topology.
2. The actual Standard Model/null-edge kernel must be checked for the anticommuting or sign-straddling condition.
3. The reference homotopy program must preserve this sign-straddling condition or replace it with a homotopy-invariant signature check.
4. Standalone Aristotle Lean is not yet promoted into trusted repo Lean.
