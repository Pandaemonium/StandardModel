# CHARGE_DESIGN_MEMO — Section 4 Route A, steps A1–A2 (with A3, validation, feasibility)

Design of an integer-valued, exactly-computable, per-crossing local charge for
finite-range unitary Bloch symbols on the 3-torus, its sum-zero theorem, the
tangent-forces-charge lemma, a three-symbol validation protocol, a Lean-4/Mathlib
feasibility verdict, the exact 1+1 warm-up statement, and the failure-mode audit.

Claim discipline (as in `context/MEMO_3PLUS1_ATTACK.md`): **KNOWN** = standard,
citable, kernel-checkable; **VERIFY** = literature attribution to be full-text
checked before manuscript use; **DESIGN** = this memo's proposal, to be validated
by exact computation. Physics attributions are marked **[phys]**. No integrals,
no homotopy theory, no K-theory imports enter any *definition* below; where the
honest *justification* is topological I say so explicitly and give the
exact-algebra reformulation to build.

---

## 0. Objects and conventions

- Lattice `ℤ³`, finite internal dimension `N`. A **finite-range translation-invariant
  exactly-unitary** update has a **Bloch symbol**
  `U(z) ∈ M_N(ℂ[z₁^{±1}, z₂^{±1}, z₃^{±1}])`, `z_j = e^{i k_j}`, with `U(z) U(z)^† = 1`
  for all `z` on the 3-torus `𝕋³ = {|z_j| = 1}`. "Finite-range" ⇔ Laurent-polynomial
  entries; "exactly unitary" ⇔ the Laurent matrix identity `U U^† = 1` on `𝕋³`.
- Quasienergy: eigenvalues of `U(k)` are `e^{i ε_n(k)}` on the unit circle.
  A **0-crossing** is `+1 ∈ spec U(k)` ⇔ `det(U(k) − 1) = 0`; a **π-crossing** is
  `−1 ∈ spec U(k)` ⇔ `det(U(k) + 1) = 0`. Floquet pairing forces us to census
  **both**; a "single-cone" evader can hide the compensating node at π
  (a pseudo-doubler, Gupta–Short language).
- A **Weyl/Dirac node** is an *isolated 2-band touching* at quasienergy 0 or π:
  a point `k₀` where `dim ker(U(k₀) ∓ 1) = 2`, all other eigenvalues bounded away
  from `±1`, and `k₀` isolated in the crossing set. This is the codimension-3
  (von Neumann–Wigner, **[phys]/KNOWN**) situation the repo's classification
  exhibits: `FullBlochZeroClassification.algebraZero_eq_zero_iff` shows the live
  cubic symbol's 0- and π-crossings are exactly `cos qx = cos qy = cos qz = 0`,
  i.e. isolated points, with the SOS witness
  `algebraZero = (c x − y z)² + (y²+z²−2y²z²)(c²+x²(1−2c²))`.

Notation: `σ₁,σ₂,σ₃` Pauli matrices; `M(k) := U(k) ∓ 1` (sign chosen per gap);
`∂_j := ∂/∂k_j`.

---

## 1. A1 — the local charge, algebraically

### 1.1 Reduction to the 2×2 Weyl block (Feshbach/Schur), and its licence

**Definition (reduced block).** Fix a node `k₀` at gap value `s ∈ {+1, −1}`
(0-crossing `s=+1`, π-crossing `s=−1`). Let `W := ker(U(k₀) − s·1)`, assume
`dim W = 2` (the node hypothesis). Choose a fixed unitary basis adapted to
`ℂ^N = W ⊕ W^⊥`: isometries `V₀ : ℂ² → ℂ^N` onto `W`, `V₁ : ℂ^{N−2} → ℂ^N` onto
`W^⊥`. Block `M(k) = U(k) − s·1`:

```
        ⎛ A(k)  B(k) ⎞         A = V₀* M V₀  (2×2)     D = V₁* M V₁  ((N−2)²)
M(k) =  ⎜            ⎟ ,       B = V₀* M V₁            C = V₁* M V₀
        ⎝ C(k)  D(k) ⎠
```

At `k₀`: `M(k₀) V₀ = 0` ⇒ `A(k₀) = 0`, `C(k₀) = 0`. And `D(k₀) = V₁*(U(k₀)−s)V₁`
is **invertible** precisely because `s` is not an eigenvalue of `U(k₀)` on `W^⊥`
(node hypothesis). Define the **Schur complement / Feshbach effective block**

```
  S(k) := A(k) − B(k) · D(k)^{-1} · C(k)          (2×2, entries rational in the
                                                    Laurent entries of U, regular
                                                    on a neighbourhood of k₀)
```

**Licence lemma (KNOWN, `Matrix.det_fromBlocks₁₁`).** On the neighbourhood where
`D(k)` is invertible,
`det(U(k) − s·1) = det D(k) · det S(k)`, so near `k₀` the crossing locus of
`U` equals the zero locus of the *scalar* `det S`, and `S(k₀) = 0`. The reduction
is licensed **exactly when** `dim ker(U(k₀) − s) = 2` and `D(k₀)` is invertible;
choosing `W = ker` makes the second automatic. If `dim ker > 2` (higher
degeneracy) the block is `d×d` with `d = dim ker`; the construction generalizes,
but "involutory unit-speed Dirac" is by definition the `d = 2` case, so A1 fixes
`d = 2`.

*Coordinate-free alternative (equivalent, mention only).* The same 2-dim
kernel/cokernel data is carried by the **(N−2)-th compound matrix** `⋀^{N-2} M(k)`
(a.k.a. the "second adjugate": ordinary `adjugate` = `⋀^{N-1}` cofactors, which
**vanishes identically at a rank-`(N−2)` point** and is therefore blind to a
2-dim kernel — this is why plain `Matrix.adjugate` is *not* enough and the
higher compound is needed). The Schur route is preferred for Lean: it stays
inside `M₂` with rational entries and needs only block-determinant lemmas that
Mathlib already has.

### 1.2 From the block to a real 3-vector (the d-vector)

`U` unitary ⇒ near a node `U − s = s(e^{-iH} − 1) ≈ −i s H` with `H` the
Hermitian effective Hamiltonian; the reduced block inherits this: to leading jet
order `S(k) ≈ −i s · H_eff(k)`, `H_eff` a `2×2` Hermitian matrix. Extract the
**traceless real d-vector** algebraically from `S` (no logs, no Cayley needed —
we only need its 1-jet):

```
  d_a(k) := −(s/2) · Im tr( σ_a · S(k) ) ,     a = 1,2,3 ,      d : (ℝ³, k₀) → (ℝ³, 0).
```

`d(k₀) = 0` (since `S(k₀) = 0`). Each `d_a` is a real-analytic function of `k`
built from finitely many exact algebraic operations on the Laurent entries of `U`
plus one inversion of `D(k₀)`; its Taylor **jet at `k₀` is exactly computable**.

### 1.3 The charge

```
  Q(k₀)  :=  deg_{k₀}( d )        (local topological degree of d : ℝ³ → ℝ³
                                    at the isolated zero k₀)
```

made *exactly computable* by:

- **Nondegenerate case (the physically relevant one).** If the **velocity matrix**
  `v_{a j} := ∂_j d_a (k₀)` (a real `3×3` matrix, = the leading jet) is invertible,
  then `deg_{k₀}(d) = sign det v ∈ {+1, −1}`. **Pure finite linear algebra** on
  the first jet. This is the sign of the Weyl chirality **[phys]**.

- **General isolated-zero case (fallback).** If `det v = 0` but `k₀` is still
  isolated, the local degree is given exactly by the **Eisenbud–Levine–
  Khimshiashvili theorem (KNOWN, 1977)**: `deg_{k₀}(d) = signature ⟨·,·⟩` of the
  symmetric bilinear form `⟨a,b⟩ = ℓ(a·b)` on the finite-dimensional **local
  algebra** `Q_{k₀} = ℝ[[k−k₀]]/(d₁,d₂,d₃)`, where `ℓ` is any ℝ-functional with
  `ℓ(J) > 0` and `J` = class of the Jacobian `det(∂_j d_a)` in `Q_{k₀}`. The
  basis of `Q_{k₀}` and the multiplication table are computed by a **Gröbner/
  standard-basis** reduction; `dim_ℝ Q_{k₀}` is the local **Bézout number**,
  bounded by the product of the `d_a`-degrees. All finite, all exact — this is
  the "resultants / local Bézout degrees / adjugate constructions" the program
  memo asks for.

**Sign convention / Floquet pairing (load-bearing).** The factor `s` in `d_a`
ties the two gaps with **opposite orientation**: a 0-node and a π-node of the
"same-looking" cone carry charges of opposite sign. This is exactly what makes
the 1D total below a boundary-free (= vanishing) count, and what tracks
pseudo-doublers rather than ignoring them.

---

## 2. A2 — the sum-zero theorem (sketch)

**Theorem shape (DESIGN).** For a finite-range unitary Laurent symbol `U` on `𝕋³`
whose 0- and π-crossings are all isolated Weyl nodes,

```
   Σ_{nodes k₀ at gap 0}  Q(k₀)   =  0        and        Σ_{nodes k₀ at gap π}  Q(k₀)  =  0 .
```

Both totals vanish **independently** in 3D (contrast 1D, §5), because a Weyl node
is codimension-3 (a point) and the signed count of the zeros of a *globally
single-valued* section over a **closed** manifold `𝕋³` carries no boundary term.

Two layers, honest about which is analysis and which is the exact algebra to build:

**(i) Honest topological reason (KNOWN, not to be imported).** The `d`-vector of
a fixed 2-band gap is, away from nodes, a nowhere-zero section; its normalization
`d/|d| : 𝕋³ ∖ {nodes} → S²` has, around each node, a local degree = `Q(k₀)`
(= first Chern number over a small enclosing `S²` = Berry monopole charge **[phys]**;
Volovik; Wan–Turner–Vishwanath–Savrasov 2011 **[phys]/VERIFY**). Since `𝕋³` is
closed (`∂𝕋³ = ∅`), the sum of the enclosed monopole charges = total flux out of
`𝕋³` = 0 (**Nielsen–Ninomiya part I / Poincaré–Hopf**, KNOWN). This is the
*content* but uses degree theory absent from Mathlib.

**(ii) Exact-algebra reformulation (the build target).** Replace "flux through a
closed manifold = 0" by a **global residue identity**. The nodes are the common
zeros of the (locally defined) `d_a`; each `Q(k₀)` equals a signed **local
residue index** (ELK signature = real Grothendieck residue of the local algebra,
§1.3). The claim `Σ Q = 0` is then an instance of the **Global Residue Theorem on
a complete/toric variety** (KNOWN in the complex holomorphic setting: sum of
Grothendieck residues of a rational top-form on a complete variety is 0; toric
version — Tsikh; Cattani–Dickenstein–Sturmfels **VERIFY**): compactify `𝕋³` as
the real points of the toric variety `(ℙ¹)³` = `Spec ℂ[z^{±1}]`-completion; the
`d_a` extend to sections whose total residue is the coefficient extraction that
the **Laurent-unit / monomial-determinant structure** pins to 0.

The **monomial-determinant input** (Codex B-lane, KNOWN there): a unitary Laurent
symbol has `det U(z) = ω · z₁^{m₁} z₂^{m₂} z₃^{m₃}` (a Laurent **unit**, `|ω|=1`),
because `det U` is nowhere-zero on `𝕋³` of modulus 1. The abelian exponents
`m = (m₁,m₂,m₃)` are the *number of zeros minus poles* of `det U` along each
circle factor. This fixes the **global degree** of the boundary/telescoping map
to 0 in the residue sum. **Crucial caveat (this is exactly the acceptance test,
§4c):** `m` is the *abelian* datum; the sum-zero of the *nonabelian* `Q` is a
finer identity — `m = 0` does NOT imply `Q ≡ 0`. The Laurent-unit theorem enters
A2 only as the global-degree normalization, not as a computation of the charges.

**Feasibility flag.** Layer (ii) is the single largest new build (see §6). A
pragmatic intermediate that is *fully exact and Lean-plausible now*: prove sum-zero
**by resultant elimination on the specific symbol class** — the node set is the
zero set of an explicit Laurent ideal, its members are computed by iterated
`Polynomial.resultant`, and `Σ sign det v = 0` is then a finite identity over the
algebraic numbers occurring (this is exactly what the cubic-walk validation, §4a,
does, and it generalizes to the separable/bounded-range classes of A4).

---

## 3. A3 — tangent forces charge (sketch)

**Definition (involutory unit-speed Dirac tangent).** At a node `k₀` the 1-jet of
the effective Hamiltonian is `H_eff(k) = Σ_a (v_{a j} δk_j) σ_a + O(δk²)`,
`δk = k − k₀`. The tangent is:
- **unit-speed / nondegenerate** iff the velocity matrix `v = (v_{a j}) ∈ M₃(ℝ)`
  is invertible (equivalently the three Dirac matrices `α_j := Σ_a v_{a j} σ_a`
  are linearly independent);
- **involutory** iff the `α_j` can be normalized to a genuine Clifford frame,
  `α_j² = 1`, `{α_i,α_j} = 2δ_{ij}` after a `GL₃` change of momentum frame —
  equivalently `v` has **no null directions**: `v vᵀ` is definite. This is the
  "genuine relativistic cone" condition; it is strictly stronger than mere
  invertibility only in that it forbids indefinite/degenerate metric, but for the
  charge what is used is precisely `det v ≠ 0`.

**Lemma (DESIGN, finite linear algebra).** If the tangent is involutory unit-speed
then `v` is invertible, hence `d(δk) = v δk + O(δk²)` has `D d(k₀) = v`
nonsingular, hence `k₀` is a **nondegenerate** isolated zero and

```
   Q(k₀) = sign det v = ±1 ≠ 0 .
```

Proof is one line once §1.3 nondegenerate case is set up: `deg` of a map with
invertible linearization = `sign det` of the linearization. The **only** place
the involutory hypothesis is used is to certify `det v ≠ 0`; a non-involutory or
merely degenerate tangent (`det v = 0`) drops into the ELK fallback and is *not*
forced to be nonzero — this is the Gupta–Short escape (§4b).

---

## 4. Validation protocol (exact-computation recipes)

General recipe per symbol: (1) census the crossing set exactly (repo machinery /
resultant elimination); (2) at each node build `S(k)` by Schur complement onto
`ker(U(k₀) ∓ 1)`; (3) compute the `3×3` velocity `v` from the 1-jet of
`d_a = −(s/2) Im tr(σ_a S)`; (4) `Q = sign det v` (or ELK if `det v = 0`);
(5) check `Σ Q` at gap 0 and at gap π.

### 4a. Repo cubic successive-axis walk — **must reproduce ±1, total 0**

Source of truth: `FullBlochZeroClassification`. Crossings (principal massive
branch `0 < |cos θ| < 1`) at `cos qx = cos qy = cos qz = 0`, i.e.
`q_j ∈ {π/2, 3π/2}` — `2³ = 8` momentum points, **each carrying both** a 0-node
and a π-node (`algebraZero_eq_zero_iff` and `algebraPi_eq_zero_iff` share the same
locus: this is the explicit Floquet pairing / pseudo-doubler bookkeeping the memo
demands). *Count caveat (to be pinned by the census, do not over-commit):* the
program memo's "four crossings" reflects the even-parity **corner aliasing** /
residual point-group identifications that fold the 8 raw points; the exact
per-node charge table and the fold must be produced by the census job, not
assumed here.
**Gate:** each node is a nondegenerate involutory cone (`det v ≠ 0`), each
`Q = ±1`, and `Σ_0 Q = 0`, `Σ_π Q = 0`. Chiralities must pair off across the
`q_j → q_j + π` (i.e. `cos q_j → −cos q_j`) reflection and across the `0 ↔ π`
mass-sign flip `algebraPi(x,y,z,c) = algebraZero(x,y,z,−c)`
(`algebraPi_eq_algebraZero_neg`) — the `−c` flip is the concrete algebraic image
of the `s`-orientation sign of §1.3. **Kill condition (unchanged from memo A1):
if this computes `Q ≡ 0` on the cubic nodes, the residue formulation is wrong.**

### 4b. Gupta–Short stay-put family — **must zero out the forced charge**

Which hypothesis fails: **A3's involutory unit-speed condition**, i.e. `det v = 0`.
The repo's `StationaryAmplitudeNoGo` (KNOWN) says no degree-one nearest-neighbour
factor supports a stay-put amplitude compatible with origin normalization, exact
unitarity, and the **full involutory Dirac tangent**; corollary — the Gupta–Short
stay-put family necessarily has a **non-involutory tangent** (their Appendix F
concedes residual Weyl-like states). Concretely the velocity matrix degenerates
(`det v = 0`: a flat / quadratic / null direction), so:
- the node is *not* a nondegenerate cone; A3 does not apply; the charge is *not*
  forced to `±1`;
- computed via the ELK fallback it comes out consistent with **no protected
  doubling** (the "charge" the naive cone argument would demand is not forced).

This is the desired *consistency* check: the design must **see the family as
outside the forced-charge hypothesis**, explaining *why* they legitimately evade
doubling (they paid the involutory-tangent price), rather than contradicting them.

### 4c. Zero-determinant-flow nonidentity witness — **the acceptance test**

The witness (Codex B-lane): `det U(z) = ω · z^0` (abelian flow `m = 0`) yet
`U ≢ 1` and it carries genuine crossing structure. The abelian determinant flow
is **blind** on it (zero flow, nonidentity); any proposed charge that is also
blind **fails**.

**Does this design see it? YES, by construction — here is why.** The determinant
is `∏_n e^{i ε_n}`, a purely **abelian** (product/trace-level) datum; it sees only
`Σ_n ε_n` and its winding `m`. Our `Q` is built from the **traceless** part of the
reduced block — `d_a = −(s/2) Im tr(σ_a S)`, `a = 1,2,3` — which is exactly the
part `det`/trace discards. A Weyl node is a *relative* winding between the two
touching bands; their **product** (what `det` sees) is smooth through the node,
so the node is invisible to `m` but visible to `deg_{k₀}(d)`. Formally: `Q` is
invariant under `U ↦ (phase)·U` and depends only on the projective/`PSU(2)`
class of the reduced block, whereas `m` depends only on the complementary
`U(1)` factor; they are independent coordinates on `U(N) = (U(1) × SU(N))/ℤ_N`.
Hence `m = 0` is compatible with `Q(k₀) ≠ 0`.

**Acceptance requirement (honest scope).** The explicit witness symbol is *not* in
the provided files, so this memo states the **separation criterion** and the
structural reason it must hold; the **binding gate** is the exact per-node
computation of §4's recipe on the witness, which must return a nonzero `Q`
(or a nonzero ELK index) at a node where `m = 0`. If it returns `Q ≡ 0` on the
witness, the invariant has failed exactly as the determinant flow did, and route A
pivots (memo §4 kill condition).

---

## 5. The 1+1 warm-up — exact statement + Lean sketch

In 1D a crossing is codimension-1 (an eigenphase through `±1`), so the charge is
the **group-velocity sign**, and — unlike 3D — the two gaps do **not** each sum to
zero: `Σ_0 (velocity sign) = Σ_π (velocity sign) = m` (the `det`-winding / the
`K₁`-type GNVW shadow **VERIFY** — Gross–Nesme–Vogts–Werner index for 1D QCA).
The invariant that *does* vanish pairs the gaps with a **relative sign** (the
"number of eigenvalues in the open upper semicircle" is a periodic integer whose
net change around the BZ is 0):

```
   Σ_{0-crossings} q  −  Σ_{π-crossings} q  =  0 ,     q := sign(group velocity).
```

A single crossing gives `±1 ≠ 0` on the left ⇒ impossible.

**Theorem (1+1 warm-up, exact statement — all hypotheses explicit).**
Let `N ≥ 1` and `U : ℂ[z, z^{-1}] → M_N(ℂ)` be given by a Laurent-polynomial
matrix `U(z) ∈ M_N(ℂ[z^{±1}])` such that `U(z) · U(z)^† = 1` for every
`z ∈ S¹ = {|z| = 1}` (finite-range, exactly unitary, 1D). Define the crossing set
`C := { z ∈ S¹ : det(U(z) − 1) · det(U(z) + 1) = 0 }`. Assume:
1. `C` is finite;
2. (nondegenerate, involutory tangent) at every `z₀ = e^{i k₀} ∈ C` there is a
   unique eigenvalue `λ(z)` of `U(z)` with `λ(z₀) ∈ {+1, −1}`, it is a **simple**
   eigenvalue of `U(z₀)`, and the real eigenphase `ε(k) := arg λ(e^{i k})` (the
   real-analytic branch through `k₀`) has `ε'(k₀) ≠ 0`.
Assign `q(z₀) := sign ε'(k₀)` if `λ(z₀) = +1` and `q(z₀) := −sign ε'(k₀)` if
`λ(z₀) = −1`. Then

```
   Σ_{z₀ ∈ C} q(z₀) = 0 .
```

**Corollary (the no-go, the actual deliverable statement).** *No finite-range 1D
walk has a single nondegenerate involutory-tangent crossing:* under hypotheses 1–2,
`|C| ≠ 1`. (A single crossing would give `Σ q = ±1 ≠ 0`.)

**Proof sketch.** Consider the integer `n(k) := #{ eigenvalues of U(e^{i k}) in the
open upper semicircle Im > 0, i.e. ε ∈ (0, π) }`. Since `U(e^{i k})` is a
continuous loop of unitaries and `C` is finite, `n` is locally constant off `C`
and changes only when an eigenphase crosses `0` (`+1`) or `π` (`−1`): crossing `+1`
upward `+1`, downward `−1`; crossing `π` upward `−1`, downward `+1`. So the jump of
`n` at `z₀` is exactly `q(z₀)`. As `k` traverses `[0, 2π]`, `n(2π) = n(0)`
(periodicity), so `Σ jumps = Σ q(z₀) = 0`. Simplicity + `ε'(k₀) ≠ 0` guarantee
each crossing is a genuine transversal `±1`-jump of a single band, so the jump
equals `q` and no cancellation is hidden inside a node. ∎

Lean-4 statement sketch (syntax only; not to be compiled here — degree-free,
uses only the eigenphase count):

```lean
-- import Mathlib
open scoped Matrix

/-- 1+1 warm-up: signed count of 0-crossings minus π-crossings vanishes;
    hence no single nondegenerate involutory-tangent crossing.  (SKETCH) -/
theorem oneD_no_single_involutory_crossing
    (N : ℕ)
    (U : ℂ[X;X⁻¹] →+* Matrix (Fin N) (Fin N) ℂ)   -- placeholder for a Laurent
                                                     -- matrix symbol z ↦ U z
    (Uunit : ∀ z : ℂ, ‖z‖ = 1 → (Usymb U z) * (Usymb U z)ᴴ = 1)
    (C : Finset ℂ)
    (hC : ∀ z, z ∈ C ↔ (‖z‖ = 1 ∧
            ((Usymb U z - 1).det = 0 ∨ (Usymb U z + 1).det = 0)))
    -- nondegenerate involutory-tangent data packaged as a charge function:
    (q : ℂ → ℤ)
    (hq : ∀ z ∈ C, q z = crossingCharge U z)          -- = ±1, sign of eigenphase
    (hsimple : ∀ z ∈ C, NondegInvolutoryCrossing U z) :  -- simple λ=±1, ε'≠0
    (∑ z ∈ C, q z) = 0 ∧ C.card ≠ 1 := by
  sorry
```

Here `Usymb`, `crossingCharge`, `NondegInvolutoryCrossing` are the interfaces to
be defined (§6 says which parts Mathlib already supports). The corollary
`C.card ≠ 1` follows from the sum being 0 and each `q z ∈ {−1, +1}`.

---

## 6. Feasibility verdict for Lean-4 + Mathlib (per ingredient)

Checked against the pinned Mathlib (`Matrix.adjugate`, `Matrix.charpoly`,
`Matrix.det_fromBlocks₁₁` in `…/Matrix/SchurComplement.lean`, `LaurentPolynomial`
in `…/Polynomial/Laurent.lean`, `Polynomial.resultant` in
`…/RingTheory/Polynomial/Resultant/Basic.lean`).

| Ingredient | Mathlib status | Verdict |
|---|---|---|
| Matrices, `det`, `adjugate`, `charpoly`, block/Schur `det_fromBlocks₁₁` | **Exists** | Reuse directly; Schur reduction (§1.1) is a short build. |
| Univariate Laurent polynomials | **Exists** (`LaurentPolynomial`) | 1D warm-up symbol layer OK. |
| Univariate resultant | **Exists** (`Polynomial.resultant`, incl. `resultant_deriv`) | Node elimination for warm-up & separable classes OK. |
| Multivariate Laurent / node ideals on `𝕋³` | **Partial** (`MvPolynomial`; no Laurent unit theory) | Build: Laurent = `MvPolynomial` + clear denominators, or localize; **Laurent-unit theorem must be built** (Codex has the abelian core). |
| Schur/Feshbach block reduction (§1.1) | **Exists** (block-det lemmas) | Feasible; main work is the invertibility-of-`D` neighbourhood and the `S(k₀)=0` lemma. |
| Velocity matrix + `sign det v` charge (§1.3 nondeg.) | **Exists** (`det`, `sign` on ℝ) | **Fully feasible now** — pure finite linear algebra. This is the whole charge in the involutory case. |
| ELK degenerate degree = signature of residue form | **Absent** (no quadratic-form signature API, no local algebra/Gröbner residue) | **Hardest algebraic build.** Needed only for degenerate nodes (Gupta–Short fallback, general A2 layer (ii)). Large; defer. |
| Local/global topological degree, Poincaré–Hopf, Berry monopole | **Absent** (no Brouwer degree in Mathlib) | Do **not** import; reformulate as residue/resultant identity (§2 (ii)) or per-class resultant identity (§2 pragmatic). |
| Winding number / eigenphase count for warm-up | **Absent as packaged**; buildable from `Complex.arg`, root-counting on `S¹` | Feasible: warm-up proof is a periodic integer-count argument, no degree theory. |

**Per-ingredient bottom line.**
- **A1 charge, nondegenerate (the target case):** feasible now — Schur + jet +
  `sign det v`. This is the minimum-viable, and it is enough for 4a/4c and for the
  cubic/separable A4 class.
- **A3 tangent-forces-charge:** feasible now (one lemma on top of A1 nondeg.).
- **A2 sum-zero, per specific class via resultants:** feasible with moderate work
  (finite algebraic-number identities).
- **A2 sum-zero, fully general via global residue theorem:** **hardest step**;
  needs new residue/toric infrastructure not in Mathlib. Recommend proving the
  bounded/separable-class version first (A4 minimum-publishable), and the 1+1
  warm-up (§5) as the de-risking milestone.
- **ELK general degenerate degree:** second-hardest; only needed if a *degenerate
  but isolated* node must be charged (it is the honest way to say "Gupta–Short
  charge is not forced"); can be stated as an interface lemma and deferred.

**Single hardest step overall:** the **general sum-zero A2** (global residue /
degree over closed `𝕋³`). Everything else is either in Mathlib or a bounded finite
computation.

---

## 7. Failure modes (how such a charge can fail to exist at this level)

Each is named with what its occurrence would imply for the no-go program.

**F1 — Blindness (the charge computes to 0 on genuine cones).** If `deg_{k₀}(d)`
returns 0 on the cubic-walk nodes (4a) or on the zero-flow witness (4c), the
residue/Schur formulation is capturing only abelian data — same failure as the
determinant flow. *Implication:* route A's invariant does not exist **at the
adjugate/Schur level chosen**; either the d-vector extraction is wrong (e.g. wrong
`Im tr σ_a` projector, or `W` chosen non-generically so the traceless part is
killed) or a genuinely finer (non-2×2, higher-jet) invariant is required. Kill
condition of memo A1/§4.

**F2 — Non-additivity.** If `Q` depends on the basis choice `V₀, V₁` (isometry
onto `W` / `W^⊥`) or on the neighbourhood, it is not a well-defined per-node
integer and cannot be summed. *Implication:* the reduction is not licensed as
stated; must prove `Q` is independent of the `SU(2)×SU(N−2)` gauge in the block
(a required lemma, provable: `sign det v` is a similarity invariant of the jet).

**F3 — Sum non-vanishing (`Σ Q ≠ 0`).** If the honest global identity gives a
nonzero total, then either (a) the census missed nodes (Floquet π-partners,
corner aliases — the repo warns these are easy to miss), or (b) the charge is
secretly the abelian `m` (winding), which does *not* vanish. *Implication:* if (a),
fix the census (this actually *helps* the no-go: it exhibits the compensating
doubler/pseudo-doubler). If (b), the charge collapsed to F1's abelian shadow.

**F4 — Degeneracy escape.** If the physically interesting nodes are all degenerate
(`det v = 0`) so that only the ELK fallback applies and it is not forced nonzero,
then the *forcing* lemma A3 has no teeth. *Implication:* this is precisely the
Gupta–Short regime; it does not break the no-go **for the involutory class**, but
it means the theorem's scope is the involutory-tangent class only (as intended) —
the no-go cannot reach non-involutory walks, and should not claim to.

**F5 — Higher degeneracy (`dim ker > 2`).** If a node has a `≥3`-fold touching,
the 2×2 reduction is not licensed and the charge is a degree of a `d×d` block map;
the integer may not be `±1`. *Implication:* restricts A1 to genuine Weyl/Dirac
(2-band) nodes; a class hypothesis, not a fatal flaw, but must be an explicit
hypothesis in A4.

**F6 — The invariant exists but equals a coboundary of `m`.** Subtle worst case:
`Q` is well-defined, additive, sums to 0, sees the witness — but is functionally
determined by the abelian `m` after all (so it certifies nothing beyond GNVW).
*Implication:* the nonabelian layer would be illusory; the discriminating test is
**4c** (a node with `m = 0` and `Q ≠ 0` *proves* independence). Passing 4c rules
out F6.

**Overall:** the design *exists at this algebraic level* iff it (i) is gauge-
invariant (defeats F2), (ii) returns `±1` on cubic cones (defeats F1), (iii) sums
to 0 with a correct Floquet-paired census (F3), and (iv) is nonzero on the
`m = 0` witness (defeats F6). 4a + 4c are the two decisive gates; A3 delivers the
forcing on the involutory class (F4/F5 bound the scope, honestly).

---

## 8. References (cite by name; uncertain attributions flagged)

- **Nielsen–Ninomiya** fermion-doubling / no-go — KNOWN classic (Nucl. Phys. B,
  1981). We inherit the *topology heuristic*, not the action-based proof (memo §7).
- **Eisenbud–Levine** and **Khimshiashvili** — local degree = signature of the
  residue bilinear form on the local algebra (1977) — KNOWN.
- **Schur complement / Feshbach map** — standard linear algebra; Mathlib
  `Matrix.det_fromBlocks₁₁`.
- **Global Residue Theorem** (sum of Grothendieck residues on a complete variety
  = 0); **toric/sparse** version — Griffiths–Harris (complex); Tsikh;
  Cattani–Dickenstein–Sturmfels — **VERIFY** exact hypotheses before use.
- **von Neumann–Wigner** codimension-3 rule for level crossings — KNOWN **[phys]**.
- **Weyl node = Berry monopole / first Chern over enclosing S²** — Volovik;
  **Wan–Turner–Vishwanath–Savrasov 2011** — **[phys]/VERIFY**.
- **GNVW index** (Gross–Nesme–Vogts–Werner) for 1D QCA/quantum-walk flow — the
  `K₁`-winding shadow of §5 — **VERIFY** exact statement/scope (as already flagged
  in `MEMO_3PLUS1_ATTACK.md §3`).
- **Gupta–Short (2026)** stay-put family; their Appendix F residual Weyl-like
  states — **VERIFY** (as in the program memo).
- Repo, KNOWN/kernel-checked: `FullBlochZeroClassification` (crossing locus),
  `StationaryAmplitudeNoGo` (no involutory stay-put), Codex Laurent-unit /
  determinant-phase-law B-lane.
```
```

---

## 9. One-paragraph verdict

The per-crossing charge should be the **local topological degree of the
Feshbach/Schur-reduced d-vector**, `Q(k₀) = deg_{k₀}(d)`, which in the involutory
unit-speed case is simply `sign det v` of the `3×3` velocity — pure finite linear
algebra, computable now in Lean, gauge-invariant, and (by construction from the
*traceless* block) sensitive to exactly the nonabelian data the determinant flow
is blind to. A2's sum-zero is genuinely `0` per gap in 3D by a boundary-free
degree argument, whose exact-algebra realization is a **global residue / resultant
identity** normalized by the Laurent-unit (monomial) determinant — the hardest
build, to be done first on the bounded/separable class and de-risked by the 1+1
warm-up. A3 forces `Q = ±1` exactly on involutory cones. The three-symbol
protocol's decisive gates are the cubic walk (`±1`, total 0) and the zero-flow
witness (`Q ≠ 0` while `m = 0`); passing the latter is what the determinant flow
could not do, and is the acceptance test for the whole design.
