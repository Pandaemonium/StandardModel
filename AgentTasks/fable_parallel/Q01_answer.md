# Q1 verdict and answer: the positivity crux, solved to its exact boundary

## 0. Verdicts first (with the false things flagged loudest)

**V0. Three things in the question's framing are wrong, and one of them is load-bearing.**

- **F1 (load-bearing).** Q3 conflates two distinct positivities. The Weitzenböck slots decompose `D^# D`, i.e. the **mass/energy form** `[psi, D^2 psi] = [D psi, D psi]`. The Gupta–Bleuler quotient statement (a) is about the **state form** `[psi, psi]` on `V'/N`. Slot-wise Weitzenböck can never prove (a); it proves a different theorem (T-II below), which becomes *automatic* once (a) holds. The crux is a two-theorem structure, and the hard one (state positivity) is not a Weitzenböck statement at all. Details in Section 3.
- **F2.** Definitizability is **vacuous in finite dimensions** and must be struck from the hypothesis menu. Every Krein-self-adjoint operator on a finite-dimensional space is definitizable (take the minimal polynomial: `[p(D)x,x] = [0,x] = 0 >= 0`). Worse: counterexample O2 below is a `2x2` operator with real spectrum that is even *J-nonnegative* (`[x, Dx] >= 0` for all `x`) and still admits no nonvacuous physical sector. The finite-dimensional invariant that actually decides everything is the **sign characteristic** (Gohberg–Lancaster–Rodman), which is invisible to the spectrum and to any definitizability criterion. The correct finite-dimensional replacement for "definitizable" in every hypothesis list below is: **conditions on the sign characteristic of D at its real eigenvalues** (Gohberg–Lancaster–Rodman canonical form). That is the invariant that actually separates the good and bad cases, and it is finitely computable and Lean-formalizable.

- **F3.** Clause (c) of your proposed route ("kappa counts what the quotient removes") is half-right in a way that matters. The quotient removes **2κ** real dimensions: κ by the constraint, κ by the radical. This is the finite skeleton of the Kugo–Ojima *quartet* (hyperbolic-pair) mechanism. What κ counts is `dim N`. The correct count of what *survives* is the striking one — see Finding A.

**Positive verdicts:**

- **V1.** The theorem you want exists, is clean, and needs no operator-theoretic hypothesis on D at all for parts (a) and (b). State positivity of the quotient is a **Witt-decomposition fact about the constraint subspace alone**: the induced form on `V'/N` is positive definite **iff** the span of the constraint covectors has signature `(a, b, r)` with `b + r = q = κ`, and the canonical (gauge-matching, `N = gauge`) case is exactly `a = b = 0, r = κ`: the constraints span a **maximal isotropic subspace**. Theorem A below. The operator D enters only through one further hypothesis — invariance, `D Γ' ⊆ Γ'` — which buys descent and self-adjointness (Q4).
- **V2 (Finding A — I believe this is new to your program and valuable).** With `J = Γ` the chirality, inertia `(p, q) = (dim M_+, dim M_-)`, and Γ' maximal isotropic: `dim(V'/N) = p − q = ind(D)`, by your own kernel-checked McKean–Singer identity. **The chiral index counts the physical states that survive the maximal first-class quotient.** Your two kernel pillars of this month — index invariance and the Krein witness — meet in the dimension of the physical sector. This is a 5-line corollary of Theorem A plus your index theorem, and it belongs at the top of the next freeze document.
- **V3 (Finding B — flag on your own witness).** Your certified κ = 2 witness has inertia (2,2), i.e. `p = q`, hence `dim(V'/N) = 0` for **any** first-class quotient. It is the right witness for the mass-form statement it was built for, but it is structurally incapable of carrying a nonvacuous physical state sector. Nonvacuousness requires `p > q` strictly — equivalently `ind ≠ 0` — the finite "more photons than ghosts" condition. Your unbalanced (2,1), ind = 1 complex is the correct seed for state-sector experiments, not the balanced one.
- **V4 (Finding C).** Your literal 2-torus model (both directions spacetime) has a **vacuous** Gupta–Bleuler quotient — and this is *correct physics*, not failure: 2D Maxwell has no propagating photon; its entire physical content is the zero-mode holonomy pair, which is exactly the sector your Wilson-loop/area-law kernel asset already governs. The nonvacuous testbed is the 2-torus as a *spatial slice* of 2+1: the quotient is then exactly 1-dimensional per mode (the single 2+1 polarization). Both computed explicitly in Section 2.
- **V5.** The finite analog of the "annihilation part of the constraint" is exact and falls into a computable trichotomy per constraint hyperbolic plane (Section 2.1). Retardedness is the *selection rule between the two null eigenrays* in the oscillatory case — it is a choice of orientation, not the source of positivity. Positivity comes from isotropy + count; retardedness makes the choice D-invariant and canonical up to an anti-unitary (advanced ↔ retarded) equivalence.

---

## 1. Theorem A: the exact characterization (Q1)

### 1.1 Setup and statement

Let `(V, [.,.])` be a finite nondegenerate Hermitian space of inertia `(p, q)`, `q = κ ≤ p`. Let `G_1, ..., G_c` be linear constraints; write them via covectors: `G_i(x) = [γ_i, x]`, and let `Γ' = span{γ_1, ..., γ_c}`, with signature `(a, b, r)` (positive, negative, radical dimensions of the form restricted to Γ'). Set

```
V' = ker(G) = Γ'^perp,     N = V' ∩ V'^perp = radical of V'.
```

Basic facts (all finite linear algebra, all Lean-ready):

```
sig(V') = (p − a − r,  q − b − r;  radical of dim r),   and   N = Γ' ∩ Γ'^perp.
```

**Theorem A (characterization of state positivity).**

1. **(Positivity)** The induced form on `V'/N` is positive definite **iff** `b + r = q`. In particular `c ≥ q = κ`: at least κ independent constraints are necessary (also directly from eigenvalue interlacing: any codimension-c subspace carries negative index ≥ q − c).
2. **(Canonicity / gauge matching)** Suppose additionally the gauge distribution is spanned by the constraint covectors themselves (first-class self-generation, the finite Gauss-law structure: the shift generated by `G_i` through the form is translation along `γ_i`). Then `N = gauge directions` **iff** `Γ' is isotropic`, i.e. `(a, b, r) = (0, 0, κ)`: the constraints span a maximal isotropic subspace. In that case:

```
V' = Γ'^perp ⊇ Γ' = N,    dim(V'/N) = p − κ,    form on V'/N positive definite.
```

3. **(Descent)** If moreover `D` is Krein-self-adjoint and `D Γ' ⊆ Γ'`, then `D V' ⊆ V'`, `D N ⊆ N`, `D` descends to `D̄` on `H := V'/N`, and `D̄` is self-adjoint for the induced (genuinely positive definite) inner product. Real spectrum, spectral theorem, orthogonal eigenbasis — all legal on H.
4. **(Index identity)** If `J = Γ` with `(p, q) = (dim M_+, dim M_-)` and the carrier is rank-symmetric (your kernel-checked automatic cases), then `dim H = p − q = ind(D)`.

**Proof sketch (working-mathematician rigor).** (1) is the perpendicular-signature formula above: nonnegativity of `V'` means its negative index `q − b − r` vanishes. (2): with Γ' isotropic, `Γ' ⊆ Γ'^perp = V'`, and `N = Γ' ∩ V' = Γ'`; conversely if `a` or `b > 0`, the nondegenerate part of Γ' does not lie in `V'`, so gauge directions ⊄ N. Positive definiteness of the quotient: Witt-decompose `V = (H_1 ⊕ ... ⊕ H_κ) ⊕ W` where each `H_i` is a hyperbolic plane containing `γ_i` as one null ray and `W = (⊕H_i)^perp` is nondegenerate of signature `(p − κ, q − κ) = (p − κ, 0)`, positive definite. Then `V' = Γ' ⊕ W`, `N = Γ'`, `V'/N ≅ W`. (3): `D = D^#` preserves `Γ'` iff it preserves `Γ'^perp`; symmetry of `D̄` is immediate from `[Dx, y] = [x, Dy]` passing to the quotient; finite-dimensional symmetric for a positive form ⇒ self-adjoint. (4): `p − q = dim M_+ − dim M_- = ind` by your McKean–Singer family theorem. ∎

Note what is *absent* from the hypotheses: no definitizability (vacuous, F2), no spectral condition on D, no positivity of `D^#D` (see O2 — it can hold and still not help). The entire positivity content lives in the **signature of the constraint span**. This is the precise sense in which your Gupta–Bleuler instinct is right: GB works in the continuum not because of the frequency integral per se, but because the Lorenz covector `k_μ` is *null on shell* — isotropy — and there is *one per mode* — the count `r = κ`.

### 1.2 The counterexample ladder (each dropped hypothesis, sharpest small witness)

All matrices in a null-adapted basis; Gram matrices displayed; everything checkable by hand or kernel in minutes.

**O1 — drop the count (`c < κ`), positivity dies.** `V = C^4`, inertia (2,2), basis with Gram `diag(1,1,−1,−1)`, one null constraint `γ = e_1 + e_3`. Then `V' = γ^perp` is 3-dimensional containing `e_2, e_4, γ`; the form on `V'` restricted to `span(e_2, e_4)` is `diag(1, −1)`: the quotient is indefinite. Interlacing makes this unavoidable: `q − c = 2 − 1 = 1` negative square must survive.

**O2 — the degenerate obstruction realized in dimension 2, immune to every spectral hypothesis.** `V = C^2`, null basis `(γ, δ)`, Gram `G = [[0,1],[1,0]]` (inertia (1,1)). Take

```
D = [[0, 1], [0, 0]]      (D γ = 0,  D δ = γ).
```

Check: `GD = [[0,0],[0,1]]` is Hermitian, so D is Krein-self-adjoint. Moreover `[x, Dx] = |x_δ|^2 ≥ 0`: D is even **J-nonnegative**, definitizable (trivially — everything is), with real spectrum `{0}`. Yet: the only D-invariant line is `ker D = span γ`, which is **null**. Every invariant maximal nonnegative subspace is degenerate; every first-class quotient is vacuous (`p − κ = 0`). The obstruction is the **even-size Jordan block at a real eigenvalue with its sign characteristic** — invisible to spectrum, J-nonnegativity, and definitizability alike. This is the sharpest form of your "adversarial review" obstruction: it lives in 2 dimensions and no operator-positivity hypothesis removes it. Only the inertia condition `p > q` (equivalently `ind ≠ 0`) does.

**O3 — drop D-invariance of Γ', descent dies.** `V = C^3`, basis `(γ, δ, w)`, Gram

```
G = [[0,1,0],[1,0,0],[0,0,1]]        (inertia (2,1)),
```

Γ' = span γ (isotropic, r = κ = 1): so `V' = span(γ, w)`, `N = span γ`, `H = span w̄` — a perfect 1-dimensional physical sector, the 2+1-photon skeleton. Now take

```
D = [[0,0,0],[0,0,1],[1,0,0]]        (D γ = w,  D δ = 0,  D w = δ).
```

Check `GD = [[0,0,1],[0,0,0],[1,0,0]]` Hermitian: D is Krein-self-adjoint. But `D w = δ ∉ V'`: D does not preserve the constraint kernel, the induced operator on H is undefined. Physically: a dynamics whose current is not conserved pumps scalar modes out of the transverse sector. Moral: `D Γ' ⊆ Γ'` (equivalently `[D, G] = 0`) is a genuine, model-by-model finite check — it is the finite Ward identity, and it is *not* implied by Krein-self-adjointness.

**O4 — drop isotropy (`b = q, r = 0`): positivity survives, canonicity dies.** Inertia (2,1), Gram `diag(1,1,−1)`, single constraint covector `γ = e_3` (negative, non-null). Then `V' = span(e_1, e_2)` is positive definite, `N = 0` — but there is no gauge interpretation: nothing null was quotiented, the negative direction was deleted by hand. This is second-class/Dirac-bracket physics, "unitarity by fiat." (a) holds, (b) fails. So isotropy is not needed for positivity — it is needed for the quotient to *be* a gauge quotient. The two failure axes (positivity vs. canonicity) are independent, and Theorem A separates them exactly.

**O5 — drop `p > κ`: positivity and canonicity survive, physics dies (vacuity).** Any `p = q` model, including O2 and your (2,2) witness. `dim H = 0`. This is your own "true but vacuous" failure mode, and it is the one your program's discipline is best equipped to catch — which is why Finding B is flagged loudly above.

### 1.3 Canonicity: the exact boundary, and the repair hypothesis

Pontryagin's theorem (existence of a D-invariant maximal nonnegative subspace for any Krein-self-adjoint D on Π_κ) is the *wrong tool*: nonconstructive, non-unique, and — your review was correct — the subspace can be degenerate (O2 is the minimal case). The quotient route replaces "choose a subspace" by "compute the kernel of the Gauss operators," and Theorem A says this is canonical exactly when:

**(H\*) Constraint completeness.** The closure/Gauss operators of the decorated complex supply `κ` independent covectors spanning an isotropic, D-invariant subspace Γ'.

This is the single repair hypothesis your route needs, and it is three finite checks per model: (i) *nullity* of each Gauss covector (computable from the soldering data; in the gauge models below it is precisely the on-shell condition), (ii) *rank* = κ (count independent null Gauss covectors against the negative inertia of Γ — if rank < κ, no canonical positive sector exists, and the gap `κ − rank(Γ')` is the exact measure of how far your model is from admitting one), (iii) *D-invariance* (the finite Ward identity, O3). When (H\*) fails, Theorem A(1) still tells you the full menu of non-canonical repairs (add second-class deletions until `b + r = q`), each with its physical price labeled.

Residual freedom under (H\*): when D moves within a constraint plane, there can be two admissible null rays (Section 2.1, case iii — retarded vs. advanced). The two resulting quotients are intertwined by the anti-unitary conjugation swapping the rays; spectra of `D̄` and all slot forms agree. So the *physics* of H is canonical; only its complex structure carries the two-fold choice. That is exactly the status of positive vs. negative frequency in the continuum, now as a finite lemma.

---

## 2. The right V' (Q2)

### 2.1 What plays the annihilation part: a finite trichotomy

In the continuum, GB imposes only the *annihilation part* of the Lorenz constraint. In finite dimensions there is no frequency integral, and here is what replaces it. By Witt, the constraint-carrying sector of V decomposes into κ hyperbolic planes `H_i` (each of inertia (1,1)) orthogonal to the positive remainder W. A GB choice is a null ray in each `H_i`, chosen D-invariantly. Parametrize the restriction of the relevant evolution operator to a plane in its null basis, Gram `[[0,1],[1,0]]`; Krein-self-adjointness forces

```
M = [[z, s], [t, z̄]],   s, t real,  z complex,   Δ := disc = 4( s t − (Im z)^2 ).
```

Trichotomy (each case decided by a 2×2 computation):

- **(iii) Oscillatory, `Δ < 0`:** eigenvalues form a complex-conjugate pair; **both eigenvectors are null** (check: for eigenvalue λ, the eigenvector `v = (s, λ − z)` has `[v,v] = 2s(Re λ − Re z) = 0` since `Re λ = Re z`). Exactly two invariant null rays, swapped by conjugation. This is the finite positive/negative-frequency split; *retardedness = the rule selecting one ray consistently across planes.* This case is the finite "discrete positive-energy condition" from your hypothesis menu — it is where that candidate hypothesis lands, made exact.
- **(scalar) `M = λ·Id`, λ real:** every ray invariant; the constraint covector `γ_i` itself is the canonical choice. This is the free photon per mode (scalar and longitudinal modes degenerate at ω): the choice is canonical because *the constraint covector is one of the null rays*.
- **(ii) Jordan, `Δ = 0`, nondiagonalizable:** unique invariant ray, automatically null (O2). Choice forced; the plane contributes nothing to H (correctly — but if this exhausts V, vacuity).
- **(i) Real-split, `Δ > 0`:** two real distinct eigenvalues, eigenvectors of norms `+` and `−`, **no invariant null ray exists.** GB is impossible on this plane: the negative-norm state is a genuine propagating ghost with its own frequency, not a gauge artifact. **This is a kill-condition**: a model whose constraint planes carry real-split dynamics has no first-class positive sector, full stop. Pre-register it.

Note the pleasant inversion: in Krein space, *nonreal* spectrum on the constraint planes is the healthy (oscillatory) case, and real-split spectrum is the pathology. Any intuition imported from Hilbert space gets this backwards.

A hyperbolic plane never contributes physical states — its quotient contribution is always 0 (both the ray and its perp-within-the-plane collapse). That is the quartet mechanism in one sentence: unphysical states leave in conjugate pairs, `2κ` dimensions total, F3.

### 2.2 The torus computations, explicitly

**(A) Your literal 2-torus (both directions spacetime; transports U_1, U_2; one plaquette).** Linearize `U_j = exp(i a_j)`; Fourier modes `k ∈ (Z_N)^2`; forward-difference symbols `K_j(k) = 1 − e^{2πi k_j/N}`. Covariant field per mode: `(a_0, a_1) ∈ C^2` with Krein form `[a, b] = − ā_0 b_0 + ā_1 b_1` (inertia (1,1), κ = 1 per mode). The solution (one-particle) sector is the kernel of the discrete d'Alembertian: `|K_0| = |K_1|`. Lorenz/Gauss covector: `γ_k = (−K_0, K_1)`, so that `[γ_k, a] = K_0^* a_0 + K_1^* a_1` = discrete `∂·a`; and

```
[γ_k, γ_k] = −|K_0|^2 + |K_1|^2 = 0   exactly on shell.
```

So per on-shell mode: `V'_k = γ_k^perp = span γ_k = N_k`, and `H_k = 0`. **The quotient is vacuous — correctly.** 2D Maxwell has no transverse polarization; `p − κ = 1 − 1 = 0` per mode is the theorem agreeing with the physics. What remains physical is the `k = 0` sector: the holonomy `a_1(0)` (Wilson line, with conjugate electric flux) — compact, positive, and *exactly the sector your kernel-checked strong-coupling Wilson-loop asset lives in.* The `a_0(0)` zero mode is the residual negative direction, removed by the global charge constraint (total charge 0); in the linearized snapshot this is an honest second-class deletion — flag it in the freeze document as the known finite-volume subtlety, not hide it.

**(B) The 2-torus as spatial slice of 2+1.** Per spatial mode `k ≠ 0`: fields `(a_0, a_1, a_2) ∈ C^3`, form `[a,b] = −ā_0 b_0 + ā_1 b_1 + ā_2 b_2`, inertia (2,1), κ = 1. On shell `|K_0|^2 = |K_1|^2 + |K_2|^2`; constraint covector `γ_k = (−K_0, K_1, K_2)`, null on shell. Then

```
V'_k = γ_k^perp  (dim 2, contains γ_k),   N_k = span γ_k,
H_k  = span ε_k,   ε_k = (0, K_2^*, −K_1^*):   [γ_k, ε_k] = 0,   [ε_k, ε_k] = |K_1|^2 + |K_2|^2 > 0.
```

One positive-definite physical polarization per mode — the correct `D − 2 = 1` count for the 2+1 photon. This, not (A), is the minimal nonvacuous testbed, and every step above is a finite matrix identity ready for the Lean layer.

So: yes, the right V' is the kernel of the explicit closure/Gauss operators; the "annihilation part" role is played by the null-eigenray selection of Section 2.1 (which in the free gauge model is canonically the Gauss covector itself); and retardedness enters only as the consistent orientation of that selection — necessary for D-invariance in case (iii), irrelevant to positivity, which Theorem A already delivers from isotropy + count.

---

## 3. Weitzenböck reduction (Q3): the two-theorem structure

Restating F1 constructively. There are two positivities:

- **T-I (state positivity):** `[ψ, ψ] > 0` on `V'/N`. This is Theorem A. The Weitzenböck slots *cannot* prove it and should not be asked to: it is a statement about the form and the constraints, with D entering only via invariance.
- **T-II (mass-form positivity and gap):** `[ψ, D^2 ψ] ≥ 0` on `V'/N`, with structure. Once T-I holds, the *bare* nonnegativity is automatic (`[ψ̄, D̄^2 ψ̄] = ⟨D̄ψ̄, D̄ψ̄⟩ ≥ 0` for the self-adjoint D̄). What the slots buy is strictly more: a channel decomposition of the mass and a criterion for masslessness. This is where your Move-1 identity earns its keep — *after* the quotient, not in place of it.

**The slot lemmas (exact finite statements to hand to Lean):**

- **S0 (slot descent, the master lemma).** Let Q = A^# A with `A Γ' ⊆ Γ'` and `A V' ⊆ V'`. Then for `ψ ∈ V'`: `[ψ, Qψ] = [Aψ, Aψ] ≥ 0` (since `Aψ ∈ V'` and T-I gives nonnegativity there), and Q descends with induced form `‖Āψ̄‖^2`. So slot positivity on H reduces to exhibiting each slot as a *constraint-compatible Krein–Gram square*.
- **S-A (aperture).** `Q_A = Q(Σ_e α_e) = q(Σ_e α_e)·Id` by the Clifford relation, and `q(Σ α_e) = det P ≥ 0` is exactly your Layer-K kernel identity (sum of future null covectors is causal). Status: KERNEL modulo transcription — this slot is already done, and it is the exact point where Layer K feeds T-II.
- **S-T (turn).** `Q_T = φ^# φ` provided the decoration satisfies `φ^# = φ` and `φ Γ' ⊆ Γ'`, `φ V' ⊆ V'` (constraint-compatible potential). Finite check per decoration. Status: statement-first, straightforward.
- **S-C (closure).** Candidate identity: `Q_C = Σ_p M_p^# M_p` with `M_p = 1 − U_p` (plaquette holonomy), using your kernel-checked "commutator of transports = plaquette curvature." For unitary transports this is a pointwise Gram square — if the identity survives your normalization, it supersedes the "beyond-leading-order" formulation of your open problem #3 in the unitary-transport regime: positivity would be exact, not perturbative, with the strong-coupling expansion only needed for *expectation values* in the gauge measure. Status: STRATEGY — verify the factorization in your normalization before celebrating; if a cross-term obstructs it, the obstruction is itself the sharp statement of open problem #3.
- **S-E (soldering-gradient).** Conjectured torsion-square: `E = T^# T` with `T` the edgewise soldering-gradient (teleparallel shape). Status: CONJECTURE; the exact finite claim is the factorization plus constraint-compatibility of T. If it fails, E is the one indefinite channel — which would be a *physically interpretable* finding (gravity as the non-Gram slot), not a disaster; pre-register both branches.

**Conjunction theorem (T-II, theorem-shape).** Under (H\*) and S-A, S-T, S-C, S-E: on H,

```
4 D̄^2 = Q̄_A + Q̄_C + 4 Q̄_T + 4 Ē,   each slot ≥ 0,
m^2 := min spec(D̄^2) ≥ 0,   and   ker D̄^2 = ker Ā_A ∩ ker Ā_C ∩ ker Ā_T ∩ ker Ā_E.
```

The last clause is the physical payoff: **a massless physical state is one simultaneously flat in all four channels** — aperture-collinear, closure-flat, turn-free, torsion-free — and by your index theorem, when `ind ≠ 0` at least `|ind|` such states are guaranteed to exist and to survive the quotient *provided* they are constraint-compatible. That compatibility is one more finite lemma:

- **S-Z (index survival).** The index-forced chiral zero mode of the unbalanced complex lies in `V'` and projects to a nonzero class in H iff it is not in `Γ'`. State and check per model; combined with Finding A this closes the loop "the index explains what must stay" *inside the physical sector*, not merely in V.

---

## 4. The legal spectral statement (Q4)

Once (H\*) holds, the following is a theorem-shape, with every hypothesis finite and displayed:

> **Theorem (physical spectrum).** Let (V, [.,.]) have inertia (p, q), let Γ' be the span of the closure/Gauss covectors, and assume (H\*): Γ' is isotropic of dimension q and D Γ' ⊆ Γ'. Set H = Γ'^perp / Γ' with the induced inner product, which is positive definite of dimension p − q = ind(D). Then D induces a self-adjoint operator D̄ on H; spec(D̄) ⊂ R with an orthonormal eigenbasis; and the mass-squared of the physical sector,
> ```
> m^2 := min spec(D̄^2),
> ```
> is well-defined, nonnegative, decomposition-independent, and equal to the minimum over unit ψ̄ ∈ H of the induced Weitzenböck form (1/4)(Q̄_A + Q̄_C + 4Q̄_T + 4Ē). m^2 = 0 iff a physical state is simultaneously flat in all four channels; if ind(D) ≠ 0, at least one constraint-compatible forced zero mode exists iff S-Z holds.

What remains to check, model by model, and nothing else: (i) nullity + rank of the Gauss covectors ((H\*)-i,ii — with the trichotomy kill-condition of Section 2.1 case (i) as the failure mode); (ii) the finite Ward identity `D Γ' ⊆ Γ'` ((H\*)-iii, O3 is the counterexample when dropped); (iii) `p > q` for nonvacuity (O2/O5); (iv) the slot factorizations if you want the channel-resolved form rather than bare nonnegativity. Until (i)–(iii) are kernel-checked for a given model, the sentence "m² = min spec" remains forbidden for that model under your own discipline — but the theorem above is the exact license you will hold once they are.

---

## 5. Formalization ladder (statement-first; no analysis smuggled in)

All over a fixed finite-dimensional complex Hermitian space with nondegenerate form of inertia (p, q); "isotropic" and "radical" as usual. Ordered so each lemma uses only its predecessors.

- **L1 (perp-signature).** For a subspace S of signature (a, b, r): `sig(S^perp) = (p − a − r, q − b − r)` with radical `S ∩ S^perp` of dimension r. *(Pure linear algebra; the workhorse. Likely needs building — I do not believe Mathlib has indefinite Witt theory in this form; check `Mathlib.LinearAlgebra.QuadraticForm` for the Witt decomposition ingredients.)*
- **L2 (finite Gupta–Bleuler).** If Γ' is isotropic with dim Γ' = q, then the form is nonnegative on `Γ'^perp`, its radical is Γ', and the induced form on `Γ'^perp/Γ'` is positive definite of dimension p − q. *(Corollary of L1 via Witt decomposition into q hyperbolic planes ⊕ positive remainder.)*
- **L3 (necessity).** Any subspace of codimension c carries negative index ≥ q − c; hence no positive-definite quotient from fewer than q constraints. *(Cauchy interlacing, finite.)*
- **L4 (descent).** If `D^# = D` and `D Γ' ⊆ Γ'`, then D preserves `Γ'^perp`, descends to `Γ'^perp/Γ'`, and the induced operator is self-adjoint for the induced form; real spectrum, orthonormal eigenbasis. *(Finite; no functional analysis.)*
- **L5 (index = physical dimension).** With J = Γ, inertia (dim M_+, dim M_-), rank-symmetric carrier, Γ' maximal isotropic: `dim(Γ'^perp/Γ') = ind(D)`. *(L2 + your kernel McKean–Singer family theorem; a genuinely new kernel target and the headline.)*
- **L6 (slot descent).** If `Q = A^# A` with A preserving Γ' and `Γ'^perp`, then the induced form of Q on the quotient is `‖Āψ̄‖^2 ≥ 0`; instantiate with S-A (already Layer-K), S-T, and the S-C factorization check. *(Finite; S-C's factorization is the one open verification.)*

Plus the 2×2 trichotomy of Section 2.1 as a decidable classification lemma if you want the kill-condition mechanized, and O2/O3 as kernel-checked *counterexample certificates* — your methodology of freezing failure modes deserves them in the repository next to the theorems.

---

## 6. Literature anchors

- L. S. Pontryagin, "Hermitian operators in spaces with indefinite metric," Izv. Akad. Nauk SSSR Ser. Mat. 8 (1944) — the invariant maximal nonnegative subspace theorem (the tool Theorem A replaces).
- J. Bognár, *Indefinite Inner Product Spaces*, Springer, 1974 — isotropic subspaces, quotients, Witt-type decompositions; L1–L2 are Bognár Chapter I–II material.
- T. Ya. Azizov, I. S. Iokhvidov, *Linear Operators in Spaces with an Indefinite Metric*, Wiley, 1989 — invariant subspaces, degeneracy phenomena.
- I. S. Iokhvidov, M. G. Krein, H. Langer, *Introduction to the Spectral Theory of Operators in Spaces with an Indefinite Metric*, Akademie-Verlag, 1982.
- H. Langer, "Spectral functions of definitizable operators in Krein spaces," Lecture Notes in Math. 948, Springer, 1982 — for orientation only; per F2, definitizability is contentless in your finite setting.
- I. Gohberg, P. Lancaster, L. Rodman, *Indefinite Linear Algebra and Applications*, Birkhäuser, 2005 — **the** finite-dimensional reference: canonical forms of J-self-adjoint matrices, sign characteristic; O2 is their minimal even Jordan block.
- S. N. Gupta, Proc. Phys. Soc. A 63 (1950) 681; K. Bleuler, Helv. Phys. Acta 23 (1950) 567 — the originals.
- T. Kugo, I. Ojima, Prog. Theor. Phys. Suppl. 66 (1979) — quartet mechanism; Theorem A + the hyperbolic-plane picture is its linear-algebra skeleton. Also N. Nakanishi, I. Ojima, *Covariant Operator Formalism of Gauge Theories and Quantum Gravity*, World Scientific, 1990.
- F. Strocchi, *An Introduction to Non-Perturbative Foundations of Quantum Field Theory*, Oxford, 2013 — rigorous indefinite-metric GB; Morchio–Strocchi on indefinite-metric QFT (Ann. Inst. H. Poincaré, c. 1980 — exact volume unverified).
- H. Neuberger, Phys. Lett. B 183 (1987) 337 — the lattice-BRST 0/0 obstruction on compact groups: a **kernel-relevant warning** that a naive finite BRST-cohomology route (the alternative to your quotient) fails nonperturbatively on the lattice; von Smekal et al. proposed cures (arXiv:0812.2992 — identifier unverified). This is a concrete reason your Gupta–Bleuler quotient, not BRST, is the right finite formalism.

---

## 7. The boundary, in one paragraph

State positivity is not an operator-theory problem and never was: it is the Witt geometry of the constraint span — isotropy plus count — and Theorem A settles it completely in finite dimensions, with O1–O5 marking every wall. The operator D contributes exactly two things: the invariance `D Γ' ⊆ Γ'` (finite Ward identity, checkable, O3 when it fails) and the trichotomy on constraint planes (with real-split dynamics as the pre-registerable kill-condition). The one hypothesis your route genuinely needs and cannot derive is (H\*) constraint completeness — and its rank condition converts, via your own index theorem, into the memorable finite law `dim(physical sector) = ind(D)`: the index does not merely protect massless modes; it *counts the states that survive gauge*. Your balanced witness is therefore the wrong stage for this act, your unbalanced ind = 1 complex is the right one, and the 2+1 torus computation of Section 2.2(B) is, I believe, the shortest path to the first kernel-checked nonvacuous physical sector in the program.
