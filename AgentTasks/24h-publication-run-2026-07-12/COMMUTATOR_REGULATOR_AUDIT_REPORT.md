# Hostile audit report: `CommutatorRegulator.lean`

Scope: semantic and algebra audit of `CommutatorRegulator.lean`, cross-read
against `ARISTOTLE_B_COMMUTATOR_REGULATOR_AUDIT.md` and `MEMO_3PLUS1_ATTACK.md`.
No Lean source was edited. All matrix identities, multiplication orders,
counterexamples, the `IsUnitary` predicate, and every possible overclaim toward
Laurent locality, chirality, and root exclusion were checked.

## 0. Verification status (independently reproduced)

- The module builds cleanly (`lake build`, 8027 jobs, no errors).
- No `sorry`, `admit`, `axiom`, or `@[implemented_by]` in the source.
- Axiom profile of the load-bearing results
  (`anticommuting_quarterTurn_eq_neg_one`,
  `exists_failure_without_second_involution`, `exists_noncentral_quarterTurn`,
  `regulator_unitary`, `regulator_quarterTurn_eq`) is exactly
  `{propext, Classical.choice, Quot.sound}` — standard, no `native_decide`/
  `ofReduceBool`.
- All fixture arithmetic was re-checked independently over ℚ (the entries are
  rational; ℂ is faithfully mirrored because every fixture is real-rational),
  by direct `#eval` of the products and `decide` of the equalities. Every
  displayed numeric value below was reproduced this way.

**Bottom line: the file is mathematically sound and, importantly, well-scoped.
Its Lean *statements* do not overclaim. All findings below are documentation /
nonvacuity nuance, plus warnings about not importing memo-level prose as if it
were proved here. Nothing rises above LOW severity.**

---

## 1. Semantic verification of the core objects (all correct)

### 1.1 The four-factor word is exactly the intended group commutator — CORRECT

```
regulator cp sp cq sq A G
  = phaseStep cp sp A * phaseStep cq sq G * phaseStep cp (-sp) A * phaseStep cq (-sq) G
```

With the intended reading `phaseStep c s A = cos·I − i·sin·A ≙ exp(−iθA)` (for
`A²=1`, `c=cosθ`, `s=sinθ`), the factors are `a · b · a⁻¹ · b⁻¹` with
`a = exp(−ipA)`, `b = exp(−iqG)`, `a⁻¹ = exp(+ipA) = phaseStep cp (−sp) A`,
`b⁻¹ = exp(+iqG) = phaseStep cq (−sq) G`. This is exactly the group commutator
`[a,b] = a b a⁻¹ b⁻¹`, matching memo §5 B2
`R(p,q)=exp(−ipA)exp(−iqG)exp(ipA)exp(iqG)`. Order is correct.

### 1.2 `phaseStep` is purely formal and correctly guarded — CORRECT

`phaseStep c s A := (c:ℂ)•1 − (I·(s:ℂ))•A` makes **no** assumption that `A²=1`,
`c²+s²=1`, or `c=cosθ`. Every place the exponential/unitary interpretation is
used (`phaseStep_unitary`, `regulator_unitary`, the reverse-multiplication
lemmas) explicitly carries `hHerm : Aᴴ=A`, `hA : A*A=1`, and
`hcircle : c²+s²=1`. No hidden interpretive leap. Good hygiene.

### 1.3 `phaseStep_conjTranspose` (adjoint order) — CORRECT

`(cI − i s A)ᴴ = c̄ I − conj(i s) Aᴴ = c I + i s A = phaseStep c (−s) A` when
`Aᴴ=A` (`c,s` real). Verified by hand: `conj(I)=−I`, `conj(s)=s`, so the sign of
the `A`-term flips, i.e. `exp(−isA)ᴴ = exp(+isA)`. Matches the lemma.

### 1.4 `regulator_quarterTurn_eq : regulator 0 1 0 1 A G = A*G*A*G` — CORRECT

`phaseStep 0 1 X = −I•X`, `phaseStep 0 (−1) X = I•X`; the four scalar factors
`(−I)(−I)(I)(I) = 1`, leaving `A·G·A·G`. Reproduced.

### 1.5 Trivial-axis reductions — CORRECT

- `regulator_first_axis_zero` (`cp=1,sp=0`): the two `A`-factors become `1`, so
  the word is `phaseStep cq sq G * phaseStep cq (−sq) G = 1` via
  `phaseStep_mul_reverse` (uses `hG`, `hq`). Correct; both hypotheses used.
- `regulator_second_axis_zero` (`cq=1,sq=0`): symmetric, uses `hA`, `hp`.

### 1.6 `IsUnitary` predicate — CORRECT (redundant but sound)

`IsUnitary U := Uᴴ*U = 1 ∧ U*Uᴴ = 1`. For finite square matrices over a field
either conjunct implies the other, so the definition is redundant — but it is a
sound, standard definition of "unitary" and is **not** an overclaim. `isUnitary_mul`
(product of unitaries is unitary) and `regulator_unitary` (the commutator word is
unitary for Hermitian involutions on the circle) are correct; `regulator_unitary`
correctly requires all six hypotheses `hAHerm, hGHerm, hA, hG, hp, hq`.

### 1.7 Central collapse `anticommuting_quarterTurn_eq_neg_one` — CORRECT

For `A²=1`, `G²=1`, `AG=−GA`:
`AGAG = A(GA)G = A(−AG)G = −(A²)(G²) = −1`. Uses **both** involution
hypotheses. This is exactly the memo B2 "negative control" (perfect
anticommutation collapses the high-symmetry quarter turn to central `−I`).
No Hermiticity is needed or claimed — a clean, general statement.

---

## 2. Nonvacuity of the two fixtures (both genuine)

### 2.1 Counterexample `exists_failure_without_second_involution` — GENUINE

`A = diag(1,−1,1,1)`, `G = !![0,2,0,0; 1,0,0,0; 0,…]`. Reproduced:
`A*A = 1` (true), `A*G = −(G*A)` (true anticommutation), and
`regulator 0 1 0 1 A G = diag(−2,−2,0,0)`, whose `(0,0)` entry is `−2 ≠ −1`.
Here `G*G = diag(2,2,0,0) ≠ 1` — this is precisely the dropped hypothesis. The
witness is non-vacuous and correctly refutes any statement of the form
"`A²=1 ∧ AG=−GA ⇒ regulator = −1`". This certifies that `hG` is load-bearing in
§1.7.

### 2.2 Noncentral fixture `exists_noncentral_quarterTurn` — GENUINE

`A = swap⊕I₂` (`[[0,1],[1,0]]` block), `G = [[3/5,4/5],[4/5,−3/5]]⊕I₂`.
Reproduced: `Aᵀ=A`, `Gᵀ=G` (real ⇒ Hermitian), `A*A=1`, `G*G=1`; and
`regulator 0 1 0 1 A G` restricts on the top block to the rotation by `2θ`
(`cos2θ=7/25`, `sin2θ=24/25`), i.e. `[[7/25,−24/25],[24/25,7/25]]⊕I₂`. Its
`(0,1)` entry `−24/25 ≠ 0`, so the regulator is `≠ 1` and `≠ −1`. Both
Hermiticity and involution hold; genuinely non-central. Consistent with
`regulator_unitary` (the block is an orthogonal/unitary rotation).

---

## 3. Severity-ranked findings

### [LOW-1] "Both involution hypotheses are necessary" is only half-witnessed in Lean
`anticommuting_quarterTurn_eq_neg_one`'s docstring asserts both `hA` and `hG`
are necessary. This is **true** — I confirmed the `A`-side: with `A` a
non-involution (`A=[[0,2],[1,0]]` block, `A²≠1`), `G=diag(1,−1,…)` an
involution, `AG=−GA`, the regulator's `(0,0)` entry is `−2 ≠ −1`. However, the
file supplies an explicit counterexample only for the missing-`hG` case
(§2.1); the missing-`hA` case is not formalized. The prose claim is correct but
its Lean evidence is one-sided.
- *Safe wording:* "`hG` is load-bearing (explicit counterexample
  `exists_failure_without_second_involution`); by the symmetric construction
  `hA` is equally necessary, though only the `hG` side is witnessed in Lean."

### [LOW-2] The counterexample's `G` is not Hermitian
The counterexample `G = [[0,2],[1,0]]` block is **not** Hermitian
(`Gᴴ=[[0,1],[2,0]]≠G`). Within `anticommuting_quarterTurn_eq_neg_one` (which has
no Hermiticity hypothesis) this is a fully valid necessity witness. But if the
*physically intended* generators are required Hermitian (Dirac matrices), a
reviewer could object that the witness leaves the Hermitian sub-case open. It
does not: a Hermitian witness also exists — `G=[[0,2],[2,0]]` block
(`Gᵀ=G`, `G²=4I≠I`), anticommuting with `A=diag(1,−1)`, gives regulator
`(0,0)=−4 ≠ −1` (reproduced). So the necessity of `hG` survives even under
Hermiticity.
- *Safe wording:* "Dropping `G*G=1` breaks the collapse even among Hermitian
  generators (Hermitian witness `G=[[0,2],[2,0]]⊕0` gives regulator `−4I` on the
  block); the recorded witness uses a non-Hermitian `G`, which is admissible
  because the theorem imposes no Hermiticity."

### [LOW-3] "different from both central values" understates and slightly overloads "central"
`exists_noncentral_quarterTurn`'s statement proves only `regulator ≠ 1` **and**
`regulator ≠ −1`. The docstring phrase "different from both central values" is
accurate for the two relevant central involutions `±I`, but "central" strictly
means "scalar multiple of `I`" (center of `M4`); the *theorem* does not exclude
all scalars, only `±1`. The actual matrix (rotation by `2θ`, `θ=arctan(3/4)`)
*is* genuinely non-scalar, so the name `exists_noncentral_quarterTurn` is
justified — but only by inspection of the witness, not by the stated conclusion.
- *Safe wording:* "the quarter-turn regulator of these Hermitian involutions is
  neither `+I` nor `−I`" (state exactly `≠1 ∧ ≠−1`); if genuine non-centrality
  is wanted, add the stronger conclusion `∀ z:ℂ, regulator ≠ z • 1`.

### [LOW-4] Do not read memo-level prose as proved by this file
`MEMO_3PLUS1_ATTACK.md` (§5 B2–B4, and the "strict-local", "Laurent",
"chirality-odd", "root-exclusion certificate", "Ξ-odd leading commutator")
material is **strategy**, explicitly marked as such. `CommutatorRegulator.lean`
proves **none** of it. What the file actually establishes is finite matrix
algebra only:
1. each `phaseStep` factor and the four-factor word are unitary for Hermitian
   involutions on the trig circle;
2. the word trivializes when either axis angle is zero;
3. the quarter turn equals `A*G*A*G` and collapses to `−I` under double-involution
   anticommutation;
4. two nonvacuity fixtures (drop-`hG` failure; Hermitian noncentral).
The module docstring is appropriately hedged ("*candidate* strict-local ...
Laurent realization and the chirality-odd choice of generators remain separate
composition steps"). No Lean statement mentions Laurent locality, chirality,
quasienergy spectrum, or roots — **there is no overclaim in the code.** The only
risk is downstream prose citing the memo's B2/route-A/route-C conclusions as if
`CommutatorRegulator.lean` backed them.
- *Safe wording (for any manuscript reference):* "`CommutatorRegulator.lean`
  proves the finite matrix identities of the quarter-turn group-commutator word
  — unitarity, axiswise triviality, the `A*G*A*G` form, central `−I` collapse
  under anticommuting double involutions, and its necessity — over `M4(ℂ)`. It
  does **not** establish strict/Laurent locality, translation invariance, a
  chirality (`Ξ`) grading, or any quasienergy root-exclusion; those remain
  separate, unproved composition steps."

### [INFO] `IsUnitary` redundancy
Both-sided definition is redundant for finite square matrices but sound; not a
defect. If a leaner API is desired, one direction plus
`Matrix.mul_eq_one_comm` suffices, but there is no need to change it.

---

## 4. Exact safe wording for the promoted results

- **Central collapse.** "For `A,G : M4(ℂ)` with `A²=G²=1` and `AG=−GA`, the
  quarter-turn group commutator `A·G·A·G = regulator 0 1 0 1 A G` equals `−I`.
  Both involution hypotheses are required; dropping `G²=1` (or `A²=1`) makes the
  identity fail (`exists_failure_without_second_involution`)."
- **Unitarity.** "For Hermitian involutions `A,G` and circle data
  `cp²+sp²=cq²+sq²=1`, the four-factor commutator word is unitary
  (`regulator_unitary`)."
- **Noncentrality.** "Some Hermitian involutions have quarter-turn commutator
  neither `+I` nor `−I` (`exists_noncentral_quarterTurn`; the block rotation by
  `2·arctan(3/4)`)."
- **Never write:** that this word is a strict-local/Laurent walk, a spectral
  regulator, carries a chirality charge, or excludes any Brillouin-zone root —
  none of that is in scope of this file.

---

## 5. Smallest next composition theorem

Add the commuting companion to the central-collapse dichotomy (pure finite
algebra, no Hermiticity needed, verified true by computation):

```lean
/-- Commuting involutions make the quarter-turn commutator trivial. -/
theorem commuting_quarterTurn_eq_one
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1) (hcomm : A * G = G * A) :
    regulator 0 1 0 1 A G = 1 := by
  -- A*G*A*G = A*A*G*G = 1 via hcomm, hA, hG
  sorry
```

Rationale: together with `anticommuting_quarterTurn_eq_neg_one` this pins both
central values of the high-symmetry quarter turn by the sign of the closed
commutator `[A,G]`, and it is the minimal, honest, in-scope step. Confirmed:
for `A=diag(1,−1,1,1)`, `G=diag(1,1,−1,1)` (commuting involutions),
`A*G*A*G = I`.

A natural follow-on (still finite algebra, one notch larger) is the leading
bilinear expansion `regulator ≈ I − sp·sq·[A,G] + …`, which is the first place a
`Ξ`-odd leading commutator (memo B2/A5) could even be *stated* — but that
requires introducing a chirality involution and a Taylor/degree bookkeeping and
is deliberately **not** the smallest next step.
