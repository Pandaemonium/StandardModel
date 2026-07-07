# Fable call 03 - CRACK Krein positivity (the last crux) + STRATEGIZE the endgame

You are Fable-5, chief theorist of the null-edge carrier program. Calls 01-02 cracked the
covariant-nabla assembly and the Krein upgrade; both landed, kernel-checked. The program
has now reached the ~40h ceiling you set (Move-1 complete including the Krein upgrade and
E-slot) well ahead of schedule, and the frontier has collapsed to ONE sharp crux. Be
maximally ambitious; everything is red-teamed + kernel-checked.

## 1. Context delta - what is now KERNEL-CHECKED + guarded (standard axioms)

Since call 02, all banked + axiom-guarded (build green, ~15 flagships):
- **`carrier_krein_square`** (attached): `4·D^#D = Q_A^# + Q_C^# + 4·Q_T + 4·E_#`, with the
  self-adjoint corollary transporting the assembly verbatim to `D^#D`. The mass form is
  decomposed. `Q_A^# = Σ g e f • (star(∇e)·∇f + star(∇f)·∇e)` - a sum of `star X · X`-shaped
  terms (positivity-SHAPED, unlike the bare `Q_A`).
- **`Q_A_eq_totalSq`** (Move-2, hand-proved): `Q_A = Q(∑ₑ αₑ)` - the aperture block IS the
  invariant mass of the total null soldering; `Q_A = 0 ⟺ Q(∑α) = 0 ⟺ collinear` (ties to the
  landed `nbody_aperture_massless_iff_collinear`). "`Q_A` = aperture" is now a THEOREM.
- Codex (C-lane) landed an honest `Q_C`-carrier bridge: the `Q_C = tanh β / exp(−osGap)`
  readout as an EXTERNAL contract (not yet derived from the plaquette curvature - the open
  `Q_C` derivation), pinned to the torus model, + a re-export of `mZero_iff_commute`.
- Witness: the assembly's joint satisfiability (all hypotheses, `Q_A/Q_C/Q_T` simultaneously
  nonzero) is discharged by a verified explicit `M₄(ℂ)` Pauli model; kernel formalization
  pending (construction jobs stall the fleet).

## 2. PRIMARY THRUST (CRACK) - Krein positivity, the single remaining crux

Mass is `inf spec D^#D`, meaningful only on a sector where the indefinite form `D^#D` is
≥ 0. You flagged (call-02 / the extensions review) that our complexes are FINITE, so we are
in a **Pontryagin space `Π_κ`**, where Pontryagin/Krein-Langer GUARANTEES a `J`-self-adjoint
operator has an invariant maximal non-negative subspace - so the positive sector EXISTS and
the question sharpens to "is it natural?". CRACK, precisely enough to write exact Lean
statements:

- **(a)** The sharpest FINITE, kernel-checkable statement of Krein positivity we can target
  now. Is the cleanest first result **`positivity_on_flat_sector`** (on `S := ⋂ₑ ker ∇ₑ`,
  `D` acts as `Γφ`, so `⟨Dψ, Dψ⟩_η = ⟨φψ, φψ⟩_η = φ^#φ`-shaped ≥ 0)? Give the exact statement
  - including the minimal representation/module structure the carrier needs to act on (the
    abstract bricks are in an algebra `B`; positivity needs vectors `ψ` - what is the least
    scaffolding: a `B`-module with an `η`-form? a concrete `M₄(ℂ)` acting on `ℂ⁴`?).
- **(b)** The Pontryagin route as a Lean target: state the finite-dimensional
  invariant-maximal-nonnegative-subspace theorem for a `J`-self-adjoint operator (this is
  unformalized in Mathlib - is it a reasonable standalone formalization, and what is the
  cleanest finite-dim proof: the Krein-Langer fixed-point / Cayley-transform argument, or a
  direct inertia/graph argument on the finite matrix `η D^#D`?). Which is more Lean-tractable?
- **(c)** Is `Q_A^#`'s `star X · X` shape enough to get `Q_A^# ≥ 0` outright on the whole
  space (in a `StarRing`/`C*`-flavored `B`), independent of the sector question? If `Σ star Xₑ
  · Xₑ`-type positivity holds abstractly, that is a clean immediate win for the aperture slot.

## 3. SECONDARY THRUSTS

- **(A) The `Q_C` derivation.** Codex has the `Q_C`=gap readout as an external contract. What
  is the sharpest route to actually DERIVE `⟨Q_C⟩ ≈ −log tanh β` (leading order) from the
  torus plaquette curvature + the character expansion - the honest content behind the
  bridge? Isolate the one hard step.
- **(B) STRATEGIZE the endgame.** We hit your ~40h ceiling early. What is the NEW most
  ambitious achievable target for the remaining ~30h? Candidates: Krein positivity (flat
  sector + Pontryagin); the `Q_C`/`Q_T` derivations; the witness formalization; the whole-
  unification `structure`; or pivoting to an extension (teleparallel `E` torsion, spin via
  the little group). Rank by (value × reachability), given two executors + heavy Aristotle.

## 4. Requested output + grading

CRACK first (the positivity statements + the minimal scaffolding), reasoning second. Grade
[ESTABLISHED]/[CONJECTURAL]/[CRUX]. Decompose each into named lemmas with the one hard step
isolated. If the flat-sector positivity or the Pontryagin route is subtler than it looks
(e.g. the `η`-form's signature obstructs even the flat sector), say so bluntly.
