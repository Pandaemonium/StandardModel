# Gate C1 — Finite overlap-index toy layer and the zero-index trap (job C266)

Date: 2026-06-29
Status: report **plus** a machine-verified, `s o r r y`-free Lean draft.

Companion roadmap: `AgentTasks/null-edge-c263-index-anomaly-bridge-plan-2026-06-29.md`.
Algebraic base layer: `PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean`
(`Dov`, `dov_ginsparg_wilson`).

Lean artifact produced by this job:
`PhysicsSM/Draft/NullEdge/GateC1/OverlapIndexToy.lean`
— builds with no `s o r r y`, assumptions `[propext, Classical.choice, Quot.sound]` only
(verified by `#print assumptions`).

Scope is **strictly finite-dimensional** `Matrix Spin Spin ℂ` trace algebra. No
functional calculus, locality, gauge covariance, or infinite-volume index
theory, per the prompt.

Throughout, `gamma5` and `eps` are square complex matrices on a finite type
`Spin`, `Dov gamma5 eps = 1 + gamma5 * eps`, and "involution" means `M * M = 1`.

---

## 0. Executive summary

| Question | Answer |
|---|---|
| Q1 Normalized `Ghat`, `overlapIndex` | `Ghat = gamma5 * (1 − ½•Dov)`, `overlapIndex = Tr Ghat`. See §1. |
| Q2 Trace formula | `overlapIndex = ½·(Tr gamma5 − Tr eps)`; under `Tr gamma5 = 0`, `= −½·Tr eps = −½·Tr(gamma5·Dov)` (HLN). Proved: `overlapIndex_eq`, `…_neg_half_trace_eps`, `…_neg_half_trace_gamma5_Dov`. See §2. |
| Q3 Zero-index theorem | **Anticommutation** kills the index: if `eps` and `gamma5` are involutions with `eps·gamma5 = −(gamma5·eps)`, then `overlapIndex = 0`. Proved: `overlapIndex_eq_zero_of_anticomm`. The C263 framing "commuting ⇒ zero" is **inverted** — see §3. |
| Q4 Nonzero witness | Explicit `Fin 2` toy, `gamma5 = diag(1,−1)`, `eps = −1` (which **commutes** with `gamma5`), gives `overlapIndex = 1`. Proved: `overlapIndex_g5_epsNegI_eq_one`. See §4. |
| Q5 Sign/normalization pins | Six choices to fix before wiring to anomaly weights; the decisive one is `Tr gamma5 = 0`. See §5. |

The single most important finding: the **zero-index trap is the anticommuting
case, not the commuting case**. This reverses the dichotomy proposed in the
C263 plan (§3.2 L4, §6) and is established here both by a general theorem and by
an explicit commuting counterexample with nonzero index.

---

## 1. Q1 — Correct normalized definitions

For `Dov gamma5 eps = 1 + gamma5 * eps` (Neuberger overlap, lattice spacing
`a = 1`, scalar prefactor `ρ/a` dropped), the **Lüscher GW-modified chirality**
and the **lattice chiral index** are

```lean
def Ghat (gamma5 eps : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  gamma5 * (1 - (1/2 : ℂ) • Dov gamma5 eps)

def overlapIndex (gamma5 eps : Matrix Spin Spin ℂ) : ℂ :=
  (Ghat gamma5 eps).trace
```

This is the normalization recommended by C263 §3.1, and it is correct **once the
physical constraint `Tr gamma5 = 0` is imposed** (see §2 and §5). The closed form

```lean
theorem Ghat_eq (h : gamma5 * gamma5 = 1) :
    Ghat gamma5 eps = (1/2 : ℂ) • (gamma5 - eps)
```

shows `Ghat` is, up to the `½`, the difference of the two involutions — the
finite-matrix shadow of `γ̂₅`. (Lüscher's `γ̂₅ = gamma5·(1 − Dov) = −eps` here;
`Ghat = ½(gamma5 + γ̂₅)` is the symmetric projector-difference whose trace is the
index.)

---

## 2. Q2 — Trace formula (proved)

The central exact identity, with no hypothesis beyond `gamma5² = 1`:

```lean
theorem overlapIndex_eq (h : gamma5 * gamma5 = 1) :
    overlapIndex gamma5 eps = (1/2 : ℂ) * (gamma5.trace - eps.trace)
```

Proof: `Tr Ghat = Tr(½•(gamma5 − eps)) = ½(Tr gamma5 − Tr eps)` via
`Matrix.trace_smul`, `Matrix.trace_sub`.

Under the physical traceless-chirality normalization this collapses to the
textbook Hasenfratz–Laliena–Niedermayer form, in two equivalent shapes:

```lean
theorem overlapIndex_eq_neg_half_trace_eps
    (h : gamma5 * gamma5 = 1) (h0 : gamma5.trace = 0) :
    overlapIndex gamma5 eps = -(1/2 : ℂ) * eps.trace

theorem overlapIndex_eq_neg_half_trace_gamma5_Dov
    (h : gamma5 * gamma5 = 1) (h0 : gamma5.trace = 0) :
    overlapIndex gamma5 eps = -(1/2 : ℂ) * (gamma5 * Dov gamma5 eps).trace
```

The second line is the canonical HLN statement `index = −½ Tr(γ₅ D)`. Since
`Tr(gamma5·Dov) = Tr gamma5 + Tr eps` and `Tr gamma5 = 0`, it equals `−½ Tr eps`,
i.e. `−½ Tr sign(H)` once `eps = sign(H)` is supplied by the analytic lane.

> **Correction to C263.** C263 §2(1) writes `index = −½ Tr(γ₅ ε)`. That is *not*
> the same number as `−½ Tr ε`: with `gamma5 = diag(1,−1)` and `eps` in `±`
> blocks, `Tr(gamma5·eps) = Tr eps₊ − Tr eps₋` whereas `Tr eps = Tr eps₊ + Tr eps₋`.
> The HLN index is `−½ Tr(γ₅ D) = −½(Tr gamma5 + Tr eps)`, which reduces to
> `−½ Tr eps` (not `−½ Tr(γ₅ ε)`) under `Tr gamma5 = 0`. The Lean file uses the
> correct `−½ Tr eps` form.

**Integrality (outline; not in the Lean draft).** `overlapIndex` is an integer
because it is `½(Tr gamma5 − Tr eps)` with both `gamma5`, `eps` involutions:
`P = (1 + M)/2` is idempotent (`P² = P`) for any involution `M`, and over a
field the trace of an idempotent matrix equals the rank of its range, an
integer; hence `Tr M = 2·rank P − dim`, an integer with the same parity as
`dim`. So `Tr gamma5 ≡ Tr eps ≡ dim (mod 2)`, their difference is even, and the
half is an integer. The clean Mathlib route is
`LinearMap.IsProj.trace : (trace) f = finrank (range)` applied to the projection
attached to `P`, after transporting `Matrix.trace` to `LinearMap.trace`
(`Matrix.trace_eq_…`/`toLin`). This is a worthwhile next milestone (M2 in C263);
in the toy file the integer values are pinned concretely (§4).

---

## 3. Q3 — Zero-index theorem (and the corrected trap)

The clean, always-true finite-matrix zero-index theorem is governed by
**anticommutation**:

```lean
theorem trace_eq_zero_of_anticomm
    (h : gamma5 * gamma5 = 1) (hanti : eps * gamma5 = -(gamma5 * eps)) :
    eps.trace = 0

theorem overlapIndex_eq_zero_of_anticomm
    (hg : gamma5 * gamma5 = 1) (he : eps * eps = 1)
    (hanti : eps * gamma5 = -(gamma5 * eps)) :
    overlapIndex gamma5 eps = 0
```

Mechanism: if `eps·gamma5 = −(gamma5·eps)` and `gamma5² = 1`, then
`gamma5·eps·gamma5 = −eps`, so `eps` is conjugate to `−eps` and `Tr eps = 0`. By
the symmetric argument (using `eps² = 1`) `Tr gamma5 = 0` as well, and
`overlapIndex = ½(Tr gamma5 − Tr eps) = 0`.

### The zero-index trap is inverted relative to C263

C263 §3.2 (L4) and §6 propose: *commuting* `gamma5, eps` ⇒ index `0` (the
"route/taste" no-go), *anticommuting* ⇒ nonzero. The honest finite-matrix
algebra says the **opposite**:

* **Anticommuting ⇒ index `0`** (theorem above). For *any* `X` anticommuting
  with `gamma5`, `Tr(gamma5 X) = 0` and, for involutions, `Tr X = 0`; there is no
  way to get a nonzero index from a purely off-diagonal (chirality-odd) `eps`.
* **Commuting can give nonzero index.** A `gamma5`-commuting `eps` is block
  diagonal `diag(eps₊, eps₋)` and `overlapIndex = −½(Tr eps₊ + Tr eps₋)` (with
  `Tr gamma5 = 0`), which is generically nonzero — see the witness in §4
  (`eps = −1` commutes with `gamma5` and yields index `1`).

Why this matters physically: in the real overlap, `H = γ₅(D_W − m)` is
Hermitian via γ₅-hermiticity (`γ₅ D_W γ₅ = D_W†`) but does **not** commute with
`γ₅` (the `γ·∂` term is chirality-odd). So `eps = sign(H)` is neither purely
commuting nor purely anticommuting; its **commuting (diagonal) part** is what
carries the index, and its anticommuting part is invisible to the trace. The
"route/taste = zero index" intuition is real, but the correct algebraic
signature of a label that *cannot* carry index is **anticommutation with
chirality**, not commutation.

A faithful "commuting ⇒ zero" statement requires an *extra* hypothesis, e.g. a
spectrally symmetric classifier `Tr eps₊ = Tr eps₋` (equivalently `Tr eps = 0`
with `eps` block-diagonal); commutation alone is insufficient.

---

## 4. Q4 — Concrete finite toy witnesses (`Fin 2`, proved)

With `gamma5 = diag(1,−1)` (`g5`, traceless involution):

| `eps` | rel. to `gamma5` | `overlapIndex` | Lean lemma |
|---|---|---|---|
| `!![0,1;1,0]` (`epsFlip`) | anticommutes | `0` | `overlapIndex_g5_epsFlip_eq_zero` |
| `!![-1,0;0,-1]` (`epsNegI`, `= −1`) | commutes | `1` | `overlapIndex_g5_epsNegI_eq_one` |

```lean
theorem overlapIndex_g5_epsFlip_eq_zero : overlapIndex g5 epsFlip = 0
theorem overlapIndex_g5_epsNegI_eq_one : overlapIndex g5 epsNegI = 1
```

Both `eps` are genuine involutions (`epsFlip_sq`, `epsNegI_sq`), with
`epsFlip_anticomm`, `epsNegI_comm` recording their (anti)commutation. The
nonzero witness is the explicit counterexample to "commuting ⇒ zero".

**No extra hypotheses are required for a nonzero index** beyond `gamma5² = eps²
= 1` and `Tr gamma5 = 0`: a nonzero `Tr eps` (i.e. a chirality-even,
gamma5-commuting component of the classifier) suffices. For a *physically
interesting* nonzero index (one reflecting genuine spectral flow rather than a
trivial `eps = ±1`), the extra structure needed is exactly the analytic lane's
`eps = sign(H)` with `H` the gapped tetrahedral Wilson symbol — see C263 M5 and
§5 below. A richer `Fin 4` witness mimicking two chiral blocks with opposite
sign assignments gives index `±1` the same way and is the natural next toy.

---

## 5. Q5 — Sign / normalization choices to pin

These must be fixed once, before connecting `overlapIndex` to the rational
anomaly weights in `AnomalyPackage`:

1. **Tracelessness of chirality, `Tr gamma5 = 0`.** This is the linchpin.
   `overlapIndex = ½(Tr gamma5 − Tr eps)` equals the HLN index `−½ Tr(gamma5·Dov)`
   *only* when `Tr gamma5 = 0`; off a balanced Dirac space the `Ghat`
   normalization and the `−½ Tr(γ₅ D)` normalization differ by `Tr gamma5`. Adopt
   `Tr gamma5 = 0` as a standing hypothesis of the index layer.

2. **Overall index sign.** Fix `index = −½ Tr(γ₅ D) = −½ Tr eps` (left-handed
   Weyl positive). The opposite sign just relabels `n₊ ↔ n₋`; pick once so that
   one left-handed zero mode gives `+1`, matching the left-handed-Weyl
   convention of `AnomalyPackage` ("all fermions entered as left-handed").

3. **`eps` vs `gamma5·eps` in the trace.** Use `Tr eps` (the sign operator),
   *not* `Tr(gamma5·eps)`; see the §2 correction. Equivalently always go through
   `Tr(gamma5·Dov)`.

4. **Lattice-spacing factor in `Dov`.** The draft uses `a = 1`,
   `Dov = 1 + gamma5·eps`. If `a` is reinstated as `Dov = (1/a)(1 + gamma5·eps)`
   the index is unchanged (it is scale-free), but the `½` in `Ghat` must track
   `1 − ½ a D`. Pin `a = 1` at the algebraic layer and reintroduce `a` only at
   the analytic boundary.

5. **`eps = sign(H)` sign convention.** When the tetrahedral Wilson symbol `H`
   (from `TetraScalarWilsonSymbol`) supplies `eps`, fix `sign(0)` handling (the
   gap `firstBandMu_pos` guarantees `0 ∉ spec H`, so this is vacuous in-band) and
   the sign of `H = ±γ₅(D_W − m)`. The chosen sign feeds directly into pin (2).

6. **Cast path `ℤ → ℂ → ℚ`.** Keep the index in `ℤ` (after the integrality
   milestone), cast once into the `ℚ`-valued anomaly functionals at the bridge
   boundary; do not let `overlapIndex : ℂ` leak into the rational arithmetic.

---

## 6. Status, claim boundary, and next steps

**Delivered (machine-checked, `s o r r y`-free):** `Ghat`, `overlapIndex`,
`Ghat_eq`, `overlapIndex_eq`, the two HLN forms, `trace_eq_zero_of_anticomm`,
`overlapIndex_eq_zero_of_anticomm`, and the `Fin 2` zero/nonzero witnesses with
their involution/(anti)commutation facts.

**This layer does NOT establish** (unchanged from C263 §5): a functional
calculus or `sign(H)` as an operator; locality / exponential tails; gauge
covariance; Krein positivity / determinant-line control; or the Furey
realization. It is finite-matrix kinematics only.

**Recommended next milestones**

* **M2 (integrality):** turn the §2 outline into a `s o r r y`-free
  `overlapIndex_int : ∃ n : ℤ, overlapIndex gamma5 eps = (n : ℂ)` via
  `LinearMap.IsProj.trace`. Prove first for `Spin = Fin 4` by exhaustion if the
  general route stalls.
* **M3 (richer witness):** a `Fin 4` two-block toy with index `±1` from a
  gamma5-commuting `eps` with `Tr eps ≠ 0`, mirroring real spectral flow.
* **M4 (bridge):** `IndexAnomalyBridge.lean` joining `overlapIndex` (cast to `ℤ`,
  charge-weighted) to `AnomalyPackage`'s `gravitationalU1Anomaly` /
  `u1CubedAnomaly`, using the §5 sign pins.
* **M5 (analytic):** instantiate `eps = sign(H)` from `TetraScalarWilsonSymbol`'s
  gapped `H`, discharging `eps² = 1` from `firstBandMu_pos`.
