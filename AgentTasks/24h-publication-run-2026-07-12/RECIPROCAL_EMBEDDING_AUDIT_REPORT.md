# Reciprocal conditional‑shift regulator — hostile embedding audit

Date: 2026‑07‑12. Reviewer: Aristotle (independent, adversarial).
Scope: document/source review of

- `B_RECIPROCAL_CONDITIONAL_SHIFT_ORACLE_2026-07-11.md` (the 2×2 oracle),
- `codex_24h_b_reciprocal_conditional_shift_regulator.lean` (the Lean target, all proofs are `sorry`),
- the naive 4×4 chirality‑register embedding described in that oracle and in
  `MEMO_3PLUS1_ATTACK.md` §5 B3a.

**No project build was run** (per instruction). The 2×2 algebra was
re‑derived independently with exact rational/symbolic arithmetic; the 4×4
claims were probed numerically and, where they are not reproducible from the
memo, are flagged as such. Verification scripts are transient (run under
`/tmp`); every numeric statement below was reproduced from the raw definitions
`C = [[3/5,4/5],[-4/5,3/5]]`, `D(z)=diag(z,1)`, `K=D(z)CD(z^{-1})C^{-1}`,
`S=K(z)K(z^{-1})`.

---

## 0. Verdict in one paragraph

The 2×2 oracle is **exactly correct in every published number** — determinant,
quadratic flatness, `S(-1)`, both `z=-1` gap determinants, and the full
`Q(z)` factorization all reproduce symbolically. The Lean target states these
faithfully but is entirely unproven (`sorry`); its unitarity hypotheses are
**sound but incompletely stated** (one missing regularity assumption, see F3).
The naive 4×4 chirality‑register embedding’s new generic eigenvalue‑one roots
are **not a bug to be tuned away: they are the expected generic behaviour**
once the embedding breaks the determinant‑locking that made the 2×2 crossings
codimension‑3. The single smallest exact structure that keeps ±1 crossings
isolated is **per‑sector unimodularity under a commuting chirality**
(`[U,Ξ]=0` and `det U|_{±}=1`) — *not* any of chiral, particle‑hole,
symplectic, or "palindromic characteristic polynomial" taken alone; three of
those four are either automatic or give the wrong codimension (F5). That
isolating structure is exactly the control class the program already argues is
trivial, so **a genuine escape cannot buy isolation from a linear symmetry and
must certify it with an explicit torus root certificate** (F6). No global alias
removal is claimed anywhere below.

---

## 1. Independent verification of the 2×2 oracle (all PASS)

Recomputed from scratch (exact rationals; `C^{-1}=C^{T}`, so the Lean
`coinInv` is correct, and `coin·coinInv=I`).

| Oracle claim | Independent result | Status |
|---|---|---|
| `S(1) = I` | `[[1,0],[0,1]]` | ✅ exact |
| `dS/dz |_{z=1} = 0` | zero matrix | ✅ exact |
| `det S(z) = 1` (all `z`) | `1` identically | ✅ exact |
| `S(-1) = (1/625)[[-527,336],[-336,-527]]` | identical | ✅ exact |
| `det(S(-1)-I) = 2304/625` | `2304/625` | ✅ exact |
| `det(S(-1)+I) = 196/625` | `196/625` | ✅ exact |
| `S(z)-I = (z-1)^2 Q(z)`, `Q` as published | difference `= 0` matrix | ✅ exact |

Extra checks the oracle did not state but that a hostile reviewer wants:

- **Full `S(z)` entries** (finite Laurent, degree range `z^{-2}..z^{2}`):
  `S00=(-144z³+432z²+193z+144)/(625z)`,
  `S01=12(z-1)²(16z+9)/(625z)`,
  `S10=-12(z-1)²(9z+16)/(625z²)`,
  `S11=(144z³+193z²+432z-144)/(625z²)`.
  Confirms strict finite Laurent range with a genuine `z^{-2}` pole in the
  symbol variable (harmless on `|z|=1`).
- **Unitarity on the circle**: for `z=e^{it}`, `S(z)^† S(z)=I` and
  `|det S|=1` to `~1e-15` over a 50‑point sweep. So the oracle’s implicit
  "unitary on the torus" is real.
- **Reciprocal spectral pairing**: characteristic polynomial is
  `λ² − (tr S) λ + 1`; since `det S = 1`, the spectrum is a reciprocal pair
  `{μ, 1/μ}` = `{e^{ia}, e^{-ia}}` on the circle. **This locking is the entire
  source of crossing isolation** (see §3).
- **`z=-1` is genuinely gap‑ful**: eigenvalues of `S(-1)` are
  `(-527 ± 336 i)/625`, modulus exactly `1` (since `527²+336²=625²`), argument
  `≠ 0, π`. So neither a 0‑ nor a π‑quasienergy crossing survives at the old
  corner. The two nonzero determinants `2304/625` and `196/625` are the exact
  witnesses.

**Conclusion of §1:** the two‑band fixture is exactly determinant‑one,
quadratically flat at the intended origin, finite‑Laurent, unitary on the
torus, and gaps the old corner at both 0 and π. Every published number holds.

---

## 2. Audit of the Lean target (`codex_24h_..._regulator.lean`)

The file is a faithful statement skeleton with **all 18 substantive proofs left
as `sorry`** (only `IsUnitary2`, the defs, and the statements exist). Nothing
is proved. Statement‑level findings:

- The matrix defs (`coin`, `coinInv`, `conditionalShift`, `shiftCoinCommutator`,
  `reciprocalRegulator`, `quadraticCoefficient`) match the oracle exactly; the
  quadratic factorization theorem uses `(z-1)^2 • quadraticCoefficient z`, which
  is the correct scalar‑smul form.
- `reciprocalRegulator_det` is stated with hypothesis `hz : z ≠ 0` only — correct
  (the identity `det S = 1` holds for all nonzero `z`, no circle hypothesis
  needed).
- The unitarity lemmas correctly gate on `z ≠ 0` **and**
  `starRingEnd ℂ z = z⁻¹` (i.e. `|z|=1`). Good: unitarity is a circle statement.
- `neg_one_has_no_zero_or_pi_crossing` is the right pair of non‑vanishing
  claims and follows from the two exact determinants.

These are all provable exactly as stated; see the theorem ladder (§7). This
audit makes **no code edits**.

---

## 3. Why the naive 4×4 embedding produces generic eigenvalue‑one roots (EXPECTED)

The naive embedding is
`U_cand(q) = (S(e^{iq_x})S(e^{iq_y})S(e^{iq_z}) ⊗ I₂) · diag(U₊(q),U₋(q))`,
i.e. the reciprocal word acts on the **chirality register** (the tensor
`⊗ I₂` slot), and the Dirac data sit in the block‑diagonal factor.

Counting argument (the decisive point):

- For a `2×2` **SU(2)** symbol (`det=1`, unitary), write `U=u₀I − i u·σ` with
  `u₀²+|u|²=1`. Eigenvalue `+1 ⇔ u₀=1 ⇔ u=0`, i.e. **three** real equations.
  Hence a `+1` (or `−1`) crossing in a 3‑torus is **codimension 3 — an isolated
  point**. This is precisely the reciprocal primitive’s protection: `det S=1`
  ties the two eigenphases to `±a`, so "one eigenphase reaches 0" is upgraded to
  "the SU(2) point is the identity," three conditions.
- For a **generic 4×4 unitary** `U(q)`, eigenvalue `+1` is the vanishing of the
  single real function `μ(q)=min_k|e^{iθ_k(q)}-1|` (equivalently
  `|det(U-I)|=0`). **One** real equation ⇒ **codimension 1 — a 2‑D sheet** in
  `T³`. As one eigenphase `θ` sweeps through `0`, the factor
  `e^{iθ}-1 = 2i sin(θ/2)e^{iθ/2} ≈ iθ` drives `det(U-I)` through the origin of
  ℂ — exactly the "determinant changes sign across that point" the oracle
  reports.

So the reported `~6e-9` smallest singular value of `U_cand-I` on a
codimension‑one locus near `(q_x,q_y,q_z)≈(-0.6896,1.7624,1.4559)`, with a
determinant sign change, is **the generic outcome**, not an accident. It is the
default codimension of an eigenphase‑zero level set for a symbol that is no
longer determinant‑locked in the crossing subspace.

Independent structural confirmation: I verified numerically that the
register‑embedding **breaks chirality commutation** — with
`Ξ = [[0,I₂],[I₂,0]]`, `‖[U_cand,Ξ]‖ ≈ 1.0` at a generic `q` (not `≈0`). Once
`Ξ` is no longer conserved, the reduced action in the would‑be crossing
subspace is a generic `U(2)`, not `SU(2)`, and its `+1` level set relaxes from
codim‑3 to codim‑1. **The report’s diagnosis ("loses the spectral pairing that
made Weyl crossings isolated") is correct.**

> Provenance caveat (F2): `U₊, U₋` are not defined in the memo, so the exact
> witness `(-0.6896…,1.7624…,1.4559…)` and the "gaps all sixteen fixtures"
> claim are **not independently reproducible from the supplied documents**. The
> *mechanism* is verified and forced; the *specific numbers* are external
> numeric assertions and should be treated as VERIFY, not KNOWN.

---

## 4. The smallest exact structure that keeps ±1 crossings isolated

Question posed: among particle‑hole, symplectic, chiral, palindromic
characteristic polynomial, or other — what is the minimal constraint a 4×4
embedding must preserve so that `±1` crossings stay isolated (codim 3)?

Analysis of each candidate (this is where the hostile audit bites):

- **Palindromic characteristic polynomial — INSUFFICIENT (automatic).** For any
  unitary `U` the spectrum lies on the circle and is closed under conjugation,
  so `p(λ)=det(λI-U)` is *already* self‑reciprocal up to a unit
  (`char poly = λ⁴ + … + det`, with `det` a phase). "Palindromic char poly" is
  therefore not an extra hypothesis at all and pins nothing to `+1`. Red
  herring.
- **Chiral (sublattice) symmetry** `Γ U Γ = U^†`, `Γ†=Γ=Γ^{-1}` —
  **INSUFFICIENT (wrong codimension).** It forces eigenphases into `±a` pairs,
  so a `0`‑crossing is a `2×2` off‑diagonal block’s complex determinant
  vanishing: `2` real equations ⇒ **codim 2 (nodal lines)**, not isolated points.
- **Symplectic / Kramers** (antiunitary `T`, `T²=-1`, `[T,U]=0`, i.e.
  `U∈Sp(2)`) — **INSUFFICIENT / wrong direction.** It Kramers‑doubles every
  level; the doublet quasienergy hitting `0` is a single real condition ⇒
  **codim 1 (nodal surfaces)**. Worse, not better.
- **Particle‑hole alone** (`C U C^{-1}=U`, antiunitary) — pins the spectrum
  symmetric about the real axis, again already implied on the circle; does not
  isolate `+1`.
- **Per‑sector unimodularity under a commuting chirality — SUFFICIENT and
  minimal.** A constant Hermitian involution `Ξ` (`Ξ†=Ξ=Ξ^{-1}`) with
  `[U(q),Ξ]=0` for **all** `q`, together with `det(U(q)|_{Ξ=±1})=1`, makes each
  Weyl sector an `SU(2)`‑valued symbol. Then, sector by sector, eigenvalue `+1
  ⇔` the `SU(2)` point is `I ⇔` three real equations ⇒ **codim‑3 isolated**.
  This is exactly the determinant‑locking of §3, now enforced globally.

**Finding.** The minimal exact structure is not one of the four named linear
(anti)symmetries; it is the **det‑locking pair `[U,Ξ]=0` ∧ `det U|_{±}=1`**
(equivalently: the symbol is valued in `SU(2)⊕SU(2)` graded by a constant
chirality). This is precisely the "global chirality is load‑bearing" (A2)
hypothesis of the memo plus the reciprocal primitive’s own `det=1`. The naive
register embedding fails **both** conjuncts (`[U_cand,Ξ]≠0`), which is why it
lands in the codim‑1 default.

---

## 5. The structural tension the escape must confront (central finding)

The det‑locking of §4 is exactly the **control class** the program argues is
trivial (A3/A4: global‑chirality symbols are strongly trivial / cannot remove
the alias). The escape route (A5/B3) *requires* nonzero `Ξ`‑odd mixing
`U_⊥ = (U - Ξ U Ξ)/2 ≠ 0`, which **breaks `[U,Ξ]=0`** — the very hypothesis
that provided isolation.

> **Central audit thesis.** No exact *linear* symmetry among
> {chiral, particle‑hole, symplectic, palindromic} simultaneously (a) permits
> nonzero `Ξ`‑odd mixing and (b) keeps `±1` crossings codimension‑3 isolated.
> Codim‑3 isolation is (generically, locally) equivalent to per‑sector
> unimodularity under a commuting chirality — the trivial control class.
> Therefore a genuine escape cannot obtain isolation from a symmetry; it must
> obtain isolation *accidentally* (from higher‑order structure) and **prove it
> with an explicit finite torus root certificate.**

This is the rigorous form of the memo’s warning and the reason
"gapping the old sixteen points" is not a success criterion.

---

## 6. Proposed finite‑Laurent embedding ansätze, one fixture, one killer

### 6a. Ansatz E (the requested escape candidate) — quadratic `Ξ`‑odd reciprocal dressing

Use the reciprocal primitive strictly as a **quadratic, zero‑jet, `Ξ`‑odd**
dressing of the live Dirac step:

```
U_E(q) = diag(U₊(q), U₋(q)) · V(q),
V(q)  = I₄ + Σ_{j∈{x,y,z}} (z_j - 1)² · [ Ξ‑odd embedding of Q(z_j) ],   z_j = e^{i q_j},
```

where `Q(z)` is the exact quadratic coefficient (`S(z)-I=(z-1)²Q(z)`, verified),
and the bracket is placed in the `Ξ`‑anti‑commuting component so that
`Ξ V(q) Ξ = V(q)^{-1}`‑type odd content, i.e. `V_⊥ ≠ 0`.

Why this is the right shape:

- **Finite Laurent, exactly unitary on `T³`** — inherited from `S` being a
  finite Laurent symbol, unitary on `|z_j|=1` (§1). (Unitarity of the *placed*
  `V` must be re‑checked for the chosen embedding — see F4.)
- **Full Dirac first jet preserved — exactly, for free.** Because
  `S(1)=I` and `dS/dz|_{1}=0` (both verified), `S-I=(z-1)²Q` has **no constant
  and no linear jet**. Hence `V(0)=I₄`, `dV(0)=0`, and
  `U_E(q)=diag(U₊,U₋) + O(q²)` reproduces the constant *and* linear jets of the
  Dirac tangent identically. This is the decisive use of the quadratic flatness
  the oracle proved.
- **Leaves the control class by design** — `V_⊥ ≠ 0` means `[U_E,Ξ]≠0` starting
  at quadratic order, which is exactly the A5 escape resource.
- **No isolation is claimed.** By §5 this ansatz has *no* symmetry protecting
  its `±1` crossings; whether it removes the aliases is **open** and must be
  settled by the B4 torus certificate (§6d). Do **not** advance it as a
  solution without that certificate.

### 6b. Ansatz P (the exact fixture) — in‑sector reciprocal dressing (pairing‑preserving)

To exhibit that the reciprocal primitive *can* preserve both the jet and the
spectral pairing, dress **inside each Weyl sector’s spin space** (never on the
register):

```
U_P(q) = ( U₊(q) · S_word(q) )  ⊕  ( U₋(q) · S_word(q) ),
S_word(q) = S(e^{i q·a}) S(e^{i q·b}) S(e^{i q·c}),   acting on spin, not on Ξ.
```

Provable properties (a clean fixture, all following from §1):

- unitary on `T³`; `[U_P,Ξ]=0` by block form; `det U_P|_{±}=det U_± · det S_word = 1·1 = 1`;
- `S_word(0)=I`, `dS_word(0)=0` ⇒ full Dirac first jet preserved exactly;
- hence **every `±1` crossing is codim‑3 isolated** (§4).

`U_P` is the honest witness that "jet + reciprocal‑pairing" is *simultaneously
achievable*. It is **not an escape**: it lives in the control class, so A3/A4
predict it cannot gap the doubler corners — it retains the alias structure. Its
value is as a positive fixture / regression anchor and as the object the escape
must *fail to reduce to*.

### 6c. Killer counterexample (independently reproduced mechanism)

The naive register embedding
`U_cand = (S_word ⊗ I₂)·diag(U₊,U₋)` is the killer: I verified
`‖[U_cand,Ξ]‖ ≈ 1.0 ≠ 0`, so it satisfies *neither* conjunct of §4. By §3 its
`±1` locus is codim‑1, matching the report’s eigenphase‑zero sheet and
determinant sign change. **Placing the reciprocal word on the chirality
register, rather than in‑sector, is the exact error.**

### 6d. Mandatory certificate before any global claim

Encode `z_j=c_j+i s_j`, `c_j²+s_j²=1`; saturate away the intended origin; and
return a Gröbner / resultant / Positivstellensatz certificate that
`det(U_E-I)` and `det(U_E+I)` have **no other common torus root**. Until such a
certificate exists and is kernel‑ or exact‑checker‑decided, **no global alias
removal may be asserted** for Ansatz E. A one‑corner fixture and sixteen gapped
points are construction evidence only.

---

## 7. Severity‑ranked findings

| ID | Severity | Finding |
|---|---|---|
| **F1** | **High** | The Lean target has **zero completed proofs** (18 `sorry`). Every headline result (`det=1`, quadratic flatness, `S(-1)`, gap determinants, unitarity) is currently unproved in Lean, though all are *exactly true* (§1). Until the ladder in §8 lands, "Lean target typechecks with proof holes" must not be read as "verified." |
| **F2** | **High** | The naive‑embedding kill is **not independently reproducible** from the supplied documents: `U₊,U₋` are undefined, so the witness `(-0.6896…,1.7624…,1.4559…)`, the `6e-9` singular value, and "gaps all sixteen fixtures" are external numeric assertions (VERIFY). The *mechanism* (codim‑1 sheet from broken det‑locking) is verified and forced (§3). |
| **F3** | **High (conceptual)** | Generic eigenvalue‑one roots after the naive embedding are **expected, not a defect**: eigenphase‑zero is codim‑1 by default and only det‑locking (`SU(2)` in the crossing subspace) upgrades it to codim‑3. Any narrative treating them as "surprising" or removable by parameter tuning is wrong. |
| **F4** | **Medium** | "Palindromic characteristic polynomial," "chiral," "symplectic/Kramers," and "particle‑hole" are each **insufficient** to isolate `±1` crossings: palindromicity/PH are automatic for unitaries; chiral gives codim‑2 nodal lines; symplectic gives codim‑1 surfaces. The minimal sufficient structure is **`[U,Ξ]=0 ∧ det U|_{±}=1`** (§4). A memo sentence listing those four as interchangeable options should be corrected. |
| **F5** | **Medium** | **Central tension (§5):** the isolating structure *is* the trivial control class, and the escape *requires* breaking it. Hence isolation for any real escape is **not symmetry‑protected** and demands an explicit torus root certificate (F6). This should be stated as a gating requirement, not a hope. |
| **F6** | **Medium** | Ansatz E must not be promoted without a Gröbner/resultant/Positivstellensatz **torus root certificate** (§6d). "No global alias removal without a certificate" is binding. |
| **F7** | **Low** | Ansatz P (in‑sector dressing) is a clean, provable fixture showing jet+pairing are jointly achievable, but is in the control class and therefore *cannot* be an escape; it should be labelled a regression anchor, not progress toward the 3+1 goal. |
| **F8** | **Low** | `reciprocalRegulator_det` correctly needs only `z≠0`; the unitarity lemmas correctly need `|z|=1`. The one stated unitarity lemma `conditionalShift_unitary` additionally needs `z≠0` (already present) — no missing hypothesis found here, but the `shiftCoinCommutator`/`reciprocalRegulator` unitarity lemmas silently rely on `coinInv = coin^†` (true, `C∈SO(2)`); make that lemma (`coin_conjTranspose`) a prerequisite edge in the ladder so the dependency is explicit. |
| **F9** | **Low** | The symbol has a genuine `z^{-2}` pole (S10, S11 denominators `625 z²`). Harmless on the torus but means any "finite Laurent range" statement must quote the range `[-2,2]`, not "polynomial." |

---

## 8. Theorem ladder (dependency‑ordered; no code edits performed)

Rung 0 — algebraic primitives (discharge first; each is exact):
1. `coin_mul_coinInv`, `coinInv_mul_coin` — `C C^{-1}=C^{-1}C=I`.
2. `coin_conjTranspose : coin^† = coinInv` — the `SO(2)` fact powering all unitarity (F8).
3. `coin_unitary`, `conditionalShift_conjTranspose`, `conditionalShift_unitary` (needs `z≠0`, `|z|=1`).
4. `isUnitary2_mul` — closure of `IsUnitary2` under product.

Rung 1 — regulator identities (pure algebra, no circle hypothesis):
5. `reciprocalRegulator_one : S(1)=I`.
6. `reciprocalRegulator_det : det S = 1` (needs only `z≠0`).
7. `reciprocalRegulator_sub_one_factor : S(z)-I=(z-1)²•Q(z)` (needs `z≠0`) — implies `dS/dz|₁=0`.
8. `reciprocalRegulator_neg_one : S(-1)=(1/625)[[-527,336],[-336,-527]]`.
9. `neg_one_det_sub_one = 2304/625`, `neg_one_det_add_one = 196/625`,
   `neg_one_has_no_zero_or_pi_crossing` (both `≠0`), `conditionalShift_neg_one_noncentral`.

Rung 2 — unitarity on the circle (needs `z≠0 ∧ starRingEnd ℂ z = z⁻¹`):
10. `shiftCoinCommutator_unitary`, then `reciprocalRegulator_unitary`
    (from rung 0.2–0.4).

Rung 3 — embedding lemmas to be *added* for the 4×4 program (new statements,
stated here, not written into code by this audit):
11. `naive_register_breaks_chirality : ∃ q, U_cand q * Ξ ≠ Ξ * U_cand q`  — the
    killer (F2/F3), matching the numeric `‖[U_cand,Ξ]‖≈1`.
12. `insector_dressing_pairing : [U_P,Ξ]=0 ∧ ∀q, det (U_P q|_{±}) = 1` — Ansatz P
    (F7); with it, `insector_dressing_crossings_isolated`.
13. `insector_dressing_first_jet : U_P q = diag(U₊,U₋) q + O(q²)` from
    `S_word(0)=I`, `dS_word(0)=0` (rungs 1.5, 1.7).
14. `escape_first_jet : U_E q = diag(U₊,U₋) q + O(q²)` (same jet lemmas) — Ansatz E.
15. `escape_is_chirality_odd : (U_E - Ξ U_E Ξ)/2 ≠ 0` — leaves the control class.
16. **(GATE)** `escape_torus_root_certificate` — Gröbner/Positivstellensatz that
    `det(U_E ∓ I)` vanish on `T³` only at the intended origin. **No global
    claim before this rung.** (§6d, F6.)

Rungs 0–2 are exactly the current Lean file’s `sorry`s and are all true as
stated (§1). Rungs 3.11–3.15 are finite algebra. Rung 3.16 is the only hard,
open, certificate‑bearing step and is where the 3+1 question actually lives.

---

## 9. What this audit did *not* establish

- It did **not** run the project build (per instruction) and did **not** edit
  any code. The Lean `sorry`s remain.
- It did **not** reproduce the report’s exact naive‑embedding witness (F2);
  `U₊,U₋` are unspecified. A local toy with `U_±=exp(∓i Σ sin q_j σ_j)` did not
  hit the sheet on a 41³ grid, confirming the sheet is `U_±`‑specific, not
  universal — consistent with, but not a substitute for, the report’s numbers.
- It makes **no** global alias‑removal claim for any ansatz; Ansatz E is a
  candidate gated on rung 3.16.
