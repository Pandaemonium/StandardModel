Gate C1 covariant branch-mass realization fallback, C245

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C240 now makes scalar Wilson viable for the finite free branch table, subject
to the lattice-duality theorem and global free gap still being proved. Therefore
this job is no longer the first branch. It is the fallback if scalar Wilson
fails globally or if later gauge/internal structure forces a non-scalar branch
mass.

C241 proved the free branch-mass interpolation theorem:

```text
M_br(p) = sum_I c_I prod_{A in I} cos(k_A)
```

can realize arbitrary masses on the 16 free branch points. In a gauge
background, the proposed replacement is:

```text
C_A[U] = (1/2)(T_A[U] + T_A[U]^dagger),
```

and products over `C_A` must be symmetrized because `C_A` generally do not
commute.

Task:

Design the finite/gauge-covariant API for a fallback branch-mass operator:

```text
M_br[U] = sum_I c_I SymProd({C_A[U] : A in I}).
```

Please answer:

1. What assumptions on `T_A[U]` make `C_A[U]` Hermitian?
2. How should `SymProd` be defined so it is Hermitian for Hermitian
   noncommuting `C_A`?
3. What is the free-limit theorem connecting `SymProd(C_A)` back to
   `prod cos(k_A)` when the shifts commute/diagonalize?
4. What gamma5-even condition is needed so `M_br` is compatible with C239?
5. What gauge-covariance statement should hold:

```text
M_br[U^g] = G M_br[U] G^-1?
```

6. What should remain a source contract versus a Lean theorem?
7. What minimal Lean structures should Codex create next?

Constraints:

- Treat `M_br` as fallback, not default.
- Do not claim `M_br` solves anomaly/Krein/no-ghost questions.
- Do not use propagator zeros as mirror removal.
- Keep the free Walsh interpolation result separate from gauge-covariant
  realization.
- Record any free coefficients as added moduli unless symmetry/minimality fixes
  them.

Requested output:

- API design;
- theorem statements;
- proof plan;
- no-overclaim boundary;
- recommended Draft file name.
