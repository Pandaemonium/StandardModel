# E13 FMS composite observable next theorem (Gate E) -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run c0ce77ee-2dfd-4b20-b140-1acb244c6f06
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

## E13 — Next theorem after the E12 finite FMS composite reconstruction

I inspected the E12 module (`PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`), the electroweak stabilizer file, and the Working Plan §25.5 / §26.6 source, then designed and **fully implemented** the next Gate-E theorem step.

### Deliverables

1. **New Lean module** `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean` — builds cleanly, contains **no `sorry`**, and every theorem depends only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.
2. **Report** `PhysicsSM/Draft/E13_FMSCompositeObservableNext_Report.md` — states what E12 proves, what it does not, the next theorem, the proof roadmap, and manuscript-safe Gate-E wording.

### What E12 proves vs. its gap
E12 gives finite gauge-invariant orbit stiffness with W/Z *leading terms*, but (a) its W/Z leading terms use the **non-gauge-invariant** `τ¹/τ³` composites (only the singlet was gauge invariant — the W channel had no gauge-invariant carrier), and (b) the orbit-stiffness mass form and the FMS composite were separate objects. It makes no pole/two-point/spectrum claim.

### The next theorem (E13), proved in the module
- **Unification (main result):** for the second-order holonomy `U(ε)=1+iε ρ(X)−(ε²/2)ρ(X)²`, the exactly gauge-invariant singlet composite expands as `O(ε)=v²/2 + iε(v²/4)(x₃−x₂) − (ε²/2)q(X)` (`fms_singlet_second_order`): its linear term is the gauge-invariant Z field and its quadratic term is exactly minus one-half the orbit-stiffness mass form `q(X)`. The bridge `⟪H₀,ρ(X)²H₀⟫=q(X)` (`cinner_H0_rho_sq_H0`) follows from `ρ(X)` being Hermitian (`rho_isHermitian`). The quadratic cost vanishes exactly along `u(1)_em` (`fms_singlet_no_quadratic_cost_iff`).
- **Gauge-invariant W carrier:** using the conjugate doublet `H̃=iσ²H*`, the custodial operator `O^W=H̃_s†U_e H_t` (`fmsW`) is SU(2)_L-invariant (`fmsW_su2L_invariant`, via `Htilde_su2_covariant` and `su2_entries_of_unitary_det_one`), with leading term `(v²/4)(x₀−i x₁)` = the `W^∓` combination `A¹∓iA²` (`fmsW_leading`) — replacing E12's non-covariant `τ¹` matrix element.

### Honest scope (no overclaiming)
`O^W` is custodial-covariant, not a full gauge-invariant scalar: under the residual U(1)_em it carries the W's electric charge ±1, which is correct physics. The label remains a gauge-invariant orbit-stiffness reconstruction with W/Z leading terms and a unified quadratic mass term — not a physical composite-spectrum/pole theorem; the report records the additional analytic assumptions such a claim would require.
