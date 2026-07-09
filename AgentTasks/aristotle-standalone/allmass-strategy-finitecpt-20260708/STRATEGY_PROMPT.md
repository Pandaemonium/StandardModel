# Proof: a finite CPT theorem (Conjecture R)

## Context (blind to the wider repo)

A finite null-edge carrier has a Dirac-type operator `D`, a chiral grading `Gamma`, and a
Krein adjoint `#` (indefinite-metric adjoint `X^# = J X^H J` for a fundamental symmetry
`J`, `J^2 = 1`). Define `Theta = C . Gamma_rev . #` where `C` is complex conjugation and
`Gamma_rev` is edge-orientation reversal (the grading involution). The conjecture:
**Theta is a finite CPT symmetry**.

## Targets
1. `Theta_antiunitary`: `Theta` is antiunitary (antilinear + Krein-isometric) on the
   carrier.
2. `Theta_conjugates_D_to_sharp`: `Theta D Theta^{-1} = D^#` (CPT maps the Dirac operator
   to its Krein adjoint). Prove it as a finite operator identity from the definitions of
   `C`, `Gamma_rev`, `#`.
3. `spectrum_conjugate_paired`: consequently the spectrum of `D` (or `D^#D`) is
   **conjugate-paired** — a finite CPT spectral-pairing theorem, adjacent to a
   `chiral_det_eq_pm_one`-style determinant/parity result.

Model `C`, `Gamma`, `#`, `J` as explicit finite matrices/operators (small carrier, e.g.
a Clifford (x) color witness), so each is a finite computation. Define them minimally and
self-containedly.

## Constraints
Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, in-file `#print axioms`. Mathlib only. Deliver
Lean + `ARISTOTLE_SUMMARY.md`: the antiunitarity, the `Theta D Theta^{-1} = D^#` identity,
the conjugate-pairing corollary, and an honest note on which carrier it is proved for.
