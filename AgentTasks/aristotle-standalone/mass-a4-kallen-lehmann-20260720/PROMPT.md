# Lemma job: the finite Kallen-Lehmann representation and the physical mass (gate A4 capstone)

Type: self-contained Mathlib-only theorem. AFPL gate A4. Capstone extending the
landed obstructions `gap_does_not_fix_pole` and `resolvent_response_entries`:
formalize the finite Kallen-Lehmann (KL) spectral representation of the two-point
response and define the physical mass as the smallest spectral point carrying
nonzero KL weight.

## Target

Work with a Hermitian matrix `H : Matrix (Fin m) (Fin m) ℂ` with real eigenvalues
`λ` and a physical observable vector `v : Fin m → ℂ`. Define the two-point
response `G_H(z) = ⟨v, (z • 1 - H)⁻¹ v⟩` for `z` off the spectrum, and the KL
spectral weight of eigenvalue `λ` as `w_λ = ⟨v, P_λ v⟩` where `P_λ` is the
spectral projector. Prove:

1. **Finite KL representation.** For `z` off the spectrum,
   `G_H(z) = Σ_λ w_λ / (z - λ)` (sum over distinct eigenvalues), with each
   `w_λ ≥ 0` real (positivity of the spectral weight). A concrete diagonalized
   version (`H = diagonal d`, `w_i = ‖v i‖²`, `G(z) = Σ_i ‖v i‖² / (z - d i)`)
   is an acceptable rigorous form if the general spectral-theorem route is heavy;
   state exactly what is proved.
2. **Residue = weight.** The residue of `G_H` at an eigenvalue `λ` is exactly the
   KL weight `w_λ` (`lim_{z→λ} (z - λ) G_H(z) = w_λ`), or in the algebraic finite
   form `(z - λ) G_H(z)` evaluated appropriately.
3. **Physical mass = smallest weighted eigenvalue.** Define the physical mass as
   `min { λ : w_λ ≠ 0 }` (the smallest eigenvalue with nonzero physical overlap).
   Prove it can EXCEED the spectral minimum `min λ` when the ground eigenvalue has
   zero weight (a propagator zero) - re-deriving `gap_does_not_fix_pole` as the
   `w_λ = 0` corner of this framework, now at the spectral-measure level.

## Constraints

Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`; standard
axioms. Report axioms. Success: the finite KL representation (concrete diagonal
form acceptable) + residue=weight + the physical-mass-exceeds-spectral-min
witness, tying the landed A4 obstructions to the standard Kallen-Lehmann map.
