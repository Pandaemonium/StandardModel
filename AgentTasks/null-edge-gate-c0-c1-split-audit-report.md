# Gate C0/C1 split strategy audit (Wave 20 / C87)

Date: 2026-06-27.

Task: `AgentTasks/null-edge-wave20-c87-gate-c-split-audit-aristotle-2026-06-27.md`.
Kind: no-build strategy/audit (report-only).

Context consumed (every file below was read against the live tree, not assumed):

- `AgentTasks/context-packs/gate-c-c0-c1-rawilson-20260627-20260627-080920.md`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
  (§§12–14, esp. 13.3–13.6 and the C0/C1 split + RA-Wilson lemma)
- `AgentTasks/null-edge-decision-log-2026-06-27.md` (D19: Gate C split into C0/C1)
- `AgentTasks/null-edge-pro-hard-problems-briefing-2026-06-27.md`
- `PhysicsSM/Draft/NullEdgeGateCSplit.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`
- `PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean`
- `AgentTasks/null-edge-taste-involution-origin-polarization-audit.md` (Wave 19 / C83)

This is an adversarial audit, not a proof. No Gate C release is claimed. The
guardrail of the task is honored directly: I check whether the C0/C1 split
*clarifies* or *hides* a Nielsen–Ninomiya / chiral-gauge obstruction.

---

## 0. Verdict

```text
SPLIT-VALID-BUT-C1-NEEDED-FOR-SM
```

The C0/C1/H split is a **correct and honest decomposition**, not a relabeling
trick, *provided the claim language in §5 is enforced*. It does the one thing a
good split must do: it pushes the Nielsen–Ninomiya / chiral-gauge obstruction
entirely into a single, explicitly-unsolved clause (C1) rather than diluting it
across the program. The RA-Wilson C0 lemma is a genuine theorem with genuine
value (it gaps every non-origin real-torus zero without classifying the zero
locus). But C0 is strictly weaker than a Standard-Model-facing release: it
produces **no chirality at the origin**, and the entire chiral-gauge content of
the mass program lives in C1, which remains open and is where the no-go pressure
is concentrated.

The split is therefore *not misleading* at the level of the Lean API and the
decision log, because the obstruction is named, kernel-guarded, and quarantined.
It *would become misleading* the instant a manuscript described a C0 result as a
"Gate C release." The verdict is conditional on the naming discipline of §5
being applied without exception.

---

## 1. What the split actually asserts (restated precisely)

From `NullEdgeGateCSplit.lean` and decision-log D19 / working-plan §13.6:

```text
Gate C0  (GateC0SpeciesHealthy):  external species health.
  origin branch retained;
  every non-origin real-torus branch gapped by an inverse-propagator mass gap;
  leading null-edge continuum symbol unchanged;
  free propagator-zero ghosts excluded.

Gate C1  (GateC1ChiralPhysicalRelease):  physical chiral release.
  physical chirality grading chosen;
  retained origin branch chiral in that grading;
  positive physical sector;
  ghost / gauge / Krein / counterterm clauses.

Gate H   (GateHCompatible):  internal finite SM algebra.
  internal spectrum legal; anomaly inherited; legal Phi_H blocks.
```

The Lean module already proves the *structural* facts that make the split
non-trivial:

- `stagedGateCReleased_of_layers` — a full release is exactly the conjunction
  C0 ∧ C1 ∧ H.
- `gateC0_alone_insufficient` — C0 plus ¬C1 ⟹ ¬(full release).
- `gateH_alone_insufficient` — H plus ¬C0 ⟹ ¬(full release).

These are tautological at the Prop level (they are projections/assemblies of a
record), but their *content* is the claim-boundary discipline: the type system
now refuses to call C0 a release. That is the right use of a proof assistant
here — it mechanizes the category boundary that D19 warns against.

---

## 2. Answers to the five questions

### Q1. Is "one healthy external Dirac cone (C0) + Gate-H chiral internal rep" sufficient, or must the external operator supply a single Weyl branch?

**The external operator (or its projected/overlap replacement) must supply the
single Weyl branch. C0 + Gate H is provably insufficient.** This is the crux,
and it is the Nielsen–Ninomiya content stated in coordinate-free form.

Reason — the factorization kills internal repair. Working-plan §14 records the
product structure the program actually has:

```text
H_total = H_N ⊗ H_F,   D_seed = i D_N ⊗ 1 + Γ_s ⊗ Φ_H,
A_F, χ_E, J_F act only on H_F;   branch projectors act only on H_N.
```

Because `χ_E` (the internal chirality) acts only on `H_F` and the branch/Dirac
data act only on `H_N`, the internal grading **commutes with everything external**.
The chiral index of a tensor product factorizes:

```text
ind(Γ_total) = ind_external(Γ_s on the retained branch) × tr(χ_E on H_F).
```

C21 (`null_kernel_both_chiralities`, re-used in the Wave-19 taste audit) fixes
`ind_external = 0` at the origin: the origin kernel is two-dimensional and
`Γ_s`-balanced (one `γ₅ = +1` mode and one `γ₅ = −1` mode). A *healthy* external
cone in the C0 sense keeps **both** of these modes — C0 says nothing about
deleting one. Multiplying a zero external index by any internal chiral number
gives zero. So a chiral internal representation cannot rescue a balanced external
origin: `0 × (anything) = 0`.

This is exactly Nielsen–Ninomiya restated: a *local* external kinetic operator
with *ordinary* `Γ_s` chirality and a healthy cone at the origin is necessarily
vector-like (balanced) at that cone. The internal SM rep is genuinely chiral, but
it is a spectator to the external branch problem. Hence the external side must
itself produce a single Weyl branch — which is precisely the C1 obligation
(physical grading `Γ_phys` + projection/overlap that *gaps* the mirror mode, not
merely grades it). This matches the Wave-19 taste-involution audit's conclusion
(`LIKELY-NEEDS-AUXILIARY-LAYER`): grading partitions, only a mass/spectral-flow
gaps.

**Answer: not sufficient. C0 + Gate H is vector-like at the origin; C1 (an
external single-Weyl/overlap layer) is mandatory.**

### Q2. Which claims require C1 rather than C0?

C0 delivers (and only delivers):

```text
invertibility of D_RA(q) + r W(q) I for real q ≠ 0;
singular-value gap σ_min ≥ r W(q) (an inverse-propagator gap, not a numerator zero);
leading continuum symbol preserved (R_W = O(|q|²) at the origin);
exclusion of *free* propagator-zero ghosts on the real torus.
```

The following are **C1-only** and are *not* touched by any scalar Wilson / C0
argument:

```text
nonzero physical chiral index at the origin (a single retained Weyl line);
choice and legality of the physical chirality grading Γ_phys;
positivity of the physical sector (Krein / reflection positivity);
gauge covariance of the projector/grading and of the overlap sign operator;
gauge-coupled ghost-zero safety (Golterman–Shamir) under dynamical U;
counterterm legality / locality of the projected construction;
anomaly inflow matching the target SM content.
```

The single most load-bearing C1 item is the chiral index. Everything physical
about "this is a fermion mass mechanism for the Standard Model" is downstream of
it, and C0 contributes exactly nothing to it (working-plan §13.3:
`D_+(0)=0`, `W(0)=0`, so the origin fiber is untouched by scalar Wilson).

### Q3. Does RA-Wilson C0 avoid needing full determinant-zero-locus classification in the free real-torus setting?

**Yes — this is C0's real and non-trivial payoff, with one honest caveat.**

The mechanism is the finite linear-algebra lemma (decision-log D19, working-plan
§13.6):

```text
If A† = −A and m > 0, then A + m I is invertible and σ_min(A + m I) ≥ m.
```

Proof sketch (sound): `(A + mI)†(A + mI) = (−A + mI)(A + mI) = −A² + m²I`. Since
`A† = −A`, `−A² = A†A ⪰ 0`, hence `(A+mI)†(A+mI) ⪰ m²I`, giving `σ_min ≥ m`.
Applied with `A = D_RA(q)` (anti-Hermitian by `RA_double_antiHermitian` /
`DRA_antiHermitian`) and `m = r W(q)`, one needs only the scalar positivity

```text
W(q) > 0  for all real q ≠ 0   (i.e. wilson_zero_iff_origin, away from origin).
```

This is a *pointwise* positivity fact about a single smooth function, **not** a
classification of where `det D_RA(q) = 0`. So off-branch zeros, cyclotomic zeros,
and the `q_star = (2π/3, 0, 0, 4π/3)` witness are all gapped uniformly without
ever being enumerated. That is a real structural advantage over the v3 program,
which kept colliding with "`T_lin` misses off-branch/cyclotomic zeros." C0 sidesteps
the entire locus-classification problem on the real torus.

Caveat (do not oversell): the gap `σ_min ≥ r W(q)` **degenerates as `q → 0`**
(`W(q) = O(|q|²)`), so it provides no uniform gap in a neighborhood of the origin
— which is correct and intended (the origin must stay massless), but it means C0
is a statement about *each fixed real `q ≠ 0`*, not a uniform-gap statement on a
punctured neighborhood without a separate lower bound. Two further boundaries:
(i) it is a *real-torus* claim; complex zeros relevant to analytic propagator
structure are not addressed by `W(q) > 0`; (ii) the gauge-coupled version needs
`W[U] = Σ_a (I − S_a[U]) ⪰ 0` as an *operator* inequality (true when each
`T_a[U]` is unitary, so `S_a[U] = (T_a[U]+T_a[U]†)/2 ⪯ I`), which is plausible
but is a separate lemma from the free `W(q) > 0`. Within its stated scope (free,
real torus, fixed `q ≠ 0`) the avoidance of locus classification is genuine.

### Q4. What remains after C0 for gauge-coupled ghost safety, locality, anomaly flow, physical positivity?

All four remain open and are C1-class:

- **Gauge-coupled ghost safety.** C0 excludes *free* propagator-zero ghosts via
  the inverse-propagator gap, which is the right Golterman–Shamir-respecting
  shape (working-plan §13.4: removal by a true `σ_min ≥ g > 0` gap, not a
  point-split numerator zero). But it must be upgraded to the dynamical-`U`
  operator inequality, and the *retained* origin branch must be shown not to
  reintroduce a gauge-charged pole. C0 does not do this.
- **Locality.** The released candidate is an overlap object
  `D_phys = (1/h)(I + Γ̂_sE sign(H_NED))`. Overlap locality is *conditional on a
  spectral gap of `H_NED`* — and that is exactly where Nielsen–Ninomiya bites:
  the gap that would localize the sign operator is the same data that must
  produce the chiral index. C0's gap degenerates at the origin (Q3), so it does
  **not** supply the locality-giving gap of `H_NED`. Locality is unproven.
- **Anomaly flow.** The chiral/index content C0 lacks is precisely what an
  anomaly-matching argument consumes. Anomaly inflow is a Gate-H/C1 joint
  obligation and is untouched by C0.
- **Physical positivity.** The RA double introduces an indefinite (Krein)
  structure. `NullEdgeKreinOverlapSignTrap.lean` (C81) is the standing guardrail:
  `J`-self-adjointness alone does **not** imply a real spectrum or a gapped sign
  function (`kreinTrap_sq_eq_neg_one`: a `J`-self-adjoint `A` with `A² = −I`,
  hence no real eigenvector). So `H_NED` being merely `J`-self-adjoint is
  insufficient; one needs genuine Hermiticity in a *positive* physical Hilbert
  structure before `sign(H_NED)` is even defined. C0 says nothing here.

### Q5. What theorem names / manuscript language prevent C0 being mistaken for full Gate C?

Already-present, and adequate if enforced:

```text
GateC0SpeciesHealthy            -- the weak layer, named "species health" not "release"
GateC1ChiralPhysicalRelease     -- the word "release" attaches only to the chiral layer
StagedGateCReleased             -- full release = C0 ∧ C1 ∧ H, never C0 alone
gateC0_alone_insufficient       -- machine-checked: C0 ∧ ¬C1 ⟹ ¬ full release
gateH_alone_insufficient        -- machine-checked: H  ∧ ¬C0 ⟹ ¬ full release
RegulatorLegal := LiftNonOrigin ∧ OriginWeylPure   -- lifting alone ≠ legality
wilson_lift_not_chiral_release_schema              -- Wilson lift ≠ chiral release
liftNonOrigin_insufficient                         -- witness: lifts all zeros, still not released
```

Recommended additions / discipline:

1. **Name the C0 deliverable so it cannot be read as chiral**, e.g.
   `GateC0SpeciesHealthy_from_RAWilson` with a docstring line
   "produces an inverse-propagator gap for `q ≠ 0`; supplies **no** origin
   chirality; not a Gate C release." Pair it with a *negative* companion theorem
   in the spirit of `scalarWilson_not_gateC_release` /
   `continuous_scalar_mass_failure` so the no-chirality fact is itself a lemma,
   not just prose.
2. **Forbid the token "released"/"Gate C release" on any declaration that does
   not have a `GateC1ChiralPhysicalRelease` field in scope.** The only release
   predicate should be `StagedGateCReleased` (or `GateC_v4_released`, which
   already requires `OriginWeylPure` + ghost/Krein/gauge/cterm).
3. **Manuscript language.** Use the decision-log phrasing verbatim:
   "RA-Wilson may release Gate C0. It does **not** release Gate C1 or full
   Gate C." Describe the RA-Wilson result as a *species-health / branch-control*
   theorem and explicitly state that the origin remains `Γ_s`-balanced (cite the
   C21 facts and the Wave-19 taste audit) so no reader infers a chiral lattice
   fermion has been constructed locally.
4. **State the Nielsen–Ninomiya boundary in the same breath as C0.** A one-line
   "C0 is vector-like at the origin by construction; chirality is the separate
   C1 obligation, which is subject to the Nielsen–Ninomiya / overlap-locality
   no-go pressure" prevents the most likely misreading.

---

## 3. Adversarial check: does the split hide an obstruction?

This is the task's central skeptical demand, so I answer it directly.

**It does not hide the obstruction; it isolates and names it.** The honest test
is: "after the split, is there any single Prop whose proof would, by itself,
deliver a local chiral lattice fermion and thereby contradict Nielsen–Ninomiya?"
The answer is no, because:

- The chiral content is concentrated in **one** clause, `retainedBranchChiral`
  inside `GateC1ChiralPhysicalRelease` (equivalently `DataOriginWeylPure` in the
  v4 contract). Discharging it is *defined* to require an auxiliary
  projection/overlap layer — `RegulatorLegal` is `LiftNonOrigin ∧ OriginWeylPure`
  and `wilson_lift_not_chiral_release_schema` proves that lifting alone never
  supplies it. So the split cannot be gamed by proving a pile of easy C0/lifting
  lemmas and quietly inheriting chirality.
- The locality-giving gap and the chiral index are *the same physical datum*
  (overlap sign of `H_NED`), and C0's gap is explicitly the wrong one (it
  vanishes at the origin). The split does not pretend otherwise.
- Two independent kernel-checked guardrails already sit next to the split and
  fire on the exact failure modes: the Krein sign trap (positivity/spectrum) and
  the regulator-legality witnesses (`liftNonOrigin_insufficient`,
  `liftOnlyWitness_not_pure`). The Wave-19 taste audit closes the
  "regrade-the-origin-for-free" loophole.

The **only** residual hiding risk is *nominal*: a careless manuscript sentence
calling a C0 theorem "Gate C." That is a language failure, not a mathematics
failure, and §5 neutralizes it. Hence the split clarifies rather than conceals —
but it earns the "VALID" verdict only together with the naming discipline, which
is why the verdict is qualified rather than unconditional.

---

## 4. Net assessment and recommended next Lean artifacts

The split is the right move: C0 is a real, locus-classification-free
species-health theorem; C1 cleanly owns the genuine (Nielsen–Ninomiya-pressured)
chiral-gauge problem; Gate H is correctly walled off from solving C1. The split
*reduces* the chance of a category error precisely because it forces the chiral
obligation into one explicitly-open, guardrail-surrounded clause.

Highest-value next Lean targets (all finite, in the spirit of the existing
modules):

```text
antiHermitian_add_posScalar_invertible          -- A†=−A, m>0 ⟹ A+mI invertible
antiHermitian_add_posScalar_singularValue_bound -- σ_min(A+mI) ≥ m
DRA_antiHermitian                               -- D_RA† = −D_RA for finite D_+
DRA_wilson_invertible_away_origin               -- instantiation, real q ≠ 0
GateC0SpeciesHealthy_from_RAWilson              -- assemble the C0 record
scalarWilson_not_gateC_release                  -- negative companion: no origin chirality
externalIndex_zero_kills_tensor_release         -- ind_ext = 0 ⟹ tensor index 0 (Q1, the N–N core)
```

The first five make C0 a real theorem; the last two keep the boundary honest by
making "C0/Gate-H is vector-like at the origin" a kernel-checked lemma rather than
a footnote.

---

## Appendix: one-line status register

| Item | Status |
| --- | --- |
| C0/C1/H split is a faithful decomposition (`StagedGateCReleased`) | sound |
| `gateC0_alone_insufficient`, `gateH_alone_insufficient` | machine-checked (existing) |
| RA-Wilson lemma `A†=−A, m>0 ⟹ σ_min(A+mI) ≥ m` | sound (verified by hand) |
| C0 avoids full determinant-zero-locus classification (free, real torus, q ≠ 0) | true, with caveats (Q3) |
| C0 supplies origin chirality | **no** (`W(0)=0`, origin stays Γ_s-balanced) |
| C0 + Gate H sufficient for SM mass program | **no** — external single Weyl branch required (Q1) |
| Chiral index, locality, anomaly, positivity | C1-only, open (Q2, Q4) |
| Split hides a Nielsen–Ninomiya / chiral-gauge obstruction | **no** — it isolates and names it (§3) |
| Residual misread risk | nominal (manuscript language); neutralized by §5 |
| Verdict | `SPLIT-VALID-BUT-C1-NEEDED-FOR-SM` |
| Gate C release claimed | none |
