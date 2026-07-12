# HOSTILE_REVIEW_2 — Adversarial audit of the five 24h-run modules

**Scope.** Review-only. Packet = verbatim Lean source of five modules in `context/`
plus `context/PAPER_CITING_PASSAGES.md`. No proving performed.

**What I verified mechanically (so it is *not* in dispute).**
The packet ships as a `context` lib (there is no `PhysicsSM` source tree here; the
files are re-homed). It builds clean against Mathlib v4.28.0 (`Build completed
successfully`), and every headline theorem I spot-checked
(`selection_uniqueness`, `census_sum_zero`, `no_odd_generator_on_samesite_block`,
`G2_signed_permutation`, `U1c_crossings_only_at_neg_one`, `restOp_cube`,
`controlZ_violates_cube`) depends only on `[propext, Classical.choice, Quot.sound]`.
So the "KERNEL-ONLY / no native_decide / no sorry" provenance claims are **true**.

**Therefore every finding below is an over-claim of _meaning_, _scope_, or
_connection to the physics_ — not a broken proof.** The statements prove exactly
what they say; the question a hostile referee asks is whether what they say is what
the docstrings and the manuscript say they say. The answer is repeatedly "no."

The four audit modes are abbreviated **[VAC]** vacuity, **[HOL]** hollow
telescoping, **[DOK]** docstring-outruns-kernel, **[FSH]** false shape.

---

## 1. `SplitStepChargeBalance.lean`

### F1 [HOL] The "eight-node sum-zero census" is a balanced-parity triviality, not a fact about any walk.
`census_sum_zero` reduces (via `chargeOf_census`) to summing, over the 8 nodes,
`if Bool.xor (nodeParity n) g then -1 else 1`. `nodeParity` is
`Bool.xor (Bool.xor (n 0) (n 1)) (n 2)` — the 3-bit XOR parity, which is *balanced*
on `{0,1}³` (4 even, 4 odd). The sum is therefore `4·(+1)+4·(−1)=0` **for any
antipodal pair of values whatsoever**. The Jacobian identities
`Jplus = (4/5)·diag(-1,1,-1)`, `det = 64/125`, etc. play **no role** in T3: only
`Jminus = -Jplus` (so the two signs are `±1`) is used. The census sum rule is
literally the statement "XOR of three bits is a balanced Boolean function,"
costumed as "the doublers are exactly the charge partners the sum rule demands."

### F2 [VAC/DOK] Nothing in the file connects the census to a walk; the assignment rule is *defined*, not *derived*.
The parity-to-Jacobian assignment is `def census`, and the docstring is candid that
this is stipulated: *"The symbol-to-Jacobian derivation (Schur reduction of the live
Bloch symbol) is deliberately NOT claimed here; these are the oracle-extracted jets,
stated as explicit matrices."* Consequently the physically loaded claims — "every
node is a nondegenerate cone," "per node the two gap charges are opposite (Floquet
pairing)," "which node carries `Jplus`" — are **inputs**, not theorems.
`census_floquet_opposition` is true because `census n false` and `census n true`
differ by one `Bool.xor` flip **by construction of `census`**, not because of any
Floquet structure.

### F3 [FSH] `chargeOf` det-sign vs. the manuscript's determinant value.
`chargeOf J = if 0 < J.det then 1 else if J.det < 0 then -1 else 0` is a faithful
"sign of the velocity-Jacobian determinant" chirality — this part is honest. But
`det = ±64/125 = ±cos³θ` (the manuscript's *nondegenerate-cone* content) is a
one-line `Matrix.det_fin_three` on a hand-entered diagonal matrix; it is disconnected
from `chargeOf` (which uses only the *sign*) and from any Bloch symbol.

### F4 [DOK — manuscript split, honestly drawn] The paper's kernel/run-record split is *fairly* stated, but it hollows out the contribution.
The cited passage says: *"The two Jacobian charges, the per-node Floquet opposition,
and the eight-node sum-zero census are machine-checked (`SplitStepChargeBalance`,
kernel-only); the Schur reduction from the walk symbol to the displayed Jacobians is
the exact run-record layer."* This is an **honest** partition — the paper does *not*
claim the Schur reduction is machine-checked. But read against F1–F2 it means the
machine-checked part is arithmetic on hand-supplied matrices + a balanced-parity
identity, while the only content that would tie it to the walk (the Schur reduction)
is explicitly outside the kernel. The split is drawn honestly and *that is the
problem*: it isolates the trivial half as "the theorem."

---

## 2. `PairKickSelection.lean`

### F5 [FSH/DOK] The uniqueness is an artifact of an ad-hoc, non-scalar gauge `diag(u,1)` that is never tied to the walk.
`def Dphase (u : ℂ) : M2 := !![u, 0; 0, 1]` is a bare local definition. Under it,
off-diagonal entries transform with weight `+1` and diagonals with weight `0`
(`|u|²=1`), which is *exactly* what forces the answer to be off-diagonal `∝ z`. Had
the "gauge" been the genuine common phase `diag(u,u)` (a scalar), conjugation is
trivial and equivariance would force `A=B=0` and then `C=0`, i.e. `H=0` — the family
collapses. So the choice `diag(u,1)` is precisely the one that makes a nonzero
one-parameter family survive. Nothing in the landed statements relates `Dphase` to
any repo operator; the provenance line's *"the repo's own site-local chiral phase
action"* and the docstring's *"the repo's gauge action (`chiralPhase`, one-particle
`diag(u,1)` at the kick's site)"* are unverifiable from the packet (`chiralPhase`
does not appear).

### F6 [DOK] "Common-phase" (manuscript) ≠ `diag(u,1)` (kernel).
The manuscript passage requires the gate *"transform under the walk's exact
**common-phase** removal with forward amplitude transforming as the derived datum
z."* A common phase is scalar `diag(u,u)`; the kernel uses the **non-scalar, chiral**
`diag(u,1)`. The docstring itself oscillates — it calls the action both *"the walk's
exact common-phase action"* and *"site-local chiral phase ... `diag(u,1)`"* in the
same file. These are different group actions with different invariants; the entire
"unique phase-reading coupling" conclusion depends on which one is meant, and the
packet does not resolve it.

### F7 [VAC] `selection_control` does **not** test the load-bearing constraint and does not establish "outside the family."
The docstring bills T3 as: *"dropping equivariance admits a coupling OUTSIDE the
family"* and *"the constraint set is demonstrably load-bearing."* What
`selection_control` actually proves is only:
```
(∀ z, (!![1,0;0,0])ᴴ = !![1,0;0,0]) ∧ (!![1,0;0,0]) ≠ 0
```
i.e. "there exists a Hermitian 2×2 matrix that is nonzero at `z=0`." It **never**
checks that `!![1,0;0,0]` satisfies equivariance, never checks it is outside the
one-parameter family, and the only constraint it is shown to violate is **vanishing**
(`H' 0 ≠ 0`) — *not* equivariance, which is the crux constraint driving uniqueness.
So (a) the stated purpose ("dropping equivariance") and the delivered content
("fails vanishing") are inconsistent, and (b) as a load-bearing demonstration it is
vacuous: it shows only that a Hermitian matrix can be nonzero at 0. The genuinely
load-bearing constraint — equivariance — has **no** control at all.

### F8 [DOK] "The supplied interaction is now the UNIQUE phase-reading coupling in its class."
Even granting `Dphase`, T1 proves uniqueness of a `2×2` block family
`famH C A B z = C + z•A + z̄•B`. The jump from "the unique solution of these three
constraints on a 2×2 block" to *"the UNIQUE phase-reading coupling in its class"* /
*"the unique phase-reading quartic up to its own circle parameter"* (manuscript) is a
reduction from the CAR quartic problem to this block that is **asserted**, not in the
file. The kernel result is a finite 2×2 linear-algebra classification.

---

## 3. `GammaOddKickDichotomy.lean`

### F9 [DOK] The T1 no-go covers a **2-dimensional** sub-block, but is sold as "the derived kick's support."
`no_odd_generator_on_samesite_block` hypothesises support on indices `{0,13}` =
pairs `(0,1)` and `(2,3)` — two of the four same-site pairs. But the docstring
concludes *"the derived kick's support can never host the odd repair"* and the
program-role line says the repair is *"IMPOSSIBLE on same-site pair blocks."* The
full same-site block is `{0,13,22,27}` = `(0,1),(2,3),(4,5),(6,7)` (verified against
`pairFst`/`pairSnd`: `(4,5)`↦22, `(6,7)`↦27). The argument would extend (G2 is `-1`
on all four), but as landed the no-go is proven only on a `{0,13}` corner, not on
"the derived kick's support." Scope claimed > scope proven.

### F10 [DOK] `G2_signed_permutation` proves a strictly weaker fact than "exactly four `-1`-fixed states and twelve two-cycles."
The docstring/target T3 promises: *"`G2` is a signed permutation with exactly four
`-1`-fixed states (the four same-site pairs) and twelve two-cycles ... `q` is the
component-flip partner."* The theorem actually delivers: for every `p`, `G2 *ᵥ eₚ`
is `−eₚ` **or** `±e_q` for **some** `q ≠ p`; plus the two specific facts that indices
`0` and `13` are `−1`-fixed. It does **not** prove (i) there are *exactly four* fixed
points, (ii) they are *exactly* the same-site pairs, (iii) there are *twelve*
two-cycles, or (iv) that `q` is *the component-flip partner*. "Exactly four / twelve
/ component-flip partner" outruns the kernel.

### F11 [VAC — in the good direction, but note] The T1 hypothesis set is genuinely satisfiable and the no-go is non-vacuous.
For balance: T1 does **not** assume Hermiticity (making it a *stronger* no-go than
advertised), and the odd space it kills is real (`oddH` in T2 is a genuine nonzero
odd Hermitian family, `oddH_ne_zero` + `oddH_odd` + `oddH_isHermitian` all hold).
The `(0,2)↔(1,3)` support of `oddH` (indices `1`,`8`) matches the definition
(`pairFst 1,pairSnd 1 = (0,2)`; `pairFst 8,pairSnd 8 = (1,3)`). So the *existence*
half (T2) is clean and faithful; only the *census/no-go scope* (F9, F10) is
over-stated.

### F12 [FSH — clean] `G1` really is site-diagonal σ_y and `G2` really is its Λ² lift.
Checked: `G1` restricted to site `s` is `[[0,-i],[i,0]] = σ_y`; `minorLift` is the
`2×2`-minor (second exterior power) lift. No false shape here. The Gaussian-integer
twin + `phi`-transport is a legitimate device and the `decide` calls are kernel.

---

## 4. `TwoBandCrossingDoubling.lean`

### F13 [FSH — clean] Charpoly sign conventions are correct.
`Matrix.charpoly_fin_two` gives `X² − trace·X + det`, so `eval 1 = 1 − tr + det` and
`eval (−1) = 1 + tr + det`, matching the stated crossing conditions `1 ∓ tr + det = 0`.
`unit_det_plus_crossing_degenerate` (det=1, eval 1 = 0 ⇒ tr=2 ⇒ charpoly `(X−1)²`) and
its `−1` twin are correct. The fixtures check out arithmetically: `det coin = 1`,
`U0c` roots `{1/2,2},{−2,−1/2}` off the circle, `U1c` evals `(1/5)(z+1)`,
`(9/5)(z+1)`, both vanishing only at `z=−1`, where `U1c(−1)` has charpoly `X²−1` (evals
`+1,−1` simple). No false shape.

### F14 [VAC] The unused `‖z‖ = 1` in `U1c_crossings_only_at_neg_one` (linter-confirmed).
The build linter reports `unused variable hz` at `TwoBandCrossingDoubling.lean:207`.
The theorem is stated *"away from `z = −1` **on the circle** there is no crossing"*
but the proof never uses `hz : ‖z‖ = 1` — it holds for **all** `z ≠ −1`. Harmless to
soundness (it is a stronger fact), but the on-the-circle framing is decorative and a
referee will read the retained-but-unused hypothesis as either sloppiness or a hint
that the "circle" geometry is doing less than advertised.

### F15 [VAC] For the actual massive fixture, the "zero-flow degeneracy headline" (W1) never fires.
W1 (`unit_det_..._degenerate`) is the *headline* ("every `±1` crossing is doubly
degenerate"). But W2 (`U0c_gapped`) proves the massive zero-flow symbol has **no**
`±1` crossings on the circle at all. So on the fixture the degeneracy theorem is
vacuously non-applicable — the two "oracle-verified facts" narrate a degeneracy that
the same file shows never occurs for the actual walk. W1 is a true *abstract* lemma
about arbitrary det-1 `2×2` matrices; its billing as a statement about the walk's
crossings is empty for the supplied walk.

### F16 [DOK, minor] "doubly degenerate" vs. algebraic multiplicity.
W1 concludes `charpoly = (X−1)²` for **any** det-1 matrix (unitarity not assumed).
That is coincidence of *eigenvalues* (algebraic mult 2), not a 2-dimensional
eigenspace; a Jordan block `[[1,1],[0,1]]` satisfies the hypotheses. The
"doubly degenerate / no simple crossing" gloss is accurate only after invoking
unitarity (normal ⇒ diagonalizable), which the theorem does not assume. The
eigenvalue reading is fine; the "degenerate cone" reading needs the missing
normality step.

### F17 [DOK] "two-band pseudo-doubler theorem" is a single-point fixture check.
T3/T4 establish that the flow-one walk's 0- and π-crossing sets both equal `{−1}`.
This is a faithful, correct fact — but it is one evaluation point of one explicit
`2×2` Laurent symbol, not a "theorem" in the general sense the name and the
program-role text ("the two-band pseudo-doubler theorem, exhibited") suggest. The
docstring is honest that *"The general signed-count theorem is NOT required here."*

---

## 5. `PlueckerRestOperatorGeneral.lean`

### F18 [strongest module — genuine general-`n` content.]
The cube law `areaMatrix_cube` (`Z Zᴴ Z = budget • Z`), the Lagrange identity
`sum_sq_areaMatrix` (`Σ|Z_ij|² = 2·budget`), `restOp_cube` (`B³ = budget•B`),
`budget_star` (budget real), and `restOp_support_projector` (idempotent, `trace = 4`
⇒ rank-4 support for every `n`) are real, general-`n`, non-trivial linear algebra.
This module is the least fragile by a wide margin.

### F19 [DOK] "The SAME finite closure as the interaction generator `K³ = |z|²K` ... one cubic algebra governs both."
The kernel proves `B³ = budget•B`. `K` **is not defined in this file** and no lemma
relates `B` to `K`. The docstring's *"the SAME finite closure shape as the
interaction generator's `K³ = |z|²K` ... One cubic algebra governs both the rest
sector and the supplied interaction"* and the manuscript's parallel display
(eq:cubiclosure) are **analogy**, not theorem. Fine as prose, but it is rhetorical
unification, not proven unification.

### F20 [VAC/FSH] `controlZ_violates_cube` refutes the *budget-valued* law but the control matrix still satisfies a *proportional* cubic closure.
The control is billed as showing *"the cube law is a theorem about spinor-generated
... data, not about antisymmetric matrices."* What it literally proves:
`Σ|Z0|² = 2·2`, `(Z0 Z0ᴴ Z0) 0 1 = 1`, and `2 • Z0 0 1 = 2` — i.e. `Z0 Z0ᴴ Z0 ≠
(area/2)•Z0` at entry `(0,1)` (1 vs 2). But `Z0` is block-diag `[[0,1],[-1,0]]⊕same`,
so `Z0 Z0ᴴ = I₄` and `Z0 Z0ᴴ Z0 = Z0 = **1**·Z0`. **`Z0` does satisfy a cubic
closure `Z Zᴴ Z = c·Z` — with `c = 1`.** What fails for the non-decomposable `Z0` is
only that the closure constant equals the area budget (`c = 1 ≠ 2`). So the honest
reading of the control is "the *coefficient identification* `c = area budget` is
special to rank ≤ 2," **not** "the cubic closure shape fails for general
antisymmetric matrices." The docstring's *"violates the cube law"* over-reads a
coefficient mismatch as a shape failure. A referee wanting a genuine shape-failure
control (a `Z` with `ZZᴴZ` not proportional to `Z` at all) will note this one is not
it. Note also `budget` is never evaluated on `Z0` (it cannot be — `Z0` is not
`areaMatrix u v`); "budget = 2" is imputed via the Lagrange identity that only holds
for spinor matrices.

### F21 [FSH — clean] `budget` real, `restOp` Hermitian/odd, trace = 4 ⇒ rank 4.
`budget_star` genuinely gives `star budget = budget`; `restOp_isHermitian`/`restOp_odd`
are correct; `trace = 4` of an idempotent over ℂ is rank 4, so "rank-4 support for
every `n` with `budget ≠ 0`" is faithful, and the `n=2` recovery `B² = budget•1₄`
is consistent (rank 4 = full). No false shape.

---

## Fragility ranking (most fragile → least) with the single strongest follow-up objection

**#1 (most fragile) — `SplitStepChargeBalance`.**
Strongest objection: *"Strip the hand-entered Jacobians and your sum rule is
`census_sum_zero` = the 3-bit XOR parity being balanced; the det value `64/125` is
never used by the charge sum, and the file itself disclaims the only step (Schur
reduction) that would tie any of it to the walk. What have you machine-checked about
the walk?"* **Answerable from landed statements alone? No.** The walk connection is
explicitly outside the kernel, and the sum rule is walk-independent by construction.

**#2 — `PairKickSelection`.**
Strongest objection: *"Your uniqueness is manufactured by the non-scalar gauge
`Dphase = diag(u,1)`, which is a bare local `def` unconnected to any repo operator
and inconsistent with the manuscript's 'common-phase' (scalar) language; a scalar
gauge kills the family entirely. And `selection_control` never tests equivariance —
the constraint that actually drives uniqueness — so the 'load-bearing' claim is
undischarged."* **Answerable from landed statements alone? No.** `chiralPhase`
never appears; there is no lemma linking `Dphase` to the walk, and no control on
equivariance.

**#3 — `GammaOddKickDichotomy`.**
Strongest objection: *"Your no-go (`no_odd_generator_on_samesite_block`) is proven
on the 2-index corner `{0,13}`, not on the full four-pair 'derived-kick support' you
claim to rule out; and `G2_signed_permutation` proves a per-state disjunction plus
two fixed points, not the docstring's 'exactly four fixed, twelve two-cycles,
component-flip partner' census."* **Answerable from landed statements alone?
Partially.** The 2-block argument plainly generalises (G2 is `−1` on all four
same-site indices) and the transport machinery is present, so the gap is fixable —
but *as landed* the theorems are strictly weaker than the claims, so the objection to
the current statements stands.

**#4 — `TwoBandCrossingDoubling`.**
Strongest objection: *"Your degeneracy headline W1 never fires on your own massive
fixture (W2 shows it has no `±1` crossings), the 'pseudo-doubler theorem' is a
single-point evaluation, and `U1c_crossings_only_at_neg_one` carries an unused
`‖z‖=1`."* **Answerable from landed statements alone? Yes, defensively.** The
individual statements are true and faithful; the objection is to framing/naming and
one dead hypothesis, all of which the author can concede without retracting a
theorem.

**#5 (least fragile) — `PlueckerRestOperatorGeneral`.**
Strongest objection: *"`controlZ` still satisfies a proportional cubic closure
(`ZZᴴZ = 1·Z`); it violates only the budget-valued coefficient, so 'violates the
cube law' overstates it, and the `K³=|z|²K` unification is analogy, not theorem."*
**Answerable from landed statements alone? Yes.** The core general-`n` results
(cube law, Lagrange, rank-4 projector) are genuine and self-contained; the two
objections are about the control's phrasing and a rhetorical cross-reference, both
of which can be rephrased without weakening any proved statement.

---

## Cross-cutting observations

- **C1.** Across all five, the soundness/"kernel-only, no `native_decide`, no sorry"
  provenance claims are **accurate** (build clean; axioms `[propext, Classical.choice,
  Quot.sound]` throughout). The audit surface is entirely *interpretation vs.
  statement*, not proof integrity.
- **C2.** Recurring pattern: **the physics is loaded into `def`s, and the theorems are
  downstream tautologies.** `census`/`nodeParity` (Module 1), `Dphase` (Module 2),
  the supplied `oddH` block and index bookkeeping (Module 3) all *define* the
  structure the prose then "discovers." The genuinely input-free theorems are W1
  (Module 4) and the whole of Module 5.
- **C3.** Two of the three "load-bearing controls" are weaker than advertised:
  `selection_control` (F7) tests the wrong constraint and proves near-nothing;
  `controlZ_violates_cube` (F20) refutes a coefficient, not the closure shape. Only
  Module 5's control is close to genuine, and even it is a coefficient-level control.
- **C4.** Three separate "exactly/unique/four" quantifier over-claims sit in
  docstrings that the kernel does not back: "the UNIQUE phase-reading coupling in its
  class" (F8), "exactly four `-1`-fixed states and twelve two-cycles" (F10), and the
  scope word "same-site pair blocks" for a `{0,13}` corner (F9).
