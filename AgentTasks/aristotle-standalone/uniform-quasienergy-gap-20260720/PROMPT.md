# Job: uniform quasienergy gap from pointwise no-crossing (HNU headline upgrade)

Prove the single theorem `uniform_quasienergy_gap` in
`PhysicsSM/Draft/NullEdge/UniformQuasienergyGap.lean` (statement unchanged).
This is an audit-driven strengthening of a landed AFPL result: a continuous
family of unitaries over a compact parameter space with no zero and no pi
quasienergy crossing pointwise has a single UNIFORM margin separating every
eigenvalue from +1 and -1.

The file docstring carries the full proof plan:
1. compactness: `‖(U k - 1).det‖` and `‖(U k + 1).det‖` are continuous, nowhere
   zero, on a nonempty compact space, so each has a positive minimum `δ₀`;
2. spectral: `μ` an eigenvalue (`det (U k - μ • 1) = 0`) is a root of the
   characteristic polynomial, `det (U k - 1) = ∏ (eigenvalue - 1)`, and
   unitarity gives `‖eigenvalue - 1‖ ≤ 2`, so
   `‖μ - 1‖ ≥ ‖det (U k - 1)‖ / 2^(m-1) ≥ δ₀ / 2^(m-1)`;
3. `δ = δ₀ / 2^(m-1)`.

Constraints: Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`;
standard axioms `[propext, Classical.choice, Quot.sound]`. Do not change the
statement. Verify with `lake env lean PhysicsSM/Draft/NullEdge/UniformQuasienergyGap.lean`.

Acceptable fallback if the general-`m` eigenvalue-product identity is heavy:
prove the theorem for `m = 4` (the physical HNU case) and return the general-`m`
lemma `det (U - 1) = ∏ (eigenvalue - 1)` as the single named missing ingredient,
with the compactness half fully proved.

Report axioms for the proved result.
