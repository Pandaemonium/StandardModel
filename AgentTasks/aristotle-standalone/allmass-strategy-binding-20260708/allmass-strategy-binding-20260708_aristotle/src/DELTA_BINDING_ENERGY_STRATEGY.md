# Strategy + formalization design: the Δ binding-energy finite invariant (T3b)

**Deliverable:** a plan to promote `Δ` (the §3↔§4 bridge binding defect) from a
numeric-oracle observation to a kernel-statable finite invariant with a proved
property — **plus a landed, kernel-clean block-level `Δ` identity**
(`src/DeltaBindingEnergy.lean`, Mathlib-only, no `sorry`, standard axioms only).

Companion to `DELTA_BINDING_ENERGY_FINDING.md`. All Lean references below are in
`src/DeltaBindingEnergy.lean`, namespace
`PhysicsSM.Draft.NullEdge.Carrier.DeltaBindingEnergy`.

---

## 0. TL;DR (the quick win)

The highest-value result — a kernel `Δ` identity — is landed:

> **`blockBindingDefect_eq_neg_kappa`:** for `0 ≤ κ ≤ λ`,  `Δ_block(λ,κ) = -κ`.

i.e. at the block level the binding defect is *exactly minus the closure
strength*. This reproduces the numeric `Δ = -t` in the kernel, and it is
- **negative** (`blockBindingDefect_nonpos`, and strict `blockBindingDefect_neg`
  for `κ > 0`): the sign of a binding energy, not additive constituent mass;
- **closure-controlled with unit slope** (`blockBindingDefect_closure_controlled`);
- **off-diagonal** (`closurePerturbation_offDiagonal`): the closure perturbation
  `B(λ,κ) - B(λ,0)` has zero diagonal, so the naive constituent estimate is `0`
  in every free basis direction while the true `Δ = -κ`.

The kill `Δ > 0` is impossible on the physical branch `κ ≥ 0`
(`blockBindingDefect_pos_imp_neg_kappa`).

---

## 1. Definition of `Δ` (precise, Lean-statable, with rationale)

### 1.1 The objects and types

The physical carrier is the two-edge `Cl(4)` escape carrier. Its compressed
`J`-positive sector mass form is a `6×6` Hermitian matrix `M6 = Pᴴ (H_A + H_C) P`
over `ℂ`. At the fixed point `(λ,κ) = (2,1)` it is **block diagonal**,
`M6 = B(λ,κ) ⊕ B(λ,-κ)` (`MassGapWitness.M6_topBlock_eq_B`,
`M6_botBlock_eq_B`, `M6_offBlock_eq_zero`), with the `3×3` Hermitian block

```
B(λ,κ) = !![λ, κ·I, 0; -κ·I, λ, 0; 0, 0, λ]     (I = Complex.I)
```

`λ` = aperture strength (the free/kinematic term), `κ` = closure strength (the
interaction that is turned on). Spectrum `{λ-κ, λ, λ+κ}`; least eigenvalue `λ-κ`.

### 1.2 The ground mass and the baseline

The **squared ground mass** of a sector block is its least eigenvalue. In Lean we
take the infimum of the (finite) eigenvalue set of the Hermitian block:

```lean
noncomputable def blockGroundMass (lam kappa : ℝ) : ℝ :=
  sInf (Set.range (B_isHermitian lam kappa).eigenvalues)
```

On the physical branch this evaluates cleanly (`blockGroundMass_eq`):
`blockGroundMass λ κ = λ - κ` for `0 ≤ κ ≤ λ`, via `B_least_eigenvalue` and
`IsLeast.csInf_eq`.

The **free/kinematic baseline** is closure off, `κ = 0`: `B(λ,0) = λ•1`, so
`blockGroundMass λ 0 = λ` (`blockGroundMass_free`). This baseline is *exactly*
`det P`, the kinematic Plücker mass, by the proved free bridge `0b(a)`
(`FreeMassBridge.free_mass_operator_eq_plucker`: the free operator mass is
`det P • 1`). So subtracting the free baseline is the faithful block analog of the
finding's `Δ := min spec − det P`.

### 1.3 The invariant

```lean
noncomputable def blockBindingDefect (lam kappa : ℝ) : ℝ :=
  blockGroundMass lam kappa - blockGroundMass lam 0
```

**Why this form (rationale).**
- **Matches what the probe measured.** `probe_bridge_binding_energy.py` computes
  `Delta(t) = min spec(t) - free_mass2`, i.e. interacting ground mass minus the
  *free* ground mass — not against an independently-supplied `det P`. Our
  definition mirrors the probe exactly, so the kernel statement is faithful to the
  actual finding rather than to an idealization.
- **`det P` enters through `0b(a)`.** In the free case `min spec(free) = det P`
  (proved). So `blockGroundMass λ 0` *is* the block-level `det P`; the two
  readings of `Δ` (`min spec − det P` and `min spec − min spec(free)`) coincide
  wherever the free bridge holds, which is exactly where "the operator mass IS the
  kinematic mass" is a theorem. Using the free ground mass keeps `Δ` well-defined
  even on carriers where an independent `det P` is not yet available (the
  honest-scope caveat in the finding).
- **Real-valued, kernel-computable.** `blockGroundMass` is a plain `ℝ`, so `Δ` is
  a real number and every downstream claim is a decidable-shape inequality/identity
  over `ℝ`, ideal for `linarith`/`ring`.

### 1.4 Definition for a general finite carrier (the intended `Δ(H,P)`)

For an arbitrary finite interacting carrier with self-adjoint sector mass form
`Hᴬᶜ` and sector isometry `P` (columns an orthonormal basis of the `J`-positive
sector), and free part `Hᴬ` (closure off):

```
Δ(H, P) := λ_min(Pᴴ Hᴬᶜ P)  −  λ_min(Pᴴ Hᴬ P)
```

with `λ_min` the least eigenvalue (Mathlib: `Matrix.IsHermitian.eigenvalues`
+ `IsLeast (Set.range …)`, or `sInf (Set.range …)`). The block definition above is
this with `Pᴴ Hᴬᶜ P = B(λ,κ) ⊕ B(λ,-κ)` and `Pᴴ Hᴬ P = B(λ,0) ⊕ B(λ,0)`. The
block `Δ` equals the sector `Δ` because the least eigenvalue of a Hermitian direct
sum is the min of the block least eigenvalues, and both blocks give `λ - |κ|`.

---

## 2. The theorem to prove (sharpest true finite claim)

### 2.1 Landed (kernel, Mathlib-only, no `sorry`)

| Lemma | Statement | Status |
|---|---|---|
| `blockBindingDefect_eq_neg_kappa` | `0≤κ≤λ ⇒ Δ_block(λ,κ) = -κ` | ✅ proved |
| `blockBindingDefect_nonpos` | `0≤κ≤λ ⇒ Δ ≤ 0` | ✅ proved |
| `blockBindingDefect_neg` | `0<κ≤λ ⇒ Δ < 0` | ✅ proved |
| `blockBindingDefect_closure_controlled` | `Δ(λ,κ₂)-Δ(λ,κ₁) = -(κ₂-κ₁)` | ✅ proved |
| `closurePerturbation_offDiagonal` | `(B(λ,κ)-B(λ,0)) i i = 0` | ✅ proved |
| `blockGroundMass_massless_line` | `0≤κ≤λ ⇒ (ground mass = 0 ↔ κ = λ)` | ✅ proved |
| `blockBindingDefect_pos_imp_neg_kappa` | `κ≤λ, Δ>0 ⇒ κ<0` | ✅ proved |
| `blockGroundMass_eq`, `blockGroundMass_free` | ground-mass evaluations | ✅ proved |
| `B_isHermitian`, `B_det`, `B_shift_posSemidef`, `B_shift_det`, `B_least_eigenvalue` | reproduced `B`-spectral theory | ✅ proved |

**The recommended headline theorem** is `blockBindingDefect_eq_neg_kappa`
(`Δ_block = -κ`): it is the sharpest true statement — an exact *identity*, not a
mere inequality — and every physical reading (binding sign, closure control,
critical line) is a one-line corollary of it.

### 2.2 What "det P at the block level" is (as requested)

`det B(λ,κ) = λ(λ² - κ²)` (`B_det`) — a cubic, **not** the mass. So `Δ` is *not*
`min spec − det B`: the full determinant is the product of all three eigenvalues,
not the ground mass. The correct block-level `det P` is the *free* least
eigenvalue `λ = blockGroundMass λ 0` (which the free bridge identifies with the
kinematic `det P`). With that identification the `Δ = -κ` identity holds and is
provable — this is the resolution of the "work out what det P even is at the block
level" question: **`det P` ↔ the free ground mass `λ`, and then `Δ = (λ-κ) - λ =
-κ`.**

---

## 3. Proof (delivered) and strategy for the general carrier

### 3.1 Block level — delivered

`Δ = -κ` reduces to `blockGroundMass λ κ = λ-κ` and `blockGroundMass λ 0 = λ`, both
immediate from `B_least_eigenvalue` (least eigenvalue `= λ-κ`) via
`IsLeast.csInf_eq`. `B_least_eigenvalue` itself is the one nontrivial input, and it
is reproduced verbatim from the kernel-checked `MassGapWitness.lean`
(shift-positivity `B_shift_posSemidef` + singularity `B_shift_det` ⇒ least
eigenvalue). Total new proof burden: a handful of `rw`/`ring`/`linarith` lines.

### 3.2 Lifting to the full sector `M6` (ranked plan)

1. **`Δ_sector = Δ_block` (cheap).** `M6 = B(λ,κ) ⊕ B(λ,-κ)` at `(2,1)` is already
   kernel-proved (`M6_*_eq_B`). Need: least eigenvalue of a Hermitian block-diagonal
   is the min of the blocks'. Mathlib API: `Matrix.fromBlocks`, eigenvalues of a
   direct sum. Both blocks give `λ-|κ|`, so `λ_min(M6) = λ-κ` for `κ≥0` and
   `Δ_sector = -κ`. Obstruction: mild — assembling the direct-sum spectrum lemma.
2. **General `(λ,κ)` reduction of the carrier to `B(λ,κ)⊕B(λ,-κ)` (hard, oracle
   now).** `carrier_spectrum_sim.py` shows the compression has this shape for all
   `(λ,κ)`; proving it in the kernel needs the explicit sector isometry `P` at
   general coupling (the enriched-carrier follow-up in the finding). This is the
   main remaining obstruction and is out of scope for T3b.
3. **Two-sided ground mass `λ - |κ|` (medium).** Generalize `B_least_eigenvalue` to
   all real `κ` with `|κ|≤λ` (the quadratic form is bounded below by
   `(λ-|κ|)‖x‖²`; `B_shift_det` gives singularity since `|κ|²=κ²`). This closes the
   `κ<0` (anti-binding) branch and upgrades `blockBindingDefect_pos_imp_neg_kappa`
   to a full `Δ>0 ↔ κ<0` iff. Independent of the carrier reduction.

---

## 4. No-go / kill analysis and the biggest risk

### 4.1 Is the kill well-posed?

Yes. The pre-registered kill is "a carrier with `Δ > 0`, or `Δ` uncorrelated with
closure." Both halves are decidable statements about the finite invariant `Δ`:
- `Δ > 0` is a real inequality on `blockBindingDefect`.
- "uncorrelated with closure" is sharpened here to the *slope* of `Δ` in `κ`:
  `blockBindingDefect_closure_controlled` proves the slope is exactly `-1`, so `Δ`
  is maximally (linearly, unit-slope) correlated with closure. A kill would need a
  carrier where this slope is `0` or positive.

### 4.2 Can `Δ` be positive for a physical carrier?

On the physical branch `κ ≥ 0`: **no.** `blockBindingDefect_pos_imp_neg_kappa`
shows `Δ > 0 ⇒ κ < 0`. Positivity of `Δ` requires `κ < 0` — a closure coupling of
the *opposite* sign (anti-binding). So within the model the binding-energy reading
is safe exactly on the physical branch, and the honest boundary is the sign of the
closure coupling.

### 4.3 The single biggest risk

**The block reduction, not the sign.** The `Δ = -κ` identity is airtight *given*
that the sector form is `B(λ,κ)⊕B(λ,-κ)`, which is kernel-proved only at the fixed
point `(2,1)`. The interpretation "`Δ` is THE binding energy of a physical bound
state" rests on the general-`(λ,κ)` carrier reduction (item 3.2.2), which is
currently oracle-grade. If, at general coupling, the true compression is *not*
`B(λ,κ)⊕B(λ,-κ)` — e.g. the off-diagonal blocks fail to vanish, or `κ` acquires a
diagonal (aperture-renormalizing) part — then `Δ` could pick up a term that is not
purely `-κ`, and the clean "binding = closure strength" reading would need
revision. Mitigation: the enriched-carrier follow-up that produces the explicit
sector isometry `P` at general coupling and re-checks `M6_offBlock_eq_zero` off the
fixed point. Until then, the kernel claim is precisely scoped: *`Δ = -κ` for the
block model `B(λ,κ)`*, which is the carrier's exact sector form at `(2,1)`.

---

## 5. Build / provenance

`src/DeltaBindingEnergy.lean` imports only `Mathlib` and is self-contained: the
`B`-spectral lemmas are reproduced from the kernel-checked `MassGapWitness.lean`
(the original additionally imports the external carrier module
`SectorGroundMassWitness`, which is not part of this handoff; eliding it lets the
`Δ` layer build standalone). `blockBindingDefect_eq_neg_kappa` depends only on
`propext, Classical.choice, Quot.sound`.
