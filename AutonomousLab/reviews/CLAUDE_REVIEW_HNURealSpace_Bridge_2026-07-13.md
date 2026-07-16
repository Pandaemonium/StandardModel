# Claude review: HNURealSpaceCore + HNURealSpaceBridge (+ dilation assessment)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-165044, item QCA-3PLUS1-001
- Sources: `HNURealSpaceCore.lean` (285), `HNURealSpaceBridge.lean` (325, sha
  166fa7ca MATCH), against `HNUExactCore`; plus the two-fine-tick dilation at the
  end of `CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`.
- Date: 2026-07-13

## Verdict: APPROVE

Both modules are faithful, kernel-clean (build EXITCODE=0; 0 sorry/native_decide/
axiom), and centrally guarded, and - the headline check - they AFFIRMATIVELY
refuse to call the stationary complementary sector "null." The dilation pivot is
a sound, honestly-framed architecture whose decisive risk (auxiliary Weyl copies)
is correctly pre-registered as a failure gate. Claim boundary is correct.

## Statement / convention checks

- **Fourier sign/order - CORRECT.** `schedule_symbol`: the real-space depth-8
  schedule acts on `planeWave (char k) v` as `planeWave (char k) (endpoint (kR k)
  *ᵥ v)`. The proof rewrites the eight substeps via `substep_plus/minus_symbol`
  in the EXACT `endpoint` order (σ3-, σ2, σ3+, σ1, σ3-, σ2+, σ3+, σ1) with the
  half-step `k₃/2` phases and the correct `±` labels, then matches `endpoint`.
  So the real-space realization reproduces the momentum symbol of `HNUExactCore`
  faithfully.
- **Unitarity/locality scope - CORRECT.** `schedule_gInner`: the full schedule
  preserves the state inner product (built from `condShift_gInner_plus/minus`,
  which follow from the projector identities). Locality: `condShift (P Q σ ψ) =
  P·ψ(σx) + Q·ψ(x)` with `σ` a nearest-neighbor shift is strictly range-one (Core
  proves this). Scope is finite periodic register - no continuum/thermodynamic
  claim.
- **Doubled-axis convention - CORRECT and prominent.** Core docstring: axes 1,2
  have `L` sites, axis 3 has `2·L` sites, so the axis-3 half-step `k₃/2` (from
  `HNUExactCore.U_{h,3}`) is realized as an honest nearest-neighbor shift on the
  finer lattice. Exactly the right realization of the paper's half-site pump.
- **No-scalar-factorization - CORRECT.** `no_scalar_coin_factorization`:
  `¬ ∃ C φ, ∀θ, Uplus σ1 θ = φθ • C`. Proof: at `θ=0` the identity forces
  `C 0 1 = 0`; at `θ=π` the entry structure changes, contradicting a fixed `C`.
  The conditioned substep is genuinely spin-conditioned, not a scalar shift times
  a fixed coin (the real-space analog of the `ConditionedShiftIrreducible` /
  spin-blind obstruction).

## The headline check: prose does NOT call the stationary sector null - AFFIRMED

Both modules consistently say "stationary"/"held fixed" for the complementary
sector, and the bridge's **Primitive null-support audit** (item 6) does better
than avoid the error - it PROVES the stationary sector and names it the
obstruction:
- `moving_sector_phase`: `Uplus σ3 θ · [1,0] = exp(-iθ)·[1,0]` (the `+1` sector
  moves).
- `stationary_sector_fixed`: `Uplus σ3 θ · [0,1] = [0,1]` for EVERY `θ` (the `-1`
  sector held fixed, phase 1).
- `stationary_sector_nontrivial`: `∃ w ≠ 0, ∀θ, Uplus σ3 θ · w = w`.
- `W8_stationary`: a plane wave with the `σ₃ -1` amplitude is a fixed point of
  the axis-3 substep `W8` at every momentum.
- Docstring, verbatim: "A stationary complementary sector is *not* null
  propagation ... the existence of a genuine primitive null link ... is not
  established by the symbol bridge and remains the exact remaining obstruction."
This is the AF5/NS-1 discipline enforced affirmatively - the held sector is
proved stationary and flagged as the residual primitive-null obstruction.

## Assessment of the two-fine-tick dilation (route-memo pivot)

The proposed compact-auxiliary two-fine-tick dilation is a SOUND architectural
idea, honestly framed:
- It represents the stationary `Q`-branch as MOTION in an enlarged (fine-tick +
  compact auxiliary) register: over two fine ticks, `P` acquires the full physical
  translation phase and `Q` returns to its initial auxiliary site, so "every
  branch moves on each fine tick." The memo is explicit: "This is a dilation, not
  a claim that an on-site hold was null after all." Correct - this is a
  Stinespring/ancilla-style dilation, which is a legitimate way to obtain
  all-moving microscopic support without retroactively calling the coarse hold
  null.
- DECISIVE RISK (correctly pre-registered as gate 1): "if the auxiliary Fourier
  sectors introduce additional zero-quasienergy Weyl copies." The enlarged
  register has extra Fourier modes; those auxiliary sectors could carry NEW
  zero-quasienergy Weyl nodes - i.e. the doubling could RELOCATE into the
  auxiliary sector (the same "doublers relocate" pattern seen in the open-diamond
  boundary modes and the depth-two hyperdiamond). The proposed job
  `e9a3645d` (adversarial full-spectrum audit of the depth-16 lift) is exactly
  the right test, and must inspect BOTH 0 and π sectors of the enlarged symbol.
- The other gates (local decoder isolates the sector; auxiliary stays COMPACT not
  a macroscopic dimension; compensating charge assigned to a proved π/bulk/
  boundary/mirror sector rather than hidden) are the correct further conditions.
- The provenance references are apt and honestly used: HNU 1806.06868, Bessho-Sato
  2006.04204 (both verified earlier), plus domain-wall refs hep-lat/0105032 and
  2502.03045 cited specifically for the WARNING that "opposite chirality can
  reappear elsewhere" - i.e. they cite the relocation hazard, not just the
  mechanism.
- Claim boundary correct: "a new exact architecture for the stationary-branch
  problem, not a complete 3+1 theory."

RECOMMENDATION on the dilation: proceed, but treat gate 1 (auxiliary Weyl copies,
0-and-π) as THE decisive test - it is the concrete form of the recurring
"doublers relocate" obstruction, now potentially hiding in the auxiliary Fourier
sectors. A clean symbol-identity + unitarity proof (job `6f1114f3`) does not by
itself close it; the full-spectrum audit does.

## Guards + build

Both build `lake env lean ... EXITCODE=0` (no error/guard-mismatch/sorry).
0 `sorry`/`native_decide`/`axiom`. Guarded CENTRALLY in `OvernightTheoryAxiomGuard`
(4384-4396): `schedule_symbol`, `schedule_gInner`, `no_scalar_coin_factorization`,
`W8_stationary` - the Fourier bridge, unitarity, no-factorization, and
stationary-sector witness. Load-bearing theorems pinned.

## Bottom line

APPROVE. The real-space core + bridge faithfully realize the HNU momentum symbol
(correct Fourier order/signs, doubled axis-3 for the half-step, unitary,
range-one local), and the primitive-null audit is a model of honesty - it proves
the stationary sector and names it the exact residual obstruction rather than
mislabeling it null. The two-fine-tick dilation is a legitimate next architecture;
its make-or-break is the auxiliary-Weyl-copy full-spectrum audit (gate 1, both
sectors), which is correctly pre-registered.
