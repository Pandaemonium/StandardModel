# Hostile semantic audit — `ModeInvariantHalfWinding.lean`

Job: `codex-pub-halfwinding-semantic-audit-20260710`.
Target: `PhysicsSM/Draft/NullEdge/ModeInvariantHalfWinding.lean` (self-contained
over Mathlib, `import Mathlib` only). Source not edited. The module was compiled
with `lake env lean` (exit 0) and every load-bearing declaration's axiom set was
read with `#print axioms`. Missing sibling-module imports are irrelevant, as the
task note states.

Claims audited (from the file header "THE RESULT" block and `C_DEFECT_DESIGN.md`
pillar 6): **"Z2 half-winding"**, **"exact protected ±1 modes iff the wall count
is 2 mod 4"**, **"localized"**, **"topologically protected"**, with
**"zero-wall and four-wall in-class NO-mode controls"**.

---

## Headline verdict

**What is actually proved (kernel-clean):** an abstract, fully general engine —
*a self-adjoint compression of a unitary matrix is an involution, hence has
`±1` spectrum, and both a `−1` and a `+1` eigenvector lift back to genuine
eigenvectors of the unitary* — plus a clean algebraic-multiplicity count
(`#(+1)+#(−1)=k`, `#(+1)−#(−1)=tr M`) valid with repeated roots and at `k=0`,
with **no diagonalizability assumption**.

**What is proved only under `native_decide` draft-trust:** the *single*
two-wall K6 fixture `Wwall = walkQ cW sWall` has an exact `−1` eigenvector and an
exact `+1` eigenvector (`twoWall_protected_modes`).

**What is NOT proved anywhere in the file:** there is no winding invariant, no
`ℤ/2`, no parity/`mod` object, no quantifier over wall count, no `iff`, no
localization statement, no perturbation/stability statement, and the "controls"
are not connected to the control walks at all.

The strings **"half-winding", "Z2", "2 mod 4", "localized", "topologically
protected"** occur **only in comments / the docstring / the module name**. No
Lean declaration realizes any of them.

Strongest safe headline (see full sentence in §"Replacement language"):
> *A self-adjoint fixed-leg compression of an exactly unitary rational walk is
> an involution and therefore forces one exact `+1` and one exact `−1`
> eigenvector; this hypothesis holds for the displayed two-wall 3-4-5 K6 walk
> (via `native_decide`) and fails for the displayed control block — machine-checked.*

---

## Severity-ranked findings

### S1 (critical) — "Z2 half-winding" is not defined in Lean; it is an interpretation of ≤3 fixtures
No declaration defines a winding number, a `ℤ/2`/`ZMod 2` value, a parity, or
any `mod` operation. `grep` for `ZMod|winding|Winding|mod|parity` returns hits
only in prose. The module does **not** import or reference the local Plücker
winding module (`PlueckerWindingDerived`); it is self-contained and never
connects a compression fact to any winding datum. "Half-winding" is presently a
verbal label attached to three explicit sine-field fixtures — not a Lean
invariant, and not shown invariant.

### S2 (critical) — No `iff`, no quantification over wall count; only explicit 0/2/4-wall fixtures
There is no `∀`, no wall-count variable, and no `iff` anywhere. The evidence for
"modes iff wall count = 2 mod 4" is exactly three hard-coded sine fields —
`sZero` (0 walls), `sWall` (2 walls), `sFour` (4 walls) — one of which
(`sWall`) yields modes and two of which do not. Three data points are consistent
with the rule "2 mod 4" but equally consistent with unboundedly many other
rules; the classification is asserted, not proved.

### S3 (critical) — The "controls" are never connected to the control walks
`Wzero` and `Wfour` are defined (lines 298, 300) but are **dead code**: no
theorem has either as its subject. The control lemmas
`Afix0_no_neg_mode`/`Afix0_no_pos_mode`/`Afix4_no_neg_mode`/`Afix4_no_pos_mode`
speak only about the *standalone displayed 4×4 matrices* `Afix0`, `Afix4`. There
is **no** analogue of `Wwall_Bfix` (no `Wzero * Bfix = Bfix * Afix0`, no
`Wfour * Bfix = Bfix * Afix4`), so nothing ties `Afix0`/`Afix4` to
`Wzero`/`Wfour`. Consequently the controls do **not** prove absence of modes for
the full control walks — not even absence on the fixed legs of the actual
control walks. They prove only invertibility of two displayed matrices at `±1`.

### S4 (high) — The two "controls" are the *same matrix*
`Afix0` and `Afix4` are byte-identical literals
(`!![0,-3/5,4/5,0; 3/5,0,0,4/5; 4/5,0,0,-3/5; 0,4/5,3/5,0]`); the `Afix4`
docstring admits "Numerically it coincides with `Afix0`." So the advertised
"zero-wall **and** four-wall in-class controls" are one control presented twice.
The claim that this "separates the true invariant from even-walls/reflection
symmetry alone" is not supported by an independent four-wall computation.

### S5 (high) — "Localized" is proved nowhere
`twoWall_protected_modes` asserts only *existence* of nonzero eigenvectors
`B.mulVec v`. There is no statement about support, decay, or concentration near
the defect. In fact the eigenvectors live in `V_fix = span{e_(1,·), e_(3,·)}`
(the reflection-fixed sites 1 and 3), whereas the docstring names the wall site
as 2 — so what is constructed is not even claimed to sit at the wall.

### S6 (high) — "Topologically protected" is proved nowhere
There is no perturbation, no perturbation class, and no stability theorem. The
"protected"/"protection" language and the header's "survives every perturbation
preserving unitarity+chirality+defect parity" wager have no Lean counterpart.
Existence of an eigenvector is not protection.

### S7 (medium) — The main theorem is not kernel-only; it carries `native_decide` draft-trust
`twoWall_protected_modes` depends on `Lean.ofReduceBool` and
`Lean.trustCompiler` (inherited from the K6 literals via
`involutiveCompression_wall`, `Wwall_Bfix`, `Afix_selfadj`,
`Wwall_orthogonal`). The header's phrasing "engine + counting kernel-only; K6
literals native_decide draft-trust" is accurate at the lemma level, but the
composed *result* itself is native-decide-trusted, not kernel-only. Any prose
that calls the mode-existence result "kernel-checked" without qualification is
overstated.

### S8 (medium) — The "2 and 2" count is stated but never assembled for the walk
The counting lemmas (`involution_full_pinning`, `involution_trace_split`) and
`Afix_trace = 0` are all proved, but they are **not** combined into a theorem
that the two-wall walk has `dim ker(W−1) = dim ker(W+1) = 2`.
`twoWall_protected_modes` yields only *one* `+1` and *one* `−1` eigenvector
(existence), not the multiplicity-2 split claimed in the docstring.

### S9 (low, positive) — The abstract engine and counting are sound and appropriately general
`compression_unitary`, `compression_involution`, `involution_neg_mode`,
`involution_pos_mode`, `lift_neg_mode`, `lift_pos_mode`,
`involutive_compression_flip_mode`, `involutive_compression_fixed_mode`,
`involution_root_pm`, `involution_roots_eq`, `involution_full_pinning`,
`involution_trace_split` are all kernel-only (standard three axioms). The
counting is by charpoly-root multiplicity, so it is valid for **repeated roots**
and handles `k = 0` explicitly (`Nat.eq_zero_or_pos`) — **no hidden
diagonalizability assumption**. The `toC` transport lemmas (`toC_mul`,
`toC_one`, `toC_conjTranspose`, `toC_injective`, `toC_neg`) are kernel-only and
the rational→complex transport in `involutiveCompression_wall` is correct.

### S10 (low) — For the two-wall walk the compression IS genuine and self-adjoint
Unlike the controls (S3), the two-wall case is honest: `Wwall_Bfix` proves
invariance `Wwall * Bfix = Bfix * Afix`, `Afix_selfadj` proves `Afix = Afixᵀ`,
`Wwall_orthogonal` proves unitarity, and these transport to
`InvolutiveCompression (toC Wwall) (toC Bfix) (toC Afix)`. So the positive
existence result is legitimate (modulo S7 trust). This is the salvageable core.

---

## Theorem table

| Declaration | Statement (informal) | What it earns | Not what it earns |
| --- | --- | --- | --- |
| `compression_unitary` | compression of unitary onto invariant subspace is unitary | engine lemma | — |
| `compression_involution` | self-adjoint compression of unitary ⇒ `M²=1` | engine core | — |
| `involution_neg_mode` / `_pos_mode` | involution `≠±1` has `∓`/`±1` eigenvector | sector modes | not localization |
| `lift_neg_mode` / `lift_pos_mode` | sector mode lifts to `W`-eigenvector | genuine walk modes | not localization |
| `involutive_compression_flip_mode` / `_fixed_mode` | self-adjoint compression forces `−1`/`+1` mode of `W` | **abstract existence engine** | not count, not stability |
| `involution_root_pm` | every charpoly root of involution is `±1` | pinning | — |
| `involution_full_pinning` | `#(+1)+#(−1)=k` | count (unused downstream) | — |
| `involution_trace_split` | `#(+1)−#(−1)=tr M` | count (unused downstream) | — |
| `Bfix_iso`, `Wwall_Bfix`, `Afix_selfadj`, `Afix_involution`, `Afix_trace`, `Wwall_orthogonal` | K6 two-wall literal facts | instantiate the engine | native_decide-trusted |
| `Afix_ne_one`, `Afix_ne_neg_one` | fixture ≠ `±1` | both modes fire | — |
| `Afix0_not_selfadj`, `Afix0_no_neg_mode`, `Afix0_no_pos_mode` | displayed `Afix0` not self-adjoint, invertible at `±1` | block has no `±1` eigenvalue | **not** about `Wzero` (S3) |
| `Afix4_not_involution`, `Afix4_no_neg_mode`, `Afix4_no_pos_mode` | displayed `Afix4`(=`Afix0`) not involution, invertible at `±1` | same block again (S4) | **not** about `Wfour` (S3,S4) |
| `involutiveCompression_wall` | assembled `InvolutiveCompression (toC Wwall) …` | fires engine on the live walk | native_decide-trusted |
| `twoWall_protected_modes` | `∃` nonzero `V`: `(toC Wwall)·V=−V` and `∃` nonzero `V`: `=V` | **exact ±1 mode existence for one fixture** | not iff, not count, not localized, not protected, not kernel-only |

Dead definitions: `Wzero`, `Wfour` (never a theorem subject).

## Trust-footprint table (`#print axioms`, verified)

| Group | Declarations | Axioms |
| --- | --- | --- |
| Kernel-only (standard three) | entire §1 engine + §2 counting: `compression_involution`, `involutive_compression_flip_mode`, `involution_full_pinning`, `involution_trace_split`, `involution_root_pm`, `toC_*` | `propext, Classical.choice, Quot.sound` |
| native_decide draft-trust | all K6 literals: `Afix_involution`, `Afix_selfadj`, `Bfix_iso`, `Wwall_Bfix`, `Wwall_orthogonal`, `Afix0_no_neg_mode`, `Afix4_not_involution`, `involutiveCompression_wall`, **and the composed `twoWall_protected_modes`** | `propext, Classical.choice, Quot.sound, Lean.ofReduceBool, Lean.trustCompiler` |

---

## Point-by-point answers to the task note

1. **Kernel-only vs native_decide:** the abstract engine (§1) and the counting
   (§2) and all `toC` lemmas are kernel-only; every K6 literal and the composed
   `twoWall_protected_modes` carry `Lean.ofReduceBool`/`Lean.trustCompiler`.
2. **Quantification / iff:** none. Only explicit 0/2/4-wall fixtures.
3. **What `twoWall_protected_modes` proves:** exact eigenmode *existence* (one
   `+1`, one `−1`) for one fixture. Not localization, not stability, not
   topological protection, not the 2/2 count.
4. **Zero/four controls:** only invertibility of the displayed compressed
   matrices at `±1`. Not absence of modes for the full walks (the walks are
   never compressed; `Wzero`/`Wfour` are unused; `Afix4 = Afix0`).
5. **Compression genuine/self-adjoint/transported:** yes for the two-wall walk
   (`Wwall_Bfix` + `Afix_selfadj` + `Wwall_orthogonal` + correct `toC`
   transport). Not established for either control walk.
6. **Root/trace counts at `k=0` and repeated roots:** valid; multiplicity-based
   via charpoly; explicit `k=0` case; no diagonalizability assumption.
7. **"Half-winding" defined & connected to Plücker winding:** no; it is a name
   only, connected to nothing; the winding module is not imported.
8. **Strongest safe sentence & successors:** below.

---

## Replacement language (drop-in for the manuscript/header)

Replace the header "THE RESULT" paragraph and any "Z2 half-winding / modes iff
walls = 2 mod 4 / topologically protected localized" prose with:

> **Safe statement.** *We formalize a general spectral engine (kernel-checked):
> a self-adjoint compression `M = BᴴWB` of a unitary `W` onto an invariant
> subspace is an involution (`M²=1`), so its algebraic spectrum is `⊆{±1}` with
> multiplicities `(k±tr M)/2`, and whenever `M≠±1` the `+1` and `−1` sector
> eigenvectors lift to genuine `±1` eigenvectors of `W` — with no
> diagonalizability hypothesis. We then exhibit one explicit rational 3-4-5
> two-wall K6 walk whose fixed-leg compression is a self-adjoint involution
> (checked by `native_decide`, draft-trust), and conclude that this walk has an
> exact `+1` eigenvector and an exact `−1` eigenvector. For the displayed
> control block the compression is not self-adjoint and is invertible at `±1`.*

Do **not** write, at the current proof state: "Z2 half-winding invariant",
"protected", "topologically protected", "localized", "iff wall count = 2 mod 4",
"NO-mode control for the zero/four-wall walk", or "kernel-checked" applied to
the mode-existence result. Permitted qualified verbs for the fixture result:
"exhibits", "for this explicit walk", "native_decide-verified / draft-trust".

---

## Minimal successor theorems that would earn each stronger phrase

- **Earns "kernel-checked modes" (removes S7):** re-prove the K6 literals
  (`Wwall_Bfix`, `Afix_selfadj`, `Wwall_orthogonal`, `Afix_ne_one`,
  `Afix_ne_neg_one`) with `decide`/`norm_num`/explicit rational arithmetic
  instead of `native_decide`, so `twoWall_protected_modes` reduces to the
  standard three axioms.

- **Earns the 2/2 "count" (removes S8):**
  `theorem twoWall_mode_count : (Afix.charpoly.roots.count 1 = 2) ∧
  (Afix.charpoly.roots.count (-1) = 2)` — instantiate `involution_full_pinning`
  + `involution_trace_split` with `Afix_involution` and `Afix_trace`, then read
  the split; and lift to `Module.finrank ℂ (eigenspace (toC Wwall) 1) = 2` via
  the isometry to make it a walk statement.

- **Earns honest "no-mode controls" (removes S3/S4):** first prove the missing
  invariance `theorem Wzero_Bfix : Wzero * Bfix = Bfix * Afix0` and
  `theorem Wfour_Bfix : Wfour * Bfix = Bfix * Afix4` **with a genuinely distinct
  `Afix4`**, then either (a) restrict the claim to the fixed sector explicitly
  ("`Wzero` has no `±1` eigenvector supported in `range Bfix`"), or (b) prove the
  full-walk statement `¬∃ V≠0, (toC Wzero).mulVec V = ±V` (e.g. via
  `(Wzero ± 1).det ≠ 0` by `native_decide` on the 8×8 walk).

- **Earns the general `iff` / "2 mod 4" (removes S2, S1):** define wall count as
  a Lean function of a sign field `s : Fin n → {±1}` (number of adjacent sign
  changes on the cycle), and prove
  `∀ s, (∃ ±1 mode of walkQ cW s) ↔ (wallCount s) % 4 = 2`, or at minimum the
  weaker parity theorem over a parametrized family — not three fixtures.

- **Earns "Z2 half-winding invariant" (removes S1):** define a `ZMod 2`-valued
  invariant `halfWinding : (Fin n → ℚ) → ZMod 2` and prove
  (i) it is invariant under the admissible deformations, and (ii) it equals the
  parity of the fixed-leg-compression involution class; then connect it to
  `PlueckerWindingDerived.totalTurning` (`= (winding)/2 mod 2`) with an actual
  import and equality lemma.

- **Earns "topologically protected" (removes S6):** state a perturbation class
  `P` (unitarity + chirality + `halfWinding`-preserving) and prove
  `∀ δ ∈ P, ∃ ±1 mode of (W+δ)` — plus the falsifier: an in-class-*breaking*
  `δ` that removes the mode.

- **Earns "localized" (removes S5):** prove a support/decay bound on the
  constructed eigenvector, e.g. `‖V (site,·)‖` decays away from the defect, or at
  minimum that `V` is supported on the fixed legs and give its explicit rational
  entries with a concentration ratio.
