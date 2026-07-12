# Reciprocal family-level sign obstruction — hostile audit

Date: 2026-07-12. Reviewer: Aristotle (independent, adversarial).
Scope: the **"Exact family-level sign obstruction"** subsection of
`B_RECIPROCAL_CONDITIONAL_SHIFT_ORACLE_2026-07-11.md` and the matching
"Family-level oracle kill" bullet of `MEMO_3PLUS1_ATTACK.md` §5 B3a, restricted
to the **one-parameter naive reciprocal 4×4 embedding family**

```
c = (1-r^2)/(1+r^2),   s = 2r/(1+r^2),     C(r) = [[c,s],[-s,c]]
D(z) = diag(z,1),  K(z) = D(z) C D(z^-1) C^-1,  S(z) = K(z) K(z^-1)
U_cand(q) = ( S(e^{iq_x}) S(e^{iq_y}) S(e^{iq_z}) ⊗ I_2 ) · diag( U_+(q), U_-(q) ).
```

**No project build was run** (per instruction) and **no code was edited**. All
symbolic claims below were re-derived from scratch with exact rational
arithmetic in a transient CAS session (SymPy, rationals only; every equality is
an exact `simplify(... ) == 0` check, not a float comparison). Nothing in this
report asserts a no-go beyond this single naive-embedding family.

---

## 0. Verdict in one paragraph

**Both published rational-parameter formulas are exactly correct and I
reproduced them symbolically over ℚ(r).** The cube-corner value equals
`det(S(-1;r)+I)^2` on the nose; the mixed-sign body-center value equals
`det(W·σ_z − I)^2` on the nose, where `W = S(i)S(i)S(-i)` is the body-center
reciprocal word. The exceptional real `r` at which the strict sign pattern
(`body center < 0` **and** `corner > 0`) breaks down is exactly the finite set
`{0, ±1, ±(√2−1), ±(√2+1)}` (seven values). Both endpoint `S`-word factors are
**exactly unitary** for the whole family (verified `S^† S = I` symbolically at
`z = i, −i, −1`). **However**, three load-bearing hypotheses are *not* stated
in the source and are the real content of this audit: (F-A, High) the Dirac
blocks `U_±(q)` are **undefined everywhere in the supplied documents**, so the
*coefficients and sign* of both formulas are only reproducible after **choosing**
`U_±` — I exhibit choices that reproduce them exactly, but the choice is not
pinned down by the source; (F-B, High) the "determinant changes sign ⇒ new
root" step is a **real** intermediate-value argument, yet `det(U_cand(q)−I)` is
in general **complex**, and its reality is equivalent to `det U_cand(q) = 1`
along the path — a paired-determinant condition on `U_±` that must be assumed;
(F-C, Medium) the phrase "continuity along **any** path forces an additional
root" is too strong for the *distinct-from-origin* conclusion: it holds for any
**origin-avoiding** path along which reality holds, and such a path exists. With
those three hypotheses made explicit the sign obstruction is valid and the
conclusion "a zero-quasienergy root distinct from the intended origin" is
correct.

---

## 1. Convention reconstruction and the per-sector factorization

The two published values are pure functions of `r`, yet `U_cand` contains the
`q`-dependent, **undefined** Dirac blocks `U_±`. The only way a pure-`r` answer
can appear at a *fixed* torus point `q₀` is that `U_±(q₀)` are fixed constant
matrices there. Writing the 4×4 space as `band ⊗ chirality`, the stated
`S_word ⊗ I_2` acts trivially on the chirality register and
`diag(U_+,U_-) = U_+⊗P_+ + U_-⊗P_-` is diagonal in that register, so the product
is **block-diagonal in chirality**:

```
U_cand = (S_word · U_+) ⊗ P_+  +  (S_word · U_-) ⊗ P_-
det( U_cand − I ) = det( S_word·U_+ − I ) · det( S_word·U_- − I ).           (★)
```

Identity (★) is the convention under which the published formulas *do*
reproduce; it is used silently. **Convention consistency check.** (★) requires
that the register on which `⊗ I_2` is the identity is the **same** register over
which `diag(U_±)` is diagonal (the chirality register), and that `S_word` acts
on the *other* (band) register. This is internally consistent, but note the
tension with `RECIPROCAL_EMBEDDING_AUDIT_REPORT.md` §3, which describes the same
object as "`S` acts **on the chirality register**." Under the literal §3 reading
`S_word` would mix the two chirality blocks, (★) would fail, and the clean
factorization would not hold. The two documents therefore use **opposite**
register conventions; the family formulas are consistent only with the
band/chirality assignment giving (★). This should be stated once and used
uniformly (see F-D).

Because `det S(z) = 1` identically (re-verified), (★) simplifies to a fact that
is decisive for the whole obstruction:

```
det( S_word·U_± − I )  has  det( S_word·U_± ) = det U_± ,                     (♦)
```

i.e. **the reciprocal primitive contributes nothing to the determinant phase of
either sector** — the sign machinery is entirely carried by `det U_±`.

---

## 2. Independent derivation of the two formulas (exact, PASS)

Exact building blocks for the family (all re-derived; `S^†S=I` at each point):

| quantity | exact value |
|---|---|
| `det( S(-1;r) − I )` | `64 r²(r−1)²(r+1)² / (r²+1)⁴` |
| `det( S(-1;r) + I )` | `4 (r²−2r−1)²(r²+2r−1)² / (r²+1)⁴` |
| `det( S(i;r) − I ) = det( S(-i;r) − I )` | `16 r²(r−1)²(r+1)² / (r²+1)⁴` |
| `det( S(i;r) + I ) = det( S(-i;r) + I )` | `4 (r⁴−2r³+2r²+2r+1)(r⁴+2r³+2r²−2r+1) / (r²+1)⁴` |

Write `X = r²−2r−1`, `Y = r²+2r−1` (so `X·Y = r⁴−6r²+1`).

**Cube corner `(π,0,0)`** — here `S(1)=I`, so `S_word = S(-1;r)`. Taking
`diag(U_+,U_-) = −I₄` at that corner (the natural corner normalization), (★)
gives `det(U_cand−I) = det(−S(-1)−I)² = det(S(-1)+I)²`, hence

```
det(U_cand − I)|_(π,0,0) = ( 4 X²Y²/(r²+1)⁴ )² = 16 X⁴Y⁴ / (r²+1)⁸ .
```

This **equals the published corner formula exactly** (CAS: difference `= 0`).

**Mixed-sign body center `(π/2,π/2,−π/2)`** — here `z=(i,i,−i)`,
`S_word = W = S(i)S(i)S(-i)`, with `det W = 1`. Taking a per-sector Dirac block
of **determinant −1** (concretely `U_+ = U_- = σ_z`, `det σ_z = −1`), (★) gives
`det(U_cand−I) = det(W·σ_z − I)²`, and

```
det(U_cand − I)|_(π/2,π/2,−π/2)
    = det(W·σ_z − I)²
    = −256 r⁴(r−1)⁴(r+1)⁴ X⁸ Y⁸ / (r²+1)²⁴ .
```

This **equals the published body-center formula exactly** (CAS: difference `= 0`).

Two remarks a hostile reviewer must keep:

* The clean factors `X = r²−2r−1`, `Y = r²+2r−1` are **the exact factors of
  `det(S(-1;r)±I)`**, i.e. of the *cube-corner* determinant `z=−1`. They are
  **not** the factors of the raw body-center `S`-word: `det(W−I)` and `det(W+I)`
  factor through the *irreducible* degree-8 polynomials `r⁸−4r⁶+30r⁴−20r²+9`
  and `9r⁸−20r⁶+30r⁴−4r²+1`, and `det(S(i)+I)` factors through the quartics
  `r⁴∓2r³+2r²±2r+1` — none of which is a power of `X` or `Y`. The `X⁸Y⁸`
  appearing at the body center therefore **does not come from the reciprocal
  word there**; it is manufactured by the (unstated) `U_±` block. This is
  concrete evidence that the body-center formula is genuinely `U_±`-dependent
  and not a property of the reciprocal primitive alone (see F-A).

* The negative sign is **not** a determinant of a negative matrix; it is a
  **square of a purely imaginary number**. `det(W·σ_z) = det W · det σ_z = −1`,
  and for any unitary `V`, `det(V−I) = det V · conj(det(V−I))`; hence
  `det V = 1 ⇒ det(V−I)∈ℝ` while `det V = −1 ⇒ det(V−I)∈ iℝ`. At the corner
  each sector has `det = +1` (real factor, positive square); at the body center
  each sector has `det = −1` (imaginary factor, negative square). **The sign
  flip between the two torus points is exactly the flip of the per-sector
  determinant `det U_±` from `+1` to `−1`** (via (♦)). This is the mechanism —
  and it lives entirely in `U_±`, not in `S`.

---

## 3. Endpoint unitarity (exact, PASS)

All momentum values occurring at the two endpoints lie on the unit circle
(`z = i, −i, −1`), where `z^{-1} = \bar z`. For the entire family (`r` real):

```
S(i;r)^† S(i;r) = S(-i;r)^† S(-i;r) = S(-1;r)^† S(-1;r) = I,   det S = 1.
```

Verified symbolically (each `S^†S − I` simplifies to the zero matrix). Hence the
reciprocal factor `S_word ⊗ I_2` is exactly unitary at **both** endpoints, and
`U_cand` is exactly unitary at both endpoints **provided** `diag(U_+,U_-)` is
unitary there (true for any unitary Dirac blocks; `−I₄` and `σ_z⊕σ_z` used above
are unitary). So the two endpoint matrices remain exactly unitary. The `z^{-2}`
Laurent pole of `S` is off the circle and never reached. **PASS**, with the
caveat that unitarity of the *full* `U_cand` still rests on `U_±` being unitary,
which is assumed, not exhibited.

---

## 4. Exceptional real `r` where strict signs fail (complete census)

Both published expressions have only **even** exponents in every factor, and
`(r²+1) > 0` for all real `r`, so:

* **Body center** `= −256 · r⁴(r−1)⁴(r+1)⁴ X⁸ Y⁸ / (r²+1)²⁴ ≤ 0` for all real
  `r`, and `= 0` **iff** some factor vanishes:
  `r ∈ {0, 1, −1} ∪ {X=0} ∪ {Y=0}`.
* **Cube corner** `= 16 · X⁴ Y⁴ / (r²+1)⁸ ≥ 0` for all real `r`, and `= 0`
  **iff** `r ∈ {X=0} ∪ {Y=0}`.

with `X = r²−2r−1 = 0 ⇔ r = 1±√2` and `Y = r²+2r−1 = 0 ⇔ r = −1±√2`, i.e.

```
{X=0} ∪ {Y=0} = { √2−1, −(√2−1), √2+1, −(√2+1) }  ≈ {±0.41421, ±2.41421}.
```

**Strict body-center negativity fails exactly at**
`r ∈ {0, ±1, ±(√2−1), ±(√2+1)}` (seven values; there the value is `0`).
**Strict corner positivity fails exactly at**
`r ∈ {±(√2−1), ±(√2+1)}` (four values; there the value is `0`).

**Combined exceptional set** (either strict sign fails, so the sign obstruction
degenerates):

```
r ∈ { 0, 1, −1, √2−1, −(√2−1), √2+1, −(√2+1) }        (seven real values).
```

Interpretation of each exception (all benign / expected):

* `r = 0`: `C(0)=I`, hence `K≡I`, `S≡I`; the regulator is the identity and
  `U_cand = diag(U_+,U_-)` — the body-center determinant is automatically `0`
  because the "obstruction" object is trivial. Not a counterexample to anything.
* `r = ±1`: `θ = ±π/2` coin, `C = [[0,±1],[∓1,0]]`; body-center value `0` but
  corner value **positive** (`X,Y ≠ 0` there), so only the body-center endpoint
  degenerates.
* `r = ±(√2−1)`, `±(√2+1)`: the `θ ∈ {±π/4, ±3π/4}` coins; here **both**
  endpoints vanish simultaneously (`X` or `Y` divides both formulas), so the
  endpoint matrices themselves already carry a zero-quasienergy mode and the
  interval argument is vacuous rather than false.

Coverage note (not an exceptional-sign point, but a family-coverage gap): the
tangent-half-angle map `r ↦ (c,s)` is injective for finite real `r` and **omits
`θ = π`**, i.e. the coin `C = −I` (`r = ∞`). The obstruction is stated for finite
real `r` only; the `−I` coin is outside the parameterized family. The formulas
are also **even in `r`** (`X(−r)=Y(r)`), so the whole sign census is symmetric
under `r ↦ −r`.

---

## 5. The determinant-reality assumption (central finding)

The published argument is: `det(U_cand−I)` is negative at the body center,
positive at the corner, so *by continuity* a zero of `det(U_cand−I)` lies
between them. **This is an intermediate-value argument and it requires
`det(U_cand−I)` to be real-valued along the path.** For a general unitary `U`,
`det(U−I)` is complex, and a continuous complex path from a negative real to a
positive real **need not pass through 0**. So reality is not optional.

From `det(U−I) = det U · conj(det(U−I))` we get the exact criterion

```
det(U_cand(q) − I) ∈ ℝ   ⇔   det U_cand(q) = 1
det U_cand(q) = det(S_word)² · det U_+(q) · det U_-(q) = det U_+(q)·det U_-(q),
```

using `det S_word = 1`. Therefore the IVT step is valid **iff the two Weyl
sectors have reciprocal determinants along the path**:

```
det U_+(q) · det U_-(q) = 1     for all q on the chosen path.               (R)
```

Condition (R) is a **paired-spectrum / particle-hole determinant condition** on
the Dirac blocks. It is exactly the "spectral pairing that keeps crossings
isolated" whose loss `RECIPROCAL_EMBEDDING_AUDIT_REPORT.md` §3 blames for the
generic roots — but here it is needed in the *opposite* direction: it is what
makes the sign obstruction's own IVT legitimate. Note (R) is **weaker** than
per-sector unimodularity `det U_± = 1`: the endpoints realize (R) via
`(det U_+,det U_-) = (+1,+1)` at the corner and `(−1,−1)` at the body center,
i.e. the individual sector determinants **flip sign together** (that joint flip
is precisely what drags the real value `det(U_cand−I)` through `0`). If the two
sector determinants flip at *different* momenta, then on the sub-interval
between them `det U_cand = −1`, `det(U_cand−I)` is purely imaginary, and the
real IVT is inapplicable. **(R) is nowhere stated in the source and is the
single most important missing hypothesis.**

Because `U_±` is undefined, whether (R) actually holds is unverifiable from the
documents. It is a natural convention for a Dirac walk, and the two endpoint
values *are* real, which is consistent with (R) holding at least at the
endpoints — but "consistent at the endpoints" is not "holds along a path."

---

## 6. Sharpest continuity theorem

Let `X = r²−2r−1`, `Y = r²+2r−1`, `E = {0, ±1, ±(√2−1), ±(√2+1)}`.

> **Theorem (sharp reciprocal family sign obstruction).**
> Fix a real `r ∉ E`. Assume the Dirac blocks `U_±` are continuous and unitary
> on `T³`, and let `γ : [0,1] → T³` be **any** continuous path with
> `γ(0) = (π/2,π/2,−π/2)`, `γ(1) = (π,0,0)` such that
> (i) `γ(t) ≠ (0,0,0)` for all `t` (origin-avoiding), and
> (ii) `det U_+(γ(t))·det U_-(γ(t)) = 1` for all `t` (reality condition (R)).
> Suppose moreover the endpoint block normalizations are those for which the
> published values hold, i.e. `det(U_cand(γ(0))−I) < 0` and
> `det(U_cand(γ(1))−I) > 0` (equivalently: the per-sector determinants are
> `(−1,−1)` at the body center and `(+1,+1)` at the corner). Then the real
> continuous function `f(t) := det(U_cand(γ(t)) − I)` satisfies `f(0) < 0`,
> `f(1) > 0`, so there is `t⋆ ∈ (0,1)` with `f(t⋆) = 0`. Hence
> `U_cand(γ(t⋆))` has eigenvalue `+1`, i.e. a **zero-quasienergy** crossing, at a
> momentum `γ(t⋆) ≠ (0,0,0)` — a root **distinct from the intended origin**.

Proof content: (R) makes `f` real (§5); `f` is a rational-trigonometric hence
continuous function of `t`; the endpoint signs are the two verified formulas of
§2 evaluated at `r ∉ E` (strict signs, §4); IVT delivers `t⋆`; `f(t⋆)=0 ⇔ 1 ∈
spec U_cand(γ(t⋆))` gives quasienergy `0` (not `π`, which would be
`det(U_cand+I)=0`); origin-avoidance gives distinctness. ∎

Two sharpness clauses that correct the source wording:

* **"Any path" is false as stated for the distinct-root conclusion.** Drop
  origin-avoidance (i) and a path may reach the origin, where the forced root
  can *be* the origin — not a new root. The correct quantifier is *"there exists
  an explicit origin-avoiding path, e.g. the coordinatewise-linear (geodesic)
  path"*: parameterize `q_x` monotonically from `π/2` to `π` (so `q_x ∈ [π/2,π]`
  never `≡ 0 (mod 2π)`), `q_y` from `π/2` to `0`, `q_z` from `−π/2` to `0`; this
  never simultaneously zeroes all three coordinates, so it avoids the origin.
  Any such path works.
* **The root is a genuinely new zero-quasienergy mode**, not the origin's mode
  extended: `t⋆ ∈ (0,1)` is interior (endpoints are non-roots for `r ∉ E`), and
  the path avoids the origin, so `γ(t⋆)` is a distinct momentum. The theorem
  does **not** claim uniqueness, multiplicity, or codimension of the new root —
  only its existence and distinctness.

---

## 7. Hidden-assumption attacks (branch / reality / path / block data)

* **Branch cuts — CLEAR.** `z_j = e^{iq_j}` is single-valued; every published
  factor carries an **even** exponent, so the sign of each formula is
  unambiguous and no square-root branch enters. The only irrational data are the
  exceptional roots `±(√2±1)`, which are ordinary algebraic points, not branch
  loci. No branch assumption is hidden.
* **Determinant reality — LOAD-BEARING, UNSTATED (F-B).** See §5: the IVT needs
  (R) `det U_+·det U_- ≡ 1` along the path. Without it `det(U_cand−I)` is complex
  and "sign change" is meaningless. This is the dominant hole.
* **Path identification — PARTIALLY OVERSTATED (F-C).** "Any path" must be
  narrowed to origin-avoiding paths satisfying (R); such paths exist (§6), so
  the *conclusion* survives, but the *quantifier* in the source is wrong.
* **Block data `U_±` — UNDEFINED (F-A).** `U_+, U_-` appear nowhere in
  `B_RECIPROCAL_CONDITIONAL_SHIFT_ORACLE_2026-07-11.md`,
  `MEMO_3PLUS1_ATTACK.md`, or `RECIPROCAL_EMBEDDING_AUDIT_REPORT.md`. The
  coefficients `−256`, `16`, the powers, and above all the **sign** of each
  formula are `U_±`-dependent (§2, (♦)). I reproduced both formulas exactly with
  explicit choices (`−I` at the corner; a `det=−1` block at the body center),
  which shows the published expressions are *internally consistent and correct
  for a suitable block*, but the source does not pin the block, so the two
  numbers are **external oracle assertions until `U_±` is written down**. This
  matches, and sharpens, F2 of the prior embedding audit.
* **Register-convention mismatch — DOCUMENTATION BUG (F-D).** §1: the family
  formulas require `S_word` on the band and `diag(U_±)` grading chirality
  (identity (★)), whereas `RECIPROCAL_EMBEDDING_AUDIT_REPORT.md` §3 says `S` acts
  on the chirality register. Both cannot be the operative convention. Fix the
  convention once; if the §3 reading is intended, (★) fails and the clean
  factorization must be re-derived from the full 4×4 determinant.
* **Reality-vs-isolation consistency — OK once (R) is used.** Under (R) but
  *not* per-sector unimodularity, `det(U_cand−I)` is real (one real equation),
  so its zero set is generically codimension 1 — a sheet — consistent with the
  obstruction producing a root along a 1-parameter path. This is *not* in tension
  with "crossings are isolated under `SU(2)⊕SU(2)`": the family precisely lacks
  per-sector unimodularity (the endpoint sectors have `det = −1`), so it sits in
  the codim-1 regime by design.

---

## 8. Severity-ranked findings

| ID | Severity | Finding |
|---|---|---|
| **F-A** | **High** | The Dirac blocks `U_±(q)` are **undefined in every supplied document**. Both family formulas' coefficients and signs depend on `U_±` (via (♦)); the reciprocal word contributes `det = 1` and no sign. The two values are therefore **external oracle assertions**, reproducible only after *choosing* `U_±`. I exhibit exact-reproducing choices, confirming the expressions are correct for a suitable block, but the source must state `U_±` before the formulas are self-contained. |
| **F-B** | **High** | The "determinant changes sign ⇒ new root" step is a **real** IVT, but `det(U_cand−I)` is generally **complex**. Reality along the path is *equivalent* to the paired-determinant condition (R) `det U_+·det U_- ≡ 1`, which is **unstated**. Endpoint reality alone does not license the interval argument. |
| **F-C** | **Medium** | "Continuity along **any** path forces a root" is too strong for *distinct-from-origin*: a path through the origin can force only the origin. Correct statement: **there exists an explicit origin-avoiding path** (e.g. the coordinatewise-linear one of §6) satisfying (R) along which the argument holds. |
| **F-D** | **Medium** | **Register-convention mismatch.** The family formulas need `S_word` on the band with `diag(U_±)` grading chirality (identity (★)); `RECIPROCAL_EMBEDDING_AUDIT_REPORT.md` §3 places `S` on the chirality register. Pick one convention; under the §3 reading (★) fails. |
| **F-E** | **Low** | The clean `X⁸Y⁸` body-center factorization is **not** a property of the reciprocal word: `det(W±I)` and `det(S(i)±I)` factor through *irreducible* degree-8 / quartic polynomials, not powers of `X,Y`. The `X,Y` factors are the `z=−1` (corner) factors and enter the body center only through `U_±`. Prose implying the primitive itself produces `X⁸Y⁸` at the body center is misleading. |
| **F-F** | **Low** | Exceptional-`r` set should be published explicitly as `{0,±1,±(√2−1),±(√2+1)}` with the mechanism per point (§4). `r=0` is the trivial coin `C=I` (`S≡I`); the `θ=π` coin `C=−I` (`r=∞`) is **outside** the parameterized family — a coverage gap, not a sign failure. |
| **F-G** | **Info** | Everything the source calls exact **is** exact: `det S=1`, endpoint unitarity `S^†S=I` at `z=i,−i,−1`, corner `= det(S(-1)+I)²`, body center `= det(Wσ_z−I)²`, all reproduced symbolically over ℚ(r). The obstruction is sound once F-A/F-B/F-C are made explicit. No global no-go beyond this naive-embedding family is claimed or implied. |

---

## 9. Lean theorem ladder (statements only; no code written by this audit)

Dependency-ordered; all rungs 0–4 are finite exact algebra over `ℂ`/`ℝ` and are
true as stated. Rung 5 is the analytic/topological capstone.

Rung 0 — family primitives (exact):
1. `coinFam r := !![c,s;-s,c]` with `c=(1-r^2)/(1+r^2)`, `s=2r/(1+r^2)`;
   `coinFam_unitary`, `coinFam_det_one`, `coinFam_inv = coinFamᵀ`.
2. `Sfam r z := K z * K z⁻¹`, `K z := D z * coinFam r * D z⁻¹ * (coinFam r)⁻¹`;
   `Sfam_det_one : det (Sfam r z) = 1` (needs `z ≠ 0`).

Rung 1 — endpoint unitarity (needs `z ∈ {i,−i,−1}`, all `|z|=1`):
3. `Sfam_unitary_i`, `Sfam_unitary_negI`, `Sfam_unitary_negOne`
   (`(Sfam r z)^† * Sfam r z = 1`).

Rung 2 — exact endpoint sub-determinants:
4. `det_Sfam_negOne_sub_one : det (Sfam r (-1) - 1) = 64 r²(r-1)²(r+1)²/(r²+1)⁴`.
5. `det_Sfam_negOne_add_one : det (Sfam r (-1) + 1) = 4 (r²-2r-1)²(r²+2r-1)²/(r²+1)⁴`.
6. `det_Sfam_i_add_one`, `det_Sfam_i_sub_one` (quartic / `r(r±1)` forms of §2).

Rung 3 — the two structural lemmas that carry the sign:
7. `unitary_det_sub_one_real : IsUnitary V → det V = 1 → (det (V - 1)).im = 0`
   and `unitary_det_sub_one_imag : IsUnitary V → det V = -1 → (det (V - 1)).re = 0`.
   (From `det (V-1) = det V * conj (det (V-1))`.)
8. `chirality_block_det_factor` (identity (★)):
   `det (Ucand - 1) = det (Sword * Uplus - 1) * det (Sword * Uminus - 1)`
   under the band/chirality block convention.
9. `Sword_det_one : det Sword = 1` ⇒ (♦) `det (Sword * U± ) = det U±`.

Rung 4 — the two family formulas and the exceptional set:
10. `family_corner`   : with `Uplus = Uminus = -1` at `(π,0,0)`,
    `det (Ucand - 1) = 16 (r²-2r-1)⁴(r²+2r-1)⁴/(r²+1)⁸`.
11. `family_bodycenter`: with a `det = -1` block at `(π/2,π/2,-π/2)`,
    `det (Ucand - 1) = -256 r⁴(r-1)⁴(r+1)⁴ (r²-2r-1)⁸(r²+2r-1)⁸/(r²+1)²⁴`.
12. `family_corner_nonneg`  : `0 ≤ family_corner r`, `= 0 ↔ r ∈ {±(√2±1)}`.
13. `family_bodycenter_nonpos` : `family_bodycenter r ≤ 0`,
    `= 0 ↔ r ∈ {0,±1,±(√2±1)}`.
14. `family_strict_signs` : `r ∉ {0,±1,±(√2±1)} → family_bodycenter r < 0 ∧ 0 < family_corner r`.

Rung 5 — continuity capstone (the only analytic rung):
15. `family_sign_obstruction` : `r ∉ E → (paired-determinant (R) along γ) →
    (γ origin-avoiding, γ(0)=body center, γ(1)=corner) →
    ∃ t ∈ (0,1), IsEigenvalue (Ucand (γ t)) 1 ∧ γ t ≠ 0`.
    Uses rung 3.7 (reality), rung 4.14 (strict signs), and
    `intermediate_value_Icc` on the real function `t ↦ det (Ucand (γ t) - 1)`.

Rungs 0–4 are immediately dischargeable (rational identities + `IsUnitary`
algebra). Rung 5 is where hypotheses (R) and origin-avoidance become explicit
Lean binders — encoding F-B and F-C as *typed obligations* rather than prose.

---

## 10. Manuscript-safe wording (drop-in)

> Parameterize the rational coin by `c=(1−r²)/(1+r²)`, `s=2r/(1+r²)` and fix the
> band/chirality convention in which the reciprocal word `S(e^{iq_x})S(e^{iq_y})
> S(e^{iq_z})` acts on the band register and the Dirac data enter through a
> chirality-graded factor `diag(U_+,U_-)`. Because `det S ≡ 1`, the
> zero-quasienergy determinant factorizes per chirality sector as
> `det(U_cand−I)=∏_{±} det(S_word U_± − I)`, and each sector's determinant phase
> is carried entirely by `det U_±`. For the endpoint block normalizations with
> `det U_± = +1` at the cube corner `(π,0,0)` and `det U_± = −1` at the
> mixed-sign body center `(π/2,π/2,−π/2)`, one computes exactly
>
> ```
> det(U_cand−I)|_(π,0,0)        =  16 (r²−2r−1)⁴(r²+2r−1)⁴ / (r²+1)⁸ ,
> det(U_cand−I)|_(π/2,π/2,−π/2) = −256 r⁴(r−1)⁴(r+1)⁴ (r²−2r−1)⁸(r²+2r−1)⁸ / (r²+1)²⁴ .
> ```
>
> For every real `r ∉ {0, ±1, ±(√2−1), ±(√2+1)}` the first value is strictly
> positive and the second strictly negative. Provided the two Weyl sectors have
> reciprocal determinants along the chosen path (so that `det(U_cand−I)` is real
> there — automatic when `det U_+·det U_- ≡ 1`), the intermediate-value theorem
> applied along any explicit origin-avoiding path between the two points forces a
> zero of `det(U_cand−I)`, i.e. an additional zero-quasienergy crossing at a
> momentum different from the origin. Thus the entire one-parameter naive
> reciprocal embedding, not only the `3-4-5` coin, fails to isolate the origin
> crossing.
>
> Caveats to state alongside: (a) `U_±(q)` must be defined explicitly — the two
> displayed values depend on the block data, the reciprocal word contributing
> `det = 1` and no sign; (b) the argument is a **real** intermediate-value
> statement and requires `det U_+·det U_- ≡ 1` along the path; (c) "any path"
> must read "any origin-avoiding path" for the crossing to be distinct from the
> origin; (d) this is a statement about the naive chirality-register embedding
> family only and is **not** a no-go for the 3+1 program.

---

## 11. What this audit did *not* do

* Did **not** run the project build and did **not** edit any Lean or other code.
* Did **not** fix `U_±`: I exhibited exact-reproducing block choices to *verify*
  the formulas, but the walk's `U_±` remains externally supplied (F-A).
* Made **no** global alias-removal claim and **no** no-go claim beyond this
  one-parameter naive embedding family; the sharp continuity theorem of §6 is
  gated on the explicit hypotheses (R) and origin-avoidance.
