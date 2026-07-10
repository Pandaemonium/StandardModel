# Summary of changes for run 1ebcbcd6-59c1-4b4b-a0f9-7d457f58f29e
Delivered `RequestProject/Main.lean` (namespace `EvenMassGaps`) and `ARISTOTLE_SUMMARY.md`, kernel-checked and building cleanly (no `sorry`/`admit`/`native_decide`, no new axioms), over ℚ only (no Real/Complex).

## The model
A finite graded 2×2 rational model: grading `Gamma = !![1,0;0,-1]`; ODD host `A = !![0,1;0,0]` with explicit chiral zero mode `v = ![1,0]`; ODD perturbation `Podd s = !![0,s;0,0]`; EVEN axial mass `Peven m = !![m,0;0,-m]`; Hermitian square `Hmass m = (A+Peven m)ᴴ(A+Peven m)`.

## Grading structure (honest labels)
- `A_odd`, `Podd_odd`: anticommute with Γ (ODD).
- `Peven_even`: commutes with Γ (EVEN).

## Four targets (all proved)
1. `zero_mode_exists`: `(Aᴴ A)·v = 0` — exact protected zero eigenvector (plus `A_zero_mode`).
2. `odd_preserves`: for all `s`, `(A+Podd s)·v = 0` — ODD perturbations keep the zero mode (plus `odd_preserves_sq`). The true, narrow content.
3. `even_gaps`: for `m ≠ 0`, `det(Hmass m) = m⁴ ≠ 0`, so no zero eigenvalue — the mode is massive. Supported by `Hmass_eq` (`Hmass m = !![m²,m; m,1+m²]`), `Hmass_det`, and `even_mode_massive` (`(Hmass m)·v ≠ 0`, energy `vᵀ(Hmass m)v = m²`).
4. `conditional_protection_verdict`: packaged result — the mode exists, is preserved by every ODD perturbation, but is gapped by the explicit EVEN mass `m=1` (`det H₁ = 1 ≠ 0`, `H₁·v ≠ 0`, `vᵀH₁v = 1 > 0`).

## Verdict
The chiral zero mode is preserved by ODD (grading-preserving) perturbations but gapped by an EVEN mass term (explicit `m=1` witness), so the protection is chiral-symmetry-CONDITIONAL — not "immune to every potential"; its honest scope is odd/grading-preserving perturbations only. This confirms the audit's s8 kill-test.

## Verification
Each of the four headline theorems carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`; the module builds under the time limit.

# Even mass gaps the chiral zero mode — s8 kill-test (kernel-checked)

A finite, rational `2×2` graded matrix model formalizing the corrected `s8` claim:
the chiral-index "protected massless mode" is robust **only** to grading-preserving
(ODD) perturbations; an EVEN (grading-diagonal) mass term GAPS it. So "immune to
every potential" is false — the honest statement is chiral-symmetry-CONDITIONAL
protection (SSH/BdG-type).

All results live in `RequestProject/Main.lean`, namespace `EvenMassGaps`, over `ℚ`
(no `Real`, no `Complex`, no `native_decide`, no new axioms).

## The model

* `Gamma = !![1,0;0,-1]` — the `ℤ/2` grading `Γ = diag(1,-1)`.
* `A = !![0,1;0,0]` — an ODD (anticommutes with `Γ`) rank-1 operator with the
  explicit protected chiral zero mode `v = ![1,0]`.
* `Podd s = !![0,s;0,0]` — an ODD (off-diagonal, grading-reversing) perturbation.
* `Peven m = !![m,0;0,-m]` — an EVEN (grading-diagonal) axial/chiral mass.
* `Hmass m = (A + Peven m)ᴴ (A + Peven m)` — the Hermitian square in the massive case.

## Grading structure (honest labels)

* `A_odd` : `Γ·A + A·Γ = 0` (A anticommutes with Γ — ODD).
* `Podd_odd` : `Γ·Podd s + Podd s·Γ = 0` (ODD).
* `Peven_even` : `Γ·Peven m = Peven m·Γ` (Peven commutes with Γ — EVEN).

## The four targets

1. **`zero_mode_exists`** — `(Aᴴ A) · v = 0`: `v = ![1,0]` is an exact zero
   eigenvector of the Hermitian square (also `A_zero_mode : A · v = 0`).
2. **`odd_preserves`** — for every `s`, `(A + Podd s) · v = 0`: an ODD perturbation
   keeps the zero mode (also `odd_preserves_sq` at the Hermitian-square level). This
   is the true, narrow content of the protection.
3. **`even_gaps`** — for `m ≠ 0`, `det (Hmass m) = m⁴ ≠ 0`, so `Hmass m` is
   invertible and has no zero eigenvalue: the mode is massive. Supporting:
   `Hmass_eq : Hmass m = !![m²,m; m,1+m²]`, `Hmass_det : det (Hmass m) = m⁴`, and
   `even_mode_massive : (Hmass m)·v ≠ 0 ∧ vᵀ(Hmass m)v = m²`.
4. **`conditional_protection_verdict`** — the package: the zero mode exists, is
   preserved by *every* ODD perturbation, but is gapped by the explicit EVEN mass
   `m = 1` (`det H₁ = 1 ≠ 0`, `H₁·v ≠ 0`, energy `vᵀH₁v = 1 > 0`).

## Verdict

The chiral zero mode is preserved by ODD (grading-preserving) perturbations but
gapped by an EVEN mass term (explicit `m = 1` witness). The protection is therefore
chiral-symmetry-CONDITIONAL, not "immune to every potential"; its honest scope is
odd/grading-preserving perturbations only. This confirms the audit's `s8` kill-test.

## Verification

* `RequestProject/Main.lean` builds cleanly (no `sorry`/`admit`/`native_decide`,
  no new axioms).
* Each headline theorem carries an in-file
  `#guard_msgs (whitespace := lax) in #print axioms <thm>` check confirming the
  footprint is exactly `[propext, Classical.choice, Quot.sound]`.
