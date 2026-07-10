# Strategy: kernelize the S1-CC closure-positivity resolution (MEMO → M)

You are the program's chief strategist. STRATEGY job (design + no-go analysis; a
proof is a bonus). Context in `src/`.

## The situation (finite mathematical-physics program: mass = obstruction to null transport)

The central crux of the QCD-shaped "closure" channel (§6) is whether the closure
Krein form `J Q_C` can be **positive** on the physical (Gauss-law) sector `V'/N`.
The current resolution is a **structured no-go at MEMO grade with a kernel-checked
engine** (`S1CC_RESOLUTION.md`):

- **KERNEL-CHECKED (M):** the finite anticonjugation + Hermitian-count algebra —
  a grading `b` with `b⁻¹(J Q_C)b = −(J Q_C)` forces equal ± eigenvalue counts
  (balanced), so `Q_C` is a *signed* chromomagnetic channel. See
  `S1CCBalancedInertia.lean`, `S1ClosureCurrentAlgebra.lean`.
- **MEMO (not yet kernel):** the physical instantiation — that the concrete
  Gauss-sector `V'/N` construction and the descent data actually realize the
  balanced form on `J Q_C|V'/N` — rests on hand-derivation + oracle numerics
  (`sig = (2,2,0)` on a `6×6` witness), NOT the kernel.
- The aperture-grading kill (`S1CC_APERTURE_GRADING_FINDING.md`): the same grading
  `b` also balances `J Q_A` and `J Q_T`, so a scalar-metric carrier cannot rescue
  positivity — escaped only by going to a larger Clifford algebra (the multi-edge
  Cl(4) carrier, which is now separately kernel-checked as `T2_positive_mass`).

## Your task — a concrete path from MEMO to M

1. **Identify the exact MEMO→M gap.** Read `S1CC_RESOLUTION.md` + the two Lean
   files. State precisely which sub-claims are already kernel-checked and which
   *single* construction (the `V'/N` Gauss sector + descent → the restricted form
   `B = J Q_C|V'/N`) is the load-bearing MEMO step. What is the minimal Lean object
   whose construction would close the gap?
2. **Design the Lean formalization.** Give the concrete definition of the Gauss
   constraint sector `V'` (from the carrier Gauss covectors), the null-space `N`,
   the quotient `V'/N`, and the restricted Hermitian form `B`, as Lean types on a
   finite-dimensional space. What is the cleanest representation (explicit matrices?
   a submodule + compression, like the `SectorGroundMassWitness` `Piso` isometry
   pattern)? Sketch the statement `balanced_on_physical_sector : (J Q_C).restrict V'/N`
   has inertia `(2,2,0)` (or is congruent to its negation).
3. **Assess feasibility + rank the sub-lemmas.** Is this a few-week formalization or
   a genuine research obstruction? Rank the sub-lemmas by difficulty; identify the
   one most likely to block.
4. **No-go honesty.** Is there any chance the MEMO claim is *wrong* (i.e. positivity
   actually survives on the true `V'/N`, and the `6×6` witness is unrepresentative)?
   State the strongest argument that the no-go is real vs. a witness artifact.

## Required output

- **The exact MEMO→M gap** (which sub-claim, which missing Lean object).
- **A formalization design** for the `V'/N` construction + restricted form, with
  the target statement and the compression pattern to use.
- **Feasibility verdict** + ranked sub-lemmas + the likely blocker.
- **No-go honesty**: is the balanced-closure no-go real or a witness artifact?

Be specific and technical; a concrete Lean object design beats a general essay.
