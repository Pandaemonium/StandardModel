# C61 — Gauge-covariant link-dressed branch projector theorem plan

Type: strategy / proof-API. Gate C gauge-covariance job.

Companion Lean module:
`PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean`
(self-contained: `import Mathlib` + the self-contained C47/C48 file
`PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`; builds clean, `sorry`-free,
axioms `propext / Classical.choice / Quot.sound` only).

---

## 0. The problem, stated honestly

The free-field Route B branch projectors are **trigonometric momentum filters**,
products of `(1 ± cos q_a)/2` over the null directions `a`. In position space
each `cos q_a` is a symmetric one-step null-edge shift,

```
cos q_a  ⟷  ½ (S_a + S_a†),
(1 ± cos q_a)/2  ⟷  ½·1  ±  ¼ (S_a + S_a†),
```

so a Route B projector is a **finite combination of forward/backward null-edge
shifts** `1, S_a, S_a†, S_a S_b, …`.

A *bare* lattice shift `S_a` is **not gauge covariant**. Under a local gauge
transformation `ψ_x ↦ g_x ψ_x` the shifted field `(S_a ψ)_x = ψ_{x+ê_a}`
transforms by `g_{x+ê_a}`, not by `g_x`, so `S_a ψ` is *not* a field at `x`.
Multiplying such objects, contracting them, or feeding them into a causal update
therefore breaks gauge covariance the instant gauge coupling is switched on.

**The fix (mandatory).** Every shift must be **link-dressed**: replaced by the
parallel transport `U_e` (the gauge link) across the edge it crosses,

```
S_a  ↦  U_{x,a} · S_a ,      (forward, retarded)
S_a† ↦  S_a† · U_{x,a}†  =  U_{x-ê_a, a}† · S_a† ,   (backward, advanced)
```

and a multi-step shift becomes the ordered product of links along the path
(the discrete Wilson line / parallel transport). The resulting object is a
**link-dressed finite-range covariant projector**.

> **Guardrail (do not claim otherwise).** The free-field projectors are **not**
> physical after gauge coupling unless (i) they are link-dressed as above
> *and* (ii) they pass the C47/C48 ghost-zero audit. Gauge covariance is
> necessary, not sufficient — see §6.

---

## 1. The Lean-facing API (deliverable 1)

All names below are in
`PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors`.

### 1.1 Setting

* Finite directed graph: vertex type `V`, gauge fibre `Fin n → ℂ` per vertex.
* **Link / connection** `U : (edge) → Matrix (Fin n) (Fin n) ℂ`, a gauge-group
  (unitary) element; `gaugeLink g U a b := g a * U * star (g b)` is the gauge
  transform of a transport running from vertex `a` to vertex `b`.
* **Local gauge transformation** `g : V → Matrix (Fin n) (Fin n) ℂ` with
  `∀ v, star (g v) * g v = 1` (unitary).
* **Field** `ψ : V → (Fin n → ℂ)`, acted on by `ψ v ↦ g v *ᵥ ψ v`.
* Hermitian fibre inner product `cinner x w = ∑ conj(xᵢ) wᵢ`, with
  `cinner_mulVec_of_unitary` (unitaries preserve it).

### 1.2 Core data type

```text
structure DressedShift (n) (V) where
  coeff : ℂ          -- coefficient in the projector
  dir   : ShiftDir   -- retarded | advanced (causal orientation)
  dst   : V          -- endpoint vertex the shift reaches
  W     : Matrix     -- parallel transport (ordered link product) dressing it
```

A **link-dressed branch projector** evaluated at the base vertex is the finite
combination

```text
dressedProjector shifts ψ  =  ∑_{sh ∈ shifts}  sh.coeff • (sh.W *ᵥ ψ sh.dst).
```

(The base vertex enters the *output* only through the `g a` factor on the
transformed side; the un-gauged projector depends only on the shifts.)

The **gauge-transformed** projector dresses each transport and rotates each
field:

```text
dressedProjectorGauged g a shifts ψ =
    ∑_{sh}  sh.coeff • ((gaugeLink g sh.W a sh.dst) *ᵥ (g sh.dst *ᵥ ψ sh.dst)).
```

---

## 2. The transformation law (deliverable 2)

There are two distinct, both proven, covariance laws — one for an **open**
projector (covariant) and one for a **closed** composite (invariant).

### 2.1 Transport algebra (the reason dressing works)

* `gaugeLink_comp` — composing transports along a connected path cancels the
  intermediate gauge factor (uses `star (g b) * g b = 1`):

  ```text
  gaugeLink g U₁ a b * gaugeLink g U₂ b c = gaugeLink g (U₁ * U₂) a c.
  ```

* `dressedHop_gauge` — a field value transported to the base point `a` by `W`
  transforms by `g a` *at the base only*:

  ```text
  (gaugeLink g W a b) *ᵥ (g b *ᵥ ψ b) = g a *ᵥ (W *ᵥ ψ b).
  ```

### 2.2 Open projector — **gauge covariance** (`dressedProjector_gauge_covariant`)

```text
dressedProjectorGauged g a shifts ψ  =  g a *ᵥ dressedProjector shifts ψ.
```

The output is a field at the base point: it transforms by the single factor
`g a`. This is the precise sense in which a link-dressed finite shift
combination is a **covariant branch projector**.

### 2.3 Closed composite — **gauge invariance** (`loopComposite_gauge_invariant`)

For a transport `W` that returns to the base vertex (a closed Wilson loop /
length-balanced path), contracted into a Hermitian singlet with the base field,

```text
loopComposite a W ψ  =  cinner (ψ a) (W *ᵥ ψ a),
cinner (g a *ᵥ ψ a) ((gaugeLink g W a a) *ᵥ (g a *ᵥ ψ a)) = cinner (ψ a) (W *ᵥ ψ a).
```

The `g a` of the field and the `g a` of its conjugate cancel: the closed
composite is **exactly gauge invariant**.

---

## 3. The three contexts (deliverable 3)

These must be kept **separate**; the admissibility of a finite shift combination
depends on which one you are in. Encoded as `ProjCtx` with predicate
`AdmissibleIn`.

### (A) Strictly retarded causal update block — `ProjCtx.causalUpdate`

A causal update writes the field at time `t` from data in its **causal past**.
The dressed projector must therefore be supported on **retarded (forward /
future-directed) shifts only**; an advanced (backward) shift would read from
outside the causal past and destroy the strict-retardation that makes the update
well-posed and the commutator structure causal.

* Transformation law required: **covariance** (§2.2). The update maps a covariant
  field to a covariant field.
* `AdmissibleIn causalUpdate a shifts ↔ ∀ sh ∈ shifts, sh.dir = retarded`
  (`causal_admissible_iff`). An advanced shift forbids it
  (`not_causal_of_advanced`).

### (B) Retarded/advanced Krein spectral double — `ProjCtx.kreinDouble`

The Krein construction doubles the state space into a retarded ⊕ advanced
(`R ⊕ A`) pair carrying an **indefinite** Krein metric. Here both orientations
are allowed, but they must enter **paired** (equal retarded/advanced
multiplicity), so the doubled object is metric-compatible and the R/A halves are
genuine conjugates.

* Transformation law required: **covariance** of each half (the Krein metric is
  built from the unitary fibre structure, which covariance preserves).
* `AdmissibleIn kreinDouble a shifts` :=
  `#{retarded} = #{advanced}` (counts of `dir` over `shifts`).

> **Krein ≠ ghost-safety.** Covariance preserves the *indefinite* metric; it does
> **not** prove the physical (gauge-invariant on-shell) subspace is Krein-positive.
> That is exactly the C22 / C47 obligation (`KreinPositivePhysicalSector`,
> `kreinArtifact` vs `fatalGhostZero`).

### (C) Gauge-invariant composite / interpolating observable — `ProjCtx.compositeObservable`

An observable must be gauge **invariant**, not merely covariant. The dressed
shifts must therefore form a **closed loop** based at the vertex (every shift
returns to the base), so the open gauge index is contracted into a singlet
(FMS-style `ψ† … ψ`, cf. `NullEdgeFMSFiniteComposite.fmsSinglet_gauge_invariant`
and `loopComposite_gauge_invariant` here).

* Transformation law required: **invariance** (§2.3).
* `AdmissibleIn compositeObservable a shifts` := `∀ sh ∈ shifts, sh.dst = a`
  (loop closure at the base; the contraction then cancels `g a`).

---

## 4. Which finite shift combinations are acceptable where (deliverable 4)

The decisive concrete fact is about the symmetric `cos`-filter part `S + S†`,
which contains **one retarded and one advanced** shift
(`cosFilterDirs = [retarded, advanced]`).

| Finite shift combination | (A) causal update | (B) Krein double | (C) composite |
|---|---|---|---|
| identity `1` (length 0) | ✅ | ✅ | ✅ (trivial loop) |
| one-sided retarded `S` (`retFilterDirs`) | ✅ `retFilter_causal` | ✅ (if paired w/ `S†`) | only inside a closed loop |
| symmetric `cos`-filter `S + S†` (`cosFilterDirs`) | ❌ `cosFilter_not_causal` | ✅ `cosFilter_kreinDouble` | ✅ if closed (loop `S S†`) |
| advanced-only `S†` | ❌ | ✅ (if paired) | only inside a closed loop |
| closed Wilson loop `S_a S_a†` | ✅ (length-balanced) | ✅ | ✅ (invariant, §2.3) |

Machine-checked entries:

* `cosFilter_not_causal` — the symmetric `cos`-filter is **not** causally
  admissible (it contains an advanced shift). To use `(1 ± cos q)/2` in a strict
  causal update you must **split** it and keep only the retarded half, or move it
  to context (B)/(C).
* `cosFilter_kreinDouble` — the symmetric `cos`-filter **is** Krein-paired, hence
  admissible in the retarded/advanced double.
* `retFilter_causal` — a one-sided retarded filter **is** causally admissible.

**Reading.** The free-field `cos`-projectors are inherently symmetric (advanced +
retarded). They are *directly* usable only in contexts (B) and (C). In the strict
causal-update context (A) they must be one-sided-ized (retarded half), at the cost
of changing the momentum filter — a genuine model decision, not a free relabelling.

---

## 5. Draft module skeleton (deliverable 5 — implemented)

`PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean` provides, all
proven:

* fibre algebra: `cinner`, `cnorm2`, `cinner_mulVec_of_unitary`;
* transport algebra: `gaugeLink`, `gaugeLink_comp`, `dressedHop_gauge`;
* contexts: `ShiftDir`, `ProjCtx`, `AdmissibleIn`, `causal_admissible_iff`,
  `not_causal_of_advanced`;
* dressed projector + covariance: `DressedShift`, `dressedProjector`,
  `dressedProjectorGauged`, **`dressedProjector_gauge_covariant`**;
* composite invariance: `loopComposite`, **`loopComposite_gauge_invariant`**;
* concrete filters: `cosFilterDirs`, `retFilterDirs`, `ofDirs`,
  `cosFilter_not_causal`, `cosFilter_kreinDouble`, `retFilter_causal`;
* ghost tie-in (§6): `DressedBranchProjector`, `GaugeCovariant`,
  `LinkDressedSafe`, **`gaugeCovariant_not_ghostSafe`**,
  `linkDressedSafe_nonvacuous`, `c61_gauge_covariance_summary`.

---

## 6. Tie to `GhostZeroSafe`: covariance is necessary, not sufficient (deliverable 6)

This is the load-bearing Gate C point. Gauge covariance is a **theorem about every
link-dressed projector** (`DressedBranchProjector.gaugeCovariant`, no
hypothesis): dressing always restores covariance. But covariance is a statement
about *transformation behaviour*, not about the *spectrum*. The
Golterman–Shamir hazard (arXiv:2311.12790; C47/C48) lives in the spectrum: a
determinant/propagator zero introduced by the projector can promote, under weak
gauge coupling, to a propagating **wrong-sign (negative Krein) ghost**.

We bundle a projector with the classified zero spectrum it introduces
(`DressedBranchProjector` carrying `zeros : List ZeroDatum` from the C47/C48
module) and prove the **separation**:

```text
gaugeCovariant_not_ghostSafe :
  ∃ P, P.GaugeCovariant ∧ ¬ GhostZeroSafe P.zeros.
```

i.e. a perfectly gauge-covariant link-dressed branch projector can still harbour a
fatal ghost zero. The honest release condition is therefore the **conjunction**

```text
LinkDressedSafe P  :=  P.GaugeCovariant ∧ GhostZeroSafe P.zeros,
```

and even that is only the spectrum-level half: full physical safety additionally
requires the C47/C48 post-gauge-coupling contract
`PostGaugeGhostSafe` (weak-coupling residue-sign control) and a
`KreinPositivePhysicalSector` certificate. The predicate is non-vacuous
(`linkDressedSafe_nonvacuous`).

**Verdict.** Link dressing is the **first** mandatory step (it secures
covariance), never the **last**. After dressing, the Route B projector still owes
the full C47/C48 ghost audit:

1. enumerate the determinant/propagator zeros of the *dressed* symbol;
2. classify each (`physicalPole / physicalDoubler / kinematicalZero /
   compositeRemovable / kreinArtifact / fatalGhostZero`);
3. discharge `GhostZeroSafe`, `KreinPositivePhysicalSector`, and
   `PostGaugeGhostSafe` on the dressed operator.

Per the Working Plan §23.6 / §25.3 four-valued language, Route B remains
**PENDING-SAFETY**: gauge covariance is now secured at theorem level by link
dressing, but the post-gauge-coupling ghost-zero obligations are open and are the
real Gate C blocker.

---

## 7. Residual obligations (open, not assumed)

1. **Dressed Clifford symbol.** Build the link-dressed Dirac/Clifford symbol of
   the flat tetrahedral null-edge operator and enumerate its zeros (the
   `OperatorForcesAlignment`/symbol data absent from the current tree).
2. **Per-zero residue sign after weak coupling.** Discharge `PostGaugeGhostSafe`
   for the dressed operator (the genuine Golterman–Shamir computation).
3. **Physical-sector Krein positivity.** Certify `KreinPositivePhysicalSector`
   on the gauge-invariant on-shell subspace (separate the `kreinArtifact` from
   the `fatalGhostZero`).
4. **Context selection.** For the strict causal-update block, fix the one-sided
   (retarded) replacement of the symmetric `cos`-filter and verify it still
   realises the intended branch projection (`cosFilter_not_causal` shows the
   symmetric form is inadmissible there).

None of these are assumed in the Lean module; they are recorded as the open Gate C
work that link dressing alone does not close.
