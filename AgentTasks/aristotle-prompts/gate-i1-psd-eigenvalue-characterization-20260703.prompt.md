# Gate I1.2 PSD/eigenvalue characterization prompt

You are working on a focused Lean 4 / Mathlib-only package for the StandardModel
Gate I1 kinematic core. The project contains one target file:

```text
GateI1KinematicCore/Core.lean
```

Run the narrow check first:

```text
lake env lean GateI1KinematicCore/Core.lean
```

The file currently kernel-checks and contains the Pauli/Hermitian soldering map
for real four-momenta:

```lean
def minkHerm (p : Momentum4) : Herm2 :=
  !![((p 0 + p 3 : Real) : Complex),
     ((p 1 : Real) : Complex) - ((p 2 : Real) : Complex) * I;
     ((p 1 : Real) : Complex) + ((p 2 : Real) : Complex) * I,
     ((p 0 - p 3 : Real) : Complex)]
```

Conventions: mostly-minus signature, `spatialNormSq p = p1^2+p2^2+p3^2`,
`spectralMinus p = p0 - sqrt(spatialNormSq p)`, and
`spectralPlus p = p0 + sqrt(spatialNormSq p)`. The file already proves:

- `minkHerm_conjTranspose`
- `det_minkHerm`
- `i1_2_det_minkHerm_sub_smul_one`
- `i1_2_spectralPlus_det_zero`
- `i1_2_spectralMinus_det_zero`
- `i1_2_spectralMinus_nonneg_iff_futureCone`
- `i1_2_spectralRoots_nonneg_of_futureCone`
- rank-one PSD/rank lemmas for `rankOne`

## Target

Please add theorem(s) completing the full I1.2 characterization. Preferred
names/statements:

```lean
/-- `minkHerm p` is Hermitian as a Mathlib `IsHermitian` proposition. -/
theorem minkHerm_isHermitian (p : Momentum4) :
    (minkHerm p).IsHermitian := by
  ...

/-- I1.2: positive semidefiniteness of the soldered block is exactly the
future cone condition in mostly-minus signature. -/
theorem i1_2_minkHerm_posSemidef_iff_futureCone (p : Momentum4) :
    (minkHerm p).PosSemidef
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  ...

/-- I1.2 eigenvalue form: Mathlib's Hermitian eigenvalues are nonnegative
exactly on the same future cone. -/
theorem i1_2_minkHerm_eigenvalues_nonneg_iff_futureCone (p : Momentum4) :
    0 <= (minkHerm_isHermitian p).eigenvalues
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  ...
```

If the exact eigenvalue theorem needs a different but semantically equivalent
statement because of Mathlib indexing or namespace details, keep the
`PosSemidef` iff theorem unchanged and add the eigenvalue bridge as a nearby
corollary.

## Proof hints

- `open scoped ComplexOrder` is already enabled; this is needed for
  `Matrix.PosSemidef` over `Complex`.
- Forward direction can use positive diagonal entries and determinant
  nonnegativity for PSD matrices. Relevant existing lemmas may include
  `Matrix.PosSemidef.diag_nonneg`, `Matrix.PosSemidef.det_nonneg`, and the
  local `det_minkHerm`.
- Reverse direction may be easiest by a `2 x 2` Cholesky/square-completion
  argument. It is fine to add small helper lemmas for Hermitian `2 x 2` blocks.
  Another route is `Matrix.posSemidef_iff_eq_conjTranspose_mul_self` with an
  explicit factorization, splitting on `p 0 + p 3 = 0` versus positive.
- Please do not weaken the future-cone statement and do not change the existing
  conventions, signs, definitions, or theorem statements.

## Guardrails

- No new assumptions beyond the theorem variables.
- No raw placeholder or escape-hatch tokens in executable Lean.
- Do not use `n a t i v e _ d e c i d e`.
- Keep imports Mathlib-only.
- ASCII in returned code and prose.
- If the target theorem is false as stated, stop and explain the counterexample
  or missing hypothesis rather than changing the statement silently.

Return the full updated contents of `GateI1KinematicCore/Core.lean` or a patch.
