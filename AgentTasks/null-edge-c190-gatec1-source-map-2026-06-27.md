# Gate C1 — Reference Index / Anomaly / Locality Source & Theorem Map

**Program:** Null-edge / NullStrand Gate C1
**Predecessors:** C159 (index/locality certificate slot), C183 (anomaly/index *source interface*),
C184 (locality/admissibility certificate slot), C179 (selection note: *Wilson/Neuberger first,
domain-wall second*).
**Status of this document:** research / strategy. It selects the *exact* reference theorems and
maps them to Lean/API certificate statements. It does **not** prove any physics theorem; every
external result is tagged **[SOURCE OBLIGATION]** and must be checked against the cited paper before
it is relied upon downstream.

> **Honesty note.** Bibliographic details below (journal/volume/year, arXiv numbers, and especially
> numerical constants such as the admissibility bound `ε`) are reproduced from working knowledge and
> are themselves part of the source obligation: verify the *exact* statement, hypotheses, and
> constants in the primary source. Where a constant or sign is convention-dependent it is flagged in
> §5.

---

## 0. What Gate C1 actually needs

Gate C1 needs a *self-contained certificate chain* showing that a chosen lattice chiral-fermion
formulation delivers, with controlled approximation:

1. an **exact lattice index theorem** (zero-mode chirality count = topological charge),
2. an **algebraic chirality relation** (Ginsparg–Wilson) underwriting (1),
3. a **locality / admissibility theorem** (the Dirac operator is exponentially local under a
   bounded-field condition),
4. an **anomaly-cancellation source shape** (existence of a local, gauge-invariant fermion measure
   given the charge/representation content),

and, for the fallback formulation, the analogues plus **residual-mass control** and an
**effective-overlap equivalence**.

The three candidate formulations and their roles:

| Formulation | Role | Why |
|---|---|---|
| Wilson/Neuberger **overlap** | **primary** | exact GW + exact index are *theorems*, locality + anomaly fully worked out by Lüscher et al. |
| **domain-wall** (Kaplan/Shamir) | **secondary** | physically transparent (inflow), but index/locality are *via* the overlap limit and need `m_res` control |
| **Adams / staggered overlap** | optional, later | only if staggered cost is wanted; needs an *extra* taste-index theorem |

---

## 1. Wilson / Neuberger overlap (PRIMARY)

### 1.1 Index theorem (the target)

- **Statement to cite:** For a lattice Dirac operator `D` obeying the Ginsparg–Wilson relation,
  the chirality-weighted count of exact zero modes equals the topological charge:
  `index(D) = n₋ − n₊ = Q`, and equivalently `index(D) = −(a/2)·Tr(γ₅ D) = Tr(γ₅(1 − (a/2)D))`.
- **Primary sources:**
  - Hasenfratz, Laliena, Niedermayer, *The index theorem in QCD with a finite cutoff*,
    Phys. Lett. B **427** (1998) 125 [hep-lat/9801021]. — first exact lattice index theorem from GW.
  - Lüscher, *Exact chiral symmetry on the lattice and the Ginsparg–Wilson relation*,
    Phys. Lett. B **428** (1998) 342 [hep-lat/9802011]. — exact lattice chiral transformation
    `δψ = γ₅(1 − aD)ψ`, the index, and the link to the topological charge and the anomaly.
  - (Continuum backdrop: Atiyah–Singer.)
- **[SOURCE OBLIGATION]** confirm the *exact* normalization (factor `a/2`, the `(1 − aD/2)`
  insertion) and the sign relating `index` to `Q` in the convention C1 adopts (see §5).
- **Lean certificate:** `LatticeIndexCert` (see `RequestProject/GateC1SourceMap.lean`), consumed by
  **C159**.

### 1.2 Ginsparg–Wilson relation (the underwriter of 1.1)

- **Statement:** `γ₅ D + D γ₅ = a · D γ₅ D` (general GW; the Neuberger operator satisfies the simplest
  form with the local kernel `R = 1`).
- **Overlap operator:** `D = (1/a)·(1 + γ₅ · sign(H_W))`, with `H_W = γ₅ D_W(−m₀)` the Hermitian
  Wilson–Dirac operator at negative mass `m₀` (free-theory single-flavour window `0 < m₀ < 2`).
- **Primary sources:**
  - Ginsparg, Wilson, *A remnant of chiral symmetry on the lattice*, Phys. Rev. D **25** (1982) 2649.
  - Neuberger, *Exactly massless quarks on the lattice*, Phys. Lett. B **417** (1998) 141
    [hep-lat/9707022]; *More about exactly massless quarks…*, Phys. Lett. B **427** (1998) 353
    [hep-lat/9801031]. — the overlap `D` and the proof it satisfies GW.
- **[SOURCE OBLIGATION]** confirm the kernel/`R` normalization and the precise `m₀` window used.
- **Lean certificate:** `GinspargWilsonCert`, consumed by **C159/C183**.

### 1.3 Locality / admissibility

- **Statement:** Under the **admissibility condition** `‖1 − U(p)‖ < ε` for every plaquette `p`
  (with `ε` small enough — the paper's sufficient bound is `ε ≤ 1/30`), `H_W` has a spectral gap,
  `sign(H_W)` is well defined, and the overlap kernel is **exponentially local**
  (`‖D(x,y)‖ ≤ C·e^{−γ|x−y|}` with `γ > 0`).
- **Primary source:** Hernández, Jansen, Lüscher, *Locality properties of Neuberger's lattice Dirac
  operator*, Nucl. Phys. B **552** (1999) 363 [hep-lat/9808010].
- **[SOURCE OBLIGATION]** confirm the exact admissibility bound (`ε ≤ 1/30` is a *sufficient*,
  non-tight constant), the exact spectral-gap statement of `H_W²`, and the localization-range
  estimate `γ`.
- **Lean certificate:** `OverlapLocalityCert`, consumed by **C184** (and feeds C159's index, since
  a well-defined `sign(H_W)` is a prerequisite).

### 1.4 Anomaly cancellation (source shape)

- **Statement (shape):** the chiral/Weyl determinant on the lattice has a *local, smooth,
  gauge-invariant* fermion integration measure **iff** the gauge anomaly cancels. Concretely:
  - **abelian U(1):** `Σ_f q_f³ = 0` (cubic) and `Σ_f q_f = 0` (linear / mixed-gravitational), with
    integer-normalized charges;
  - **non-abelian:** `Σ_reps tr(T^a {T^b, T^c}) = 0` (the `d^{abc}` anomaly).
- **Primary sources:**
  - Lüscher, *Abelian chiral gauge theories on the lattice with exact gauge invariance*,
    Nucl. Phys. B **549** (1999) 295 [hep-lat/9811032].
  - Lüscher, *Weyl fermions on the lattice and the non-abelian gauge anomaly*,
    Nucl. Phys. B **568** (2000) 162 [hep-lat/9904009].
- **[SOURCE OBLIGATION]** confirm the precise cohomological reconstruction statement
  (anomaly = local field; cancellation ⇒ existence of the measure term) and the exact charge
  normalization in the abelian condition (see §5 hypercharge hazard).
- **Lean certificate:** `AbelianAnomalyCert` / `NonabelianAnomalyCert`, consumed by **C183**.

---

## 2. Domain-wall (SECONDARY)

### 2.1 Boundary index / anomaly inflow

- **Statement (shape):** a chiral zero mode is bound to the 4D domain wall; its gauge anomaly is
  cancelled by **inflow** of Chern–Simons current from the 5D bulk, so the *coupled* system is
  consistent and the boundary index equals the bulk topological data.
- **Primary sources:**
  - Callan, Harvey, *Anomalies and fermion zero modes on strings and domain walls*,
    Nucl. Phys. B **250** (1985) 427. — inflow mechanism.
  - Kaplan, *A method for simulating chiral fermions on the lattice*, Phys. Lett. B **288** (1992) 342
    [hep-lat/9206013]. — lattice domain-wall realization.
  - Shamir, Nucl. Phys. B **406** (1993) 90 [hep-lat/9303005]; Furman, Shamir, Nucl. Phys. B **439**
    (1995) 54 [hep-lat/9405004]. — boundary formulation used in practice.
- **[SOURCE OBLIGATION]** the *exact* lattice statement of "boundary index = bulk level" (continuum
  inflow is rigorous; the lattice version is usually argued via the overlap limit, §2.2).
- **Lean certificate:** `BoundaryIndexInflowCert`, consumed by **C159** (domain-wall branch).

### 2.2 Effective-overlap equivalence

- **Statement:** as the fifth dimension `L_s → ∞`, the 4D effective Dirac operator of the domain-wall
  /truncated-overlap construction converges to the Neuberger overlap operator with kernel `H_W`
  (`D_eff(L_s) → D_ov`). This is what *imports* §1.1–§1.4 into the domain-wall branch.
- **Primary sources:**
  - Neuberger, *Vectorlike gauge theories with almost massless fermions on the lattice*
    [hep-lat/9710089]; *Bounds on the Wilson Dirac operator* / truncated overlap.
  - Kikukawa, Noguchi, *Low energy effective action of domain-wall fermion and the Ginsparg–Wilson
    relation* [hep-lat/9902022].
  - Borici [hep-lat/9909057]; Edwards, Heller, Phys. Rev. D **63** (2001) 094505 [hep-lat/0005002].
- **[SOURCE OBLIGATION]** the *mode of convergence* (operator norm vs. matrix-element vs. on a fixed
  admissible background) and the rate.
- **Lean certificate:** `DomainWallOverlapEquivCert`, consumed by **C159/C184**.

### 2.3 Residual-mass control

- **Statement (shape):** the explicit chiral-symmetry breaking of finite-`L_s` DWF is summarized by a
  **residual mass** `m_res`, bounded by the near-zero spectral density of `H_W` and decaying in `L_s`
  (exponentially if `H_W` has a gap, power-law `~1/L_s` if the density at the origin is nonzero).
- **Primary sources:**
  - Furman, Shamir [hep-lat/9405004] (origin of `m_res`).
  - RBC/UKQCD residual-mass analyses (e.g. arXiv:0804.0473).
  - Brower, Neff, Orginos, *The Möbius domain wall fermion algorithm* [arXiv:1206.5214] (improved
    `m_res` scaling).
- **[SOURCE OBLIGATION]** the *quantitative* bound `m_res ≤ f(L_s, ρ(0))` and its hypotheses.
- **Lean certificate:** `ResidualMassControlCert`, consumed by **C183/C184** (it bounds the anomaly /
  index error of the secondary branch).

### 2.4 Locality

- **Statement:** the domain-wall locality reduces, in the `L_s → ∞` limit, to overlap locality (same
  admissibility), together with exponential localization of the chiral mode along the fifth direction
  `s` (rate set by the transfer-matrix gap).
- **Primary source:** same admissibility analysis as §1.3 [hep-lat/9808010] via §2.2; plus the
  transfer-matrix localization in Kaplan/Shamir.
- **Lean certificate:** reuse `OverlapLocalityCert` composed with `DomainWallOverlapEquivCert`;
  consumed by **C184**.

---

## 3. Adams / staggered overlap (OPTIONAL, LATER)

- **Extra theorem needed (taste-index):** the staggered Dirac operator carries a 4-fold *taste*
  degeneracy; the index theorem requires the **spin–taste chirality** `Γ₅₅ = γ₅ ⊗ ξ₅` and a
  **flavored mass term** that splits the four tastes, so that the *taste-singlet* sector gives
  `index = Q`.
- **Primary sources:**
  - Adams, *Theoretical foundation for the index theorem on the lattice with staggered fermions*,
    Phys. Rev. Lett. **104** (2010) 141602 [arXiv:0912.2850].
  - Adams, *Staggered overlap fermions*, Phys. Lett. B **699** (2011) 394 [arXiv:1008.2833].
  - Hoelbling, *Single flavor staggered fermions*, Phys. Lett. B **696** (2011) 422
    [arXiv:1009.5362].
- **[SOURCE OBLIGATION]** the exact form of the flavored mass term, the spin–taste `Γ₅₅`
  normalization, and the taste-singlet index statement (this is the *only* additional ingredient
  beyond §1 if the staggered route is taken).
- **Lean certificate:** `StaggeredTasteIndexCert`, consumed by **C159** (staggered branch only).

---

## 4. Lean / API certificate map

All certificate *statements* live in `RequestProject/GateC1SourceMap.lean`. They are encoded as
Lean `structure`s (interfaces), **not** raw assumptions: an inhabitant of each structure is exactly a bundle
of the external facts, so the structure faithfully records the source obligation without asserting
it. The gate-to-certificate routing:

| Certificate (Lean) | Encodes | Gate slot |
|---|---|---|
| `GinspargWilsonCert` | §1.2 GW relation | C159 / C183 |
| `LatticeIndexCert` | §1.1 exact index theorem | C159 |
| `OverlapLocalityCert` | §1.3 admissibility ⇒ locality | C184 |
| `AbelianAnomalyCert` | §1.4 U(1) anomaly cancellation | C183 |
| `NonabelianAnomalyCert` | §1.4 `d^{abc}` cancellation | C183 |
| `BoundaryIndexInflowCert` | §2.1 boundary index / inflow | C159 (DW) |
| `DomainWallOverlapEquivCert` | §2.2 `D_eff → D_ov` | C159 / C184 (DW) |
| `ResidualMassControlCert` | §2.3 `m_res` bound | C183 / C184 (DW) |
| `StaggeredTasteIndexCert` | §3 taste-singlet index | C159 (staggered) |

Each structure carries its citation and a `[SOURCE OBLIGATION]` docstring.

---

## 5. Convention hazards (must be pinned before any certificate is instantiated)

1. **γ₅ vs Γ_K / Γ₅₅.** Overlap uses ordinary spin `γ₅`. Staggered uses the **spin–taste** operator
   `Γ₅₅ = γ₅ ⊗ ξ₅` (sometimes written `Γ_K`); they are *different operators* and the index formula
   uses the taste-singlet one. Do not mix.
2. **Chirality / index sign.** `index = n₋ − n₊` vs `n₊ − n₋`, and whether `index = +Q` or `−Q`,
   varies by author. Lüscher's `Tr(γ₅(1 − aD/2))` fixes one convention; HLN may differ by a sign.
   Pin one convention for C159 and make every certificate state it explicitly.
3. **Mass parameter range.** Overlap kernel mass `m₀` (a.k.a. domain-wall height `M₅`): the
   single-massless-flavour window is `0 < m₀ < 2`; `(2,4),(4,6),(6,8)` give 4,6,4 species
   (doublers). Beware `m₀` (dimensionless) vs `a·M` normalizations.
4. **Admissibility bound `ε`.** `‖1 − U(p)‖ < ε` with HJL sufficient constant `ε ≤ 1/30` — this is
   *not tight*; it is the value that guarantees the spectral gap of `H_W²` used in the locality proof.
   Treat the specific number as a source obligation.
5. **Normalization of the index / `Tr γ₅`.** The `(a/2)` factor and the `(1 − aD/2)` insertion are
   essential; a missing factor silently breaks `index = Q`.
6. **Hypercharge / charge normalization.** The abelian anomaly conditions `Σ q³ = 0`, `Σ q = 0`
   require a fixed charge normalization (integer charges vs `Y/2` vs `Y`); the cubic condition is
   *not* invariant under rescaling unless applied consistently, and the linear (mixed-gravitational)
   condition must use the same normalization.

---

## 6. Recommendation: what to formalize / cite first

Consistent with **C179** (Wilson/Neuberger first, domain-wall second):

1. **First: `GinspargWilsonCert` + `LatticeIndexCert` (§1.2 → §1.1).** This is the cleanest, purely
   *algebraic* exact result (GW relation ⇒ exact index), it underwrites everything else, and it is a
   genuine theorem rather than an approximation. Cite Ginsparg–Wilson 1982, Neuberger 1998,
   HLN 1998, Lüscher 1998.
2. **Second: `OverlapLocalityCert` (§1.3).** Required to make `sign(H_W)` and hence `D` well defined;
   cite Hernández–Jansen–Lüscher 1999. Pin the admissibility bound.
3. **Third: anomaly source shape (`AbelianAnomalyCert`, then `NonabelianAnomalyCert`, §1.4).** Cite
   Lüscher 1999/2000. This is the C183 deliverable proper.
4. **Then the domain-wall branch** (`DomainWallOverlapEquivCert`, `ResidualMassControlCert`,
   `BoundaryIndexInflowCert`) as the secondary certificate, importing §1 via the overlap limit.
5. **Defer staggered** (`StaggeredTasteIndexCert`) unless the staggered cost profile is explicitly
   requested; it adds the taste-index obligation (Adams 2010/2011) on top of §1.

> **Bottom line.** Formalize the GW⇒index algebraic certificate first (it is provable in the abstract
> and is the load-bearing exact statement); cite locality and anomaly next as structured source
> obligations; bring in domain-wall and staggered as composite certificates that reduce to §1.
