# FUR-H2 — Can Furey/Krasnov complex-structure data discharge `chi_E`?

**Deliverable status.** A self-contained, fully proved Lean module
`PhysicsSM/Draft/NullEdgeFureyChiE.lean` (imports Mathlib only, no `sorry`,
axioms `propext`/`Classical.choice`/`Quot.sound`) formalizes the answer below.
A literal bridge module that *references* the real `MinimalLeftIdeal` /
`NullEdgeInternalSpectrum` objects could not be built **in this delivered
subset**, because the foundational files those context files import are absent
(see "Build situation" and "Missing APIs" at the end). The abstract module is
written so each symbol maps to a named repository object; instantiating it once
the foundational files are in the build is a finite, mechanical step.

---

## 1. What the included files actually contain

### Furey ideal `J` (`PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`)

* `omega : ComplexOctonion := (1 - i·e111)/2`, the primitive idempotent
  (`omega_idempotent : omega * omega = omega`).
* The eight `ℂ`-basis states `omega, v1,…,v6, nu` of `J = (ℂ⊗𝕆)·omega`, with the
  complete `Cl(6)` ladder action tables (`alpha_k`, `alpha_k_dag`).
* Number operators `N1,N2,N3` (`Nk x = alpha_k_dag * (alpha_k * x)`) with
  eigenvalues giving `N := N1+N2+N3` the values
  `omega↦3, v1,v2,v3↦2, v4,v5,v6↦1, nu↦0` (`charge_*` theorems).
* The complementary idempotent `omega_bar := (1 + i·e111)/2`
  (`omega_bar_idempotent`, `omega_plus_omega_bar : omega + omega_bar = 1`,
  `omega_mul_omega_bar = 0`), explicitly documented as the
  charge-conjugation/complement partner, plus `vbar1,…`.

**Crucially, there is no `chi_E`, no involution, and no Z/2 grading defined on
`J` in these files.** The privileged unit `e111 = e_7` and the scalar `i` appear
only inside `omega`/`omega_bar`; "right multiplication by `e111` = `×i`" is
described in prose (file header) but is **not** a formal definition here, and
`CliffordConnection.lean` is a stub.

### Null-edge internal spectrum (`PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`)

* `InternalGrading := even | odd` — a **two-element type**, i.e. a Z/2 label.
* `NullEdgeInternalSpectrum.grading : ChiralMultiplet → InternalGrading` — the
  `chi_E` field, explicitly documented as "internal **Z/2 grading**" and as
  "bookkeeping only" that "play[s] no role in … the anomaly theorems".
* `fureyStyleRealization` marks the whole internal sector `InternalGrading.odd`.

### Super-Dirac sign layer (`PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean`)

* Abstract `super_dirac_sign_bridge (Gs Xe Ph)` with `Gs*Gs=1`, `Xe*Xe=1`,
  `[Gs,Ph]=0`, `{Xe,Ph}=0` ⟹ `(Gs Ph)² = +Ph²` and `(Xe Ph)² = -Ph²`.
* Concrete `gammaS`, `chiE` as **diagonal ±1 matrix gradings** on `Deg × Chir`
  (`grading sign`), each squaring to `1` (`gammaS_sq`, `chiE_sq`), with
  `chiE_anticommutes_internalBlock` and `gammaS_ne_chiE`.

### Working plan (`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`)

The decorated null-tetrad data tuple (§15.3) is
`(…, Phi_H, Gamma_s, chi_E, J)` — i.e. the plan **already lists the complex
structure `J` and the grading `chi_E` as two separate decorations**. The grading
guardrail (§15.5): `Phi_H` commutes with `Gamma_s` but is **odd** under `chi_E`;
conflating the two flips the sign of `Phi_H²`.

---

## 2. The internal complex structure vs. the grading

| object | repository witness | algebraic type | square |
|---|---|---|---|
| Krasnov/Furey `×i` (right-mult by `e111`) | `omega = (1∓ i·e111)/2`, prose in header | **complex structure** `J` | `J² = -1` |
| `chi_E` (internal) | `InternalGrading`, `grading` field; concrete `chiE` matrix | **Z/2 grading / involution** | `χ² = +1` |
| `Gamma_s` (spacetime) | concrete `gammaS` matrix | Z/2 grading / involution | `+1` |

The module `NullEdgeFureyChiE.lean` makes the two notions precise:

```lean
def IsComplexStructure (J : A) : Prop := J * J = -1   -- the Krasnov ×i datum
def IsZ2Grading        (g : A) : Prop := g * g = 1    -- chi_E and Gamma_s
def IsOdd  (g Ph : A) : Prop := g * Ph = -(Ph * g)    -- "Phi_H is chi_E-odd"
def IsEven (g Ph : A) : Prop := g * Ph =  (Ph * g)    -- "Phi_H is Gamma_s-even"
```

---

## 3. The bridge theorems (all proved in `NullEdgeFureyChiE.lean`)

**Non-conflation.**
```lean
theorem complexStructure_not_grading (x : A) (hchar : (1:A) ≠ -1)
    (h : IsComplexStructure x) : ¬ IsZ2Grading x
theorem complexStructure_ne_grading (J g : A) (hchar : (1:A) ≠ -1)
    (hJ : IsComplexStructure J) (hg : IsZ2Grading g) : J ≠ g
```
A complex structure is never a Z/2 grading, and a complex structure can never be
*equal* to a grading, in any ring with `(1:A) ≠ -1` (e.g. any `ℂ`-algebra). This
is the formal "do not conflate multiplication by `i` with a chirality grading".

**Conversion requires extra data.**
```lean
theorem grading_of_complexStructure_mul_central
    (i J : A) (hi : i*i = -1) (hcomm : i*J = J*i)
    (hJ : IsComplexStructure J) : IsZ2Grading (i*J)
```
The *only* clean way to get an involution out of a complex structure `J` is to
twist it by a **second, independent, commuting** square-root of `-1`: then
`(i·J)² = i²J² = (-1)(-1) = +1`. So a grading needs strictly more data than a
single complex structure.

**Why the twist degenerates on `J`.**
```lean
theorem complexStructure_self_mul_is_trivial (J : A)
    (hJ : IsComplexStructure J) : J * J = -1
```
Krasnov's statement is that on the ideal the internal complex structure *is*
multiplication by the scalar `i` (they coincide). Then the twist
`i·J = J·J = -1` is the **trivial central** involution — it grades nothing (it is
`-1·id`, with no nontrivial ±1 eigenspace splitting).

**A central involution cannot make `Phi_H` odd.**
```lean
theorem central_cannot_be_internal_grading
    (g Ph : A) (hcentral : ∀ x, g*x = x*g) (hodd : IsOdd g Ph) :
    (2:A) * (g*Ph) = 0
theorem central_invertible_odd_block_zero
    (g Ph : A) (hg : IsZ2Grading g) (hcentral : ∀ x, g*x = x*g)
    (hodd : IsOdd g Ph) (h2 : ∀ y, (2:A)*y = 0 → y = 0) : Ph = 0
```
Because the Krasnov `×i` acts as the **scalar** `i`, it is central on the complex
ideal `J`; anything central that also anticommutes with a `Phi_H` forces (no
`2`-torsion) `Phi_H = 0`. Since `chi_E` is *defined* by `{chi_E, Phi_H} = 0`
with `Phi_H ≠ 0`, the central complex structure **cannot** be `chi_E`.

**Non-vacuity.** `complexI_isComplexStructure`, `complexI_not_grading`,
`negOne_isZ2Grading` exhibit the separation concretely in `ℂ`.

---

## 4. Exact classification (task item 4)

* The Furey/Krasnov datum ("right-mult by `e111` = `×i`") is a **complex
  structure** (`J² = -1`). It equips `J` with a complex vector-space structure;
  it is **not** a Z/2 grading and **not** a chirality involution.
* `chi_E` is a **Z/2 grading** (involution, `χ² = +1`), matching the
  `InternalGrading` two-element type and the concrete `chiE` matrix.
* They are **not** "both": no theorem in the project converts `×i` into a
  chirality grading, and — as proved — none can do so *naively*. A conversion is
  possible only with extra data (a second commuting complex structure,
  `grading_of_complexStructure_mul_central`), and on `J` that extra structure
  degenerates to the trivial `-1`. **The complex structure does not supply
  `chi_E`.**

**Therefore `chi_E` must be sourced separately.** The natural, non-central
involution already implicit in the Furey files is the **number-operator parity**
`(-1)^N`, `N = N1+N2+N3` (eigenvalues `3,2,2,2,1,1,1,0` on
`omega,v1..v6,nu`), or equivalently the `omega`/`omega_bar` (particle /
antiparticle, `L`/`R`) reflection. This is a genuine `χ²=+1` involution with a
nontrivial ±1 splitting, and is the correct candidate for `chi_E` — distinct
from the complex structure `J` and from `Gamma_s`.

---

## 5. Interaction with `Phi_H` oddness and the Gate A sign theorem (task item 5)

`NullEdgeFureyChiE.lean` reproduces the Gate A dichotomy self-containedly:
```lean
theorem sign_bridge_with_grading (Gs Xe Ph : A)
    (hGs2 : IsZ2Grading Gs) (hXe2 : IsZ2Grading Xe)
    (hGsPh : IsEven Gs Ph) (hXePh : IsOdd Xe Ph) :
    (Gs*Ph)*(Gs*Ph) = Ph*Ph ∧ (Xe*Ph)*(Xe*Ph) = -(Ph*Ph)
```
This is the abstract core of `SuperDiracSignBridge.super_dirac_sign_bridge`. The
slot paired with `Phi_H` in `D = i D_N + g·Phi_H` must be an **involution**
(`g² = 1`):

* Pairing `Phi_H` with `Gamma_s` (which it is **even** under) gives the physical
  `+Phi_H²`.
* `chi_E` is the grading `Phi_H` is **odd** under; pairing `Phi_H` with `chi_E`
  would give the tachyonic `-Phi_H²`. Keeping `Gamma_s ≠ chi_E` (the repo's
  `gammaS_ne_chiE`) is exactly what protects the `+Phi_H²` sign.

A complex structure cannot enter this picture at all:
```lean
theorem complexStructure_cannot_fill_grading_slot (g : A)
    (hchar : (1:A) ≠ -1) (h : IsComplexStructure g) : ¬ IsZ2Grading g
```
so the Furey `×i` can play **neither** `Gamma_s` **nor** `chi_E`; it is the
ambient `i` that supplies the central `Im` (`Im² = -1`) multiplying `D_N`, not a
grading. Net effect: the Krasnov complex structure feeds the `i D_N` term, while
`chi_E` (the number-parity involution) feeds the grading that makes `Phi_H` odd —
two genuinely different decorations, exactly as the working-plan tuple
`(…, Gamma_s, chi_E, J)` already separates them.

---

## Guardrail compliance

`Gamma_s` (spacetime chirality, involution), `chi_E` (internal grading,
involution), the complex structure `J` (square `-1`), and any form/cochain-degree
grading are kept strictly separate. No theorem identifies any two of them; the
only link offered, `grading_of_complexStructure_mul_central`, is explicit about
the additional commuting-`i` data it consumes and is shown to degenerate on `J`.

---

## Build situation and missing APIs

`lake build` of the default target fails: the delivered subset omits files that
the context files import. To wire `NullEdgeFureyChiE.lean` to the *real* objects
one needs, in the build:

* `PhysicsSM.Algebra.Octonion.ComplexOctonion`, `…Furey.LadderOperators`
  (carriers of `e111`, `alpha_k`), then `…Furey.MinimalLeftIdeal` (present, but
  its imports are absent).
* `PhysicsSM.StandardModel.AnomalyPackage` (needed by
  `NullEdgeInternalSpectrum`).
* `PhysicsSM.Draft.NullEdgeSuperDiracSignAudit`,
  `…NullEdgeSuperDiracBlockCore`, `…NullEdgeSuperDiracProductGradingKrein`,
  `…NullEdgeFiniteTetradPostulate` (needed by the sign/Lichnerowicz bridges).

**Missing formal APIs to complete a literal bridge (none currently exist):**

1. `rightMulE111 : ComplexOctonion →ₗ[?] ComplexOctonion` and a theorem
   `rightMulE111 ∘ rightMulE111 = -id` on `J` (the formal `IsComplexStructure`
   witness; only described in prose today).
2. A theorem `rightMulE111 = (scalar i) • ·` on `J` (the formal Krasnov
   identification, currently prose).
3. A number-parity involution `chiN : J → J`, `chiN := (-1)^(N1+N2+N3)`, with
   `chiN ∘ chiN = id` (the genuine `chi_E` candidate) and a map
   `J-multiplet → InternalGrading` sending it to `even`/`odd`.
4. A theorem `chiN` anticommutes with the off-diagonal mass block `Phi_H`
   (`{chiN, Phi_H} = 0`), feeding `sign_bridge_with_grading`.

Once 1–4 exist, instantiate the abstract `A` of `NullEdgeFureyChiE.lean` at the
endomorphism ring of `J`, take `J := rightMulE111`, `Xe := chiN`,
`Gs := gammaS`, and the abstract theorems transport verbatim, giving the clean
formal bridge and confirming that the Krasnov complex structure does **not**
discharge `chi_E`.
