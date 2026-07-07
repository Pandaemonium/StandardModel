# HSTAR Model Audit - 2026-07-07

Job: `ne-solo-lane-hstar-gauss-ward-realsplit-model-audit-20260707`.

Project: `16d04733-8cd0-4aaa-9867-cd43c8ba834c`.

## Scope

This audit covers the finite HSTAR-facing constraint surfaces already present in
the repo: Kugo-Ojima/Gauss-like constraints, Ward/descent preservation,
positive-sector `p > q` nonvacuity, and real-split kill conditions.  It is a
finite-model audit only.  It does not claim physical state-space positivity,
BRST cohomology, continuum Ward identities, or anomaly cancellation.

## Current API Inventory

- `PhysicsSM/Draft/NullEdge/Carrier/KugoOjima.lean` supplies `kreinForm`,
  `kreinAdjoint`, `orthoB`, `finrank_orthoB`, `orthoB_ker_eq_range`,
  `finite_kugo_ojima`, and `descent_unitary`.
- `PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean` supplies
  the shared nilpotent charge `Qop`, the `(2,1)` positive witness `Jpos`, the
  same-charge `(1,2)` negative witness `Jneg`, and the surviving representative
  `e2`.
- `PhysicsSM/Draft/NullEdge/Carrier/CarrierIndexProtection.lean` supplies the
  finite chiral-index protection layer and forced-massless-mode witnesses.
- `PhysicsSM/Draft/NullEdge/GateI1/Q11RealStructure.lean` supplies the finite
  `J_R` sign table on `Lambda(C^5)`, with the important boundary that
  `Btop_eq_Bstd` makes that fiber Hilbert-positive, not Krein-indefinite.

## New Landed Witness

`PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean` closes one
concrete audit gap.  On the existing `(2,1)` positive-sector model, it defines
the diagonal phase operator `Uop a = diag(a, a, 1)` and proves:

- `Uop_comm_Qop`: the phase operator commutes with the nilpotent charge.
- `Uop_kreinUnitary`: for `star a * a = 1`, it is `Jpos`-unitary.
- `Uop_e2`: it fixes the surviving representative `e2`.
- `Uop_e0`: it scales the isotropic constraint direction.
- `ward_descent_preservation`: it instantiates `descent_unitary` and preserves
  `ker Qop`, `range Qop`, and `kreinForm Jpos`.
- `ward_descent_nonvacuous`: the phase `Complex.I` is a genuine non-identity
  symmetry satisfying the finite descent hypotheses.

The new file and the central carrier guard pin the two headline Ward/descent
theorems to the standard finite-project footprint.

## Remaining Blockers

- The model still needs a carrier/Gauss constraint span that connects the
  finite witness to the actual carrier physical quotient.
- The positive-sector theorem still needs the model-specific Ward/completeness
  hypotheses for the carrier, not merely the finite matrix witness.
- The Sylvester/inertia bridge should be instantiated for `Jpos` and `Jneg`
  rather than relying only on per-vector sign witnesses.
- The Q11 fiber remains Hilbert-positive in the current formalization; it is
  not a Krein model unless a genuinely indefinite Q11 form is supplied.

## Lean-Ready Follow-Ups

1. Prove the induced `Uop a` action on `ker Qop / range Qop` is well-defined
   and preserves the induced form.
2. Prove the Gauss-covector rank/physical-class interface on `Jpos`, using
   `finrank_orthoB` and `orthoB_ker_eq_range`.
3. Instantiate the Sylvester bridge for the concrete `GmatPos` and `GmatNeg`
   Gram matrices.
4. Generalize the `Jneg` no-go into a finite `p <= q` obstruction for positive
   quotient classes in the shared nilpotent-charge model.
5. Formalize the Q11 Hilbert-vs-Krein obstruction as a finite theorem about
   the current `Btop_eq_Bstd` pairing.

## Verification

Locally verified after integration:

```text
lake env lean PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean
```
