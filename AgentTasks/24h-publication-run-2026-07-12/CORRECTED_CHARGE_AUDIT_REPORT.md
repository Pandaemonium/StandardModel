# Corrected 3+1 Charge Architecture — Hostile Semantic Audit

Date: 2026-07-11. Scope: the corrected strict-3+1 "charge" chain as realized in
`SU2LocalCrossingCharge.lean`, `DiracLocalChargeNeutrality.lean`,
`ChiralityMixingNecessity.lean`, cross-read against `MEMO_3PLUS1_ATTACK.md`,
`B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`, and the corrected-charge passage
of the manuscript (`Null_Edge_..._2026-07-10.tex`, §≈1408–1439 and result table
rows ≈1713–1721).

Method: read all sources verbatim; rebuilt all three modules
(`8031 jobs, success`); `#print axioms`-checked the load-bearing theorems
(`massBlend_sq`, `diracFirstJet_perp_eq_zero`, `diracSectorCharges_cancel`) —
each closes on `{propext, Classical.choice, Quot.sound}` only; grepped for
`sorry`/`admit`/`axiom` (none present; the single grep hit is the substring
"admit" inside "mass-**admit**ting"). No Lean file was edited.

---

## 0. Bottom line

**No critical flaw.** There is no vacuity, no false theorem, no hidden
`sorry`/axiom, and no place where the Lean kernel is made to assert a
Chern/winding/K-theory/Floquet result. Every one of the three modules is
individually honest: each proves exactly a finite algebraic identity or a finite
sign/fixture fact, and each carries a docstring that disclaims the global
topological reading. The imported K-theory (Read 2017) and Floquet
(Bessho–Sato 2021) statements are **not** encoded in Lean and are explicitly
marked VERIFY in the memo and source audit.

What remains are **naming/prose gaps**, not proof defects: three theorem *names*
and several memo/manuscript sentences read as though a topological or
per-Dirac-symbol statement were established, when the kernel content is a chosen
finite fixture or a pointwise algebraic identity. These are correctable by
wording only. The single most valuable missing theorem is the finite A4
"charge-balance ⇒ second crossing" implication (§7).

The five requested strata separate cleanly and must be kept separate; none is
allowed to borrow authority from another:

| Stratum | File / object | What the kernel actually gives | What it does NOT give |
|---|---|---|---|
| (a) sign of a supplied real Jacobian | `localCrossingCharge`, `SU2…` | `sign(det J)` as an `Int`; trivial sign lemmas | that `det J`'s sign equals a Berry/Chern flux |
| (b) local 2-component Weyl-sector charge | `weylPlus/Minus_charge`, `diracSectorCharges_cancel` | `+1`, `−1`, and `1+(−1)=0` for **two hand-picked** `3×3` matrices | that these are the sector Jacobians of any actual Dirac symbol |
| (c) algebraic full-Dirac mass homotopy | `massBlend_sq`, `_start`, `_end` | pointwise: `(cF+sβ)²=1` on `c²+s²=1`, endpoints `F` and `β` | a continuous/`Homotopy` object; "null-homotopic"; "class-A charge = 0" |
| (d) global chiral splitting | (no Lean object) | nothing — it is a stated hypothesis `[U(k),Ξ]=0` | any proof, or any check that a symbol satisfies it |
| (e) imported K-theory / Floquet | (no Lean object) | nothing — cited prose, marked VERIFY | any kernel content; must never be a Lean assumption |

---

## 1. Findings, ordered by severity

### S1 (moderate) — `diracSectorCharges_cancel`: name and table row outrun the kernel
`SU2LocalCrossingCharge.diracSectorCharges_cancel` proves
`localCrossingCharge weylPlusJacobian + localCrossingCharge weylMinusJacobian = 0`,
where `weylPlusJacobian := (1 : 3×3)` and
`weylMinusJacobian := diagonal ![-1,1,1]`. Reduced, the kernel proves
**`1 + (−1) = 0`** for two matrices whose determinant signs were *chosen* to be
opposite. Nothing connects these two Jacobians to the two Weyl sectors of any
Dirac tangent; the cancellation is guaranteed by construction, not derived.
The manuscript result-table row (≈1717) reads "exact supplied-Jacobian Weyl
charges +1,−1, zero Dirac-sector sum" — the hedge word **"supplied"** is doing
all the honest work, and a hostile reader will still take "zero Dirac-sector
sum \Kernel" as a proof about a Dirac point. Safe reading in §2; replacement
wording in §5.

### S2 (moderate) — memo A1 phrase "the two sectors of the Dirac tangent have opposite charges"
`MEMO_3PLUS1_ATTACK.md` §4/A1 says "Prove … the two sectors of the Dirac
tangent have opposite charges. **Finite fixture landed.**" The Lean fixture does
not range over the sectors of a Dirac tangent; it evaluates the sign API on the
identity and a one-axis reflection. The claim is true of the *fixtures*, not of
*the Dirac tangent*. Same defect as S1 at memo level.

### S3 (moderate) — "null-homotopic" / "neutral in class A" outruns `massBlend_sq`
`DiracLocalChargeNeutrality` proves a **pointwise** identity: for each `(c,s)`
with `c²+s²=1`, `(cF+sβ)²=1`, plus the two endpoint evaluations. There is **no**
`Continuous`, `Path`, or `Homotopy` object in the file, and no statement that a
gapped deformation to a constant forces the class-A invariant to vanish. Memo §3
("the full Dirac defect is explicitly **null-homotopic** … Equivalently … total
class-A charge is zero") and the manuscript's lead sentence ("A complete
mass-admitting four-component Dirac crossing **is neutral in class A**", ≈1409)
state the *topological consequence* as fact. It is a defensible informal
corollary, but it is **not** kernel-checked, and the "Equivalently" in the memo
asserts an equivalence (null-homotopy ⇔ opposite sector charges summing to zero)
that is nowhere proved. The manuscript is *more* careful than the memo: it
attributes only "The finite matrix identity … is \Realization \Kernel" (≈1418).
Keep that attribution boundary; do not let the lead sentence borrow it.

### S4 (low) — "Weyl charge" / "local charge" terminology invites a Chern reading
`localCrossingCharge := sign(det J)` is the *standard local* definition of Weyl
chirality, so the terminology is defensible. But the identity
`sign(det J) = Chern number on a small enclosing sphere` is a genuine theorem
that is **not** present. The `SU2…` docstring is exemplary here ("It does not
prove a global degree or charge-sum theorem"); the risk is only that manuscript
prose ("Weyl charges", "charge") may be read topologically. Keep the
"Jacobian-sign" qualifier everywhere the word "charge" appears in the charge
thread (see §5).

### S5 (low) — A1/A5 coefficients are not tied to any actual jet of a symbol
`ChiralityMixingNecessity.diracFirstJet_perp_eq_zero` operates on three abstract
matrices `A1,A2,A3`; nothing in the file identifies them with the first-order
Taylor/`fderiv` coefficients of a symbol `U(k)`. There is no differentiability,
no `O(|k|²)` remainder, no root exclusion, no no-doubling — exactly as the
request anticipates and as the file docstring concedes. The result is pure
linear algebra ("if it commutes with `Ξ`, its odd part is zero"), and its
"first jet" reading is an interpretive label. Load-bearing hypothesis
`Xi*Aᵢ = Aᵢ*Xi` is present and honestly quoted in the manuscript ("when the
normalized Dirac first jet commutes with `Ξ`", ≈1435). No overclaim in Lean;
flagged only so the analytic gap is not silently closed later.

### S6 (low) — global chiral splitting `[U(k),Ξ]=0` is correctly a hypothesis, but has no Lean witness
Stratum (d) is a *stated* hypothesis in memo §3/A2 and manuscript (≈1423). This
is the right treatment. The residual risk is that later composition steps quietly
assume a concrete symbol satisfies it. There is currently no Lean object that
either states the sectorwise sum rule under `[U(k),Ξ]=0` or checks the hypothesis
for a candidate symbol; the load-bearing role is asserted, not formalized.

### S7 (low) — imported K-theory / Floquet: convention-drift and composition gates
`B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md` is careful ("Do not encode the
Read result as a new Lean assumption"). Residual convention risks it itself
flags and that must survive into any manuscript sentence:
(i) Read's symbol `R_3` is the **quaternionic** ring, not "three-variable" —
read the attachment's `R_3` as "three-variable" only; (ii) algebraic `K₁`
vs topological `K¹(T³)` vs stable rank vs determinant-delay must stay separate;
(iii) Bessho–Sato records a **dimension-dependent sign** for the quasienergy-π
contribution — the 0/π sign convention and class-A-vs-symmetry-protected case
must be copied from the displayed theorem before use. None of this is in Lean;
all is marked VERIFY. Keep it that way.

### S8 (informational) — do not conflate the charge thread with the Plücker "winding-one" thread
The manuscript also carries a separate kernel thread (`windingOneField_…`,
`global_real_lift_forces_zero_winding`, etc., ≈1641–1653) about a 2-D turning
number of a link field. That is a different construction with its own Lean files
(not among the three audited here) and must not be read as evidence for the 3+1
Weyl-charge chain. Their shared vocabulary ("winding", "chiral") is the drift
hazard; they are logically independent.

---

## 2. Theorem-by-theorem semantic readings (exact safe readings)

### `SU2LocalCrossingCharge.lean`
- `localCrossingCharge J := if 0<J.det then 1 else if J.det<0 then -1 else 0`
  — **Safe reading:** the three-valued *sign of the determinant* of a supplied
  real `3×3` matrix, packaged as an `Int`. It is a total function of a matrix;
  it is not a degree, a Chern number, or a Berry flux, and it reads no symbol.
- `localCrossingCharge_eq_one / _eq_neg_one / _eq_zero` — the sign function's
  three branches. Trivial and correct.
- `localCrossingCharge_ne_zero_iff` — charge `≠0 ⇔ det ≠ 0`, i.e. the API is
  nonzero exactly on invertible (nondegenerate) supplied Jacobians. Correct.
- `weylPlusJacobian := 1`, `weylMinusJacobian := diagonal ![-1,1,1]`,
  `singularControlJacobian := diagonal ![1,1,0]` — **hand-supplied fixtures**,
  not derived from any symbol.
- `weylPlus/Minus/singularControlJacobian_det` = `1 / -1 / 0` — correct
  determinant computations of the chosen fixtures.
- `weylPlus_charge = 1`, `weylMinus_charge = -1`, `singularControl_charge = 0`
  — the sign API applied to the fixtures. **Safe reading:** two orientation
  fixtures and one degenerate fixture have the expected signs. No physics beyond
  "identity and one-axis reflection have opposite det sign."
- `diracSectorCharges_cancel` — **Safe reading: `1 + (−1) = 0`.** It is a true
  arithmetic fact about two chosen matrices; it is *not* a proof that the two
  Weyl sectors of a Dirac tangent cancel. The cancellation was built in by
  picking opposite determinant signs. (S1.)

### `DiracLocalChargeNeutrality.lean`
- `massBlend c s F beta := c•F + s•beta` — an affine combination of two matrices.
- `massBlend_sq` (load-bearing) — **Safe reading:** *given* two involutions
  `F,β` (`F²=1`, `β²=1`) that **anticommute** (`Fβ+βF=0`), every unit-circle
  combination (`c²+s²=1`, `c,s ∈ ℂ`) is again an involution. This is the exact
  finite Clifford core; correct and non-vacuous. It is **pointwise** in `(c,s)`
  — there is no continuity/homotopy object.
- `massBlend_start = F`, `massBlend_end = β` — the two endpoints. Together with
  `massBlend_sq` these *exhibit a one-parameter family of involutions from `F`
  to the constant `β`*. **Safe reading stops there.** "Null-homotopic" and
  "class-A neutral" are informal consequences, not kernel content. (S3.)
- `exists_distinct_anticommuting_involutions` — nonvacuity: explicit distinct
  anticommuting involutions in `4×4` exist. Correct; prevents `massBlend_sq`
  from being vacuous.
- `exists_nonanticommuting_blend_failure` — **negative control:** dropping
  anticommutation (`F=β=1`, `c=3/5,s=4/5`) breaks the conclusion. Confirms
  `hanti` is load-bearing, not decorative. Correct.

### `ChiralityMixingNecessity.lean`
- `parallelPart Xi U := (U + Xi U Xi)/2`, `perpPart Xi U := (U − Xi U Xi)/2`
  — the even/odd projection under conjugation by `Ξ`.
- `parallelPart_add_perpPart` — reconstruction `even+odd = U`. Correct.
- `Xi_mul_parallelPart_eq` — `Ξ` commutes with the even part. Correct.
- `Xi_mul_perpPart_eq_neg` — `Ξ·odd = −(odd·Ξ)`. Correct.
- `perpPart_eq_zero_of_commutes` — if `ΞU=UΞ` then odd part `=0`. Correct.
- `perpPart_one_eq_zero` — the identity (i.e. a constant term `U(0)=I`) has zero
  odd part. Correct; this is the "constant jet" case.
- `diracFirstJet_perp_eq_zero` (load-bearing) — **Safe reading:** *three
  matrices* `A1,A2,A3` that each commute with `Ξ` have zero odd part. Under the
  interpretive dictionary "`A1,A2,A3` = first-order symbol coefficients", this
  says the odd constant/linear jet vanishes *when the tangent commutes with `Ξ`*.
  The dictionary itself (that these are `fderiv` coefficients) is **not** in the
  file. (S5.)
- `exists_nonzero_perpPart` — nonvacuity: an involutory `Ξ` with a genuinely
  nonzero odd coefficient exists. Correct; blocks the trivial "everything is
  even" reading.

---

## 3. Overclaims in the memo / manuscript (each with a safe boundary)

1. **Memo §3:** "the full Dirac defect is explicitly **null-homotopic** while
   remaining gapped on the enclosing sphere. **Equivalently**, its two Weyl
   sectors carry opposite charges and the total class-A charge is zero."
   — Kernel gives only the pointwise involutory family (§2, S3). "Null-homotopic",
   "gapped on the enclosing sphere" (as a statement over the whole sphere of
   directions), and the "Equivalently … total class-A charge is zero" equivalence
   are informal. Mark as strategy, not KERNEL.
2. **Memo §4/A1:** "the two sectors of **the Dirac tangent** have opposite
   charges. Finite fixture landed." — Fixtures, not the Dirac tangent (S2).
3. **Manuscript ≈1409:** "A complete mass-admitting four-component Dirac crossing
   **is neutral in class A.**" — Correct informal corollary; the *kernel* proves
   only the algebraic identity, which the next sentence correctly attributes
   (\Realization \Kernel). Keep the boundary explicit (S3).
4. **Manuscript table ≈1717 / `diracSectorCharges_cancel`:** "zero Dirac-sector
   sum \Kernel" — reduce to "supplied-Jacobian fixtures with opposite sign sum to
   zero" (S1).
5. **Manuscript ≈1421 "the exact **Jacobian-sign API** gives opposite +1 and −1"**
   — this one is already correctly hedged; retain the "Jacobian-sign" qualifier
   and do not drop it to bare "charge" (S4).
6. **Manuscript ≈1428–1432 (Read + Bessho–Sato):** "supplies a source-supported
   **route to** a global-chirality doubling theorem, but the finite-rank and
   zero/π convention composition is **not yet kernel-checked here**." — Already
   honest; keep the "route to / not yet kernel-checked" hedge and the
   convention caveats of §S7. Never upgrade to "a doubling theorem".

The manuscript is, on the whole, more disciplined than the memo: it consistently
attaches \Kernel only to the finite identity and uses "supplied", "fixture",
"Jacobian-sign", and "route to" as hedges. The overclaims are concentrated in
memo §3–§4 (strategy prose) and in two theorem *names* leaking into the table.

---

## 4. Vacuity / false-shape / hidden-assumption checklist (all PASS)

- **Vacuity:** every general theorem has a matching non-vacuity fixture
  (`exists_distinct_anticommuting_involutions`, `exists_nonzero_perpPart`) and a
  negative control where relevant (`exists_nonanticommuting_blend_failure`,
  `singularControl_charge`). No hypothesis set is unsatisfiable; no goal is
  `True`-shaped.
- **False shape:** `massBlend_sq`, the even/odd laws, and the sign lemmas are
  all genuinely the stated identities (rebuilt; axioms clean). No conclusion is
  weakened to trivial form.
- **Hidden topology:** none imported. No `Chern`, `Berry`, `winding`, `degree`,
  `K1`, `K¹`, `Homotopy`, or Floquet object appears in any of the three files.
  The topological content lives only in prose and is marked VERIFY.
- **Docstring-vs-kernel:** the three file docstrings each *disclaim* the global
  reading ("does not infer a global no-doubling theorem"; "does not define a
  Chern class"; "does not prove a global degree or charge-sum theorem"). The
  leaks are in memo §3–4 and two table names, not in the Lean docstrings.
- **Convention drift:** the one live drift risk (Read's `R_3` = quaternionic;
  Bessho–Sato π-sign) is already isolated in the source audit and must be kept
  out of Lean (S7).

---

## 5. Exact replacement wording

- **`diracSectorCharges_cancel` (manuscript table row ≈1717).**
  Replace: "exact supplied-Jacobian Weyl charges +1,−1, zero Dirac-sector sum,
  and singular control"
  With: "the Jacobian-sign API returns +1 and −1 on the two supplied unit-
  orientation fixtures and 0 on the singular fixture; hence the **two supplied
  fixtures' charges cancel (1+(−1)=0)**. This is an arithmetic fact about the
  chosen fixtures and does **not** derive a cancellation for the sectors of any
  particular Dirac symbol, which requires the live Jacobian extraction and the
  global splitting `[U(k),Ξ]=0`."

- **Manuscript lead sentence (≈1409).**
  Replace: "A complete mass-admitting four-component Dirac crossing is neutral in
  class A."
  With: "A complete mass-admitting four-component Dirac crossing carries **no
  well-defined class-A Weyl charge**: kernel-checked, the flattened tangent `F`
  and the anticommuting mass involution `β` lie on a common unit-circle family of
  involutions (`massBlend_sq`, endpoints `massBlend_start/_end`), so `F` deforms
  to the constant `β` through gapped involutions. The topological reading
  ('null-homotopic', 'class-A charge zero') is the informal corollary of this
  finite identity, not itself kernel-checked."

- **Memo §3.**
  Replace: "the full Dirac defect is explicitly null-homotopic … Equivalently,
  its two Weyl sectors carry opposite charges and the total class-A charge is
  zero."
  With: "the full Dirac tangent lies on a gapped unit-circle family of
  involutions ending at the constant `β` (kernel: `massBlend_sq`). The
  topological consequences — null-homotopy, and hence vanishing total class-A
  charge realized as opposite sector charges — are the intended *informal*
  reading; the equivalence between them is not proved here."

- **Memo §4/A1.**
  Replace: "the two sectors of the Dirac tangent have opposite charges. Finite
  fixture landed."
  With: "two supplied unit-orientation Jacobian fixtures have opposite
  Jacobian-sign charges (+1,−1); the live per-sector Jacobian of an actual Dirac
  symbol is not yet extracted, so this is a fixture, not a per-symbol theorem."

- **Anywhere in the charge thread using bare "charge"/"Weyl charge".** Prefer
  "**Jacobian-sign** (local) charge" and, on first use, state explicitly:
  "identification of this sign with a Chern/Berry monopole charge is a separate
  theorem not established here."

---

## 6. Residual gaps (no critical flaw, but the chain is incomplete)

G1. **Live Jacobian extraction (stratum a→b).** No theorem produces the `3×3`
   Pauli-coefficient Jacobian from an actual symbol `u₀I − i u·σ` at a crossing;
   the sign API is only exercised on hand-chosen matrices.

G2. **Sectorwise sum rule under `[U(k),Ξ]=0` (stratum d).** The global splitting
   is a stated hypothesis with no Lean statement of the sum rule it enables and
   no checker that a candidate symbol satisfies it.

G3. **Homotopy → invariant bridge (stratum c).** No formal step from
   "gapped unit-circle family of involutions" to "class-A invariant = 0"; this
   is where "neutral in class A" currently lives on informal footing.

G4. **Analytic A5 (stratum, ChiralityMixing).** No `fderiv`/Taylor identification
   of `A1,A2,A3`, no `O(|k|²)` remainder, no differentiability — so
   "odd correction begins beyond first order" is an algebraic, not analytic,
   statement.

G5. **Imported K-theory/Floquet composition (stratum e).** Read's algebraic `K₁`
   → topological `K¹(T³)` change-of-rings, finite-rank stabilization, and the
   Bessho–Sato 0/π sign are all VERIFY-only; the composition into a doubling
   theorem is unbuilt (and, correctly, must not be a Lean assumption).

---

## 7. Single smallest missing theorem (most strengthens the chain)

**The finite A4 charge-balance implication** — a purely finite, kernel-provable
*now* statement that converts the existing sign API + neutrality into a
conditional no-doubling result, without importing any K-theory or Floquet
result:

> Let `charges : Finset ι → ℤ` assign to each nondegenerate crossing `i` its
> Jacobian-sign charge `localCrossingCharge Jᵢ ∈ {−1,+1}`. If
> (i) `∑ i, charges i = 0` (total-charge-zero, supplied as an explicit
> hypothesis — later discharged by a finite census or by the external
> K-theory/Floquet input), and
> (ii) some crossing `i₀` has `charges i₀ ≠ 0`,
> then there exists a **second** crossing `i₁ ≠ i₀` with `charges i₁ ≠ 0`
> (`¬ uniqueness`). Equivalently: a single isolated nondegenerate crossing is
> incompatible with vanishing total charge — the finite Nielsen–Ninomiya /
> doubling contradiction.

Why this one: it is the logical hinge (`memo` A4). It is elementary finite `ℤ`
arithmetic on a `Finset` sum, so it is provable immediately with no new
mathematics; it makes the whole conditional chain rigorous by cleanly isolating
the *only* genuinely topological input (the `∑ charges = 0` sum rule) as a named
hypothesis; and it turns the currently-decorative `diracSectorCharges_cancel`
fixture into a instance of a real theorem. The deeper (non-"smallest") missing
result behind hypothesis (i) is the honest degree/Poincaré–Hopf sum rule
`∑ sign(det Jᵢ) = 0` for the relevant Brillouin-zone map — that is the real
topology and is exactly what Read + Bessho–Sato are being enlisted to supply.

---

## 8. Verification log

- `lake build` (all three default targets): success, 8031 jobs.
- `#print axioms` on `massBlend_sq`, `diracFirstJet_perp_eq_zero`,
  `diracSectorCharges_cancel`: each `{propext, Classical.choice, Quot.sound}`.
- `grep -n "sorry\|admit\|axiom" *.lean`: only match is "admit" within
  "mass-admitting" (a docstring word); no `sorry`, no `axiom`, no `admit`
  tactic.
- No Lean file was modified during this audit.
