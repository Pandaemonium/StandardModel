# Adversarial over-claim audit — the all-mass landed flagships

**Scope of what I did.** I read all four `src/` files line-by-line, together with
every docstring, and checked each *statement* (not just that it kernel-checks)
against the four over-claim modes: vacuity, hollow telescoping, docstring-outruns-
kernel, false shape. The external `PhysicsSM.*` modules the files import
(`Spinor.PluckerMass`, `Carrier.FiniteUnitaryEvolution`) are **not vendored in
this repo**, so I audited the source-as-landed and the *local* proofs; I did not
re-run a fresh kernel build (I cannot, the deps are absent) and I take the
`#print axioms` guards / "kernel-clean" pins at face value. Claims that rest on
the absent imports (`two_edge_plucker_mass_identity`, `FiniteUnitaryEvolution.*`)
are flagged as trusted-not-re-verified.

The kernel content is, throughout, **true and (with two exceptions noted) non-
vacuous**. The over-claims that exist are all in *docstrings / theorem framing*,
never in a false or vacuous kernel statement. Two of them are load-bearing.

---

## Per-theorem table

Verdict key: CLEAN = statement == intended reading; MINOR = honest kernel fact,
over-narrated name/docstring but self-disclosed or harmless; LOAD-BEARING = the
name/docstring makes a physical claim the kernel statement does not support.

### `FreeMassBridge.lean`

| Theorem | Intended reading | Verdict | Mismatch |
|---|---|---|---|
| `massOp_eq_det_smul` | for any 2×2 `P`, `P·adj P = det P•1` | CLEAN | literally `Matrix.mul_adjugate`; docstring says so. |
| `free_mass_operator_eq_plucker` | two-edge free mass operator `= |ψ∧φ|²•1` | MINOR | The 2×2 "mass operator is a scalar" is **automatic** (`mul_adjugate`); the only physical content — `det (twoEdgeMomentum) = |ψ∧φ|²` — is the *imported* `two_edge_plucker_mass_identity`, not re-verified here. Honestly attributed in the docstring, so MINOR, but "the operator mass IS the kinematic mass" is carried entirely by an unseen import. |
| `free_mass_operator_single_eq_zero` | a single null edge (rank-one) has zero free mass operator | CLEAN | rests on imported `det_rankOneHermitian_eq_zero`; honest. |

### `MassGapWitness.lean`

| Theorem | Intended reading | Verdict | Mismatch |
|---|---|---|---|
| `B` (def) | 3×3 Hermitian block, aperture `λ`, closure `κ` | CLEAN | — |
| `B_isHermitian` | `Bᴴ = B` | CLEAN | — |
| `B_det` | `det B = λ(λ²−κ²)` | CLEAN | — |
| `B_massless_iff` | `det=0 ↔ λ=0 ∨ κ=±λ` | CLEAN | *exemplary*: the docstring flags that the naive `det=0 ↔ κ=±λ` is **false at λ=0** and corrects it. |
| `B_massless_iff_of_pos` | `λ>0 ⇒ (det=0 ↔ κ=±λ)` | CLEAN | — |
| `B_posDef_iff` | `PosDef ↔ |κ|<λ` | CLEAN | genuine two-sided quadratic-form argument. |
| `B_posDef_iff_of_nonneg` | `0≤κ ⇒ (PosDef ↔ κ<λ)` | CLEAN | — |
| `B_shift_posSemidef`, `B_shift_det` | `B−(λ−κ)1` is PSD and singular | CLEAN | — |
| `B_least_eigenvalue` | least eigenvalue `= λ−κ` for `0≤κ≤λ` | CLEAN | docstring honestly notes `hlk` is unnecessary (kept because requested). |
| `M6_topBlock_eq_B` | top 3×3 block of `M6` `= B(2,1)` | CLEAN | genuine tie to the actual compression. |
| `M6_botBlock_eq_B` | bottom block `= B(2,−1)` | CLEAN | — |
| `M6_offBlock_eq_zero` | off-blocks vanish (`M6` block-diagonal) | CLEAN | — |
| *(file docstring)* | "The carrier sector mass gap is aperture minus closure … generalizes T2 to the whole coupling plane" | MINOR | The **whole-plane** result is spectral theory of the *abstract* block `B(λ,κ)`; the *carrier* tie is kernel-checked **only at (2,1)** (`M6_*Block_eq_B`) and the general-`(λ,κ)` carrier reduction is explicitly quarantined as oracle-grade. The "Scope of the carrier tie" paragraph is admirably honest, so this is MINOR, not load-bearing. The title alone slightly over-reaches. |

### `SectorGroundMassWitness.lean`

| Theorem | Intended reading | Verdict | Mismatch |
|---|---|---|---|
| `sector_ground_mass` | symmetric `T` with form `≥c>0` ⇒ least Rayleigh quotient is a positive eigenvalue | CLEAN | keystone, provided; genuine, non-vacuous (`Nontrivial H`). |
| `sectorCompression` (+ `_isSymmetric`, `_reApplyInnerSelf`, `_sector_ground_mass`) | compression of `S` to a submodule is symmetric and Rayleigh-agreeing | CLEAN | generic Mathlib-level (T1); honestly labelled "clean Mathlib". |
| `toEuclideanCLM_isSymmetric_of_isHermitian` | Hermitian ⇒ Euclidean-symmetric | CLEAN | — |
| `reApplyInnerSelf_ge_of_sub_posSemidef` | `M−c1` PSD ⇒ form `≥ c‖x‖²` | CLEAN | — |
| `HAC`, `Jmet`, `Piso`, `M6`, `Bwit` (defs) | the assembled Krein form, metric, isometry, sector form, Gram witness | see LOAD-BEARING #2 | **hand-typed literal matrices**; their Clifford provenance is asserted only in docstrings. |
| `Jmet_isHermitian`, `Jmet_sq`, `Jmet_mul_Piso` | `J`=Jᴴ, `J²=1`, `J·Piso=Piso` | CLEAN | genuinely certify `Piso`'s columns are `+1` eigenvectors of the (hand-typed) `Jmet`. |
| `HAC_isHermitian` | `HACᴴ=HAC` | CLEAN | of the hand-typed matrix. |
| `Piso_isometry` | `PisoᴴPiso=1` | CLEAN | coordinate selection; genuine isometry (not secretly trivial). |
| `compression_eq` | `Pisoᴴ HAC Piso = M6` | CLEAN | ties `M6` to `HAC` — this is what makes `M6_posDef` *not* a built-in `1+BᴴB` triviality. |
| `M6_eq_one_add_gram` | `M6 = 1 + Bwitᴴ Bwit` | CLEAN | — |
| `M6_posDef` | `M6` positive-definite | CLEAN | genuine PosDef on a nonzero 6-space; positivity is a *proved property of the compressed form* (via `compression_eq`), not an assumption baked into a `1+BᴴB` shape. |
| `M6_sub_one_posSemidef` | `M6−1` PSD (`c=1` bound) | CLEAN | — |
| `T2_positive_mass` | least eigenvalue of the compressed `D#D`-form is a genuine positive squared mass | CLEAN **as a matrix statement**; LOAD-BEARING #2 in its "Cl(4) carrier" framing | Kernel proves: a hand-typed Hermitian `M6` (least eigenvalue 1) gives a positive least Rayleigh quotient via `sector_ground_mass`. Non-vacuous. The over-claim is only that this is "the two-edge **Cl(4) carrier**". |
| `gauge_covariance` | conjugation by an isometry `u` is a `*`-endomorphism preserving products/sums/Hermiticity/expectations | MINOR | Pure generic linear algebra: **no** block, `D#D`, Clifford, chirality, or turn-field appears in the statement — only `u,A,B`. "Gauge covariance of the four blocks" is over-narration of `(uAuᴴ)(uBuᴴ)=u(AB)uᴴ` etc. Honest and true, but the physics is entirely in the name. |

### `CarrierUnitaryFlow.lean`

| Theorem | Intended reading | Verdict | Mismatch |
|---|---|---|---|
| `skewHermitian_neg_I_smul` | `A=−itH` is skew-Hermitian | CLEAN | — |
| `hermitian_flow_mem_unitaryGroup` | `exp(−itH)` unitary for Hermitian `H` | CLEAN | genuine core fact (`exp(Aᴴ)=exp(−A)`), fully general. |
| `hermitian_flow_isometry` | induced map on `EuclideanSpace ℂ n` is a `LinearIsometryEquiv` | CLEAN | genuine; not secretly trivial. |
| `B_flow_unitary` | `exp(−it·B(λ,κ))` unitary | CLEAN as a matrix fact | see LOAD-BEARING #1. |
| `carrierFlowStep` (def) | the carrier's time step as a sector isometry | LOAD-BEARING #1 | it is `exp(−it·B(λ,κ))` on `EuclideanSpace ℂ (Fin 3)`. |
| `carrier_orbit_norm_conserved` | "D2 fired on the actual carrier — norm conserved along the real carrier orbit" | LOAD-BEARING #1 | see below. |
| `carrier_orbit_energy_conserved` | ditto for energy | LOAD-BEARING #1 | hypothesis `CommutesWithStep` is satisfiable (`E=id`), so not vacuous; the over-claim is the "actual carrier" framing. |

---

## The single most load-bearing over-claim

**`CarrierUnitaryFlow.lean` — "D2 fires on the *actual carrier*; conservation of
norm and energy along the *real carrier orbit* is kernel-checked" (Krein↔Euclidean
false shape).**

What the kernel actually proves (`carrier_orbit_norm_conserved`,
`carrier_orbit_energy_conserved`, via `carrierFlowStep`): for the **positive-
definite** Hilbert space `EuclideanSpace ℂ (Fin 3)`, the map `exp(−it·B(λ,κ))` is
**Euclidean-unitary**, hence conserves the **Euclidean** norm. The *only* carrier-
specific input is `MassGapWitness.B_isHermitian` — literally "B is Hermitian".
Everything else is the generic chain `skew-Hermitian ⇒ exp is unitary ⇒ isometry
⇒ orbit conserves norm`, which fires for *any* Hermitian matrix.

Why the "actual carrier / real carrier orbit" framing is not earned — three
independent mismatches, each fatal on its own:

1. **Wrong inner product (Krein vs Euclidean).** The carrier lives in a *Krein*
   (indefinite `J`) space; physical evolution is `J`-unitary, generated by a
   `J`-self-adjoint operator, and generically **mixes the `J=±1` sectors** (so it
   does not restrict to the `J`-positive sector as an invariant Euclidean
   subspace). The theorem proves Euclidean-unitarity, which coincides with
   `J`-unitarity *only after* restricting to the `J`-positive sector — a
   restriction this file never performs and never justifies.
2. **Wrong space / wrong object (block vs sector).** The `J`-positive sector of
   the carrier is the **6-dimensional** `M6 = B(2,1) ⊕ B(2,−1)`
   (`EuclideanSpace ℂ (Fin 6)`). The flow here is generated by a **single 3×3
   half-block** `B(λ,κ)` on `EuclideanSpace ℂ (Fin 3)`, at **arbitrary** `(λ,κ)`
   — precisely the couplings where MassGapWitness's own disclaimer says the
   carrier tie is oracle-grade, not kernel. There is no theorem about
   `exp(−it·M6)`.
3. **Mass form used as a Hamiltonian.** `B`/`M6` is the compressed `D#D`
   *mass-squared* form, not shown anywhere to be the generator of the carrier's
   transport / time translation. `exp(−it·(mass form))` being unitary is true of
   *any* Hermitian matrix and says nothing about the carrier's dynamics (D2).

So the phrase "D2 fires on the *actual carrier*, not merely a generic isometry"
inverts the situation: it is norm-unitarity on a first-quantized **Euclidean**
3-space for a mass half-block — exactly a generic isometry with `H` chosen to be
Hermitian — and is *quietly not the Krein evolution*.

**Exact remedy.** Regrade the docstrings/names (statement change not required):
- Rename the physical claims to what is proved, e.g.
  `euclidean_flow_of_massBlock_unitary` / `..._norm_conserved`, and state
  "`exp(−itH)` is Euclidean-unitary for any Hermitian `H`, instantiated at the
  mass block `B`". Drop "D2 fires on the actual carrier / real carrier orbit /
  the open §9a link now a single kernel theorem".
- To genuinely earn the carrier claim, add: (i) the flow on the **actual**
  `Fin 6` sector `exp(−it·M6)` (or a `J`-unitary flow on `Fin 12`), (ii) a lemma
  that the carrier's Krein evolution **preserves the `J`-positive sector** (so
  Euclidean = Krein there), and (iii) an identification of the *generator* of
  D2/transport with `M6` (not merely "it is Hermitian"). Absent (i)–(iii), the
  file establishes a true but generic linear-algebra fact, not a property of the
  carrier's evolution.

## Strongest secondary finding (LOAD-BEARING #2)

**`SectorGroundMassWitness.lean` — "explicit two-edge **Cl(4)** carrier whose
`J`-positive sector form `M6`" (docstring-outruns-kernel / unverified provenance).**

The flagship `T2_positive_mass` is billed as *the critical-path linchpin*
("positive squared mass IN A CONCRETE MODEL"). But `HAC`, `Jmet`, `Piso`, `M6`,
`Bwit` are **hand-typed literal matrices**. The entire Clifford derivation that
makes them "the carrier" — gammas `g1..g4` as Pauli-Kronecker products, `omega`,
`Js`, `J = Js⊗I₃`, `Q_A = I₄⊗(λI₃)`, `Q_C = omega⊗K`, and the assembly
`HAC = J(Q_A+Q_C)` — exists **only in the docstrings** (confirmed: no
`kronecker`/`tensorProduct`/`Q_A`/`Q_C`/`Js` token occurs in any kernel
declaration). What *is* kernel-checked is entirely internal to the hand-typed
matrices: `HAC_isHermitian`, `Piso_isometry`, `Jmet_sq`, `Jmet_mul_Piso`,
`compression_eq : Pisoᴴ HAC Piso = M6`, `M6_posDef`. So the positivity is an
honest *proved property of the compressed form* (good — this answers the
"positivity built in by `1+BᴴB`?" probe: `compression_eq` ties `M6` to `HAC`,
so it is not a built-in triviality). The gap is upstream: **nothing certifies
that `HAC` (and `Jmet`) equal the Clifford assembly**, i.e. that this matrix is
the two-edge Cl(4) carrier's Krein form at all. A reader citing "T2 proves a
Cl(4) carrier has positive mass" is trusting a hand-transcription of a gamma-
matrix computation (numerically validated by an oracle, per the docstring).

**Exact remedy (new lemmas needed).** Define the Pauli matrices and `Cl(4)`
gammas as Kronecker products, define `omega, Js, K, Q_A, Q_C`, `J := Js ⊗ I₃`,
and prove in-kernel `Jmet = Js ⊗ I₃` and `HAC = Jmet * (Q_A + Q_C)` (with `λ=2`).
Until then, regrade "explicit two-edge Cl(4) carrier" to "a hand-transcribed
12×12 Hermitian matrix asserted (numerically) to be the Cl(4) carrier's Krein
form", so the docstring stops out-running the kernel.

## Vacuity / triviality spot-checks (all pass)

- `T2_positive_mass`: `EuclideanSpace ℂ (Fin 6)` is `Nontrivial`; `M6−1` is PSD
  with `c=1>0`; `M6` is genuinely PosDef (eigenvalues `{1,2,3}` per block). Not
  vacuous; not a PosDef on a zero space.
- `Piso_isometry`: `Piso` selects 6 distinct coordinates — a genuine isometry,
  not the zero/trivial map.
- `gauge_covariance` (`uᴴu=1`), `carrier_orbit_energy_conserved`
  (`CommutesWithStep`): hypotheses satisfiable (`u=1`, `E=id`); not vacuous.
- `B_massless_iff`: the `λ=0` disjunct is real and correctly included.
