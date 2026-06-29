# Gate C1 — First Physical Reference: Wilson/Neuberger Overlap with CKM Texture

This document specifies the concrete operator architecture for the first *physical* Gate C1
reference (`GateC1_NU`), following the C179 recommendation: import a Wilson/Neuberger
**overlap** Dirac operator as the physical kernel and use **CKM as texture/table**, not as a
literal naive physical operator.

A machine-checked nucleus accompanies this note in
`RequestProject/GateC1Architecture.lean`: every claim below that is *derivable from the
overlap algebra* is proved there with no proof placeholders and only the standard kernel dependencies
(`propext`, `Classical.choice`, `Quot.sound`); the two genuinely-open certificates are
carried as explicit named hypotheses.

---

## 0. Verdict on the conceptual question

Wilson/Neuberger + CKM-texture is **conceptually correct** as the first physical reference,
**provided CKM enters as a flavor-factor texture (a unitary conjugation), not as an additive
naive Dirac operator.** The naive route (adding a CKM-shaped mass directly to the kernel) is
exactly the 8+8 product/parity trap and must be avoided. The architecture below makes the
distinction precise and proves that the texture cannot reintroduce the trap.

---

## 1. Explicit schematic operator formulas

Let `a` be the lattice spacing, `m0 ∈ (0, 2)` the overlap regulator (Wilson mass), `ρ` the
overall overlap scale, and `γ5` the chirality involution (`γ5² = 1`).

- **Wilson operator:** `D_W(-m0)` (standard nearest-neighbor Wilson Dirac operator with the
  Wilson term and subtracted mass `-m0/a`).

- **Wilson/Neuberger Hamiltonian:**
  ```
  H_ne = γ5 · D_W(-m0)          (Hermitian Wilson Hamiltonian)
  ```

- **Texture Hamiltonian:**
  ```
  H_t  = γ5 · M_tex            M_tex = (CKM texture/mass matrix on the flavor factor)
  ```

- **Physical reference Hamiltonian:**
  ```
  H_ref = H_ne + κ · H_t        (κ = texture coupling)
  ```

- **Neuberger overlap (the reference Dirac operator):**
  ```
  D_ov,ne = ρ/a · ( 1 + γ5 · sign(H_ref) )         S := sign(H_ref),  S² = 1
  ```
  In the file we take `ρ = a = 1` and abstract the spectral content to `S = sign(H_ref)`,
  whose only used property is the involutivity `S² = 1` (the defining property of a sign).

- **Texture-dressed overlap (where CKM actually acts):**
  ```
  D_ov^tex = V · D_ov,ne · V⁻¹       V = CKM texture unitary on the finite flavor factor
  ```

The Lean definitions are `GateC1.Hne`, `GateC1.Ht`, `GateC1.Href`, `GateC1.Arch.Dov`,
`GateC1.Arch.DovTex`.

---

## 2. Where the CKM texture lives

**The CKM texture lives in the finite branch/flavor tensor factor, as a unitary `V` (the
CKM matrix, extended over the branch table) that commutes with chirality `γ5` and dresses
the overlap by conjugation.** Concretely:

- The full space factorizes as `(spinor ⊗ color ⊗ lattice) ⊗ (branch/flavor)`.
- CKM is a unitary `V = 1 ⊗ U_CKM` (lifted over the branch table) on the **flavor factor**.
  Because it acts trivially on the spinor factor, `V · γ5 = γ5 · V` (field `V_comm`).
- It enters the reference in **two equivalent guises**:
  1. as the off-diagonal flavor structure of the texture/mass matrix `M_tex` inside
     `H_t = γ5 · M_tex` (the "table/texture" reading), and
  2. as the conjugation `D_ov^tex = V · D_ov,ne · V⁻¹` of the overlap (the "dressing"
     reading).

It is **not** a projector, **not** a boundary coupling, and crucially **not** an additive
naive Dirac operator. It is a finite unitary texture on the branch/flavor factor.

---

## 3. How the 8+8 trap is avoided

The naive 8+8 product/parity mass fails because it has a chirality-flipping parity
involution `P` (`P² = 1`, `P·γ5 = -(γ5·P)`) that commutes with the operator, splitting it
into two equal parity-conjugate ultralocal sectors whose chiral contributions cancel. This
forces the sector signature to vanish:

> **`parity_eight_eight_nogo`** *(proved):* if `P² = 1`, `P·γ5 = -(γ5·P)` and `P·D = D·P`,
> then `tr(γ5·D) = 0`.

The overlap escapes this because the Neuberger sign `S = sign(H_ref)` produces genuine
spectral flow (Ginsparg–Wilson), giving a nonzero signature, which is **logically
incompatible** with the existence of such a `P`:

> **`eight_eight_avoided`** *(proved):* if `χ(D_ov^tex) ≠ 0` then no chirality-flipping
> parity involution commutes with `D_ov^tex`.

Finally, the texture cannot smuggle the trap back in, because conjugation by `V` leaves the
signature unchanged:

> **`Arch.index_texture_invariant`** *(proved):* `χ(D_ov^tex) = χ(D_ov,ne)`.

So CKM is signature-neutral: it reshuffles flavor without touching the topological charge
that defeats the 8+8 factorization.

---

## 4. What is null-edge-native after the import

Only the **Wilson kernel `D_W`** and the **Neuberger sign `S = sign(H_ref)`** (with its
exponential-locality control) are *imported* from lattice gauge theory. Everything else
remains null-edge-native:

| Component | Status |
|---|---|
| Branch table | null-edge-native |
| CKM texture `V` (flavor-factor unitary) | null-edge-native |
| Sub-gap homotopy | null-edge-native (re-run on `H_ref`) |
| Path-shell control | null-edge-native |
| Sector signatures `χ` | null-edge-native (computed from imported `S`) |
| Wilson kernel `D_W`, sign `S = sign(H_ref)` | **imported** |

The import is deliberately minimal: the overlap supplies the *chiral spectral flow*; the
null-edge program supplies the *table, texture, homotopy, path-shell, and signatures* that
organize it.

---

## 5. Certificate plug-in status

**Plug in directly (machine-proved here from the overlap algebra):**

- **Anomaly / index certificate** — `Arch.ginspargWilson` and `Arch.ginspargWilson_tex`:
  the bare and texture-dressed overlaps both satisfy the Ginsparg–Wilson relation
  `γ5·D + D·γ5 = D·γ5·D`, the lattice incarnation of the anomaly/index.
- **Sector-signature certificate** — `Arch.index_texture_invariant`: CKM texture preserves
  `χ`, so the imported signature transfers to the dressed operator.
- **Determinant / ghost (Krein)** — carried as `DetGhost`; plugs in from the standard
  positivity of the overlap fermion determinant on the chiral subspace (Krein structure of
  `1 + γ5 S`). Stated as a certificate field.
- **SM-internality** — carried as `SMInternal`; plugs in unchanged since the texture is
  internal to the flavor factor.

**Remain genuinely open (carried as explicit named hypotheses):**

- **Sub-gap homotopy under the texture** — `SubGapHomotopy`: adding `κ·H_t` can in principle
  close the spectral gap of `H_ref`; the sub-gap homotopy must be re-established for the
  combined `H_ref = H_ne + κ·H_t` (a bound on `κ` relative to the Wilson gap).
- **Non-ultralocal control** — `NonUltralocal`: the overlap sign `S = sign(H_ref)` is not
  ultralocal; one needs the exponential-locality bound for `S` to hold uniformly after the
  texture dressing.

---

## 6. The closure API

```lean
structure GateC1_NU (A : Arch N) (targetSig : ℂ)
    (DetGhost SMInternal SubGapHomotopy NonUltralocal : Prop) : Prop where
  anomaly_index            : A.γ5 * A.Dov + A.Dov * A.γ5 = A.Dov * A.γ5 * A.Dov
  anomaly_index_tex        : A.γ5 * A.DovTex + A.DovTex * A.γ5 = A.DovTex * A.γ5 * A.DovTex
  signature_texture_stable : A.chir A.DovTex = A.chir A.Dov
  sector_signature         : A.chir A.DovTex = targetSig
  no_eight_eight           : targetSig ≠ 0 → ¬ ∃ P, P*P = 1 ∧ P*A.γ5 = -(A.γ5*P) ∧ P*A.DovTex = A.DovTex*P
  determinant_ghost        : DetGhost
  sm_internality           : SMInternal
  subgap_homotopy          : SubGapHomotopy
  nonultralocal_control    : NonUltralocal

theorem WilsonNeuberger_CKM_closes_GateC1_NU
    (A : Arch N) (targetSig : ℂ)
    (DetGhost SMInternal SubGapHomotopy NonUltralocal : Prop)
    (hSig : A.chir A.DovTex = targetSig)
    (hDet : DetGhost) (hSM : SMInternal)
    (hHom : SubGapHomotopy) (hLoc : NonUltralocal) :
    GateC1_NU A targetSig DetGhost SMInternal SubGapHomotopy NonUltralocal
```

The first five fields are discharged internally (anomaly/index, texture-stability, and the
8+8 exclusion are *proved*); the determinant/ghost, SM-internality, sub-gap homotopy and
non-ultralocal control enter exactly as the imported/open certificates. This is the precise
sense in which **"Wilson/Neuberger-with-CKM-texture closes `GateC1_NU` under certificates."**

To upgrade the two open fields to theorems, replace the `SubGapHomotopy` / `NonUltralocal`
propositions with concrete spectral-gap and exponential-locality statements about
`H_ref = H_ne + κ·H_t` and discharge them — no other part of the closure needs to change.
