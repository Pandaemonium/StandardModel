# Fable-5 call 08 (solo run): audit the session's new flagships + manuscript state

You are the program's toughest semantic-alignment auditor + referee (finite,
machine-verified mathematical-physics program: *mass is the obstruction to
coherent null transport*). Since your last review (call-07) a large body of new
kernel-checked, guard-pinned results landed. I need (1) a **semantic-alignment
audit of the two most consequential new flagships** (embedded verbatim), and (2) a
**manuscript-state judgment** on whether the grade discipline held across ~40 edits.

## What landed since call-07 (all M, guard-pinned unless noted)

- **Mass gap, full sector**: `B_spectrum` (spectrum `{λ-κ,λ,λ+κ}`); `Msec` = the
  `6×6` sector form `B(λ,κ)⊕B(λ,-κ)` with least eigenvalue `λ-κ` = aperture-|closure|.
- **D2 unitary flow**: `exp(-itH)` unitary + `LinearIsometryEquiv`; carrier ORBIT
  conserves norm/energy. (Graded honestly: generator-as-Hamiltonian is a **C**
  posit; Euclidean ≠ Krein evolution — the sector's Krein form = Euclidean identity
  is `sector_krein_form_eq_one`.)
- **Binding defect** (`BindingDefect`): `Δ_block(λ,κ) = −κ` (negative,
  closure-controlled, off-diagonal) — the interacting-bridge crux, block level.
- **T2 Clifford provenance** (`CliffordAssembly`): the hand-typed carrier `HAC`/`Jmet`
  = the Cl(4) Kronecker assembly (verbatim); I graded this as "realizes the
  documented recipe" (NOT canonicity — K/order are inputs) after a prior audit.
- **S1-CC central-crux witness** (`S1CCPhysicalSectorWitness`, embedded): the §6
  closure form `J Q_C|V'/N` has inertia `(2,2,0)` on the explicit `6×6` physical
  sector — upgrading the program's former #1 crux from MEMO to kernel on the witness.
- **Organizing theorem, provable half** (`EquivariantGradedIndex`, embedded):
  `graded_budget_decomposition` writes the `4 D^#D = Q_A+Q_C+4Q_T+4E_#` budget as
  one equivariant graded-supertrace identity ("unification is decomposition");
  disclaimed as NOT a topological index.
- **Free second-quantized gap** (`FockMassGap`): `dΓ(B)` gap = one-particle gap;
  `Δ=−κ` seeds a below-threshold bound state (interacting hadron mass still open).

## Task 1 — semantic-alignment audit of the two embedded flagships (be adversarial)

**`S1CCPhysicalSectorWitness.lean`** (the central-crux upgrade). Probe HARD:
- Is `V'/N` the genuine Gauss-constraint physical sector, or a convenient
  coordinate choice? Is `N_in_radical` enough to justify "`B = (J Q_C)|V'/N` is the
  genuine induced form", or is the `submatrix` compression subtly not the true
  quotient form?
- Is `balanced_on_physical_sector` (inertia `(2,2,0)`) the real inertia of the
  induced form, or a weaker fact dressed up? Does the `6×6` toy carrier's link to
  the *actual* §6 closure form live outside the kernel (I claim only the witness is
  kernel; the general reduction stays MEMO — is that the honest line)?

**`EquivariantGradedIndex.lean`** (the organizing theorem). Probe:
- Is `graded_budget_decomposition` a genuine equivariant identity, or trace
  linearity applied to an *assumed* budget hypothesis (renamed to sound deep)?
  Where is the real content?
- Does anything call this an "index" in a way the kernel does not earn? Is the
  "NOT a topological index" disclaimer sufficient, or does the prose still oversell?

## Task 2 — manuscript state

The complete manuscript is embedded. Since call-07 it gained ~10 new §11 anchor
rows, §10 crux upgrades (S1-CC MEMO→kernel; binding defect C→block-M), a §9
second-quantization update, and grade caveats throughout. **Did the grade
discipline hold?** Flag any grade slip, internal inconsistency, stale "open/MEMO"
claim now closed, or over-claim introduced by the rapid additions — most severe
first. If the manuscript is clean, say so and say what you checked. Is it still
publication-ready as a self-contained draft?

## Required output

- **Semantic-alignment verdict** on each of the two embedded flagships (per-file,
  3-5 sentences): do the kernel statements say the intended physics? Any mismatch,
  most severe first.
- **Manuscript verdict**: did grade discipline hold; any slips; still done?
- **Bottom line**: the 1-3 most important things (if any) to fix.

One sharp correct load-bearing finding beats ten generic cautions. Report even if
the news is that it is all honest.
