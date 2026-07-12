# HOSTILE_REVIEW_3 — Adversarial audit of tonight's four landed modules

Review-only. No proofs were added or altered. All line numbers refer to the
verbatim sources under `context/`. Every quotation below is copied verbatim.

Throughout I test each module against four over-claim modes:

* **Mode A — Framing/scope overreach**: a theorem *name* or *docstring* claims
  more than the elaborated statement delivers.
* **Mode B — Completeness gap**: a classification / census / enumeration
  silently omits cases it purports to cover.
* **Mode C — Hypothesis inflation**: an added hypothesis trivializes, is
  vacuous, or is not exhibited to be satisfiable.
* **Mode D — Computational artifact**: a `native_decide`/normalization step
  computes a look-alike, or a scalar hides a rescaling.

---

## 1. `MassCovarianceForcing`

### Mode B — completeness of the two-probe classification (T1)

The load-bearing completeness statement is

> ```
> theorem classification (W : Matrix (Fin 2) (Fin 2) ℂ) (hW : W * Wᴴ = 1)
>     (w1 w2 : ℂ) (h1 : W * massOperator 1 * Wᴴ = massOperator w1)
>     (h2 : W * massOperator Complex.I * Wᴴ = massOperator w2) :
>     IsDiagonal W ∨ IsAntidiagonal W
> ```
> (lines 104–110)

**Could a `W` be covariant at `z = 1, i` but neither diagonal nor
antidiagonal?** No — and the two-probe restriction is genuinely sufficient, not
a shortcut. The hypotheses `h1, h2` are exactly "the image at each probe lands
back in the family" (`= massOperator w1`, `= massOperator w2`); the conclusion
forces `IsDiagonal ∨ IsAntidiagonal`. The complementary theorems then show these
two shapes are covariant *for every* `z`:

> ```
> theorem orientation_preserving ... :
>     W * massOperator z * Wᴴ = massOperator ((W 0 0 * (starRingEnd ℂ) (W 1 1)) * z)
> ```
> (lines 118–121) and the antidiagonal twin `orientation_flip` (lines 128–133).

So the classification does **not** "miss covariances acting nontrivially only at
other `z`": any `W` covariant at the two probes is diagonal/antidiagonal, and
each such `W` is then covariant everywhere with the stated action. The two
probes `z = 1` (`conj z = 1`) and `z = i` (`conj z = -i`) are precisely the pair
that separates the orientation-preserving (`z`) from the orientation-flipping
(`conj z`) action, which is why two suffice. **T1 completeness is genuine.**
The `rotation_not_covariant` control (lines 300–316) correctly witnesses that a
non-diagonal/non-antidiagonal unitary already fails at `z = 1`, so completeness
is load-bearing rather than vacuous.

### Mode A — does "forcing" overreach; is the honest boundary respected?

The honest-boundary paragraph is explicit and correct:

> "This classifies the covariances of the **static** derived family `{B z}`.
> Identifying this covariance group with the dynamical walk commutant is a
> further step and is **not** claimed here." (lines 71–73)

However, the framing in two places reaches past what is elaborated:

* Intro, lines 6–7:
  > "This module upgrades Paper A's selection result from "unique *given* the
  > gauge action" to "the gauge action is itself *forced*"."
* `blockOf_gauge_forced` docstring, lines 264–265:
  > "The selection theorem's constraint is therefore the covariance constraint
  > of the derived family."

`blockOf_gauge_forced` itself only proves the *matrix identity*
`blockOf (DfockL u ∘ₗ H ∘ₗ DfockL u⁻¹) = W * blockOf H * Wᴴ` for a diagonal
unitary `W` (lines ~253–260). The clause "the selection theorem's constraint is
therefore …" is prose linking to a *dynamical* selection result that has no Lean
counterpart in this file. The disclaimer in lines 71–73 covers the walk
commutant, but the intro/`blockOf_gauge_forced` prose still asserts the bridge
to "Paper A's selection result". This is a **contained Mode-A overreach in
docstrings only** — every *theorem statement* stays inside the static scope.

### Mode A (secondary) — T2 covers only one branch

`covariance_group_eq_chiralPhase` (lines ~148–156) identifies **only the
diagonal (orientation-preserving) branch** with `λ • chiralPhase u`. The
"covariance group … *is* the chiral phase circle" reading is accurate only after
the "mod global phase **and orientation**" quotient stated in the docstring; the
antidiagonal flip branch is a separate coset and is not part of the circle. This
is disclosed, so it is a labelling nuance, not a false claim.

**Single strongest objection:** the intro's "the gauge action is itself
*forced*" and `blockOf_gauge_forced`'s "the selection theorem's constraint is
therefore the covariance constraint" import the dynamical selection theorem by
prose; nothing in the file connects the static covariance classification to
Paper A's selection result. **Answerable from the landed statements? Yes,
defensively** — the theorem statements are all static and correct, and the
honest-boundary paragraph pre-empts the dynamical reading; a referee's objection
is to the *marketing*, not the mathematics.

---

## 2. `PairCharpolyBridge`

### Mode D — is the `5^11` factor a normalization artifact?

No. `V.charpoly` is monic of degree 28, and `48828125 = 5^11` is exactly the
product of the leading coefficients of the non-monic rational spectral factors,
which is also visible at the constant term of `charpoly_factorization`
(lines 92–128): evaluating the LHS at `lam = 0` gives
`1 · 1 · 25 · 5² · 5² · p12(0)` with `p12(0) = 3125 = 5⁵` (line 84), i.e.
`25 · 25 · 25 · 3125 = 5⁶ · 5⁵ = 5¹¹`. The `Polynomial.C (48828125 : ℂ) *
V.charpoly` on the LHS of `V_charpoly_eq` (line 257) is therefore the honest
denominator-clearing of a monic rational charpoly, not a hidden rescaling. The
scaling chain is transparent:

> ```
> theorem V_charpoly_scaled :
>     V.charpoly = Polynomial.C (((25 : ℂ)⁻¹) ^ 28)
>       * (Rpoly.map GaussianInt.toComplex).comp (Polynomial.C 25 * Polynomial.X)
> ```
> (lines 242–245), with `V := (25⁻¹ : ℂ) • Vz.map GaussianInt.toComplex` (lines 78–80).

### Mode D — does `native_decide` compute the charpoly, or a look-alike?

The audit's own framing ("4× `native_decide` (28×28 charpoly over ℤ[i])") is
itself inaccurate: **no `native_decide` computes a 28×28 charpoly.** The four
disclosed `native_decide` facts are matrix *arithmetic* and companion facts:

> ```
> theorem hST : SqA * TqA = dscale • (1 : ...) := by native_decide            (line 172)
> theorem hTS : TqA * SqA = dscale • (1 : ...) := by native_decide            (line 174)
> theorem hconj : TqA * VzA * SqA = dscale • BqA := by native_decide          (line 176)
> theorem hBshape : BqA = Matrix.reindex eEquiv eEquiv Bblock := by native_decide (line 186)
> ```
> plus `hA_aeval/hB_aeval` (aeval of a sextic at a companion = 0) and
> `hA_cyc/hB_cyc` (cyclicity), lines 188–201.

The genuine `Matrix.charpoly` is then obtained **structurally, kernel-checked**,
not by a 28! Leibniz expansion: `companion_charpoly` gives the two sextic
companion charpolys (lines 208–211), and
`Matrix.charpoly_fromBlocks_zero₂₁` + `Matrix.charpoly_diagonal` assemble the
block charpoly (lines 215–222), finally transported across the scaled similarity
by `charpoly_conj_of_scaled` (line 229). So charpoly is genuinely computed; the
soundness of this step rests on (i) the `Lean.ofReduceBool` trust of
`native_decide` for the *arithmetic* identities (acceptable), and (ii) the
correctness of the structural lemmas.

### Mode D — same degree-28 RHS as the sibling factorization?

Yes, verbatim. The RHS coefficient list of `V_charpoly_eq` (lines 257–286) is
identical, coefficient by coefficient, to the RHS of `charpoly_factorization`
(lines 99–128) — leading `48828125`, then `-70312500, -35937500, 43312500,
113734375, …` down to constant `48828125`. And `V_charpoly_factored` closes the
loop by *reusing the same lemma*:

> ```
> theorem V_charpoly_factored : ... := by
>   rw [V_charpoly_eq]
>   exact (charpoly_factorization (R := Polynomial ℂ) Polynomial.X).symm
> ```
> (lines 298–306)

so the factored product and the degree-28 RHS are provably the same object.

### The real defect (Mode outside A–D) — the module is not verifiable as landed

`context/PairCharpolyBridge.lean` opens with `import PairCharpolyBridgeAux`
(line 2), but **no such file exists anywhere in the delivered tree** (searched:
absent). Every decisive lemma/definition — `Rpoly`, `prod_eq_Rpoly`,
`charpoly_conj_of_scaled`, `companion_charpoly`, `charpoly_smul`, `diag16f`,
`P6aZ`, `P6bZ`, `eEquiv` — lives in that missing dependency. Consequently a
referee cannot, from `context/` alone, confirm that `Rpoly` is `Vz.charpoly`,
that `prod_eq_Rpoly` matches the displayed coefficients, or that
`charpoly_conj_of_scaled`/`companion_charpoly` are faithful statements about
Mathlib's `Matrix.charpoly` (as opposed to a look-alike defined in the Aux
file). The `context` lake target would not even build without it.

**Single strongest objection:** the module's charpoly bridge is only as sound as
the *unshipped* `PairCharpolyBridgeAux`, which houses `Rpoly`,
`charpoly_conj_of_scaled`, and `companion_charpoly`; from the landed source one
cannot rule out that `charpoly`/`Rpoly` there are look-alikes. **Answerable from
the landed statements? No** — the decisive lemmas are not present in `context/`.
(The *specific* audit worries — `5^11`, native_decide, matching RHS — are all
cleanly answerable and check out.)

---

## 3. `SplitStepSchurJetAllNodes`

### Mode B/D — is the `(-1)^parity` collapse `U_n = (-1)^parity · U0` exact?

Yes, exactly, and no `3π/2` factor escapes it. The two transcendental values are
pinned correctly:

> ```
> lemma cos_three_pi_div_two : Real.cos (3 * Real.pi / 2) = 0    (line 542)
> lemma sin_three_pi_div_two : Real.sin (3 * Real.pi / 2) = -1   (line 546)
> ```

so each node factor is a clean scalar times the central factor:

> ```
> lemma E_node (M : Mat4) (b : Bool) : E M (qval b) = signOf b • (I • M)   (line 553)
> ```
> with `signOf b = if b then -1 else 1` (line 529).

Because scalar multiplication commutes through the matrix product
`U = Bmat * E α3 * E α2 * E α1` (def lines 102–105), the three per-axis signs
multiply to `nodeParitySign n` and the collapse is the *literal* identity

> ```
> lemma walkNodeAll (n : Fin 3 → Bool) :
>     U (qval (n 0)) (qval (n 1)) (qval (n 2)) = UnodeMat n     (line 590–591)
> ```
> where `UnodeMat n := nodeParitySign n • U0` (line 585).

There is no "sign the parity rule misses": at `3π/2`, `cos = 0` kills the
identity part and `sin = -1` supplies exactly the `-1` that the parity product
already tracks. **The collapse is exactly right.**

### Mode B — does the derived 8-node census MATCH the supplied census, or
silently differ?

Here is the genuine soft spot. The "landed census" is **not imported**; it is
re-declared locally and only *claimed* to be a verbatim copy:

> "this file is self-contained and imports nothing project-local" (line 9)
>
> "The landed census assignment (copied verbatim; `Jplus_census`,
> `Jminus_census` are from the central-node module above)" (line 755)

The `census` function is a local definition (lines ~755–759), and the bridge
theorems tie the *walk* to this *local copy*:

> ```
> theorem census_gap0_derived (n) : census n false = -(walkJac0 n)     (line ~761)
> theorem census_gapPi_derived (n) : census n true = -(walkJacPi n)    (line ~773)
> ```

Internally everything is consistent and fully proved (no `sorry`): the walk
charge table `chargeOf (walkJac0 n) = if nodeParity n then 1 else -1`
(lines ~789–792), the census charge table
`chargeOf (census n false) = if nodeParity n then -1 else 1`
(lines ~811–825), the per-node opposition, and both sum-zero facts
(`walk_sum_zero_gap0`/`walk_sum_zero_gapPi`, lines ~845–862) all discharge by
`decide`/`norm_num`. But the identity between this local `census`,
`Jplus_census`, `Jminus_census` and the *actual* `context/SplitStepChargeBalance`
module is asserted only by the words "copied verbatim". Any drift between the
copy and the landed module would pass unnoticed because there is no import to
force agreement.

Note also the sign convention: the census charge is the **negation** of the walk
charge (`census = -(walkJac)`), so "matches the landed parity rule EXACTLY"
(lines 811, 828) is true *for the copied table*; a referee should check the
landed module uses the same `J_recorded = -J_here` orientation.

**Single strongest objection:** the "tie to the landed census" ties the walk to
a *local re-declaration* labelled "copied verbatim", with no import of
`context/SplitStepChargeBalance.lean`, so machine-checking does not actually
exclude a silent divergence from the landed census. **Answerable from the landed
statements? No** — the target census module is not in `context/`, so the
verbatim-copy fidelity cannot be verified here. (The physics core — exact
`(-1)^parity` collapse, kernel dims, Jacobians, sum-zero — is fully proven and
robust.)

---

## 4. `TwoBandEigenphaseAnalytic`

### Mode C — are `jump_law`'s added hypotheses satisfiable, or vacuous/trivializing?

`jump_law` (lines ~583–606) is proved not for the reference interface but for a
**strengthened** `TwoBandFamily`/`CrossingData`, with two disclosed additions.
The additions are honestly flagged:

* `CrossingData` second-eigenvalue fields:
  > "**(documented strengthening for the jump law (b)).**  The second
  > eigenvalue, presented as a continuous local branch `other`.  The reference
  > statement of the jump law was under-specified … this field supplies exactly
  > the missing transversal datum, and is genuinely available for a smooth
  > two-band walk." (the `other`/`hother`/`hroots`/`hother_ne` fields)
* `TwoBandFamily.hclean`:
  > "**(documented strengthening for the jump law (b)).**  Cleanliness of each
  > bracket … which is why the jump law was not provable as literally stated; it
  > holds for a genuine two-band walk whose crossing list is complete."
  > ```
  > hclean : ∀ i : Fin cs.length, ∀ k ∈ Set.Icc (sample i) (sample (i + 1)),
  >     k ≠ (cs[i]).momentum →
  >       (U k).charpoly.eval 1 ≠ 0 ∧ (U k).charpoly.eval (-1) ≠ 0
  > ```

**(a) Satisfiable for a real two-band walk?** Yes. At a genuine single-band
transversal `±1` crossing the two eigenvalues are distinct there (one at `±1`
real, the other with `hother_ne : (other c.momentum).im ≠ 0`), so a continuous
local eigenvalue splitting `other` exists on a neighbourhood (`hroots`), and by
choosing the samples close enough the other band stays away from `±1`
(`hclean`). So the fields are **not vacuous / not unsatisfiable**.

**(b) So strong they trivialize the claim?** Not logically. `hclean` is exactly
the fact that makes both half-bracket counts constant via
`countAt_locally_constant_aux`, and the conclusion
`F.n (i+1) - F.n i = jumpOf F.cs[i]` remains a non-trivial signed statement
(proved through the fully-elaborated `countAt_local_jump`, lines ~412–~480). The
proof is genuine, not a contradiction-from-hypotheses.

**The real fragility is scope, not vacuity.** `hclean` postulates, *per bracket*,
that the listed crossing is the *only* `±1` event — i.e. it assumes the crossing
list is complete on each bracket. Completeness of the crossing enumeration is
typically the very physical fact one wants to *establish*, and here it is
*assumed*. Worse, **no instance of the strengthened `TwoBandFamily` is
constructed anywhere in the module**, so nothing verifies that any actual walk
symbol satisfies `hclean` + the `other` fields simultaneously. The theorem is
therefore honest but potentially inapplicable: `jump_law` (and the downstream
`flowDiff_eq_zero`, `no_single_crossing'`) hold for the strengthened structure,
whose non-emptiness for a real walk is left to prose ("genuinely available",
"it holds for a genuine two-band walk").

### Mode B/D — is `countAt_locally_constant`'s `imProd`/`imSum` sign argument
valid at the unit-circle boundary?

Yes, and this part is solid. The key definitional choice avoids any square-root
branch ambiguity by using the **modulus**:

> ```
> def imProd (M) : ℝ := ((M.trace.im) ^ 2 - (‖charDiscr M‖ - (charDiscr M).re) / 2) / 4   (lines 156–158)
> ```

`exists_roots` (lines 169–188) proves this equals `r₁.im * r₂.im` exactly: with
`charDiscr M = (r₁ - r₂)²`, one has `(‖Δ‖ - Δ.re)/2 = (Im(r₁-r₂))² =
(r₁.im - r₂.im)²`, so `imProd = ((r₁.im+r₂.im)² - (r₁.im-r₂.im)²)/4 =
r₁.im·r₂.im` — no branch choice enters because `‖Δ‖` is unambiguous. The
boundary case is handled correctly: `imProd = 0` iff an eigenvalue is real, and
for a unitary matrix a real eigenvalue is `±1` (`unitary_root_abs_one`,
lines 203–223; `imProd_ne_zero_of_no_pm_one`, lines 227–244). The interval
hypothesis excludes `±1` eigenvalues, so `imProd (U ·)` is continuous and
non-vanishing, hence sign-constant by IVT (`sign_const`, lines 307–316), and
when the sign is `+`, `imSum (U ·)` is likewise non-vanishing
(`imSum_ne_zero_of_imProd_pos`, lines 248–253). The three sign cases
(`countAt_of_imProd_neg/pos_imSum_pos/pos_imSum_neg`, lines 257–279) then pin
`countAt` to `1/2/0`. **The unit-circle boundary argument is valid**; the
`±1` locus (where `im = 0` on the circle) is precisely the excluded set.

**Single strongest objection:** `jump_law` was reproved only after adding
`hclean` (per-bracket crossing-list completeness) and the continuous second-band
fields, and the module constructs **no `TwoBandFamily` instance** exhibiting a
real walk that satisfies them — so the headline "jump law" may be
non-vacuously *true* yet *inapplicable*, its completeness content assumed rather
than derived. **Answerable from the landed statements? Only partially** — one
can confirm the added hypotheses are satisfiable in principle from the docstrings
and the distinctness at the crossing, but there is no landed witness that a
concrete walk yields such a family, so applicability cannot be discharged from
what is present.

---

## Referee-fragility ranking (most fragile → least)

| Rank | Module | Single strongest objection | Answerable from landed statements? |
|------|--------|----------------------------|-------------------------------------|
| 1 (most fragile) | **TwoBandEigenphaseAnalytic** | `jump_law` proved only under the *added* `hclean` (per-bracket crossing-list completeness) + continuous second-band fields, with **no instance** showing a real two-band walk satisfies them — the claim risks being inapplicable / its completeness assumed. | Partially: satisfiability is arguable, but no landed witness discharges applicability. |
| 2 | **PairCharpolyBridge** | The charpoly bridge depends entirely on the **missing** `PairCharpolyBridgeAux` (`Rpoly`, `charpoly_conj_of_scaled`, `companion_charpoly`); as landed the module cannot be built or verified, and one cannot exclude a `charpoly`/`Rpoly` look-alike. | No: the decisive lemmas are absent from `context/`. |
| 3 | **SplitStepSchurJetAllNodes** | The "tie to the landed census" ties the walk to a **local re-declaration** ("copied verbatim") with no import of `SplitStepChargeBalance`, so a silent divergence from the landed census is not machine-excluded. | No: the target census module is not in `context/`. |
| 4 (least fragile) | **MassCovarianceForcing** | Prose overreach only: the intro ("the gauge action is itself *forced*") and `blockOf_gauge_forced` docstring import Paper A's *dynamical* selection result by words; every theorem statement stays inside the disclosed static scope. | Yes, defensively: statements are correct and the honest-boundary paragraph pre-empts the dynamical reading. |

### One-line verdicts

* **T1 completeness (Module 1)** is genuine: two probes `z = 1, i` suffice; a
  covariant-at-both `W` must be diagonal or antidiagonal, and both shapes are
  then covariant for all `z`. The `forcing` claim overreaches only in prose.
* **`5^11` (Module 2)** is the product of the spectral factors' leading
  coefficients (`25·25·25·p12(0)=25³·5⁵=5¹¹`), not a hidden rescaling; the
  `native_decide` steps compute *matrix arithmetic*, not the charpoly, which is
  assembled by kernel-checked structural lemmas against the *same* degree-28 RHS
  as `charpoly_factorization`. The only defect is the unshipped Aux dependency.
* **`(-1)^parity` collapse (Module 3)** is exact — `cos(3π/2)=0`, `sin(3π/2)=−1`
  supply exactly the tracked sign, pulled through the product as a scalar. The
  census "match" is to a verbatim local copy, not the imported landed module.
* **`imProd`/`imSum` (Module 4)** boundary argument is valid (modulus-based, no
  branch ambiguity; `imProd=0 ⇔` eigenvalue `±1`, excluded). The `hclean`/`other`
  hypotheses are satisfiable and non-trivializing, but unwitnessed by any
  concrete family.
