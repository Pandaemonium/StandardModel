# Claude review: FiniteTransverseWeylLift

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-155602, item QCA-3PLUS1-001
- Sources: `FiniteTransverseWeylLift.lean` (325, sha 486e4c02 MATCH), audit
  `CODEX_FINITE_TRANSVERSE_WEYL_LIFT_AUDIT_2026-07-13.md` (sha bfdcf968 MATCH)
- Checks: exact kernel; complement identity; Pauli-symbol intertwiner; no prose
  implying domain-wall / full-operator gap / Nielsen-Ninomiya escape / anomaly
  inflow.
- Date: 2026-07-13

## Verdict: APPROVE

All three requested statement checks are supported exactly, and no surviving
prose implies any of the four forbidden readings - the disclaimers are precise
and technically correct (in particular the "separable, no anticommuting
gamma-coupling" reason it is not a domain wall, and the "complement gap is
`Mchain`-only, not a full-`Hfull` gap" caveat). Build EXITCODE=0, 5 `#guard_msgs`
pass. 0 sorry / native_decide / axiom. No repair required.

## Statement checks

### Exact kernel - SUPPORTED
- `Mchain_mulVec_w`: `Mchain *ᵥ w = 0` (w a zero mode).
- `mem_ker_iff`: `Mchain *ᵥ v = 0 <-> exists c, v = c • w` (kernel = the w-line).
- `kernel_eq_span`: `ker (Mchain.mulVecLin) = span ℝ {w}`; `kernel_finrank = 1`.
The exact kernel is the 1-dimensional line `ℝ ∙ w`, `w ≠ 0` (`w_ne_zero`). Correct.

### Complement identity - SUPPORTED (and correctly NOT a full-operator gap)
- `Mchain_sq_certificate`: `Mchain² = 5•I - vecMulVec w w` (exact rank-one).
- `gap_identity`: `‖Mchain v‖² = 5‖v‖² - ⟨w,v⟩²` - the exact quadratic form,
  UNCONDITIONAL (no assumed spectrum).
- `complement_gap`: on `⟨w,v⟩ = 0`, `‖Mchain v‖² = 5‖v‖²` (gap √5 on `w⊥`),
  DERIVED from `gap_identity`; `complement_gap_tight` shows `v=(0,1,0)` attains it
  (nonvacuous, tight). Correct, and it is explicitly the COMPLEMENT gap - the
  kernel direction `w` is the gapless zero mode.

### Pauli-symbol intertwiner - SUPPORTED
- `Hfull(k) = Mc ⊗ I₂ + I₃ ⊗ (k·σ)` (a SEPARABLE additive sum).
- `weyl_restriction`: `Hfull(k) *ᵥ (embed e) = embed (pauliSym k *ᵥ e)`, i.e.
  `H(k)·(w ⊗ e) = w ⊗ ((k·σ)·e)`. Holds precisely because `Mc *ᵥ wc = 0`
  (`Mc_mulVec_wc`): the transverse-chain summand annihilates the kernel, leaving
  the Pauli symbol. Non-vacuous: `embed_ne_zero` (nonzero spinor -> nonzero kernel
  state, sector genuinely 2-d). Chirality is local symbol data
  (`trace_pauli{X,Y,Z} = 2k_a`, `chiralityJacobian = I`, `chirality_det = 1`),
  explicitly "does not prove globally isolated chirality on a periodic Brillouin
  zone." Correct.

## No forbidden prose (all four disclaimed, precisely)

- **Domain-wall**: DENIED. Docstring: "a finite algebraic precursor to a
  domain-wall construction, not a domain-wall Dirac operator." Scope: "The
  additive lift LACKS THE ANTICOMMUTING GAMMA-MATRIX COUPLING of a domain-wall
  Dirac operator." Provenance: "the returned domain-wall ... interpretation was
  not retained because the displayed operator is a separable transverse-chain
  plus continuum-symbol sum." The `Hfull` definition is manifestly separable.
- **Full-operator gap**: DENIED (the exact concern). Scope: "The complement
  identity concerns `Mchain` alone. It must NOT be read as a uniform gap for the
  separable full operator `Hfull`, whose two commuting summands can have
  cancelling eigenvalues." Precisely correct.
- **Nielsen-Ninomiya escape**: DENIED. "does not ... establish an escape from
  lattice doubling"; the tangential factor "is the nonperiodic continuum symbol
  `k·σ`, not a local operator on a three-dimensional lattice"; `weyl_restriction`
  docstring: "not a local periodic three-dimensional lattice realization."
- **Anomaly inflow**: DENIED. "No opposite-chirality partner, bulk invariant,
  anomaly inflow, primitive-null update, gauge coupling, or thermodynamic
  statement is identified here." Provenance drops the anomaly-inflow reading.
- Bonus: also disclaims asymptotic localization ("`w` ... not a proved
  asymptotically localized boundary state in a chain family").

## Build/replay footprint

`lake env lean ... FiniteTransverseWeylLift.lean`: EXITCODE=0, no error, no
`#guard_msgs` mismatch. 5 build-enforced guards (`Mchain_sq_certificate`,
`complement_gap`, `kernel_finrank`, `weyl_restriction`, `chirality_det`) pass at
`[propext, Classical.choice, Quot.sound]`. 0 `sorry`/`native_decide`/`axiom`.

## Bottom line

APPROVE. The finite content (1-d kernel, rank-one square certificate, exact
complement quadratic form, kernel-sector Pauli intertwiner, local +1 chirality)
is exactly stated and kernel-clean, and the module scrupulously refuses the
domain-wall / full-gap / NN-escape / anomaly-inflow readings - explicitly noting
the operator is a separable sum lacking the anticommuting gamma-coupling a real
domain wall needs. An honest finite precursor, correctly labeled.
