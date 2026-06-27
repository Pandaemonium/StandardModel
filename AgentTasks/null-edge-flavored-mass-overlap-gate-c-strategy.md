# Gate C v3 strategy: flavored mass / point splitting / Hermitian spectral flow

Task: C75 (Wave 18). Kind: no-build strategy/audit.

Context pack: `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`
Wave memo: `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`

Scope guardrails honored throughout: this report does **not** claim Gate C
release, does **not** assume locality of the overlap sign function, and does
**not** assume that the Creutz–Kimura–Misumi (CKM) construction transfers
automatically to the null-edge operator. Every coefficient/regulator choice is
classified `fixed` / `constrained` / `tunable` / `open`.

---

## 0. Starting facts (post-C21 / post-C64) that this strategy must respect

These are the live, kernel-checked facts the construction is built on top of.
They are constraints, not targets.

- **F1 (bare branch kernels are balanced, C21).** The flat tetrahedral
  null-edge Clifford symbol `c(p(q))` has, on each of the four high-momentum
  null branches, a **two-dimensional, chirality-balanced** kernel (one
  `Γ_s = +1` mode and one `Γ_s = -1` mode). Source:
  `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean`,
  `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean` (`naive_index_zero`). Hence
  the bare predicate `OperatorForcesAlignment bc := bc = g5` is **not**
  discharged by `D_+`; a single-sign branch chirality only emerges after a
  projection. (Decision log D6.)

- **F2 (massive branch lifting algebra, C20).** For `M = i·Dp + Γ_s·Φ_H` with
  the Gate A relations `Γ_s² = 1`, `{Γ_s, Dp} = 0`, `Dp² = p²·1`,
  `[Γ_s, Φ_H] = 0`, `[Dp, Φ_H] = 0`, one has

  ```text
  M² = Φ_H² − p²·1.
  ```

  On a determinant-zero null branch (`p² = 0`): `M² = Φ_H²`, so the branch is
  lifted iff `Φ_H` is invertible (scalar `m`: iff `m ≠ 0`). Source:
  `PhysicsSM/Draft/NullEdgeMassiveBranchLifting.lean`.

- **F3 (nodal locus is not exhausted by branch lines, C64).** The certified
  nodal components (origin + four branch lines `branchLineU a t`) do **not**
  exhaust the bare determinant-zero locus. There is an explicit off-branch
  Clifford-determinant zero

  ```text
  q⋆ = (2π/3, 0, 0, 4π/3),   qform(phaseU q⋆) = 0,   phaseU q⋆ ≠ 0,
       phaseU q⋆ ∉ ⋃_a branchLine a.
  ```

  Source: `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean`,
  `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean` (`offBranch_nonempty`).

- **F4 (`T_lin` misses the C64 witness).** The naive/linear species-split term
  (`g5`-type taste sign, `M_split = r·T` with the C45/C46 direction) gaps the
  four branch lines but does **not** gap `q⋆`. The off-branch sector is genuinely
  inhabited and currently undischarged (`OffBranchSectorDischarged` is an open
  obligation). So any Gate C release that controls only the four branches is
  incomplete.

- **F5 (scalar Wilson positivity, Wave 17).** `W(q) := Σ_a (1 − cos q_a) ≥ 0`,
  with `W(q) = 0` on the real torus iff `q ≡ 0`. In particular `W(q⋆) = 3 > 0`
  (`cos(2π/3) = cos(4π/3) = −1/2`, `cos 0 = 1`). This is the global
  branch-lifting lemma. It is a **scalar** statement: it controls the
  determinant magnitude, not chirality, taste index, or Krein sign.

- **F6 (projected release decomposition, C59).** `ProjectedGateCRelease`
  already decomposes release into seven independent clauses: nodal-gap control,
  branch-projector well-definedness, one-dimensional projected kernel, projected
  chirality alignment, Krein positivity of the retained sector, ghost-zero
  safety, and species-splitting moduli status. Source:
  `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`. The v3 construction must
  *discharge* these clauses, not replace them.

**Central reading.** F1+F2 say a *scalar* mass lifts branches but cannot assign
branch chirality; F3+F4 say a *single global scalar regulator is needed to reach
off-branch zeros*; F5 supplies exactly that scalar; F6 says chirality/index/Krein
are separate clauses. Therefore the central operator must be the one object that
simultaneously carries **branch chirality + taste index** — the flavored mass —
with the scalar Wilson term demoted to the lemma that closes the determinant
magnitude everywhere off the origin.

---

## 1. The proposed `D_phys` construction family (exact statement)

Literature lane: CKM `1011.0761` (flavored-mass terms for minimally doubled
fermions) and `1110.2482` (index theorem and overlap from naive / minimally
doubled fermions via the Hermitian spectral flow of a point-split flavored-mass
Dirac operator). We adapt that playbook to the null-edge symbol, keeping the
Lorentzian/Krein structure as an explicit obstruction rather than assuming the
Euclidean result.

Define the family in four named layers. Notation: `q` = lattice momentum (real
torus coordinate), `Dp(q) = c(p(q))` = bare null-edge Clifford symbol, `Γ_s` =
spacetime chirality, `T_a` / `T_a^♯` = forward/backward unit shifts in null
direction `a`.

### Layer 0 — kinetic seed (fixed)

```text
D_0(q) := i · Dp(q),     Dp² = p²(q)·1,   {Γ_s, Dp} = 0.
```

Status: **fixed**. This is `D_+`, the null kinetic seed; FATAL-FOR-NAIVE-FLAT by
F1/F3 (it is not a release candidate on its own).

### Layer 1 — point-split projectors `P_a` (fixed shape, constrained signs)

For each null direction `a`, a momentum-space projector built from the symmetric
shift:

```text
P_a(q) := ½ (1 − cos q_a) · Π_a        (free-field form),
```

where `Π_a` is the branch-selecting idempotent for branch `a` (the C21
two-dimensional kernel projector at corner `a`). Position-space form (C79 lane):
`P_a` is realized by the finite link-dressed shift combination
`¼(2 − T_a − T_a^♯)` so it is a genuine point split, not a pointwise mass.

Status: shape **fixed** by the requirement "vanishes at origin, peaks at the BZ
corner"; the per-branch sign/orientation is **constrained** by the Gate A
sign/grading audit and tetrahedral symmetry; the overall normalization is
**tunable**.

### Layer 2 — flavored mass `M_flavored` and modified chirality `Γ_f`

```text
M_flavored(q) := M_0 · Σ_a s_a · P_a(q) · Γ_f,
Γ_f := Γ_s · T,            T = taste involution (Π_a-block sign pattern),
```

with branch signs `s_a ∈ {+1, −1}` chosen so that `M_flavored` assigns
**opposite** taste sign to mirror-paired branches — exactly the mechanism that
makes `flavoredIndex ≠ 0` while `naive_index = 0` in
`NullEdgeFlavoredChirality.lean`. See §3 for the `Γ_f` / `M_flavored` relation.

Status: structure **fixed** by F1 (must break the balanced kernel by taste, not
by `Γ_s` alone); `s_a` pattern **constrained** (Gate A audit + symmetry); overall
mass scale `M_0` **tunable** (a modulus until forced).

### Layer 3 — Hermitian kernel and `D_phys`

Form the Hermitian (Krein-Hermitian, see §6) kernel

```text
H(m; q) := J · ( D_0(q) + M_flavored(q) − m·1 ),     H = H^‡  (‡ = Krein-adjoint),
```

and read off `D_phys` either as the **spectral-flow / sign** operator

```text
D_phys^ov(q) := 1 + Γ_f · sign( H(m_0; q) )         (overlap form, Route OV)
```

or as the **projected retained-sector operator** (Route PR)

```text
D_phys^pr(q) := Π_phys(q) · ( D_0(q) + M_flavored(q) ) · Π_phys(q),
Π_phys(q) := spectral projector of H onto its Krein-positive retained branch.
```

Status: Route PR is the **near-term** target (finite, no `sign` function, no
locality claim). Route OV is the **aspirational** target and requires the gap
+ locality theorems of C78 before `sign(H)` is even well-defined as a local
operator. The regulator coefficient `r` (relating `M_flavored`/Wilson term to
the seed) remains a **modulus** (decision log D13).

**One-line summary of the family.**

```text
D_phys = projection/sign of  [ i·Dp  +  M_flavored(Γ_f, P_a, s_a, M_0)  −  m ],
with scalar Wilson W(q) used only to prove the magnitude lemma (§4),
not as the chiral object.
```

---

## 2. Role of the point-split projectors `P_a`

The `P_a` are what make the mass **flavored** rather than scalar. Three precise
roles:

1. **Momentum localization of the mass at BZ corners.** `P_a(q) ∝ (1 − cos q_a)`
   vanishes at the physical origin (so the leading Dirac symbol near `q = 0` is
   untouched, preserving the continuum limit) and is maximal at the branch
   corner `a`. This is the CKM point-split mechanism: the mass term is built from
   shifts, so it is `O(q²)` near the origin and `O(1)` at the doubler corners.

2. **Branch/taste resolution.** Each `P_a` selects one branch's two-dimensional
   balanced kernel (F1). Distributing opposite taste signs `s_a` across the
   `P_a` is exactly what converts the balanced kernel into a single retained
   chirality after projection (Layer 3).

3. **Gauge-covariance carrier (deferred to C79).** Because `P_a` is built from
   shifts `T_a`, gauge covariance is implemented by link-dressing the shifts
   (`T_a → U_a T_a`). This is the natural home for the Wave-17 gauge-covariance
   work, specialized to branch projectors.

Proposed theorem statements (Lean targets, abstract version in C77 API):

```text
P_a idempotent on branch a:        P_a(q) ∘ P_a(q) = P_a(q)·(1 − cos q_a)/normalization
P_a orthogonality:                 a ≠ b → P_a · P_b = 0   (on branch subspaces)
P_a origin-vanishing:              P_a(0) = 0
P_a corner-support:                P_a at corner a is the C21 kernel projector Π_a.
```

Status of `P_a`: **fixed shape**, **constrained signs**, **tunable normalization**,
**open** whether the link-dressed version stays a clean idempotent (C79).

---

## 3. `M_flavored` ↔ `Γ_f` relationship (precise)

The flavored chirality already exists in the repo:
`NullEdgeFlavoredChirality.lean` defines `Γ_f = Γ_s · T` with `T` the taste
involution, and proves `naive_index_zero` (the `Γ_s`-only index vanishes on the
null set) together with `flavored_index_ne_zero` (the `Γ_f` index does not).
The strategy ties `M_flavored` to `Γ_f` by the following algebraic contract,
mirroring the C20 lifting algebra (F2):

**Contract (intended theorem shape).** Assume the Gate A relations plus
`{Γ_s, Dp} = 0`, `T² = Π_B` on the branch subspace, `[T, Dp] = 0` on each branch
block, and `Γ_f = Γ_s·T`. Then with `M_flavored = M_0 Σ_a s_a P_a Γ_f`:

```text
(a) Γ_f² = 1   on the branch subspace        (from Γ_s² = 1, T² = Π_B, [Γ_s,T]=0);
(b) {Γ_f, Dp} = 0  per branch                (so Γ_f grades the kinetic seed);
(c) on branch a (p² = 0):
        (D_0 + M_flavored)² = (M_0 s_a (1−cos q_a))² · 1     (scalar block),
    i.e. the flavored mass lifts the branch exactly as the scalar mass in F2,
    but with a per-branch taste sign s_a carried by Γ_f;
(d) tr( Γ_f · Π_null ) = flavoredIndex(s) ≠ 0,   while  tr( Γ_s · Π_null ) = 0.
```

Item (c) is the key: **the *magnitude* of the lift is exactly the scalar Wilson
profile** `(1 − cos q_a)` (hence §4), while the *sign/index* that resolves the
balanced kernel is carried by `Γ_f` and the `s_a` pattern. This is the precise
sense in which scalar Wilson positivity is a supporting lemma and flavored mass
is the central object.

Relationship classification:

- `Γ_f = Γ_s·T`: **fixed** (already in repo).
- taste involution `T` block-sign pattern: **constrained** by Gate A
  sign/grading audit (D7) and by requiring (a)–(b).
- `s_a` branch-sign assignment: **constrained** (must make `flavoredIndex ≠ 0`).
- `M_0`: **tunable** modulus.
- whether `[T, Dp] = 0` holds *globally* (not just per-branch) on the actual
  null-edge symbol: **open** — this is a genuine computation, not an assumption.

---

## 4. Scalar Wilson positivity as a lemma (not the central operator)

Demoted role, stated as a lemma library that the flavored construction *consumes*:

**Lemma W1 (global positivity).** `∀ q, W(q) = Σ_a (1 − cos q_a) ≥ 0`.
**Lemma W2 (origin characterization).** `W(q) = 0 ↔ q ≡ 0 (mod 2π)` on the real
torus. (Wave 17 target; do not re-prove here, cite.)
**Lemma W3 (C64 witness control).** `W(q⋆) = 3 > 0` (C76 target,
`wilsonScalar_c64Witness_eq_three`).
**Lemma W4 (magnitude lift).** For any regulator/mass whose per-branch lift
magnitude is bounded below by `c·W(q)` with `c > 0`, every non-origin real
determinant zero of the seed receives strictly positive lift; in particular `q⋆`
is lifted (`c64Witness_not_missed_by_wilsonLowerBound`, C76).

**How the flavored construction uses these.** By §3(c), the flavored-mass lift
magnitude on branch `a` is `(M_0 s_a (1 − cos q_a))²`, and more generally the
determinant magnitude of `D_0 + M_flavored` is bounded below by
`M_0²·(min_a stuff)·W(q)` away from the origin. So:

```text
W-lemmas  ⟹  |det(D_0 + M_flavored)| > 0  for all q ≠ 0 on the real torus,
          ⟹  the only surviving real-torus zero is the physical origin,
          ⟹  the off-branch sector (F3/F4) is closed at the level of magnitude.
```

This is exactly the part `T_lin` failed at (F4). **What the Wilson lemma does
NOT do**, and must not be claimed to do:

- it does not assign branch chirality (that is `Γ_f`, §3);
- it does not compute the taste/flavored index (that is `flavoredIndex`, §3(d));
- it does not establish Krein positivity of the retained sector (§6);
- it does not establish ghost-zero safety or locality.

So scalar Wilson positivity is the **branch-and-off-branch magnitude-lifting
lemma**; the flavored mass is the central operator that additionally fixes
chirality, index, and the retained physical sector.

Coefficient status: `r` / `c` (Wilson-to-seed coupling) **tunable** modulus;
positivity of `c` **constrained** (`c > 0` required); the claim that the bound is
*exactly* `W` rather than merely `≥ c·W` is **open** for the full symbol.

---

## 5. Parts that should become Lean proof targets

Ordered easiest → hardest; finite/algebraic first.

1. **C76 — off-branch witness magnitude lift (in flight).**
   `wilsonScalar_c64Witness_eq_three`, `regulator_lifts_c64Witness_of_nonzero_coeff`,
   `c64Witness_not_missed_by_wilsonLowerBound`. Finite trig/algebra. *Lean.*

2. **C77 — abstract flavored spectral-flow API (in flight).**
   `BranchProjectorSystem`, `TasteSignSystem`, `ModifiedChiralityData`,
   `FlavoredMassData`, `HermitianSpectralFlowKernel`, `FlavoredIndexReady`;
   plus the algebraic theorems `Γ_f² = 1` on the branch subspace, `T² = Π_B`,
   and `FlavoredIndexReady → (chirality clause of ProjectedGateCRelease)`. *Lean.*

3. **`P_a` idempotent/orthogonality/origin-vanishing** (§2 theorem block).
   Finite linear algebra over the C21 kernel projectors. *Lean.*

4. **`M_flavored` lifting identity** §3(c): `(D_0 + M_flavored)² = (M_0 s_a (1−cos q_a))²·1`
   on each branch. Direct generalization of `NullEdgeMassiveBranchLifting`. *Lean.*

5. **Flavored index nonvanishing on the full null set**: extend
   `flavored_index_ne_zero` from the model matrices to the actual branch
   projectors. *Lean* (may need the C21 projectors as explicit data).

6. **Global magnitude bound** §4: `|det(D_0 + M_flavored)| ≥ M_0²·c·W(q)` on the
   real torus, hence nonzero off the origin. Partly *Lean* (finite per-branch),
   partly **analytic** if stated over the continuous torus (see §6).

7. **Discharge of `OffBranchSectorDischarged`** for the flavored operator: supply
   the `CompositeRemovable` certificate at `q⋆` (and, ideally, sector-wide).
   *Lean*, reusing `NullEdgeOffBranchZeroSector` reduction.

8. **Finite Euclidean positive proxy** (C78 §5): a finite-volume Hermitian
   `H(m)` with a proven spectral gap, so `sign(H)` and the spectral projector
   `Π_phys` are well-defined on the model. *Lean* (finite), as the honest
   stand-in for the infinite-volume locality theorem.

Targets 1–5 are pure finite algebra and should be attempted first; 6–8 are where
analytic assumptions enter and should be staged behind explicit hypotheses.

---

## 6. Parts that remain analytic / locality / gauge-coupling assumptions

These must stay as **named hypotheses**, never silently assumed:

- **A1 (Hermitian-kernel gap).** Existence of a spectral gap of `H(m;q)` around
  `0` uniform in `q` (infinite volume). Without it `sign(H)` / `Π_phys` is not
  well-defined. Krein/Lorentzian subtlety: "Hermitian" must be Krein-`‡`-self-
  adjoint, and Krein-self-adjoint operators can have **complex** spectrum, so the
  Euclidean spectral theorem does **not** transfer. This is the central C78
  obstruction. Status: **open analytic assumption**.

- **A2 (overlap locality).** Even granting A1, `sign(H)` need not be local; locality
  requires an exponential-decay/analyticity estimate (Hernández–Jansen–Lüscher
  type). **Do not assume.** Status: **open analytic assumption**.

- **A3 (Krein positivity of retained sector).** That `Π_phys` selects a
  Krein-*positive* (ghost-free in the retarded double) subspace. Mirrors the K2
  criterion (`NullEdgeKreinPositiveReleaseCriterion`). Status: **open**; a
  per-branch finite proxy is a Lean target (target 8), the infinite-volume
  statement is an assumption.

- **A4 (gauge coupling / link dressing).** That the link-dressed `P_a`
  (`T_a → U_a T_a`) preserves idempotency, branch resolution, and does not
  introduce new propagator zeros or break tetrahedral symmetry uncontrollably.
  Status: **constrained/open** (C79 construction plan; new moduli expected).

- **A5 (ghost-zero safety after gauge).** Golterman–Shamir hazard: SMG-type
  propagator *zeros* can act as gauge-coupled ghost states (cf. `2311.12790`,
  `2505.20436` in the pack). Release predicate, not provable from magnitude
  lifting alone. Status: **hard release predicate**, partly Lean (C47/C48
  calculus), partly analytic.

- **A6 (continuum limit / single-cone accounting).** That near `q = 0` the
  flavored mass is irrelevant and the correct single Dirac cone with correct
  multiplicity survives (no double counting of Kähler–Dirac, chirality, and
  generation indices). Status: **open analytic assumption**.

Coefficient/regulator register (consolidated):

| Quantity | Status |
| --- | --- |
| `D_0 = i·Dp` kinetic seed form | fixed |
| `Γ_f = Γ_s·T` | fixed |
| `P_a ∝ (1 − cos q_a)` shape, origin-vanishing | fixed |
| taste involution `T` block pattern | constrained (Gate A + §3a/b) |
| branch signs `s_a` | constrained (flavoredIndex ≠ 0) |
| Wilson coupling `r`/`c` sign | constrained (`> 0`) |
| mass scale `M_0`, coupling `r`/`c` value | tunable moduli |
| Route PR vs Route OV choice | tunable (PR near-term) |
| `[T, Dp] = 0` globally on actual symbol | open |
| A1 gap / A2 locality / A3 Krein+ / A6 continuum | open |
| A4 link dressing keeps structure | constrained/open |
| A5 ghost-zero safety | open release predicate |

---

## 7. Release checklist for Gate C v3 (one page)

Gate C v3 may be **proposed for release only when every box is either a
kernel-checked Lean theorem or an explicitly named, accepted analytic
assumption.** Until then: **no Gate C release.**

```text
[ ] M0  Operator fixed.  D_phys construction family (§1) written down with a
        single chosen Route (PR near-term).                      [config]

— Finite / Lean clauses (must be theorems, not assumptions) —
[ ] L1  P_a idempotent, orthogonal, origin-vanishing.             (Lean, §2)
[ ] L2  Γ_f² = 1, {Γ_f, Dp} = 0 per branch, Γ_f = Γ_s·T.          (Lean, §3a/b)
[ ] L3  Flavored lift identity (D_0+M_flavored)² = (M0 s_a(1−cos q_a))²·1.
                                                                   (Lean, §3c)
[ ] L4  flavoredIndex ≠ 0 on the actual null set; naive index = 0. (Lean, §3d)
[ ] L5  W-lemmas W1–W4 incl. W(q⋆)=3 (C76).                        (Lean, §4)
[ ] L6  Magnitude bound ⇒ only real-torus zero is the origin.     (Lean+A, §4)
[ ] L7  Off-branch sector discharged at q⋆ (CompositeRemovable).  (Lean, §5.7)
[ ] L8  Finite Euclidean positive proxy: gapped H, well-defined
        Π_phys, projected kernel 1-dim, aligned chirality.        (Lean, §5.8)
[ ] L9  ProjectedGateCRelease conjunction discharged on D_phys
        data (the seven C59 clauses).                             (Lean, F6)

— Analytic / assumption clauses (must be NAMED and accepted, not hidden) —
[ ] A1  Hermitian-kernel spectral gap (Krein-aware).              (assumption)
[ ] A2  Overlap/sign locality estimate — NOT assumed automatically.(assumption)
[ ] A3  Krein positivity of retained sector (infinite volume).    (assumption)
[ ] A4  Link-dressed P_a preserve structure; symmetry-breaking
        moduli enumerated.                                        (assumption)
[ ] A5  Ghost-zero safety after gauge (Golterman–Shamir).         (release pred.)
[ ] A6  Continuum single-cone / no double-count accounting.       (assumption)

— Guardrails (binding) —
[ ] G1  No claim of overlap locality without A2 proved.
[ ] G2  No claim that CKM (1011.0761 / 1110.2482) transfers automatically;
        every transferred step re-derived for the null-edge symbol.
[ ] G3  Regulator coefficient r / mass scale M0 labeled modulus unless a later
        theorem forces them.
[ ] G4  Gate A sign/grading audit binding on T, Γ_f, s_a, M_flavored placement.
[ ] G5  Furey/Baez stays Gate H/internal support, not Gate C branch control.
[ ] G6  Claim label = regulated reconstruction / branch-control construction,
        NOT prediction, unless r and operator form are forced.
```

**Release verdict logic.** Gate C v3 releases iff (L1–L9 are sorry-free Lean
theorems) **and** (A1–A6 are explicitly stated as accepted hypotheses of the
release theorem, none silently discharged) **and** (G1–G6 hold). Anything less is
a **downgrade to reconstruction-only**: the construction stands as a regulated
branch-control model whose chiral/locality claims await A1–A6.

---

## Appendix: literature mapping (verify before relying)

| Source (pack) | Use in this strategy | Caveat |
| --- | --- | --- |
| CKM `1011.0761` | flavored-mass term shape for minimally doubled fermions → Layer 2 | Euclidean; transfer to Krein null-edge is open (G2) |
| CKM `1110.2482` | point-split flavored mass + Hermitian spectral-flow index → Layers 2–3, overlap from naive kernels | spectral flow assumes Hermiticity & gap (A1) |
| `2311.12790`, `2505.20436` | propagator-zero = gauge-coupled ghost warning → A5 | unitarity loss risk; informs ghost predicate |
| Repo `NullEdgeFlavoredChirality` | `Γ_f = Γ_s·T`, naive vs flavored index | model matrices; extend to actual projectors (L4) |
| Repo `NullEdgeMassiveBranchLifting` | `M² = Φ_H² − p²·1` lift algebra → §3c | scalar/matrix; flavored generalization is L3 |
| Repo `NullEdgeProjectedGateCRelease` | seven-clause release decomposition → checklist | clauses are the L8/L9 discharge targets |
| Repo `NullEdgeOffBranchZeroSector` | off-branch sector + discharge reduction → L7 | sector inhabited by q⋆, undischarged |
```
