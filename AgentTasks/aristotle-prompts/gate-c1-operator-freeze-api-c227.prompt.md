Gate C1 operator-freeze API and strategy job, C227

You are Aristotle working on the StandardModel Lean 4 project.

Project context:

Pro has sharpened the Gate C1 architecture:

```text
Wilson/Neuberger overlap reference
  with CKM inserted as an internal branch/flavor mass texture,
  not as the primary spacetime doubler-resolution operator.
```

Therefore:

```text
Wilson/Neuberger resolves spacetime momentum doublers.
CKM splits finite branch/flavor sectors.
The null-edge endpoint must be gapped-homotopic to the reference.
```

The reference kernel should be:

```text
H_ref(U) =
  Gamma_ref [
    D_W^0(U) tensor I_CKM
    + I tensor r_b(15 I - M_CKM)
    - m0 I
  ].
```

The null-edge endpoint should be:

```text
H_ne(U) =
  Gamma_K [
    D_ne^cov(U)
    + W_NE,space(U)
    + r_b(15 R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

The free mass window is:

```text
0 < m0 < min(2 r_W, 16 r_b),
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

Files in this request project:

- `CKMWilsonWindow.lean`
- `GappedHomotopy.lean`
- `SignStability.lean`

Task:

Design the smallest formal API needed to freeze the operator choice and prepare
the next local Lean work.

Please propose:

1. Records or predicates for `H_ref`, `H_ne`, transport `S`, and the constants
   `kappa`, `omega`, `rho`, `alpha`, `beta`.
2. A theorem statement expressing:

   ```text
   ||H_ne - S H_ref S^-1|| <= kappa + omega + rho + alpha + beta
   < gamma_free
   -> gapped homotopy.
   ```

3. First-pass zero clauses:

   ```text
   omega = 0 by exact CKM transport;
   rho = 0 by R_ref = R_ne = I;
   alpha = 0 at U = 1;
   beta = 0 in the flat branch frame.
   ```

4. A guardrail predicate or source comment preventing CKM-only spacetime
   doubler-resolution overclaims.
5. The minimum next Lean module layout after the promoted Draft leaves compile.

Constraints:

- This is a strategy/API job, not a broad proof search.
- Keep the API close to the promoted leaves.
- Do not claim the actual null-edge endpoint is already defined.
- Do not claim anomaly, determinant-line, Krein, ghost, gauge, or quantum Gate
  C closure.
- Prefer small, checkable theorem statements that Codex can implement locally.

Requested output:

- proposed Lean structures/theorem statements;
- relation to the three provided files;
- local module layout;
- exact next Aristotle proof jobs after the API is implemented;
- explicit no-overclaim guardrails.
