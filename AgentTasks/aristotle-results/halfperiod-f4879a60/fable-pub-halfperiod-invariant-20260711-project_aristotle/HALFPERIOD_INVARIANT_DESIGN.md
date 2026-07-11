# Is the C protection law the Cedzich et al. half-period invariant? — DESIGN + ORACLE memo

**Scope.** C gates 1–2. DESIGN job with exact-computation obligations. All
rational numbers below are exact (`Fraction`) computations on the K6 palindromic
register `W = S·C·S` on `V8 = Fin 4 × Fin 2` (the register of
`context/ModeInvariantHalfWinding.lean`), reproduced independently; the
load-bearing rational identities are additionally stated as `native_decide`
facts in `context/HalfPeriodInvariantStatements.lean`. The two momentum-space
frame windings (§2) are computed on the translation-invariant bulk with the
half-step coin `C^{1/2}` whose entries live in `ℚ(√10)` for the `3-4-5` coin.
The context modules were **not** modified.

**Literature anchors.**
Cedzich–Geib–C.Werner–R.Werner, *Chiral Floquet Systems and Quantum Walks at
Half-Period*, Ann. Henri Poincaré 22 (2021), DOI 10.1007/s00023-020-00982-6
(arXiv 2006.04634). Asbóth, PRB **86**, 195414 (2012); Asbóth–Obuse, PRB **88**,
121406(R) (2013) — the two-frame origin. Cedzich–Geib–Stahl–Velázquez–
C.Werner–R.Werner, Ann. Henri Poincaré **19** (2018), arXiv:1611.04439 (the
real-space symmetry index — the surviving next candidate, §3).

---

## 0. Setup recovered from the context (exact)

* Register `V8 = Fin 4 × Fin 2`, index `(site, chirality)`, cyclic 4-site ring.
* Shift `S = shiftQ`: chirality-0 legs hop `+1`, chirality-1 legs hop `−1`.
* Coin `C = coinQ c s`: per-site `SO(2)` block `[[c,−s],[s,c]]`, `c ≡ 4/5`,
  `s_p ∈ {+3/5,−3/5}` the value-only derived datum `sign(Im z_p)`.
* Walk `W = S·C·S` (`walkQ`), exactly orthogonal over `ℚ`.
* **Chiral grading** `Γ = I₄ ⊗ σ_x` (`gradeX`): the unique candidate making every
  fixture chiral. `S` and `C` are **each individually chiral**, so `W = S·C·S`
  is a genuine symmetric (palindromic) time-frame walk.
* **Reflection** `R = Rrefl`: swap `0 ↔ 2`, fix `1,3` (`R²=1`, `[R,W]=[R,Γ]=0`).
* **Fixtures.** `sWall=[+,+,−,+]` (two-wall, singleton at non-fixed site 2),
  `sZero=[+,+,+,+]`, `sFour=[+,−,+,−]`, plus the full 16-field audit.

---

## 1. Advisor point 1 — the load-bearing hypothesis `Γ W Γ = W⁻¹` (exact)

Verified exactly and **field-independently**: with `Γ = I ⊗ σ_x`,
`Γ² = 1` and `Γ · W(b) · Γ = W(b)ᵀ = W(b)⁻¹` for **all 16** fields (`W` is
orthogonal, so `Wᵀ = W⁻¹`). The per-site `σ_z` grading fails on the two-wall
walk, so `σ_x` is forced. (Lean: `gradeX_sq`, `gradeX_chiral`,
`allFields_unitary`, and the direct `chiral_inverse : Γ W Γ W = 1`.) The one
hypothesis everything hangs on holds.

---

## 2. Advisor point 2 — the pre-registered second-frame winding check

`W = S·C·S` is the product `B·A` with `A = C^{1/2}S`, `B = S·C^{1/2}`; the two
Asbóth/Cedzich symmetric time frames are the conjugate palindromes

* **Frame 2** (given, S-centered): `W₂ = B·A = S·C·S`;
* **Frame 1** (C-centered): `W₁ = A·B = C^{1/2}·S²·C^{1/2}`.

Both are chiral (`Γ Wᵢ Γ = Wᵢ⁻¹`) and palindromic, so each carries a genuine
half-period winding. Computing the bulk winding of the chiral off-diagonal
vector `(n_y(k), n_z(k))` (with `n_x(k)≡0` verified, gap `min|d|=3/5>0`, no
criticality) over `k ∈ [0,2π)`:

| bulk sign `s` | ν(Frame 2 = SCS) | ν(Frame 1 = C^{1/2}S²C^{1/2}) | (ν₀, ν_π) = ((ν₁+ν₂)/2,(ν₁−ν₂)/2) |
|---|---|---|---|
| `s = +3/5` | **0** | **−2** | (−1, −1) |
| `s = −3/5` | **0** | **+2** | (+1, +1) |

So the timeframe pair is genuinely **non-trivial in the second frame**: the given
frame `SCS` is winding-trivial (0) while the C-centered frame winds `∓2`. A
**single, well-separated `+/−` domain wall** carries the relative index
`Δ(ν₀,ν_π) = (+1,+1) − (−1,−1) = (2,2)`, predicting `2` protected modes at
quasienergy `0` and `2` at `π` per isolated wall. This correctly reproduces the
**domain-block** fixtures: `++−−, +−−+, −−++, −++−` have two well-separated walls
and exactly `4` modes at each of `±1` (finite audit: `ker± = 4`).

### Where the proposal breaks — the counterexample pair

The `8-vs-4` split is between two-wall fields of **equal total winding** that
differ only in **defect position** relative to the reflection-fixed sites. Take
the pre-registered counterexample pair

* `b₁ = ++−+` (singleton flip at the **non-fixed** site 2) — compression
  self-adjoint, engine **fires**;
* `b₂ = +++−` (singleton flip at the **fixed** site 3) — compression **not**
  self-adjoint, engine **blind**.

Both are point defects in a uniform `+` bulk (the `−` region is a **single**
site). Consequences, computed exactly:

* **Frame-2 windings are EQUAL** for the pair (both `0`: uniform `+` bulk).
* **Frame-1 windings are EQUAL** for the pair: the bulk value is `−2` for both;
  the two walls flanking a singleton carry canceling relative indices
  `+ (2,2)` and `− (2,2)`, so the **net index around the ring is `(0,0)` for
  every two-wall field**, `b₁` and `b₂` alike.
* A winding is a homotopy/translation invariant: it **cannot read the position**
  of the defect, so it assigns site-2 and site-3 singletons **identical** data.
* It also **over-counts** narrow singletons: the per-wall prediction `(2,2)` per
  adjacent wall would give `4+4`, but the one-site `−` region hybridizes the two
  walls down to the observed `2+2`.

### DECISION on the timeframe pair — advisor's KILL CONDITION met (verbatim)

> "if the frame-2 windings are EQUAL for the counterexample pair, the
> timeframe-pair proposal is dead for this family."

The frame-2 windings **are** equal for the counterexample pair (both `0`); so are
the frame-1 windings (net `(0,0)`); and neither frame can distinguish fixed- from
non-fixed-site singletons. **The timeframe-pair proposal is dead for this
family.** It is not that half-period windings are trivial — the *bulk* pair is
`(ν₀,ν_π)=(∓1,∓1)` and correctly predicts the block-fixture modes — but they are
**blind to defect position** and thus cannot reproduce the `8-vs-4`
`fixedSingleton` split, exactly the phenomenon that distinguishes the pair.

---

## 3. Advisor point 3 — next candidate (kill triggered): the real-space symmetry index

Per the adopted kill condition, the next candidate is the full
**Cedzich–Geib–Stahl–Velázquez–C.Werner–R.Werner real-space symmetry index**
(arXiv:1611.04439, AHP **19** (2018), and the complete-homotopy-invariants
companion, *Quantum* **2** (2018)): the Fredholm-type left/right indices
`si_L, si_R`, defined for **non-translation-invariant** walks, with the
gentle-perturbation stability theorem. These are the right home for a
position-sensitive, defect-local invariant, because they are computed on a
half-line rather than in momentum space and can therefore see *where* the wall
sits. Two honest caveats for this family:

* On a **finite closed ring** the Fredholm indices reduce to the finite
  signed counts, which for our fixtures are the `Γ`-signatures of `ker(W∓1)` —
  computed exactly to be `(0,0)` for **every** field (balanced `+1,−1` modes).
  So the *signed* real-space index, as a closed-system number, is still `0`
  and does not by itself separate the fixtures.
* The mirror-graded winding is not merely blind on the blind fields — it is
  **ill-defined** there: the reflection commutes with `W(b)` **iff** the two
  reflection-fixed sites carry equal signs (`b 1 = b 3`, exact, Lean:
  `reflR_comm_walk_iff`), and **every fixed singleton breaks this symmetry**
  (`fixedSingleton_not_reflSym`). So the `R`-sectoring the mirror-graded
  candidate needs does not even exist on the 4 fields it would have to separate.
* The genuinely separating datum in the live compression remains the
  **self-adjointness of the reflection-fixed-leg compression** (§4), which is
  the finite avatar of "does the wall engage the reflection-frame's
  inversion-fixed site". The real-space symmetry index is the correct
  *infinite-system* classifier to which this finite discriminator should be
  matched in a follow-up; establishing that match (with the gentle-perturbation
  stability) is the sharpened open gate.

---

## 4. The exact discriminator, and its relation to `fixedSingleton` (advisor point 4)

**Value-only discipline.** The separating invariant reads from the field **only**
the sign pattern `b = (sign s_0,…,sign s_3) ∈ {+,−}⁴`; it forms the `4×4` real
matrix `M(b) = Bfixᵀ · W(b) · Bfix` on the reflection-fixed legs
`V_fix = span{e_{(1,·)}, e_{(3,·)}}` and tests the **discrete** predicate
`M(b) = M(b)ᵀ`. The fixed sector is `W`-invariant for **every** field, `Bfix` is
always an isometry, `W` always unitary, `tr M(b) = 0` always — so the **only**
hypothesis of the `InvolutiveCompression` engine that ever varies is
self-adjointness.

**Exact relation to `fixedSingleton`** (16-field audit):

> `M(b)` is self-adjoint  ⟺  `b` has two walls **and** is **not** a singleton
> seated on a reflection-**fixed** site (`1` or `3`).

The `4` blind two-wall fields are exactly the **fixed singletons**
`{+++−, +−++, −+−−, −−−+}`; the `8` protected fields are the `4` non-fixed
singletons `{++−+, −−+−, +−−−, −+++}` plus the `4` domain blocks
`{++−−, +−−+, −−++, −++−}`. This is the paper's positional criterion:
`fixedSingleton(b) = true  ⟺  fixed-leg compression fails self-adjointness
⟺  engine blind`. The advisor's mechanism — *"a wall on a frame's inversion-fixed
site engages that frame's index"* — is realized here as: a singleton on a
reflection-fixed site kills the fixed-leg involution. The difference between the
two frames' windings (`ν₁−ν₂ = ∓2`, i.e. `ν_π = ∓1`) is exactly the sector in
which the fixed-leg modes live (`R=+1`), but the winding cannot localize the
defect onto sites `{1,3}` versus `{0,2}`, which is why it under-determines the
split.

---

## 5. Honest fallback / summary table

| invariant | two-wall fixed-singleton | two-wall non-fixed / block | 0-/4-wall | separates 8-vs-4? |
|---|---|---|---|---|
| `det W` | +1 | +1 | +1 | no (constant) |
| `tr(ΓW)`, `tr(ΓWR)`, `tr Γ`, `tr(ΓR)` | 0 | 0 | 0 | no (constant) |
| full-period winding = Frame-2 ν | 0 | 0 | 0 | no |
| **timeframe pair** `(ν₀,ν_π)` bulk | (∓1,∓1) | (∓1,∓1) | (∓1,∓1) | **no** (position-blind; equal on counterexample pair — KILL) |
| net ring index `Δ(ν₀,ν_π)` | (0,0) | (0,0) | (0,0) | no |
| finite signed `Γ`-index on `ker(W∓1)` | (0,0) | (0,0) | (0,0) | no |
| **mode count** `dim ker(W∓1)` | 2,2 | 2,2 (sing.) / 4,4 (block) | 0,0 | partial (walls vs none; not 8-vs-4) |
| **fixed-leg self-adjointness = ¬fixedSingleton** | **fails** | **holds** | fails | **YES** |

**Conclusion.** Neither the single winding, the half-period **timeframe pair**,
nor the mirror-graded winding separates the fixtures on the `8-vs-4` positional
axis; the timeframe pair is dead by the advisor's own pre-registered kill
condition (equal frame windings on the counterexample pair, position-blindness).
The exact discriminator that reproduces the split and the `2+2` (block: `4+4`)
mode structure is the **self-adjointness of the reflection-fixed-leg
compression**, equal to `¬fixedSingleton` — a discrete, `W`-dependent,
kernel-checkable, value-only datum, already the mechanism landed in
`ModeInvariantHalfWinding`. This sharpens the paper's open gate to:

> The C protecting invariant is **finer than the half-period timeframe pair and
> the mirror-graded winding**. The surviving classifier is the CGGSVWZ real-space
> symmetry index (a half-line, position-sensitive, Fredholm invariant); the open
> gate is to prove the finite fixed-leg self-adjointness / `¬fixedSingleton`
> discriminator equals that real-space index and inherits its
> gentle-perturbation stability.

---

## 6. Scope guard (advisor point 5, kept verbatim in spirit)

Everything above is a `1+1D`, `Γ`-respecting, unitary-walk statement. It proves
**nothing** about `3+1D`, and nothing about perturbations that **break** the
chiral grading `Γ`. The stability claim to be established (via the real-space
symmetry index) is only for finite-range, `Γ`-respecting unitary perturbations
that keep both spectral gaps open away from the wall.

---

## 7. Lean closure plan (companion `context/HalfPeriodInvariantStatements.lean`)

Self-contained (`import Mathlib` + the landed engine), all rational facts by
exact `native_decide`:

1. **Chiral / symmetric-frame structure** — `gradeX_sq` (`Γ²=1`),
   `gradeX_chiral` (`ΓWΓ=Wᵀ` ∀field), `chiral_inverse` (`ΓWΓW=1`, i.e. `ΓWΓ=W⁻¹`),
   `shift_chiral`, `coin_chiral` (S, C individually chiral).
2. **Blindness of trace / full-period-winding invariants** —
   `allFields_trGW_zero`, `allFields_trGWR_zero`, `trace_gradeX_zero`,
   `trace_gradeX_reflR_zero` (all constant across the family; determinant
   blindness inherited from the landed context modules).
2'. **Mirror-graded winding ill-defined on the blind fields** —
   `reflR_comm_walk_iff` (`[R,W]=0 ↔ b 1 = b 3`) and
   `fixedSingleton_not_reflSym` (every fixed singleton breaks reflection
   symmetry).
3. **The `8-vs-4` separation** — `selfadj_iff_protected`:
   `M(b)=M(b)ᵀ ↔ protectedField b`, with
   `protectedField b := wallCount b = 2 ∧ ¬ fixedSingleton b`.
4. **Structural family facts** — `fixedSector_isometry`, `fixedSector_intertwine`
   (fixed sector always `W`-invariant), `allFields_unitary`, `Mfix_trace_zero`.
5. **Invariant ⇒ self-adjointness ⇒ pinned modes** (engine bridge) —
   `protected_modes : ∀ b, protectedField b → (∃ −1 mode) ∧ (∃ +1 mode)` of
   `W(b)` over `ℂ`, via the landed `InvolutiveCompression` engine.
6. **Fixture evaluations** — `sWall_protected`, `sZero_not_protected`,
   `sFour_not_protected`, `fixedSingleton_blind`, `fixedSingleton_blind'`.

The momentum-space frame windings of §2 (integers `0, ∓2` over `ℚ(√10)` data)
are the pre-registered check output and the decision driver; they are reported
here rather than formalized, since an integer winding of a continuous `k`-loop is
outside the `native_decide` rational-matrix discipline of this design job.
