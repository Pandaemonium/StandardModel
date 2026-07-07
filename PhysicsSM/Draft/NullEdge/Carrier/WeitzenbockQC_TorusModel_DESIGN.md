# Design doc — the torus `Q_C` brick (Z2×Z2 gauge lattice realization of `[∇_e,∇_f]`)

**Status: statement design only.** Every Lean fragment below was elaborated /
kernel-checked in a scratch environment (Lean 4 + Mathlib). No proof obligation is
left open in the *statements*; the two nontrivial lemmas (shift-exchange and the KEY
commutator identity) were additionally verified to be *true* by completing their
proofs, so the design carries no hidden false claim. Proofs are quoted here only to
certify the statements; the shipped brick would keep them (they are short).

Companion brick: `WeitzenbockMaster.lean` (brick 2b), which supplies the abstract
identity `4 • D0² = Q_A + Q_C` with
`Q_C = Σ_e Σ_f (γe·γf − γf·γe)·(∇e·∇f − ∇f·∇e)`. This doc realizes the transport
commutator `[∇_a, ∇_b]` on a concrete minimal gauge lattice so that it becomes a
plaquette holonomy defect.

---

## 0. Type-class / environment summary

* Base ring `R`: `[CommRing R]` (matches brick 2b; `Field` not needed).
* Fibre / matter module `W`: `[AddCommGroup W] [Module R W]`.
* Gauge group elements are packaged as **linear endomorphisms** `W →ₗ[R] W`
  (`Module.End R W`), *not* as `LinearEquiv`. Reasons:
  - the `nabla` algebra only ever needs composition + subtraction, i.e. the
    (noncommutative) ring structure on `Module.End R W`; invertibility of `U` is
    irrelevant to the identity and would only add friction;
  - `Module.End R W` is a `Ring`, so pointwise product = composition is literally
    the ring `*` — this is what makes the read-off to a holonomy clean.
* The lattice `Site := ZMod 2 × ZMod 2` is a `Fintype` with `DecidableEq`
  (both derived automatically), so all sums are finite and everything is
  kernel-computable **except** the maps into `W →ₗ[R] W`, which are generally
  `noncomputable` (LinearMap has no `DecidableEq`/`Computable` content over a
  general module). This is fine — the brick proves an *equational* identity, not a
  `decide`.

> **Flag (noncomputable).** `gaugeLM`, `shiftLM`, `nabla` build `LinearMap`s over a
> general `Module`; do **not** mark them `def ... := by decide` or expect `#eval`.
> They need no `noncomputable` keyword themselves (they are honest `def`s producing
> data), but any downstream `def` that tries to *compute* with them will need
> `noncomputable`. The finiteness that matters (`Fintype Site`, two directions
> `Fin 2`) is only used so the brick-2b sums `Σ_a Σ_b` are finite.

---

## 1. Exact Lean definitions

```lean
import Mathlib
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.Torus

variable {R W : Type*} [CommRing R] [AddCommGroup W] [Module R W]

/-- Vertices of the minimal gauge torus: the `Z2 × Z2` group, acting on itself by
translation. `DecidableEq` and `Fintype` are derived. -/
abbrev Site : Type := ZMod 2 × ZMod 2

/-- The two lattice unit vectors `e_0 = (1,0)`, `e_1 = (0,1)`, indexed by the
direction `a : Fin 2`. -/
def unitVec : Fin 2 → Site := ![(1, 0), (0, 1)]

/-- **Shift** `T_a`.  `(T_a ψ) x = ψ (x + e_a)`.  Realized as `LinearMap.funLeft`
(precomposition with translation), which is linear for free. -/
def shiftLM (a : Fin 2) : (Site → W) →ₗ[R] (Site → W) :=
  LinearMap.funLeft R W (fun x => x + unitVec a)

/-- The same shift as a `LinearEquiv` (translation is an `Equiv`), used only for the
`Q_C = 0 ⇔ flat` read-off where surjectivity of `T_a ∘ T_b` is needed. -/
def shiftLE (a : Fin 2) : (Site → W) ≃ₗ[R] (Site → W) :=
  LinearEquiv.funCongrLeft R W (Equiv.addRight (unitVec a))

/-- **Pointwise gauge multiplication** `M(U)`.  `(M(U) ψ) x = U x (ψ x)`, i.e.
apply the endomorphism sitting at vertex `x`.  Linear in `ψ`. -/
def gaugeLM (U : Site → (W →ₗ[R] W)) : (Site → W) →ₗ[R] (Site → W) where
  toFun ψ := fun x => U x (ψ x)
  map_add' f g := by funext x; simp
  map_smul' c f := by funext x; simp

/-- **Covariant difference** `∇_a := M(U_a) ∘ T_a − id`.  `U : Fin 2 → Site → End`
is the gauge field: `U a x : W →ₗ[R] W` is the parallel transporter across the
`a`-edge based at `x`. -/
def nabla (U : Fin 2 → Site → (W →ₗ[R] W)) (a : Fin 2) :
    (Site → W) →ₗ[R] (Site → W) :=
  (gaugeLM (U a)).comp (shiftLM a) - LinearMap.id
```

Notes on choices:

* `LinearMap.funLeft R W f : (β → W) →ₗ[R] (α → W)` for `f : α → β` is exactly
  precomposition `ψ ↦ ψ ∘ f`. With `f = (· + e_a)` this gives `(T_a ψ) x = ψ (x+e_a)`.
  This is why `T_a` needs **no** hand-written linearity proof.
* `gaugeLM` is the only definition needing its `map_add'/map_smul'` filled — both are
  one-line `funext x; simp` (pointwise `LinearMap.map_add`/`map_smul`).
* Keeping `∇_a = M∘T − id` (rather than `T − id`, `M(T−1)`, …) is essential: it is the
  gauge-covariant lattice derivative and its `−id` piece is exactly what cancels in
  the commutator (§3).

---

## 2. The shift-exchange (non-Leibniz) lemma

The single geometric input. `τ_a` shifts the *field of endomorphisms*:
`(V ∘ τ_a)(x) := V (x + e_a)`.

```lean
/-- **Shift-exchange / non-Leibniz identity.**
`T_a ∘ M(V) = M(V ∘ τ_a) ∘ T_a`, where `(V ∘ τ_a) x = V (x + e_a)`.
Pushing a shift past a pointwise multiplication re-bases the multiplier one edge
along `a`.  (cf. arXiv:hep-lat/0309120.) -/
theorem shift_mul_pointwise (a : Fin 2) (V : Site → (W →ₗ[R] W)) :
    (shiftLM (R := R) a).comp (gaugeLM V)
      = (gaugeLM (fun x => V (x + unitVec a))).comp (shiftLM a) := by
  apply LinearMap.ext; intro ψ; funext x
  simp [shiftLM, gaugeLM, LinearMap.funLeft]
```

**Proof method (verified):** `LinearMap.ext` then `funext x`, then a single `simp`.
Both sides evaluate at `x` to `V (x + e_a) (ψ (x + e_a))` definitionally, so `simp`
(unfolding `shiftLM`, `gaugeLM`, `LinearMap.funLeft`) closes it. Note: **`add_comm`
is not needed here** — the two sides are literally equal after unfolding. `add_comm`
enters only in the *shift commutativity* fact `T_a ∘ T_b = T_b ∘ T_a` below, which is
where "soldering commutes with transport" (`hcomm` of brick 2b) is discharged on this
model.

Auxiliary facts used in §3 (both verified, both one-liners):

```lean
/-- `M` is a monoid homomorphism from pointwise-composition to composition:
`M(A) ∘ M(C) = M(fun x => A x ∘ C x)`. -/
theorem gauge_comp (A C : Site → (W →ₗ[R] W)) :
    (gaugeLM A).comp (gaugeLM C) = gaugeLM (fun x => (A x).comp (C x)) := by
  apply LinearMap.ext; intro ψ; funext x; simp [gaugeLM]

/-- Shifts commute (this is the model-level content of brick-2b `hcomm`). Uses
`add_comm` on `Site`. -/
theorem shift_comm (a b : Fin 2) :
    (shiftLM (R := R) (W := W) a).comp (shiftLM b)
      = (shiftLM b).comp (shiftLM a) := by
  apply LinearMap.ext; intro ψ; funext x
  simp only [shiftLM, LinearMap.comp_apply, LinearMap.funLeft_apply]
  rw [add_right_comm]   -- x + e_b + e_a = x + e_a + e_b
```
```

---

## 3. KEY lemma — commutator = path-difference

**Confirmed: the target statement is exactly right** (no sign flip, no order fix). It
was proved in full. The pointwise product `·` is **composition of endomorphisms in
`Module.End R W`**, i.e. `(A · C) x = (A x).comp (C x)` = "apply `C x` first, then
`A x`". The `τ_a` sits on the **second** factor of the first term and on the **first**
term's partner via `τ_b`, precisely because the shift is pushed past the *inner*
gauge multiplication.

```lean
/-- **KEY: transport-commutator = plaquette path difference.**
`[∇_a, ∇_b] = M( U_a·(U_b∘τ_a) − U_b·(U_a∘τ_b) ) ∘ (T_a ∘ T_b)`,
where `(A·C) x = (A x).comp (C x)` and `(U∘τ_a) x = U (x + e_a)`.
The `−id` parts of `∇` cancel in the commutator; the two surviving terms are the two
ordered parallel transports around the `a,b`-plaquette based at `x`:

  * `U_a x ∘ U_b (x+e_a)`  — go along `b` first (from `x+e_a`), then along `a`;
  * `U_b x ∘ U_a (x+e_b)`  — go along `a` first (from `x+e_b`), then along `b`. -/
theorem nabla_commutator_path_difference
    (U : Fin 2 → Site → (W →ₗ[R] W)) (a b : Fin 2) :
    (nabla U a).comp (nabla U b) - (nabla U b).comp (nabla U a)
      = (gaugeLM (fun x => (U a x).comp (U b (x + unitVec a))
                            - (U b x).comp (U a (x + unitVec b)))).comp
          ((shiftLM a).comp (shiftLM b)) := by
  apply LinearMap.ext; intro ψ; funext x
  simp only [nabla, gaugeLM, shiftLM, LinearMap.sub_apply,
    LinearMap.comp_apply, LinearMap.id_apply, LinearMap.coe_mk, AddHom.coe_mk,
    LinearMap.funLeft_apply, Pi.sub_apply, Function.comp, map_sub]
  rw [show x + unitVec b + unitVec a = x + unitVec a + unitVec b from by ring]
  abel
```

**Why exactly right — the expansion (all verified by the proof above).** Write
`A = U_a`, `B = U_b`. Then `∇_a = M(A)T_a − 1`, `∇_b = M(B)T_b − 1` and

```
∇_a ∇_b = M(A) T_a M(B) T_b − M(A)T_a − M(B)T_b + 1
        = M(A) M(B∘τ_a) T_a T_b − M(A)T_a − M(B)T_b + 1     (shift_mul_pointwise)
        = M(A·(B∘τ_a)) T_a T_b − M(A)T_a − M(B)T_b + 1        (gauge_comp)
∇_b ∇_a = M(B·(A∘τ_b)) T_b T_a − M(B)T_b − M(A)T_a + 1.
```

Subtracting, the linear (`M(A)T_a`, `M(B)T_b`) and constant (`1`) terms cancel, and
`T_a T_b = T_b T_a` (`shift_comm`), so

```
[∇_a,∇_b] = ( M(A·(B∘τ_a)) − M(B·(A∘τ_b)) ) T_a T_b
          = M( A·(B∘τ_a) − B·(A∘τ_b) ) (T_a T_b),
```

using additivity of `M` (`M(P)−M(Q)=M(P−Q)`). This is verbatim the claimed identity.

**Order/sign convention to lock in the brick:**
* pointwise `·` = `Module.End` `*` = `LinearMap.comp` (leftmost applied last);
* `τ` is applied to the multiplier that got *jumped over*: first term `U_b∘τ_a`,
  second term `U_a∘τ_b`;
* overall sign is `+(a-then read)` minus the swapped copy — matches brick-2b's
  `∇e·∇f − ∇f·∇e`.

---

## 4. `Q_C` read-off: `Q_C = 0 ⇔ flat`

Define the **plaquette curvature field** (the bracketed multiplier above):

```lean
/-- Plaquette curvature: difference of the two ordered transports around the
`a,b`-plaquette based at `x`. `F a b x = 0` for all `x` ⇔ the two paths agree. -/
def plaquetteCurvature (U : Fin 2 → Site → (W →ₗ[R] W)) (a b : Fin 2) :
    Site → (W →ₗ[R] W) :=
  fun x => (U a x).comp (U b (x + unitVec a)) - (U b x).comp (U a (x + unitVec b))
```

By the KEY lemma, `[∇_a,∇_b] = M(F a b) ∘ (T_a T_b)`. Because `T_a T_b` is a
`LinearEquiv` (§1 `shiftLE`, so a *surjective* / bijective endomorphism), composing
with it neither creates nor destroys the zero map. Hence:

```lean
/-- Local flatness ⇔ transport commutation, on the torus model.
LHS is holonomy path-independence at every base point; RHS is `[∇_a,∇_b]=0`. -/
theorem flatness_iff_commute (U : Fin 2 → Site → (W →ₗ[R] W)) (a b : Fin 2) :
    (∀ x, (U a x).comp (U b (x + unitVec a))
            = (U b x).comp (U a (x + unitVec b)))
      ↔ (nabla U a).comp (nabla U b) = (nabla U b).comp (nabla U a) := by
  sorry  -- design target; proof route below
```

Proof route for `flatness_iff_commute`:
1. `commute ↔ [∇_a,∇_b] = 0` is `sub_eq_zero` on `LinearMap` (`sub_eq_zero.symm`).
2. `[∇_a,∇_b] = M(F) ∘ (T_a T_b)` by `nabla_commutator_path_difference`.
3. `M(F) ∘ (T_a T_b) = 0 ↔ M(F) = 0`: `(· ∘ shiftLE)` is postcomposition by an
   equiv, hence injective on maps; use that `shiftLE a ≪≫ shiftLE b` is surjective,
   so `M(F) ∘ e = 0 → M(F) = 0` via `LinearMap.comp_right`/`Function.Surjective`.
   (Concretely: `M(F) = M(F) ∘ e ∘ e.symm = 0 ∘ e.symm = 0`.)
4. `M(F) = 0 ↔ ∀ x, F x = 0`: `gaugeLM` is `0` iff pointwise `0`; then
   `LinearMap` at each `x` is `0` iff `F x = 0` — but note `M(F) = 0` means
   `∀ ψ x, F x (ψ x) = 0`, which gives `∀ x, F x = 0` by choosing `ψ` to hit each
   coordinate (needs `W` to have enough vectors, i.e. this direction is the honest
   `∀ ψ` statement). **Cleanest fix:** state flatness as `M(F a b) = 0` (or
   `∀ x, F a b x = 0` *plus* `Nontrivial`/nothing), avoiding the "enough test
   vectors" subtlety — see the flag in §5.

**Brick-2b hookup.** With `E := Fin 2`, `γ` the soldered generators and
`∇ := nabla U`, `Q_C = Σ_a Σ_b (γa·γb − γb·γa)·(∇a·∇b − ∇b·∇a)`. Each transport
commutator is `M(F a b)∘(T_aT_b)`, so **flat (`∀ a b x, F a b x = 0`) ⇒ every
`[∇_a,∇_b] = 0` ⇒ `Q_C = 0`** — this is the concrete instance of brick 2a
(`SolderedSquareGram`: `[∇e,∇f]=0 ⇒ Q_C=0`). The converse `Q_C = 0 ⇒ flat` needs the
Clifford commutators `γa·γb − γb·γa` to be "nondegenerate enough" to separate the
independent `[∇_a,∇_b]` blocks; on `Fin 2` there is a single off-diagonal pair
`(0,1)` so `Q_C = 2·(γ0γ1−γ1γ0)·[∇_0,∇_1]`, and `Q_C = 0 ⇔ [∇_0,∇_1] = 0` provided
`γ0γ1−γ1γ0` is a non-zero-divisor (true for genuine Clifford generators). State the
converse **only for the single-pair `Fin 2` case** to keep it clean.

---

## 5. The single hardest Lean step (isolated) + failure flags

**Hardest step: item 3 of `flatness_iff_commute` — cancelling the shift equiv**, i.e.

> from `M(F) ∘ (T_a ∘ T_b) = 0` conclude `M(F) = 0` (and back).

Everything else is `funext`/`simp`/`ring`/`abel` (the two genuinely mathematical
lemmas §2, §3 are already fully proved). The commutator identity itself, despite
looking hardest, is a mechanical `simp only [...] ; rw [add_right_comm-style] ; abel`.
The equiv-cancellation is the only place needing real Mathlib API and a
surjectivity/injectivity argument rather than pointwise unfolding.

**Mathlib API to use for the hard step:**
* `shiftLE a : (Site → W) ≃ₗ[R] (Site → W)` (via `LinearEquiv.funCongrLeft` +
  `Equiv.addRight`), giving `(shiftLM a) = (shiftLE a : _ →ₗ _)` so `T_a ∘ T_b` is
  the coercion of `shiftLE a ≪≫ₗ shiftLE b`.
* `LinearEquiv.comp_toLinearMap_symm_eq` / `LinearMap.comp_assoc` /
  `LinearEquiv.symm_comp` to write `M(F) = (M(F) ∘ e) ∘ e.symm`.
* `LinearMap.zero_comp`, `LinearMap.comp_zero`, `sub_eq_zero` for the algebra.
* For item 4: `gaugeLM`-is-zero-iff-pointwise via `LinearMap.ext_iff`,
  `funext_iff`, `Pi.zero_apply`.

**Failure flags (where the design can bite in Lean):**

1. **`M(F) = 0 ⇒ ∀ x, F x = 0` needs test vectors.** `M(F) = 0` unfolds to
   `∀ ψ, ∀ x, F x (ψ x) = 0`. To get `F x = 0` as a `LinearMap` you must feed `ψ`
   that realizes an arbitrary `w : W` at coordinate `x` (e.g.
   `ψ := Pi.single x w` — needs `DecidableEq Site`, which holds). Then
   `F x w = 0` for all `w`, so `LinearMap.ext`. This works but is the fiddliest
   sub-step; **recommend stating flatness directly as `M(F a b) = 0` or
   `plaquetteCurvature U a b = 0`** to sidestep it in the main `iff`. `DecidableEq
   Site` is available, so `Pi.single` is fine if you do want the pointwise form.

2. **`unitVec` as `![…]` (Matrix.of / `Fin.cons`).** `![(1,0),(0,1)]` elaborates,
   but `simp`/`decide` on `unitVec a` for symbolic `a : Fin 2` will not reduce; case
   on `a` with `Fin.cases`/`Fin.isValue` or `fin_cases a` if you ever need its value.
   The identities in §2–3 never inspect `unitVec`'s value (they only use `add_comm` /
   `add_right_comm`), so this does not bite there — only in any `decide`-style check.

3. **`noncomputable`.** As in §0: fine for the equational bricks; only downstream
   `#eval`/`decide` attempts on `LinearMap`-valued data would force it. Do not try to
   `decide` `flatness_iff_commute`.

4. **`Module.End` `*` vs `LinearMap.comp` orientation.** `A * B = A.comp B` in
   `Module.End R W` (apply `B` first). When phrasing `plaquetteCurvature` with `*`
   instead of `.comp`, keep this orientation or the KEY lemma's sign meaning flips.
   The doc uses `.comp` explicitly to avoid ambiguity.

5. **No `Fintype`/`DecidableEq` obstruction.** `Site = ZMod 2 × ZMod 2` derives both;
   `Fin 2` for directions is `Fintype`. So the brick-2b sums `Σ_a Σ_b` are finite and
   kernel-checkable; nothing here forces classical choice beyond what Mathlib's
   `LinearMap` algebra already uses.

---

### Deliverable checklist

| # | Item | Status |
|---|------|--------|
| 1 | Defs `Site, unitVec, shiftLM, shiftLE, gaugeLM, nabla` | elaborated ✓ |
| 2 | `shift_mul_pointwise` statement + proof (`funext`+`simp`, no `add_comm`) | proved ✓ |
| 3 | `nabla_commutator_path_difference` — **exactly right**, incl. order/sign | proved ✓ |
| 4 | `plaquetteCurvature`, `flatness_iff_commute`, `Q_C=0 ⇔ flat` read-off | stated (proof route) ✓ |
| 5 | Hardest step = equiv-cancellation; Mathlib API + 5 failure flags | ✓ |
