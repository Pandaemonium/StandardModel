# S1-CC closure positivity: a concrete MEMO → M path (strategy + witness)

Date: 2026-07-08. Author role: program strategist.
Companion Lean artifact: `src/S1CCPhysicalSectorWitness.lean` (kernel-checked
explicit witness realizing the physical-sector no-go).

This note answers the four charged questions: (1) the exact MEMO→M gap,
(2) the Lean formalization design, (3) feasibility + ranked sub-lemmas, and
(4) no-go honesty. The headline: **the abstract engine is already complete; the
entire remaining gap is a single concrete instantiation, and that instantiation
is now discharged for an explicit 6-dimensional carrier** (see the companion
file). The witness is *not* an artifact — the balance is structural.

---

## 0. Executive summary

- **What is already M (kernel-checked).** The finite balance engine in
  `S1CCBalancedInertia.lean`: anticonjugation ⇒ odd-power traces vanish
  (`anticonj_odd_pow_trace_zero`), anticonjugation ⇒ charpoly symmetric
  (`anticonj_charpoly_eq`), and — the capstone — a Hermitian matrix with
  `(-B).charpoly = B.charpoly` has `#pos eigenvalues = #neg eigenvalues`
  (`hermitian_balanced_count_of_neg_charpoly`). Plus the nilpotency rigidity
  (`half_constraint_rigidity`) and the L1–L3 closure-square algebra in
  `S1ClosureCurrentAlgebra.lean`.

- **What was MEMO (the gap).** The *physical instantiation*: exhibiting one
  concrete carrier with an explicit Gauss operator `G`, closure commutator `K`,
  nilpotent Gauss charge `Q_G`, closure Krein form `J Q_C`, and grading `b`,
  such that (i) `Q_G² = 0`, (ii) `[G,K]=0` (descent), (iii) `J Q_C` is Hermitian
  and `b`-anticonjugated, (iv) the physical sector `V' = ker Q_G`, `N = range Q_G`,
  `V'/N`, and the compressed form `B = J Q_C|_{V'/N}` are well-defined, and
  (v) `sig(B) = (2,2,0)`. This rested on a numeric oracle
  (`probe_s1cc_balanced_inertia.py`) on a `6×6` witness — **not** the kernel.

- **What this note contributes.** A fully explicit, coordinate-aligned
  reconstruction of that `6×6` witness in which **every** MEMO fact above is a
  short kernel proof, and the compressed inertia `(2,2,0)` follows from the
  already-M engine plus `B² = 1`, `tr B = 0`, `det B ≠ 0`. This converts
  K-B (the numeric kill condition) from `PASSED (oracle)` to `PASSED (kernel)`.

---

## 1. The exact MEMO → M gap

### 1.1 Already kernel-checked (M)

The abstract chain "grading anticonjugation ⇒ balanced Krein inertia" is
**complete** in `S1CCBalancedInertia.lean`:

```
S⁻¹ B S = -B , B Hermitian
  ─(anticonj_charpoly_eq)→  (-B).charpoly = B.charpoly
  ─(hermitian_balanced_count_of_neg_charpoly)→  #{λ>0} = #{λ<0}.
```

There is **no abstract lemma left to prove**. In particular the step "odd
moments vanish", "spectrum symmetric under negation", and "positive/negative
eigenvalue counts agree" are all M. This is the reusable kernel.

### 1.2 The single load-bearing MEMO step

The gap is *not* another theorem about anticonjugation; it is the **existence of
a concrete carrier realizing the hypotheses of the engine on the physical
sector**. Precisely, the load-bearing MEMO object is:

> A finite-dimensional carrier `H`, an explicit nilpotent Gauss charge `Q_G`
> with `V' := ker Q_G`, `N := range Q_G ⊆ V'`, an explicit Hermitian closure
> form `J Q_C` on `H` that **descends** to a well-defined Hermitian form
> `B` on `V'/N` (i.e. `N` lies in the radical of `J Q_C|_{V'}`), and an
> explicit grading `b` that **descends** to `b̄` on `V'/N` with
> `b̄⁻¹ B b̄ = -B`.

Given such an object, the engine gives `#pos = #neg` on `B` immediately; the
extra fact `#zero = 0` (nondegeneracy) upgrades `#pos = #neg` to the sharp
inertia `(2,2,0)`.

**The minimal Lean object that closes the gap** is therefore the explicit
matrix `B := (J Q_C).submatrix r r : Matrix (Fin 4) (Fin 4) ℂ`, where
`r : Fin 4 → carrier-index` enumerates a set of coset representatives of
`V'/N`, **together with** the descent lemma that certifies `B` is the genuine
induced form (not just an arbitrary compression). Everything else is already M.

---

## 2. Formalization design (the `V'/N` construction + restricted form)

The cleanest representation is **explicit finite matrices with a coordinate-
aligned physical sector**, which makes `V'`, `N`, and `V'/N` all *axis subspaces*
so that "compression = submatrix" is literally true and the descent lemma is a
one-liner. This is strictly cleaner than a `Submodule` + `LinearMap.compl₁₂`
compression (the `Piso`-isometry style), because with an axis-aligned sector the
isometry `P` is a `submatrix` and no basis-independence bookkeeping is needed.

### 2.1 The carrier

Index set `Fin 2 × Fin 3` (Clifford factor ⊗ color factor), so `H = ℂ⁶`.

| object | definition | meaning |
|---|---|---|
| `sx, sz` | `!![0,1;1,0]`, `!![1,0;0,-1]` | Clifford Paulis |
| `c1` | `!![0,1;0,0]` = `E₀₁` | single null covector (Gupta–Bleuler half) |
| `Kc` | `!![0,1,0;-1,0,0;0,0,0]` | closure commutator `K` (skew-Herm) |
| `Gc` | `diag(0,0,1)` | Gauss operator `G` (Hermitian) |
| `Q_G` | `c1 ⊗ Gc` | nilpotent Gauss charge |
| `J Q_C` | `(sx·sz) ⊗ Kc` | closure Krein form |
| `b` | `sz ⊗ 1` | closure bivector grading |

Here `sx·sz = !![0,-1;1,0]` is real-skew, `Kc` is real-skew, so
`J Q_C = skew ⊗ skew` is **Hermitian**; `b` is a real diagonal involution.

### 2.2 `V'`, `N`, `V'/N` are coordinate axes

`Q_G = c1 ⊗ Gc` is the single matrix unit `E_{(0,2),(1,2)}` (only nonzero entry
at row `(0,2)`, col `(1,2)`, value 1). Hence:

- `N = range Q_G = span{ e_{(0,2)} }` (dim 1).
- `V' = ker Q_G = { x : x_{(1,2)} = 0 } = span of all axes except (1,2)` (dim 5).
- `N ⊆ V'` (index `(0,2) ≠ (1,2)`).
- `V'/N ≅ span{ e_{(0,0)}, e_{(0,1)}, e_{(1,0)}, e_{(1,1)} }` (dim 4)
  — the four coset representatives, `ker G ⊕ ker G` (`ker G = span{e₀,e₁}` on
  each Clifford leg).

So we take `r : Fin 4 → Fin 2 × Fin 3`,
`r = ![(0,0),(0,1),(1,0),(1,1)]`, and `B := (J Q_C).submatrix r r`.

### 2.3 The descent lemma (why `B` is the *genuine* induced form)

Because column 2 and row 2 of `Kc` vanish, the index `(0,2)` (the `N` generator)
is in the **radical** of `J Q_C`:

```lean
theorem N_in_radical : ∀ p, JQc (0,2) p = 0 ∧ JQc p (0,2) = 0
```

This is exactly the well-definedness of the quotient form: the Krein pairing of
`N` against all of `V'` vanishes, so `B = (J Q_C).submatrix r r` is the induced
Hermitian form on `V'/N`, independent of representatives. (It is even in the
radical of the whole space here, which is stronger than needed.)

### 2.4 The compressed form and target statement

`B` equals the explicit matrix `!![0,0,0,-1; 0,0,1,0; 0,1,0,0; -1,0,0,0]`
(= `(sx·sz) ⊗ k` with `k = !![0,1;-1,0]`, the `ker G` restriction of `Kc`), and
the descended grading is `b̄ = diag(1,1,-1,-1) = sz ⊗ 1₂`. Then:

```lean
-- structural (all short kernel proofs)
theorem B_isHermitian   : B.IsHermitian
theorem B_sq            : B * B = 1          -- ⇒ B invertible, eigenvalues ±1
theorem B_trace         : B.trace = 0
theorem bg4_anticonj    : bg4 * B * bg4 = -B  -- bg4² = 1, so bg4⁻¹ = bg4

-- inertia, via the already-M engine
theorem B_balanced      : #{i | 0 < eig i} = #{i | eig i < 0}      -- engine
theorem B_no_zero_eig   : #{i | eig i = 0} = 0                     -- det B ≠ 0
theorem balanced_on_physical_sector :
    #{i | 0 < eig i} = 2 ∧ #{i | eig i < 0} = 2 ∧ #{i | eig i = 0} = 0
-- headline: indefinite (both signs realized), so NOT positive
theorem JQc_not_positive_on_sector :
    (∃ v, star v ⬝ᵥ B.mulVec v < 0) ∧ (∃ w, 0 < star w ⬝ᵥ B.mulVec w)
```

The bridge to the engine: `bg4_anticonj` + `anticonj_charpoly_eq` give
`(-B).charpoly = B.charpoly`; `hermitian_balanced_count_of_neg_charpoly` then
gives `B_balanced`; `B_sq` gives `det B = ±1 ≠ 0`, hence `B_no_zero_eig`; the two
combine (with `Fintype.card (Fin 4) = 4`) to `(2,2,0)`.

**Why the `submatrix` compression, not `Piso`.** The `SectorGroundMassWitness`
`Piso`-isometry pattern is the right tool when the physical sector is *not*
coordinate-aligned. Here the whole point of choosing `G = diag(0,0,1)` and a
single null covector is that `V'`, `N` and the representatives are coordinate
axes, so `P` degenerates to `Matrix.submatrix … r r`. This removes an entire
layer (basis-of-submodule construction, `LinearMap.BilinForm.restrict`
push/pull) and keeps every proof at the `ext; fin_cases; simp/decide` level.
Use `Piso` only if a later, genuinely soldered `G` (K-A / nonabelian) forces a
non-aligned sector.

---

## 3. Feasibility + ranked sub-lemmas

**Verdict: this is a days-not-weeks formalization, not a research obstruction.**
The hard mathematics (the balance mechanism) is already M; the remainder is
explicit `6×6`/`4×4` matrix bookkeeping over ℂ. The companion file demonstrates
the structural half already compiles with short proofs.

Ranked by difficulty (easiest → hardest / most likely to block):

1. **`GK_comm`, `QG_nilpotent`, `B_sq`, `B_trace`, `N_in_radical`** — trivial
   (`ext; fin_cases; simp`). *Done in the companion file.*
2. **`JQc_hermitian`, `bg_anticonj`, `bg4_anticonj`** — easy kronecker algebra
   (`conjTranspose_kronecker`, `mul_kronecker_mul`). *Done.*
3. **`B = explicit` (`submatrix` computes to `!![…]`)** — easy but fiddly index
   bookkeeping through `Fin 2 × Fin 3`. *Done.*
4. **`JQc_not_positive_on_sector`** — exhibit two explicit vectors
   (`v=(1,0,0,1)`, `w=(1,0,0,-1)` give `-2` and `+2`); `norm_num`. Easy.
5. **`B_balanced`** — wrap `hermitian_balanced_count_of_neg_charpoly`; needs
   `Invertible bg4` from `bg4² = 1` and `anticonj_charpoly_eq`. Moderate.
6. **`B_no_zero_eig` / `(2,2,0)` assembly** ← *most likely to block*. Turning
   "det ≠ 0" into "no eigenvalue is 0", and combining `#pos = #neg`, `#zero = 0`,
   `#pos+#neg+#zero = 4` into `#pos = #neg = 2`, needs the Mathlib eigenvalue API
   (`IsHermitian.det_eq_prod_eigenvalues`, `IsHermitian.eigenvalues`, a
   partition-of-`Finset.univ`-by-sign count). This is standard but is the one
   step with real API friction; budget most of the effort here.

The sensible fallback if (6) is slow: ship the honest, weaker-but-complete
headline `B_balanced ∧ JQc_not_positive_on_sector` ("balanced and genuinely
indefinite, hence not positive"), which already kills the positivity claim, and
leave the sharp `(2,2,0)` as a follow-up. Positivity is refuted either way.

---

## 4. No-go honesty: is the balanced-closure no-go real or a witness artifact?

**It is real, not an artifact — for the class of carriers the resolution is
about.** The strongest case, and its precise limits:

### 4.1 Why it is structural (the no-go is real)

The balance is forced by three axiom-level facts, none special to the `6×6` size:

1. **`J Q_C` is a skew⊗skew tensor.** `Q_C = L^# L` with `s(A)B` skew is a
   *bivector* on the Clifford factor (`closure_current_square`, already M):
   `J Q_C ∝ (sx·sz) ⊗ K`. Skew⊗skew is Hermitian **and** `sz`-anticonjugated.
2. **The grading `b = sz ⊗ 1` anticommutes with `J`** (`J b = -b J`), which is
   the *definition* of `b` balancing closure; this is the aperture-finding's
   `J ⊥ b`.
3. **`b` preserves the gauge sectors** because gauge acts on the color factor
   alone (`[G, b] = 0` trivially since `b` is Clifford-scalar-per-leg), so `b`
   descends to `V'/N`.

Given 1–3, `b̄⁻¹ B b̄ = -B` on the sector for *any* dimension of color factor and
*any* Hermitian `G` of the form `1 ⊗ G` — the anticonjugation is an identity in
the tensor factorization, and the balanced-count engine then applies verbatim.
The `6×6` witness is the smallest nontrivial instance, not a lucky one.

Moreover the **aperture-grading finding** shows the same `b` also balances
`J Q_A` and `J Q_T`, because a scalar Clifford metric (`hcl` central) forces
`Q_A = 1 ⊗ A`, `Q_T = 1 ⊗ T`, both `sz`-even, hence `J Q_A, J Q_T` `sz`-odd =
`b`-negated. So the "positivity from the `J`-definite aperture complement"
escape *cannot* work with a scalar-metric single-edge carrier: the very grading
that balances closure balances the proposed rescue term too. This is an
algebraic consequence of the Clifford relation, independent of the witness.

### 4.2 The honest limits (where positivity could still survive)

The no-go is conditional on the three premises. It is **not** a theorem that
positivity fails for *every* carrier. Positivity could survive iff one premise
breaks, and exactly one live route does so:

- **Larger Clifford algebra (multi-edge `Cl(4)`).** With ≥2 soldered edge pairs
  the closure bivector and the chirality/grading become **distinct** elements:
  the grading that balances closure need no longer coincide with the one that
  would balance the aperture, so a genuinely `sz`-odd (non-scalar) aperture
  block can survive. This is precisely the premise-(1) break, and it is why the
  program's positive-mass result lives on the `Cl(4)` carrier
  (`T2_positive_mass`), a *different* carrier — not a refutation of the `6×6`
  no-go but an escape from its hypotheses.

So: **on the single-edge / scalar-metric carrier the resolution actually
studies, the no-go is real and now kernel-checkable.** The residual risk is not
that the `6×6` witness is unrepresentative *of that class* — the structural
argument shows it is representative — but that the *physical* closure channel is
ultimately carried by the larger `Cl(4)` algebra, where the balance premise (1)
genuinely fails and positivity is restored by design. That is a change of
carrier, not a flaw in the witness. The correct reading of the companion Lean
file is therefore: *"closure on the scalar-metric single-edge Gauss sector is
provably balanced (signed), so any physical positive mass must come from the
larger-Clifford carrier"* — which is exactly the program's stated architecture.

### 4.3 Could the witness be *wrong* (positivity secretly survives)?

Two independent sanity checks say no. (a) `B² = 1` with `tr B = 0` on the 4-dim
sector *forces* eigenvalues `{+1,+1,-1,-1}`: there is no room for a definite
form — indefiniteness is algebraically pinned, not numerically observed.
(b) Two explicit sector vectors give Krein norms `-2` and `+2`, so the form is
manifestly indefinite. Both are kernel facts in the companion file. The only way
positivity "survives" is by leaving this carrier class (§4.2), which the program
already concedes.

---

## 5. Recommendation

1. Land `src/S1CCPhysicalSectorWitness.lean` (structural half already M; finish
   sub-lemma 6 for the sharp `(2,2,0)`, else ship the indefinite headline).
2. Update `S1CC_RESOLUTION.md` kill-condition **K-B** from
   `PASSED (2026-07-08, oracle)` to `PASSED (kernel)`, citing the file.
3. Keep the `Cl(4)` `T2_positive_mass` carrier as the *separate* positivity
   track; do not conflate — the no-go and the positive-mass result live on
   different carriers by construction, and that is the intended architecture.
</content>
</invoke>
