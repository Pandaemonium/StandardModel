# Composition-Landings Audit — 2026-07-10

Scope: the four newest cross-layer "composition landing" modules under
`AgentTasks/aristotle-standalone/composition-landings-audit-20260710/Audit/Inputs`:

| # | Module | Headline theorem |
|---|--------|------------------|
| A | `CheckerboardAmplitudeGluing.lean` | `pathAmplitude_append` (amplitude gluing) |
| B | `CanonicalGramTurnDictionary.lean` | `free_mass_operator_eq_complexified_turn` (Gram→turn dictionary) |
| C | `FixedMomentumManyStepContinuum.lean` | `fixed_time_many_step_bound` / `_tendsto` (many-step continuum) |
| D | `NullFactorizationSpinFiber.lean` | `factorization_fiber_unitary` / `_special_unitary` (spin fiber) |

Audit lens applied to each: **vacuity, false shape, hollow conjunction,
docstring overreach, hidden scale choices, zero-dimensional cases, inadequate
controls.**

Verification performed for this audit:
* `grep` confirms **no `sorry`, `admit`, or `axiom`** in any of the four files.
* Modules **C** and **D** are self-contained (`import Mathlib`). I copied them
  into the build target and compiled them under the repository's pinned
  `leanprover/lean4:v4.28.0` + Mathlib `v4.28.0`. Both **build clean of errors,
  sorry-free**, and their `#guard_msgs`/`#print axioms` guards pass, confirming
  the axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`.
* Modules **A** and **B** depend on `PhysicsSM.Draft.NullEdge.*` primitives that
  are **not present in this repository**, so they could not be elaborated here;
  they were audited at source level only. Their claimed axiom footprint is the
  same standard triple.

---

## 1. Findings (highest severity first)

### F1 — [C] Nine leftover `exact?` search calls in the flagship continuum proof (MEDIUM: fragility)
`FixedMomentumManyStepContinuum.lean` closes goals with a raw `exact?` at lines
151, 203, 212, 254, 280, 287, 328, 330, 462. `exact?` is a *library-search*
tactic: it recompiles a proof term found by Mathlib's discrimination-tree search
at elaboration time. The file compiles today (each `exact?` resolves and only
emits an `info: Try this …`), but this is not a stable proof — a future Mathlib
lemma rename/reprioritization can silently change or break what is found. The
"flagship fixed-time estimate" therefore rests, in nine places, on search rather
than on named lemmas. **Not a soundness bug** (the current build is genuine and
sorry-free) but a maintainability/reproducibility defect for the module the
provenance calls the flagship. Recommend replacing each with the concrete term
the search reports.

### F2 — [B] The "missing-dictionary control" is a hollow conjunction; it refutes only its false conjunct (MEDIUM: inadequate control)
`fixed_pair_cannot_encode_two_turn_scales` states
`¬ (P₁ ∧ P₂)` where
* `P₁` = "the fixed `m=1` pair's free-mass operator equals `complexify (Q_T 1)`" — this is *true* (it is exactly `free_mass_operator_eq_complexified_turn` at `m=1`);
* `P₂` = "the same operator equals `complexify (Q_T 2)`" — this is *false*.

The proof does `rintro ⟨_, htwo⟩` and derives a contradiction from `htwo` alone,
i.e. it proves `¬ P₂`. Because `P₁` is a theorem, `¬ (P₁ ∧ P₂)` is logically
identical to `¬ P₂`, so the first conjunct is decorative. The genuine content is
merely `complexify (Q_T 1) ≠ complexify (Q_T 2)` at entry `(0,0)` — i.e.
`Q_T 1 ≠ Q_T 2`. The control does **not** demonstrate the intended tension (that
*one fixed pair* cannot be read at two different scales); it only observes that
two different target matrices differ. A stronger control would fix the *pair*
`edge0, edge1 m₀` and show the bridge forces the turn scale to equal `m₀`
(rules out any `m₁ ≠ m₀`), rather than picking `m=1` on the left and comparing to
`Q_T 2` on the right. As written it is adequate to *disprove* the naïve
"same pair encodes two scales by renaming," but it is weaker than its prose.

### F3 — [D] `hdet0` is a redundant hypothesis (LOW: non-minimal statement)
`factorization_fiber_special_unitary` assumes `hleft : L0 * M0 = 1`,
`hright : M0 * L0 = 1`, **and** `hdet0 : M0.det ≠ 0`. The first two make `M0`
two-sided invertible, which already forces `M0.det ≠ 0` (`det L0 * det M0 = 1`).
So `hdet0` is derivable from existing hypotheses and should be dropped for a
minimal, cleaner statement. Not a soundness or vacuity problem — the theorem is
true — but the redundant hypothesis is exactly the kind of clutter this audit
flags. (Confirmed the statement compiles; minimization not applied to the input.)

### F4 — [A] The gluing "witness" re-exports the general theorem and tests only nonzeroness, not the turn count (LOW: partial control / mild docstring overreach)
`two_segment_turn_gluing_witness` is a three-way conjunction whose **first
conjunct is literally `pathAmplitude_append 1 1 right [right, left] [right]`** —
an instance of the already-proved general law, contributing no new information.
The load-bearing content is only the two `≠ 0` clauses, which exclude the
degenerate `m = 0` reading and the straight-only history. The docstring/module
prose claims the boundary "counts a turn at the gluing boundary exactly once,"
but neither the witness nor the append law *checks a turn count*: correctness of
"exactly once" is delegated entirely to the supplied primitive `terminalDirection`
threaded through `pathWeight`/`turnCount` in `ExactCheckerboardPathSum`. So the
"exactly once" claim is an assertion about the *supplied* API, not something the
landed theorem verifies. The general theorem itself (`pathWeight_append`,
`pathAmplitude_append`) is clean and correct.

### F5 — [B] The bridge is a *supplied* scale dictionary, not a derived arrow (INFORMATIONAL, honestly disclosed)
`free_mass_operator_eq_complexified_turn` holds because the input data is fixed
to the canonical pair `edge0 = (1,0)`, `edge1 m = (0,m)`. The equality of the
Pluecker mass and the checkerboard turn channel is *manufactured* by choosing
these spinors so the wedge has squared modulus `m²` and then invoking the
supplied facts `free_mass_operator_eq_plucker` and `turn_is_mass_squared`. This
is a **hidden-scale construction by design**: the same symbol `m` is inserted on
both sides. The module docstring states this plainly ("the smallest explicit
dictionary … derivation of that dictionary from primitive histories remains
open"), so this is *not* overreach — but it must be recorded in the dependency
graph as a **supplied dictionary**, distinct from a derived arrow. The
`rational_dictionary_witness` (nonzero at `m = 3/5`, coefficient `9/25`)
correctly rules out the zero-dimensional `m = 0` collapse.

### F6 — [C] Scale coupling `angles = (k·eps, m·eps)` is a modeling choice, adequately disclosed (INFORMATIONAL)
The walk compared to the flow is `walk (k·eps) (m·eps)` versus
`exp(-eps · i·H)` with `H = k σz + m σx`. Tying the shift/coin angles linearly
to `eps` with fixed `(k,m)` is the fixed-momentum lattice scaling; it is a hidden
scale choice in the sense of the audit, but the docstring restricts scope to
"a fixed-momentum matrix theorem … not a spacetime propagator, uniform-in-momentum
estimate, PDE convergence theorem, or 3+1 result," so the claim matches the
statement. No overreach.

### Non-findings (checked, clean)

* **Vacuity.** No theorem is vacuously true. C is guarded by `hn : 0 < n`
  (rules out the zero-dimensional `n = 0`), and `_tendsto` uses `n+1` to stay
  positive; the hypothesis `hsmall : |t/n| ≤ 1` is satisfiable and satisfied on
  the tail used by the limit. D's fiber theorems have satisfiable hypotheses
  witnessed concretely by `witnessBase`/`witnessRotation`. B's bridge is an
  unconditional identity in `m`. A's laws hold for all lists including `nil`.
* **False shape.** Each headline theorem's *conclusion* matches its prose:
  C uses Mathlib's genuine L2 operator norm (`Matrix.Norms.L2Operator`, verified
  by compilation), proves both steps unitary (`walk_mem_unitary`,
  `exactFlow_mem_unitary`), uses a *linear* (no exponential-in-`n`) telescope
  (`unitary_pow_telescope`: bound `n · ‖U−V‖`), and identifies `flow(t/n)^n =
  flow(t)` (`exactFlow_div_pow`) — all four properties the target demanded.
  D's `SameMomentumGram` is the correct `M Mᴴ = M0 M0ᴴ`, and `∃!` genuinely
  delivers uniqueness. B's `complexAbsSq (wedge) = m²` is the correct Pluecker
  invariant.
* **Zero-dimensional / degenerate cases.** All controls carry an explicit
  non-degeneracy clause: A excludes `m=0` and straight-only; B excludes `m=0`
  (`9/25 ≠ 0`); D excludes the trivial factor `U = 1` (`witnessFactor ≠
  witnessBase`). C is dimension-2 throughout and guards `n>0`.
* **Docstring overreach (headline theorems).** C and D docstrings carry explicit
  "honest scope" disclaimers (no spin reps / Wigner rotations / spin-statistics;
  no PDE / 3+1). B discloses the open derivation. A discloses "not a continuum
  propagator composition law." The only overreach flagged is the localized F4
  "exactly once" phrasing.

---

## 2. Primitive → observable dependency graph (exact)

Legend: `═▶` **supplied dictionary / trusted primitive** (asserted upstream, not
re-derived here); `──▶` **derived arrow** (proved inside the audited module).

### A. Checkerboard amplitude gluing
```
[supplied: ExactCheckerboardPathSum]
  Direction, terminalDirection, terminalDirection_cons        ═▶┐
  pathWeight, pathWeight_cons                                  ═▶┤
  pathAmplitude, pathAmplitude_eq_corner_power                 ═▶┤
  cornerWeight, turnCount, GaussianRat(.I,.ofRat,.im)          ═▶┤
                                                                 │
      pathWeight_append   ──────────(induction on h1)──────────▶│  (derived)
      pathAmplitude_append ─(rw via pathAmplitude_eq_corner_power)▶ OBSERVABLE: amplitude gluing law
      two_segment_turn_gluing_witness ─(instance + im≠0)───────▶  control (see F4)
```

### B. Canonical Gram → turn dictionary
```
[supplied: FreeMassBridge]                    [supplied: CheckerboardCarrierBridge]
  CSpinor, spinorWedge, complexAbsSq  ═▶         DiracWalkCarrier.Q_T, .turn        ═▶
  twoEdgeMomentum, rankOneHermitian   ═▶         turn_is_mass_squared               ═▶
  free_mass_operator_eq_plucker       ═▶
        │                                              │
        │   ══ SUPPLIED SCALE DICTIONARY ══            │
        │   edge0=(1,0), edge1 m=(0,m)   (F5)          │
        ▼                                              ▼
  canonical_plucker_mass ──(simp+ring)──▶ ‖wedge‖² = m²
        └───────────────┐                ┌─────────────┘
                        ▼                ▼
   free_mass_operator_eq_complexified_turn ──▶ OBSERVABLE: free-mass operator = complexified Q_T m
   rational_dictionary_witness ──▶ nondegeneracy at m=3/5
   fixed_pair_cannot_encode_two_turn_scales ──▶ control (weak; see F2)
```

### C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  NormedSpace.exp, Matrix.unitaryGroup, L2 operator norm  ═▶
   │
   ├─ abs_one_sub_cos_le, abs_sub_sin_le ─┐
   ├─ norm_H_le, l2_opNorm_le_two_entryMax ┤
   ├─ walk_sub_firstOrder_entry{00,01,10,11}_bound ─▶ walk_sub_firstOrder_entry_bound ─▶ walk_sub_firstOrder_bound
   ├─ norm_exp_sub_one_sub_le ─▶ firstOrder_sub_exactFlow_bound
   │        └──────────────┬───────────────┘
   │                       ▼
   │            one_step_to_exact_flow_bound  (‖walk−flow‖ ≤ Dkm·eps²)
   ├─ walk_mem_unitary, exactFlow_mem_unitary ─▶ unitary_pow_telescope (linear, no eⁿ loss)
   ├─ exactFlow_div_pow (flow(t/n)^n = flow(t))
   │                       ▼
   └──────────▶ fixed_time_many_step_bound ──▶ fixed_time_many_step_tendsto
                          OBSERVABLE: n-step walk → exact Dirac flow, rate Dkm·t²/n
```

### D. Null factorization spin fiber (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  unitaryGroup, specialUnitaryGroup, det_fin_two, conjTranspose ═▶
   │
   ├─ unitary_right_action_preserves ─┐
   │                                   ▼
   ├─ factorization_fiber_unitary (∃! U∈U(2), M=M0·U)
   │                                   ▼
   └─ factorization_fiber_special_unitary (∃! U∈SU(2)) ──▶ OBSERVABLE: U(2)/SU(2) factor fiber
   witnessBase/Inverse/Rotation/Factor ─▶ witness_* ─▶ nontrivial_special_unitary_fiber_witness (control)
```

### Cross-layer status
The four observables are **currently disjoint**: no arrow connects A↔B↔C↔D. The
only shared symbol is the mass/turn scalar `m`, which appears independently in
A's amplitude `(i·eps·m)^turnCount`, B's dictionary `Q_T m`, and C's walk
`H = k σz + m σx` — but no theorem identifies these three `m`'s. That gap is the
subject of §3.

---

## 3. Single highest-value next composition theorem

**Bridge the finite checkerboard path-sum (A) to the fixed-momentum transfer
matrix (C): prove the summed, glued checkerboard amplitudes over `n` steps equal
the matrix element of `walk^n`, hence — via `fixed_time_many_step_tendsto` —
converge to the exact Dirac propagator.**

Concretely, the missing **derived arrow** is a *path-sum = matrix-power* identity:

```
theorem pathSum_eq_walk_pow (eps m : ℝ) (n : ℕ) (i j : direction/index) :
    (∑ h : histories of length n from j to i, pathAmplitude eps m j h)
      = (walk (k*eps) (m*eps) ^ n) i j        -- after A↔C parameter matching
```

Composing this with the already-landed pieces yields the flagship cross-layer
theorem

```
  (checkerboard n-step path-sum, step eps = t/n)  ──▶  (walk^n) i j  ──▶  (exactFlow k m t) i j
                     A (gluing gives multiplicativity)   pathSum_eq_walk_pow   C (fixed_time_many_step_tendsto)
```

i.e. **the Feynman-checkerboard amplitude converges to the fixed-momentum Dirac
propagator matrix element.**

Why this is highest value:
* It is the *only* proposal that turns three of the four disjoint observables
  into one dependency chain (A → new arrow → C), converting today's parallel
  landings into an actual composition.
* Both endpoints already exist and are verified (A's `pathAmplitude_append`
  gluing law supplies the multiplicativity needed to fold the path-sum; C's
  `fixed_time_many_step_tendsto` supplies the limit). Only the middle arrow is
  missing, and it is a *finite, exact* combinatorial identity — the kind these
  modules already discharge.
* It directly attacks the audit's central weakness (F5, and the "Cross-layer
  status" gap): it would be the first **derived** cross-layer arrow rather than
  another **supplied** dictionary. B's Gram→turn dictionary would then attach as
  a corollary (identifying C's mass `m` with B's turn/Pluecker mass), and D's
  spin fiber gives the residual little-group ambiguity of the endpoint spinors —
  so all four modules plug into one graph.

Prerequisite to make it a theorem rather than a definition: fix the A↔C
parameter dictionary explicitly (relate `Direction` histories and
`GaussianRat` amplitudes to the `2×2` complex `walk`; reconcile `(i·eps·m)` vs
`H = k σz + m σx`). That dictionary should be **displayed and labeled supplied**,
exactly as B does, so the composition remains honest about which arrow is derived
and which is assumed.
