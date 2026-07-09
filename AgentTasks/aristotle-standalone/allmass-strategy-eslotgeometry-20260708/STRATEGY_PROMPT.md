# Strategy + proof: give the soldering (gravity) E-slot a discrete-geometric transformation law (F7)

## Context (blind to the wider repo)

A finite null-edge Dirac program decomposes a carrier square into four force-shaped
channels; the fourth is the **soldering / geometry channel** `E_# = φ·(∇^# − ∇)` (the
gap between a transport `∇` and its Krein adjoint `∇^#`, weighted by the turn field
`φ`). It is the "gravity-shaped" channel. Two facts are established: (a) `E_#`
vanishes exactly in the self-adjoint gauge class (`∇^# = ∇`), and (b) `E_#` splits
into a **torsion-shaped** and a **nonmetricity-shaped** piece — and the "pure-torsion"
conjecture is **dead** (a witness has genuinely non-torsion content). So the E-slot is
NOT pure teleparallel torsion.

The frontier: the E-slot is the least physically developed channel, but perhaps the
most original — it is the finite analogue of a connection defect. It needs a genuine
**transformation law** to be geometry rather than bookkeeping.

## Your task (strategy + proof)

Give `E_#` a genuine discrete-geometric transformation law under a change of the
finite connection / frame, and test which continuum object it behaves like:

1. **Transformation law.** Under a finite gauge/frame change `∇ ↦ U^{-1} ∇ U` (or the
   Krein analogue), derive how `E_# = φ(∇^# − ∇)` transforms. Prove the finite
   transformation rule as a theorem. Does it transform **tensorially** (like
   contorsion / nonmetricity — a genuine geometric object) or **inhomogeneously**
   (like a connection — gauge-dependent, not by itself physical)?
2. **Which continuum object?** Given the established torsion/nonmetricity split,
   prove which piece transforms like **contorsion** (the antisymmetric,
   metric-compatible defect) and which like **nonmetricity** (`∇g ≠ 0`, the
   symmetric/metric-violating defect). A finite Regge-adjacent connection-defect
   interpretation is also admissible — state precisely which.
3. **No double-counting.** Show `E_#` can enter the same mass budget as the gauge
   (`Q_C`) and turn (`Q_T`) channels **without double-counting curvature** — i.e.
   that the E-slot content is independent of the closure `Q_C` content (they are
   different grade/parity pieces of the square), so gravity-mass and gauge-mass are
   genuinely distinct summands.

The clean win: **the E-slot has a real geometric transformation law**, making the
carrier a finite theory in which gauge mass, Higgs mass, binding mass, and *geometric*
mass are different faces of one square.

## Constraints

Kernel-checked only for any proved theorem: no `sorry`/`admit`/`native_decide`/new
`axiom`; footprint `[propext, Classical.choice, Quot.sound]`, guarded in-file. Mathlib
only. This is a hard, open-ended target — deliver whatever lands as kernel-checked
theorems (the transformation law is the most tractable first win) plus an
`ARISTOTLE_SUMMARY.md`: the transformation rule, the contorsion-vs-nonmetricity
verdict, the no-double-counting argument, and an honest boundary of what stays
conjectural / needs a refinement limit.
