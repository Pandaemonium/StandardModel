# C161 — Overlap linearization and bad-sector inverse-propagator gap

PhysicsSM null-edge Gate C1 program. Job C161.

Companion Lean artifact: `RequestProject/C161.lean`
(namespace `PhysicsSM.NullEdge.C161`, builds clean, a x i o ms = `propext, Classical.choice, Quot.sound` only, no `s o r r y`).

Operator under study (from `ROUND_CONTEXT.md`):

```text
H_ne    = Γ_K (D_ne + W_branch - m0 R)
T_br    = sign(H_ne)
D_ov_ne = ρ (1 + Γ_K T_br)
```

---

## 1. Executive verdict

- **Deliverable met, with the contract you asked for.** The overlap operator's
  bad/physical-sector behaviour is governed by a single, fully-proved algebraic
  fact: for two Hermitian involutions `Γ = Γ_K` and `T = T_br = sign(H_ne)`,
  the product `Γ·T` is **unitary**, so `D_ov = ρ(1 + Γ·T)` has its spectrum on
  the circle of radius `ρ` centred at `ρ`. A sector is killed by an
  **inverse-propagator gap** (`‖D_ov v‖` bounded below) exactly when `Γ·T`
  avoids the eigenvalue `−1`. This is the GW/overlap picture, and it never needs
  a propagator-zero substitution.
- **Bad sector (positive shifted mass):** alignment `T v = Γ v` gives
  `D_ov v = 2ρ v` exactly (heavy doubler), and a margin `‖T v − Γ v‖ ≤ δ` gives
  the lower bound `‖D_ov v‖ ≥ ρ(2‖v‖ − δ)`. **Proved.**
- **Physical sector (negative shifted mass):** anti-alignment `T v = −Γ v` gives
  `D_ov v = 0` exactly (massless), and the Weyl-symbol behaviour is a **template
  theorem** valid *only* under an explicit linearization/anticommutation
  certificate (`WeylLinearizationData`). **Proved as a conditional.**
- **Separation honoured.** Nothing in the bad-gap theorem or the linearization
  template uses anomaly, index, determinant-line, or locality data. The
  certificate that selects which sectors are bad/physical (the C160 output) and
  the branch-line linearization certificate enter strictly as hypotheses.
- **No overclaim.** We do **not** claim continuum Weyl behaviour unconditionally,
  and we do **not** derive anomaly/index/determinant health from the bad gap.
- **Import-contract recommendation:** the standard overlap small-momentum
  expansion is the better route for the *content* of the linearization
  certificate; the Lean side should import it as a hypothesis bundle, not reprove
  it. See §6.

---

## 2. Proposed theorem statements

Let `E` be a finite-dimensional complex inner-product space (`CompleteSpace`).
`Γ`, `T : E →L[ℂ] E` are **Hermitian involutions** (`SignInvolution`:
`S* = S` and `S² = 1`). `T` models `sign(H_ne)`; `Γ` models `Γ_K`.

**Lemma (GW unitarity / norm preservation).** A Hermitian involution is
norm-preserving (`‖S v‖ = ‖v‖`) and satisfies `S (S v) = v`. Hence `Γ·T` is
unitary and `D_ov` has spectrum on the `ρ`-circle. *(Lean: `SignInvolution.norm_map`,
`SignInvolution.apply_apply`.)*

**T1 — Exact bad sector.** If `T v = Γ v` then `D_ov v = (2ρ) v`.
*(Lean: `overlapD_bad_exact`.)*

**T2 — Perturbative bad-sector inverse-propagator gap.** If `0 ≤ ρ` and
`‖T v − Γ v‖ ≤ δ` then
```
ρ (2‖v‖ − δ) ≤ ‖D_ov v‖.
```
For `δ < 2‖v‖` this is a genuine lower bound: bad-sector removal by inverse gap,
not by a propagator zero. *(Lean: `overlapD_bad_gap`.)*

**T3 — Uniform bad-sector gap.** Given a sector alignment certificate
`SectorAlignment Γ T Bad` (`∀ v, Bad v → T v = Γ v`) and `ρ > 0`,
`D_ov` satisfies `UniformBadSectorInverseGap (OverlapD ρ Γ T) Bad (2ρ)`, i.e.
`0 < 2ρ ∧ ∀ v ∈ Bad, 2ρ‖v‖ ≤ ‖D_ov v‖`. *(Lean:
`uniformBadSectorInverseGap_of_alignment`.)*

**T4 — Exact physical lightness.** If `T v = −Γ v` then `D_ov v = 0`.
*(Lean: `overlapD_phys_light_exact`.)*

**T5 — Overlap linearizes to a Weyl symbol (template).** Given a
`WeylLinearizationData Γ T Phys` providing a Weyl symbol operator `W`,
normalization `c`, remainder size `ε ≥ 0`, and the bound
`∀ v ∈ Phys, ‖Γ(T v) − (−v + c·W v)‖ ≤ ε‖v‖`, then for `0 ≤ ρ` and `v ∈ Phys`:
```
‖ D_ov v − (ρ c) · W v ‖ ≤ ρ ε ‖v‖.
```
This is the **only** sense in which continuum Weyl behaviour is asserted, and it
is asserted only under the explicit certificate. *(Lean:
`overlapLinearizesToWeylSymbol`.)*

---

## 3. Proof decomposition

1. **Algebraic kernel (proved, Mathlib-only).**
   - `D_ov v = ρ•(v + Γ(T v))` (`overlapD_apply`).
   - Hermitian involution ⇒ `Γ(Γ v) = v` (`apply_apply`) and `‖Γ w‖ = ‖w‖`
     (`norm_map`, via `⟨Γv,Γv⟩ = ⟨v,Γ*Γ v⟩ = ⟨v,v⟩`). These two facts are the
     whole GW skeleton.
2. **Bad sector.**
   - T1: substitute `T v = Γ v`, collapse `Γ(Γ v) = v`, get `2ρ v`.
   - T2: write `Γ(T v) = v + Γ(T v − Γ v)`, so `D_ov v = ρ•(2v + Γ(T v − Γ v))`;
     reverse triangle inequality + `‖Γ(·)‖ = ‖·‖` give the lower bound.
   - T3: quantify T1 over the certificate and read off the constant `2ρ`.
3. **Physical sector.**
   - T4: substitute `T v = −Γ v`, collapse to `ρ•(v − v) = 0`.
   - T5: with the certificate, `D_ov v − (ρc)·W v = ρ•(Γ(T v) − (−v + c·W v))`,
     so the norm is `ρ` times the certificate bound.
4. **What is *not* in any proof:** no spectral construction of `sign(H_ne)`
   (only its involution+selfadjointness is used), no index theorem, no
   determinant line, no locality/control input. The sector selection and the
   linearization are inputs.

---

## 4. Exact assumptions (kept separate from anomaly/index and locality)

Load-bearing for **this** package:

- `SignInvolution Γ` and `SignInvolution T` (`Γ_K` and `sign(H_ne)` are Hermitian
  involutions). For `T`, only the involution+selfadjoint properties of the matrix
  sign are used.
- `0 ≤ ρ` (resp. `0 < ρ` for a strict uniform gap).
- Bad sector: `SectorAlignment Γ T Bad` (or the pointwise margin `‖T v−Γ v‖ ≤ δ`).
  This is the C160 mass-window / sign-straddling certificate restricted to the
  positive shifted-mass sector.
- Physical sector: `WeylLinearizationData Γ T Phys` — the branch-line lift /
  continuum-expansion certificate (anti-alignment plus a linear Weyl term plus a
  controlled remainder).

Deliberately **excluded** (must remain separate certificates, never hidden here):

- Anomaly cancellation / index / `Odd_J(sign(H))` content.
- Determinant-line / ghost-rule health.
- Locality or controlled-nonlocality (path-shell / Neumann / resolvent) control.
- The spectral *derivation* that positive shifted mass ⇒ alignment and negative
  shifted mass ⇒ anti-alignment+linear term. That derivation is C160 +
  branch-line lift; here it is an interface.

---

## 5. Lean / API sketch (as implemented)

```text
namespace PhysicsSM.NullEdge.C161
  structure SignInvolution (S) : Prop                  -- S* = S, S² = 1
  theorem  SignInvolution.norm_map    : ‖S v‖ = ‖v‖
  theorem  SignInvolution.apply_apply : S (S v) = v

  noncomputable def OverlapD (ρ : ℝ) (Γ T) : E →L[ℂ] E := ρ • (1 + Γ * T)
  theorem overlapD_apply : OverlapD ρ Γ T v = ρ • (v + Γ (T v))

  -- Bad sector
  theorem overlapD_bad_exact : T v = Γ v → OverlapD ρ Γ T v = (2ρ) • v
  theorem overlapD_bad_gap   : 0 ≤ ρ → ‖T v − Γ v‖ ≤ δ →
                               ρ*(2‖v‖ − δ) ≤ ‖OverlapD ρ Γ T v‖
  def     SectorAlignment Γ T Bad : Prop := ∀ v, Bad v → T v = Γ v
  def     UniformBadSectorInverseGap D Bad g : Prop :=
            0 < g ∧ ∀ v, Bad v → g*‖v‖ ≤ ‖D v‖
  theorem uniformBadSectorInverseGap_of_alignment :
            0 < ρ → SectorAlignment Γ T Bad →
            UniformBadSectorInverseGap (OverlapD ρ Γ T) Bad (2ρ)

  -- Physical sector
  theorem overlapD_phys_light_exact : T v = −Γ v → OverlapD ρ Γ T v = 0
  structure WeylLinearizationData Γ T Phys                -- W, c, ε≥0, bound
  structure PhysicalWeylSector Γ T                        -- Phys + data
  theorem overlapLinearizesToWeylSymbol :
            0 ≤ ρ → Phys v →
            ‖OverlapD ρ Γ T v − (ρ*c) • W v‖ ≤ ρ*(ε*‖v‖)
end PhysicsSM.NullEdge.C161
```

The four names requested by the job map exactly to: `OverlapD`,
`UniformBadSectorInverseGap`, `PhysicalWeylSector`, `OverlapLinearizesToWeylSymbol`
(the last spelled `overlapLinearizesToWeylSymbol`, Lean lower-camelCase).

---

## 6. Import contract vs. reproving (overlap expansion)

The *algebraic* GW facts above are short and are proved here from scratch. The
*physical content* of `WeylLinearizationData` — that `sign(H_ne)` on the light
sector is `−Γ_K` plus a linear Weyl term with a controlled higher-order remainder
— is exactly the standard overlap small-momentum / branch-line expansion. We
recommend **importing** that as a certificate (instantiating
`WeylLinearizationData`) rather than reproving it:

- Contract in: a chosen reference kernel + branch-line lift supplies `W` (the
  normalized `D_ne` Weyl symbol), `c`, `ε`, and the bound for all `v ∈ Phys`.
- Contract out: `overlapLinearizesToWeylSymbol` then yields the Weyl behaviour of
  `D_ov` with an explicit error `ρ ε ‖v‖`.

This keeps the linearization claim conditional and auditable, matching the C159
reference-import philosophy and the constraint "do not claim continuum Weyl
behaviour without a separate branch-line lift or linearization hypothesis".

---

## 7. Sign-convention and normalization warnings

1. **`Γ_K` is the grading, not a phase.** Everything uses `Γ_K² = 1` and
   `Γ_K* = Γ_K`. If the project's `Γ_K` is anti-Hermitian or squares to `−1`
   (Krein/Hilbertization variants), replace `SignInvolution` accordingly; the
   `Γ·T` unitarity step changes.
2. **`sign(H_ne)` normalization.** `T_br = sign(H_ne)` must be the genuine matrix
   sign (`T² = 1`, `T* = T`) — i.e. `H_ne` has no kernel on the relevant sector.
   A zero mode of `H_ne` makes `sign` ill-defined; that is a *certificate
   precondition* (the mass window must straddle, not sit at, zero).
3. **Alignment vs. anti-alignment is the whole physics.** Bad sector = `T v = +Γ v`
   ⇒ heavy `2ρ`; physical sector = `T v = −Γ v` ⇒ light/zero. Flipping the sign
   convention of `Γ_K`, of `sign`, or of `m0 R` swaps doublers and physical modes.
   Pin the convention so that *positive* shifted mass lands on `+Γ` (heavy).
4. **`ρ` is a positive normalization.** All gaps scale with `ρ`. The bad gap is
   `2ρ`; the linearization normalization is `ρ c`. If the project uses
   `D_ov = (1 + Γ T)` (ρ absorbed) or `D_ov = (1/a)(...)`, rescale `ρ` and `c`
   consistently — the theorems take `ρ` explicitly to make this visible.
5. **Doubler mass is `2ρ`, not `2`.** The "heavy = 2" folklore assumes `ρ = 1`
   (lattice units). Track `ρ` so the inverse-propagator gap is not mis-stated.
6. **The remainder is *relative* (`ε‖v‖`).** `ε` in `WeylLinearizationData` is a
   relative bound; do not read it as an absolute mass. The linearization is only
   as good as `ε` is small on the physical sector.

---

## 8. Open blockers and recommended follow-up jobs

- **Blocker A (selection certificate).** Proving that positive/negative shifted
  masses actually yield `+Γ`/`−Γ(+ linear)` alignment requires the C160
  mass-window/sign-straddling spectral result for `H_ne = Γ_K(D_ne + W − m0 R)`.
  Follow-up: connect C160's `SectorSignatureStability` output to instantiate
  `SectorAlignment` and the anti-alignment part of `WeylLinearizationData`.
- **Blocker B (branch-line lift).** The `WeylLinearizationData` *bound* is an
  import (continuum/overlap expansion + C148 branch-line topology/lift). Follow-up
  job: produce a concrete `W, c, ε` for the null-edge reference kernel and
  discharge the bound, turning T5 from template to applied.
- **Blocker C (anomaly/index, determinant, locality).** Explicitly out of scope
  here. Route through C142/C146/C147/C153 (anomaly/index import), ghost-rule
  certificate, and C151/C156 (path-shell/Neumann locality). The present package
  is the clean interface those imports plug into via C159's
  `NullEdgeReferenceOverlapImport`.
- **Recommended next Lean file:** a `C161Apply` module instantiating `E` with the
  finite null-edge seed Hilbert space and feeding C160's certificate into
  `uniformBadSectorInverseGap_of_alignment`, leaving only Blocker B as a `s o r r y`.
