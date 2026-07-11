# Summary of changes for run 79179c00-3e9e-46b1-91a0-7838e015ddf1
## Deliverables (committed + pushed to `main`)

- **`HALFPERIOD_INVARIANT_DESIGN.md`** — the design/oracle memo with the decision and the exact computed tables.
- **`context/HalfPeriodInvariantStatements.lean`** — a self-contained (`import Mathlib` + the landed engine) statement file, all facts discharged by exact `native_decide` over ℚ; it builds cleanly, has no `sorry`, and every theorem uses only allowed axioms. The two existing context modules were **not** modified.

## Decision (Task 1): NO — the half-period invariant is blind to the 8-vs-4 split

Recovering the setup exactly (grading `Γ = I⊗σ_x` is the unique chiral grading making every fixture chiral, and `S`, `C` are each individually chiral, so `W = S·C·S` is a genuine symmetric-time-frame walk):

- The finite half-period chiral invariant (signed `Γ`-signature on `ker(W∓1)`) is **identically 0** on all three fixtures and all 16 fields. Naive/trace indices `tr Γ, tr(ΓR), tr(ΓW), tr(ΓWR)` all vanish; `det = +1` throughout. These are constant across the family (= "equal winding").
- Mode counts: zero-/four-wall have 0 modes; all 12 two-wall fields have modes (2+2, or 4+4 for domain blocks). So mode count does **not** produce the 8-vs-4 split.

## Advisor timeframe-pair check (Tasks incorporating H5): KILL CONDITION MET

- Verified the load-bearing hypothesis exactly and field-independently: `Γ W Γ = W⁻¹` (Lean `chiral_inverse`); `σ_z` fails, `σ_x` is forced.
- Ran the pre-registered second-frame winding check on the momentum-space bulk (half-step coin `C^{1/2}` over ℚ(√10)): Frame 2 `= SCS` has winding **0**; Frame 1 `= C^{1/2}S²C^{1/2}` has winding **∓2** for bulk sign `s=±`, giving bulk `(ν₀,ν_π) = (∓1,∓1)`. A single well-separated `+/−` domain wall carries `Δ(ν₀,ν_π)=(2,2)`, correctly reproducing the domain-block fixtures' 4+4 modes.
- **But** the winding is a translation/homotopy invariant: it cannot read defect position. For the counterexample pair `++−+` (singleton on non-fixed site 2, engine fires) vs `+++−` (singleton on fixed site 3, engine blind) both frame windings are **equal** (net `(0,0)` around the ring), so the advisor's verbatim kill condition ("if frame-2 windings are equal for the counterexample pair, the proposal is dead") is met. It also over-counts narrow singletons (predicts 4+4, actual 2+2).

## Mirror-graded candidate (Task 3): also fails — in fact ill-defined

The reflection commutes with `W(b)` **iff** the reflection-fixed sites carry equal signs (`b 1 = b 3`, Lean `reflR_comm_walk_iff`), and every fixed singleton breaks this (`fixedSingleton_not_reflSym`). So the `R`-sectoring the mirror-graded winding needs does not even exist on the 4 blind fields; where it is defined its signed index is again 0.

## The exact discriminator (Task 4) and honest fallback (Task 5)

The datum that reproduces the 8-vs-4 split is the **self-adjointness of the reflection-fixed-leg compression** `M(b) = Bfixᵀ·W(b)·Bfix`. The fixed sector is always `W`-invariant, `Bfix` always an isometry, `W` always unitary, `tr M(b)=0` always — so self-adjointness is the *only* varying hypothesis of the landed `InvolutiveCompression` engine. Exactly (Lean `selfadj_iff_protected`):

> `M(b)` self-adjoint ⟺ `b` is two-wall and **not** a singleton seated on a reflection-fixed site {1,3} = `¬ fixedSingleton b`.

This is value-only (reads only the sign pattern `b`) and equals the paper's positional `fixedSingleton` criterion. `protected_modes` composes it through the landed engine: `∀ b, protectedField b → (∃ −1 mode) ∧ (∃ +1 mode)` — the requested "invariant nonzero ⟹ involutive-compression self-adjointness ⟹ pinned modes" theorem, with fixture evaluations (`sWall_protected`, `fixedSingleton_blind`, zero/four-wall not protected).

**Net for the paper's gates 1–2:** the C protecting invariant is provably **finer than the half-period timeframe pair and the mirror-graded winding**. The sharpened open gate is to match the finite self-adjointness/`¬fixedSingleton` discriminator to the CGGSVWZ real-space symmetry index (arXiv:1611.04439, position-sensitive, Fredholm) and inherit its gentle-perturbation stability. Scope guard kept: this is a 1+1D, Γ-respecting, unitary-walk statement; nothing about 3+1D or Γ-breaking perturbations.
