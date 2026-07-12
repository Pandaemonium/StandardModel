# Summary of changes for run ad410454-5a64-4d86-934a-336688245794
Formalized the "exact interacting two-particle spectrum" fixture in namespace `PhysicsSM.Draft.NullEdge.PairSpectrumFixture`, across two new files under `context/`. All source is free of `sorry`/`admit`; no `axiom` or `@[implemented_by]` was introduced. A full write-up is in `ARISTOTLE_SUMMARY.md`.

What was proved (with the tactic each uses):

- T1 `charpoly_factorization` (kernel, `ring`, over any `CommRing`): the product of the displayed spectral factors `(λ+1)²(λ−1)⁴(25λ²+14λ+25)(5λ²−6λ+5)²(5λ²+6λ+5)²·p12(λ)` equals the explicit degree‑28 polynomial (leading coefficient 5¹¹ = 48828125). All coefficients were recomputed exactly, not copied.
- T2 `p12_palindromic_reduction` (kernel, `field_simp; ring`, over any `Field`, λ≠0): `p12 λ = λ⁶·(3125 w³ − 2300 w² − 6156 w − 1440)` with `w = λ² + λ⁻²` (exact cleared form).
- The explicit matrices are carried as Gaussian-integer rescalings (`Az=5·U1`, `Bz=25·U2`, `Kz=5·K2`, `Vz=25·V`) for exact checkability; physical ℂ matrices are scaled casts via `GaussianInt.toComplex`. `faithful : Bz·Kz = 5•Vz` (`native_decide`) machine-checks that the literal `Vz` is genuinely the determinant-minor lift `U2` composed with the kick `K2`. `U2_eq_minor` (kernel) and `V_eq_U2_K2` give the physical statements.
- T4 (kernel `decide`): six exact eigenvectors — four independent for eigenvalue +1 (`Vz.mulVec vpᵢ = 25•vpᵢ`, matching the (λ−1)⁴ factor) and two for −1 (`= −25•vmᵢ`, matching (λ+1)²).
- T3 (disclosed): the full symbolic 28×28 characteristic-polynomial determinant is infeasible (a sum over 28! permutations), so the matrix bridge is realized in its Cayley–Hamilton annihilation form. `Vz_annihilated` (`native_decide`) shows the degree‑28 T1 polynomial annihilates `Vz`; `V_annihilated` transports this across `GaussianInt.toComplex` to `P(V)=0` on the physical rational-complex matrix `V`. Because ±1 are semisimple here, the minimal polynomial is a proper divisor of the characteristic polynomial; the annihilation records exactly the T1 degree‑28 polynomial as an annihilator of `V`.

Axiom footprint: T1, T2, `U2_eq_minor`, and all six T4 theorems are kernel-only (`propext`/`Classical.choice`/`Quot.sound`); `faithful`, `Vz_annihilated` (and transitively `V_eq_U2_K2`, `V_annihilated`) additionally use the allowed `Lean.ofReduceBool` (native_decide).

Notes: the supplied provenance file `PlueckerQuarticInteraction.lean` imports upstream `PhysicsSM.*` modules absent from this fixture (already unbuildable at the initial commit); its contents are preserved verbatim inside a block comment so the project builds cleanly. A caveat documented in the summary: the `native_decide` steps (notably `Vz^28` over ℤ[i]) and the kernel `decide` checks are compute-heavy, so a cold build of the two modules takes on the order of tens of minutes (each step exact and correct; incremental rebuilds are fast).

# Aristotle summary — exact interacting two-particle spectrum (E lane fixture)

Namespace: `PhysicsSM.Draft.NullEdge.PairSpectrumFixture`.
Deliverable files (new):

- `context/PairSpectrumFixture.lean` — T1, T2, the explicit matrices, the
  faithfulness bridge, T4 pinned modes, and the integer form of T3.
- `context/PairSpectrumFixtureC.lean` — the ℂ (physical-matrix) form of T3,
  transported from the integer form across `GaussianInt.toComplex`.

All source files are free of `sorry`/`admit`; no `axiom` or `@[implemented_by]`
declarations were introduced.

## The objects (as formalized)

- One-particle walk `U1 = S · C` on `Fin 8` (`index = 2·site + coin`), coin
  `[[4/5, -3i/5],[-3i/5, 4/5]]` per site, moving shift
  (`coin 0 : site ↦ site+1`, `coin 1 : site ↦ site-1`, mod 4).
- Two-particle walk `U2` = the 28×28 determinant-minor (Plücker) lift of `U1`
  over the antisymmetric pair sector `{(i,j) : i<j}`.
- Kick `K2` = identity except the single 2×2 block coupling the occupation
  pairs `{0,1}` and `{2,3}`, given by the exact 3-4-5 rotation.
- Composed step `V = U2 · K2` (the rational-complex matrix).

Everything computational is carried on Gaussian-integer rescalings so that it is
exactly checkable: `Az = 5·U1`, `Bz = 25·U2`, `Kz = 5·K2`, `Vz = 25·V`, all over
`GaussianInt = ℤ[i]`. The physical ℂ matrices are recovered as scaled casts,
e.g. `V = (25⁻¹:ℂ) • Vz.map GaussianInt.toComplex`.

## Results and the tactic used for each

### T1 — characteristic-polynomial factorization (kernel, `ring`)
`charpoly_factorization` (over an arbitrary `CommRing`): the product of the
displayed spectral factors
`(λ+1)²(λ−1)⁴(25λ²+14λ+25)(5λ²−6λ+5)²(5λ²+6λ+5)²·p12(λ)`
equals the explicit degree-28 polynomial (leading coefficient `5^11 = 48828125`).
Every coefficient on the right-hand side was recomputed exactly; closed by `ring`
(kernel-only). `p12` is the degree-12 palindromic factor
`3125λ¹² − 2300λ¹⁰ + 3219λ⁸ − 6040λ⁶ + 3219λ⁴ − 2300λ² + 3125`.

### T2 — palindromic reduction of `p12` (kernel, `field_simp; ring`)
`p12_palindromic_reduction` (over an arbitrary `Field`, `lam ≠ 0`):
`p12 λ = λ⁶ · (3125 w³ − 2300 w² − 6156 w − 1440)` with `w = λ² + λ⁻²`.
This is the exact cleared-of-denominators form. Kernel-only.

### Faithfulness of the explicit matrix (`native_decide`)
`faithful : Bz · Kz = 5 • Vz`, where `Bz` is built by the determinant-minor
formula from `Az = Sp · C5` and `Kz` is the kick. This machine-checks that the
literal `Vz` really is the `U2·K2` construction (in the cleared integer scaling).
Uses `native_decide` (axiom `Lean.ofReduceBool`).

`V_eq_U2_K2 : V = U2 · K2` (matrix algebra from `faithful` + `Matrix.map_mul`)
and `U2_eq_minor` (each entry of `U2` is the 2×2 Plücker minor of `U1`) give the
physical ℂ statements. `U2_eq_minor` is kernel (`simp`/`ring`); `V_eq_U2_K2`
depends transitively on `faithful` (hence `Lean.ofReduceBool`).

### T4 — exact pinned modes (kernel `decide`)
Six explicit exact eigenvectors, each proven by kernel `decide`
(`set_option maxRecDepth 100000`), with no non-standard axioms beyond the
standard `propext`/`Classical.choice`/`Quot.sound`:
- `Vz_eigenvector_plus_0 … _3`: `Vz.mulVec vpᵢ = 25 • vpᵢ` (four independent
  witnesses; eigenvalue `25` for `Vz` ⇔ `+1` for `V`), matching the `(λ−1)⁴`
  factor of T1.
- `Vz_eigenvector_minus_0, _1`: `Vz.mulVec vmᵢ = −25 • vmᵢ` (two witnesses;
  eigenvalue `−25` for `Vz` ⇔ `−1` for `V`), matching the `(λ+1)²` factor.

### T3 — the matrix bridge (Cayley–Hamilton annihilation; `native_decide`)
**Disclosed status.** A full symbolic characteristic-polynomial *determinant* of
a 28×28 matrix (a Leibniz sum over `28!` permutations) is not feasible in-kernel
or by `native_decide`. T3 is therefore realized in its Cayley–Hamilton
*annihilation* form:
- `Vz_annihilated` (integer form): the degree-28 T1 polynomial, with the coin
  denominators cleared consistently against `Vz = 25·V`, annihilates `Vz`.
  Proven by `native_decide` (axiom `Lean.ofReduceBool`).
- `V_annihilated` (ℂ form): the explicit degree-28 T1 polynomial (integer
  coefficients, leading `5^11`) annihilates the physical matrix `V`: `P(V) = 0`.
  Proven by transporting `Vz_annihilated` through the ring homomorphism
  `GaussianInt.toComplex` (helpers `toC_bridge`, `map_pow_bridge`, `coef_map`)
  and cancelling the nonzero scalar `(25:ℂ)^28`; depends transitively on
  `Lean.ofReduceBool`.

The annihilation records exactly the degree-28 T1 polynomial as an annihilator of
`V`. Note that because the pinned eigenvalues `±1` are semisimple here (T4
exhibits full eigenspaces), the *minimal* polynomial is a proper divisor of the
characteristic polynomial; the full symbolic charpoly-as-determinant identity was
not attempted to completion (it is infeasible at this size), as anticipated.

## Physics framing (memo)

The low-degree factors of T1 are the free two-particle levels that survive; the
degree-12 factor `p12` carries the twelve interaction-shifted quasienergies,
which T2 reduces to the rational cubic `3125 w³ − 2300 w² − 6156 w − 1440` in
`w = λ² + λ⁻²`. Boundaries (unchanged from the request): single-kick spectra are
phase-independent; the phase-sensitive quantity is the two-kick interference; the
interaction is supplied, not derived; this is an `L = 4` fixture with no
thermodynamic claims.

## Verification notes

- No `sorry`/`admit`; no added `axiom`/`@[implemented_by]`.
- Kernel-only (`propext`, `Classical.choice`, `Quot.sound`): T1, T2,
  `U2_eq_minor`, and all six T4 eigenvector theorems.
- `native_decide` (adds the allowed `Lean.ofReduceBool`): `faithful`,
  `Vz_annihilated`; transitively `V_eq_U2_K2` and `V_annihilated`.
- Build-time caveat: the `native_decide` steps (especially `Vz_annihilated`,
  which evaluates `Vz^28` over `ℤ[i]`) and the kernel `decide` eigenvector checks
  are compute-heavy; a cold/fresh build of these two modules takes on the order of
  tens of minutes even though each step is exact and correct. Incremental rebuilds
  are fast once the artifacts are cached.

## Provenance file

`context/PlueckerQuarticInteraction.lean` was supplied only as a provenance
reference and imports upstream modules (`PhysicsSM.Draft.NullEdge.FiniteCARFockBasic`,
`PhysicsSM.Spinor.PluckerMass`) that are not part of this fixture, so it could not
elaborate here (it was already unbuildable at the initial commit). Its original
contents are preserved verbatim inside a block comment, with an explanatory header,
so the project builds cleanly.
