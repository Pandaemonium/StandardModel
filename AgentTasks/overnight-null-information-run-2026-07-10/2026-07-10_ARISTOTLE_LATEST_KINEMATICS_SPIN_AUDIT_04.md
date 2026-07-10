# LATEST_KINEMATICS_SPIN_AUDIT_04

Independent source-level audit of the D4 null shell, normalized Clifford unitary
step, SU(2) spin-half action, general Gram turn scale, finite Fourier lift, and
the checkerboard operator-history bridge, cross-checked against
`MANUSCRIPT_CLAIM_MATRIX.md` and `THEORY_COMPLETION_MATRIX.md`.

Scope note: **source files were not edited.** Findings are ordered by severity.
Grades: `CLOSED` (kernel statement proves exactly what the caption claims),
`PARTIAL` (statement is honest but narrower than the surrounding prose, or rests
on supplied data), `OPEN` (the claimed arrow is not in the kernel).

Legend for verification status:
- `[verified-here]` I re-elaborated the declaration in this Lean/Mathlib
  (v4.28.0) and reproduced the `#print a x i o m s` guard.
- `[source-only]` module imports upstream files that are **absent** from the
  delivered tree, so it cannot be recompiled here; audited from source text plus
  its stated guard.

---

## F0 (SEVERITY: HIGH) — The delivered corpus is not self-contained and its "build-enforced" guards are not build-enforced here

The lakefile builds a single target, the library `Audit`, i.e. `Audit/Core.lean`,
whose only theorem is `LatestKinematicsSpinAudit.package_marker : True`. None of
the six audited modules under `PhysicsSM/Draft/NullEdge/` are in a build target,
and four of the six import modules that **do not exist anywhere in the tree**:

| Module | Missing import(s) |
|---|---|
| `NormalizedCliffordUnitaryStep` | `Clifford3Plus1WalkSymbol` (`Mat4`, `alpha1`, `alpha2`, `beta`) |
| `SU2SpinHalfAction` | `NullFactorizationSpinFiber` (`Mat2`, `witnessRotation`, `witness_rotation_special_unitary`) |
| `GeneralGramTurnScale` | `CanonicalGramTurnDictionary`, `Spinor.PluckerMass`, `Carrier.FreeMassBridge` |
| `CheckerboardOperatorHistoryBridge` | `CheckerboardPathSumTransferPower`, `HistoryOperatorMonoidalDagger` |

Consequence: the `#print a x i o m s … #guard_msgs` blocks at the foot of each file —
the corpus's headline soundness mechanism ("Build-enforced assumption-footprint
guards") — **cannot be executed in this package**. For the four import-dependent
modules the guards are unverified assertions about source text, not enforced
facts. The two self-contained files (`D4NullShellLattice`,
`FiniteFourierContinuumLift`) import only Mathlib; I re-elaborated their core
declarations and reproduced the exact `[propext, Classical.choice, Quot.sound]`
footprints, so their guards are genuine.

This does not indicate any theorem is false; it means the audit package under-
delivers its own dependency closure, and any reader claim of "kernel-checked" for
the four import-dependent modules is currently un-reproducible.

**Recommendation to the manuscript:** either vendor the upstream modules into the
submission set or explicitly downgrade the four modules to `[import]`/source-only
in both matrices.

---

## F1 — D4 null shell: honest 3+1 luminal *alphabet*, but the split is a convention

`D4NullShellLattice` — `[verified-here]` (`decide`-based, kernel a x i o m s clean; no
`n a t i v e _ d e c i d e`/`Lean.ofReduceBool`, so no compiler trust).

**CLOSED (finite arithmetic).** Reproduced: `d4_root_count = 24`,
`null_root_count = 12`, `every_null_root_is_unit_luminal`
(`|v 0| = 1 ∧ (v 1)^2+(v 2)^2+(v 3)^2 = 1`). Also present and consistent:
`every_root_has_norm_two`, `null_shell_antipodal`, and the essential
`spacelike_root_control` showing `![0,1,1,0]` is a root, is not null, and has
`minkowskiSq = -2`. Nondegeneracy is properly controlled: the selection is shown
to be non-vacuous by exhibiting a discarded spacelike root.

**PARTIAL — exactly what is *not* derived.**
1. **Time selection is external.** `minkowskiSq` hard-codes coordinate `0` as time
   with signature `(+ - - -)`. Nothing selects coordinate `0`; by the symmetry of
   `rootsList` any of the four coordinates yields exactly twelve null roots. The
   "3+1" split is a labeled convention, honestly disclosed in the docstring
   ("supplied, not derived").
2. **The alphabet is axial, not the full null cone.** The twelve steps are
   `(±e_time) + (±e_spatial-axis)`; there are no diagonal/off-axis null steps.
   "Luminal alphabet" is honest as *twelve primitive axial luminal steps*, but the
   word could be read as the full light cone. The source says "primitive axial
   luminal step," which is accurate.
3. **Dimension 3+1 is inherited from the ambient `D4`/`Fin 4`, not derived**, and
   spatial isotropy is not claimed or shown (axial directions only).

Verdict: an honest, kernel-clean finite classification; the "3+1 luminal" reading
is a convention layered on decidable arithmetic. Matches the matrix caption
("Lorentzian time-coordinate selection is supplied").

---

## F2 — Normalized Clifford unitary step: two-sided ✔, nonzero mass coefficient ✔ (but "mass" is a supplied label)

`NormalizedCliffordUnitaryStep` — `[source-only]`.

**CLOSED (two-sidedness).** `IsUnitary U` is *defined* two-sided
(`Uᴴ * U = 1 ∧ U * Uᴴ = 1`) and `step_unitary` discharges both conjuncts via
`constructor`. So the step is genuinely two-sided, not one-sided-plus-dimension-
count. The underlying algebra is standard and correct: for `a : ℝ`, `Hᴴ = H`,
`H*H = qI`, `a²+q = 1`, one has `U = aI - iH`, `Uᴴ = aI + iH`, and
`UᴴU = UUᴴ = (a²+q)I = I`.

**PARTIAL (nonzero mass witness).** `witnessH = ½·alpha1 + ½·alpha2 + ½·beta`
has `q = 3/4` (`witnessH_sq`), and with `a = ½` gives a unitary step;
`massive_rational_unitary_witness` additionally proves `step (½) witnessH ≠ 1`.
The `beta` coefficient is `½ ≠ 0`, so the witness does carry a nonzero coefficient
on the third generator. Caveats:
- That `beta` is the **mass** generator (and `alpha1, alpha2` the velocity
  generators) is a dictionary defined in the absent `Clifford3Plus1WalkSymbol`.
  The kernel statement of `step_unitary`/`massive_rational_unitary_witness`
  contains **no notion of mass**; "carries a nonzero mass coefficient" is a
  docstring claim that outruns the kernel content.
- `q = 3/4 = (½)² + (½)² + (½)²` is consistent with the matrix's
  `H(k,m)² = (|k|²+m²)I`, i.e. `|k|² + m² = 3/4`, but this consistency also lives
  in the absent module.
- Honestly disclaimed: "momentum-space internal step … does not construct BCC
  position-space shifts, prove locality, sum lattice histories, or establish a
  3+1 continuum limit."

Verdict: the unitarity theorem is genuinely two-sided and the witness is genuinely
massive-in-coefficient; the *physical* "mass" reading is a supplied convention
and is not re-established here.

---

## F3 — SU(2) spin-half action: correct defining representation + double-cover fingerprint, no particle/spin-statistics overreach

`SU2SpinHalfAction` — `[source-only]`.

**CLOSED (algebraic rung), as captioned.**
- `isSU2_iff_mem_specialUnitaryGroup` ties the local `IsSU2` predicate to
  `Matrix.specialUnitaryGroup (Fin 2) ℂ`; `isSU2_one`, `isSU2_mul` give the group
  structure.
- `spinAction_mul` is the genuine defining 2-dimensional representation law
  `spinAction (U*V) = spinAction U ∘ spinAction V`.
- `spinInner_preserved` / `special_unitary_spinInner_preserved`: SU(2) preserves
  the Hermitian inner product `⟨ψ,φ⟩ = (star ψ)·φ`.
- `factor_fiber_spin_half_witness`: the landed `witnessRotation` is in SU(2),
  moves `up`, and satisfies `witnessRotation² = -I`, `witnessRotation⁴ = I` — the
  `2π → -I` double-cover fingerprint.

The question posed — does it connect the determinant-fixed factor fiber to a
defining spin-half rep **without** claiming a particle sector or spin-statistics —
is answered **yes**. The docstring correctly disclaims particle identification,
Wigner rotations, and spin-statistics.

**PARTIAL.**
1. "Spin-half" here means precisely *the defining 2-dim SU(2) representation with
   the `-I` double-cover control*. There is no `su(2)` Lie-algebra / angular-
   momentum generator content and no SO(3) covering map, so "spin-half" is a
   fingerprint, not an angular-momentum theorem.
2. The tie to the "landed determinant-fixed factor fiber" is by **importing**
   `witnessRotation` / `witness_rotation_special_unitary` from the absent
   `NullFactorizationSpinFiber`. The kernel here only asserts that this particular
   matrix satisfies the SU(2) relations; that it *is* the factorization fiber is
   inherited, not re-derived.
3. Minor convention note: `IsSU2` states unitarity one-sided (`Uᴴ*U = 1`) plus
   `det = 1`; harmless in finite dimension and reconciled with
   `specialUnitaryGroup` via `mem_unitaryGroup_iff'`.

---

## F4 — General Gram turn scale: canonical-pair restriction genuinely removed; decorations still supplied

`GeneralGramTurnScale` — `[source-only]`.

**CLOSED (removal of the canonical-pair restriction).**
`free_mass_operator_eq_derived_turn` is quantified over **every** decorated pair
`(psi phi : CSpinor)`:
`twoEdgeMomentum ψ φ * (twoEdgeMomentum ψ φ).adjugate = complexify (Q_T (turnScale ψ φ))`,
with `turnScale ψ φ = √(normSq (spinorWedge ψ φ))` and
`turnScale_sq : turnScale² = normSq (spinorWedge)`. This is a real generalization
of the earlier `e0, m·e1` dictionary from the pair to the whole space of pairs;
the caption "removes the earlier restriction to the canonical pair" is accurate.
Nondegeneracy is controlled by `derived_scale_controls`: a nonzero rational
fixture `turnScale edge0 (edge1 (2/5)) = 2/5`, a collinear zero control
`turnScale edge0 collinearEdge = 0`, and a nonzero free-mass operator.

**PARTIAL.**
1. Decorations remain **supplied data** — no theorem reconstructs the spinor
   decorations from a bare graph, fixes physical units, or identifies an
   interacting mass. Correctly disclaimed.
2. The "free mass **operator** equals the checkerboard turn channel" is, for
   `2×2`, essentially a **scalar** identity: `M · adj(M) = det(M) · I`, so the
   matrix framing carries determinant/Plücker content, not independent operator
   content. Honest but the "operator" language slightly outruns the payload.
3. `turnScale` is the nonnegative magnitude `√normSq(wedge)`; the phase/sign of
   the Plücker invariant is discarded. "Nonnegative turn scale" is accurate; a
   reader should not infer a signed/oriented mass.
4. The equality rides on `free_mass_operator_eq_plucker`,
   `turn_is_mass_squared`, `canonical_plucker_mass` from the absent
   `CanonicalGramTurnDictionary`; only re-parameterization over the pair is new.

---

## F5 — Finite Fourier lift: index-limit convergence on a *fixed finite grid* only

`FiniteFourierContinuumLift` — `[verified-here]` (`finite_fourier_error_bound`,
`synth_sub`, `two_mode_sharp_witness` re-elaborated; a x i o m s clean).

**CLOSED, exactly as the question states.** With `ι` a `Fintype` (the fixed finite
momentum grid) and `synth phase f = ∑ₖ phase k • f k`:
- `finite_fourier_error_bound`: `‖synth φ approx − synth φ exact‖ ≤ (card ι)·ε`
  under `‖φ k‖ ≤ 1` and modewise `‖approx k − exact k‖ ≤ ε`.
- `finite_fourier_tendsto`: a uniform `D/n` modewise estimate gives
  `synth φ (approx n) → synth φ exact` as **n → ∞**, on a **fixed** `ι`.

This is position-space synthesis convergence in the approximation index only.

**PARTIAL / naming caveat.** The title word "continuum" overreaches the kernel:
- The limit variable is the step index `n`, not a **grid refinement**; `ι` is
  fixed, and the explicit `card ι` factor *grows* under refinement, so the bound
  does not survive taking the grid to infinity.
- It is not an infinite-volume inverse Fourier theorem, an `L²` propagator
  estimate, or a continuum Dirac PDE — correctly disclaimed in the docstring, and
  correctly flagged `H/O` in the completion matrix.
- `two_mode_sharp_witness` (`synth = 2`, `‖synth‖ = card(Fin 2)·1`) properly shows
  the cardinality factor is saturated, so the bound is not a vacuous consequence
  of cancellation. Good control.

---

## F6 — Checkerboard operator-history bridge: a genuine composition arrow, but only for the *uniform* history

`CheckerboardOperatorHistoryBridge` — `[source-only]`.

**CLOSED (genuine arrow, not notation).** `pathSum_as_operator_history`:
`directionPathSum mu phase n start finish
   = historyOperator (List.replicate n (transfer mu phase)) finish start`,
proved by `directionPathSum_eq_transfer_pow` (a substantive lemma from the
absent transfer-power module) together with `historyOperator = List.prod` and
`List.prod_replicate`. It equates two independently defined layers — the scalar
direction-history path sum and a matrix entry of the operator produced by the
monoidal-composition assignment — so it is a real bridge, not definitional
notation. `two_step_operator_history_witness` gives the nonzero fixture `85` on
both sides.

**PARTIAL.**
1. Only the **constant/uniform** history `List.replicate n (transfer mu phase)`
   is bridged (a single repeated gate). General varying-gate history composition
   is not covered by this theorem.
2. The transfer gate is built from **supplied** `mu`/`phase`; it is **not proved
   unitary**, not graph-derived, and not connected to the Hodge mass decoder —
   all correctly disclaimed.
3. `[source-only]`: `directionPathSum_eq_transfer_pow`,
   `HistoryOperatorMonoidalDagger.historyOperator`, `transfer`, `Direction` all
   live in absent modules, so the guard is not re-executable here.

---

## F7 — Cross-cutting: dictionaries, conventions, controls, docstring vs kernel

- **Hidden physical dictionaries.** Every physics noun that carries the manuscript
  — "mass coefficient" (F2), "spin-half" (F3), "free mass operator" (F4), "3+1
  luminal alphabet / time" (F1), "continuum" (F5) — is a label attached to a
  kernel statement that does **not** contain that notion; each depends on a
  supplied convention or on a definition in an absent upstream module. All are
  disclosed in docstrings, but the manuscript must not upgrade any of them to a
  derivation.
- **Nondegeneracy controls are uniformly present and effective**: `spacelike_root_control`;
  `step ≠ 1` with nonzero mass coefficient; `spinAction … ≠ up` with `sq = -I`;
  `collinearEdge` zero control plus nonzero operator; `two_mode_sharp_witness`
  saturating the card factor; the `85` fixture. No audited headline is vacuous.
- **Convention points to watch**: signature `(+ - - -)` with coordinate `0`
  arbitrarily named time (F1); one-sided `IsSU2` def reconciled with two-sided
  unitarity (F3); `turnScale` keeps magnitude, drops phase (F4); `IsUnitary`
  correctly two-sided (F2).
- **Soundness of tactics**: the two verifiable files avoid `n a t i v e _ d e c i d e`;
  `D4NullShellLattice` uses kernel `decide`. For the four `[source-only]` files
  the claimed footprint is the standard `[propext, Classical.choice, Quot.sound]`
  triple, but is currently unenforced here (F0).

---

## Findings summary

| ID | Item | Grade | One-line |
|---|---|---|---|
| F0 | Package build closure / guards | **HIGH / OPEN** | 4 of 6 modules import absent files; only `Audit/Core.lean` (`= True`) builds; guards not re-runnable here |
| F1 | D4 twelve null roots | CLOSED + PARTIAL | kernel-clean finite classification; time-axis + axial "3+1 luminal" is a supplied convention |
| F2 | `step_unitary` | CLOSED (two-sided) + PARTIAL | genuinely two-sided; witness mass coefficient `½ ≠ 0` but "mass" is a supplied label |
| F3 | `SU2SpinHalfAction` | CLOSED + PARTIAL | correct defining SU(2) rep + `-I` double cover; no particle/spin-statistics; fiber tie imported |
| F4 | `GeneralGramTurnScale` | CLOSED + PARTIAL | canonical-pair restriction genuinely removed (∀ pair); decorations still supplied; content is a det/Plücker scalar |
| F5 | `FiniteFourierContinuumLift` | CLOSED + PARTIAL | fixed finite grid, index-limit convergence only; "continuum" overreaches |
| F6 | `CheckerboardOperatorHistoryBridge` | CLOSED + PARTIAL | genuine arrow for uniform histories; gate not unitary, not graph-derived |

---

## Strongest honest manuscript paragraph

> On a fixed four-dimensional integer root system we isolate, by decidable
> computation, exactly twelve primitive axial luminal steps once one coordinate
> is *named* the time axis in signature `(+ - - -)`; the selection is essential,
> since the discarded roots are spacelike. On the internal `4×4` Clifford symbol
> algebra we prove an exact, two-sided unitarity criterion — `U = aI − iH` is
> unitary whenever `H` is Hermitian with `H² = qI` and `a² + q = 1` — and realize
> it with a fully rational, nontrivial fixture whose third (mass-slot) coefficient
> is nonzero. The determinant-fixed `2×2` factor acts as the defining
> two-dimensional `SU(2)` representation: it obeys the representation law,
> preserves the Hermitian inner product, and exhibits the `2π → −I` double-cover
> fingerprint, with no claim of a particle species or spin-statistics. For every
> decorated null spinor pair the free two-edge mass operator equals the
> complexified checkerboard turn channel at the derived nonnegative Plücker scale,
> removing the earlier single-pair restriction; and the exact scalar sum over
> length-`n` direction histories is recovered as a matrix entry of the operator
> assigned to the corresponding uniform operator history, with a uniform
> finite-grid Fourier bound turning modewise `D/n` control into position-space
> synthesis convergence. Each statement is a finite algebraic rung: the time axis,
> the mass/velocity dictionary, the spinor decorations, and the transfer gate are
> *supplied* data, and no rung yet asserts grid-refined continuum limits, gate
> unitarity from primitive data, or a particle interpretation.

## Single most important exact next theorem

Close the one gap that both `M5` and the F6 docstring flag — the transfer gate is
assumed, not proved, unitary — by instantiating the already-proved two-sided
criterion (`NormalizedCliffordUnitaryStep.step_unitary`) at the checkerboard gate
and lifting it through the history operator:

```lean
theorem transfer_history_unitary
    (mu : ℂ) (phase : Direction → ℂ) (n : ℕ)
    (hgate : NormalizedCliffordUnitaryStep.IsUnitary
               (embed (transfer mu phase)))          -- transfer is a normalized step
    : NormalizedCliffordUnitaryStep.IsUnitary
        (embed (HistoryOperatorMonoidalDagger.historyOperator
                  (List.replicate n (transfer mu phase))))
```

i.e. first prove `transfer mu phase` is two-sided unitary for the physical
parameter regime as an instance of `step_unitary`, then conclude that the uniform
operator history (`= transferⁿ`) is unitary. This upgrades the F6 bridge from a
supplied-gate composition to **unitary finite-history evolution**, converting the
Quantum-composition row's "unitary history composition" deliverable from `B` to a
checked theorem, and is the smallest arrow wiring F2 into F6.

*Falsifier:* if no normalization of `(mu, phase)` makes `transfer mu phase`
two-sided unitary (e.g. the phase channel is not norm-preserving), the gate is not
a legitimate evolution operator and the operator-history layer must be restated
around a contraction/CP map rather than a unitary.
