# Proof: mass thermodynamics — a Gibbs–Duhem sum rule with critical divergence (Conjecture V)

## Context (blind to the wider repo)

A finite null-edge program decomposes the carrier mass² into channel **shares**
`b_A + b_C + b_T = 1` (aperture / closure / turn), a kernel-checked budget identity.
This makes the mass budget behave like an equation of state: the shares are
extensive-fraction variables with Maxwell-type relations, and the `3x3` mass block
`B(l,k) = !![l, ki, 0; -ki, l, 0; 0,0,l]` (aperture `l`, closure `k`, spectrum
`{l-k, l, l+k}`) is explicit enough to compute the whole susceptibility matrix in
closed form.

## Targets

1. **`gibbs_duhem_sum_rule` (the core M-target).** Define the channel shares
   `b_A, b_C, b_T` as differentiable functions of the couplings `g = (l, k)` (from the
   budget decomposition of `B(l,k)`, normalized so `b_A + b_C + b_T = 1`). Define the
   **susceptibilities** `chi_{XY} = d b_X / d g_Y`. Prove the Gibbs–Duhem sum rule
   `Sum_X chi_{XY} = 0` for each coupling `Y` — an immediate consequence of
   differentiating the constant budget `b_A + b_C + b_T = 1`. (This is "small and
   pretty": the derivative of a constant, distributed over the shares.)
2. **`susceptibility_matrix_closed_form` (compute it).** On `B(l,k)` give the full
   susceptibility matrix `chi_{XY}` in closed form (explicit rational/algebraic
   functions of `l, k`), and verify the sum rule holds entrywise.
3. **`critical_divergence` (the physics payload).** Prove that a channel
   susceptibility (e.g. `d b_C / d k`, or the low-temperature D5-ensemble
   susceptibility to `k`) **diverges as `k -> l`** (the massless critical line) — the
   thermodynamic signature of the massless transition, stated with objects that are
   all already kernel-checked. Make the divergence precise (a pole / blow-up as
   `l - k -> 0`).

The reading: the mass budget is a thermodynamic budget of decoding resources; the
shares are conjugate response variables; near the critical line the decoder becomes
infinitely sensitive to closure perturbations (a small loop-memory change toggles the
rank/mass of the visible direction state).

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, in-file `#print axioms`. Mathlib
only (use `HasDerivAt` / `deriv` for the susceptibilities). Deliver Lean +
`ARISTOTLE_SUMMARY.md`: the sum rule, the closed-form susceptibility matrix, the
critical divergence, and an honest note on which normalization of the shares you used.
