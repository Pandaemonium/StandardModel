# Assembly witness: satisfiability argument (the "true but unwitnessed" concern)

## 2026-07-07 correction: superseded for the physical Krein reading

This note's original Pauli model is **superseded for the physical
Krein/Pontryagin reading** by the M4 witness harvest:

- Aristotle project `578f32e6-efb8-4cab-abd8-325b02034685`, task
  `873b2c8c-4c49-4c77-a50d-ab2e2074e848`.
- Tracked handoff:
  `AgentTasks/twoday-carrier-run-2026-07-07/M4_PAULI_PONTRYAGIN_WITNESS_HANDOFF_2026-07-07.md`.

The old model is internally consistent as an ordinary conjugate-transpose matrix
exercise, but that is the vacuous `kappa = 0` Hilbert-star reading. Fable call
03 requires the non-vacuous Pontryagin model with `J = Gamma`,
`kreinSharp J X = J * X^H * J`, inertia `(2,2)`, and `kappa = 2`.

Corrected data:

- `gamma0 = i * (sigma_x tensor I)`, `gamma1 = i * (sigma_y tensor I)`;
- `g e e = -2`, off-diagonal `0`;
- `phi = c * I` with `c : R` and `c != 0`;
- `Q_A = -8 * I`, `Q_C = +8 * (sigma_z tensor sigma_z)`,
  `Q_T = c^2 * I`.

The simultaneous nonzeroness claim survives, but the sign/star convention in the
original note must not be used for the Krein/Pontryagin carrier claim.

---

Both reviewers (Fable call-02 audit item 3; the grand-strategy review) flagged that the
Move-1 hypotheses (`hcl`, `hcomm`, the `Γ`/`φ` relations) are stated across bricks that
live in different algebras, so `carrier_square_assembly` is "true but unwitnessed" until a
single object instantiates them all with `Q_A/Q_C/Q_T` simultaneously nonzero.

**This note discharges that concern MATHEMATICALLY** with a verified explicit model. The
**kernel formalization is a pending target** (`CarrierGlueWitness.lean`): Aristotle stalls
on it (a witness = model + 8 hypothesis proofs + 3 nonzero-slot evaluations is a
construction job, not a proof job, and construction jobs have repeatedly stalled at 4-6%),
so it needs a hand-built Kronecker-API approach, tracked as OPEN. The mathematics below is
complete and hand-checked; only the Lean transcription is outstanding.

## The model (verified by hand)

`R := ℂ`, `E := Fin 2` (two edges), `B := M₄(ℂ) = End(ℂ² ⊗ ℂ²)` = spinor factor `S`
tensor transport factor `T`. Pauli matrices `σx, σy, σz` (pairwise anticommuting,
`σ² = I`). Kronecker products `A ⊗ B` (which satisfy `(A⊗B)(C⊗D) = (AC)⊗(BD)`).

| datum | value | acts on |
|---|---|---|
| `γ₀` | `σx ⊗ I` | S |
| `γ₁` | `σy ⊗ I` | S |
| `Γ`  | `σz ⊗ I` | S |
| `∇₀` | `I ⊗ σx` | T |
| `∇₁` | `I ⊗ σy` | T |
| `φ`  | `c·(I⊗I)`, `c ≠ 0` | scalar |
| `g e f` | `2` if `e=f` else `0` | — |

## Every hypothesis holds

- **`hcl`** `{γₑ,γ_f} = g(e,f)`: `{σx,σy}=0` so `{γ₀,γ₁}=0=g(0,1)`; `σx²=σy²=I` so
  `{γₑ,γₑ}=2I=g(e,e)·1`. ✓
- **`hcomm`** `γₑ∇_f = ∇_f γₑ`: `(σₑ⊗I)(I⊗σ_f) = σₑ⊗σ_f = (I⊗σ_f)(σₑ⊗I)`. **The whole
  point of tensor-factor separation** — operators on different Kronecker factors commute
  literally. ✓
- **`hGammaSq`** `Γ²=1`: `σz²⊗I = I`. ✓
- **`hGammaAnti`** `Γγₑ = −γₑΓ`: `σzσx=−σxσz`, `σzσy=−σyσz`, tensored with `I`. ✓
- **`hGammaNabla`** `[Γ,∇ₑ]=0`: `Γ` on `S`, `∇ₑ` on `T` — different factors. ✓
- **`hPhiGamma`, `hPhiComm`, `hCov`**: `φ = c·1` is central — commutes with everything. ✓
  (In particular `φ` is covariantly constant trivially.)

## All three slots are simultaneously nonzero

- **`Q_C ≠ 0`**: `[γ₀,γ₁] = [σx,σy]⊗I = 2iσz⊗I ≠ 0` and `[∇₀,∇₁] = I⊗[σx,σy] = I⊗2iσz ≠ 0`,
  so `Q_C = Σ [γₑ,γ_f][∇ₑ,∇_f]` contains `[γ₀,γ₁][∇₀,∇₁] + [γ₁,γ₀][∇₁,∇₀] = 2·(2iσz⊗I)(I⊗2iσz)
  = −8·(σz⊗σz) ≠ 0`. **This needs a genuinely non-flat model** — the Pauli `∇`s do not commute.
- **`Q_A ≠ 0`**: diagonal `g(e,e)=2`, `{∇ₑ,∇ₑ}=2∇ₑ²=2·(I⊗σₑ²)=2·1`, so
  `Q_A = Σ g(e,f)·{∇ₑ,∇_f}` has diagonal `2·2·1 = 4·1` per edge = `8·1 ≠ 0`.
- **`Q_T ≠ 0`**: `Q_T = φ² = c²·1 ≠ 0` for `c ≠ 0`.

## Conclusion

`carrier_square_assembly` is **non-vacuous**: it has an explicit finite model in `M₄(ℂ)`
where all hypotheses hold and all three mass slots are simultaneously active. The
"unwitnessed" risk is discharged at the level of mathematics. Status of the kernel witness:
**OPEN (formalization pending)** — a hand-built `CarrierGlueWitness.lean` using the
Kronecker-product ring API (`Matrix.kroneckerMap`, `Matrix.mul_kronecker_mul`) rather than
16-entry `!![…]` computations; Aristotle construction jobs stall on it. Honestly labeled as
a pending formalization, not a completed kernel result.
