# Proof: the Wigner–Araki–Yanase no-go for the chirality (turn) gate (Conjecture H)

## Context (blind to the wider repo)

A finite null-edge program has a "turn" channel `Γφ` that flips chirality. Chirality
does not commute with conserved weak isospin `Q_s`. The **Wigner–Araki–Yanase (WAY)**
theorem says: a gate not commuting with an additively conserved charge cannot be
implemented by a closed-system unitary that conserves the total charge — it needs an
ancilla carrying charge coherence, with error ~ 1/(ancilla charge variance). The
reading: **the Higgs is the WAY-evading reference frame for weak isospin**, and
`m ∝ φ` is the standard resource scaling of frame-dependent gates.

## Targets (the no-go half is a near-term M; state and prove it)

Work in finite dimensions. Let `Q_s` (system isospin) and `Q_a` (ancilla charge) be
Hermitian; total `Q = Q_s ⊗ 1 + 1 ⊗ Q_a`.

1. **`way_nogo` (the clean M-target).** If a unitary `U` on system⊗ancilla conserves
   total charge (`U (Q_s⊗1 + 1⊗Q_a) = (Q_s⊗1 + 1⊗Q_a) U`) **and factorizes** as
   `U = u ⊗ 1` (trivial ancilla), then `u` commutes with `Q_s` (`u Q_s = Q_s u`).
   Contrapositive: a chirality gate `u` with `[u, Q_s] ≠ 0` **cannot** be a
   charge-conserving closed-system unitary with a trivial ancilla — it *requires* a
   nontrivial charge-carrying ancilla. This is one line: `[U, Q_s⊗1 + 1⊗Q_a] = 0`
   with `U = u⊗1` gives `[u,Q_s]⊗1 = 0`, hence `[u,Q_s]=0`. Prove it as a clean
   finite-dimensional matrix/operator theorem.
2. **`chirality_gate_not_isospin_commuting` (witness).** Exhibit an explicit small
   chirality gate `u` (a `2×2` flip) and isospin `Q_s` with `[u, Q_s] ≠ 0`, so the
   no-go bites: this gate needs the ancilla (the Higgs resource).
3. **(Optional, harder) the quantitative bound.** State (prove if tractable, else
   pre-register) the resource scaling: the achievable gate fidelity/effective
   amplitude is bounded by the ancilla charge variance, so effective turn amplitude
   `∝ φ` with `1/variance` corrections — the finite `m ∝ φ` resource law.

This connects the turn channel `Q_T` to a real finite quantum-information theorem
family (WAY / frame resources), which is the register the program is allowed to
speak in — NOT continuum EWSB.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md`: the
no-go theorem, the witness, and (if reached) the quantitative bound or its precise
statement as a pre-registered target.
