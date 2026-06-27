# C17/C18 audit: spectral-graph species counting and flavored chirality for Gate C zeros

No-build audit/strategy deliverable for Wave 7. Scope: sharpen Gate C beyond
flat coefficient-vector / momentum-symbol determinant zeros using (a) spectral-graph
species counting (Yumoto–Misumi arXiv:2112.13501) and (b) modified/flavored
chirality diagnostics (Basak–Chakrabarti–Kishore arXiv:2501.10336; Catterall
arXiv:2311.02487), against the existing minimally doubled pack (Misumi
2512.22609, Golterman–Shamir 2505.20436, Weber 2312.08526, Weber 2502.16500,
Capitani–Weber–Wittig 0910.2597).

Companion verified artifact: `RequestProject/TetrahedralNodalStructure_Draft.lean`
(every non-`sorry` theorem there compiles against Mathlib; see §8 and the
machine-checked branch count in §A).

---

## 0. Executive verdict (read first)

- **Gate C is still a live kill switch.** It has *not* been passed and *cannot*
  be passed by the current "retardedness avoids doublers" argument, which is a
  coefficient-vector statement. The decisive object is the determinant /
  mass-shell zero set `det(i D_+(q) + Γ_s Φ) = 0` (massless: `p(q)^2 = 0`).
- **There is a concrete, machine-checked failure of the naive picture.** On the
  tetrahedral frame the corner `q = (π,π,π,0)` has nonzero Clifford symbol
  `u ≠ 0` but `p(q)^2 = 0`. Enumerating all `{0,π}^4` corners, **exactly five**
  are real null branches: the physical `q = 0` plus the **four** permutations of
  `(π,π,π,0)`. This is verified in Lean by `decide` (`null_corner_count`,
  `ppp0_null`). The four nontrivial corners form a reduced, minimally
  doubled-style species set — not "one doubler per axis" (single-axis corners are
  gapped, `single_not_null`), and *not* the full `(π,π,π,π)` (gapped,
  `pppp_not_null`).
- **Ordinary chirality `Γ_s` is the wrong diagnostic here**, for exactly the
  reason BCK warn about: at minimally doubled / graph-native nodes the naive
  index can be zero (mirror cancellation) while a real species imbalance exists.
  A **flavored chirality `Γ_f`** built from the tetrahedral taste structure is
  the natural diagnostic.
- **Recommended Gate C status label:** `PENDING → FATAL-FOR-NAIVE-FLAT`. The
  flat tetrahedral operator, taken literally, carries four high-momentum null
  branches; it is releasable only if those four are *provably* removed/gapped/
  projected (Wilson-like term, Krein constraint, or domain-wall/overlap), and
  each removal must be entered in the Gate F counterterm/moduli ledger.

---

## 1. From the null-edge flat finite operator to a spectral-graph / matrix species problem

The flat retarded dual-soldered symbol is
```text
D_+(q) = Σ_a C_a (e^{i q_a} − 1)/h = c(p(q)),
p(q)   = h^{-1} Σ_a (e^{i q_a} − 1) α^a,     u_a := e^{i q_a} − 1.
```
Two distinct "null" objects must be separated:

1. **Coefficient-vector zero:** `p(q) = 0`, i.e. `u ∈ ker(α-map)`. Retardedness
   (the `α^a` form a basis) kills extra zeros *of this kind*. This is what the
   old "no doublers" claim actually proved.
2. **Determinant / mass-shell zero:** `det c(p(q)) = 0`, i.e. (4D Dirac form)
   `p(q)^2 = 0`. In Lorentzian signature a nonzero null vector has vanishing
   determinant, so this set is strictly larger than (1).

**Translation to a spectral-graph problem (Yumoto–Misumi frame).** Treat the
decorated null-tetrad graph `(V, E, ℓ_a, α^a, h_a, U_a, J_x, Γ_s, χ_E, Φ_x)` as a
finite weighted directed graph and form the *finite Dirac matrix*
`𝔻 = i D_N + Γ_s Φ` on `ℂ^{|V|} ⊗ (spin) ⊗ (internal)`. Species counting becomes
a **nullity problem for a family of finite matrices**:

- On a periodic box `(L)^4`, `𝔻` block-diagonalizes over the discrete momenta
  `q ∈ (2π/L · ℤ)^4`. Each block `𝔻(q)` is a finite matrix; the species set is
  `{ q : det 𝔻(q) = 0 }` together with the kernel data at each such `q`.
- On a *non-torus* graph (boundary, defect, irregular tetrahedralization) there
  is no momentum label. Then the Yumoto–Misumi message applies directly:
  species/zero-mode counting is the **graph nullity** `dim ker 𝔻`, which can pick
  up contributions that are topological (depend on graph homology / boundary)
  rather than kinematical.

So the Gate C object is a *pair*: (i) the torus mass-shell zero set (kinematics),
and (ii) the finite-graph nullity and its dependence on topology/boundary
(graph-native species). Item (i) is what the verified Lean enumeration computes
on the high-symmetry corners; item (ii) is the new experiment proposed in §B.

---

## 2. Branch data to collect beyond `det(i D_+(q) + Γ_s Φ) = 0`

Solving the determinant equation is necessary but not sufficient. For each zero
`q*` (or each graph kernel vector) collect:

| Field | Meaning | Why |
| --- | --- | --- |
| `q*` / kernel id | location (momentum) or graph kernel vector | locate the branch |
| `coeff_zero?` | is `p(q*) = 0` (coefficient-level) or only `p(q*)^2 = 0`? | separates real no-go from kinematics |
| `Re/Im` class | real-energy vs complex-energy branch | complex ⇒ instability risk |
| `low/high q` | is `q*` near `0` (physical) or a Brillouin corner? | doubler vs physical pole |
| `kernel dim` | algebraic + geometric multiplicity of the zero | taste multiplicity |
| `Γ_s sign` | spacetime chirality eigenvalue / `tr Γ_s` on kernel | naive index |
| `Γ_f sign` | **flavored** chirality eigenvalue / `tr Γ_f` on kernel | true species imbalance |
| `χ_E grade` | internal grading eigenvalue | left/right internal sector |
| `form deg` | Kähler–Dirac form degree of the mode | KD taste/anomaly bookkeeping |
| `Krein sig` | `J`-norm sign of the mode; multiplicity after doubling | ghost vs physical |
| `Φ-lift?` | does the mass block `+Φ²` lift this zero or preserve it? | does Higgs gap it? |
| `topology?` | does nullity change with graph topology/boundary? | graph-native vs kinematical |
| `counterterm` | what operator removes it; fixed/symmetry-forbidden/tuned/free | Gate F moduli impact |
| `verdict` | one of the eight classes in §3 | classification |

The last column closes the loop into the zero-classification table schema
(Deliverable 1, §6).

---

## 3. Classification of high-momentum null branches

Every zero must be assigned exactly one label (Working Plan §23.1 list, here
operationalized with decision criteria):

1. **Physical pole** — `q*` near `0`, real, single, correct `Γ_s`/`χ_E`,
   `Φ`-block behaves as a mass. Accept.
2. **Physical doubler** — extra real low-energy pole degenerate with (1) in the
   continuum limit; opposite naive chirality. *Fatal* unless removed.
3. **Kinematical propagator zero** — `p(q)^2 = 0` with `p(q) ≠ 0`, at a Brillouin
   corner, *not* surviving as a propagating pole after Krein/physical projection
   (Golterman–Shamir 2505.20436: propagator zeros as kinematical singularities).
   This is the natural candidate label for the four `(π,π,π,0)` corners — **but
   the label must be earned**, by showing they have no physical residue / are
   gapped after `+Φ²` or a Wilson-like term.
4. **Graph-topological nullity** — kernel dimension that changes with graph
   homology/boundary (Yumoto–Misumi). Not a momentum doubler; an index/boundary
   effect. Track separately; may be benign or an artifact.
5. **Boundary artifact** — nullity present only with specific boundary
   conditions; absent on the torus. Removable by BC choice; record as such.
6. **Gapped taste/species partner** — real but gapped by `Φ²`/species-splitting
   mass (Misumi 2512.22609 single-Weyl targets). Acceptable if the gap is
   `O(1/h)` (decouples) and does not need a tuned counterterm.
7. **Complex instability / ghost** — `Im(energy) ≠ 0` in the physical sector, or
   negative Krein norm leaking into observables. Fatal (Feinberg–Riser
   2109.09221: Krein self-adjointness ≠ real spectrum; Chernodub 1701.07426 as
   warning).
8. **Redesign trigger** — an unavoidable physical doubler, persistent
   high-momentum massless pole, or instability not removable without a free/tuned
   counterterm. Forces operator redesign.

**Current reading of the four `(π,π,π,0)`-type corners:** candidate **(3)** or
**(6)**, *provisionally*. They are real, high-momentum, `u ≠ 0`, mass-shell-null.
Until a residue/gapping computation is done they cannot be declared benign;
defaulting them to "harmless cutoff artifact" is exactly the overclaim the audit
forbids.

---

## 4. How ordinary chirality fails as a diagnostic

Ordinary spacetime chirality `Γ_s` (with `Γ_s² = 1`, `{Γ_s, C_a} = 0`,
`[Γ_s, ∇_a] = 0`, `[Γ_s, Φ] = 0`) is the right grading for the *continuum*
massless operator. It fails as a Gate C zero-mode diagnostic in three ways
documented in the literature:

- **Mirror cancellation (BCK 2501.10336).** Minimally doubled spectra carry
  paired nodes of opposite `Γ_s`. The naive index `tr(Γ_s P_zero)` then sums to
  zero even when there is a genuine, physically inequivalent species pair. A
  vanishing naive index is *not* evidence of no doubling.
- **Broken/anticommutation assumptions at corners.** The clean relations above
  are continuum-symbol relations. At a Brillouin corner the *finite* operator's
  effective Clifford structure can violate `{Γ_s, D_+(q*)} = 0`, so `Γ_s` does
  not even act as a chirality on that kernel; its eigenvalue is not the right
  label.
- **Form-degree / Kähler–Dirac mismatch (Catterall 2311.02487; Butt–Catterall–
  Pradhan–Toga 2101.01026).** When the operator is cochain/form-degree-native,
  the natural grading is the KD form-degree parity `(-1)^{deg}`, not `Γ_s`. The
  residual `Z_4` KD anomaly and flavor-count constraints are invisible to `Γ_s`.
  Reduced KD (Catterall) shows that trying to halve taste can hide a gauge-measure
  / mirror problem; `Γ_s` will not see it.

Conclusion: at minimally doubled or graph-native zeros, `Γ_s` can be *blind*
(index 0) or *ill-defined* (does not anticommute). A different grading is needed.

---

## 5. A natural modified / flavored chirality for the null-edge architecture

The null-edge architecture has *four* commuting/grading-like structures already:
spacetime chirality `Γ_s`, internal grading `χ_E`, Krein metric `J`, and
Kähler–Dirac form degree `deg`. The flavored chirality should be assembled from
the **taste structure of the tetrahedral null frame**, mirroring how
Karsten–Wilczek/Boriçi–Creutz flavored chirality `Γ_f = Γ_s ⊗ (taste)` is built
(Weber 2312.08526, 2502.16500).

Proposed `Γ_f`:
```text
Γ_f := Γ_s · T,
```
where `T` is a **taste involution** acting on the four-corner species index,
defined by the corner-permutation symmetry of the inverse Gram
`G⁻¹ = -3/4 I + 1/4 J`. Concretely, the four null corners `(π,π,π,0)` and
permutations carry an `S_4`/taste label; `T` is the diagonal `±1` operator that
assigns `+1` to the would-be "physical-handed" taste sector and `−1` to its
mirror, chosen so that:
```text
Γ_f² = 1,
{Γ_f, D_+} = 0   on the null-corner kernel (even where {Γ_s, D_+} fails),
[Γ_f, Φ_taste] = 0,
tr(Γ_f P_null) = (signed species imbalance) ≠ 0   when a real imbalance exists.
```
Interaction with the other gradings (Deliverable: §6 of the prompt):

- **Krein `J`.** Require `Γ_f^♯ = J Γ_f† J = ±Γ_f`. The doubled operator
  `D_dbl = [[0, D_-],[D_+,0]]` should commute or anticommute with
  `Γ_f,dbl = Γ_f ⊕ (±Γ_f)` consistently; the relative sign decides whether `Γ_f`
  is a symmetry or an anomaly of the doubled (retarded/advanced) operator. Do
  **not** infer real spectrum or stability from `J`-self-adjointness (§3.7,
  Feinberg–Riser).
- **Internal grading `χ_E`.** `Γ_f` is spacetime⊗taste; `χ_E` is internal. They
  should commute; the *physical* chiral charge is the joint eigenvalue
  `(Γ_f, χ_E)`. The Higgs/Yukawa block `+Φ_H²` must be `χ_E`-odd (Roadmap
  GradedSquare) — that is what makes `+Φ²` (not `−Φ²`) the correct sign.
- **Kähler–Dirac form degree.** If the operator is genuinely cochain-native,
  `Γ_f` should reduce on-shell to (or be intertwined with) the KD parity
  `(-1)^deg`; mismatch between `Γ_f` and `(-1)^deg` is itself a diagnostic of a
  KD-type anomaly (Catterall; BCPT). This is the Gate H hook.

This is a *proposal*, not a theorem: the existence of a `Γ_f` with all four
bullet properties is **C18-1/C18-2** below and must be proved on the concrete
finite operator.

---

## 6. Deliverable 1 — Gate C zero-classification table schema

Machine-readable schema (one row per zero / kernel vector):
```text
{
  "id":            string,          // momentum tag or graph kernel id
  "q":             [int x dim] | "graph",
  "coeff_zero":    bool,            // p(q)=0 (true) vs only p(q)^2=0 (false)
  "energy_class":  "real" | "complex",
  "momentum_band": "low" | "high",  // near 0 vs Brillouin corner
  "kernel_dim":    int,             // geometric multiplicity
  "alg_mult":      int,             // algebraic multiplicity
  "gamma_s":       int,             // tr Γ_s on kernel (naive index)
  "gamma_f":       int,             // tr Γ_f on kernel (flavored index)
  "chi_E":         int,             // internal grading eigenvalue
  "form_deg":      int | null,      // KD form degree
  "krein_sig":     "+" | "-" | "mixed",
  "krein_mult":    int,             // multiplicity after J-doubling
  "phi_lift":      "lifted" | "preserved",  // effect of +Φ^2
  "topology_dep":  bool,            // nullity changes with graph topology
  "boundary_dep":  bool,            // nullity changes with BC
  "counterterm":   { "op": string, "status": "fixed"|"symmetry-forbidden"|"tuned"|"free" } | null,
  "class":         "physical-pole" | "physical-doubler" | "kinematical-zero"
                 | "graph-topological-nullity" | "boundary-artifact"
                 | "gapped-taste-partner" | "complex-instability-ghost"
                 | "redesign-trigger",
  "verdict":       "RELEASED" | "PENDING" | "FATAL-FOR-NAIVE-FLAT" | "REDESIGN-REQUIRED"
}
```
Gate C is `RELEASED` only if every row is `physical-pole`, `gapped-taste-partner`
(with `O(1/h)` gap and non-`free`/non-`tuned` counterterm), `kinematical-zero`
(with no physical residue), or `boundary-artifact` (removable). Any
`physical-doubler`, `complex-instability-ghost`, or `redesign-trigger` row, or any
`free`/`tuned` counterterm, blocks release.

---

## 7. Deliverable 2 — proposed spectral-graph nullity experiment

A finite-matrix protocol runnable *before any continuum interpretation*:

**Stage 0 (verified, done here).** High-symmetry torus corners `{0,π}^4`:
enumerate `p(q)^2`, classify null vs gapped. Verified in Lean: five null corners,
four nontrivial `(π,π,π,0)`-type (§A). This is the ground truth the larger sweep
must reproduce.

**Stage 1 — torus branch sweep.** On a periodic box `L^4` (start `L = 4, 6, 8`),
for each discrete `q` build `𝔻(q) = i D_+(q) + Γ_s Φ` and record `det 𝔻(q)`, its
kernel, and every column of the §6 schema. Outputs: counts of (real massless,
massive, high-momentum null, complex) branches; multiplicities after Krein
doubling; `Γ_s` vs `Γ_f` indices per branch.

**Stage 2 — graph-native nullity.** Replace the torus by (a) an open box (test
`boundary_dep`), (b) a single bulk tetrahedralization defect (test
`topology_dep`), (c) two distinct triangulations of the same region (test
triangulation-independence). For each, compute `dim ker 𝔻` directly (no momentum
label). A nullity that *moves* with topology/boundary is graph-native (Yumoto–
Misumi), not kinematical; flag it class `graph-topological-nullity` /
`boundary-artifact`.

**Stage 3 — mass-block and Wilson tests.** Turn on `+Φ²`; record which null
branches lift (`phi_lift`). Separately add a candidate Wilson-like / null-edge
species-splitting term and check whether the four corner branches gap at `O(1/h)`
*without* introducing a `free`/`tuned` counterterm.

**Stage 4 — flavored-chirality index.** Construct `Γ_f` (§5) on the finite
matrix; compute `tr(Γ_s P_null)` and `tr(Γ_f P_null)`. The decisive datum: if the
flavored index is nonzero while the naive one is zero, there is a real species
imbalance (BCK 2501.10336) and Gate C cannot be released by a `Γ_s`-blind
argument.

**Acceptance / failure** (Working Plan §20.5): accept iff exactly the desired
near-`q=0` branch survives and all corner branches are gapped/projected/removed
without free counterterms; fail on persistent high-momentum massless poles or
physical-sector complex modes.

---

## 8. Deliverable 3 — chirality / flavored-chirality decision tree

```text
ZERO at q* (det 𝔻(q*) = 0):
├─ Is energy complex in the physical (Krein-positive) sector?
│    └─ YES → class = complex-instability-ghost → verdict FATAL/REDESIGN. STOP.
├─ Is q* near 0 (low band)?
│    ├─ unique, correct Γ_s & χ_E, +Φ² acts as mass → physical-pole. ACCEPT.
│    └─ extra low-band pole (doubler) → physical-doubler → FATAL unless removed.
├─ Is q* a Brillouin corner (high band), with p(q*)^2 = 0 but p(q*) ≠ 0?
│    ├─ Does {Γ_s, 𝔻(q*)} = 0 hold on the kernel?
│    │    ├─ NO  → Γ_s is not a valid chirality here. Use Γ_f.
│    │    └─ YES → compute naive index tr(Γ_s P_null).
│    ├─ Compute flavored index tr(Γ_f P_null).
│    │    ├─ Γ_f-index ≠ 0  → REAL species imbalance → treat as physical-doubler.
│    │    │                    Needs index/domain-wall/overlap fix → REDESIGN
│    │    │                    or PENDING with explicit mechanism.
│    │    └─ Γ_f-index = 0  → no net imbalance; continue.
│    ├─ Does +Φ² (or Wilson-like term) gap it at O(1/h) w/o free/tuned ct?
│    │    ├─ YES → gapped-taste-partner. ACCEPT (log ct status).
│    │    └─ NO  → does it carry a physical residue after Krein projection?
│    │             ├─ NO  → kinematical-zero (Golterman–Shamir). ACCEPT.
│    │             └─ YES → physical-doubler → FATAL/REDESIGN.
├─ Does nullity depend on graph topology or boundary?
│    ├─ boundary only → boundary-artifact → ACCEPT (record BC).
│    └─ topology     → graph-topological-nullity → investigate KD/index origin.
└─ Otherwise → redesign-trigger.
```

---

## 9. Deliverable 4 — Lean theorem statements (host: `TetrahedralNodalStructure.lean`)

The **verified** finite core (compiles against Mathlib, see
`RequestProject/TetrahedralNodalStructure_Draft.lean`):

```lean
-- Determinant-level ≠ coefficient-level: a real null branch with nonzero symbol.
theorem ppp0_null : msShell (fun i => decide (i.val ≠ 3)) = 0 := by decide
theorem ppp0_coeff_nonzero : coeffVec (fun i => decide (i.val ≠ 3)) ≠ 0 := …

-- Branch count: exactly five real null corners of {0,π}^4 (q=0 + four (π,π,π,0)).
theorem null_corner_count :
    (Finset.univ.filter (fun b : Fin 4 → Bool => msShell b = 0)).card = 5 := by decide

-- The naive "doubler per axis" / all-π pictures are both wrong.
theorem pppp_not_null   : msShell (fun _ => true) ≠ 0 := by decide
theorem single_not_null : msShell (fun i => decide (i.val = 0)) ≠ 0 := by decide
```

The **next Gate C targets** (state in the host file once `D_+`, `Γ_s`, `Φ`, `J`,
`Γ_f` are defined there; leave as `by sorry` until then — do not add as axioms):

```text
-- C-Det: general mass-shell form factorization
theorem msShell_eq_quad (q) : msShell q = (Σ u_a)^2 − 3·Σ u_a^2     -- (proved core; generalize off-corners)

-- C18-1: flavored chirality exists and anticommutes on the null set
theorem Gamma_f_involutive : Γ_f^2 = 1
theorem Gamma_f_anticomm_on_null :
    ∀ q ∈ nullCorners, AntiComm Γ_f (D_+ q)        -- even where {Γ_s, D_+ q} ≠ 0

-- C18-2: ordinary chirality is blind, flavored chirality is not
theorem naive_index_zero  : tr (Γ_s ∘ P_null) = 0
theorem flavored_index_ne : tr (Γ_f ∘ P_null) ≠ 0   -- ⇒ real species imbalance

-- C-Krein: J-self-adjoint doubling WITHOUT stability (paired with counterexample)
theorem Ddbl_J_selfadjoint : (D_dbl)^♯ = D_dbl
theorem J_selfadjoint_not_real_spectrum :
    ∃ M, M^♯ = M ∧ ¬ (spectrum ℝ M = spectrum ℂ M)   -- overclaim guard

-- C-Phi: mass block lifts the physical pole but classify each corner's lift
theorem phi_lifts_origin   : 0 ∉ kernel (D_+ 0 + Γ_s Φ)         -- with Φ ≠ 0
theorem corner_lift_status : ∀ q ∈ nullCorners, Lifts (Γ_s Φ) q ∨ Preserved (Γ_s Φ) q

-- Gate H hook: form-degree vs flavored chirality mismatch = KD anomaly signal
theorem KD_parity_vs_Gamma_f : (KDparity = Γ_f) ∨ (KD anomaly obstruction)
```

What is provable *finitely now* vs later:

- **Finite/decidable now:** all of `ppp0_null`, `null_corner_count`,
  `pppp_not_null`, `single_not_null`, and any `decide`/`native_decide` enumeration
  over `{0,π}^4` or small `L^4` boxes. The `Γ_f` index theorems become finite
  `decide` facts once `Γ_f` is given as an explicit matrix.
- **Linear-algebra (Mathlib) now:** `Ddbl_J_selfadjoint`,
  `J_selfadjoint_not_real_spectrum`, `Gamma_f_involutive` — finite-dimensional,
  no analysis.
- **Needs the host operator definitions:** everything mentioning `D_+`, `Φ`,
  `P_null` concretely; straightforward once `PhysicsSM` supplies them.
- **Analytic / continuum (Gate D, not C):** any statement about the `h → 0`
  limit, propagating poles, or physical residues. Keep out of Gate C.
- **Manuscript-only (not Lean):** the *interpretation* of a kinematical zero as
  "benign", which requires the residue argument plus literature comparison.

---

## 10. Deliverable 5 — verdict: is Gate C still a possible kill switch?

**Yes — Gate C remains a genuine kill switch, and it is currently open.**

- The flat tetrahedral operator, taken literally, has **four** high-momentum
  null branches (machine-verified), beyond the physical `q=0` mode. "Retardedness
  avoids doublers" is downgraded to "avoids *coefficient-vector* doublers"; it
  says nothing about these four mass-shell zeros.
- Whether the four are fatal depends on data **not yet computed**: their Krein
  residue, their flavored-chirality index, and whether `+Φ²` or a null-edge
  Wilson-like term gaps them without a `free`/`tuned` counterterm. Each of those
  is a finite, runnable computation (Stages 1–4) — Gate C is *decidable in
  practice*, not stuck.
- Honest current label: **`FATAL-FOR-NAIVE-FLAT`, `PENDING` overall.** The naive
  flat operator is not releasable as-is. Safe downgrade if the four cannot be
  cleanly removed: keep the construction as a *null-edge reconstruction* with an
  explicit species-splitting mechanism (and its counterterm logged in the Gate F
  moduli ledger), **not** as a chiral-fermion prediction.
- A `Γ_s`-only "index = 0, therefore no doubling" argument must be rejected: by
  §4 it can be blind. Release requires the **flavored** index `tr(Γ_f P_null)` and
  the Krein/residue classification, per the §8 decision tree.

---

## Appendix A. Machine-checked finite facts

From `RequestProject/TetrahedralNodalStructure_Draft.lean`, all by `decide` over
`ℤ` (denominators cleared: tracked quantity is `4 h² p(q)² = (Σu)² − 3Σu²`):

| Corner `q` | `u = e^{iq}−1` | `4h²p(q)²` | null? | class |
| --- | --- | --- | --- | --- |
| `(0,0,0,0)` | `(0,0,0,0)` | `0` | yes (trivial) | physical point |
| `(π,π,π,0)` + 3 perms | three `−2`, one `0` | `0` | **yes** | high-momentum null (the 4) |
| `(π,0,0,0)` + perms | one `−2` | `−2` | no | gapped |
| `(π,π,0,0)` + perms | two `−2` | `−4` | no | gapped |
| `(π,π,π,π)` | `(−2,−2,−2,−2)` | `+4` | no | gapped |

Total real null corners in `{0,π}^4`: **5** (`null_corner_count`), of which **4**
are nontrivial high-momentum branches. `ppp0_coeff_nonzero` certifies the
`(π,π,π,0)` symbol is nonzero, so these are determinant/mass-shell zeros, not
coefficient-vector zeros.

## Appendix B. Source map

- Yumoto–Misumi 2112.13501 → §1 graph-nullity translation; §7 Stage 2.
- Basak–Chakrabarti–Kishore 2501.10336 → §4 mirror cancellation; §5/§8 flavored
  index `tr(Γ_f P_null)`.
- Catterall 2311.02487 → §4/§5 reduced KD, form-degree grading, mirror/gauge-
  measure warning; §9 Gate H hook.
- Golterman–Shamir 2505.20436 → §3 class (3) kinematical propagator zeros.
- Misumi 2512.22609 → §3 class (6) single-Weyl / species-splitting gap.
- Weber 2312.08526, 2502.16500; Capitani–Weber–Wittig 0910.2597 → §5 flavored
  chirality `Γ_f = Γ_s·T`; §3/§6 counterterm hazard (Boriçi–Creutz / Karsten–
  Wilczek).
- Feinberg–Riser 2109.09221; Chernodub 1701.07426 → §3/§5 Krein ≠ stability,
  complex-branch warning.
- Butt–Catterall–Pradhan–Toga 2101.01026 → §4/§9 KD `Z_4` anomaly, flavor-count.
